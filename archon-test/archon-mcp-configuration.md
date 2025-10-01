# Archon MCP Server Configuration

**Timestamp:** 2025-10-01T17:38:24Z
**Status:** ✅ Configured and Running
**Purpose:** Document Archon MCP server configuration and access testing

---

## MCP Server Status

### Docker Services
```bash
NAME            IMAGE                    STATUS                  PORTS
archon-mcp      archon-archon-mcp        Up 17 hours (healthy)   0.0.0.0:8051->8051/tcp
archon-server   archon-archon-server     Up 17 hours (healthy)   0.0.0.0:8181->8181/tcp
archon-ui       archon-archon-frontend   Up 17 hours (healthy)   0.0.0.0:3737->3737/tcp
```

### Service Endpoints
- **MCP Server:** http://localhost:8051/mcp
- **API Server:** http://localhost:8181/health
- **Frontend UI:** http://localhost:3737

---

## Claude Code MCP Configuration

### Configuration Location
**File:** `~/.claude.json`

**Atlas Project Configuration:**
```json
{
  "mcpServers": {
    "archon": {
      "type": "http",
      "url": "http://localhost:8051/mcp"
    }
  },
  "enabledMcpjsonServers": []
}
```

### Configuration Method
**Command Used:**
```bash
claude mcp add --transport http archon http://localhost:8051/mcp
```

**Note:** Claude Code must be fully restarted (quit and relaunch) to detect the new MCP server configuration.

---

## MCP Server Capabilities

### Server Information
- **Name:** archon-mcp-server
- **Version:** 1.12.2
- **Protocol Version:** 2024-11-05
- **Transport:** Streamable HTTP

### Available Capabilities
- ✅ **Tools** - Command execution for task management, search, etc.
- ✅ **Prompts** - Pre-configured prompt templates
- ✅ **Resources** - Access to knowledge base and documents
- ✅ **Experimental Features** - Advanced functionality

---

## Available MCP Tools

### Task Management (Consolidated - 2 tools)

#### 1. list_tasks
**Purpose:** List, search, or get specific tasks

**Parameters:**
- `query` (optional) - Keyword search
- `task_id` (optional) - Get specific task with full details
- `filter_by` (optional) - Filter by "status", "project", or "assignee"
- `filter_value` (optional) - Value to filter by
- `per_page` (default: 10) - Results per page

**Examples:**
```python
# List all tasks
archon:list_tasks()

# Search for tasks
archon:list_tasks(query="authentication")

# Get specific task
archon:list_tasks(task_id="t-123")

# Filter by status
archon:list_tasks(filter_by="status", filter_value="todo")

# Filter by project
archon:list_tasks(filter_by="project", filter_value="p-456")
```

#### 2. manage_task
**Purpose:** Create, update, or delete tasks

**Parameters:**
- `action` (required) - "create", "update", or "delete"
- `task_id` (required for update/delete)
- `project_id` (required for create)
- `title`, `description`, `status`, `assignee`, `feature`, `task_order`, etc.

**Examples:**
```python
# Create task
archon:manage_task(
    action="create",
    project_id="p-123",
    title="Implement RAG optimization",
    description="Test and optimize RAG parameters",
    feature="RAG Testing",
    task_order=10
)

# Update task status
archon:manage_task(
    action="update",
    task_id="t-123",
    status="doing"
)

# Delete task
archon:manage_task(action="delete", task_id="t-123")
```

### Project Management (Consolidated - 2 tools)

#### 1. list_projects
**Purpose:** List, search, or get specific projects

**Parameters:**
- `project_id` (optional) - Get specific project
- `query` (optional) - Search projects
- `page`, `per_page` - Pagination

**Examples:**
```python
# List all projects
archon:list_projects()

# Get specific project
archon:list_projects(project_id="p-123")

# Search projects
archon:list_projects(query="archon")
```

#### 2. manage_project
**Purpose:** Create, update, or delete projects

**Parameters:**
- `action` (required) - "create", "update", or "delete"
- `project_id` (required for update/delete)
- `title`, `description`, `github_repo`, etc.

**Examples:**
```python
# Create project
archon:manage_project(
    action="create",
    title="Archon Test Suite",
    description="RAG optimization testing",
    github_repo="github.com/user/archon-test"
)

# Update project
archon:manage_project(
    action="update",
    project_id="p-123",
    description="Updated description"
)
```

### Knowledge Base Search (3 tools)

#### 1. rag_search_knowledge_base
**Purpose:** Search documentation and knowledge base for relevant content

**Parameters:**
- `query` (required) - Search query
- `match_count` (default: 5) - Number of results (recommend 3-5)

**Examples:**
```python
# Architecture patterns
archon:rag_search_knowledge_base(
    query="RAG chunking optimization techniques",
    match_count=5
)

# API usage
archon:rag_search_knowledge_base(
    query="pgvector similarity search",
    match_count=3
)
```

#### 2. rag_search_code_examples
**Purpose:** Find code snippets and implementation examples

**Parameters:**
- `query` (required) - Search query
- `match_count` (default: 3) - Number of results

