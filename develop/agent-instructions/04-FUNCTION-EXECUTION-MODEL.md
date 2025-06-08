# Agent Instructions: Function Execution Model

## Project: Function-Execution-Model

### Overview
The Function Execution Model project implements the application layer where programs specify which functions they want to run on which hardware through service/deadline requests. This is the core of the FuncOS vision - pure userland applications with no direct system access, all hardware requests mediated through safe service APIs.

### Architecture Context
This project is part of the layered FuncOS/Project Biometal architecture:
1. **FuncOS**: Hardware abstraction OS providing safe hardware access
2. **Project Biometal**: Neural data collection from hardware interactions  
3. **Application Layer**: Function-level hardware requests via service APIs ← **THIS PROJECT**
4. **Browser Ecosystem**: WebAXP network API for hardware access

### Objectives
- [ ] Implement function-level execution framework
- [ ] Create service/deadline request system
- [ ] Integrate WebAssembly for portable function execution
- [ ] Establish application isolation and security model
- [ ] Enable idempotent function behavior with hardware changes

### Prerequisites
- Understanding of WebAssembly runtime architecture
- Knowledge of service-oriented application design
- Experience with capability-based security models
- Familiarity with function-level programming paradigms

### Project Structure (WebAXP Compliant)
```
Function-Execution-Model/
├── spec/           # Function execution and service request APIs
├── app/            # Runtime engine and execution framework
├── build/          # Runtime build system and WASM toolchain
├── dist/           # Runtime binaries and example applications
├── docs/           # Developer guides and API documentation
├── develop/        # Development tools and testing framework
└── config/         # Runtime configuration and security policies
```

### Setup Instructions

1. **Initialize Project Structure**
   ```bash
   mkdir -p Function-Execution-Model/{spec,app,build,dist,docs,develop,config}
   cd Function-Execution-Model
   ```

2. **Configure WebAXP Environment**
   ```bash
   # Copy shared configuration template
   cp ../BiometalOS/shared/docker-compose.template.yaml ./docker-compose.yaml
   
   # Create project configuration
   cat > config/webaxp.yaml << EOF
   project:
     name: "Function-Execution-Model"
     type: "api"
     description: "Function-level execution runtime for FuncOS applications"
   
   build:
     toolchain: "multi"
     target_arch: "x86_64"
     commands:
       - "./develop/scripts/build-runtime.sh"
       - "./develop/scripts/build-examples.sh"
   
   features:
     - "wasm"
     - "service-api"
     - "security"
   EOF
   ```

3. **Set Environment Variables**
   ```bash
   export PROJECT_NAME="Function-Execution-Model"
   export PROJECT_TYPE="api"
   export TOOLCHAIN="multi"
   ```

### Core Components to Implement

#### 1. Function Runtime Engine (`app/runtime/`)

**WebAssembly Runtime**
- WASM module loading and execution
- Memory management and sandboxing
- Function call optimization
- Resource usage tracking

**Service Request Framework**
- Hardware service discovery
- Request/response handling
- Deadline management
- Capability validation

**Execution Scheduler**
- Function queue management
- Priority and deadline scheduling
- Resource allocation
- Load balancing across services

#### 2. Service API Layer (`app/api/`)

**Hardware Service Clients**
- Memory service client
- Storage service client
- Network service client
- Graphics service client
- Input service client

**Request Builder**
- Service request construction
- Parameter validation
- Deadline specification
- Capability checking

**Response Handler**
- Asynchronous response processing
- Error handling and retry logic
- Performance metrics collection
- Result caching

#### 3. Application Framework (`app/framework/`)

**Function Definition API**
```rust
// Example function definition
#[funcos_function]
async fn process_image(
    input: ImageData,
    hardware: HardwareSpec,
    deadline: Duration
) -> Result<ImageData, FuncError> {
    // Request GPU processing
    let gpu = hardware.request_gpu(deadline).await?;
    let result = gpu.process_image(input).await?;
    Ok(result)
}
```

**Hardware Specification DSL**
```yaml
# Hardware requirements specification
hardware_spec:
  memory:
    size: "1GB"
    type: "fast"
    deadline: "100ms"
  
  compute:
    type: "gpu"
    cores: 4
    deadline: "500ms"
  
  storage:
    type: "ssd"
    iops: 1000
    deadline: "50ms"
```

**Application Manifest**
```yaml
# Application manifest
app:
  name: "image-processor"
  version: "1.0.0"
  functions:
    - name: "process_image"
      hardware_requirements: "./specs/gpu-processing.yaml"
      security_capabilities: ["graphics", "storage"]
```

#### 4. Security and Isolation (`app/security/`)

**Capability System**
- Fine-grained hardware access permissions
- Dynamic capability granting
- Capability revocation
- Audit logging

**Application Sandboxing**
- WASM-based isolation
- Resource usage limits
- Network access control
- File system restrictions

**Biometric Integration**
- Per-application identity verification
- Capability inheritance
- Security policy enforcement
- Access pattern monitoring

### Development Workflow

1. **Start Development Environment**
   ```bash
   docker-compose run --rm dev
   ```

2. **Build Runtime Engine**
   ```bash
   ./develop/scripts/build-runtime.sh
   ```

3. **Build Example Applications**
   ```bash
   ./develop/scripts/build-examples.sh
   ```

4. **Test Function Execution**
   ```bash
   ./develop/scripts/test-functions.sh
   ```

