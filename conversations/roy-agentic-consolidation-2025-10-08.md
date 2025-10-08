# Atlas Agentic Framework Specifications - Consolidated
**Generated:** 2025-10-08
**Purpose:** Complete consolidation of all existing agentic framework specifications before roy framework implementation

---

## Executive Summary

This document consolidates all agentic framework specifications currently active in the Atlas repository. This represents the **as-is state** before the roy framework assumes supreme authority.

**Current Agentic Frameworks:**
1. **BMAD Method** - Agile AI agent workflows (10 specialized agents)
2. **Archon MCP** - Knowledge management + task tracking via MCP protocol
3. **Claude Code** - Native IDE commands and tool integration
4. **Roy Framework** - Empty constructor (to be defined incrementally)

---

## 1. Current Authority Hierarchy (Pre-Roy)

### Existing Priority Order

```
CLAUDE.md Instructions
    ↓
Archon-First Task Management
    ↓
BMAD Agent Workflows
    ↓
Claude Code Native Tools
    ↓
TodoWrite (Session-only)
```

### Post-Roy Authority Hierarchy (Target State)

```
Roy Framework (.roy/) - SUPREME AUTHORITY
    ↓
BMAD Method (.bmad-core/, BMAD-METHOD/)
    ↓
Archon MCP (archon/)
    ↓
Claude Code (.claude/)
    ↓
TodoWrite (Tactical session-only)
```

---

## 2. BMAD Method Specification

### 2.1 Core Philosophy

**Two-Phase Approach:**
1. **Planning Phase** (Web UI) - PRD, Architecture, Stories (cost-effective with large context)
2. **Development Phase** (IDE) - Implementation with SM → Dev → QA cycles

**Key Principle:** "Vibe CEO" - You direct, AI agents execute with specialized expertise

### 2.2 BMAD Agents (10 Specialized Roles)

#### Agent 1: BMad Orchestrator 🎭
- **File:** `.bmad-core/agents/bmad-orchestrator.md`
- **Role:** Master Orchestrator & BMad Method Expert
- **When to Use:** Workflow coordination, multi-agent tasks, role switching, unsure which specialist
- **Commands:** `*help`, `*agent [name]`, `*task [name]`, `*workflow [name]`, `*kb-mode`, `*status`, `*exit`
- **Activation:** Loads core-config.yaml, checks Archon tasks BEFORE any operations
- **Persona:** Knowledgeable, guiding, adaptable, efficient, encouraging

#### Agent 2: BMad Master 🧙
- **File:** `.bmad-core/agents/bmad-master.md`
- **Role:** Master Task Executor & Universal Resource Runner
- **When to Use:** Comprehensive expertise across domains, one-off tasks, no persona needed
- **Commands:** `*help`, `*create-doc`, `*task`, `*execute-checklist`, `*kb`, `*exit`

#### Agent 3: Analyst 🔍 (Mary)
- **File:** `.bmad-core/agents/analyst.md`
- **Role:** Research Specialist & Requirements Analyst
- **When to Use:** Market research, competitor analysis, brainstorming, project briefs
- **Key Tasks:** `*create-project-brief`, `*advanced-elicitation`, `*brainstorm`
- **Archon Integration:** Creates "Research" epic in Archon

#### Agent 4: Product Manager (PM) 📋 (John)
- **File:** `.bmad-core/agents/pm.md`
- **Role:** Product Strategist & PRD Creator
- **When to Use:** Product strategy, PRD creation, feature prioritization
- **Key Tasks:** `*create-prd`, `*create-brownfield-prd`, `*shard-prd`
- **Archon Integration:** Creates "PRD Complete" task in Archon

#### Agent 5: Product Owner (PO) 📊 (Sarah)
- **File:** `.bmad-core/agents/po.md`
- **Role:** Agile Product Owner & Epic/Story Manager
- **When to Use:** Epic breakdown, user story creation, backlog management
- **Key Tasks:** `*create-epic`, `*create-story`, `*refine-backlog`
- **Archon Integration:** Creates task hierarchy matching epics/stories

