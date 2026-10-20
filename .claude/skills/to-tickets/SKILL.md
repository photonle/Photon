---
name: to-tickets
description: Break a plan, spec, or the current conversation into a set of tracer-bullet tickets, each declaring its blocking edges, published to the issue tracker as sub-issues with native blocked-by links.
disable-model-invocation: true
---

# To Tickets

Break a plan, spec, or conversation into a set of **tickets**: tracer-bullet vertical slices, each declaring the tickets that **block** it.

Read [.claude/docs/issue-tracker.md](../../docs/issue-tracker.md) for the tracker, its conventions and the Stages.

## Process

### 1. Gather context

Work from whatever is already in the conversation context. If the user passes a reference (an issue number or URL) as an argument, fetch it and read its full body and comments.

### 2. Explore the codebase (optional)

If you have not already explored the codebase, do so to understand the current state of the code. Ticket titles and descriptions should use the vocabulary of `CONTEXT.md` where it exists, and respect ADRs under `docs/adr/` in the area you're touching.

Look for opportunities to prefactor the code to make the implementation easier. "Make the change easy, then make the easy change."

### 3. Draft vertical slices

Break the work into **tracer bullet** tickets.

<vertical-slice-rules>

- Each slice cuts a narrow but COMPLETE path through every layer it touches (definition format, shared state, networking, client render, tests): vertical, NOT a horizontal slice of one layer
- A completed slice is demoable or verifiable on its own
- Each slice is sized to fit in a single fresh context window
- Any prefactoring should be done first

</vertical-slice-rules>

Give each ticket its **blocking edges**: the other tickets that must complete before it can start. A ticket with no blockers can start immediately.

**Wide refactors are the exception to vertical slicing.** A **wide refactor** is one mechanical change (rename a field every vehicle definition sets, retype a shared symbol) whose **blast radius** fans across the whole codebase, so a single edit breaks hundreds of call sites at once and no vertical slice can land green. Don't force it into a tracer bullet; sequence it as **expand–contract**. First expand: add the new form beside the old so nothing breaks. Then migrate the call sites over in batches sized by blast radius (per library folder, per subsystem), each batch its own ticket blocked by the expand, keeping CI green batch to batch because the old form still exists. Finally contract: delete the old form once no caller remains, in a ticket blocked by every migrate batch. Downstream servers and third-party vehicle packs call Photon's public surface too, so the contract ticket may need to wait a release with a deprecation warning rather than land straight after the last batch.

### 4. Quiz the user

Present the proposed breakdown as a numbered list. For each ticket, show:

- **Title**: short descriptive name
- **Blocked by**: which other tickets (if any) must complete first
- **What it delivers**: the end-to-end behaviour this ticket makes work

Ask the user:

- Does the granularity feel right? (too coarse / too fine)
- Are the blocking edges correct: does each ticket only depend on tickets that genuinely gate it?
- Should any tickets be merged or split further?

Iterate until the user approves the breakdown.

### 5. Publish the tickets

Publish one issue per approved ticket, in dependency order (blockers first), so each ticket's blocked-by links can name real issues. Each is a **Task** with a Priority, an Effort and Stage `Triaged`: tickets are born triaged. Use the template below. Pass `--blocked-by` at creation, and `--parent` when the source is an existing issue. Mechanics are in [the `github-issues` skill](../github-issues/SKILL.md).

Create them in build order: an issue's sub-issues are listed in the order they were added, and that order is what `/wave` and `/deliver-epic` walk.

When the source was an existing issue, it becomes the tickets' **parent** once every ticket is published. Re-type it **Epic**, and set its Stage to `Triaged` if it was a Spec; any other source keeps its Stage. Its Priority stays. An Epic carries no Effort: clear it if one is set ([advanced.md](../github-issues/references/advanced.md#setting-fields-through-graphql)). Its body is left as it is: the sub-issue list is the record of its tickets.

The parent is done when it is an Epic with no Effort and every published ticket is its sub-issue, in build order.

#### A spec sized for one ticket

When the source is a Spec and the approved breakdown is a single ticket, don't publish a lone child. Convert the spec in place so it works as the ticket itself:

1. At the quiz step, say "this spec is sized for one ticket" and show the acceptance criteria and blockers you would add, instead of a one-item list.
2. On approval, append `## Acceptance criteria` and `## Blocked by` sections to its body, in the issue template's shape, keeping the existing body intact.
3. Re-type it **Task**, set an Effort and Stage `Triaged`. Wire any blockers as blocked-by links.

No sub-issues: the spec is the ticket.

<issue-template>

## What to build

The end-to-end behaviour this ticket makes work, from the user's perspective, not layer-by-layer implementation.

## Acceptance criteria

- [ ] Criterion 1
- [ ] Criterion 2

## Blocked by

- A reference to each blocking ticket, or "None (can start immediately)".

</issue-template>

Avoid specific file paths or code snippets: they go stale fast. Exception: if a prototype produced a snippet that encodes a decision more precisely than prose can (state machine, reducer, schema, type shape), inline it and note briefly that it came from a prototype. Trim to the decision-rich parts, not a working demo, just the important bits.
