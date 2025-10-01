# Neo4j + Graphiti Integration Plan for Archon Hybrid RAG

## Executive Summary

This plan details the integration of Neo4j graph database and Graphiti library into Archon's existing RAG system to create a true **hybrid RAG** system combining:
- **Vector/Semantic Search** (existing: Supabase + pgvector)
- **Full-Text Search** (existing: PostgreSQL ts_vector)
- **Graph Search** (new: Neo4j + Graphiti)

## Current State Analysis

### Existing Architecture (Archon)
- **Database:** Supabase (PostgreSQL + pgvector)
- **RAG Strategy Pattern:**
  - `BaseSearchStrategy` - vector similarity search
  - `HybridSearchStrategy` - combines vector + full-text search
  - `RerankingStrategy` - CrossEncoder reranking (optional)
  - `AgenticRAGStrategy` - enhanced code example search
- **Document Storage:** `documents` table with embeddings
- **Search Orchestration:** `RAGService` coordinates multiple strategies

### Reference Implementation (local-ai-packaged)
- **Neo4j Service:** Configured in docker-compose.yml
  - Ports: 7473 (HTTPS), 7474 (HTTP Browser), 7687 (Bolt)
  - Environment: `NEO4J_AUTH` for authentication
  - Volumes: logs, config, data, plugins
- **Mentioned Tools:** GraphRAG, LightRAG, Graphiti

### Gap Analysis
❌ No Neo4j service in Archon docker-compose.yml
❌ No Neo4j Python client dependencies
❌ No Graphiti library integration
❌ No graph storage during document ingestion
❌ No graph search strategy implementation
❌ No MCP tools for graph queries

## Implementation Plan

### Phase 1: Infrastructure Setup

#### Task 1.1: Add Neo4j Service to Docker Compose
**File:** `/mnt/e/repos/atlas/archon/docker-compose.yml`

Add Neo4j service configuration:
```yaml
  neo4j:
    image: neo4j:5.27.0
    container_name: archon-neo4j
    ports:
      - "${NEO4J_HTTP_PORT:-7474}:7474"    # HTTP Browser
      - "${NEO4J_HTTPS_PORT:-7473}:7473"   # HTTPS Browser
      - "${NEO4J_BOLT_PORT:-7687}:7687"    # Bolt Protocol
    environment:
      - NEO4J_AUTH=${NEO4J_USER:-neo4j}/${NEO4J_PASSWORD}
      - NEO4J_dbms_memory_pagecache_size=512M
      - NEO4J_dbms_memory_heap_initial__size=512M
      - NEO4J_dbms_memory_heap_max__size=1G
      - NEO4J_dbms_security_procedures_unrestricted=apoc.*
      - NEO4J_dbms_security_procedures_allowlist=apoc.*
    volumes:
      - neo4j_data:/data
      - neo4j_logs:/logs
      - neo4j_conf:/conf
      - neo4j_plugins:/plugins
    networks:
      - app-network
    healthcheck:
      test: ["CMD", "cypher-shell", "-u", "neo4j", "-p", "${NEO4J_PASSWORD}", "RETURN 1"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s

volumes:
  neo4j_data:
  neo4j_logs:
  neo4j_conf:
  neo4j_plugins:
```

**Environment Variables (`.env`):**
```bash
NEO4J_USER=neo4j
NEO4J_PASSWORD=your_secure_password_here
NEO4J_HTTP_PORT=7474
NEO4J_HTTPS_PORT=7473
NEO4J_BOLT_PORT=7687
NEO4J_URI=bolt://neo4j:7687
```

#### Task 1.2: Add Python Dependencies
**File:** `/mnt/e/repos/atlas/archon/python/pyproject.toml`

Add to `[dependency-groups]` → `server`:
```toml
server = [
    # ... existing dependencies ...

    # Graph database and knowledge graph
    "neo4j>=5.27.0",
    "graphiti-core>=0.3.0",  # Knowledge graph construction
]
```

**Research Required:** Verify latest stable versions of:
- `neo4j` Python driver
- `graphiti-core` or alternative Graphiti package name
- Check for additional dependencies (e.g., networkx, rdflib if needed)

