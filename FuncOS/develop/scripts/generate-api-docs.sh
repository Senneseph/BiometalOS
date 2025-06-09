#!/bin/bash

# FuncOS - API Documentation Generation Script
# Generates comprehensive API documentation from OpenAPI specifications

set -euo pipefail

# Configuration
SPEC_DIR="${SPEC_DIR:-./spec/api}"
DOCS_DIR="${DOCS_DIR:-./docs/api}"
BUILD_DIR="${BUILD_DIR:-./build/docs}"
FORMAT="${FORMAT:-html}"
SERVE="${SERVE:-false}"
PORT="${PORT:-3000}"

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
    log_info "Checking documentation generation dependencies..."
    
    local missing_deps=()
    
    # Check for redoc-cli (for HTML generation)
    if [ "$FORMAT" = "html" ] && ! command -v redoc-cli &> /dev/null; then
        missing_deps+=("redoc-cli")
    fi
    
    # Check for swagger-codegen (for various formats)
    if ! command -v swagger-codegen &> /dev/null && ! command -v openapi-generator &> /dev/null; then
        missing_deps+=("openapi-generator or swagger-codegen")
    fi
    
    # Check for pandoc (for PDF generation)
    if [ "$FORMAT" = "pdf" ] && ! command -v pandoc &> /dev/null; then
        missing_deps+=("pandoc")
    fi
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        log_error "Missing dependencies: ${missing_deps[*]}"
        log_info "Install with: npm install -g redoc-cli @apidevtools/swagger-cli"
        exit 1
    fi
    
    log_success "All dependencies available"
}

# Generate documentation for a single spec
generate_spec_docs() {
    local spec_file="$1"
    local spec_name=$(basename "$spec_file" .yaml)
    
    log_info "Generating documentation for $spec_name..."
    
    # Create output directories
    mkdir -p "$DOCS_DIR/$spec_name"
    mkdir -p "$BUILD_DIR/$spec_name"
    
    case "$FORMAT" in
        html)
            generate_html_docs "$spec_file" "$spec_name"
            ;;
        markdown)
            generate_markdown_docs "$spec_file" "$spec_name"
            ;;
        pdf)
            generate_pdf_docs "$spec_file" "$spec_name"
            ;;
        all)
            generate_html_docs "$spec_file" "$spec_name"
            generate_markdown_docs "$spec_file" "$spec_name"
            ;;
        *)
            log_error "Unsupported format: $FORMAT"
            return 1
            ;;
    esac
}

# Generate HTML documentation using Redoc
generate_html_docs() {
    local spec_file="$1"
    local spec_name="$2"
    
    if command -v redoc-cli &> /dev/null; then
        log_info "Generating HTML documentation with Redoc..."
        
        redoc-cli build "$spec_file" \
            --output "$DOCS_DIR/$spec_name/index.html" \
            --title "FuncOS $spec_name API Documentation" \
            --options.theme.colors.primary.main="#2196F3" \
            --options.hideDownloadButton=false
        
        log_success "HTML documentation generated: $DOCS_DIR/$spec_name/index.html"
    else
        log_warning "redoc-cli not available, skipping HTML generation"
    fi
}

# Generate Markdown documentation
generate_markdown_docs() {
    local spec_file="$1"
    local spec_name="$2"
    
    if command -v openapi-generator &> /dev/null; then
        log_info "Generating Markdown documentation..."
        
        openapi-generator generate \
            -i "$spec_file" \
            -g markdown \
            -o "$BUILD_DIR/$spec_name/markdown" \
            --additional-properties=appName="FuncOS $spec_name API",appDescription="API documentation for FuncOS $spec_name service"
        
        # Copy main README to docs directory
        if [ -f "$BUILD_DIR/$spec_name/markdown/README.md" ]; then
            cp "$BUILD_DIR/$spec_name/markdown/README.md" "$DOCS_DIR/$spec_name/README.md"
            log_success "Markdown documentation generated: $DOCS_DIR/$spec_name/README.md"
        fi
    else
        log_warning "openapi-generator not available, skipping Markdown generation"
    fi
}

# Generate PDF documentation
generate_pdf_docs() {
    local spec_file="$1"
    local spec_name="$2"
    
    if command -v pandoc &> /dev/null; then
        log_info "Generating PDF documentation..."
        
        # First generate markdown, then convert to PDF
        generate_markdown_docs "$spec_file" "$spec_name"
        
        if [ -f "$DOCS_DIR/$spec_name/README.md" ]; then
            pandoc "$DOCS_DIR/$spec_name/README.md" \
                -o "$DOCS_DIR/$spec_name/$spec_name-api.pdf" \
                --pdf-engine=xelatex \
                --variable=geometry:margin=1in \
                --variable=fontsize:11pt
            
            log_success "PDF documentation generated: $DOCS_DIR/$spec_name/$spec_name-api.pdf"
        fi
    else
        log_warning "pandoc not available, skipping PDF generation"
    fi
}

