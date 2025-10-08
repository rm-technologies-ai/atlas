#!/bin/bash
# Archon Task Restore Tool
# Deserializes tasks from JSON backup and upserts into Archon
# Called by /roy-tasks-restore command

set -euo pipefail

# Configuration
ARCHON_API="${ARCHON_API:-http://localhost:8181}"

# Validate input
if [ $# -ne 1 ]; then
    echo "Usage: $0 <backup-directory>"
    exit 1
fi

backup_dir="$1"

# Check if backup directory exists
if [ ! -d "$backup_dir" ]; then
    echo "Error: Backup directory not found: $backup_dir"
    exit 1
fi

# Check if Archon is accessible
if ! curl -s "${ARCHON_API}/health" > /dev/null 2>&1; then
    echo "Error: Archon API not accessible at ${ARCHON_API}"
    echo "Start Archon: cd /mnt/e/repos/atlas/archon && docker compose up -d"
    exit 1
fi

echo "============================================================"
echo "Archon Task Restore"
echo "============================================================"
echo "API: ${ARCHON_API}"
echo "Backup: $backup_dir"
echo ""

# Count task files
task_files=$(find "$backup_dir" -name "task_*.json" | sort)
task_count=$(echo "$task_files" | wc -l)

if [ "$task_count" -eq 0 ]; then
    echo "Error: No task files found in backup directory"
    exit 1
fi

echo "Found $task_count task files to restore"
echo ""

# Restore each task
echo "Restoring tasks to Archon..."
restored_count=0
failed_count=0

i=1
while IFS= read -r task_file; do
    task_data=$(cat "$task_file")
    task_title=$(echo "$task_data" | jq -r '.title // "untitled"')

    # Remove 'id' field if present (let Archon assign new ID)
    task_payload=$(echo "$task_data" | jq 'del(.id)')

    # Upsert task to Archon
    response=$(curl -s -X POST "${ARCHON_API}/api/tasks" \
        -H "Content-Type: application/json" \
        -d "$task_payload" 2>/dev/null || echo '{"error": true}')

    if echo "$response" | jq -e '.error' > /dev/null 2>&1; then
        echo "  ✗ [$i/$task_count] Failed: $task_title"
        failed_count=$((failed_count + 1))
    else
        echo "  ✓ [$i/$task_count] $task_title"
        restored_count=$((restored_count + 1))
    fi

    i=$((i + 1))
    sleep 0.1  # Rate limiting
done <<< "$task_files"

echo ""
echo "============================================================"
echo "Restore Complete!"
echo "============================================================"
echo ""
echo "Statistics:"
echo "  Tasks restored: $restored_count"
echo "  Failed: $failed_count"
echo "  Total in backup: $task_count"
echo ""
if [ "$failed_count" -gt 0 ]; then
    echo "⚠ Some tasks failed to restore. Check Archon logs for details."
fi
echo "============================================================"
