# Archon RAG Baseline Configuration

**Timestamp:** 2025-10-01T17:10:48Z
**Version:** v1
**Purpose:** Baseline configuration for RAG optimization testing
**Source:** archon-RAG-settings-screenshot-v1.jpg

---

## LLM Configuration

### Provider
**LLM Provider:** OpenAI

### Models
- **Chat Model:** `gpt-4.1-nano`
- **Embedding Model:** `text-embedding-3-small`

---

## RAG Strategy Settings

### Use Contextual Embeddings
**Status:** ✅ Enabled

**Description:** Enhances embeddings with contextual information for better retrieval

**Parameters:**
- **Contextual Chunk Count:** `3` (Max)
- **Note:** Controls parallel processing for embeddings (1-10)

### Use Hybrid Search
**Status:** ✅ Enabled

**Description:** Combines vector similarity search with keyword search for better results

### Use Reranking
**Status:** ✅ Enabled

**Description:** Applies cross-encoder reranking to improve search result relevance

### Use Agentic RAG
**Status:** ✅ Enabled

**Description:** Enables code extraction and specialized search for technical content

---

## Crawling Performance Settings

### Batch Processing
- **Batch Size:** `50`
  - URLs to crawl in parallel (10-100)

- **Max Concurrent:** `10`
  - Pages to crawl in parallel per operation (1-20)

### Timing Controls
- **Wait Strategy:** `DOM Loaded (Fast)`

- **Page Timeout (sec):** `30`

- **Render Delay (sec):** `0.5`

---

## Storage Performance Settings

### Document Processing
- **Document Batch Size:** `100`
  - Chunks per batch (10-100)

- **Embedding Batch Size:** `200`
  - Per API call (20-200)

- **Code Extraction Workers:** `3`
  - Parallel workers (1-10)

### Parallel Processing
**Enable Parallel Processing:** ✅ Enabled

**Description:** Process multiple document batches simultaneously for faster storage

---

## Testing Notes

### Optimization Parameters to Monitor

**High-Priority Tuning Targets:**
1. **Contextual Chunk Count** (currently 3/Max) - affects embedding quality vs. speed
2. **Embedding Batch Size** (currently 200) - affects API efficiency
3. **Document Batch Size** (currently 100) - affects ingestion speed
4. **Hybrid Search** - can toggle to compare pure vector vs. hybrid results
5. **Reranking** - can disable to measure impact on relevance

**Performance Tuning Targets:**
1. **Batch Size** (crawling) - currently 50, range 10-100
2. **Max Concurrent** - currently 10, range 1-20
3. **Code Extraction Workers** - currently 3, range 1-10
4. **Parallel Processing** - can disable to compare sequential vs. parallel

### Expected Impacts

**Quality vs. Speed Trade-offs:**
- Higher contextual chunks = better quality, slower ingestion
- Larger embedding batches = faster API calls, potential quality variance
- Reranking enabled = better relevance, slower queries
- Hybrid search = better recall, slower than pure vector

**Resource Utilization:**
- Higher concurrency = faster crawling, higher resource usage
- More workers = faster code extraction, higher CPU usage
- Parallel processing = faster overall, higher memory usage

### Baseline Test Expectations

With these settings, expect:
- **Ingestion Speed:** Moderate to fast (parallel processing enabled)
- **Query Quality:** High (hybrid search + reranking + contextual embeddings)
- **Query Speed:** Moderate (reranking adds latency)
- **Resource Usage:** Moderate to high (multiple parallel processes)

### Recommended First Optimization Test

**Test:** Disable reranking and measure impact
- **Hypothesis:** Reranking improves precision but adds query latency
- **Metric:** Compare precision/recall with and without reranking
- **Expected:** 10-20% quality improvement, 2-3x query speed reduction

---

## Configuration Change Log

### v1 - 2025-10-01T17:10:48Z (Baseline)
- Initial baseline configuration captured
- All optimization features enabled (contextual, hybrid, reranking, agentic)
- Moderate performance settings (batch: 50, concurrent: 10, workers: 3)
- OpenAI provider with gpt-4.1-nano and text-embedding-3-small

---

## Related Files

- **Screenshot Source:** `/mnt/e/repos/atlas/docs/configuration-documents/archon-RAG-settings-screenshot-v1.jpg`
- **Test Results Directory:** `/mnt/e/repos/atlas/archon-test/test-results/`
- **Optimization Log:** To be created during testing iterations

---

## Usage

This configuration serves as the baseline for all RAG optimization tests. When testing parameter changes:

1. **Document Change:** Create new timestamped configuration file
2. **Note Hypothesis:** What improvement is expected?
3. **Run Test:** Execute test with new settings
4. **Compare Results:** Compare against this baseline
5. **Update Recommended:** If improvement confirmed, update recommended configuration

**Next Steps:**
1. Execute baseline test with these settings
2. Capture baseline metrics (precision, recall, query time)
3. Begin iterative optimization following test plan in TODO.md
