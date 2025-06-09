# WebAXP Base Container - Generic Environment for All Sub-Projects
# Terraform-like configuration system for project-specific customization

FROM debian:bookworm-slim

# Build arguments for customization
ARG PROJECT_TYPE=generic
ARG TOOLCHAIN=multi
ARG TARGET_ARCH=x86_64
ARG FEATURES=""

# Environment variables
ENV PROJECT_TYPE=${PROJECT_TYPE}
ENV TOOLCHAIN=${TOOLCHAIN}
ENV TARGET_ARCH=${TARGET_ARCH}
ENV FEATURES=${FEATURES}
ENV DEBIAN_FRONTEND=noninteractive

# Base system packages (always installed)
RUN apt-get update && apt-get install -y \
    # Core utilities
    curl wget git vim nano \
    build-essential cmake ninja-build \
    # Archive and compression
    tar gzip xz-utils unzip p7zip-full \
    # Development tools
    jq yq-go \
    # Network tools
    netcat-openbsd socat \
    # Documentation
    pandoc \
    && rm -rf /var/lib/apt/lists/*

# Conditional package installation based on project type
RUN case "${PROJECT_TYPE}" in \
    "operating-system") \
        apt-get update && apt-get install -y \
            qemu-system-x86 qemu-system-arm qemu-utils \
            xorriso grub-pc-bin grub-efi-amd64-bin \
            nasm yasm binutils \
            && rm -rf /var/lib/apt/lists/* ;; \
    "kernel") \
        apt-get update && apt-get install -y \
            gcc-multilib g++-multilib \
            gcc-aarch64-linux-gnu g++-aarch64-linux-gnu \
            gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf \
            clang llvm lld \
            && rm -rf /var/lib/apt/lists/* ;; \
    "api") \
        apt-get update && apt-get install -y \
            nodejs npm \
            python3 python3-pip \
            openjdk-17-jdk \
            && rm -rf /var/lib/apt/lists/* ;; \
    "neural") \
        apt-get update && apt-get install -y \
            python3 python3-pip python3-venv \
            && rm -rf /var/lib/apt/lists/* ;; \
    "browser") \
        apt-get update && apt-get install -y \
            nodejs npm \
            chromium \
            && rm -rf /var/lib/apt/lists/* ;; \
    *) \
        echo "Generic project type, no additional packages" ;; \
    esac

# Conditional toolchain installation
RUN case "${TOOLCHAIN}" in \
    "zig"|"multi") \
        curl -L "https://ziglang.org/download/0.12.0/zig-linux-x86_64-0.12.0.tar.xz" \
        | tar -xJ -C /opt \
        && mv "/opt/zig-linux-x86_64-0.12.0" /opt/zig ;; \
    esac

RUN case "${TOOLCHAIN}" in \
    "rust"|"multi") \
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
        && . ~/.cargo/env \
        && rustup target add wasm32-unknown-unknown \
        && rustup target add wasm32-wasip1 ;; \
    esac

RUN case "${TOOLCHAIN}" in \
    "go"|"multi") \
        curl -L "https://go.dev/dl/go1.21.5.linux-amd64.tar.gz" \
        | tar -xz -C /opt ;; \
    esac

# Feature-based installations
RUN echo "${FEATURES}" | grep -q "wasm" && { \
        npm install -g wabt; \
    } || true

RUN echo "${FEATURES}" | grep -q "neural" && { \
        pip3 install numpy scipy scikit-learn; \
    } || true

RUN echo "${FEATURES}" | grep -q "docs" && { \
        npm install -g @apidevtools/swagger-cli; \
    } || true

# Set up PATH for all toolchains
ENV PATH="/opt/zig:/opt/go/bin:/root/.cargo/bin:${PATH}"

# Create standard WebAXP directory structure
WORKDIR /workspace
RUN mkdir -p \
    /workspace/spec \
    /workspace/app \
    /workspace/build \
    /workspace/dist \
    /workspace/docs \
    /workspace/develop \
    /workspace/config \
    /workspace/cache

# Copy configuration processor
COPY process-config.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/process-config.sh

# Default command processes terraform-like config
CMD ["/usr/local/bin/process-config.sh"]