### Phase 2: Neo4j Service Layer

#### Task 2.1: Create Neo4j Connection Service
**File:** `/mnt/e/repos/atlas/archon/python/src/server/services/graph/neo4j_service.py`

```python
"""
Neo4j Service

Provides connection management and basic operations for Neo4j graph database.
"""

import os
from typing import Any, Optional

from neo4j import GraphDatabase, Driver, Session
from ...config.logfire_config import get_logger, safe_span

logger = get_logger(__name__)


class Neo4jService:
    """Service for managing Neo4j connections and operations."""

    def __init__(self):
        """Initialize Neo4j connection from environment variables."""
        self.uri = os.getenv("NEO4J_URI", "bolt://localhost:7687")
        self.user = os.getenv("NEO4J_USER", "neo4j")
        self.password = os.getenv("NEO4J_PASSWORD")

        if not self.password:
            logger.warning("NEO4J_PASSWORD not set - Neo4j service disabled")
            self._driver = None
            return

        try:
            self._driver: Optional[Driver] = GraphDatabase.driver(
                self.uri,
                auth=(self.user, self.password)
            )
            logger.info(f"Neo4j service initialized: {self.uri}")
        except Exception as e:
            logger.error(f"Failed to initialize Neo4j driver: {e}")
            self._driver = None

    def is_available(self) -> bool:
        """Check if Neo4j service is available."""
        return self._driver is not None

    def get_session(self) -> Optional[Session]:
        """Get a Neo4j session."""
        if not self._driver:
            return None
        return self._driver.session()

    async def execute_query(
        self,
        query: str,
        parameters: dict[str, Any] | None = None
    ) -> list[dict[str, Any]]:
        """
        Execute a Cypher query and return results.

        Args:
            query: Cypher query string
            parameters: Query parameters

        Returns:
            List of result records as dictionaries
        """
        if not self._driver:
            logger.warning("Neo4j driver not available")
            return []

        with safe_span("neo4j_query") as span:
            try:
                with self._driver.session() as session:
                    result = session.run(query, parameters or {})
                    records = [dict(record) for record in result]
                    span.set_attribute("record_count", len(records))
                    return records
            except Exception as e:
                logger.error(f"Neo4j query error: {e}")
                span.record_exception(e)
                return []

    def close(self):
        """Close Neo4j driver connection."""
        if self._driver:
            self._driver.close()
            logger.info("Neo4j driver closed")


# Singleton instance
_neo4j_service: Optional[Neo4jService] = None


def get_neo4j_service() -> Neo4jService:
    """Get or create Neo4j service singleton."""
    global _neo4j_service
    if _neo4j_service is None:
        _neo4j_service = Neo4jService()
    return _neo4j_service
```

**File:** `/mnt/e/repos/atlas/archon/python/src/server/services/graph/__init__.py`
```python
from .neo4j_service import Neo4jService, get_neo4j_service

__all__ = ["Neo4jService", "get_neo4j_service"]
```

#### Task 2.2: Implement Graphiti Integration Service
**File:** `/mnt/e/repos/atlas/archon/python/src/server/services/graph/graphiti_service.py`