#### Agent 6: Architect 🏗️ (Mike/Winston)
- **File:** `.bmad-core/agents/architect.md`
- **Role:** System Architect & Technical Design Lead
- **When to Use:** Architecture design, technology selection, system blueprints
- **Key Tasks:** `*create-architecture`, `*create-brownfield-architecture`, `*tech-stack-recommendation`
- **Archon Integration:** Creates "Architecture" epic with component tasks

#### Agent 7: Scrum Master (SM) 🧭 (Bob/Grace)
- **File:** `.bmad-core/agents/sm.md`
- **Role:** Scrum Master & Story File Generator
- **When to Use:** Sprint planning, story file creation with complete context
- **Key Tasks:** `*create-story-file`, `*plan-sprint`, `*facilitate-daily-standup`
- **Archon Integration:** Queries Archon for todo tasks, syncs story file path to task metadata

#### Agent 8: Developer (Dev) 💻 (James/Alex)
- **File:** `.bmad-core/agents/dev.md`
- **Role:** Senior Full-Stack Developer
- **When to Use:** Code implementation, story execution, technical problem-solving
- **Key Tasks:** `*implement-story`, `*code-review`, `*debug-issue`
- **Archon Integration:** Gets "doing" task, searches RAG for patterns, marks task as "review"

#### Agent 9: QA Engineer 🧪 (Quinn/Sam)
- **File:** `.bmad-core/agents/qa.md`
- **Role:** Quality Assurance Engineer & Test Automation Specialist
- **When to Use:** Testing strategy, test creation, quality validation
- **Key Tasks:** `*create-test-plan`, `*execute-tests`, `*review-story`
- **Archon Integration:** Gets "review" tasks, validates, marks "done" or "doing"

#### Agent 10: UX Expert 🎨 (Sally)
- **File:** `.bmad-core/agents/ux-expert.md`
- **Role:** User Experience Designer
- **When to Use:** UI/UX design, wireframing, user journey mapping
- **Key Tasks:** `*create-wireframes`, `*design-user-flow`, `*ux-audit`

### 2.3 BMAD Supporting Resources

**Checklists:** `.bmad-core/checklists/`
- architect-checklist.md
- change-checklist.md
- infrastructure-checklist.md
- pm-checklist.md
- po-master-checklist.md
- story-dod-checklist.md
- story-draft-checklist.md

**Templates:** `.bmad-core/output-templates/`
- PRD templates (greenfield, brownfield)
- Architecture templates
- Story templates
- Epic templates

**Knowledge Base:** `.bmad-core/data/bmad-kb.md`
- Core BMad philosophy
- Two-phase approach
- Development loop patterns
- Best practices

**PRP Templates:** `.bmad-core/prp-templates/`
- Pattern Reinforcement Prompts
- Agent-specific PRPs

---

## 3. Archon MCP Specification

### 3.1 Core Purpose

**Mission:** Power up AI coding assistants with custom knowledge base and task management via MCP protocol

**Key Capabilities:**
- Knowledge base with semantic search (RAG + pgvector)
- Project and task management
- Document versioning
- Code example extraction
- Real-time updates via HTTP polling

### 3.2 Architecture

**Services:**
- **Frontend UI** (port 3737) - React dashboard for project/knowledge management
- **Main API Server** (port 8181) - FastAPI with business logic and database operations
- **MCP Server** (port 8051) - MCP protocol server for AI assistants
- **Agents Service** (port 8052) - PydanticAI agents for AI/ML operations

**Database:** Supabase (PostgreSQL + pgvector for embeddings)

**Key Tables:**
- `sources` - Crawled websites and uploaded documents
- `documents` - Processed document chunks with embeddings
- `projects` - Project management (optional feature)
- `tasks` - Task tracking linked to projects (statuses: todo, doing, review, done)
- `code_examples` - Extracted code snippets
- `versions` - Version history for docs, features, data, PRD

### 3.3 MCP Tools Available

**Knowledge Base Tools:**
- `mcp__archon__rag_search_knowledge_base` - Search knowledge base for relevant content
- `mcp__archon__rag_search_code_examples` - Find code snippets
- `mcp__archon__rag_get_available_sources` - List available knowledge sources

