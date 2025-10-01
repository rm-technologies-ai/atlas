# Atlas Project TODO

⚠️ **IMPORTANT:** This file is a READ-ONLY overview for quick reference.

**For actual task management, use Archon:**
- **Web UI:** http://localhost:3737
- **MCP (in Claude Code):** `archon:find_tasks(project_id="3f2b6ee9-05ff-48ae-ad6f-54cad080addc")`
- **CLI Helper:** `source .ai/scripts/archon-helpers.sh && archon_status`

---

## Current Sprint - Brownfield Reverse Engineering

**Atlas Project ID:** `3f2b6ee9-05ff-48ae-ad6f-54cad080addc`

### Phase 1: Discovery & Documentation (Next Up)
**Status:** Ready to start
**Archon Task:** `d68e3e98-8d43-476c-a07c-d656e48b27f6`

Document existing Lion/Paxium system (30% complete) using BMAD Analyst agent.

**Output:** `docs/existing-system/*.md`

---

### Phase 2: Requirements & Architecture Planning
**Status:** Pending Phase 1
**Archon Tasks:** `0f6be4ca-6843-45ad-8d6a-4810f943870c`, `23f08c50-f52d-4464-804d-30c9f9433c58`

Create brownfield PRD and architecture using BMAD PM and Architect agents.

**Output:** `docs/prd.md`, `docs/architecture.md`

---

### Phase 3: Document Sharding
**Status:** Pending Phase 2
**Archon Task:** `dd53845b-bb3a-4f90-a630-1127ee2bf414`

Shard PRD/Architecture for development using BMAD PO agent.

**Output:** `docs/prd/`, `docs/architecture/`

---

### Phase 4: Story Creation
**Status:** Pending Phase 3
**Archon Task:** `8a6ce2b9-cf83-4bf7-b91f-e3e3333c000c`

Create detailed stories using BMAD SM agent.

**Output:** `docs/stories/*.md`

---

### Phase 5: Implementation
**Status:** Pending Phase 4
**Archon Task:** `a392b62d-82b6-45a9-b0be-7ad536569846`

SM → Dev → QA cycles until MVP complete (December 2025).

---

## Completed This Week

- ✅ **Task Management Integration** - Archon, BMAD, TodoWrite hierarchy established
- ✅ **CLAUDE.md Updates** - Comprehensive task management strategy documented
- ✅ **Helper Scripts** - archon-helpers.sh with 20+ functions
- ✅ **BMAD Training** - Agents configured for Archon-first workflow

---

## Quick Actions

```bash
# View all tasks
archon:find_tasks(project_id="3f2b6ee9-05ff-48ae-ad6f-54cad080addc")

# Start next task
archon_todo           # List todos
archon_start <id>     # Mark as doing

# Complete task
archon_complete <id>  # Mark as done
```

---

## Key Reminders

1. **Archon is the source of truth** for all tasks
2. **Query Archon RAG** before implementing features
3. **Use BMAD agents** for structured workflows
4. **Update Archon status** after completing work
5. **TodoWrite ONLY for session-scoped** breakdown (rare)

---

**Last Updated:** 2025-10-01
**Managed In:** Archon (http://localhost:3737)
**Atlas Project ID:** `3f2b6ee9-05ff-48ae-ad6f-54cad080addc`
