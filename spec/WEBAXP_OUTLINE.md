**Preliminary Guide for WebAXP (Web Application Experience Project)** — an idempotent build system spec — written as a reference document for anyone tasked with onboarding a project into the WebAXP ecosystem.

---

# 🧱 WebAXP Preliminary Build System Specification

## 🌐 Purpose

WebAXP aims to create an **idempotent**, **environment-agnostic**, and **developer-friendly** build system. It ensures that **any project** can be cloned, built, tested, and developed **entirely inside a container**, requiring only:

* `git` for source retrieval
* `docker` (or compatible OCI runtime) for execution

**No native dependencies. No setup instructions. No excuses.**

---

## ✅ Core Principles

### 1. **Idempotent**

> The build process must produce the same result, given the same inputs, every time, from scratch.

* Use **locked dependency versions** (e.g., `requirements.txt`, `package-lock.json`, pinned Git SHAs)
* Rebuild images and artifacts *from zero* on each CI run or local build
* Avoid dependence on non-versioned global state (e.g., `$HOME/.cargo`, `/usr/bin/python`)

### 2. **Container-Only Execution**

> All build, test, and run steps must execute **inside a Docker container**.

* No developer should install compilers, interpreters, or toolchains locally
* Use `Dockerfile` or `docker-compose.yml` to define the complete environment
* Provide **entrypoint scripts** that run inside the container to perform useful tasks (e.g., `./scripts/build.sh`, `./scripts/test.sh`)

### 3. **Zero Local Configuration**

> Cloning and building should be a one-liner:

```sh
git clone https://your.repo/project && cd project && ./run.sh
```

* `run.sh` is a universal entrypoint wrapper (see below)
* No `.env`, `.bashrc`, or system dependencies required

---

## 📁 Directory Structure

```txt
project/
├── Dockerfile             # Build environment
├── docker-compose.yml     # Optional: multi-container orchestration
├── run.sh                 # Universal entrypoint (recommended)
├── scripts/               # Build/test scripts (inside container)
│   ├── build.sh
│   ├── test.sh
│   └── devshell.sh
├── .webaxp/               # Metadata/config for the agent
│   └── manifest.yml       # Describes tasks, requirements, roles
└── src/                   # Source code
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

