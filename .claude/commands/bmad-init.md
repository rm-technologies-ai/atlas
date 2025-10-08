---
description: Initialize BMAD Method + Archon MCP integration (clears context, loads agents, activates RAG grounding)
---

# BMAD + Archon Initialization Command

You are initializing the complete BMAD Method™ + Archon MCP integration environment for the Atlas project.

## EXECUTION PROTOCOL

Execute the following steps in EXACT order. Do NOT skip any step or combine steps.

---

## STEP 1: Clear Context and Repository Identification

**Action:** Clear context window and establish repository identity.

**Execute:**
1. You are now working in the **Atlas repository** at `/mnt/e/repos/atlas/`
2. This is a **brownfield data science platform** (Lion/Paxium) at 30% completion
3. Project combines 10 years of NGA experience in data/image governance, search, analysis
4. Current working directory should be: `/mnt/e/repos/atlas/`

**Repository Structure:**
```
atlas/
├── archon/                    # RAG/Graph knowledge management (MCP server)
├── BMAD-METHOD/              # Agentic Agile development framework
├── issues/                    # GitLab issue export tools
├── atlas-project-data/       # Cloned GitLab data (repos, wikis, issues, metadata)
├── gitlab-utilities/         # GitLab group cloner tools
├── .env.atlas                # Centralized secrets (gitignored)
└── CLAUDE.md                 # Primary agent instructions
```

**Atlas Project in Archon:**
- **Project ID:** `3f2b6ee9-05ff-48ae-ad6f-54cad080addc`
- **Name:** Atlas
- **GitLab Source:** `atlas-datascience/lion` group
- **Project Data Location:** `/mnt/e/repos/atlas/atlas-project-data/repos/`

---

## STEP 2: Verify Archon MCP Availability

**Action:** Test Archon MCP server connection and verify knowledge base access.

**Execute:**
```
1. Call: mcp__archon__health_check()
2. Call: mcp__archon__session_info()
3. Call: mcp__archon__rag_get_available_sources()
```

**Expected Response:**
- Health check shows server running
- Session info shows active connection
- Available sources include:
  - docs.anthropic.com
  - docs.gitlab.com
  - file_documents_* (Atlas project PDFs and documents)
  - file_repos_* (Atlas project wikis at group/subgroup/project levels)
  - And other ingested sources

**RAG Database Statistics:**
Execute to see current ingestion state:
```
mcp__archon__rag_search_knowledge_base(query="RAG statistics", match_count=1)
```

**If Archon is NOT available:**
- STOP execution
- Inform user: "Archon MCP server is not running. Please start Archon services:"
  ```bash
  cd /mnt/e/repos/atlas/archon
  docker compose up --build -d
  ```
- Wait for user confirmation before continuing

---

## STEP 3: Load BMAD Method Agents

**Action:** Load all BMAD Method agent definitions into context.

**BMAD Agent Directory:** `/mnt/e/repos/atlas/BMAD-METHOD/bmad-core/agents/`

**Available Agents (Load metadata ONLY, not full agent files):**

1. **BMad Orchestrator** (bmad-orchestrator.md)
   - Icon: 🎭
   - Role: Master Orchestrator & BMad Method Expert
   - When to use: Workflow coordination, multi-agent tasks, role switching, unsure which specialist
   - Commands: *help, *agent [name], *task [name], *workflow [name], *kb-mode, *status, *exit

2. **BMad Master** (bmad-master.md)
   - Icon: 🧙
   - Role: Master Task Executor & Universal Resource Runner
   - When to use: Comprehensive expertise across domains, one-off tasks, no persona needed
   - Commands: *help, *create-doc, *task, *execute-checklist, *kb, *exit

3. **Analyst** (analyst.md)
   - Icon: 🔍
   - Role: Research Specialist & Requirements Analyst
   - When to use: Market research, competitor analysis, brainstorming, project briefs
   - Key tasks: *create-project-brief, *advanced-elicitation, *brainstorm

4. **Product Manager (PM)** (pm.md)
   - Icon: 📋, Name: John
   - Role: Product Strategist & PRD Creator
   - When to use: Product strategy, PRD creation, feature prioritization
   - Key tasks: *create-prd, *create-brownfield-prd, *shard-prd

