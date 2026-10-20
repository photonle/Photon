---
name: grill-to-tickets
description: "Grill a subject to shared understanding, publish its spec, then break the spec into published tickets: the route for anything that has to be interrogated before it can be built."
argument-hint: "[<issue> | <subject>]"
disable-model-invocation: true
---

# Grill to Tickets

[`/grill-to-spec`](../grill-to-spec/SKILL.md) grills a subject and publishes its spec, then stops for
the user to run [`/to-tickets`](../to-tickets/SKILL.md). This is both, back to back, in one session:
the spec still gets written, because it is where the testing seams and Testing Decisions are
settled, which a breakdown alone never asks about. The two skills each check in with the user once
after the grilling, on the seams and on the breakdown; here that is one check-in, so the seams and
the slices are judged against each other.

## 1. Grill

Follow [`/grill-to-spec`](../grill-to-spec/SKILL.md)'s first two steps: read the subject, claiming
it if it is an issue, and grill it until both of that skill's conditions hold.

## 2. Propose the seams and the breakdown together

1. Explore the repo, per the first step of [`/to-spec`](../to-spec/SKILL.md) and the second of
   [`/to-tickets`](../to-tickets/SKILL.md).
2. Sketch the testing seams, per `/to-spec`'s second step.
3. Draft the tracer-bullet slices and their blocking edges, per `/to-tickets`' third step, sizing
   each slice so it can be proved at those seams.
4. Put both to the user in one message: the seams first, then the numbered breakdown in
   `/to-tickets`' quiz shape, then both sets of questions — do the seams match their expectations,
   and are the granularity, the blocking edges and the merges and splits right. Where the
   breakdown is a single ticket, say "this spec is sized for one ticket" and show its acceptance
   criteria and blockers instead of a one-item list, as `/to-tickets` does.

Iterate on both until the user approves both; a change to the seams can move the slices, so show
the breakdown again whenever the seams change. A design question you find yourself wanting to ask
here marks a branch of the tree left unvisited: ask it, as a grilling round, before going on.

## 3. Publish the spec

Follow `/grill-to-spec`'s third step to write and publish the spec, skipping `/to-spec`'s seams
check: the approved seams are its Testing Decisions. A Stub or a Feature becomes the spec in place,
as that skill says. Skip `/grill-to-spec`'s hand back: the next step is the breakdown it would have
handed to.

This step is done when the spec is published as a Spec issue.

## 4. Publish the tickets

Follow `/to-tickets`' fifth step to publish the approved breakdown, with the spec just published as
the source issue. Its quiz is the one step 2 already ran. The spec becomes the tickets' parent Epic,
or converts in place to the ticket itself when it is sized for one, exactly as `/to-tickets` says.
A Stub or a Feature carries through both conversions, keeping its number, its thread and, for a
Feature, the requester's original text. Each ticket's acceptance criteria come from the spec's user
stories and Testing Decisions.

This step is done when every approved ticket is published and the spec is an Epic with them as
sub-issues in build order, or a Task with acceptance criteria and an Effort.

## 5. Hand back

Link the parent and the published tickets, frontier first (the tickets with no blockers), and the
docs PR where the grilling raised one. Tell the user that `/wave` on the parent, or `/deliver` on a
frontier ticket, starts the build.

Where the subject was an issue other than a Stub or a Feature, say that it stands as it was, bar the
claim, and that closing it, re-typing it, or leaving it open against the tickets is the user's call,
as `/grill-to-spec` leaves it.
