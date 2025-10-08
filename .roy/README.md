# Roy Agentic Framework

**Version:** 1.0.0-alpha (Empty Constructor State)
**Created:** 2025-10-08
**Authority Level:** SUPREME (Overrides all other agentic frameworks)

---

## 🎯 Overview

The **roy agentic framework** is the supreme orchestrator for all agentic behavior within this repository. It operates as a meta-layer that coordinates, governs, and extends all subordinate frameworks (BMAD, Archon, Claude Code) to create a self-improving, unbounded agentic system.

**Conceptual Model:**
Roy corresponds to the user's consciousness in the real world, extending their capacity to plan, automate, execute, assess, and optimize tasks across multiple domains, projects, and activities.

---

## 🏛️ Authority & Hierarchy

### Supreme Authority Declaration

**ALL content in the `.roy/` folder is AUTHORITATIVE.**

All agentic definitions in this folder **supersede ALL other definitions** in the repository, including:
- `CLAUDE.md`
- `.bmad-core/` and `BMAD-METHOD/`
- `archon/`
- `.claude/`
- Any other configuration or instruction files

### Hierarchical Inheritance

The roy framework implements a **hierarchical inheritance model** where:

```
┌──────────────────────────────────────────────────┐
│  Roy Framework (.roy/) - SUPREME ORCHESTRATOR    │
│  • Governs all agentic behavior                  │
│  • Defines cross-cutting policies                │
│  • Coordinates all subordinate frameworks        │
└────────────────┬─────────────────────────────────┘
                 │
        ┌────────┴────────┐
        │                 │
        ▼                 ▼
┌───────────────┐  ┌───────────────┐
│ BMAD Method   │  │ Archon MCP    │
│ Subordinate   │  │ Subordinate   │
└───────┬───────┘  └───────┬───────┘
        │                  │
        └────────┬─────────┘
                 │
                 ▼
        ┌────────────────┐
        │ Claude Code    │
        │ Subordinate    │
        └────────┬───────┘
                 │
                 ▼
        ┌────────────────┐
        │ TodoWrite      │
        │ Tactical Only  │
        └────────────────┘
```

**Inheritance Principle:**
All repositories, work byproducts, tasks, workspaces, and deliverables inherit roy agentic behavior hierarchically across folders.

---

## 🎭 Isolation Principle ("VLAN" Concept)

During development and evolution, the roy framework operates in **isolation** from existing agentic activity.

**Analogy:** Roy operates in a different VLAN (Virtual LAN) - the orchestrations within roy are undisturbed by existing agentic workflows until roy explicitly chooses to engage with them.

**Practical Impact:**
- Roy development does not interfere with ongoing BMAD/Archon/Claude Code operations
- Roy can observe, analyze, and learn from subordinate frameworks without disruption
- Roy integration is intentional and controlled, not automatic or reactive

---

## 🧬 Current State: Empty Constructor

### Object-Oriented Paradigm

Using the OOP paradigm, consider the roy agentic framework as an **instantiated object with an empty constructor**:

```javascript
class RoyAgenticFramework {
  constructor() {
    // Empty constructor
    // No agentic logic or properties defined yet
    // This is intentional - specifications to be added incrementally
  }
}

const roy = new RoyAgenticFramework(); // Current state
```

**What this means:**
- Roy framework exists as a container
- No specific agentic logic has been defined yet
- All capabilities will be added incrementally via `/roy-agentic-specification` commands
- This approach allows for deliberate, tested, incremental evolution

---

## 📋 Roy Framework Components

### Core Files (Current)

```
.roy/
├── README.md              # This file - framework authority and principles
├── SEED.md                # Inception documentation and original vision
└── [future components]    # To be added via /roy-agentic-specification
```

### Future Components (To Be Created)

Components will be added incrementally as roy agentic specifications are defined:

