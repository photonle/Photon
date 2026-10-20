# Advanced: GraphQL writes, relationship endpoints and node ids

Secondary reference for [../SKILL.md](../SKILL.md). Reach for it to clear a field, to batch
relationship writes across many issues, or when a script needs node ids.

## Setting fields through GraphQL

Prefer the REST POST in the skill. GraphQL is the only way to **clear** a value. Its single-select
parameter takes the option's **node id**, where REST takes the option name.

```bash
gh api graphql -H 'GraphQL-Features: issue_fields' -f query='
mutation {
  setIssueFieldValue(input: {
    issueId: "ISSUE_NODE_ID"
    issueFields: [{ fieldId: "IFSS_kgDOAudDIw", delete: true }]
  }) { issue { number } }
}'
```

| Field type | Parameter | Format |
| --- | --- | --- |
| Date | `dateValue` | `"2026-10-31"` |
| Single select | `singleSelectOptionId` | option node id |
| Clear | `delete: true` | in place of the value |

An issue's node id: `gh issue view <n> --repo photonle/Photon --json id --jq .id`. Option node ids:
`gh api orgs/photonle/issue-fields --jq '.[] | {name, options: [.options[]? | {name, node_id}]}'`.

Every issue-fields GraphQL call needs the `GraphQL-Features: issue_fields` header. Without it the
types are not in the schema and the error is "field does not exist", not a permissions error. On
`IssueFieldSingleSelectValue` the option's text is `.name`; `.value` is its id.

## Relationship endpoints

`gh issue edit` covers every relationship write. Reach for these to script across many issues.

| Endpoint | Verbs |
| --- | --- |
| `repos/photonle/Photon/issues/{n}/sub_issues` | `GET` list · `POST` add |
| `repos/photonle/Photon/issues/{n}/sub_issue` | `DELETE` remove |
| `repos/photonle/Photon/issues/{n}/sub_issues/priority` | `PATCH` reorder |
| `repos/photonle/Photon/issues/{n}/dependencies/blocked_by` | `GET` list · `POST` add |
| `repos/photonle/Photon/issues/{n}/dependencies/blocked_by/{issue_id}` | `DELETE` remove |
| `repos/photonle/Photon/issues/{n}/dependencies/blocking` | `GET` list |

- **The path takes an issue _number_; every body takes an issue _id_** (`sub_issue_id`,
  `issue_id`, `after_id`, `before_id`): the database id from the issue payload, not `#n`.
- **`sub_issues` is plural for `GET`/`POST`, singular for `DELETE`.**
- **`blocking` is read-only.** Write the edge from the blocked issue's `blocked_by`.
- `POST .../sub_issues` takes `replace_parent: true` to move an issue that already has a parent.

```bash
id=$(gh api repos/photonle/Photon/issues/312 --jq .id)
gh api repos/photonle/Photon/issues/310/sub_issues/priority -X PATCH \
  -F sub_issue_id="$id" -F after_id="$(gh api repos/photonle/Photon/issues/311 --jq .id)"
```

GraphQL mutations: `addSubIssue`, `removeSubIssue`, `reprioritizeSubIssue`, `addBlockedBy`,
`removeBlockedBy`. Relationship fields need no feature header, so one query can read them beside
issue fields as long as the header is present for the fields half, which is what
[`../issues.sh`](../issues.sh) does.

## Issue type node ids

`--type` takes the name; GraphQL (`updateIssueIssueType`) takes these.

| Type | Node id |
| --- | --- |
| Task | `IT_kwDOAs-U3M4AlRGM` |
| Bug | `IT_kwDOAs-U3M4AlRGP` |
| Feature | `IT_kwDOAs-U3M4AlRGQ` |
| Initiative | `IT_kwDOAs-U3M42UZt7` |
| Stub | `IT_kwDOAs-U3M42Uaqm` |
| Spec | `IT_kwDOAs-U3M42Uatz` |
| Epic | `IT_kwDOAs-U3M42Ua6h` |
| Research | `IT_kwDOAs-U3M42UbU-` |
| Wayfinder | `IT_kwDOAs-U3M42Ubbj` |

```bash
gh api orgs/photonle/issue-types --jq '.[] | select(.is_enabled) | {node_id, name}'
```
