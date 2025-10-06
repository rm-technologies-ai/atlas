# GitLab SDK - Documentation Index

**Project:** GitLab-Archon RAG Integration
**Status:** ✅ Implementation Complete, Testing Pending
**Last Updated:** 2025-10-02

---

## Quick Start

### For Users
1. Read **[README.md](README.md)** - Understand what the tool does
2. Execute full refresh (see [TEST_PLAN.md](TEST_PLAN.md) - Test 3)
3. Query GitLab data via Archon RAG (see README.md examples)

### For Developers
1. Read **[IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md)** - Understand architecture
2. Review source code: `/archon/python/src/mcp_server/features/gitlab/`
3. Run tests (see [TEST_PLAN.md](TEST_PLAN.md))

### For AI Agents
1. Read **[/mnt/e/repos/atlas/SESSION.md](../SESSION.md)** - Full session context
2. Check Archon tasks: `curl localhost:8181/api/tasks?project_id=3f2b6ee9...&feature=GitLab%20Integration`
3. Continue from last saved state

---

## Document Overview

### User-Facing Documentation

#### 📘 [README.md](README.md)
**Purpose:** User guide and reference
**Audience:** BMAD agents, developers, users
**Contents:**
- Tool overview and architecture
- MCP tool usage examples
- Query patterns for GitLab data
- Local data storage structure
- RAG document format
- Configuration and environment variables
- Troubleshooting guide

**Key Sections:**
- How to use `gitlab_refresh_issues()`
- Querying GitLab data via Archon RAG
- Example queries (sprint stories, epics, projects)
- Filtering results by metadata and tags

---

### Testing Documentation

#### 🧪 [TEST_PLAN.md](TEST_PLAN.md)
**Purpose:** Comprehensive testing strategy
**Audience:** QA, developers, AI agents
**Contents:**
- 7 detailed test scenarios
- Expected results and validation
- Performance metrics
- Data integrity checks
- Manual test commands
- Test execution log template

**Test Scenarios:**
1. Initial Execution (Fresh Start)
2. Resume from Saved State
3. Complete Full Refresh
4. Query Archon RAG for GitLab Data
5. Force Refresh (Reset State)
6. Time Limit Variations
7. Error Handling

**Use This When:**
- Running first-time tests
- Validating functionality
- Debugging issues
- Documenting test results

---

### Technical Documentation

#### 🔧 [IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md)
**Purpose:** Technical implementation details
**Audience:** Developers, architects, AI agents
**Contents:**
- Architecture and design patterns
- Processing phases (init → epics → projects → upload → done)
- State management schema
- RAG document structure
- Integration with BMAD agents
- Deployment status
- Known limitations and workarounds
- Production enhancement roadmap

**Key Technical Details:**
- Tool signature and parameters
- Expected data volumes
- Processing time estimates
- File locations and structure
- Error handling strategies
- Optimization techniques

---

### Session Context (Project Root)

#### 📋 [/mnt/e/repos/atlas/SESSION.md](../SESSION.md)
**Purpose:** Complete session context for continuation
**Audience:** AI agents, developers returning to project
**Contents:**
- Full session chronology
- All files created/modified
- Archon tasks created
- Next steps and commands
- Environment configuration
- Debugging commands
- Success criteria

**Use This When:**
- Starting a new session
- Continuing interrupted work
- Onboarding new team members
- Debugging complex issues

---

#### ✅ [/mnt/e/repos/atlas/COMPLETION_SUMMARY.md](../COMPLETION_SUMMARY.md)
**Purpose:** Executive summary of completion
**Audience:** Stakeholders, project managers
**Contents:**
- What was delivered
- Success metrics
- Next steps (user actions)
- File locations reference
- Deliverables checklist
- Sign-off status

**Use This When:**
- Reviewing project status
- Planning next phase
- Reporting to stakeholders

---

## Quick Reference

### Common Tasks

