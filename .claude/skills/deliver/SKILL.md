---
name: deliver
description: "Deliver a ready ticket end to end: red GLuaTest cases, implementation, a sized code review beside a standards review, one fix round, then a pull request marked ready once CI is green."
argument-hint: "<issue> | <epic>/<ticket>"
disable-model-invocation: true
---

# Deliver

Conduct one ticket from spec to a reviewed, green pull request. You are the **conductor**: you hold
every write to GitHub, and the build itself runs in the
[`deliver-stages`](../../workflows/deliver-stages.js) workflow, one subagent per stage:

| Stage | Agent | Model | Follows |
| --- | --- | --- | --- |
| Red: failing GLuaTest cases at the spec's seams | `qa-tester` | Sonnet | [`/tdd`](../tdd/SKILL.md#acceptance-contract) |
| Explore, beside red: read-only notes on how to build it, handed to green | `Explore` | Sonnet | — |
| Green: implementation until they pass | general-purpose | Sonnet | [`/implement`](../implement/SKILL.md), minus the steps you own |
| Review: `/code-review`, sized to the ticket | general-purpose | Sonnet or Opus | the built-in `/code-review` |
| Review: standards and spec, beside it | general-purpose | Opus | [`/standards-review`](../standards-review/SKILL.md) |
| Fix: one round over the blocking findings | general-purpose | Sonnet | — |

The ticket arrives already grilled, specified and broken down. Where it is not, this skill stops at
step 1 rather than making the decisions those skills exist to make.

[`/deliver-epic`](../deliver-epic/SKILL.md) runs the stages once per ticket of an Epic on one branch,
and opens one pull request for the lot.

## 1. Check the ticket is ready

The argument takes `/implement`'s forms, `<issue>` or `<epic>/<ticket>`. With no argument, say so and
stop.