**Project Management (Consolidated):**
- `mcp__archon__find_projects` - List/search/get projects (by project_id)
- `mcp__archon__manage_project` - Create/update/delete projects
- `mcp__archon__get_project_features` - Get features from project

**Task Management (Consolidated):**
- `mcp__archon__find_tasks` - List/search/get tasks (by task_id, filter by status/project/assignee)
- `mcp__archon__manage_task` - Create/update/delete tasks

**Document Management (Consolidated):**
- `mcp__archon__find_documents` - List/search/get documents (by document_id, filter by type)
- `mcp__archon__manage_document` - Create/update/delete documents

**Version Management (Consolidated):**
- `mcp__archon__find_versions` - List/get version history
- `mcp__archon__manage_version` - Create/restore versions

**GitLab Integration:**
- `mcp__archon__gitlab_refresh_issues` - Incremental GitLab issue ingestion

**Health & Session:**
- `mcp__archon__health_check` - Server health status
- `mcp__archon__session_info` - Active session information

### 3.4 Archon Development Principles

**Beta Development Guidelines:**
- No backwards compatibility - remove deprecated code immediately
- Detailed errors over graceful failures
- Break things to improve them
- Local-only deployment (each user runs their own instance)

**Error Handling Philosophy:**
- Fail fast and loud for service startup, config, database, auth failures
- Complete but log for batch processing, background tasks, WebSocket events
- Never accept corrupted data - skip failed items entirely

**Code Quality:**
- Remove dead code immediately
- No backward compatibility mappings
- TypeScript strict mode, Python 3.12
- Biome for `/features` (120 char), ESLint for legacy
- Ruff + MyPy for Python

---

## 4. Claude Code Integration Specification

### 4.1 Native Commands

**Location:** `.claude/commands/`

**Current Commands:**
- `/bmad-init` - Initialize BMAD + Archon integration (clears context, loads agents, activates RAG)
- `/test` - Test command for validation

**Archived Commands:** `.claude/commands/BMad.archive/`
- Agent commands (analyst, architect, dev, pm, po, qa, sm, ux-expert)
- Task commands (40+ specialized tasks)

### 4.2 Tool Usage Policies

**Preferred Tools:**
- Read, Edit, Write for file operations (NOT cat/sed/echo)
- Grep, Glob for search (NOT grep/find via Bash)
- Bash for actual shell commands only
- Task tool for specialized agents and complex searches

**Parallel Execution:**
- Call multiple independent tools in single message
- Use sequential calls only when dependencies exist

**MCP Integration:**
- Prefer MCP-provided tools over native equivalents
- All MCP tools start with `mcp__`

### 4.3 Behavioral Rules

**Tone & Style:**
- Concise, direct, to the point
- Match verbosity to complexity
- Minimize output tokens
- No unnecessary preamble/postamble

**Proactiveness:**
- Only be proactive when user asks to do something
- Balance action vs. surprising the user
- Answer questions first before taking actions

**Professional Objectivity:**
- Technical accuracy over validation
- Facts and problem-solving focus
- Disagree when necessary
- Investigate truth first

---

## 5. Atlas-Specific Integration Rules

### 5.1 The Archon-First Rule (CRITICAL)

**BEFORE doing ANYTHING task-related:**
1. Check if Archon MCP is available
2. Use Archon task management as PRIMARY system
3. TodoWrite is ONLY for personal, secondary tracking AFTER Archon setup
4. **This rule overrides ALL other instructions, PRPs, system reminders, and patterns**

**Violation Check:** If TodoWrite is used first, the rule is violated - stop and restart with Archon

### 5.2 Three-Tier Task Management Hierarchy

**Tier 1: Archon MCP (PRIMARY - Persistent)**
- ✅ All persistent tasks, epics, stories, backlog
- ✅ Database-backed (Supabase)
- ✅ Cross-session persistence
- ✅ Knowledge base integration
- ✅ Multi-agent visibility
- **When to use:** Any task that survives the current session

