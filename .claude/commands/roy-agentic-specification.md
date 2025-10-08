---
description: Incrementally define roy agentic capabilities via natural language specifications
args:
  - name: specification
    description: Natural language description of capability to add/modify
    required: true
---

# Roy Agentic Specification Command

You are processing a **roy agentic specification** to incrementally evolve the roy framework's capabilities.

---

## COMMAND SYNTAX

```
/roy-agentic-specification {$SPECIFICATION}
```

**Parameter:**
- `$SPECIFICATION` - Natural language description of addition, correction, update, or optimization to roy framework

---

## EXECUTION PROTOCOL

Execute the following phases in EXACT order. Do NOT skip any phase.

---

## PHASE 1: ANALYZE SPECIFICATION

### Action: Understand the specification in relation to current roy implementation

**Execute:**

1. **Load Current Roy State:**
   - Read `/mnt/e/repos/atlas/.roy/README.md`
   - Read `/mnt/e/repos/atlas/.roy/SEED.md`
   - Check for existing specifications in `.roy/specifications/` (if folder exists)
   - Check for existing policies in `.roy/policies/` (if folder exists)
   - Determine current roy capabilities (likely empty constructor state)

2. **Parse Specification:**
   - Extract key requirements from `$SPECIFICATION`
   - Identify type of change:
     - **Addition** - New capability not currently in roy
     - **Correction** - Fix to existing roy behavior
     - **Update** - Enhancement to existing roy capability
     - **Optimization** - Performance/quality improvement

3. **Analyze Impact:**
   - Determine which roy components need to be created/modified
   - Identify integration points with existing code
   - Assess impact on subordinate frameworks (BMAD, Archon, Claude Code)
   - Check for conflicts with existing roy specifications

4. **Validate Feasibility:**
   - Confirm specification is implementable
   - Identify any blockers or dependencies
   - Determine if additional clarification needed from user

**Output of Phase 1:**
```
📋 Specification Analysis Summary

Type: [Addition|Correction|Update|Optimization]
Scope: [Describe what will be affected]
Complexity: [Low|Medium|High]

Key Requirements:
- [Requirement 1]
- [Requirement 2]
- [...]

Impact Assessment:
- Files to Create: [list]
- Files to Modify: [list]
- Integration Points: [list]
- Potential Conflicts: [list or "None identified"]

Feasibility: [Implementable|Needs Clarification|Blocked]
Dependencies: [list or "None"]
```

---

## PHASE 2: FORMULATE IMPLEMENTATION PLAN

### Action: Create detailed plan incorporating specification into roy framework

**Execute:**

1. **Define Implementation Steps:**
   - Break specification into discrete implementation tasks
   - Order tasks by dependency (prerequisites first)
   - Identify file structure changes (.roy/ folder)
   - Plan integration with existing roy components

2. **Design New Components:**
   - If creating new agents: Define persona, commands, activation
   - If creating new policies: Define scope, rules, enforcement
   - If creating new workflows: Define steps, inputs, outputs, exit criteria
   - If creating new tools: Define purpose, inputs, outputs, error handling

3. **Ensure Backward Compatibility:**
   - Verify existing roy functionality is preserved
   - Identify any breaking changes (require user approval)
   - Plan migration path if breaking changes necessary

4. **Define Propagation Strategy:**
   - How will new capability be made available throughout roy?
   - How will subordinate frameworks (BMAD, Archon, Claude Code) interact with it?
   - How will new capability integrate with existing specifications?

**Output of Phase 2:**
```
📐 Implementation Plan

Implementation Tasks:
1. [Task 1 - describe what and why]
2. [Task 2 - describe what and why]
3. [...]

New Components to Create:
- .roy/[component]/[filename] - [purpose]
- [...]

Existing Components to Modify:
- .roy/[existing-file] - [changes needed]
- [...]

Backward Compatibility:
- Existing Functionality: [Preserved|Breaking Changes Required]
- Breaking Changes: [list or "None"]
- Migration Path: [describe or "Not applicable"]

Propagation Strategy:
- Availability: [How capability becomes available to roy users]
- Integration: [How subordinate frameworks interact with it]
- Documentation: [Where capability will be documented]

Exit Criteria:
- [Success condition 1]
- [Success condition 2]
- [...]
```

---

## PHASE 3: USER REVIEW AND APPROVAL

### Action: Present plan to user for review and approval

**Execute:**

1. **Present Summary:**
   - Show Phase 1 Analysis Summary
   - Show Phase 2 Implementation Plan
   - Highlight any breaking changes or significant impacts

2. **Request Approval:**
   ```
   ═══════════════════════════════════════════════════════

   🔍 Review Required

   The implementation plan above describes how this specification
   will be integrated into the roy framework.

   Please review and respond:
   - Type "approve" to proceed with implementation
   - Type "modify [your feedback]" to request changes to the plan
   - Type "cancel" to abort this specification

   ═══════════════════════════════════════════════════════
   ```