A bare `<issue>` is resolved first: read its `parent`
([Reading an issue](../github-issues/SKILL.md#reading-an-issue)).

- **No parent**: the issue is its own spec.
- **A parent in `photonle/Photon`**: run as `<parent>/<issue>` from here on, and say so in the report
  ("resolved #314 to #310/314 from its parent").
- **A parent in another repository**: stop and name it, because the spec lives where this run cannot
  follow it.

An explicit `<epic>/<ticket>` is taken as given.

Read the ticket's body and thread (and the Epic's, for `<epic>/<ticket>`), where later decisions are
often recorded. Every check holds before anything else happens:

- The ticket is open, at Stage `Triaged`, and unassigned or assigned to you.
- Nothing open blocks it: `gh api repos/photonle/Photon/issues/<ticket>/dependencies/blocked_by --jq '[.[] | select(.state == "open") | .number]'` prints `[]`.
- For `<epic>/<ticket>`, the ticket is one of the Epic's sub-issues.
- The ticket has an `## Acceptance criteria` checklist.
- The spec has a `## Testing Decisions` section naming the **seams** to test at. The red stage tests
  at those seams and nowhere else, with nobody to confirm a new one with. The spec is the ticket's
  own body whenever that body has the section: a Spec `/to-tickets` sized for one ticket is converted
  in place, so it carries its own seams even under an Epic. Otherwise, for `<epic>/<ticket>`, it is
  the Epic's body.

A Bug with no parent may meet the last two checks with a **triage brief** instead: the latest comment
holding a `## Brief` heading, as [`/triage`](../triage/BRIEF.md) posts it. The brief is then the
spec. Its `**Acceptance criteria:**` checklist stands for `## Acceptance criteria`, and the interfaces
under its `**Key interfaces:**` are the seams, since a bug restores intended behaviour at an
interface that already exists. A brief missing either has no contract to test.

When a check fails, name what failed and the skill that fixes it (`/to-spec` or `/grill-to-spec` for
missing seams, `/to-tickets` for missing acceptance criteria, `/triage` for a bug's brief), and stop.

Then pick the **runner**, which decides where the suites run:

- **`local`** when `docker info` succeeds, so
  [`.github/scripts/gluatest-local.sh`](../../../.github/scripts/gluatest-local.sh) can run the
  suites here.
- **`ci`** otherwise. Nothing here runs a suite: the red cases are proven red by the pull request's
  CI before anything is built on them (step 3a), and CI is the first run of the implementation.

Then rename the session after the ticket where the client offers `set_session_title`
("Deliver #314: <title>").

## 2. Claim and branch

Assign yourself per [the tracker's conventions](../../docs/issue-tracker.md#conventions) before
anything else, branch included. Run `git fetch origin development`, then cut a branch from
`origin/development` **without tracking it** (`git switch --no-track -c <branch> origin/development`),
so a bare `git push` can never land on `development`. Where the session names its branch, use that
one, reset to `origin/development`, with `git branch --unset-upstream` after. Push with
`git push -u origin HEAD`. The local `development` branch is not a base: diffing against a stale one
hands every stage, both reviews included, the commits that landed since.

## 3. Run the stages

Call the Workflow tool with `name: "deliver-stages"` and these `args`:

| Key | Value |
| --- | --- |
| `ticket` | The ticket's number |
| `epic` | The Epic's number, or `null` |
| `brief` | The ticket's title and body verbatim; then its whole comment thread, oldest first, each comment headed with its author and date, since later decisions are recorded there and override the body; then a list of the issues and pull requests that mention it (its timeline's cross-references), any still open read for a follow-up that narrows or extends it; then, when the spec is the Epic's, its `## Testing Decisions` section and any thread comment that moves it, verbatim |
| `labels` | `{ "type": …, "priority": …, "effort": … }`: the issue type and the Priority and Effort fields as GitHub shows them (`"Bug"`, `"High"`), or `null` where one is unset |
| `base` | `"origin/development"` |
| `runner` | `"local"` or `"ci"`, from step 1 |
| `red` | `null` |
| `workdir` | `null`: the stages work in this checkout |
| `implementer` | `null`, for general-purpose |

Calling it from here is the user's opt-in to the workflow: invoking `/deliver` is the request.

It returns `stage`: `"done"` when every stage ran, `"verify-red"` when a `"ci"` run has its red
cases and hands them to step 3a, or `"red"` / `"green"` naming where it stopped, with that stage's
result. A stop ends the run at step 6, reported with the stage's own account (`red.blocked`, or
`green.suite` and `green.gates`). Nothing is pushed. A red stage stops only on `blocked`: criteria
it lists in `red.untested`, such as a client-only behaviour, go to the green stage.

### 3a. Prove red on the pull request (`ci` only)

With no local runner, the draft pull request is where the contract is checked:

1. Confirm `red.commit` is the branch's only commit and touches only files under `lua/tests/`, then
   push and open the draft as step 5 describes. Its description holds `Closes #<ticket>.`, a line
   saying the red cases are in and the implementation follows, and `red.criteria`.
2. Wait on [`ci-state.sh`](ci-state.sh) as step 5 does. The expected answer is **red**, with the
   glualint check green and the GLuaTest check red.
3. Read the failing GLuaTest job's log into a scratch file
   (`gh run view <run-id> --repo photonle/Photon --log-failed`) and hold it against `red.criteria`.
   The contract is proven when every case listed there fails, each with the failure the red stage
   predicted or one that says the same thing, and nothing else fails.

Any other outcome ends the run at step 6, with the draft left open and the log lines that settle it:
CI green or glualint red; a case that passed; a case that failed on a load error, an unrelated error
or leaked state; a suite that ran zero cases, which did not load; or a failure in a case this branch
did not add, which is `development`'s to fix before this ticket can be proven.

Once it is proven, call the workflow again with the same `args`, `red` set to the red result, so it
starts at green.

## 4. Verify before the push

The subagents report their own results. Prove the ones the push depends on:

- `git diff <red.commit> HEAD -- <red.testFiles>` is empty, or every file it touches appears in
  `green.redTestsEdited` with a reason. An unexplained edit to a red case is reported at step 6 as
  the first line of the run, because a weakened contract invalidates the green it bought.
- The history reads test first: `red.commit` is the branch's first commit, typed `test`, touching
  only files under `lua/tests/`, and every commit after it is a `feat`, `fix` or `refactor`.
- The glualint hunk gate is clean on the final head:
  `python .github/scripts/lua_hunk_gate.py --base origin/development --head HEAD`. Under `local`, the
  GLuaTest run is green too. Under `ci`, CI is the only run.

A failure here ends the run at step 6, unpushed.

## 5. Pull request, CI, ready

Push the branch and open a draft against `development` per
[artifacts.md](../../docs/artifacts.md#code-implement-and-deliver):
`gh pr create --draft --base development`. Title it as a Conventional Commit, `fix:` for a Bug and
`feat:` otherwise. Photon's pull requests land by squash, merge or rebase, so release-please reads
either this title or every commit on the branch: both have to read as changelog lines, which step 4's
history check already holds the commits to. Under `ci`, step 3a already opened it: push, retitle, and
rewrite its description. The description follows
[§ What the PR description carries](../../docs/artifacts.md#what-the-pr-description-carries), with
these in its sections:

1. `Closes #<ticket>.`
2. What was built, from `green.summary`.
3. The in-game test plan, where something in game can observe the change. Every criterion in
   `red.untested` that a person in game can check is a step in it.
4. What moved in the test suites: the red cases from `red.criteria`, the finer cases the green and
   fix stages added, and the runs in `green.suitesRun`.
5. `## Open items`: only what still stands, each with the reason it stands or its mitigation:
   - a blocking finding the fix round left, did not reproduce, or fixed only in part;
   - each entry in either review's `advisory` that no commit addressed;
   - each criterion in `red.untested` the test plan does not cover, for the reviewer to check by
     reading.

   List only what stands: the reader needs that, and the passing suite covers what was fixed. The
   reports stay in the workflow journal. Leave the section out when nothing stands.

The description describes the pull request's current head. Whenever you push to it again (a CI fix,
a reviewer's ask) or a review thread settles an open item, rewrite it to match. The commits and the
comment thread carry what changed; the description carries what stands.

Opening the pull request starts CI. Wait for it with [`ci-state.sh`](ci-state.sh), which counts only
the pull request's own checks and reads "no GLuaTest check yet" as pending:

```bash
.claude/skills/deliver/ci-state.sh <pr>   # 0 green · 1 red · 2 pending · 3 read failed
```

Wait with the Monitor tool, or a background Bash loop that polls every minute, until it exits
anything other than 2, up to 45 minutes. Read it only after the push has registered: a check from
the previous head can still be listed for a few seconds.

- **Green**: `gh pr ready <pr> --repo photonle/Photon`.
- **Red**: leave the pull request a draft. Name each failing check, and say whether the fix round's
  commits are the likely cause. The run's one fix round is spent, so the failure goes to the human.
  Under `ci` one more round comes first, since no stage saw a suite run: read the failing jobs'
  logs, spawn the `implementer` agent type (general-purpose unless the caller named one) with the
  failures, the brief and the red files it must leave alone, push what it commits, and wait again.
  A second red goes to the human.
- **Pending at 45 minutes**, or **read failed**: leave it a draft and say which.

## 6. Report

Lead with what the human has to do next: review a ready pull request, or look at where the run
stopped and why. Then:

- the pull request, linked as a full GitHub URL, and its CI state;
- each open item, as the description lists it;
- any red case the green stage edited, with its reason;
- each criterion in `red.untested`, with its reason, so the reviewer checks those by reading or in
  game. [`/ingame-test`](../ingame-test/SKILL.md) can run the test plan.

A run that stopped before the push leaves the ticket claimed with no pull request behind it, and one
that stopped at step 3a leaves a draft holding only the red cases. Say which, so the human can
release the ticket or re-run `/deliver`.
