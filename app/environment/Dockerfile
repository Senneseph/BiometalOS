# Project Biometal - Application Development Environment
# Browser-centric development with WebAssembly compilation support

FROM debian:bookworm-slim

# Build arguments
ARG TARGET_ARCH=x86_64
ARG BUILD_MODE=debug
ARG ZIG_VERSION=0.12.0

# Environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV TARGET_ARCH=${TARGET_ARCH}
ENV BUILD_MODE=${BUILD_MODE}
ENV FUNCOS_MODE=development
ENV PATH="/opt/zig:${PATH}"

# Install base dependencies
RUN apt-get update && apt-get install -y \
    # Core development tools
    curl wget git build-essential \
    # Cross-compilation support
    gcc-multilib g++-multilib \
    # WebAssembly toolchain
    nodejs npm \
    # QEMU for testing
    qemu-system-x86 qemu-system-arm qemu-utils \
    # Development utilities
    vim nano htop tree jq \
    # Network tools for API development
    netcat-openbsd socat \
    # Documentation tools
    pandoc \
    && rm -rf /var/lib/apt/lists/*

# Install Zig toolchain (primary language for FuncOS)
RUN curl -L "https://ziglang.org/download/${ZIG_VERSION}/zig-linux-x86_64-${ZIG_VERSION}.tar.xz" \
    | tar -xJ -C /opt \
    && mv "/opt/zig-linux-x86_64-${ZIG_VERSION}" /opt/zig

# Install WebAssembly tools (for browser-centric execution)
RUN npm install -g \
    wabt

# Install Rust (for WebAssembly and compatibility modules)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
    && . ~/.cargo/env \
    && rustup target add wasm32-unknown-unknown \
    && rustup target add wasm32-wasip1

# Add Rust to PATH
ENV PATH="/root/.cargo/bin:${PATH}"

# Create workspace structure
WORKDIR /workspace
RUN mkdir -p \
    /workspace/src \
    /workspace/spec \
    /workspace/config \
    /workspace/build \
    /workspace/dist \
    /workspace/docs

# Create scripts directory (scripts will be mounted at runtime)
RUN mkdir -p /workspace/scripts

# Development server setup
EXPOSE 8080 2345 3000

# Default command for development
CMD ["bash", "-c", "echo 'FuncOS Development Environment Ready' && echo 'Target: ${TARGET_ARCH} | Mode: ${BUILD_MODE}' && bash"]