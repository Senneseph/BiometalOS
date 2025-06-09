#!/bin/bash

# Biometal - Docker-based API Specification Validation Script
# Validates all OpenAPI specifications using Docker containers

set -euo pipefail

# Configuration
SPEC_DIR="${SPEC_DIR:-./spec/api}"
OUTPUT_DIR="${OUTPUT_DIR:-./build/validation}"
VERBOSE="${VERBOSE:-false}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check Docker availability
check_docker() {
    if ! command -v docker &> /dev/null; then
        log_error "Docker is required but not installed"
        exit 1
    fi
    
    if ! docker info &> /dev/null; then
        log_error "Docker daemon is not running"
        exit 1
    fi
    
    log_success "Docker is available"
}

# Basic YAML syntax validation using Python
validate_yaml_syntax() {
    local spec_file="$1"
    local spec_name=$(basename "$spec_file" .yaml)
    
    log_info "Validating YAML syntax for $spec_name..."
    
    # Use Python to validate YAML syntax
    docker run --rm -v "$(pwd):/workspace" python:3.9-slim bash -c "
pip install PyYAML > /dev/null 2>&1 && python3 -c \"
import yaml
import sys
try:
    with open('/workspace/$spec_file', 'r') as f:
        yaml.safe_load(f)
    print('✓ Valid YAML syntax')
    sys.exit(0)
except yaml.YAMLError as e:
    print(f'✗ YAML syntax error: {e}')
    sys.exit(1)
except Exception as e:
    print(f'✗ Error reading file: {e}')
    sys.exit(1)
\"
"
    
    if [ $? -eq 0 ]; then
        log_success "$spec_name: YAML syntax is valid"
        return 0
    else
        log_error "$spec_name: YAML syntax validation failed"
        return 1
    fi
}

# OpenAPI validation using openapi-generator Docker image
validate_openapi_schema() {
    local spec_file="$1"
    local spec_name=$(basename "$spec_file" .yaml)

    log_info "Validating OpenAPI schema for $spec_name..."

    # Create output directory for this spec
    mkdir -p "$OUTPUT_DIR/$spec_name"

    # Use openapi-generator-cli Docker image for validation (supports OpenAPI 3.0)
    if docker run --rm -v "$(pwd):/workspace" \
        openapitools/openapi-generator-cli:latest validate \
        -i "/workspace/$spec_file" > "$OUTPUT_DIR/$spec_name/validation.log" 2>&1; then
        log_success "$spec_name: OpenAPI schema validation passed"
        return 0
    else
        log_error "$spec_name: OpenAPI schema validation failed"
        if [ "$VERBOSE" = "true" ]; then
            cat "$OUTPUT_DIR/$spec_name/validation.log"
        fi
        return 1
    fi
}

# Check for common API design issues
check_api_design() {
    local spec_file="$1"
    local spec_name=$(basename "$spec_file" .yaml)
    
    log_info "Checking API design for $spec_name..."
    
    local issues=0
    
    # Use Python to check API design patterns
    docker run --rm -v "$(pwd):/workspace" python:3.9-slim bash -c "
pip install PyYAML > /dev/null 2>&1 && python3 -c \"
import yaml
import re
import sys

def check_naming_conventions(data, spec_name):
    issues = 0
    
    # Check path naming (should use kebab-case)
    if 'paths' in data:
        for path in data['paths'].keys():
            if re.search(r'[A-Z_]', path):
                print(f'⚠ {spec_name}: Path \"{path}\" should use kebab-case')
                issues += 1
    
    # Check schema naming (should use PascalCase)
    if 'components' in data and 'schemas' in data['components']:
        for schema_name in data['components']['schemas'].keys():
            if re.search(r'^[a-z]|[_-]', schema_name):
                print(f'⚠ {spec_name}: Schema \"{schema_name}\" should use PascalCase')
                issues += 1
    
    return issues

def check_required_fields(data, spec_name):
    issues = 0
    
    # Check if info section has required fields
    if 'info' not in data:
        print(f'✗ {spec_name}: Missing info section')
        issues += 1
    else:
        info = data['info']
        required_fields = ['title', 'version', 'description']
        for field in required_fields:
            if field not in info:
                print(f'✗ {spec_name}: Missing required info.{field}')
                issues += 1
    
    return issues

try:
    with open('/workspace/$spec_file', 'r') as f:
        data = yaml.safe_load(f)
    
    total_issues = 0
    total_issues += check_naming_conventions(data, '$spec_name')
    total_issues += check_required_fields(data, '$spec_name')
    
    if total_issues == 0:
        print(f'✓ {\"$spec_name\"}: API design check passed')
    
    sys.exit(total_issues)
    
except Exception as e:
    print(f'✗ Error checking API design: {e}')
    sys.exit(1)
\"
"
    
    local exit_code=$?
    if [ $exit_code -eq 0 ]; then
        log_success "$spec_name: API design check passed"
    else
        log_warning "$spec_name: Found $exit_code API design issues"
        issues=$((issues + exit_code))
    fi
    
    return $issues
}

