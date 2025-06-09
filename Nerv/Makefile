# Nerv - Minimal Microkernel (Mach/Hurd Inspired)
# WebAXP-compliant development workflow

.PHONY: help setup validate build test docs clean all

# Default target
help:
	@echo "Nerv Microkernel Development Commands:"
	@echo "  setup     - Initialize development environment"
	@echo "  validate  - Validate API specifications"
	@echo "  build     - Build Nerv microkernel"
	@echo "  test      - Run test suite"
	@echo "  docs      - Generate documentation"
	@echo "  clean     - Clean build artifacts"
	@echo "  all       - Run complete build pipeline"
	@echo ""
	@echo "Microkernel Commands:"
	@echo "  kernel-build    - Build kernel only"
	@echo "  kernel-test     - Test kernel in QEMU"
	@echo "  ipc-test        - Test IPC mechanisms"

# Environment setup
setup:
	@echo "Setting up Nerv development environment..."
	docker-compose --profile setup up --build
	@echo "Nerv environment ready!"

# API specification validation
validate:
	@echo "Validating Nerv API specifications..."
	../tools/scripts/validate-api-specs-docker.sh --spec-dir spec/api
	docker-compose --profile validate up

# Build Nerv microkernel
build: validate
	@echo "Building Nerv microkernel..."
	docker-compose --profile build up --build

# Run test suite
test: build
	@echo "Running Nerv test suite..."
	docker-compose --profile test up

# Generate documentation
docs:
	@echo "Generating Nerv documentation..."
	../tools/scripts/generate-api-docs.sh --spec-dir spec/api --format html
	docker-compose --profile docs up

# Clean build artifacts
clean:
	@echo "Cleaning Nerv build artifacts..."
	docker-compose down --volumes --remove-orphans
	docker system prune -f

# Complete build pipeline
all: setup validate build test docs
	@echo "Nerv build pipeline completed!"

# Microkernel-specific commands
kernel-build:
	@echo "Building Nerv kernel..."
	docker-compose run --rm build make kernel

kernel-test: kernel-build
	@echo "Testing Nerv kernel in QEMU..."
	docker-compose run --rm dist qemu-system-x86_64 -kernel dist/nerv-kernel.elf -m 32M -display none -serial stdio

ipc-test: kernel-build
	@echo "Testing IPC mechanisms..."
	docker-compose run --rm test make ipc-tests

# Development shortcuts
dev: setup
	@echo "Starting Nerv development environment..."
	docker-compose --profile dev up

dev-logs:
	docker-compose logs -f app

dev-shell:
	docker-compose exec app /bin/bash

# Specification-driven development
spec-first: validate docs
	@echo "Specification-first development ready!"

# Mach/Hurd study
study-mach:
	@echo "Studying Mach microkernel architecture..."
	docker-compose run --rm docs make mach-study

study-hurd:
	@echo "Studying Hurd system design..."
	docker-compose run --rm docs make hurd-study
