# Session artifacts

What a skill session produces, and where each kind must end up. **Documents** go to a branch and a
draft pull request, **decided work** goes to issues, and **code** follows the repo's branching
rules. Nothing is left in the transcript.

Every pull request targets `development`, never `master`
([CONTRIBUTING.md](../../.github/CONTRIBUTING.md#pull-requests)), and its title is a Conventional
Commit: release-please builds the changelog and release notes from PR titles, and a title that
doesn't parse is left out of both.

## Documents: branch and draft PR

A Markdown artifact a skill writes into the repo goes on a branch cut from `development` and is
raised as a **draft PR**, one per session rather than one per artifact.

| Artifact | Path in repo |
| --- | --- |
| ADR | `docs/adr/NNNN-<slug>.md` |
| Domain glossary | `CONTEXT.md` |

Everything under `docs/` is published to the documentation site, so write it for a reader who is
not in this session.

Research findings are not a document: `/research` posts them as a comment on their Research issue.

`/domain-modeling` writes glossary terms and ADRs the moment they crystallise, mid-conversation.
Those edits accumulate in the working tree and go out on the session's branch at the end, with the
rest of its documents.

The PR title is `docs: <session topic>`, hidden from release notes. The body says what each
artifact decides and links any issue that prompted it.

### Exceptions

- **`/improve-codebase-architecture`** writes its HTML report to the OS temp directory. No branch,
  no PR.
- **`/prototype`** commits throwaway code to its own throwaway branch and leaves a pointer on the
  issue. The verdict is captured on the issue, so it opens no PR.

## Code: `/implement` and `/deliver`

- A branch cut from `development`.
- Conventional Commits on each commit, and on the PR title: `feat` for additions, `fix` for bug
  fixes, `perf` for optimisations, `refactor` for internal changes. The PR title is the changelog
  line, so write it for a server owner reading release notes.
- A **draft PR** opened once the first commit lands, marked ready when the work is done.
- Before marking it ready, the changed Lua passes glualint (CI lints changed hunks only) and the
  GLuaTest suites under `lua/tests/photon/` pass; CI runs both on every pull request.

### What the PR description carries

1. **`Closes #<n>.`** for each issue the PR implements, one per line, at the head of the body, so
   merging closes it and unblocks whatever it blocks.
2. **What changed and why**, at the level of the decisions taken rather than a restatement of the
   diff.
3. **A test plan** for whoever checks the branch in game, only where something in game can observe
   the change. See below.
4. **What moved in the test suites**: each suite added or changed and what it now covers. Where part
   of the change has no coverage, say which part and why, so the gap is a reviewed decision rather
   than an omission.

Leave out a section that doesn't apply, heading included, without a sentence saying so.

### The in-game test plan

Any change something in game can observe carries one: a light pattern, a siren, a component, a
vehicle definition, the menu, a networked state, a hook. A refactor meant to change nothing still
carries one, naming the behaviour that has to survive it.

Write it as steps a tester can follow without reading the code. **Setup** is one line of context:
the map, the vehicle, the components or controller state to have in place. Every action the tester
takes, paired with the result it must produce, is its own `- [ ]` entry, so the PR body becomes a
checklist `/ingame-test` and a person can tick off. Where the change touches both realms, say which
realm each step proves: a client-side check proves nothing about the server half.

## Specs and decided work: issues

A finished spec is written to the tracker, typed so a later session can pick it up. Types, Stages
and who picks each up are in [issue-tracker.md](issue-tracker.md#types-the-skills-produce).

### Capture the sidebar

Anything raised in passing that is real work but not this session's point gets its own issue before
the session ends, separate from what the session is producing. Check the tracker for it first, with
`issues.sh` and a search of titles, so a sidebar already tracked gets a comment rather than a second
issue. File it with a sentence of context and a `#`-reference to the issue or PR it surfaced from,
and tell the user what you filed.
