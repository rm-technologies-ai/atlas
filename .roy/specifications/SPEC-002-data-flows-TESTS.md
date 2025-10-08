# Roy Specification Tests: SPEC-002 Data Flows

**Test Suite For:** SPEC-002 Data Sources and Data Flows
**Created:** 2025-10-08
**Status:** Defined (Ready for execution)

---

## Test 1: `/roy-gitlab-refresh` - Full GitLab Data Refresh

**Scenario:** Synchronize latest GitLab project data into Archon RAG

**Prerequisites:**
- Archon MCP server running
- GitLab API token configured in `.env.atlas`
- Internet connection to GitLab API

**Input:**
```
/roy-gitlab-refresh
```

**Expected Output:**
1. Status message: "Refreshing GitLab project data → Archon RAG"
2. Execution of `issues/ingest-gitlab-knowledge.sh`
   - Progress output showing projects, wikis, issues extracted
   - CSV files created in `issues/` folder
3. Execution of `issues/upload-to-archon.sh`
   - Upload progress showing documents uploaded to Archon
4. Statistics summary:
   - Total projects extracted
   - Total wikis and wiki pages
   - Total issues
   - Total RAG sources created
5. Success message with completion time

**Verification:**
- Check `atlas-project-data/` folder contains recent data
- Query Archon RAG: `archon:rag_search_knowledge_base(query="Lion platform architecture", match_count=5)`
- Verify results contain GitLab content (issues, wikis)
- Check Archon UI at http://localhost:3737 - Knowledge Base section shows sources

**Status:** Not Run

---

## Test 2: `/roy-tasks-clear --backup` - Backup and Clear Tasks

**Scenario:** Create timestamped backup of all Archon tasks, then delete all tasks

**Prerequisites:**
- Archon MCP server running
- At least 5 tasks exist in Archon (create test tasks if needed)

**Input:**
```
/roy-tasks-clear --backup
```

**Expected Output:**
1. Backup creation messages:
   - "Fetching all tasks from Archon..."
   - "Found X tasks"
   - "Serializing tasks to JSON files..."
   - Progress: "✓ [1/X] Task title"
2. Backup location displayed: `.roy/backups/archon/tasks/archon-tasks-{timestamp-ET}/`
3. User confirmation prompt: "Delete all Archon tasks? Type 'confirm' to proceed:"
4. After typing "confirm":
   - "Deleting tasks via Archon API..."
   - "✓ Deleted X tasks"
5. Summary with backup location

**Verification:**
- Check backup folder exists: `.roy/backups/archon/tasks/archon-tasks-{timestamp}/`
- Verify folder contains JSON files: `task_0001_*.json`, `task_0002_*.json`, etc.
- Count JSON files matches deleted task count
- Open one JSON file - verify valid task structure
- Check Archon - all tasks deleted: `archon:find_tasks()` returns empty array
- Verify timestamp format: `YYYYMMDD-HHMMSS-EDT` or `YYYYMMDD-HHMMSS-EST`

**Status:** Not Run

---

## Test 3: `/roy-tasks-clear` - Clear Without Backup (Abort)

**Scenario:** Attempt to clear tasks without backup, then abort

**Prerequisites:**
- Archon MCP server running
- At least 1 task exists in Archon

**Input:**
```
/roy-tasks-clear
```

**Expected Output:**
1. Warning: "⚠️ WARNING: No backup will be created!"
2. Confirmation prompt: "Delete all Archon tasks? Type 'confirm' to proceed:"
3. User types: "cancel"
4. Abort message: "Operation aborted. Tasks not deleted."

**Verification:**
- Check Archon - tasks still exist: `archon:find_tasks()` returns tasks
- No backup folder created
- No tasks deleted

**Status:** Not Run

---

## Test 4: `/roy-tasks-restore` - Restore from Backup

**Scenario:** Restore tasks from a previous backup

**Prerequisites:**
- Archon MCP server running
- At least one backup exists in `.roy/backups/archon/tasks/`
- Archon tasks currently empty or different from backup

**Input:**
```
/roy-tasks-restore
```

**Expected Output:**
1. "Available Task Backups" header
2. Enumerated list of backups:
   ```
   1. archon-tasks-20251008-143022-EDT  (47 tasks)
   2. archon-tasks-20251008-120000-EDT  (52 tasks)
   ...
   ```
3. Prompt: "Enter backup number to restore (or 'cancel'):"
4. User enters: "1"
5. Restore progress:
   - "Restoring from: archon-tasks-20251008-143022-EDT"
   - "Found X task files to restore"
   - Progress: "✓ [1/X] Task title"
6. Summary:
   - "Tasks restored: X"
   - "Failed: 0" (or count if any failures)

**Verification:**
- Check Archon - tasks restored: `archon:find_tasks()` returns restored tasks
- Count matches backup task count
- Task titles match backup JSON files
- Task statuses preserved (todo, doing, done)

**Status:** Not Run

---

## Test 5: `/roy-tasks-restore` - No Backups Available

**Scenario:** Attempt to restore when no backups exist

