# Atlas Project Quick Start

## 🚀 New Session? Start Here!

### Step 1: Initialize Environment
```
/bmad-init
```

This single command:
- ✅ Clears context window
- 🏗️ Loads Atlas project identity
- 🔌 Connects to Archon MCP (RAG + Tasks)
- 🎭 Loads all BMAD agents
- 🔄 Activates integration rules
- 📊 Configures GitLab access

**Wait for:** "✅ BMAD + Archon Initialization Complete" message

---

## 💬 After Initialization

### Query Project Status
```
What tasks are currently in progress?
What tasks are in the backlog?
Show me review tasks
```

### Search Knowledge Base (RAG)
```
Search knowledge base for JWT authentication
Search code examples for React hooks
What are the best practices for error handling?
```

### Activate BMAD Agent
```
*agent sm                  # Activate Scrum Master by name
7                          # Or activate by number
```

**Available Agents:**
```
1. Orchestrator 🎭  - Workflow coordination
2. Master 🧙        - Universal task executor
3. Analyst 🔍       - Research & requirements
4. PM 📋            - Product strategy & PRDs
5. PO 📊            - Epic & story management
6. Architect 🏗️     - System design
7. SM 🧭            - Sprint planning & story files
8. Dev 💻           - Code implementation
9. QA 🧪            - Testing & quality
10. UX 🎨           - UI/UX design
```

### Create Tasks
```
Create a task to implement JWT authentication with weight 5
Create an epic for user management system
Add a task to refactor the API layer
```

### Continue Development
```
Get my next todo task
What should I work on next?
Show me high priority tasks
```

---

## 🔄 Common Workflows

### Greenfield Development (New Feature)
```
1. /bmad-init
2. *agent analyst
3. *create-project-brief
4. *agent pm
5. *create-prd
6. *agent architect
7. *create-architecture
8. *agent sm
9. *create-story-file
10. *agent dev
11. *implement-story
```

### Brownfield Analysis (Existing Code)
```
1. /bmad-init
2. Search knowledge base for [component name]
3. *agent analyst
4. *advanced-elicitation
5. *agent architect
6. *create-brownfield-architecture
7. Create tasks for identified gaps
```

### Bug Fix Workflow
```
1. /bmad-init
2. Search code examples for [bug area]
3. *agent dev
4. Implement fix
5. *agent qa
6. *execute-tests
```

---

## 🎯 Key Rules (Always Active)

### 1. Archon-First Task Management
- ✅ Query Archon before starting work
- ✅ Update Archon during work
- ✅ Use TodoWrite only for session checklists

### 2. Research-First Implementation
- ✅ Search RAG before coding
- ✅ Use code examples from knowledge base
- ✅ Ground responses with project data

### 3. Task-Driven Development
```
Query → Research → Implement → Update → Next
```

---

## 🛠️ Troubleshooting

### Archon Not Connected?
```bash
cd /mnt/e/repos/atlas/archon
docker compose up --build -d
```

### Need GitLab Data?
```bash
cd /mnt/e/repos/atlas/gitlab-utilities
./clone-atlas-hive.sh --content-types all
```

### Agent Not Responding?
- Make sure you ran `/bmad-init` first
- Try: `*agent orchestrator` for help
- Or: `*help` to see available commands

---

## 📚 Documentation

- **Full Instructions:** `/mnt/e/repos/atlas/CLAUDE.md`
- **Command Guide:** `/mnt/e/repos/atlas/.claude/commands/README.md`
- **Archon Setup:** `/mnt/e/repos/atlas/archon/SETUP-ATLAS.md`
- **BMAD Method:** `/mnt/e/repos/atlas/BMAD-METHOD/bmad-core/data/bmad-kb.md`

---

## 🎓 Tips

### Getting Help
```
*agent orchestrator         # Get workflow guidance
*help                       # Show available commands (when agent active)
*kb                         # Toggle knowledge base mode (when agent active)
```

### Efficient Development
1. Let RAG ground your decisions
2. Let Archon track your tasks
3. Let BMAD agents guide your workflow
4. Trust the integration - it's all connected!

### When Stuck
```
*agent orchestrator
Ask: "What should I do next?"
```

---

**Remember:** Every new session starts with `/bmad-init`

This is your single source of truth for environment setup!
