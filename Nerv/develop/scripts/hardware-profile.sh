#!/bin/bash
# Nerv - Hardware Profiler
# Detects optimal build targets and runtime parameters

set -euo pipefail

# === Configuration ===
OUTPUT_FILE="${OUTPUT_FILE:-/workspace/config/hardware-profile.yaml}"
LOG_LEVEL="${LOG_LEVEL:-info}"
TARGET_ARCH="${TARGET_ARCH:-auto}"

# === Logging Functions ===
log_info() { [[ "$LOG_LEVEL" =~ ^(debug|info)$ ]] && echo "[INFO] $*" >&2; }
log_warn() { [[ "$LOG_LEVEL" =~ ^(debug|info|warn)$ ]] && echo "[WARN] $*" >&2; }
log_error() { echo "[ERROR] $*" >&2; }
log_debug() { [[ "$LOG_LEVEL" == "debug" ]] && echo "[DEBUG] $*" >&2; }

# === Hardware Detection Functions ===
detect_cpu_architecture() {
    local arch
    if [[ -f /host/cpuinfo ]]; then
        arch=$(grep -m1 "^processor" /host/cpuinfo | head -1 | cut -d: -f2 | xargs)
        if grep -q "x86_64\|amd64" /host/cpuinfo; then
            echo "x86_64"
        elif grep -q "aarch64\|arm64" /host/cpuinfo; then
            echo "arm64"
        elif grep -q "armv7" /host/cpuinfo; then
            echo "arm32"
        else
            echo "unknown"
        fi
    else
        uname -m
    fi
}

detect_cpu_features() {
    local features=()
    
    if [[ -f /host/cpuinfo ]]; then
        if grep -q "sse2" /host/cpuinfo; then features+=("sse2"); fi
        if grep -q "avx" /host/cpuinfo; then features+=("avx"); fi
        if grep -q "avx2" /host/cpuinfo; then features+=("avx2"); fi
        if grep -q "avx512" /host/cpuinfo; then features+=("avx512"); fi
        if grep -q "neon" /host/cpuinfo; then features+=("neon"); fi
    fi
    
    printf '%s\n' "${features[@]}"
}

detect_memory_info() {
    local total_mem="unknown"
    local available_mem="unknown"
    
    if [[ -f /proc/meminfo ]]; then
        total_mem=$(grep "MemTotal:" /proc/meminfo | awk '{print $2}')
        available_mem=$(grep "MemAvailable:" /proc/meminfo | awk '{print $2}')
    fi
    
    echo "total: ${total_mem}"
    echo "available: ${available_mem}"
}

detect_virtualization() {
    local virt_type="none"
    
    # Check for common virtualization indicators
    if [[ -f /host/sys/hypervisor/type ]]; then
        virt_type=$(cat /host/sys/hypervisor/type 2>/dev/null || echo "unknown")
    elif grep -q "hypervisor" /host/cpuinfo 2>/dev/null; then
        virt_type="hypervisor"
    elif [[ -d /host/sys/firmware/efi ]]; then
        virt_type="uefi"
    fi
    
    echo "$virt_type"
}

determine_optimal_config() {
    local arch="$1"
    local features="$2"
    local memory="$3"
    
    # Determine optimal build configuration
    local build_config="debug"
    local parallel_jobs=2
    local qemu_memory="64M"
    
    # Adjust based on available memory
    if [[ "$memory" =~ ^[0-9]+$ ]] && [[ $memory -gt 8000000 ]]; then
        parallel_jobs=4
        qemu_memory="128M"
        build_config="release"
    elif [[ "$memory" =~ ^[0-9]+$ ]] && [[ $memory -gt 4000000 ]]; then
        parallel_jobs=3
        qemu_memory="96M"
    fi
    
    echo "build_config: $build_config"
    echo "parallel_jobs: $parallel_jobs"
    echo "qemu_memory: $qemu_memory"
}

# === Main Hardware Profiling ===
main() {
    log_info "Starting hardware profiling for Project Biometal..."
    
    # Create output directory
    mkdir -p "$(dirname "$OUTPUT_FILE")"
    
    # Detect hardware characteristics
    log_info "Detecting CPU architecture..."
    local cpu_arch
    cpu_arch=$(detect_cpu_architecture)
    log_debug "Detected CPU architecture: $cpu_arch"
    
    log_info "Detecting CPU features..."
    local cpu_features
    cpu_features=$(detect_cpu_features)
    log_debug "Detected CPU features: $cpu_features"
    
    log_info "Detecting memory configuration..."
    local memory_info
    memory_info=$(detect_memory_info)
    log_debug "Memory info: $memory_info"
    
    log_info "Detecting virtualization environment..."
    local virt_env
    virt_env=$(detect_virtualization)
    log_debug "Virtualization: $virt_env"
    
    # Determine optimal configuration
    local total_mem
    total_mem=$(echo "$memory_info" | grep "total:" | cut -d: -f2 | xargs)
    local optimal_config
    optimal_config=$(determine_optimal_config "$cpu_arch" "$cpu_features" "$total_mem")
    
    # Generate hardware profile YAML
    log_info "Generating hardware profile: $OUTPUT_FILE"
    
    cat > "$OUTPUT_FILE" << EOF
# Nerv - Hardware Profile
# Generated: $(date -Iseconds)

detection:
  timestamp: "$(date -Iseconds)"
  method: "container-based"
  target_arch_override: "$TARGET_ARCH"

hardware:
  cpu:
    architecture: "$cpu_arch"
    features:
$(echo "$cpu_features" | sed 's/^/      - /')
    
  memory:
$(echo "$memory_info" | sed 's/^/    /')
    
  virtualization:
    type: "$virt_env"
    kvm_available: $([ -c /dev/kvm ] && echo "true" || echo "false")

optimal_configuration:
$(echo "$optimal_config" | sed 's/^/  /')

recommendations:
  toolchain:
    primary: "zig"
    version: "0.12.0"
    
  build:
    target_arch: "$cpu_arch"
    optimization: "$(echo "$optimal_config" | grep build_config | cut -d: -f2 | xargs)"
    parallel_jobs: $(echo "$optimal_config" | grep parallel_jobs | cut -d: -f2 | xargs)
    
  runtime:
    qemu_memory: "$(echo "$optimal_config" | grep qemu_memory | cut -d: -f2 | xargs)"
    neural_interface: "stub"
    
  development:
    hot_reload: true
    debug_symbols: true
    introspection: "full"
EOF

    log_info "Hardware profiling complete!"
    log_info "Profile saved to: $OUTPUT_FILE"
    
    # Display summary
    if [[ "$LOG_LEVEL" =~ ^(debug|info)$ ]]; then
        echo
        echo "=== Hardware Profile Summary ==="
        echo "Architecture: $cpu_arch"
        echo "Features: $(echo "$cpu_features" | tr '\n' ' ')"
        echo "Memory: $total_mem KB"
        echo "Virtualization: $virt_env"
        echo "Recommended parallel jobs: $(echo "$optimal_config" | grep parallel_jobs | cut -d: -f2 | xargs)"
        echo "================================"
    fi
}

# === Script Entry Point ===
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
