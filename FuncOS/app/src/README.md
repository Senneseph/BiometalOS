# FuncOS Application Source

This directory contains the source code for Project Biometal's FuncOS implementation.

## Structure

```
src/
├── kernel/           # FuncOS kernel implementation
│   ├── scheduler/    # Function scheduler
│   ├── memory/       # Memory management
│   ├── io/          # I/O bus and device management
│   └── neural/      # Neural interface stub
├── api/             # Generated API implementations
├── userland/        # Userland components
│   ├── shell/       # BloomShell implementation
│   └── wasm/        # WebAssembly runtime
└── tests/           # Unit and integration tests
```

## Development

The source code is generated from API specifications in `/spec/api/` and follows the API-first development paradigm.

To build:
```bash
# From development shell
build

# Or directly
./scripts/build.sh
```

## API-First Development

All implementations are driven by the OpenAPI specifications:
- `spec/api/core.yaml` → Core system APIs
- `spec/api/hardware.yaml` → Hardware abstraction APIs
- `spec/api/neural.yaml` → Neural interface APIs

Code generation creates implementation stubs that are then filled with actual functionality.