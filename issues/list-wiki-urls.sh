#!/bin/bash
# List all GitLab wiki URLs from a group
# Discovers all projects in a group and checks if they have wikis enabled

set -euo pipefail

# Load environment variables from parent .env.atlas
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

# GitLab API endpoint
API_BASE="${GITLAB_HOST}/api/${GITLAB_API_VERSION}"

echo "Fetching projects from group: ${GITLAB_GROUP}"
echo "API Base: ${API_BASE}"
echo ""

# URL encode the group path
GROUP_ENCODED=$(echo -n "$GITLAB_GROUP" | jq -sRr @uri)

# Output files
WIKI_URLS_FILE="gitlab-wiki-urls.txt"
WIKI_URLS_JSON="gitlab-wiki-urls.json"

# Clear output files
> "$WIKI_URLS_FILE"
echo "[]" > "$WIKI_URLS_JSON"

# Fetch all projects in the group (with pagination)
page=1
per_page=100
total_projects=0
projects_with_wikis=0

echo "Discovering projects and wiki URLs..."
echo ""

while true; do
    response=$(curl -s --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
        "${API_BASE}/groups/${GROUP_ENCODED}/projects?per_page=${per_page}&page=${page}&include_subgroups=true")

    # Check if response is empty or error
    if [ -z "$response" ] || [ "$response" = "[]" ]; then
        break
    fi

    # Parse projects
    project_count=$(echo "$response" | jq '. | length')

    if [ "$project_count" -eq 0 ]; then
        break
    fi

    # Process each project
    for i in $(seq 0 $((project_count - 1))); do
        project_name=$(echo "$response" | jq -r ".[$i].name")
        project_path=$(echo "$response" | jq -r ".[$i].path_with_namespace")
        project_id=$(echo "$response" | jq -r ".[$i].id")
        wiki_enabled=$(echo "$response" | jq -r ".[$i].wiki_enabled")
        web_url=$(echo "$response" | jq -r ".[$i].web_url")

        total_projects=$((total_projects + 1))

        # Check if wiki is enabled
        if [ "$wiki_enabled" = "true" ]; then
            # Construct wiki URL
            wiki_url="${web_url}/-/wikis/home"

            # Check if wiki actually has content by fetching wiki pages
            wiki_pages=$(curl -s --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
                "${API_BASE}/projects/${project_id}/wikis" 2>/dev/null || echo "[]")

            page_count=$(echo "$wiki_pages" | jq '. | length' 2>/dev/null || echo "0")

            if [ "$page_count" -gt 0 ]; then
                projects_with_wikis=$((projects_with_wikis + 1))

                echo "✓ [$projects_with_wikis] ${project_path}"
                echo "  Wiki URL: ${wiki_url}"
                echo "  Pages: ${page_count}"

                # Save to text file
                echo "$wiki_url" >> "$WIKI_URLS_FILE"

                # Build JSON entry
                wiki_entry=$(jq -n \
                    --arg name "$project_name" \
                    --arg path "$project_path" \
                    --arg url "$wiki_url" \
                    --arg pages "$page_count" \
                    '{name: $name, path: $path, wiki_url: $url, page_count: ($pages | tonumber)}')

                # Append to JSON array
                jq --argjson entry "$wiki_entry" '. += [$entry]' "$WIKI_URLS_JSON" > "${WIKI_URLS_JSON}.tmp"
                mv "${WIKI_URLS_JSON}.tmp" "$WIKI_URLS_JSON"

                echo ""
            fi
        fi
    done

    page=$((page + 1))
done

echo "=================================================="
echo "Summary:"
echo "  Total projects scanned: ${total_projects}"
echo "  Projects with wikis: ${projects_with_wikis}"
echo ""
echo "Output files:"
echo "  - ${WIKI_URLS_FILE} (plain text URLs)"
echo "  - ${WIKI_URLS_JSON} (structured JSON)"
echo "=================================================="

if [ "$projects_with_wikis" -gt 0 ]; then
    echo ""
    echo "Next steps:"
    echo "1. Review the wiki URLs in ${WIKI_URLS_FILE}"
    echo "2. Import into Archon via web crawl or use the URLs for ingestion"
    echo "3. Run: cat ${WIKI_URLS_FILE} | while read url; do echo \"Crawl: \$url\"; done"
fi
