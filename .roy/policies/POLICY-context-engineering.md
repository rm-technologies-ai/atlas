# POLICY: Context Engineering

**Policy ID:** POLICY-context-engineering
**Domain:** Roy Framework - Context Engineering
**Status:** Active
**Created:** 2025-10-08
**Last Updated:** 2025-10-08

---

## 🎯 Policy Statement

**All modifications to `.claude/` folder content require Claude Code to be exited and restarted before the changes take effect.**

This policy ensures the integrity and validity of the context engineering logic within the roy agentic framework at all times.

---

## 📋 Scope

This policy applies to:

- All commands defined in `.claude/commands/`
- All agent definitions in `.claude/agents/`
- All configuration files in `.claude/`
- Any custom slash command files (`.md` files in `.claude/commands/`)
- Any modifications, additions, or deletions to `.claude/` folder content

---

## 🔧 Technical Context

### Claude Code Context Loading Mechanism

Claude Code loads the contents of the `.claude/` folder into its context window **at startup**:

1. **Startup Phase:** Claude Code reads all files in `.claude/` folder
2. **Context Loading:** Command definitions, agent personas, and configurations are loaded into memory
3. **Session Duration:** Loaded context remains static for the entire session
4. **No Hot Reload:** Changes to `.claude/` files during an active session are **not** detected or applied

### Implications

**Without Restart:**
- New commands are not registered
- Modified commands retain old behavior
- Deleted commands remain accessible
- Context window contains stale definitions
- Roy framework state is invalid

**With Restart:**
- All `.claude/` content is reloaded
- New commands become available
- Modified commands reflect updated logic
- Deleted commands are removed
- Context window accurately reflects current state

---

## ✅ Required Actions

### When `.claude/` Content Changes

If any of the following occur, Claude Code **MUST** be restarted:

1. **New Command Created**
   - File: `.claude/commands/[command-name].md`
   - Action: Exit Claude Code → Restart → Verify command available

2. **Existing Command Modified**
   - File: `.claude/commands/[command-name].md`
   - Action: Exit Claude Code → Restart → Verify updated behavior

3. **Command Deleted**
   - File: `.claude/commands/[command-name].md`
   - Action: Exit Claude Code → Restart → Verify command removed

4. **Agent Definition Changed**
   - File: `.claude/agents/[agent-name].md`
   - Action: Exit Claude Code → Restart → Verify agent behavior

5. **Configuration Modified**
   - File: `.claude/[config-file]`
   - Action: Exit Claude Code → Restart → Verify configuration active

### Verification Steps

After restarting Claude Code:

1. **Verify Command Registration**
   - Type `/` to see available commands
   - Confirm new/modified commands appear in list
   - Confirm deleted commands do not appear

2. **Test Command Execution**
   - Execute the new/modified command
   - Verify expected behavior occurs
   - Check that command expansion uses updated logic

3. **Validate Context State**
   - Confirm context window contains correct definitions
   - Verify no stale or outdated logic persists
   - Ensure roy framework state is valid

---

## 🚨 Enforcement

### Automated Enforcement

The `/roy-agentic-specification` command automatically enforces this policy:

- **Phase 7 (Finalize):** Detects if `.claude/` folder was modified during specification
- **Conditional Reminder:** Displays restart instructions if `.claude/` changes detected
- **User Notification:** Clearly communicates restart requirement before proceeding

### Manual Enforcement

Users executing manual changes to `.claude/` folder:

- **Responsibility:** User must remember to restart Claude Code
- **Risk:** Stale context if restart skipped
- **Mitigation:** Always restart immediately after `.claude/` modifications

---

## 🔄 Future Automation (Planned)

### Automated Restart Workflow

**Vision:** Roy framework will automate the restart process:

1. Launch Claude Code as separate process
2. Execute `/roy-agentic-specification {instruction}`
3. Detect `.claude/` folder modifications
4. Exit Claude Code upon specification completion
5. Restart Claude Code automatically
6. Validate updated commands registered and loaded
7. Return control to user with confirmation

**Status:** Planned - PBI created in Archon for future implementation

**Benefit:** Eliminates manual restart steps and ensures context validity automatically

---

## 📊 Rationale

### Why This Policy Exists

**Problem:** Stale context window with outdated command definitions leads to:
- Unexpected behavior (old command logic executes instead of new)
- Failed command execution (new commands not found)
- Invalid roy framework state (context doesn't match filesystem)
- User confusion (commands appear to work but use wrong logic)

**Solution:** Mandatory restart after `.claude/` changes ensures:
- Context window always reflects current filesystem state
- All commands use latest definitions
- Roy framework state remains valid
- Predictable, reliable agentic behavior

### Alignment with Roy Principles

This policy aligns with roy framework principles:

- **Rule 2 (Exit Criteria):** Clear termination condition - restart required
- **Rule 4 (Root Cause Analysis):** Addresses underlying cause (stale context), not symptoms
- **Supreme Authority:** Roy definitions must be authoritative and current
- **Deliberate Evolution:** Incremental changes require deliberate context refresh

---

## 🛡️ Exceptions

**None.** This policy has no exceptions.

All `.claude/` folder modifications require restart, regardless of:
- Size of change (single character edit vs. new file)
- Type of change (command vs. agent vs. config)
- User role (developer vs. end user)
- Urgency (emergency fix vs. routine update)

**Rationale:** Context validity is binary - either valid or invalid. No partial validity exists.

---

## 📚 References

- `.roy/README.md` - Roy framework overview and command documentation
- `.claude/commands/roy-agentic-specification.md` - Specification workflow with automated enforcement
- Claude Code Documentation - Context loading and session management

---

## 📝 Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2025-10-08 | Initial policy creation via SPEC-001 |

---

**Policy Owner:** Roy Framework
**Review Frequency:** As needed (via `/roy-agentic-specification`)
**Next Review:** When automation workflow is implemented
