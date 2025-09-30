# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Atlas** (root: `/mnt/e/repos/atlas/` or `E:\repos\atlas\` on Windows) is an aggregation repository for the ATLAS Data Science (Lion/Paxium) project - a brownfield commercial data science platform at 30% completion. This repository serves as a workspace for solutions, research, tools, and cloned open-source projects used during project execution.

The project builds on 10 years of NGA experience in data/image governance, search, analysis, dissemination, and lineage. It uses an iterative, ad-hoc hierarchical taxonomy with minimal scaffolding.

## Architecture

### Project Structure

- `/issues/` - GitLab issue export tool (scripts and exported CSV/XLSX data)
- Root directory will contain multiple project folders
- Each project folder is self-contained with its own tools, data, and potentially its own VCS
- Projects may be cloned from GitHub, GitLab, or custom content
- Open-source tools are cloned here and built locally to preserve customizations

### Key Components

**GitLab Integration:**
- Primary issue tracking via GitLab at `atlas-datascience/lion` group
- Scripts export issues with full text for LLM/RAG processing
- Issue hierarchy traces from individual tasks to product delivery

**Issues Folder (`/issues/`):**
- Contains scripts and exported data for GitLab issue analysis
- `gitlab-hive-issues.csv` - Basic issue metadata export
- `gitlab-issues-with-text.csv` - Full issue export with descriptions and comments
- `gitlab-issues-with-text.xlsx` - Excel formatted issue data
- Shell scripts for GitLab API interaction

## Git Integration

Atlas is connected to GitHub at `https://github.com/repotest182/atlas.git`. See `GIT-WORKFLOW.md` for detailed multi-repository workflow.

**Quick Git Commands:**
```bash
# Atlas root operations
git status                    # Check what's changed
git add .                     # Stage all changes
git commit -m "message"       # Commit changes
git push origin main          # Push to GitHub

# Verify repository context (important for multi-repo work)
pwd && git remote -v          # Show location and remote
```

**Important:** Subfolders may contain their own git repositories. Always verify your current repository context with `git remote -v` before running git commands.

## Common Commands

### Export GitLab Issues (Basic)
```bash
cd issues
./list-issues-csv.sh
```
Exports metadata for all issues in the `atlas-datascience/lion` group to `gitlab-hive-issues.csv`.

### Export GitLab Issues (Full Text)
```bash
cd issues
./list-issues-csv-with-text.sh
```
Exports complete issue data including descriptions and comments to `gitlab-issues-with-text.csv`. Set `FETCH_COMMENTS=true` to include all comments (slower).

**Environment Variables for Export Scripts:**
- `GITLAB_HOST` - GitLab instance URL (default: https://gitlab.com)
- `GROUP_PATHS` - Comma-separated group paths (default: atlas-datascience/lion)
- `INCLUDE_SUBGROUPS` - Include subgroups (default: true)
- `STATE` - Issue state filter: opened|closed|all (default: all)
- `OUT` - Output filename
- `FETCH_COMMENTS` - Fetch issue comments (default: false, set to true for full data)

## Development Context

### Environment
- **Platform:** Windows 11 Pro with WSL (Ubuntu/Debian)
- **Tools:** VS Code (WSL terminal), Docker Desktop, GitLab REST API utilities
- **Version Control:**
  - This Atlas repository is stored in GitHub (private)
  - Subfolders may contain their own version control (GitHub or GitLab clones)
  - GitLab projects from `atlas-datascience/lion` are cloned into subfolders as needed
  - Each subfolder maintains its own VCS independently

### Current Tasks

#### Task 1: RAG/Graph Implementation with Archon

Implement a RAG/Graph solution (archon) that can be accessed and properly consumed by Claude Code during ad-hoc execution of BMAD method agentic framework workflows.

**Subtasks:**
1. Clone and install archon within Atlas root directory
2. Configure archon to be accessible by Claude Code via MCP during normal prompt execution
3. Ingest project documentation (GitLab wikis, code repos, issues) into archon
4. Identify and configure extension points in archon for fine-tuning RAG/Graph query logic
5. Optimize context window loading to maximize relevant RAG/Graph records

**Test-Driven Development (TDD) Acceptance Criteria:**
- Start Claude Code session and ask: "Tell me the top level components of the lion system architecture"
- Claude Code queries archon via MCP and loads optimal amount of data into context window
- GitLab wiki pages containing architecture information are successfully ingested
- Claude Code responds with specific itemized list: "Edge Connector, Enrichment, Catalog, Access Broker, etc."

#### Task 2: Identify Missing Scrum Product Backlog Items (PBIs)

Execute the first BMAD task: Identify and create missing Scrum product backlog items (Issues in GitLab) for delivery of Project Lion MVP by December 2025.

**Requirements:**
- Claude Code must have implicit access to archon via MCP and context engineering
- All relevant RAG/Graph records loaded to context window for optimal responses
- Analyze all existing GitLab issues (open and closed) to identify gaps
- Trace issue hierarchy from individual tasks to product delivery
- Create new GitLab issues for identified gaps in brownfield effort

**Deliverables:**
- Complete backlog of missing PBIs (User Stories, Epics, Tasks) defined in GitLab
- Hierarchical traceability from work items to MVP delivery goals

### Technical Stack
- **Backend:** Node.js, Next.js, Python
- **Cloud:** AWS (Terraform, CloudFormation)
- **Platform:** GitLab CI/CD (pipelines, runners)
- **Data:** RAG/Graph databases for project documentation and code analysis

## Important Notes

- **Root Directory:** The project root is `E:\repos\atlas\` (Windows) or `/mnt/e/repos/atlas/` (WSL). All paths and operations should be relative to this root.
- **Repository Model:** This is a meta-repository that aggregates multiple sources. Subfolders may be git repositories themselves (from GitHub or GitLab). Be cautious with git operations at the root level vs. subfolder level.
- **Tool and Dependency Management:** All code, clones, repos, and tools needed for tasks are cloned and stored within the Atlas root directory. Tools are not installed globally but kept as local clones within this repository.
- **Security:** GitLab API tokens are currently hardcoded in scripts (see issues/list-issues-*.sh:7). These should be migrated to environment variables or secure credential storage.
- **Scalability:** Issue export scripts currently paginate up to 10 pages (1000 issues max). Increase page loop limit if needed.
- **Project Phase:** Brownfield project requiring reverse-engineering of platform engineering components (pipelines, IaC) to logical architecture views.
- **Hierarchical Analysis:** All work items must be traceable in hierarchical format to product delivery goals.