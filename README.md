# 🧠 Project Biometal - FuncOS Development

**Hardware-aware, function-oriented operating system with neural scheduling interface**

[![WebAXP Compliant](https://img.shields.io/badge/WebAXP-Compliant-green)](https://github.com/Senneseph/BiometalOS)
[![Specification-First](https://img.shields.io/badge/Approach-Specification--First-blue)](#philosophy)
[![Remote Agent Ready](https://img.shields.io/badge/Remote%20Agent-Ready-orange)](#remote-agent-support)

---

## 🎯 **Quick Start**

```bash
# Clone the repository
git clone https://github.com/Senneseph/BiometalOS.git
cd BiometalOS

# Choose a project to work on
cd FuncOS     # Function-oriented operating system
cd Nerv       # Minimal microkernel
cd Biometal   # Reporting & benchmarking layer
cd IFLib      # Intermediate Form Library

# Start development environment for chosen project
make setup    # Initialize development environment
make dev      # Start development environment
make build    # Build project components
make test     # Run test suite
```

## 🏗️ **Architecture Overview**

**Project Biometal** is a multi-project ecosystem implementing a complete function-oriented computing stack:

### **🔧 FuncOS** - Function-Oriented Operating System
- 🧮 **Functions are first-class citizens** - All execution is function-based
- ⚡ **Hardware-aware execution** - Automatic optimization for target architecture
- 🔍 **Service discovery** - Capability-based service management
- 🛡️ **Security-first** - Capability-based access control

### **🧠 Nerv** - Minimal Microkernel (Mach/Hurd Inspired)
- 🏗️ **Microkernel foundation** - Minimal, reliable kernel services
- 💬 **Message passing** - Efficient IPC mechanisms
- 🔒 **Process isolation** - Strong security boundaries
- 🔧 **Modular services** - User-space service architecture

### **📊 Biometal** - Reporting & Benchmarking Layer
- 🧠 **Neural data collection** - Function execution pattern recording
- 📈 **Performance analysis** - Real-time system metrics
- 🎯 **Optimization hints** - AI-driven performance suggestions
- 📋 **Benchmarking** - Comprehensive performance validation

### **📚 IFLib** - Intermediate Form Library
- 📝 **Function specifications** - Standardized function definitions
- 🏗️ **Architecture optimization** - Multi-architecture implementations
- 🌐 **Browser integration** - WebAXP network API
- 🔐 **Permission management** - Secure function execution

## 📁 **Repository Structure**

```
BiometalOS/
├── FuncOS/         # Function-oriented operating system
├── Nerv/           # Minimal microkernel (Mach/Hurd inspired)
├── Biometal/       # Reporting & benchmarking layer
├── IFLib/          # Intermediate Form Library
├── project/        # Project management and tickets
├── tools/          # Shared development utilities
└── spec/           # High-level project documentation
```

### **Project Structure**
Each project contains a complete WebAXP-compliant structure:
```
{Project}/
├── spec/           # API specifications and requirements
├── app/            # Application source code
├── build/          # Build system and toolchain
├── dist/           # Built artifacts and testing
├── docs/           # Documentation and guides
├── develop/        # Development tools and scripts
├── config/         # Project-specific configuration
├── shared/         # Docker configurations
├── Makefile        # Project build commands
├── docker-compose.yaml  # Development environment
└── .env            # Environment variables
```

## ⚙️ **Project Development**

### **Independent Project Development**
Each project can be developed independently:

```bash
# FuncOS - Function-oriented operating system
cd FuncOS
make setup          # Initialize development environment
make zealos-setup   # Setup ZealOS integration
make build          # Build FuncOS components
make test           # Run test suite

# Nerv - Minimal microkernel
cd Nerv
make setup          # Initialize development environment
make kernel-build   # Build microkernel
make kernel-test    # Test in QEMU
make ipc-test       # Test IPC mechanisms

# Biometal - Reporting & benchmarking
cd Biometal
make setup          # Initialize development environment
make collect-data   # Start data collection
make train-model    # Train ML models
make benchmark      # Run benchmarks

# IFLib - Intermediate Form Library
cd IFLib
make setup          # Initialize development environment
make validate-specs # Validate function specifications
make optimize-funcs # Generate optimized implementations
make webaxp-test    # Test browser integration
```

## 🛠️ **Shared Tools**

### **API Validation**
```bash
# Validate API specifications for any project
./tools/scripts/validate-api-specs-docker.sh --spec-dir FuncOS/spec/api
./tools/scripts/validate-api-specs-docker.sh --spec-dir Biometal/spec/api

# Generate documentation
./tools/scripts/generate-api-docs.sh --spec-dir IFLib/spec/api --format html
```

### **Cross-Project Development**
```bash
# Validate all projects
for project in FuncOS Nerv Biometal IFLib; do
  ./tools/scripts/validate-api-specs-docker.sh --spec-dir $project/spec/api
done

# Generate documentation for all projects
for project in FuncOS Nerv Biometal IFLib; do
  ./tools/scripts/generate-api-docs.sh --spec-dir $project/spec/api --output-dir docs/$project
done
```

## 🤖 **Remote Agent Support**

**Optimized for Augment Remote Agent** with:

- ✅ **Zero local dependencies** - Only requires Docker + Git
- ✅ **Idempotent builds** - Identical results every time
- ✅ **Parallel execution** - Multiple agents can work simultaneously
- ✅ **Hardware awareness** - Automatic optimization for agent environment
- ✅ **Specification validation** - Catch errors before execution
- ✅ **Clear status reporting** - Agent-friendly success/failure indicators

### **Agent Usage Examples**
```bash
# Agent can run these commands independently
docker-compose up profiler          # Detect optimal configuration
docker-compose up spec-validator    # Validate all specifications  
docker-compose up build             # Execute build pipeline
docker-compose up test              # Run test suite
```

## 📋 **Philosophy: API-First, Specification-Driven**

> **"Everything starts with API. `/spec` contains the seed of all other subsystems."**

### **🎯 Core Principle**
All subsystems are **generated** from API and system specifications:

- **📚 `/docs`** ← Generated from API specs (`spec/api/*.yaml`)
- **🏗️ `/build`** ← Generated from system specs (`spec/systems/*.yaml`)
- **💻 `/app`** ← Scaffolded from API definitions
- **📦 `/dist`** ← Built from generated configurations

### **🔄 Development Flow**
1. **Define APIs** in `spec/api/` (OpenAPI format)
2. **Define system implementations** in `spec/systems/` (per architecture)
3. **Generate everything else** from specifications
4. **Validate and build** using off-the-shelf components

### **Multi-Project Architecture**
```
BiometalOS/
├── FuncOS/                # Function-oriented operating system
│   ├── spec/api/         # Core, hardware, service discovery, security APIs
│   ├── app/              # FuncOS implementation
│   ├── build/            # ZealOS integration and build system
│   └── ...               # Complete WebAXP structure
├── Nerv/                 # Minimal microkernel
│   ├── spec/api/         # Kernel, IPC, memory management APIs
│   ├── app/              # Microkernel implementation
│   ├── build/            # Kernel build system
│   └── ...               # Complete WebAXP structure
├── Biometal/             # Reporting & benchmarking layer
│   ├── spec/api/         # Neural data collection APIs
│   ├── app/              # Data collection and ML implementation
│   ├── build/            # ML pipeline build system
│   └── ...               # Complete WebAXP structure
├── IFLib/                # Intermediate Form Library
│   ├── spec/api/         # Browser integration and function APIs
│   ├── app/              # Function library implementation
│   ├── build/            # Multi-architecture optimization
│   └── ...               # Complete WebAXP structure
├── project/              # Cross-project management and tickets
├── tools/                # Shared development utilities
└── spec/                 # High-level project documentation
```

## 🔌 **API Specifications**

**Project Biometal** distributes APIs across focused projects:

### **🔧 FuncOS APIs**
- **📋 Core API** (`FuncOS/spec/api/core.yaml`) - Function management, scheduler, memory
- **⚙️ Hardware API** (`FuncOS/spec/api/hardware.yaml`) - Hardware discovery, optimization, monitoring
- **🔍 Service Discovery API** (`FuncOS/spec/api/service-discovery.yaml`) - Service registration, capability discovery
- **🛡️ Security API** (`FuncOS/spec/api/security-capabilities.yaml`) - Capability management, access control

### **🧠 Biometal APIs**
- **🧠 Neural API** (`Biometal/spec/api/neural.yaml`) - Training data collection, optimization hints, ML integration

### **📚 IFLib APIs**
- **🌐 Browser Integration API** (`IFLib/spec/api/browser-integration.yaml`) - WebAXP network API, sandbox management

### **🧠 Nerv APIs** (To be created)
- **Kernel API** - Process management, memory management, exception handling
- **IPC API** - Message passing, port management, capability transfer
- **Memory API** - Virtual memory, shared memory, protection

> **This is "MCP on steroids"** - supplying function inputs/outputs to neural nets for training on hardware requests at the function level.

## 🏗️ **System Implementations**

Each target architecture defines **how** the APIs work on that system:

- **`spec/systems/x86_64.yaml`**: Intel/AMD implementation details
- **`spec/systems/arm64.yaml`**: ARM64 implementation details

These specs define instruction sets, performance characteristics, optimization strategies, and platform-specific features.

## 🔧 **Development Workflow**

### **1. Choose Your Project**
```bash
# Work on the function-oriented operating system
cd FuncOS

# Work on the microkernel foundation
cd Nerv

# Work on neural data collection and analysis
cd Biometal

# Work on function specifications and browser integration
cd IFLib
```

### **2. Project Setup**
```bash
# Initialize development environment
make setup

# Validate API specifications
make validate

# Generate documentation
make docs
```

### **3. Development**
```bash
# Start development environment
make dev

# View logs
make dev-logs

# Access development shell
make dev-shell
```

### **4. Building & Testing**
```bash
# Build project components
make build

# Run test suite
make test

# Clean build artifacts
make clean
```

### **5. Project-Specific Commands**
```bash
# FuncOS: ZealOS integration
make zealos-setup && make zealos-build

# Nerv: Kernel development
make kernel-build && make kernel-test

# Biometal: Data collection and ML
make collect-data && make train-model

# IFLib: Function optimization
make validate-specs && make optimize-funcs
```

## 🎯 **Key Features**

- 🏗️ **Multi-Project Architecture** - Focused, independent development
- 🔧 **WebAXP Compliant** - Standardized development across all projects
- 📋 **Specification-Driven** - API-first development workflow
- 🛠️ **Shared Tooling** - Common validation and documentation tools
- ⚡ **Parallel Development** - Teams can work independently
- 🔍 **Independent Environments** - Each project is self-contained
- 🤖 **Agent-Friendly** - Optimized for AI development assistants

## 🚀 **Next Steps**

1. **Choose a project** based on your interests:
   - **FuncOS** for operating system development
   - **Nerv** for microkernel architecture
   - **Biometal** for data analysis and ML
   - **IFLib** for function specifications and browser integration

2. **Read project documentation** in each project's README.md

3. **Start development** with `cd {Project} && make setup && make dev`

4. **Explore high-level concepts** in `spec/` directory

---

**Project Biometal** - Where specifications become reality through intelligent actualization.
