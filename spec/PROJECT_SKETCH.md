**Project Biometal OS Specification Document**

---

**Codename:** BiometalOS
**Reference Baseline:** ZealOS ([https://github.com/Senneseph/ZealOS](https://github.com/Senneseph/ZealOS))
**Version:** 0.1 (Spec Draft)

---

### **1. Executive Summary**

BiometalOS is a general-purpose, modular, introspective operating system designed for high-performance computation, predictable scheduling, and real-time data introspection. Inspired by ZealOS for its minimalist, retro-inspired kernel and toolchain model, BiometalOS extends the idea into a function-oriented microkernel where all executions are observable, and AI-driven schedulers can manipulate execution timelines like a digital nervous system.

The long-term goal is to create a neural-symbiotic OS with highly introspectable kernel-space activity, capable of training and cooperating with machine learning systems for application acceleration, autonomous robotics, and deep function profiling.

---

### **2. Core Tenets**

1. **Function-Oriented Kernel:** Execution is structured around schedulable functions rather than monolithic processes.
2. **Observable Everything:** Every system call, memory access, function input/output, and IO event is loggable, inspectable, and subscribable.
3. **AI-Native Scheduling:** A neural interface can receive execution traces and request scheduling, memory prioritization, or IO control just like a user process.
4. **Portable Modular HAL:** Hardware abstraction is expressed as dataflow and DSP-like transforms, not just interface contracts.
5. **WebAXP-Compliant Builds:** All builds must conform to idempotent, Docker-containerized builds for consistent environments.

---

### **3. Initial Platform Goals**

* **CPU Architectures:**

  * x86\_64 (primary dev target)
  * ARM64 (Apple M1/M2+, Raspberry Pi 4/5, Ampere Altra)
* **Bootloader Compatibility:**

  * GRUB2, UEFI, or custom flat binary boot with minimal stage-1
* **Memory Model:**

  * Flat physical memory model at early boot
  * Transition to virtual memory with identity mapping for kernel space

---

### **4. Kernel Architecture**

**4.1 Microkernel Core Components:**

* `Scheduler`: Deadline-aware, cooperative + preemptive hybrid
* `FunctionManager`: Registers, maps, and profiles all running kernel/user functions
* `MemoryManager`: Page-table aware, introspective memory tagging system
* `IOBus`: Abstracted device IO and DMA channels with subscription API
* `IPC`: Minimal, tagged message-passing between isolated sandboxes

**4.2 Neural Interface:**

* Special system process that:

  * Subscribes to function executions and memory profiles
  * Sends optimization hints (frequency, cache locality, priority)
  * Can register functions just like any user-space program

---

### **5. Filesystem / Storage Model**

* Minimalist read/write VFS
* `metaFS`: All functions, I/O, devices, and scheduling queues are mounted as pseudo-files
* Support for:

  * ext4 / btrfs (import)
  * `biofs`: Custom metadata-optimized journaling FS for kernel-native telemetry

---

### **6. Language and Toolchain**

* **Primary Language:**

  * Zig (for kernel, toolchain, and runtime systems)
  * Assembly for boot/init stages
  * Rust/C for compatibility modules
* **Scripting Layer:**

  * Perl 5 (lightweight glue)
  * Zig WASM runtime
  * Forth (optional for BIOS-style control)

---

### **7. WebAXP Integration**

* All core modules, build tools, drivers, and packages are contained in reproducible Docker environments.
* All userland packages must provide a `WebAXP.yaml` descriptor.
* Standardized interfaces for debugging, testing, and simulating hardware from within containers.

---

### **8. GUI/Interface Design**

* Initial text-mode terminal with rich ANSI control
* BloomUI compatibility via framebuffer or PWA-hosted frontend
* Console-first experience with optional graphical shell

---

### **9. Security/Access Model**

* Kernel-enforced execution rings for function access
* Hardware fuse states (if present) to validate boot trust
* All IPC is filtered via tagging and trust level enforcement

---

### **10. Roadmap (Early Milestones)**

1. Bootloader + Flat memory init + Serial console (stage 0)
2. Function loader + basic scheduler (stage 1)
3. Memory tags + observable execution logs (stage 2)
4. Neural interface stub with fake hints (stage 3)
5. Kernel build + runtime in Docker (stage 4)
6. Userland ABI + scripting glue (stage 5)
7. Basic IPC + metaFS (stage 6)

---

### **Appendix A: ZealOS Inspirations**

* Retro computing aesthetic (text-mode friendliness)
* Tightly-coupled editor/OS/dev environment
* Command-driven development model

### **Appendix B: System Name Definitions**

* **Biometal:** Core kernel and scheduler
* **NeuroCore:** Neural runtime manager
* **BloomShell:** Userland command interface
* **biofs:** Kernel-aware journaling filesystem
* **WebAXP:** Project standard for build environment encapsulation
