# Roy Specification Tests: SPEC-004

**Specification:** SPEC-004 - Intelligent Task Creation with TDD Inference
**Test Suite:** Task Creation with TDD Inference
**Created:** 2025-10-08
**Status:** Ready for Execution

---

## Test Overview

This test suite validates the `/roy-task-create` command's ability to:
1. Create Archon tasks via MCP
2. Infer TDD components (behavior, acceptance criteria, expected results) from descriptions
3. Store extended properties in JSON files
4. Validate task creation
5. Handle error scenarios gracefully

---

## Test 1: Simple Feature Implementation Task

**Scenario:** Create task from clear, specific feature description

**Input:**
```
/roy-task-create Implement user authentication using JWT tokens with email/password login
```

**Expected Behavior:**

1. **TDD Inference:**
   - Behavior: Clear statement about implementing JWT authentication
   - Acceptance Criteria: 3-5 testable criteria covering:
     - User registration with password hashing
     - User login with credential validation
     - JWT token generation and validation
     - Error handling for invalid credentials
     - Token expiration handling
   - Expected Results: 2-4 observable outcomes like:
     - Working auth endpoints (register, login, validate)
     - Tests passing
     - Secure password hashing implemented
   - Test Strategy: Description of validation approach
   - Inference Quality: `high` (description is clear and specific)

2. **Archon Task Created:**
   - Title: "Implement user authentication using JWT tokens..."
   - Description: Original input
   - Status: `todo`
   - Assignee: `User`
   - task_id: Valid UUID returned

3. **Extended Properties File:**
   - Location: `.roy/tasks/extended/{task_id}.json`
   - Structure:
     ```json
     {
       "roy": {
         "state": "Draft",
         "behavior": "<inferred behavior>",
         "acceptance_criteria": ["<criterion 1>", "<criterion 2>", ...],
         "expected_results": ["<result 1>", "<result 2>", ...],
         "inferred_from": "Implement user authentication...",
         "created_by_command": "/roy-task-create",
         "created_at": "<ET timestamp>",
         "test_strategy": "<strategy>",
         "tags": []
       },
       "tdd": {
         "inference_quality": "high"
       },
       "gitlab": {...}
     }
     ```

4. **Validation:**
   - Query `archon:find_tasks(task_id="...")` returns task
   - Extended properties file exists and is valid JSON
   - All required fields present

**Verification:**
- ✅ Task ID returned
- ✅ Archon task queryable
- ✅ Extended properties file exists
- ✅ TDD components are relevant and high quality
- ✅ Inference quality marked as `high`

**Status:** Not Run

---

## Test 2: Bug Fix Task

**Scenario:** Create task from bug description

**Input:**
```
/roy-task-create Fix memory leak in data processing pipeline that causes OOM errors after 1000 records
```

**Expected Behavior:**

1. **TDD Inference:**
   - Behavior: Statement about resolving memory leak
   - Acceptance Criteria: 3-5 criteria covering:
     - Memory usage stays within bounds
     - No OOM errors during processing
     - Memory profiling shows no leaks
     - Regression test added
     - Performance acceptable for large datasets
   - Expected Results:
     - Memory leak eliminated
     - Pipeline stable for 10,000+ records
     - Tests passing
   - Test Strategy: Memory profiling and stress testing
   - Inference Quality: `high`

2. **Archon Task Created:**
   - Title: "Fix memory leak in data processing pipeline..."
   - Status: `todo`

3. **Extended Properties:**
   - `roy.state`: "Draft"
   - All TDD components populated
   - GitLab labels might include: ["bug", "performance"]

**Verification:**
- ✅ Bug fix pattern recognized
- ✅ Acceptance criteria focus on verification (no leak, tests added)
- ✅ Test strategy includes profiling and stress testing
- ✅ Extended properties include appropriate labels

**Status:** Not Run

---

## Test 3: Research Task

**Scenario:** Create research/investigation task

**Input:**
```
/roy-task-create Research vector database options for RAG implementation and recommend best fit
```

**Expected Behavior:**

1. **TDD Inference:**
   - Behavior: Research and recommend vector database solution
   - Acceptance Criteria:
     - Multiple options evaluated (at least 3-5)
     - Comparison matrix created
     - Trade-offs documented
     - Recommendation provided with justification
     - POC completed with recommended solution
   - Expected Results:
     - Research document with comparison
     - Recommendation with justification
     - POC demonstrating capability
   - Test Strategy: Verify research complete, POC demonstrates requirements
   - Inference Quality: `high`

2. **Task Created:**
   - Title: "Research vector database options for RAG..."
   - Appropriate for research-type work

3. **Extended Properties:**
   - Acceptance criteria focus on deliverables (document, recommendation, POC)
   - Not implementation-focused

**Verification:**
- ✅ Research pattern recognized
- ✅ Acceptance criteria are deliverable-focused
- ✅ Expected results include documentation and POC
- ✅ Test strategy verifies completeness not implementation

**Status:** Not Run

---

## Test 4: Vague/Ambiguous Description

**Scenario:** Create task from vague description to test inference quality assessment

**Input:**
```
/roy-task-create Add authentication
```

