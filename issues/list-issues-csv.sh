#!/usr/bin/env bash
# export-gitlab-hive-issues.nopaging.sh
# Headless idempotent installer for exporting GitLab hive issues (no pagination) to one CSV with Project column.
# Copyright © 2025 Roy Mayfield, RM Technologies. Licensed under the Apache License 2.0 with attribution.

# ── Token (hard-coded; requires at least read_api) ───────────────────────────
TOKEN="glpat-A7skmJhDq95q9UXddWG3Om86MQp1OmhhdGllCw.01.120e062ee"

set -euo pipefail

# ── Preflight checks ─────────────────────────────────────────────────────────
if ! command -v jq >/dev/null 2>&1; then
  echo "[ERROR] jq is not installed. Install jq and rerun." >&2
  exit 1
fi

if ! curl -sS --fail -H "PRIVATE-TOKEN: $TOKEN" https://gitlab.com/api/v4/user >/dev/null; then
  echo "[ERROR] GitLab token is invalid, expired, or missing required scope (read_api)." >&2
  exit 1
fi

# ── Config (env overrides allowed) ───────────────────────────────────────────
GITLAB_HOST="${GITLAB_HOST:-https://gitlab.com}"
GROUP_PATHS="${GROUP_PATHS:-atlas-datascience/lion}"          # comma-separated root groups
INCLUDE_SUBGROUPS="${INCLUDE_SUBGROUPS:-true}"                # true|false
STATE="${STATE:-all}"                                         # opened|closed|all
ORDER_BY="${ORDER_BY:-created_at}"
SORT="${SORT:-asc}"
# PER_PAGE is fixed at 100 (GitLab API maximum)
OUT="${OUT:-gitlab-hive-issues.csv}"

TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT
TMPJSON="$TMPDIR/issues.jsonl"
: > "$TMPJSON"

encode() { python3 - <<'PY' "$1"
import urllib.parse, sys
print(urllib.parse.quote(sys.argv[1], safe=""))
PY
}

# ── Fetch: multiple requests to get all issues (GitLab limits to 100/page) ───
IFS=',' read -r -a GROUP_ARR <<< "$GROUP_PATHS"
for gp in "${GROUP_ARR[@]}"; do
  gp_trim="$(echo "$gp" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
  genc="$(encode "$gp_trim")"

  # Fetch multiple pages (GitLab API max is 100 per page)
  for page in 1 2 3 4 5; do
    URL="$GITLAB_HOST/api/v4/groups/$genc/issues?per_page=100&page=$page&include_subgroups=$INCLUDE_SUBGROUPS&state=$STATE&scope=all&order_by=$ORDER_BY&sort=$SORT"
    echo "[INFO] GET $URL (page $page)"
    BODY="$TMPDIR/body.$RANDOM.json"

    # Try to fetch the page, break if empty or error
    if curl -sS --fail -H "PRIVATE-TOKEN: $TOKEN" "$URL" -o "$BODY" 2>/dev/null; then
      # Check if we got any issues
      issue_count=$(jq 'length' "$BODY")
      if [ "$issue_count" -eq 0 ]; then
        echo "[INFO] No more issues on page $page"
        break
      fi
      jq -c '.[]' "$BODY" >> "$TMPJSON"
      echo "[INFO] Got $issue_count issues from page $page"
    else
      echo "[INFO] No more pages available"
      break
    fi
  done
done

# ── CSV header ───────────────────────────────────────────────────────────────
echo "Project,project_id,issue_iid,issue_id,title,state,author,assignees,labels,milestone,created_at,updated_at,due_date,weight,confidential,web_url" > "$OUT"

# ── JSON → CSV (denormalize Project) ─────────────────────────────────────────
jq -r '
  def csvsafe:
    if . == null then "" else
      tostring
      | gsub("\u0000"; "")
      | gsub("\r\n|\n|\r"; " ")
      | gsub("\""; "\"\"")
    end;

  def projpath:
    (.references.full // "") as $f
    | if $f == "" then "" else ($f | split("#")[0]) end;

  [
    (projpath),                     # Project (namespace/project)
    .project_id,
    .iid,
    .id,
    .title,
    .state,
    .author.username,
    ( .assignees // [] | map(.username) | join("|") ),
    ( .labels // []    | join("|") ),
    ( .milestone.title // "" ),
    .created_at,
    .updated_at,
    ( .due_date // "" ),
    ( .weight // "" ),
    ( .confidential // false ),
    .web_url
  ]
  | map(csvsafe)
  | @csv
' "$TMPJSON" >> "$OUT"

echo "[DONE] Wrote CSV: $OUT"
echo "[INFO] Issue rows: $(($(wc -l < "$OUT") - 1))"
