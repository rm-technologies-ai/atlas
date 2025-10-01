# Atlas Repository Consolidation & Updates - Draft
**Date:** 2025-10-01
**Purpose:** Consolidate Archon, BMAD, and Claude Code into unified agentic framework

---

## Executive Summary

### Issues Identified

1. **Duplicate BMAD Installations:** Three separate BMAD directories exist (`.bmad-core/`, `.bmad-infrastructure-devops/`, `.claude/commands/BMad/`)
2. **Outdated Timestamps:** README.md and TODO.md show "Last Updated: 2025-09-30" (should be 2025-10-01)
3. **TODO.md Redundancy:** Manual task list duplicates Archon task management
4. **Missing .claude Integration:** No documentation on how `.claude/commands/` relates to `.bmad-core/`
5. **No Centralized Workflow Guide:** Task management integration documented but not prominently referenced
6. **Obsolete .gemini Directory:** Purpose unclear, may be redundant with current workflow
7. **Missing BMAD + Archon Examples:** No concrete examples showing integrated workflow
8. **Environment Variable Documentation:** .env.atlas structure not documented in README

### Recommended Actions

1. ✅ **Consolidate BMAD directories** - Keep only `.bmad-core/`, archive others
2. ✅ **Update all timestamps** - Reflect 2025-10-01 changes
3. ✅ **Simplify TODO.md** - Point to Archon as primary source
4. ✅ **Document .claude integration** - Explain slash command system
5. ✅ **Add workflow quick start** - Prominently feature in README
6. ✅ **Clean up obsolete directories** - Archive or remove .gemini
7. ✅ **Add integration examples** - Show BMAD + Archon in action
8. ✅ **Document environment structure** - Add .env.atlas template section

---

## Detailed Updates

### 1. README.md Updates

**File:** `/mnt/e/repos/atlas/README.md`

#### Current Issues:
- Last Updated: 2025-09-30 (outdated)
- No mention of BMAD Method integration
- No task management hierarchy explanation
- Missing quick start for integrated workflow
- No .env.atlas structure documentation

#### Proposed Changes:

```markdown
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
- **[.ai/conversations/task-management-quick-guide-2025-10-01.md](.ai/conversations/task-management-quick-guide-2025-10-01.md)** - Task management quick ref
- **[.bmad-core/data/bmad-kb.md](.bmad-core/data/bmad-kb.md)** - BMAD knowledge base
- **[archon/SETUP-ATLAS.md](archon/SETUP-ATLAS.md)** - Archon setup
- **[issues/CLAUDE.md](issues/CLAUDE.md)** - GitLab tools

---

## Contributing

**For Atlas team members:**

1. **Always use Archon-first workflow** (see CLAUDE.md)
2. **Query Archon RAG before implementing** features
3. **Use BMAD agents** for structured workflows
4. **Update `.env.atlas`** with new credentials
5. **Document workflows** in `.ai/conversations/`
6. **Keep Archon knowledge base** up to date

---

## Support

**Issues or questions:**
1. Check [CLAUDE.md](CLAUDE.md) for workflows
2. Review task management guide: `.ai/conversations/task-management-quick-guide-2025-10-01.md`
3. Query Archon knowledge base: `archon:rag_search_knowledge_base()`
4. Contact technical project manager

---

**Last Updated:** 2025-10-01
**Maintainer:** Technical Project Manager, ATLAS Data Science
**Framework Version:** Archon (beta) + BMAD v4 + Claude Code MCP
```

---

### 2. TODO.md Updates

**File:** `/mnt/e/repos/atlas/TODO.md`

#### Current Issues:
- Manual task list duplicates Archon
- Last Updated: 2025-09-30 (outdated)
- Checkboxes imply manual tracking (conflicts with Archon-first)

#### Proposed Changes:

```markdown
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
```

---

### 3. BMAD Directory Consolidation

**Issue:** Three separate BMAD directories exist with overlapping content.

#### Analysis:

1. **`.bmad-core/`** - Primary installation (complete)
   - All agents, tasks, templates, data
   - `core-config.yaml` with project settings
   - Recently updated with Archon integration