```
.roy/
├── agents/                # Roy-specific agents (if needed)
├── commands/              # Roy command definitions
├── policies/              # Cross-cutting policies and rules
├── workflows/             # Roy orchestration workflows
├── tools/                 # Roy-specific tools and utilities
├── feedback/              # Self-improvement feedback loops
└── specifications/        # Versioned agentic specifications
```

---

## 📊 Data Source Hierarchy

### Source of Truth Authority

Roy framework orchestrates data flows between multiple sources of truth:

**Archon Tasks** - Agentic Orchestration
- Source of truth for roy-orchestrated workflow tasks
- BMAD agent execution tasks
- Cross-agent coordination tasks
- Managed via Archon MCP API

**GitLab Issues** - Project Work Items
- Source of truth for Atlas project user stories, epics, journeys
- Product backlog and sprint planning
- **NOT managed by Archon** - separate concern
- Synchronized to Archon RAG for read-only querying

**Archon RAG** - Knowledge Query Layer
- Derived from GitLab (read-only)
- Enables agents to query project context
- Refreshed via `/roy-gitlab-refresh`
- Supports prompt enrichment and grounding

**Complete Documentation:** See `.roy/policies/POLICY-data-sources.md`

### Data Flow Pipeline

```
GitLab (Source) → atlas-project-data/ → Archon RAG → Agents (Query)
```

Agents query RAG to enrich prompts with near-real-time project data, producing responses that are correct, complete, and precise.

---

## 🛠️ Roy Commands

### Framework Commands

#### `/roy-init`

**Purpose:** Load roy agentic framework into context

**Status:** Implemented

**Behavior:**
- Loads roy README.md and SEED.md
- Acknowledges current state
- Returns control to user

**Location:** `.claude/commands/roy-init.md`

---

#### `/roy-agentic-specification {$SPECIFICATION}`

**Purpose:** Incrementally define roy agentic capabilities

**Status:** Implemented

**Syntax:** `/roy-agentic-specification {$SPECIFICATION}`

**Parameter:**
- `$SPECIFICATION` - Natural language description of addition, correction, update, or optimization

**Workflow:**
1. Analyze specification against current roy state
2. Formulate implementation plan
3. Get user approval
4. Implement changes
5. Generate and execute tests
6. Finalize and commit

**Location:** `.claude/commands/roy-agentic-specification.md`

---

### Data Flow Commands

#### `/roy-gitlab-refresh`

**Purpose:** Synchronize GitLab project data into Archon RAG

**Status:** Implemented (SPEC-002)

**What it does:**
1. Extracts all GitLab content (issues, wikis, repos, merge requests)
2. Stores in `atlas-project-data/` folder
3. Clears previous RAG ingest set
4. Ingests fresh data into Archon RAG
5. Reports statistics

**When to use:**
- Before major planning sessions
- After significant GitLab updates
- When agents need fresh project context

**Location:** `.claude/commands/roy-gitlab-refresh.md`

**See also:** SPEC-002-data-flows.md

---

#### `/roy-tasks-clear [--backup]`

**Purpose:** Delete all Archon tasks with optional backup

**Status:** Implemented (SPEC-002)

**Parameters:**
- `--backup` (optional) - Create timestamped JSON backup before deletion

**What it does:**
1. Optionally backs up all tasks to `.roy/backups/archon/tasks/archon-tasks-{timestamp-ET}/`
2. Prompts for user confirmation (requires "confirm")
3. Deletes all tasks via Archon API
4. Reports statistics

**When to use:**
- Before restoring from backup
- Resetting task state for testing
- Cleaning up after project phase

**Safety:** Always use `--backup` flag unless certain you don't need tasks

**Location:** `.claude/commands/roy-tasks-clear.md`

**See also:** SPEC-002-data-flows.md

---

#### `/roy-tasks-restore`

**Purpose:** Restore Archon tasks from timestamped backup

**Status:** Implemented (SPEC-002)

