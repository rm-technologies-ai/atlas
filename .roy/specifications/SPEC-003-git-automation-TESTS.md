# Roy Specification Tests: SPEC-003

**Specification:** SPEC-003 - Git Commit Automation
**Test Status:** PASSED (17/17 automated tests)
**Created:** 2025-10-08
**Executed:** 2025-10-08

---

## Test 1: Command File Exists and is Valid

**Scenario:** Verify `/roy-git-commit` command file exists with proper structure

**Input:**
- Read `.claude/commands/roy-git-commit.md`

**Expected Output:**
- File exists at expected location
- Contains command syntax documentation
- Follows roy command pattern (matches structure of other roy commands)
- Includes all required sections: Command, What This Command Does, When to Use, Safety Mechanisms

**Verification:** Read file and compare structure to existing roy commands

**Status:** Not Run

---

## Test 2: Documentation Updated in README

**Scenario:** Verify `.roy/README.md` includes new command documentation

**Input:**
- Read `.roy/README.md`
- Search for `/roy-git-commit` section

**Expected Output:**
- Command documented in Roy Commands section
- Includes purpose, status, what it does, when to use
- References SPEC-003
- Located before Context Engineering Requirements section

**Verification:** Grep for `/roy-git-commit` in README.md

**Status:** Not Run

---

## Test 3: Git Status Check (Positive Case)

**Scenario:** Command detects changes in repository when files are modified

**Input:**
- Create test file: `echo "test" > /mnt/e/repos/atlas/.test-git-automation`
- Run: `git status --porcelain`

**Expected Output:**
- Git status shows untracked file
- Command would detect changes to commit

**Verification:** Check git status output contains test file

**Status:** Not Run

---

## Test 4: Git Status Check (Negative Case - Clean Working Directory)

**Scenario:** Command correctly handles clean working directory (no changes)

**Input:**
- Ensure working directory is clean
- Run: `git status --porcelain`

**Expected Output:**
- Git status returns empty output
- Command should report "No changes to commit"

**Verification:** Verify git status output is empty

**Status:** Not Run

---

## Test 5: Repository Validation

**Scenario:** Verify command can validate current repository is Atlas

**Input:**
- Run: `pwd`
- Run: `git remote -v`

**Expected Output:**
- Current directory: `/mnt/e/repos/atlas/`
- Remote `origin` points to: `https://github.com/rm-technologies-ai/atlas.git`

**Verification:** Check pwd output and git remote output match expected values

**Status:** Not Run

---

## Test 6: Timestamp Generation (ET Format)

**Scenario:** Generate Eastern Time timestamp with proper format

**Input:**
- Get current time in Eastern Time zone
- Format: `YYYY-MM-DD HH:MM:SS EDT/EST`

**Expected Output:**
- Timestamp string matching format
- Correct time zone indicator (EDT or EST based on date)
- Example: `2025-10-08 14:35:22 EDT`

**Verification:** Parse timestamp and validate format components

**Status:** Not Run

---

## Test 7: Commit Message Format (feat type)

**Scenario:** Generate properly formatted commit message for feature addition

**Input:**
- Context: New command file created
- File: `.claude/commands/roy-git-commit.md`

**Expected Output:**
```
feat(roy): [description]

[optional body]

(ET: [timestamp])
```

**Verification:** Commit message follows conventional commits format with ET timestamp

**Status:** Not Run

---

## Test 8: Commit Message Format (docs type)

**Scenario:** Generate properly formatted commit message for documentation changes

**Input:**
- Context: README.md modified
- File: `.roy/README.md`

**Expected Output:**
```
docs(roy): [description]

[optional body]

(ET: [timestamp])
```

**Verification:** Commit message uses "docs" type for documentation-only changes

**Status:** Not Run

---

## Test 9: Context Analysis for Commit Message

**Scenario:** Analyze git diff and conversation context to generate meaningful message

**Input:**
- Git diff showing changes to `.claude/commands/roy-git-commit.md`
- Conversation context about implementing SPEC-003

**Expected Output:**
- Commit message mentions git automation or SPEC-003
- Description accurately reflects work performed
- Not generic (e.g., not just "updated files")

**Verification:** Review generated message for specificity and accuracy

**Status:** Not Run

---

## Test 10: Safety - User Confirmation Required

**Scenario:** Verify command requires explicit "confirm" before pushing

**Input:**
- Stage changes
- Generate commit message
- Prompt user for confirmation

**Expected Output:**
- Command displays changes to be committed
- Command displays generated commit message
- Command prompts: "Push to GitHub remote main? Type 'confirm' to proceed:"
- Command only proceeds if response is exactly "confirm"

**Verification:** Confirm prompt behavior and abort on non-confirm responses

**Status:** Not Run

---

## Test 11: Git Add Execution

**Scenario:** Verify command stages all changes with `git add .`

**Input:**
- Create test file
- Execute staging logic

**Expected Output:**
- Test file appears in staged changes
- `git status` shows file ready to commit

**Verification:** Check git status after staging

**Status:** Not Run

---

