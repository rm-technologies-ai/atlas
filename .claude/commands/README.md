# Claude Code Custom Commands for Atlas

This directory contains custom slash commands for the Atlas project that integrate BMAD Method™, Archon MCP, and Claude Code native functionality.

## Available Commands

### `/bmad-init` - Initialize BMAD + Archon Environment

**Purpose:** Complete initialization of the BMAD Method + Archon MCP integration for Atlas project.

**What it does:**
1. ✅ Clears context window
2. 🏗️ Establishes repository identity (Atlas project)
3. 🔌 Verifies Archon MCP server connection
4. 🎭 Loads all 10 BMAD agents (metadata)
5. 🔄 Establishes Archon-first integration rules
6. 📊 Configures GitLab data access
7. 🚀 Presents ready-to-use environment

**Usage:**
```
/bmad-init
```

**After initialization you can:**
- Query project status: "What tasks are in progress?"
- Activate BMAD agents: "*agent sm" or type agent number
- Search knowledge: "Search RAG for authentication patterns"
- Create tasks: "Create a task to implement JWT auth"
- Continue work: "Get my next todo task"

**Requirements:**
- Archon MCP server must be running (docker compose up)
- GitLab data optionally cloned to atlas-project-data/

**Troubleshooting:**
If Archon is not running:
```bash
cd /mnt/e/repos/atlas/archon
docker compose up --build -d
```

## Command Structure

Claude Code slash commands are markdown files in `.claude/commands/` that expand into prompts when invoked.

### How Slash Commands Work

1. User types `/bmad-init` in Claude Code
2. Claude Code reads `/mnt/e/repos/atlas/.claude/commands/bmad-init.md`
3. The entire markdown file becomes the prompt
4. Claude executes the instructions in the file
5. User sees the final output (initialization summary)

### Creating New Commands

Create a new `.md` file in this directory:

**Example: `/mnt/e/repos/atlas/.claude/commands/my-command.md`**
```markdown
# My Custom Command

You are executing a custom command.

## Steps:
1. Do this thing
2. Do that thing
3. Present results to user

Output to user:
✅ Command complete!
```

**Invoke with:** `/my-command`

## BMAD Agent Quick Reference

After running `/bmad-init`, these agents are available:

| # | Agent | Icon | Role | When to Use |
|---|-------|------|------|-------------|
| 1 | Orchestrator | 🎭 | Workflow coordination | Multi-agent tasks, role switching |
| 2 | Master | 🧙 | Universal executor | One-off tasks, any domain |
| 3 | Analyst | 🔍 | Research specialist | Market research, requirements |
| 4 | PM | 📋 | Product manager | PRD creation, product strategy |
| 5 | PO | 📊 | Product owner | Epic/story management |
| 6 | Architect | 🏗️ | System architect | Architecture design |
| 7 | SM | 🧭 | Scrum master | Story files, sprint planning |
| 8 | Dev | 💻 | Developer | Code implementation |
| 9 | QA | 🧪 | QA engineer | Testing, quality assurance |
| 10 | UX | 🎨 | UX designer | UI/UX design |

**Activate agent:** `*agent [name]` or type the number (e.g., `7`)

## Integration Rules (Automatically Applied)

After `/bmad-init`, these rules are ALWAYS active:

### 1. Archon-First Task Management
- All task queries go to Archon first
- TodoWrite is ONLY for session-scoped checklists
- Archon task status is updated during work

### 2. Research-First Implementation
- ALL technical answers search RAG knowledge base first
- ALL code implementations search code examples first
- Responses grounded with project-specific data

### 3. Task-Driven Development Cycle
```
Query Task → Research RAG → Implement → Update Status → Next Task
```

### 4. Three-Tier Task Hierarchy
- **Archon** (PRIMARY): Persistent tasks, backlog, cross-session
- **BMAD Stories** (SECONDARY): Generated from Archon for Dev/QA
- **TodoWrite** (TERTIARY): Current session checklists only

## Advanced Usage

### Combining Commands with Arguments

Some commands accept inline arguments:
```
/bmad-init
```

After initialization, use natural language:
```
# Activate specific agent
*agent sm

# Or use agent number
7

# Execute agent commands
*create-story-file

# Research with RAG
Search knowledge base for JWT authentication best practices

# Query tasks
What tasks are currently in doing status?

# Create new task
Create a task to implement user authentication with weight 5
```

## Architecture Integration

This command system integrates three frameworks:

### 1. Claude Code Native (Base Layer)
- Native tools: Read, Write, Edit, Bash, Grep, Glob
- Native task management: TodoWrite (session-scoped)
- Native agents: Task tool for specialized work

### 2. Archon MCP (Knowledge Layer)
- RAG knowledge base with vector search
- Project/task management (persistent)
- GitLab issue ingestion
- Code example retrieval

### 3. BMAD Method™ (Agent Layer)
- 10 specialized agents with personas
- Prescribed workflows (greenfield/brownfield)
- Story file generation with complete context
- Quality checklists and templates

**Integration Flow:**
```
User Request
    ↓
Claude Code Native (task execution)
    ↓
Archon MCP (knowledge retrieval + task tracking)
    ↓
BMAD Agents (specialized persona + workflows)
    ↓
RAG-Grounded Response
```

## File Locations

- **Commands:** `/mnt/e/repos/atlas/.claude/commands/`
- **Preferences:** `/mnt/e/repos/atlas/.claude/preferences.md`
- **BMAD Agents:** `/mnt/e/repos/atlas/BMAD-METHOD/bmad-core/agents/`
- **Archon Config:** `/mnt/e/repos/atlas/archon/`
- **Project Data:** `/mnt/e/repos/atlas/atlas-project-data/`

## Best Practices

### Starting a New Session

**Always run:**
```
/bmad-init
```

This ensures:
- Clean context
- Archon connection verified
- BMAD agents loaded
- Integration rules active
- Ready for RAG-grounded work

### During Development

**Let the system guide you:**
1. Query current tasks (Archon managed)
2. Search RAG before implementing
3. Activate appropriate BMAD agent
4. Update task status as you work
5. Move to next task

### When Stuck

**Use the orchestrator:**
```
*agent orchestrator
*help
```

The orchestrator can:
- Recommend which agent to use
- Show available workflows
- Help navigate complex multi-agent tasks

## Troubleshooting

### Command not found
- Check file exists: `ls -la /mnt/e/repos/atlas/.claude/commands/bmad-init.md`
- File must have `.md` extension
- Command name matches filename (without `.md`)

### Archon not connecting
```bash
cd /mnt/e/repos/atlas/archon
docker compose ps                    # Check status
docker compose logs -f archon-mcp    # View logs
docker compose up --build -d         # Restart
```

### BMAD agents not loading
```bash
ls -la /mnt/e/repos/atlas/BMAD-METHOD/bmad-core/agents/
```
Ensure all 10 agent files exist.

### GitLab data missing
```bash
cd /mnt/e/repos/atlas/gitlab-utilities
./clone-atlas-hive.sh --content-types all
```

## Support

For issues or questions:
- Check `/mnt/e/repos/atlas/CLAUDE.md` for project instructions
- Review `/mnt/e/repos/atlas/archon/SETUP-ATLAS.md` for Archon setup
- See `/mnt/e/repos/atlas/BMAD-METHOD/bmad-core/data/bmad-kb.md` for BMAD documentation

---

**Version:** 1.0
**Last Updated:** 2025-10-06
**Author:** Atlas Development Team
