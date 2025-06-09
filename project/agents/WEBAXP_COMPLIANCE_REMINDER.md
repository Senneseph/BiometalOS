# 🚨 WebAXP Compliance Reminder for AI Agents

**CRITICAL: Read this before working on any Project Biometal component**

## ⚠️ **STOP! Check These First**

Before making ANY changes to Project Biometal, verify:

### **✅ File Structure Compliance**
- [ ] Makefile is in `/build/Makefile` (NOT project root)
- [ ] Build scripts are in `/build/scripts/`
- [ ] Application specs exist in `/spec/applications/`
- [ ] All APIs are defined in `/spec/api/`
- [ ] System specs are in `/spec/systems/`

### **✅ Build System Compliance**
- [ ] Builds are idempotent (skip when no changes)
- [ ] Dependency tracking with checksums
- [ ] Cache directories for build artifacts
- [ ] Proper error handling and logging

### **✅ Specification-Driven Development**
- [ ] Start with specifications in `/spec/`
- [ ] Generate documentation from specs
- [ ] Scaffold code from API definitions
- [ ] Never manually edit generated content

## 🚨 **Common Violations We Made**

### **❌ WRONG: Makefile in Project Root**
```
FuncOS/
├── Makefile          # ← WRONG LOCATION!
├── spec/
├── app/
└── build/
```

### **✅ CORRECT: Makefile in Build Directory**
```
FuncOS/
├── spec/
├── app/
├── build/
│   ├── Makefile      # ← CORRECT LOCATION!
│   └── scripts/
└── dist/
```

### **❌ WRONG: Missing Application Specs**
```
FuncOS/spec/
├── api/              # ← Only API specs
│   ├── core.yaml
│   └── hardware.yaml
└── build.yaml
```

### **✅ CORRECT: Complete Specifications**
```
FuncOS/spec/
├── api/              # API specifications
│   ├── core.yaml
│   └── hardware.yaml
├── applications/     # ← Application specifications
│   └── funcos-demo.yaml
├── systems/          # System specifications
│   ├── x86_64.yaml
│   └── arduino.yaml
├── build.yaml        # Build configuration
└── docs.yaml         # Documentation config
```

### **❌ WRONG: Non-Idempotent Build**
```bash
#!/bin/bash
# Always rebuilds everything
rm -rf dist/
mkdir -p dist/
zig build
```

### **✅ CORRECT: Idempotent Build**
```bash
#!/bin/bash
# Check if build needed
if ! check_build_needed; then
    echo "Build skipped - no changes"
    return 0
fi

# Only build when needed
zig build
```

## 📋 **Pre-Work Checklist**

Before starting ANY development task:

### **1. Verify Project Structure**
```bash
# Check if Makefile is in correct location
if [ -f "Makefile" ]; then
    echo "❌ VIOLATION: Makefile in project root!"
    echo "✅ MOVE TO: build/Makefile"
fi

# Check for application specs
if [ ! -d "spec/applications" ]; then
    echo "❌ VIOLATION: Missing spec/applications/"
    echo "✅ CREATE: Application specifications"
fi
```

### **2. Validate WebAXP Compliance**
```bash
# Use shared validation tools
../tools/scripts/validate-webaxp-structure.sh
../tools/scripts/validate-api-specs-docker.sh --spec-dir spec/api
```

### **3. Check Build Idempotency**
```bash
cd build/
make clean
make build  # Should build
make build  # Should skip with "no changes" message
```

## 🛠️ **Fixing Common Issues**

### **Fix 1: Move Makefile to Correct Location**
```bash
# If Makefile exists in project root
if [ -f "Makefile" ]; then
    mkdir -p build/
    mv Makefile build/Makefile
    echo "✅ Moved Makefile to build/ directory"
fi
```

### **Fix 2: Create Missing Application Spec**
```bash
# Create application specification
mkdir -p spec/applications/
cat > spec/applications/my-app.yaml << 'EOF'
application:
  name: "my-app"
  version: "0.1.0"
  description: "Application description"
  type: "application-type"
  
architecture:
  pattern: "layered"
  layers:
    - name: "layer1"
      components: ["component1"]
      
components:
  component1:
    source_files:
      - "app/src/**/*.zig"
    dependencies:
      - "spec/api/*.yaml"
      
build:
  idempotent: true
  dependencies:
    - "spec/api/*.yaml"
    - "app/src/**/*.zig"
  checksum_file: "./build/.my-app-checksum"
EOF
```

### **Fix 3: Make Build Script Idempotent**
```bash
# Add to build script
CHECKSUM_FILE="./build/.build-checksum"
DEPENDENCY_FILES=(
    "spec/api/*.yaml"
    "app/src/**/*.zig"
    "${BASH_SOURCE[0]}"
)

calculate_dependencies_checksum() {
    local temp_file=$(mktemp)
    for dep in "${DEPENDENCY_FILES[@]}"; do
        find $dep -type f 2>/dev/null | sort | xargs sha256sum >> "$temp_file"
    done
    sha256sum "$temp_file" | cut -d' ' -f1
    rm -f "$temp_file"
}

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
```

## 🎯 **Quick Validation Commands**

### **Structure Check**
```bash
# Verify WebAXP structure
ls -la | grep -E "(spec|app|build|dist|docs|develop|config)"

# Check Makefile location
[ -f "build/Makefile" ] && echo "✅ Makefile in correct location" || echo "❌ Makefile missing or wrong location"

# Check application specs
[ -d "spec/applications" ] && echo "✅ Application specs directory exists" || echo "❌ Missing spec/applications/"
```

### **Build System Check**
```bash
cd build/
make clean
time make build  # Should build
time make build  # Should be fast (idempotent)
```

### **Specification Check**
```bash
# Validate API specifications
../tools/scripts/validate-api-specs-docker.sh --spec-dir spec/api

# Check for required files
for file in spec/build.yaml spec/docs.yaml; do
    [ -f "$file" ] && echo "✅ $file exists" || echo "❌ $file missing"
done
```

## 📚 **Reference Documentation**

- **WebAXP Best Practices**: `../WEBAXP_BEST_PRACTICES.md`
- **Project Structure**: `../README.md`
- **API Validation**: `../tools/scripts/validate-api-specs-docker.sh`
- **Build Templates**: `../shared/webaxp-base/`

## 🚀 **When in Doubt**

1. **Check existing compliant projects** for reference
2. **Validate with shared tools** before committing
3. **Ask for clarification** rather than guessing
4. **Document any new patterns** for future reference

## ⚡ **Quick Fix Script**

```bash
#!/bin/bash
# Quick WebAXP compliance fix

# Move Makefile if in wrong location
[ -f "Makefile" ] && mkdir -p build/ && mv Makefile build/

# Create missing directories
mkdir -p spec/applications spec/systems build/scripts

# Create basic application spec if missing
if [ ! -f "spec/applications/$(basename $(pwd)).yaml" ]; then
    cat > "spec/applications/$(basename $(pwd)).yaml" << EOF
application:
  name: "$(basename $(pwd))"
  version: "0.1.0"
  description: "Generated application specification"
  
build:
  idempotent: true
  dependencies:
    - "spec/api/*.yaml"
    - "app/src/**/*"
  checksum_file: "./build/.$(basename $(pwd))-checksum"
EOF
fi

echo "✅ Basic WebAXP compliance fixes applied"
```

---

**REMEMBER: WebAXP compliance is mandatory for all Project Biometal development. When in doubt, check this document and the best practices guide!** 🤖✨
