#!/bin/bash
# Project Biometal - FuncOS Build Script (WebAXP Idempotent)

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CHECKSUM_FILE="${PROJECT_ROOT}/build/.funcos-build-checksum"

log_info() {
    echo "[INFO] $*"
}

calculate_dependencies_checksum() {
    local temp_file=$(mktemp)
    
    # Hash key dependency files
    find "${PROJECT_ROOT}/spec" -name "*.yaml" 2>/dev/null | sort | xargs sha256sum >> "$temp_file" || true
    find "${PROJECT_ROOT}/app" -name "*.zig" 2>/dev/null | sort | xargs sha256sum >> "$temp_file" || true
    sha256sum "${PROJECT_ROOT}/docker-compose.yaml" >> "$temp_file" 2>/dev/null || true
    
    sha256sum "$temp_file" | cut -d' ' -f1
    rm -f "$temp_file"
}

check_build_needed() {
    local current_checksum=$(calculate_dependencies_checksum)
    local stored_checksum=""
    
    if [ -f "$CHECKSUM_FILE" ]; then
        stored_checksum=$(cat "$CHECKSUM_FILE")
    fi
    
    if [ "$current_checksum" = "$stored_checksum" ]; then
        log_info "Build is up-to-date (checksum: ${current_checksum:0:8}...)"
        return 1  # Build not needed
    else
        log_info "Build needed (checksum changed)"
        echo "$current_checksum" > "$CHECKSUM_FILE"
        return 0  # Build needed
    fi
}

main() {
    log_info "Starting FuncOS build (WebAXP Idempotent)..."
    
    cd "$PROJECT_ROOT"
    
    # Check if build is needed (idempotency)
    if ! check_build_needed; then
        log_info "Build skipped - no changes detected"
        return 0
    fi
    
    log_info "Building FuncOS components..."
    docker-compose --profile build up --build
    
    log_info "FuncOS build completed successfully!"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
