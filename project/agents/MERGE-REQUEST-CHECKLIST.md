# Merge Request Preparation Checklist

## Overview

This checklist ensures that your ticket is properly prepared for merge request review. Complete all items before creating your merge request to ensure smooth integration and maintain project quality standards.

## Pre-Merge Ticket Update Requirements

### 1. Ticket Status Update
Update your ticket in `/project/in-progress/` with the following section:

```markdown
## Merge Request Preparation (Date: YYYY-MM-DD)

**Status**: 🔄 IN REVIEW
**Merge Request**: [Link to MR when created]
**Target Branch**: main
**Source Branch**: feature/[your-project-name]
```

### 2. Specification Completeness ✅

#### 2.1 API Specifications
- [ ] **All APIs Defined**: Every required API has OpenAPI 3.0 specification
- [ ] **Validation Passes**: `swagger-codegen validate` passes for all specs
- [ ] **Examples Complete**: Request/response examples for all endpoints
- [ ] **Error Handling**: All error cases documented
- [ ] **Security Defined**: Authentication and authorization specified

#### 2.2 Data Schemas
- [ ] **Schemas Complete**: All data structures defined in `/spec/data/`
- [ ] **Validation Rules**: Input validation rules specified
- [ ] **Relationships**: Data relationships clearly defined
- [ ] **Versioning**: Schema versioning strategy documented

#### 2.3 Integration Interfaces
- [ ] **Cross-Project APIs**: All integration points specified
- [ ] **Dependencies**: Required interfaces from other projects documented
- [ ] **Exports**: Interfaces provided to other projects documented
- [ ] **Compatibility**: Backward compatibility maintained or migration provided

#### 2.4 Performance Specifications
- [ ] **SLAs Defined**: Service level agreements documented
- [ ] **Benchmarks**: Performance targets specified
- [ ] **Monitoring**: Performance monitoring requirements defined
- [ ] **Scaling**: Scaling characteristics documented

### 3. Implementation Completeness ✅

#### 3.1 Code Quality
- [ ] **Generated from Specs**: Implementation uses tool-generated stubs where possible
- [ ] **No LLM Transcription**: Direct tool extraction from specifications used
- [ ] **Code Review**: Internal code review completed
- [ ] **Style Compliance**: Follows project coding standards
- [ ] **Documentation**: Code documentation complete

#### 3.2 Testing
- [ ] **Unit Tests**: >80% code coverage achieved
- [ ] **Integration Tests**: All integration points tested
- [ ] **Performance Tests**: Performance benchmarks met
- [ ] **Security Tests**: Security requirements validated
- [ ] **Regression Tests**: No existing functionality broken

#### 3.3 Build and Deployment
- [ ] **Build Success**: All build targets successful
- [ ] **Container Build**: Docker containers build successfully
- [ ] **Deployment Ready**: Deployment configurations complete
- [ ] **Environment Tested**: Tested in development environment

### 4. Documentation Completeness ✅

#### 4.1 Generated Documentation
- [ ] **API Docs**: Auto-generated from OpenAPI specifications
- [ ] **Integration Guides**: Generated from specification interfaces
- [ ] **Developer Guides**: Usage examples and tutorials
- [ ] **Architecture Docs**: System design documentation

#### 4.2 Manual Documentation
- [ ] **README Updated**: Project README reflects current state
- [ ] **CHANGELOG**: Changes documented in changelog
- [ ] **Migration Guide**: Breaking changes documented with migration steps
- [ ] **Troubleshooting**: Common issues and solutions documented

### 5. Integration Readiness ✅

#### 5.1 Cross-Project Coordination
- [ ] **Dependencies Satisfied**: All required dependencies available
- [ ] **Interface Testing**: Integration interfaces tested with mock services
- [ ] **Dependent Teams Notified**: Teams waiting for this work informed
- [ ] **Handoff Documentation**: Complete handoff guide prepared

#### 5.2 Deployment Coordination
- [ ] **Deployment Plan**: Deployment strategy documented
- [ ] **Rollback Plan**: Rollback procedure documented
- [ ] **Monitoring Plan**: Post-deployment monitoring strategy
- [ ] **Support Plan**: Support and maintenance plan documented

## Ticket Update Template

Add this section to your ticket before creating merge request:

```markdown
## Merge Request Preparation (Date: YYYY-MM-DD)

### Specifications Complete ✅
- [x] All APIs specified and validated (OpenAPI 3.0)
- [x] Data schemas complete and documented
- [x] Integration interfaces defined and tested
- [x] Performance SLAs documented and validated
- [x] Security requirements implemented and tested

**Specification Files**:
- `spec/api/[service].yaml` - [Brief description]
- `spec/data/schemas.yaml` - [Brief description]
- `spec/security/capabilities.yaml` - [Brief description]
- `spec/performance/slas.yaml` - [Brief description]

### Implementation Complete ✅
- [x] All components implemented from specifications
- [x] Unit tests passing (Coverage: XX%)
- [x] Integration tests passing
- [x] Performance benchmarks met
- [x] Security requirements validated

**Implementation Files**:
- `app/[component]/` - [Brief description]
- `build/[scripts]/` - [Brief description]
- `dist/[artifacts]/` - [Brief description]

### Quality Assurance ✅
- [x] Code review completed by [Reviewer Name]
- [x] Security review completed by [Security Team]
- [x] Performance review completed by [Performance Team]
- [x] Documentation review completed by [Doc Team]

**Quality Metrics**:
- Test Coverage: XX%
- Performance: [Key metrics]
- Security: [Security validation results]
- Documentation: [Documentation completeness]

### Integration Ready ✅
- [x] Cross-project interfaces tested
- [x] Dependencies satisfied: [List dependencies]
- [x] Handoff documentation complete
- [x] Next teams notified: [List teams]

**Integration Points**:
- Provides to [Project A]: [Interface description]
- Depends on [Project B]: [Interface description]
- Integrates with [Project C]: [Integration description]

### Merge Request Details
- **Source Branch**: feature/[your-project-name]
- **Target Branch**: main
- **Reviewers**: @[team-lead], @[integration-team], @[security-team]
- **Related Tickets**: [Links to related tickets]
- **Breaking Changes**: None / [List breaking changes]
- **Migration Required**: None / [Migration steps]
- **Deployment Notes**: [Special deployment considerations]

### Post-Merge Actions
- [ ] Update dependent project tickets
- [ ] Notify integration teams
- [ ] Update project documentation
- [ ] Schedule integration testing
- [ ] Plan next phase work

### Lessons Learned
**What Worked Well**:
- [Successful approaches and practices]

**What Could Be Improved**:
- [Areas for improvement in future work]

**Recommendations for Future Work**:
- [Suggestions for similar projects]
```

## Merge Request Creation

### 1. Branch Preparation
```bash
# Ensure your branch is up to date
git checkout main
git pull origin main
git checkout feature/your-project-name
git rebase main

# Final testing
./develop/scripts/test-all.sh
./develop/scripts/validate-specs.sh
```

### 2. Merge Request Template
Use this template for your merge request description:

```markdown
# [Project Name] Implementation

## Summary
Brief description of what this merge request implements.

## Related Ticket
Closes: [Link to ticket in /project/in-progress/]

## Specifications
- **APIs**: [List API specifications added/updated]
- **Schemas**: [List data schemas added/updated]
- **Integration**: [List integration interfaces]

## Implementation
- **Components**: [List major components implemented]
- **Tests**: [Test coverage and types]
- **Performance**: [Performance characteristics]

## Breaking Changes
- None / [List breaking changes with migration steps]

## Deployment Notes
- [Any special deployment considerations]

## Review Checklist
- [ ] Specifications complete and validated
- [ ] Implementation follows specifications
- [ ] Tests passing with adequate coverage
- [ ] Documentation generated and complete
- [ ] Integration points tested
- [ ] Security requirements met
- [ ] Performance targets achieved

## Post-Merge Actions
- [ ] Update dependent tickets
- [ ] Notify integration teams
- [ ] Schedule integration testing
```

### 3. Reviewer Assignment
Assign reviewers based on project type:
- **Architecture Review**: @architecture-team
- **Security Review**: @security-team
- **Performance Review**: @performance-team
- **Integration Review**: @integration-team
- **Documentation Review**: @documentation-team

## Post-Merge Actions

### 1. Ticket Completion
```bash
# Move ticket to done
mv project/in-progress/YYYYMMDD-your-project-ticket.md project/done/

# Update final status in ticket
# Status: 🔄 IN REVIEW → ✅ COMPLETED
```

### 2. Handoff Documentation
Update your completed ticket with:

```markdown
## Handoff Complete (Date: YYYY-MM-DD)

### Deliverables
- **Specifications**: `spec/` - Complete API and data specifications
- **Implementation**: `app/` - Working implementation with tests
- **Documentation**: `docs/` - Generated documentation and guides
- **Build System**: `build/` - Build and deployment configurations

### For Dependent Teams
**[Team A] can now start**:
- Interface: [Description and location]
- Documentation: [Location of integration guide]
- Contact: [Your contact for questions]

**[Team B] can now integrate**:
- API: [API endpoint and documentation]
- Examples: [Location of usage examples]
- Support: [Support and troubleshooting guide]

### Next Steps
- [What should happen next in the project]
- [Any follow-up work required]
- [Integration milestones to watch]
```

## Quality Gates

### Before Merge Request
- All checklist items completed
- Ticket properly updated
- All tests passing
- Documentation complete

### During Review
- Address all reviewer feedback
- Update ticket with any changes
- Maintain specification-implementation consistency
- Ensure integration compatibility

### After Merge
- Complete ticket handoff
- Notify dependent teams
- Update project tracking
- Plan next phase work

**Remember: A well-prepared ticket makes for a smooth merge request and successful integration!** ✅🚀
