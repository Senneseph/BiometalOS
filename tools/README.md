# 🛠️ Tools - Development Utilities

**Collection of development tools, utilities, and scripts that support the Project Biometal ecosystem**

This directory contains shared development tools, validation scripts, and utilities used across all Project Biometal components (FuncOS, Nerv, Biometal, IFLib).

## 📁 Directory Structure

```
tools/
├── scripts/                    # Development and validation scripts
│   ├── validate-api-specs-docker.sh    # Docker-based API validation
│   ├── validate-api-specs.sh           # Local API validation
│   └── generate-api-docs.sh            # Documentation generation
├── build/                      # Build tools and utilities
├── testing/                    # Testing frameworks and utilities
├── validation/                 # Validation tools and checkers
└── development/               # Development environment tools
```

## 🔧 Available Tools

### **API Validation Scripts**

#### **Docker-based Validation** (`scripts/validate-api-specs-docker.sh`)
- **Purpose**: Validate OpenAPI 3.0 specifications using Docker containers
- **Dependencies**: Docker only (zero local dependencies)
- **Features**:
  - OpenAPI 3.0 schema validation
  - YAML syntax checking
  - API design pattern validation
  - Cross-reference validation

**Usage**:
```bash
# Validate all API specifications
./tools/scripts/validate-api-specs-docker.sh

# Validate with verbose output
./tools/scripts/validate-api-specs-docker.sh --verbose

# Validate specific directory
./tools/scripts/validate-api-specs-docker.sh --spec-dir FuncOS/spec/api
```

#### **Local Validation** (`scripts/validate-api-specs.sh`)
- **Purpose**: Local API validation with dependency management
- **Dependencies**: Manages local tool installation
- **Features**:
  - Dependency checking and installation
  - Local tool optimization
  - Faster validation for development

**Usage**:
```bash
# Validate with local tools
./tools/scripts/validate-api-specs.sh

# Install dependencies and validate
./tools/scripts/validate-api-specs.sh --install-deps
```

### **Documentation Generation** (`scripts/generate-api-docs.sh`)
- **Purpose**: Generate comprehensive API documentation
- **Output Formats**: HTML, Markdown, PDF
- **Features**:
  - Multi-format documentation generation
  - Auto-generated index pages
  - Local documentation server
  - Cross-project documentation

**Usage**:
```bash
# Generate HTML documentation
./tools/scripts/generate-api-docs.sh --format html

# Generate all formats and serve locally
./tools/scripts/generate-api-docs.sh --format all --serve

# Generate for specific project
./tools/scripts/generate-api-docs.sh --spec-dir Biometal/spec/api --format html
```

## 🌊 Cross-Project Usage

### **From Any Project Directory**
```bash
# Validate current project's APIs
../tools/scripts/validate-api-specs-docker.sh --spec-dir spec/api

# Generate documentation for current project
../tools/scripts/generate-api-docs.sh --spec-dir spec/api --format html
```

### **From Repository Root**
```bash
# Validate all projects
for project in FuncOS Nerv Biometal IFLib; do
  ./tools/scripts/validate-api-specs-docker.sh --spec-dir $project/spec/api
done

# Generate documentation for all projects
for project in FuncOS Nerv Biometal IFLib; do
  ./tools/scripts/generate-api-docs.sh --spec-dir $project/spec/api --output-dir docs/$project
done
```

## 🔍 Validation Features

### **OpenAPI 3.0 Compliance**
- Schema validation against OpenAPI 3.0 specification
- Ensures all API specifications are valid
- Catches syntax and structural errors
- Validates references and dependencies

### **Design Pattern Validation**
- Checks naming conventions (kebab-case paths, PascalCase schemas)
- Validates consistent error handling patterns
- Ensures proper HTTP status code usage
- Verifies security scheme consistency

### **Cross-Reference Validation**
- Validates internal references within specifications
- Checks external references between projects
- Ensures component schema consistency
- Validates parameter and response references

## 📚 Documentation Generation

### **Multi-Format Support**
- **HTML**: Interactive documentation with Redoc
- **Markdown**: GitHub-compatible documentation
- **PDF**: Printable documentation format
- **JSON**: Machine-readable API definitions

### **Features**
- Auto-generated index pages
- Cross-project navigation
- Search functionality
- Interactive API exploration
- Code examples and samples

### **Local Development Server**
- Serves documentation locally for development
- Hot-reload for specification changes
- Cross-project documentation browsing
- Mobile-responsive design

## 🛠️ Development Workflow Integration

### **Pre-commit Validation**
```bash
# Add to git pre-commit hook
#!/bin/bash
./tools/scripts/validate-api-specs-docker.sh
if [ $? -ne 0 ]; then
  echo "API validation failed. Please fix errors before committing."
  exit 1
fi
```

### **CI/CD Integration**
```yaml
# GitHub Actions example
- name: Validate API Specifications
  run: ./tools/scripts/validate-api-specs-docker.sh

- name: Generate Documentation
  run: ./tools/scripts/generate-api-docs.sh --format html
```

### **Development Environment**
```bash
# Start development with validation
./tools/scripts/validate-api-specs-docker.sh && \
./tools/scripts/generate-api-docs.sh --format html --serve
```

## 📊 Quality Assurance

### **Validation Reports**
- Detailed validation results in JSON format
- Error categorization and severity levels
- Validation timestamps and tool versions
- Cross-project validation summaries

### **Documentation Quality**
- Completeness checking
- Link validation
- Example verification
- Accessibility compliance

### **Performance Monitoring**
- Validation execution time tracking
- Documentation generation performance
- Tool efficiency metrics
- Resource usage monitoring

## 🔧 Tool Configuration

### **Environment Variables**
```bash
# Validation configuration
export SPEC_DIR="./spec/api"           # Default specification directory
export OUTPUT_DIR="./build/validation" # Validation output directory
export VERBOSE="false"                 # Verbose output mode

# Documentation configuration
export DOCS_DIR="./docs/api"           # Documentation output directory
export FORMAT="html"                   # Default documentation format
export SERVE="false"                   # Serve documentation locally
export PORT="3000"                     # Local server port
```

### **Custom Configuration Files**
- Tool-specific configuration files
- Project-specific validation rules
- Custom documentation templates
- Integration-specific settings

## 🚀 Future Enhancements

### **Planned Features**
- **Mock Service Generation**: Generate mock services from API specs
- **Contract Testing**: Validate implementations against specifications
- **Performance Testing**: API performance benchmarking tools
- **Security Analysis**: Security vulnerability scanning

### **Integration Improvements**
- **IDE Integration**: Editor plugins for real-time validation
- **Advanced Reporting**: Enhanced validation and documentation reports
- **Automation**: Automated tool updates and maintenance
- **Cloud Integration**: Cloud-based validation and documentation services

## 📈 Usage Statistics

### **Validation Metrics**
- Number of API specifications validated
- Validation success/failure rates
- Common error patterns
- Tool performance metrics

### **Documentation Metrics**
- Documentation generation frequency
- Format usage statistics
- User engagement metrics
- Documentation quality scores

---

**The tools directory provides the essential development infrastructure that ensures quality, consistency, and efficiency across all Project Biometal components.**
