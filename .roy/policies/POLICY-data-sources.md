# POLICY: Data Sources and Authority Hierarchy

**Policy ID:** POLICY-data-sources
**Domain:** Roy Framework - Data Source Management
**Status:** Active
**Created:** 2025-10-08
**Last Updated:** 2025-10-08

---

## 🎯 Policy Statement

**The roy framework orchestrates data flows between multiple sources of truth, each with defined authority and responsibility boundaries.**

This policy establishes the authoritative hierarchy for task management, project data, and knowledge base content to ensure data integrity and clear ownership.

---

## 📊 Data Source Hierarchy

### Source of Truth: Archon Tasks

**Authority:** All tasks being executed and orchestrated under the roy framework

**Responsibility:**
- Agentic task creation, tracking, and completion
- Cross-session task persistence
- Multi-agent task visibility
- Workflow orchestration state

**System:** Archon MCP Server (http://localhost:8181)

**Management:**
- Created/updated via roy framework and subordinate agents
- Managed through Archon MCP tools (`archon:manage_task`)
- Backed up via `/roy-tasks-clear --backup`
- Restored via `/roy-tasks-restore`

**What Archon Tasks ARE:**
- Roy-orchestrated agentic workflow tasks
- BMAD agent execution tasks
- Claude Code session tasks with persistence requirements
- Cross-agent coordination tasks

**What Archon Tasks ARE NOT:**
- Atlas project user stories, epics, journeys (those belong in GitLab)
- GitLab issues or milestones
- Business requirements or product backlog items

---

### Source of Truth: GitLab Issues

**Authority:** All Atlas project work items (user stories, tasks, epics, journeys, milestones, releases)

**Responsibility:**
- Product backlog management
- Sprint planning and tracking
- Business requirements
- Release management
- Team collaboration and visibility

**System:** GitLab at `https://gitlab.com/atlas-datascience/lion`

**Management:**
- Created/updated manually via GitLab UI or API
- **NOT managed by Archon tasks**
- Synchronized to Archon RAG via `/roy-gitlab-refresh` for read-only querying

**What GitLab Issues ARE:**
- Product features and user stories
- Business epics and journeys
- Sprint tasks and subtasks
- Bug reports and technical debt
- Release milestones

**What GitLab Issues ARE NOT:**
- Agentic workflow orchestration tasks
- Temporary session-scoped work items
- Tool execution tracking

---

### Data Flow: GitLab → RAG → Agents

**Pipeline:**
```
GitLab (Source of Truth)
    ↓
    [Extract via /roy-gitlab-refresh]
    ↓
atlas-project-data/ (Local Cache)
    ↓
    [Ingest into Archon RAG]
    ↓
Archon RAG/Knowledge Base (Read-Only Query Layer)
    ↓
    [Available to all agents via rag_search_knowledge_base]
    ↓
BMAD Agents, Claude Code, Roy Framework
(Enrich and ground prompts with project data)
```

**Purpose:**
Enable all agents to query near-real-time Atlas project data (issues, wikis, repos) to enrich and ground agentic prompts, resulting in responses that are:
- **Correct** - Based on actual project state
- **Complete** - Incorporating all relevant context
- **Precise** - Aligned with current requirements

**Data Freshness:**
- Run `/roy-gitlab-refresh` to synchronize latest GitLab content
- Recommended frequency: Before major planning sessions, sprint boundaries, or when requirements change

---

## 🔄 Data Flow Commands

### Command: `/roy-gitlab-refresh`

**Purpose:** Synchronize GitLab project data into Archon RAG

**Workflow:**
1. Extract all GitLab content (issues, wikis, repos, merge requests, metadata)
2. Store in `atlas-project-data/` folder
3. Clear previous "atlas-project-data" RAG ingest set from Archon
4. Ingest fresh data into Archon RAG
5. Report statistics

**When to Use:**
- Before major sprint planning
- After significant GitLab issue updates
- When agents need current project context
- Before generating reports or analysis

**Data Extracted:**
- All issues with full text, comments, events, relations
- All wiki pages with content
- Repository metadata, merge requests
- Project structure and labels

---

### Command: `/roy-tasks-clear`

**Purpose:** Delete all Archon tasks (agentic orchestration tasks)

**Workflow:**
1. Optional: Create timestamped backup with `--backup` flag
2. Prompt user for confirmation
3. Delete all tasks via Archon MCP API
4. Report success with count

**When to Use:**
- Resetting agentic task state for testing
- Cleaning up after completed project phase
- Before restoring from backup

**Safety:**
- **Always** use `--backup` flag unless absolutely certain
- Requires explicit user confirmation
- Backup location: `.roy/backups/archon/tasks/archon-tasks-{timestamp-ET}/`

---

### Command: `/roy-tasks-restore`

**Purpose:** Restore Archon tasks from backup

**Workflow:**
1. Scan `.roy/backups/archon/tasks/` for available backups
2. Present enumerated list to user
3. User selects backup by number
4. Deserialize and upsert tasks into Archon
5. Report success with count

**When to Use:**
- Disaster recovery after accidental deletion
- Restoring known-good state for testing
- Migrating tasks between environments

---

### Command: `/roy-rag-delete`

**Purpose:** Delete Archon RAG records by ingest set or all records

**Syntax:**
- `/roy-rag-delete --ingest-set:<name>` - Delete specific ingest set
- `/roy-rag-delete --force` - Delete ALL RAG records

**Workflow:**
1. Parse and validate parameters (exactly one required)
2. Prompt user for confirmation
3. Delete RAG records via Archon API
4. Report success with count

**When to Use:**
- Before re-ingesting updated GitLab data
- Cleaning up stale or incorrect RAG data
- Resetting knowledge base to empty state

**Ingest Sets:**
- `atlas-project-data` - GitLab issues, wikis, repos from Atlas project
- (Future sets to be defined)

**Safety:**
- Requires explicit user confirmation
- `--force` flag is destructive - use with extreme caution
- No backup created - RAG data must be re-ingested from source

---

## 🛡️ Data Integrity Principles

### Principle 1: Single Source of Truth

**Rule:** Each data type has exactly one authoritative source

- **Agentic Tasks** → Archon
- **Project Work Items** → GitLab
- **Knowledge/Documentation** → GitLab (synced to RAG for querying)

**Violation Example:** Creating Atlas project user stories in Archon tasks (should be in GitLab)

**Correct Approach:** Create user story in GitLab, sync via `/roy-gitlab-refresh`, query via RAG

---

### Principle 2: Read-Only Derivations

**Rule:** Derived data layers (RAG) are read-only query interfaces, not sources of truth

- Archon RAG content is **derived** from GitLab
- Agents **query** RAG but do not update it
- Updates flow from source of truth → RAG, never reverse

**Violation Example:** Agent updates RAG content directly

**Correct Approach:** Agent identifies needed change → Update source of truth (GitLab) → Run `/roy-gitlab-refresh` → RAG updated

---

### Principle 3: Separation of Concerns

**Rule:** Agentic orchestration tasks are separate from business project tasks

- **Archon Tasks:** "Roy framework: Ingest GitLab wiki pages into RAG"
- **GitLab Issues:** "Implement user authentication for Lion platform"

**Why Separate:**
- Different lifecycles (agentic tasks are ephemeral, project tasks persist across sprints)
- Different audiences (roy/agents vs. product team)
- Different management workflows (API-driven vs. human-driven)

---

### Principle 4: Controlled Synchronization

**Rule:** Data flow from source of truth to derived layers is deliberate and controlled

- Manual trigger: `/roy-gitlab-refresh` command
- Not automatic/reactive (prevents unnecessary API calls and processing)
- User decides when fresh data is needed

**Future Enhancement:** Scheduled/automated refresh with incremental sync optimization

---

## 📚 References

- `.roy/specifications/SPEC-002-data-flows.md` - Implementation details
- `.claude/commands/roy-gitlab-refresh.md` - GitLab sync command
- `.claude/commands/roy-tasks-clear.md` - Task deletion command
- `.claude/commands/roy-tasks-restore.md` - Task restore command
- `.claude/commands/roy-rag-delete.md` - RAG deletion command
- `issues/ingest-gitlab-knowledge.sh` - GitLab extraction script
- `issues/upload-to-archon.sh` - Archon RAG upload script

---

## 🔮 Future Enhancements

### Incremental Synchronization

**Current:** `/roy-gitlab-refresh` performs full extract/delete/re-ingest

**Future:** Smart incremental sync based on:
- GitLab updated_at timestamps
- Change detection (issues modified since last sync)
- Partial ingest set updates (only changed entities)

**Benefit:** Faster sync, reduced API calls, lower processing overhead

### Automated Refresh Triggers

**Current:** Manual command execution

**Future:** Automatic refresh based on:
- Time-based schedule (e.g., daily at midnight)
- Event-driven (GitLab webhook notifications)
- Agent request with staleness detection

**Benefit:** Always-fresh RAG data without manual intervention

### Multi-Source RAG Ingestion

**Current:** Single ingest set (atlas-project-data)

**Future:** Multiple labeled ingest sets:
- `atlas-project-data` - GitLab issues/wikis/repos
- `external-docs` - Public documentation, API references
- `research` - Papers, articles, technical resources
- `conversations` - Historical Claude Code session transcripts

**Benefit:** Organized knowledge base with source attribution

---

## 📝 Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2025-10-08 | Initial policy creation via SPEC-002 |

---

**Policy Owner:** Roy Framework
**Review Frequency:** As needed (via `/roy-agentic-specification`)
**Next Review:** When incremental sync is implemented
