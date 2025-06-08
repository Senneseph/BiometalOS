# 🎫 TICKET: ZealOS Integration & WebAXP Foundation

**Ticket ID**: 20241215-zealos-integration
**Project**: ZealOS-Integration
**Status**: 🟢 READY TO START
**Priority**: HIGH
**Assignee**: ZealOS Integration Team

### Overview
Integrate ZealOS (Senneseph fork) into the Project Biometal ecosystem following WebAXP conventions. This ticket establishes the foundational build system and development environment that will serve as the base for FuncOS development, ensuring ZealOS builds reliably and consistently within our specification-driven architecture.

### Architecture Context
ZealOS integration serves as the **foundational layer** for Project Biometal:
1. **ZealOS Base** ← **THIS TICKET** - Reliable build system and WebAXP integration
2. **FuncOS Core** - Function-oriented extensions built on ZealOS
3. **Project Biometal** - Neural data collection from function execution
4. **Application Layer** - Function-level hardware requests via service APIs
5. **Browser Ecosystem** - WebAXP network API for hardware access

### Objectives
- [ ] Establish reliable ZealOS build system within WebAXP conventions
- [ ] Create specification-driven build configuration
- [ ] Implement containerized development environment
- [ ] Define system specifications for target architectures
- [ ] Enable parallel development of FuncOS components

### Prerequisites
- Understanding of ZealOS architecture and build system
- Docker and containerization experience
- WebAXP convention knowledge
- Build system automation experience

### ZealOS Repository
**Source**: https://github.com/Senneseph/ZealOS
- Fork of the original ZealOS project
- Contains Project Biometal-specific modifications
- Target for FuncOS development foundation

### Project Structure (WebAXP Compliant)
```
ZealOS-Integration/
├── spec/           # ZealOS build specifications and system definitions
│   ├── api/        # Build system APIs (if exposing build services)
│   ├── systems/    # Target architecture specifications
│   │   ├── x86_64.yaml     # x86_64 build configuration
│   │   ├── arm64.yaml      # ARM64 build configuration (future)
│   │   └── embedded.yaml   # Embedded targets (future)
│   ├── build.yaml  # Build requirements and strategies
│   └── zealos.yaml # ZealOS-specific configuration
├── app/            # ZealOS source integration and development tools
│   ├── src/        # ZealOS source code (git submodule or clone)
│   └── environment/ # Development environment configuration
├── build/          # Build system and toolchain configuration
│   ├── environment/ # Build environment (Docker, toolchain)
│   ├── scripts/    # Build automation scripts
│   └── targets/    # Target-specific build configurations
├── dist/           # Built ZealOS artifacts and testing
│   ├── environment/ # Testing environment (QEMU, VMs)
│   ├── iso/        # Built ISO images
│   └── packages/   # Distribution packages
├── docs/           # ZealOS integration documentation
│   ├── environment/ # Documentation environment
│   ├── build/      # Build system documentation
│   └── api/        # API documentation (if applicable)
└── develop/        # Development tools and scripts
    ├── scripts/    # Development automation
    └── environment/ # Development environment setup
```

### Setup Instructions

1. **Initialize Project Structure**
   ```bash
   mkdir -p ZealOS-Integration/{spec,app,build,dist,docs,develop}
   cd ZealOS-Integration
   ```

2. **Configure WebAXP Environment**
   ```bash
   # Create project configuration
   cat > spec/zealos.yaml << EOF
   project:
     name: "ZealOS-Integration"
     type: "system"
     description: "ZealOS integration for Project Biometal foundation"
   
   source:
     repository: "https://github.com/Senneseph/ZealOS"
     branch: "main"
     integration_method: "submodule"
   
   build:
     toolchain: "gcc"
     target_arch: "x86_64"
     optimization: "size"
     
   targets:
     - name: "x86_64-bios"
       bootloader: "legacy"
       format: "iso"
     - name: "x86_64-uefi"
       bootloader: "uefi"
       format: "iso"
   
   features:
     - "iso-generation"
     - "vm-testing"
     - "debug-symbols"
   EOF
   ```