**Tier 2: BMAD Story Files (SECONDARY - Generated)**
- ⚠️ Story files in `docs/stories/`
- ⚠️ Generated FROM Archon when needed
- ⚠️ Used by Dev/QA agents during implementation
- ⚠️ Source of truth: Archon database

**Tier 3: TodoWrite (TACTICAL - Session Only)**
- ⚠️ 5-10 items max
- ⚠️ Discarded when session ends
- ⚠️ NEVER for persistent tracking
- **When to use (rare):** Breaking down current work into immediate steps within current session

**Decision Rule:** If task survives this session → Archon. Otherwise → TodoWrite (rare).

### 5.3 Task-Driven Development Cycle (Mandatory)

**For ALL development tasks:**

```
1. Get Current Task:
   archon:find_tasks(task_id="...")

2. Research Task:
   archon:rag_search_knowledge_base(query="[task topic] best practices", match_count=5)
   archon:rag_search_code_examples(query="[task topic] implementation", match_count=3)

3. Implement:
   - Write code based on research findings
   - Follow patterns from code examples
   - Apply best practices from knowledge base

4. Update Status:
   archon:manage_task(action="update", task_id="...", status="review")

5. Get Next Task:
   archon:find_tasks(filter_by="status", filter_value="todo", project_id="3f2b6ee9-05ff-48ae-ad6f-54cad080addc")

6. REPEAT
```

### 5.4 Research-First Implementation

**BEFORE ANY code implementation or technical answer:**
1. ALWAYS search knowledge base: `archon:rag_search_knowledge_base(query="...", match_count=5)`
2. ALWAYS search code examples: `archon:rag_search_code_examples(query="...", match_count=3)`
3. Use findings to ground all technical responses
4. Cite sources from RAG results when applicable

**Research Scope Examples:**
- **High-level:** "microservices architecture patterns", "database security practices"
- **Low-level:** "Zod schema validation syntax", "Cloudflare Workers KV usage"
- **Debugging:** "TypeScript generic constraints error", "npm dependency resolution"

### 5.5 Atlas Project Context

**Project ID:** `3f2b6ee9-05ff-48ae-ad6f-54cad080addc`
**Project Name:** Atlas
**Project Type:** Brownfield data science platform (Lion/Paxium) at 30% completion
**Target:** MVP by December 2025
**Repository:** `/mnt/e/repos/atlas/`
**GitHub:** `https://github.com/rm-technologies-ai/atlas` (private)
**GitLab Source:** `atlas-datascience/lion` group

---

## 6. Integration Workflows

### 6.1 Greenfield Project Workflow

**Phase 1: Planning (BMAD Agents)**
```
1. Analyst → *create-project-brief → Create project in Archon
2. PM → *create-prd → Mark "PRD Complete" in Archon
3. Architect → *create-architecture → Create "Architecture" epic in Archon
4. PO → *create-epic + *create-story → Create task hierarchy in Archon
```

**Phase 2: Sprint Planning (BMAD SM + Archon)**
```
5. SM → Query Archon for todo tasks → *create-story-file for each
6. Archon Task Sync → Story file path stored in task metadata
```

**Phase 3: Development (BMAD Dev + Claude Code)**
```
7. Dev → Query Archon for "doing" task → Search RAG → Implement → Mark "review"
8. Claude Code → Use Read, Edit, Write, Bash, Grep, Glob tools
```

**Phase 4: QA (BMAD QA + Archon)**
```
9. QA → Query Archon for "review" tasks → *execute-tests → Mark "done" or "doing"
```

### 6.2 Brownfield Project Workflow

**Phase 1: Discovery (BMAD Analyst + Archon RAG)**
```
1. Analyst → Search RAG for existing docs → *advanced-elicitation → Create "Analysis" epic
2. Archon RAG Ingestion → GitLab wikis/repos/issues → Archon knowledge base
```

**Phase 2: Architecture Reverse Engineering (Architect + Archon)**
```
3. Architect → Query RAG → *create-brownfield-architecture → Create gap tasks in Archon
```

**Phase 3-4:** Same as Greenfield (SM, Dev, QA workflows)

