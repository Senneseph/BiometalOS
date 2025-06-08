# Agent Workflow Instructions

## Overview

This document provides comprehensive workflow instructions for agents working on FuncOS/Project Biometal tickets. Follow this process to ensure consistent, high-quality development that integrates seamlessly with the overall architecture.

## Core Principles

### 1. Specification-First Development
- **Always start from `/spec`** in your project
- Evaluate existing specifications before any implementation
- Update specifications before creating implementation
- Use specifications as source of truth for all subsystems

### 2. WebAXP Methodology
- `/spec` drives everything else
- `/docs`, `/build`, `/app`, `/dist` are generated from specifications
- Tools extract details from `/spec` to avoid transcription errors
- No LLM necessary for spec-to-implementation translation

### 3. Ticket-Driven Workflow
- Update tickets throughout development lifecycle
- Prepare tickets for merge request review
- Document all changes and decisions in tickets

## Workflow Steps

### Phase 1: Ticket Preparation

#### 1.1 Claim Your Ticket
```bash
# Move ticket from /project/next to /project/in-progress
mv project/next/YYYYMMDD-your-project-ticket.md project/in-progress/

# Update ticket status
# Change: Status: 🟢 READY TO START
# To:     Status: 🔄 IN PROGRESS
```

#### 1.2 Create Agent Status File
```bash
# Create your agent status file
cp project/agents/agent-api-team.md project/agents/agent-[your-team].md

# Update with your project details:
# - Current assignment
# - Team composition
# - Progress tracking
# - Coordination requirements
```

### Phase 2: Specification Analysis

#### 2.1 Start from `/spec`
```bash
cd [YourProject]/spec/

# Evaluate existing specifications:
# - What APIs are already defined?
# - What interfaces need to be created?
# - What integration points exist?
# - What's missing or incomplete?
```

#### 2.2 Specification Evaluation Checklist
- [ ] **API Definitions**: Are all required APIs specified?
- [ ] **Data Schemas**: Are data structures defined?
- [ ] **Integration Points**: Are cross-project interfaces clear?
- [ ] **Security Model**: Are security requirements specified?
- [ ] **Performance SLAs**: Are performance targets defined?
- [ ] **Testing Criteria**: Are success criteria measurable?

#### 2.3 Update Specifications
```bash
# Add missing specifications
# Update existing specifications
# Document new requirements
# Validate with OpenAPI 3.0 tools

# Example specification update:
./develop/scripts/validate-specs.sh
./develop/scripts/generate-docs.sh
```

### Phase 3: Implementation Planning

#### 3.1 Generate Implementation Plan
```bash
# Use tools to extract from /spec (avoid LLM transcription errors)
./develop/scripts/extract-interfaces.sh
./develop/scripts/generate-stubs.sh
./develop/scripts/plan-implementation.sh
```

#### 3.2 Update Ticket with Implementation Plan
Add to your ticket in `/project/in-progress/`:

```markdown
## Implementation Plan (Updated: YYYY-MM-DD)

### Specifications Updated
- [ ] API definitions complete
- [ ] Data schemas defined
- [ ] Integration interfaces specified
- [ ] Security model documented

### Implementation Components
- [ ] Component 1: Description and timeline
- [ ] Component 2: Description and timeline
- [ ] Component 3: Description and timeline

### Integration Points
- [ ] Interface A: Status and dependencies
- [ ] Interface B: Status and dependencies

### Testing Strategy
- [ ] Unit tests planned
- [ ] Integration tests planned
- [ ] Performance tests planned
```

### Phase 4: Development

#### 4.1 Specification-Driven Development
```bash
# Generate code from specifications
./develop/scripts/generate-from-spec.sh

# Build implementation
./develop/scripts/build.sh

# Validate against specifications
./develop/scripts/validate-implementation.sh
```

#### 4.2 Regular Ticket Updates
Update your ticket weekly with:
- **Progress**: What's completed
- **Blockers**: What's preventing progress
- **Changes**: Any specification or plan changes
- **Integration**: Status of cross-project coordination

### Phase 5: Pre-Merge Preparation

#### 5.1 Ticket Merge Preparation Checklist
Before creating merge request, update your ticket with:

