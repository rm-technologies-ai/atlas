# SPEC-004: Intelligent Task Creation with TDD Inference

**Specification ID:** SPEC-004
**Title:** Intelligent Task Creation with TDD Inference
**Status:** Active
**Created:** 2025-10-08
**Last Updated:** 2025-10-08
**Roy Framework Version:** 1.0.0-alpha

---

## 📋 Overview

This specification defines the `/roy-task-create` command, which creates Archon tasks with intelligent TDD-based inference from free-form descriptions. The command uses Test-Driven Design principles to automatically derive behavior, acceptance criteria, and expected results from a simple textual description.

---

## 🎯 Purpose

### Problem Statement

Creating well-defined tasks with clear acceptance criteria is time-consuming and often inconsistent. Developers and project managers must:
1. Write task descriptions
2. Define acceptance criteria separately
3. Specify expected results
4. Determine test strategy
5. Ensure consistency across tasks

This manual process is error-prone and leads to:
- Vague task definitions
- Missing acceptance criteria
- Inconsistent task quality
- Lack of testability

### Solution

The `/roy-task-create` command automates TDD analysis using LLM inference to:
1. **Analyze** free-form task descriptions
2. **Infer** behavior, acceptance criteria, and expected results
3. **Create** well-defined tasks in zero-shot manner
4. **Validate** task creation automatically
5. **Store** extended properties for roy and GitLab interoperability

---

## 🏗️ Architecture

### Component Overview

```
User
  ↓
  /roy-task-create <description>
  ↓
Claude Code Command (.claude/commands/roy-task-create.md)
  ↓
  ┌─────────────────────────────────────────────┐
  │ TDD Inference (LLM Analysis)                │
  │ • Analyze description                       │
  │ • Generate behavior statement               │
  │ • Infer acceptance criteria (3-5 items)     │
  │ • Derive expected results (2-4 items)       │
  │ • Determine test strategy                   │
  └─────────────────────────────────────────────┘
  ↓
  ┌─────────────────────────────────────────────┐
  │ Archon Task Creation                        │
  │ • archon:manage_task(action="create")       │
  │ • Standard fields: title, description, etc  │
  │ • Returns task_id                           │
  └─────────────────────────────────────────────┘
  ↓
  ┌─────────────────────────────────────────────┐
  │ Extended Properties Storage                 │
  │ • Create .roy/tasks/extended/{task_id}.json │
  │ • Store roy custom properties               │
  │ • Store GitLab mapping properties           │
  │ • Store TDD metadata                        │
  └─────────────────────────────────────────────┘
  ↓
  ┌─────────────────────────────────────────────┐
  │ Validation                                  │
  │ • Query Archon: archon:find_tasks()         │
  │ • Verify extended properties file exists    │
  │ • Validate data integrity                   │
  └─────────────────────────────────────────────┘
  ↓
User Report
```

### Data Storage Model

**Archon Task (PostgreSQL via Supabase):**
```sql
archon_tasks
├── id (UUID)
├── project_id (UUID)
├── title (TEXT)
├── description (TEXT)
├── status (ENUM: todo|doing|review|done)
├── assignee (TEXT)
├── task_order (INTEGER)
├── feature (TEXT)
├── sources (JSONB)
├── code_examples (JSONB)
├── created_at (TIMESTAMPTZ)
└── updated_at (TIMESTAMPTZ)
```

**Extended Properties (JSON File):**
```
.roy/tasks/extended/{task_id}.json
├── roy
│   ├── state (Draft|Active|Blocked|Deferred)
│   ├── behavior (string)
│   ├── acceptance_criteria (array)
│   ├── expected_results (array)
│   ├── inferred_from (string)
│   ├── created_by_command (string)
│   ├── created_at (string)
│   ├── test_strategy (string)
│   └── tags (array)
├── tdd
│   └── inference_quality (high|medium|low)
└── gitlab
    ├── labels (array)
    ├── milestone (string)
    ├── weight (integer)
    ├── time_estimate (integer)
    ├── due_date (string)
    ├── epic_iid (string)
    └── health_status (enum)
```

---

