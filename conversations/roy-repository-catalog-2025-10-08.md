# Atlas Repository Catalog
**Generated:** 2025-10-08
**Purpose:** Complete directory hierarchy mapping for roy agentic framework context loading

---

## Repository Overview

**Atlas** (`/mnt/e/repos/atlas/` or `E:\repos\atlas\`) is a meta-repository serving as a virtual extension of the owner's capacity to plan, automate, execute, assess, and optimize tasks across multiple domains, projects, and activities.

**Original Purpose:** Aggregation workspace for ATLAS Data Science (Lion/Paxium) brownfield project
**Evolved Purpose:** Universal personal agentic workspace with unbounded possibilities for agent creation, reuse, and self-improvement

---

## Root-Level Structure

### Configuration & Documentation Files

```
/mnt/e/repos/atlas/
├── CLAUDE.md                   # Primary AI guidance - Archon/BMAD integration workflows
├── README.md                   # Project overview and quick start guide
├── NOTES.md                    # Session notes and development journal
├── TODO.md                     # High-level task overview (READ-ONLY, use Archon for actual tasks)
├── SESSION.md                  # Current session tracking and status
├── CONTRIBUTING.md             # Contribution guidelines
├── COMPLETION_SUMMARY.md       # Project milestone completions
├── IMPLEMENTATION_PLAN_SUMMARY.md  # Implementation planning documentation
├── SPRINT_TASK_REPORT.md       # Sprint progress reports
├── .env.atlas                  # Centralized environment variables (GITIGNORED - all secrets)
├── .env.atlas.template         # Template for environment setup
```

**Purpose:** Root-level documentation establishing workflows, patterns, and project context for AI agents

---

### Hidden Configuration Directories

#### `.roy/` - Roy Agentic Layer (SUPREME AUTHORITY)
```
.roy/
├── SEED.md                     # Inception documentation for roy framework
```

**Purpose:** Top-level orchestrator for all agentic behavior. ALL content in this folder supersedes all other agentic definitions in the repository. Currently in "empty constructor" state - agentic specifications to be defined incrementally.

**Authority Level:** SUPREME - overrides BMAD, Archon, and all other frameworks

---

#### `.claude/` - Claude Code Native Integration
```
.claude/
├── commands/
│   ├── bmad-init.md            # BMAD initialization command
│   ├── test.md                 # Test command for validation
│   ├── README.md               # Command documentation
│   └── BMad.archive/           # Archived BMAD commands
│       ├── agents/             # Agent command definitions (analyst, architect, dev, pm, qa, sm, ux-expert)
│       └── tasks/              # Task command definitions (40+ specialized tasks)
└── [future roy commands]       # /roy-init, /roy-agentic-specification (to be created)
```

**Purpose:** Claude Code slash commands and native agent definitions. Home for roy commands once created.

---

#### `.bmad-core/` - BMAD Method Core Framework
```
.bmad-core/
├── agents/                     # AI agent personas (Analyst, PM, Architect, SM, Dev, QA, UX, etc.)
│   ├── analyst.md              # Mary - Discovery, research, competitive analysis
│   ├── pm.md                   # John - PRDs, product strategy, roadmaps
│   ├── architect.md            # Winston - System design, tech stack, APIs
│   ├── po.md                   # Sarah - Backlog management, story refinement
│   ├── sm.md                   # Bob - User stories, sprint planning
│   ├── dev.md                  # James - Code implementation, testing
│   ├── qa.md                   # Quinn - Quality gates, test architecture
│   ├── ux-expert.md            # Sally - UI/UX design, prototypes
│   ├── bmad-orchestrator.md    # Orchestrates agent collaboration
│   └── infra-devops-platform.md # Infrastructure/DevOps specialist
├── checklists/                 # Quality gates and validation checklists
│   ├── architect-checklist.md
│   ├── change-checklist.md
│   ├── infrastructure-checklist.md
│   ├── pm-checklist.md
│   ├── po-master-checklist.md
│   ├── story-dod-checklist.md
│   └── story-draft-checklist.md
├── data/                       # BMAD knowledge base and techniques
│   ├── bmad-kb.md              # Core BMAD knowledge base
│   └── brainstorming-techniques.md
├── output-templates/           # PRD, architecture, story templates
└── prp-templates/              # Pattern Reinforcement Prompt templates
```

**Purpose:** Specialized AI agents for Agile roles with prompts, personas, and workflows. Subordinate to roy framework.

---

#### `.ai/` - AI Session Management
```
.ai/
├── conversations/              # Archived AI session conversations
├── scripts/                    # Helper scripts
│   └── archon-helpers.sh       # CLI helpers for Archon task management
└── [task management guides]    # Integration analysis and quick reference
```

**Purpose:** Session archives and helper utilities for AI-assisted development

---

#### Other Hidden Directories
```
.atlas/                         # Atlas-specific configuration
.bmad-infrastructure-devops.archive/  # Archived infrastructure content
.gemini.archive/                # Archived Gemini-related content
```

**Purpose:** Archived or specialized configuration directories

---

## Primary Project Directories

### `/archon/` - Knowledge Management & Task Tracking (MCP Server)
```
archon/
├── archon-ui-main/             # React frontend (port 3737) - Project/knowledge dashboard
│   ├── src/
│   │   ├── features/           # Modern vertical slice architecture
│   │   │   ├── ui/             # Radix UI primitives, hooks, types
│   │   │   ├── projects/       # Project management feature
│   │   │   ├── knowledge/      # Knowledge base management
│   │   │   ├── mcp/            # MCP integration UI
│   │   │   └── testing/        # Testing utilities
│   │   └── components/         # Legacy components (being migrated)
│   ├── public/                 # Static assets
│   └── tests/                  # Frontend tests
├── python/                     # FastAPI backend + MCP server
│   └── src/
│       ├── server/             # Main API server (port 8181)
│       │   ├── api_routes/     # REST API endpoints
│       │   └── services/       # Business logic layer
│       ├── mcp_server/         # MCP protocol server (port 8051)
│       │   └── features/       # MCP tools (tasks, projects, docs, RAG, versions)
│       └── agents/             # PydanticAI agents (port 8052)
├── docs/                       # Docusaurus documentation
├── PRPs/                       # Pattern Reinforcement Prompts
├── migration/                  # Database migration scripts
├── scripts/                    # Utility scripts
├── README.md                   # Archon setup and overview
├── SETUP-ATLAS.md              # Atlas-specific setup instructions
├── docker-compose.yml          # Service orchestration
└── .env                        # Archon environment (sources from .env.atlas)
```

**Purpose:** RAG/Graph knowledge base with semantic search (pgvector), project and task management database, MCP server for Claude Code integration. Subordinate to roy framework.

**Services:**
- UI: http://localhost:3737 (dashboard)
- API: http://localhost:8181 (REST)
- MCP: http://localhost:8051 (protocol for AI assistants)

---

### `/BMAD-METHOD/` - Universal AI Agent Framework
```
BMAD-METHOD/
├── bmad-core/                  # Core agent definitions (symlink to .bmad-core)
├── common/                     # Shared utilities and libraries
├── dist/                       # Distribution builds
├── docs/                       # BMAD documentation and user guides
├── expansion-packs/            # Domain-specific agent packs (game dev, DevOps, etc.)
├── tools/                      # BMAD tooling and utilities
└── README.md                   # BMAD overview and quick start
```

**Purpose:** Breakthrough Method of Agile AI-Driven Development framework. Provides Analyst, PM, Architect, SM, Dev, QA agents for full-stack Agile development. Subordinate to roy framework.

**Activation:** `/BMad:agents:bmad-orchestrator` in Claude Code

---

### `/issues/` - GitLab Issue Export Tool
```
issues/
├── list-issues-csv.sh          # Basic issue metadata export
├── list-issues-csv-with-text.sh # Full export with descriptions/comments
├── list-issues-csv-with-text-enhanced.sh # Enhanced export with complete history
├── test-csv-format.sh          # CSV formatting tests
├── gitlab-hive-issues.csv      # Basic metadata export output
├── gitlab-issues-with-text.csv # Full export output
├── gitlab-issues-enhanced-*.csv # Enhanced exports with timestamps
└── CLAUDE.md                   # Tool usage documentation
```

**Purpose:** Export GitLab issues from `atlas-datascience/lion` group to CSV/XLSX for LLM/RAG processing and analysis

---

### `/gitlab-utilities/` - GitLab Integration Tools
```
gitlab-utilities/
├── docs/                       # Utility documentation
├── export/                     # Export output directory
├── export-[timestamp]/         # Timestamped export snapshots
├── gitlab-group-cloner/        # Clone entire GitLab groups
├── gitlab-issue-csv-exporter/  # CSV export tool
├── gitlab_cloner/              # Repository cloning utilities
├── ms-project-merge/           # MS Project integration
├── reports/                    # Generated reports
├── simple-gitlab-issue-backup/ # Lightweight issue backup
├── test-clone-output/          # Test outputs
└── test_env/                   # Testing environment
```

**Purpose:** Suite of utilities for GitLab integration (cloning, exporting, reporting) for `atlas-datascience/lion` project

---

### `/gitlab-sdk/` - GitLab SDK Integration
```
gitlab-sdk/
└── data/                       # SDK data and outputs
```

**Purpose:** GitLab SDK integration for programmatic GitLab access

---

### `/docs/` - Project Documentation
```
docs/
├── atlas-documents/            # Atlas project documentation
└── configuration-documents/    # Configuration guides
```

**Purpose:** Output directory for BMAD-generated documents (stories, PRD, architecture, discovery)

---

### `/local-ai-packaged/` - Local AI Infrastructure
```
local-ai-packaged/
├── assets/                     # Static assets
├── caddy-addon/                # Caddy reverse proxy configuration
├── flowise/                    # Flowise low-code AI workflows
├── n8n/                        # n8n workflow automation
├── n8n-tool-workflows/         # Pre-built n8n workflows
└── searxng/                    # SearxNG metasearch engine
```

**Purpose:** Containerized local AI infrastructure (Flowise, n8n, SearxNG) for self-hosted AI workflows

---

### `/atlas-project-data/` - Atlas Project Assets
```
atlas-project-data/
├── conversations/              # Project conversations and archives
├── documents/                  # Project document storage
└── repos/                      # Project-related repositories
```

**Purpose:** Centralized storage for Atlas project artifacts, conversations, and cloned repositories

---

### `/conversations/` - Session Archives
```
conversations/
├── [various session archives]  # Saved AI conversation sessions
└── roy-repository-catalog-2025-10-08.md  # THIS DOCUMENT
```

**Purpose:** Archive of AI-assisted development sessions and analysis documents

---

### `/archon-test/` - Archon Testing Data
```
archon-test/
├── graph-ingest-records/       # Graph database test data
└── rag-ingest-records/         # RAG ingestion test records
```

**Purpose:** Test data and fixtures for Archon knowledge base development

---

## Repository Relationships & Integration

### Three-Tier Task Management Hierarchy

1. **Archon MCP (PRIMARY)** - Persistent tasks, database-backed, cross-session
2. **BMAD Story Files (SECONDARY)** - Generated documentation from Archon during dev cycle
3. **TodoWrite (TACTICAL)** - Session-only breakdown, discarded after session

### Agentic Authority Hierarchy (Post-Roy Implementation)

1. **Roy Framework (SUPREME)** - `.roy/` - Orchestrates all other frameworks
2. **BMAD Method** - `.bmad-core/`, `BMAD-METHOD/` - Agile AI agent workflows
3. **Archon MCP** - `archon/` - Knowledge base + task management
4. **Claude Code** - `.claude/` - Native commands and integration

### Data Flow Patterns

```
GitLab Issues → issues/ → CSV → Archon RAG → Claude Code MCP
                                    ↓
                           Project/Task Management
                                    ↓
                            BMAD Agents ← Roy Orchestration
                                    ↓
                         Story Files → docs/stories/
                                    ↓
                            Dev/QA Implementation
                                    ↓
                            Git Commit → GitHub
```

---

## Key Files for Context Loading

### Essential Reading for New Sessions
1. `.roy/SEED.md` - Roy framework inception and vision
2. `CLAUDE.md` - AI workflow patterns and integration
3. `README.md` - Project overview and quick start
4. `.bmad-core/data/bmad-kb.md` - BMAD knowledge base
5. `archon/SETUP-ATLAS.md` - Archon integration details

### Agentic Specifications (Consolidation Required)
- All `.md` files in `.claude/commands/`
- All `.md` files in `.bmad-core/agents/`
- All `.md` files in `.bmad-core/checklists/`
- `BMAD-METHOD/docs/` documentation
- `archon/PRPs/` Pattern Reinforcement Prompts

---

## Version Control

**Primary Repository:** GitHub - `https://github.com/rm-technologies-ai/atlas` (private)

**Subfolders with VCS:**
- `archon/` - GitHub
- `BMAD-METHOD/` - GitHub
- Individual project folders may contain their own Git repos from GitHub/GitLab

**GitLab Integration:** `atlas-datascience/lion` group (issues, wikis, repos cloned into subfolders)

---

## Environment & Platform

- **Platform:** Windows 11 Pro with WSL (Ubuntu/Debian)
- **Tools:** VS Code (WSL terminal), Docker Desktop
- **Backend:** Node.js, Next.js, Python, FastAPI
- **Cloud:** AWS (Terraform, CloudFormation)
- **Database:** Supabase (PostgreSQL + pgvector)
- **AI:** OpenAI (Archon embeddings), Claude Code (primary agent)
- **CI/CD:** GitLab pipelines (for Lion project)

---

## Statistics

**Total Directories:** 100+ (excluding node_modules, .git, __pycache__)
**Total Root-Level Projects:** 10+
**Agentic Frameworks:** 3 (Roy [empty], BMAD, Archon) + Claude Code native
**Command Definitions:** 50+ (BMAD tasks + agents + future roy commands)

---

## Notes for Roy Framework

This catalog represents the **as-is state** before roy agentic specifications are defined. All folders, tools, and frameworks documented here will operate under roy's orchestration once the framework is implemented.

**Current State:** Roy framework is instantiated with empty constructor - no specific agentic logic defined yet.

**Next Steps:**
1. Consolidate agentic specifications from all sources
2. Create roy command definitions (`/roy-init`, `/roy-agentic-specification`)
3. Register roy framework in `CLAUDE.md`
4. Begin incremental specification via `/roy-agentic-specification` commands

---

**End of Catalog**