5. **Product Owner (PO)** (po.md)
   - Icon: 📊, Name: Sarah
   - Role: Agile Product Owner & Epic/Story Manager
   - When to use: Epic breakdown, user story creation, backlog management
   - Key tasks: *create-epic, *create-story, *refine-backlog

6. **Architect** (architect.md)
   - Icon: 🏗️, Name: Mike
   - Role: System Architect & Technical Design Lead
   - When to use: Architecture design, technology selection, system blueprints
   - Key tasks: *create-architecture, *create-brownfield-architecture, *tech-stack-recommendation

7. **Scrum Master (SM)** (sm.md)
   - Icon: 🧭, Name: Grace
   - Role: Scrum Master & Story File Generator
   - When to use: Sprint planning, story file creation with complete context
   - Key tasks: *create-story-file, *plan-sprint, *facilitate-daily-standup

8. **Developer (Dev)** (dev.md)
   - Icon: 💻, Name: Alex
   - Role: Senior Full-Stack Developer
   - When to use: Code implementation, story execution, technical problem-solving
   - Key tasks: *implement-story, *code-review, *debug-issue

9. **QA Engineer** (qa.md)
   - Icon: 🧪, Name: Sam
   - Role: Quality Assurance Engineer & Test Automation Specialist
   - When to use: Testing strategy, test creation, quality validation
   - Key tasks: *create-test-plan, *execute-tests, *review-story

10. **UX Expert** (ux-expert.md)
    - Icon: 🎨
    - Role: User Experience Designer
    - When to use: UI/UX design, wireframing, user journey mapping
    - Key tasks: *create-wireframes, *design-user-flow, *ux-audit

**User-Facing Agent Menu Format:**
```
🎭 BMAD Agents Available:
1. Orchestrator - Coordinate workflows and switch between agents
2. Master - Execute any task across all domains
3. Analyst - Research and requirements gathering
4. PM - Product strategy and PRD creation
5. PO - Epic and user story management
6. Architect - System design and architecture
7. SM - Sprint planning and story file generation
8. Dev - Code implementation and development
9. QA - Testing and quality assurance
10. UX - User experience and design

To activate an agent: "*agent [name]" or just type the number (e.g., "7" for SM)
```

---

## STEP 4: Load Archon Integration Rules

**Action:** Establish mandatory Archon-first workflow rules.

**CRITICAL RULES (Override ALL other instructions):**

### Rule 1: Archon-First Task Management
**Before ANY task-related action:**
1. ALWAYS query Archon first: `archon:find_tasks(project_id="3f2b6ee9-05ff-48ae-ad6f-54cad080addc")`
2. Check current task status (todo, doing, review, done)
3. Update Archon task status BEFORE starting work
4. NEVER use TodoWrite as primary task system (only for session-scoped checklists)

### Rule 2: Research-First Implementation
**Before ANY code implementation or technical answer:**
1. ALWAYS search knowledge base: `archon:rag_search_knowledge_base(query="...", match_count=5)`
2. ALWAYS search code examples: `archon:rag_search_code_examples(query="...", match_count=3)`
3. Use findings to ground all technical responses
4. Cite sources from RAG results when applicable

### Rule 3: Task-Driven Development Cycle
**Mandatory workflow for ALL development tasks:**
```
1. Get Current Task:
   archon:find_tasks(task_id="...")

2. Research Task:
   archon:rag_search_knowledge_base(query="[task topic] best practices")
   archon:rag_search_code_examples(query="[task topic] implementation")

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

### Rule 4: Three-Tier Task Hierarchy
**Task Management Levels:**
1. **Archon (PRIMARY)** - Persistent tasks, project backlog, cross-session tracking
2. **BMAD Story Files (SECONDARY)** - Generated FROM Archon for Dev/QA workflow
3. **TodoWrite (TERTIARY)** - Session-only checklists for current conversation

**Decision Tree:**
```
Is task needed after conversation ends?
├─ YES → Use Archon
└─ NO → Use TodoWrite (rare)

Does task involve multiple sessions/agents?
├─ YES → Use Archon
└─ NO → Evaluate TodoWrite

