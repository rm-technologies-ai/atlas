#!/bin/bash
# Upload extracted GitLab knowledge to Archon
# Converts CSV data to Archon-compatible format and uploads via API

set -euo pipefail

# Configuration
ARCHON_API="http://localhost:8181"
KNOWLEDGE_CSV="archon-knowledge-base.csv"
ENTITIES_CSV="archon-entities.csv"
RELATIONSHIPS_CSV="archon-relationships.csv"

# Check if Archon is running
if ! curl -s "${ARCHON_API}/health" > /dev/null 2>&1; then
    echo "Error: Archon API not accessible at ${ARCHON_API}"
    echo "Start Archon: cd /mnt/e/repos/atlas/archon && docker compose up -d"
    exit 1
fi

echo "============================================================"
echo "Uploading GitLab Knowledge to Archon"
echo "============================================================"
echo "API: ${ARCHON_API}"
echo ""

# Check if extraction files exist
if [ ! -f "$KNOWLEDGE_CSV" ]; then
    echo "Error: $KNOWLEDGE_CSV not found"
    echo "Run: ./ingest-gitlab-knowledge.sh first"
    exit 1
fi

echo "Phase 1: Creating Archon Project for Lion..."
echo "-----------------------------------------------------------"

# Create or get Lion project in Archon
PROJECT_RESPONSE=$(curl -s -X POST "${ARCHON_API}/api/projects" \
    -H "Content-Type: application/json" \
    -d '{
        "title": "Lion Platform",
        "github_repo": "https://gitlab.com/atlas-datascience/lion",
        "description": "ATLAS Data Science (Lion/Paxium) - brownfield commercial data science platform",
        "features": ["Edge Connector", "Enrichment", "Catalog", "Access Broker", "Policies", "SDK", "API", "Web UI"]
    }' 2>/dev/null || echo '{"error": "Project may already exist"}')

PROJECT_ID=$(echo "$PROJECT_RESPONSE" | jq -r '.id // "existing"')
echo "✓ Project ID: $PROJECT_ID"
echo ""

echo "Phase 2: Uploading Knowledge Base Documents..."
echo "-----------------------------------------------------------"

# Process knowledge base CSV and upload as documents
uploaded_count=0
failed_count=0

# Read CSV line by line (skip header)
tail -n +2 "$KNOWLEDGE_CSV" | while IFS=, read -r entity_type entity_id entity_name entity_path content full_text metadata_json source_url created_at updated_at author tags relationships; do
    # Remove quotes
    entity_type=$(echo "$entity_type" | sed 's/^"//;s/"$//')
    entity_name=$(echo "$entity_name" | sed 's/^"//;s/"$//')
    full_text=$(echo "$full_text" | sed 's/^"//;s/"$//')
    source_url=$(echo "$source_url" | sed 's/^"//;s/"$//')
    tags=$(echo "$tags" | sed 's/^"//;s/"$//')

    # Skip if empty content
    if [ -z "$full_text" ] || [ "$full_text" = "null" ]; then
        continue
    fi

    # Prepare document for Archon
    doc_title="[$entity_type] $entity_name"

    # Upload as crawled source/document
    response=$(curl -s -X POST "${ARCHON_API}/api/sources" \
        -H "Content-Type: application/json" \
        -d "$(jq -n \
            --arg url "$source_url" \
            --arg title "$doc_title" \
            --arg content "$full_text" \
            --arg tags "$tags" \
            '{
                url: $url,
                source_type: "manual_upload",
                title: $title,
                content: $content,
                tags: ($tags | split(",")),
                status: "completed"
            }')" 2>/dev/null || echo '{"error": true}')

    if echo "$response" | jq -e '.error' > /dev/null 2>&1; then
        failed_count=$((failed_count + 1))
    else
        uploaded_count=$((uploaded_count + 1))
        echo "  ✓ [$uploaded_count] $doc_title"
    fi

    # Rate limit
    sleep 0.1
done

echo "✓ Uploaded $uploaded_count documents"
if [ "$failed_count" -gt 0 ]; then
    echo "⚠ Failed: $failed_count documents"
fi
echo ""

echo "Phase 3: Processing Wiki Pages..."
echo "-----------------------------------------------------------"

# Upload wiki pages separately for better chunking
wiki_count=0

tail -n +2 "$KNOWLEDGE_CSV" | grep '^"wiki_page"' | while IFS=, read -r entity_type entity_id entity_name entity_path content full_text metadata_json source_url created_at updated_at author tags relationships; do
    entity_name=$(echo "$entity_name" | sed 's/^"//;s/"$//')
    full_text=$(echo "$full_text" | sed 's/^"//;s/"$//')
    source_url=$(echo "$source_url" | sed 's/^"//;s/"$//')

    # Upload wiki page
    curl -s -X POST "${ARCHON_API}/api/sources/crawl" \
        -H "Content-Type: application/json" \
        -d "$(jq -n \
            --arg url "$source_url" \
            --arg title "$entity_name" \
            '{
                url: $url,
                max_depth: 1,
                max_pages: 1
            }')" > /dev/null 2>&1

    wiki_count=$((wiki_count + 1))
    echo "  ✓ [$wiki_count] Wiki: $entity_name"

    sleep 0.5
done

echo "✓ Initiated $wiki_count wiki crawls"
echo ""

echo "============================================================"
echo "Upload Complete!"
echo "============================================================"
echo ""
echo "Statistics:"
echo "  Documents uploaded: $uploaded_count"
echo "  Wiki pages crawled: $wiki_count"
echo "  Failed uploads: $failed_count"
echo ""
echo "Next Steps:"
echo "  1. Open Archon UI: http://localhost:3737"
echo "  2. Check Knowledge Base → Sources"
echo "  3. Monitor crawl progress"
echo "  4. Test RAG queries:"
echo "     - 'Tell me about Lion architecture'"
echo "     - 'What are the Lion platform components?'"
echo "     - 'Explain Edge Connector functionality'"
echo "============================================================"