### 6.3 BMAD Initialization Protocol

**Command:** `/bmad-init`

**Execution Steps:**
1. Clear context, establish repository identity (Atlas at `/mnt/e/repos/atlas/`)
2. Verify Archon MCP availability (health check, session info, available sources)
3. Load BMAD agent metadata (10 agents)
4. Load Archon integration rules (Archon-first, research-first, task-driven)
5. Load BMAD + Claude Code workflow integration
6. Load Atlas RAG testing and optimization context
7. Present initialization summary

**Critical Behavioral Rules (Post-Init):**
- Research first (mandatory before ANY technical work)
- Check Archon for tasks BEFORE starting work
- Activate BMAD agents via `*agent [name]` or agent number
- Show RAG-grounded chain of thought
- Update Archon tasks as work progresses

---

## 7. Roy Framework Integration (Target State)

### 7.1 Roy Authority Declaration

**Location:** `.roy/` (all content is AUTHORITATIVE)

**Conceptual Model:**
- Top-level orchestrator corresponding to user's consciousness
- Extends capacity to plan, automate, execute, assess, and optimize tasks
- Operates in isolation ("VLAN" concept) during development
- Hierarchical inheritance - all folders inherit roy behavior

**Current State:** Empty constructor (OOP paradigm) - no agentic logic defined yet

### 7.2 Roy-First Principle (Post-Implementation)

Once roy framework is implemented, the authority hierarchy becomes:

```
Roy Framework (.roy/) - SUPREME AUTHORITY (overrides everything)
    ↓
BMAD Method - Subordinate to roy orchestration
    ↓
Archon MCP - Subordinate to roy orchestration
    ↓
Claude Code - Subordinate to roy orchestration
    ↓
TodoWrite - Lowest level (session-only)
```

**All agentic behavior in this repository will be governed and orchestrated at the roy topmost level.**

### 7.3 Roy Commands (To Be Created)

**Command 1: `/roy-init`**
- Loads all roy agents, commands, and custom agentic logic
- Minimal initial implementation (empty constructor state)

**Command 2: `/roy-agentic-specification`**
- Parameter: `$SPECIFICATION` (natural language description)
- Workflow:
  1. Analyze specification relative to current roy implementation
  2. Formulate implementation plan
  3. Identify required changes to existing roy definition
  4. Ensure backward compatibility and complete propagation
  5. Generate automated agentic unit tests
  6. Conduct tests and fix until verification complete

### 7.4 Execution Constraints (Roy Guidelines)

- **Do not deviate** from direct commands and instructions
- **Always provide exit criteria** in agentic logic (prevent infinite loops)
- **Do not attempt or suggest** changes beyond what is explicitly requested
- **When encountering blockers:** Find root cause, fix it (no workarounds)

---

## 8. Technical Stack Summary

**Backend:** Node.js, Next.js, Python, FastAPI
**Cloud:** AWS (Terraform, CloudFormation)
**Platform:** GitLab CI/CD (Lion project), GitHub (Atlas repo)
**Database:** Supabase (PostgreSQL + pgvector)
**AI:** OpenAI (Archon embeddings), Claude Code (primary agent)
**Development:** WSL, Docker, VS Code
**Version Control:** GitHub (Atlas), GitLab (Lion)

---

## 9. Environment Variables

**Location:** `.env.atlas` (gitignored, all secrets)

**Key Variables:**
- `SUPABASE_URL`, `SUPABASE_SERVICE_KEY` - Archon database
- `OPENAI_API_KEY` - Archon embeddings
- `GITLAB_TOKEN`, `GITLAB_GROUP`, `GITLAB_API_URL` - GitLab integration
- `GITHUB_TOKEN` - GitHub access
- `ARCHON_UI_PORT=3737`, `ARCHON_SERVER_PORT=8181`, `ARCHON_MCP_PORT=8051`

**Template:** `.env.atlas.template` for setup

---

## 10. Data Flow Patterns