| Task | Document | Section |
|------|----------|---------|
| Run the tool | README.md | MCP Tool Usage |
| Query GitLab data | README.md | Query GitLab Data via Archon |
| Test the tool | TEST_PLAN.md | Test Scenarios 1-7 |
| Understand architecture | IMPLEMENTATION_SUMMARY.md | Architecture |
| Debug issues | README.md | Troubleshooting |
| Continue work | SESSION.md | Next Session Checklist |
| Check deployment status | IMPLEMENTATION_SUMMARY.md | Deployment Status |

---

## File Locations

### Documentation
```
/mnt/e/repos/atlas/gitlab-sdk/
├── INDEX.md (this file)
├── README.md (user guide)
├── TEST_PLAN.md (testing strategy)
└── IMPLEMENTATION_SUMMARY.md (technical details)

/mnt/e/repos/atlas/
├── SESSION.md (session context)
└── COMPLETION_SUMMARY.md (executive summary)
```

### Source Code
```
/mnt/e/repos/atlas/archon/python/src/mcp_server/features/gitlab/
├── __init__.py (module initialization)
└── refresh_tool.py (main implementation, 600+ lines)
```

### Configuration
```
/mnt/e/repos/atlas/archon/python/
├── pyproject.toml (dependencies)
└── src/mcp_server/mcp_server.py (tool registration)
```

### Data (Container)
```
/tmp/gitlab-sdk-data/ (inside archon-mcp container)
├── .refresh_state.json (processing state)
├── epics.json (extracted epics)
├── issues_partial.json (extracted issues)
├── milestones_partial.json (extracted milestones)
└── rag_documents.json (formatted for RAG)
```

---

## Quick Commands

### Check Status
```bash
# View state file
docker compose exec archon-mcp cat /tmp/gitlab-sdk-data/.refresh_state.json | jq

# Check Archon for GitLab data
curl "http://localhost:8181/api/sources?source_type=gitlab_issue&limit=5" | jq

# View tasks
curl "http://localhost:8181/api/tasks?project_id=3f2b6ee9-05ff-48ae-ad6f-54cad080addc&feature=GitLab%20Integration" | jq
```

### Run Tool
See [README.md](README.md) - MCP Tool Usage section

### Debug
See [README.md](README.md) - Troubleshooting section

---

## Reading Order

### First Time Users
1. **README.md** - Understand what it does
2. **TEST_PLAN.md** - Run Test 3 (Complete Full Refresh)
3. **README.md** - Try query examples

### Developers
1. **IMPLEMENTATION_SUMMARY.md** - Understand architecture
2. **README.md** - Review data format and API
3. Source code: `refresh_tool.py`
4. **TEST_PLAN.md** - Run all tests

### AI Agents (New Session)
1. **SESSION.md** - Load full context
2. Check Archon tasks (via API)
3. **TEST_PLAN.md** - Execute pending tests
4. Update SESSION.md with findings

### Troubleshooting
1. **README.md** - Troubleshooting section
2. **SESSION.md** - Common debugging commands
3. **IMPLEMENTATION_SUMMARY.md** - Known limitations

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2025-10-02 | Initial implementation complete |

---

## Next Steps

1. **Execute Full Refresh** (User)
   - See TEST_PLAN.md - Test 3
   - Update Archon task #094b70cb when complete

2. **Verify Data** (User)
   - See TEST_PLAN.md - Test 4
   - Update Archon task #c1971b48 when complete

3. **Test BMAD Queries** (AI Agent)
   - See TEST_PLAN.md - Test 4
   - Update Archon task #4a3fe704 when complete

4. **Document Results** (AI Agent)
   - Update TEST_PLAN.md with results
   - Update IMPLEMENTATION_SUMMARY.md
   - Mark Archon task #0fdf5eed as done

---

## Support & Contact

**Maintainer:** Atlas Technical Team
**Documentation:** `/mnt/e/repos/atlas/gitlab-sdk/`
**Source Code:** `/mnt/e/repos/atlas/archon/python/src/mcp_server/features/gitlab/`
**Archon UI:** http://localhost:3737
**Archon API:** http://localhost:8181

For questions:
1. Check troubleshooting sections
2. Review logs: `docker compose logs archon-mcp`
3. Inspect state file
4. Review SESSION.md for debugging commands

---

**Index Version:** 1.0
**Last Updated:** 2025-10-02
**Status:** Complete - Ready for Testing
