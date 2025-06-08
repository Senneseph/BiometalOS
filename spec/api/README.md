# FuncOS API Specifications

This directory contains the complete API specifications for Project Biometal's FuncOS - a function-oriented operating system with neural scheduling interface and hardware-aware execution.

## 🎯 API Architecture Overview

FuncOS follows a **layered, service-oriented architecture** where each layer exposes well-defined APIs:

```
┌─────────────────────────────────────────────────────────────┐
│                    Browser Integration                      │
│              (browser-integration.yaml)                    │
├─────────────────────────────────────────────────────────────┤
│                  Application Layer                         │
│                   (core.yaml)                             │
├─────────────────────────────────────────────────────────────┤
│              Service Discovery & Security                  │
│        (service-discovery.yaml, security-capabilities.yaml)│
├─────────────────────────────────────────────────────────────┤
│                Neural Data Interface                       │
│                  (neural.yaml)                            │
├─────────────────────────────────────────────────────────────┤
│               Hardware Abstraction                         │
│                 (hardware.yaml)                           │
└─────────────────────────────────────────────────────────────┘
```

## 📋 API Specifications

### Core System APIs

#### [`core.yaml`](./core.yaml) - FuncOS Core API
**Purpose**: Function management, execution, scheduling, and memory management
- **Function Management**: Register, execute, and manage functions
- **Scheduler Interface**: Neural-driven scheduling and queue management  
- **Memory Management**: Memory allocation and status monitoring
- **Introspection**: Execution traces for neural interface training

**Key Endpoints**:
- `POST /functions` - Register new functions
- `POST /functions/{id}/execute` - Execute functions
- `GET /scheduler/status` - Get scheduler status
- `GET /introspection/traces` - Get execution traces

#### [`service-discovery.yaml`](./service-discovery.yaml) - Service Discovery API
**Purpose**: Service registration, discovery, and capability management
- **Service Registration**: Dynamic service registration and updates
- **Capability Discovery**: Find services by capabilities
- **Health Monitoring**: Service health checks and metrics
- **Service Level Agreements**: Deadline-driven service contracts

**Key Endpoints**:
- `POST /services` - Register services
- `POST /discover` - Discover services by capabilities
- `GET /services/{id}/health` - Check service health
- `POST /sla` - Create service level agreements

#### [`security-capabilities.yaml`](./security-capabilities.yaml) - Security & Capability Management API
**Purpose**: Capability-based access control and security management
- **Capability Management**: System capability definitions and access
- **Access Control**: Fine-grained permission management
- **Security Policies**: Policy-based security enforcement
- **Audit & Monitoring**: Security event logging and monitoring

**Key Endpoints**:
- `GET /capabilities` - List system capabilities
- `POST /access/request` - Request capability access
- `POST /policies` - Create security policies
- `GET /audit/events` - Get security audit events

### Hardware & Performance APIs

#### [`hardware.yaml`](./hardware.yaml) - Hardware Abstraction API
**Purpose**: Hardware discovery, optimization, and performance monitoring
- **Hardware Discovery**: CPU, memory, and system topology detection
- **Execution Actualizer**: Hardware-specific function optimization
- **Performance Monitoring**: Hardware performance counters and profiling

**Key Endpoints**:
- `GET /discovery` - Discover hardware capabilities
- `POST /actualizer/optimize` - Request function optimization
- `GET /performance/counters` - Get performance counters
- `POST /performance/profile` - Start performance profiling

#### [`neural.yaml`](./neural.yaml) - Neural Interface API
**Purpose**: AI-driven scheduling, optimization hints, and function-level training
- **Training Data Collection**: Function execution data for neural networks
- **Optimization Hints**: AI-generated optimization recommendations
- **Scheduling Interface**: Neural-driven scheduling predictions
- **Model Management**: Neural model status and management

**Key Endpoints**:
- `POST /training/functions` - Submit training data
- `POST /optimization/hints` - Request optimization hints
- `POST /scheduling/predict` - Get scheduling predictions
- `GET /models` - List available neural models

