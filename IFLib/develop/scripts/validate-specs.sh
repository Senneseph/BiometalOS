#!/bin/sh
# IFLib - Specification Validator
# Validates all YAML specifications for consistency and correctness

set -eu

# === Configuration ===
SPEC_DIR="${SPEC_DIR:-/workspace/spec}"
CONFIG_DIR="${CONFIG_DIR:-/workspace/config}"
OUTPUT_FILE="${OUTPUT_FILE:-/workspace/config/validation-report.json}"
LOG_LEVEL="${LOG_LEVEL:-info}"

# === Logging Functions ===
log_info() { [ "$LOG_LEVEL" = "debug" ] || [ "$LOG_LEVEL" = "info" ] && echo "[INFO] $*" >&2; }
log_warn() { [ "$LOG_LEVEL" != "error" ] && echo "[WARN] $*" >&2; }
log_error() { echo "[ERROR] $*" >&2; }
log_debug() { [ "$LOG_LEVEL" = "debug" ] && echo "[DEBUG] $*" >&2; }

# === Validation Functions ===
validate_yaml_syntax() {
    local file="$1"
    local result="valid"
    local message=""
    
    if ! yq eval '.' "$file" >/dev/null 2>&1; then
        result="invalid"
        message="YAML syntax error"
    fi
    
    echo "$result|$message"
}

validate_required_fields() {
    local file="$1"
    local spec_type="$2"
    local result="valid"
    local message=""
    
    case "$spec_type" in
        "build")
            if ! yq eval '.project.name' "$file" >/dev/null 2>&1; then
                result="invalid"
                message="Missing required field: project.name"
            elif ! yq eval '.architectures.primary' "$file" >/dev/null 2>&1; then
                result="invalid"
                message="Missing required field: architectures.primary"
            fi
            ;;
        "services")
            if ! yq eval '.services' "$file" >/dev/null 2>&1; then
                result="invalid"
                message="Missing required field: services"
            fi
            ;;
        "manifest")
            if ! yq eval '.name' "$file" >/dev/null 2>&1; then
                result="invalid"
                message="Missing required field: name"
            elif ! yq eval '.version' "$file" >/dev/null 2>&1; then
                result="invalid"
                message="Missing required field: version"
            fi
            ;;
    esac
    
    echo "$result|$message"
}

validate_cross_references() {
    local build_file="$SPEC_DIR/build.yaml"
    local services_file="$CONFIG_DIR/services.yaml"
    local result="valid"
    local message=""
    
    # Check if primary architecture in build.yaml matches services configuration
    if [ -f "$build_file" ] && [ -f "$services_file" ]; then
        local build_arch
        local services_arch
        
        build_arch=$(yq eval '.architectures.primary' "$build_file" 2>/dev/null || echo "")
        services_arch=$(yq eval '.services.build.compilation.target_architectures[0]' "$services_file" 2>/dev/null || echo "")
        
        if [ -n "$build_arch" ] && [ -n "$services_arch" ] && [ "$build_arch" != "$services_arch" ]; then
            result="warning"
            message="Architecture mismatch between build.yaml ($build_arch) and services.yaml ($services_arch)"
        fi
    fi
    
    echo "$result|$message"
}

# === Main Validation Logic ===
validate_file() {
    local file="$1"
    local spec_type="$2"
    local filename
    filename=$(basename "$file")
    
    log_debug "Validating $filename ($spec_type)"
    
    # Initialize validation result
    local overall_result="valid"
    local issues=0
    local warnings=0
    
    # Validate YAML syntax
    local syntax_result
    syntax_result=$(validate_yaml_syntax "$file")
    local syntax_status="${syntax_result%%|*}"
    local syntax_message="${syntax_result##*|}"
    
    if [ "$syntax_status" = "invalid" ]; then
        overall_result="invalid"
        issues=$((issues + 1))
        log_error "$filename: $syntax_message"
    else
        log_debug "$filename: YAML syntax valid"
    fi
    
    # Validate required fields (only if syntax is valid)
    if [ "$syntax_status" = "valid" ]; then
        local fields_result
        fields_result=$(validate_required_fields "$file" "$spec_type")
        local fields_status="${fields_result%%|*}"
        local fields_message="${fields_result##*|}"
        
        if [ "$fields_status" = "invalid" ]; then
            overall_result="invalid"
            issues=$((issues + 1))
            log_error "$filename: $fields_message"
        elif [ -n "$fields_message" ]; then
            log_debug "$filename: Required fields valid"
        fi
    fi
    
    # Return validation summary
    echo "$overall_result|$issues|$warnings"
}

