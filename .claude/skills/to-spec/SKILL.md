---
name: to-spec
description: "Turn the current conversation into a spec and publish it to the issue tracker: no interview, just synthesis of what you've already discussed."
disable-model-invocation: true
---

This skill takes the current conversation context and codebase understanding and produces a spec. Do NOT interview the user; just synthesize what you already know.

Read [.claude/docs/issue-tracker.md](../../docs/issue-tracker.md) for the tracker, its conventions and the Stages.

## Process

1. Explore the repo to understand the current state of the codebase, if you haven't already. Use the vocabulary of `CONTEXT.md` where it exists, respect any ADRs under `docs/adr/` in the area you're touching, and hold the design against [docs/design-constraints.md](../../../docs/design-constraints.md).

2. Sketch out the seams at which you're going to test the feature. Existing seams should be preferred to new ones. Use the highest seam possible. If new seams are needed, propose them at the highest point you can. The fewer seams across the codebase, the better - the ideal number is one.

   Spawn the [`qa-tester`](../../agents/qa-tester.md) agent with the seams and the modules behind them, and ask, per seam: the existing suite under `lua/tests/photon/` and prior-art cases it would extend, the realm each case runs in, what each case must stub, and anything only provable by hand in game. Its answers fill the spec's Testing Decisions; a seam no suite can reach gets a higher one or an in-game check instead.

   Check with the user that these seams match their expectations.

3. Write the spec using the template below, then publish it to the tracker as a **Spec** with a Priority, no Effort, and Stage `Awaiting Review`.

   Don't size the spec. It is input to a breakdown, not something to build directly, and `/to-tickets` is the one place that decides whether it is one ticket or several. When you hand it back, tell the user to run `/to-tickets` on it.

<spec-template>

## Problem Statement

The problem that the user is facing, from the user's perspective.

## Solution

The solution to the problem, from the user's perspective.

## User Stories

A LONG, numbered list of user stories. Each user story should be in the format of:

1. As an <actor>, I want a <feature>, so that <benefit>

<user-story-example>
1. As a vehicle author, I want a component to declare its own light colours, so that I can reuse it across liveries without copying it
</user-story-example>

This list of user stories should be extremely extensive and cover all aspects of the feature.

## Implementation Decisions

A list of implementation decisions that were made. This can include:

- The modules that will be built/modified
- The interfaces of those modules that will be modified
- Technical clarifications from the developer
- Architectural decisions
- Networked state and its wire format
- Vehicle-definition and component-format contracts
- Specific interactions

Do NOT include specific file paths or code snippets. They may end up being outdated very quickly.

Exception: if a prototype produced a snippet that encodes a decision more precisely than prose can (state machine, reducer, schema, type shape), inline it within the relevant decision and note briefly that it came from a prototype. Trim to the decision-rich parts, not a working demo, just the important bits.

## Testing Decisions

A list of testing decisions that were made. Include:

- A description of what makes a good test (only test external behavior, not implementation details)
- Which modules will be tested
- Prior art for the tests (i.e. similar types of tests in the codebase)

## Out of Scope

A description of the things that are out of scope for this spec.

## Further Notes

Any further notes about the feature.

</spec-template>
