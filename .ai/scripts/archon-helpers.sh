#!/bin/bash
# Archon Task Management Helper Scripts for Atlas Project
# Usage: Source this file or run individual functions

# Atlas Project Configuration
export ATLAS_PROJECT_ID="3f2b6ee9-05ff-48ae-ad6f-54cad080addc"
export ARCHON_API_URL="http://localhost:8181"
export ARCHON_MCP_URL="http://localhost:8051"
export ARCHON_UI_URL="http://localhost:3737"

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper function to print colored output
print_color() {
    local color=$1
    shift
    echo -e "${color}$@${NC}"
}

# Check if Archon is running
archon_health_check() {
    print_color $BLUE "Checking Archon services..."

    # Check API
    if curl -s "$ARCHON_API_URL/health" > /dev/null 2>&1; then
        print_color $GREEN "✓ API Server running at $ARCHON_API_URL"
    else
        print_color $RED "✗ API Server not responding at $ARCHON_API_URL"
        return 1
    fi

    # Check MCP
    if curl -s "$ARCHON_MCP_URL/health" > /dev/null 2>&1; then
        print_color $GREEN "✓ MCP Server running at $ARCHON_MCP_URL"
    else
        print_color $RED "✗ MCP Server not responding at $ARCHON_MCP_URL"
        return 1
    fi

    print_color $BLUE "UI available at: $ARCHON_UI_URL"
    return 0
}

# List all Atlas tasks
archon_list_all() {
    print_color $BLUE "Fetching all Atlas project tasks..."
    curl -s "$ARCHON_API_URL/api/tasks?project_id=$ATLAS_PROJECT_ID&include_closed=true" | jq '.'
}

# List todo tasks
archon_todo() {
    print_color $BLUE "Fetching TODO tasks..."
    curl -s "$ARCHON_API_URL/api/tasks?project_id=$ATLAS_PROJECT_ID&status=todo&include_closed=false" | \
        jq -r '.tasks[] | "\(.id | .[0:8]) | Priority: \(.task_order) | \(.title)"'
}

# List in-progress tasks
archon_doing() {
    print_color $BLUE "Fetching IN-PROGRESS tasks..."
    curl -s "$ARCHON_API_URL/api/tasks?project_id=$ATLAS_PROJECT_ID&status=doing&include_closed=false" | \
        jq -r '.tasks[] | "\(.id | .[0:8]) | \(.assignee) | \(.title)"'
}

# List review tasks
archon_review() {
    print_color $BLUE "Fetching REVIEW tasks..."
    curl -s "$ARCHON_API_URL/api/tasks?project_id=$ATLAS_PROJECT_ID&status=review&include_closed=false" | \
        jq -r '.tasks[] | "\(.id | .[0:8]) | \(.assignee) | \(.title)"'
}

# List done tasks
archon_done() {
    print_color $BLUE "Fetching DONE tasks..."
    curl -s "$ARCHON_API_URL/api/tasks?project_id=$ATLAS_PROJECT_ID&status=done" | \
        jq -r '.tasks[] | "\(.id | .[0:8]) | \(.title)"'
}

# Task status summary
archon_status() {
    print_color $BLUE "=== Atlas Task Status Summary ==="

    local response=$(curl -s "$ARCHON_API_URL/api/tasks?project_id=$ATLAS_PROJECT_ID&include_closed=true")

    local todo_count=$(echo "$response" | jq '[.tasks[] | select(.status=="todo")] | length')
    local doing_count=$(echo "$response" | jq '[.tasks[] | select(.status=="doing")] | length')
    local review_count=$(echo "$response" | jq '[.tasks[] | select(.status=="review")] | length')
    local done_count=$(echo "$response" | jq '[.tasks[] | select(.status=="done")] | length')
    local total_count=$(echo "$response" | jq '.tasks | length')

    print_color $YELLOW "TODO:       $todo_count"
    print_color $BLUE "IN PROGRESS: $doing_count"
    print_color $YELLOW "REVIEW:     $review_count"
    print_color $GREEN "DONE:       $done_count"
    echo "-------------------"
    print_color $BLUE "TOTAL:      $total_count"
}

# Search tasks by keyword
archon_search() {
    if [ -z "$1" ]; then
        print_color $RED "Usage: archon_search <keyword>"
        return 1
    fi

    print_color $BLUE "Searching for: $1"
    curl -s "$ARCHON_API_URL/api/tasks?project_id=$ATLAS_PROJECT_ID&q=$1&include_closed=true" | \
        jq -r '.tasks[] | "\(.id | .[0:8]) | [\(.status)] \(.title)"'
}

# Get task by ID (first 8 chars accepted)
archon_get_task() {
    if [ -z "$1" ]; then
        print_color $RED "Usage: archon_get_task <task_id>"
        return 1
    fi

    local task_id=$1
    print_color $BLUE "Fetching task: $task_id"
    curl -s "$ARCHON_API_URL/api/tasks/$task_id" | jq '.'
}