# Generate index page
generate_index() {
    log_info "Generating documentation index..."
    
    local index_file="$DOCS_DIR/index.html"
    
    cat > "$index_file" << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FuncOS API Documentation</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
            line-height: 1.6;
        }
        .header {
            text-align: center;
            margin-bottom: 3rem;
            padding-bottom: 2rem;
            border-bottom: 2px solid #e0e0e0;
        }
        .api-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
            margin-bottom: 3rem;
        }
        .api-card {
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            padding: 1.5rem;
            background: #f9f9f9;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .api-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .api-title {
            color: #2196F3;
            margin-bottom: 0.5rem;
        }
        .api-links {
            margin-top: 1rem;
        }
        .api-links a {
            display: inline-block;
            margin-right: 1rem;
            color: #2196F3;
            text-decoration: none;
            font-weight: 500;
        }
        .api-links a:hover {
            text-decoration: underline;
        }
        .footer {
            text-align: center;
            margin-top: 3rem;
            padding-top: 2rem;
            border-top: 1px solid #e0e0e0;
            color: #666;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>FuncOS API Documentation</h1>
        <p>Complete API reference for Project Biometal's FuncOS</p>
    </div>
    
    <div class="api-grid">
EOF
    
    # Add cards for each API
    for spec_file in "$SPEC_DIR"/*.yaml; do
        if [ -f "$spec_file" ]; then
            local spec_name=$(basename "$spec_file" .yaml)
            local title=$(yq eval '.info.title // "Unknown API"' "$spec_file" 2>/dev/null || echo "Unknown API")
            local description=$(yq eval '.info.description // "No description available"' "$spec_file" 2>/dev/null || echo "No description available")
            
            # Truncate description if too long
            if [ ${#description} -gt 150 ]; then
                description="${description:0:150}..."
            fi
            
            cat >> "$index_file" << EOF
        <div class="api-card">
            <h3 class="api-title">$title</h3>
            <p>$description</p>
            <div class="api-links">
EOF
            
            # Add links based on what was generated
            if [ -f "$DOCS_DIR/$spec_name/index.html" ]; then
                echo "                <a href=\"./$spec_name/index.html\">HTML Docs</a>" >> "$index_file"
            fi
            if [ -f "$DOCS_DIR/$spec_name/README.md" ]; then
                echo "                <a href=\"./$spec_name/README.md\">Markdown</a>" >> "$index_file"
            fi
            if [ -f "$DOCS_DIR/$spec_name/$spec_name-api.pdf" ]; then
                echo "                <a href=\"./$spec_name/$spec_name-api.pdf\">PDF</a>" >> "$index_file"
            fi
            
            cat >> "$index_file" << EOF
            </div>
        </div>
EOF
        fi
    done
    
    cat >> "$index_file" << EOF
    </div>
    
    <div class="footer">
        <p>Generated on $(date) | FuncOS - FuncOS</p>
    </div>
</body>
</html>
EOF
    
    log_success "Documentation index generated: $index_file"
}

# Serve documentation locally
serve_docs() {
    if [ "$SERVE" = "true" ]; then
        log_info "Starting documentation server on port $PORT..."
        
        if command -v python3 &> /dev/null; then
            cd "$DOCS_DIR"
            python3 -m http.server "$PORT"
        elif command -v python &> /dev/null; then
            cd "$DOCS_DIR"
            python -m SimpleHTTPServer "$PORT"
        else
            log_warning "Python not available, cannot serve documentation"
            log_info "Documentation available at: file://$PWD/$DOCS_DIR/index.html"
        fi
    fi
}

# Main execution
main() {
    log_info "Starting API documentation generation..."
    log_info "Spec directory: $SPEC_DIR"
    log_info "Docs directory: $DOCS_DIR"
    log_info "Format: $FORMAT"
    
    # Create output directories
    mkdir -p "$DOCS_DIR"
    mkdir -p "$BUILD_DIR"
    
    # Check dependencies
    check_dependencies
    
    # Generate documentation for each specification
    for spec_file in "$SPEC_DIR"/*.yaml; do
        if [ -f "$spec_file" ]; then
            generate_spec_docs "$spec_file"
        fi
    done
    
    # Generate index page
    generate_index
    
    log_success "API documentation generation completed!"
    log_info "Documentation available at: $DOCS_DIR/index.html"
    
    # Serve documentation if requested
    serve_docs
}

# Handle script arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -f|--format)
            FORMAT="$2"
            shift 2
            ;;
        -s|--serve)
            SERVE=true
            shift
            ;;
        -p|--port)
            PORT="$2"
            shift 2
            ;;
        -d|--spec-dir)
            SPEC_DIR="$2"
            shift 2
            ;;
        -o|--docs-dir)
            DOCS_DIR="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo "Options:"
            echo "  -f, --format        Output format (html|markdown|pdf|all) (default: html)"
            echo "  -s, --serve         Serve documentation locally"
            echo "  -p, --port          Port for local server (default: 3000)"
            echo "  -d, --spec-dir      Specification directory (default: ./spec/api)"
            echo "  -o, --docs-dir      Documentation output directory (default: ./docs/api)"
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
