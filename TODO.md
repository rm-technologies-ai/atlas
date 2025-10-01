# Atlas Project TODO List

**Note:** This file provides a high-level overview of project tasks. Detailed task management is handled in **Archon** (http://localhost:3737). Always use Archon MCP integration for active task tracking and management.

## Priority: Immediate Execution

- [x] Clone and install Archon within Atlas root directory
- [x] Configure Archon for MCP integration with Claude Code
- [ ] **Ingest project documentation into Archon**
  - [ ] Import GitLab wikis from `atlas-datascience/lion` group
  - [ ] Import GitLab issues (export via `/issues/` tool first)
  - [ ] Import existing code repositories and architecture documentation
  - [ ] Validate knowledge base queries return relevant results
- [ ] **Validate Archon TDD acceptance criteria**
  - [ ] Test query: "Tell me the top level components of the lion system architecture"
  - [ ] Verify Claude Code retrieves specific Lion components from knowledge base
  - [ ] Confirm context window optimization is working

## Task 1: RAG/Graph Implementation with Archon

**Status:** In Progress (🔄)

**Completed:**
- [x] Clone and install archon within Atlas root directory
- [x] Configure archon to be accessible by Claude Code via MCP during normal prompt execution
- [x] Set up Archon services (Frontend, API Server, MCP Server)
- [x] Configure Supabase database with pgvector for embeddings
- [x] Configure OpenAI API for RAG operations

**In Progress:**
- [ ] Ingest project documentation (GitLab wikis, code repos, issues) into archon
  - [ ] Set up GitLab wiki crawling or manual import
  - [ ] Export and import GitLab issues from `/issues/` tool
  - [ ] Import architecture documentation and technical specs
  - [ ] Import existing Lion codebase for code search
- [ ] Identify and configure extension points in archon for fine-tuning RAG/Graph query logic
  - [ ] Review Archon RAG strategies in UI settings
  - [ ] Configure optimal match_count for different query types
  - [ ] Test and tune semantic search relevance
- [ ] Optimize context window loading to maximize relevant RAG/Graph records
  - [ ] Benchmark query response times
  - [ ] Adjust chunking strategies for optimal context
  - [ ] Configure smart polling intervals for active development

**Validation:**
- [ ] Validate archon integration - test TDD acceptance criteria for Lion architecture query
  - [ ] Expected response: "Edge Connector, Enrichment, Catalog, Access Broker, etc."

## Task 2: Identify Missing Scrum Product Backlog Items (PBIs)

**Status:** Pending (⏸️) - Blocked by Task 1 completion

**Prerequisites:**
- ✅ Archon installed and operational
- 🔄 Project documentation ingested into Archon knowledge base
- 🔄 Claude Code can query Archon effectively for Lion architecture and requirements

**Tasks:**
- [ ] Analyze all existing GitLab issues (open and closed) to identify gaps
  - [ ] Export all issues from `atlas-datascience/lion` group
  - [ ] Categorize issues by Epic, User Story, Task, Work Item
  - [ ] Identify coverage gaps in brownfield effort
- [ ] Create missing Scrum PBIs (User Stories, Epics, Tasks) in GitLab for Lion MVP
  - [ ] Define platform engineering PBIs (pipelines, IaC, runners)
  - [ ] Define application development PBIs (features, APIs, UIs)
  - [ ] Define integration and testing PBIs
  - [ ] Define deployment and DevOps PBIs
- [ ] Establish hierarchical traceability from work items to MVP delivery goals
  - [ ] Map tasks → user stories → epics → MVP features
  - [ ] Identify critical path for December 2025 MVP
  - [ ] Prioritize backlog based on dependencies and timeline

**Deliverables:**
- Complete backlog of missing PBIs defined in GitLab
- Hierarchical traceability matrix
- Prioritized sprint planning for MVP delivery

## Task 3: Ongoing Documentation & Knowledge Management

- [ ] Continuously update Archon knowledge base with new findings
- [ ] Document architectural decisions and patterns
- [ ] Maintain synchronized task tracking between Archon and GitLab
- [ ] Keep `.env.atlas` configuration up to date
- [ ] Update CLAUDE.md with new workflows and capabilities

## Completed Tasks

- [x] Initial Atlas repository setup
- [x] Created GitLab issues export tool (`/issues/`)
- [x] Documented GitLab integration in `issues/CLAUDE.md`
- [x] Set up `.env.atlas` for centralized environment variables
- [x] Installed Archon RAG/Graph solution
- [x] Configured Docker Desktop WSL integration for Archon
- [x] Set up Supabase database for Archon
- [x] Started Archon services (Frontend, API, MCP)

## Notes

- **Archon MCP Integration:** All task management should primarily occur in Archon. This TODO.md provides a high-level view only.
- **GitLab Sync:** Tasks created in Archon can be exported to GitLab issues for team visibility.
- **MVP Deadline:** December 2025 - maintain focus on critical path items.
- **Brownfield Context:** Platform engineering reverse-engineering required for logical architecture views.

---

**Last Updated:** 2025-09-30
**Managed In:** Archon (http://localhost:3737) + GitLab (`atlas-datascience/lion`)