**Expected Behavior:**

1. **TDD Inference:**
   - Behavior: Reasonable interpretation made (e.g., "Implement authentication system")
   - Acceptance Criteria: Generic criteria inferred
   - Expected Results: Generic outcomes
   - Inference Quality: `low` (description is vague)

2. **Task Created:**
   - Title: "Add authentication"
   - Task successfully created despite vagueness

3. **Extended Properties:**
   - `tdd.inference_quality`: "low"
   - Note or comment about assumptions made
   - User encouraged to review and refine

4. **User Feedback:**
   - Command reports low inference quality
   - Suggests reviewing and editing extended properties
   - Encourages providing more detail

**Verification:**
- ✅ Task created despite vague input
- ✅ Inference quality correctly marked as `low`
- ✅ User notified about need to review
- ✅ Command doesn't fail (graceful degradation)

**Status:** Not Run

---

## Test 5: Archon API Validation

**Scenario:** Verify task is queryable via Archon MCP after creation

**Input:**
```
/roy-task-create Implement API rate limiting with Redis-based counter
```

**Expected Behavior:**

1. **Task Created in Archon**

2. **Validation Query:**
   ```
   archon:find_tasks(task_id="<returned_task_id>")
   ```

3. **Query Returns:**
   ```json
   {
     "id": "<task_id>",
     "project_id": "3f2b6ee9-05ff-48ae-ad6f-54cad080addc",
     "title": "Implement API rate limiting with Redis-based counter",
     "description": "Implement API rate limiting with Redis-based counter",
     "status": "todo",
     "assignee": "User",
     "created_at": "<timestamp>",
     "updated_at": "<timestamp>"
   }
   ```

4. **Verification Steps:**
   - All standard fields present
   - Values match what was created
   - Task is immediately queryable (no delay)

**Verification:**
- ✅ `archon:find_tasks` returns task
- ✅ All fields match expected values
- ✅ No errors during query
- ✅ Task queryable immediately after creation

**Status:** Not Run

---

## Test 6: Extended Properties Schema Validation

**Scenario:** Verify extended properties file conforms to JSON schema

**Input:**
```
/roy-task-create Refactor user service to use dependency injection pattern
```

**Expected Behavior:**

1. **Extended Properties File Created:**
   - Location: `.roy/tasks/extended/{task_id}.json`

2. **Schema Validation:**
   - Load schema from `.roy/schemas/extended-task-properties.json`
   - Validate extended properties against schema
   - All required fields present:
     - `roy.state`
     - `roy.behavior`
     - `roy.inferred_from`
     - `roy.created_by_command`
     - `roy.created_at`

3. **Data Types Correct:**
   - `roy.state`: String (enum: Draft|Active|Blocked|Deferred)
   - `roy.acceptance_criteria`: Array of strings
   - `roy.expected_results`: Array of strings
   - `roy.created_at`: String (timestamp format)
   - `tdd.inference_quality`: String (enum: high|medium|low)

**Verification:**
- ✅ Extended properties file is valid JSON
- ✅ Conforms to JSON schema
- ✅ All required fields present
- ✅ Data types match schema
- ✅ Enum values are valid

**Status:** Not Run

---

## Test 7: Error Handling - Archon API Unavailable

**Scenario:** Test behavior when Archon API is not accessible

**Setup:**
1. Stop Archon services: `cd /mnt/e/repos/atlas/archon && docker compose down`

**Input:**
```
/roy-task-create Test task for error handling
```

**Expected Behavior:**

1. **Command Attempts to Create Task:**
   - HTTP request to `http://localhost:8181/api/tasks`
   - Request fails (connection refused)

2. **Error Detected:**
   - Command catches exception
   - Identifies Archon API is unavailable

3. **User Notified:**
   ```
   ❌ Error: Failed to create Archon task

   Archon API is not accessible at http://localhost:8181

   Diagnostic Information:
   - Connection refused (Archon services may be down)

   Suggested Actions:
   1. Check Archon services: docker compose ps
   2. Start Archon: cd /mnt/e/repos/atlas/archon && docker compose up -d
   3. Wait for services to be healthy
   4. Retry command
   ```

4. **Cleanup:**
   - No extended properties file created
   - No partial task artifacts left

**Verification:**
- ✅ Error detected and caught
- ✅ User notified with clear diagnostic info
- ✅ Suggested actions provided
- ✅ No extended properties file created
- ✅ No cleanup needed

**Teardown:**
- Restart Archon services

**Status:** Not Run

---

## Test 8: Error Handling - Invalid Project ID

**Scenario:** Test behavior with non-existent project ID

**Input:**
```
/roy-task-create --project-id 00000000-0000-0000-0000-000000000000 Test invalid project
```

**Expected Behavior:**

1. **Command Attempts to Create Task:**
   - Uses provided invalid project ID

2. **Archon API Returns Error:**
   - 404 Not Found or validation error
   - Project does not exist

3. **User Notified:**
   ```
   ❌ Error: Failed to create Archon task

   Project ID not found: 00000000-0000-0000-0000-000000000000

   Suggested Actions:
   1. Query projects: archon:find_projects()
   2. Use valid project ID (default: Atlas project)
   3. Retry command with correct project ID
   ```

