# Atlas Scripts

Utility scripts for Atlas project automation.

## archon-helpers.sh

Bash helper functions for Archon task management.

### Installation

```bash
# Add to your shell profile (~/.bashrc or ~/.zshrc)
source /mnt/e/repos/atlas/.ai/scripts/archon-helpers.sh
```

### Quick Start

```bash
# Source the helpers
source .ai/scripts/archon-helpers.sh

# Check Archon is running
archon_health_check

# View status summary
archon_status

# List todo tasks
archon_todo

# Start working on a task
archon_start abc12345

# Complete a task
archon_complete abc12345
```

### Available Commands

See all commands:
```bash
archon_help
```

**Health & Status:**
- `archon_health_check` - Check Archon services
- `archon_status` - Task count summary
- `archon_ui` - Open web UI

**Listing Tasks:**
- `archon_todo` - TODO tasks
- `archon_doing` - In-progress tasks
- `archon_review` - Review tasks
- `archon_done` - Done tasks

**Search & Filter:**
- `archon_search <keyword>` - Search tasks
- `archon_feature <name>` - Tasks by feature
- `archon_get_task <id>` - Get task details

**Managing Tasks:**
- `archon_create_task <title> [desc] [feature] [priority]`
- `archon_update_status <id> <status>`
- `archon_start <id>` - Mark as in-progress
- `archon_complete <id>` - Mark as done

### Quick Aliases

- `archon` - Show help
- `at-status` - Task status summary
- `at-todo` - List TODO tasks
- `at-doing` - List in-progress tasks
- `at-search` - Search tasks
- `at-start` - Start task
- `at-done` - Complete task
- `at-ui` - Open UI

### Examples

```bash
# Check status
at-status

# Find authentication tasks
at-search authentication

# Start working on task
at-start acf264b7

# Complete task
at-done acf264b7

# Open web UI
at-ui
```

### Configuration

Edit these variables in the script if needed:
- `ATLAS_PROJECT_ID` - Atlas project UUID
- `ARCHON_API_URL` - API server URL
- `ARCHON_MCP_URL` - MCP server URL
- `ARCHON_UI_URL` - Web UI URL