## 🔧 Implementation Details

### Command Syntax

```
/roy-task-create <description>
```

**Parameters:**
- `<description>` - Free-form textual description of task (required)

**Examples:**
```
/roy-task-create Implement user authentication with JWT tokens

/roy-task-create Fix memory leak in data processing pipeline

/roy-task-create Research vector database options for RAG implementation
```

### TDD Inference Algorithm

**Input:** Free-form task description

**Output:** Structured TDD components

**Process:**

1. **Analyze Description**
   - Identify task type (implement, fix, refactor, research, etc.)
   - Extract key requirements and constraints
   - Determine scope and complexity

2. **Generate Behavior Statement**
   - Action-oriented (starts with verb)
   - Specific and measurable
   - Captures core purpose
   - Format: "Verb + noun + with/by/to + details"
   - Example: "Implement user authentication using JWT tokens with email/password login"

3. **Infer Acceptance Criteria** (3-5 items)
   - Each criterion is testable
   - Written in Given-When-Then format where applicable
   - Specific, measurable, achievable
   - Independently verifiable
   - Covers functional requirements, edge cases, validation

4. **Derive Expected Results** (2-4 items)
   - Observable outcomes when task complete
   - Concrete artifacts, states, or behaviors
   - Objectively verifiable
   - Examples: "Tests passing", "Documentation updated", "No errors in logs"

5. **Determine Test Strategy**
   - Brief description of validation approach
   - May reference tools, commands, validation steps
   - Format: "Action + verification + expected outcome"

6. **Assess Inference Quality**
   - `high`: Description clear and detailed, inference confident
   - `medium`: Description adequate, reasonable inference
   - `low`: Description vague, inference uncertain

### Task State Lifecycle

**Draft (Initial State)**
- Task created via `/roy-task-create`
- TDD components need review
- Not yet prioritized for work
- Extended property: `roy.state = "Draft"`
- Archon status: `todo`

**Active (Ready for Work)**
- TDD components reviewed and approved
- Task prioritized and ready to execute
- Extended property: `roy.state = "Active"`
- Archon status: `todo` or `doing`

**Blocked (Dependency or Issue)**
- Cannot proceed due to external factor
- Extended property: `roy.state = "Blocked"`
- Archon status: remains unchanged

**Deferred (Not Now)**
- Lower priority, postponed
- Extended property: `roy.state = "Deferred"`
- Archon status: remains `todo`

**Completed**
- Task finished, acceptance criteria met
- Extended property: `roy.state` not used (Archon status is sufficient)
- Archon status: `done`

### Extended Properties Schema

See: `.roy/schemas/extended-task-properties.json`

**Required Fields:**
- `roy.state`
- `roy.behavior`
- `roy.inferred_from`
- `roy.created_by_command`
- `roy.created_at`

**Optional Fields:**
- `roy.acceptance_criteria`
- `roy.expected_results`
- `roy.test_strategy`
- `roy.tags`
- `roy.dependencies`
- `tdd.test_cases`
- `tdd.inference_quality`
- `gitlab.*` (all GitLab mapping properties)

### Integration with Archon MCP

**Task Creation:**
```python
archon:manage_task(
    action="create",
    project_id="3f2b6ee9-05ff-48ae-ad6f-54cad080addc",
    title="<generated title>",
    description="<original description>",
    status="todo",
    assignee="User"
)
```

**Task Query:**
```python
archon:find_tasks(task_id="<task_id>")
```

**Returns:**
```json
{
  "id": "uuid",
  "project_id": "uuid",
  "title": "Task title",
  "description": "Original description",
  "status": "todo",
  "assignee": "User",
  "created_at": "timestamp",
  "updated_at": "timestamp"
}
```

---

## 📊 Integration with Roy Framework

### Data Source Hierarchy

Per POLICY-data-sources, tasks created via `/roy-task-create` are **Archon tasks** (source of truth for roy-orchestrated agentic workflow tasks).

**What these tasks ARE:**
- Roy-orchestrated workflow tasks
- BMAD agent execution tasks
- Cross-session persistent tasks
- Agentic coordination tasks

