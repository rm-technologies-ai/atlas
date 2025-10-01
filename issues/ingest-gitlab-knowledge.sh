#!/bin/bash
# GitLab Knowledge Ingestion for Archon RAG/Graph
# Extracts wikis, issues, projects with metadata and relationships
# Outputs RAG-friendly CSV and Graph-friendly relationship files

set -euo pipefail

# Load environment variables
if [ -f "../.env.atlas" ]; then
    set -a
    source "../.env.atlas"
    set +a
fi

# Configuration
GITLAB_TOKEN="${GITLAB_TOKEN:-}"
GITLAB_HOST="${GITLAB_HOST:-https://gitlab.com}"
GITLAB_GROUP="${GITLAB_GROUP:-atlas-datascience/lion}"
GITLAB_API_VERSION="${GITLAB_API_VERSION:-v4}"

# Validate required variables
if [ -z "$GITLAB_TOKEN" ]; then
    echo "Error: GITLAB_TOKEN not set"
    exit 1
fi

API_BASE="${GITLAB_HOST}/api/${GITLAB_API_VERSION}"
GROUP_ENCODED=$(echo -n "$GITLAB_GROUP" | jq -sRr @uri)

# Output files
KNOWLEDGE_BASE_CSV="archon-knowledge-base.csv"
ENTITIES_CSV="archon-entities.csv"
RELATIONSHIPS_CSV="archon-relationships.csv"
METADATA_JSON="archon-metadata.json"

echo "============================================================"
echo "GitLab Knowledge Extraction for Archon RAG/Graph"
echo "============================================================"
echo "Group: ${GITLAB_GROUP}"
echo "API: ${API_BASE}"
echo ""

# Initialize output files
# Knowledge Base CSV (RAG-friendly: flat, denormalized, full-text optimized)
cat > "$KNOWLEDGE_BASE_CSV" << 'EOF'
entity_type,entity_id,entity_name,entity_path,content,full_text,metadata_json,source_url,created_at,updated_at,author,tags,relationships
EOF

# Entities CSV (Graph nodes)
cat > "$ENTITIES_CSV" << 'EOF'
entity_id,entity_type,name,path,description,url,created_at,updated_at,metadata_json
EOF

# Relationships CSV (Graph edges)
cat > "$RELATIONSHIPS_CSV" << 'EOF'
source_id,source_type,relationship_type,target_id,target_type,metadata_json
EOF

# Initialize metadata JSON
echo '{"projects": [], "wikis": [], "issues": [], "users": [], "statistics": {}}' > "$METADATA_JSON"

# Temporary files
TEMP_PROJECTS="/tmp/gitlab_projects_$$.json"
TEMP_WIKIS="/tmp/gitlab_wikis_$$.json"

# Statistics
total_projects=0
total_wikis=0
total_wiki_pages=0
total_issues=0
total_users=0
total_relationships=0

echo "Phase 1: Extracting Projects..."
echo "-----------------------------------------------------------"

# Fetch all projects in group
page=1
all_projects="[]"

while true; do
    response=$(curl -s --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
        "${API_BASE}/groups/${GROUP_ENCODED}/projects?per_page=100&page=${page}&include_subgroups=true&with_shared=false")

    if [ -z "$response" ] || [ "$response" = "[]" ]; then
        break
    fi

    project_count=$(echo "$response" | jq '. | length')
    if [ "$project_count" -eq 0 ]; then
        break
    fi

    all_projects=$(jq -s '.[0] + .[1]' <(echo "$all_projects") <(echo "$response"))
    total_projects=$((total_projects + project_count))

    echo "  Fetched page $page: $project_count projects"
    page=$((page + 1))
done

echo "$all_projects" > "$TEMP_PROJECTS"
echo "✓ Total projects extracted: $total_projects"
echo ""

echo "Phase 2: Extracting Wikis and Pages..."
echo "-----------------------------------------------------------"

wiki_data="[]"

