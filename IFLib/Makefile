# IFLib - Intermediate Form Library
# WebAXP-compliant development workflow

.PHONY: help setup validate build test docs clean all

# Default target
help:
	@echo "IFLib Development Commands:"
	@echo "  setup     - Initialize development environment"
	@echo "  validate  - Validate API specifications"
	@echo "  build     - Build IFLib components"
	@echo "  test      - Run test suite"
	@echo "  docs      - Generate documentation"
	@echo "  clean     - Clean build artifacts"
	@echo "  all       - Run complete build pipeline"
	@echo ""
	@echo "Function Library Commands:"
	@echo "  validate-specs  - Validate function specifications"
	@echo "  optimize-funcs  - Generate optimized implementations"
	@echo "  test-browser    - Test browser integration"

# Environment setup
setup:
	@echo "Setting up IFLib development environment..."
	docker-compose --profile setup up --build
	@echo "IFLib environment ready!"

# API specification validation
validate:
	@echo "Validating IFLib API specifications..."
	../tools/scripts/validate-api-specs-docker.sh --spec-dir spec/api
	docker-compose --profile validate up

# Build IFLib components
build: validate
	@echo "Building IFLib components..."
	docker-compose --profile build up --build

# Run test suite
test: build
	@echo "Running IFLib test suite..."
	docker-compose --profile test up

# Generate documentation
docs:
	@echo "Generating IFLib documentation..."
	../tools/scripts/generate-api-docs.sh --spec-dir spec/api --format html
	docker-compose --profile docs up

# Clean build artifacts
clean:
	@echo "Cleaning IFLib build artifacts..."
	docker-compose down --volumes --remove-orphans
	docker system prune -f

# Complete build pipeline
all: setup validate build test docs
	@echo "IFLib build pipeline completed!"

# Function library commands
validate-specs:
	@echo "Validating function specifications..."
	docker-compose run --rm app iflib validate-specs

optimize-funcs:
	@echo "Generating optimized implementations..."
	docker-compose run --rm app iflib optimize --arch x86_64
	docker-compose run --rm app iflib optimize --arch arm64

test-browser:
	@echo "Testing browser integration..."
	docker-compose run --rm app iflib test-browser

# Development shortcuts
dev: setup
	@echo "Starting IFLib development environment..."
	docker-compose --profile dev up

dev-logs:
	docker-compose logs -f app

dev-shell:
	docker-compose exec app /bin/bash

# Specification-driven development
spec-first: validate docs
	@echo "Specification-first development ready!"

# Browser integration commands
webaxp-test:
	@echo "Testing WebAXP network API..."
	docker-compose run --rm app iflib webaxp-test

sandbox-test:
	@echo "Testing browser sandbox..."
	docker-compose run --rm app iflib sandbox-test

# Architecture optimization commands
optimize-x86:
	@echo "Optimizing for x86_64..."
	docker-compose run --rm app iflib optimize --arch x86_64 --features avx2,fma

optimize-arm:
	@echo "Optimizing for ARM64..."
	docker-compose run --rm app iflib optimize --arch arm64 --features neon

# Network hardware commands
network-hardware-test:
	@echo "Testing network hardware access..."
	docker-compose run --rm app iflib network-test
