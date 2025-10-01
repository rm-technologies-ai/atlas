# GitLab Wiki Ingestion Guide for Archon

## Environment Variables Required

All required variables are already defined in `/mnt/e/repos/atlas/.env.atlas`:

```bash
GITLAB_TOKEN=glpat-A7skmJhDq95q9UXddWG3Om86MQp1OmhhdGhlCw.01.120e062ee
GITLAB_HOST=https://gitlab.com
GITLAB_GROUP=atlas-datascience/lion
```

**No additional configuration needed!**

## Discovered Wiki URLs

The following wikis have been discovered in the `atlas-datascience/lion` group:

1. **DevOps Wiki**
   - URL: https://gitlab.com/atlas-datascience/lion/devops/-/wikis/home
   - Pages: 1
   - Project: atlas-datascience/lion/devops

## How to Ingest Wikis into Archon

### Method 1: Manual Web Crawl (Recommended for Small Number of Wikis)

1. Open Archon UI: http://localhost:3737
2. Navigate to **Knowledge Base** → **Sources**
3. Click **"Crawl Website"** or **"Add Source"**
4. Enter wiki URL: `https://gitlab.com/atlas-datascience/lion/devops/-/wikis/home`
5. Configure crawl settings:
   - **Max Depth**: 3 (to crawl sub-pages)
   - **Max Pages**: 50 (adjust based on wiki size)
   - **Include Patterns**: `/-/wikis/` (to stay within wiki)
6. Click **"Start Crawl"**
7. Monitor progress in the UI

### Method 2: Bulk Import via API (For Multiple Wikis)

Use the discovered `gitlab-wiki-urls.txt` file:

```bash
cd /mnt/e/repos/atlas/issues

# Read each wiki URL and trigger Archon crawl
while read wiki_url; do
    echo "Crawling: $wiki_url"
    curl -X POST http://localhost:8181/api/sources/crawl \
        -H "Content-Type: application/json" \
        -d "{\"url\": \"$wiki_url\", \"max_depth\": 3, \"max_pages\": 50}"
    sleep 2
done < gitlab-wiki-urls.txt
```

### Method 3: GitLab Wiki Export + Upload

If wikis are large or contain many images:

1. Export wiki from GitLab (Settings → General → Advanced → Export project)
2. Extract wiki markdown files
3. Upload to Archon as documents via UI or API

## Scripts Available

- **`list-wiki-urls.sh`** - Discovers all wikis in the GitLab group
  - Output: `gitlab-wiki-urls.txt` (plain text)
  - Output: `gitlab-wiki-urls.json` (structured data)

## Next Steps

1. ✅ Environment variables configured
2. ✅ Wiki URLs discovered
3. 🔄 Choose ingestion method (Manual UI or Bulk API)
4. 🔄 Start crawling wikis into Archon
5. 🔄 Validate knowledge base queries return wiki content

## Validation

After ingestion, test with Archon MCP or UI:

```bash
# Query via Archon knowledge base
"Tell me about the Lion devops setup"
"What are the deployment procedures for Lion?"
```

Expected: Archon returns content from the DevOps wiki.

---

**Last Updated**: 2025-09-30
**Status**: Wiki discovery in progress
