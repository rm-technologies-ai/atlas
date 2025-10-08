# Roy Specification 001: Context Engineering

**Specification ID:** SPEC-001
**Title:** Context Engineering and Command Lifecycle Management
**Status:** Implemented
**Created:** 2025-10-08
**Type:** Addition (Policy + Workflow Enhancement)

---

## 📋 Original Specification

**User Request:**
> In order for new, updated, or deleted commands in roy to take effect, claude code must be exited and restarted so that all the content inside .claude/ folder is properly loaded into context. Incorporate this into the roy specification to ensure that the proper context engineering logic of roy is maintained in a valid state at all times.

---

## 🎯 Purpose

Establish and enforce requirements for maintaining valid context engineering state in the roy framework when `.claude/` folder content is modified.

**Problem Addressed:**
Claude Code loads `.claude/` folder contents into context window at startup. Changes made during an active session are not detected, leading to stale command definitions and invalid roy framework state.

**Solution:**
Create authoritative policy and integrate enforcement into roy specification workflow to ensure users restart Claude Code when necessary.

---

## 🏗️ Implementation Details

### Components Created

1. **Policy File:** `.roy/policies/POLICY-context-engineering.md`
   - Authoritative policy documenting restart requirements
   - Technical explanation of Claude Code context loading
   - Enforcement mechanisms
   - Verification procedures
   - No exceptions clause

2. **Workflow Enhancement:** `.claude/commands/roy-agentic-specification.md` (Phase 7)
   - Added Step 3: Check for Context Engineering Requirements
   - Conditional restart reminder based on `.claude/` modifications
   - Clear user instructions for restart procedure
   - Policy reference for additional details

3. **Documentation Update:** `.roy/README.md`
   - New section: "Context Engineering Requirements"
   - Claude Code Restart Policy overview
   - Affected operations list
   - Enforcement mechanisms
   - Reference to policy file

### Components Modified

- `.claude/commands/roy-agentic-specification.md` - Enhanced Phase 7 with context engineering checks
- `.roy/README.md` - Added context engineering documentation section

---

## 🔄 Workflow Integration

### Automated Enforcement in `/roy-agentic-specification`

**Phase 7 Enhancement:**

```
3. Check for Context Engineering Requirements
   - Determine if .claude/ folder was modified during implementation
   - If yes: Display restart instructions per POLICY-context-engineering
   - If no: Proceed with standard finalization

4. Present to User
   [IF .claude/ folder was modified, display:]

   ⚠️  RESTART REQUIRED (POLICY-context-engineering)

   Changes to .claude/ folder detected. Claude Code must be restarted
   for the updated commands/agents to take effect.

   REQUIRED STEPS:
   1. Commit changes to version control
   2. Exit Claude Code completely
   3. Restart Claude Code
   4. Verify commands are registered
   5. Test updated behavior
```

### Manual Operations

Users performing manual edits to `.claude/` folder must remember to restart Claude Code. Policy documentation provides guidance.

---

## ✅ Success Criteria

- [x] Policy file created with comprehensive documentation
- [x] `/roy-agentic-specification` Phase 7 includes restart detection
- [x] `.roy/README.md` documents context engineering requirements
- [x] All changes preserve existing roy functionality
- [x] Policy is accessible and referenced throughout roy framework

---

## 📊 Benefits

### Prevents Invalid State

- Ensures context window always reflects current filesystem state
- Eliminates stale command definitions
- Prevents unexpected behavior from old logic
- Maintains roy framework validity

### User Guidance

- Clear instructions when restart required
- Automated detection in specification workflow
- Single source of truth (policy file)
- Verification procedures documented

### Framework Integrity

- Enforces roy principle of valid state at all times
- Aligns with "Exit Criteria Required" rule
- Supports "Root Cause Analysis" approach
- Maintains supreme authority of roy definitions

---

## 🔮 Future Enhancement (PBI Created)

### Automated Restart Workflow

**Vision:** Roy framework will automate the entire restart process:

1. Launch Claude Code as separate process
2. Execute `/roy-agentic-specification {instruction}`
3. Detect `.claude/` folder modifications
4. Exit Claude Code upon specification completion
5. Restart Claude Code automatically
6. Validate updated commands registered and loaded
7. Return control to user with confirmation

**Status:** Product Backlog Item created in Archon
**Benefit:** Eliminates manual restart steps, ensures context validity automatically

---

## 📚 Related Documents

- `.roy/policies/POLICY-context-engineering.md` - Authoritative policy
- `.claude/commands/roy-agentic-specification.md` - Workflow implementation
- `.roy/README.md` - User-facing documentation

---

## 🧪 Test Coverage

See: `.roy/specifications/SPEC-001-context-engineering-TESTS.md`

---

## 📝 Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2025-10-08 | Initial implementation via `/roy-agentic-specification` |

---

**Specification Owner:** Roy Framework
**Implementation Status:** Complete
**Test Status:** All tests passed (see TESTS.md)