# Validate individual OpenAPI spec
validate_spec() {
    local spec_file="$1"
    local spec_name=$(basename "$spec_file" .yaml)
    
    log_info "Validating $spec_name..."
    
    local validation_errors=0
    
    # YAML syntax validation
    if ! validate_yaml_syntax "$spec_file"; then
        ((validation_errors++))
    fi
    
    # OpenAPI schema validation
    if ! validate_openapi_schema "$spec_file"; then
        ((validation_errors++))
    fi
    
    # API design check
    if ! check_api_design "$spec_file"; then
        # Design issues are warnings, not errors
        log_warning "$spec_name: API design issues found (non-blocking)"
    fi
    
    return $validation_errors
}

# Generate validation report
generate_report() {
    log_info "Generating validation report..."
    
    local report_file="$OUTPUT_DIR/validation-report.json"
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    
    cat > "$report_file" << EOF
{
  "validation_timestamp": "$timestamp",
  "spec_directory": "$SPEC_DIR",
  "validation_method": "docker",
  "validated_specs": [
EOF
    
    local first=true
    for spec_file in "$SPEC_DIR"/*.yaml; do
        if [ -f "$spec_file" ]; then
            local spec_name=$(basename "$spec_file" .yaml)
            
            if [ "$first" = true ]; then
                first=false
            else
                echo "," >> "$report_file"
            fi
            
            cat >> "$report_file" << EOF
    {
      "name": "$spec_name",
      "file": "$spec_file",
      "status": "validated"
    }
EOF
        fi
    done
    
    cat >> "$report_file" << EOF
  ],
  "validation_tools": {
    "docker": "available",
    "openapi_generator": "docker:openapitools/openapi-generator-cli:latest",
    "python_yaml": "docker:python:3.9-slim"
  }
}
EOF
    
    log_success "Validation report generated: $report_file"
}

# Main execution
main() {
    log_info "Starting Docker-based API specification validation..."
    log_info "Spec directory: $SPEC_DIR"
    log_info "Output directory: $OUTPUT_DIR"
    
    # Create output directory
    mkdir -p "$OUTPUT_DIR"
    
    # Check Docker availability
    check_docker
    
    # Validate each specification
    local validation_errors=0
    for spec_file in "$SPEC_DIR"/*.yaml; do
        if [ -f "$spec_file" ]; then
            if ! validate_spec "$spec_file"; then
                ((validation_errors++))
            fi
        fi
    done
    
    # Generate report
    generate_report
    
    # Final status
    if [ $validation_errors -eq 0 ]; then
        log_success "All API specifications validated successfully!"
        exit 0
    else
        log_error "Validation completed with $validation_errors errors"
        exit 1
    fi
}

# Handle script arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -d|--spec-dir)
            SPEC_DIR="$2"
            shift 2
            ;;
        -o|--output-dir)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo "Options:"
            echo "  -v, --verbose       Enable verbose output"
            echo "  -d, --spec-dir      Specification directory (default: ./spec/api)"
            echo "  -o, --output-dir    Output directory (default: ./build/validation)"
            echo "  -h, --help          Show this help message"
            exit 0
            ;;
        *)
            log_error "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Run main function
main