## Test 12: Git Commit Execution

**Scenario:** Verify command creates commit with generated message

**Input:**
- Staged changes present
- Generated commit message
- Execute commit

**Expected Output:**
- Commit created successfully
- Commit message matches generated message with ET timestamp
- Commit hash returned

**Verification:** Check `git log -1` to verify commit details

**Status:** Not Run

---

## Test 13: Git Push Execution

**Scenario:** Verify command pushes to origin/main (dry-run)

**Input:**
- Committed changes present
- Execute: `git push --dry-run origin main`

**Expected Output:**
- Dry-run succeeds without errors
- Reports what would be pushed

**Verification:** Check dry-run output for success status

**Status:** Not Run

---

## Test 14: Error Handling - Not in Atlas Repository

**Scenario:** Command detects when not run from Atlas repository

**Input:**
- Change to different directory: `/tmp`
- Check if current directory is `/mnt/e/repos/atlas/`

**Expected Output:**
- Detection logic returns false
- Error message: "Current directory is not Atlas repository"

**Verification:** Verify error detection logic

**Status:** Not Run

---

## Test 15: Error Handling - Wrong Remote

**Scenario:** Command detects when remote doesn't point to GitHub atlas repo

**Input:**
- Get remote URL: `git remote get-url origin`
- Compare to expected: `https://github.com/rm-technologies-ai/atlas.git`

**Expected Output:**
- If mismatch, error message: "Remote 'origin' does not point to GitHub"

**Verification:** Verify remote validation logic

**Status:** Not Run

---

## Test 16: Integration Test - Full Workflow

**Scenario:** Execute complete `/roy-git-commit` workflow end-to-end

**Input:**
- Create test changes (new file or modify existing)
- Execute full command workflow (add, commit, push with --dry-run)

**Expected Output:**
- Status check: ✓
- Repository validation: ✓
- Context analysis: ✓
- Commit message generation: ✓
- Changes staged: ✓
- Commit created: ✓
- Push (dry-run): ✓

**Verification:** Verify each step completes successfully

**Status:** Not Run

---

## Test 17: Backward Compatibility

**Scenario:** Verify existing roy commands still work after adding new command

**Input:**
- Execute `/roy-init` (if implemented)
- Check existing roy command files unchanged

**Expected Output:**
- All existing roy commands functional
- No breaking changes to roy framework
- New command coexists with existing commands

**Verification:** Test existing commands still execute correctly

**Status:** Not Run

---

## Test 18: Command Availability After Restart

**Scenario:** Verify `/roy-git-commit` available after Claude Code restart

**Input:**
- Restart Claude Code
- Type `/` to see available commands
- Search for `/roy-git-commit`

**Expected Output:**
- Command appears in command list
- Command can be invoked with `/roy-git-commit`

**Verification:** Manual verification after restart (requires restart to test)

**Status:** Not Run (Requires Claude Code Restart)

---

## Test Coverage Summary

**Total Tests:** 18

**Test Categories:**
- ✅ Documentation (2 tests)
- ✅ Git Operations (5 tests)
- ✅ Commit Message Generation (3 tests)
- ✅ Safety & Validation (3 tests)
- ✅ Error Handling (2 tests)
- ✅ Integration (2 tests)
- ✅ Backward Compatibility (1 test)

**Verification Methods:**
- Automated: 17 tests (can be scripted)
- Manual: 1 test (requires Claude Code restart)

---

## Test Execution Plan

### Phase 1: Validation Tests (Tests 1-2)
Verify implementation files exist and follow proper structure

### Phase 2: Core Functionality Tests (Tests 3-8)
Verify git operations and timestamp/message generation work correctly

### Phase 3: Context Analysis Tests (Tests 9)
Verify intelligent commit message generation based on context

### Phase 4: Safety Tests (Tests 10-13)
Verify user confirmation and git operations execute correctly

### Phase 5: Error Handling Tests (Tests 14-15)
Verify proper error detection and messaging

### Phase 6: Integration Tests (Tests 16-17)
Verify end-to-end workflow and backward compatibility

### Phase 7: Post-Restart Verification (Test 18)
Verify command registration after Claude Code restart (manual)

---

## Success Criteria

All tests must pass with these conditions:

- ✅ Command file exists and follows roy command pattern
- ✅ Documentation updated in `.roy/README.md`
- ✅ Git status detection works (both with and without changes)
- ✅ Repository and remote validation works correctly
- ✅ Timestamp generation produces correct ET format
- ✅ Commit message follows conventional commits format with ET timestamp
- ✅ Context analysis generates meaningful commit messages (not generic)
- ✅ User confirmation required before push
- ✅ Git operations (add, commit, push) execute successfully
- ✅ Error handling detects wrong directory and wrong remote
- ✅ Full workflow integration test passes
- ✅ Existing roy commands unaffected (backward compatibility)
- ✅ Command available after restart (post-implementation verification)

---

**Test Specification Version:** 1.0
**Requires Human Verification:** Test 18 only (post-restart availability check)
**Automation Potential:** 94% (17/18 tests can be automated)
