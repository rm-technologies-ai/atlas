# Roy Command: Delete Archon RAG Records

Delete Archon RAG records by ingest set or all records.

---

## Command

```
/roy-rag-delete --ingest-set:<name>
/roy-rag-delete --force
```

---

## Parameters

**Exactly one parameter required:**

- `--ingest-set:<name>` - Delete only records from specified ingest set
- `--force` - Delete ALL RAG records (use with extreme caution)

---

## What This Command Does

This command deletes RAG/knowledge base records from Archon:

1. **Parameter Validation**
   - Verify exactly one parameter provided
   - Parse ingest set name or force flag

2. **Fetch Current RAG Sources**
   - Query Archon API for all RAG sources
   - Display total count
   - Filter by ingest set (if applicable)

3. **User Confirmation**
   - Prompt: "Delete RAG records [<set> | ALL]? Type 'confirm' to proceed"
   - Requires explicit "confirm" response
   - Aborts if any other response

4. **Delete Records**
   - Delete matching sources via Archon API
   - Report progress for each deletion
   - Rate limiting to prevent API overload

5. **Summary**
   - Statistics on deleted records
   - Failed count (if any)

---

## When to Use This Command

### Use Case 1: Re-ingest Updated GitLab Data

**Before running `/roy-gitlab-refresh`**, clear previous GitLab data:

```
/roy-rag-delete --ingest-set:atlas-project-data
/roy-gitlab-refresh
```

**Why:** Prevents duplicate records and stale data in RAG.

### Use Case 2: Clean Up Incorrect Data

If RAG contains incorrect or test data, delete specific ingest set:

```
/roy-rag-delete --ingest-set:test-data
```

### Use Case 3: Reset RAG to Empty State

**Rarely needed**, but available for complete reset:

```
/roy-rag-delete --force
```

**⚠️ WARNING:** This deletes ALL knowledge base content. Only use when:
- Archon RAG is corrupted
- Starting fresh environment
- Testing RAG ingestion from scratch

---

## Ingest Sets

### Currently Defined

- **`atlas-project-data`** - GitLab issues, wikis, repos from Atlas project
  - Created by `/roy-gitlab-refresh`
  - Contains all synced GitLab content

### Future Ingest Sets (To Be Defined)

- `external-docs` - Public documentation, API references
- `research` - Papers, articles, technical resources
- `conversations` - Historical Claude Code session transcripts

---

## Safety Mechanisms

### User Confirmation Required

The command will prompt:

```
Delete RAG records for ingest set 'atlas-project-data'? Type 'confirm' to proceed:
```

or (for --force):

```
⚠️  DELETE ALL RAG RECORDS? Type 'confirm' to proceed:
```

You must type exactly **"confirm"** (case-sensitive) to proceed. Any other response aborts.

### No Backup Created

**⚠️ IMPORTANT:** This command does NOT create backups of RAG data.

**Mitigation:** RAG data can be re-ingested from source of truth:
- GitLab data: Run `/roy-gitlab-refresh`
- Other sources: Re-run original ingestion process

---

## Example Workflows

### Workflow 1: Delete Specific Ingest Set

```
User: /roy-rag-delete --ingest-set:atlas-project-data

Claude Code:
============================================================
Archon RAG Delete
============================================================
API: http://localhost:8181
Mode: Delete ingest set 'atlas-project-data'

Fetching current RAG sources...
Total sources in RAG: 342

Sources matching ingest set 'atlas-project-data': 287

Delete RAG records for ingest set 'atlas-project-data'? Type 'confirm' to proceed: confirm

Deleting 287 RAG sources...
✓ [1/287] [project] Lion Platform
✓ [2/287] [wiki_page] System Architecture
✓ [3/287] [issue] Implement Edge Connector
...
✓ [287/287] [issue] Update documentation

============================================================
Delete Complete!
============================================================

Statistics:
  Sources deleted: 287
  Failed: 0
  Total attempted: 287
```

### Workflow 2: Force Delete All Records

```
User: /roy-rag-delete --force

Claude Code:
============================================================
Archon RAG Delete
============================================================
API: http://localhost:8181
Mode: DELETE ALL RAG RECORDS (FORCE)

Fetching current RAG sources...
Total sources in RAG: 342

⚠️  DELETE ALL 342 RAG RECORDS? Type 'confirm' to proceed: confirm

Deleting 342 RAG sources...
[... progress output ...]

============================================================
Delete Complete!
============================================================

Statistics:
  Sources deleted: 342
  Failed: 0
  Total attempted: 342

⚠️  All RAG records have been deleted.
Re-ingest data with /roy-gitlab-refresh or other ingestion commands.
```

