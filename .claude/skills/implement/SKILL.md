---
name: implement
description: "Implement a piece of work based on a spec or set of tickets."
argument-hint: "[<issue> | <epic>/<ticket>]"
disable-model-invocation: true
---

Implement the work described by the user in the spec or tickets.

The argument names the work:

- **`<issue>`**, such as `310`: that issue is the whole scope.
- **`<epic>/<ticket>`**, such as `310/314`: both are issue numbers in `photonle/Photon`. The ticket
  is the scope, and the epic is its context: read the epic's body for the spec, decisions and
  testing seams the ticket assumes. Confirm the ticket is one of the epic's sub-issues.
- **No argument**: the spec or tickets are in the conversation.

For either issue form, confirm nothing open blocks the scoped issue, and read its thread, where later
decisions are often recorded:

```bash
gh issue view <ticket> --repo photonle/Photon --json title,body,comments \
  --jq '.title, .body, (.comments[] | "--- \(.author.login)\n\(.body)")'
gh api repos/photonle/Photon/issues/<ticket>/dependencies/blocked_by \
  --jq '[.[] | select(.state == "open") | .number]'   # must print []
```

When a check fails, name what failed and stop before claiming anything.

If the work comes from tracker issues, claim each one before anything else, branch included:
assign yourself per [the tracker's conventions](../../docs/issue-tracker.md#conventions). An open,
unassigned issue reads as unclaimed, and a second agent picks up the same work.

Hold the change against [docs/design-constraints.md](../../../docs/design-constraints.md) and the
SimpleNet rules in [AGENTS.md](../../../AGENTS.md) as you go: both describe failures that look fine
in review and only show on a live server.

Use /tdd where possible, at pre-agreed seams. The [`qa-tester`](../../agents/qa-tester.md) agent
writes and runs the GLuaTest cases under `lua/tests/photon/`; you write the Photon code:

- **Red.** Per slice, spawn `qa-tester` with the seam and the behaviour the slice adds (for a bug,
  the brief's acceptance criteria). It returns the case red against the current code.
- **Green.** Change Photon until that case passes. Hand back to `qa-tester` when a case fails for a
  reason you cannot read.
- **Validate.** Once every slice is green, spawn `qa-tester` once more to run every suite the change
  touches and add the negative, boundary and invariant cases its own file requires. Every case it
  reports red or unrun is named in the PR description.

Behaviour the tester raises as a question is a decision for the user, not a case to make pass.

Run glualint over the changed Lua between slices: it is the nearest thing to a compiler here,
catching parse errors and the silent GLua footguns before a suite run spends minutes booting. CI
lints changed hunks with `.github/scripts/lua_hunk_gate.py`; run the same locally where glualint is
installed.

Once done, review the work with /standards-review and then /code-review, with `origin/development`
as the fixed point for both. The spec is the scoped issue, or for `<epic>/<ticket>`, the ticket read
with its epic. /standards-review checks the diff against the documented standards and the spec.
/code-review looks for correctness bugs. Neither one covers what the other checks.

[`/deliver`](../deliver/SKILL.md) runs this same work as staged subagents, red cases first, and
carries the pull request through to green CI.

Branch, commit and raise the PR per [artifacts.md](../../docs/artifacts.md#code-implement-and-deliver):
a branch cut from `development`, Conventional Commits, and a draft PR against `development` opened as
soon as the first commit lands. The PR description opens with a `Closes #<n>.` line for each issue
the PR implements (for `<epic>/<ticket>`, the ticket), so merging closes it and unblocks whatever
depends on it. What the rest of it carries, including the in-game test plan, is in
[§ What the PR description carries](../../docs/artifacts.md#what-the-pr-description-carries).
