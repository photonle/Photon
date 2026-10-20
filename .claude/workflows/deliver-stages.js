export const meta = {
  name: 'deliver-stages',
  description: 'The agent stages of /deliver: red acceptance tests, implementation, a sized code review beside a standards review, then one fix round',
  whenToUse: 'Called by the /deliver skill (or /build-ui) with a prepared brief; not meant to be run by hand',
  phases: [
    { title: 'Red', detail: 'failing GLuaTest cases at the agreed seams, beside a read-only explorer scouting the implementation', model: 'sonnet' },
    { title: 'Green', detail: 'implementation until the red cases pass', model: 'sonnet' },
    { title: 'Review', detail: '/code-review sized to the ticket, beside /standards-review' },
    { title: 'Fix', detail: 'one round over the blocking findings', model: 'sonnet' },
  ],
}

// args, prepared by .claude/skills/deliver/SKILL.md:
//   ticket       the ticket's issue number in photonle/Photon, e.g. 314
//   epic         the parent's number, or null when the ticket is its own spec
//   brief        the ticket body and the spec's Testing Decisions (or a bug's triage brief), verbatim
//   labels       { type, priority, effort }: the issue type and field values as GitHub shows them ("Bug", "High"), or null
//   base         the fixed point the reviews and gates diff against, normally "origin/development"
//   runner       "local" when qa-tester's local GLuaTest runner works here, "ci" when only the pull request's CI can run it
//   red          null, or the red result of an earlier "ci" run that CI has since proven red
//   workdir      the checkout to work in, or null for the session's own
//   implementer  the agent type for the green and fix stages, or null for general-purpose
const { ticket, epic, brief, labels, base } = args
const ci = args.runner === 'ci'
const workdir = args.workdir || null
const implementer = args.implementer || 'general-purpose'
const scope = epic ? `${epic}/${ticket}` : `${ticket}`
// The red stage commits test: …; the change that turns it green is typed from the ticket.
const implType = labels.type === 'Bug' ? 'fix' : 'feat'

const WHERE = workdir
  ? `Work in the git checkout at ${workdir}, on the branch it has checked out: cd there before every
command, and give every file tool an absolute path under it. The session's own checkout is not yours.`
  : 'Work in the current checkout and on the current branch.'

const SHARED = `You are one stage of /deliver for photonle/Photon issue #${ticket}${epic ? `, part of #${epic}` : ''}.
${WHERE} Commit what you change; never push, never open or edit a pull request, never comment on the
issue: the conductor owns every forge write.

${ci
  ? `GLuaTest cannot run in this checkout: the pull request's CI runs the suites once the conductor
pushes, and the conductor reads the results.`
  : `GLuaTest runs locally with the runner .claude/agents/qa-tester.md names under "Run".`}