```python
"""
Graphiti Service

Integrates Graphiti library for building knowledge graphs from documents.
Graphiti provides entity extraction, relationship detection, and graph construction.
"""

from typing import Any
from ...config.logfire_config import get_logger, safe_span
from .neo4j_service import get_neo4j_service

logger = get_logger(__name__)


class GraphitiService:
    """Service for building knowledge graphs using Graphiti."""

    def __init__(self):
        """Initialize Graphiti service with Neo4j backend."""
        self.neo4j_service = get_neo4j_service()
        # TODO: Initialize Graphiti client with Neo4j connection
        # Research Graphiti API for proper initialization

    async def build_graph_from_text(
        self,
        text: str,
        source_id: str,
        metadata: dict[str, Any] | None = None
    ) -> dict[str, Any]:
        """
        Build knowledge graph from text using Graphiti.

        Args:
            text: Document text to process
            source_id: Source identifier for traceability
            metadata: Additional metadata about the document

        Returns:
            Dictionary with entities and relationships created
        """
        if not self.neo4j_service.is_available():
            logger.warning("Neo4j not available - skipping graph construction")
            return {"entities": [], "relationships": []}

        with safe_span("graphiti_build_graph") as span:
            try:
                # TODO: Implement Graphiti graph construction
                # 1. Extract entities from text
                # 2. Detect relationships between entities
                # 3. Store in Neo4j via Graphiti
                # 4. Return summary of what was created

                logger.info(f"Building graph for source: {source_id}")

                # Placeholder implementation
                entities = []
                relationships = []

                span.set_attribute("entities_created", len(entities))
                span.set_attribute("relationships_created", len(relationships))

                return {
                    "entities": entities,
                    "relationships": relationships,
                    "source_id": source_id
                }
            except Exception as e:
                logger.error(f"Graph construction error: {e}")
                span.record_exception(e)
                return {"entities": [], "relationships": [], "error": str(e)}


# Singleton instance
_graphiti_service = None


def get_graphiti_service() -> GraphitiService:
    """Get or create Graphiti service singleton."""
    global _graphiti_service
    if _graphiti_service is None:
        _graphiti_service = GraphitiService()
    return _graphiti_service
```

### Phase 3: Graph Search Strategy

#### Task 3.1: Implement Graph Search Strategy
**File:** `/mnt/e/repos/atlas/archon/python/src/server/services/search/graph_search_strategy.py`

```python
"""
Graph Search Strategy

Implements graph-based search using Neo4j Cypher queries.
Complements vector and full-text search with relationship traversal.
"""

from typing import Any
from ...config.logfire_config import get_logger, safe_span
from ..graph.neo4j_service import get_neo4j_service

logger = get_logger(__name__)


class GraphSearchStrategy:
    """Strategy for searching knowledge graph using Neo4j."""

    def __init__(self):
        """Initialize graph search with Neo4j service."""
        self.neo4j_service = get_neo4j_service()

    async def search_graph(
        self,
        query: str,
        match_count: int = 5,
        traversal_depth: int = 2
    ) -> list[dict[str, Any]]:
        """
        Search knowledge graph for relevant entities and relationships.

        Args:
            query: Search query (keywords or concepts)
            match_count: Maximum number of results
            traversal_depth: Maximum relationship traversal depth

        Returns:
            List of relevant graph nodes with relationships
        """
        if not self.neo4j_service.is_available():
            logger.debug("Neo4j not available - returning empty results")
            return []

        with safe_span("graph_search") as span:
            try:
                # Build Cypher query for concept search
                # This is a basic implementation - enhance based on graph schema
                cypher_query = """
                MATCH (n:Entity)
                WHERE n.name CONTAINS $query
                   OR n.description CONTAINS $query
                WITH n,
                     CASE
                       WHEN n.name CONTAINS $query THEN 2
                       ELSE 1
                     END as relevance_score
                OPTIONAL MATCH (n)-[r]-(related)
                RETURN n, collect(r) as relationships, collect(related) as related_entities, relevance_score
                ORDER BY relevance_score DESC, n.importance DESC
                LIMIT $limit
                """

                results = await self.neo4j_service.execute_query(
                    cypher_query,
                    {"query": query, "limit": match_count}
                )

                span.set_attribute("results_count", len(results))
                return results

            except Exception as e:
                logger.error(f"Graph search error: {e}")
                span.record_exception(e)
                return []
```

#### Task 3.2: Integrate Graph Search into RAGService
**File:** `/mnt/e/repos/atlas/archon/python/src/server/services/search/rag_service.py`

