# Writing briefs

A brief is a structured comment posted on an issue when its Stage moves to `Triaged`. It is the authoritative specification the implementer works from. The original body and discussion are context: the brief is the contract.

A Feature is the exception: it takes the [condensed brief](#condensed-brief-feature) and moves to `Awaiting Review`, because `/grill-to-spec` designs it before anyone builds it.

## Principles

### Durability over precision

The issue may sit triaged for days or weeks. The codebase will change in the meantime. Write the brief so it stays useful even as files are renamed, moved, or refactored.

- **Do** describe interfaces, types, and behavioral contracts
- **Do** name specific types, function signatures, or config shapes that the implementer should look for or modify
- **Don't** reference file paths: they go stale
- **Don't** reference line numbers
- **Don't** assume the current implementation structure will remain the same

### Behavioral, not procedural

Describe **what** the system should do, not **how** to implement it. The implementer will explore the codebase fresh and make its own implementation decisions.

- **Good:** "The `SkillConfig` type should accept an optional `schedule` field of type `CronExpression`"
- **Bad:** "Open src/types/skill.ts and add a schedule field on line 42"
- **Good:** "When a user runs `/triage` with no arguments, they should see a summary of issues needing attention"
- **Bad:** "Add a switch statement in the main handler function"

### Complete acceptance criteria

The implementer needs to know when it's done. Every brief must have concrete, testable acceptance criteria. Each criterion should be independently verifiable.

- **Good:** "A component with no `Meta` table is refused at registration, with a warning naming the component"
- **Bad:** "Triage should work correctly"

### A bug's brief is its test contract

[`/deliver`](../deliver/SKILL.md) takes a Bug's brief as the spec: its red stage writes a
failing case for every acceptance criterion, at the interfaces under **Key interfaces** and nowhere
else. Name interfaces a GLuaTest case can call or observe, and phrase each criterion as something one
of them returns or does. A case pinned during verification goes in as a criterion by name.

### Explicit scope boundaries

State what is out of scope. This keeps the implementer from gold-plating or making assumptions about adjacent features.

## Template

```markdown
## Brief

**Type:** the issue's type
**Summary:** one-line description of what needs to happen

**Current behavior:**
Describe what happens now. For bugs, this is the broken behavior.
For features and tasks, this is the status quo the change builds on.

**Desired behavior:**
Describe what should happen after the work is complete.
Be specific about edge cases and error conditions.

**Key interfaces:**
- `TypeName`: what needs to change and why
- `functionName()` return type: what it currently returns vs what it should return
- Config shape: any new configuration options needed

**Acceptance criteria:**
- [ ] Specific, testable criterion 1
- [ ] Specific, testable criterion 2
- [ ] Specific, testable criterion 3

**Out of scope:**
- Thing that should NOT be changed or addressed in this issue
- Adjacent feature that might seem related but is separate
```

## Condensed brief (Feature)

A Feature's brief records what triage established and hands the design to
[`/grill-to-spec`](../grill-to-spec/SKILL.md). It carries no acceptance criteria and no key
interfaces: those are decisions the grilling makes, and writing them here would settle the design
before anyone has grilled it. **Open questions** is the grilling's first round, so make each one a
decision someone has to take, not a fact you could look up.

```markdown
## Brief

**Type:** Feature
**Summary:** one line, from the requester's side
**The ask:** what the requester wants to be able to do, and the problem behind it
**Current behavior:** what happens now, the status quo the request builds on
**Checks:** how it sits with the project's scope and the design constraints, where you looked for
an existing implementation, and any `.out-of-scope/` entry it resembles
**Open questions:**
- A design decision the grilling has to settle
- Another one

**Out of scope:**
- Anything triage already ruled out, with the reason
```

## Examples

### Good brief (bug)

```markdown
## Brief

**Type:** Bug
**Summary:** Skill description truncation drops mid-word, producing broken output

**Current behavior:**
When a skill description exceeds 1024 characters, it is truncated at exactly
1024 characters regardless of word boundaries. This produces descriptions
that end mid-word (e.g. "Use when the user wants to confi").

**Desired behavior:**
Truncation should break at the last word boundary before 1024 characters
and append "..." to indicate truncation.

**Key interfaces:**
- The `SkillMetadata` type's `description` field: no type change needed,
  but the validation/processing logic that populates it needs to respect
  word boundaries
- Any function that reads SKILL.md frontmatter and extracts the description

**Acceptance criteria:**
- [ ] Descriptions under 1024 chars are unchanged
- [ ] Descriptions over 1024 chars are truncated at the last word boundary
      before 1024 chars
- [ ] Truncated descriptions end with "..."
- [ ] The total length including "..." does not exceed 1024 chars

**Out of scope:**
- Changing the 1024 char limit itself
- Multi-line description support
```

### Good brief (task)

```markdown
## Brief

**Type:** Task
**Summary:** Add `.out-of-scope/` directory support for tracking rejected feature requests

**Current behavior:**
When a feature request is rejected, the issue is closed as not planned with a
comment. There is no persistent record of the decision or reasoning.
Future similar requests require the maintainer to recall or search for the
prior discussion.

**Desired behavior:**
Rejected feature requests should be documented in `.out-of-scope/<concept>.md`
files that capture the decision, reasoning, and links to all issues that
requested the feature. When triaging new issues, these files should be
checked for matches.

**Key interfaces:**
- Markdown file format in `.out-of-scope/`: each file should have a
  `# Concept Name` heading, a `**Decision:**` line, a `**Reason:**` line,
  and a `**Prior requests:**` list with issue links
- The triage workflow should read all `.out-of-scope/*.md` files early
  and match incoming issues against them by concept similarity

**Acceptance criteria:**
- [ ] Closing a feature as not planned creates/updates a file in `.out-of-scope/`
- [ ] The file includes the decision, reasoning, and link to the closed issue
- [ ] If a matching `.out-of-scope/` file already exists, the new issue is
      appended to its "Prior requests" list rather than creating a duplicate
- [ ] During triage, existing `.out-of-scope/` files are checked and surfaced
      when a new issue matches a prior rejection

**Out of scope:**
- Automated matching (human confirms the match)
- Reopening previously rejected features
- Bug reports (only rejected feature requests go to `.out-of-scope/`)
```

### Bad brief

```markdown
## Brief

**Summary:** Fix the triage bug

**What to do:**
The triage thing is broken. Look at the main file and fix it.
The function around line 150 has the issue.

**Files to change:**
- src/triage/handler.ts (line 150)
- src/types.ts (line 42)
```

This is bad because:
- No type
- Vague description ("the triage thing is broken")
- References file paths and line numbers that will go stale
- No acceptance criteria
- No scope boundaries
- No description of current vs desired behavior
