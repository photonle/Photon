---
name: ingame-test
description: "Run a pull request's in-game test plan in the local Garry's Mod, then tick the steps that pass in the PR's checklist. Use when asked to test a PR in game, run its test plan, or verify its unticked test-plan steps. Stops at once where no local GMod exists."
argument-hint: "<pr-number|#number|pr-url>…"
---

# In-game test

Run one `photonle/Photon` pull request's in-game test plan in the local Garry's Mod. You are done
when **every unticked test-plan step has a verdict** (pass, fail or not run), each with the evidence
behind it, and the PR description and your report both carry those verdicts. Given several PRs, take
them one at a time, each start to finish.

The game itself is the [gmod skill](../gmod/SKILL.md): read it now, since steps 1, 4 and 7 run its
steps.

## 1. Preflight

Run the gmod skill's step 1, then `gh auth status`. If either fails, **stop** before reading or
editing any PR: report the failure lines verbatim and say the plan could not be run in this
environment. A PR with no verdicts is better than one whose checklist was touched from a machine
that can't run the game.

## 2. Read the PR

```bash
gh pr view <N> --repo photonle/Photon --json state,headRefName,headRefOid,body,closingIssuesReferences
```

Save the body to a file and leave that copy untouched: it is your backup. Skip the PR, saying why,
if it is closed or merged or its body has no unticked `- [ ]` entry. From the body, pull out:

- **Setup**: the map, vehicle, components and controller state the plan needs first.
- **Steps**: every unticked `- [ ]` entry, including the negative case and the per-realm checks.
  These are what you give verdicts.

Read the linked issue and the diff (`gh pr diff <N>`) for what each step is really checking. A
step's wording can be loose, and the code says what "the pattern holds after a resync" means.

## 3. Check out the head in its own worktree

Keep this session's checkout where it is: the skills and the launcher run from it, and an older PR
head may not carry them. Give the PR head a worktree of its own:

```bash
git fetch origin "pull/<N>/head"
PR_TREE="${TMPDIR:-/tmp}/ingame-test-pr<N>"
git worktree add --detach "$PR_TREE" FETCH_HEAD
git -C "$PR_TREE" rev-parse HEAD
cygpath -w "$PR_TREE"        # the -Worktree value for the launcher
```

`pull/<N>/head` reaches a PR from a fork too. Name the SHA you tested in the report; if it differs
from `headRefOid`, the PR moved.

## 4. Get the game, launch, wait

Choose `-Map` from the Setup line; a map that isn't installed makes the steps needing it *not run*,
with the reason "map not available locally". Then run the gmod skill's steps 2 to 4 with `-Worktree`
set to the PR tree. A failed launch, or a boot where Photon didn't load, blocks the run: record what
`console_log` says, give every step the verdict *not run*, and go to step 7.

## 5. Set up

Put the Setup line in place, preferring server-realm Lua: spawn the vehicle, set its components,
put the controller in the state the plan names. Keep a list of everything you create or change;
step 7 undoes all of it. Drive Photon through its own functions, so the check runs on the same path
a player's input would.

## 6. Run each step

For each unticked step, do the action and check the result it names, by the gmod skill's step 5.
Record:

- **The verdict**: *pass*, *fail* or *not run*.
- **The evidence**: values read from the game, naming any Lua call that stood in for real input.

A *fail* names what was expected and what you observed instead. Run every step even after a
failure; a step the failure blocks is *not run*, and its evidence names the blocking step. A step
only real input or a human eye can prove is *not run*, and the evidence says why.

## 7. Clean up and hand back

1. Undo everything on your step 5 list, by the gmod skill's step 6.
2. Quit the game (`run_gmod_command` `quit`) and wait for `gmod.exe` to exit.
3. Point `addons\photon` back at the main checkout, so the game isn't left on a tree you are about
   to delete: the launcher's `-Restore`, as the gmod skill's step 6 shows.
4. `git worktree remove --force "$PR_TREE"`.
5. Hand the game back the way `CLAUDE.local.md` describes. After that, do nothing more in GMod.

## 8. Update the PR description

Edit only the test-plan checkboxes and the `## Open items` section. Everything else in the body stays
byte for byte.

- Change `- [ ]` to `- [x]` for each step that **passed**. Leave failed and not-run steps unticked.
- For each failed or not-run step, add a line under `## Open items`: the step, what you observed,
  and the head SHA. Append to that section if it exists, or add it at the end of the body, above the
  `🤖 Generated with` footer if there is one.

Edit the saved body with a script that reads and writes UTF-8 bytes, never through a shell variable,
and write it back from the file:

```bash
gh pr edit <N> --repo photonle/Photon --body-file "$NEW_BODY"
```

Re-read the PR and diff its body against your saved original. The only changes should be your ticks
and open items.

## 9. Report

Reply with:

- the PR link and the head SHA you tested;
- a table of every step, giving the verdict and a one-line summary of the evidence;
- the open items you added, and anything that blocked the run.