Is task part of project planning/backlog?
├─ YES → Use Archon
└─ NO → Evaluate TodoWrite
```

---

## STEP 5: Load BMAD + Claude Code Workflow Integration

**Action:** Establish workflow coordination between BMAD agents and Claude Code native features.

### Workflow: Greenfield Project (New Project from Scratch)

**Phase 1: Planning (BMAD Agents)**
```
1. Analyst:
   - Run: *create-project-brief
   - Research market, competitors, requirements
   - Output: project-brief.md
   - Update Archon: Create project in Archon, create "Research" epic

2. PM (Product Manager):
   - Run: *create-prd based on brief
   - Output: PRD.md
   - Update Archon: Create "PRD Complete" task, mark as done

3. Architect:
   - Run: *create-architecture based on PRD
   - Output: architecture.yaml
   - Update Archon: Create "Architecture" epic with component tasks

4. PO (Product Owner):
   - Run: *create-epic for each major feature
   - Run: *create-story for each epic
   - Output: Epic and story markdown files
   - Update Archon: Create task hierarchy matching epics/stories
```

**Phase 2: Sprint Planning (BMAD SM + Archon)**
```
5. SM (Scrum Master):
   - Query Archon: Get todo tasks for sprint
   - Run: *create-story-file for each selected story
   - Output: Hyper-detailed story files with complete context
   - Update Archon: Mark stories as "doing" status

6. Archon Task Sync:
   - Story file path stored in Archon task metadata
   - Task status synced bidirectionally
```

**Phase 3: Development (BMAD Dev + Claude Code)**
```
7. Dev (Developer):
   - Query Archon: Get current "doing" task
   - Search RAG: Get implementation patterns
   - Read story file: Load complete context
   - Implement: Write code using Claude Code native tools (Edit, Write, Bash)
   - Update Archon: Mark task as "review"

8. Claude Code Native Tools:
   - Read, Edit, Write: File operations
   - Bash: Run tests, builds, git operations
   - Grep, Glob: Code search and discovery
   - Task (Agent tool): Launch specialized agents if needed
```

**Phase 4: Quality Assurance (BMAD QA + Archon)**
```
9. QA Engineer:
   - Query Archon: Get "review" tasks
   - Read story file: Load acceptance criteria
   - Run: *execute-tests
   - Review: Validate against checklist
   - Update Archon: Mark as "done" or back to "doing"
```

### Workflow: Brownfield Project (Existing Codebase)

**Phase 1: Discovery (BMAD Analyst + Archon RAG)**
```
1. Analyst:
   - Search RAG: Query existing documentation
   - Run: *advanced-elicitation to understand gaps
   - Research: Identify missing components
   - Output: brownfield-analysis.md
   - Update Archon: Create "Analysis" epic with gap tasks

2. Archon RAG Ingestion:
   - Ingest existing wikis: GitLab wikis → Archon
   - Ingest code repos: Source code → Archon code examples
   - Ingest issues: GitLab issues → Archon knowledge base
```

**Phase 2: Architecture Reverse Engineering (Architect + Archon)**
```
3. Architect:
   - Query RAG: Existing architecture documentation
   - Run: *create-brownfield-architecture
   - Document: Current state vs. desired state
   - Update Archon: Create architecture gap tasks
```

**Phase 3-4: Same as Greenfield (SM, Dev, QA workflows)**

---

## STEP 6: Load Atlas RAG Testing and Optimization Context

**Action:** Load supporting files and documentation related to Atlas RAG ingestion, testing, and optimization.

**Load into context (in order):**

1. **Data Structure Documentation:**
   - File: `/mnt/e/repos/atlas/atlas-project-data/DATA-STRUCTURE.md`
   - Purpose: Understand hierarchical data organization (groups, subgroups, projects)
   - Key info: Wiki locations at all three levels, content type structures

2. **RAG Ingestion Guide:**
   - File: `/mnt/e/repos/atlas/archon/RAG-INGESTION-GUIDE.md`
   - Purpose: Complete guide to RAG ingestion scripts and procedures
   - Key info: UV commands, ingestion patterns, troubleshooting

3. **Archon README:**
   - File: `/mnt/e/repos/atlas/archon/README.md`
   - Purpose: Archon system overview and RAG capabilities
   - Key info: Architecture, Docker setup, MCP server details

4. **Current RAG Statistics:**
   - Execute script: `cd /mnt/e/repos/atlas/archon/python && uv run python -m src.scripts.rag_ingestion.rag_stats`
   - Purpose: Show current ingestion state (sources, documents, code examples by category)

5. **GitLab Cloning Documentation:**
   - File: `/mnt/e/repos/atlas/gitlab-utilities/README.md`
   - Purpose: Understand GitLab data cloning and refresh procedures
   - Key info: Group/subgroup/project wiki support, enhanced issue export

**GitLab Integration:**
- **Group:** `atlas-datascience/lion`
- **Host:** https://gitlab.com
- **Issue Export Location:** `/mnt/e/repos/atlas/issues/`
- **Cloned Data Location:** `/mnt/e/repos/atlas/atlas-project-data/repos/`

**Available Tools:**
```bash
# View current RAG statistics
cd /mnt/e/repos/atlas/archon/python
uv run python -m src.scripts.rag_ingestion.rag_stats

