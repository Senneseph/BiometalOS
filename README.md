# 🧠 Project Biometal - FuncOS Development

**Hardware-aware, function-oriented operating system with neural scheduling interface**

[![WebAXP Compliant](https://img.shields.io/badge/WebAXP-Compliant-green)](https://github.com/Senneseph/BiometalOS)
[![Specification-First](https://img.shields.io/badge/Approach-Specification--First-blue)](#philosophy)
[![Remote Agent Ready](https://img.shields.io/badge/Remote%20Agent-Ready-orange)](#remote-agent-support)

---

## 🎯 **Quick Start**

```bash
# Clone and start development environment
git clone https://github.com/Senneseph/BiometalOS.git
cd BiometalOS

# Start all services (hardware profiling, validation, development)
docker-compose up -d

# Or start specific services
docker-compose up profiler spec-validator  # Setup and validation
docker-compose up app                       # Development environment
docker-compose up build                     # Build pipeline
docker-compose up test                      # Testing suite
```

## 🏗️ **Architecture Overview**

**Project Biometal** implements **FuncOS** - a function-oriented operating system where:

- 🧮 **Functions are first-class citizens** - All execution is function-based
- 🔍 **Everything is observable** - Complete introspection of system behavior  
- 🧠 **Neural scheduling interface** - AI can optimize hardware utilization
- ⚡ **Hardware-aware execution** - Automatic optimization for target architecture
- 📋 **Specification-driven** - Build from specs, not custom implementations

## 🐳 **Service Architecture**

| Service | Purpose | Dependencies |
|---------|---------|--------------|
| `profiler` | Hardware detection & optimization | Host hardware access |
| `spec-validator` | Specification validation | None |
| `app` | Development environment | `spec-validator` |
| `build` | Build pipeline actualizer | `spec-validator`, `profiler` |
| `dist` | Distribution & VM testing | `build` |
| `docs` | Living documentation | None |

## ⚙️ **Configuration**

### **Environment Variables** (`.env`)
```bash
# Core Configuration
TARGET_ARCH=x86_64          # x86_64, arm64, auto
BUILD_MODE=debug            # debug, release, profile
FUNCOS_MODE=development     # development, production, testing

# Hardware Optimization
HARDWARE_PROFILE=detect     # detect, desktop, server, embedded
PARALLEL_JOBS=4             # Build parallelization
NEURAL_INTERFACE=stub       # stub, mock, real, disabled

# Development
DEV_PORT=8080              # Development server port
DEBUG_PORT=2345            # Debugger port
LOG_LEVEL=info             # debug, info, warn, error
```

### **Custom Configuration**
```bash
# Use custom environment
docker-compose --env-file production.env up

# Override specific settings
TARGET_ARCH=arm64 BUILD_MODE=release docker-compose up build
```

## 🎛️ **Service Profiles**

```bash
# Development workflow
docker-compose --profile dev up -d

# Full build pipeline  
docker-compose --profile build up

# Testing and validation
docker-compose --profile test up

# Complete environment
docker-compose --profile all up -d
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

## 📋 **Philosophy: Specification-First**

> **"Perfect specifications enable trivial builds from off-the-shelf components"**

1. **Define specifications** in `spec/` and `config/` directories
2. **Validate specifications** before any build attempts
3. **Use off-the-shelf components** wherever possible
4. **Build only what's truly custom** to the project

### **Directory Structure**
```
BiometalOS/
├── spec/                   # Specifications (WHAT to build)
│   ├── build.yaml         # Build requirements & targets
│   ├── PROJECT_SKETCH.md  # High-level project description
│   ├── FuncOS_OUTLINE.md  # Core OS concepts
│   └── WEBAXP_OUTLINE.md  # Build system specification
├── config/                # Configuration (HOW to build)
│   └── services.yaml      # Service runtime configuration
├── app/                   # Application source & environment
├── build/                 # Build instructions & environment  
├── dist/                  # Distribution & testing environment
├── docs/                  # Documentation & environment
└── scripts/               # Automation scripts
```

## 🔧 **Development Workflow**

### **1. Hardware Profiling**
```bash
# Detect optimal configuration for your hardware
docker-compose up profiler

# View generated profile
cat config/hardware-profile.yaml
```

### **2. Specification Validation**
```bash
# Validate all specifications
docker-compose up spec-validator

# View validation report
cat config/validation-report.json
```

### **3. Development**
```bash
# Start development environment with hot reload
docker-compose up app

# Access development server
open http://localhost:8080
```

### **4. Building**
```bash
# Execute full build pipeline
docker-compose up build

# Check build artifacts
ls -la dist/
```

### **5. Testing**
```bash
# Run in virtualized environment
docker-compose up dist

# View test results
docker-compose logs dist
```

## 🎯 **Key Features**

- 🏗️ **WebAXP Compliant** - Standardized, containerized development
- 🔍 **Hardware Profiling** - Automatic optimization detection
- 📋 **Specification Validation** - Catch errors early
- ⚡ **Parallel Builds** - Multi-architecture support
- 🧪 **VM Testing** - Automated testing in QEMU
- 📚 **Living Documentation** - Auto-generated from specifications
- 🤖 **Agent-Friendly** - Optimized for AI development assistants

## 🚀 **Next Steps**

1. **Explore the specifications** in `spec/` directory
2. **Run hardware profiling** to optimize for your system
3. **Start development environment** with `docker-compose up app`
4. **Read the FuncOS concepts** in `spec/FuncOS_OUTLINE.md`

---

**Project Biometal** - Where specifications become reality through intelligent actualization.