# Update task status
archon_update_status() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        print_color $RED "Usage: archon_update_status <task_id> <status>"
        print_color $YELLOW "Valid statuses: todo, doing, review, done"
        return 1
    fi

    local task_id=$1
    local status=$2

    if [[ ! "$status" =~ ^(todo|doing|review|done)$ ]]; then
        print_color $RED "Invalid status: $status"
        print_color $YELLOW "Valid statuses: todo, doing, review, done"
        return 1
    fi

    print_color $BLUE "Updating task $task_id to status: $status"
    curl -s -X PUT "$ARCHON_API_URL/api/tasks/$task_id" \
        -H "Content-Type: application/json" \
        -d "{\"status\": \"$status\"}" | jq '.'
}

# Start working on a task (set to doing)
archon_start() {
    if [ -z "$1" ]; then
        print_color $RED "Usage: archon_start <task_id>"
        return 1
    fi

    archon_update_status "$1" "doing"
}

# Complete a task (set to done)
archon_complete() {
    if [ -z "$1" ]; then
        print_color $RED "Usage: archon_complete <task_id>"
        return 1
    fi

    archon_update_status "$1" "done"
}

# List tasks by feature
archon_feature() {
    if [ -z "$1" ]; then
        print_color $RED "Usage: archon_feature <feature_name>"
        return 1
    fi

    print_color $BLUE "Tasks for feature: $1"
    archon_search "$1"
}

# Create a new task
archon_create_task() {
    if [ -z "$1" ]; then
        print_color $RED "Usage: archon_create_task <title> [description] [feature] [priority]"
        return 1
    fi

    local title="$1"
    local description="${2:-}"
    local feature="${3:-}"
    local priority="${4:-50}"

    local json_payload=$(jq -n \
        --arg project_id "$ATLAS_PROJECT_ID" \
        --arg title "$title" \
        --arg description "$description" \
        --arg feature "$feature" \
        --argjson task_order "$priority" \
        '{
            project_id: $project_id,
            title: $title,
            description: $description,
            assignee: "User",
            task_order: $task_order,
            feature: $feature,
            sources: [],
            code_examples: []
        }')

    print_color $BLUE "Creating new task: $title"
    curl -s -X POST "$ARCHON_API_URL/api/tasks" \
        -H "Content-Type: application/json" \
        -d "$json_payload" | jq '.'
}

# Open Archon UI in browser
archon_ui() {
    print_color $BLUE "Opening Archon UI in browser..."

    if command -v xdg-open > /dev/null; then
        xdg-open "$ARCHON_UI_URL"
    elif command -v open > /dev/null; then
        open "$ARCHON_UI_URL"
    else
        print_color $YELLOW "Please open manually: $ARCHON_UI_URL"
    fi
}

# Show help
archon_help() {
    cat << 'EOF'
╔═══════════════════════════════════════════════════════════════╗
║          Archon Task Management Helper Commands              ║
╚═══════════════════════════════════════════════════════════════╝

Health & Status:
  archon_health_check    - Check if Archon services are running
  archon_status          - Show task count summary by status
  archon_ui              - Open Archon web UI in browser

Listing Tasks:
  archon_list_all        - List all tasks (JSON format)
  archon_todo            - List TODO tasks
  archon_doing           - List IN-PROGRESS tasks
  archon_review          - List REVIEW tasks
  archon_done            - List DONE tasks

Searching & Filtering:
  archon_search <keyword>      - Search tasks by keyword
  archon_feature <feature>     - List tasks by feature name
  archon_get_task <task_id>    - Get full task details

Managing Tasks:
  archon_create_task <title> [desc] [feature] [priority]
  archon_update_status <task_id> <status>
  archon_start <task_id>       - Mark task as in-progress
  archon_complete <task_id>    - Mark task as done

Configuration:
  ATLAS_PROJECT_ID = 3f2b6ee9-05ff-48ae-ad6f-54cad080addc
  ARCHON_API_URL   = http://localhost:8181
  ARCHON_MCP_URL   = http://localhost:8051
  ARCHON_UI_URL    = http://localhost:3737

Examples:
  archon_status
  archon_todo
  archon_search "authentication"
  archon_start abc12345
  archon_complete abc12345
  archon_create_task "Fix bug" "Description" "Feature Name" 100

EOF
}

# Aliases for convenience
alias archon='archon_help'
alias at-status='archon_status'
alias at-todo='archon_todo'
alias at-doing='archon_doing'
alias at-search='archon_search'
alias at-start='archon_start'
alias at-done='archon_complete'
alias at-ui='archon_ui'

# Print banner when sourced
print_color $GREEN "✓ Archon helpers loaded!"
print_color $BLUE "Type 'archon_help' or 'archon' for available commands"
print_color $BLUE "Quick aliases: at-status, at-todo, at-doing, at-search, at-start, at-done, at-ui"
