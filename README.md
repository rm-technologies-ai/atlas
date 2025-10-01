# Atlas

A meta-repository for the ATLAS Data Science (Lion/Paxium) project - aggregating multiple assets, projects, research, and repositories used during project execution.

## Overview

Atlas is an aggregation workspace that contains solutions, knowledge, and working spaces for various projects. It uses an iterative, ad-hoc hierarchical taxonomy with minimal scaffolding.

**Root Directory:** `E:\repos\atlas\` (Windows) or `/mnt/e/repos/atlas/` (WSL)

## Project Structure

Each subfolder is self-contained with its own tools, data, and potentially its own version control:

### `/issues/`
GitLab issue export tool for the `atlas-datascience/lion` group. Exports issues to CSV/XLSX for LLM/RAG processing.

See: [`issues/CLAUDE.md`](issues/CLAUDE.md) for detailed usage.

### Future Projects
Additional tools and cloned repositories will be added here as the project evolves.

## Documentation

- **[CLAUDE.md](CLAUDE.md)** - Guidance for Claude Code when working in this repository
- **[TODO.md](TODO.md)** - Current project task list
- **[issues/CLAUDE.md](issues/CLAUDE.md)** - GitLab issues tool documentation
- **[.env.atlas](.env.atlas)** - Environment variables and secrets (gitignored, local only)

## Repository Information

- **GitHub:** https://github.com/rm-technologies-ai/atlas (private)
- **Project:** ATLAS Data Science (Lion/Paxium) - brownfield platform
- **MVP Target:** December 2025

## Current Status

- ✅ Issues tool - GitLab export functionality
- 🔄 Archon - RAG/Graph solution (planned installation)
- 📋 Backlog analysis - Identifying missing PBIs for Lion MVP

## Quick Start

```bash
# Clone this repository
git clone https://github.com/rm-technologies-ai/atlas.git
cd atlas

# Export GitLab issues
cd issues
./list-issues-csv-with-text.sh
```

For detailed architecture and development context, see [CLAUDE.md](CLAUDE.md).
