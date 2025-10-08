#!/bin/bash
# Archon Task Backup Tool
# Serializes all Archon tasks to timestamped JSON backup
# Called by /roy-tasks-clear --backup command

set -euo pipefail

# Configuration
ARCHON_API="${ARCHON_API:-http://localhost:8181}"
BACKUP_ROOT="/mnt/e/repos/atlas/.roy/backups/archon/tasks"

# Get current timestamp in Eastern Time
get_eastern_timestamp() {
    TZ="America/New_York" date '+%Y%m%d-%H%M%S-%Z'
}

# Check if Archon is accessible
if ! curl -s "${ARCHON_API}/health" > /dev/null 2>&1; then
    echo "Error: Archon API not accessible at ${ARCHON_API}"
    echo "Start Archon: cd /mnt/e/repos/atlas/archon && docker compose up -d"
    exit 1
fi

echo "============================================================"
echo "Archon Task Backup"
echo "============================================================"
echo "API: ${ARCHON_API}"
echo ""

# Create backup directory with timestamp
timestamp=$(get_eastern_timestamp)
backup_dir="${BACKUP_ROOT}/archon-tasks-${timestamp}"
mkdir -p "$backup_dir"

echo "Backup directory: $backup_dir"
echo ""

# Fetch all tasks from Archon
echo "Fetching all tasks from Archon..."
tasks_response=$(curl -s "${ARCHON_API}/api/tasks" || echo '[]')

# Check if response is valid JSON array
if ! echo "$tasks_response" | jq -e '. | type == "array"' > /dev/null 2>&1; then
    echo "Error: Failed to fetch tasks from Archon (invalid response)"
    exit 1
fi

task_count=$(echo "$tasks_response" | jq '. | length')

if [ "$task_count" -eq 0 ]; then
    echo "No tasks found in Archon. Nothing to backup."
    rmdir "$backup_dir" 2>/dev/null || true
    exit 0
fi

echo "Found $task_count tasks"
echo ""

# Serialize each task to individual JSON file
echo "Serializing tasks to JSON files..."
for i in $(seq 0 $((task_count - 1))); do
    task=$(echo "$tasks_response" | jq ".[$i]")
    task_id=$(echo "$task" | jq -r '.id // "unknown"')
    task_title=$(echo "$task" | jq -r '.title // "untitled"' | tr '/' '_' | cut -c1-50)

    # Auto-numbered filename with task title hint
    filename=$(printf "task_%04d_%s.json" $((i + 1)) "$task_title")

    echo "$task" | jq '.' > "$backup_dir/$filename"

    echo "  ✓ [$((i + 1))/$task_count] $task_title"
done

echo ""
echo "============================================================"
echo "Backup Complete!"
echo "============================================================"
echo ""
echo "Statistics:"
echo "  Tasks backed up: $task_count"
echo "  Backup location: $backup_dir"
echo "  Timestamp: $timestamp"
echo ""
echo "Restore command:"
echo "  /roy-tasks-restore"
echo "============================================================"