for i in $(seq 0 $((total_projects - 1))); do
    project=$(jq ".[$i]" "$TEMP_PROJECTS")
    project_id=$(echo "$project" | jq -r '.id')
    project_name=$(echo "$project" | jq -r '.name')
    project_path=$(echo "$project" | jq -r '.path_with_namespace')
    project_url=$(echo "$project" | jq -r '.web_url')
    project_desc=$(echo "$project" | jq -r '.description // ""')
    wiki_enabled=$(echo "$project" | jq -r '.wiki_enabled')
    created_at=$(echo "$project" | jq -r '.created_at')

    echo "  [$((i+1))/$total_projects] $project_path"

    # Add project as entity
    project_metadata=$(echo "$project" | jq -c '{id, name, path: .path_with_namespace, namespace: .namespace.full_path, visibility: .visibility, default_branch, star_count, forks_count}')

    echo "\"project_${project_id}\",\"project\",\"$project_name\",\"$project_path\",\"$(echo "$project_desc" | sed 's/"/""/g')\",\"$project_url\",\"$created_at\",\"$created_at\",\"$(echo "$project_metadata" | sed 's/"/""/g')\"" >> "$ENTITIES_CSV"

    # Add project to knowledge base (RAG)
    full_text="Project: $project_name\nPath: $project_path\nDescription: $project_desc\nURL: $project_url"
    tags="project,gitlab,$(echo "$project_path" | cut -d'/' -f3-)"

    echo "\"project\",\"project_${project_id}\",\"$project_name\",\"$project_path\",\"$(echo "$project_desc" | sed 's/"/""/g')\",\"$(echo "$full_text" | sed 's/"/""/g')\",\"$(echo "$project_metadata" | sed 's/"/""/g')\",\"$project_url\",\"$created_at\",\"$created_at\",\"\",\"$tags\",\"\"" >> "$KNOWLEDGE_BASE_CSV"

    # Skip if wiki not enabled
    if [ "$wiki_enabled" != "true" ]; then
        continue
    fi

    # Fetch wiki pages
    wiki_pages=$(curl -s --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
        "${API_BASE}/projects/${project_id}/wikis" 2>/dev/null || echo "[]")

    page_count=$(echo "$wiki_pages" | jq '. | length' 2>/dev/null || echo "0")

    if [ "$page_count" -eq 0 ]; then
        continue
    fi

    total_wikis=$((total_wikis + 1))
    echo "    → Wiki found: $page_count pages"

    # Process each wiki page
    for j in $(seq 0 $((page_count - 1))); do
        wiki_page=$(echo "$wiki_pages" | jq ".[$j]")
        page_slug=$(echo "$wiki_page" | jq -r '.slug')
        page_title=$(echo "$wiki_page" | jq -r '.title')

        # Fetch full wiki page content
        wiki_content=$(curl -s --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
            "${API_BASE}/projects/${project_id}/wikis/${page_slug}" 2>/dev/null || echo "{}")

        content=$(echo "$wiki_content" | jq -r '.content // ""')
        format=$(echo "$wiki_content" | jq -r '.format // "markdown"')
        wiki_url="${project_url}/-/wikis/${page_slug}"

        # Add wiki page as entity
        wiki_page_id="wiki_${project_id}_${page_slug}"
        wiki_metadata=$(jq -n \
            --arg project_id "$project_id" \
            --arg project_path "$project_path" \
            --arg slug "$page_slug" \
            --arg format "$format" \
            '{project_id: $project_id, project_path: $project_path, slug: $slug, format: $format}')

        echo "\"$wiki_page_id\",\"wiki_page\",\"$page_title\",\"$project_path/wiki/$page_slug\",\"Wiki page in $project_name\",\"$wiki_url\",\"$created_at\",\"$created_at\",\"$(echo "$wiki_metadata" | sed 's/"/""/g')\"" >> "$ENTITIES_CSV"

        # Add wiki page to knowledge base (RAG)
        full_text="Wiki Page: $page_title\nProject: $project_name ($project_path)\nContent:\n$content"
        tags="wiki,documentation,$format,$(echo "$project_path" | cut -d'/' -f3-)"

        echo "\"wiki_page\",\"$wiki_page_id\",\"$page_title\",\"$project_path/wiki/$page_slug\",\"$(echo "$content" | sed 's/"/""/g' | tr '\n' ' ')\",\"$(echo "$full_text" | sed 's/"/""/g' | tr '\n' ' ')\",\"$(echo "$wiki_metadata" | sed 's/"/""/g')\",\"$wiki_url\",\"$created_at\",\"$created_at\",\"\",\"$tags\",\"project_${project_id}\"" >> "$KNOWLEDGE_BASE_CSV"

        # Add relationship: wiki_page -> belongs_to -> project
        echo "\"$wiki_page_id\",\"wiki_page\",\"belongs_to\",\"project_${project_id}\",\"project\",\"{}\"" >> "$RELATIONSHIPS_CSV"
        total_relationships=$((total_relationships + 1))

        total_wiki_pages=$((total_wiki_pages + 1))
    done
done

echo "✓ Total wikis: $total_wikis"
echo "✓ Total wiki pages: $total_wiki_pages"
echo ""

echo "Phase 3: Enriching with Issue Data..."
echo "-----------------------------------------------------------"

