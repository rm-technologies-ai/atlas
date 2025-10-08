# Roy Command: GitLab Data Refresh

Synchronize GitLab project data into Archon RAG knowledge base.

---

## Command

```
/roy-gitlab-refresh
```

---

## What This Command Does

This command orchestrates the complete data flow from GitLab to Archon RAG:

1. **Extract GitLab Content**
   - All issues (with full text, comments, events, relations)
   - All wiki pages with content
   - Repository metadata, merge requests
   - Project structure and labels

2. **Store Locally**
   - Cache extracted data in `atlas-project-data/` folder
   - Hierarchical folder structure by project

3. **Clear Previous RAG Data**
   - Delete previous "atlas-project-data" ingest set from Archon RAG
   - Ensures no stale or duplicate records

4. **Ingest Fresh Data**
   - Upload knowledge base to Archon RAG
   - Create entities and relationships for graph queries
   - Chunk and embed for semantic search

5. **Report Results**
   - Statistics on projects, wikis, issues processed
   - Status of RAG ingestion

---

## When to Use This Command

Use `/roy-gitlab-refresh` when you need to synchronize the latest Atlas project data:

- **Before major planning sessions** - Ensure agents have current backlog
- **After significant GitLab updates** - New epics, user stories, or documentation
- **When agents need fresh context** - Before complex analysis or report generation
- **Sprint boundaries** - Sync at start of new sprint for updated priorities

---

## What Agents Can Do After Refresh

Once GitLab data is in Archon RAG, all agents can:

- **Query project data** via `archon:rag_search_knowledge_base()`
- **Enrich prompts** with near-real-time issue/wiki content
- **Ground responses** in actual project state (not assumptions)
- **Generate reports** based on complete, current backlog

---

## Example Workflow

```
User: I need to analyze the Lion platform backlog to identify missing epics

Claude Code: Let me first refresh the GitLab data to ensure I'm working with current information.

[Executes /roy-gitlab-refresh]
[GitLab data extracted → Stored in atlas-project-data/ → Ingested into Archon RAG]

Claude Code: ✓ GitLab data refreshed. Found 247 issues, 18 wiki pages across 12 projects.

Now I'll query the RAG for all epics and analyze coverage...

[Uses archon:rag_search_knowledge_base to query epics, user stories, tasks]
[Performs gap analysis with complete, current data]

Claude Code: Analysis complete. I found 3 epics without sufficient user stories:
1. "Data Lineage Tracking" - has only 2 stories, needs 5-7 more
2. "Advanced Search" - no stories defined yet
3. "Export Functionality" - 1 story, needs workflow definition

Would you like me to draft missing user stories for review?
```

---

## Technical Details

### Scripts Executed

1. **`issues/ingest-gitlab-knowledge.sh`**
   - Extracts all GitLab content via REST API
   - Outputs CSV files for RAG ingestion
   - Creates entity/relationship files for graph

2. **`issues/upload-to-archon.sh`**
   - Uploads extracted data to Archon via API
   - Creates RAG sources and knowledge base entries
   - Tags with "atlas-project-data" ingest set

### Data Sources

- **GitLab Group:** `atlas-datascience/lion`
- **API:** GitLab REST API v4
- **Credentials:** From `.env.atlas` (GITLAB_TOKEN)

### Output Location

- **Local Cache:** `/mnt/e/repos/atlas/atlas-project-data/`
- **Archon RAG:** http://localhost:8181 (via MCP server)

---

## Prerequisites

- Archon MCP server running (`docker compose up -d` in `archon/` folder)
- GitLab API token configured in `.env.atlas`
- Internet connection to GitLab API
- Disk space for `atlas-project-data/` folder (~100MB typical)

---

## Estimated Execution Time

- Small projects (< 50 issues): 30-60 seconds
- Medium projects (50-200 issues): 2-5 minutes
- Large projects (200+ issues): 5-10 minutes

Varies based on:
- Number of issues, wikis, merge requests
- GitLab API rate limits
- Network speed
- Archon RAG processing time

---

## Error Handling

**If Archon is not running:**
```
Error: Archon API not accessible at http://localhost:8181
Start Archon: cd /mnt/e/repos/atlas/archon && docker compose up -d
```

**If GitLab token is invalid:**
```
Error: GITLAB_TOKEN not set or invalid
Check: .env.atlas file contains valid GITLAB_TOKEN
```

**If extraction fails:**
- Review `issues/ingest-gitlab-knowledge.sh` output for API errors
- Check GitLab API rate limits (pause and retry)
- Verify network connectivity

---

## See Also

- **Policy:** `.roy/policies/POLICY-data-sources.md` - Data source hierarchy
- **Specification:** `.roy/specifications/SPEC-002-data-flows.md` - Implementation details
- **Scripts:** `issues/ingest-gitlab-knowledge.sh`, `issues/upload-to-archon.sh`

---

## Authority

This command is part of the Roy Framework and adheres to:
- **POLICY-data-sources:** GitLab is source of truth for Atlas project work items
- **POLICY-context-engineering:** No restart required (modifies data, not commands)

---

**Command Type:** Data Synchronization
**Destructive:** No (refreshes RAG data, does not modify GitLab)
**Requires Restart:** No
**User Confirmation:** No (safe operation)
