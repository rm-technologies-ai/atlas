# Atlas

A meta-repository for the ATLAS Data Science (Lion/Paxium) project - integrating **Archon MCP**, **BMAD Method**, and **Claude Code** for AI-powered brownfield platform development.

## Overview

Atlas is an aggregation workspace providing a unified agentic framework for the Lion/Paxium brownfield project (30% complete, targeting MVP by December 2025).

**Key Integration:**
- 🧠 **Archon MCP** - Knowledge base (RAG) + Task management + MCP protocol
- 🎭 **BMAD Method** - AI agent workflows (Analyst, PM, Architect, SM, Dev, QA)
- 💬 **Claude Code** - AI coding assistant with MCP integration

**Root Directory:** `E:\repos\atlas\` (Windows) or `/mnt/e/repos/atlas/` (WSL)

---

## Quick Start - Integrated Workflow

### Prerequisites
- Windows 11 Pro with WSL (Ubuntu/Debian)
- Docker Desktop with WSL integration
- VS Code with WSL extension
- Supabase account (free tier)
- OpenAI API key

### 1. Clone Repository
```bash
git clone https://github.com/rm-technologies-ai/atlas.git
cd atlas
```

### 2. Configure Environment
```bash
# Copy environment template
cp .env.atlas.template .env.atlas

# Edit .env.atlas with your credentials
# Required:
#   - SUPABASE_URL, SUPABASE_SERVICE_KEY
#   - OPENAI_API_KEY
#   - GITLAB_TOKEN, GITLAB_GROUP
```

### 3. Start Archon (Knowledge + Tasks)
```bash
cd archon

# Run database migration in Supabase SQL Editor
# Execute: migration/complete_setup.sql

# Start services
docker compose up --build -d

# Verify
docker compose ps
# Open UI: http://localhost:3737
```

### 4. Use Integrated Workflow

**Morning Workflow:**
```bash
# 1. Check Archon tasks
source .ai/scripts/archon-helpers.sh
archon_status

# 2. Get next task
archon_todo

# 3. Start working (mark as doing)
archon_start <task-id>
```

**Development Workflow:**
```
# In Claude Code session:

1. Query Archon for task details:
   archon:find_tasks(task_id="...")

2. Research with Archon RAG:
   archon:rag_search_knowledge_base(query="Lion architecture", match_count=5)

3. Use BMAD agents for implementation:
   /BMad:agents:bmad-orchestrator
   *agent analyst    # For discovery
   *agent pm         # For PRD
   *agent architect  # For architecture
   *agent sm         # For stories
   *agent dev        # For implementation

4. Update Archon task status:
   archon:manage_task(action="update", task_id="...", status="done")
```

---

## Project Structure

### Core Directories

#### `/archon/`
**RAG/Graph knowledge management + Task tracking**

- Knowledge base with semantic search (pgvector)
- Project and task management database
- MCP server for Claude Code integration
- GitLab wiki/issue ingestion

**Services:**
- UI: http://localhost:3737 (dashboard)
- API: http://localhost:8181 (REST)
- MCP: http://localhost:8051 (protocol)

**Docs:** [`archon/SETUP-ATLAS.md`](archon/SETUP-ATLAS.md), [`archon/README.md`](archon/README.md)

---

#### `/.bmad-core/`
**BMAD Method - AI Agent Framework**

Specialized AI agents for Agile roles:
- **Analyst** (Mary) - Discovery, research, competitive analysis
- **PM** (John) - PRDs, product strategy, roadmaps
- **Architect** (Winston) - System design, tech stack, APIs
- **PO** (Sarah) - Backlog management, story refinement
- **SM** (Bob) - User stories, sprint planning
- **Dev** (James) - Code implementation, testing
- **QA** (Quinn) - Quality gates, test architecture
- **UX Expert** (Sally) - UI/UX design, prototypes

**Activation:** Use `/BMad:agents:bmad-orchestrator` in Claude Code

**Docs:** [`.bmad-core/data/bmad-kb.md`](.bmad-core/data/bmad-kb.md)

---

#### `/.ai/`
**AI Session Management**

- `/conversations/` - Saved session archives
- `/scripts/` - Helper scripts (archon-helpers.sh)

**Key Files:**
- `task-management-quick-guide-2025-10-01.md` - Quick reference
- `task-management-integration-analysis-2025-10-01.md` - Full analysis

---

#### `/issues/`
**GitLab Issue Export Tool**

Export issues from `atlas-datascience/lion` GitLab group for ingestion into Archon.

**Docs:** [`issues/CLAUDE.md`](issues/CLAUDE.md)

---

#### `/docs/`
**Project Documentation**

Output directory for BMAD-generated documents:
- `/stories/` - User stories (from SM agent)
- `/prd/` - Sharded PRD epics
- `/architecture/` - Sharded architecture docs
- `/existing-system/` - Discovery documentation

---

### Configuration Files

#### `CLAUDE.md`
**Primary guidance for Claude Code**

Comprehensive rules for:
- Archon-first task management workflow
- BMAD agent integration
- Task management hierarchy (Archon → BMAD → TodoWrite)
- Development workflows and patterns

**THIS IS THE SOURCE OF TRUTH for AI behavior in this repo.**

---

#### `TODO.md`
**High-level task overview**

⚠️ **Note:** This is a READ-ONLY overview.

**For actual task management, use Archon:**
- Web UI: http://localhost:3737
- MCP: `archon:find_tasks()` in Claude Code
- CLI: `source .ai/scripts/archon-helpers.sh && archon_status`

This file provides high-level project status only. All task CRUD operations happen in Archon.

---

#### `.env.atlas`
**Centralized environment variables** (gitignored)

**Structure:**
```bash
# Supabase (Archon database)
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_SERVICE_KEY=your-service-key-here

