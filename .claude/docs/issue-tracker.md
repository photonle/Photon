# Issue tracker: GitHub

Issues, specs and pull requests for Photon live on GitHub at
[`photonle/Photon`](https://github.com/photonle/Photon). Use the `gh` CLI. This page is what the
planning and delivery skills mean when they say "the tracker"; the mechanics behind every line here
(field ids, the REST call for fields, the query helper, relationship flags, close reasons) are in
[the `github-issues` skill](../skills/github-issues/SKILL.md). Read it before any filtered
query or bulk edit.

## Conventions

- **Claim an issue** before its first edit, branch included: `gh issue edit <n> --add-assignee @me`.
  An open, unassigned issue reads as unclaimed, and a second agent picks up the same work.
- **Fetch the relevant ticket**: body and thread together, per
  [Reading an issue](../skills/github-issues/SKILL.md#reading-an-issue). The thread is where later decisions
  are often recorded, so read it, not just the body.
- **Publish to the issue tracker**: create the issue with `--type`, then set its Stage, and Priority
  and Effort as its type needs them, in one POST. Stage is `Triaged` where a skill says the issue is
  born triaged (`/to-tickets`), `Awaiting Review` for a Stub or a Spec, and `New` otherwise.
- **Comment**: `gh issue comment <n> --body-file comment.md`.
- **List or filter**: `.claude/skills/github-issues/issues.sh` piped to `jq`, never a search
  qualifier.
- **Close**: comment the reason, then `gh issue close` with the matching `--reason`. A pull request
  whose body says `Closes #<n>` closes it on merge.

## Stage transitions

`New` → `Awaiting Review` (when a decision is needed) → `Triaged`. Any Stage can move to
`Needs Information`, and returns to `New` once the reporter replies, so the issue resurfaces for
triage. `Blocked` is set by hand and taken off by hand, with its `Blocked on:` line.

An open issue with no Stage was filed before the field existed: it is untriaged, the same as `New`.

## The triaged state

An issue is `Triaged` when it carries a type, Stage `Triaged`, the fields its type needs, and:

| Type | Also needs |
| --- | --- |
| Bug | The claim verified: reproduced, or the faulty code path found. A brief: expected against actual behaviour, and acceptance criteria that prove the fix |
| Task | A brief, or a body that works as one: what to build and how to tell it is done. Blockers wired as blocked-by, and a parent where it has one |
| Epic | Its Tasks as sub-issues, in build order. No brief of its own: its sub-issues carry them |
| Initiative | A body that states the goal, and its Epics and Tasks as sub-issues. No brief of its own |
| Research | The question, and what an answer has to cover |
| Wayfinder | The map, as `/wayfinder` leaves it |

A Spec, a Stub and a Feature never reach `Triaged`. A Spec has the problem and the decisions but no
acceptance criteria, so it is not a brief: `/to-tickets` turns it into issues that are. A Stub has an
idea and its open questions, and a Feature that passes triage has a condensed brief; both wait at
`Awaiting Review` for `/grill-to-spec`, which rewrites each in place as a Spec.

Born triaged: `/to-tickets` creates its tickets and its Epic at `Triaged`, and an Initiative, set up
by hand as planning, starts there too.

## Types the skills produce

| Skill concept | Type and Stage |
| --- | --- |
| A report filed by `/file-issue` | Bug, Task or Research at `New` |
| A sidebar raised in passing, agreed in outline | Stub at `Awaiting Review` |
| A bug confirmed during triage | Bug |
| A spec from `/to-spec` or `/grill-to-spec`, not yet broken down | Spec at `Awaiting Review` |
| A Stub or Feature after `/grill-to-spec` | The same issue, re-typed Spec at `Awaiting Review` |
| A ticket from `/to-tickets`, or a Spec it sized as one ticket | Task at `Triaged` |
| A Spec `/to-tickets` split into several tickets | The same issue, re-typed Epic at `Triaged` |
| A `/wayfinder` map | Wayfinder |
| A `/wayfinder` research ticket | Research |
| A `/wayfinder` grilling, prototype or task ticket | Task |

Bug and Feature also arrive from outside, through the issue templates. Initiative and Stub are set by
hand.

## Wayfinding operations

Used by `/wayfinder`.

- **Map**: a Wayfinder issue with a Priority and no Effort. Its body holds the Destination, Notes,
  Decisions-so-far, Not-yet-specified and Out-of-scope sections.
- **Child ticket**: a sub-issue of the map, in map order. Its wayfinder kind is its type: Research
  for research, Task for grilling, prototype and task, with the kind named on the body's first
  line (`Kind: grilling`). Set a Priority, and Effort where it is known.
- **Blocking**: native blocked-by links.
- **Frontier query**: the map's open sub-issues with an empty `blockedBy` and no assignee, in
  sub-issue order; the first wins.

  ```bash
  .claude/skills/github-issues/issues.sh | jq -c 'select(.parent == <map> and .blockedBy == [] and .assignees == [])'
  ```

  `issues.sh` sorts by last update, so take the order from
  `gh api repos/photonle/Photon/issues/<map>/sub_issues --jq '.[].number'`.
- **Claim**: assign yourself. It is the session's first write.
- **Resolve**: comment the answer, close it as completed, and append a context pointer to the map's
  Decisions-so-far.
- **Rule out of scope**: close it as not planned and add one line to the map's Out of scope section.
  It stays out of Decisions-so-far, which records the route actually walked.
