**WebAXP (Web Application Experience Project)** — an API-first, specification-driven development ecosystem where `/spec` is the source of truth for all system components.

---

# 🧱 WebAXP: API-First Development Specification

## 🌐 Purpose

WebAXP creates an **API-first**, **specification-driven**, and **system-aware** development ecosystem. The core principle:

> **Everything starts with API. `/spec` contains the seed of all other subsystems.**

The system ensures that **any project** can be understood, built, tested, and deployed **entirely from its specifications**, requiring only:

* `git` for source retrieval
* `docker` (or compatible OCI runtime) for execution
* **API specifications** as the single source of truth

**No native dependencies. No manual documentation. No implementation guesswork.**

---

## ✅ Core Principles

### 1. **API-First Architecture**

> Everything starts with API. All subsystems are generated from `/spec` definitions.

* **API specifications** define interfaces, data structures, and behaviors
* **System specifications** define target platforms and implementation strategies
* **Documentation** is generated from API specs, not written manually
* **Build systems** are actualized from specifications, not custom scripts

### 2. **Specification-Driven Generation**

> `/spec` contains the seed of all other subsystems, including `/docs`.

* `/spec` → `/docs`: API documentation, system guides, implementation notes
* `/spec` → `/build`: Build instructions, toolchain requirements, target configurations
* `/spec` → `/app`: Application scaffolding, interface implementations
* `/spec` → `/dist`: Distribution packages, deployment configurations

### 3. **System-Aware Implementation**

> Specifications define "which ways it works on which systems" for target platforms.

* **Target-specific implementations** from unified API specifications
* **Hardware-aware optimizations** based on system capabilities
* **Platform abstractions** that maintain API consistency across targets
* **Graceful degradation** for unsupported features on specific systems

### 4. **Container-Only Execution**

> All build, test, and run steps execute **inside Docker containers**.

* No developer installs compilers, interpreters, or toolchains locally
* Use `docker-compose.yml` to define complete environment orchestration
* Specifications drive container configuration and service definitions

### 5. **Zero Local Configuration**

> Cloning and building should be a one-liner:

```sh
git clone https://your.repo/project && cd project && docker-compose up
```

* `docker-compose` is the universal interface
* Configuration via `.env` files and specification-driven defaults

---

## 📁 Directory Structure

```txt
project/
├── spec/                   # 🎯 SOURCE OF TRUTH - API & System Specifications
│   ├── api/               # API definitions (OpenAPI, GraphQL, gRPC, etc.)
│   │   ├── core.yaml      # Core system APIs
│   │   ├── hardware.yaml  # Hardware abstraction APIs
│   │   └── neural.yaml    # Neural interface APIs
│   ├── systems/           # Target system specifications
│   │   ├── x86_64.yaml    # x86_64 implementation details
│   │   ├── arm64.yaml     # ARM64 implementation details
│   │   └── embedded.yaml  # Embedded system constraints
│   ├── build.yaml         # Build requirements & strategies
│   ├── docs.yaml          # Documentation generation rules
│   └── PROJECT_SKETCH.md  # High-level project vision
├── app/                   # 🏗️ GENERATED - Application implementation
│   ├── environment/       # Development environment
│   └── src/              # Source code (scaffolded from specs)
├── build/                 # 🏗️ GENERATED - Build instructions
│   ├── environment/       # Build environment
│   └── targets/          # Target-specific build configs
├── dist/                  # 🏗️ GENERATED - Distribution packages
│   ├── environment/       # Testing environment
│   └── packages/         # Built artifacts
├── docs/                  # 📚 GENERATED - Documentation
│   ├── environment/       # Documentation environment
│   ├── api/              # API documentation (from spec/api/)
│   ├── systems/          # System-specific guides (from spec/systems/)
│   └── guides/           # Implementation guides
├── config/                # Runtime configuration
├── scripts/               # Automation scripts
├── docker-compose.yml     # Service orchestration
├── .env                   # Environment configuration
└── .webaxp/               # WebAXP metadata
    └── manifest.yml       # Project manifest
```

---

## 🐚 `run.sh`: Universal Wrapper Script

```bash
#!/bin/bash
# run.sh - WebAXP container launcher

CMD="${1:-devshell}"

docker build -t webaxp-project . || exit 1
docker run --rm -it \
  -v "$PWD":/workspace \
  -w /workspace \
  webaxp-project \
  ./scripts/"$CMD".sh
```

> Supports: `./run.sh build`, `./run.sh test`, `./run.sh devshell`

---

## 📜 `.webaxp/manifest.yml` (Optional)

Used by AI agents or WebAXP tooling to understand the project.

```yaml
name: ZealOS-Builder
description: Build system for ZealOS inside a VM-friendly container
roles:
  - build
  - test
  - interactive
requirements:
  os: "alpine|debian"
  ram: "4GB"
  disk: "10GB"
scripts:
  build: ./scripts/build.sh
  test: ./scripts/test.sh
  devshell: ./scripts/devshell.sh
```

---

## 🧪 Testing the Build System

Every WebAXP-compliant project must be tested by running:

```sh
./run.sh build
```

And the expected output should be **documented** in a CI-compatible way (stdout log, file hash, executable, etc).

---

## ♻️ Extending WebAXP Projects

To convert any existing open-source project:

1. Add a `Dockerfile` that reproduces its toolchain.
2. Add wrapper scripts in `scripts/`.
3. Define a top-level `run.sh`.
4. Add `.webaxp/manifest.yml` to describe it.
5. Test it cleanly on:

   * Linux (native Docker)
   * macOS (Docker Desktop)
   * WSL2 (optional)

---