# OpenAI (Archon embeddings)
OPENAI_API_KEY=sk-...

# GitLab Integration
GITLAB_TOKEN=glpat-...
GITLAB_GROUP=atlas-datascience/lion
GITLAB_API_URL=https://gitlab.com/api/v4

# GitHub
GITHUB_TOKEN=ghp_...

# AWS (if needed)
AWS_ACCESS_KEY_ID=...
AWS_SECRET_ACCESS_KEY=...
AWS_DEFAULT_REGION=us-east-1

# Archon Service Ports
ARCHON_UI_PORT=3737
ARCHON_SERVER_PORT=8181
ARCHON_MCP_PORT=8051
```

**Usage:** Subprojects (archon/, issues/) source from this file.

**Template:** See `.env.atlas.template` for setup.

---

## Task Management Hierarchy

**Atlas uses a three-tier system:**

### 1. Archon MCP (PRIMARY - Persistent)
✅ **Use for:** All persistent tasks, epics, stories, backlog

- Database-backed (Supabase)
- Cross-session persistence
- Knowledge base integration
- Multi-agent visibility
- MCP tools: `archon:find_tasks()`, `archon:manage_task()`

### 2. BMAD Story Files (SECONDARY - Generated)
⚠️ **Use for:** Generated documentation from Archon

- Story files in `docs/stories/`
- Generated FROM Archon when needed
- Used by Dev/QA agents during implementation
- Source of truth: Archon database

### 3. TodoWrite (TACTICAL - Session Only)
⚠️ **Use for:** Current session breakdown ONLY

- 5-10 items max
- Discarded when session ends
- NEVER for persistent tracking

**Decision Rule:** If task survives this session → Archon. Otherwise → TodoWrite (rare).

---

## Integrated Workflows

### Workflow 1: Brownfield Discovery

**Objective:** Document existing Lion/Paxium system

```
1. Create task in Archon:
   archon:manage_task(
       action="create",
       project_id="3f2b6ee9-05ff-48ae-ad6f-54cad080addc",
       title="Discovery: Edge Connector Component",
       feature="System Architecture"
   )

2. Activate BMAD Analyst:
   /BMad:agents:analyst
   *document-project

3. Research with Archon RAG:
   archon:rag_search_knowledge_base(query="Edge Connector architecture")

4. Analyst generates docs/existing-system/edge-connector.md

5. Mark complete in Archon:
   archon:manage_task(action="update", task_id="...", status="done")
```

---

### Workflow 2: PRD Creation with Archon Integration

**Objective:** Create brownfield PRD with knowledge base context

```
1. Query Archon for existing Lion documentation:
   archon:rag_search_knowledge_base(query="Lion MVP requirements", match_count=10)

2. Activate BMAD PM:
   /BMad:agents:pm
   *create-doc
   Select: brownfield-prd-tmpl.yaml

3. PM uses Archon RAG results for context

4. Generate docs/prd.md with epics/stories

5. Create Archon tasks from PRD epics:
   for each epic:
       archon:manage_task(action="create", title="Epic: ...", feature="...")
```

---

### Workflow 3: Story Implementation with Task Tracking

**Objective:** Implement story with Archon status tracking

```
1. Get next todo task from Archon:
   archon:find_tasks(filter_by="status", filter_value="todo")