The brief (the ticket, and the spec's testing seams):

${brief}`

const GATES = `the glualint hunk gate, python .github/scripts/lua_hunk_gate.py --base ${base} --head HEAD`

// Where a fix round's cases go: beside the behaviour, so the suite reads by feature, not by history.
const TEST_HOME = `Put each new case in the existing test file for the behaviour it covers, beside the cases
already there, and never in a new file named after a review, a finding or this round.`

const RED = {
  type: 'object',
  properties: {
    commit: { type: 'string', description: 'SHA of the commit holding the red cases' },
    testFiles: { type: 'array', items: { type: 'string' } },
    criteria: {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          criterion: { type: 'string' },
          tests: { type: 'array', items: { type: 'string' } },
          failure: { type: 'string', description: 'The expectation or missing-behaviour message each case fails with' },
        },
        required: ['criterion', 'tests', 'failure'],
      },
    },
    untested: {
      type: 'array',
      description: 'Criteria with no red case because nothing at the seam can observe them: a doc change, an internal refactor, client rendering, behaviour only a person in game can prove',
      items: {
        type: 'object',
        properties: { criterion: { type: 'string' }, reason: { type: 'string' } },
        required: ['criterion', 'reason'],
      },
    },
    blocked: { type: 'string', description: 'Empty, or why a behaviour the seam can observe has no honest red case, or why the runner would not boot; the only reasons to stop' },
  },
  required: ['commit', 'testFiles', 'criteria', 'untested', 'blocked'],
}

const GREEN = {
  type: 'object',
  properties: {
    head: { type: 'string' },
    changedFiles: { type: 'array', items: { type: 'string' }, description: 'git diff --name-only against the base' },
    suite: { type: 'string', enum: ['green', 'red', 'unrun'], description: '"unrun" only when GLuaTest cannot boot here' },
    suitesRun: { type: 'array', items: { type: 'string' }, description: 'Each GLuaTest run, e.g. "local"; empty when unrun' },
    gates: { type: 'string', enum: ['clean', 'errors'] },
    redTestsEdited: {
      type: 'array',
      items: { type: 'object', properties: { file: { type: 'string' }, why: { type: 'string' } }, required: ['file', 'why'] },
    },
    summary: { type: 'string' },
  },
  required: ['head', 'changedFiles', 'suite', 'suitesRun', 'gates', 'redTestsEdited', 'summary'],
}

// The explorer's notes for the green stage: gathered while red writes its cases, so green starts
// with the reading done instead of cold.
const EXPLORE = {
  type: 'object',
  properties: {
    approach: { type: 'string', description: 'How the ticket is likely built, in a few sentences' },
    files: {
      type: 'array',
      description: 'Files the implementation will likely change or must read, existing or new',
      items: { type: 'object', properties: { path: { type: 'string' }, why: { type: 'string' } }, required: ['path', 'why'] },
    },
    patterns: { type: 'array', items: { type: 'string' }, description: 'Existing code to copy, each with its path' },
    pitfalls: { type: 'array', items: { type: 'string' }, description: 'Traps: footguns, conventions, coupling, cases that will need care' },
  },
  required: ['approach', 'files', 'patterns', 'pitfalls'],
}

const FINDINGS = {
  type: 'object',
  properties: {
    report: { type: 'string', description: 'The review as written; it stays in the journal, and the pull request lists "advisory" instead' },
    blocking: {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          id: { type: 'string' },
          file: { type: 'string' },
          line: { type: 'integer' },
          summary: { type: 'string' },
        },
        required: ['id', 'file', 'summary'],
      },
    },
    advisory: {
      type: 'array',
      description: 'Every finding outside "blocking" that still stands: what the pull request lists as open',
      items: {
        type: 'object',
        properties: {
          id: { type: 'string' },
          file: { type: 'string' },
          summary: { type: 'string' },
          kind: { type: 'string', enum: ['judgement', 'baseline-smell', 'scope', 'spec-handoff', 'other'] },
          note: { type: 'string', description: 'Why it stands rather than being fixed here, and any mitigation' },
        },
        required: ['id', 'summary', 'kind', 'note'],
      },
    },
  },
  required: ['report', 'blocking', 'advisory'],
}

const FIX = {
  type: 'object',
  properties: {
    head: { type: 'string' },
    outcomes: {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          id: { type: 'string' },
          outcome: { type: 'string', enum: ['fixed', 'not-reproduced', 'left'] },
          note: { type: 'string' },
        },
        required: ['id', 'outcome', 'note'],
      },
    },
    suite: { type: 'string', enum: ['green', 'red', 'unrun'] },
    gates: { type: 'string', enum: ['clean', 'errors'] },
  },
  required: ['head', 'outcomes', 'suite', 'gates'],
}

// The review is sized from the ticket's fields, then raised to at least `high` when the diff
// touches a path where a missed bug is expensive on every server running Photon. Highest matching row wins.
const LEVELS = ['low', 'medium', 'high', 'xhigh']
const RISKY = [
  /(^|\/)sh_simplenet\.lua$/,          // the wire format every networked value rides on
  /(^|\/)(cl|sv)_emv_net\.lua$/,       // net receivers a hostile client reaches
  /(^|\/)cl_photon_eng\.lua$/,         // the per-frame render path
  /(^|\/)sh_registry\.lua$/,
  /(^|\/)meta\//,                       // the public entity-method surface downstream code calls
]

function reviewLevel(changedFiles){
  let level = 'low'
  const raise = l => { if (LEVELS.indexOf(l) > LEVELS.indexOf(level)) level = l }
  if (labels.effort === 'Medium' || labels.priority === 'Medium') raise('medium')
  if (labels.effort === 'High' || labels.priority === 'High') raise('high')
  if (labels.priority === 'Urgent') raise('xhigh')
  const risky = changedFiles.filter(f => RISKY.some(r => r.test(f)))
  if (risky.length) raise('high')
  return { level, risky }
}

const RED_CHECK = ci
  ? `Each case must fail for the right reason once CI runs it: an expectation about the missing
behaviour, never a compile error, a missing function the case could have stubbed through a public
seam, or leaked state. Nothing here can run it, so compile-check your files with luac -p and run
glualint over them, read each case against the code it calls, and put in "failure" the
message you expect CI to report for it: the conductor checks every one against CI's log.`
  : `Each case must fail for the right reason: an expectation about the missing behaviour, never a
compile error, a missing function the case could have stubbed through a public seam, or leaked
state. Run the suites with the local runner your instructions name and read the failure message
before you call it red; a suite that shows zero cases failed to load.`

// Read-only, so it can share the checkout with red: it gives green a head start, never a contract.
const explore = () => agent(`You are the explorer for /deliver on photonle/Photon issue #${ticket}${epic ? `, part of #${epic}` : ''}.
${WHERE} While another stage writes the ticket's failing GLuaTest cases, you scout how it will be
implemented, so the implementation stage starts with the reading done.

This stage is read-only: change no file, make no commit, and run nothing that writes (no GLuaTest
runs, no gate scripts, no git besides log, show, diff and grep). Another stage may be editing cases
in this checkout as you read, so ignore uncommitted changes under lua/tests/.

Read AGENTS.md and docs/design-constraints.md first, then the docs and code the brief touches. Return:
- approach: how the ticket is likely built, in a few sentences;
- files: the files the change will likely touch or must read, each with why;
- patterns: the existing code to copy, each with its path;
- pitfalls: the footguns, conventions and coupling an implementer would trip on.
Be concrete and short: paths and names, not prose. Do not design the cases; another stage owns them.

The brief:

${brief}`, { label: `explore:#${ticket}`, phase: 'Red', model: 'sonnet', agentType: 'Explore', schema: EXPLORE })

// ── Red, beside the explorer ────────────────────────────────────────────────
phase('Red')
// A "ci" run stops after red so the conductor can push it and read CI's verdict, and its notes
// would go unread, so it scouts in the run that follows instead: that one passes the proven red
// result back in and starts at green.
const [red, explored] = args.red ? [args.red, await explore()] : await parallel([
  () => agent(`${SHARED}

Your stage is RED: write the acceptance contract for this ticket as failing GLuaTest cases.

Read .claude/skills/tdd/SKILL.md and its tests.md and mocking.md, and follow them, with one
sanctioned difference that its "Acceptance contract" section describes: you write a case for every
acceptance criterion in one pass, at the seams the brief names, and write no Photon code at all.
The seams are already agreed; they are the brief's, so confirm nothing with anyone.

Every acceptance criterion gets at least one case, and the negative path (rejected, denied, failed)
gets its own case wherever the criterion has one. GLuaTest runs the server realm only: a criterion
only the client realm can observe goes in "untested".

${RED_CHECK}

Commit the cases alone as test: <what the contract covers>, and return the commit SHA.
A criterion nothing at the seam can observe (a doc change, an internal refactor, client rendering,
behaviour only a person in game can prove) goes in "untested" with the reason: the implementation
stage and the PR's in-game test plan take it from there. "blocked" is for two cases only, and stops
the whole run: a behaviour the seam can observe that you cannot test honestly, or a runner that will
not boot here. Leave it empty otherwise, and never write a case that passes by construction.`, { label: `red:#${ticket}`, phase: 'Red', model: 'sonnet', agentType: 'qa-tester', schema: RED }),
  ...(ci ? [] : [explore]),
])

if (!red || red.blocked) return { stage: 'red', red }
if (ci && !args.red) return { stage: 'verify-red', red }

// ── Green ───────────────────────────────────────────────────────────────────
phase('Green')
const green = await agent(`${SHARED}

Your stage is GREEN: implement the ticket until its red cases pass.

The red cases are commit ${red.commit}, in: ${red.testFiles.join(', ')}. They are the contract. Leave
them as they are; if one is genuinely wrong (it contradicts the brief), change the least you can and
record the file and the reason in "redTestsEdited". The conductor diffs those files afterwards.

Read .claude/skills/implement/SKILL.md and follow its building guidance with the argument ${scope},
except for these steps, which the conductor owns: claiming the issue, cutting the branch,
/standards-review, /code-review, and the pull request. Write the cases for anything finer than the
red cases reach yourself, with /tdd's loop: there is no qa-tester to hand them to in this stage.

The red stage left these acceptance criteria to you, with no red case behind them. Satisfy each, and
add a case of your own wherever its behaviour turns out to be observable:
${red.untested.length ? red.untested.map(u => `- ${u.criterion}: ${u.reason}`).join('\n') : '(none)'}
${explored ? `
A read-only explorer scouted this ticket before you. Its notes are a head start, not a contract: the
red cases decide, so verify anything here before you rely on it.

Approach: ${explored.approach}

Files:
${explored.files.map(f => `- ${f.path}: ${f.why}`).join('\n') || '(none)'}

Patterns to copy:
${explored.patterns.map(p => `- ${p}`).join('\n') || '(none)'}

Pitfalls:
${explored.pitfalls.map(p => `- ${p}`).join('\n') || '(none)'}
` : ''}
Commit the implementation separately from the red cases, on top of ${red.commit}: never amend, squash
or rebase into it, so the history reads test first, then the change that made it pass. Type each
commit as ${implType}: …, and use refactor: … for a preparatory change that alters no behaviour.
Finer cases from the /tdd loop go in the commit with the code they cover.

Run ${GATES} between slices. ${ci
  ? `Done when they are clean, with "suite" "unrun" and "suitesRun" empty: CI is the first thing to
run your change, so read each red case against it line by line before you stop, and write any
finer case you add as carefully as one you could run.`
  : `Done when it is clean and the GLuaTest run is green. List the run in "suitesRun".`} Return the changed files from
\`git diff --name-only ${base}...HEAD\`.`, { label: `green:#${ticket}`, phase: 'Green', model: 'sonnet', agentType: implementer, schema: GREEN })

const suiteOk = s => s === 'green' || (ci && s === 'unrun')
if (!green || !suiteOk(green.suite) || green.gates !== 'clean') return { stage: 'green', red, green }

// ── Review ──────────────────────────────────────────────────────────────────
phase('Review')
const sized = reviewLevel(green.changedFiles)
const reviewModel = LEVELS.indexOf(sized.level) >= LEVELS.indexOf('high') ? 'opus' : 'sonnet'
log(`code review at ${sized.level} on ${reviewModel}${sized.risky.length ? `, raised by ${sized.risky.join(', ')}` : ''}`)

const READ_ONLY = 'This stage is read-only: change no file, make no commit.'

const [codeReview, standardsReview] = await parallel([
  () => agent(`${SHARED}

Your stage is CODE REVIEW. ${READ_ONLY}

Call the Skill tool with skill "code-review" and args "${sized.level} ${base}...HEAD", so it reviews
this branch's commits against ${base} at effort ${sized.level}. Report its findings without filtering.
Put every correctness finding it reports in "blocking", with a short stable id (cr-1, cr-2, …).
Every other finding it reports goes in "advisory", with ids ca-1, ca-2, …, and a note on why it
stands rather than being fixed in this ticket.`,
    { label: `code-review:${sized.level}`, phase: 'Review', model: reviewModel, agentType: 'general-purpose', schema: FINDINGS }),
  () => agent(`${SHARED}

Your stage is STANDARDS REVIEW. ${READ_ONLY}

Read .claude/skills/standards-review/SKILL.md and follow it with ${base} as the fixed point. The spec
is the brief above${epic ? `, read with epic #${epic}'s body` : ''}; you need not search for it.
Put in "blocking", with ids sr-1, sr-2, …: every hard violation of a documented standard, every
requirement the Spec axis finds missing or partial, and every one it finds implemented wrongly.
Baseline smells, scope creep, judgement calls and spec hand-offs go in "advisory" instead, with ids
sa-1, sa-2, …, the kind that fits, and a note on why it stands rather than being fixed here.`,
    { label: 'standards-review', phase: 'Review', model: 'opus', agentType: 'general-purpose', schema: FINDINGS }),
])

const blocking = [codeReview, standardsReview].filter(Boolean).flatMap(r => r.blocking)

// ── Fix ─────────────────────────────────────────────────────────────────────
phase('Fix')
let fix = null
if (blocking.length) {
  fix = await agent(`${SHARED}

Your stage is FIX: one round over the review's blocking findings, below.

${JSON.stringify(blocking, null, 2)}

Verify each before touching code: reproduce it, ideally as a failing case. Fix what reproduces, with
a regression case where the finding is a behaviour bug; mark the rest not-reproduced with what you
checked. Leave a finding as "left" only when fixing it would widen the ticket, and say why. The red
cases in ${red.testFiles.join(', ')} stay as they are. ${TEST_HOME}

Commit as fix: …, then re-run ${GATES}${ci ? '' : ` and the GLuaTest runs the green stage ran
(${green.suitesRun.join(', ')})`}. This is the only round: there is no re-review after you.`, { label: `fix:${blocking.length}`, phase: 'Fix', model: 'sonnet', agentType: implementer, schema: FIX })
} else {
  log('no blocking findings: fix round skipped')
}

return {
  stage: 'done',
  red,
  green,
  review: { level: sized.level, model: reviewModel, risky: sized.risky, code: codeReview, standards: standardsReview },
  fix,
}