**Prerequisites:**
- `.roy/backups/archon/tasks/` folder empty or doesn't exist

**Input:**
```
/roy-tasks-restore
```

**Expected Output:**
1. Error message: "No task backups found in .roy/backups/archon/tasks/"
2. Help text:
   ```
   Create a backup first:
     /roy-tasks-clear --backup

   Then restore with:
     /roy-tasks-restore
   ```

**Verification:**
- Command exits gracefully
- No errors or crashes

**Status:** Not Run

---

## Test 6: `/roy-rag-delete --ingest-set:atlas-project-data` - Delete Specific Ingest Set

**Scenario:** Delete only RAG records from atlas-project-data ingest set

**Prerequisites:**
- Archon MCP server running
- Archon RAG contains sources tagged with "atlas-project-data"
- Archon RAG contains sources from other ingest sets (or untagged sources)

**Input:**
```
/roy-rag-delete --ingest-set:atlas-project-data
```

**Expected Output:**
1. Mode: "Delete ingest set 'atlas-project-data'"
2. "Fetching current RAG sources..."
3. "Total sources in RAG: X"
4. "Sources matching ingest set 'atlas-project-data': Y"
5. Confirmation prompt: "Delete RAG records for ingest set 'atlas-project-data'? Type 'confirm' to proceed:"
6. User types: "confirm"
7. Deletion progress:
   - "Deleting Y RAG sources..."
   - Progress: "✓ [1/Y] [entity_type] Entity name"
8. Summary:
   - "Sources deleted: Y"
   - "Failed: 0" (or count if failures)

**Verification:**
- Count sources before deletion
- After deletion: Sources matching "atlas-project-data" = 0
- Other sources remain (total sources after = X - Y)
- Query RAG for atlas data: `archon:rag_search_knowledge_base(query="Lion platform", match_count=5)` returns no results or different sources

**Status:** Not Run

---

## Test 7: `/roy-rag-delete --force` - Delete All RAG Records (Abort)

**Scenario:** Attempt force delete all RAG records, then abort

**Prerequisites:**
- Archon MCP server running
- Archon RAG contains sources

**Input:**
```
/roy-rag-delete --force
```

**Expected Output:**
1. Mode: "DELETE ALL RAG RECORDS (FORCE)"
2. "Total sources in RAG: X"
3. Warning prompt: "⚠️ DELETE ALL X RAG RECORDS? Type 'confirm' to proceed:"
4. User types: "cancel"
5. Abort message: "Operation aborted. No records deleted."

**Verification:**
- Check Archon RAG - all sources still exist
- Source count unchanged

**Status:** Not Run

---

## Test 8: `/roy-rag-delete --force` - Delete All RAG Records (Confirmed)

**Scenario:** Force delete all RAG records with confirmation

**Prerequisites:**
- Archon MCP server running
- Archon RAG contains sources
- **⚠️ WARNING:** This is destructive - only run in test environment

**Input:**
```
/roy-rag-delete --force
```

**Expected Output:**
1. Mode: "DELETE ALL RAG RECORDS (FORCE)"
2. "Total sources in RAG: X"
3. Prompt: "⚠️ DELETE ALL X RAG RECORDS? Type 'confirm' to proceed:"
4. User types: "confirm"
5. Deletion progress for all X sources
6. Summary:
   - "Sources deleted: X"
   - Warning: "⚠️ All RAG records have been deleted."

**Verification:**
- Check Archon RAG - all sources deleted
- `archon:rag_get_available_sources()` returns empty array
- Archon UI shows empty Knowledge Base

**Status:** Not Run

---

## Test 9: `/roy-rag-delete` - Invalid Parameters

**Scenario:** Test parameter validation

**Input 1:** (no parameters)
```
/roy-rag-delete
```

**Expected Output 1:**
- Error: "Must specify either --ingest-set:<name> or --force"
- Usage instructions displayed

**Input 2:** (both parameters)
```
/roy-rag-delete --ingest-set:atlas-project-data --force
```

**Expected Output 2:**
- Error: "Cannot specify both --ingest-set and --force. Choose one."
- Usage instructions displayed

**Input 3:** (invalid parameter)
```
/roy-rag-delete --invalid
```

**Expected Output 3:**
- Error: "Invalid argument '--invalid'"
- Usage instructions displayed

**Verification:**
- Commands exit with error
- No RAG records deleted
- Error messages are clear and helpful

**Status:** Not Run

---

## Test 10: Eastern Time Timestamp Format

**Scenario:** Verify backup timestamps use Eastern Time with correct timezone indicator

**Prerequisites:**
- Archon MCP server running

**Input:**
```
/roy-tasks-clear --backup
```

**Expected Output:**
- Backup folder created with timestamp format: `archon-tasks-YYYYMMDD-HHMMSS-TZ`
- Where TZ is either "EDT" or "EST" depending on current date

**Verification:**
- Check backup folder name matches pattern
- Verify timezone indicator:
  - If date is Mar-Nov: EDT (Eastern Daylight Time)
  - If date is Nov-Mar: EST (Eastern Standard Time)
- Verify timestamp is accurate (within 1 minute of current Eastern Time)