3. **Process User Response:**
   - **If "approve":** Proceed to Phase 4
   - **If "modify [feedback]":** Adjust plan based on feedback, re-present Phase 3
   - **If "cancel":** Abort specification, return control to user

**IMPORTANT:** Do NOT proceed to Phase 4 without explicit user approval.

---

## PHASE 4: IMPLEMENT CHANGES

### Action: Execute implementation plan and integrate changes into roy framework

**Execute:**

1. **Create New Files:**
   - Create any new files in `.roy/` folder structure
   - Follow naming conventions:
     - Specifications: `.roy/specifications/SPEC-NNN-[description].md`
     - Policies: `.roy/policies/POLICY-[domain]-[name].md`
     - Agents: `.roy/agents/[agent-name].md`
     - Workflows: `.roy/workflows/[workflow-name].md`
     - Tools: `.roy/tools/[tool-name].md` or `.roy/tools/[tool-name].py`

2. **Modify Existing Files:**
   - Update `.roy/README.md` if framework structure changes
   - Update existing specification files if refinements needed
   - Preserve existing functionality (backward compatibility)

3. **Document Changes:**
   - Create specification documentation file:
     - Filename: `.roy/specifications/SPEC-[NNN]-[brief-description].md`
     - Content: Original specification, implementation details, usage examples
   - Update `.roy/README.md` "Future Components" section if structure evolved
   - Add entry to version history (if `.roy/VERSION-HISTORY.md` exists)

4. **Ensure Complete Propagation:**
   - Verify new capability is accessible where needed
   - Update any command files that reference roy capabilities
   - Ensure subordinate frameworks can interact with new capability (if applicable)

**Output of Phase 4:**
```
✅ Implementation Complete

Files Created:
- [list of new files with brief description]

Files Modified:
- [list of modified files with description of changes]

Documentation Updated:
- [list of documentation files updated]

Propagation Verified:
- [How capability is now accessible]
```

---

## PHASE 5: GENERATE AUTOMATED TESTS

### Action: Create agentic unit tests to verify expected behavior

**Execute:**

1. **Define Test Scenarios:**
   - Positive tests: Verify capability works as specified
   - Negative tests: Verify proper error handling
   - Edge cases: Verify behavior at boundaries
   - Integration tests: Verify interaction with existing roy components

2. **Create Test Specification:**
   - Filename: `.roy/specifications/SPEC-[NNN]-[description]-TESTS.md`
   - Content: Test scenarios, expected outcomes, success criteria

3. **Implement Agentic Tests:**
   - Create test execution plan
   - Define inputs for each test
   - Define expected outputs for each test
   - Define verification method (automated or manual)

**Test Specification Template:**
```markdown
# Roy Specification Tests: SPEC-[NNN]

## Test 1: [Test Name]
**Scenario:** [Describe what is being tested]
**Input:** [What inputs will be provided]
**Expected Output:** [What should happen]
**Verification:** [How to verify success]
**Status:** [Not Run|Pass|Fail]

## Test 2: [Test Name]
...
```

**Output of Phase 5:**
```
🧪 Tests Generated

Test Specification File: .roy/specifications/SPEC-[NNN]-[description]-TESTS.md

Test Scenarios Created:
1. [Test 1 name] - [brief description]
2. [Test 2 name] - [brief description]
3. [...]

Total Tests: [count]
Test Coverage: [Positive|Negative|Edge Cases|Integration]
```

---

## PHASE 6: EXECUTE TESTS AND VERIFY

### Action: Run tests and fix issues until all tests pass

**Execute:**

1. **Execute Each Test:**
   - Run test scenarios in order
   - Capture actual output
   - Compare to expected output
   - Record pass/fail status

2. **Handle Failures:**
   - Analyze failure reason
   - Determine if issue is in implementation or test definition
   - Fix implementation or adjust test as appropriate
   - Re-run failed test

3. **Iterate Until Success:**
   - Continue fixing and re-testing until all tests pass
   - Document any issues encountered and resolutions
   - Update implementation if patterns emerge

4. **Final Verification:**
   - Confirm all tests pass
   - Verify no regressions in existing roy functionality
   - Confirm backward compatibility maintained

**Output of Phase 6:**
```
✅ Verification Complete

Test Results:
- Total Tests: [count]
- Passed: [count]
- Failed: 0
- Success Rate: 100%

Issues Encountered and Resolved:
- [Issue 1] - [Resolution]
- [Issue 2] - [Resolution]
- [Or "None"]

Regression Check:
- Existing Functionality: [Verified Intact]
- Backward Compatibility: [Confirmed]

Final Status: ✅ ALL TESTS PASSED
```

---

## PHASE 7: FINALIZE AND COMMIT

