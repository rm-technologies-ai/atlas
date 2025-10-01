# archon-test

**Test Suite for Hybrid RAG System Optimization**

## Overview

This project is a Test Suite to fine-tune the hybrid RAG system by optimizing RAG ingest formats and parameters, and extending Archon capabilities to facilitate the optimization workflow.

**Location:** `/mnt/e/repos/atlas/archon-test/`

## Testing Methodology

Each test uses a controlled approach:
- **Controlled Input Dataset**: Specific documents with known content (e.g., Atlas Business Plan)
- **Controlled Test Prompt**: Precise queries (e.g., "List the top 10 architectural components of the system")
- **Measured Results**: Correctness and precision measured against expected components in the input dataset
- **Parameter Optimization**: Iterate RAG parameters (max records, reranking, temperature) until results are consistently correct

## Test Convention

**All tests follow: Setup → Exercise → Verify → Teardown**

This convention applies to:
- Custom test scripts
- Code-based tests using Node.js and Python test libraries



## Generalized Test Script Pattern

This pattern is designed to be reusable across multiple test scenarios:

### 1. Ingest Document (User Action)
Ingest the test document (e.g., Atlas Business Plan) via Archon UI or API.

### 2. Inspect RAG Chunk Records
Generate markdown files showing each text record and metadata for chunks being inserted in RAG.
- **Output Location:** `/mnt/e/repos/atlas/archon-test/rag-ingest-records/`
- **Format:** Auto-numbered markdown files (001.md, 002.md, etc.)
- **Content:** Chunk text, metadata, embeddings info

### 3. Inspect Graph Database Records
Generate markdown files showing records and relationships created in the graph database.
- **Output Location:** `/mnt/e/repos/atlas/archon-test/graph-ingest-records/`
- **Format:** Auto-numbered markdown files (001.md, 002.md, etc.)
- **Content:** Neo4j nodes, relationships, properties

### 4. Execute Test Query
Enter controlled test query in Archon search UI:
- Example: "List the top 10 architectural components of the system"
- View and reference all records returned by both databases (RAG + Graph)

### 5. Verify Results (Manual Visual Review)
Examine results to assert expected outcomes against known ground truth.

### 6. Iterate Optimization
Modify hybrid RAG implementation based on findings:
- **Chunking logic**: Chunk size, overlap, semantic boundaries
- **Metadata enrichment**: Enhanced context, document structure
- **LLM parameters**: Temperature, max tokens, top-k, top-p
- **RAG/Graph DB logic**: Query strategies, reranking, hybrid fusion

## Project Structure

```
/mnt/e/repos/atlas/archon-test/
├── CLAUDE.md                    # Claude Code guidance (inherits from root)
├── README.md                    # This file
├── TODO.md                      # Task tracking
├── tests/                       # Test scripts (Node.js/Python)
├── test-data/                   # Input datasets for tests
├── rag-ingest-records/          # RAG chunk inspection outputs
├── graph-ingest-records/        # Graph DB record inspection outputs
└── test-results/                # Test execution results and reports
```

## Current Tasks

### Task 1: Manual Archon Ingest Test ⏳
**Status:** Pending

Test archon ingest directly via UI (manual process):
1. Start Archon services
2. Access Archon UI at http://localhost:3737
3. Ingest test document
4. Observe and document ingest process

### Task 2: Identify RAG Optimization Parameters ⏳
**Status:** Pending

Identify parameters and logic that can be modified to optimize hybrid RAG responses for Claude Code consumption:
- RAG vector DB parameters (chunk size, similarity threshold, max records)
- Graph DB parameters (traversal depth, filtering logic)
- LLM parameters (temperature, top-k, top-p)
- Hybrid fusion strategies (RAG vs Graph weight balancing)

## Archon Integration

This project uses **Archon MCP server** for task management and knowledge base queries. See `CLAUDE.md` for detailed Archon workflow integration.

**Key Archon Commands:**
- `archon:manage_task()` - Task management
- `archon:perform_rag_query()` - Knowledge base search
- `archon:search_code_examples()` - Code pattern search
- `archon:get_available_sources()` - Check knowledge sources

## Getting Started

1. Ensure Archon services are running: `cd /mnt/e/repos/atlas/archon && docker compose up -d`
2. Review `CLAUDE.md` for complete workflow guidance
3. Follow Archon-first rule: Always use Archon task management as primary system

## Inspecting RAG Records Directly in Supabase

### Accessing Supabase SQL Editor

1. **Navigate to Supabase Dashboard:**
   - URL: https://erqocjafzxeyxrghigwd.supabase.co
   - Go to SQL Editor in the left sidebar

