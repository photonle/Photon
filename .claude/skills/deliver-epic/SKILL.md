---
name: deliver-epic
description: "Deliver every ready ticket of an Epic, one after another on one branch, then review the whole Epic, open a single draft pull request, and walk its open items with you until it is marked ready on a green CI."
argument-hint: "<epic>"
disable-model-invocation: true
---

# Deliver an Epic

Conduct a whole Epic from its sub-issues to one reviewed, green pull request. It is
[`/deliver`](../deliver/SKILL.md) run once per ticket, on one branch, with a review of the whole Epic
at the end. You are the **conductor**: you hold every write to GitHub and every git check, and the
build runs in the [`deliver-epic`](../../workflows/deliver-epic.js) workflow:

| Stage | Model | What it is |
| --- | --- | --- |
| Per ticket, in order | as `/deliver` | the [`deliver-stages`](../../workflows/deliver-stages.js) workflow, unchanged: red beside a read-only explorer, green, both reviews, one fix round |
| Final review | Opus | `/code-review` over the whole branch, beside `/standards-review` against the Epic |
| Final fix | Sonnet | one round over the final review's blocking findings |
| Repair | Sonnet | only when that fix round leaves the suite red: make it green, nothing more |

Once every ticket is delivered and CI is green, you walk the pull request's open items with the
human (step 9): they decide each one, and you fix, file or drop it, then review the branch again. The
pull request stays a draft until the walk ends on a green CI.

Use `/wave` instead when each ticket should land as its own pull request.

## 1. Find an earlier run

The argument is one Epic: a number, `#`-number or `photonle/Photon` issue URL. With no argument, say
so and stop.

