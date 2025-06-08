# Agent Instruction Template

## Project: [PROJECT_NAME]

### Overview
[Brief description of the sub-project and its role in the FuncOS/Project Biometal architecture]

### Architecture Context
This project is part of the layered FuncOS/Project Biometal architecture:
1. **FuncOS**: Hardware abstraction OS providing safe hardware access
2. **Project Biometal**: Neural data collection from hardware interactions
3. **Application Layer**: Function-level hardware requests via service APIs
4. **Browser Ecosystem**: WebAXP network API for hardware access

### Objectives
- [ ] Primary objective 1
- [ ] Primary objective 2
- [ ] Primary objective 3

### Prerequisites
- ZealOS build foundation completed
- BiometalOS development environment available
- Understanding of WebAXP methodology

### Project Structure (WebAXP Compliant)
```
[PROJECT_NAME]/
├── spec/           # API specifications and documentation
├── app/            # Source code implementation
├── build/          # Build scripts and configuration
├── dist/           # Distribution artifacts
├── docs/           # Generated documentation
├── develop/        # Development tools and scripts
└── config/         # Project configuration
```

### Setup Instructions

1. **Initialize Project Structure**
   ```bash
   mkdir -p [PROJECT_NAME]/{spec,app,build,dist,docs,develop,config}
   cd [PROJECT_NAME]
   ```

2. **Configure WebAXP Environment**
   ```bash
   # Copy shared configuration template
   cp ../BiometalOS/shared/docker-compose.template.yaml ./docker-compose.yaml
   
   # Create project configuration
   cat > config/webaxp.yaml << EOF
   project:
     name: "[PROJECT_NAME]"
     type: "[PROJECT_TYPE]"
     description: "[PROJECT_DESCRIPTION]"
   
   build:
     toolchain: "[TOOLCHAIN]"
     target_arch: "x86_64"
     commands:
       - "./develop/scripts/build.sh"
   
   features:
     - "[FEATURE1]"
     - "[FEATURE2]"
   EOF
   ```

3. **Set Environment Variables**
   ```bash
   export PROJECT_NAME="[PROJECT_NAME]"
   export PROJECT_TYPE="[PROJECT_TYPE]"
   export TOOLCHAIN="[TOOLCHAIN]"
   ```

### Development Workflow

1. **Start Development Environment**
   ```bash
   docker-compose run --rm dev
   ```

2. **Build Project**
   ```bash
   docker-compose run --rm build
   ```

3. **Run Tests**
   ```bash
   docker-compose run --rm test
   ```

4. **Generate Documentation**
   ```bash
   docker-compose run --rm docs
   ```

### Integration Points

#### With ZealOS Foundation
- [Specific integration requirements]
- [API dependencies]
- [Data flow requirements]

#### With Other Sub-Projects
- [Cross-project dependencies]
- [Shared interfaces]
- [Communication protocols]

### Success Criteria

#### Phase 1: Foundation
- [ ] WebAXP structure established
- [ ] Basic build system working
- [ ] Core APIs specified

#### Phase 2: Implementation
- [ ] Core functionality implemented
- [ ] Integration tests passing
- [ ] Documentation generated

#### Phase 3: Integration
- [ ] ZealOS integration working
- [ ] Cross-project interfaces functional
- [ ] Performance benchmarks met

### Deliverables

1. **Specifications** (`spec/`)
   - API definitions (OpenAPI 3.0)
   - System architecture documentation
   - Integration specifications

2. **Implementation** (`app/`)
   - Core source code
   - Configuration files
   - Resource definitions

3. **Build System** (`build/`)
   - Build scripts
   - Dependency management
   - Deployment configuration

4. **Documentation** (`docs/`)
   - API documentation
   - User guides
   - Integration examples

5. **Development Tools** (`develop/`)
   - Build scripts
   - Test utilities
   - Development helpers

### Testing Strategy

#### Unit Tests
- [Unit testing requirements]
- [Test framework selection]
- [Coverage targets]

#### Integration Tests
- [Integration testing approach]
- [Cross-project test scenarios]
- [Performance benchmarks]

#### System Tests
- [End-to-end testing]
- [Hardware compatibility]
- [Stress testing]

### Timeline

#### Week 1: Setup & Specification
- [ ] Project structure established
- [ ] Core APIs specified
- [ ] Build system configured

#### Week 2: Core Implementation
- [ ] Basic functionality implemented
- [ ] Unit tests written
- [ ] Integration points identified

#### Week 3: Integration & Testing
- [ ] ZealOS integration completed
- [ ] Cross-project interfaces implemented
- [ ] System tests passing

#### Week 4: Documentation & Handoff
- [ ] Documentation completed
- [ ] Performance benchmarks established
- [ ] Handoff to next phase

### Resources

#### Documentation
- [Relevant documentation links]
- [API references]
- [Architecture guides]

#### Tools & Libraries
- [Required tools]
- [Recommended libraries]
- [Development utilities]

#### Communication
- [Project communication channels]
- [Status reporting requirements]
- [Escalation procedures]

### Notes

#### Architecture Considerations
- [Important architectural decisions]
- [Design constraints]
- [Performance requirements]

#### Risk Mitigation
- [Identified risks]
- [Mitigation strategies]
- [Contingency plans]

#### Future Considerations
- [Planned enhancements]
- [Scalability requirements]
- [Maintenance considerations]
