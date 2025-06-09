# 🤖 Contributing Guide for AI Agents - Project Biometal

**Multi-Project Architecture | Specification-Driven Development | Parallel Agent Collaboration**

This guide provides AI agents with everything needed to contribute effectively to Project Biometal's multi-project ecosystem while avoiding conflicts and maintaining quality standards.

## 🏗️ **Repository Architecture Overview**

Project Biometal uses a **multi-project architecture** with **4 independent projects**:

```
BiometalOS/
├── FuncOS/         # 🔧 Function-oriented operating system (ZealOS foundation)
├── Nerv/           # 🧠 Minimal microkernel (Mach/Hurd inspired)
├── Biometal/       # 📊 Reporting & benchmarking layer (neural data collection)
├── IFLib/          # 📚 Intermediate Form Library (function specs & browser integration)
├── project/        # 📋 Cross-project management and tickets
├── tools/          # 🛠️ Shared development utilities
└── spec/           # 📖 High-level project documentation
```

### **🎯 Core Principle: Independent Projects, Shared Quality**
- **Each project is completely self-contained** with full WebAXP structure
- **Agents can work independently** on different projects without conflicts
- **Shared tools ensure quality** and consistency across all projects
- **Cross-project coordination** happens through `/project/` management

## 📋 **Project Management System (`/project/`)**

### **Directory Structure**
```
project/
├── next/           # 🟢 Active tickets ready for development
├── done/           # ✅ Completed tickets and summaries
├── agents/         # 🤖 Agent configurations and coordination
├── README.md       # Project management overview
└── *.md           # Project management documentation
```

### **Ticket Lifecycle**
1. **Tickets start in `/project/next/`** - Ready for agent assignment
2. **Agents claim tickets** by working on them and documenting progress
3. **Completed work moves to `/project/done/`** with summary documentation
4. **Cross-project coordination** through ticket updates and summaries

### **Ticket Format**
All tickets follow this structure:
```markdown
# 🎫 TICKET: {Title}

**Ticket ID**: {YYYYMMDD-ticket-name}
**Project**: {FuncOS|Nerv|Biometal|IFLib}
**Status**: 🟢 READY TO START | 🟡 IN PROGRESS | ✅ COMPLETED
**Priority**: HIGH | MEDIUM | LOW
**Assignee**: {Agent Name}
**Dependencies**: {Other tickets or components}

### Overview
{Clear description of what needs to be accomplished}

### Objectives
- [ ] {Specific, measurable objectives}

### Success Criteria
- [ ] {Clear criteria for completion}
```

## 🔧 **Project-Specific Development**

### **Choose Your Project**
Each project has distinct focus and can be developed independently:

#### **🔧 FuncOS** - Function-Oriented Operating System
- **Focus**: Core OS, ZealOS integration, hardware abstraction
- **APIs**: `core.yaml`, `hardware.yaml`, `service-discovery.yaml`, `security-capabilities.yaml`
- **Priority**: **HIGH** - ZealOS integration is critical foundation
- **Commands**: `make zealos-setup`, `make zealos-build`, `make profile`

#### **🧠 Nerv** - Minimal Microkernel
- **Focus**: Microkernel design, IPC, Mach/Hurd architecture
- **APIs**: Kernel, IPC, memory management (to be created)
- **Priority**: HIGH - Foundation for FuncOS
- **Commands**: `make kernel-build`, `make kernel-test`, `make ipc-test`

#### **📊 Biometal** - Reporting & Benchmarking Layer
- **Focus**: Neural data collection, ML integration, performance analysis
- **APIs**: `neural.yaml` (data collection, ML integration)
- **Priority**: MEDIUM - Depends on FuncOS basic functionality
- **Commands**: `make collect-data`, `make train-model`, `make benchmark`

#### **📚 IFLib** - Intermediate Form Library
- **Focus**: Function specifications, browser integration, optimization
- **APIs**: `browser-integration.yaml` (WebAXP network API)
- **Priority**: MEDIUM - Function specs and browser integration
- **Commands**: `make validate-specs`, `make optimize-funcs`, `make webaxp-test`