# Check if issues CSV exists
if [ -f "gitlab-issues-with-text.csv" ]; then
    echo "  Using existing gitlab-issues-with-text.csv"

    # Parse existing issues and add to entities/relationships
    tail -n +2 "gitlab-issues-with-text.csv" | while IFS=, read -r project project_id issue_iid issue_id title state author assignees labels milestone created_at updated_at due_date weight confidential web_url full_text; do
        # Remove quotes
        project=$(echo "$project" | sed 's/^"//;s/"$//')
        issue_id=$(echo "$issue_id" | sed 's/^"//;s/"$//')
        title=$(echo "$title" | sed 's/^"//;s/"$//')
        author=$(echo "$author" | sed 's/^"//;s/"$//')
        web_url=$(echo "$web_url" | sed 's/^"//;s/"$//')

        # Add issue as entity
        issue_metadata=$(jq -n \
            --arg project "$project" \
            --arg state "$state" \
            --arg labels "$labels" \
            --arg milestone "$milestone" \
            '{project: $project, state: $state, labels: $labels, milestone: $milestone}')

        echo "\"issue_${issue_id}\",\"issue\",\"$title\",\"$project\",\"Issue in project\",\"$web_url\",\"$created_at\",\"$updated_at\",\"$(echo "$issue_metadata" | sed 's/"/""/g')\"" >> "$ENTITIES_CSV"

        # Add issue to knowledge base (RAG)
        tags="issue,$state,$(echo "$labels" | sed 's/,/,issue-/g')"
        echo "\"issue\",\"issue_${issue_id}\",\"$title\",\"$project\",\"$full_text\",\"$full_text\",\"$(echo "$issue_metadata" | sed 's/"/""/g')\",\"$web_url\",\"$created_at\",\"$updated_at\",\"$author\",\"$tags\",\"project_${project_id}\"" >> "$KNOWLEDGE_BASE_CSV"

        # Find matching project and create relationship
        if grep -q "\"project_${project_id}\"" "$ENTITIES_CSV"; then
            echo "\"issue_${issue_id}\",\"issue\",\"belongs_to\",\"project_${project_id}\",\"project\",\"{}\"" >> "$RELATIONSHIPS_CSV"
            total_relationships=$((total_relationships + 1))
        fi

        total_issues=$((total_issues + 1))
    done

    echo "✓ Processed $total_issues issues"
else
    echo "  ⚠ gitlab-issues-with-text.csv not found - skipping issue enrichment"
fi
echo ""

echo "Phase 4: Building Metadata Summary..."
echo "-----------------------------------------------------------"

# Build comprehensive metadata JSON
jq -n \
    --argjson projects "$(cat "$TEMP_PROJECTS")" \
    --arg total_projects "$total_projects" \
    --arg total_wikis "$total_wikis" \
    --arg total_wiki_pages "$total_wiki_pages" \
    --arg total_issues "$total_issues" \
    --arg total_relationships "$total_relationships" \
    '{
        statistics: {
            total_projects: ($total_projects | tonumber),
            total_wikis: ($total_wikis | tonumber),
            total_wiki_pages: ($total_wiki_pages | tonumber),
            total_issues: ($total_issues | tonumber),
            total_relationships: ($total_relationships | tonumber),
            extracted_at: (now | strftime("%Y-%m-%dT%H:%M:%SZ"))
        },
        projects: $projects,
        gitlab_group: "'"$GITLAB_GROUP"'",
        gitlab_host: "'"$GITLAB_HOST"'"
    }' > "$METADATA_JSON"

echo "✓ Metadata saved"
echo ""

# Cleanup
rm -f "$TEMP_PROJECTS" "$TEMP_WIKIS"

echo "============================================================"
echo "Extraction Complete!"
echo "============================================================"
echo ""
echo "Statistics:"
echo "  Projects:      $total_projects"
echo "  Wikis:         $total_wikis"
echo "  Wiki Pages:    $total_wiki_pages"
echo "  Issues:        $total_issues"
echo "  Relationships: $total_relationships"
echo ""
echo "Output Files (Ready for Archon Ingestion):"
echo "  1. $KNOWLEDGE_BASE_CSV"
echo "     → RAG-friendly: Denormalized, full-text optimized"
echo "     → Columns: entity_type, entity_id, name, path, content, full_text, metadata, url, dates, tags, relationships"
echo ""
echo "  2. $ENTITIES_CSV"
echo "     → Graph nodes: Projects, wikis, issues"
echo "     → Columns: entity_id, type, name, path, description, url, dates, metadata"
echo ""
echo "  3. $RELATIONSHIPS_CSV"
echo "     → Graph edges: belongs_to, authored_by, assigned_to, etc."
echo "     → Columns: source_id, source_type, relationship, target_id, target_type, metadata"
echo ""
echo "  4. $METADATA_JSON"
echo "     → Complete extraction metadata and statistics"
echo ""
echo "Next Steps:"
echo "  1. Review extracted data: head -20 $KNOWLEDGE_BASE_CSV"
echo "  2. Import to Archon via API or UI"
echo "  3. Validate knowledge base queries"
echo "============================================================"