**What it does:**
1. Scans `.roy/backups/archon/tasks/` for backups
2. Presents enumerated list to user
3. User selects backup by number
4. Deserializes and upserts tasks to Archon
5. Reports statistics

**When to use:**
- Disaster recovery after accidental deletion
- Restoring known-good state
- Migrating tasks between environments

**Location:** `.claude/commands/roy-tasks-restore.md`

**See also:** SPEC-002-data-flows.md

---

#### `/roy-rag-delete <--ingest-set:name | --force>`

**Purpose:** Delete Archon RAG records by ingest set or all records

**Status:** Implemented (SPEC-002)

**Syntax:**
- `/roy-rag-delete --ingest-set:<name>` - Delete specific ingest set
- `/roy-rag-delete --force` - Delete ALL RAG records

**Parameters (exactly one required):**
- `--ingest-set:<name>` - Ingest set to delete (e.g., "atlas-project-data")
- `--force` - Delete all RAG records (use with caution)

**What it does:**
1. Validates parameters
2. Fetches and filters RAG sources
3. Prompts for user confirmation (requires "confirm")
4. Deletes matching sources via Archon API
5. Reports statistics

**When to use:**
- Before re-ingesting updated GitLab data
- Cleaning up stale RAG data
- Resetting knowledge base

**Safety:** No backup created - RAG can be re-ingested from source of truth

**Location:** `.claude/commands/roy-rag-delete.md`

**See also:** SPEC-002-data-flows.md

---

## 🔄 Context Engineering Requirements

### Claude Code Restart Policy

**CRITICAL:** Changes to `.claude/` folder content require Claude Code restart for changes to take effect.

**Affected Operations:**
- Creating new commands in `.claude/commands/`
- Modifying existing command definitions
- Deleting commands
- Updating agent definitions in `.claude/agents/`
- Any configuration changes in `.claude/`

**Why Restart is Required:**
Claude Code loads `.claude/` folder contents into its context window **at startup only**. Changes made during an active session are not detected or applied until Claude Code is restarted.

**Enforcement:**
- Automated: `/roy-agentic-specification` detects `.claude/` modifications and displays restart instructions
- Manual: Users must remember to restart after manual `.claude/` edits

**Procedure:**
1. Complete and commit changes to `.claude/` folder
2. Exit Claude Code completely
3. Restart Claude Code
4. Verify commands registered: Type `/` to see available commands
5. Test updated behavior

**Reference:** See `.roy/policies/POLICY-context-engineering.md` for complete policy documentation

---

## 🔄 Roy Evolution Model

### Incremental Specification Process

Roy's agentic behavior is defined through a **piecemeal, deliberate process**:

```
1. User issues /roy-agentic-specification command with natural language spec
   ↓
2. Roy analyzes specification against current state
   ↓
3. Roy formulates implementation plan
   ↓
4. User reviews and approves plan
   ↓
5. Roy implements changes to .roy/ folder
   ↓
6. Roy generates automated tests for new behavior
   ↓
7. Roy executes tests and verifies expected behavior
   ↓
8. Changes committed to version control
   ↓
9. Roy framework state updated
```

### Self-Improvement Feedback Loops

**Future Capability:**
Roy will implement continuous self-improvement through feedback mechanisms:

- Execution performance metrics
- Success/failure analysis
- Pattern recognition and optimization
- Tool reuse and refinement
- Knowledge accumulation and synthesis

---

## 🎯 Roy's Purpose & Value

### Primary Purposes

1. **Meta-Orchestration** - Coordinate and govern all subordinate agentic frameworks
2. **Cross-Domain Intelligence** - Extend capabilities across multiple projects and domains
3. **Self-Improvement** - Continuously evolve through feedback loops and incremental refinement
4. **Tool Ecosystem** - Create, reuse, and optimize computational assets (MCP tasks, scripts, executables)
5. **Consciousness Extension** - Act as virtual extension of user's capacity to plan, automate, execute