Modify `RAGService.__init__()`:
```python
def __init__(self, supabase_client=None):
    """Initialize RAG service with all search strategies"""
    self.supabase_client = supabase_client or get_supabase_client()

    # Existing strategies
    self.base_strategy = BaseSearchStrategy(self.supabase_client)
    self.hybrid_strategy = HybridSearchStrategy(self.supabase_client, self.base_strategy)
    self.agentic_strategy = AgenticRAGStrategy(self.supabase_client, self.base_strategy)

    # NEW: Graph search strategy
    self.graph_strategy = None
    use_graph_search = self.get_bool_setting("USE_GRAPH_SEARCH", False)
    if use_graph_search:
        try:
            from .graph_search_strategy import GraphSearchStrategy
            self.graph_strategy = GraphSearchStrategy()
            logger.info("Graph search strategy loaded successfully")
        except Exception as e:
            logger.warning(f"Failed to load graph search strategy: {e}")
            self.graph_strategy = None

    # Existing reranking initialization
    # ...
```

Add graph search method:
```python
async def search_with_graph(
    self,
    query: str,
    match_count: int = 5
) -> dict[str, Any]:
    """
    Perform hybrid search combining vector, text, and graph search.

    Returns:
        Dictionary with results from each search type
    """
    results = {
        "vector_results": [],
        "graph_results": [],
        "combined_results": []
    }

    # Get vector search results (existing)
    vector_results = await self.search_documents(query, match_count)
    results["vector_results"] = vector_results

    # Get graph search results (new)
    if self.graph_strategy:
        graph_results = await self.graph_strategy.search_graph(query, match_count)
        results["graph_results"] = graph_results

    # TODO: Implement fusion/merging strategy
    # Combine vector and graph results with deduplication

    return results
```

### Phase 4: Document Ingestion Pipeline

#### Task 4.1: Update Document Storage to Include Graph
**File:** `/mnt/e/repos/atlas/archon/python/src/server/services/storage/storage_services.py`

Modify document storage to call graph service:
```python
from ..graph.graphiti_service import get_graphiti_service

async def store_document_chunk(self, chunk_data):
    """Store chunk in both Supabase and Neo4j graph."""

    # Existing Supabase storage
    await self.store_in_supabase(chunk_data)

    # NEW: Build knowledge graph
    graphiti_service = get_graphiti_service()
    if graphiti_service.neo4j_service.is_available():
        try:
            graph_result = await graphiti_service.build_graph_from_text(
                text=chunk_data["content"],
                source_id=chunk_data["source_id"],
                metadata=chunk_data.get("metadata", {})
            )
            logger.info(f"Graph created: {len(graph_result['entities'])} entities")
        except Exception as e:
            logger.warning(f"Failed to build graph for chunk: {e}")
            # Continue - don't fail ingestion if graph fails
```

### Phase 5: MCP Integration

#### Task 5.1: Create MCP Tools for Graph Queries
**File:** `/mnt/e/repos/atlas/archon/python/src/mcp_server/features/graph/graph_tools.py`

```python
"""
MCP Tools for Graph Database Queries

Provides Claude Code with tools to query the knowledge graph.
"""

from typing import Any
from mcp.types import Tool, TextContent

async def search_knowledge_graph(query: str, match_count: int = 5) -> list[dict[str, Any]]:
    """
    Search the knowledge graph for entities and relationships.

    Args:
        query: Search query for concepts, entities, or relationships
        match_count: Maximum number of results (default: 5)

    Returns:
        List of relevant graph nodes with relationships
    """
    from src.server.services.search.graph_search_strategy import GraphSearchStrategy

    strategy = GraphSearchStrategy()
    results = await strategy.search_graph(query, match_count)

    return {
        "success": True,
        "results": results,
        "count": len(results)
    }


# MCP tool registration
GRAPH_TOOLS = [
    Tool(
        name="search_knowledge_graph",
        description="Search the knowledge graph for entities, concepts, and their relationships",
        inputSchema={
            "type": "object",
            "properties": {
                "query": {
                    "type": "string",
                    "description": "Search query for concepts or entities"
                },
                "match_count": {
                    "type": "integer",
                    "default": 5,
                    "description": "Maximum number of results to return"
                }
            },
            "required": ["query"]
        }
    )
]
```

### Phase 6: Testing & Documentation

#### Task 6.1: Integration Tests
**File:** `/mnt/e/repos/atlas/archon/python/tests/test_neo4j_integration.py`

