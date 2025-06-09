#!/bin/bash
# Biometal - Development Shell
# Interactive development environment with API-first tooling

set -euo pipefail

# === Configuration ===
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="$(dirname "$SCRIPT_DIR")"
TARGET_ARCH="${TARGET_ARCH:-x86_64}"
BUILD_MODE="${BUILD_MODE:-debug}"
FUNCOS_MODE="${FUNCOS_MODE:-development}"

# === Colors for output ===
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# === Logging ===
log_info() { echo -e "${BLUE}[INFO]${NC} $*"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $*"; }

# === Development Functions ===
show_banner() {
    cat << 'EOF'
    ____  _                      _        _    ___  ____  
   |  _ \(_) ___  _ __ ___   ___| |_ __ _| |  / _ \/ ___| 
   | |_) | |/ _ \| '_ ` _ \ / _ \ __/ _` | | | | | \___ \ 
   |  _ <| | (_) | | | | | |  __/ || (_| | | | |_| |___) |
   |_| \_\_|\___/|_| |_| |_|\___|\__\__,_|_|  \___/|____/ 
                                                          
   FuncOS Development Environment
   API-First | Hardware-Aware | Neural-Optimized
EOF
    echo
    echo -e "${CYAN}Project:${NC} Project Biometal"
    echo -e "${CYAN}OS:${NC} FuncOS"
    echo -e "${CYAN}Mode:${NC} $FUNCOS_MODE"
    echo -e "${CYAN}Target:${NC} $TARGET_ARCH"
    echo -e "${CYAN}Build:${NC} $BUILD_MODE"
    echo
}

show_help() {
    cat << EOF
${GREEN}FuncOS Development Commands:${NC}

${YELLOW}Build & Test:${NC}
  build                 - Build FuncOS kernel and userland
  test [suite]          - Run test suite (all, specs, build, vm, api, fpep)
  clean                 - Clean build artifacts
  profile               - Run hardware profiling

${YELLOW}API Development:${NC}
  api-validate          - Validate all API specifications
  api-generate          - Generate code from API specs
  api-docs              - Generate API documentation
  api-serve             - Serve interactive API documentation

${YELLOW}System Development:${NC}
  kernel-build          - Build kernel only
  userland-build        - Build userland components
  wasm-build            - Build WebAssembly components
  cross-build [arch]    - Cross-compile for architecture

${YELLOW}Testing & Validation:${NC}
  vm-test               - Test in virtual machine
  fpep-test             - Test Foreign Program Execution Profiler
  spec-validate         - Validate all specifications
  hardware-test         - Test hardware detection

${YELLOW}Development Tools:${NC}
  dev-server            - Start development server
  debug [target]        - Start debugger for target
  monitor               - Monitor system performance
  logs [service]        - View service logs

${YELLOW}Neural Interface:${NC}
  neural-stub           - Start neural interface stub
  neural-train          - Collect training data
  neural-optimize       - Get optimization hints

${YELLOW}Utilities:${NC}
  status                - Show development environment status
  env                   - Show environment variables
  help                  - Show this help message
  exit                  - Exit development shell

${YELLOW}Examples:${NC}
  build                 - Build everything
  test api              - Test API specifications
  cross-build arm64     - Cross-compile for ARM64
  vm-test               - Test in QEMU
EOF
}

show_status() {
    echo -e "${GREEN}Development Environment Status:${NC}"
    echo
    
    # Check toolchain availability
    echo -e "${CYAN}Toolchains:${NC}"
    for tool in zig rustc gcc clang; do
        if command -v "$tool" >/dev/null 2>&1; then
            local version
            case "$tool" in
                "zig") version=$(zig version 2>/dev/null || echo "unknown") ;;
                "rustc") version=$(rustc --version 2>/dev/null | cut -d' ' -f2 || echo "unknown") ;;
                "gcc") version=$(gcc --version 2>/dev/null | head -1 | cut -d' ' -f4 || echo "unknown") ;;
                "clang") version=$(clang --version 2>/dev/null | head -1 | cut -d' ' -f3 || echo "unknown") ;;
            esac
            echo -e "  ✓ $tool ($version)"
        else
            echo -e "  ✗ $tool (not available)"
        fi
    done
    
    echo
    echo -e "${CYAN}Cross-compilation:${NC}"
    for tool in aarch64-linux-gnu-gcc arm-linux-gnueabihf-gcc; do
        if command -v "$tool" >/dev/null 2>&1; then
            echo -e "  ✓ $tool"
        else
            echo -e "  ✗ $tool"
        fi
    done
    
    echo
    echo -e "${CYAN}Development Tools:${NC}"
    for tool in qemu-system-x86_64 qemu-system-aarch64 gdb valgrind strace; do
        if command -v "$tool" >/dev/null 2>&1; then
            echo -e "  ✓ $tool"
        else
            echo -e "  ✗ $tool"
        fi
    done
    
    echo
    echo -e "${CYAN}Specifications:${NC}"
    local spec_count=0
    if [[ -d "$WORKSPACE_DIR/spec/api" ]]; then
        spec_count=$(find "$WORKSPACE_DIR/spec/api" -name "*.yaml" | wc -l)
        echo -e "  API specs: $spec_count"
    fi
    
    if [[ -d "$WORKSPACE_DIR/spec/systems" ]]; then
        spec_count=$(find "$WORKSPACE_DIR/spec/systems" -name "*.yaml" | wc -l)
        echo -e "  System specs: $spec_count"
    fi
    
    echo
    echo -e "${CYAN}Build Artifacts:${NC}"
    if [[ -d "$WORKSPACE_DIR/dist" ]]; then
        local artifact_count
        artifact_count=$(find "$WORKSPACE_DIR/dist" -type f | wc -l)
        echo -e "  Artifacts: $artifact_count files"
    else
        echo -e "  No build artifacts found"
    fi
}