### **Standard Development Workflow**
```bash
# 1. Choose a project
cd {FuncOS|Nerv|Biometal|IFLib}

# 2. Standard development commands (available in all projects)
make setup      # Initialize development environment
make validate   # Validate API specifications
make build      # Build project components
make test       # Run test suite
make docs       # Generate documentation
make dev        # Start development environment
make clean      # Clean build artifacts

# 3. Use project-specific commands as needed
```

## 🛠️ **Shared Tools and Quality Assurance**

### **Validation Tools** (`/tools/scripts/`)
```bash
# Validate API specifications for any project
./tools/scripts/validate-api-specs-docker.sh --spec-dir {Project}/spec/api

# Generate documentation
./tools/scripts/generate-api-docs.sh --spec-dir {Project}/spec/api --format html

# Cross-project validation
for project in FuncOS Nerv Biometal IFLib; do
  ./tools/scripts/validate-api-specs-docker.sh --spec-dir $project/spec/api
done
```

### **Quality Standards**
- **Always validate APIs** before committing changes
- **Follow WebAXP conventions** in all projects
- **Use specification-driven development** - start with `/spec`
- **Document all changes** with clear commit messages
- **Test thoroughly** using project-specific test suites

## 🤝 **Parallel Agent Collaboration**

### **Avoiding Conflicts**
1. **Work on different projects** - Each project is independent
2. **Claim tickets clearly** - Update ticket status when starting work
3. **Use project-specific branches** - `feature/{project}-{ticket-name}`
4. **Coordinate through tickets** - Update progress and dependencies
5. **Validate before committing** - Use shared validation tools

### **Communication Protocol**
```markdown
# When starting work on a ticket:
**Status**: 🟡 IN PROGRESS
**Assignee**: {Your Agent Name}
**Started**: {Date}
**Estimated Completion**: {Date}

# When completing work:
**Status**: ✅ COMPLETED
**Completed**: {Date}
**Summary**: {Brief summary of work completed}
**Files Changed**: {List of key files}
**Next Steps**: {Any follow-up work needed}
```

### **Branch Naming Convention**
```bash
# Project-specific feature branches
feature/funcos-zealos-integration
feature/nerv-ipc-optimization
feature/biometal-data-collection
feature/iflib-browser-integration

# Cross-project coordination
feature/multi-project-{description}
```

## 📋 **Specification-Driven Development**

### **Always Start with `/spec`**
1. **Review existing specifications** in `{Project}/spec/api/`
2. **Understand project architecture** from project README.md
3. **Follow WebAXP conventions** - `/spec → /docs → /app → /build → /dist`
4. **Validate specifications** before implementation
5. **Generate documentation** from specifications

### **API Development Workflow**
```bash
# 1. Design or update API specifications
edit {Project}/spec/api/{api-name}.yaml

# 2. Validate specifications
./tools/scripts/validate-api-specs-docker.sh --spec-dir {Project}/spec/api

# 3. Generate documentation
./tools/scripts/generate-api-docs.sh --spec-dir {Project}/spec/api --format html

# 4. Implement according to specifications
# 5. Test implementation against specifications
# 6. Document and commit changes
```

## 🎯 **Current Priorities and Dependencies**

### **HIGH PRIORITY: ZealOS Integration (FuncOS)**
- **Critical foundation** for all other development
- **Blocks**: Most FuncOS development, some Nerv integration
- **Ticket**: `20241215-zealos-integration-ticket.md`
- **Repository**: https://github.com/Senneseph/ZealOS

### **Development Dependencies**
```
ZealOS Integration (FuncOS) → FuncOS Core → Biometal Data Collection
                           ↘ Nerv Integration → Advanced Features
                           ↘ IFLib Function Specs → Browser Integration
```

### **Parallel Development Opportunities**
- **Nerv microkernel design** - Independent of ZealOS
- **IFLib function specifications** - Can proceed independently
- **Biometal framework design** - Can design while waiting for FuncOS
- **Documentation and specifications** - Always available

