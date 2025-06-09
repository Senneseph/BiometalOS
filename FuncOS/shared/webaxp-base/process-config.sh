#!/bin/bash

# WebAXP Configuration Processor
# Terraform-like configuration system for project customization

set -e

CONFIG_FILE="/workspace/config/webaxp.yaml"
DEFAULT_CONFIG="/workspace/config/default.yaml"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() {
    echo -e "${BLUE}[WebAXP]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Load configuration
load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        log "Loading project configuration: $CONFIG_FILE"
        export CONFIG_SOURCE="$CONFIG_FILE"
    elif [ -f "$DEFAULT_CONFIG" ]; then
        log "Loading default configuration: $DEFAULT_CONFIG"
        export CONFIG_SOURCE="$DEFAULT_CONFIG"
    else
        log "No configuration found, using environment defaults"
        return 0
    fi
    
    # Extract configuration values using yq
    if command -v yq &> /dev/null; then
        export PROJECT_NAME=$(yq eval '.project.name // "unknown"' "$CONFIG_SOURCE")
        export PROJECT_TYPE=$(yq eval '.project.type // "generic"' "$CONFIG_SOURCE")
        export BUILD_TOOLCHAIN=$(yq eval '.build.toolchain // "multi"' "$CONFIG_SOURCE")
        export TARGET_ARCH=$(yq eval '.build.target_arch // "x86_64"' "$CONFIG_SOURCE")
        export FEATURES=$(yq eval '.features[]? // empty' "$CONFIG_SOURCE" | tr '\n' ' ')
        
        log "Project: $PROJECT_NAME ($PROJECT_TYPE)"
        log "Toolchain: $BUILD_TOOLCHAIN"
        log "Architecture: $TARGET_ARCH"
        log "Features: $FEATURES"
    fi
}

# Process build commands
process_build_commands() {
    if [ -f "$CONFIG_SOURCE" ] && command -v yq &> /dev/null; then
        local build_commands=$(yq eval '.build.commands[]? // empty' "$CONFIG_SOURCE")
        
        if [ -n "$build_commands" ]; then
            log "Executing build commands..."
            echo "$build_commands" | while read -r cmd; do
                if [ -n "$cmd" ]; then
                    log "Running: $cmd"
                    eval "$cmd" || error "Build command failed: $cmd"
                fi
            done
        fi
    fi
}

# Set up project-specific environment
setup_environment() {
    # Create project-specific directories
    if [ -n "$PROJECT_NAME" ]; then
        mkdir -p "/workspace/cache/$PROJECT_NAME"
        mkdir -p "/workspace/build/$PROJECT_NAME"
        mkdir -p "/workspace/dist/$PROJECT_NAME"
    fi
    
    # Set up toolchain-specific environment
    case "$BUILD_TOOLCHAIN" in
        "zig")
            export CC="zig cc"
            export CXX="zig c++"
            ;;
        "rust")
            source ~/.cargo/env 2>/dev/null || true
            ;;
        "go")
            export GOROOT="/opt/go"
            export GOPATH="/workspace/cache/go"
            mkdir -p "$GOPATH"
            ;;
    esac
    
    # Feature-specific setup
    echo "$FEATURES" | grep -q "neural" && {
        export PYTHONPATH="/workspace/app:$PYTHONPATH"
    } || true
    
    echo "$FEATURES" | grep -q "wasm" && {
        export WASM_TARGET="wasm32-unknown-unknown"
    } || true
}

# Generate project documentation
generate_docs() {
    if [ -f "/workspace/spec/api.yaml" ] && command -v swagger-codegen &> /dev/null; then
        log "Generating API documentation..."
        mkdir -p "/workspace/docs/api"
        swagger-codegen generate \
            -i "/workspace/spec/api.yaml" \
            -l html2 \
            -o "/workspace/docs/api" || true
    fi
    
    if [ -f "/workspace/spec/README.md" ]; then
        log "Processing specification documentation..."
        mkdir -p "/workspace/docs"
        cp "/workspace/spec/README.md" "/workspace/docs/"
    fi
}

# Validate WebAXP structure
validate_structure() {
    log "Validating WebAXP project structure..."
    
    local required_dirs=("spec" "app" "build" "dist" "docs" "develop")
    local missing_dirs=()
    
    for dir in "${required_dirs[@]}"; do
        if [ ! -d "/workspace/$dir" ]; then
            missing_dirs+=("$dir")
        fi
    done
    
    if [ ${#missing_dirs[@]} -eq 0 ]; then
        success "WebAXP structure validation passed"
    else
        error "Missing required directories: ${missing_dirs[*]}"
    fi
}

# Main execution
main() {
    log "Starting WebAXP configuration processing..."
    
    load_config
    setup_environment
    validate_structure
    process_build_commands
    generate_docs
    
    success "WebAXP configuration processing completed"
    
    # If additional arguments provided, execute them
    if [ $# -gt 0 ]; then
        log "Executing command: $*"
        exec "$@"
    else
        log "Entering interactive shell..."
        exec bash
    fi
}

# Execute main with all arguments
main "$@"
