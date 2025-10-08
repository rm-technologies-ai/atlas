# Roy Command: Git Commit and Push

Automatically stage, commit, and push changes to GitHub with context-aware commit messages.

---

## Command

```
/roy-git-commit
```

---

## Parameters

None (command executes git add, commit, push sequence)

---

## What This Command Does

This command automates the git workflow for committing changes to the GitHub remote main branch:

1. **Check Git Status**
   - Verify current repository is Atlas (`/mnt/e/repos/atlas/`)
   - Verify remote is GitHub (`https://github.com/rm-technologies-ai/atlas.git`)
   - Identify modified, added, and deleted files
   - Display changes to be committed

2. **Generate Context-Aware Commit Message**
   - Analyze git status and recent file changes
   - Review current conversation context
   - Craft meaningful commit message based on work performed
   - Append readable timestamp localized to Eastern Time (ET)

3. **Execute Git Operations**
   - Stage all changes: `git add .`
   - Commit with generated message: `git commit -m "[message] (ET: [timestamp])"`
   - Push to remote main: `git push origin main`

4. **Report Results**
   - Display commit hash
   - Show files committed
   - Confirm successful push to GitHub

---

## When to Use This Command

Use `/roy-git-commit` to quickly commit and push changes after:

- **Implementing roy specifications** - After completing `/roy-agentic-specification` workflow
- **Creating new commands** - After adding new `.claude/commands/` files
- **Updating policies** - After modifying `.roy/policies/` files
- **Documentation changes** - After updating README files or other documentation
- **Tool development** - After creating or modifying scripts in `.roy/tools/`
- **Configuration updates** - After changing environment or configuration files

---

## Commit Message Format

The command generates commit messages in this format:

```
[type]([scope]): [description]

[optional body with details]

(ET: [YYYY-MM-DD HH:MM:SS EDT/EST])
```

**Example commit messages:**

```
feat(roy): add git commit automation command

Implemented /roy-git-commit command to automate git add, commit,
and push operations with context-aware commit messages and ET timestamps.

(ET: 2025-10-08 14:35:22 EDT)
```

```
docs(roy): update README with new data flow commands

Added documentation for /roy-gitlab-refresh, /roy-tasks-clear,
/roy-tasks-restore, and /roy-rag-delete commands.

(ET: 2025-10-08 09:15:10 EDT)
```

```
fix(archon): correct RAG ingest script permissions

Made archon-rag-delete.sh executable and fixed API endpoint URL.

(ET: 2025-10-08 16:42:33 EST)
```

**Commit Type Prefixes:**
- `feat` - New feature or capability
- `fix` - Bug fix or correction
- `docs` - Documentation changes only
- `refactor` - Code restructuring without behavior change
- `chore` - Maintenance tasks, dependency updates
- `test` - Adding or modifying tests

**Scope Examples:**
- `roy` - Roy framework changes
- `archon` - Archon integration changes
- `bmad` - BMAD method changes
- `issues` - GitLab issues tool changes
- `root` - Root-level repository changes

---

## Safety Mechanisms

### Pre-Commit Validation

The command performs these safety checks before committing:

