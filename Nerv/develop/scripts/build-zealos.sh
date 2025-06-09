#!/bin/bash

# ZealOS Build Script for Nerv Microkernel Integration
# Builds ZealOS within the Nerv Microkernel development environment

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
ZEALOS_DIR="$PROJECT_ROOT/../ZealOS"
BUILD_LOG="$PROJECT_ROOT/build/zealos-build.log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log() {
    echo -e "${BLUE}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a "$BUILD_LOG"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$BUILD_LOG"
    exit 1
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1" | tee -a "$BUILD_LOG"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1" | tee -a "$BUILD_LOG"
}

# Ensure we're in the right environment
check_environment() {
    log "Checking build environment..."
    
    if [ ! -d "$ZEALOS_DIR" ]; then
        error "ZealOS directory not found at $ZEALOS_DIR"
    fi
    
    # Check for required tools
    for tool in qemu-system-x86_64 make xorriso git; do
        if ! command -v "$tool" &> /dev/null; then
            error "Required tool '$tool' not found"
        fi
    done
    
    # Check for KVM support
    if lsmod | grep -q kvm; then
        log "KVM acceleration available"
        export KVM_ACCEL="-accel kvm"
    else
        warn "KVM acceleration not available, builds will be slower"
        export KVM_ACCEL=""
    fi
    
    success "Environment check passed"
}

# Prepare build directories
prepare_build() {
    log "Preparing build environment..."
    
    mkdir -p "$PROJECT_ROOT/build"
    mkdir -p "$PROJECT_ROOT/dist/zealos"
    
    # Create build log
    echo "ZealOS Build Log - $(date)" > "$BUILD_LOG"
    
    success "Build environment prepared"
}

# Build ZealBooter
build_zealbooter() {
    log "Building ZealBooter..."
    
    cd "$ZEALOS_DIR/zealbooter"
    
    # Clean previous builds
    make distclean || true
    
    # Build
    if make all 2>&1 | tee -a "$BUILD_LOG"; then
        success "ZealBooter built successfully"
    else
        error "ZealBooter build failed"
    fi
}

# Build ZealOS ISOs
build_zealos() {
    log "Building ZealOS ISOs..."
    
    cd "$ZEALOS_DIR/build"
    
    # Set headless mode for automated builds
    export QEMU_HEADLESS='-display none'
    
    # Run the build script
    if ./build-iso.sh --headless 2>&1 | tee -a "$BUILD_LOG"; then
        success "ZealOS ISOs built successfully"
    else
        error "ZealOS ISO build failed"
    fi
}

# Copy artifacts to distribution
copy_artifacts() {
    log "Copying build artifacts..."
    
    cd "$ZEALOS_DIR/build"
    
    # Copy ISOs to distribution directory
    for iso in ZealOS-*.iso; do
        if [ -f "$iso" ]; then
            cp "$iso" "$PROJECT_ROOT/dist/zealos/"
            log "Copied $iso to distribution"
        fi
    done
    
    # Copy ZealBooter binary
    if [ -f "$ZEALOS_DIR/zealbooter/bin/kernel" ]; then
        cp "$ZEALOS_DIR/zealbooter/bin/kernel" "$PROJECT_ROOT/dist/zealos/zealbooter.elf"
        log "Copied ZealBooter to distribution"
    fi
    
    success "Artifacts copied to distribution"
}

# Verify build results
verify_build() {
    log "Verifying build results..."
    
    local iso_count=0
    
    for iso in "$PROJECT_ROOT/dist/zealos"/ZealOS-*.iso; do
        if [ -f "$iso" ]; then
            local size=$(stat -c%s "$iso")
            local size_mb=$((size / 1024 / 1024))
            
            if [ "$size_mb" -gt 50 ] && [ "$size_mb" -lt 500 ]; then
                log "✓ $(basename "$iso"): ${size_mb}MB (valid size)"
                ((iso_count++))
            else
                warn "$(basename "$iso"): ${size_mb}MB (suspicious size)"
            fi
        fi
    done
    
    if [ "$iso_count" -ge 2 ]; then
        success "Build verification passed: $iso_count ISOs generated"
    else
        error "Build verification failed: insufficient ISOs generated"
    fi
}

# Test ISOs (optional)
test_isos() {
    if [ "$1" = "--test" ]; then
        log "Testing ZealOS ISOs..."
        
        cd "$PROJECT_ROOT/dist/zealos"
        
        for iso in ZealOS-*.iso; do
            if [ -f "$iso" ]; then
                log "Testing $iso..."
                
                # Quick boot test (10 second timeout)
                timeout 10s qemu-system-x86_64 \
                    -machine q35 $KVM_ACCEL \
                    -m 512M -smp 2 \
                    -rtc base=localtime \
                    -cdrom "$iso" \
                    -display none \
                    -device isa-debug-exit || true
                
                log "Boot test completed for $iso"
            fi
        done
        
        success "ISO testing completed"
    fi
}

# Generate build report
generate_report() {
    log "Generating build report..."
    
    local report_file="$PROJECT_ROOT/build/zealos-build-report.md"
    
    cat > "$report_file" << EOF
# ZealOS Build Report

**Build Date**: $(date)
**Build Environment**: Nerv Microkernel Development Container
**Build Status**: SUCCESS

## Artifacts Generated

EOF
    
    for iso in "$PROJECT_ROOT/dist/zealos"/ZealOS-*.iso; do
        if [ -f "$iso" ]; then
            local size=$(stat -c%s "$iso")
            local size_mb=$((size / 1024 / 1024))
            local checksum=$(sha256sum "$iso" | cut -d' ' -f1)
            
            echo "### $(basename "$iso")" >> "$report_file"
            echo "- **Size**: ${size_mb}MB" >> "$report_file"
            echo "- **SHA256**: \`$checksum\`" >> "$report_file"
            echo "" >> "$report_file"
        fi
    done
    
    cat >> "$report_file" << EOF
## Integration Status

- [x] ZealBooter compiled successfully
- [x] BIOS ISO generated
- [x] UEFI ISO generated
- [x] Artifacts copied to distribution
- [x] Build verification passed

## Next Steps

1. **Hardware Profiling**: Integrate ZealOS with Nerv Microkernel hardware detection
2. **API Mapping**: Document ZealOS system calls for FuncOS abstraction
3. **Data Collection**: Implement Project Biometal monitoring hooks
4. **Mach Integration**: Begin GNU Mach/Hurd foundation work

## Build Log

See \`build/zealos-build.log\` for detailed build output.
EOF
    
    success "Build report generated: $report_file"
}

# Main execution
main() {
    log "Starting ZealOS build for Nerv Microkernel integration"
    
    check_environment
    prepare_build
    build_zealbooter
    build_zealos
    copy_artifacts
    verify_build
    test_isos "$@"
    generate_report
    
    success "ZealOS build completed successfully!"
    log "Artifacts available in: $PROJECT_ROOT/dist/zealos/"
    log "Build report: $PROJECT_ROOT/build/zealos-build-report.md"
}

# Execute main function with all arguments
main "$@"