**Example valid timestamps:**
- `archon-tasks-20251008-143022-EDT` (October = EDT)
- `archon-tasks-20251215-093015-EST` (December = EST)

**Status:** Not Run

---

## Test 11: Integration Test - Full Data Flow Cycle

**Scenario:** Complete end-to-end data flow from GitLab to RAG to Agent query

**Prerequisites:**
- Archon MCP server running
- GitLab contains test issues and wikis
- GitLab API credentials configured

**Workflow:**
1. Clear existing RAG data:
   ```
   /roy-rag-delete --ingest-set:atlas-project-data
   ```
   Confirm deletion

2. Refresh GitLab data:
   ```
   /roy-gitlab-refresh
   ```
   Wait for completion

3. Verify data in RAG:
   ```
   archon:rag_search_knowledge_base(query="test issue", match_count=5)
   ```
   Should return results

4. Agent uses data:
   - Query for specific epic, user story, or wiki page
   - Verify results are current (not stale)
   - Verify results match GitLab content

**Expected Outcome:**
- Complete data pipeline functional
- Agent can query fresh GitLab content
- Results are accurate and complete

**Status:** Not Run

---

## Test 12: Backup and Restore Cycle

**Scenario:** Complete backup/restore cycle preserves task state

**Prerequisites:**
- Archon MCP server running
- 10+ test tasks in Archon with various statuses

**Workflow:**
1. Record initial state:
   - Query tasks: `archon:find_tasks()`
   - Note task count, titles, statuses

2. Backup and clear:
   ```
   /roy-tasks-clear --backup
   ```
   Confirm deletion

3. Verify empty:
   - Query tasks: `archon:find_tasks()` should return empty

4. Restore from backup:
   ```
   /roy-tasks-restore
   ```
   Select most recent backup

5. Verify restored state:
   - Query tasks: `archon:find_tasks()`
   - Compare to initial state
   - Task count matches
   - Task titles match
   - Task statuses match

**Expected Outcome:**
- Task state fully preserved through backup/restore cycle
- No data loss
- Timestamps may differ (new created_at dates)

**Status:** Not Run

---

## Test Summary

| Test # | Test Name | Category | Status | Priority |
|--------|-----------|----------|--------|----------|
| 1 | GitLab Data Refresh | Integration | Not Run | High |
| 2 | Backup and Clear Tasks | Task Management | Not Run | High |
| 3 | Clear Without Backup (Abort) | Safety | Not Run | Medium |
| 4 | Restore from Backup | Task Management | Not Run | High |
| 5 | Restore - No Backups | Error Handling | Not Run | Low |
| 6 | Delete Specific Ingest Set | RAG Management | Not Run | High |
| 7 | Force Delete (Abort) | Safety | Not Run | Medium |
| 8 | Force Delete (Confirmed) | RAG Management | Not Run | Medium |
| 9 | Invalid Parameters | Validation | Not Run | Low |
| 10 | Eastern Time Timestamps | Utility | Not Run | Medium |
| 11 | Full Data Flow Cycle | Integration | Not Run | High |
| 12 | Backup/Restore Cycle | Integration | Not Run | High |

---

## Test Execution Notes

### High Priority Tests (Must Pass)
- Test 1: GitLab Data Refresh
- Test 2: Backup and Clear Tasks
- Test 4: Restore from Backup
- Test 6: Delete Specific Ingest Set
- Test 11: Full Data Flow Cycle
- Test 12: Backup/Restore Cycle

### Safety Tests (Important)
- Test 3: Clear Without Backup (Abort)
- Test 7: Force Delete (Abort)

### Edge Case Tests (Nice to Have)
- Test 5: Restore - No Backups
- Test 9: Invalid Parameters
- Test 10: Eastern Time Timestamps

---

## Prerequisites for Test Execution

1. **Archon MCP Server**
   ```bash
   cd /mnt/e/repos/atlas/archon
   docker compose up -d
   ```

2. **GitLab API Credentials**
   - Verify `.env.atlas` contains valid `GITLAB_TOKEN`

3. **Test Data in GitLab**
   - At least 5 issues in `atlas-datascience/lion` group
   - At least 2 wiki pages
   - At least 1 project

4. **Test Data in Archon**
   - Create 10 test tasks before running task management tests
   ```
   archon:manage_task(action="create", project_id="...", title="Test Task 1", ...)
   ```

5. **Clean Test Environment**
   - Backup production data before testing destructive operations
   - Use separate Archon instance for testing if possible

---

## Test Execution Checklist

Before marking SPEC-002 as "Verified":

- [ ] All High Priority tests pass
- [ ] All Safety tests pass
- [ ] At least 2 Edge Case tests pass
- [ ] No regressions in existing roy functionality
- [ ] Commands available after Claude Code restart
- [ ] Documentation accurate (commands work as documented)
- [ ] Error messages clear and helpful
- [ ] Performance acceptable (refresh completes in < 10 minutes for typical data)

---

**Test Suite Owner:** Roy Framework
**Last Updated:** 2025-10-08
**Next Review:** After all tests executed and verified
