---
name: github-issues
description: "Read and set issue type, the Stage, Priority, Effort and date issue fields, sub-issue and blocked-by links, and close reasons on photonle/Photon issues. Use when creating, triaging, querying, updating, linking or closing an issue. Prevents recording priority or status in labels, and building issue lists on search qualifiers that silently return nothing."
argument-hint: "[issue-number] | create | query | link [issue-number]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Bash
model: sonnet
---

# GitHub issues (photonle/Photon)

## The mistakes this skill exists to prevent

1. **Recording a value where the skills don't look.** Stage, Priority, Effort, Start date and
   Target date are **org issue fields**: values stored on the issue itself, defined once for the
   `photonle` org. They are not labels and not project fields. This repo has no project board; the
   org's `Photon v2` board tracks `photonle/Photon-v2`, a different codebase.
2. **Building a list on search.** GitHub's issue-field search qualifiers return nothing even when
   issues match. Query through [`issues.sh`](#querying).

## Where each piece of metadata lives

| What | Mechanism | Set with |
| --- | --- | --- |
| Type | Org issue type, exactly one per issue | `gh issue create --type` · `gh issue edit --type` |
| Stage, Priority, Effort, Start date, Target date | Org issue fields | REST POST, see [Setting fields](#setting-fields) |
| Parent / sub-issue | Native sub-issues | `--parent` · `--add-sub-issue` |
| Blocked by / blocking | Native dependencies | `--add-blocked-by` · `--add-blocking` |
| Blocked by something that isn't an issue | Stage `Blocked`, plus a `Blocked on:` line in the body | See [Blocked by something that isn't an issue](#blocked-by-something-that-isnt-an-issue) |
| Why it closed | Native close reason | `gh issue close --reason` |
| Claimed by | Assignee | `gh issue edit --add-assignee @me` |
| Topic | Repo label | `gh issue edit --add-label` |

## Org issue fields

All are `organization_members_only`: logged-out readers do not see them.

| Field | REST id | GraphQL node id | Values |
| --- | --- | --- | --- |
| Stage | `48710435` | `IFSS_kgDOAudDIw` | `New` · `Needs Information` · `Awaiting Review` · `Triaged` · `Blocked` |
| Priority | `12894770` | `IFSS_kgDOAMTCMg` | `Urgent` · `High` · `Medium` · `Low` |
| Effort | `12894773` | `IFSS_kgDOAMTCNQ` | `High` · `Medium` · `Low` |
| Start date | `12894771` | `IFD_kgDOAMTCMw` | `YYYY-MM-DD` |
| Target date | `12894772` | `IFD_kgDOAMTCNA` | `YYYY-MM-DD` |

Re-discover if a write returns 422 or a field looks missing:

```bash
gh api orgs/photonle/issue-fields --jq '.[] | {id, node_id, name, options: [.options[]?.name]}'
```

### Stage

Stage is where an issue sits in the planning pipeline. The skills route on it.

| Stage | Meaning | Set by |
| --- | --- | --- |
| `New` | Filed, not yet looked at | Anyone filing an issue by hand, `/file-issue` |
| `Needs Information` | Waiting on the reporter before triage can finish | `/triage` |
| `Awaiting Review` | Triaged, waiting to be grilled into a spec or broken into tickets | `/triage` on a Feature; born on a Stub, and on a Spec from `/to-spec` or `/grill-to-spec` |
| `Triaged` | Ready to deliver | `/triage` on a Bug, Task or Research; born on tickets from `/to-tickets` |
| `Blocked` | Stopped on something no dependency can name | By hand, see below |

An open issue with **no Stage** predates the field and has never been triaged. Treat it as `New`.

### Which fields a type needs

An issue is triaged once it carries the fields its type needs:

| Type | Priority | Effort |
| --- | --- | --- |
| Bug, Task, Research | required | required |
| Feature, Stub, Spec, Epic, Initiative, Wayfinder | required | none |

A Feature, Stub or Spec never reaches `Triaged`, but still carries a Priority so a wave or a planner
can rank it.

### Choosing Priority and Effort

| Priority | When |
| --- | --- |
| `Urgent` | Breaks servers or errors for everyone running Photon, or a regression in the latest release |
| `High` | Broken or missing for many users, with no reasonable workaround |
| `Medium` | Real, with a workaround or a narrow audience. The default when nothing argues up or down |
| `Low` | Cosmetic, rare, or a nice-to-have |

| Effort | When |
| --- | --- |
| `Low` | One focused change in one area; well inside a single session |
| `Medium` | Several files or both realms; about one session |
| `High` | More than one session can hold. Usually a sign it should be a Spec broken into Tasks |

State the reason for each in the triage recommendation, so the maintainer is correcting a judgement
rather than a guess.

## Choosing a type

Pick the type whose description matches the issue. `Task` is not a default.

**Inbound** issues arrive from outside the planning process, unsized. `/triage` sizes them.

| Type | Use for | Signal |
| --- | --- | --- |
| Bug | Photon misbehaves against its intended behaviour | Reproduction steps, expected vs. actual. The bug-report template |
| Feature | A request or idea for new functionality, not yet decided or specified | "Please add". The feature-request template. Once triaged and grilled, `/grill-to-spec` re-types it Spec in place |

**Planned** issues are internal work. Apart from Stub and Spec, they form a ladder from one change
up to a goal.

| Type | Use for | Signal |
| --- | --- | --- |
| Stub | An idea agreed in outline that needs grilling: a title, a paragraph and its open questions | Filed by hand, often a batch under an Initiative or Epic. `/grill-to-spec` rewrites it in place as a Spec, so it keeps its number and its parent. Born `Awaiting Review`, with a Priority and no Effort |
| Spec | A worked-through specification, not yet broken into tickets | Created by `/to-spec` or `/grill-to-spec`. `/to-tickets` re-types it Task when it is small enough, or Epic |
| Task | One piece of decided work: a ticket split from a spec, a refactor, a migration or a chore | No "it's broken" or "please add" framing |
| Epic | One feature too big for a single task | You are about to give it Task sub-issues, not close it directly |
| Initiative | Several features or fixes grouped under one goal or named update | Its sub-issues are Epics, Tasks or both |

**Outside the ladder:**

| Type | Use for | Signal |
| --- | --- | --- |
| Research | A question answered by reading sources | The outcome is findings, not code |
| Wayfinder | A `/wayfinder` map of decision tickets toward a large goal | Created by `/wayfinder` only |

An idea raised internally is a Task if it is already decided, a Spec if it has been worked through
and only needs writing up, and a Stub if it is agreed in outline but still needs grilling. Feature
is for requests from outside.

## Creating an issue

Set the type at creation. An issue created from `gh` arrives untyped otherwise:

```bash
gh issue create --repo photonle/Photon --type Bug --title "..." --body-file body.md
```

`create` also takes `--parent <n>` and `--blocked-by <n>,<n>`. It prints the issue URL; the number
is its last path segment. Then set its Stage, Priority and Effort in one POST, below: there is no
`create` flag for issue fields.

## Setting fields

```bash
gh api repos/photonle/Photon/issues/<n>/issue-field-values -X POST --input - <<'EOF'
{"issue_field_values": [
  {"field_id": 48710435, "value": "New"},
  {"field_id": 12894770, "value": "High"},
  {"field_id": 12894773, "value": "Medium"}
]}
EOF
```

Every way of getting this wrong is a loud 422. Trust the error text and fix the call:

1. **`value` is the option _name_**, not its id. The read endpoint returns the id in `value` and
   the name under `single_select_option.name`, so a read cannot be round-tripped into a write.
2. **Wrap the values** in an `issue_field_values` array, sent with `--input -` as JSON. `-f`/`-F`
   send flat form keys, which fail with `"issue_field_values" wasn't supplied`.
3. **One POST carries every field.** It merges: fields you omit keep their values. A Stage change
   is a POST of the Stage alone.

The response is the issue's full field set after the write, so it is your read-back. To read one
issue's fields later:

```bash
gh api repos/photonle/Photon/issues/<n>/issue-field-values \
  --jq '.[] | "\(.issue_field_name): \(.single_select_option.name // .value)"'
```

An issue with nothing set returns `[]`.

Clearing a value needs GraphQL: `setIssueFieldValue` with `delete: true` for that field's node id,
under the `GraphQL-Features: issue_fields` header.

## Querying

The search qualifier for issue fields (`field.priority:High`) returns 0 results even when issues
match, so a list built on it reads as "nothing to do". Use [`issues.sh`](issues.sh): it pages every issue in one state through GraphQL and prints one JSON
object per line, with type, Stage, Priority, Effort, dates, labels, assignees, parent, sub-issue
progress and the **open** issues blocking it. Filter with `jq`:

```bash
.claude/skills/github-issues/issues.sh | jq -c 'select(.stage == "New" or .stage == null)'
.claude/skills/github-issues/issues.sh | jq -c 'select(.type == "Bug" and .priority == "High")'
.claude/skills/github-issues/issues.sh | jq -c 'select(.parent == 310)'
.claude/skills/github-issues/issues.sh CLOSED | jq -c 'select(.type == "Spec")'
```

An issue is **ready** when its Stage is `Triaged` and its `blockedBy` list is empty.

## Reading an issue

```bash
gh issue view <n> --repo photonle/Photon --json title,body,comments --jq '.title, .body, (.comments[] | "--- \(.author.login)\n\(.body)")'
gh issue view <n> --repo photonle/Photon --json number,title,issueType,labels,parent,subIssues,blockedBy,blocking
```

`--comments` prints the thread *without* the body, and nothing at all on an issue with no comments,
so read both from `--json` as above. `gh issue edit --type` prints only the URL: read `issueType`
back with the second line.

For an Epic or Initiative, `subIssuesSummary` gives `total` / `completed` without listing every
child.

## Relationships

| Relationship | Cardinality | Set with |
| --- | --- | --- |
| Parent / sub-issue | One parent; up to 100 sub-issues, 8 levels deep | `--parent` · `--add-sub-issue` · `--remove-parent` · `--remove-sub-issue` |
| Blocked by / blocking | Many, either direction | `--add-blocked-by` · `--add-blocking` · their `--remove-*` twins |

```bash
gh issue edit <n> --repo photonle/Photon --parent 310 --add-blocked-by 305
```

- **`--parent` moves an issue that already has a parent**, rather than erroring.
- **Blocked-by and blocking are one edge seen from two ends.** Write it from whichever issue you
  are already editing.
- **Sub-issue order is the build order.** An Epic's sub-issues are listed in the order its tickets
  should land; `/to-tickets` creates them in that order. Reorder with
  `PATCH repos/photonle/Photon/issues/<parent>/sub_issues/priority`.
- A Spec re-typed by `/to-tickets` or `/grill-to-spec` keeps its number, so it keeps its parent and
  its place in the order.

Batch writes, cross-issue reads and the REST endpoints are in
[references/advanced.md](references/advanced.md).

### Plain relationships go in the prose

Keep sub-issues for work that decomposes and blocked-by for work that has to wait. Anything looser,
such as context, prior art or an issue that merely informs this one, is a `#`-reference inside a
sentence that carries the reason:

> Same root cause as #292, which adds the vehicle-base adapter this depends on.

### Blocked by something that isn't an issue

When work is stopped on something a dependency can't point at (a model from an artist, a decision
taken off the tracker, an upstream Garry's Mod fix), set Stage `Blocked` and add a `Blocked on:`
line to the body in the same edit. When it arrives, remove the line and set the Stage back. If the
blocker is an issue, it is a blocked-by link instead. On an Epic or Initiative, `/wave` holds back
every sub-issue under it too.

## Labels

Labels are repo topics, a separate axis from type.

- **Superseded:** `bug`, `feature` and `enhancement` (the issue type carries this), `priority none`
  (Priority field), `duplicate` and `wontfix` (close reasons). Never add one. The issue templates
  still add `bug` and `feature`: when triage sets the type, remove them in the same pass
  (`gh issue edit <n> --remove-label bug,feature,enhancement,"priority none"`).
- **Topics, still in use:** `library`, `ci/cd`.
- **`autorelease: pending`** belongs to release-please, on its release PRs. Never set it by hand.

## Closing an issue

Comment the reasoning first, then close with the reason:

| Outcome | Close with |
| --- | --- |
| Fixed, or already implemented | `gh issue close <n> --reason completed` |
| Out of scope, rejected, can't reproduce | `gh issue close <n> --reason "not planned"` |
| Already tracked elsewhere | `gh issue close <n> --duplicate-of <other>` |

A pull request whose body says `Closes #<n>` closes it as completed on merge.

## Checklist

- [ ] Type chosen against the tables above and set with `--type`
- [ ] Stage set: `New` unless the issue is born at a later stage
- [ ] Priority, and Effort where the type needs it, set in the same POST
- [ ] Any filtered list came from `issues.sh`, never a `field.*` search qualifier
- [ ] Real blockers wired as blocked-by; children as sub-issues, in build order
- [ ] On close: comment, then the matching close reason