3. **Set Environment Variables**
   ```bash
   export PROJECT_NAME="ZealOS-Integration"
   export PROJECT_TYPE="system"
   export ZEALOS_REPO="https://github.com/Senneseph/ZealOS"
   ```

### Core Development Tasks

#### 1. ZealOS Source Integration (`app/src/`)

**Integrate ZealOS Repository**
```bash
# Add ZealOS as git submodule
git submodule add https://github.com/Senneseph/ZealOS app/src/zealos

# Or clone directly for development
git clone https://github.com/Senneseph/ZealOS app/src/zealos
```

**Source Organization**
- `app/src/zealos/` - ZealOS source code
- `app/src/patches/` - Project Biometal-specific patches
- `app/src/config/` - Build configuration overrides

#### 2. Build System Specification (`spec/systems/`)

**x86_64 Build Specification** (`spec/systems/x86_64.yaml`)
```yaml
architecture: x86_64
toolchain:
  compiler: gcc
  assembler: nasm
  linker: ld
  
build_targets:
  - name: "zealos-bios"
    bootloader: "legacy"
    output: "zealos-bios.iso"
  - name: "zealos-uefi"
    bootloader: "uefi"
    output: "zealos-uefi.iso"

optimization:
  level: "size"
  debug_symbols: true
  
memory_layout:
  kernel_base: "0x100000"
  stack_size: "64KB"
  heap_size: "1MB"
```

#### 3. Containerized Build Environment (`build/environment/`)

**Docker Build Environment**
```dockerfile
FROM ubuntu:22.04

# Install ZealOS build dependencies
RUN apt-get update && apt-get install -y \
    gcc nasm make git \
    qemu-system-x86 \
    xorriso genisoimage \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
COPY build/scripts/ /workspace/scripts/
RUN chmod +x /workspace/scripts/*

CMD ["./scripts/build-zealos.sh"]
```

#### 4. Build Automation (`build/scripts/`)

**Primary Build Script** (`build/scripts/build-zealos.sh`)
- Automated ZealOS compilation
- ISO generation for both BIOS and UEFI
- Build artifact validation
- Integration with WebAXP conventions

**Testing Script** (`build/scripts/test-zealos.sh`)
- QEMU-based boot testing
- Automated validation of built ISOs
- Performance benchmarking
- Integration test suite

#### 5. Distribution & Testing (`dist/`)

**VM Testing Environment**
```bash
# QEMU testing configuration
qemu-system-x86_64 \
  -cdrom dist/iso/zealos-uefi.iso \
  -m 64M \
  -cpu 486 \
  -display none \
  -serial stdio
```

**Artifact Management**
- `dist/iso/` - Built ZealOS ISO images
- `dist/packages/` - Distribution packages
- `dist/testing/` - Test results and logs

### Development Workflow

1. **Start Development Environment**
   ```bash
   docker-compose run --rm zealos-dev
   ```

2. **Build ZealOS**
   ```bash
   ./build/scripts/build-zealos.sh
   ```

3. **Test Built ISOs**
   ```bash
   ./build/scripts/test-zealos.sh
   ```

4. **Validate Integration**
   ```bash
   ./develop/scripts/validate-zealos-build.sh
   ```

### Success Criteria

#### Phase 1: Basic Integration (Week 1)
- [ ] ZealOS source integrated into WebAXP structure
- [ ] Containerized build environment working
- [ ] Basic ISO generation functional
- [ ] QEMU testing operational

#### Phase 2: Build System Maturity (Week 2)
- [ ] Automated build scripts complete
- [ ] Both BIOS and UEFI ISOs building
- [ ] Comprehensive testing suite
- [ ] Build artifact validation

#### Phase 3: WebAXP Integration (Week 3)
- [ ] Full WebAXP convention compliance
- [ ] Specification-driven configuration
- [ ] Integration with project tooling
- [ ] Documentation complete

#### Phase 4: Foundation Ready (Week 4)
- [ ] Stable, reproducible builds
- [ ] Comprehensive testing coverage
- [ ] Ready for FuncOS development
- [ ] Other teams can build upon this foundation

This ticket establishes the critical foundation that enables all subsequent FuncOS/Project Biometal development!
