#!/bin/bash
# Project Biometal - QEMU Testing Script
# Test Arduino firmware in QEMU ARM emulation

set -euo pipefail

# === Configuration ===
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
DIST_DIR="${PROJECT_ROOT}/dist/firmware"
LOGS_DIR="${PROJECT_ROOT}/dist/test/logs"

# QEMU configuration
QEMU_SYSTEM="qemu-system-arm"
MACHINE="mps2-an385"  # ARM Cortex-M4 machine
CPU="cortex-m4"
MEMORY="32M"
FIRMWARE_FILE="${DIST_DIR}/nerv-arduino.elf"

# Test configuration
TEST_DURATION=10  # seconds
SERIAL_LOG="${LOGS_DIR}/qemu-serial.log"

# === Logging Functions ===
log_info() {
    echo "[INFO] $*"
}

log_error() {
    echo "[ERROR] $*" >&2
}

log_success() {
    echo "[SUCCESS] $*"
}

# === Check Dependencies ===
check_dependencies() {
    log_info "Checking QEMU dependencies..."
    
    if ! command -v "$QEMU_SYSTEM" &> /dev/null; then
        log_error "QEMU ARM system emulator not found."
        log_error "Install with: sudo apt-get install qemu-system-arm"
        log_error "Or on macOS: brew install qemu"
        exit 1
    fi
    
    if [ ! -f "$FIRMWARE_FILE" ]; then
        log_error "Firmware file not found: $FIRMWARE_FILE"
        log_error "Please build the firmware first with: ./build-arduino.sh"
        exit 1
    fi
    
    log_info "Dependencies check passed"
}

# === Setup Test Environment ===
setup_test_env() {
    log_info "Setting up test environment..."
    
    # Create logs directory
    mkdir -p "$LOGS_DIR"
    
    # Clear previous logs
    rm -f "$SERIAL_LOG"
    
    log_info "Test environment ready"
}

# === Run QEMU Test ===
run_qemu_test() {
    log_info "Starting QEMU emulation..."
    log_info "Machine: $MACHINE"
    log_info "CPU: $CPU"
    log_info "Memory: $MEMORY"
    log_info "Firmware: $FIRMWARE_FILE"
    log_info "Test duration: ${TEST_DURATION}s"
    
    # Start QEMU with serial output to file
    timeout "${TEST_DURATION}s" "$QEMU_SYSTEM" \
        -machine "$MACHINE" \
        -cpu "$CPU" \
        -m "$MEMORY" \
        -kernel "$FIRMWARE_FILE" \
        -nographic \
        -serial file:"$SERIAL_LOG" \
        -d guest_errors \
        || true  # Don't fail on timeout
    
    log_info "QEMU emulation completed"
}

# === Analyze Test Results ===
analyze_results() {
    log_info "Analyzing test results..."
    
    if [ ! -f "$SERIAL_LOG" ]; then
        log_error "Serial log file not found"
        return 1
    fi
    
    local log_size=$(stat -c%s "$SERIAL_LOG" 2>/dev/null || stat -f%z "$SERIAL_LOG" 2>/dev/null || echo "0")
    log_info "Serial log size: $log_size bytes"
    
    if [ "$log_size" -gt 0 ]; then
        log_success "✓ QEMU produced output"
        log_info "First few lines of output:"
        head -n 10 "$SERIAL_LOG" 2>/dev/null || echo "No readable output"
    else
        log_error "✗ No output produced"
        return 1
    fi
    
    log_success "Basic test completed"
    return 0
}

# === Interactive Mode ===
run_interactive() {
    log_info "Starting interactive QEMU session..."
    log_info "Press Ctrl+A, X to exit QEMU"
    
    "$QEMU_SYSTEM" \
        -machine "$MACHINE" \
        -cpu "$CPU" \
        -m "$MEMORY" \
        -kernel "$FIRMWARE_FILE" \
        -nographic \
        -serial stdio
}

# === Usage Information ===
usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -h, --help        Show this help message"
    echo "  -i, --interactive Run QEMU in interactive mode"
    echo "  -t, --time SECS   Set test duration (default: $TEST_DURATION)"
    echo ""
    echo "Default mode runs automated test for $TEST_DURATION seconds"
}

# === Main Function ===
main() {
    local mode="test"
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                usage
                exit 0
                ;;
            -i|--interactive)
                mode="interactive"
                shift
                ;;
            -t|--time)
                TEST_DURATION="$2"
                shift 2
                ;;
            *)
                log_error "Unknown option: $1"
                usage
                exit 1
                ;;
        esac
    done
    
    check_dependencies
    
    case $mode in
        test)
            setup_test_env
            run_qemu_test
            analyze_results
            ;;
        interactive)
            run_interactive
            ;;
    esac
}

# === Script Entry Point ===
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
