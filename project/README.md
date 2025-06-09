# FuncOS/Project Biometal - Project Tracking System

## Overview

This is our lightweight project tracking system - a primitive, unbloated version of JIRA for managing parallel development across multiple agents and sub-projects.

## Directory Structure

```
project/
├── goals/          # High-level project goals and objectives
├── next/           # Tasks ready to start (backlog)
├── in-progress/    # Currently active work
├── done/           # Completed tasks and deliverables
├── problems/       # Issues, blockers, and risks
├── agents/         # Agent-specific tracking and status
└── README.md       # This file
```

## Usage Guidelines

### For Project Managers
- **Track Progress**: Monitor overall project health
- **Identify Blockers**: Quickly spot problems and dependencies
- **Resource Allocation**: See which agents need support
- **Milestone Planning**: Track progress toward integration points

### For Agents
- **Check Dependencies**: See what tickets are ready for your work
- **Report Status**: Update your progress and blockers
- **Coordinate**: Understand what other teams are doing
- **Handoff**: Document completed work for integration

## File Naming Convention

### Ticket Files
- `YYYYMMDD-project-name-ticket.md`
- Example: `20241215-funcos-core-ticket.md`

### Agent Files
- `agent-[team-name].md`
- Example: `agent-kernel-team.md`

### Status Indicators
- 🟢 **Green**: On track, no issues
- 🟡 **Yellow**: Minor issues, watching closely
- 🔴 **Red**: Blocked or major issues
- ✅ **Done**: Completed successfully
- ⏸️ **Paused**: Temporarily stopped
- 🔄 **In Review**: Waiting for review/approval

## Project Phases

### Phase 1: Foundation (Weeks 1-4) ✅
- ZealOS build and test infrastructure
- Shared WebAXP container system
- Agent instruction templates
- Project breakdown structure

### Phase 2: Core Services (Weeks 5-8)
- FuncOS-Core hardware abstraction
- GNU Mach/Hurd microkernel integration
- API specifications v1.0
- Function execution model basics

### Phase 3: Integration (Weeks 9-12)
- Cross-project API integration
- Neural data collection implementation
- Browser network API development
- System-wide testing

### Phase 4: Optimization (Weeks 13-16)
- Performance optimization
- Hardware profiling integration
- Security and biometric systems
- Final system integration

## Integration Milestones

### Milestone 1: Foundation Complete ✅
- **Date**: Week 4
- **Status**: ✅ COMPLETED
- **Deliverables**: ZealOS building, shared infrastructure, agent instructions

### Milestone 2: Core Services
- **Date**: Week 8
- **Status**: 🟡 NEXT
- **Deliverables**: Microkernel working, hardware services, API v1.0

### Milestone 3: System Integration
- **Date**: Week 12
- **Status**: ⏸️ WAITING
- **Deliverables**: Full system integration, cross-project APIs

### Milestone 4: Production Ready
- **Date**: Week 16
- **Status**: ⏸️ WAITING
- **Deliverables**: Optimized system, complete documentation

## Quick Status Dashboard

### Active Tickets (8 total)
- 🟢 **API-Specifications**: Ready to start (HIGH priority)
- 🟢 **FuncOS-Core**: Ready to start (HIGH priority)
- 🟢 **Mach-Hurd-Integration**: Ready to start (HIGH priority)
- 🟡 **Function-Execution-Model**: Waiting for APIs (MEDIUM priority)
- 🟡 **Neural-Data-Interface**: Waiting for FuncOS-Core (MEDIUM priority)
- 🟡 **Browser-Network-API**: Waiting for Function-Execution (MEDIUM priority)
- ⏸️ **Hardware-Profiler**: Waiting for core services (LOW priority)
- ⏸️ **Security-Biometric**: Waiting for runtime model (LOW priority)

### Resource Status
- **Shared Infrastructure**: 🟢 Operational
- **Build System**: 🟢 Working
- **Documentation**: 🟢 Up to date
- **Integration Tests**: 🟡 Basic framework ready

### Risk Areas
- **GNU Mach Complexity**: 🟡 Monitoring
- **Cross-Project Dependencies**: 🟡 Managing
- **Performance Targets**: 🟡 TBD
- **Timeline Pressure**: 🟢 On track

## Communication Protocols

### Daily Updates
- Agents update their status files
- Problems reported immediately
- Dependencies tracked and resolved

### Weekly Sync
- Cross-project coordination
- Milestone progress review
- Resource reallocation if needed

### Integration Points
- Formal handoffs between projects
- Integration testing coordination
- Documentation updates

## Getting Started

### For New Agents
1. **Read Agent Instructions**: Start with `project/agents/AGENT-WORKFLOW.md`
2. **Check Available Tickets**: Browse `project/next/` for ready tickets
3. **Follow Specification-First**: Read `project/agents/SPECIFICATION-FIRST-DEVELOPMENT.md`
4. **Create Agent Status**: Copy template in `project/agents/`
5. **Start from `/spec`**: Always evaluate and update specifications first
6. **Prepare for Merge**: Use `project/agents/MERGE-REQUEST-CHECKLIST.md`

### For Project Coordination
1. Monitor `project/in-progress/` for active work
2. Check `project/problems/` for blockers
3. Update `project/next/` with ready tasks
4. Move completed work to `project/done/`
5. **Review Agent Instructions**: Ensure teams follow `project/agents/` guidelines
6. **Validate Specifications**: Ensure specification-first development
7. **Merge Request Reviews**: Use `project/agents/MERGE-REQUEST-CHECKLIST.md`

### Agent Instruction Files
- **`AGENT-WORKFLOW.md`**: Complete workflow from ticket to merge
- **`SPECIFICATION-FIRST-DEVELOPMENT.md`**: WebAXP methodology and tools
- **`MERGE-REQUEST-CHECKLIST.md`**: Pre-merge preparation requirements

This system keeps us organized without the bloat - simple, effective, and focused on getting the work done!
