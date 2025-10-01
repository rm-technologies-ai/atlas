# TODO - archon-test

**Project:** Archon Test Suite for Hybrid RAG System Optimization

**IMPORTANT:** This project uses **Archon MCP server** for primary task management. This TODO.md file serves as a secondary reference only. Always use Archon task management as the authoritative source.

## Current Sprint

### Task 1: Manual Archon Ingest Test
**Status:** 🔴 Todo
**Priority:** High
**Estimated Time:** 1-2 hours

**Description:**
Test archon ingest directly via UI (manual process) to understand baseline behavior before optimization.

**Acceptance Criteria:**
- [ ] Archon services running successfully
- [ ] Test document ingested via UI at http://localhost:3737
- [ ] Ingest process observed and documented
- [ ] Initial baseline metrics captured

**Steps:**
1. Start Archon services: `cd /mnt/e/repos/atlas/archon && docker compose up -d`
2. Access Archon UI at http://localhost:3737
3. Ingest test document (Atlas Business Plan or similar)
4. Observe chunking, metadata creation, and embedding process
5. Document baseline observations in `/test-results/`

---

### Task 2: Identify RAG Optimization Parameters
**Status:** 🔴 Todo
**Priority:** High
**Estimated Time:** 2-3 hours

**Description:**
Identify which parameters and logic can be modified to optimize hybrid RAG responses as consumed by Claude Code.

**Acceptance Criteria:**
- [ ] RAG vector DB parameters identified and documented
- [ ] Graph DB parameters identified and documented
- [ ] LLM parameters identified and documented
- [ ] Hybrid fusion strategies documented
- [ ] Extension points in Archon codebase located

**Research Areas:**

**RAG Vector DB Parameters:**
- Chunk size (tokens/characters)
- Chunk overlap
- Similarity threshold
- Max records returned
- Reranking strategies
- Embedding model selection

**Graph DB Parameters:**
- Relationship traversal depth
- Node filtering logic
- Query expansion rules
- Entity extraction parameters

**LLM Parameters:**
- Temperature
- Top-k sampling
- Top-p (nucleus sampling)
- Max tokens
- System prompt engineering

**Hybrid Fusion:**
- RAG vs Graph weight balancing
- Result merging strategies
- Relevance scoring algorithms
- Context window optimization

**Deliverables:**
- Documentation of all tunable parameters
- Location of configuration files in Archon
- Recommended starting values for optimization tests

---

### Task 3: Implement Test Inspection Artifact Generator
**Status:** 🔴 Todo
**Priority:** Medium
**Estimated Time:** 3-4 hours

**Description:**
Create tooling to generate inspection artifacts (markdown files) showing RAG chunks and Graph DB records.

**Acceptance Criteria:**
- [ ] Script to export RAG chunks to markdown in `/rag-ingest-records/`
- [ ] Script to export Graph DB nodes/relationships to markdown in `/graph-ingest-records/`
- [ ] Auto-numbering implemented (001.md, 002.md, etc.)
- [ ] Proper metadata included in each artifact
- [ ] Integration with Archon API or database queries

**Output Format Examples:**

**RAG Ingest Record:**
```markdown
# RAG Ingest Record 001
**Document:** Atlas Business Plan
**Chunk ID:** chunk-001
**Timestamp:** 2025-10-01T12:00:00Z

## Content
[Chunk text]

## Metadata
- Source: atlas-business-plan.pdf
- Page: 5
- Token Count: 512
```

**Graph Ingest Record:**
```markdown
# Graph Ingest Record 001
**Document:** Atlas Business Plan
**Timestamp:** 2025-10-01T12:00:00Z

## Nodes Created
1. Component: Edge Connector

## Relationships Created
1. Edge Connector -> Enrichment Service (DEPENDS_ON)
```

---

### Task 4: Execute Baseline Test Cycle
**Status:** 🔴 Todo
**Priority:** Medium
**Estimated Time:** 2-3 hours

**Description:**
Execute complete test cycle with baseline parameters following Setup → Exercise → Verify → Teardown convention.

**Test Scenario:**
- **Input Dataset:** Atlas Business Plan
- **Test Query:** "List the top 10 architectural components of the system"
- **Expected Results:** [Define based on document content]

**Acceptance Criteria:**
- [ ] Setup: Document ingested, parameters documented
- [ ] Exercise: Test query executed via Archon UI
- [ ] Verify: Results compared against expected components
- [ ] Teardown: Results documented, artifacts generated
- [ ] Precision/recall metrics calculated

---

## Backlog

### Future Tasks
- Implement automated test scripts (Node.js/Python)
- Create parameter optimization iteration framework
- Build result comparison and metrics dashboard
- Develop regression test suite
- Document optimization best practices

---

## Task Management Notes

**Archon Task Sync:**
All tasks above should be created in Archon MCP server using:
```bash
archon:manage_task(
  action="create",
  project_id="[archon-test-project-id]",
  title="Task Title",
  description="Task description",
  feature="RAG Optimization",
  task_order=[priority]
)
```

**Status Updates:**
Update task status in both Archon and this file:
- 🔴 Todo
- 🟡 Doing
- 🔵 Review
- 🟢 Done

**Workflow:**
1. Check Archon for current task
2. Update Archon status to "doing"
3. Complete work
4. Update Archon status to "review"
5. After user confirmation, mark "done"

---

**Last Updated:** 2025-10-01
**Next Review:** After Task 1 completion
