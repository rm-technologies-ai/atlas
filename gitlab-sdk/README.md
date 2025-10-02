# GitLab SDK - Lion Work Items Sync

Synchronizes GitLab work items from https://gitlab.com/atlas-datascience/lion to Archon RAG for BMAD agent access.

## Overview

This SDK provides a single MCP tool `gitlab_refresh_issues()` that:
1. Traverses the Lion GitLab hierarchy (groups → projects)
2. Extracts all work items (issues, epics, milestones)
3. Formats for RAG with full denormalization
4. Persists locally to `gitlab-sdk/data/`
5. Upserts to Archon RAG for semantic search

## Architecture

```
GitLab API (Lion) → gitlab_refresh_issues() → Local Storage → Archon RAG → BMAD Agents
```

## MCP Tool Usage

### In Claude Code or BMAD Agent

```python
# Refresh all GitLab work items
result = archon:gitlab_refresh_issues(force_refresh=True)

# Returns:
{
    'success': True,
    'summary': {
        'issues_processed': 234,
        'epics_processed': 12,
        'milestones_processed': 8,
        'uploaded_to_archon': 254,
        'updated_in_archon': 50,
        'failed': 0
    },
    'data_path': '/mnt/e/repos/atlas/gitlab-sdk/data/',
    'duration_seconds': 45.3
}
```

## Query GitLab Data via Archon

Once refreshed, BMAD agents can query GitLab data using existing Archon RAG tools:

### Example 1: Current Sprint User Stories

```python
# Refresh GitLab data
archon:gitlab_refresh_issues()

# Query for sprint items
result = archon:rag_search_knowledge_base(
    query="sprint user story milestone",
    match_count=20
)

# Filter by current sprint
sprint_items = [r for r in result['results']
                if r.get('metadata', {}).get('milestone_title') == 'Sprint 1']
```

### Example 2: Epic Status

```python
# Query for specific epic
result = archon:rag_search_knowledge_base(
    query="Edge Connector v1 epic",
    match_count=10
)

# Get epic and related issues
epic = [r for r in result['results']
        if r.get('metadata', {}).get('gitlab_type') == 'epic'][0]

epic_issues = [r for r in result['results']
               if r.get('metadata', {}).get('epic_title') == 'Edge Connector v1']
```

### Example 3: Items Due This Week

```python
# Refresh data
archon:gitlab_refresh_issues()

# Query for due dates
result = archon:rag_search_knowledge_base(
    query="due date",
    match_count=50
)

# Filter by date
import datetime
end_of_week = (datetime.date.today() + datetime.timedelta(days=7)).isoformat()

due_this_week = [r for r in result['results']
                 if r.get('metadata', {}).get('due_date')
                 and r.get('metadata', {}).get('due_date') <= end_of_week]
```

## Local Data Storage

Extracted data is saved to `/mnt/e/repos/atlas/gitlab-sdk/data/`:

```
data/
├── issues.json           # All issues
├── epics.json            # All epics
├── milestones.json       # All milestones
├── rag_documents.json    # Formatted for RAG
└── metadata.json         # Extraction metadata
```

## RAG Document Format

Each work item is formatted for optimal RAG ingestion:

```json
{
  "id": "gitlab-issue-169054766",
  "type": "gitlab_issue",
  "url": "https://gitlab.com/atlas-datascience/lion/project-lion/edge-connector/-/issues/1",
  "title": "atlas-datascience/lion/project-lion/edge-connector #1: Create base Lambda Function skeleton",
  "content": "PROJECT: atlas-datascience/lion/project-lion/edge-connector\nISSUE #1: Create base Lambda Function skeleton\nSTATE: closed\nEPIC: Edge Connector v1 (#6)\n...",
  "metadata": {
    "gitlab_type": "issue",
    "gitlab_id": 169054766,
    "project_path": "atlas-datascience/lion/project-lion/edge-connector",
    "state": "closed",
    "due_date": null,
    "epic_id": 3655658,
    "epic_title": "Edge Connector v1",
    "milestone_title": "Sprint 1",
    "milestone_due": "2025-10-15"
  },
  "tags": [
    "gitlab-issue",
    "project-edge-connector",
    "state-closed",
    "epic-6",
    "epic-edge-connector-v1"
  ]
}
```

## Configuration

Environment variables (from `.env.atlas`):

```bash
GITLAB_TOKEN=glpat-...              # GitLab API token
GITLAB_HOST=https://gitlab.com      # GitLab instance
GITLAB_GROUP=atlas-datascience/lion # Group to scan
ARCHON_SERVER_PORT=8181             # Archon API port
```

## Implementation Details

### Work Item Types Extracted

1. **Issues** - All issues with:
   - Full description and comments
   - Epic relationship
   - Milestone assignment
   - Labels and assignees
   - Due dates

2. **Epics** - Group-level epics with:
   - Title and description
   - Start and due dates
   - State (opened/closed)

3. **Milestones** - Project milestones with:
   - Title and description
   - Start and due dates
   - State (active/closed)

### Tags Applied

- `gitlab-issue`, `gitlab-epic`, `gitlab-milestone` - Type tags
- `project-{name}` - Project name
- `state-{opened|closed}` - Current state
- `epic-{iid}` - Epic IID
- `epic-{slug}` - Epic title slug
- `label-{name}` - GitLab labels

### Filtering Examples

```python
# Filter by type
issues = [r for r in results if 'gitlab-issue' in r.get('tags', [])]

# Filter by state
open_items = [r for r in results if 'state-opened' in r.get('tags', [])]

# Filter by project
edge_connector = [r for r in results if 'project-edge-connector' in r.get('tags', [])]

# Filter by epic
epic_6 = [r for r in results if 'epic-6' in r.get('tags', [])]
```

## Maintenance

### When to Refresh

Run `gitlab_refresh_issues()`:
- Weekly (recommended for active projects)
- Before sprint planning sessions
- After major GitLab updates
- On-demand when BMAD agents need current data

### Force Refresh

```python
# Re-fetch everything (ignores incremental updates)
archon:gitlab_refresh_issues(force_refresh=True)

# Incremental update (default)
archon:gitlab_refresh_issues(force_refresh=False)
```

## Troubleshooting

### GitLab Token Invalid

```
Error: GITLAB_TOKEN environment variable not set
```

**Solution:** Check `.env.atlas` has valid `GITLAB_TOKEN`

### Archon API Not Accessible

```
Error: Connection refused to http://localhost:8181
```

**Solution:** Start Archon:
```bash
cd /mnt/e/repos/atlas/archon
docker compose up -d
```

### Rate Limit Errors

GitLab API has rate limits. If you hit them:
- Wait a few minutes
- Use `force_refresh=False` for incremental updates
- Contact GitLab admin to increase limits

## Development

### File Locations

- **MCP Tool:** `/mnt/e/repos/atlas/archon/python/src/mcp_server/features/gitlab/refresh_tool.py`
- **Data Storage:** `/mnt/e/repos/atlas/gitlab-sdk/data/`
- **Environment:** `/mnt/e/repos/atlas/.env.atlas`

### Testing

```python
# Test refresh
result = archon:gitlab_refresh_issues(force_refresh=True)
assert result['success'] == True

# Verify local files
ls -lh /mnt/e/repos/atlas/gitlab-sdk/data/

# Test Archon upload
curl "http://localhost:8181/api/sources?source_type=gitlab_issue&limit=5" | jq
```

---

**Created:** 2025-10-01
**Maintainer:** Atlas Technical Team
**Integration:** Archon MCP + BMAD Agents