generate_report() {
    local total_files="$1"
    local valid_files="$2"
    local invalid_files="$3"
    local total_issues="$4"
    local total_warnings="$5"
    
    # Create output directory
    mkdir -p "$(dirname "$OUTPUT_FILE")"
    
    # Generate JSON report
    cat > "$OUTPUT_FILE" << EOF
{
  "validation": {
    "timestamp": "$(date -Iseconds)",
    "summary": {
      "total_files": $total_files,
      "valid_files": $valid_files,
      "invalid_files": $invalid_files,
      "total_issues": $total_issues,
      "total_warnings": $total_warnings,
      "overall_status": "$([ $invalid_files -eq 0 ] && echo "valid" || echo "invalid")"
    },
    "files": [
EOF

    # Add file details (simplified for this version)
    local first=true
    for file in "$SPEC_DIR"/*.yaml "$SPEC_DIR"/*.yml "$CONFIG_DIR"/*.yaml "$CONFIG_DIR"/*.yml; do
        [ -f "$file" ] || continue
        
        if [ "$first" = true ]; then
            first=false
        else
            echo "," >> "$OUTPUT_FILE"
        fi
        
        local filename
        filename=$(basename "$file")
        echo "      {\"file\": \"$filename\", \"status\": \"checked\"}" >> "$OUTPUT_FILE"
    done
    
    cat >> "$OUTPUT_FILE" << EOF

    ]
  }
}
EOF
}

main() {
    log_info "Starting specification validation for Project Biometal..."
    
    # Initialize counters
    local total_files=0
    local valid_files=0
    local invalid_files=0
    local total_issues=0
    local total_warnings=0
    
    # Validate build specifications
    for file in "$SPEC_DIR"/build.yaml "$SPEC_DIR"/build.yml; do
        [ -f "$file" ] || continue
        total_files=$((total_files + 1))
        
        local result
        result=$(validate_file "$file" "build")
        local status="${result%%|*}"
        local issues="${result#*|}"
        issues="${issues%%|*}"
        local warnings="${result##*|}"
        
        if [ "$status" = "valid" ]; then
            valid_files=$((valid_files + 1))
        else
            invalid_files=$((invalid_files + 1))
        fi
        
        total_issues=$((total_issues + issues))
        total_warnings=$((total_warnings + warnings))
    done
    
    # Validate service configurations
    for file in "$CONFIG_DIR"/services.yaml "$CONFIG_DIR"/services.yml; do
        [ -f "$file" ] || continue
        total_files=$((total_files + 1))
        
        local result
        result=$(validate_file "$file" "services")
        local status="${result%%|*}"
        local issues="${result#*|}"
        issues="${issues%%|*}"
        local warnings="${result##*|}"
        
        if [ "$status" = "valid" ]; then
            valid_files=$((valid_files + 1))
        else
            invalid_files=$((invalid_files + 1))
        fi
        
        total_issues=$((total_issues + issues))
        total_warnings=$((total_warnings + warnings))
    done
    
    # Validate WebAXP manifest
    for file in .webaxp/manifest.yml .webaxp/manifest.yaml; do
        [ -f "/workspace/$file" ] || continue
        total_files=$((total_files + 1))
        
        local result
        result=$(validate_file "/workspace/$file" "manifest")
        local status="${result%%|*}"
        local issues="${result#*|}"
        issues="${issues%%|*}"
        local warnings="${result##*|}"
        
        if [ "$status" = "valid" ]; then
            valid_files=$((valid_files + 1))
        else
            invalid_files=$((invalid_files + 1))
        fi
        
        total_issues=$((total_issues + issues))
        total_warnings=$((total_warnings + warnings))
    done
    
    # Validate cross-references
    local cross_ref_result
    cross_ref_result=$(validate_cross_references)
    local cross_ref_status="${cross_ref_result%%|*}"
    local cross_ref_message="${cross_ref_result##*|}"
    
    if [ "$cross_ref_status" = "warning" ] && [ -n "$cross_ref_message" ]; then
        total_warnings=$((total_warnings + 1))
        log_warn "$cross_ref_message"
    fi
    
    # Generate validation report
    generate_report "$total_files" "$valid_files" "$invalid_files" "$total_issues" "$total_warnings"
    
    # Display summary
    log_info "Validation complete!"
    log_info "Files processed: $total_files"
    log_info "Valid files: $valid_files"
    log_info "Invalid files: $invalid_files"
    log_info "Total issues: $total_issues"
    log_info "Total warnings: $total_warnings"
    log_info "Report saved to: $OUTPUT_FILE"
    
    # Exit with appropriate code
    if [ $invalid_files -gt 0 ]; then
        log_error "Validation failed with $invalid_files invalid files"
        exit 1
    elif [ $total_warnings -gt 0 ]; then
        log_warn "Validation passed with $total_warnings warnings"
        exit 0
    else
        log_info "All specifications are valid!"
        exit 0
    fi
}

# === Script Entry Point ===
if [ "${0##*/}" = "validate-specs.sh" ]; then
    main "$@"
fi
