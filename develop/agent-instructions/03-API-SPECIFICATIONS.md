# Agent Instructions: API Specifications

## Project: API-Specifications

### Overview
The API Specifications project defines the complete interface contracts for all layers of the FuncOS/Project Biometal architecture. This is the source of truth for all inter-component communication and the foundation for specification-driven development.

### Architecture Context
This project is part of the layered FuncOS/Project Biometal architecture:
1. **FuncOS**: Hardware abstraction OS providing safe hardware access
2. **Project Biometal**: Neural data collection from hardware interactions  
3. **Application Layer**: Function-level hardware requests via service APIs ← **THIS PROJECT**
4. **Browser Ecosystem**: WebAXP network API for hardware access ← **THIS PROJECT**

### Objectives
- [ ] Define complete API specifications for all system layers
- [ ] Establish service discovery and registration protocols
- [ ] Create security and capability models
- [ ] Design cross-layer interface definitions
- [ ] Enable specification-driven parallel development

### Prerequisites
- Understanding of OpenAPI 3.0 specification format
- Knowledge of microservice architecture patterns
- Familiarity with hardware abstraction concepts
- Experience with API design best practices

### Project Structure (WebAXP Compliant)
```
API-Specifications/
├── spec/           # Complete API specifications (OpenAPI 3.0)
├── app/            # API validation tools and generators
├── build/          # Specification build and validation system
├── dist/           # Generated API documentation and SDKs
├── docs/           # API design guides and examples
├── develop/        # API development and testing tools
└── config/         # API gateway and service configurations
```

### Setup Instructions

1. **Initialize Project Structure**
   ```bash
   mkdir -p API-Specifications/{spec,app,build,dist,docs,develop,config}
   cd API-Specifications
   ```

2. **Configure WebAXP Environment**
   ```bash
   # Copy shared configuration template
   cp ../BiometalOS/shared/docker-compose.template.yaml ./docker-compose.yaml
   
   # Create project configuration
   cat > config/webaxp.yaml << EOF
   project:
     name: "API-Specifications"
     type: "api"
     description: "Complete API specifications for FuncOS/Project Biometal"
   
   build:
     toolchain: "multi"
     target_arch: "x86_64"
     commands:
       - "./develop/scripts/validate-specs.sh"
       - "./develop/scripts/generate-docs.sh"
   
   features:
     - "docs"
     - "api-validation"
   EOF
   ```

3. **Set Environment Variables**
   ```bash
   export PROJECT_NAME="API-Specifications"
   export PROJECT_TYPE="api"
   export TOOLCHAIN="multi"
   ```

### Core API Specifications to Define

#### 1. Hardware Abstraction APIs (`spec/hardware/`)

**Memory Service API** (`spec/hardware/memory.yaml`)
```yaml
openapi: 3.0.0
info:
  title: FuncOS Memory Service API
  version: 1.0.0
paths:
  /memory/allocate:
    post:
      summary: Allocate memory region
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              properties:
                size:
                  type: integer
                  description: Size in bytes
                alignment:
                  type: integer
                  description: Alignment requirement
                deadline:
                  type: string
                  format: date-time
                  description: Service deadline
      responses:
        '200':
          description: Memory allocated successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/MemoryRegion'
```

**Storage Service API** (`spec/hardware/storage.yaml`)
**Network Service API** (`spec/hardware/network.yaml`)
**Graphics Service API** (`spec/hardware/graphics.yaml`)
**Input Service API** (`spec/hardware/input.yaml`)

#### 2. Function Execution APIs (`spec/execution/`)

**Function Request API** (`spec/execution/function-request.yaml`)
**Service Discovery API** (`spec/execution/service-discovery.yaml`)
**Capability Management API** (`spec/execution/capabilities.yaml`)

#### 3. Neural Data Collection APIs (`spec/biometal/`)

**Data Collection API** (`spec/biometal/data-collection.yaml`)
**Performance Metrics API** (`spec/biometal/metrics.yaml`)
**Neural Interface API** (`spec/biometal/neural-interface.yaml`)

#### 4. Browser Integration APIs (`spec/browser/`)

**WebAXP Network API** (`spec/browser/webaxp-network.yaml`)
**Hardware Access API** (`spec/browser/hardware-access.yaml`)
**Security Sandbox API** (`spec/browser/security.yaml`)

