# Roy Command: Clear Archon Tasks

Delete all Archon tasks with optional backup.

---

## Command

```
/roy-tasks-clear [--backup]
```

---

## Parameters

- `--backup` (optional) - Create timestamped JSON backup before deletion

---

## What This Command Does

This command deletes all agentic orchestration tasks from Archon:

1. **Optional Backup** (if `--backup` flag provided)
   - Fetch all tasks from Archon API
   - Serialize each task to individual JSON file
   - Store in timestamped backup folder: `.roy/backups/archon/tasks/archon-tasks-{timestamp-ET}/`

2. **User Confirmation**
   - Prompt: "Delete all Archon tasks? Type 'confirm' to proceed"
   - Requires explicit "confirm" response
   - Aborts if any other response

3. **Delete Tasks**
   - Delete all tasks via Archon MCP API
   - Report count of tasks deleted

4. **Summary**
   - Statistics on deletion
   - Backup location (if created)

---

## When to Use This Command

Use `/roy-tasks-clear` when you need to reset Archon task state:

- **Before restoring from backup** - Clear current state before restore
- **After completed project phase** - Clean slate for next phase
- **Testing and development** - Reset task state between test runs
- **Accidental task pollution** - Remove incorrect or test tasks

---

## Safety Mechanisms

### Always Use --backup Flag

**Rule:** Unless you are absolutely certain you don't need the tasks, **always** use `--backup` flag.

```
✅ SAFE:   /roy-tasks-clear --backup
❌ RISKY:  /roy-tasks-clear
```

### User Confirmation Required

The command will prompt:
```
Delete all Archon tasks? Type 'confirm' to proceed:
```

You must type exactly **"confirm"** (case-sensitive) to proceed. Any other response aborts.

### Backup Location

Backups are stored with Eastern Time timestamp:

```
.roy/backups/archon/tasks/archon-tasks-20251008-143022-EDT/
├── task_0001_implement_authentication.json
├── task_0002_setup_database.json
├── task_0003_create_api_endpoints.json
└── ...
```

Timestamp format: `YYYYMMDD-HHMMSS-TZ` where TZ is EDT or EST

---

## Example Workflows

### Workflow 1: Safe Clear with Backup

```
User: /roy-tasks-clear --backup

Claude Code:
[Executing archon-task-backup.sh]
✓ Found 47 tasks
✓ Backup created: .roy/backups/archon/tasks/archon-tasks-20251008-143022-EDT/

Delete all Archon tasks? Type 'confirm' to proceed: confirm

[Deleting tasks via Archon API]
✓ Deleted 47 tasks

Summary:
  Tasks deleted: 47
  Backup location: .roy/backups/archon/tasks/archon-tasks-20251008-143022-EDT/

Restore command: /roy-tasks-restore
```

### Workflow 2: Clear Without Backup (Use with Caution)

```
User: /roy-tasks-clear

Claude Code:
⚠️  WARNING: No backup will be created!

Delete all Archon tasks? Type 'confirm' to proceed: confirm

[Deleting tasks via Archon API]
✓ Deleted 47 tasks

Summary:
  Tasks deleted: 47
  Backup: None (no --backup flag)

⚠️  Tasks are permanently deleted and cannot be recovered.
```

### Workflow 3: Abort Deletion

```
User: /roy-tasks-clear --backup

Claude Code:
[Executing archon-task-backup.sh]
✓ Backup created: .roy/backups/archon/tasks/archon-tasks-20251008-143022-EDT/

Delete all Archon tasks? Type 'confirm' to proceed: cancel

Operation aborted. Tasks not deleted.
Backup preserved at: .roy/backups/archon/tasks/archon-tasks-20251008-143022-EDT/
```

---

## What Gets Deleted

**Archon Tasks (Deleted):**
- Roy-orchestrated agentic workflow tasks
- BMAD agent execution tasks
- Claude Code session tasks
- Cross-agent coordination tasks

**GitLab Issues (NOT Deleted):**
- Atlas project user stories, epics, journeys
- Product backlog items
- Sprint tasks and milestones
- Business requirements

**Archon RAG (NOT Deleted):**
- Knowledge base content
- GitLab-synced documentation
- Wiki pages, issue text

---

## Technical Details

### Script Executed

**`.roy/tools/archon-task-backup.sh`** (if --backup flag provided)
- Fetches tasks from `http://localhost:8181/api/tasks`
- Serializes to JSON with auto-numbered filenames
- Preserves all task fields (title, description, status, metadata, etc.)

**Archon MCP API**
- DELETE request to each task endpoint
- Permanent deletion (no "soft delete")

---

## Prerequisites

- Archon MCP server running (`docker compose up -d` in `archon/` folder)
- Write permissions to `.roy/backups/archon/tasks/` folder
- Archon API accessible at http://localhost:8181

---

## Error Handling

**If Archon is not running:**
```
Error: Archon API not accessible at http://localhost:8181
Start Archon: cd /mnt/e/repos/atlas/archon && docker compose up -d
```

**If no tasks exist:**
```
No tasks found in Archon. Nothing to delete.
```

**If backup fails:**
```
Error: Failed to create backup
Aborting deletion for safety.
```

---

## See Also

- **Restore Command:** `/roy-tasks-restore` - Restore tasks from backup
- **Policy:** `.roy/policies/POLICY-data-sources.md` - Task management hierarchy
- **Specification:** `.roy/specifications/SPEC-002-data-flows.md` - Implementation details

---

## Authority

This command is part of the Roy Framework and adheres to:
- **POLICY-data-sources:** Archon is source of truth for agentic orchestration tasks
- **POLICY-context-engineering:** No restart required (modifies data, not commands)

---

**Command Type:** Task Management
**Destructive:** Yes (deletes all tasks)
**Requires Restart:** No
**User Confirmation:** Yes (explicit "confirm" required)
**Backup Recommended:** Always use `--backup` flag