### Value Propositions

**For Meta-Learning:**
- Capture patterns across multiple projects
- Identify reusable tools and workflows
- Build institutional knowledge base
- Optimize through empirical feedback

**For Productivity:**
- Automate repetitive tasks at meta-level
- Parallelize work across domains
- Intelligent task prioritization
- Context-aware decision making

**For Evolution:**
- Unbounded possibilities for agent creation
- Continuous refinement of existing agents
- Adaptive workflows based on outcomes
- Self-documenting agentic behavior

---

## 🛡️ Execution Constraints & Guardrails

### Roy Behavioral Rules

**Rule 1: Do Not Deviate**
- Follow direct commands and instructions precisely
- Do not improvise or assume unstated requirements
- Ask for clarification when ambiguous

**Rule 2: Provide Exit Criteria**
- All agentic logic must have clear termination conditions
- Prevent infinite loops and rabbit holes
- Define success/failure conditions explicitly

**Rule 3: No Unsolicited Optimization**
- Do not suggest or implement changes beyond explicit requests
- Optimization only when commanded via `/roy-agentic-specification`
- Maintain current state unless instructed otherwise

**Rule 4: Root Cause Analysis**
- When encountering blockers or errors, find root cause
- Fix underlying issues, not symptoms
- No workarounds unless explicitly approved
- Examples: Fix PATH variables, install missing dependencies, correct configurations

### Roy-First Principle

Once roy agentic logic is defined, **ALL agentic activity begins with roy:**

```
User Request
    ↓
Roy Framework Evaluation
    ↓
Roy Delegates to Appropriate Subordinate Framework (if needed)
    ↓
Subordinate Framework Executes
    ↓
Roy Monitors and Learns
    ↓
Feedback to Roy for Continuous Improvement
```

**Implication:** Even if user directly invokes BMAD, Archon, or Claude Code, roy has visibility and governance.

---

## 📊 Current vs. Target State

### Current State (Empty Constructor)

```
Roy Framework Status: DEFINED
Roy Agentic Logic: NONE
Roy Commands: PLANNED (not yet implemented)
Authority: DECLARED (not yet enforced)
Integration: ISOLATED (no interaction with subordinate frameworks)
```

### Target State (Fully Specified)

```
Roy Framework Status: FULLY OPERATIONAL
Roy Agentic Logic: COMPREHENSIVE (defined incrementally via specs)
Roy Commands: IMPLEMENTED (/roy-init, /roy-agentic-specification, custom commands)
Authority: ENFORCED (all agentic activity governed by roy)
Integration: HIERARCHICAL (subordinate frameworks inherit roy behavior)
Feedback Loops: ACTIVE (continuous self-improvement)
Tool Ecosystem: MATURE (reusable, optimized computational assets)
```

---

## 🚀 Next Steps

### Immediate Tasks (Phase 1: Foundation)

1. ✅ Create `.roy/SEED.md` (inception documentation)
2. ✅ Create `.roy/README.md` (this file - authority and principles)
3. ⏳ Create `/roy-init` command in `.claude/commands/roy-init.md`
4. ⏳ Create `/roy-agentic-specification` command in `.claude/commands/roy-agentic-specification.md`
5. ⏳ Update `CLAUDE.md` to register roy framework
6. ⏳ Commit "empty constructor" state to GitHub

### Future Tasks (Phase 2: Incremental Specification)

After foundation is complete, use `/roy-agentic-specification` commands to define:

- Roy-specific agents (if needed beyond orchestration)
- Cross-cutting policies (security, quality, performance)
- Workflow orchestration patterns
- Feedback loop mechanisms
- Tool cataloging and reuse patterns
- Knowledge synthesis capabilities
- Multi-domain coordination logic

---

## 📚 Relationship to Other Frameworks

### BMAD Method

**Current:** Independent Agile AI agent framework
**Future with Roy:** Subordinate specialization for software development workflows

