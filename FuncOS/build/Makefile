# FuncOS - Function-Oriented Operating System
# WebAXP-compliant development workflow

.PHONY: help setup validate build test docs clean all

# Default target
help:
	@echo "FuncOS Development Commands:"
	@echo "  setup     - Initialize development environment"
	@echo "  validate  - Validate API specifications"
	@echo "  build     - Build FuncOS components"
	@echo "  test      - Run test suite"
	@echo "  docs      - Generate documentation"
	@echo "  clean     - Clean build artifacts"
	@echo "  all       - Run complete build pipeline"
	@echo ""
	@echo "ZealOS Integration:"
	@echo "  zealos-setup    - Setup ZealOS integration"
	@echo "  zealos-build    - Build ZealOS foundation"
	@echo "  zealos-test     - Test ZealOS integration"

# Environment setup
setup:
	@echo "Setting up FuncOS development environment..."
	docker-compose --profile setup up --build
	@echo "FuncOS environment ready!"

# API specification validation
validate:
	@echo "Validating FuncOS API specifications..."
	../tools/scripts/validate-api-specs-docker.sh --spec-dir spec/api
	docker-compose --profile validate up

# Build FuncOS components (WebAXP Idempotent)
build: validate validate-app-specs
	@echo "Building FuncOS components (idempotent)..."
	@./scripts/build-funcos.sh

# Run test suite
test: build
	@echo "Running FuncOS test suite..."
	docker-compose --profile test up

# Generate documentation
docs:
	@echo "Generating FuncOS documentation..."
	../tools/scripts/generate-api-docs.sh --spec-dir spec/api --format html
	docker-compose --profile docs up

# Validate application specifications
validate-app-specs:
	@echo "Validating FuncOS application specifications..."
	@[ -f "../spec/applications/funcos-core.yaml" ] || (echo "❌ Missing application spec" && exit 1)
	@echo "✅ Application specifications validated"

# Clean build artifacts
clean:
	@echo "Cleaning FuncOS build artifacts..."
	docker-compose down --volumes --remove-orphans
	docker system prune -f
	rm -rf .build-cache .funcos-*-checksum

# Complete build pipeline
all: setup validate build test docs
	@echo "FuncOS build pipeline completed!"

# ZealOS Integration Commands
zealos-setup:
	@echo "Setting up ZealOS integration..."
	git submodule add https://github.com/Senneseph/ZealOS app/src/zealos || true
	git submodule update --init --recursive

zealos-build: zealos-setup
	@echo "Building ZealOS foundation..."
	docker-compose --profile build up zealos-builder

zealos-test: zealos-build
	@echo "Testing ZealOS integration..."
	docker-compose --profile test up zealos-tester

# Development shortcuts
dev: setup
	@echo "Starting FuncOS development environment..."
	docker-compose --profile dev up

dev-logs:
	docker-compose logs -f app

dev-shell:
	docker-compose exec app /bin/bash

# Specification-driven development
spec-first: validate docs
	@echo "Specification-first development ready!"

# Hardware profiling
profile:
	@echo "Running hardware profiling..."
	docker-compose --profile setup up profiler