```python
"""Tests for Neo4j and graph search integration."""

import pytest
from src.server.services.graph.neo4j_service import get_neo4j_service
from src.server.services.graph.graphiti_service import get_graphiti_service

@pytest.mark.asyncio
async def test_neo4j_connection():
    """Test Neo4j service can connect."""
    service = get_neo4j_service()
    assert service.is_available()

@pytest.mark.asyncio
async def test_graph_construction():
    """Test Graphiti can build graph from text."""
    service = get_graphiti_service()
    result = await service.build_graph_from_text(
        text="Neo4j is a graph database. It stores entities and relationships.",
        source_id="test-doc-001"
    )
    assert "entities" in result
    assert "relationships" in result
```

#### Task 6.2: Documentation Updates

**File:** `/mnt/e/repos/atlas/archon/CLAUDE.md`

Add section:
```markdown
## Neo4j Graph Database

Archon uses Neo4j for knowledge graph storage alongside Supabase:

- **Neo4j Browser**: http://localhost:7474
- **Bolt Protocol**: bolt://localhost:7687
- **Use Cases**: Entity relationships, concept mapping, graph traversal

### Configuration

Set in `.env`:
```bash
NEO4J_USER=neo4j
NEO4J_PASSWORD=your_password
NEO4J_URI=bolt://neo4j:7687
USE_GRAPH_SEARCH=true
```

### Graph Search

Enable graph search in hybrid RAG:
```python
results = await rag_service.search_with_graph(
    query="architecture components",
    match_count=5
)
```
```

**File:** `/mnt/e/repos/atlas/archon-test/README.md`

Update Neo4j section with actual implementation details.

## Implementation Order

### Week 1: Infrastructure
1. ✅ Research Graphiti and Neo4j patterns
2. Add Neo4j to docker-compose.yml
3. Add Python dependencies
4. Test Neo4j connectivity

### Week 2: Services
5. Create Neo4j service
6. Implement Graphiti integration
7. Create graph search strategy
8. Write unit tests

### Week 3: Integration
9. Integrate graph search into RAGService
10. Update document ingestion pipeline
11. Add Neo4j credentials management
12. Test end-to-end ingestion → search

### Week 4: MCP & Polish
13. Create MCP graph tools
14. Update documentation
15. Add graph visualization (optional)
16. Performance testing and optimization

## Success Criteria

- [ ] Neo4j service starts and is accessible
- [ ] Documents ingested create graph entities and relationships
- [ ] Graph search returns relevant results for test queries
- [ ] MCP tools expose graph search to Claude Code
- [ ] Hybrid RAG combines vector + text + graph results
- [ ] Performance: Graph search completes in < 500ms for typical queries
- [ ] Documentation complete for setup and usage

## Dependencies & Research

### Graphiti Library
- **Research Required:** Verify package name and API
- Possible packages: `graphiti-core`, `graphiti`, or custom implementation
- Alternative: Use LangChain GraphCypherQAChain or build custom entity extraction

### Neo4j APOC Plugins
- May need APOC (Awesome Procedures on Cypher) for advanced graph operations
- Install via Neo4j plugins volume

### Graph Schema Design
- Define node types: Document, Entity, Concept, Source
- Define relationship types: MENTIONS, RELATED_TO, PART_OF, DERIVED_FROM
- Add properties: importance, confidence_score, created_at

## Risks & Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Graphiti library not well-maintained | High | Use alternative: LightRAG, custom entity extraction |
| Performance: Graph queries slow | Medium | Optimize Cypher queries, add indexes, limit traversal depth |
| Memory: Neo4j requires significant RAM | Medium | Configure heap size, use smaller memory profile for dev |
| Complexity: Graph schema becomes unwieldy | Medium | Start simple, iterate based on actual use cases |

## Future Enhancements

- **GraphRAG**: Implement Microsoft GraphRAG pattern
- **LightRAG**: Alternative lightweight graph RAG approach
- **Graph Visualization**: Add D3.js or vis.js graph viewer in Archon UI
- **Multi-hop Reasoning**: Traverse relationships for complex queries
- **Temporal Graphs**: Track entity evolution over time
- **Graph Embeddings**: Combine node embeddings with text embeddings