show_env() {
    echo -e "${GREEN}Environment Variables:${NC}"
    echo
    echo -e "${CYAN}Core Configuration:${NC}"
    echo -e "  TARGET_ARCH=$TARGET_ARCH"
    echo -e "  BUILD_MODE=$BUILD_MODE"
    echo -e "  FUNCOS_MODE=$FUNCOS_MODE"
    echo -e "  TOOLCHAIN=${TOOLCHAIN:-zig}"
    echo -e "  PARALLEL_JOBS=${PARALLEL_JOBS:-4}"
    echo
    echo -e "${CYAN}Development:${NC}"
    echo -e "  DEV_PORT=${DEV_PORT:-8080}"
    echo -e "  DEBUG_PORT=${DEBUG_PORT:-2345}"
    echo -e "  LOG_LEVEL=${LOG_LEVEL:-info}"
    echo
    echo -e "${CYAN}Testing:${NC}"
    echo -e "  QEMU_MEMORY=${QEMU_MEMORY:-64M}"
    echo -e "  QEMU_CPU=${QEMU_CPU:-486}"
    echo -e "  TEST_SUITE=${TEST_SUITE:-all}"
}

# === Command Handlers ===
handle_command() {
    local cmd="$1"
    shift || true
    
    case "$cmd" in
        "build")
            log_info "Building FuncOS..."
            "$WORKSPACE_DIR/scripts/build.sh"
            ;;
        "test")
            local suite="${1:-all}"
            log_info "Running test suite: $suite"
            TEST_SUITE="$suite" "$WORKSPACE_DIR/scripts/test.sh"
            ;;
        "clean")
            log_info "Cleaning build artifacts..."
            rm -rf "$WORKSPACE_DIR/dist"/*
            log_success "Build artifacts cleaned"
            ;;
        "profile")
            log_info "Running hardware profiling..."
            "$WORKSPACE_DIR/scripts/hardware-profile.sh"
            ;;
        "api-validate")
            log_info "Validating API specifications..."
            "$WORKSPACE_DIR/scripts/validate-specs.sh"
            ;;
        "api-generate")
            log_info "Generating code from API specs..."
            # This would call actual code generation tools
            log_warn "Code generation not yet implemented"
            ;;
        "api-docs")
            log_info "Generating API documentation..."
            # This would generate docs from OpenAPI specs
            log_warn "API documentation generation not yet implemented"
            ;;
        "vm-test")
            log_info "Testing in virtual machine..."
            TEST_SUITE="vm" "$WORKSPACE_DIR/scripts/test.sh"
            ;;
        "status")
            show_status
            ;;
        "env")
            show_env
            ;;
        "help")
            show_help
            ;;
        "exit"|"quit")
            log_info "Exiting development shell..."
            exit 0
            ;;
        "")
            # Empty command, do nothing
            ;;
        *)
            log_error "Unknown command: $cmd"
            echo "Type 'help' for available commands"
            ;;
    esac
}

# === Interactive Shell ===
interactive_shell() {
    show_banner
    show_help
    echo
    
    while true; do
        echo -n -e "${PURPLE}funcos-dev${NC} ${CYAN}[$TARGET_ARCH]${NC} $ "
        read -r input
        
        if [[ -n "$input" ]]; then
            # Split input into command and arguments
            read -ra cmd_args <<< "$input"
            handle_command "${cmd_args[@]}"
        fi
        
        echo
    done
}

# === Main Function ===
main() {
    cd "$WORKSPACE_DIR"
    
    # If arguments provided, execute command and exit
    if [[ $# -gt 0 ]]; then
        handle_command "$@"
    else
        # Start interactive shell
        interactive_shell
    fi
}

# === Script Entry Point ===
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
