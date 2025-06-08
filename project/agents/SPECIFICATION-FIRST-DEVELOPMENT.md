# Specification-First Development Guide

## Core Philosophy

**Everything starts from `/spec`** - this is the foundation of WebAXP methodology. Specifications are the single source of truth that drives all other subsystems: `/docs`, `/app`, `/build`, and `/dist`.

## Why Specification-First?

### Eliminates Transcription Errors
- **Tools extract from `/spec`** - no LLM transcription needed
- **Automated generation** - reduces human error
- **Single source of truth** - prevents inconsistencies
- **Validation built-in** - specifications are machine-readable

### Enables True Parallel Development
- **Clear interfaces** - teams know exactly what to implement
- **Dependency management** - specifications define what's needed
- **Integration testing** - specifications define expected behavior
- **Documentation generation** - always up-to-date

### Ensures Architecture Integrity
- **WebAXP compliance** - specifications enforce methodology
- **Cross-project consistency** - shared specification patterns
- **Quality gates** - specifications define success criteria
- **Evolution management** - controlled specification changes

## Specification Structure

### Required Files in `/spec`
```
/spec/
├── api/                    # API definitions (OpenAPI 3.0)
│   ├── hardware.yaml      # Hardware service APIs
│   ├── functions.yaml     # Function execution APIs
│   └── integration.yaml   # Cross-project APIs
├── data/                  # Data schemas and models
│   ├── schemas.yaml       # Data structure definitions
│   └── protocols.yaml     # Communication protocols
├── security/              # Security specifications
│   ├── capabilities.yaml  # Capability definitions
│   └── policies.yaml      # Security policies
├── performance/           # Performance specifications
│   ├── slas.yaml          # Service level agreements
│   └── benchmarks.yaml    # Performance targets
└── README.md              # Specification overview
```

### Specification Quality Standards
- **OpenAPI 3.0 Compliant** - all APIs must validate
- **Machine Readable** - tools can extract all details
- **Complete** - no undefined interfaces or behaviors
- **Versioned** - clear version management
- **Documented** - human-readable descriptions

## Development Workflow

### Step 1: Specification Analysis
```bash
cd [YourProject]/spec/

# Evaluate existing specifications
find . -name "*.yaml" -exec echo "=== {} ===" \; -exec cat {} \;

# Check for completeness
./develop/scripts/spec-completeness-check.sh

# Validate existing specs
./develop/scripts/validate-specs.sh
```

### Step 2: Specification Updates
```bash
# Add missing API definitions
vim spec/api/your-service.yaml

# Define data schemas
vim spec/data/your-schemas.yaml

# Specify security requirements
vim spec/security/your-capabilities.yaml

# Set performance targets
vim spec/performance/your-slas.yaml
```

### Step 3: Specification Validation
```bash
# Validate OpenAPI specifications
swagger-codegen validate -i spec/api/your-service.yaml

# Check specification consistency
./develop/scripts/spec-consistency-check.sh

# Generate documentation to verify completeness
./develop/scripts/generate-docs.sh
```

### Step 4: Tool-Based Extraction
```bash
# Extract interfaces (NO LLM needed)
./develop/scripts/extract-interfaces.sh

# Generate code stubs from specifications
./develop/scripts/generate-stubs.sh

# Create test templates from specifications
./develop/scripts/generate-test-templates.sh

# Generate build configurations
./develop/scripts/generate-build-config.sh
```

## Tool Development for Specification Extraction

### Interface Extraction Tool
```bash
#!/bin/bash
# extract-interfaces.sh - Extract interfaces from specifications

# Parse OpenAPI specs to extract interface definitions
yq eval '.paths | keys | .[]' spec/api/*.yaml > interfaces.list

# Extract data schemas
yq eval '.components.schemas | keys | .[]' spec/api/*.yaml > schemas.list

# Generate interface headers
for interface in $(cat interfaces.list); do
    echo "Generating interface for: $interface"
    ./tools/generate-interface-header.sh "$interface"
done
```

### Code Generation Tool
```bash
#!/bin/bash
# generate-stubs.sh - Generate implementation stubs

# Generate service stubs from API specifications
for api_file in spec/api/*.yaml; do
    service_name=$(basename "$api_file" .yaml)
    echo "Generating stubs for: $service_name"
    
    # Use OpenAPI generator (not LLM)
    openapi-generator generate \
        -i "$api_file" \
        -g rust-server \
        -o "app/services/$service_name"
done
```

