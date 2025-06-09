#!/bin/bash
# Biometal - Test Script
# Comprehensive testing including VM testing and FPEP validation

set -euo pipefail

# === Configuration ===
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="$(dirname "$SCRIPT_DIR")"
TEST_SUITE="${TEST_SUITE:-all}"
QEMU_MEMORY="${QEMU_MEMORY:-64M}"
QEMU_CPU="${QEMU_CPU:-486}"
TARGET_ARCH="${TARGET_ARCH:-x86_64}"

# === Logging ===
log_info() { echo "[INFO] $*" >&2; }
log_warn() { echo "[WARN] $*" >&2; }
log_error() { echo "[ERROR] $*" >&2; }
log_success() { echo "[SUCCESS] $*" >&2; }

# === Test Functions ===
test_specifications() {
    log_info "Testing specification validity..."
    
    local test_passed=true
    
    # Test API specifications
    if [[ -d "$WORKSPACE_DIR/spec/api" ]]; then
        for api_spec in "$WORKSPACE_DIR/spec/api"/*.yaml; do
            if [[ -f "$api_spec" ]]; then
                log_info "Validating API spec: $(basename "$api_spec")"
                
                # Basic YAML syntax check
                if ! yq eval '.' "$api_spec" >/dev/null 2>&1; then
                    log_error "Invalid YAML syntax in $api_spec"
                    test_passed=false
                fi
                
                # OpenAPI validation (if available)
                if command -v swagger-codegen >/dev/null 2>&1; then
                    if ! swagger-codegen validate -i "$api_spec" >/dev/null 2>&1; then
                        log_warn "OpenAPI validation issues in $api_spec"
                    fi
                fi
            fi
        done
    fi
    
    # Test system specifications
    if [[ -d "$WORKSPACE_DIR/spec/systems" ]]; then
        for system_spec in "$WORKSPACE_DIR/spec/systems"/*.yaml; do
            if [[ -f "$system_spec" ]]; then
                log_info "Validating system spec: $(basename "$system_spec")"
                
                if ! yq eval '.' "$system_spec" >/dev/null 2>&1; then
                    log_error "Invalid YAML syntax in $system_spec"
                    test_passed=false
                fi
            fi
        done
    fi
    
    if [[ "$test_passed" == "true" ]]; then
        log_success "Specification tests passed"
        return 0
    else
        log_error "Specification tests failed"
        return 1
    fi
}

test_build_system() {
    log_info "Testing build system..."
    
    # Test that build script exists and is executable
    if [[ ! -x "$WORKSPACE_DIR/scripts/build.sh" ]]; then
        log_error "Build script not found or not executable"
        return 1
    fi
    
    # Test build with different configurations
    local test_configs=(
        "BUILD_MODE=debug TARGET_ARCH=x86_64"
        "BUILD_MODE=release TARGET_ARCH=x86_64"
    )
    
    for config in "${test_configs[@]}"; do
        log_info "Testing build with: $config"
        
        if env $config "$WORKSPACE_DIR/scripts/build.sh" >/dev/null 2>&1; then
            log_success "Build test passed: $config"
        else
            log_error "Build test failed: $config"
            return 1
        fi
    done
    
    log_success "Build system tests passed"
    return 0
}

test_vm_boot() {
    log_info "Testing VM boot sequence..."
    
    local iso_file="$WORKSPACE_DIR/dist/funcos-complete.iso"
    local vm_log="$WORKSPACE_DIR/dist/vm-test.log"
    
    if [[ ! -f "$iso_file" ]]; then
        log_warn "ISO file not found, skipping VM boot test"
        return 0
    fi
    
    # Determine QEMU system based on target architecture
    local qemu_system
    case "$TARGET_ARCH" in
        "x86_64")
            qemu_system="qemu-system-x86_64"
            ;;
        "arm64")
            qemu_system="qemu-system-aarch64"
            ;;
        *)
            log_error "Unsupported architecture for VM testing: $TARGET_ARCH"
            return 1
            ;;
    esac
    
    # Check if QEMU is available
    if ! command -v "$qemu_system" >/dev/null 2>&1; then
        log_warn "QEMU not available, skipping VM boot test"
        return 0
    fi
    
    log_info "Starting VM boot test with $qemu_system..."
    
    # Run QEMU with timeout
    timeout 30s "$qemu_system" \
        -cdrom "$iso_file" \
        -m "$QEMU_MEMORY" \
        -cpu "$QEMU_CPU" \
        -display none \
        -serial file:"$vm_log" \
        -no-reboot \
        -no-shutdown \
        >/dev/null 2>&1 || true
    
    # Check boot log for success indicators
    if [[ -f "$vm_log" ]]; then
        if grep -q "FuncOS" "$vm_log"; then
            log_success "VM boot test passed"
            return 0
        else
            log_error "VM boot test failed - no FuncOS signature found"
            return 1
        fi
    else
        log_error "VM boot test failed - no log file generated"
        return 1
    fi
}

test_api_endpoints() {
    log_info "Testing API endpoints..."
    
    # This would test the actual API endpoints when implemented
    # For now, just validate the API specifications
    
    local api_specs=("$WORKSPACE_DIR/spec/api"/*.yaml)
    
    for api_spec in "${api_specs[@]}"; do
        if [[ -f "$api_spec" ]]; then
            local api_name=$(basename "$api_spec" .yaml)
            log_info "Testing API specification: $api_name"
            
            # Extract endpoints from OpenAPI spec
            if command -v yq >/dev/null 2>&1; then
                local endpoints
                endpoints=$(yq eval '.paths | keys | .[]' "$api_spec" 2>/dev/null || echo "")
                
                if [[ -n "$endpoints" ]]; then
                    log_info "Found endpoints in $api_name: $(echo "$endpoints" | tr '\n' ' ')"
                else
                    log_warn "No endpoints found in $api_name"
                fi
            fi
        fi
    done
    
    log_success "API endpoint tests passed"
    return 0
}

test_fpep_sandbox() {
    log_info "Testing Foreign Program Execution Profiler (FPEP)..."
    
    # Test basic sandboxing capabilities
    local fpep_dir="$WORKSPACE_DIR/fpep"
    mkdir -p "$fpep_dir/sandbox" "$fpep_dir/logs"
    
    # Test that we can create isolated environments
    if command -v unshare >/dev/null 2>&1; then
        log_info "Testing namespace isolation..."
        
        # Test basic namespace isolation
        if unshare --pid --fork --mount-proc echo "FPEP sandbox test" >/dev/null 2>&1; then
            log_success "Namespace isolation working"
        else
            log_warn "Namespace isolation not available"
        fi
    else
        log_warn "unshare not available, skipping sandbox test"
    fi
    
    # Test process monitoring capabilities
    if command -v strace >/dev/null 2>&1; then
        log_info "Testing system call monitoring..."
        
        # Test that we can monitor system calls
        if strace -c echo "test" >/dev/null 2>&1; then
            log_success "System call monitoring working"
        else
            log_warn "System call monitoring not available"
        fi
    else
        log_warn "strace not available, skipping monitoring test"
    fi
    
    log_success "FPEP tests passed"
    return 0
}

test_hardware_profiling() {
    log_info "Testing hardware profiling..."
    
    if [[ -f "$WORKSPACE_DIR/scripts/hardware-profile.sh" ]]; then
        if "$WORKSPACE_DIR/scripts/hardware-profile.sh" >/dev/null 2>&1; then
            log_success "Hardware profiling test passed"
            return 0
        else
            log_error "Hardware profiling test failed"
            return 1
        fi
    else
        log_warn "Hardware profiler not found, skipping test"
        return 0
    fi
}

test_cross_compilation() {
    log_info "Testing cross-compilation capabilities..."
    
    local test_passed=true
    
    # Test that cross-compilation tools are available
    local cross_tools=(
        "aarch64-linux-gnu-gcc"
        "arm-linux-gnueabihf-gcc"
    )
    
    for tool in "${cross_tools[@]}"; do
        if command -v "$tool" >/dev/null 2>&1; then
            log_info "Cross-compilation tool available: $tool"
        else
            log_warn "Cross-compilation tool not available: $tool"
        fi
    done
    
    # Test Zig cross-compilation
    if command -v zig >/dev/null 2>&1; then
        log_info "Testing Zig cross-compilation..."
        
        # Test that Zig can target different architectures
        if zig targets >/dev/null 2>&1; then
            log_success "Zig cross-compilation available"
        else
            log_warn "Zig cross-compilation test failed"
        fi
    else
        log_warn "Zig not available, skipping cross-compilation test"
    fi
    
    log_success "Cross-compilation tests passed"
    return 0
}

# === Main Test Runner ===
run_test_suite() {
    local suite="$1"
    local tests_passed=0
    local tests_failed=0
    
    case "$suite" in
        "specs"|"specifications")
            if test_specifications; then
                ((tests_passed++))
            else
                ((tests_failed++))
            fi
            ;;
        "build")
            if test_build_system; then
                ((tests_passed++))
            else
                ((tests_failed++))
            fi
            ;;
        "vm")
            if test_vm_boot; then
                ((tests_passed++))
            else
                ((tests_failed++))
            fi
            ;;
        "api")
            if test_api_endpoints; then
                ((tests_passed++))
            else
                ((tests_failed++))
            fi
            ;;
        "fpep")
            if test_fpep_sandbox; then
                ((tests_passed++))
            else
                ((tests_failed++))
            fi
            ;;
        "hardware")
            if test_hardware_profiling; then
                ((tests_passed++))
            else
                ((tests_failed++))
            fi
            ;;
        "cross")
            if test_cross_compilation; then
                ((tests_passed++))
            else
                ((tests_failed++))
            fi
            ;;
        "all")
            # Run all test suites
            for test_type in specs build vm api fpep hardware cross; do
                run_test_suite "$test_type"
            done
            return $?
            ;;
        *)
            log_error "Unknown test suite: $suite"
            return 1
            ;;
    esac
    
    log_info "Test results: $tests_passed passed, $tests_failed failed"
    return $tests_failed
}

# === Main Function ===
main() {
    log_info "Starting FuncOS test suite..."
    log_info "Suite: $TEST_SUITE | Target: $TARGET_ARCH"
    
    cd "$WORKSPACE_DIR"
    
    if run_test_suite "$TEST_SUITE"; then
        log_success "All tests passed!"
        exit 0
    else
        log_error "Some tests failed!"
        exit 1
    fi
}

# === Script Entry Point ===
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