**Verification:**
- ✅ Invalid project ID detected
- ✅ User notified with clear error
- ✅ Suggested query command provided
- ✅ No extended properties file created

**Status:** Not Run

---

## Test 9: TDD Inference Quality - Complex Description

**Scenario:** Test inference with detailed, complex description

**Input:**
```
/roy-task-create Implement a real-time collaborative text editor feature with operational transformation for conflict resolution, supporting multiple concurrent users, with presence awareness showing active users and their cursor positions, and automatic conflict-free synchronization of edits across all connected clients using WebSocket connections
```

**Expected Behavior:**

1. **TDD Inference:**
   - Behavior: Comprehensive statement capturing all requirements
   - Acceptance Criteria: Detailed criteria covering:
     - Operational transformation implementation
     - Multi-user support
     - Presence awareness
     - Cursor position sync
     - WebSocket connections
     - Conflict-free synchronization
     - Real-time performance
   - Expected Results: Multiple specific outcomes
   - Test Strategy: Comprehensive testing approach
   - Inference Quality: `high` (description is detailed)

2. **Quality Assessment:**
   - All major requirements captured in acceptance criteria
   - No important details missed
   - Criteria are specific and testable

**Verification:**
- ✅ Complex description handled successfully
- ✅ All major requirements captured
- ✅ Acceptance criteria comprehensive
- ✅ Inference quality is `high`
- ✅ No truncation or loss of detail

**Status:** Not Run

---

## Test 10: GitLab Properties Inference

**Scenario:** Test inference of GitLab properties from description

**Input:**
```
/roy-task-create [Epic: User Management] High priority: Implement user roles and permissions system with RBAC, targeting Sprint 5 milestone, estimated 8 story points
```

**Expected Behavior:**

1. **GitLab Properties Inferred:**
   ```json
   "gitlab": {
     "labels": ["feature", "user-management", "high-priority"],
     "milestone": "Sprint 5",
     "weight": 8,
     "epic_iid": "User Management",
     "health_status": null
   }
   ```

2. **Metadata Extracted:**
   - Epic reference: "User Management"
   - Priority: "high-priority" label
   - Sprint/Milestone: "Sprint 5"
   - Story points: 8

**Verification:**
- ✅ GitLab properties populated
- ✅ Epic extracted from description
- ✅ Milestone identified
- ✅ Weight/story points set
- ✅ Priority label added

**Status:** Not Run

---

## Test Execution Summary

**Total Tests:** 10

**Status Breakdown:**
- Not Run: 10
- Passed: 0
- Failed: 0

**Test Categories:**
- Positive Tests: 6 (Tests 1-3, 5-6, 9)
- Edge Cases: 2 (Tests 4, 10)
- Error Handling: 2 (Tests 7-8)

---

## Test Execution Instructions

### Prerequisites

1. **Archon Services Running:**
   ```bash
   cd /mnt/e/repos/atlas/archon
   docker compose ps
   # Verify archon-server, archon-mcp, archon-ui are healthy
   ```

2. **Python Dependencies:**
   ```bash
   pip install requests
   ```

3. **Environment Variables:**
   ```bash
   export ARCHON_API_URL=http://localhost:8181
   ```

### Running Tests

**Manual Execution:**
1. Run each `/roy-task-create` command
2. Verify expected behavior
3. Check extended properties files
4. Query Archon via MCP
5. Update test status

**Automated Execution (Future):**
```bash
python .roy/tools/run_spec_tests.py SPEC-004
```

### Passing Criteria

Each test passes if:
1. ✅ Task created successfully (or expected error occurs)
2. ✅ TDD components are relevant and high quality
3. ✅ Extended properties file exists and is valid
4. ✅ Archon task is queryable
5. ✅ All required fields present and correct
6. ✅ Error handling works as expected

### Failure Handling

If test fails:
1. Document failure reason
2. Update test status to "Failed"
3. Create issue for investigation
4. Fix root cause
5. Re-run test
6. Update status when passing

---

## Integration Testing

After all unit tests pass, perform integration testing:

### Integration Test 1: Full Workflow

1. Create task: `/roy-task-create Implement feature X`
2. Review TDD analysis
3. Edit extended properties to refine
4. Promote to Active: Update `roy.state` to "Active"
5. Work on task
6. Mark complete: Update Archon status to "done"
7. Verify workflow completed successfully

### Integration Test 2: Multiple Tasks

1. Create 5 tasks with different types (feature, bug, research)
2. Verify all created successfully
3. Query all tasks: `archon:find_tasks(project_id="...")`
4. Verify all appear in query results
5. Check extended properties for all 5

### Integration Test 3: GitLab Sync (Future)

1. Create task with `/roy-task-create --sync-gitlab`
2. Verify GitLab issue created
3. Update task in Archon
4. Verify GitLab issue updated
5. Update GitLab issue
6. Verify Archon task updated

---

**Last Updated:** 2025-10-08
**Test Suite Status:** Ready for Execution
**Pass Rate:** Not Yet Executed
