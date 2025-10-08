# Atlas Integration Architecture

## 🎯 Three-Framework Integration

```
┌─────────────────────────────────────────────────────────────┐
│                    USER INTERACTION                          │
│                   (Claude Code Chat)                         │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
            ┌──────────────────────┐
            │   /bmad-init         │  ◄─── INITIALIZATION COMMAND
            │   (Slash Command)    │
            └──────────┬───────────┘
                       │
                       ▼
        ┌──────────────────────────────────┐
        │  THREE FRAMEWORKS INTEGRATED:    │
        │                                  │
        │  1. Claude Code Native (Base)    │
        │  2. Archon MCP (Knowledge)       │
        │  3. BMAD Method™ (Agents)        │
        └──────────────┬───────────────────┘
                       │
       ┌───────────────┼───────────────┐
       │               │               │
       ▼               ▼               ▼
┌─────────────┐ ┌─────────────┐ ┌─────────────┐
│   NATIVE    │ │   ARCHON    │ │    BMAD     │
│             │ │             │ │             │
│ • Read      │ │ • RAG       │ │ • 10 Agents │
│ • Write     │ │ • Tasks     │ │ • Workflows │
│ • Edit      │ │ • Projects  │ │ • Templates │
│ • Bash      │ │ • Knowledge │ │ • Personas  │
│ • Grep/Glob │ │ • GitLab    │ │ • Commands  │
│ • TodoWrite │ │ • MCP Tools │ │ • Checklists│
└──────┬──────┘ └──────┬──────┘ └──────┬──────┘
       │               │               │
       └───────────────┼───────────────┘
                       │
                       ▼
            ┌──────────────────────┐
            │  UNIFIED RESPONSE    │
            │  (RAG-Grounded)      │
            └──────────────────────┘
```

---

## 🔄 Integration Flow

### Request Processing Pipeline

```
1. USER REQUEST
   ↓
2. ARCHON CHECK
   • Query current tasks
   • Get project context
   ↓
3. RAG RESEARCH
   • Search knowledge base
   • Find code examples
   ↓
4. BMAD AGENT (if activated)
   • Apply specialized persona
   • Execute agent workflow
   • Use agent templates/tasks
   ↓
5. CLAUDE CODE EXECUTION
   • Use native tools (Read/Write/Edit/Bash)
   • Implement with RAG findings
   • Follow BMAD workflows
   ↓
6. ARCHON UPDATE
   • Update task status
   • Log completion
   • Track progress
   ↓
7. USER RESPONSE
   • Show results
   • Cite sources
   • Suggest next steps
```

---

## 📊 Task Management Hierarchy

```
┌─────────────────────────────────────────────────────────┐
│                  ARCHON MCP (PRIMARY)                    │
│  • Persistent storage                                    │
│  • Cross-session tracking                                │
│  • Project/task database                                 │
│  • Status: todo → doing → review → done                  │
└────────────────────┬────────────────────────────────────┘
                     │
                     ├── Generate ──→ ┌────────────────────────────┐
                     │                 │  BMAD STORY FILES          │
                     │                 │  (SECONDARY)               │
                     │                 │  • docs/stories/           │
                     │                 │  • Generated from Archon   │
                     │                 │  • Dev/QA execution        │
                     │                 └────────────────────────────┘
                     │
                     └── Track ──→    ┌────────────────────────────┐
                                      │  TODOWRITE                 │
                                      │  (TERTIARY)                │
                                      │  • Session-only checklists │
                                      │  • Tactical breakdown      │
                                      │  • Discarded after session │
                                      └────────────────────────────┘
```

### Decision Tree

```
New work item identified
    │
    ├── Survives session? ──YES──→ ARCHON (always safe)
    │
    ├── Multiple agents? ──YES──→ ARCHON (visibility)
    │
    ├── Reporting needed? ──YES──→ ARCHON (analytics)
    │
    └── Session-only? ──MAYBE──→ TodoWrite (rare)
```

---

## 🎭 BMAD Agent Architecture

### Agent Ecosystem

