# GitLab Refresh Issues - Simplified Implementation Plan
**Date:** 2025-10-01
**Objective:** Single MCP tool to sync Lion GitLab work items to Archon RAG

---

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [Architecture Overview](#architecture-overview)
3. [Single MCP Tool Design](#single-mcp-tool-design)
4. [Data Model](#data-model)
5. [Implementation Plan](#implementation-plan)
6. [File Structure](#file-structure)
7. [Testing Strategy](#testing-strategy)
8. [Success Criteria](#success-criteria)

---

## Executive Summary

### Problem Statement
BMAD agents need access to current GitLab work items (issues, epics, milestones, etc.) from Lion project to answer queries like:
- "What user stories are in the current sprint?"
- "Which epics are in progress?"
- "What's due this week?"

### Solution
**Single MCP Tool:** `gitlab_refresh_issues()`
- Traverses `https://gitlab.com/atlas-datascience/lion` hierarchy
- Extracts all work items (issues, epics, milestones, journeys, releases)
- Persists to `gitlab-sdk/data/` folder
- Upserts to Archon RAG for semantic search

### What's Eliminated from Original Plan
- ❌ Multiple MCP tools (only need one: `gitlab_refresh_issues()`)
- ❌ Complex temporal indexing (handled by metadata)
- ❌ Separate schema extensions (use existing Archon sources table)
- ❌ Hierarchy graph tables (include in metadata JSON)
- ❌ CLI interface (MCP tool only)
- ❌ Standalone Python package (simple module in Archon)

### What's Kept (Essentials Only)
- ✅ GitLab API traversal (reuse existing utilities)
- ✅ RAG formatting with full denormalization
- ✅ Archon upload via existing `/api/sources` endpoint
- ✅ Local persistence in `gitlab-sdk/data/`
- ✅ Metadata with dates for filtering

---

## Architecture Overview

### Simplified Flow

```
┌─────────────────────────────────────────────────────────────┐
│  MCP Tool: gitlab_refresh_issues()                           │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  1. Traverse Lion GitLab hierarchy                  │   │
│  │  2. Extract all work items (issues, epics, etc.)   │   │
│  │  3. Format for RAG (denormalize)                    │   │
│  │  4. Save to gitlab-sdk/data/                        │   │
│  │  5. Upsert to Archon RAG                            │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│  Local Storage: gitlab-sdk/data/                             │
│  • issues.json (all issues)                                  │
│  • epics.json (all epics)                                    │
│  • milestones.json (all milestones)                          │
│  • rag_documents.json (formatted for Archon)                 │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│  Archon RAG (existing sources table)                         │
│  • source_type: "gitlab_issue", "gitlab_epic", etc.          │
│  • metadata: {due_date, state, epic_id, ...}                │
│  • tags: [project, epic, state, ...]                        │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│  BMAD Agents Query via Existing RAG Tools                    │
│  • archon:rag_search_knowledge_base()                        │
│  • Filter by tags: "gitlab-epic-6", "state-opened"          │
└─────────────────────────────────────────────────────────────┘
```

---

## Single MCP Tool Design

### gitlab_refresh_issues()

**Location:** `/mnt/e/repos/atlas/archon/python/src/mcp_server/features/gitlab/refresh_tool.py`

**Signature:**
```python
@mcp.tool()
async def gitlab_refresh_issues(
    force_refresh: bool = False
) -> Dict[str, Any]:
    """
    Refresh all GitLab work items from Lion project to Archon RAG

    Traverses https://gitlab.com/atlas-datascience/lion hierarchy and:
    1. Extracts all work items (issues, epics, milestones, journeys, releases)
    2. Formats for RAG with full denormalization
    3. Saves to gitlab-sdk/data/ folder
    4. Upserts to Archon RAG via /api/sources

    Args:
        force_refresh: If True, re-fetch all data. If False, only update changed items.

    Returns:
        {
            'success': True,
            'summary': {
                'issues_processed': 234,
                'epics_processed': 12,
                'milestones_processed': 8,
                'uploaded_to_archon': 254,
                'failed': 0,
                'skipped_unchanged': 50
            },
            'data_path': '/mnt/e/repos/atlas/gitlab-sdk/data/',
            'duration_seconds': 45.3
        }
    """
```

**Implementation:**
```python
import json
import os
from pathlib import Path
from datetime import datetime
from typing import Dict, List, Any
import requests
from gitlab import Gitlab

async def gitlab_refresh_issues(force_refresh: bool = False) -> Dict[str, Any]:
    start_time = datetime.now()

    # Configuration
    GITLAB_URL = "https://gitlab.com"
    GITLAB_TOKEN = os.getenv('GITLAB_TOKEN')
    LION_GROUP = "atlas-datascience/lion"
    DATA_DIR = Path("/mnt/e/repos/atlas/gitlab-sdk/data")
    ARCHON_API = "http://localhost:8181"

    # Ensure data directory exists
    DATA_DIR.mkdir(parents=True, exist_ok=True)

    # Initialize GitLab client
    gl = Gitlab(GITLAB_URL, private_token=GITLAB_TOKEN)

    # Step 1: Traverse hierarchy and extract all work items
    print("Step 1: Traversing Lion hierarchy...")
    all_work_items = await extract_all_work_items(gl, LION_GROUP, force_refresh, DATA_DIR)

    # Step 2: Format for RAG
    print("Step 2: Formatting for RAG...")
    rag_documents = format_for_rag(all_work_items)

    # Step 3: Save to local files
    print("Step 3: Saving to local storage...")
    save_to_local(all_work_items, rag_documents, DATA_DIR)

    # Step 4: Upsert to Archon
    print("Step 4: Upserting to Archon RAG...")
    upload_results = await upsert_to_archon(rag_documents, ARCHON_API)

    # Calculate summary
    duration = (datetime.now() - start_time).total_seconds()

    return {
        'success': True,
        'summary': {
            'issues_processed': len(all_work_items['issues']),
            'epics_processed': len(all_work_items['epics']),
            'milestones_processed': len(all_work_items['milestones']),
            'uploaded_to_archon': upload_results['uploaded'],
            'failed': upload_results['failed'],
            'skipped_unchanged': upload_results['skipped']
        },
        'data_path': str(DATA_DIR),
        'duration_seconds': duration
    }


async def extract_all_work_items(gl: Gitlab, group_path: str, force_refresh: bool, data_dir: Path) -> Dict:
    """Extract all work items from Lion hierarchy"""

    work_items = {
        'issues': [],
        'epics': [],
        'milestones': [],
        'merge_requests': [],
        'metadata': {
            'extracted_at': datetime.now().isoformat(),
            'group_path': group_path,
            'force_refresh': force_refresh
        }
    }

    # Get Lion group
    group = gl.groups.get(group_path)

    # Extract epics (group-level)
    print(f"  Extracting epics from {group_path}...")
    for epic in group.epics.list(all=True):
        epic_data = extract_epic(epic, group)
        work_items['epics'].append(epic_data)

    # Get all projects (recursively including subgroups)
    print(f"  Finding all projects under {group_path}...")
    all_projects = get_all_projects(gl, group)

    # Extract issues, milestones, MRs from each project
    for project in all_projects:
        print(f"  Processing project: {project.path_with_namespace}")

        # Issues
        for issue in project.issues.list(all=True):
            issue_data = extract_issue(issue, project)
            work_items['issues'].append(issue_data)

        # Milestones
        for milestone in project.milestones.list(all=True):
            milestone_data = extract_milestone(milestone, project)
            work_items['milestones'].append(milestone_data)

    return work_items


def get_all_projects(gl: Gitlab, group) -> List:
    """Get all projects including subgroups (recursive)"""
    projects = []

    # Direct projects
    projects.extend(group.projects.list(all=True))

    # Subgroup projects (recursive)
    for subgroup in group.subgroups.list(all=True):
        sub_group_obj = gl.groups.get(subgroup.id)
        projects.extend(get_all_projects(gl, sub_group_obj))

    return projects


def extract_issue(issue, project) -> Dict:
    """Extract issue with full context"""

    # Get discussions (comments)
    discussions = []
    try:
        for disc in issue.discussions.list(all=True):
            for note in disc.attributes.get('notes', []):
                discussions.append({
                    'author': note.get('author', {}).get('username'),
                    'created_at': note.get('created_at'),
                    'body': note.get('body')
                })
    except:
        pass

    # Get epic relationship
    epic_info = None
    if hasattr(issue, 'epic') and issue.epic:
        epic_info = {
            'id': issue.epic.get('id'),
            'iid': issue.epic.get('iid'),
            'title': issue.epic.get('title')
        }

    return {
        'type': 'issue',
        'id': issue.id,
        'iid': issue.iid,
        'project_id': project.id,
        'project_path': project.path_with_namespace,
        'project_name': project.name,
        'title': issue.title,
        'description': issue.description or '',
        'state': issue.state,
        'created_at': issue.created_at,
        'updated_at': issue.updated_at,
        'closed_at': getattr(issue, 'closed_at', None),
        'due_date': getattr(issue, 'due_date', None),
        'author': {
            'username': issue.author.get('username'),
            'name': issue.author.get('name')
        },
        'assignees': [
            {'username': a.get('username'), 'name': a.get('name')}
            for a in getattr(issue, 'assignees', [])
        ],
        'labels': getattr(issue, 'labels', []),
        'milestone': {
            'id': issue.milestone.get('id'),
            'title': issue.milestone.get('title'),
            'due_date': issue.milestone.get('due_date')
        } if hasattr(issue, 'milestone') and issue.milestone else None,
        'epic': epic_info,
        'discussions': discussions,
        'web_url': issue.web_url
    }


def extract_epic(epic, group) -> Dict:
    """Extract epic with metadata"""

    return {
        'type': 'epic',
        'id': epic.id,
        'iid': epic.iid,
        'group_id': group.id,
        'group_path': group.full_path,
        'title': epic.title,
        'description': epic.description or '',
        'state': epic.state,
        'created_at': epic.created_at,
        'updated_at': epic.updated_at,
        'closed_at': getattr(epic, 'closed_at', None),
        'start_date': getattr(epic, 'start_date', None),
        'due_date': getattr(epic, 'due_date', None),
        'author': {
            'username': epic.author.get('username'),
            'name': epic.author.get('name')
        },
        'labels': getattr(epic, 'labels', []),
        'web_url': epic.web_url
    }


def extract_milestone(milestone, project) -> Dict:
    """Extract milestone with metadata"""

    return {
        'type': 'milestone',
        'id': milestone.id,
        'iid': milestone.iid,
        'project_id': project.id,
        'project_path': project.path_with_namespace,
        'title': milestone.title,
        'description': milestone.description or '',
        'state': milestone.state,
        'created_at': milestone.created_at,
        'updated_at': milestone.updated_at,
        'due_date': getattr(milestone, 'due_date', None),
        'start_date': getattr(milestone, 'start_date', None),
        'web_url': milestone.web_url
    }


def format_for_rag(work_items: Dict) -> List[Dict]:
    """Format all work items for RAG ingestion"""

    rag_documents = []

    # Format issues
    for issue in work_items['issues']:
        rag_doc = format_issue_for_rag(issue)
        rag_documents.append(rag_doc)

    # Format epics
    for epic in work_items['epics']:
        rag_doc = format_epic_for_rag(epic)
        rag_documents.append(rag_doc)

    # Format milestones
    for milestone in work_items['milestones']:
        rag_doc = format_milestone_for_rag(milestone)
        rag_documents.append(rag_doc)

    return rag_documents


def format_issue_for_rag(issue: Dict) -> Dict:
    """Format single issue for RAG"""

    # Build full text content
    content_parts = [
        f"PROJECT: {issue['project_path']}",
        f"ISSUE #{issue['iid']}: {issue['title']}",
        f"STATE: {issue['state']}",
        f"AUTHOR: {issue['author']['name']} ({issue['author']['username']})",
        f"CREATED: {issue['created_at']}",
    ]

    if issue['due_date']:
        content_parts.append(f"DUE DATE: {issue['due_date']}")

    if issue['epic']:
        content_parts.append(f"EPIC: {issue['epic']['title']} (#{issue['epic']['iid']})")

    if issue['milestone']:
        content_parts.append(f"MILESTONE: {issue['milestone']['title']} (due {issue['milestone']['due_date']})")

    if issue['assignees']:
        assignee_names = [a['name'] for a in issue['assignees']]
        content_parts.append(f"ASSIGNEES: {', '.join(assignee_names)}")

    if issue['labels']:
        content_parts.append(f"LABELS: {', '.join(issue['labels'])}")

    content_parts.append(f"\nDESCRIPTION:\n{issue['description']}")

    if issue['discussions']:
        content_parts.append(f"\nCOMMENTS ({len(issue['discussions'])}):")
        for disc in issue['discussions']:
            content_parts.append(
                f"[{disc['created_at']}] {disc['author']}: {disc['body']}"
            )

    full_text = "\n".join(content_parts)

    # Build tags
    tags = [
        'gitlab-issue',
        f"project-{issue['project_path'].split('/')[-1]}",
        f"state-{issue['state']}"
    ]

    if issue['epic']:
        tags.append(f"epic-{issue['epic']['iid']}")

    if issue['labels']:
        tags.extend([f"label-{label}" for label in issue['labels']])

    return {
        'id': f"gitlab-issue-{issue['id']}",
        'type': 'gitlab_issue',
        'url': issue['web_url'],
        'title': f"{issue['project_path']} #{issue['iid']}: {issue['title']}",
        'content': full_text,
        'metadata': {
            'gitlab_type': 'issue',
            'gitlab_id': issue['id'],
            'gitlab_iid': issue['iid'],
            'project_path': issue['project_path'],
            'state': issue['state'],
            'due_date': issue['due_date'],
            'created_at': issue['created_at'],
            'updated_at': issue['updated_at'],
            'closed_at': issue['closed_at'],
            'epic_id': issue['epic']['id'] if issue['epic'] else None,
            'epic_title': issue['epic']['title'] if issue['epic'] else None,
            'milestone_title': issue['milestone']['title'] if issue['milestone'] else None,
            'milestone_due': issue['milestone']['due_date'] if issue['milestone'] else None
        },
        'tags': tags
    }


def format_epic_for_rag(epic: Dict) -> Dict:
    """Format single epic for RAG"""

    content_parts = [
        f"GROUP: {epic['group_path']}",
        f"EPIC #{epic['iid']}: {epic['title']}",
        f"STATE: {epic['state']}",
        f"AUTHOR: {epic['author']['name']} ({epic['author']['username']})",
        f"CREATED: {epic['created_at']}",
    ]

    if epic['start_date']:
        content_parts.append(f"START DATE: {epic['start_date']}")

    if epic['due_date']:
        content_parts.append(f"DUE DATE: {epic['due_date']}")

    if epic['labels']:
        content_parts.append(f"LABELS: {', '.join(epic['labels'])}")

    content_parts.append(f"\nDESCRIPTION:\n{epic['description']}")

    full_text = "\n".join(content_parts)

    tags = [
        'gitlab-epic',
        f"group-{epic['group_path'].split('/')[-1]}",
        f"state-{epic['state']}"
    ]

    if epic['labels']:
        tags.extend([f"label-{label}" for label in epic['labels']])

    return {
        'id': f"gitlab-epic-{epic['id']}",
        'type': 'gitlab_epic',
        'url': epic['web_url'],
        'title': f"{epic['group_path']} Epic #{epic['iid']}: {epic['title']}",
        'content': full_text,
        'metadata': {
            'gitlab_type': 'epic',
            'gitlab_id': epic['id'],
            'gitlab_iid': epic['iid'],
            'group_path': epic['group_path'],
            'state': epic['state'],
            'start_date': epic['start_date'],
            'due_date': epic['due_date'],
            'created_at': epic['created_at'],
            'updated_at': epic['updated_at']
        },
        'tags': tags
    }


def format_milestone_for_rag(milestone: Dict) -> Dict:
    """Format single milestone for RAG"""

    content_parts = [
        f"PROJECT: {milestone['project_path']}",
        f"MILESTONE: {milestone['title']}",
        f"STATE: {milestone['state']}",
        f"CREATED: {milestone['created_at']}",
    ]

    if milestone['start_date']:
        content_parts.append(f"START DATE: {milestone['start_date']}")

    if milestone['due_date']:
        content_parts.append(f"DUE DATE: {milestone['due_date']}")

    content_parts.append(f"\nDESCRIPTION:\n{milestone['description']}")

    full_text = "\n".join(content_parts)

    tags = [
        'gitlab-milestone',
        f"project-{milestone['project_path'].split('/')[-1]}",
        f"state-{milestone['state']}"
    ]

    return {
        'id': f"gitlab-milestone-{milestone['id']}",
        'type': 'gitlab_milestone',
        'url': milestone['web_url'],
        'title': f"{milestone['project_path']} Milestone: {milestone['title']}",
        'content': full_text,
        'metadata': {
            'gitlab_type': 'milestone',
            'gitlab_id': milestone['id'],
            'project_path': milestone['project_path'],
            'state': milestone['state'],
            'start_date': milestone['start_date'],
            'due_date': milestone['due_date'],
            'created_at': milestone['created_at']
        },
        'tags': tags
    }


def save_to_local(work_items: Dict, rag_documents: List[Dict], data_dir: Path):
    """Save extracted data to local files"""

    # Save raw work items
    with open(data_dir / 'issues.json', 'w') as f:
        json.dump(work_items['issues'], f, indent=2)

    with open(data_dir / 'epics.json', 'w') as f:
        json.dump(work_items['epics'], f, indent=2)

    with open(data_dir / 'milestones.json', 'w') as f:
        json.dump(work_items['milestones'], f, indent=2)

    # Save RAG documents
    with open(data_dir / 'rag_documents.json', 'w') as f:
        json.dump(rag_documents, f, indent=2)

    # Save metadata
    with open(data_dir / 'metadata.json', 'w') as f:
        json.dump(work_items['metadata'], f, indent=2)


async def upsert_to_archon(rag_documents: List[Dict], archon_api: str) -> Dict:
    """Upsert RAG documents to Archon"""

    results = {
        'uploaded': 0,
        'failed': 0,
        'skipped': 0
    }

    for doc in rag_documents:
        try:
            # Check if already exists (by URL)
            check_response = requests.get(
                f"{archon_api}/api/sources",
                params={'url': doc['url']}
            )

            if check_response.status_code == 200 and check_response.json():
                # Update existing
                existing_id = check_response.json()[0]['id']
                response = requests.put(
                    f"{archon_api}/api/sources/{existing_id}",
                    json={
                        'title': doc['title'],
                        'content': doc['content'],
                        'metadata': doc['metadata'],
                        'tags': doc['tags'],
                        'status': 'completed'
                    }
                )
            else:
                # Create new
                response = requests.post(
                    f"{archon_api}/api/sources",
                    json={
                        'url': doc['url'],
                        'source_type': doc['type'],
                        'title': doc['title'],
                        'content': doc['content'],
                        'metadata': doc['metadata'],
                        'tags': doc['tags'],
                        'status': 'completed'
                    }
                )

            if response.status_code in [200, 201]:
                results['uploaded'] += 1
            else:
                results['failed'] += 1

        except Exception as e:
            print(f"Error upserting {doc['id']}: {e}")
            results['failed'] += 1

    return results
```

---

## Data Model

### Work Item Types

**1. Issue**
```json
{
  "type": "issue",
  "id": 169054766,
  "iid": 1,
  "project_path": "atlas-datascience/lion/project-lion/edge-connector",
  "title": "Create base Lambda Function skeleton",
  "state": "closed",
  "due_date": null,
  "epic": {
    "id": 3655658,
    "iid": 6,
    "title": "Edge Connector v1"
  },
  "milestone": {
    "title": "Sprint 1",
    "due_date": "2025-10-15"
  },
  "assignees": [...],
  "labels": [],
  "discussions": [...]
}
```

**2. Epic**
```json
{
  "type": "epic",
  "id": 3655658,
  "iid": 6,
  "group_path": "atlas-datascience/lion",
  "title": "Edge Connector v1",
  "state": "opened",
  "start_date": "2025-06-01",
  "due_date": "2025-10-31",
  "labels": []
}
```

**3. Milestone**
```json
{
  "type": "milestone",
  "id": 12345,
  "project_path": "atlas-datascience/lion/project-lion/edge-connector",
  "title": "Sprint 1",
  "state": "active",
  "start_date": "2025-10-01",
  "due_date": "2025-10-15"
}
```

### RAG Document Format

**Stored in Archon sources table:**
```json
{
  "url": "https://gitlab.com/atlas-datascience/lion/project-lion/edge-connector/-/issues/1",
  "source_type": "gitlab_issue",
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
  "tags": ["gitlab-issue", "project-edge-connector", "state-closed", "epic-6"],
  "status": "completed"
}
```

---

## Implementation Plan

### Phase 1: Create gitlab-sdk Structure (Day 1)

```bash
# Create directory structure
mkdir -p /mnt/e/repos/atlas/gitlab-sdk/data

# Create refresh tool in Archon
# Location: /mnt/e/repos/atlas/archon/python/src/mcp_server/features/gitlab/
mkdir -p /mnt/e/repos/atlas/archon/python/src/mcp_server/features/gitlab
touch /mnt/e/repos/atlas/archon/python/src/mcp_server/features/gitlab/__init__.py
touch /mnt/e/repos/atlas/archon/python/src/mcp_server/features/gitlab/refresh_tool.py
```

### Phase 2: Implement Core Logic (Day 2-3)

**Tasks:**
1. ✅ Create `refresh_tool.py` with `gitlab_refresh_issues()` function
2. ✅ Implement `extract_all_work_items()` - traverse Lion hierarchy
3. ✅ Implement extractors: `extract_issue()`, `extract_epic()`, `extract_milestone()`
4. ✅ Implement formatters: `format_issue_for_rag()`, `format_epic_for_rag()`, `format_milestone_for_rag()`
5. ✅ Implement `save_to_local()` - persist to gitlab-sdk/data/
6. ✅ Implement `upsert_to_archon()` - upload via /api/sources

### Phase 3: Register MCP Tool (Day 3)

**Update Archon MCP server:**
```python
# /mnt/e/repos/atlas/archon/python/src/mcp_server/mcp_server.py

from features.gitlab.refresh_tool import gitlab_refresh_issues

# Register tool
mcp.add_tool(gitlab_refresh_issues)
```

### Phase 4: Testing (Day 4)

**Manual test:**
```python
# In Claude Code or Python shell
result = archon:gitlab_refresh_issues(force_refresh=True)

# Expected output:
{
    'success': True,
    'summary': {
        'issues_processed': 234,
        'epics_processed': 12,
        'milestones_processed': 8,
        'uploaded_to_archon': 254,
        'failed': 0,
        'skipped_unchanged': 0
    },
    'data_path': '/mnt/e/repos/atlas/gitlab-sdk/data/',
    'duration_seconds': 45.3
}
```

**Verify data:**
```bash
# Check local files
ls -lh /mnt/e/repos/atlas/gitlab-sdk/data/
# issues.json, epics.json, milestones.json, rag_documents.json, metadata.json

# Check Archon RAG
curl "http://localhost:8181/api/sources?source_type=gitlab_issue" | jq
```

### Phase 5: BMAD Integration (Day 5)

**Test BMAD agent queries:**
```python
# Query 1: What user stories are in current sprint?
result = archon:rag_search_knowledge_base(
    query="user stories sprint",
    match_count=10
)

# Filter results by tag
filtered = [r for r in result['results'] if 'milestone-sprint-1' in r.get('tags', [])]

# Query 2: What epics are in progress?
result = archon:rag_search_knowledge_base(
    query="epic",
    match_count=20
)

filtered = [r for r in result['results']
            if r.get('metadata', {}).get('gitlab_type') == 'epic'
            and r.get('metadata', {}).get('state') == 'opened']

# Query 3: What's due this week?
result = archon:rag_search_knowledge_base(
    query="due date",
    match_count=50
)

# Filter by due_date in metadata
import datetime
end_of_week = (datetime.date.today() + datetime.timedelta(days=7)).isoformat()
due_this_week = [r for r in result['results']
                 if r.get('metadata', {}).get('due_date')
                 and r.get('metadata', {}).get('due_date') <= end_of_week]
```

---

## File Structure

```
/mnt/e/repos/atlas/
├── gitlab-sdk/
│   ├── data/                          # Local persistence
│   │   ├── issues.json               # All issues
│   │   ├── epics.json                # All epics
│   │   ├── milestones.json           # All milestones
│   │   ├── rag_documents.json        # Formatted for RAG
│   │   └── metadata.json             # Extraction metadata
│   └── README.md                      # Usage documentation
│
├── archon/
│   └── python/
│       └── src/
│           └── mcp_server/
│               └── features/
│                   └── gitlab/
│                       ├── __init__.py
│                       └── refresh_tool.py   # MCP tool implementation
```

---

## Testing Strategy

### Unit Tests (Optional)
```python
# Test extraction
def test_extract_issue():
    mock_issue = create_mock_issue()
    result = extract_issue(mock_issue, mock_project)
    assert result['type'] == 'issue'
    assert 'title' in result

# Test formatting
def test_format_issue_for_rag():
    issue_data = {...}
    rag_doc = format_issue_for_rag(issue_data)
    assert 'content' in rag_doc
    assert 'metadata' in rag_doc
    assert 'tags' in rag_doc
```

### Integration Test
```python
# Full pipeline test
async def test_gitlab_refresh_issues():
    result = await gitlab_refresh_issues(force_refresh=True)

    assert result['success'] == True
    assert result['summary']['issues_processed'] > 0

    # Verify files exist
    assert Path('/mnt/e/repos/atlas/gitlab-sdk/data/issues.json').exists()

    # Verify Archon upload
    response = requests.get('http://localhost:8181/api/sources?source_type=gitlab_issue')
    assert len(response.json()) > 0
```

### Manual Verification
```bash
# 1. Run refresh
# In Claude Code:
archon:gitlab_refresh_issues(force_refresh=True)

# 2. Check local files
cat /mnt/e/repos/atlas/gitlab-sdk/data/metadata.json

# 3. Query Archon
curl "http://localhost:8181/api/sources?source_type=gitlab_issue&limit=5" | jq '.[] | {title, url, tags}'

# 4. Test BMAD query
archon:rag_search_knowledge_base(query="Edge Connector epic", match_count=5)
```

---

## Success Criteria

### Functional Requirements
- ✅ Single MCP tool: `gitlab_refresh_issues()` implemented
- ✅ Traverses entire Lion hierarchy (groups, subgroups, projects)
- ✅ Extracts all work item types (issues, epics, milestones)
- ✅ Formats with full denormalization for RAG
- ✅ Persists to `gitlab-sdk/data/` folder
- ✅ Upserts to Archon via existing `/api/sources` endpoint
- ✅ BMAD agents can query GitLab data via existing RAG tools

### Performance Requirements
- Extract 500+ work items in < 10 minutes
- Upload to Archon in < 5 minutes
- Incremental refresh (skip unchanged) in < 2 minutes

### Data Quality Requirements
- 100% of Lion work items extracted
- All metadata preserved (dates, assignees, labels, epics)
- Epic → Issue relationships maintained
- No data loss during extraction/upload

---

## Usage Examples

### Run Full Refresh
```python
# In Claude Code or BMAD agent
result = archon:gitlab_refresh_issues(force_refresh=True)

# Output:
{
    'success': True,
    'summary': {
        'issues_processed': 234,
        'epics_processed': 12,
        'milestones_processed': 8,
        'uploaded_to_archon': 254,
        'failed': 0,
        'skipped_unchanged': 0
    },
    'data_path': '/mnt/e/repos/atlas/gitlab-sdk/data/',
    'duration_seconds': 45.3
}
```

### Query Current Sprint Items
```python
# BMAD Scrum Master agent

# Step 1: Refresh GitLab data
archon:gitlab_refresh_issues()

# Step 2: Query for sprint items
result = archon:rag_search_knowledge_base(
    query="sprint milestone user story",
    match_count=20
)

# Step 3: Filter by current sprint milestone
current_sprint = [r for r in result['results']
                  if r.get('metadata', {}).get('milestone_title') == 'Sprint 1']

# Step 4: Present to user
for item in current_sprint:
    print(f"- {item['title']}")
    print(f"  State: {item['metadata']['state']}")
    print(f"  Due: {item['metadata']['due_date']}")
```

### Query Epic Status
```python
# BMAD Product Manager agent

# Refresh data
archon:gitlab_refresh_issues()

# Query for specific epic
result = archon:rag_search_knowledge_base(
    query="Edge Connector v1 epic",
    match_count=10
)

# Get epic details
epic = [r for r in result['results']
        if r.get('metadata', {}).get('gitlab_type') == 'epic'][0]

# Get all issues in epic
epic_issues = [r for r in result['results']
               if r.get('metadata', {}).get('epic_title') == 'Edge Connector v1']

print(f"Epic: {epic['title']}")
print(f"State: {epic['metadata']['state']}")
print(f"Issues: {len(epic_issues)}")
print(f"Open issues: {len([i for i in epic_issues if i['metadata']['state'] == 'opened'])}")
```

---

## Next Steps

### Immediate (This Week)
1. Create `gitlab-sdk/` folder structure
2. Create `archon/.../gitlab/refresh_tool.py`
3. Implement `gitlab_refresh_issues()` MCP tool
4. Register tool in Archon MCP server
5. Test full pipeline

### Next Week
1. Run production refresh of Lion data
2. Train BMAD agents on usage patterns
3. Document common queries
4. Set up scheduled refresh (cron job or manual)

---

**Plan Status:** Ready for Implementation
**Simplified From:** Complex multi-tool architecture
**Focus:** Single MCP tool for complete GitLab sync
**Target:** BMAD agents can query Lion work items via Archon RAG

---

**Created:** 2025-10-01
**Implementation Time:** 5 days
**Maintenance:** Run `gitlab_refresh_issues()` weekly or on-demand
