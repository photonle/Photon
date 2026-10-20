---
name: grill-to-spec
description: "Grill a subject to shared understanding, then publish the spec it produced: the route for anything that has to be interrogated before it can be written up."
argument-hint: "[<issue> | <subject>]"
disable-model-invocation: true
---

# Grill to Spec

`/grilling` reaches a shared understanding and stops there. [`/to-spec`](../to-spec/SKILL.md) writes
the spec, but only out of what has already been discussed. This is the route for a subject that has
to be interrogated before it can be written up: both, in that order, in one session.

## 1. Read the subject

| Argument | The subject |
| --- | --- |
| An issue: `412`, `#412`, or a full GitHub issue URL | That issue, [body and thread](../../docs/issue-tracker.md#conventions) |
| Anything else | What the user typed, plus the conversation so far |
| Nothing | The conversation so far |

Anything `/grilling` takes is a subject here: a plan, a decision, an idea, an issue, a Feature
request, a Stub.

A Feature that triage passed carries a condensed brief: its checks are settled facts, and its
**Open questions** are the first round's frontier, though not all of it.

An issue is where the design tree starts, never a settled branch of it — a reporter's proposed
solution is an answer you have not heard the user give. Claim it first if it is open and
unassigned, [per the tracker's convention](../../docs/issue-tracker.md#conventions): the grilling
runs over several rounds, and an unassigned issue reads as unclaimed for every one of them.

## 2. Grill

Call the Skill tool with "grill-with-docs" and follow it as written: the design tree, the whole
frontier asked in one numbered round with your recommended answer against each question, facts
found by you and decisions left to the user, and `CONTEXT.md` and ADRs written as terms and
decisions land.

Every decision in a round is about the subject. Step 3 already settles how the spec is recorded:
where it goes, what it contains and how the issue is typed. Invoking this skill is the user's
go-ahead to publish it.

Two conditions end this step, and both are checkable:

- The **frontier is empty** — every branch of the tree visited, nothing silently assumed.
- The **user has said in words** that you have reached a shared understanding. Ask for it. A round
  that drew no new questions is not it, and neither is silence.

Until both hold, the next round is the work. Once they do, raise any changes to `CONTEXT.md` and
`docs/adr/` as one docs PR, per [artifacts.md](../../docs/artifacts.md#documents-branch-and-draft-pr),
before you move on.

## 3. Write and publish the spec

Follow [`/to-spec`](../to-spec/SKILL.md) from its first step to its publish.

Its "do not interview" rule holds here, and means what it has always meant: a spec is **synthesis**.
The interview is the grilling that just finished, so the Implementation Decisions record the answers
the user gave, written as the conclusions they are rather than as options to choose between. A
question you find yourself wanting to ask while writing marks a branch of the tree left unvisited:
go back to step 2 and ask it.

Where the subject was any other issue, reference it in the spec's prose with the reason it is there.
It prompted the spec, which makes it a
[plain relationship](../github-issues/SKILL.md#plain-relationships-go-in-the-prose) rather than a
parent or a dependency.

**A Stub or a Feature is the exception: publish the spec into the issue itself** rather than as a
new one. The issue is waiting on exactly this spec, so a second issue would leave it open, and the
next `/wave` would grill it again. Edit it in place:

- **A Stub**: replace its body with the spec.
- **A Feature**: put the spec first, then the requester's original text, verbatim, under
  `## Original request`. Drop the triage brief's content from the body; the comment stays in the
  thread.

Retitle it to the spec's subject if its title no longer names it, re-type it **Spec**, and set its
Stage to `Awaiting Review`. Its Priority stays. The issue keeps its number, its parent, its place
among its parent's sub-issues, and its blocked-by links.

## 4. Hand back

Link the published spec, and the docs PR where the grilling raised one, and tell the user to run
`/to-tickets` on it, which is the one place that decides whether a spec is one ticket or several.

Where the subject was any other issue, say that it stands as it was, bar the claim: closing it,
re-typing it, or leaving it open against the spec is the user's call. A Stub or a Feature is the
spec now, so there is nothing to decide about it.
