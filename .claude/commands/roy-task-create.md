# Command: /roy-task-create

**Purpose:** Create an Archon task with intelligent TDD-based inference from a free-form description

**Status:** Active (SPEC-004)

**Syntax:** `/roy-task-create <description>`

**Parameters:**
- `<description>` - Free-form textual description of the task to create

---

## Command Behavior

When invoked, this command:

1. **Analyzes the task description** using Test-Driven Design (TDD) principles
2. **Infers task components** from the description:
   - **Behavior**: What the task should accomplish
   - **Acceptance Criteria**: Testable conditions for completion (3-5 criteria)
   - **Expected Results**: Observable outcomes when task is done
   - **Test Strategy**: How to verify completion
3. **Creates Archon task** via MCP with standard fields
4. **Writes extended properties** to `.roy/tasks/extended/{task_id}.json`
5. **Sets task state** to "Draft" (stored in extended properties)
6. **Validates creation** by querying Archon and verifying files
7. **Reports results** to user with task ID and next steps

---

## Workflow

### Step 1: Analyze Description with TDD Inference

Use LLM reasoning to analyze the user's description and generate:

**Behavior Statement:**
- Clear, concise description of what task accomplishes
- Action-oriented (starts with verb)
- Specific and measurable

**Acceptance Criteria (3-5 items):**
- Testable conditions that must be met
- Written in Given-When-Then format where applicable
- Specific, measurable, achievable
- Each criterion independently verifiable

**Expected Results (2-4 items):**
- Observable outcomes when task complete
- Concrete artifacts, states, or behaviors
- Can be verified objectively

**Test Strategy:**
- Brief description of how to verify completion
- May reference tools, commands, or validation steps

**Inference Quality Assessment:**
- `high`: Description was clear and detailed, inference confident
- `medium`: Description adequate, reasonable inference made
- `low`: Description vague, inference uncertain

### Step 2: Determine Task Title

Generate concise task title (50 chars max) from description:
- Starts with action verb
- Captures core task purpose
- Example: "Implement user authentication with JWT tokens"

### Step 3: Create Archon Task

Use `archon:manage_task` to create task with:
- `project_id`: Default to Atlas project ID `3f2b6ee9-05ff-48ae-ad6f-54cad080addc`
- `title`: Generated title from Step 2
- `description`: Original user description
- `status`: `"todo"` (standard Archon status)
- `assignee`: `"User"` (default assignee)

Capture the returned `task_id`.

### Step 4: Write Extended Properties

Create JSON file at `.roy/tasks/extended/{task_id}.json` with structure:

```json
{
  "roy": {
    "state": "Draft",
    "behavior": "<inferred behavior>",
    "acceptance_criteria": [
      "<criterion 1>",
      "<criterion 2>",
      "<criterion 3>"
    ],
    "expected_results": [
      "<result 1>",
      "<result 2>"
    ],
    "inferred_from": "<original description>",
    "created_by_command": "/roy-task-create",
    "created_at": "<timestamp in ET>",
    "test_strategy": "<test strategy>",
    "tags": []
  },
  "tdd": {
    "inference_quality": "high|medium|low"
  },
  "gitlab": {
    "labels": [],
    "weight": null
  }
}
```

Use Python to get proper ET timezone timestamp.

### Step 5: Validate Task Creation

1. Query Archon task: `archon:find_tasks(task_id="<task_id>")`
2. Verify extended properties file exists
3. Check both contain expected data
4. Report validation results

### Step 6: Report to User

Display structured report:

```
✅ Task Created Successfully

Task ID: <task_id>
Title: <title>
State: Draft (roy extended property)
Status: todo (Archon status)

TDD Analysis:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Behavior:
<inferred behavior>

Acceptance Criteria:
1. <criterion 1>
2. <criterion 2>
3. <criterion 3>

Expected Results:
• <result 1>
• <result 2>

Test Strategy:
<test strategy>

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Inference Quality: <high|medium|low>

Files Created:
• Archon task: http://localhost:3737/projects/<project_id>
• Extended props: .roy/tasks/extended/<task_id>.json

Next Steps:
1. Review TDD analysis and acceptance criteria
2. Refine if needed by editing extended properties JSON
3. Promote to Active: Update roy.state to "Active" when ready to work
4. Query task: archon:find_tasks(task_id="<task_id>")
```

---

## Implementation Details

### TDD Inference Logic

When analyzing the description, apply these patterns:

**For "Implement X" descriptions:**
- Behavior: "Implement X with Y capabilities"
- Criteria: Focus on functional requirements, edge cases, validation
- Results: Working implementation, tests passing, documentation updated

**For "Fix X" descriptions:**
- Behavior: "Resolve X issue by addressing Y root cause"
- Criteria: Bug no longer reproducible, regression tests added, related cases verified
- Results: Issue resolved, tests pass, no side effects

**For "Refactor X" descriptions:**
- Behavior: "Refactor X to improve Y"
- Criteria: Functionality preserved, code quality metrics improved, tests still pass
- Results: Cleaner code, better maintainability, same behavior

**For "Research X" descriptions:**
- Behavior: "Research X and document findings about Y"
- Criteria: Key questions answered, trade-offs identified, recommendation provided
- Results: Documentation created, decision recorded, next steps clear

**For vague descriptions:**
- Ask clarifying questions OR
- Infer reasonable interpretation with `low` quality rating
- Include note in extended properties about assumptions made

### Error Handling

**If Archon task creation fails:**
- Report error to user
- Do not create extended properties file
- Provide diagnostic information
- Suggest checking Archon service status

**If extended properties write fails:**
- Delete Archon task (cleanup)
- Report error to user
- Provide file path that failed
- Suggest checking file permissions