5. **Performance Benchmarking**
   ```bash
   ./develop/scripts/benchmark-execution.sh
   ```

### Integration Points

#### With FuncOS-Core
- **Service Discovery**: Find and connect to hardware services
- **Service Requests**: Make function-level hardware requests
- **Capability Validation**: Verify access permissions
- **Resource Management**: Coordinate resource allocation

#### With API-Specifications
- **Service Contracts**: Implement specified service APIs
- **Request Protocols**: Follow specified communication patterns
- **Security Model**: Implement specified capability system
- **Performance SLAs**: Meet specified execution deadlines

#### With Neural-Data-Interface
- **Execution Metrics**: Provide function execution data
- **Performance Data**: Report timing and resource usage
- **Behavior Patterns**: Enable ML analysis of function behavior
- **Optimization Hints**: Receive AI-driven optimization suggestions

#### With Browser-Network-API
- **Web Integration**: Enable browser-based function execution
- **Network Protocols**: Support remote function calls
- **Security Boundaries**: Maintain web application isolation
- **Performance Optimization**: Optimize for network latency

### Success Criteria

#### Phase 1: Runtime Foundation (Week 1-2)
- [ ] WASM runtime loading and executing functions
- [ ] Basic service request framework working
- [ ] Simple hardware service integration
- [ ] Function isolation and sandboxing functional

#### Phase 2: Service Integration (Week 3-4)
- [ ] All hardware services integrated
- [ ] Deadline-based scheduling working
- [ ] Capability system implemented
- [ ] Performance metrics collection

#### Phase 3: Application Framework (Week 5-6)
- [ ] Complete application framework
- [ ] Example applications working
- [ ] Security model fully implemented
- [ ] Performance optimization complete

### Example Applications to Build

#### 1. Image Processing App
```rust
#[funcos_function]
async fn resize_image(
    image: ImageData,
    target_size: (u32, u32),
    deadline: Duration
) -> Result<ImageData, FuncError> {
    let gpu = request_hardware("gpu", deadline).await?;
    gpu.resize_image(image, target_size).await
}
```

#### 2. Data Analysis App
```rust
#[funcos_function]
async fn analyze_dataset(
    data: Dataset,
    algorithm: AnalysisType,
    deadline: Duration
) -> Result<AnalysisResult, FuncError> {
    let compute = request_hardware("compute", deadline).await?;
    let storage = request_hardware("storage", deadline).await?;
    
    let processed = compute.process_data(data, algorithm).await?;
    storage.save_result(processed).await?;
    Ok(processed)
}
```

#### 3. Network Service App
```rust
#[funcos_function]
async fn handle_request(
    request: HttpRequest,
    deadline: Duration
) -> Result<HttpResponse, FuncError> {
    let network = request_hardware("network", deadline).await?;
    let storage = request_hardware("storage", deadline).await?;
    
    let data = storage.load_data(request.path).await?;
    network.send_response(data).await
}
```

### Testing Strategy

#### Unit Tests
- Function execution validation
- Service request testing
- Capability system verification
- Performance measurement

#### Integration Tests
- End-to-end function execution
- Multi-service coordination
- Security boundary testing
- Deadline compliance verification

#### System Tests
- Full application lifecycle
- Hardware compatibility testing
- Stress testing under load
- Security penetration testing

### Performance Targets

#### Execution Performance
- **Function Startup**: <10ms for WASM functions
- **Service Request Latency**: <1ms for local services
- **Memory Overhead**: <1MB per function instance
- **Throughput**: >1000 functions/second per core

#### Resource Management
- **Memory Isolation**: 99.9% isolation effectiveness
- **CPU Scheduling**: <1ms scheduling overhead
- **I/O Performance**: 90% of native performance
- **Network Latency**: <10ms additional overhead

### Deliverables

1. **Runtime Engine** (`app/runtime/`)
   - WASM execution environment
   - Service request framework
   - Execution scheduler
   - Resource management

2. **Application Framework** (`app/framework/`)
   - Function definition APIs
   - Hardware specification DSL
   - Application manifest system
   - Development tools

3. **Security System** (`app/security/`)
   - Capability-based access control
   - Application sandboxing
   - Biometric integration
   - Security policy enforcement

4. **Example Applications** (`dist/`)
   - Image processing demo
   - Data analysis demo
   - Network service demo
   - Performance benchmarks

5. **Documentation** (`docs/`)
   - Developer guide
   - API reference
   - Security model documentation
   - Performance tuning guide

### Timeline

#### Week 1-2: Runtime Foundation
- [ ] WASM runtime implementation
- [ ] Basic service integration
- [ ] Function isolation

#### Week 3-4: Service Framework
- [ ] Complete service integration
- [ ] Deadline scheduling
- [ ] Capability system

#### Week 5-6: Application Layer
- [ ] Application framework
- [ ] Example applications
- [ ] Performance optimization

### Resources

#### Documentation
- [WebAssembly Specification](https://webassembly.github.io/spec/)
- [Capability-Based Security](https://en.wikipedia.org/wiki/Capability-based_security)
- [Microservice Architecture Patterns](https://microservices.io/patterns/)

#### Tools & Libraries
- WebAssembly runtime (Wasmtime/Wasmer)
- Rust for systems programming
- Protocol Buffers for service communication
- Performance profiling tools

This is where applications meet the FuncOS vision - safe, efficient, function-level hardware access!
