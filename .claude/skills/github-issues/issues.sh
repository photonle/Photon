#!/usr/bin/env bash
# Print every issue in photonle/Photon in one state, one JSON object per line, with its type, labels,
# org issue fields, parent, open blockers and sub-issue progress. Filter the output with jq.
#
#   .claude/skills/github-issues/issues.sh [OPEN|CLOSED]
#
#   issues.sh | jq -c 'select(.stage == "New")'
#   issues.sh | jq -c 'select(.type == "Bug" and .priority == "High")'
#   issues.sh | jq -c 'select(.stage == null)'            # never triaged
#   issues.sh | jq -c 'select(.blockedBy == [])'          # nothing open blocks it
#
# Issue fields live behind the issue_fields GraphQL feature header; without it the schema has no
# issueFieldValues and the query fails with "field does not exist".
set -euo pipefail

state=${1:-OPEN}

gh api graphql --paginate -H 'GraphQL-Features: issue_fields' -F state="$state" -f query='
query($state: IssueState!, $endCursor: String) {
  repository(owner: "photonle", name: "Photon") {
    issues(first: 100, after: $endCursor, states: [$state], orderBy: {field: UPDATED_AT, direction: DESC}) {
      pageInfo { hasNextPage endCursor }
      nodes {
        number
        title
        createdAt
        author { login }
        comments(last: 1) { nodes { author { login } } }
        issueType { name }
        labels(first: 20) { nodes { name } }
        assignees(first: 5) { nodes { login } }
        parent { number }
        subIssuesSummary { total completed }
        blockedBy(first: 20) { nodes { number state } }
        issueFieldValues(first: 10) {
          nodes {
            ... on IssueFieldSingleSelectValue { name field { ... on IssueFieldSingleSelect { name } } }
            ... on IssueFieldDateValue { value field { ... on IssueFieldDate { name } } }
          }
        }
      }
    }
  }
}' --jq '.data.repository.issues.nodes[]
  | (.issueFieldValues.nodes | map(select(.field) | {key: .field.name, value: (.name // .value)}) | from_entries) as $f
  | {
      number, title,
      created: .createdAt[:10],
      author: .author.login,
      lastCommenter: .comments.nodes[0].author.login,
      type: .issueType.name,
      stage: $f.Stage, priority: $f.Priority, effort: $f.Effort,
      startDate: $f["Start date"], targetDate: $f["Target date"],
      labels: [.labels.nodes[].name],
      assignees: [.assignees.nodes[].login],
      parent: .parent.number,
      subIssues: .subIssuesSummary,
      blockedBy: [.blockedBy.nodes[] | select(.state == "OPEN") | .number]
    }
  | tojson'