**If validation fails:**
- Report which validation check failed
- Provide task ID if task was created
- Offer manual verification steps
- Do not fail the command (task may still be usable)

---

## Configuration

### Default Project ID
Atlas project: `3f2b6ee9-05ff-48ae-ad6f-54cad080addc`

To use different project, user can:
1. Specify in description: "For project X, create task to..."
2. Query project first: `archon:find_projects(query="project name")`
3. Modify extended properties after creation

### Archon API URL
Default: `http://localhost:8181`

Override with environment variable: `ARCHON_API_URL`

### Extended Properties Location
`.roy/tasks/extended/{task_id}.json`

Follows roy framework authority (files in `.roy/` are authoritative)

---

## Examples

### Example 1: Simple Feature Implementation

**Command:**
```
/roy-task-create Implement user authentication using JWT tokens with email/password login
```

**Inferred TDD Components:**

Behavior:
> Implement user authentication system using JWT tokens with email and password-based login

Acceptance Criteria:
1. Users can register with email and password (password hashed with bcrypt)
2. Users can login with valid credentials and receive JWT token
3. JWT tokens are validated on protected endpoints
4. Invalid credentials return appropriate error messages
5. Tokens expire after 24 hours and require re-authentication

Expected Results:
• Working authentication endpoints (register, login, validate)
• JWT tokens generated and validated correctly
• Password hashing implemented securely
• Integration tests passing for auth flows

Test Strategy:
> Create test user, attempt login with valid/invalid credentials, verify token generation and validation, test token expiration

### Example 2: Bug Fix

**Command:**
```
/roy-task-create Fix memory leak in data processing pipeline that causes OOM errors after 1000 records
```

**Inferred TDD Components:**

Behavior:
> Resolve memory leak in data processing pipeline causing out-of-memory errors after processing 1000 records

Acceptance Criteria:
1. Pipeline processes 10,000+ records without memory growth
2. Memory usage stays within expected bounds throughout processing
3. No OOM errors occur during extended operations
4. Memory profiling shows no leak patterns
5. Regression test added to catch future leaks

Expected Results:
• Memory leak eliminated
• Pipeline stable for large datasets
• Memory profiling data shows flat memory usage
• Regression test passing

Test Strategy:
> Profile memory usage with 10,000 record dataset, verify memory remains stable, run overnight stress test

### Example 3: Research Task

**Command:**
```
/roy-task-create Research vector database options for RAG implementation and recommend best fit for our use case
```

**Inferred TDD Components:**

Behavior:
> Research vector database solutions for RAG implementation and provide recommendation based on project requirements

Acceptance Criteria:
1. At least 5 vector DB options evaluated (Pinecone, Weaviate, Milvus, Qdrant, pgvector)
2. Comparison matrix created covering performance, cost, features, integration
3. Trade-offs documented for each option
4. Recommendation provided with justification
5. POC completed with recommended solution

Expected Results:
• Research document with comparison matrix
• Recommendation with clear justification
• POC demonstrating recommended solution
• Next steps documented for implementation

Test Strategy:
> Verify all options researched, comparison matrix complete, recommendation addresses requirements, POC successfully demonstrates capability

---

## Integration with Roy Framework

### Data Source Hierarchy

Tasks created via `/roy-task-create` are **Archon tasks** (source of truth for agentic workflow tasks).

They are **NOT** GitLab issues. See POLICY-data-sources for distinction:
- Archon tasks: Roy-orchestrated agentic workflow
- GitLab issues: Atlas project work items (user stories, epics)

### Extended Properties Purpose

Extended properties enable:
1. **TDD workflow**: Acceptance criteria drive implementation
2. **State management**: Draft → Active → Completed lifecycle
3. **GitLab interoperability**: Future sync with GitLab issues
4. **Quality tracking**: Inference quality assessment
5. **Audit trail**: Original description and creation metadata

### Future Enhancements

**Phase 2: GitLab Sync**
- Bidirectional sync between Archon tasks and GitLab issues
- Automatic GitLab property population from task metadata
- Label and milestone synchronization

**Phase 3: Template Library**
- Pre-defined templates for common task types
- User can specify template: `/roy-task-create --template feature <description>`
- Templates provide structured acceptance criteria patterns

**Phase 4: Intelligent Refinement**
- Iterative refinement of TDD components based on feedback
- Learning from historical task quality assessments
- Suggested improvements to vague descriptions

---

## Technical Notes

### Why Extended Properties?

Extended properties stored in separate JSON files (not Archon DB) because:
1. **Non-invasive**: No Archon schema changes required
2. **Roy authority**: Files in `.roy/` are authoritative per roy framework
3. **Version control**: Easy to track changes in git
4. **Flexibility**: Can evolve schema without DB migrations
5. **Portability**: Can export/import tasks with extended properties

### Why Draft State?

"Draft" state (roy extended property) separate from Archon "todo" status because:
1. **Distinction**: Draft = needs review, todo = ready to work
2. **Workflow**: Draft → Review/Refine → Promote to Active → Begin work
3. **Quality**: Allows validation of TDD inference before committing to work
4. **Flexibility**: Can have Draft tasks that aren't yet prioritized

### Schema Validation

Extended properties follow JSON schema: `.roy/schemas/extended-task-properties.json`

Validation performed by:
- Python script on write
- Command implementation on read
- Future: Automated validation on git commit

---

## See Also

- **SPEC-004**: Complete specification for task creation capability
- **POLICY-data-sources**: Data source hierarchy and authority
- **Extended Properties Schema**: `.roy/schemas/extended-task-properties.json`
- **Task Creator Tool**: `.roy/tools/task_creator.py`

---

**Created:** 2025-10-08
**Last Updated:** 2025-10-08
**Roy Framework Version:** 1.0.0-alpha
**Specification:** SPEC-004
