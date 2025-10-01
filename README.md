# Atlas

A meta-repository for the ATLAS Data Science (Lion/Paxium) project - aggregating multiple assets, projects, research, and repositories used during project execution.

## Overview

Atlas is an aggregation workspace that contains solutions, knowledge, and working spaces for various projects. It uses an iterative, ad-hoc hierarchical taxonomy with minimal scaffolding.

**Root Directory:** `E:\repos\atlas\` (Windows) or `/mnt/e/repos/atlas/` (WSL)

## Project Structure

Each subfolder is self-contained with its own tools, data, and potentially its own version control:

### `/archon/`
RAG/Graph knowledge management and task tracking system with MCP (Model Context Protocol) integration.

**Features:**
- Knowledge base with semantic search (RAG)
- Project and task management integrated with AI coding assistants
- GitLab wiki, code, and issue ingestion
- MCP server for Claude Code integration

**Services:**
- Frontend UI: http://localhost:3737
- API Server: http://localhost:8181
- MCP Server: http://localhost:8051

See: [`archon/SETUP-ATLAS.md`](archon/SETUP-ATLAS.md) for setup instructions
See: [`archon/README.md`](archon/README.md) for detailed Archon documentation

### `/issues/`
GitLab issue export tool for the `atlas-datascience/lion` group. Exports issues to CSV/XLSX for LLM/RAG processing and Archon ingestion.

See: [`issues/CLAUDE.md`](issues/CLAUDE.md) for detailed usage.

### Future Projects
Additional tools and cloned repositories will be added here as the project evolves.

## Documentation

- **[CLAUDE.md](CLAUDE.md)** - Guidance for Claude Code when working in this repository (includes Archon workflow)
- **[TODO.md](TODO.md)** - Current project task list (synchronized with Archon tasks)
- **[issues/CLAUDE.md](issues/CLAUDE.md)** - GitLab issues tool documentation
- **[archon/SETUP-ATLAS.md](archon/SETUP-ATLAS.md)** - Archon installation and configuration
- **[.env.atlas](.env.atlas)** - Environment variables and secrets (gitignored, local only)

## Repository Information

- **GitHub:** https://github.com/rm-technologies-ai/atlas (private)
- **Project:** ATLAS Data Science (Lion/Paxium) - brownfield platform at 30% completion
- **MVP Target:** December 2025
- **GitLab Group:** `atlas-datascience/lion`

## Current Status

- ✅ **Archon** - RAG/Graph solution installed and configured with MCP
- ✅ **Issues Tool** - GitLab export functionality operational
- 🔄 **Data Ingestion** - Importing GitLab wikis, repos, and issues into Archon
- 🔄 **Backlog Analysis** - Identifying missing PBIs for Lion MVP (using Archon)

## Quick Start

### Prerequisites
- Windows 11 Pro with WSL (Ubuntu/Debian)
- Docker Desktop with WSL integration enabled
- VS Code with WSL extension
- Supabase account (for Archon)
- OpenAI API key (for Archon)

### Clone Repository
```bash
git clone https://github.com/rm-technologies-ai/atlas.git
cd atlas
```

### Setup Archon (Knowledge & Task Management)
```bash
cd archon

# Configure environment (sources from ../. env.atlas)
# Edit .env with Supabase and OpenAI credentials

# Run database migration in Supabase SQL Editor
# Execute contents of: migration/complete_setup.sql

# Start Archon services
docker compose up --build -d

# Verify services
docker compose ps

# Access Archon UI
# Open: http://localhost:3737
```

See [`archon/SETUP-ATLAS.md`](archon/SETUP-ATLAS.md) for detailed setup instructions.

### Export GitLab Issues
```bash
cd issues

# Configure GitLab credentials in .env file
# Edit .env with GITLAB_TOKEN and GITLAB_GROUP

# Export issues to CSV
./list-issues-csv-with-text.sh
```

See [`issues/CLAUDE.md`](issues/CLAUDE.md) for detailed usage.

## Workflow

### Using Archon with Claude Code

1. **Start Archon Services**
   ```bash
   cd /mnt/e/repos/atlas/archon
   docker compose up -d
   ```

2. **Query Knowledge Base** (via Claude Code MCP integration)
   - Claude Code automatically has access to Archon via MCP server
   - Ask questions about Lion architecture, components, or implementation
   - Archon searches knowledge base and returns relevant context

3. **Manage Tasks** (via Archon MCP or UI)
   - Create and track tasks in Archon
   - Tasks integrate with knowledge base for context-aware development
   - Status: `todo` → `doing` → `review` → `done`

4. **Research Before Coding**
   - Always query Archon knowledge base before implementing features
   - Search for code examples and documentation
   - Use RAG results to inform implementation decisions

For detailed Archon workflow, see [CLAUDE.md](CLAUDE.md#archon-integration--workflow)

## Project Background

Atlas serves as the workspace for the ATLAS Data Science (Lion/Paxium) project, a brownfield commercial platform building on 10 years of NGA experience in:
- Data and image governance
- Search and analysis
- Dissemination and lineage
- Platform engineering (GitLab CI/CD, AWS, Terraform)

The project is currently at 30% completion with an MVP target of December 2025.

## Technical Stack

- **Backend:** Node.js, Next.js, Python
- **Cloud:** AWS (Terraform, CloudFormation)
- **Platform:** GitLab CI/CD (pipelines, runners)
- **Knowledge Management:** Archon (Supabase + pgvector, OpenAI embeddings)
- **Version Control:** GitHub (Atlas), GitLab (Lion subprojects)
- **Development:** WSL, Docker Desktop, VS Code

## Contributing

This is a private repository for the ATLAS Data Science project. For team members:

1. Always work within the Atlas root directory structure
2. Use Archon for task tracking and knowledge management
3. Follow the Archon-first workflow (see CLAUDE.md)
4. Keep `.env.atlas` up to date with required credentials
5. Document new tools and projects in this README

## Support

For questions or issues:
- Check [CLAUDE.md](CLAUDE.md) for guidance and workflows
- Review [archon/CLAUDE.md](archon/CLAUDE.md) for Archon-specific development
- Consult project documentation in Archon knowledge base
- Contact technical project manager

---

**Last Updated:** 2025-09-30
**Maintainer:** Technical Project Manager, ATLAS Data Science