## 🔍 **Debugging and Troubleshooting**

### **Common Issues**
1. **API validation failures** - Check YAML syntax and OpenAPI compliance
2. **Build failures** - Ensure Docker is available and project setup is complete
3. **Merge conflicts** - Work on different projects or coordinate through tickets
4. **Missing dependencies** - Check project-specific requirements

### **Getting Help**
1. **Check project README.md** for project-specific guidance
2. **Review existing tickets** in `/project/next/` and `/project/done/`
3. **Validate your work** using shared tools before asking for help
4. **Document issues** in ticket updates for other agents

## ✅ **Success Checklist for Agents**

### **Before Starting Work**
- [ ] Choose appropriate project based on expertise and priorities
- [ ] Review project README.md and architecture
- [ ] Check `/project/next/` for available tickets
- [ ] Claim ticket by updating status and assignee
- [ ] Understand dependencies and integration points

### **During Development**
- [ ] Follow specification-driven development workflow
- [ ] Use project-specific development commands
- [ ] Validate APIs and specifications regularly
- [ ] Test thoroughly using project test suites
- [ ] Document progress in ticket updates

### **Before Completing Work**
- [ ] Validate all API specifications
- [ ] Generate and review documentation
- [ ] Run complete test suite
- [ ] Update ticket with completion status and summary
- [ ] Move completed ticket to `/project/done/`
- [ ] Create pull request with comprehensive description

## 🚀 **Getting Started**

### **Quick Start for New Agents**
```bash
# 1. Understand the architecture
cat README.md
cat CONTRIBUTING.md

# 2. Review available work
ls project/next/

# 3. Choose a project and ticket
cd {FuncOS|Nerv|Biometal|IFLib}
cat README.md

# 4. Set up development environment
make setup

# 5. Start development
make dev
```

### **First Contribution Workflow**
1. **Pick a ticket** from `/project/next/` that matches your capabilities
2. **Update ticket status** to indicate you're working on it
3. **Create feature branch** following naming conventions
4. **Follow specification-driven development** workflow
5. **Use shared validation tools** throughout development
6. **Complete ticket** with summary and move to `/project/done/`
7. **Create pull request** with comprehensive description

## 🔐 **Security and Best Practices**

### **Repository Security**
- **Never commit sensitive information** (API keys, passwords, personal data)
- **Use environment variables** for configuration
- **Follow principle of least privilege** in all implementations
- **Validate all inputs** and sanitize outputs
- **Document security considerations** in specifications

### **Code Quality Standards**
- **Write clear, self-documenting code** with appropriate comments
- **Follow project-specific coding conventions** (see project README.md)
- **Include comprehensive error handling** and logging
- **Write tests for all new functionality**
- **Use meaningful commit messages** following conventional commits

### **Performance Considerations**
- **Profile and benchmark** new implementations
- **Consider resource constraints** (memory, CPU, I/O)
- **Optimize for target architectures** when relevant
- **Document performance characteristics** in specifications
- **Use appropriate data structures** and algorithms

## 📚 **Learning Resources**

### **Project-Specific Documentation**
- **FuncOS**: `FuncOS/README.md` - Function-oriented OS concepts
- **Nerv**: `Nerv/README.md` - Microkernel architecture principles
- **Biometal**: `Biometal/README.md` - Neural data collection and ML integration
- **IFLib**: `IFLib/README.md` - Function specifications and optimization

### **Architecture Documentation**
- **`spec/BIG_PICTURE.md`** - Overall project vision and goals
- **`spec/FuncOS_OUTLINE.md`** - FuncOS concepts and design
- **`spec/PROJECT_SKETCH.md`** - Project architecture overview
- **`spec/WEBAXP_OUTLINE.md`** - WebAXP conventions and standards
- **`spec/ZEALOS_CONVERSION.md`** - ZealOS integration notes

### **WebAXP Conventions**
- **Specification-first development** - Always start with API specs
- **Containerized environments** - Use Docker for all development
- **Validation-driven quality** - Validate early and often
- **Documentation generation** - Auto-generate from specifications
- **Cross-platform compatibility** - Support multiple architectures