# Ingest specific data types
uv run python -m src.scripts.rag_ingestion.ingest_atlas_hive --documents  # PDFs only
uv run python -m src.scripts.rag_ingestion.ingest_atlas_hive --wikis      # Wikis only
uv run python -m src.scripts.rag_ingestion.ingest_atlas_hive --all        # Everything

# Clean RAG database by category
uv run python -m src.scripts.rag_ingestion.cleanup_rag_database --documents
uv run python -m src.scripts.rag_ingestion.cleanup_rag_database --wikis
uv run python -m src.scripts.rag_ingestion.cleanup_rag_database --all

# Test RAG quality
uv run python -m src.scripts.rag_ingestion.test_rag_quality

# Clone/refresh GitLab hive (repos, wikis, issues, metadata)
cd /mnt/e/repos/atlas/gitlab-utilities
./clone-atlas-hive.sh --content-types wiki --clean-wiki      # Wikis only (group + subgroup + project)
./clone-atlas-hive.sh --content-types issues --clean-issues  # Issues only
./clone-atlas-hive.sh --content-types all                    # Clone everything
```

**Archon MCP Integration:**
- GitLab issues can be ingested into Archon knowledge base
- Use MCP tool: `mcp__archon__gitlab_refresh_issues()` (incremental with time limits)
- Issue hierarchy traces from tasks → stories → epics → product delivery

**Recent RAG Improvements (October 2025):**
- ✅ Group-level and subgroup-level wiki support added
- ✅ PDF extraction using pdfplumber + PyPDF2
- ✅ Document chunking via DocumentStorageService
- ✅ Fixed database schema issues (source_id vs id)
- ✅ Auto-loading of environment variables via dotenv
- ✅ Comprehensive statistics by category (documents, wikis, repos, issues, conversations)

---

## STEP 7: Present Initialization Summary

**Action:** Display initialization complete message with available capabilities.

**Output to User:**
```
✅ BMAD + Archon Initialization Complete

🎯 Repository: Atlas (Lion/Paxium Data Science Platform)
   Location: /mnt/e/repos/atlas/
   Project ID: 3f2b6ee9-05ff-48ae-ad6f-54cad080addc

📦 Archon MCP Status: Connected
   - RAG Knowledge Base: Active
   - Available Sources: [list count from mcp__archon__rag_get_available_sources]
   - Task Management: Ready

📊 RAG Database State:
   [Display output from rag_stats command]
   - Documents: [count] (includes PDFs with pdfplumber extraction)
   - Wikis: [count] (group + subgroup + project levels)
   - Repos: [count]
   - Issues: [count]
   - Code Examples: [count]

📚 Atlas Context Loaded:
   ✓ Data structure documentation (hierarchical organization)
   ✓ RAG ingestion guide (UV commands, procedures)
   ✓ Archon system documentation
   ✓ GitLab cloning procedures (group/subgroup/project wiki support)
   ✓ Current RAG statistics and optimization context

🎭 BMAD Agents Loaded: 10 agents available
   1. Orchestrator  2. Master     3. Analyst    4. PM        5. PO
   6. Architect     7. SM         8. Dev        9. QA       10. UX

