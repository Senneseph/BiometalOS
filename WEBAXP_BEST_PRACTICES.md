# 📋 WebAXP Best Practices - Project Biometal

**Critical guidelines to follow for all Project Biometal development to maintain WebAXP compliance**

## 🚨 **CRITICAL VIOLATIONS TO AVOID**

### **❌ Common Mistakes We Made**
1. **Makefile in wrong location** - Put in project root instead of `/build/`
2. **Missing application specifications** - No `/spec/applications/` definitions
3. **Non-idempotent builds** - No dependency tracking or checksum validation
4. **Violating WebAXP structure** - Not following specification-driven development

### **✅ Correct WebAXP Structure**
```
{Project}/
├── spec/                    # ← ALL specifications here
│   ├── api/                # API specifications (OpenAPI 3.0)
│   ├── applications/       # Application specifications
│   ├── systems/           # Target system specifications
│   ├── build.yaml         # Build configuration
│   └── docs.yaml          # Documentation configuration
├── app/                   # Application source code
├── build/                 # ← Build system goes here
│   ├── Makefile          # ← NOT in project root!
│   ├── scripts/          # Build automation scripts
│   └── environment/      # Build environment configs
├── dist/                 # Built artifacts and testing
├── docs/                 # Generated documentation
├── develop/              # Development tools and scripts
├── config/               # Project-specific configuration
├── shared/               # Docker configurations
└── docker-compose.yaml  # Development environment
```

## 📋 **WebAXP Compliance Checklist**

### **✅ Specification-Driven Development**
- [ ] **All APIs defined in `/spec/api/*.yaml`** (OpenAPI 3.0 format)
- [ ] **Application specs in `/spec/applications/*.yaml`**
- [ ] **System specs in `/spec/systems/*.yaml`**
- [ ] **Build configuration in `/spec/build.yaml`**
- [ ] **Documentation config in `/spec/docs.yaml`**

### **✅ Idempotent Build System**
- [ ] **Makefile in `/build/Makefile`** (NOT project root)
- [ ] **Build scripts in `/build/scripts/`**
- [ ] **Dependency tracking with checksums**
- [ ] **Incremental builds when possible**
- [ ] **Cache directories for build artifacts**
- [ ] **Skip builds when no changes detected**

### **✅ Containerized Development**
- [ ] **Docker environment in `/build/environment/`**
- [ ] **docker-compose.yaml in project root**
- [ ] **All development tools containerized**
- [ ] **No local dependencies required**

### **✅ Generated Artifacts**
- [ ] **Documentation generated from specs**
- [ ] **Build configs generated from specs**
- [ ] **API implementations scaffolded from specs**
- [ ] **All generation is reproducible**

## 🔧 **Idempotent Build Requirements**

### **Dependency Tracking**
```yaml
# In spec/build.yaml
artifacts:
  my_artifact:
    dependencies:
      - "spec/api/*.yaml"
      - "app/src/**/*.zig"
      - "build/scripts/build-my-artifact.sh"
    checksum_file: "./build/.my-artifact-checksum"
    idempotent: true
```

### **Build Script Template**
```bash
#!/bin/bash
# WebAXP Idempotent Build Script

# Calculate checksum of all dependencies
calculate_dependencies_checksum() {
    local temp_file=$(mktemp)
    
    # Hash all dependency files
    for dep in "${DEPENDENCY_FILES[@]}"; do
        if [ -f "$dep" ]; then
            sha256sum "$dep" >> "$temp_file"
        elif [ -d "$dep" ]; then
            find "$dep" -type f | sort | xargs sha256sum >> "$temp_file"
        fi
    done
    
    # Include toolchain version
    toolchain_version >> "$temp_file"
    
    sha256sum "$temp_file" | cut -d' ' -f1
    rm -f "$temp_file"
}

# Check if build is needed
check_build_needed() {
    local current_checksum=$(calculate_dependencies_checksum)
    local stored_checksum=""
    
    if [ -f "$CHECKSUM_FILE" ]; then
        stored_checksum=$(cat "$CHECKSUM_FILE")
    fi
    
    if [ "$current_checksum" = "$stored_checksum" ] && [ -f "$OUTPUT_FILE" ]; then
        echo "Build is up-to-date"
        return 1  # Build not needed
    else
        echo "$current_checksum" > "$CHECKSUM_FILE"
        return 0  # Build needed
    fi
}

# Main build function
main() {
    if ! check_build_needed; then
        echo "Build skipped - no changes detected"
        return 0
    fi
    
    # Perform actual build
    do_build
}
```

## 📁 **File Organization Rules**

### **Specifications (`/spec/`)**
- **`/spec/api/`** - OpenAPI 3.0 specifications for all APIs
- **`/spec/applications/`** - Complete application specifications
- **`/spec/systems/`** - Target system and platform specifications
- **`/spec/build.yaml`** - Build system configuration
- **`/spec/docs.yaml`** - Documentation generation configuration

