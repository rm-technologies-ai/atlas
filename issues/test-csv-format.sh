#!/bin/bash
# Test the CSV formatting with sample GitLab issue JSON

cat > /tmp/test-issue.jsonl << 'EOF'
{"id":1,"iid":10,"project_id":100,"project":{"path_with_namespace":"group/project"},"title":"Test Issue","state":"opened","created_at":"2025-01-01T10:00:00Z","updated_at":"2025-01-02T11:00:00Z","author":{"username":"user1"},"assignees":[{"username":"dev1"},{"username":"dev2"}],"labels":["bug","urgent"],"milestone":{"title":"v1.0"},"due_date":"2025-02-01","weight":3,"confidential":false,"web_url":"https://gitlab.com/group/project/-/issues/10"}
{"id":2,"iid":20,"project_id":200,"project":{"path_with_namespace":"group2/project2"},"title":"Issue with \"quotes\" and\nnewlines","state":"closed","created_at":"2025-01-03T12:00:00Z","updated_at":"2025-01-04T13:00:00Z","author":{"username":"user2"},"assignees":[],"labels":[],"milestone":null,"due_date":null,"weight":null,"confidential":true,"web_url":"https://gitlab.com/group2/project2/-/issues/20"}
EOF

echo "Testing CSV conversion..."
echo "Project,project_id,issue_iid,issue_id,title,state,author,assignees,labels,milestone,created_at,updated_at,due_date,weight,confidential,web_url" > /tmp/test.csv

/tmp/jq -r '
  def csvsafe:
    if . == null then "" else tostring | gsub("\""; "\"\"") | gsub("\r"; "") | gsub("\n"; " ") end;

  def arraytostr:
    if . == null then ""
    elif type == "array" then (map(if type == "object" then (.name // .username // "") elif type == "string" then . else "" end) | join(","))
    else tostring end;

  [
    (.project.path_with_namespace // ""),
    (.project_id // ""),
    (.iid // ""),
    (.id // ""),
    (.title | csvsafe),
    (.state // ""),
    (.author.username // ""),
    (.assignees | arraytostr),
    (.labels | arraytostr),
    (.milestone.title // "" | csvsafe),
    (.created_at // ""),
    (.updated_at // ""),
    (.due_date // ""),
    (.weight // ""),
    (.confidential // false),
    (.web_url // "")
  ] | @csv
' /tmp/test-issue.jsonl >> /tmp/test.csv

echo -e "\nGenerated CSV:"
cat /tmp/test.csv