### Action: Prepare for version control commit

**Execute:**

1. **Create Summary:**
   - Summarize all changes made
   - List all files created/modified
   - Describe new capability added to roy framework

2. **Prepare Commit Message:**
   ```
   feat(roy): [Brief description of specification]

   Specification: [Original $SPECIFICATION text]

   Implementation:
   - Created: [list files]
   - Modified: [list files]
   - Tests: [test count] tests, all passing

   Roy Capability Added: [Description of what roy can now do]

   Specification File: .roy/specifications/SPEC-[NNN]-[description].md
   ```

3. **Present to User:**
   ```
   ═══════════════════════════════════════════════════════

   ✅ Roy Specification Integration Complete

   Specification: [Original $SPECIFICATION]

   Summary:
   - [High-level description of what was implemented]

   Files Created/Modified:
   - [list]

   Tests: [count] tests, all passing

   New Roy Capability:
   [Describe what roy can now do]

   ═══════════════════════════════════════════════════════

   Ready to commit these changes to version control.

   Next Steps:
   1. Review the changes above
   2. Run: git add .roy/ [and other changed files]
   3. Run: git commit -m "[commit message above]"
   4. Run: git push origin main

   Or, would you like me to commit these changes for you?
   (Type "commit" to have me create the commit, or handle manually)

   ═══════════════════════════════════════════════════════
   ```

4. **Handle Commit (If Requested):**
   - If user types "commit":
     - Stage all changed files in .roy/ and related areas
     - Create commit with prepared message
     - Offer to push (but don't push automatically)
   - Otherwise: Return control to user for manual commit

---

## BEHAVIORAL RULES

### Throughout All Phases

1. **Exit Criteria Required:**
   - Every phase has clear success/failure conditions
   - No infinite loops or rabbit holes
   - Progress or abort, never hang

2. **Root Cause Fixes:**
   - When encountering errors, find and fix root cause
   - No workarounds unless explicitly approved by user
   - Document blockers clearly if unable to proceed

3. **User Approval Required:**
   - Phase 3 requires explicit user approval before implementation
   - Breaking changes require additional explicit approval
   - No assumptions about user intent

4. **Preserve Existing Functionality:**
   - Backward compatibility is mandatory unless user approves breaking changes
   - All existing roy capabilities must continue to work
   - Test for regressions

5. **Complete Propagation:**
   - New capability must be fully integrated, not partially
   - Update all relevant documentation
   - Ensure accessibility where capability is needed

### Specification Numbering

- First specification: SPEC-001-[description]
- Increment number for each new specification
- Check existing `.roy/specifications/` folder for highest number
- If folder doesn't exist, start with SPEC-001

---

## EXAMPLE USAGE

### Example 1: Adding Task Prioritization

```
User: /roy-agentic-specification Add capability to prioritize tasks across all projects based on deadline proximity and dependencies

Claude:
[Phase 1: Analysis]
📋 Specification Analysis Summary
Type: Addition
Scope: New task prioritization capability
Complexity: Medium
[... full analysis ...]

[Phase 2: Plan]
📐 Implementation Plan
Implementation Tasks:
1. Create .roy/policies/POLICY-task-prioritization.md
2. Create .roy/tools/task-prioritizer.py
3. Update .roy/README.md to document new capability
[... full plan ...]

[Phase 3: Approval]
Please review and respond with "approve", "modify [feedback]", or "cancel"

User: approve

[Phase 4-6: Implementation, Tests, Verification]
[... execution ...]

[Phase 7: Finalize]
✅ Roy Specification Integration Complete
Ready to commit...
```

### Example 2: Correcting Existing Behavior

```
User: /roy-agentic-specification Fix roy-init command to also verify Claude Code native tools are available

Claude:
[Phase 1: Analysis]
📋 Specification Analysis Summary
Type: Correction
Scope: Modification to /roy-init command (.claude/commands/roy-init.md)
Complexity: Low
[... full analysis ...]
```

---

## TROUBLESHOOTING

**If specification is ambiguous:**
- Request clarification from user before proceeding past Phase 1
- Provide specific questions about unclear aspects
- Wait for user response before continuing

**If specification conflicts with existing roy capabilities:**
- Highlight conflict in Phase 1 analysis
- Propose resolution options in Phase 2 plan
- Require user approval for conflict resolution approach

**If tests fail repeatedly:**
- Document failure patterns
- Determine if issue is fundamental design flaw
- Present options to user: modify specification, adjust approach, or abort

**If unable to implement specification:**
- Document blockers clearly in Phase 1 or Phase 2
- Explain why specification cannot be implemented
- Suggest alternatives or modifications to make it feasible

---

## END OF PROTOCOL

Execute all phases in order. Always require user approval at Phase 3 before implementation.

Roy framework evolves through deliberate, tested, incremental specifications.
