# Roy Specification 002: Data Sources and Data Flows

**Specification ID:** SPEC-002
**Title:** Data Source Authority Hierarchy and Data Flow Orchestration
**Status:** Implemented
**Created:** 2025-10-08
**Type:** Addition (Policy + Commands + Tools)

---

## 📋 Original Specification

**User Request:**

> definition of source of truth data sources and data flows:
> 1. archon is the source of truth for all tasks being executed and orchestrated under the roy framework.
> - to be used by the roy framework to create, track, update and complete agentic coordination and orchestration tasks.
> - GitLab is the source of truth for all atlas project issues (user stories, tasks, epics, journeys, milestones, releases, etc.). **These tasks are not managed by archon**. All the project-specific Atlas data stored in GitLab is made accessible to the roy framework via RAG queries that allow for enrichment and grounding of prompts.
> 2. define claude code native command /roy-gitlab-refresh. This command leverages existing tools that extract the entire GitLab content into the folder atlas-project-data/. Examine the existing tools and wire them to the /roy-gitlab-refresh command. The current implementation is a simple hierarchical traversal dump of the main data types in GitLab into the atlas-project-data/ folder without any smart logic. Leave it as-is for now. Once the data flows are defined for roy, a future specification will indicate how to optimize the refresh by only synchronizing changes. This command clears all the RAG records previously created from previous GitLab atlas data ingests, and updates RAG content with up-to-date project information which can then be consumed by other agents such as the bmad agents or other claude code agents to assist roy in completing complex project tasks in optimal fashion, such that all agents can query RAG content and ground and enrich any agentic prompt template with near-real-time project data, in order to enable agents to enrich and ground with data any given prompt in a workflow, resulting in prompt responses that are correct, complete, and precise. In this fashion, all logic specified in the agentic framework produces results that are repeatable and deterministic according to the acceptance criteria of the agentic step or task. This is made prossible by defining in the agentic workflow specifications the necessary prompt segments within each step that indicate flow control behavior, logic to be executed, error handling, and if needed, overrides to system prompts that may be required to achieve the expectd results of the agentic step.
> 3. define command /roy-tasks-clear - always asks for human user confirmation (i.e. roy) to confirm deleting all the task records in archon. Add support for the option "--backup". This flag indicates that all the tasks are to be serialized into json and exported into files in the directory .roy/backups/archon/tasks/{folder name that includes the timestamp of when the tasks backup was made, i.e. archon-tasks-{timestamp localized to eastern time, including the time zone indicator "ET", applicable during both EDT or EST times}. The content of the folder contains auto-numbered files that contain the task in json format. This data allows for the implementation of the next command, /roy-tasks-restore.
> 4. define the command /roy-tasks-restore - this command looks for the existence of previous task backups and presents the user with a list of enumerated available backup sets available for task restore. then the user (roy) inputs a number selection and the corresponding backup is read, deserialized, and upserted into archon tasks.
> 5. define the command /roy-rag-delete < --ingest-set:{name of ingest set} | --force > - always asks for human user confirmation (i.e. roy) to confirm that the RAG records for a particular data set is being deleted from archon RAG. Initially we define the first data set as "atlas-project-data". This data set comprises of all the RAG records generated during the RAG ingest of atlas project data. So for example, to delete all the RAG records originated by chunks created from the content in atlas-project-data/ folder, issue the command "/roy-rag-delete --ingest-set:atlas-project-data". Other RAG data sources and ingestion processes remain to be defined and labeled.
> When the --force parameter is specified, all the archon RAG records are deleted from the database, independent of ingest sets or sources.
> - either the parameter "--ingest-set:<set name>"  or "--force" must always be used.

---

## 🎯 Purpose

Establish authoritative data source hierarchy and implement commands for orchestrating data flows between GitLab, Archon tasks, and Archon RAG to enable intelligent, grounded agentic behavior.

**Problems Addressed:**

1. **Unclear data authority** - Which system is source of truth for different data types?
2. **Manual data synchronization** - No automated way to refresh GitLab data in RAG
3. **Task management safety** - No backup/restore capability for Archon tasks
4. **RAG lifecycle management** - No way to clear and re-ingest specific data sets

**Solutions:**

1. **POLICY-data-sources** - Authoritative hierarchy documentation
2. **Four new commands** - `/roy-gitlab-refresh`, `/roy-tasks-clear`, `/roy-tasks-restore`, `/roy-rag-delete`
3. **Three helper scripts** - Reusable bash tools for Archon operations
4. **Data flow orchestration** - GitLab → atlas-project-data → Archon RAG pipeline

---

## 🏗️ Implementation Details

### Components Created

#### 1. Policy File: `.roy/policies/POLICY-data-sources.md`

**Purpose:** Authoritative documentation of data source hierarchy

**Key Content:**
- **Archon Tasks:** Source of truth for roy-orchestrated agentic tasks
- **GitLab Issues:** Source of truth for Atlas project work items (NOT managed by Archon)
- **Data Flow:** GitLab → atlas-project-data → Archon RAG → Available to all agents
- **Four data integrity principles:** Single source of truth, read-only derivations, separation of concerns, controlled synchronization

#### 2. Helper Scripts: `.roy/tools/`

**`archon-task-backup.sh`**
- Fetches all tasks from Archon API
- Serializes to individual JSON files
- Stores in timestamped folder: `.roy/backups/archon/tasks/archon-tasks-{timestamp-ET}/`
- Auto-numbered filenames: `task_0001_title.json`, `task_0002_title.json`, etc.
- Eastern Time timestamps with EDT/EST indicator

**`archon-task-restore.sh`**
- Reads task JSON files from backup folder
- Deserializes and upserts to Archon via API
- Removes `id` field (Archon assigns new IDs)
- Rate limiting to prevent API overload
- Progress reporting

**`archon-rag-delete.sh`**
- Fetches all RAG sources from Archon
- Filters by ingest set (tag-based) or selects all (--force)
- Deletes matching sources via API
- Rate limiting and progress reporting
- Statistics on deleted records

All scripts made executable with `chmod +x`.

#### 3. Commands: `.claude/commands/`

**`roy-gitlab-refresh.md`**
- Orchestrates GitLab → Archon RAG data pipeline
- Executes `issues/ingest-gitlab-knowledge.sh` (extracts GitLab data)
- Executes `issues/upload-to-archon.sh` (uploads to Archon RAG)
- Reports statistics on projects, wikis, issues processed

**`roy-tasks-clear.md`**
- Deletes all Archon tasks with user confirmation
- Optional `--backup` flag to create timestamped backup first
- Calls `archon-task-backup.sh` if --backup provided
- Explicit "confirm" required before deletion

**`roy-tasks-restore.md`**
- Scans `.roy/backups/archon/tasks/` for available backups
- Presents enumerated list to user
- User selects backup by number
- Calls `archon-task-restore.sh` with selected path
- Reports success/failure statistics

**`roy-rag-delete.md`**
- Deletes Archon RAG records by ingest set or all
- Requires `--ingest-set:<name>` or `--force` parameter
- User confirmation required (explicit "confirm")
- Calls `archon-rag-delete.sh` with parameters
- Reports deleted record count

#### 4. Specification Documentation: `.roy/specifications/`

**`SPEC-002-data-flows.md`** (this file)
- Original specification
- Implementation details
- Data flow diagrams
- Command usage examples

**`SPEC-002-data-flows-TESTS.md`**
- Test scenarios for all commands
- Expected outcomes
- Verification procedures

#### 5. Documentation Updates: `.roy/README.md`

**Sections Added:**
- "Data Source Hierarchy" - Overview of authority model
- "Data Flow Commands" - Summary of four new commands
- Updated "Roy Commands" section with command references

---

## 🔄 Data Flow Architecture

### Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│  GitLab (Source of Truth)                                   │
│  • Issues (user stories, epics, tasks)                      │
│  • Wikis (documentation)                                    │
│  • Repositories (code, configs)                             │
│  • Merge Requests, Milestones, Labels                       │
└────────────────┬────────────────────────────────────────────┘
                 │
                 │  /roy-gitlab-refresh
                 │  ↓
                 │  [Extract via issues/ingest-gitlab-knowledge.sh]
                 ↓
┌─────────────────────────────────────────────────────────────┐
│  atlas-project-data/ (Local Cache)                          │
│  • repos/atlas-datascience/lion/*/                          │
│    - issues/, merge_requests/, metadata/                    │
│  • documents/ (PDFs, business plans)                        │
│  • Hierarchical folder structure by project                 │
└────────────────┬────────────────────────────────────────────┘
                 │
                 │  [Ingest via issues/upload-to-archon.sh]
                 ↓
┌─────────────────────────────────────────────────────────────┐
│  Archon RAG / Knowledge Base (Read-Only Query Layer)        │
│  • Ingest Set: "atlas-project-data"                         │
│  • Entities: Projects, Issues, Wikis                        │
│  • Full-text indexed for semantic search                    │
│  • Graph relationships for traversal                        │
└────────────────┬────────────────────────────────────────────┘
                 │
                 │  archon:rag_search_knowledge_base()
                 │  archon:rag_search_code_examples()
                 ↓
┌─────────────────────────────────────────────────────────────┐
│  Agents (Consumers)                                          │
│  • Roy Framework                                            │
│  • BMAD Agents (SM, Dev, QA)                                │
│  • Claude Code                                              │
│  • Future custom agents                                     │
│                                                             │
│  Use RAG to:                                                │
│  • Enrich prompts with project context                      │
│  • Ground responses in actual project state                 │
│  • Produce correct, complete, precise results               │
└─────────────────────────────────────────────────────────────┘
```

### Parallel System: Archon Tasks

```
┌─────────────────────────────────────────────────────────────┐
│  Archon Tasks (Source of Truth for Agentic Work)            │
│  • Roy-orchestrated workflow tasks                          │
│  • BMAD agent execution tasks                               │
│  • Cross-agent coordination tasks                           │
│  • Session-persisted work items                             │
└────────────────┬────────────────────────────────────────────┘
                 │
                 │  archon:manage_task(action="create"|"update")
                 │  archon:find_tasks(...)
                 ↓
┌─────────────────────────────────────────────────────────────┐
│  Roy Framework & Agents                                      │
│  Create, track, update, complete tasks                      │
└────────────────┬────────────────────────────────────────────┘
                 │
                 │  /roy-tasks-clear --backup
                 ↓
┌─────────────────────────────────────────────────────────────┐
│  .roy/backups/archon/tasks/archon-tasks-{timestamp-ET}/     │
│  • task_0001_title.json                                     │
│  • task_0002_title.json                                     │
│  • ...                                                      │
└────────────────┬────────────────────────────────────────────┘
                 │
                 │  /roy-tasks-restore
                 ↓
┌─────────────────────────────────────────────────────────────┐
│  Archon Tasks (Restored)                                    │
│  Tasks upserted back into Archon                            │
└─────────────────────────────────────────────────────────────┘
```

---

## 💡 Key Principles

### 1. Single Source of Truth

**Archon Tasks:**
- Roy-orchestrated agentic workflow tasks
- Ephemeral, API-driven, session-scoped (but persistent)

**GitLab Issues:**
- Atlas project work items (user stories, epics, etc.)
- Persistent, human-driven, sprint-scoped

**Separation is Critical:**
- Never create Atlas project user stories in Archon tasks
- Never track agentic workflow orchestration in GitLab issues

### 2. Read-Only Derivations

**Archon RAG is derived from GitLab:**
- RAG does not modify GitLab
- Updates flow GitLab → RAG, never reverse
- Agents query RAG but update source of truth (GitLab)

### 3. Controlled Synchronization

**Manual trigger:** `/roy-gitlab-refresh`
- Not automatic/reactive
- User decides when fresh data needed
- Future: Incremental sync optimization

### 4. Data Integrity Through Workflow

**Repeatable, deterministic results:**
- Agents query RAG for current project state
- Prompts enriched and grounded with actual data
- Responses are correct, complete, precise
- Workflow specifications define flow control, error handling, prompt overrides

---

## 🧪 Usage Examples

### Example 1: Sprint Planning with Fresh Data

```
# Before planning session, refresh GitLab data
/roy-gitlab-refresh

# Now agents have access to latest issues, epics, wikis via RAG
# BMAD SM agent can query backlog and identify gaps

# Agents use archon:rag_search_knowledge_base() to:
# - Find all epics without sufficient user stories
# - Identify missing acceptance criteria
# - Analyze issue dependencies
```

### Example 2: Safe Task State Management

```
# Before major workflow changes, backup current task state
/roy-tasks-clear --backup

# Backup created: .roy/backups/archon/tasks/archon-tasks-20251008-143022-EDT/

# Later, if needed, restore previous state
/roy-tasks-restore
# [Select backup #1]
# Tasks restored successfully
```

### Example 3: RAG Lifecycle Management

```
# Clear previous GitLab data before refresh
/roy-rag-delete --ingest-set:atlas-project-data

# Confirmed - deleted 287 sources

# Re-ingest fresh GitLab data
/roy-gitlab-refresh

# RAG now contains only latest data, no duplicates
```

### Example 4: Agent Prompt Enrichment

```python
# BMAD SM Agent workflow step:

# 1. Query RAG for current epics
epics_context = archon:rag_search_knowledge_base(
    query="all epics in Lion platform backlog",
    match_count=20
)

# 2. Enrich prompt with actual epic data
enriched_prompt = f"""
Analyze the following epics from the Lion platform backlog:

{epics_context}

Identify epics that lack sufficient user stories (< 3 stories per epic).
For each gap, suggest 2-3 user stories that should be created.
"""

# 3. Generate response grounded in actual project state
# Result: Correct (based on real epics), Complete (all epics analyzed),
#         Precise (specific story suggestions)
```

---

## ✅ Success Criteria

- [x] POLICY-data-sources.md created with comprehensive hierarchy documentation
- [x] Three helper scripts created and made executable
- [x] Four commands created with complete documentation
- [x] Commands integrate with existing `issues/` scripts
- [x] Commands integrate with Archon MCP API
- [x] User confirmation required for all destructive operations
- [x] Timestamps use Eastern Time with EDT/EST indicator
- [x] Backup/restore workflow functional
- [x] RAG deletion supports ingest set filtering and force mode
- [x] `.roy/README.md` updated with new commands and data flow sections
- [x] All existing roy functionality preserved (backward compatible)
- [x] Specification documentation complete (this file)
- [x] Test specification created (SPEC-002-data-flows-TESTS.md)

---

## 📊 Benefits

### For Data Integrity

- **Clear authority boundaries** - No confusion about source of truth
- **Controlled synchronization** - Manual trigger prevents stale data
- **Separation of concerns** - Agentic tasks vs. project tasks
- **Read-only derivations** - RAG cannot corrupt source data

### For Agentic Workflows

- **Grounded prompts** - Agents query actual project state, not assumptions
- **Repeatable results** - Same query → same data → deterministic outcomes
- **Complete context** - All GitLab data available to all agents
- **Precise responses** - Answers based on real issues, epics, documentation

### For Operational Safety

- **Task backups** - Disaster recovery for Archon tasks
- **RAG lifecycle management** - Clean re-ingestion without duplicates
- **User confirmations** - Prevent accidental destructive operations
- **Timestamped backups** - Track state over time

### For Future Enhancements

- **Incremental sync** - Foundation for optimized GitLab refresh
- **Multi-source RAG** - Framework for additional ingest sets
- **Automated triggers** - Scheduled or event-driven refresh
- **Advanced querying** - Graph traversal, temporal analysis

---

## 🔮 Future Enhancements

### 1. Incremental GitLab Synchronization

**Current:** Full extract/delete/re-ingest on every refresh

**Future:**
- Track `updated_at` timestamps for GitLab entities
- Detect changes since last sync
- Update only changed entities in RAG
- Partial ingest set updates

**Benefit:** Faster refresh, reduced API calls, lower processing overhead

### 2. Additional Ingest Sets

**Current:** Single ingest set (`atlas-project-data`)

**Future:**
- `external-docs` - Public documentation, API references
- `research` - Papers, articles, technical resources
- `conversations` - Historical Claude Code session transcripts
- `custom-knowledge` - User-curated knowledge base

**Benefit:** Organized RAG with source attribution, selective updates

### 3. Automated Refresh Triggers

**Current:** Manual `/roy-gitlab-refresh` execution

**Future:**
- **Time-based:** Daily at midnight, weekly on Sundays
- **Event-driven:** GitLab webhook notifications on issue updates
- **On-demand with staleness detection:** Agent requests data, checks freshness, auto-refreshes if stale

**Benefit:** Always-fresh RAG without manual intervention

### 4. Advanced RAG Queries

**Current:** Basic semantic search via `rag_search_knowledge_base()`

**Future:**
- **Graph traversal:** "Find all issues related to epic X"
- **Temporal queries:** "What changed in last sprint?"
- **Aggregation:** "Count issues by label across all projects"
- **Hybrid search:** Combine semantic + graph + filters

**Benefit:** More powerful agent capabilities, complex analysis

---

## 🛠️ Technical Notes

### Archon API Endpoints Used

- `GET /api/tasks` - Fetch all tasks (backup)
- `POST /api/tasks` - Create/upsert task (restore)
- `DELETE /api/tasks/{id}` - Delete task (clear)
- `GET /api/sources` - Fetch RAG sources (RAG delete)
- `DELETE /api/sources/{id}` - Delete RAG source (RAG delete)
- `GET /health` - Health check

### GitLab Extraction Scripts

**`issues/ingest-gitlab-knowledge.sh`:**
- Uses GitLab REST API v4
- Extracts projects, issues, wikis, merge requests
- Outputs CSV files for RAG ingestion
- Outputs JSON files for graph relationships

**`issues/upload-to-archon.sh`:**
- Uploads CSV data to Archon via API
- Creates knowledge base entries
- Tags with "atlas-project-data" ingest set

### Backup File Format

**Folder structure:**
```
.roy/backups/archon/tasks/archon-tasks-20251008-143022-EDT/
├── task_0001_implement_authentication.json
├── task_0002_setup_database.json
└── ...
```

**JSON format:**
```json
{
  "title": "Implement user authentication",
  "description": "Add JWT-based authentication to API",
  "status": "doing",
  "project_id": "3f2b6ee9-05ff-48ae-ad6f-54cad080addc",
  "feature": "Authentication",
  "task_order": 100,
  "metadata": {...}
}
```

---

## 📚 Related Documents

- **Policy:** `.roy/policies/POLICY-data-sources.md` - Authoritative data source hierarchy
- **Commands:**
  - `.claude/commands/roy-gitlab-refresh.md`
  - `.claude/commands/roy-tasks-clear.md`
  - `.claude/commands/roy-tasks-restore.md`
  - `.claude/commands/roy-rag-delete.md`
- **Tools:**
  - `.roy/tools/archon-task-backup.sh`
  - `.roy/tools/archon-task-restore.sh`
  - `.roy/tools/archon-rag-delete.sh`
- **Tests:** `.roy/specifications/SPEC-002-data-flows-TESTS.md`
- **GitLab Scripts:**
  - `issues/ingest-gitlab-knowledge.sh`
  - `issues/upload-to-archon.sh`

---

## 📝 Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2025-10-08 | Initial implementation via `/roy-agentic-specification` |

---

**Specification Owner:** Roy Framework
**Implementation Status:** Complete
**Test Status:** Tests defined (see TESTS.md)
**Context Engineering:** ⚠️ **RESTART REQUIRED** (`.claude/commands/` modified)