```
┌──────────────────────────────────────────────────────────┐
│              BMad Orchestrator (🎭)                       │
│  Master coordinator - switches between all agents        │
└────────────┬─────────────────────────────────────────────┘
             │
    ┌────────┼────────┐
    │        │        │
    ▼        ▼        ▼
┌────────┐ ┌────────┐ ┌────────┐
│Planning│ │  Dev   │ │Support │
│ Agents │ │ Agents │ │ Agents │
└───┬────┘ └───┬────┘ └───┬────┘
    │          │          │
    ├─ 🔍 Analyst         ├─ 🧙 Master
    ├─ 📋 PM              └─ 🎨 UX Expert
    ├─ 📊 PO
    ├─ 🏗️ Architect
    │          │
    ├─ 🧭 SM   ├─ 💻 Dev
    │          └─ 🧪 QA
    │
    └─ All agents have:
       • Persona definition
       • Command set (*-prefixed)
       • Dependencies (tasks/templates/checklists)
       • Integration with Archon RAG
```

### Agent Activation Flow

```
User: "7" or "*agent sm"
    │
    ▼
┌────────────────────────────────────┐
│ 1. Load agent file                 │
│    /BMAD-METHOD/bmad-core/         │
│    agents/sm.md                    │
└──────────┬─────────────────────────┘
           │
           ▼
┌────────────────────────────────────┐
│ 2. Adopt persona                   │
│    • Name: Grace                   │
│    • Role: Scrum Master            │
│    • Style: Organized, detail      │
└──────────┬─────────────────────────┘
           │
           ▼
┌────────────────────────────────────┐
│ 3. Load core-config.yaml           │
│    (Project-specific settings)     │
└──────────┬─────────────────────────┘
           │
           ▼
┌────────────────────────────────────┐
│ 4. Present *help menu              │
│    Show available commands         │
└──────────┬─────────────────────────┘
           │
           ▼
┌────────────────────────────────────┐
│ 5. Await user command              │
│    Execute with RAG grounding      │
└────────────────────────────────────┘
```

---

## 🔍 RAG-Grounded Response Pattern

### Before ANY Technical Response

```
┌────────────────────────────────────┐
│    USER ASKS TECHNICAL QUESTION    │
└──────────────┬─────────────────────┘
               │
               ▼
┌────────────────────────────────────┐
│  MANDATORY: Search Knowledge Base  │
│  archon:rag_search_knowledge_base( │
│    query="...",                    │
│    match_count=5                   │
│  )                                 │
└──────────────┬─────────────────────┘
               │
               ▼
┌────────────────────────────────────┐
│  MANDATORY: Search Code Examples   │
│  archon:rag_search_code_examples(  │
│    query="...",                    │
│    match_count=3                   │
│  )                                 │
└──────────────┬─────────────────────┘
               │
               ▼
┌────────────────────────────────────┐
│  SYNTHESIZE RESPONSE               │
│  • Use RAG findings                │
│  • Cite sources                    │
│  • Apply to user's context         │
│  • Provide code examples           │
└────────────────────────────────────┘
```

### Example Flow

```
User: "How should I implement JWT authentication?"
    │
    ▼
Claude: [SEARCHES]
    • archon:rag_search_knowledge_base("JWT authentication best practices")
    • archon:rag_search_code_examples("JWT middleware implementation")
    │
    ▼
Claude: [FINDS]
    • docs.anthropic.com: Security recommendations
    • Atlas wikis: Existing auth patterns
    • Code examples: Express JWT middleware
    │
    ▼
Claude: [RESPONDS]
    "Based on project documentation and security best practices:

    1. Use industry-standard approach [source: docs.anthropic.com]
    2. Follow existing patterns in edge-connector [source: GitLab wiki]
    3. Here's implementation example [source: code_examples]

    [Provides grounded code implementation]"
```

---

## 🔗 GitLab Integration

