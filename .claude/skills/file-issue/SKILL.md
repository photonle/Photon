---
name: file-issue
description: Interactive filing session where the user reports bugs, tasks and ideas conversationally, and the agent files them as GitHub issues in the project's domain language, after a duplicate check. Explores the codebase in the background for context.
disable-model-invocation: true
---

# File Issue

Run an interactive filing session. The user describes problems they've hit or work they want tracked. You clarify, explore the codebase for context, check the tracker for duplicates, and file `photonle/Photon` issues that are durable, user-focused, and use the project's domain language.

Read [.claude/docs/issue-tracker.md](../../docs/issue-tracker.md) for the tracker and the [`github-issues` skill](../github-issues/SKILL.md) for the `gh` and API mechanics. Every issue you file lands at Stage `New`, where `/triage` picks it up.

## For each report the user raises

### 1. Listen and lightly clarify

Let the user describe it in their own words. Ask **at most 2-3 short clarifying questions**, focused on:

- What they expected vs what actually happened
- Steps to reproduce, if not obvious: the vehicle and its components, the map, singleplayer or a server, other addons involved (a vehicle base such as simfphys or Glide), the Photon version
- Whether it's consistent or intermittent

Do NOT over-interview. If the description is clear enough to file, move on.

**Stop and ask before filing** when the report would need someone's personal data in the body. The tracker is public: an exploit or a way to crash servers goes to the maintainers privately first, so ask the user how they want it handled rather than filing it.

### 2. Explore the codebase in the background

While talking to the user, kick off an Agent (`subagent_type: Explore`) in the background to understand the relevant area. The goal is NOT to find a fix. It's to:

- Learn the domain language used in that area: `CONTEXT.md` where it exists, any ADRs under `docs/adr/`, then the topic pages under `docs/`
- Understand what the feature is supposed to do, so a "bug" that is intended behaviour gets caught before filing
- Identify the user-facing boundary of the behaviour

This context sharpens the issue, but the issue itself must NOT reference files, line numbers, or internal implementation details.

### 3. Check for duplicates

Search the tracker by the domain concept, not just the user's wording. Try two or three keywords:

```bash
gh issue list --repo photonle/Photon --search "<term>" --state all --limit 20 --json number,title,state --jq '.[] | "#\(.number) [\(.state)] \(.title)"'
```

- **Open duplicate**: show it to the user and offer to add their detail as a comment (`gh issue comment <n> --body-file …`) instead of filing. File a new issue only if they say it's different.
- **Closed match**: a bug that comes back after its fix is a regression. File it, and name the old issue in a sentence that says why: "Regression of #n, which fixed the same siren cut-out in 76.4."

### 4. Pick the type

Choose against [the tables in `github-issues`](../github-issues/SKILL.md#choosing-a-type). In a filing session it's almost always one of:

| Report | Type |
| --- | --- |
| Photon is broken against its intended behaviour | Bug |
| Work that's already decided: a chore, a refactor, a follow-up | Task |
| A request or idea that still needs deciding | Feature |
| A question to answer by reading sources | Research |

Don't file a Stub here. A Stub is an agreed idea waiting to be grilled into a spec, filed by hand as planning at `Awaiting Review`, not a report for `/triage`. If the user is describing one, say so and file it that way instead.

### 5. Assess scope: single issue or breakdown?

Break down when:

- The fix spans several independent areas ("the lightbar desyncs AND the siren doesn't stop AND the menu shows the wrong preset")
- There are clearly separable concerns different people could work on in parallel
- The user describes several distinct failure modes or symptoms

Keep it as a single issue when:

- It's one behaviour that's wrong in one place
- The symptoms all come from the same root behaviour

### 6. File the issue(s)

Do NOT ask the user to review the body first. Invoking `/file-issue` is the go-ahead, so file and share URLs. The exceptions are the stop-and-ask case in step 1 and a duplicate in step 3.

Issues must be **durable**: they should still make sense after major refactors. Write from the perspective of whoever runs into it: a player, a server owner, a vehicle author.

Write the body to a temp file outside the repo, create the issue with its type, then set its Stage in one POST ([Setting fields](../github-issues/SKILL.md#setting-fields)):

```bash
gh issue create --repo photonle/Photon --type Bug --title "..." --body-file "$body"
```

- One type and Stage `New`, always.
- Add Priority and Effort to the same POST only when the user stated them ("this is urgent", "five-minute fix"). Otherwise leave them for `/triage`. Don't guess.
- `create` prints the new issue's URL. The number is its last path segment.

#### Bug template

```
## What happened

[The actual behaviour the user saw, in plain language]

## What I expected

[The expected behaviour]

## Steps to reproduce

1. [Concrete, numbered steps a developer can follow]
2. [Use domain terms from the codebase, not internal function or file names]
3. [Include the vehicle, its components, the map, and any addons or inputs that matter]

## Additional context

[Consistent or intermittent, the Photon version, when it started, anything the exploration surfaced that frames it, in domain language, no file paths]
```

#### Task, Feature and Research template

```
## What

[The work, request or question, from the user's or developer's perspective]

## Why

[What prompted it: the problem it solves or the need behind it]

## Done when

- [ ] [Observable outcome 1]
- [ ] [Observable outcome 2]

## Additional context

[Constraints, prior art, related issues with the reason they're related]
```

For a Feature, replace "Done when" with "Open questions": nothing is decided yet, and `/grill-to-spec` turns the answers into acceptance criteria.

#### For a breakdown

Create the issues in dependency order (blockers first), passing `--blocked-by <n>` for each real blocker so each can reference real numbers. Use the matching template for each slice, scoped to just that slice, and add:

```
## Blocked by

- #<n>, [why it has to wait]

Or "None, can start immediately."
```

When breaking down:

- **Prefer many thin issues to a few thick ones.** Each should be independently fixable and verifiable.
- **Mark blocking honestly.** If B can't be tested until A is fixed, wire it. If they're independent, both say "None, can start immediately."
- **Maximise parallelism**, so several people or agents can take different issues at once.
- **No parent by default.** Only when the user asks for one, create an Epic and add the issues to it as sub-issues ([Relationships](../github-issues/SKILL.md#relationships)).

#### Rules for every issue body

- **No file paths or line numbers.** They go stale.
- **Use the project's domain language**, as step 2 found it.
- **Describe behaviours, not code.** Write "the rear lightbar stays on after the siren is turned off", not "`CAR_Siren` never clears the NW2 var".
- **Reproduction steps are mandatory for a bug.** If you can't determine them, ask the user.
- **Link related issues in prose that carries the reason**, never a bare `#n`.
- **Keep it concise.** A developer should be able to read it in 30 seconds.

After filing, print each issue's URL, type, and any blocking edges, then ask: "Next issue, or are we done?"

### 7. Continue the session

Keep going until the user says they're done. Each report is independent, so don't batch them.
