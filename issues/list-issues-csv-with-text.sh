#!/usr/bin/env bash
# export-gitlab-issues-with-full-text.sh
# Exports GitLab issues to CSV with descriptions and comments for LLM processing
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
OUT="${OUT:-gitlab-issues-with-text.csv}"
FETCH_COMMENTS="${FETCH_COMMENTS:-false}"                    # true|false - set to false by default for speed

TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT
TMPJSON="$TMPDIR/issues.jsonl"
TMPCOMMENTS="$TMPDIR/comments"
mkdir -p "$TMPCOMMENTS"
: > "$TMPJSON"

encode() { python3 - <<'PY' "$1"
import urllib.parse, sys
print(urllib.parse.quote(sys.argv[1], safe=""))
PY
}

# ── Fetch: multiple requests to get all issues ───────────────────────────────
echo "[INFO] Fetching issues..."
IFS=',' read -r -a GROUP_ARR <<< "$GROUP_PATHS"
for gp in "${GROUP_ARR[@]}"; do
  gp_trim="$(echo "$gp" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
  genc="$(encode "$gp_trim")"

  # Fetch multiple pages (GitLab API max is 100 per page)
  for page in 1 2 3 4 5 6 7 8 9 10; do
    URL="$GITLAB_HOST/api/v4/groups/$genc/issues?per_page=100&page=$page&include_subgroups=$INCLUDE_SUBGROUPS&state=$STATE&scope=all&order_by=$ORDER_BY&sort=$SORT"
    echo "[INFO] GET issues page $page"
    BODY="$TMPDIR/body.$RANDOM.json"

    if curl -sS --fail -H "PRIVATE-TOKEN: $TOKEN" "$URL" -o "$BODY" 2>/dev/null; then
      issue_count=$(jq 'length' "$BODY")
      if [ "$issue_count" -eq 0 ]; then
        break
      fi
      jq -c '.[]' "$BODY" >> "$TMPJSON"
      echo "[INFO] Got $issue_count issues from page $page"
    else
      break
    fi
  done
done

# ── Fetch comments for each issue ────────────────────────────────────────────
if [ "$FETCH_COMMENTS" = "true" ]; then
  echo "[INFO] Fetching comments for issues..."
  total_issues=$(wc -l < "$TMPJSON")
  current=0

  while IFS= read -r issue_json; do
    current=$((current + 1))
    project_id=$(echo "$issue_json" | jq -r '.project_id')
    issue_iid=$(echo "$issue_json" | jq -r '.iid')
    issue_id=$(echo "$issue_json" | jq -r '.id')

    # Progress indicator
    if [ $((current % 25)) -eq 0 ] || [ "$current" -eq "$total_issues" ]; then
      echo "[INFO] Processing comments: $current/$total_issues"
    fi

    # Fetch comments for this issue
    COMMENTS_FILE="$TMPCOMMENTS/${issue_id}.json"
    echo "[]" > "$COMMENTS_FILE"

    # Fetch up to 3 pages of comments (300 comments max per issue)
    for cpage in 1 2 3; do
      URL="$GITLAB_HOST/api/v4/projects/$project_id/issues/$issue_iid/notes?per_page=100&page=$cpage"
      CBODY="$TMPDIR/comments_body_${issue_id}_${cpage}.json"

      if curl -sS --fail -H "PRIVATE-TOKEN: $TOKEN" "$URL" -o "$CBODY" 2>/dev/null; then
        comment_count=$(jq 'length' "$CBODY")
        if [ "$comment_count" -eq 0 ]; then
          break
        fi

        # Merge comments into the issue's comment file
        jq -s '.[0] + .[1]' "$COMMENTS_FILE" "$CBODY" > "$COMMENTS_FILE.tmp"
        mv "$COMMENTS_FILE.tmp" "$COMMENTS_FILE"

        if [ "$comment_count" -lt 100 ]; then
          break
        fi
      else
        break
      fi
    done
  done < "$TMPJSON"
  echo "[INFO] Comments fetching complete"
fi

# ── CSV header ───────────────────────────────────────────────────────────────
echo "Project,project_id,issue_iid,issue_id,title,state,author,assignees,labels,milestone,created_at,updated_at,due_date,weight,confidential,web_url,full_text" > "$OUT"

# ── JSON → CSV with denormalized text ────────────────────────────────────────
echo "[INFO] Generating CSV with full text..."
jq -r --slurpfile comments_map <(
  # Create a JSON object mapping issue IDs to their comments
  for f in "$TMPCOMMENTS"/*.json; do
    if [ -f "$f" ]; then
      issue_id=$(basename "$f" .json)
      echo "{\"$issue_id\": $(cat "$f")}"
    fi
  done | jq -s 'add // {}'
) '
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

  def format_comments($comments):
    if $comments == null or ($comments | length) == 0 then
      ""
    else
      $comments
      | map(select(.system != true))  # Filter out system messages
      | map(
        "Comment by " + (.author.username // "unknown") +
        " (" + (.created_at // "") + "): " +
        (.body // "")
      )
      | join(" | ")
    end;

  def build_full_text($comments):
    # Build a structured text representation for LLM processing
    "ISSUE TITLE: " + (.title // "") + "\n" +
    "STATE: " + (.state // "") + "\n" +
    "AUTHOR: " + (.author.username // "") + "\n" +
    "CREATED: " + (.created_at // "") + "\n" +
    "LABELS: " + ((.labels // []) | join(", ")) + "\n" +
    "ASSIGNEES: " + ((.assignees // []) | map(.username) | join(", ")) + "\n" +
    "DESCRIPTION: " + (.description // "No description") + "\n" +
    if $comments and ($comments | length) > 0 then
      "COMMENTS:\n" + format_comments($comments)
    else
      "COMMENTS: None"
    end;

  . as $issue
  | ($comments_map[0][.id | tostring] // []) as $issue_comments
  | [
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
    .web_url,
    build_full_text($issue_comments)
  ]
  | map(csvsafe)
  | @csv
' "$TMPJSON" >> "$OUT"

echo "[DONE] Wrote CSV: $OUT"
echo "[INFO] Issue rows: $(($(wc -l < "$OUT") - 1))"
echo "[INFO] File size: $(du -h "$OUT" | cut -f1)"