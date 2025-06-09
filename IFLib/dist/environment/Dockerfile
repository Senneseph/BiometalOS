# Project Biometal - Distribution & Testing Environment
# VM testing, packaging, and Foreign Program Execution Profiler (FPEP) support

FROM debian:bookworm-slim

# Environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV QEMU_MEMORY=64M
ENV QEMU_CPU=486
ENV TEST_SUITE=all

# Install distribution and testing tools
RUN apt-get update && apt-get install -y \
    # QEMU for VM testing
    qemu-system-x86 qemu-system-arm qemu-utils \
    # KVM support (if available)
    qemu-kvm \
    # Virtualization tools
    libvirt-clients virt-manager \
    # ISO creation tools
    genisoimage xorriso \
    # Archive and compression
    tar gzip xz-utils zip unzip \
    # Network testing tools
    netcat-openbsd socat curl wget \
    # System monitoring for FPEP
    strace ltrace \
    # Container tools for sandboxing
    runc containerd \
    # Performance analysis
    perf-tools-unstable \
    # File system tools
    dosfstools mtools \
    # Debugging tools
    gdb valgrind \
    # Scripting and automation
    bash expect python3 python3-pip \
    # YAML processing
    yq \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages for automation
RUN pip3 install --no-cache-dir \
    pexpect \
    psutil \
    pyyaml \
    requests

# Create testing workspace
WORKDIR /workspace
RUN mkdir -p \
    /workspace/dist \
    /workspace/spec \
    /workspace/config \
    /workspace/tests \
    /workspace/vm \
    /workspace/fpep

# Create scripts directory (scripts will be mounted at runtime)
RUN mkdir -p /workspace/scripts

# Set up VM testing environment
RUN mkdir -p \
    /workspace/vm/images \
    /workspace/vm/iso \
    /workspace/vm/logs \
    /workspace/fpep/sandbox \
    /workspace/fpep/logs \
    /workspace/fpep/profiles

# Configure QEMU networking (for API testing)
RUN mkdir -p /etc/qemu && \
    echo "allow br0" > /etc/qemu/bridge.conf

# FPEP (Foreign Program Execution Profiler) setup
# This will be used for sandboxing and reverse-engineering legacy code
RUN mkdir -p \
    /workspace/fpep/targets \
    /workspace/fpep/analysis \
    /workspace/fpep/models

# Expose ports for testing
EXPOSE 8080 8081 8082

# Default testing command
CMD ["bash", "-c", "echo 'FuncOS Distribution & Testing Environment Ready' && echo 'QEMU Memory: ${QEMU_MEMORY} | CPU: ${QEMU_CPU}' && bash"]