**What these tasks ARE NOT:**
- Atlas project user stories (those belong in GitLab)
- GitLab issues or epics
- Product backlog items

### GitLab Interoperability (Future)

Extended properties include `gitlab` namespace for future sync with GitLab issues:

**Phase 2 Enhancement: Bidirectional Sync**
1. Create Archon task via `/roy-task-create`
2. Optionally sync to GitLab: `--sync-gitlab`
3. GitLab issue created with mapped properties
4. Changes in either system sync to the other

**GitLab Property Mapping:**
- `gitlab.labels` → GitLab labels
- `gitlab.milestone` → GitLab milestone
- `gitlab.weight` → Story points
- `gitlab.time_estimate` → Time estimate
- `gitlab.due_date` → Due date
- `gitlab.epic_iid` → Parent epic
- `gitlab.health_status` → Health indicator

---

## 🧪 Validation and Testing

### Validation Workflow

After task creation, command validates:

1. **Archon Task Exists**
   - Query via `archon:find_tasks(task_id="...")`
   - Verify returned data matches expected values
   - Check all standard fields populated

2. **Extended Properties File Exists**
   - Check `.roy/tasks/extended/{task_id}.json` exists
   - File is readable and valid JSON
   - Contains required fields

3. **Data Integrity**
   - Extended properties conform to schema
   - task_id matches between Archon and extended properties
   - Timestamps are valid
   - No missing required fields

4. **Report Results**
   - Success: Display task details and next steps
   - Partial failure: Report which validation failed
   - Complete failure: Report error and cleanup

### Test Scenarios

See: `SPEC-004-task-creation-TESTS.md` for complete test suite

**Minimum Test Coverage:**
1. Simple feature implementation description
2. Bug fix description
3. Research task description
4. Vague/ambiguous description
5. Invalid project ID
6. Archon API unavailable
7. File system write failure

---

## 🔄 Workflow Examples

### Example 1: Feature Implementation

**User Input:**
```
/roy-task-create Implement pagination for user list with page size of 25
```

**TDD Inference:**
```
Behavior:
Implement pagination for user list endpoint with configurable page size defaulting to 25 items

Acceptance Criteria:
1. API endpoint accepts page and page_size query parameters
2. Returns paginated user list with 25 items per page by default
3. Response includes total count and pagination metadata
4. Edge cases handled: page out of range, invalid page_size
5. Performance remains acceptable for large user datasets

Expected Results:
• Paginated user list endpoint functional
• Tests passing for pagination logic
• API documentation updated with pagination parameters
• Performance benchmarks meet SLA

Test Strategy:
Create test dataset with 100 users, verify page=1 returns first 25, page=2 returns next 25, verify total count, test edge cases
```

**Archon Task Created:**
- Title: "Implement pagination for user list with page size of 25"
- Description: "Implement pagination for user list with page size of 25"
- Status: `todo`
- Assignee: `User`

**Extended Properties:**
```json
{
  "roy": {
    "state": "Draft",
    "behavior": "Implement pagination for user list endpoint...",
    "acceptance_criteria": [...],
    "expected_results": [...],
    "inferred_from": "Implement pagination for user list...",
    "created_by_command": "/roy-task-create",
    "created_at": "2025-10-08 14:23:45 ET",
    "test_strategy": "Create test dataset with 100 users...",
    "tags": []
  },
  "tdd": {
    "inference_quality": "high"
  },
  "gitlab": {
    "labels": ["feature", "api"],
    "weight": 3
  }
}
```

---

## 🚀 Usage Guidelines

### When to Use /roy-task-create

**Appropriate Use Cases:**
- Creating new feature implementation tasks
- Defining bug fixes with acceptance criteria
- Planning research tasks
- Breaking down epics into implementable tasks
- Quick task creation during planning sessions

**Inappropriate Use Cases:**
- GitLab issues (use GitLab UI or API)
- Temporary session-scoped todos (use TodoWrite)
- Non-development tasks (meetings, admin work)
- Tasks without clear completion criteria

### Best Practices