### Documentation Generation Tool
```bash
#!/bin/bash
# generate-docs.sh - Generate documentation from specifications

# Generate API documentation
for api_file in spec/api/*.yaml; do
    swagger-codegen generate \
        -i "$api_file" \
        -l html2 \
        -o "docs/api/$(basename "$api_file" .yaml)"
done

# Generate integration guides
./tools/generate-integration-docs.sh

# Generate developer guides
./tools/generate-dev-guides.sh
```

## Specification Templates

### API Specification Template
```yaml
# spec/api/service-template.yaml
openapi: 3.0.0
info:
  title: "[Service Name] API"
  version: "1.0.0"
  description: "[Service description]"

servers:
  - url: "http://localhost:8080/api/v1"
    description: "Development server"

paths:
  /service/action:
    post:
      summary: "[Action description]"
      operationId: "serviceAction"
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: "#/components/schemas/ActionRequest"
      responses:
        '200':
          description: "Success"
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/ActionResponse"
        '400':
          description: "Bad request"
        '500':
          description: "Internal server error"

components:
  schemas:
    ActionRequest:
      type: object
      required:
        - parameter1
      properties:
        parameter1:
          type: string
          description: "[Parameter description]"
    
    ActionResponse:
      type: object
      properties:
        result:
          type: string
          description: "[Result description]"
```

### Data Schema Template
```yaml
# spec/data/schemas-template.yaml
schemas:
  HardwareRequest:
    type: object
    required:
      - service_type
      - deadline
    properties:
      service_type:
        type: string
        enum: ["memory", "storage", "network", "graphics", "input"]
      deadline:
        type: integer
        format: int64
        description: "Deadline in milliseconds"
      capabilities:
        type: array
        items:
          type: string
        description: "Required capabilities"
  
  ServiceResponse:
    type: object
    properties:
      status:
        type: string
        enum: ["success", "error", "timeout"]
      data:
        type: object
        description: "Service-specific response data"
      error:
        type: string
        description: "Error message if status is error"
```

### Performance SLA Template
```yaml
# spec/performance/slas-template.yaml
service_level_agreements:
  hardware_services:
    memory_service:
      latency_p99: "10ms"
      throughput: "1000 requests/second"
      availability: "99.9%"
    
    storage_service:
      latency_p99: "50ms"
      throughput: "500 requests/second"
      availability: "99.9%"
  
  function_execution:
    startup_time: "10ms"
    execution_overhead: "<5%"
    memory_overhead: "1MB"
```

## Integration with Other Projects

### Cross-Project Specification Sharing
```bash
# Share specifications with dependent projects
./develop/scripts/export-interfaces.sh target-project

# Import specifications from dependencies
./develop/scripts/import-interfaces.sh source-project

# Validate cross-project compatibility
./develop/scripts/validate-integration.sh
```

### Specification Versioning
```yaml
# spec/VERSION.yaml
specification_version: "1.0.0"
api_version: "v1"
compatibility:
  minimum_supported: "0.9.0"
  breaking_changes_since: "0.8.0"

dependencies:
  funcos_core: ">=1.0.0"
  api_specifications: ">=1.0.0"
```

## Quality Assurance

### Specification Review Checklist
- [ ] **OpenAPI 3.0 Validation**: All API specs validate
- [ ] **Completeness**: All required interfaces defined
- [ ] **Consistency**: Follows project naming conventions
- [ ] **Documentation**: Human-readable descriptions complete
- [ ] **Examples**: Request/response examples provided
- [ ] **Error Handling**: All error cases specified
- [ ] **Security**: Security requirements documented
- [ ] **Performance**: SLAs and benchmarks defined

### Tool Validation
```bash
# Validate all specifications
./develop/scripts/validate-all-specs.sh

# Check tool extraction works
./develop/scripts/test-extraction-tools.sh

# Verify generated code compiles
./develop/scripts/test-generated-code.sh

# Validate documentation generation
./develop/scripts/test-doc-generation.sh
```

## Benefits of This Approach

### For Developers
- **Clear Requirements**: Specifications define exactly what to build
- **Automated Scaffolding**: Tools generate boilerplate code
- **Consistent Interfaces**: Specifications ensure compatibility
- **Up-to-Date Documentation**: Always reflects current specifications

### For Project Management
- **Progress Tracking**: Specification completion indicates progress
- **Dependency Management**: Clear interface dependencies
- **Quality Gates**: Specifications define acceptance criteria
- **Risk Reduction**: Early interface validation

### For Architecture
- **Consistency**: Shared specification patterns
- **Evolution**: Controlled specification changes
- **Integration**: Clear cross-project interfaces
- **Validation**: Machine-readable specifications enable automated testing

**Remember: Specifications are not documentation - they are the executable definition of your system!** 📋⚙️