### Development Workflow

1. **Start Development Environment**
   ```bash
   docker-compose run --rm dev
   ```

2. **Validate Specifications**
   ```bash
   ./develop/scripts/validate-specs.sh
   ```

3. **Generate Documentation**
   ```bash
   ./develop/scripts/generate-docs.sh
   ```

4. **Generate SDKs**
   ```bash
   ./develop/scripts/generate-sdks.sh
   ```

### API Design Principles

#### 1. Consistency
- Uniform naming conventions across all APIs
- Consistent error handling and response formats
- Standard authentication and authorization patterns

#### 2. Service-Oriented
- Each hardware component exposed as independent service
- Clear service boundaries and responsibilities
- Discoverable and self-describing services

#### 3. Deadline-Driven
- All requests include deadline specifications
- Service-level agreements for response times
- Graceful degradation for missed deadlines

#### 4. Security-First
- Capability-based access control
- Fine-grained permissions for hardware access
- Secure by default configurations

#### 5. Observable
- Comprehensive logging and metrics
- Distributed tracing support
- Performance monitoring integration

### Integration Points

#### With FuncOS-Core
- **Service Implementation**: APIs define service contracts
- **IPC Protocols**: Specify inter-service communication
- **Security Model**: Define capability and permission systems

#### With Function-Execution-Model
- **Application APIs**: Define how apps request services
- **Runtime Integration**: Specify execution environment
- **Resource Management**: Define resource allocation APIs

#### With Neural-Data-Interface
- **Data Collection**: Specify monitoring and metrics APIs
- **Performance Tracking**: Define performance measurement
- **ML Integration**: Specify neural network interfaces

#### With Browser-Network-API
- **Web Integration**: Define browser-to-hardware APIs
- **Network Protocols**: Specify communication protocols
- **Security Boundaries**: Define web application limits

### Success Criteria

#### Phase 1: Core APIs (Week 1-2)
- [ ] Hardware abstraction APIs specified
- [ ] Function execution APIs defined
- [ ] Service discovery protocols established
- [ ] Basic validation tools working

#### Phase 2: Integration APIs (Week 3)
- [ ] Neural data collection APIs specified
- [ ] Browser integration APIs defined
- [ ] Security and capability models documented
- [ ] Cross-layer interfaces specified

#### Phase 3: Validation & Documentation (Week 4)
- [ ] All APIs validated and consistent
- [ ] Complete documentation generated
- [ ] SDK generation working
- [ ] Integration test specifications ready

### Testing Strategy

#### Specification Validation
- OpenAPI 3.0 schema validation
- API consistency checking
- Breaking change detection
- Documentation completeness

#### Contract Testing
- Mock service generation
- Client SDK testing
- Integration test generation
- Performance benchmark specs

### Deliverables

1. **Complete API Specifications** (`spec/`)
   - Hardware abstraction APIs
   - Function execution APIs
   - Neural data collection APIs
   - Browser integration APIs

2. **Validation Tools** (`app/`)
   - Specification validators
   - Consistency checkers
   - Mock service generators
   - Test case generators

3. **Documentation System** (`build/`)
   - Automated doc generation
   - SDK generation pipeline
   - Integration guides
   - API reference sites

4. **Generated Artifacts** (`dist/`)
   - API documentation websites
   - Client SDKs (multiple languages)
   - Mock services for testing
   - Integration test suites

### Timeline

#### Week 1: Hardware & Core APIs
- [ ] Memory, storage, network APIs
- [ ] Function execution framework
- [ ] Service discovery protocols

#### Week 2: Integration APIs
- [ ] Neural data collection
- [ ] Browser integration
- [ ] Security and capabilities

#### Week 3: Validation & Tools
- [ ] Specification validation
- [ ] Documentation generation
- [ ] SDK generation

#### Week 4: Testing & Refinement
- [ ] Integration test specs
- [ ] Performance benchmarks
- [ ] Final validation

### Resources

#### Tools & Libraries
- OpenAPI Generator for SDK generation
- Swagger UI for documentation
- Spectral for API linting
- Postman for API testing

#### Documentation
- OpenAPI 3.0 Specification
- REST API Design Guidelines
- Microservices API Patterns
- Security API Best Practices

This project enables all other teams to develop in parallel with clear, consistent interfaces!