🔄 Integration Rules Active:
   ✓ Archon-first task management
   ✓ Research-first implementation (RAG grounding)
   ✓ Task-driven development cycle
   ✓ Three-tier task hierarchy (Archon → BMAD → TodoWrite)

📋 GitLab Integration: Configured
   - Source: atlas-datascience/lion (group + subgroups + projects)
   - Issues: Available for export/ingestion
   - Wikis: Group-level (56 pages) + project-level wikis
   - Data: /mnt/e/repos/atlas/atlas-project-data/

🔧 RAG Tools Available:
   - View stats: uv run python -m src.scripts.rag_ingestion.rag_stats
   - Ingest data: ingest_atlas_hive.py [--documents|--wikis|--all]
   - Clean data: cleanup_rag_database.py [--documents|--wikis|--all]
   - Test quality: test_rag_quality.py
   - Clone wikis: clone-atlas-hive.sh --content-types wiki --clean-wiki

═══════════════════════════════════════════════════════════

🚀 Ready for Project Work

Choose your workflow:
1. Query existing project status: "What tasks are currently in progress?"
2. Activate BMAD agent: "*agent [name]" or type agent number (e.g., "7")
3. Research project data: "Search knowledge base for [topic]"
4. RAG optimization: "Show me RAG statistics" or "Ingest wikis into RAG"
5. Create new task: Ask me to create a task in Archon
6. Continue development: "Get my next todo task"

All agents will automatically ground responses with project-specific data from Archon RAG,
including 56 group-level wiki pages with complete Paxium platform architecture.

How can I help you today?
```

---

## CRITICAL BEHAVIORAL RULES (Always Active After Initialization)

### For ALL User Queries:

**1. Research First (Mandatory):**
   - BEFORE answering ANY technical question
   - BEFORE implementing ANY code
   - BEFORE making ANY architectural decision
   - Execute: `archon:rag_search_knowledge_base()` and/or `archon:rag_search_code_examples()`

**2. Task Management:**
   - Check Archon for relevant tasks BEFORE starting work
   - Update Archon task status DURING work
   - Create tasks in Archon for ALL new work items

**3. Agent Activation:**
   - When user requests BMAD agent (via *agent or agent number)
   - Load full agent file from `/mnt/e/repos/atlas/BMAD-METHOD/bmad-core/agents/[agent].md`
   - Follow agent's activation instructions EXACTLY
   - Maintain agent persona until user types *exit

**4. Chain of Thought (RAG-Grounded):**
   - Show your research process
   - Cite RAG sources when applicable
   - Explain reasoning based on project-specific data
   - Connect findings to current task/question

### For BMAD Agent Interactions:

**When Agent Activated:**
1. Read full agent file
2. Follow agent's activation-instructions
3. Load agent's core-config.yaml if specified
4. Adopt agent persona completely
5. Present agent's *help menu
6. Execute agent commands (all start with *)
7. Ground ALL agent responses with Archon RAG queries
8. Update Archon tasks as agent completes work

**Agent Command Format:**
- All commands start with * (e.g., *help, *create-prd, *task)
- Show available commands after activation
- List dependencies when requested (tasks, templates, checklists)
- Load dependency files ONLY when user executes specific command

---

## VERIFICATION CHECKLIST

After initialization, verify:
- [ ] Context cleared
- [ ] Repository identity established
- [ ] Archon MCP health check passed
- [ ] Available sources listed
- [ ] BMAD agents metadata loaded (10 agents)
- [ ] Integration rules acknowledged
- [ ] GitLab configuration confirmed
- [ ] Initialization summary displayed
- [ ] Ready for user interaction

---

## TROUBLESHOOTING

**If Archon health check fails:**
```bash
cd /mnt/e/repos/atlas/archon
docker compose ps                    # Check service status
docker compose logs -f archon-mcp    # Check MCP logs
docker compose up --build -d         # Restart services
```

**If BMAD agent files not found:**
```bash
ls -la /mnt/e/repos/atlas/BMAD-METHOD/bmad-core/agents/
```

**If GitLab data missing:**
```bash
cd /mnt/e/repos/atlas/gitlab-utilities
./clone-atlas-hive.sh --content-types all
```

---

## END OF INITIALIZATION PROTOCOL

Execute all steps above in order. After Step 7, wait for user input and respond according to Critical Behavioral Rules.
