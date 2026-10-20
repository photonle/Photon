---
name: wave
description: "Dispatch every child that can move right now — across initiatives, epics or tickets — to the skill that advances it, one session each, or work the earliest one here with --inline: the next wave after /to-tickets or a round of merges."
argument-hint: "[--inline] <issue-number|#number|issue-url>…"
disable-model-invocation: true
---

# Wave

Launch the next **wave** across everything the arguments reach: their **frontier** (every child that
can move right now), each handed to its own session running the skill that advances it from where it
is. One run launches one wave and stops, or with [`--inline`](#inline-mode) works one ticket of it
itself. The human merges that wave's PRs and answers what the parked sessions asked, and the next
`/wave` run finds the frontier that opened.

GitHub is the only state: every run reads the tree afresh. Mechanics for every edit below are in
[the `github-issues` skill](../github-issues/SKILL.md).

## Inline mode

`--inline`, anywhere among the arguments, narrows the wave to **one** ticket worked in **this**
session: the Frontier entry with the lowest issue `number`, the earliest filed. Strip the flag before
calling `frontier.py`. Sections 1 and 2 run unchanged; from there:

- **Section 3** is skipped: one ticket spawns nothing.
- **Section 4** claims that one entry only. Every other Frontier entry stays unclaimed, so the next
  run finds it on the frontier again.
- **Section 5** becomes: set this session's title to `#<n>: <title>`, then read
  `.claude/skills/<skill>/SKILL.md` for the entry's `action.skill` and follow it with
  `action.argument`, to that skill's own completion criterion.
- **Section 6** is reported **before** section 5 starts, so the wave's state sits above the work
  rather than under it. The chosen entry is **Working here**, in place of Running and Coming back to
  you; every other Frontier entry is listed as **Still on the frontier**, with its skill and parent.

An empty frontier ends the run at section 6, naming the bucket holding it up.

## 1. Resolve the frontier

[`frontier.py`](frontier.py) beside this file does the walking and the classifying. It is
**authoritative** on everything in section 2: the table there documents what it decides, and when the
two disagree the script is right and the table is a bug.

```bash
python .claude/skills/wave/frontier.py fetch 310 '#320' > "$SCRATCH/wave.json"
python .claude/skills/wave/frontier.py classify "$SCRATCH/wave.json"
```

Fetching and classifying are separate on purpose: `classify` is a pure function of its payload, which
is what puts the ladder in the unit suite ([`test_frontier.py`](test_frontier.py):
`python -m unittest discover -s .claude/skills/wave`). Keep the payload in your scratchpad, so a
re-read costs nothing.

**Arguments** are one or more issues, space separated, each an Initiative, Epic or ticket, as a bare
number, a `#`-prefixed number or a full `photonle/Photon` issue URL. They resolve into **one**
frontier: a ticket two of them reach is started once. An invocation with **no issue arguments is an
error**, `--inline` alone included — say so and stop, rather than guessing at a scope.

`classify` prints:

| Key | What it holds |
| --- | --- |
| `arguments` | One entry per argument, `status` `ok` or `skipped` with a `reason` |
| `buckets` | `frontier`, `in_flight`, `blocked`, `human` and `done`, each entry naming its `parent` and the `root` argument it was reached from; each frontier entry carries the `action` that advances it |
| `parents` | Every container the walk visited, and whether its sub-issues are `all_done` |
| `warnings` | Sub-issues the walk could not read, and cycles it cut |
| `counts` | Per-bucket totals, for the guard in section 3 |

An argument that cannot be read (a pull request number, a missing issue), or that is already closed,
comes back `skipped`. **Report it and carry on**: one bad argument never costs the run. A closed
argument takes its children with it — closing a container is a human judgement about the whole
feature, and the wave respects it.

## 2. What the ladder does

The walk descends into a **container**: an open Initiative or Epic with sub-issues. A container is
never bucketed, it is walked — uncapped, so an Initiative holding an Epic holding Tasks resolves those
Tasks. Everything else is a **leaf** and goes down this table, first match winning:

| Condition | Bucket | Action |
| --- | --- | --- |
| Closed | **Done** | — |
| Assigned, or an open pull request closes it | **In flight** | — |
| Stage `Needs Information`, or a Wayfinder | **Human** | — |
| An open blocked-by issue, or Stage `Blocked` | **Blocked** | — |
| Stage `New`, or no Stage | **Frontier** | `/triage` |
| A Feature at `Awaiting Review` or `Triaged` | **Frontier** | `/grill-to-spec` |
| A Stub, at any Stage | **Frontier** | `/grill-to-spec` |
| A Spec at `Awaiting Review` | **Frontier** | `/to-tickets` |
| An Epic or Initiative with no sub-issues | **Frontier** | `/to-tickets` |
| A Research issue | **Frontier** | `/research` |
| A Task or Bug at `Triaged` | **Frontier** | `/deliver` |
| Anything else | **Human** | — |

Stage is a condition **on each row** rather than a gate applied across all of them, so every Stage
on the ladder has a route out. One run moves a child **one rung**: the claim in section 4 holds it
out of the next wave until the maintainer releases it, the same way any assigned issue is held.

Three consequences are deliberate:

- A Feature never reaches `/deliver`. One that survives triage is by definition undesigned: it waits
  at `Awaiting Review` for its grilling, which re-types it Spec in place, so the next wave finds it on
  the `/to-tickets` row.
- Dispatching a Spec is not bypassing its review. `Awaiting Review` records that the outstanding
  decision is *how it breaks down*, and `/to-tickets` makes that decision with its own quiz step.
- A child needing a person is reported **above** its blockers, because the judgement nobody has made
  is why it is stuck.

An assignee on a *container* is who is driving that feature, not a claim on its sub-issues, which is
why containers are walked before this table is reached. A container at Stage `Blocked`, or with an
open blocker, is the exception: it goes straight to **Blocked** and is not walked, because stopping
an Epic by hand means stopping its Tasks too.

**Nothing is ever closed.** A parent whose `all_done` is true is reported as ready for the human to
close, and left open.

## 3. The spawn guard

One run reaches every ticket under an Initiative, so count before spawning. `counts.frontier` is one
combined count across every action. At **10** or fewer, spawn with no prompt. Above it, stop and ask,
naming the count and the **full list** — every frontier ticket with the skill it would run and its
parent — so the answer can be given without looking anything up. Answer it **everything or
nothing**: narrowing a wave is done by re-running with fewer arguments, which is reproducible.

## 4. Claim every dispatch

Assign each **Frontier** entry to yourself, **before** anything is spawned, per
[the tracker's conventions](../../docs/issue-tracker.md#conventions):

```bash
gh issue edit <n> --repo photonle/Photon --add-assignee @me
```

A session parked on a question has no pull request to show for itself, so an unclaimed ticket reads
as unclaimed to the next run, which dispatches it a second time. Claiming here keeps every skill on
the ladder unmodified.

Done when every entry is assigned. A claim that fails is a ticket **not** to spawn: report it in
section 6 instead.

## 5. Spawn the wave

Every **Frontier** entry is claimed by now, and each gets one session running its `action.skill`.

- **In the Claude desktop app**, with the session-start tool in reach: start one session per entry,
  `initiation: "user_asked"` (invoking `/wave` is the request), `context: "fresh"`, its own worktree,
  titled `#<n>: <title>`, with the prompt below as its brief and one line of background naming the
  wave's arguments.
- **Anywhere else**, print each filled prompt in its own fenced block for the human to start by hand.

### The prompt

One template covers every action. For a ticket the walk reached through a parent:

```text
Run /<skill> with the argument <argument>: photonle/Photon issue #<n>, "<title>", under #<parent>,
"<parent title>".

Read that issue first. A spawned session gets its opening message as text rather than as a typed
command, so a bare /<skill> never runs: read .claude/skills/<skill>/SKILL.md and follow it with that
argument.

This session's title already names its issue, so leave it as it is.
```

For a ticket **passed as an argument itself** (its `parent` is `null`), drop the `under #<parent>`
clause.

Take `<skill>` and `<argument>` from the entry's `action` rather than deciding either here. The
script writes `<parent>/<n>` for a `/deliver` dispatch under a parent and the bare `<n>` everywhere
else, since `/deliver` reads `<epic>/<ticket>` as two different issues.

Write the prompt to stand alone — a spawned session starts from an empty conversation. The skill it
names carries the blocker check and, where it implements, the `Closes #<n>.` line the next wave
depends on.

## 6. Report

The buckets stay **flat** across the whole run, one list each, and **every line names the parent its
ticket hangs off**. Report in this order:

- **Skipped arguments**: each with its reason, if any were skipped.
- **Running**: every spawned entry whose `action.waits_for_you` is false, by title, linked, with the
  skill it is running and its parent.
- **Coming back to you**: every spawned entry whose `action.waits_for_you` is true, the same way. Mark
  any whose `action.multi_round` is true as **multi-round**: a grilling is several exchanges, not one
  answer.
- **In flight**: each ticket with its pull request or assignee, and its parent.
- **Blocked**: each ticket with the open issues blocking it, and its parent. Where `held` is true, its
  Stage is `Blocked`: quote its body's `Blocked on:` line, since no issue names the blocker.
- **Needs a person**: each ticket with its `reason`.

Then anything in `warnings`, and every parent whose `all_done` is true, as ready for the human to
close. When nothing was dispatched, say which bucket is holding the run up.

Where a run is interrupted between claiming and spawning, say which tickets were left claimed with no
session behind them — those are the only ones a re-run will not pick up again.