**Writing Good Task Descriptions:**
1. **Be specific**: Include key requirements and constraints
2. **Provide context**: Mention related systems or components
3. **State intent**: What problem are you solving?
4. **Include success criteria**: How will you know it's done?
5. **Keep it concise**: 1-3 sentences ideal

**Good Examples:**
```
✅ Implement user authentication with JWT tokens supporting email/password login
✅ Fix memory leak in data processing pipeline causing OOM after 1000 records
✅ Research vector database options and recommend best fit for RAG use case
```

**Poor Examples:**
```
❌ Add auth
❌ Fix bug
❌ Do research
```

### Reviewing and Refining TDD Analysis

After task creation:

1. **Review inferred components** in command output
2. **Edit extended properties JSON** if adjustments needed
3. **Add domain-specific criteria** that LLM may have missed
4. **Refine test strategy** based on project specifics
5. **Promote to Active** when ready: Update `roy.state` to "Active"

---

## 📈 Future Enhancements

### Phase 2: GitLab Synchronization

**Capability:** Bidirectional sync between Archon tasks and GitLab issues

**Command Extensions:**
```
/roy-task-create <description> --sync-gitlab
/roy-task-create <description> --gitlab-project lion --gitlab-milestone "Sprint 5"
```

**Workflow:**
1. Create Archon task with TDD inference
2. Map extended properties to GitLab issue fields
3. Create GitLab issue via API
4. Link task and issue in extended properties
5. Sync updates bidirectionally

### Phase 3: Template Library

**Capability:** Pre-defined templates for common task types

**Command Extensions:**
```
/roy-task-create --template feature <description>
/roy-task-create --template bugfix <description>
/roy-task-create --template research <description>
```

**Templates Provide:**
- Structured acceptance criteria patterns
- Domain-specific test strategies
- Common expected results
- Best practice guidance

### Phase 4: Intelligent Refinement

**Capability:** Iterative improvement of TDD components

**Features:**
- Feedback loop from completed tasks
- Quality metrics for acceptance criteria
- Learning from historical tasks
- Suggested improvements for vague descriptions
- Pattern recognition for similar tasks

### Phase 5: Automated Test Generation

**Capability:** Generate executable tests from acceptance criteria

**Workflow:**
1. Create task with `/roy-task-create`
2. Extract acceptance criteria
3. Generate test stubs in appropriate framework
4. Create test files in project
5. Link tests to task for validation

---

## 🛡️ Error Handling

### Error Scenarios

**Archon API Unavailable:**
- Detect connection failure
- Report diagnostic information
- Suggest checking Archon service: `docker compose ps`
- Do not create extended properties

**Task Creation Fails:**
- Capture error response from Archon
- Report specific failure reason
- Suggest corrective action
- Exit gracefully

**File Write Failure:**
- Attempt to create extended properties file
- If fails, delete Archon task (cleanup)
- Report file permission or disk space issue
- Suggest manual intervention

**Validation Failure:**
- Report which validation check failed
- Provide task_id if task was created
- Offer manual verification steps
- Mark as partial success (task may be usable)

**Vague Description:**
- Generate TDD components with `low` quality rating
- Include note in extended properties about assumptions
- Suggest user review and refine
- Proceed with task creation

---

## 📚 References

### Related Specifications
- **SPEC-002**: Data source hierarchy and data flows
- **POLICY-data-sources**: Source of truth authority

### Related Commands
- `/roy-init`: Load roy framework context
- `/roy-gitlab-refresh`: Sync GitLab data to Archon RAG
- `/roy-tasks-clear`: Clear Archon tasks with backup
- `/roy-tasks-restore`: Restore tasks from backup

### File Locations
- Command definition: `.claude/commands/roy-task-create.md`
- Extended properties schema: `.roy/schemas/extended-task-properties.json`
- Task creator tool: `.roy/tools/task_creator.py`
- Extended properties storage: `.roy/tasks/extended/{task_id}.json`
- Test specification: `.roy/specifications/SPEC-004-task-creation-TESTS.md`

---

**Specification Status:** ✅ Active
**Implementation Status:** ✅ Complete
**Test Status:** ⏳ Pending execution
