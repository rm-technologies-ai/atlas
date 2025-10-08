# SPEC-005: Task Workspace Management (Foundation)

**Specification ID:** SPEC-005
**Title:** Task Workspace Management - Part 1 (Foundation)
**Status:** Partial Implementation
**Created:** 2025-10-08
**Roy Framework Version:** 1.0.0-alpha

---

## 📋 Overview

This specification establishes the foundational infrastructure for task workspace management in the roy framework. Task workspaces are dedicated directories at the atlas repository root that persist work products, agent interactions, and workflow state for each task.

**Note:** This is Part 1 (Foundation). Part 2 will complete integration and commands.

---

## 🎯 Purpose

Enable persistent workspace directories for tasks to:
1. Store work products and artifacts
2. Maintain workflow state across sessions
3. Log agent interactions and work units
4. Support task resumption and checkpointing
5. Track progress for Archon task updates

---

## ✅ Completed Components

### 1. Extended Properties Schema

**File:** `.roy/schemas/extended-task-properties.json`

**Added fields to `roy` namespace:**
- `directory_name` (string) - Unique workspace directory name
- `workspace_path` (string) - Absolute path to workspace
- `unit_of_work_log` (array) - Log of completed work units

### 2. Workspace Metadata Schema

**File:** `.roy/schemas/task-workspace-metadata.json`

**Defines structure for `.roy-metadata.json` in each workspace:**
- Task identification (task_id, title, description)
- Workflow state tracking (current_stage, progress, assigned_agents)
- Unit of work log (completed work with timestamps)
- Artifact catalog (documents, code, data)
- Checkpoint history for session resumption

### 3. Task Queue Schema

**File:** `.roy/schemas/task-queue-entry.json`

**Defines structure for `.roy/queue/{task_id}.json`:**
- Queue status (queued, assigned, in_progress, paused, completed, failed)
- Priority (1-10)
- Dependencies and blockers
- Agent assignments
- Error tracking and retry management

### 4. Workspace Manager Tool

**File:** `.roy/tools/workspace_manager.py`

**Capabilities:**
- `create` - Create workspace with unique directory name
- `get` - Retrieve workspace metadata by task_id
- `list` - List all task workspaces
- `update-metadata` - Update workspace metadata

**Directory Structure Created:**
```
{directory-name}/
├── .roy-metadata.json
├── README.md
├── artifacts/
│   ├── documents/
│   ├── code/
│   └── data/
└── checkpoints/
```

**Directory Naming Convention:**
- Format: `{category}-{slug}`
- Examples: `atlas-gap-analysis`, `tooling-task-decomposition`
- Ensures uniqueness with counter suffix if needed

---

## ⏳ Remaining Work (SPEC-005-Part2)

### Components Not Yet Implemented

1. **Task Queue Manager Tool** (`.roy/tools/task_queue.py`)
   - Queue subscription/dequeue operations
   - Priority and dependency management
   - Status tracking

2. **POLICY-task-workspaces** (`.roy/policies/POLICY-task-workspaces.md`)
   - Workspace lifecycle
   - Naming conventions
   - Cleanup policies (deferred)

3. **/roy-task-create Integration**
   - Add workspace creation step
   - Generate directory name
   - Subscribe to roy queue
   - Update extended properties with workspace info

4. **/roy-queue-status Command** (`.claude/commands/roy-queue-status.md`)
   - View task queue
   - Filter by status, priority
   - Show dependencies and blockers

5. **Complete Documentation**
   - Usage examples
   - Integration guide
   - Workflow diagrams

6. **Test Scenarios**
   - Workspace creation tests
   - Directory uniqueness tests
   - Metadata persistence tests
   - Queue operations tests

---

## 🔧 Usage (When Complete)

### Create Task with Workspace

```bash
/roy-task-create Implement user authentication with JWT tokens
```

**Expected behavior:**
1. TDD inference performed
2. Archon task created
3. Workspace directory created: `atlas-user-authentication/`
4. Metadata file created: `atlas-user-authentication/.roy-metadata.json`
5. Task subscribed to roy queue
6. Extended properties updated with workspace info

### View Queue Status

```bash
/roy-queue-status
```

**Shows:**
- All queued tasks
- Current status (queued, assigned, in_progress)
- Priority and dependencies
- Assigned agents

---

## 📊 Integration Points

### With SPEC-004 (Task Creation)

Task creation workflow extended:
1. Create Archon task (existing)
2. **NEW:** Create workspace directory
3. **NEW:** Initialize metadata file
4. **NEW:** Subscribe to roy queue
5. Write extended properties (modified)
6. Validate creation

### With Future SPEC-006 (Agent Orchestration)

Agents will use workspaces:
- Read metadata for task context
- Write artifacts to `artifacts/` directories
- Log interactions for feedback loops
- Update workflow state

---

## 🚀 Next Steps

**To Complete SPEC-005:**

1. Create task queue manager tool
2. Update `/roy-task-create` command
3. Create `/roy-queue-status` command
4. Write POLICY-task-workspaces
5. Generate comprehensive tests
6. Update roy README
7. Test integration with SPEC-004

**Estimated Effort:** 1-2 hours of implementation

---

## 📝 Technical Notes

### Directory Name Generation

Algorithm ensures uniqueness:
1. Extract category from first 1-2 words
2. Create slug from remaining words (max 4)
3. Check for collisions with existing directories
4. Add numeric suffix if collision detected

### Workspace Persistence

All workspace data persists across sessions:
- Metadata in `.roy-metadata.json`
- Artifacts in organized subdirectories
- Checkpoints for resumption capability

### Schema Validation

All metadata files conform to JSON schemas in `.roy/schemas/`

---

## 🔗 Related Specifications

- **SPEC-004**: Task creation with TDD inference
- **SPEC-006** (future): Agent orchestration system
- **SPEC-007** (future): Feedback loops and quality assessment

---

**Specification Status:** ✅ Foundation Complete (Part 1)
**Implementation Status:** 🔶 Partial (4/12 components)
**Next Phase:** SPEC-005-Part2 (Integration and Commands)