## 🎭 **Agent Personas and Specializations**

### **Recommended Agent Specializations**
Different agents can focus on different aspects based on their strengths:

#### **🏗️ Systems Architecture Agent**
- **Focus**: FuncOS, Nerv microkernel design
- **Skills**: Operating systems, kernel development, hardware abstraction
- **Tickets**: ZealOS integration, microkernel implementation, hardware profiling

#### **🧠 Machine Learning Agent**
- **Focus**: Biometal neural data collection and analysis
- **Skills**: ML/AI, data analysis, performance optimization
- **Tickets**: Neural data interface, ML model training, optimization algorithms

#### **🌐 Web Integration Agent**
- **Focus**: IFLib browser integration and WebAXP API
- **Skills**: Web technologies, browser APIs, network protocols
- **Tickets**: Browser network API, WebAXP implementation, function specifications

#### **📋 Specification Agent**
- **Focus**: API design, documentation, validation
- **Skills**: API design, technical writing, validation tools
- **Tickets**: API specification creation, documentation generation, validation improvements

#### **🔧 DevOps Agent**
- **Focus**: Build systems, CI/CD, tooling
- **Skills**: Docker, build automation, testing frameworks
- **Tickets**: Build system improvements, testing infrastructure, deployment automation

### **Cross-Agent Collaboration Patterns**
- **Specification handoffs** - Spec agents create APIs, implementation agents build them
- **Integration testing** - Multiple agents coordinate on integration points
- **Code reviews** - Agents review each other's work through pull requests
- **Knowledge sharing** - Document learnings in ticket summaries

## 🚨 **Emergency Procedures**

### **If You Break Something**
1. **Don't panic** - The multi-project architecture limits blast radius
2. **Identify scope** - Which project is affected?
3. **Revert changes** - Use git to revert to last known good state
4. **Document the issue** - Update ticket with what went wrong
5. **Ask for help** - Create issue ticket for other agents

### **Conflict Resolution**
1. **Check if it's a real conflict** - Different projects shouldn't conflict
2. **Communicate through tickets** - Update status and coordinate
3. **Use feature branches** - Isolate work until ready to merge
4. **Validate before merging** - Use shared validation tools
5. **Document resolution** - Help future agents avoid same issues

### **Rollback Procedures**
```bash
# Rollback to previous commit
git reset --hard HEAD~1

# Rollback specific files
git checkout HEAD~1 -- {file-path}

# Create rollback branch for investigation
git checkout -b rollback-investigation {commit-hash}
```

## 📈 **Metrics and Success Tracking**

### **Project Health Indicators**
- **API validation success rate** - Should be 100%
- **Build success rate** - Should be >95%
- **Test coverage** - Aim for >80% in critical components
- **Documentation completeness** - All APIs should have docs
- **Ticket completion rate** - Track velocity and quality

### **Quality Metrics**
- **Specification compliance** - All implementations match specs
- **Cross-project integration** - Clean interfaces between projects
- **Performance benchmarks** - Meet or exceed performance targets
- **Security compliance** - No security vulnerabilities
- **Code maintainability** - Clear, well-documented code

### **Reporting Progress**
```markdown
# Weekly Progress Template (add to ticket updates)
## Week of {Date}
### Completed
- [ ] {Specific accomplishments}

### In Progress
- [ ] {Current work items}

### Blocked
- [ ] {Blockers and dependencies}

### Next Week
- [ ] {Planned work}

### Metrics
- API Validation: {Pass/Fail}
- Build Status: {Pass/Fail}
- Tests: {X/Y passing}
- Documentation: {Complete/Incomplete}
```

---

**Welcome to Project Biometal! This multi-project architecture enables efficient, parallel development while maintaining quality and avoiding conflicts. Start with specifications, work independently on focused projects, and coordinate through the ticket system for maximum productivity.** 🎯

**Remember: When in doubt, validate early, document thoroughly, and communicate through tickets. The architecture is designed to support parallel development - use it to your advantage!** 🚀
