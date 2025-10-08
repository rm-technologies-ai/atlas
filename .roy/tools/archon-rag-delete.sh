#!/bin/bash
# Archon RAG Delete Tool
# Deletes RAG records by ingest set or all records
# Called by /roy-rag-delete command

set -euo pipefail

# Configuration
ARCHON_API="${ARCHON_API:-http://localhost:8181}"

# Parse arguments
mode=""
ingest_set=""

if [ $# -eq 0 ]; then
    echo "Usage: $0 <--ingest-set:name | --force>"
    exit 1
fi

for arg in "$@"; do
    case $arg in
        --force)
            mode="force"
            ;;
        --ingest-set:*)
            mode="ingest-set"
            ingest_set="${arg#*:}"
            ;;
        *)
            echo "Error: Invalid argument '$arg'"
            echo "Usage: $0 <--ingest-set:name | --force>"
            exit 1
            ;;
    esac
done

# Validate exactly one mode
if [ -z "$mode" ]; then
    echo "Error: Must specify either --ingest-set:<name> or --force"
    exit 1
fi

# Check if Archon is accessible
if ! curl -s "${ARCHON_API}/health" > /dev/null 2>&1; then
    echo "Error: Archon API not accessible at ${ARCHON_API}"
    echo "Start Archon: cd /mnt/e/repos/atlas/archon && docker compose up -d"
    exit 1
fi

echo "============================================================"
echo "Archon RAG Delete"
echo "============================================================"
echo "API: ${ARCHON_API}"

if [ "$mode" = "force" ]; then
    echo "Mode: DELETE ALL RAG RECORDS (FORCE)"
else
    echo "Mode: Delete ingest set '$ingest_set'"
fi

echo ""

# Fetch current RAG sources/records
echo "Fetching current RAG sources..."
sources_response=$(curl -s "${ARCHON_API}/api/sources" || echo '[]')

if ! echo "$sources_response" | jq -e '. | type == "array"' > /dev/null 2>&1; then
    echo "Error: Failed to fetch sources from Archon (invalid response)"
    exit 1
fi

total_sources=$(echo "$sources_response" | jq '. | length')
echo "Total sources in RAG: $total_sources"
echo ""

# Filter sources based on mode
if [ "$mode" = "force" ]; then
    sources_to_delete="$sources_response"
    delete_count=$total_sources
else
    # Filter by ingest set (assuming sources have tags or metadata indicating ingest set)
    # NOTE: This implementation assumes sources are tagged with ingest set name
    # Adjust filter logic based on actual Archon schema
    sources_to_delete=$(echo "$sources_response" | jq --arg set "$ingest_set" '[.[] | select(.tags[]? == $set or .url | contains($set))]')
    delete_count=$(echo "$sources_to_delete" | jq '. | length')

    echo "Sources matching ingest set '$ingest_set': $delete_count"

    if [ "$delete_count" -eq 0 ]; then
        echo "No sources found for ingest set '$ingest_set'. Nothing to delete."
        exit 0
    fi
fi

echo ""
echo "Deleting $delete_count RAG sources..."

# Delete each source
deleted_count=0
failed_count=0

for i in $(seq 0 $((delete_count - 1))); do
    source=$(echo "$sources_to_delete" | jq ".[$i]")
    source_id=$(echo "$source" | jq -r '.id // ""')
    source_title=$(echo "$source" | jq -r '.title // "untitled"')

    if [ -z "$source_id" ]; then
        echo "  ✗ [$((i + 1))/$delete_count] No ID: $source_title"
        failed_count=$((failed_count + 1))
        continue
    fi

    # Delete source via API
    response=$(curl -s -X DELETE "${ARCHON_API}/api/sources/${source_id}" 2>/dev/null || echo '{"error": true}')

    if echo "$response" | jq -e '.error' > /dev/null 2>&1; then
        echo "  ✗ [$((i + 1))/$delete_count] Failed: $source_title"
        failed_count=$((failed_count + 1))
    else
        echo "  ✓ [$((i + 1))/$delete_count] Deleted: $source_title"
        deleted_count=$((deleted_count + 1))
    fi

    sleep 0.05  # Rate limiting
done

echo ""
echo "============================================================"
echo "Delete Complete!"
echo "============================================================"
echo ""
echo "Statistics:"
echo "  Sources deleted: $deleted_count"
echo "  Failed: $failed_count"
echo "  Total attempted: $delete_count"
echo ""
if [ "$failed_count" -gt 0 ]; then
    echo "⚠ Some sources failed to delete. Check Archon logs for details."
fi
echo "============================================================"
