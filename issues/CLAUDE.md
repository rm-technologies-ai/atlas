# CLAUDE.md - GitLab Issues Export Tool

This file provides guidance to Claude Code (claude.ai/code) when working with the GitLab issues export tool.

## Tool Overview

This tool exports GitLab issues from the `atlas-datascience/lion` group to CSV/XLSX format for LLM/RAG processing and analysis. It uses the GitLab REST API to fetch issue metadata, descriptions, and comments.

## Files in This Folder

- **Scripts:**
  - `list-issues-csv.sh` - Exports basic issue metadata to CSV
  - `list-issues-csv-with-text.sh` - Exports full issue data with descriptions and comments
  - `test-csv-format.sh` - Test script for CSV formatting

- **Data Files:**
  - `gitlab-hive-issues.csv` - Basic issue metadata export
  - `gitlab-issues-with-text.csv` - Full issue export with descriptions and comments
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

## Environment Variables

All scripts support the following environment variables:

- `GITLAB_HOST` - GitLab instance URL (default: https://gitlab.com)
- `GROUP_PATHS` - Comma-separated group paths (default: atlas-datascience/lion)
- `INCLUDE_SUBGROUPS` - Include subgroups (default: true)
- `STATE` - Issue state filter: opened|closed|all (default: all)
- `OUT` - Output filename (default varies by script)
- `FETCH_COMMENTS` - Fetch issue comments (default: false, set to true for full data)

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
- Exports to `gitlab-issues-with-text.csv`
- Includes structured full_text field for LLM processing
- Optionally fetches comments (up to 300 per issue)
- Progress indicator when fetching comments

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

To increase limits, modify the `for page in 1 2 3 4 5...` loop in the scripts.

## Integration with RAG/Graph Solutions

These exports are designed for:
- Ingesting into RAG systems (archon, etc.)
- Training/fine-tuning LLMs on project context
- Analyzing issue hierarchies and traceability
- Identifying missing backlog items
- Understanding project history and patterns

The structured full_text format optimizes for LLM context window loading and semantic search.
