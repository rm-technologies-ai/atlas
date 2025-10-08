# CLAUDE.md - GitLab Issues Export Tool

This file provides guidance to Claude Code (claude.ai/code) when working with the GitLab issues export tool.

## Tool Overview

This tool exports GitLab issues from the `atlas-datascience/lion` group to CSV/XLSX format for LLM/RAG processing and analysis. It uses the GitLab REST API to fetch issue metadata, descriptions, and comments.

## Files in This Folder

- **Scripts:**
  - `list-issues-csv.sh` - Exports basic issue metadata to CSV
  - `list-issues-csv-with-text.sh` - Exports full issue data with descriptions and comments
  - `list-issues-csv-with-text-enhanced.sh` - **NEW** Enhanced export with complete history, events, relations, and optional raw JSON
  - `test-csv-format.sh` - Test script for CSV formatting

- **Data Files:**
  - `gitlab-hive-issues.csv` - Basic issue metadata export
  - `gitlab-issues-with-text.csv` - Full issue export with descriptions and comments
  - `gitlab-issues-enhanced-*.csv` - Enhanced export with timestamps (includes comments, events, relations)
  - `gitlab-issues-with-text.xlsx` - Excel formatted issue data

## Usage

### Export Basic Issue Metadata
```bash
./list-issues-csv.sh
```
Exports metadata for all issues in the `atlas-datascience/lion` group to `gitlab-hive-issues.csv`.

**Output includes:** Project, project_id, issue_iid, issue_id, title, state, author, assignees, labels, milestone, created_at, updated_at, due_date, weight, confidential, web_url

### Export Full Issue Text
```bash
./list-issues-csv-with-text.sh
```
Exports complete issue data including descriptions and comments to `gitlab-issues-with-text.csv`.

**Additional output:** Full text field containing structured issue title, state, author, created date, labels, assignees, description, and comments

### Fetch Comments (Optional)
```bash
FETCH_COMMENTS=true ./list-issues-csv-with-text.sh
```
Set `FETCH_COMMENTS=true` to include all issue comments. This is slower but provides complete conversation history.

### Export Enhanced Issue Data (Comprehensive)
```bash
./list-issues-csv-with-text-enhanced.sh
```
Exports comprehensive issue data including **all 1-to-many relationships** denormalized into CSV columns:

**Features:**
- **32+ columns** with all visible and hidden fields
- **Comments**: Up to 500 comments per issue (stored as JSON)
- **History**: Complete audit trail with label_events, state_events, milestone_events
- **Relations**: Related issues and closing merge requests
- **Denormalized text**: Human-readable full_text field for LLM processing
- **Optional raw JSON**: Complete GitLab API response when `INCLUDE_JSON=true`

**Configuration Options:**
```bash
# Disable specific features for faster export
FETCH_COMMENTS=false FETCH_EVENTS=false FETCH_RELATIONS=false ./list-issues-csv-with-text-enhanced.sh

# Enable full feature set (default)
FETCH_COMMENTS=true FETCH_EVENTS=true FETCH_RELATIONS=true ./list-issues-csv-with-text-enhanced.sh

# Include complete raw JSON in output
INCLUDE_JSON=true ./list-issues-csv-with-text-enhanced.sh

# Export only open issues with full data
STATE=opened FETCH_COMMENTS=true ./list-issues-csv-with-text-enhanced.sh
```

**Output columns:**
- Basic: project, IDs, title, state, author, assignees, labels, milestone
- Timestamps: created_at, updated_at, closed_at, due_date
- Metrics: weight, time_estimate, time_spent, upvotes, downvotes, user_notes_count
- Status: confidential, has_tasks, task_status, health_status, epic_iid, merge_requests_count
- Denormalized: full_text (human-readable), comments_json, events_json, relations_json
- Optional: raw_issue_json (complete API response when `INCLUDE_JSON=true`)

## Environment Variables

All scripts support the following environment variables:

### Common Variables (All Scripts)
- `GITLAB_HOST` - GitLab instance URL (default: https://gitlab.com)
- `GROUP_PATHS` - Comma-separated group paths (default: atlas-datascience/lion)
- `INCLUDE_SUBGROUPS` - Include subgroups (default: true)
- `STATE` - Issue state filter: opened|closed|all (default: all)
- `OUT` - Output filename (default varies by script)

### Enhanced Export Variables (list-issues-csv-with-text-enhanced.sh)
- `FETCH_COMMENTS` - Fetch issue comments/notes (default: true)
- `FETCH_EVENTS` - Fetch resource events (label/state/milestone changes) (default: true)
- `FETCH_RELATIONS` - Fetch related issues and closing merge requests (default: true)
- `INCLUDE_JSON` - Include raw_issue_json column with complete API response (default: false)

**Example:**
```bash
GROUP_PATHS="atlas-datascience/lion,other-group" STATE=opened OUT=open-issues.csv ./list-issues-csv.sh
```

## Script Details

### list-issues-csv.sh
- Fetches up to 500 issues (5 pages × 100 per page)
- Exports to `gitlab-hive-issues.csv`
- Fast execution (no comment fetching)

### list-issues-csv-with-text.sh
- Fetches up to 1000 issues (10 pages × 100 per page)
- Exports to `gitlab-issues-with-text-TIMESTAMP.csv`
- Includes structured full_text field for LLM processing
- Optionally fetches comments (up to 300 per issue)
- Progress indicator when fetching comments

### list-issues-csv-with-text-enhanced.sh
- Fetches up to 1000 issues (10 pages × 100 per page)
- Exports to `gitlab-issues-enhanced-TIMESTAMP.csv`
- **Comprehensive data export** with all GitLab issue data
- Fetches comments (up to 500 per issue across 5 pages)
- Fetches resource events (label, state, milestone changes) via GitLab Resource Events API
- Fetches related issues and closing merge requests
- Denormalizes 1-to-many relationships into JSON columns
- Optional raw JSON dump of complete API response
- Progress indicators every 10 issues for comments, events, relations
- Typical export time: ~3-5 minutes for 100 issues with all features enabled

## Data Structure

### Full Text Field Format
The full_text field is structured for LLM consumption:
```
ISSUE TITLE: <title>
STATE: <state>
AUTHOR: <username>
CREATED: <created_at>
LABELS: <labels>
ASSIGNEES: <assignees>
DESCRIPTION: <description>
COMMENTS:
Comment by <user> (<date>): <body> | ...
```

### Enhanced CSV Columns (list-issues-csv-with-text-enhanced.sh)

The enhanced export includes 32+ columns organized by category:

**Basic Fields (9):**
- Project, project_id, issue_iid, issue_id, title, state, author, assignees, labels, milestone

**Timestamps (4):**
- created_at, updated_at, closed_at, due_date

**Metrics (7):**
- weight, time_estimate, time_spent, upvotes, downvotes, user_notes_count, merge_requests_count

**Status Fields (6):**
- confidential, has_tasks, task_status, task_completion_status, epic_iid, health_status

**Other:**
- web_url

**Denormalized Data (4-5):**
- full_text: Human-readable structured text (title, description, comments, history)
- comments_json: Array of comment objects with author, date, body
- events_json: Object with label_events, state_events, milestone_events arrays
- relations_json: Object with related_issues and closing_merge_requests arrays
- raw_issue_json: (Optional) Complete GitLab API response when `INCLUDE_JSON=true`

### JSON Column Structures

**comments_json:**
```json
[
  {
    "id": 2761635400,
    "body": "Comment text",
    "author": {"username": "...", "name": "..."},
    "created_at": "2025-09-18T20:34:32.113Z",
    "system": false
  }
]
```

**events_json:**
```json
{
  "label_events": [
    {
      "user": {"username": "..."},
      "created_at": "2025-08-29T13:06:54.188Z",
      "label": {"name": "Backlog"},
      "action": "add"
    }
  ],
  "state_events": [...],
  "milestone_events": [...]
}
```

**relations_json:**
```json
{
  "related_issues": [
    {
      "issue_link_id": 123,
      "iid": 456,
      "title": "Related issue title",
      "state": "opened"
    }
  ],
  "closing_merge_requests": [...]
}
```

## Security Notes

**⚠ IMPORTANT:** GitLab API tokens are currently hardcoded in scripts (line 7 of list-issues-*.sh). These should be migrated to environment variables or secure credential storage.

**Current token location:** `list-issues-csv.sh:7` and `list-issues-csv-with-text.sh:7`

**Recommended approach:**
```bash
export GITLAB_TOKEN="your-token-here"
# Update scripts to use: TOKEN="${GITLAB_TOKEN}"
```

## Scalability

- **list-issues-csv.sh:** Paginates up to 5 pages (500 issues max)
- **list-issues-csv-with-text.sh:** Paginates up to 10 pages (1000 issues max)
- **list-issues-csv-with-text-enhanced.sh:** Paginates up to 10 pages (1000 issues max)
  - Comments: Up to 5 pages per issue (500 comments max)
  - Events: Up to 3 pages per event type (300 events max)
  - Relations: Up to 3 pages (300 relations max)

To increase limits, modify the `for page in 1 2 3 4 5...` loop in the scripts.

**Performance Notes for Enhanced Export:**
- Export time scales linearly with number of issues and enabled features
- Typical times for 100 issues:
  - No features: ~10 seconds (basic metadata only)
  - Comments only: ~60 seconds
  - Events only: ~90 seconds
  - Relations only: ~90 seconds
  - All features: ~3-5 minutes
- GitLab API rate limits may affect performance on very large exports
- Progress indicators show every 10 issues processed

## Integration with RAG/Graph Solutions

These exports are designed for:
- Ingesting into RAG systems (archon, etc.)
- Training/fine-tuning LLMs on project context
- Analyzing issue hierarchies and traceability
- Identifying missing backlog items
- Understanding project history and patterns
- Building knowledge graphs from issue relations
- Temporal analysis of project evolution via events history
- Sentiment and engagement analysis from comments

**Recommended Usage by Export Type:**

**list-issues-csv.sh:**
- Quick metadata exports
- High-level issue overview
- Dashboard and reporting systems

**list-issues-csv-with-text.sh:**
- Semantic search and RAG ingestion
- LLM context loading
- Basic text analysis

**list-issues-csv-with-text-enhanced.sh:**
- **Comprehensive RAG/Graph ingestion** (recommended for Archon)
- Complete audit trail and history analysis
- Relationship mapping and graph databases
- Advanced analytics and ML training data
- Full project knowledge base construction
- Issue lifecycle and workflow analysis

The enhanced export's structured JSON columns enable:
- Direct parsing into graph nodes/edges (relations_json)
- Temporal analysis of state transitions (events_json)
- Conversation threading and sentiment analysis (comments_json)
- Complete historical reconstruction via raw_issue_json