2. **Key Tables for RAG Inspection:**

   **`documents` table** - Contains RAG chunk records with embeddings:
   ```sql
   -- View all document chunks for a specific source
   SELECT
     id,
     source_id,
     content,
     metadata,
     created_at,
     embedding -- pgvector embedding (1536 dimensions)
   FROM documents
   WHERE source_id = 'file_Atlas_-_Business_Plan_-_2025_06_21_-_REL_pdf_bbfbb44a'
   ORDER BY id
   LIMIT 20;

   -- Count chunks per source
   SELECT
     source_id,
     COUNT(*) as chunk_count
   FROM documents
   GROUP BY source_id;

   -- View metadata structure for chunks
   SELECT
     id,
     content::text AS chunk_text,
     metadata->>'page' AS page_number,
     metadata->>'chunk_index' AS chunk_index,
     metadata->>'chunk_size' AS chunk_size,
     metadata->>'word_count' AS word_count,
     metadata->>'source_type' AS source_type,
     metadata->>'knowledge_type' AS knowledge_type
   FROM documents
   WHERE source_id = 'file_Atlas_-_Business_Plan_-_2025_06_21_-_REL_pdf_bbfbb44a'
   ORDER BY (metadata->>'chunk_index')::int
   LIMIT 20;

   -- Search using vector similarity (requires embedding)
   -- Note: You need a query embedding to perform semantic search
   SELECT
     id,
     content,
     metadata,
     1 - (embedding <=> '[your_query_embedding_vector_here]'::vector) AS similarity
   FROM documents
   WHERE source_id = 'file_Atlas_-_Business_Plan_-_2025_06_21_-_REL_pdf_bbfbb44a'
   ORDER BY embedding <=> '[your_query_embedding_vector_here]'::vector
   LIMIT 10;
   ```

   **`sources` table** - Contains document source metadata:
   ```sql
   -- View all ingested sources
   SELECT
     source_id,
     title,
     summary,
     metadata,
     total_words,
     created_at,
     updated_at
   FROM sources
   ORDER BY created_at DESC;

   -- View source details with tags
   SELECT
     source_id,
     title,
     metadata->>'tags' AS tags,
     metadata->>'source_type' AS source_type,
     metadata->>'knowledge_type' AS knowledge_type,
     total_words,
     update_frequency
   FROM sources;
   ```

   **`code_examples` table** - Contains extracted code snippets:
   ```sql
   -- View code examples
   SELECT
     id,
     source_id,
     code,
     language,
     summary,
     metadata
   FROM code_examples
   ORDER BY created_at DESC
   LIMIT 10;
   ```

3. **Useful Queries for RAG Testing:**

   ```sql
   -- Export all chunks for manual inspection
   COPY (
     SELECT
       id,
       source_id,
       content,
       metadata->>'chunk_index' AS chunk_index,
       metadata->>'page' AS page
     FROM documents
     WHERE source_id = 'your_source_id_here'
     ORDER BY (metadata->>'chunk_index')::int
   ) TO '/tmp/rag_chunks.csv' WITH CSV HEADER;

   -- Analyze chunk size distribution
   SELECT
     (metadata->>'chunk_size')::int AS chunk_size,
     COUNT(*) AS count
   FROM documents
   WHERE source_id = 'your_source_id_here'
   GROUP BY chunk_size
   ORDER BY chunk_size;

   -- Find chunks with specific keywords
   SELECT
     id,
     content,
     metadata->>'page' AS page
   FROM documents
   WHERE source_id = 'your_source_id_here'
     AND content ILIKE '%architecture%'
   ORDER BY (metadata->>'chunk_index')::int;
   ```

### Connection Details

**Supabase URL:** https://erqocjafzxeyxrghigwd.supabase.co
**Database:** PostgreSQL with pgvector extension
**Key Extensions:**
- `pgvector` - Vector similarity search (1536-dimensional embeddings)
- `pg_trgm` - Text search and similarity

## Neo4j Graph Database Status

**Note:** Archon currently uses **Supabase (PostgreSQL + pgvector) only** for RAG storage. Neo4j graph database integration is **not currently implemented** in the Archon architecture.

The current architecture uses:
- **pgvector** for semantic similarity search
- **PostgreSQL relational model** for document relationships
- **JSON metadata fields** for flexible schema

### Future Neo4j Integration

If Neo4j is added in the future, typical queries would include:

```cypher
// Example: View document nodes and relationships
MATCH (d:Document)-[r]->(related)
WHERE d.source_id = 'your_source_id_here'
RETURN d, r, related
LIMIT 25;

// Example: Find related concepts
MATCH (c:Concept)-[:MENTIONED_IN]->(d:Document)
WHERE c.name = 'architecture'
RETURN c, d
LIMIT 10;

// Example: Traverse knowledge graph
MATCH path = (start:Concept)-[*1..3]-(end:Concept)
WHERE start.name = 'authentication'
RETURN path
LIMIT 5;
```

**Neo4j Browser** would be accessible at: http://localhost:7474 (if implemented)
**Neo4j Bolt Protocol:** bolt://localhost:7687 (if implemented)

### Recommended Graph Visualizations (Future)

If Neo4j is integrated:
- **Neo4j Browser** - Built-in graph visualization at http://localhost:7474
- **Bloom** - Enterprise visualization tool (requires Neo4j Enterprise)
- **Arrows.app** - Free graph diagram tool for static visualizations
- **neovis.js** - JavaScript library for custom web visualizations