### Browser & Web Integration APIs

#### [`browser-integration.yaml`](./browser-integration.yaml) - Browser Integration API
**Purpose**: Secure browser-to-hardware access via WebAXP network API
- **WebAXP Network API**: Hardware capabilities for web applications
- **Sandbox Management**: Isolated execution environments
- **Security & Permissions**: Web application permission management
- **Function Execution Bridge**: Execute FuncOS functions from web apps

**Key Endpoints**:
- `GET /webaxp/capabilities` - Get web-accessible capabilities
- `POST /webaxp/request` - Request hardware access
- `POST /sandbox` - Create browser sandbox
- `POST /execute` - Execute functions from web apps

## 🔧 API Design Principles

### 1. **Consistency**
- Uniform naming conventions (kebab-case for paths, PascalCase for schemas)
- Consistent error handling and response formats
- Standard authentication and authorization patterns

### 2. **Service-Oriented**
- Each hardware component exposed as independent service
- Clear service boundaries and responsibilities
- Discoverable and self-describing services

### 3. **Deadline-Driven**
- All requests include deadline specifications
- Service-level agreements for response times
- Graceful degradation for missed deadlines

### 4. **Security-First**
- Capability-based access control
- Fine-grained permissions for hardware access
- Secure by default configurations

### 5. **Observable**
- Comprehensive logging and metrics
- Distributed tracing support
- Performance monitoring integration

## 🛠️ Development Tools

### Validation
```bash
# Validate all API specifications
./develop/scripts/validate-api-specs.sh

# Validate with verbose output
./develop/scripts/validate-api-specs.sh --verbose
```

### Documentation Generation
```bash
# Generate HTML documentation
./develop/scripts/generate-api-docs.sh --format html

# Generate all formats and serve locally
./develop/scripts/generate-api-docs.sh --format all --serve
```

### Testing
```bash
# Run API contract tests
docker-compose run --rm test

# Generate mock services for testing
./develop/scripts/generate-mocks.sh
```

## 📊 API Metrics & Monitoring

All APIs include built-in observability:

- **Request/Response Logging**: Structured logging for all API calls
- **Performance Metrics**: Response times, throughput, error rates
- **Health Checks**: Standardized health check endpoints
- **Distributed Tracing**: OpenTelemetry-compatible tracing

## 🔗 Integration Points

### With FuncOS-Core
- **Service Implementation**: APIs define service contracts
- **IPC Protocols**: Specify inter-service communication
- **Security Model**: Define capability and permission systems

### With Function-Execution-Model
- **Application APIs**: Define how apps request services
- **Runtime Integration**: Specify execution environment
- **Resource Management**: Define resource allocation APIs

### With Neural-Data-Interface
- **Data Collection**: Specify monitoring and metrics APIs
- **Performance Tracking**: Define performance measurement
- **ML Integration**: Specify neural network interfaces

### With Browser-Network-API
- **Web Integration**: Define browser-to-hardware APIs
- **Network Protocols**: Specify communication protocols
- **Security Boundaries**: Define web application limits

## 📝 Contributing

When adding or modifying API specifications:

1. **Follow OpenAPI 3.0 standards**
2. **Validate specifications** using provided tools
3. **Update documentation** and examples
4. **Ensure backward compatibility** or provide migration guides
5. **Add appropriate tests** and mock implementations

## 🔍 Quick Reference

| API | Purpose | Key Features |
|-----|---------|--------------|
| Core | Function execution & management | Neural scheduling, memory management |
| Service Discovery | Service registration & discovery | Capability-based discovery, SLAs |
| Security | Access control & security | Capability-based permissions, audit |
| Hardware | Hardware abstraction & optimization | Performance monitoring, optimization |
| Neural | AI-driven optimization & scheduling | Training data collection, ML hints |
| Browser | Web application integration | Secure hardware access, sandboxing |

For detailed API documentation, see the individual specification files or generate documentation using the provided tools.
