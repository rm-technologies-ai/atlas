# Roy Command: Restore Archon Tasks

Restore Archon tasks from timestamped JSON backup.

---

## Command

```
/roy-tasks-restore
```

---

## What This Command Does

This command restores agentic orchestration tasks to Archon from a previous backup:

1. **Scan for Backups**
   - Search `.roy/backups/archon/tasks/` for backup folders
   - List all available backups with timestamps
   - Sort by date (newest first)

2. **Present Options**
   - Display enumerated list to user
   - Show backup timestamp and task count

3. **User Selection**
   - User inputs number corresponding to desired backup
   - Validates selection

4. **Restore Tasks**
   - Read all task JSON files from selected backup
   - Deserialize task data
   - Upsert each task into Archon via API
   - Report success/failure for each task

5. **Summary**
   - Statistics on restored tasks
   - Failed count (if any)

---

## When to Use This Command

Use `/roy-tasks-restore` when you need to recover or restore task state:

- **After accidental deletion** - Disaster recovery with `/roy-tasks-clear`
- **Restore known-good state** - Return to previous task configuration
- **Testing scenarios** - Load specific task set for testing
- **Environment migration** - Copy tasks between Archon instances

---

## Example Workflow

### Workflow 1: Standard Restore

```
User: /roy-tasks-restore

Claude Code:
============================================================
Available Task Backups
============================================================

1. archon-tasks-20251008-143022-EDT  (47 tasks)
2. archon-tasks-20251008-120000-EDT  (52 tasks)
3. archon-tasks-20251007-180500-EDT  (43 tasks)
4. archon-tasks-20251006-093015-EDT  (38 tasks)

Enter backup number to restore (or 'cancel'): 1

Restoring from: archon-tasks-20251008-143022-EDT
Found 47 task files to restore

[Restoring tasks to Archon...]
✓ [1/47] Implement user authentication
✓ [2/47] Setup database schema
✓ [3/47] Create API endpoints
...
✓ [47/47] Deploy to staging

============================================================
Restore Complete!
============================================================

Statistics:
  Tasks restored: 47
  Failed: 0
  Total in backup: 47
```

### Workflow 2: No Backups Available

```
User: /roy-tasks-restore

Claude Code:
No task backups found in .roy/backups/archon/tasks/

Create a backup first:
  /roy-tasks-clear --backup

Then restore with:
  /roy-tasks-restore
```

### Workflow 3: Partial Restore Failure

```
User: /roy-tasks-restore

[User selects backup #2]

[Restoring tasks...]
✓ [1/52] Task A
✓ [2/52] Task B
✗ [3/52] Failed: Task C (duplicate ID conflict)
✓ [4/52] Task D
...

============================================================
Restore Complete!
============================================================

Statistics:
  Tasks restored: 49
  Failed: 3
  Total in backup: 52

⚠ Some tasks failed to restore. Check Archon logs for details.
```

---

## Technical Details

### Backup Structure

Each backup folder contains auto-numbered JSON files:

```
.roy/backups/archon/tasks/archon-tasks-20251008-143022-EDT/
├── task_0001_implement_authentication.json
├── task_0002_setup_database.json
├── task_0003_create_api_endpoints.json
├── task_0004_write_documentation.json
└── ...
```

**JSON File Format:**
```json
{
  "title": "Implement user authentication",
  "description": "Add JWT-based authentication to API",
  "status": "doing",
  "project_id": "3f2b6ee9-05ff-48ae-ad6f-54cad080addc",
  "feature": "Authentication",
  "task_order": 100,
  "metadata": {
    "tags": ["security", "backend"],
    "estimated_hours": 8
  }
}
```

Note: The `id` field is removed during restore (Archon assigns new IDs)

### Script Executed

**`.roy/tools/archon-task-restore.sh`**
- Reads all `task_*.json` files from selected backup
- Removes `id` field to prevent conflicts
- POSTs to `http://localhost:8181/api/tasks` for each task
- Rate limiting (0.1s between requests)

---

## Behavior Notes

### ID Assignment

**Original task IDs are NOT preserved.** Archon assigns new IDs during restore.

**Why:** Prevents ID conflicts if tasks already exist. Each restore creates fresh task entries.

**Implication:** Cross-references by ID will break. Use task titles or metadata for linking.

### Duplicate Handling

If a task with identical content already exists, restore behavior depends on Archon API:
- **Upsert mode:** Updates existing task
- **Create mode:** Creates duplicate task
- **Error mode:** Fails with duplicate error

Current implementation uses **create mode** (new tasks always created).

### Timestamps

Restored tasks receive **new timestamps** (created_at, updated_at) at restore time. Original timestamps from backup are not preserved.

### Project References

If `project_id` in backup no longer exists in Archon, task restore may fail or create orphaned task. Verify projects exist before restoring.

---

## Prerequisites

- Archon MCP server running (`docker compose up -d` in `archon/` folder)
- At least one backup exists in `.roy/backups/archon/tasks/`
- Read permissions for backup folder
- Archon API accessible at http://localhost:8181

---

## Error Handling

**If Archon is not running:**
```
Error: Archon API not accessible at http://localhost:8181
Start Archon: cd /mnt/e/repos/atlas/archon && docker compose up -d
```

**If backup folder doesn't exist:**
```
Error: Backup directory not found: .roy/backups/archon/tasks/archon-tasks-20251008-143022-EDT
```

**If backup folder is empty:**
```
Error: No task files found in backup directory
```

**If restore fails for some tasks:**
```
⚠ Some tasks failed to restore. Check Archon logs for details.
```

---

## Best Practices

### Before Restoring

1. **Review current state** - Check existing Archon tasks with `archon:find_tasks()`
2. **Backup current state** - Run `/roy-tasks-clear --backup` before restore
3. **Verify backup contents** - Ensure selected backup contains expected tasks

### After Restoring

1. **Verify task count** - Use `archon:find_tasks()` to confirm all tasks restored
2. **Check task status** - Verify statuses match expectations (todo, doing, done)
3. **Update references** - Fix any cross-references broken by ID changes

---

## See Also

- **Clear Command:** `/roy-tasks-clear` - Delete tasks and create backups
- **Policy:** `.roy/policies/POLICY-data-sources.md` - Task management hierarchy
- **Specification:** `.roy/specifications/SPEC-002-data-flows.md` - Implementation details

---

## Authority

This command is part of the Roy Framework and adheres to:
- **POLICY-data-sources:** Archon is source of truth for agentic orchestration tasks
- **POLICY-context-engineering:** No restart required (modifies data, not commands)

---

**Command Type:** Task Management
**Destructive:** No (creates new tasks, does not delete)
**Requires Restart:** No
**User Confirmation:** Yes (backup selection required)
**Idempotent:** No (multiple restores create duplicate tasks)