2. **`.bmad-infrastructure-devops/`** - Expansion pack
   - Only contains infra/devops agent
   - Documented as "expansion pack" in README
   - Should be merged into `.bmad-core/` or archived

3. **`.claude/commands/BMad/`** - Claude Code slash commands
   - Out of sync with `.bmad-core/`
   - Files differ based on `diff` comparison
   - Purpose: Slash command system for Claude Code Desktop
   - Should be symlinked or removed (Claude Code IDE doesn't use)

#### Recommended Actions:

**Option A: Consolidate Everything to .bmad-core/ (Recommended)**

```bash
# 1. Archive infrastructure expansion
mv .bmad-infrastructure-devops .bmad-infrastructure-devops.archive

# 2. Copy infrastructure agent to core
cp .bmad-infrastructure-devops.archive/agents/infra-devops-platform.md .bmad-core/agents/

# 3. Copy infrastructure checklist to core
cp .bmad-infrastructure-devops.archive/checklists/infrastructure-checklist.md .bmad-core/checklists/

# 4. Remove .claude/commands/BMad (not needed for Claude Code IDE)
mv .claude/commands/BMad .claude/commands/BMad.archive

# 5. Document in README that .bmad-core/ is the only BMAD installation
```

**Option B: Symlink .claude/commands to .bmad-core/ (If slash commands needed)**

```bash
# If slash commands are still used
rm -rf .claude/commands/BMad
ln -s ../../.bmad-core .claude/commands/BMad
```

**Recommended: Option A** - Claude Code IDE doesn't use `.claude/commands/`, only Desktop does.

---

### 4. New File: .env.atlas.template

**Purpose:** Provide environment variable template for team members

**File:** `/mnt/e/repos/atlas/.env.atlas.template`

```bash
# =================================================================
# Atlas Project Environment Variables Template
# =================================================================
# Copy this file to .env.atlas and fill in your credentials
# cp .env.atlas.template .env.atlas
#
# .env.atlas is gitignored and never committed to version control
# =================================================================

# -----------------------------------------------------------------
# Supabase (Archon Database)
# -----------------------------------------------------------------
# Get these from: https://supabase.com/dashboard/project/YOUR_PROJECT/settings/api
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_SERVICE_KEY=your-service-role-key-here

# -----------------------------------------------------------------
# OpenAI (Archon Embeddings & RAG)
# -----------------------------------------------------------------
# Get this from: https://platform.openai.com/api-keys
OPENAI_API_KEY=sk-your-api-key-here

# -----------------------------------------------------------------
# GitLab Integration (Issues Export & Wiki Ingestion)
# -----------------------------------------------------------------
# Get token from: https://gitlab.com/-/profile/personal_access_tokens
# Required scopes: api, read_api, read_repository
GITLAB_TOKEN=glpat-your-token-here
GITLAB_GROUP=atlas-datascience/lion
GITLAB_API_URL=https://gitlab.com/api/v4
GITLAB_PROJECT_ID=your-project-id

# -----------------------------------------------------------------
# GitHub (Optional - for code sync)
# -----------------------------------------------------------------
# Get from: https://github.com/settings/tokens
GITHUB_TOKEN=ghp_your_token_here
GITHUB_REPO=rm-technologies-ai/atlas

# -----------------------------------------------------------------
# AWS (Optional - if deploying infrastructure)
# -----------------------------------------------------------------
AWS_ACCESS_KEY_ID=your-access-key
AWS_SECRET_ACCESS_KEY=your-secret-key
AWS_DEFAULT_REGION=us-east-1

# -----------------------------------------------------------------
# Archon Service Ports (usually no need to change)
# -----------------------------------------------------------------
ARCHON_UI_PORT=3737
ARCHON_SERVER_PORT=8181
ARCHON_MCP_PORT=8051
ARCHON_AGENTS_PORT=8052

# -----------------------------------------------------------------
# Archon Host (change if running remotely)
# -----------------------------------------------------------------
HOST=localhost

# -----------------------------------------------------------------
# Log Level (DEBUG, INFO, WARNING, ERROR)
# -----------------------------------------------------------------
LOG_LEVEL=INFO

# -----------------------------------------------------------------
# Optional: Logfire (for observability)
# -----------------------------------------------------------------
# LOGFIRE_TOKEN=your-logfire-token

# =================================================================
# End of Configuration
# =================================================================
```

---

### 5. New File: CONTRIBUTING.md

**Purpose:** Provide contribution guidelines for team members

**File:** `/mnt/e/repos/atlas/CONTRIBUTING.md`

```markdown
# Contributing to Atlas

Welcome to the Atlas project! This guide will help you contribute effectively using our integrated Archon + BMAD + Claude Code framework.

---

## Table of Contents

1. [Getting Started](#getting-started)
2. [Workflow Overview](#workflow-overview)
3. [Task Management](#task-management)
4. [Using BMAD Agents](#using-bmad-agents)
5. [Using Archon Knowledge Base](#using-archon-knowledge-base)
6. [Code Standards](#code-standards)
7. [Documentation](#documentation)
8. [Git Workflow](#git-workflow)

---

## Getting Started

### Prerequisites

- Windows 11 Pro with WSL (Ubuntu/Debian)
- Docker Desktop with WSL integration
- VS Code with WSL extension
- Supabase account (free tier works)
- OpenAI API key

### Initial Setup

1. **Clone Repository**
   ```bash
   git clone https://github.com/rm-technologies-ai/atlas.git
   cd atlas
   ```

2. **Configure Environment**
   ```bash
   cp .env.atlas.template .env.atlas
   # Edit .env.atlas with your credentials
   ```

3. **Start Archon**
   ```bash
   cd archon
   # Run migration in Supabase: migration/complete_setup.sql
   docker compose up --build -d
   ```

4. **Load Helper Scripts**
   ```bash
   source .ai/scripts/archon-helpers.sh
   ```

5. **Verify Setup**
   ```bash
   archon_health_check
   archon_status
   ```

---

## Workflow Overview

### Daily Workflow

**Morning:**
1. Start Archon: `cd archon && docker compose up -d`
2. Check tasks: `archon_status` or http://localhost:3737
3. Get next todo: `archon_todo`

**During Work:**
1. Start task: `archon_start <task-id>`
2. Research: `archon:rag_search_knowledge_base(query="...")`
3. Use BMAD agents: `/BMad:agents:bmad-orchestrator`
4. Implement and commit
5. Complete task: `archon_complete <task-id>`

**End of Day:**
1. Update task status in Archon
2. Commit work to git
3. Stop Archon: `cd archon && docker compose down` (optional)

---

## Task Management

### The Hierarchy

**1. Archon (PRIMARY)**
- All persistent tasks
- Cross-session tracking
- Knowledge base integration
- Web UI + MCP tools

**2. BMAD Story Files (SECONDARY)**
- Generated from Archon
- Used by Dev/QA agents
- Git-versioned documentation

**3. TodoWrite (TACTICAL)**
- Session-only breakdown
- 5-10 items max
- Never for persistence

### Creating Tasks

```python
# Via MCP in Claude Code
archon:manage_task(
    action="create",
    project_id="3f2b6ee9-05ff-48ae-ad6f-54cad080addc",
    title="Task title",
    description="Detailed description",
    feature="Epic Name",
    task_order=100  # Higher = more priority
)
```

### Updating Tasks

```bash
# Via helper script
archon_start abc12345     # Mark as doing
archon_complete abc12345  # Mark as done

# Or via MCP
archon:manage_task(action="update", task_id="...", status="doing")
```

---

## Using BMAD Agents

### Available Agents

- **Analyst** - Discovery, research, documentation
- **PM** - PRDs, product strategy
- **Architect** - System design, tech stack
- **PO** - Backlog management, refinement
- **SM** - User stories, sprint planning
- **Dev** - Code implementation
- **QA** - Quality gates, testing
- **UX Expert** - UI/UX design

### Activating Agents

```
# In Claude Code
/BMad:agents:bmad-orchestrator

# List agents
*help

# Switch to specific agent
*agent pm
*agent architect
*agent dev
```

### Agent Workflows

**Discovery:**
```
*agent analyst
*document-project
```

**PRD Creation:**
```
*agent pm
*create-doc
Select: brownfield-prd-tmpl.yaml
```

**Story Creation:**
```
*agent sm
*draft
```

---

## Using Archon Knowledge Base

### Searching Documentation

```python
# General knowledge search
archon:rag_search_knowledge_base(
    query="Lion architecture components",
    match_count=5
)

# Code examples
archon:rag_search_code_examples(
    query="JWT authentication middleware",
    match_count=3
)

# List sources
archon:rag_get_available_sources()
```

### Best Practices

1. **Always research before implementing**
   - Query Archon RAG for existing patterns
   - Search for code examples
   - Review architecture documentation

2. **Use specific queries**
   - Good: "Edge Connector data validation patterns"
   - Bad: "how does it work"

3. **Adjust match_count**
   - High-level: 5-10 results
   - Specific: 2-3 results

---

## Code Standards

### General Principles

1. **Follow existing patterns** in the Lion codebase
2. **Query Archon** for architectural decisions
3. **Use BMAD agents** for structured workflows
4. **Write tests** for all new features
5. **Document** public APIs and complex logic

### Code Style

- **TypeScript:** Use strict mode, avoid `any`
- **Python:** PEP 8, type hints
- **Node.js:** ESLint, Prettier
- **Commits:** Conventional commits format

### Testing

- Unit tests for all business logic
- Integration tests for API endpoints
- E2E tests for critical user flows
- All tests must pass before marking task "done"

---

## Documentation

### What to Document

1. **In Code:** Complex logic, public APIs, non-obvious decisions
2. **In Archon:** Task descriptions, implementation notes
3. **In BMAD Stories:** Acceptance criteria, test scenarios
4. **In .ai/conversations/:** Session summaries, decisions

### Documentation Standards

- **Markdown** for all documentation
- **Mermaid** for diagrams
- **Code examples** for APIs
- **Clear headings** and structure

---

## Git Workflow

### Branch Strategy

```bash
# Feature branches
git checkout -b feature/task-description

# Bug fixes
git checkout -b fix/issue-description

# Infrastructure
git checkout -b infra/change-description
```

### Commit Messages

```
<type>(<scope>): <subject>

<body>

Archon Task: <task-id>
```

**Types:** feat, fix, docs, style, refactor, test, chore

**Examples:**
```
feat(edge-connector): add data validation layer

Implement validation for JSON, XML, and CSV formats
with error handling and logging.

Archon Task: abc12345-6789-...
```

### Pull Requests

1. Create PR from feature branch to main
2. Reference Archon task ID in description
3. Ensure all tests pass
4. Request review from team lead
5. Update Archon task to "review" status

---

## Questions or Issues?

1. **Check CLAUDE.md** for workflow guidance
2. **Query Archon knowledge base** for technical questions
3. **Review .ai/conversations/** for past decisions
4. **Contact technical project manager** for process questions

---

**Happy contributing!** 🚀
```

---

### 6. Obsolete Directory Cleanup

#### .gemini Directory

**Current Status:** Exists but purpose unclear

**Investigation Needed:**
```bash
ls -la .gemini/
# Check what's in this directory
```

**Recommended Action:**
```bash
# If obsolete (replaced by BMAD + Archon workflow)
mv .gemini .gemini.archive

# Update .gitignore to exclude archives
echo ".gemini.archive" >> .gitignore
echo ".bmad-infrastructure-devops.archive" >> .gitignore
echo ".claude/commands/BMad.archive" >> .gitignore
```

---

### 7. Update .gitignore

**File:** `/mnt/e/repos/atlas/.gitignore`

**Add:**
```gitignore
# Environment files
.env
.env.atlas
.env.local
*.env

# Archive directories
*.archive/

# AI session temporary files
.ai/temp/
.ai/debug-log.md

# Node modules
node_modules/
npm-debug.log*

# Python
__pycache__/
*.py[cod]
*$py.class
.venv/
venv/

# IDE
.vscode/
.idea/

# OS
.DS_Store
Thumbs.db

# Archon local data (if any)
archon/data/local/

# Temporary files
*.tmp
*.temp
*.swp
*.swo
```

---

## Implementation Checklist

### High Priority (Do First)

- [ ] **Backup current state**
  ```bash
  git add .
  git commit -m "Backup before consolidation"
  git push
  ```

- [ ] **Update README.md** with integrated workflow
- [ ] **Update TODO.md** to point to Archon
- [ ] **Create .env.atlas.template**
- [ ] **Create CONTRIBUTING.md**
- [ ] **Update timestamps** to 2025-10-01

### Medium Priority (This Week)

- [ ] **Archive duplicate BMAD directories**
  ```bash
  mv .bmad-infrastructure-devops .bmad-infrastructure-devops.archive
  mv .claude/commands/BMad .claude/commands/BMad.archive
  ```

- [ ] **Copy infrastructure agent to .bmad-core/**
- [ ] **Update .gitignore** with new rules
- [ ] **Investigate .gemini/** directory and archive if obsolete
- [ ] **Test all workflows** after changes

### Low Priority (Next Sprint)

- [ ] **Create video walkthrough** of integrated workflow
- [ ] **Add more examples** to CONTRIBUTING.md
- [ ] **Create troubleshooting guide**
- [ ] **Document GitLab sync process** in detail

---

## Summary of Changes

### Files to Update

1. ✅ `README.md` - Major rewrite for integrated framework
2. ✅ `TODO.md` - Simplify to point to Archon
3. ✅ `.env.atlas.template` - NEW file
4. ✅ `CONTRIBUTING.md` - NEW file
5. ✅ `.gitignore` - Add archive exclusions

### Files to Archive/Remove

1. ⚠️ `.bmad-infrastructure-devops/` → Archive (copy agent to core first)
2. ⚠️ `.claude/commands/BMad/` → Archive (not used by IDE)
3. ⚠️ `.gemini/` → Investigate and archive if obsolete

### Directories to Keep

1. ✅ `.bmad-core/` - Primary BMAD installation
2. ✅ `.ai/` - Session management and scripts
3. ✅ `archon/` - Archon MCP server
4. ✅ `issues/` - GitLab export tools
5. ✅ `docs/` - Project documentation output

---

## Testing Plan

### After Updates

1. **Verify Archon still works:**
   ```bash
   cd archon && docker compose ps
   curl http://localhost:3737
   curl http://localhost:8181/health
   ```

2. **Test helper scripts:**
   ```bash
   source .ai/scripts/archon-helpers.sh
   archon_health_check
   archon_status
   ```

3. **Test BMAD activation:**
   ```
   /BMad:agents:bmad-orchestrator
   *help
   ```

4. **Test MCP integration:**
   ```python
   archon:find_tasks(project_id="3f2b6ee9-05ff-48ae-ad6f-54cad080addc")
   ```

5. **Verify documentation:**
   - README.md renders correctly on GitHub
   - All links work
   - Code examples are accurate

---

## Risks and Mitigation

### Risk 1: Breaking Existing Workflows
**Mitigation:** Create git backup before changes, test thoroughly

### Risk 2: Lost Configuration
**Mitigation:** Archive rather than delete directories

### Risk 3: Team Confusion
**Mitigation:** Clear CONTRIBUTING.md, update team in standup

### Risk 4: MCP Integration Breaks
**Mitigation:** Don't touch `.bmad-core/` or `archon/` configurations

---

## Next Steps

1. **Review this draft** with technical project manager
2. **Get approval** for consolidation plan
3. **Create git branch** for updates: `git checkout -b repo-consolidation`
4. **Implement changes** incrementally
5. **Test each change** before proceeding
6. **Create PR** for review
7. **Merge to main** after approval
8. **Update team** on new structure

---

**Draft Created:** 2025-10-01
**Status:** Awaiting Review and Approval
**Estimated Effort:** 2-4 hours for full implementation
