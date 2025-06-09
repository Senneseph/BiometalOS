# Biometal - Reporting & Benchmarking Layer
# WebAXP-compliant development workflow

.PHONY: help setup validate build test docs clean all

# Default target
help:
	@echo "Biometal Development Commands:"
	@echo "  setup     - Initialize development environment"
	@echo "  validate  - Validate API specifications"
	@echo "  build     - Build Biometal components"
	@echo "  test      - Run test suite"
	@echo "  docs      - Generate documentation"
	@echo "  clean     - Clean build artifacts"
	@echo "  all       - Run complete build pipeline"
	@echo ""
	@echo "Data Collection Commands:"
	@echo "  collect-data    - Start data collection"
	@echo "  analyze-data    - Run data analysis"
	@echo "  generate-report - Generate performance reports"

# Environment setup
setup:
	@echo "Setting up Biometal development environment..."
	docker-compose --profile setup up --build
	@echo "Biometal environment ready!"

# API specification validation
validate:
	@echo "Validating Biometal API specifications..."
	../tools/scripts/validate-api-specs-docker.sh --spec-dir spec/api
	docker-compose --profile validate up

# Build Biometal components
build: validate
	@echo "Building Biometal components..."
	docker-compose --profile build up --build

# Run test suite
test: build
	@echo "Running Biometal test suite..."
	docker-compose --profile test up

# Generate documentation
docs:
	@echo "Generating Biometal documentation..."
	../tools/scripts/generate-api-docs.sh --spec-dir spec/api --format html
	docker-compose --profile docs up

# Clean build artifacts
clean:
	@echo "Cleaning Biometal build artifacts..."
	docker-compose down --volumes --remove-orphans
	docker system prune -f

# Complete build pipeline
all: setup validate build test docs
	@echo "Biometal build pipeline completed!"

# Data collection commands
collect-data:
	@echo "Starting neural data collection..."
	docker-compose run --rm app python -m biometal.collector

analyze-data:
	@echo "Running data analysis..."
	docker-compose run --rm app python -m biometal.analyzer

generate-report:
	@echo "Generating performance reports..."
	docker-compose run --rm app python -m biometal.reporter

# Development shortcuts
dev: setup
	@echo "Starting Biometal development environment..."
	docker-compose --profile dev up

dev-logs:
	docker-compose logs -f app

dev-shell:
	docker-compose exec app /bin/bash

# Specification-driven development
spec-first: validate docs
	@echo "Specification-first development ready!"

# Machine learning commands
train-model:
	@echo "Training optimization models..."
	docker-compose run --rm app python -m biometal.ml.train

evaluate-model:
	@echo "Evaluating model performance..."
	docker-compose run --rm app python -m biometal.ml.evaluate

# Benchmarking commands
benchmark:
	@echo "Running system benchmarks..."
	docker-compose run --rm app python -m biometal.benchmark

profile-performance:
	@echo "Profiling system performance..."
	docker-compose run --rm profiler
