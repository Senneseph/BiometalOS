# Project Biometal - Build Environment
# Specification-driven build pipeline with cross-compilation support

FROM debian:bookworm-slim

# Build arguments
ARG TOOLCHAIN=zig
ARG TARGET_ARCH=x86_64
ARG ZIG_VERSION=0.12.0

# Environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV TOOLCHAIN=${TOOLCHAIN}
ENV TARGET_ARCH=${TARGET_ARCH}
ENV PATH="/opt/zig:/opt/llvm/bin:${PATH}"

# Install build dependencies
RUN apt-get update && apt-get install -y \
    # Core build tools
    curl wget git build-essential cmake ninja-build \
    # Cross-compilation toolchains
    gcc-aarch64-linux-gnu g++-aarch64-linux-gnu \
    gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf \
    # LLVM/Clang for advanced compilation
    clang llvm lld \
    # Assembly and linking tools
    nasm yasm binutils \
    # Archive and compression tools
    tar gzip xz-utils unzip \
    # Hardware profiling tools
    cpuid dmidecode \
    # QEMU for cross-platform testing
    qemu-system-x86 qemu-system-arm qemu-user-static \
    # Validation tools
    file \
    # YAML processing for specs
    yq \
    && rm -rf /var/lib/apt/lists/*

# Install Zig toolchain (primary)
RUN curl -L "https://ziglang.org/download/${ZIG_VERSION}/zig-linux-x86_64-${ZIG_VERSION}.tar.xz" \
    | tar -xJ -C /opt \
    && mv "/opt/zig-linux-x86_64-${ZIG_VERSION}" /opt/zig

# Install additional toolchains based on build argument
RUN if [ "$TOOLCHAIN" = "rust" ]; then \
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
        && . ~/.cargo/env \
        && rustup target add x86_64-unknown-linux-gnu \
        && rustup target add aarch64-unknown-linux-gnu; \
    fi

# Add Rust to PATH if installed
ENV PATH="/root/.cargo/bin:${PATH}"

# Create build workspace
WORKDIR /workspace
RUN mkdir -p \
    /workspace/src \
    /workspace/spec \
    /workspace/config \
    /workspace/build \
    /workspace/dist \
    /workspace/cache

# Create scripts directory (scripts will be mounted at runtime)
RUN mkdir -p /workspace/scripts

# Set up build cache directories
RUN mkdir -p \
    /workspace/cache/zig \
    /workspace/cache/artifacts \
    /workspace/cache/downloads

# Configure cross-compilation environment
ENV CC_aarch64_unknown_linux_gnu=aarch64-linux-gnu-gcc
ENV CXX_aarch64_unknown_linux_gnu=aarch64-linux-gnu-g++
ENV AR_aarch64_unknown_linux_gnu=aarch64-linux-gnu-ar
ENV STRIP_aarch64_unknown_linux_gnu=aarch64-linux-gnu-strip

# Default build command
CMD ["bash", "-c", "echo 'FuncOS Build Environment Ready' && echo 'Toolchain: ${TOOLCHAIN} | Target: ${TARGET_ARCH}' && bash"]