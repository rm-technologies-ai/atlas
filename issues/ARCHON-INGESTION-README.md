# Archon Knowledge Ingestion - Complete Guide

## Overview

This directory contains automated tools for extracting GitLab knowledge (projects, wikis, issues) and ingesting it into Archon for RAG/Graph-based AI assistance.

## Architecture

### Data Flow

```
GitLab Group (atlas-datascience/lion)
    ↓
[ingest-gitlab-knowledge.sh] ← Extraction & Enrichment
    ↓
    ├─→ archon-knowledge-base.csv    (RAG-friendly: denormalized full-text)
    ├─→ archon-entities.csv          (Graph nodes: projects, wikis, issues)
    ├─→ archon-relationships.csv     (Graph edges: belongs_to, references)
    └─→ archon-metadata.json         (Statistics & metadata)
    ↓
[upload-to-archon.sh] ← API Upload
    ↓
Archon Knowledge Base (Supabase + pgvector)
    ↓
Claude Code (MCP queries)
```

### File Structure

```
issues/
├── ingest-gitlab-knowledge.sh      # Main extraction script
├── upload-to-archon.sh             # Archon API upload script
├── list-wiki-urls.sh               # Wiki discovery utility
├── ARCHON-INGESTION-README.md      # This file
├── WIKI-INGESTION-GUIDE.md         # Wiki-specific guide
│
├── archon-knowledge-base.csv       # RAG-optimized flat format
├── archon-entities.csv             # Graph nodes
├── archon-relationships.csv        # Graph edges
├── archon-metadata.json            # Extraction stats
│
├── gitlab-issues-with-text.csv     # Issue export (existing)
└── gitlab-wiki-urls.txt            # Discovered wiki URLs
```

## Data Schema

### 1. Knowledge Base CSV (RAG-Friendly)

**Purpose:** Optimized for semantic search and full-text RAG queries

**Columns:**
- `entity_type` - Type: project, wiki_page, issue
- `entity_id` - Unique identifier
- `entity_name` - Human-readable name
- `entity_path` - GitLab path/namespace
- `content` - Raw content (markdown, text)
- `full_text` - Enriched full-text for embeddings (title + context + content)
- `metadata_json` - Structured metadata (JSON)
- `source_url` - Original GitLab URL
- `created_at`, `updated_at` - Timestamps
- `author` - Creator/author
- `tags` - Comma-separated tags for filtering
- `relationships` - Related entity IDs

**Example:**
```csv
"wiki_page","wiki_71509248_Lion-Software-Development","Lion Software Development","atlas-datascience/lion/devops/wiki","# Lion Development\n...","Wiki Page: Lion Software Development\nProject: devops\nContent: # Lion Development...","{}","https://gitlab.com/...","2025-06-09","2025-06-09","","wiki,documentation,markdown","project_71509248"
```

### 2. Entities CSV (Graph Nodes)

**Purpose:** Graph database nodes representing distinct entities

**Columns:**
- `entity_id` - Unique node ID
- `entity_type` - Node type (project, wiki_page, issue, user)
- `name` - Display name
- `path` - Hierarchical path
- `description` - Brief description
- `url` - Web URL
- `created_at`, `updated_at` - Timestamps
- `metadata_json` - Type-specific metadata

**Example:**
```csv
"project_74557728","project","paxium-access-broker","atlas-datascience/lion/project-lion/paxium-access-broker","Access broker component","https://gitlab.com/...","2025-09-18","2025-09-18","{\"visibility\":\"private\",\"default_branch\":\"main\"}"
```

### 3. Relationships CSV (Graph Edges)

**Purpose:** Graph database edges representing relationships

**Columns:**
- `source_id` - Source entity ID
- `source_type` - Source entity type
- `relationship_type` - Relationship: belongs_to, authored_by, references, depends_on
- `target_id` - Target entity ID
- `target_type` - Target entity type
- `metadata_json` - Relationship metadata

**Example:**
```csv
"wiki_71509248_Lion-Software-Development","wiki_page","belongs_to","project_71509248","project","{}"
```

**Relationship Types:**
- `belongs_to` - Wiki page belongs to project, Issue belongs to project
- `authored_by` - Entity created by user
- `assigned_to` - Issue assigned to user
- `references` - Issue references another issue
- `depends_on` - Project depends on another project

## Environment Variables

All required variables are in `/mnt/e/repos/atlas/.env.atlas`:

```bash
GITLAB_TOKEN=glpat-...              # GitLab personal access token
GITLAB_HOST=https://gitlab.com      # GitLab instance
GITLAB_GROUP=atlas-datascience/lion # Group to extract
```

## Usage

### Step 1: Extract GitLab Knowledge

```bash
cd /mnt/e/repos/atlas/issues

# Run extraction (takes 2-5 minutes)
./ingest-gitlab-knowledge.sh
```

**Output:**
```
Phase 1: Extracting Projects... (106 projects)
Phase 2: Extracting Wikis and Pages... (2 wikis, 4 pages)
Phase 3: Enriching with Issue Data... (302 issues)
Phase 4: Building Metadata Summary...

Extraction Complete!
  Projects:      106
  Wikis:         2
  Wiki Pages:    4
  Issues:        302
  Relationships: 4
```

### Step 2: Review Extracted Data

```bash
# Preview knowledge base
head -5 archon-knowledge-base.csv

# Check statistics
cat archon-metadata.json | jq '.statistics'

# View relationships
cat archon-relationships.csv
```

### Step 3: Upload to Archon

```bash
# Ensure Archon is running
cd /mnt/e/repos/atlas/archon && docker compose up -d

# Upload extracted knowledge
cd /mnt/e/repos/atlas/issues
chmod +x upload-to-archon.sh
./upload-to-archon.sh
```