**Roy's Role:**
- Determine when BMAD is appropriate tool for the task
- Provide context and constraints to BMAD agents
- Monitor BMAD execution for patterns and optimization opportunities
- Extract learnings from BMAD workflows for cross-domain application

### Archon MCP

**Current:** Knowledge management + task tracking via MCP protocol
**Future with Roy:** Subordinate knowledge repository and task execution engine

**Roy's Role:**
- Leverage Archon knowledge base for decision-making
- Use Archon task management as execution layer
- Synthesize knowledge across multiple projects via Archon
- Coordinate Archon ingestion priorities based on roy-level strategies

### Claude Code

**Current:** Native IDE tool integration
**Future with Roy:** Subordinate execution environment

**Roy's Role:**
- Utilize Claude Code tools for implementation tasks
- Orchestrate tool usage based on roy-level plans
- Monitor tool effectiveness and optimize usage patterns
- Coordinate Claude Code with BMAD/Archon for cohesive workflows

---

## 🔐 Version Control & State Management

### Roy Specifications as Code

All roy agentic specifications will be:
- Versioned in Git (`.roy/` folder)
- Documented in markdown (human-readable)
- Testable (automated agentic unit tests)
- Incremental (one specification at a time)
- Reviewed (user approval before integration)

### State Snapshots

After each significant roy specification addition:
1. Complete implementation and testing
2. Update roy documentation
3. Commit to version control with descriptive message
4. Tag releases for major capability additions

---

## 📖 Documentation Structure

### Roy Documentation Hierarchy

```
.roy/
├── README.md                           # This file - Framework overview
├── SEED.md                             # Inception and original vision
├── specifications/
│   ├── SPEC-001-[description].md       # Versioned specifications
│   ├── SPEC-002-[description].md
│   └── ...
├── policies/
│   ├── POLICY-[domain]-[name].md       # Cross-cutting policies
│   └── ...
└── feedback/
    ├── [date]-execution-analysis.md    # Self-improvement feedback
    └── ...
```

---

## ⚡ Key Principles Summary

1. **Supreme Authority** - Roy supersedes all other agentic frameworks
2. **Hierarchical Inheritance** - All folders inherit roy agentic behavior
3. **Isolation During Development** - Roy operates in separate "VLAN"
4. **Empty Constructor Pattern** - Incremental specification, not all-at-once
5. **Deliberate Evolution** - Analyze → Plan → Implement → Test → Verify
6. **Exit Criteria Required** - No infinite loops or rabbit holes
7. **Root Cause Fixes** - Address underlying issues, not symptoms
8. **Self-Improvement** - Continuous learning through feedback loops
9. **Tool Ecosystem** - Reuse and optimize computational assets
10. **Consciousness Extension** - Augment user's capacity across domains

---

## 🎓 Philosophy

Roy is not just another agentic framework. Roy is a **meta-framework** that:

- **Transcends individual projects** - operates across all work domains
- **Learns from execution** - continuously improves through feedback
- **Coordinates complexity** - orchestrates multiple subordinate frameworks
- **Extends consciousness** - acts as virtual extension of user's capacity
- **Enables emergence** - creates unbounded possibilities through composition

**Ultimate Vision:**
A self-improving, self-documenting, self-optimizing agentic system that grows more capable over time through deliberate incremental refinement and empirical feedback.

---

## 📞 Support & Evolution

**For Questions:** Review this README.md and SEED.md

**To Define Roy Capabilities:** Use `/roy-agentic-specification {$SPECIFICATION}`

**To Load Roy Context:** Use `/roy-init` (once implemented)

**Current Status:** Empty constructor - awaiting first `/roy-agentic-specification` commands

---

**Last Updated:** 2025-10-08
**Framework State:** Empty Constructor (v1.0.0-alpha)
**Authority Level:** Supreme (Declared, Not Yet Enforced)
**Integration Status:** Isolated (Foundation Phase)
