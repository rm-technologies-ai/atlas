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