Read its type first ([Reading an issue](../github-issues/SKILL.md#reading-an-issue)). A Bug or Task
is one ticket, so it is `/deliver`'s: say so ("#314 is a Bug, delivering it with /deliver"), then
read [`/deliver`](../deliver/SKILL.md) and follow it from its step 1 with the same argument, in place
of everything below. Read the file rather than calling the Skill tool, which cannot invoke
`/deliver`. Any other type goes on to the plan, which stops on anything that is not an Epic.

Every ticket's red cases have to be seen failing, then passing, before the next ticket builds on
them, so this skill needs the **`local`** runner `/deliver` step 1 describes: `docker info`
succeeds, so `.github/scripts/gluatest-local.sh` runs here. Without it, as in a cloud session, stop
and say so: `/deliver` proves each ticket's red cases on its own pull request's CI instead, one
ticket at a time.

Read your login with `gh api user --jq .login`. Then look for a pull request an earlier run of this
skill opened (`gh pr list --repo photonle/Photon --state open --json number,body,headRefName,isDraft`),
keeping the one whose description has the line `Part of #<epic>.` or `Closes #<epic>.` (step 7),
whatever its head branch is called: an earlier run may have used its session's branch (step 3).

- **A draft with `Part of #<epic>.`**: a stopped run. This run **resumes** it, on its head branch,
  whatever branch this session names.
- **A draft with `Closes #<epic>.`**: every ticket is delivered and the walk is unfinished. Check out
  its head branch and go straight to step 9.
- **Ready**: the Epic is delivered, walked and waiting for review. Report it and stop.
- **None**: this run starts fresh.

## 2. Plan

Let [`plan.py`](plan.py) do every issue read:

```bash
python .claude/skills/deliver-epic/plan.py <epic> --as <you> --script <scratchpad>/deliver-epic-<epic>.js [--resume-pr <n>]
```

Pass `--resume-pr` with the draft's number when resuming, and a `--script` path in your scratchpad
directory. It prints one JSON document; a failed read exits 1 and prints nothing. It orders the
Epic's open sub-issues by their blocked-by links to each other, ties broken by sub-issue order, and
lists each ticket's acceptance `criteria`. When the plan is `ok`, it also writes the workflow step 5
runs to the `--script` path, with each ticket's brief and the Epic's body baked in: they never pass
through this conversation. The plan is **all or nothing**:

- **`ok` false**: name every entry in `stops` with its `skill`, and stop. A ticket that is not a
  triaged Task or Bug, has no acceptance criteria or seams, is claimed by someone else, or waits on
  an issue outside the Epic means the Epic is not ready to land as one.
- **`done`**: sub-issues already closed. Nothing to do.

Read every ticket's `criteria` for one **only a person can satisfy**: a check on a live server, a
decision recorded on the ticket, content or access no agent has. It does not stop the plan, because
the rest of the ticket can still be built; it is a thing the pull request cannot finish. Name each in
step 4, and carry it to the pull request in step 7: an open item, and a step in the in-game test plan
when a person in game can check it.

Each ticket's baked brief carries its body, its whole comment thread and the issues and pull requests
that mention it, and the Epic's brief its body and thread: later decisions and follow-ups are recorded
there, not in the body. A ticket's `criteria` come from its body or, failing that, its latest triage
brief. Read every ticket's `open_references` before step 4: an open issue that mentions a ticket may
be a follow-up that changes what it should build. Name each to the human there, with what it says,
and stop if one contradicts its ticket's acceptance criteria.

On a resume, every ticket with `resume_pr` true is already delivered, and the script leaves it out:
collect it for `delivered`, with its title and the summary under its `### #<n>` heading in the draft.
With nothing left to deliver, skip step 4: only the final pass remains.

Rename the session where the client offers `set_session_title` ("Deliver Epic #310: <title>").

## 3. Branch

- **Fresh**: `git fetch origin development`, then cut a branch from `origin/development` **without
  tracking it**, so a bare `git push` can never land on `development`:

  ```bash
  git switch --no-track -c epic-<epic>-<slug> origin/development
  ```

  Where the session names its own branch, use that name instead, reset to `origin/development`, with
  `git branch --unset-upstream` after. Push with `git push -u origin HEAD`. The local `development`
  is never the base.
- **Resuming**: check out the draft's branch, `git fetch origin development` and rebase onto
  `origin/development`. A conflict ends the run at step 8: abort the rebase and report it, rather
  than resolving it unattended. Run `bash .github/scripts/gluatest-local.sh` on the rebased head;
  red ends the run the same way. For each ticket in `delivered`, add `testFiles`: the test files its
  `test` commit on the branch touched.

## 4. Guard and claim

Count the tickets left to deliver. Above **6**, stop and ask whether to deliver all of them, naming
the count and every ticket with its title in plan order. Offer two answers, all or none: an Epic is
narrowed by splitting it. At six or fewer, carry on without asking.

Either way, say which criteria only a person can satisfy (step 2), before anything is claimed, so the
human hears it at the start of the run rather than in the pull request.

Then assign every ticket in the plan to yourself, **before** the first stage runs, per
[the tracker's conventions](../../docs/issue-tracker.md#conventions):

```bash
gh issue edit <n> --repo photonle/Photon --add-assignee @me
```

A long run that stops part-way otherwise leaves tickets a parallel `/wave` would dispatch again.

## 5. Run the workflow

Call the Workflow tool with `scriptPath` set to the plan's `script`, which already carries the Epic,
its brief and the tickets, and only these `args`. Run that file itself, never a script of your own
that calls `workflow('deliver-epic', …)`: nesting stops at one level, `deliver-epic` spends it on
`deliver-stages`, and a wrapper fails before its first agent.

| Key | Value |
| --- | --- |
| `delivered` | `[{ number, title, summary, testFiles }]` from steps 2 and 3, or `[]` |
| `startHead` | `git rev-parse HEAD`, now |

Calling it from here is the user's opt-in to the workflow: invoking `/deliver-epic` is the request.

It returns one compact result; the review reports stay in its journal:

- `tickets`: one entry per ticket delivered this run, with its `redCommit`, `testFiles`, `head`,
  `summary`, `suitesRun`, `untested`, `redTestsEdited` and the findings still `outstanding`.
- `stopped`: `null`, or the ticket that did not finish, its `stage`, its account (`blocked`, or
  `suite` and `gates`), and `resetTo`, the last good head.
- `final`: `null` when a ticket stopped, otherwise the final pass: its `level`, whether it was
  `repaired` or `reverted`, `resetTo` when reverted, the `redTestsEdited` it kept, and what is
  `outstanding`.

Act on it before anything else:

- **`stopped`**: note `git rev-parse HEAD` for the report, then `git reset --hard <stopped.resetTo>`.
  The pull request carries whole tickets only, and the stopped ticket starts over on the re-run. On a
  fresh run with no ticket delivered, nothing is pushed: go to step 8.
- **`final.reverted`**: the same reset, to `final.resetTo`. The final fix left the suite red even
  after its repair, and every ticket's own head was proven green.

## 6. Verify before the push

The subagents report their own results. Prove the ones the push depends on.

For **each ticket delivered this run**, over the range from the previous ticket's `head` (or
`startHead`) to its own:

- Its first commit is its `redCommit`, typed `test`, touching only files under `lua/tests/`; every
  commit after it is a `feat`, `fix` or `refactor`. A Bug lands as `fix`, anything else as `feat`.
- `git diff <redCommit> HEAD -- <testFiles>`, to the final head, either only adds cases (a later
  ticket's red commit sharing the file), or every file it changes is in the `redTestsEdited` of this
  ticket, of a later one, or of `final`, with a reason.

For each ticket in `delivered`, `git diff <startHead> HEAD -- <testFiles>` passes the same test. Every
commit after the last ticket's `head` is a `fix`.

An unexplained edit to a red case is the first line of the report, because a weakened contract
invalidates the green it bought. Then, once, on the final head: the glualint hunk gate
(`python .github/scripts/lua_hunk_gate.py --base origin/development --head HEAD`) clean, and
`bash .github/scripts/gluatest-local.sh` green; CI repeats the run on the pull request. A failure
here ends the run at step 8, unpushed.

## 7. Pull request, CI, ready

Push the branch: `git push -u origin HEAD`, or on a resume `git push --force-with-lease`, because the
rebase rewrote it. On a fresh run, open a draft against `development` per
[artifacts.md](../../docs/artifacts.md#code-implement-and-deliver):
`gh pr create --draft --base development`, titled as a Conventional Commit for the Epic as a whole
(`feat:` unless every ticket is a Bug). Photon's pull requests land by squash, merge or rebase, so
release-please reads either this title or every commit on the branch: step 6 already holds the
commits to Conventional Commits, and the title gives a squash its one line. On a resume, rewrite the draft's description to match the new head. The
description follows
[§ What the PR description carries](../../docs/artifacts.md#what-the-pr-description-carries), in this
order:

1. One `Closes #<n>.` line per delivered ticket, earlier runs included, then the Epic's line:
   - **`Closes #<epic>.`** once every ticket in the plan is delivered, so merging closes the Epic
     with its tickets.
   - **`Part of #<epic>.`** while a stopped run leaves tickets undelivered, so a partial pull request
     never closes the Epic. The run that finishes it rewrites the line.
2. Two or three sentences on what the Epic delivers.
3. `## Tickets`: a `### #<n> <title>` per delivered ticket, holding its `summary`, then its open
   items. A ticket delivered by an earlier run keeps its section from the draft as written.
4. The in-game test plan for the Epic as a whole, where something in game can observe it. Every
   `untested` criterion a person in game can check is a step in it.
5. What moved in the test suites: each ticket's red cases, the finer cases the green and fix stages
   added, and the runs in each ticket's `suitesRun`.
6. `## Final pass`: the final review's open items, saying first if it was reverted. Leave it out when
   `final` is null or nothing stands.
7. `## Not delivered here`: on a stopped run, each ticket not reached yet. Leave it out when empty.

Open items are as [`/deliver` step 5](../deliver/SKILL.md#5-pull-request-ci-ready) defines them,
drawn here from each `outstanding` entry (its `note` says why it stands) and each `untested`
criterion the test plan does not cover.

Wait for CI exactly as `/deliver` step 5 does, with its [`ci-state.sh`](../deliver/ci-state.sh)
script, up to 45 minutes. A run that stopped at a ticket stays a draft whatever CI says, so the pull
request does not read as the whole Epic.

- **Green, and every ticket delivered**: it stays a draft. Step 9 walks its open items and marks it
  ready.
- **Red**: leave it a draft and name each failing check.
- **Pending at 45 minutes**, or **read failed**: leave it a draft and say which.

## 8. Report

Lead with what the human has to do next: decide the open items step 9 lists, or look at where the run
stopped and why. Then:

- the pull request, linked as a full GitHub URL, and its CI state;
- each open item, as the description lists it, on a run that does not go on to step 9;
- any red case that was edited, with its reason;
- where the run stopped, if it did: the ticket, the stage, its account (`stopped.blocked`, or
  `stopped.suite` and `stopped.gates`), and the abandoned head you noted before the reset, which the
  reflog keeps.

A run that stopped leaves its undelivered tickets claimed. Say so: re-running `/deliver-epic <epic>`
resumes from the draft, or the human releases them by removing the assignee.

A green pull request with every ticket delivered goes on to step 9, which ends this report with its
open items list.

## 9. Walk the open items

Every ticket is delivered, CI is green, and the draft's description holds every open item still
standing. The human decides each one; you action the decisions, review the branch once more, and
leave the description matching the head. The pull request stays a draft for the whole walk.

### List

Read the description as posted on the pull request, not the workflow result: it is also what a re-run
reaching step 9 from step 1 finds. Collect every open item under each `### #<n>` heading and under
`## Final pass`, except one already carrying a `Tracked in #<n>.` line: a person decided it in an
earlier cycle. Check each against the current head, reading the code it names: an item the head has
settled is dropped from the list.

Return the list in this format, and end the turn:

```markdown
I checked each open item against the current head (`<short sha>`). <One sentence: whether any blocks the merge, and what kind of items they are.>

**[#<n>](https://github.com/photonle/Photon/issues/<n>) <ticket title>**

1. <What is missing or wrong, as behaviour.> <Why it stands.>
2. …

**Final pass**

3. …

Answer by number with fix, more info, disregard or ticket. Ranges are fine: `1 fix, 2-4 disregard`.
```

- Numbering runs on across groups, so every item has one number for the whole walk.
- Each item is one or two plain sentences: the behaviour first, then why it stands, from its note.
  Name a file only when the item is about that file.
- An item dropped as settled gets one sentence after the opening line: how many, and which head
  settled them.
- With nothing left, say so in the opening line. On the walk's first cycle, go to **Review**; on a
  later one, the walk is done: go to **Ready**.

### Decide

Each item takes one of four decisions:

| Decision | What you do |
| --- | --- |
| **fix** | the fix round below |
| **more info** | investigate it read-only and answer under its number, then ask for its decision again |
| **disregard** | drop it from the description |
| **ticket** | file it per [the tracker's conventions](../../docs/issue-tracker.md#conventions) at Stage `New`, citing the pull request and the Epic, and append `Tracked in #<new>.` to the item in the description |

A free-form answer maps onto these; ask about one that does not. Act on each decision as it arrives:
the first **fix** starts a fix round while other items still wait on more info. Repeat the more-info
loop until every item has a decision of fix, disregard or ticket.

Whenever you list again within a cycle, list only the items still undecided, under their original
numbers.

### Fix

Dispatch one Sonnet `general-purpose` agent with the Agent tool, in the background, so the
conversation carries on while it works. Hand it the Epic's number and every fix item not yet handed
to a round, numbered as in the list, with the item's text and its ticket. It verifies each before
touching code, fixes it with a regression case where the item is a behaviour, keeps every ticket's
red cases as they are unless one genuinely must change (recording the file and the reason), commits
as `fix: …`, and runs `bash .github/scripts/gluatest-local.sh` and the glualint hunk gate. It never
pushes, opens or edits a pull request, or comments on an issue. It reports each item as fixed, not
reproduced or left, with a note, and any red case it edited.

Verify as step 6 does: every new commit is a `fix`, each red-case edit carries its reason, and the
gate is clean and the GLuaTest run green on the new head. A failure resets the branch to the head
before that round, and the walk carries on: the round's items go back to undecided, each noting what
failed, and the next list raises them for a fresh decision.

Rounds run one at a time on the one checkout. Items decided **fix** while a round runs wait for it,
then go together into the next round.

### Review

Once every item is decided and the last fix round has passed verification, run both reviews at once,
each in its own Opus `general-purpose` agent, read-only, over `origin/development...HEAD`:

- **Code**: `/code-review` over the branch, at `final.level`, or `high` when this run did not reach
  the final pass.
- **Spec**: `/standards-review` with `origin/development` as the fixed point and the Epic as the spec.

A finding that repeats an item already listed is that item. Every other finding is a new open item
under `## Final pass`, which these reviews now own. They are left for the human, not fixed here.

### Publish

Push with a plain `git push`. Rewrite the description to match the new head, per
[`/deliver` step 5](../deliver/SKILL.md#5-pull-request-ci-ready): fixed and disregarded items gone,
ticketed items carrying their link, an item fixed in part or left keeping its note, `## Final pass`
from the review, and the in-game test plan and the test-suite section updated for what the fix rounds
changed. Wait for CI as step 7 does; red names each failing check in the report.

Report the CI state and what each decision did. That ends the cycle: go back to **List** for the next
one, which reads the description just rewritten and numbers from 1. The walk repeats until a cycle's
list is empty. If the session ends mid-walk, re-running `/deliver-epic <epic>` picks it up from
**List**.

### Ready

With the walk done, read CI on the head with `ci-state.sh`, waiting as step 7 does:

- **Green**: `gh pr ready <n> --repo photonle/Photon`, and report it ready for review.
- **Red**, **pending at 45 minutes** or **read failed**: leave it a draft and say which, naming each
  failing check. A re-run of `/deliver-epic <epic>` comes back here once CI is green.
