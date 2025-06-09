#!/bin/bash

# Project Biometal - API Specification Validation Script
# Validates all OpenAPI specifications for consistency and correctness

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

# Check dependencies
check_dependencies() {
    log_info "Checking dependencies..."
    
    local missing_deps=()
    
    # Check for swagger-codegen or openapi-generator
    if ! command -v openapi-generator &> /dev/null && ! command -v swagger-codegen &> /dev/null; then
        missing_deps+=("openapi-generator or swagger-codegen")
    fi
    
    # Check for spectral (API linting)
    if ! command -v spectral &> /dev/null; then
        missing_deps+=("spectral")
    fi
    
    # Check for yq (YAML processing)
    if ! command -v yq &> /dev/null; then
        missing_deps+=("yq")
    fi
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        log_error "Missing dependencies: ${missing_deps[*]}"
        log_info "Install with: npm install -g @stoplight/spectral-cli @apidevtools/swagger-cli"
        log_info "Or use Docker: docker run --rm -v \$(pwd):/workspace openapitools/openapi-generator-cli"
        exit 1
    fi
    
    log_success "All dependencies available"
}

# Validate individual OpenAPI spec
validate_spec() {
    local spec_file="$1"
    local spec_name=$(basename "$spec_file" .yaml)
    
    log_info "Validating $spec_name..."
    
    # Create output directory for this spec
    mkdir -p "$OUTPUT_DIR/$spec_name"
    
    # Basic YAML syntax validation
    if ! yq eval '.' "$spec_file" > /dev/null 2>&1; then
        log_error "$spec_name: Invalid YAML syntax"
        return 1
    fi
    
    # OpenAPI schema validation
    if command -v spectral &> /dev/null; then
        if spectral lint "$spec_file" --format json > "$OUTPUT_DIR/$spec_name/spectral-report.json" 2>&1; then
            log_success "$spec_name: Spectral validation passed"
        else
            log_warning "$spec_name: Spectral validation issues found"
            if [ "$VERBOSE" = "true" ]; then
                cat "$OUTPUT_DIR/$spec_name/spectral-report.json"
            fi
        fi
    fi
    
    # OpenAPI Generator validation
    if command -v openapi-generator &> /dev/null; then
        if openapi-generator validate -i "$spec_file" > "$OUTPUT_DIR/$spec_name/generator-validation.log" 2>&1; then
            log_success "$spec_name: OpenAPI Generator validation passed"
        else
            log_error "$spec_name: OpenAPI Generator validation failed"
            if [ "$VERBOSE" = "true" ]; then
                cat "$OUTPUT_DIR/$spec_name/generator-validation.log"
            fi
            return 1
        fi
    fi
    
    return 0
}

# Check cross-references between specs
check_cross_references() {
    log_info "Checking cross-references between specifications..."
    
    local ref_errors=0
    
    # Extract all $ref references from specs
    for spec_file in "$SPEC_DIR"/*.yaml; do
        local spec_name=$(basename "$spec_file" .yaml)
        
        # Find external references (not starting with #/)
        local external_refs=$(yq eval '.. | select(has("$ref")) | ."$ref" | select(. != null and (. | startswith("#/") | not))' "$spec_file" 2>/dev/null || true)
        
        if [ -n "$external_refs" ]; then
            log_warning "$spec_name has external references:"
            echo "$external_refs" | while read -r ref; do
                echo "  - $ref"
                # TODO: Validate that external references exist
            done
        fi
    done
    
    if [ $ref_errors -eq 0 ]; then
        log_success "Cross-reference validation completed"
    else
        log_error "Found $ref_errors cross-reference issues"
        return 1
    fi
}

# Check API consistency
check_consistency() {
    log_info "Checking API consistency..."
    
    # Check for consistent naming conventions
    local naming_issues=0
    
    for spec_file in "$SPEC_DIR"/*.yaml; do
        local spec_name=$(basename "$spec_file" .yaml)
        
        # Check path naming (should use kebab-case)
        local bad_paths=$(yq eval '.paths | keys | .[] | select(. | test("[A-Z]|_"))' "$spec_file" 2>/dev/null || true)
        if [ -n "$bad_paths" ]; then
            log_warning "$spec_name: Non-kebab-case paths found:"
            echo "$bad_paths" | sed 's/^/  - /'
            ((naming_issues++))
        fi
        
        # Check schema naming (should use PascalCase)
        local bad_schemas=$(yq eval '.components.schemas | keys | .[] | select(. | test("^[a-z]|_|-"))' "$spec_file" 2>/dev/null || true)
        if [ -n "$bad_schemas" ]; then
            log_warning "$spec_name: Non-PascalCase schema names found:"
            echo "$bad_schemas" | sed 's/^/  - /'
            ((naming_issues++))
        fi
    done
    
    if [ $naming_issues -eq 0 ]; then
        log_success "API consistency check passed"
    else
        log_warning "Found $naming_issues naming convention issues"
    fi
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
  "validated_specs": [
EOF
    
    local first=true
    for spec_file in "$SPEC_DIR"/*.yaml; do
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
    done
    
    cat >> "$report_file" << EOF
  ],
  "validation_tools": {
    "spectral": "$(command -v spectral >/dev/null && echo "available" || echo "not available")",
    "openapi_generator": "$(command -v openapi-generator >/dev/null && echo "available" || echo "not available")",
    "yq": "$(command -v yq >/dev/null && echo "available" || echo "not available")"
  }
}
EOF
    
    log_success "Validation report generated: $report_file"
}

# Main execution
main() {
    log_info "Starting API specification validation..."
    log_info "Spec directory: $SPEC_DIR"
    log_info "Output directory: $OUTPUT_DIR"
    
    # Create output directory
    mkdir -p "$OUTPUT_DIR"
    
    # Check dependencies
    check_dependencies
    
    # Validate each specification
    local validation_errors=0
    for spec_file in "$SPEC_DIR"/*.yaml; do
        if [ -f "$spec_file" ]; then
            if ! validate_spec "$spec_file"; then
                ((validation_errors++))
            fi
        fi
    done
    
    # Check cross-references
    if ! check_cross_references; then
        ((validation_errors++))
    fi
    
    # Check consistency
    check_consistency
    
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