- ✅ Verify current directory is Atlas repository
- ✅ Verify remote points to GitHub (not GitLab or other)
- ✅ Confirm changes exist to commit (don't create empty commits)
- ✅ Warn if uncommitted submodule changes exist
- ✅ Display files to be committed for user review

### User Confirmation

Before pushing to GitHub, the command displays:

```
Changes to be committed:
  M .roy/README.md
  A .claude/commands/roy-git-commit.md
  M CLAUDE.md

Commit message:
feat(roy): add git commit automation command (ET: 2025-10-08 14:35:22 EDT)

Push to GitHub remote main? Type 'confirm' to proceed:
```

User must type **"confirm"** to execute the push. Any other response aborts.

---

## Example Workflows

### Workflow 1: Commit Roy Specification Changes

```
User: /roy-git-commit

Claude Code:
[Analyzing git status and context]

Repository: /mnt/e/repos/atlas
Remote: https://github.com/rm-technologies-ai/atlas.git
Branch: main

Changes to be committed:
  M .roy/README.md
  A .roy/specifications/SPEC-003-git-automation.md
  A .roy/specifications/SPEC-003-git-automation-TESTS.md
  A .claude/commands/roy-git-commit.md

Generated commit message:
feat(roy): implement git commit automation (SPEC-003)

Added /roy-git-commit command to automate git add, commit, and push
operations with intelligent commit message generation and ET timestamps.

(ET: 2025-10-08 14:35:22 EDT)

Push to GitHub remote main? Type 'confirm' to proceed: confirm

[Executing git operations]
✓ Staged all changes
✓ Committed: feat(roy): implement git commit automation (SPEC-003)
  Commit hash: a7f3c9e
✓ Pushed to origin/main

Summary:
  Files committed: 4
  Commit: a7f3c9e
  Remote: https://github.com/rm-technologies-ai/atlas.git
```

### Workflow 2: Abort Push

```
User: /roy-git-commit

Claude Code:
[Analyzing git status and context]

Changes to be committed:
  M CLAUDE.md

Generated commit message:
docs(root): update project overview (ET: 2025-10-08 10:22:15 EDT)

Push to GitHub remote main? Type 'confirm' to proceed: cancel

Operation aborted. Changes staged but not committed.
Run 'git reset' to unstage, or manually commit with 'git commit'.
```

### Workflow 3: No Changes to Commit

```
User: /roy-git-commit

Claude Code:
[Checking git status]

No changes to commit. Working directory is clean.

Run 'git status' to verify, or make changes before committing.
```

---

## Timestamp Format

The command appends Eastern Time (ET) timestamps in this format:

```
(ET: YYYY-MM-DD HH:MM:SS TZ)
```

Where:
- `YYYY-MM-DD` - Date in ISO format
- `HH:MM:SS` - Time in 24-hour format
- `TZ` - Time zone indicator (`EDT` during daylight saving, `EST` otherwise)

**Examples:**
- `(ET: 2025-10-08 14:35:22 EDT)` - October 8, 2025 at 2:35 PM EDT
- `(ET: 2025-12-15 09:12:45 EST)` - December 15, 2025 at 9:12 AM EST

The timestamp reflects the **exact time when the commit is created**, localized to Eastern Time.

---

## Technical Details

### Git Operations Executed

```bash
# 1. Stage all changes
git add .

# 2. Commit with generated message
git commit -m "[context-aware message]

[optional details]

(ET: [timestamp])"

# 3. Push to remote main
git push origin main
```

### Context Analysis for Commit Messages

The command analyzes these sources to generate intelligent commit messages:

1. **Git status** - Modified, added, deleted files
2. **Git diff** - Actual changes in files
3. **Recent conversation context** - What work was just performed
4. **File patterns** - Type of files changed (commands, specs, policies, docs)
5. **Roy specifications** - If working on a specific SPEC-NNN

This analysis produces commit messages that accurately reflect the nature and purpose of changes.

---

## Prerequisites

- Git repository initialized at `/mnt/e/repos/atlas/`
- Remote named `origin` pointing to `https://github.com/rm-technologies-ai/atlas.git`
- User has push permissions to GitHub repository
- Git credentials configured (SSH key or HTTPS token)
- Working on `main` branch (or specify different branch)

---

## Error Handling

**If not in Atlas repository:**
```
Error: Current directory is not Atlas repository
Expected: /mnt/e/repos/atlas/
Current: [actual path]

Navigate to Atlas root: cd /mnt/e/repos/atlas
```

**If remote is not GitHub:**
```
Error: Remote 'origin' does not point to GitHub
Expected: https://github.com/rm-technologies-ai/atlas.git
Actual: [actual remote URL]

Verify remote: git remote -v
```

**If push fails (authentication):**
```
Error: Push to GitHub failed (authentication required)

Configure credentials:
- SSH: Add SSH key to GitHub account
- HTTPS: Generate personal access token at github.com/settings/tokens
```

**If push fails (conflicts):**
```
Error: Push rejected due to remote changes

Pull latest changes first:
git pull origin main --rebase
Then retry: /roy-git-commit
```

**If working directory is clean:**
```
No changes to commit. Working directory is clean.
```

---

## Advanced Usage

### Customizing Commit Message

By default, the command generates commit messages automatically. For custom messages:

1. Let command generate the message
2. Review the generated message when prompted
3. If unsatisfied, abort with any response except "confirm"
4. Manually commit with custom message: `git commit -m "your message"`
5. Manually push: `git push origin main`

### Committing to Different Branch

This command always pushes to `main` branch. To commit to a different branch:

1. Switch branch: `git checkout [branch-name]`
2. Use standard git commands instead of `/roy-git-commit`
3. Or request a future roy specification to support branch parameter

### Partial Staging

This command stages **all changes** with `git add .`. For partial staging:

1. Manually stage specific files: `git add [file1] [file2]`
2. Use standard git commit and push commands
3. Or use `/roy-git-commit` which will only commit staged files

---

## See Also

- **GitHub Repository:** https://github.com/rm-technologies-ai/atlas
- **Git Basics:** Use `git status`, `git log`, `git diff` for manual inspection
- **Roy Specifications:** `.roy/specifications/` - Versioned capability additions
- **Policy:** `.roy/policies/POLICY-context-engineering.md` - When restart required

---

## Authority

This command is part of the Roy Framework and adheres to:
- **POLICY-context-engineering:** Creates `.claude/commands/` file (requires restart after implementation)
- **Roy Evolution Model:** Implements incremental, tested, version-controlled specifications

---

**Command Type:** Version Control Automation
**Destructive:** No (creates commits, does not delete)
**Requires Restart:** No (executes git operations, doesn't modify commands)
**User Confirmation:** Yes (explicit "confirm" required before push)
**Backup Recommended:** Not applicable (git history is the backup)
