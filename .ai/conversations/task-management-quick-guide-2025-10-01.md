# Task Management Quick Guide - Atlas Project
**Last Updated:** 2025-10-01

---

## TL;DR - The One Rule

**Use Archon for everything persistent. Use TodoWrite only for current session breakdown.**

---

## Daily Workflow

### 1. Morning: Check Tasks in Archon UI
```
Open: http://localhost:3737
Review: Project "Atlas" tasks
Filter: Status = "todo"
Pick: Next highest priority (task_order)
```

### 2. Start Work: Update Status via MCP
```
archon:manage_task(
    action="update",
    task_id="[paste-id-here]",
    status="doing"
)
```

### 3. During Work: Optional Session Breakdown
```
*Use TodoWrite ONLY if you need to break current task into sub-steps*

Example:
- [ ] Read acceptance criteria
- [ ] Set up test fixtures
- [ ] Implement feature
- [ ] Run tests
- [ ] Update Archon status
```

### 4. Complete Work: Update Archon
```
archon:manage_task(
    action="update",
    task_id="[task-id]",
    status="done"
)
```

---

## Quick MCP Commands

### Query Tasks
```python
# All Atlas tasks
archon:find_tasks(project_id="3f2b6ee9-05ff-48ae-ad6f-54cad080addc")

# Just TODOs
archon:find_tasks(
    project_id="3f2b6ee9-05ff-48ae-ad6f-54cad080addc",
    filter_by="status",
    filter_value="todo"
)

# Search
archon:find_tasks(query="authentication")
```

### Create Task
```python
archon:manage_task(
    action="create",
    project_id="3f2b6ee9-05ff-48ae-ad6f-54cad080addc",
    title="Task title",
    description="Detailed description",
    feature="Epic Name",
    task_order=100
)
```

### Update Status
```python
archon:manage_task(
    action="update",
    task_id="abc-123",
    status="doing"  # todo|doing|review|done
)
```

---

## When to Use What

| Need | Solution | Example |
|------|----------|---------|
| Track epic | ✅ Archon | "Epic 1: Edge Connector Enhancements" |
| Plan sprint | ✅ Archon | Create 10 stories, assign priorities |
| Implement story | ✅ Archon (update status) | Mark as "doing", then "done" |
| Break down current work | ⚠️ TodoWrite | "This function needs: validation, logging, tests" |
| Long-term roadmap | ✅ Archon | All Q4 2025 deliverables |
| Session checklist | ⚠️ TodoWrite | "Steps to debug this issue" |

**Rule of Thumb:**
- Survives this session? → Archon
- Gone when chat closes? → TodoWrite

---

## Atlas Project Info

**Project ID:** `3f2b6ee9-05ff-48ae-ad6f-54cad080addc`

**Existing Tasks (as of 2025-10-01):**
1. Phase 1: Discovery & Documentation
2. Phase 2: Requirements Planning - PRD
3. Phase 2: Architecture Planning
4. Phase 3: Document Sharding
5. Phase 4: Story Creation Loop
6. Phase 5: Implementation Cycles

---

## Archon URLs

- **Web UI:** http://localhost:3737
- **API:** http://localhost:8181
- **MCP:** http://localhost:8051

---

## Troubleshooting

### Archon Not Running?
```bash
cd /mnt/e/repos/atlas/archon
docker compose up --build -d
docker compose logs -f archon-mcp
```

### Can't Find Task ID?
- Open Archon UI: http://localhost:3737
- Click on task to see full ID
- Or query by name: `archon:find_tasks(query="task name")`

### TodoWrite Getting Cluttered?
- You're using it wrong! TodoWrite is for 5-10 items max
- Move long-term items to Archon
- Clear and restart session if needed

---

## BMAD Agent Guidance

When BMad agents ask about task management:

**✅ Correct Response:**
"Let me query Archon for current tasks..."
`archon:find_tasks(project_id="3f2b6ee9-05ff-48ae-ad6f-54cad080addc")`

**❌ Wrong Response:**
"Let me create a TodoWrite list for the project..."
*[Creates session-only list that will be lost]*

---

## Next Steps

Read full analysis: `.ai/conversations/task-management-integration-analysis-2025-10-01.md`

**Week 1 Actions:**
1. Update CLAUDE.md with Archon-first rule ✅
2. Create task query helpers
3. Train BMad agents on Archon workflow

---

**Remember:** Archon is your task database. TodoWrite is your scratch pad.