### Workflow 3: Abort Deletion

```
User: /roy-rag-delete --ingest-set:atlas-project-data

[... displays source count ...]

Delete RAG records for ingest set 'atlas-project-data'? Type 'confirm' to proceed: cancel

Operation aborted. No records deleted.
```

### Workflow 4: Invalid Parameters

```
User: /roy-rag-delete

Claude Code:
Error: Must specify either --ingest-set:<name> or --force

Usage:
  /roy-rag-delete --ingest-set:atlas-project-data
  /roy-rag-delete --force
```

```
User: /roy-rag-delete --ingest-set:atlas-project-data --force

Claude Code:
Error: Cannot specify both --ingest-set and --force. Choose one.

Usage:
  /roy-rag-delete --ingest-set:<name>  (delete specific set)
  /roy-rag-delete --force               (delete all records)
```

---

## Technical Details

### Script Executed

**`.roy/tools/archon-rag-delete.sh`**
- Fetches sources from `http://localhost:8181/api/sources`
- Filters by tags or URL pattern for ingest set matching
- DELETE request to `/api/sources/{id}` for each source
- Rate limiting (0.05s between requests)

### Ingest Set Detection

Sources are identified by ingest set through:
- **Tags:** Sources tagged with ingest set name
- **URL pattern:** Source URL contains ingest set identifier
- **Metadata:** Custom metadata field (if implemented)

**Note:** Exact detection logic depends on Archon schema. Current implementation uses tag-based filtering.

---

## Prerequisites

- Archon MCP server running (`docker compose up -d` in `archon/` folder)
- Archon API accessible at http://localhost:8181
- Proper permissions to delete RAG sources

---

## Error Handling

**If Archon is not running:**
```
Error: Archon API not accessible at http://localhost:8181
Start Archon: cd /mnt/e/repos/atlas/archon && docker compose up -d
```

**If ingest set not found:**
```
No sources found for ingest set 'atlas-project-data'. Nothing to delete.
```

**If some deletions fail:**
```
⚠ Some sources failed to delete. Check Archon logs for details.

Statistics:
  Sources deleted: 280
  Failed: 7
  Total attempted: 287
```

---

## Recovery

### After Deleting Ingest Set

Re-ingest from source of truth:

**GitLab data (atlas-project-data):**
```
/roy-gitlab-refresh
```

**Other sources:**
Run original ingestion process for that source.

### After Force Delete

Re-ingest all data sources:

```
/roy-gitlab-refresh                    # GitLab data
# Run other ingestion commands as needed
```

---

## Best Practices

### Before Deleting

1. **Verify ingest set name** - Check available ingest sets in Archon UI
2. **Consider impact** - Know which agents/queries depend on this data
3. **Plan re-ingestion** - Ensure you can restore data if needed

### After Deleting

1. **Re-ingest if needed** - Run appropriate ingestion command
2. **Verify RAG queries** - Test that agents can still access needed data
3. **Monitor performance** - Fresh RAG data may improve query speed

### Force Delete

**Only use `--force` when:**
- Archon RAG is corrupted beyond repair
- Migrating to new Archon instance
- Testing RAG setup from scratch
- Absolutely certain you want to delete everything

**Never use `--force` when:**
- You only want to update one ingest set (use `--ingest-set` instead)
- You're not sure what's in the RAG (explore first)
- Other users depend on RAG data (coordinate first)

---

## See Also

- **Refresh Command:** `/roy-gitlab-refresh` - Re-ingest GitLab data
- **Policy:** `.roy/policies/POLICY-data-sources.md` - Data source hierarchy
- **Specification:** `.roy/specifications/SPEC-002-data-flows.md` - Implementation details

---

## Authority

This command is part of the Roy Framework and adheres to:
- **POLICY-data-sources:** GitLab is source of truth; RAG is read-only derivation
- **POLICY-context-engineering:** No restart required (modifies data, not commands)

---

**Command Type:** Knowledge Base Management
**Destructive:** Yes (deletes RAG records, no backup)
**Requires Restart:** No
**User Confirmation:** Yes (explicit "confirm" required)
**Recoverable:** Yes (re-ingest from source of truth)