**Examples:**
```python
# Find implementation examples
archon:rag_search_code_examples(
    query="Python vector embedding implementation",
    match_count=3
)
```

#### 3. rag_get_available_sources
**Purpose:** List available knowledge sources

**Examples:**
```python
# Get all sources
archon:rag_get_available_sources()
```

### Document Management (Consolidated - 2 tools)

#### 1. list_documents
**Purpose:** List, search, or get project documents

**Parameters:**
- `project_id` (required)
- `document_id` (optional) - Get specific document
- `query` (optional) - Search documents
- `document_type` (optional) - Filter by type
- `page`, `per_page` - Pagination

#### 2. manage_document
**Purpose:** Create, update, or delete documents

**Parameters:**
- `action` (required) - "create", "update", or "delete"
- `project_id` (required)
- `document_id` (required for update/delete)
- `title`, `content`, `document_type`, etc.

### Version Management (Consolidated - 2 tools)

#### 1. list_versions
**Purpose:** List version history or get specific version

**Parameters:**
- `project_id` (required)
- `field_name` (optional) - Filter by field ("docs", "features", "data", "prd")
- `version_number` (optional) - Get specific version
- `page`, `per_page` - Pagination

#### 2. manage_version
**Purpose:** Create or restore versions

**Parameters:**
- `action` (required) - "create" or "restore"
- `project_id` (required)
- `field_name` (required) - "docs", "features", "data", "prd"
- `version_number` (required for restore)
- `content`, `change_summary` - For create action

---

## Task Status Workflow

### Status Progression
```
todo → doing → review → done
```

**Rules:**
- Only ONE task in "doing" status at a time
- Use "review" for completed work awaiting validation
- Mark "done" only after user verification

---

## Archon-First Development Workflow

### Mandatory Task Cycle

1. **Check Current Task**
   ```python
   archon:list_tasks(task_id="current-task-id")
   ```

2. **Research for Task**
   ```python
   # High-level patterns
   archon:rag_search_knowledge_base(
       query="architecture patterns",
       match_count=5
   )

   # Implementation examples
   archon:rag_search_code_examples(
       query="specific feature implementation",
       match_count=3
   )
   ```

3. **Update Task to In-Progress**
   ```python
   archon:manage_task(
       action="update",
       task_id="current-task-id",
       status="doing"
   )
   ```

4. **Implement the Task**
   - Write code based on research
   - Follow best practices from knowledge base

5. **Update Task for Review**
   ```python
   archon:manage_task(
       action="update",
       task_id="current-task-id",
       status="review"
   )
   ```

6. **Get Next Task**
   ```python
   archon:list_tasks(
       filter_by="status",
       filter_value="todo"
   )
   ```

---

## Optimization Notes

### Payload Optimization Features
- **Truncated Descriptions:** List operations return 200-character descriptions
- **Array Counts:** Source/example arrays replaced with counts in lists
- **Smart Defaults:** Default page size reduced to 10 items
- **Search Support:** Keyword search via `query` parameter

### Performance Tuning
- **match_count:** Keep between 3-5 for focused RAG results
- **per_page:** Use 10-20 for responsive UI
- **Filters:** Use filter_by/filter_value for efficient queries

---

## Testing Access

### Manual MCP Test
```bash
# Initialize connection (requires session management)
curl -s -H "Accept: application/json, text/event-stream" \
     -H "Content-Type: application/json" \
     -X POST http://localhost:8051/mcp \
     -d '{"jsonrpc":"2.0","method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}},"id":1}'
```

**Expected Response:** Server initialization with capabilities and instructions

### Via Claude Code
After restarting Claude Code:
1. Run `/mcp` command
2. Verify "archon" server is listed
3. Test with: `archon:list_projects()`

---

## Troubleshooting

### MCP Not Detected
- ✅ Verify Docker services running: `cd /mnt/e/repos/atlas/archon && docker compose ps`
- ✅ Check MCP endpoint: `curl http://localhost:8051/mcp`
- ✅ Verify configuration in `~/.claude.json`
- ⚠️ **Restart Claude Code** (fully quit and relaunch)

### Connection Errors
- Check Docker logs: `docker compose logs archon-mcp`
- Verify port 8051 not blocked: `netstat -an | grep 8051`
- Test health endpoint: `curl http://localhost:8181/health`

### Session Errors
- MCP uses session management for stateful connections
- Claude Code handles sessions automatically
- Manual testing requires session ID management

---

## Related Files

- **Configuration Screenshot:** `/mnt/e/repos/atlas/docs/configuration-documents/archon-RAG-settings-screenshot-v1.jpg`
- **Baseline RAG Config:** `/mnt/e/repos/atlas/archon-test/baseline-rag-configuration-2025-10-01T17-10-48Z.md`
- **Archon Setup Guide:** `/mnt/e/repos/atlas/archon/SETUP-ATLAS.md`
- **Archon CLAUDE.md:** `/mnt/e/repos/atlas/archon/CLAUDE.md`

---

**Last Updated:** 2025-10-01T17:38:24Z
**Status:** Configuration documented and verified
**Next Step:** Restart Claude Code to activate MCP connection