**Output:**
```
Phase 1: Creating Archon Project for Lion...
✓ Project ID: <project_id>

Phase 2: Uploading Knowledge Base Documents...
  ✓ [1] [project] paxium-access-broker
  ✓ [2] [wiki_page] Lion Software Development
  ...
✓ Uploaded 108 documents

Phase 3: Processing Wiki Pages...
  ✓ [1] Wiki: Lion Software Development
  ...
✓ Initiated 4 wiki crawls

Upload Complete!
```

### Step 4: Validate Ingestion

1. **Open Archon UI:** http://localhost:3737
2. **Check Knowledge Base → Sources**
   - Verify 108+ sources
   - Check crawl status (should be "completed")
3. **Test RAG Queries** (via UI or Claude Code MCP):
   ```
   "Tell me about Lion architecture"
   "What are the Edge Connector components?"
   "Explain the Enrichment pipeline"
   "What is the Access Broker?"
   ```

## Metadata Enrichment

The extraction script enriches data with:

### Project Metadata
- Namespace hierarchy
- Visibility (private/public)
- Default branch
- Star count, fork count
- Creation/update timestamps

### Wiki Page Metadata
- Parent project
- Page slug
- Format (markdown, rdoc, etc.)
- Content with context

### Issue Metadata
- State (open/closed)
- Author, assignees
- Labels, milestone
- Complete conversation history

### Relationship Discovery
- Wiki pages → Projects
- Issues → Projects
- (Future) Issues → Users (authored_by, assigned_to)
- (Future) Cross-references between issues

## Advanced Usage

### Custom Filtering

Extract specific project types:

```bash
# Modify ingest-gitlab-knowledge.sh
# Add filter in Phase 1:
| jq '.[] | select(.path | contains("project-lion"))'
```

### Additional Relationships

Add user relationships:

```bash
# In Phase 3, add:
# Extract unique authors/assignees
# Create user entities
# Add authored_by and assigned_to relationships
```

### Graph Database Import

For Neo4j or other graph databases:

```bash
# Convert to Cypher
./convert-to-cypher.sh archon-entities.csv archon-relationships.csv > import.cypher

# Import to Neo4j
cat import.cypher | cypher-shell -u neo4j -p password
```

## Integration with Archon

### RAG Queries

Archon automatically:
1. Chunks long documents (wiki pages, issue threads)
2. Generates embeddings (OpenAI/Gemini)
3. Stores in Supabase pgvector
4. Enables semantic search

**Query via Claude Code MCP:**
```
archon:rag_search_knowledge_base(
  query="Lion system architecture components",
  match_count=5
)
```

### Task Management

Create tasks based on extracted issues:

```
archon:manage_task(
  action="create",
  project_id="<lion_project_id>",
  title="Implement Edge Connector",
  description="Based on GitLab issue #123",
  feature="Edge Connector"
)
```

## Troubleshooting

### Issue: GitLab API Rate Limiting

**Solution:**
```bash
# Add delays in extraction script
sleep 0.5  # Between API calls
```

### Issue: Large Wiki Pages

**Solution:**
```bash
# Archon automatically chunks large documents
# Adjust max chunk size in Archon settings
```

### Issue: Missing Relationships

**Solution:**
```bash
# Re-run extraction with verbose mode
VERBOSE=true ./ingest-gitlab-knowledge.sh

# Check relationship patterns
grep "issue_" archon-relationships.csv
```

## Maintenance

### Incremental Updates

**Option 1:** Full re-extraction (recommended for now)
```bash
./ingest-gitlab-knowledge.sh
./upload-to-archon.sh
```

**Option 2:** Delta sync (future enhancement)
```bash
# Track last extraction timestamp
# Only fetch updated_since last run
```

### Data Cleanup

```bash
# Remove old extractions
rm archon-*.csv archon-*.json

# Re-extract fresh
./ingest-gitlab-knowledge.sh
```

## Future Enhancements

### Planned Features

1. **User Entities & Relationships**
   - Extract GitLab users
   - Map authored_by, assigned_to relationships

2. **Cross-Reference Detection**
   - Parse issue descriptions for #123 references
   - Create `references` relationships

3. **Code Repository Ingestion**
   - Clone git repos
   - Extract README.md, CONTRIBUTING.md
   - Index code files for code search

4. **Dependency Mapping**
   - Parse package.json, pom.xml, requirements.txt
   - Create `depends_on` relationships

5. **Delta Synchronization**
   - Track last update timestamp
   - Only fetch new/modified entities

6. **Graph Visualization**
   - Export to Graphviz DOT format
   - Visualize project relationships

## Files Reference

| File | Purpose | Format | Size |
|------|---------|--------|------|
| `archon-knowledge-base.csv` | RAG semantic search | CSV (denormalized) | ~83KB |
| `archon-entities.csv` | Graph nodes | CSV (normalized) | ~54KB |
| `archon-relationships.csv` | Graph edges | CSV (normalized) | ~1KB |
| `archon-metadata.json` | Stats & metadata | JSON | ~5KB |
| `gitlab-issues-with-text.csv` | Issue source data | CSV | ~289KB |
| `gitlab-wiki-urls.txt` | Wiki URL list | Text | ~1KB |

## Support

For issues or questions:
1. Check extraction logs in script output
2. Verify Archon is running: `docker compose ps`
3. Test Archon API: `curl http://localhost:8181/health`
4. Review Archon logs: `docker compose logs archon-server`

---

**Last Updated:** 2025-09-30
**Status:** Ready for production use
**Maintainer:** Atlas Data Science Team