### **Build System (`/build/`)**
- **`/build/Makefile`** - Main build targets (NOT in project root!)
- **`/build/scripts/`** - All build automation scripts
- **`/build/environment/`** - Docker build environments
- **`/build/.build-cache/`** - Build cache directory
- **`/build/.{artifact}-checksum`** - Checksum files for idempotency

### **Source Code (`/app/`)**
- **`/app/src/`** - Application source code
- **`/app/environment/`** - Application runtime environment

### **Generated Content**
- **`/docs/`** - Generated from `/spec/` (never edit manually)
- **`/dist/`** - Built artifacts (never commit to git)

## 🚀 **Development Workflow**

### **1. Start with Specifications**
```bash
# Always start here
cd {Project}/spec/

# Define your application
vim applications/my-app.yaml

# Define APIs
vim api/my-api.yaml

# Define target systems
vim systems/my-target.yaml
```

### **2. Generate from Specifications**
```bash
# From /build/ directory
cd build/
make validate-specs
make generate-docs
make generate-scaffolding
```

### **3. Implement Against Specifications**
```bash
# Implement in /app/src/
cd ../app/src/
# Write code that matches the specifications
```

### **4. Build and Test**
```bash
# From /build/ directory
cd ../build/
make build    # Idempotent build
make test     # Validate against specs
```

## ⚠️ **Common Anti-Patterns to Avoid**

### **❌ Manual File Editing**
- Don't manually edit generated documentation
- Don't manually edit generated build configs
- Don't manually edit generated API stubs

### **❌ Non-Idempotent Builds**
- Don't rebuild when nothing changed
- Don't ignore dependency tracking
- Don't skip checksum validation

### **❌ Wrong File Locations**
- Don't put Makefile in project root
- Don't put build scripts outside `/build/`
- Don't put specifications outside `/spec/`

### **❌ Missing Specifications**
- Don't write code without API specs
- Don't build without application specs
- Don't deploy without system specs

## 🔍 **Validation Commands**

### **Check WebAXP Compliance**
```bash
# Validate project structure
./tools/scripts/validate-webaxp-structure.sh

# Validate specifications
./tools/scripts/validate-api-specs-docker.sh --spec-dir spec/api

# Check build idempotency
cd build/
make clean
make build  # Should build
make build  # Should skip (idempotent)
```

### **Verify Generated Content**
```bash
# Ensure docs are generated from specs
make clean-docs
make docs
git status  # Should show generated files

# Ensure builds are reproducible
make clean
make build
checksum1=$(sha256sum dist/my-artifact)
make clean
make build
checksum2=$(sha256sum dist/my-artifact)
[ "$checksum1" = "$checksum2" ]  # Should be identical
```

## 📚 **Reference Examples**

### **Correct Application Specification**
```yaml
# spec/applications/my-app.yaml
application:
  name: "my-app"
  version: "1.0.0"
  type: "embedded-firmware"
  
architecture:
  pattern: "layered"
  layers:
    - name: "hal"
      depends_on: []
    - name: "kernel"
      depends_on: ["hal"]
      
components:
  kernel:
    source_files:
      - "app/src/kernel/*.zig"
    memory_requirements:
      flash: "64KB"
      sram: "8KB"
      
build:
  dependencies:
    - "spec/api/*.yaml"
    - "app/src/**/*.zig"
  idempotent: true
  checksum_file: "./build/.my-app-checksum"
```

### **Correct Build Configuration**
```yaml
# spec/build.yaml
artifacts:
  my_firmware:
    name: "my-firmware"
    output: "./dist/firmware/my-firmware.hex"
    dependencies:
      - "spec/applications/my-app.yaml"
      - "app/src/**/*.zig"
    build_command: "./build/scripts/build-firmware.sh"
    idempotent: true
    checksum_file: "./build/.firmware-checksum"
    
idempotency:
  enabled: true
  checksum_algorithm: "sha256"
  dependency_tracking: true
  cache_locations:
    - "./build/.build-cache/"
```

## 🎯 **Success Criteria**

A project is WebAXP compliant when:

1. ✅ **All specifications exist** in `/spec/` directories
2. ✅ **Build system is in `/build/`** with Makefile there
3. ✅ **Builds are idempotent** with proper dependency tracking
4. ✅ **Documentation is generated** from specifications
5. ✅ **Development is containerized** with no local dependencies
6. ✅ **Structure follows WebAXP** conventions exactly

## 🚨 **Enforcement**

To prevent future violations:

1. **Add pre-commit hooks** to validate WebAXP structure
2. **Include WebAXP validation** in CI/CD pipelines
3. **Review this document** before starting new projects
4. **Use project templates** that enforce correct structure
5. **Validate during code reviews** that WebAXP is followed

---

**Remember: WebAXP compliance is not optional - it's the foundation that enables specification-driven development and ensures our projects can be developed by AI agents effectively!** 🤖✨