```
┌─────────────────────────────────────────────────────────┐
│        GitLab (atlas-datascience/lion)                   │
│  • Issues • Wikis • Repos • Merge Requests              │
└──────────────────┬──────────────────────────────────────┘
                   │
        ┌──────────┼──────────┐
        │          │          │
        ▼          ▼          ▼
    ┌────────┐ ┌────────┐ ┌────────┐
    │ Clone  │ │ Export │ │ Ingest │
    │  Hive  │ │ Issues │ │  RAG   │
    └───┬────┘ └───┬────┘ └───┬────┘
        │          │          │
        ▼          ▼          ▼
    ┌─────────────────────────────┐
    │  /atlas-project-data/       │
    │  • repos/                   │
    │  • wikis/                   │
    │  • issues/ (JSON)           │
    │  • metadata/                │
    └──────────┬──────────────────┘
               │
               ▼
        ┌──────────────┐
        │ Archon RAG   │
        │ • Searchable │
        │ • Vectorized │
        │ • Queryable  │
        └──────────────┘
```

---

## 📁 File Organization

```
atlas/
├── .claude/
│   ├── commands/
│   │   ├── bmad-init.md          ◄── INITIALIZATION COMMAND
│   │   └── README.md              ◄── Command documentation
│   ├── QUICK-START.md             ◄── Quick reference
│   ├── INTEGRATION-SUMMARY.md     ◄── This file
│   └── preferences.md             ◄── User preferences
│
├── BMAD-METHOD/
│   └── bmad-core/
│       ├── agents/                ◄── 10 agent persona files
│       ├── workflows/             ◄── Prescribed sequences
│       ├── templates/             ◄── Document templates
│       ├── tasks/                 ◄── Reusable workflows
│       └── checklists/            ◄── Quality checklists
│
├── archon/
│   ├── docker-compose.yml         ◄── Services definition
│   ├── server/ (port 8181)        ◄── Main API
│   ├── mcp-server/ (port 8051)    ◄── MCP tools
│   └── frontend/ (port 3737)      ◄── Web UI
│
├── atlas-project-data/
│   └── repos/                     ◄── Cloned GitLab data
│
├── issues/
│   ├── list-issues-csv-with-text-enhanced.sh  ◄── Issue export
│   └── *.csv                      ◄── Exported issues
│
├── CLAUDE.md                      ◄── Primary instructions
└── .env.atlas                     ◄── Secrets (gitignored)
```

---

## 🎯 Key Commands Reference

### Initialization
```
/bmad-init                         # Start every session with this
```

### Agent Activation
```
*agent orchestrator                # Workflow coordinator
*agent sm                          # Scrum Master
*agent dev                         # Developer
7                                  # Activate agent by number
```

### Agent Commands (when agent active)
```
*help                              # Show agent commands
*task [name]                       # Execute task
*create-doc [template]             # Create document
*kb                                # Toggle knowledge base mode
*exit                              # Exit agent
```

### Natural Language (always available)
```
What tasks are in progress?        # Query Archon
Search RAG for JWT auth            # RAG search
Get my next todo task              # Task management
Create a task to implement X       # Task creation
```

---

## 🚀 Deployment Checklist

### Prerequisites
- [ ] Docker Desktop running
- [ ] Archon services started (`cd archon && docker compose up -d`)
- [ ] GitLab data cloned (optional but recommended)
- [ ] Environment variables in `.env.atlas`

### Every New Session
- [ ] Run `/bmad-init`
- [ ] Wait for "✅ Initialization Complete"
- [ ] Verify Archon connection
- [ ] Begin work with RAG grounding

### During Development
- [ ] Query Archon for current tasks
- [ ] Search RAG before implementing
- [ ] Update Archon task status
- [ ] Use BMAD agents for specialized work
- [ ] Follow task-driven development cycle

---

## 📖 Learning Resources

**Quick Start:**
- `.claude/QUICK-START.md` - Get started fast

**Detailed Documentation:**
- `CLAUDE.md` - Primary instructions (comprehensive)
- `.claude/commands/README.md` - Command system details
- `archon/SETUP-ATLAS.md` - Archon MCP setup
- `BMAD-METHOD/bmad-core/data/bmad-kb.md` - BMAD Method guide

**Issue Export:**
- `issues/CLAUDE.md` - GitLab issue export tools

**Project Data:**
- `atlas-project-data/DATA-STRUCTURE.md` - Data organization

---

**Version:** 1.0
**Last Updated:** 2025-10-06
**Purpose:** Visual reference for Atlas three-framework integration