```markdown
## Merge Request Preparation (Date: YYYY-MM-DD)

### Specifications Complete ✅
- [ ] All APIs specified and validated
- [ ] Documentation generated from specs
- [ ] Integration interfaces documented
- [ ] Security model implemented

### Implementation Complete ✅
- [ ] All components implemented
- [ ] Unit tests passing (>80% coverage)
- [ ] Integration tests passing
- [ ] Performance benchmarks met

### Quality Assurance ✅
- [ ] Code review completed
- [ ] Security review completed
- [ ] Performance review completed
- [ ] Documentation review completed

### Integration Ready ✅
- [ ] Cross-project interfaces tested
- [ ] Dependencies satisfied
- [ ] Handoff documentation complete
- [ ] Next team notified

### Merge Request Details
- **Branch**: feature/your-project-name
- **Target**: main
- **Reviewers**: @team-lead, @integration-team
- **Related Tickets**: Links to dependent tickets
- **Breaking Changes**: None / List changes
- **Migration Required**: None / Migration steps
```

#### 5.2 Move Ticket for Review
```bash
# Move ticket to review status
mv project/in-progress/YYYYMMDD-your-project-ticket.md project/in-progress/YYYYMMDD-your-project-ticket-REVIEW.md

# Update status in ticket:
# Status: 🔄 IN PROGRESS → 🔄 IN REVIEW
```

### Phase 6: Post-Merge

#### 6.1 Complete Ticket
After successful merge:
```bash
# Move to done
mv project/in-progress/YYYYMMDD-your-project-ticket-REVIEW.md project/done/

# Update final status:
# Status: 🔄 IN REVIEW → ✅ COMPLETED
```

#### 6.2 Handoff Documentation
Add to ticket:
```markdown
## Handoff Complete (Date: YYYY-MM-DD)

### Deliverables
- **Specifications**: Location and status
- **Implementation**: Location and status
- **Documentation**: Location and status
- **Tests**: Location and coverage

### Integration Points
- **APIs Exposed**: List and documentation
- **Dependencies**: What this project provides to others
- **Next Steps**: What dependent projects can now start

### Lessons Learned
- **What Worked**: Successful approaches
- **What Didn't**: Issues and solutions
- **Recommendations**: For future similar work
```

## Tools and Automation

### Specification Tools
```bash
# Validate specifications
./develop/scripts/validate-specs.sh

# Generate documentation
./develop/scripts/generate-docs.sh

# Extract interfaces (avoid LLM transcription errors)
./develop/scripts/extract-interfaces.sh

# Generate implementation stubs
./develop/scripts/generate-stubs.sh
```

### Quality Tools
```bash
# Run tests
./develop/scripts/test.sh

# Check coverage
./develop/scripts/coverage.sh

# Performance benchmarks
./develop/scripts/benchmark.sh

# Security scan
./develop/scripts/security-scan.sh
```

## Communication Protocols

### Daily Updates
- Update agent status file in `/project/agents/`
- Report blockers immediately
- Coordinate with dependent teams

### Weekly Sync
- Update ticket with progress
- Participate in cross-team coordination
- Review integration points

### Milestone Reviews
- Prepare comprehensive ticket updates
- Demonstrate working functionality
- Validate against specifications

## Quality Standards

### Specification Quality
- **Complete**: All required APIs and interfaces defined
- **Consistent**: Follows WebAXP methodology
- **Validated**: Passes OpenAPI 3.0 validation
- **Documented**: Auto-generated documentation complete

### Implementation Quality
- **Specification-Driven**: Generated from `/spec` where possible
- **Tested**: >80% test coverage, all tests passing
- **Performant**: Meets specified performance targets
- **Secure**: Passes security review

### Integration Quality
- **Interface Compliance**: Implements specified interfaces exactly
- **Dependency Management**: Clear dependency satisfaction
- **Handoff Ready**: Complete documentation for next teams
- **Backward Compatible**: No breaking changes without migration

## Common Pitfalls to Avoid

### ❌ Don't Do This
- Start implementation before updating specifications
- Use LLM to transcribe between specifications and code
- Create merge requests without updating tickets
- Skip cross-project coordination
- Implement without validating against specifications

### ✅ Do This
- Always start from `/spec` evaluation
- Use tools to extract from specifications
- Update tickets throughout development
- Coordinate regularly with dependent teams
- Validate implementation against specifications

## Success Criteria

### For Individual Agents
- Tickets properly maintained throughout lifecycle
- Specifications complete before implementation
- Quality standards met
- Integration points working

### For Teams
- Cross-team coordination effective
- Dependencies managed properly
- Handoffs smooth and complete
- Architecture integrity maintained

### For Project
- WebAXP methodology followed
- Specification-first development achieved
- Quality standards maintained
- Integration milestones met

**Remember: The ticket is your project's story - keep it updated, complete, and ready for merge review!** 📋✅