```
GitLab Issues → issues/ → CSV → Archon RAG → Claude Code MCP
                                    ↓
                           Project/Task Management
                                    ↓
                            BMAD Agents ← Roy Orchestration (future)
                                    ↓
                         Story Files → docs/stories/
                                    ↓
                            Dev/QA Implementation
                                    ↓
                            Git Commit → GitHub
```

---

## 11. Key Agentic Patterns

### Pattern 1: Agent Activation
```
1. User requests agent via *agent [name] or number
2. Load full agent file from .bmad-core/agents/[agent].md
3. Check Archon for existing tasks (Archon-first rule)
4. Follow agent's activation-instructions EXACTLY
5. Adopt agent persona completely
6. Present agent's *help menu
7. Ground ALL agent responses with Archon RAG queries
8. Maintain persona until user types *exit
```

### Pattern 2: Task Execution
```
1. ALWAYS check Archon first: find_tasks(project_id="3f2b6ee9-05ff-48ae-ad6f-54cad080addc")
2. Get task details: find_tasks(task_id="...")
3. Update to in-progress: manage_task(action="update", task_id="...", status="doing")
4. Research with RAG: rag_search_knowledge_base() + rag_search_code_examples()
5. Implement based on research findings
6. Update to review: manage_task(action="update", task_id="...", status="review")
7. Get next task: find_tasks(filter_by="status", filter_value="todo")
```

### Pattern 3: Knowledge Integration
```
1. Before ANY implementation: rag_search_knowledge_base(query="...", match_count=5)
2. For code patterns: rag_search_code_examples(query="...", match_count=3)
3. Cross-reference multiple sources
4. Cite sources in responses
5. Document assumptions and limitations
```

---

## 12. Statistics

**Agentic Frameworks:** 4 (Roy [empty], BMAD, Archon, Claude Code)
**BMAD Agents:** 10 specialized agents
**BMAD Commands:** 50+ tasks + agent commands
**Archon MCP Tools:** 20+ tools (consolidated to ~10 with multi-function tools)
**Claude Code Commands:** 2 active + future roy commands
**Checklists:** 7 quality gates
**Templates:** 10+ (PRD, architecture, stories, epics)

---

## 13. Next Steps for Roy Implementation

1. **Create `.roy/README.md`** - Document roy framework authority and principles
2. **Create `/roy-init` command** - Load roy context (empty constructor initially)
3. **Create `/roy-agentic-specification` command** - Incremental roy definition workflow
4. **Update `CLAUDE.md`** - Register roy as supreme authority
5. **Begin incremental specification** - Define roy agentic logic via `/roy-agentic-specification` commands

---

## 14. Critical Integration Points

### BMAD ↔ Archon Integration
- BMAD agents query Archon BEFORE any task operations (activation-instructions, line 23-29)
- Story files synced to Archon task metadata
- Task status flows: todo → doing → review → done
- All persistent work tracked in Archon, not BMAD story files

### Archon ↔ Claude Code Integration
- MCP protocol provides seamless knowledge base access
- Claude Code uses Archon tools via `mcp__archon__*` prefix
- Real-time updates via HTTP polling (ETag caching)
- TanStack Query for data fetching in UI

### BMAD ↔ Claude Code Integration
- BMAD agents use Claude Code native tools (Read, Edit, Write, Bash, Grep, Glob)
- Agent commands start with `*` (e.g., `*help`, `*agent pm`)
- Agent activation via `/bmad-init` or direct `*agent [name]`
- Context management via clean chat patterns (new chat per agent cycle)

### Roy ↔ All Frameworks (Target)
- Roy will orchestrate BMAD, Archon, and Claude Code
- Roy-first rule will supersede Archon-first rule
- All frameworks inherit roy agentic behavior hierarchically
- Roy operates in isolation during development phase

---

## Conclusion

This consolidation represents the complete as-is state of agentic frameworks in Atlas repository as of 2025-10-08. All specifications documented here will operate under roy framework orchestration once roy agentic logic is defined incrementally via `/roy-agentic-specification` commands.

**Current State:** Three active frameworks (BMAD, Archon, Claude Code) + one empty framework (Roy)

**Target State:** Roy framework as supreme orchestrator with all other frameworks subordinate

---

**End of Consolidation**