2. Mark as in-progress:
   archon:manage_task(action="update", task_id="...", status="doing")

3. Research implementation approach:
   archon:rag_search_code_examples(query="JWT authentication")

4. Activate BMAD Dev:
   /BMad:agents:dev
   *develop-story

5. Dev implements, tests, commits

6. Complete task:
   archon:manage_task(action="update", task_id="...", status="done")
```

---

## Repository Information

- **GitHub:** https://github.com/rm-technologies-ai/atlas (private)
- **Project:** ATLAS Data Science (Lion/Paxium)
- **Status:** Brownfield platform at 30% completion
- **MVP Target:** December 2025
- **GitLab Group:** `atlas-datascience/lion`

---

## Current Status

**As of 2025-10-01:**

- ✅ **Archon** - Installed, configured, MCP integrated
- ✅ **BMAD** - Agents configured with Archon integration
- ✅ **Task Management** - Three-tier hierarchy established
- ✅ **Helper Scripts** - archon-helpers.sh created
- 🔄 **Knowledge Ingestion** - GitLab wikis/issues pending
- 🔄 **Brownfield Discovery** - Phase 1 ready to start

**View tasks:** http://localhost:3737 or `archon_status`

---

## Technical Stack

- **Backend:** Node.js, Next.js, Python
- **Cloud:** AWS (Terraform, CloudFormation)
- **Platform:** GitLab CI/CD
- **Knowledge:** Archon (Supabase + pgvector, OpenAI)
- **AI Agents:** BMAD Method + Claude Code
- **Version Control:** GitHub (Atlas), GitLab (Lion)
- **Development:** WSL, Docker, VS Code

---

## Quick Reference

### Archon Commands (MCP)
```python
# Tasks
archon:find_tasks(project_id="3f2b6ee9-05ff-48ae-ad6f-54cad080addc")
archon:manage_task(action="create", title="...", ...)

# Knowledge
archon:rag_search_knowledge_base(query="...", match_count=5)
archon:rag_search_code_examples(query="...", match_count=3)
```

### Helper Scripts (Bash)
```bash
source .ai/scripts/archon-helpers.sh
archon_status          # Task summary
archon_todo            # List TODO tasks
archon_start <id>      # Mark as doing
archon_complete <id>   # Mark as done
archon_ui              # Open web UI
```

### BMAD Agents (Slash Commands)
```
/BMad:agents:bmad-orchestrator    # Orchestrator
/BMad:agents:analyst              # Analyst
/BMad:agents:pm                   # Product Manager
/BMad:agents:architect            # Architect
/BMad:agents:sm                   # Scrum Master
/BMad:agents:dev                  # Developer
/BMad:agents:qa                   # QA Engineer
```

---

## Documentation

- **[CLAUDE.md](CLAUDE.md)** - Primary AI guidance (Archon workflows, BMAD integration)
- **[TODO.md](TODO.md)** - High-level overview (points to Archon)
- **[CONTRIBUTING.md](CONTRIBUTING.md)** - Contribution guidelines
- **[.ai/conversations/task-management-quick-guide-2025-10-01.md](.ai/conversations/task-management-quick-guide-2025-10-01.md)** - Task management quick ref
- **[.bmad-core/data/bmad-kb.md](.bmad-core/data/bmad-kb.md)** - BMAD knowledge base
- **[archon/SETUP-ATLAS.md](archon/SETUP-ATLAS.md)** - Archon setup
- **[issues/CLAUDE.md](issues/CLAUDE.md)** - GitLab tools

---

## Contributing

**For Atlas team members:**

1. **Always use Archon-first workflow** (see CLAUDE.md and CONTRIBUTING.md)
2. **Query Archon RAG before implementing** features
3. **Use BMAD agents** for structured workflows
4. **Update `.env.atlas`** with new credentials
5. **Document workflows** in `.ai/conversations/`
6. **Keep Archon knowledge base** up to date

---

## Support

**Issues or questions:**
1. Check [CLAUDE.md](CLAUDE.md) for workflows
2. Review [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines
3. Review task management guide: `.ai/conversations/task-management-quick-guide-2025-10-01.md`
4. Query Archon knowledge base: `archon:rag_search_knowledge_base()`
5. Contact technical project manager

---

**Last Updated:** 2025-10-01
**Maintainer:** Technical Project Manager, ATLAS Data Science
**Framework Version:** Archon (beta) + BMAD v4 + Claude Code MCP
