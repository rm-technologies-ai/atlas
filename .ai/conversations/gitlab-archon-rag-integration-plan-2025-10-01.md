# GitLab-Archon RAG Integration Plan
**Date:** 2025-10-01
**Objective:** Create unified GitLab SDK for hierarchical data extraction and Archon RAG ingestion

---

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [Current State Analysis](#current-state-analysis)
3. [Proposed Architecture](#proposed-architecture)
4. [Implementation Plan](#implementation-plan)
5. [Data Model & RAG Format](#data-model--rag-format)
6. [GitLab SDK Design](#gitlab-sdk-design)
7. [Archon Integration](#archon-integration)
8. [Query Capabilities](#query-capabilities)
9. [Development Roadmap](#development-roadmap)
10. [Testing Strategy](#testing-strategy)

---

## Executive Summary

### Problem Statement
Currently, GitLab data (issues, epics, user stories, wikis) from Project Lion is fragmented across multiple tools:
- **issues/** - Bash scripts for CSV export (basic metadata)
- **gitlab-utilities/** - Python utilities for comprehensive cloning

**Gaps identified:**
- No unified SDK for programmatic access
- Data not optimized for RAG ingestion
- Cannot answer temporal queries ("Which user stories are due this Friday")
- Hierarchical relationships not preserved for RAG
- No MCP integration for BMAD agents

### Solution Overview
Create **gitlab-sdk/** - A reusable Python library that:
1. Hierarchically clones Lion group structure (groups → projects → issues)
2. Formats data for Archon RAG with full denormalization
3. Provides MCP-compatible API for BMAD agents
4. Enables temporal and semantic queries

### Key Deliverables
1. **gitlab-sdk/** library (Python package)
2. **Archon RAG ingestion pipeline**
3. **MCP integration** for Claude Code & BMAD
4. **Temporal query support** (due dates, milestones, sprints)
5. **Documentation & examples**

---

## Current State Analysis

### Existing Tools Assessment

#### 1. issues/ Directory
**Files:**
- `list-issues-csv.sh` - Basic metadata export
- `list-issues-csv-with-text.sh` - Full text export with comments
- `upload-to-archon.sh` - Archon API upload (partial)
- `ingest-gitlab-knowledge.sh` - Knowledge extraction

**Capabilities:**
- ✅ Exports up to 1000 issues
- ✅ Includes descriptions and comments
- ✅ Structured full_text for LLM
- ✅ Basic Archon upload via API

**Limitations:**
- ❌ Bash-based (not reusable)
- ❌ Hardcoded tokens
- ❌ No hierarchy preservation
- ❌ Limited to 1000 issues (pagination constraints)
- ❌ No epic → story relationships
- ❌ No temporal query support

#### 2. gitlab-utilities/ Directory
**Files:**
- `consolidated_backup_export.py` - Full GitLab cloning
- `enhanced_export.py` - Enhanced issue analytics
- `gitlab_cloner/` - Modular cloning package
- `gitlab_discovery/` - Discovery and export

**Capabilities:**
- ✅ Complete hierarchical cloning (groups, subgroups, projects)
- ✅ Multiple content types (git, wikis, issues, MRs, metadata)
- ✅ Enhanced issue history (labels, state transitions, assignees)
- ✅ AI-ready analytics and metrics
- ✅ JSON export with full metadata
- ✅ Resource events tracking

**Example Issue Structure:**
```json
{
  "id": 169054766,
  "iid": 1,
  "project_id": 70663067,
  "title": "Create base Lambda Function skeleton",
  "description": "...",
  "state": "closed",
  "created_at": "2025-06-17T19:38:20.979Z",
  "updated_at": "2025-07-21T14:34:19.069Z",
  "closed_at": "2025-07-21T14:34:18.931Z",
  "author": {...},
  "assignees": [...],
  "labels": [],
  "epic": {
    "id": 3655658,
    "iid": 6,
    "title": "Edge Connector v1"
  },
  "discussions": [...],
  "_project_info": {
    "project_path": "atlas-datascience/lion/project-lion/edge-connector"
  }
}
```

**Limitations:**
- ❌ Not optimized for RAG ingestion
- ❌ No Archon integration
- ❌ No temporal indexing
- ❌ No MCP compatibility
- ❌ Data stored in filesystem (not queryable)

#### 3. Archon MCP Server
**Location:** `/mnt/e/repos/atlas/archon/python/src/mcp_server/`

**Current MCP Tools:**
- `rag_search_knowledge_base()` - Semantic search
- `rag_search_code_examples()` - Code search
- `rag_get_available_sources()` - List sources
- `find_tasks()`, `manage_task()` - Task management
- `find_projects()`, `manage_project()` - Project management

**RAG Capabilities:**
- ✅ Supabase + pgvector for embeddings
- ✅ OpenAI embeddings
- ✅ Semantic search
- ✅ Source crawling (web scraping)
- ✅ Manual upload via API

**Upload Endpoint Pattern:**
```bash
curl -X POST "http://localhost:8181/api/sources" \
  -H "Content-Type: application/json" \
  -d '{
    "url": "source_url",
    "source_type": "manual_upload",
    "title": "Document Title",
    "content": "Full text content",
    "tags": ["tag1", "tag2"],
    "status": "completed"
  }'
```

**Gaps for GitLab Integration:**
- ❌ No hierarchical relationship storage
- ❌ No temporal metadata indexing
- ❌ No issue-specific schema
- ❌ No epic → story → task relationships
- ❌ No due date / milestone queries

---

## Proposed Architecture

### High-Level Design

```
┌─────────────────────────────────────────────────────────────┐
│                      GitLab SDK                              │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  Core Components                                     │   │
│  │  • GitLabClient (API wrapper)                       │   │
│  │  • HierarchyScanner (group → project traversal)    │   │
│  │  • IssueExtractor (issues, epics, MRs)             │   │
│  │  • RAGFormatter (denormalization for Archon)       │   │
│  │  • TemporalIndexer (due dates, milestones)         │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│              RAG Ingestion Pipeline                          │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  1. Extract (GitLab API)                            │   │
│  │  2. Transform (Denormalize + Format)                │   │
│  │  3. Chunk (Optimal for RAG)                         │   │
│  │  4. Enrich (Temporal metadata)                      │   │
│  │  5. Load (Archon RAG)                               │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    Archon RAG Storage                        │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  Supabase (pgvector)                                │   │
│  │  • sources table (with GitLab metadata)             │   │
│  │  • embeddings (OpenAI)                              │   │
│  │  • temporal_index (due_date, milestone_date)        │   │
│  │  • hierarchy_graph (epic → story → task)            │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                  MCP Integration Layer                       │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  New MCP Tools:                                      │   │
│  │  • gitlab_search_issues()                           │   │
│  │  • gitlab_get_epic_hierarchy()                      │   │
│  │  • gitlab_query_temporal()                          │   │
│  │  • gitlab_get_work_items_by_date()                  │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│              Consumers (Claude Code, BMAD)                   │
└─────────────────────────────────────────────────────────────┘
```

---

## Implementation Plan

### Phase 1: GitLab SDK Foundation (Week 1)

#### 1.1 Create gitlab-sdk/ Structure
```
/mnt/e/repos/atlas/gitlab-sdk/
├── gitlab_sdk/
│   ├── __init__.py
│   ├── client.py              # GitLabClient - API wrapper
│   ├── scanner.py             # HierarchyScanner
│   ├── extractors/
│   │   ├── __init__.py
│   │   ├── issues.py          # IssueExtractor
│   │   ├── epics.py           # EpicExtractor
│   │   ├── projects.py        # ProjectExtractor
│   │   └── wikis.py           # WikiExtractor
│   ├── formatters/
│   │   ├── __init__.py
│   │   ├── rag_formatter.py  # RAGFormatter
│   │   └── temporal_indexer.py # TemporalIndexer
│   ├── models/
│   │   ├── __init__.py
│   │   ├── issue.py           # Issue dataclass
│   │   ├── epic.py            # Epic dataclass
│   │   ├── hierarchy.py       # Hierarchy models
│   │   └── temporal.py        # Temporal models
│   └── utils/
│       ├── __init__.py
│       ├── config.py          # Configuration
│       └── helpers.py         # Helper functions
├── tests/
│   ├── test_client.py
│   ├── test_scanner.py
│   └── test_formatters.py
├── examples/
│   ├── basic_scan.py
│   ├── export_to_archon.py
│   └── query_issues.py
├── setup.py
├── requirements.txt
├── README.md
└── CLAUDE.md
```

#### 1.2 Core Components

**GitLabClient (client.py)**
```python
from typing import Optional, List, Dict, Any
import gitlab
from .models import Issue, Epic, Project

class GitLabClient:
    """Unified GitLab API client with retry and error handling"""

    def __init__(self,
                 url: str = "https://gitlab.com",
                 token: Optional[str] = None):
        self.gl = gitlab.Gitlab(url, private_token=token)

    def get_group_hierarchy(self, group_path: str) -> Dict[str, Any]:
        """Get complete group hierarchy with subgroups and projects"""
        pass

    def get_all_issues(self,
                      project_id: int,
                      include_closed: bool = True) -> List[Issue]:
        """Get all issues for a project with full metadata"""
        pass

    def get_issue_with_relationships(self,
                                    project_id: int,
                                    issue_iid: int) -> Issue:
        """Get issue with epic, related issues, and full history"""
        pass
```

**HierarchyScanner (scanner.py)**
```python
class HierarchyScanner:
    """Recursively scan GitLab hierarchy"""

    def scan_group(self, group_path: str) -> Dict[str, Any]:
        """
        Scan entire group hierarchy
        Returns nested structure:
        {
            'group': {...},
            'subgroups': [...],
            'projects': [...]
        }
        """
        pass

    def get_all_projects(self, group_path: str) -> List[Project]:
        """Flatten all projects under group (including subgroups)"""
        pass
```

**IssueExtractor (extractors/issues.py)**
```python
class IssueExtractor:
    """Extract issues with full context"""

    def extract_with_context(self,
                            project_id: int,
                            issue_iid: int) -> Dict[str, Any]:
        """
        Extract issue with:
        - Full description and comments
        - Epic relationship
        - Related issues
        - Time tracking
        - Label history
        - State transitions
        - Assignee changes
        """
        pass

    def extract_all_for_project(self, project_id: int) -> List[Dict]:
        """Extract all issues with context"""
        pass
```

#### 1.3 Data Models

**Issue Model (models/issue.py)**
```python
from dataclasses import dataclass
from typing import Optional, List, Dict
from datetime import datetime

@dataclass
class Issue:
    # Core fields
    id: int
    iid: int
    project_id: int
    project_path: str
    title: str
    description: str
    state: str

    # Temporal fields
    created_at: datetime
    updated_at: datetime
    closed_at: Optional[datetime]
    due_date: Optional[datetime]

    # Relationships
    epic: Optional['Epic']
    related_issues: List[int]
    blocking_issues: List[int]

    # People
    author: Dict
    assignees: List[Dict]

    # Categorization
    labels: List[str]
    milestone: Optional[Dict]

    # Content
    comments: List[Dict]
    state_history: List[Dict]

    # URLs
    web_url: str

    def to_rag_format(self) -> Dict[str, Any]:
        """Convert to RAG-optimized format"""
        pass

    def get_full_text(self) -> str:
        """Generate full text for embedding"""
        pass
```

### Phase 2: RAG Formatting & Archon Integration (Week 1-2)

#### 2.1 RAG Formatter

**RAGFormatter (formatters/rag_formatter.py)**
```python
class RAGFormatter:
    """Format GitLab data for Archon RAG ingestion"""

    def format_issue_for_rag(self, issue: Issue) -> Dict[str, Any]:
        """
        Format issue with denormalized content:
        {
            'id': 'gitlab-issue-123',
            'type': 'issue',
            'url': 'https://gitlab.com/...',
            'title': '...',
            'content': '...', # Full denormalized text
            'metadata': {
                'project_path': '...',
                'epic_title': '...',
                'epic_id': '...',
                'labels': [...],
                'assignees': [...],
                'state': '...',
                'due_date': '...',
                'milestone': '...',
                'created_at': '...',
                'updated_at': '...',
                'closed_at': '...',
                'author': '...',
                'comments_count': 5
            },
            'tags': ['issue', 'epic-6', 'project-edge-connector'],
            'temporal': {
                'due_date': '2025-10-04',
                'milestone_due': '2025-10-15',
                'created_at': '2025-06-17',
                'closed_at': '2025-07-21'
            },
            'hierarchy': {
                'epic_id': 6,
                'epic_title': 'Edge Connector v1',
                'parent_epic_id': None,
                'related_issues': [2, 3, 5]
            }
        }
        """

        # Denormalize content
        full_text = self._build_full_text(issue)

        return {
            'id': f'gitlab-issue-{issue.id}',
            'type': 'issue',
            'url': issue.web_url,
            'title': f'{issue.project_path} #{issue.iid}: {issue.title}',
            'content': full_text,
            'metadata': self._build_metadata(issue),
            'tags': self._build_tags(issue),
            'temporal': self._build_temporal(issue),
            'hierarchy': self._build_hierarchy(issue)
        }

    def _build_full_text(self, issue: Issue) -> str:
        """
        Build comprehensive text for RAG:

        PROJECT: atlas-datascience/lion/project-lion/edge-connector
        ISSUE #1: Create base Lambda Function skeleton
        EPIC: Edge Connector v1
        STATE: closed
        AUTHOR: Ryan Cross
        ASSIGNEES: Ryan Cross, Serge Zahniy
        LABELS: (none)
        CREATED: 2025-06-17
        DUE DATE: (none)
        MILESTONE: (none)

        DESCRIPTION:
        Create the initial codebase for the Node 22 + TypeScript Edge-Connector Lambda...

        COMMENTS (10):
        [2025-06-18] Serge Zahniy: added Edge Connector v1 as parent epic
        [2025-06-18] Serge Zahniy: changed title from "Create base Lambda Function to perform & delegate extraction tasks" to "Create base Lambda Function skeleton"
        ...

        RESOLUTION:
        Closed by Ryan Cross on 2025-07-21
        Status changed to Done
        """
        pass
```

**TemporalIndexer (formatters/temporal_indexer.py)**
```python
from datetime import datetime, timedelta
from typing import List, Dict

class TemporalIndexer:
    """Index GitLab data by temporal attributes"""

    def index_by_due_date(self, issues: List[Issue]) -> Dict[str, List[Issue]]:
        """Group issues by due date"""
        pass

    def get_due_this_week(self, issues: List[Issue]) -> List[Issue]:
        """Get issues due this week"""
        pass

    def get_due_on_date(self, issues: List[Issue], date: datetime) -> List[Issue]:
        """Get issues due on specific date"""
        pass

    def get_overdue(self, issues: List[Issue]) -> List[Issue]:
        """Get overdue issues"""
        pass

    def build_temporal_metadata(self, issue: Issue) -> Dict[str, Any]:
        """
        Build temporal metadata:
        {
            'due_date': '2025-10-04',
            'due_date_timestamp': 1728086400,
            'milestone_due': '2025-10-15',
            'is_overdue': False,
            'days_until_due': 3,
            'created_at': '2025-06-17',
            'age_days': 106,
            'time_to_close_days': 34
        }
        """
        pass
```

#### 2.2 Archon Integration

**ArchonUploader (archon_uploader.py)**
```python
import requests
from typing import List, Dict

class ArchonUploader:
    """Upload formatted data to Archon RAG"""

    def __init__(self, archon_url: str = "http://localhost:8181"):
        self.archon_url = archon_url

    def upload_issue(self, rag_formatted_issue: Dict) -> bool:
        """Upload single issue to Archon"""

        response = requests.post(
            f"{self.archon_url}/api/sources",
            json={
                'url': rag_formatted_issue['url'],
                'source_type': 'gitlab_issue',
                'title': rag_formatted_issue['title'],
                'content': rag_formatted_issue['content'],
                'metadata': rag_formatted_issue['metadata'],
                'tags': rag_formatted_issue['tags'],
                'status': 'completed'
            }
        )
        return response.status_code == 200

    def upload_batch(self, rag_formatted_issues: List[Dict]) -> Dict[str, int]:
        """Upload batch of issues"""
        pass

    def create_temporal_index(self, issues: List[Dict]):
        """Create temporal index in Archon for date-based queries"""
        # This may require Archon schema extension
        pass
```

### Phase 3: Archon Schema Extension (Week 2)

#### 3.1 Extend Archon Database Schema

**New Tables (Supabase migration):**

```sql
-- GitLab-specific metadata table
CREATE TABLE IF NOT EXISTS gitlab_metadata (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    source_id UUID REFERENCES sources(id) ON DELETE CASCADE,
    gitlab_type VARCHAR(50), -- 'issue', 'epic', 'merge_request'
    gitlab_id BIGINT,
    gitlab_iid INTEGER,
    project_id BIGINT,
    project_path TEXT,
    epic_id BIGINT,
    epic_title TEXT,
    state VARCHAR(50),
    due_date DATE,
    milestone_due DATE,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    closed_at TIMESTAMP,
    created_at_timestamp BIGINT,
    due_date_timestamp BIGINT,
    metadata JSONB, -- Flexible metadata storage
    created_at TIMESTAMP DEFAULT NOW()
);

-- Temporal index for fast date queries
CREATE INDEX idx_gitlab_due_date ON gitlab_metadata(due_date) WHERE due_date IS NOT NULL;
CREATE INDEX idx_gitlab_state ON gitlab_metadata(state);
CREATE INDEX idx_gitlab_epic ON gitlab_metadata(epic_id) WHERE epic_id IS NOT NULL;
CREATE INDEX idx_gitlab_project ON gitlab_metadata(project_path);
CREATE INDEX idx_gitlab_timestamps ON gitlab_metadata(due_date_timestamp) WHERE due_date_timestamp IS NOT NULL;

-- Hierarchy relationship table
CREATE TABLE IF NOT EXISTS gitlab_hierarchy (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    parent_type VARCHAR(50), -- 'epic', 'issue'
    parent_id BIGINT,
    child_type VARCHAR(50), -- 'issue', 'subtask'
    child_id BIGINT,
    relationship_type VARCHAR(50), -- 'epic_issue', 'blocks', 'related_to'
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_hierarchy_parent ON gitlab_hierarchy(parent_type, parent_id);
CREATE INDEX idx_hierarchy_child ON gitlab_hierarchy(child_type, child_id);
```

#### 3.2 Update Archon API Endpoints

**New endpoint: `/api/gitlab/upload`**
```python
# archon/python/src/mcp_server/features/gitlab/gitlab_tools.py

async def upload_gitlab_issue(
    issue_data: Dict,
    temporal_metadata: Dict,
    hierarchy: Dict
) -> Dict:
    """
    Upload GitLab issue with extended metadata

    1. Create source entry (existing sources table)
    2. Create gitlab_metadata entry
    3. Create hierarchy relationships
    4. Generate embeddings (existing RAG pipeline)
    """

    # Insert into sources table
    source_id = await insert_source(
        url=issue_data['url'],
        title=issue_data['title'],
        content=issue_data['content'],
        tags=issue_data['tags']
    )

    # Insert GitLab metadata
    await insert_gitlab_metadata(
        source_id=source_id,
        gitlab_type='issue',
        gitlab_id=issue_data['id'],
        project_path=issue_data['project_path'],
        due_date=temporal_metadata.get('due_date'),
        ...
    )

    # Insert hierarchy relationships
    if hierarchy.get('epic_id'):
        await insert_hierarchy(
            parent_type='epic',
            parent_id=hierarchy['epic_id'],
            child_type='issue',
            child_id=issue_data['id']
        )

    return {'success': True, 'source_id': source_id}
```

### Phase 4: MCP Integration (Week 2-3)

#### 4.1 New MCP Tools

**GitLab MCP Tools (mcp_server/features/gitlab/gitlab_mcp_tools.py)**

```python
from mcp.server.fastmcp import FastMCP

mcp = FastMCP("Archon GitLab Tools")

@mcp.tool()
async def gitlab_search_issues(
    query: str,
    project_path: Optional[str] = None,
    state: Optional[str] = None,
    labels: Optional[List[str]] = None,
    match_count: int = 5
) -> Dict:
    """
    Search GitLab issues with semantic search + filters

    Args:
        query: Semantic search query
        project_path: Filter by project (e.g., "atlas-datascience/lion/project-lion/edge-connector")
        state: Filter by state ("opened", "closed")
        labels: Filter by labels
        match_count: Number of results

    Returns:
        {
            'success': True,
            'results': [
                {
                    'title': '...',
                    'url': '...',
                    'content': '...',
                    'project_path': '...',
                    'state': '...',
                    'due_date': '...',
                    'assignees': [...]
                }
            ]
        }
    """
    pass

@mcp.tool()
async def gitlab_query_temporal(
    date_filter: str,  # "due_this_week", "due_this_friday", "overdue", "due_2025-10-04"
    project_path: Optional[str] = None,
    state: Optional[str] = None
) -> Dict:
    """
    Query GitLab issues by temporal criteria

    Examples:
        gitlab_query_temporal("due_this_friday")
        gitlab_query_temporal("due_this_week", project_path="edge-connector")
        gitlab_query_temporal("overdue", state="opened")
        gitlab_query_temporal("due_2025-10-04")

    Returns list of issues matching temporal criteria
    """

    # Parse date filter
    if date_filter == "due_this_friday":
        target_date = get_next_friday()
    elif date_filter == "due_this_week":
        start_date, end_date = get_week_range()
    elif date_filter == "overdue":
        end_date = datetime.now()
    elif date_filter.startswith("due_"):
        target_date = parse_date(date_filter.replace("due_", ""))

    # Query gitlab_metadata table
    query = """
        SELECT s.*, gm.*
        FROM sources s
        JOIN gitlab_metadata gm ON s.id = gm.source_id
        WHERE gm.due_date = :target_date
          AND (:project_path IS NULL OR gm.project_path LIKE :project_path)
          AND (:state IS NULL OR gm.state = :state)
        ORDER BY gm.due_date ASC
    """

    results = await db.fetch_all(query, {
        'target_date': target_date,
        'project_path': f'%{project_path}%' if project_path else None,
        'state': state
    })

    return {'success': True, 'results': results}

@mcp.tool()
async def gitlab_get_epic_hierarchy(
    epic_id: int,
    include_closed: bool = False
) -> Dict:
    """
    Get epic with all child issues and hierarchy

    Returns:
        {
            'epic': {...},
            'issues': [
                {
                    'id': 1,
                    'title': '...',
                    'state': '...',
                    'assignees': [...],
                    'due_date': '...'
                }
            ],
            'hierarchy_graph': {
                'nodes': [...],
                'edges': [...]
            }
        }
    """

    # Query hierarchy table
    query = """
        SELECT
            s.*,
            gm.*
        FROM gitlab_hierarchy gh
        JOIN gitlab_metadata gm ON gh.child_id = gm.gitlab_id
        JOIN sources s ON gm.source_id = s.id
        WHERE gh.parent_type = 'epic'
          AND gh.parent_id = :epic_id
          AND (:include_closed OR gm.state != 'closed')
        ORDER BY gm.due_date ASC NULLS LAST
    """

    issues = await db.fetch_all(query, {
        'epic_id': epic_id,
        'include_closed': include_closed
    })

    return {
        'success': True,
        'epic': await get_epic_info(epic_id),
        'issues': issues,
        'hierarchy_graph': build_graph(issues)
    }

@mcp.tool()
async def gitlab_get_work_items_by_date(
    start_date: str,  # "2025-10-01"
    end_date: str,    # "2025-10-07"
    item_type: Optional[str] = None,  # "issue", "epic", "merge_request"
    project_path: Optional[str] = None
) -> Dict:
    """
    Get all work items in date range

    Use cases:
        - Sprint planning: Get all items due in sprint
        - Reporting: Get all items closed this week
        - Forecasting: Get all items due next month
    """
    pass
```

#### 4.2 Register MCP Tools

**Update archon/python/src/mcp_server/mcp_server.py:**

```python
# Import GitLab tools
from features.gitlab.gitlab_mcp_tools import (
    gitlab_search_issues,
    gitlab_query_temporal,
    gitlab_get_epic_hierarchy,
    gitlab_get_work_items_by_date
)

# Register tools
mcp.add_tool(gitlab_search_issues)
mcp.add_tool(gitlab_query_temporal)
mcp.add_tool(gitlab_get_epic_hierarchy)
mcp.add_tool(gitlab_get_work_items_by_date)
```

### Phase 5: CLI & Pipeline (Week 3)

#### 5.1 Command-Line Interface

**gitlab-sdk CLI (gitlab_sdk/cli.py)**

```bash
# Scan and extract
gitlab-sdk scan atlas-datascience/lion --output ./gitlab-data

# Format for RAG
gitlab-sdk format ./gitlab-data --output ./rag-ready

# Upload to Archon
gitlab-sdk upload ./rag-ready --archon-url http://localhost:8181

# All-in-one pipeline
gitlab-sdk pipeline atlas-datascience/lion --archon-url http://localhost:8181

# Query examples
gitlab-sdk query "Which user stories are due this Friday" --archon-url http://localhost:8181
```

**Implementation:**
```python
import click
from gitlab_sdk import GitLabClient, HierarchyScanner, RAGFormatter, ArchonUploader

@click.group()
def cli():
    """GitLab SDK - Hierarchical data extraction and RAG ingestion"""
    pass

@cli.command()
@click.argument('group_path')
@click.option('--output', '-o', default='./gitlab-data')
@click.option('--token', envvar='GITLAB_TOKEN')
def scan(group_path, output, token):
    """Scan GitLab group hierarchy"""
    client = GitLabClient(token=token)
    scanner = HierarchyScanner(client)

    data = scanner.scan_group(group_path)
    # Save to output directory

@cli.command()
@click.argument('data_dir')
@click.option('--output', '-o', default='./rag-ready')
def format(data_dir, output):
    """Format extracted data for RAG"""
    formatter = RAGFormatter()
    # Process data_dir and format for RAG

@cli.command()
@click.argument('rag_data_dir')
@click.option('--archon-url', default='http://localhost:8181')
def upload(rag_data_dir, archon_url):
    """Upload formatted data to Archon"""
    uploader = ArchonUploader(archon_url)
    # Upload all RAG-formatted data

@cli.command()
@click.argument('group_path')
@click.option('--archon-url', default='http://localhost:8181')
@click.option('--token', envvar='GITLAB_TOKEN')
def pipeline(group_path, archon_url, token):
    """Complete pipeline: scan → format → upload"""
    # Execute all steps
    pass
```

---

## Data Model & RAG Format

### RAG Document Structure

**Optimized for Archon ingestion and semantic search:**

```json
{
  "id": "gitlab-issue-169054766",
  "type": "issue",
  "url": "https://gitlab.com/atlas-datascience/lion/project-lion/edge-connector/-/issues/1",
  "title": "atlas-datascience/lion/project-lion/edge-connector #1: Create base Lambda Function skeleton",

  "content": "PROJECT: atlas-datascience/lion/project-lion/edge-connector\nISSUE #1: Create base Lambda Function skeleton\nEPIC: Edge Connector v1\nSTATE: closed\nAUTHOR: Ryan Cross\nASSIGNEES: Ryan Cross, Serge Zahniy\nCREATED: 2025-06-17\nCLOSED: 2025-07-21\n\nDESCRIPTION:\nCreate the initial codebase for the Node 22 + TypeScript Edge-Connector Lambda, including configuring local deployment to LocalStack...\n\nACCEPTANCE CRITERIA:\n- Repo skeleton: src/, test/, scripts/, docs/\n- README.md with prerequisites\n- Git pre-hooks with Husky (ESLint, Prettier)\n- Jest for unit tests\n- npm run build produces minified bundle\n- npm run deploy:local deploys to LocalStack\n\nCOMMENTS (10):\n[2025-06-18] Serge Zahniy: added Edge Connector v1 as parent epic\n[2025-06-18] Serge Zahniy: changed title from 'Create base Lambda Function to perform & delegate extraction tasks' to 'Create base Lambda Function skeleton'\n[2025-07-08] Ryan Cross: assigned to @rcross3\n[2025-07-16] Ryan Cross: set status to In progress\n[2025-07-21] Ryan Cross: set status to Done\n\nRESOLUTION:\nClosed by Ryan Cross on 2025-07-21. Status changed to Done. Time to resolution: 34 days.",

  "metadata": {
    "gitlab_type": "issue",
    "gitlab_id": 169054766,
    "gitlab_iid": 1,
    "project_id": 70663067,
    "project_path": "atlas-datascience/lion/project-lion/edge-connector",
    "project_name": "edge‑connector",
    "epic_id": 3655658,
    "epic_iid": 6,
    "epic_title": "Edge Connector v1",
    "state": "closed",
    "author": "Ryan Cross (rcross3)",
    "assignees": ["Ryan Cross (rcross3)", "Serge Zahniy (szahniy)"],
    "labels": [],
    "milestone": null,
    "created_at": "2025-06-17T19:38:20.979Z",
    "updated_at": "2025-07-21T14:34:19.069Z",
    "closed_at": "2025-07-21T14:34:18.931Z",
    "due_date": null,
    "comments_count": 10,
    "time_to_close_days": 34
  },

  "tags": [
    "gitlab-issue",
    "epic-6",
    "epic-edge-connector-v1",
    "project-edge-connector",
    "state-closed",
    "author-rcross3"
  ],

  "temporal": {
    "due_date": null,
    "due_date_timestamp": null,
    "milestone_due": null,
    "created_at": "2025-06-17",
    "created_at_timestamp": 1718651900,
    "updated_at": "2025-07-21",
    "closed_at": "2025-07-21",
    "closed_at_timestamp": 1721570058,
    "is_overdue": false,
    "days_until_due": null,
    "age_days": 106,
    "time_to_close_days": 34
  },

  "hierarchy": {
    "epic_id": 3655658,
    "epic_iid": 6,
    "epic_title": "Edge Connector v1",
    "parent_epic_id": null,
    "related_issues": [],
    "blocking_issues": [],
    "blocked_by_issues": []
  },

  "source_type": "gitlab_issue",
  "status": "completed"
}
```

### Chunking Strategy

For large issues with many comments:

```python
def chunk_issue_for_rag(issue: Issue, max_chunk_size: int = 2000) -> List[Dict]:
    """
    Chunk large issues into multiple RAG documents

    Strategy:
    1. Main chunk: Title + Description + Metadata
    2. Comments chunks: Groups of 5-10 comments
    3. Each chunk maintains reference to parent issue
    """

    chunks = []

    # Main chunk
    main_chunk = {
        'id': f'gitlab-issue-{issue.id}-main',
        'type': 'issue',
        'content': build_main_content(issue),
        'metadata': {...},
        'tags': [...],
        'is_primary': True
    }
    chunks.append(main_chunk)

    # Comment chunks (if many comments)
    if len(issue.comments) > 10:
        for i, comment_group in enumerate(chunk_list(issue.comments, 10)):
            comment_chunk = {
                'id': f'gitlab-issue-{issue.id}-comments-{i}',
                'type': 'issue_comments',
                'content': build_comments_content(comment_group),
                'metadata': {...},
                'tags': [...],
                'parent_id': f'gitlab-issue-{issue.id}-main',
                'is_primary': False
            }
            chunks.append(comment_chunk)

    return chunks
```

---

## GitLab SDK Design

### Package Structure (Detailed)

```python
# gitlab_sdk/__init__.py
from .client import GitLabClient
from .scanner import HierarchyScanner
from .extractors import IssueExtractor, EpicExtractor
from .formatters import RAGFormatter, TemporalIndexer
from .archon_uploader import ArchonUploader

__version__ = '0.1.0'

# gitlab_sdk/client.py
class GitLabClient:
    """
    Unified GitLab API client

    Features:
    - Automatic retry with exponential backoff
    - Rate limit handling
    - Token authentication
    - Support for GitLab.com and self-hosted
    """

    def __init__(self, url: str = "https://gitlab.com", token: str = None):
        self.gl = gitlab.Gitlab(url, private_token=token)
        self.gl.auth()

    @retry(stop=stop_after_attempt(3), wait=wait_exponential(multiplier=1, min=4, max=10))
    def get_group(self, group_path: str):
        """Get group with retry"""
        return self.gl.groups.get(group_path)

    def get_all_subgroups(self, group_id: int) -> List:
        """Recursively get all subgroups"""
        subgroups = []
        group = self.gl.groups.get(group_id)

        for subgroup in group.subgroups.list(all=True):
            subgroups.append(subgroup)
            # Recursive call
            subgroups.extend(self.get_all_subgroups(subgroup.id))

        return subgroups

    def get_all_issues_for_project(self, project_id: int) -> List:
        """Get all issues with pagination"""
        project = self.gl.projects.get(project_id)
        return project.issues.list(all=True)

# gitlab_sdk/scanner.py
class HierarchyScanner:
    """Scan GitLab hierarchy recursively"""

    def __init__(self, client: GitLabClient):
        self.client = client

    def scan_group(self, group_path: str) -> Dict:
        """
        Scan entire group hierarchy

        Returns:
        {
            'group': {
                'id': 123,
                'name': 'lion',
                'path': 'atlas-datascience/lion'
            },
            'subgroups': [
                {
                    'id': 456,
                    'name': 'project-lion',
                    'path': 'atlas-datascience/lion/project-lion',
                    'subgroups': [...],
                    'projects': [...]
                }
            ],
            'projects': [
                {
                    'id': 789,
                    'name': 'edge-connector',
                    'path': 'atlas-datascience/lion/project-lion/edge-connector',
                    'issues_count': 45,
                    'merge_requests_count': 12
                }
            ]
        }
        """

        group = self.client.get_group(group_path)

        hierarchy = {
            'group': {
                'id': group.id,
                'name': group.name,
                'path': group.full_path
            },
            'subgroups': [],
            'projects': []
        }

        # Get subgroups recursively
        for subgroup in self.client.get_all_subgroups(group.id):
            sub_hierarchy = self.scan_group(subgroup.full_path)
            hierarchy['subgroups'].append(sub_hierarchy)

        # Get projects
        for project in group.projects.list(all=True):
            hierarchy['projects'].append({
                'id': project.id,
                'name': project.name,
                'path': project.path_with_namespace,
                'issues_count': project.open_issues_count,
                'web_url': project.web_url
            })

        return hierarchy

    def flatten_projects(self, hierarchy: Dict) -> List[Dict]:
        """Flatten hierarchy to get all projects"""
        projects = hierarchy.get('projects', [])

        for subgroup in hierarchy.get('subgroups', []):
            projects.extend(self.flatten_projects(subgroup))

        return projects

# gitlab_sdk/extractors/issues.py
class IssueExtractor:
    """Extract issues with full context"""

    def __init__(self, client: GitLabClient):
        self.client = client

    def extract_with_context(self, project_id: int, issue_iid: int) -> Dict:
        """Extract issue with full context"""

        project = self.client.gl.projects.get(project_id)
        issue = project.issues.get(issue_iid)

        # Get discussions (comments)
        discussions = issue.discussions.list(all=True)

        # Get resource events (state changes, label changes, etc.)
        resource_events = {
            'state_events': issue.resourcestateevents.list(all=True),
            'label_events': issue.resourcelabelevents.list(all=True),
            'milestone_events': issue.resourcemilestoneevents.list(all=True)
        }

        # Get related issues
        links = issue.links.list(all=True)

        # Build context
        context = {
            'issue': issue.attributes,
            'discussions': [d.attributes for d in discussions],
            'resource_events': resource_events,
            'related_issues': [link.issue_link_id for link in links],
            'project_info': {
                'id': project.id,
                'path': project.path_with_namespace,
                'name': project.name,
                'url': project.web_url
            }
        }

        return context

    def extract_all_for_project(self, project_id: int) -> List[Dict]:
        """Extract all issues for a project"""

        issues = self.client.get_all_issues_for_project(project_id)

        results = []
        for issue in issues:
            context = self.extract_with_context(project_id, issue.iid)
            results.append(context)

        return results
```

### Usage Examples

**Example 1: Scan and Extract**
```python
from gitlab_sdk import GitLabClient, HierarchyScanner, IssueExtractor

# Initialize client
client = GitLabClient(
    url="https://gitlab.com",
    token=os.getenv('GITLAB_TOKEN')
)

# Scan hierarchy
scanner = HierarchyScanner(client)
hierarchy = scanner.scan_group('atlas-datascience/lion')

# Get all projects
projects = scanner.flatten_projects(hierarchy)
print(f"Found {len(projects)} projects")

# Extract issues from first project
extractor = IssueExtractor(client)
issues = extractor.extract_all_for_project(projects[0]['id'])
print(f"Extracted {len(issues)} issues")
```

**Example 2: Format and Upload to Archon**
```python
from gitlab_sdk import RAGFormatter, ArchonUploader

# Format for RAG
formatter = RAGFormatter()
rag_issues = [formatter.format_issue_for_rag(issue) for issue in issues]

# Upload to Archon
uploader = ArchonUploader('http://localhost:8181')
results = uploader.upload_batch(rag_issues)

print(f"Uploaded {results['success']} issues")
print(f"Failed {results['failed']} issues")
```

**Example 3: Temporal Queries**
```python
from gitlab_sdk import TemporalIndexer

indexer = TemporalIndexer()

# Get issues due this week
due_this_week = indexer.get_due_this_week(issues)

# Get issues due on specific date
due_friday = indexer.get_due_on_date(issues, datetime(2025, 10, 4))

# Get overdue issues
overdue = indexer.get_overdue(issues)
```

---

## Archon Integration

### Enhanced Archon MCP Tools

**Temporal Queries via MCP:**

```python
# In Claude Code or BMAD agent:

# Query 1: Which user stories are due this Friday?
result = archon:gitlab_query_temporal(
    date_filter="due_this_friday",
    project_path="edge-connector"
)

# Query 2: What epics have open issues?
result = archon:gitlab_search_issues(
    query="epic",
    state="opened"
)

# Query 3: Get all work for Edge Connector epic
result = archon:gitlab_get_epic_hierarchy(
    epic_id=6,
    include_closed=False
)

# Query 4: Sprint planning - what's due next week?
result = archon:gitlab_get_work_items_by_date(
    start_date="2025-10-07",
    end_date="2025-10-13"
)
```

**Integration with existing RAG:**

```python
# Combined semantic + temporal query
result = archon:rag_search_knowledge_base(
    query="Lambda function authentication issues",
    match_count=5
)

# Then filter by temporal criteria
temporal_result = archon:gitlab_query_temporal(
    date_filter="due_this_week"
)

# BMAD agent can now access both results
```

---

## Query Capabilities

### Example Queries (After Implementation)

**1. "Which user stories are due this Friday?"**
```python
archon:gitlab_query_temporal(
    date_filter="due_this_friday"
)

# Returns:
{
    'success': True,
    'results': [
        {
            'id': 'gitlab-issue-45',
            'title': 'Implement OAuth authentication flow',
            'project_path': 'atlas-datascience/lion/project-lion/edge-connector',
            'due_date': '2025-10-04',
            'assignees': ['Ryan Cross'],
            'state': 'opened',
            'url': 'https://gitlab.com/...'
        },
        ...
    ],
    'count': 3
}
```

**2. "What are all the issues related to Edge Connector epic?"**
```python
archon:gitlab_get_epic_hierarchy(
    epic_id=6
)

# Returns epic with all child issues, hierarchy graph
```

**3. "Show me overdue issues assigned to Ryan"**
```python
# First get overdue
overdue = archon:gitlab_query_temporal(
    date_filter="overdue",
    state="opened"
)

# Then filter by assignee (can be done in query)
```

**4. "What authentication-related work is planned for next sprint?"**
```python
# Semantic search
auth_issues = archon:rag_search_knowledge_base(
    query="authentication implementation",
    match_count=10
)

# Temporal filter
next_sprint = archon:gitlab_get_work_items_by_date(
    start_date="2025-10-07",
    end_date="2025-10-20"
)

# BMAD agent combines results
```

---

## Development Roadmap

### Week 1: Foundation
- [ ] Day 1-2: Create gitlab-sdk structure
- [ ] Day 2-3: Implement GitLabClient and HierarchyScanner
- [ ] Day 3-4: Implement IssueExtractor with full context
- [ ] Day 4-5: Implement RAGFormatter and TemporalIndexer

### Week 2: Integration
- [ ] Day 1-2: Extend Archon database schema (gitlab_metadata, gitlab_hierarchy)
- [ ] Day 2-3: Create Archon upload endpoints
- [ ] Day 3-4: Implement MCP tools (gitlab_search_issues, gitlab_query_temporal)
- [ ] Day 4-5: Test end-to-end pipeline

### Week 3: Polish & Testing
- [ ] Day 1-2: Create CLI interface
- [ ] Day 2-3: Write comprehensive tests
- [ ] Day 3-4: Documentation and examples
- [ ] Day 4-5: BMAD agent integration examples

### Week 4: Deployment
- [ ] Day 1: Run full Lion scan and upload
- [ ] Day 2-3: Validate temporal queries
- [ ] Day 3-4: Performance optimization
- [ ] Day 5: Team training and handoff

---

## Testing Strategy

### Unit Tests
```python
# tests/test_client.py
def test_gitlab_client_auth():
    client = GitLabClient(token="test-token")
    assert client.gl.user is not None

# tests/test_scanner.py
def test_hierarchy_scan():
    scanner = HierarchyScanner(mock_client)
    result = scanner.scan_group("test-group")
    assert 'group' in result
    assert 'projects' in result

# tests/test_formatters.py
def test_rag_formatter():
    formatter = RAGFormatter()
    rag_doc = formatter.format_issue_for_rag(mock_issue)
    assert 'content' in rag_doc
    assert 'temporal' in rag_doc
```

### Integration Tests
```python
# tests/test_integration.py
@pytest.mark.integration
def test_full_pipeline():
    # Scan
    hierarchy = scanner.scan_group("test-group")

    # Extract
    issues = extractor.extract_all_for_project(project_id)

    # Format
    rag_issues = [formatter.format_issue_for_rag(i) for i in issues]

    # Upload
    results = uploader.upload_batch(rag_issues)

    assert results['success'] > 0

@pytest.mark.integration
def test_temporal_query():
    # Upload test data with known due dates
    # Query using MCP tool
    result = gitlab_query_temporal("due_2025-10-04")
    assert len(result['results']) > 0
```

### End-to-End Test
```python
# tests/test_e2e.py
@pytest.mark.e2e
def test_bmad_agent_query():
    """Test that BMAD agent can query GitLab data via MCP"""

    # Upload test dataset
    setup_test_data()

    # Simulate BMAD agent query
    result = mcp_client.call_tool(
        'gitlab_query_temporal',
        {'date_filter': 'due_this_friday'}
    )

    assert result['success']
    assert len(result['results']) > 0

    # Verify structure
    for item in result['results']:
        assert 'title' in item
        assert 'due_date' in item
        assert 'assignees' in item
```

---

## Implementation Commands

### Setup
```bash
# Create gitlab-sdk directory
cd /mnt/e/repos/atlas
mkdir gitlab-sdk
cd gitlab-sdk

# Initialize Python package
python -m venv .venv
source .venv/bin/activate
pip install python-gitlab click requests pydantic

# Create structure
mkdir -p gitlab_sdk/{extractors,formatters,models,utils}
mkdir -p tests examples
touch setup.py requirements.txt README.md CLAUDE.md
```

### Development Workflow
```bash
# Install in development mode
pip install -e .

# Run tests
pytest tests/

# Test CLI
gitlab-sdk scan atlas-datascience/lion --output ./data

# Format for RAG
gitlab-sdk format ./data --output ./rag-ready

# Upload to Archon
gitlab-sdk upload ./rag-ready --archon-url http://localhost:8181

# Complete pipeline
gitlab-sdk pipeline atlas-datascience/lion
```

### Archon Schema Update
```bash
# Run migration
cd /mnt/e/repos/atlas/archon
# Add migration SQL to migration/ directory
# Apply via Supabase dashboard or CLI
```

---

## Success Metrics

### Functional Metrics
- ✅ Successfully scan all Lion projects and subgroups
- ✅ Extract 100% of issues with full metadata
- ✅ Upload all issues to Archon RAG
- ✅ Answer temporal queries accurately
- ✅ BMAD agents can query via MCP

### Performance Metrics
- Scan 50+ projects in < 10 minutes
- Extract 500+ issues in < 5 minutes
- Upload 500+ issues in < 10 minutes
- Temporal queries return in < 2 seconds
- Semantic search remains performant (< 3 seconds)

### Quality Metrics
- 100% test coverage for core functions
- Zero data loss during extraction
- Accurate temporal indexing (due dates)
- Preserved hierarchy relationships
- Comprehensive metadata capture

---

## Next Steps

### Immediate Actions (This Week)
1. ✅ Create this plan document
2. ⏭️ Create gitlab-sdk/ directory structure
3. ⏭️ Implement GitLabClient with auth
4. ⏭️ Implement HierarchyScanner
5. ⏭️ Test scan of Lion group

### Week 1 Deliverables
- gitlab-sdk package (functional)
- IssueExtractor with full context
- RAGFormatter with temporal indexing
- Unit tests passing

### Week 2 Deliverables
- Archon schema extended
- MCP tools implemented
- Integration tests passing
- First successful upload

### Week 3 Deliverables
- CLI complete
- BMAD agent examples
- Documentation complete
- Ready for production use

---

**Plan Created:** 2025-10-01
**Status:** Ready for Implementation
**Owner:** Atlas Technical Team
**Review Date:** 2025-10-08 (end of Week 1)

