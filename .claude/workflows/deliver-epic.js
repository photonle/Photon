export const meta = {
  name: 'deliver-epic',
  description: 'The agent stages of /deliver-epic: deliver-stages once per ticket in order, then one review of the whole epic, one fix round and at most one repair round',
  whenToUse: 'Called by the /deliver-epic skill with a prepared plan; not meant to be run by hand',
  phases: [
    { title: 'Tickets', detail: 'deliver-stages once per ticket, one after another, on one branch' },
    { title: 'Final review', detail: '/code-review over the whole epic, beside /standards-review against the epic', model: 'opus' },
    { title: 'Final fix', detail: 'one round over the blocking findings, then at most one repair round', model: 'sonnet' },
  ],
}

// The plan, baked in here by .claude/skills/deliver-epic/plan.py --script, so a plan of any size reaches this
// workflow without the conductor writing it out. Run unbaked, args carries all of it instead.
//   epic        the epic's number, e.g. 347
//   epicBrief   the epic's title and body verbatim: the spec the final review checks against
//   tickets     [{ number, title, brief, labels }] still to deliver, in the order plan.py gave
//   base        the fixed point the final review diffs against, normally "origin/development"
const PLAN = null

// args, from .claude/skills/deliver-epic/SKILL.md: what the conductor knows from git and this machine.
//   delivered   [{ number, title, summary, testFiles }] delivered by an earlier run onto this branch, or []
//   startHead   the SHA HEAD stood at when this run began: the first ticket's review base
const { epic, epicBrief, tickets, delivered = [], base, startHead } = { ...PLAN, ...args }

const LEVELS = ['low', 'medium', 'high', 'xhigh']

// What "green" means for every stage that changes code here, as deliver-stages defines it for a
// local runner: the diff gates over the whole epic, and every GLuaTest project the epic reaches.
const CHECKS = `the glualint hunk gate (python .github/scripts/lua_hunk_gate.py --base ${base} --head HEAD) is
clean, and the GLuaTest run (bash .github/scripts/gluatest-local.sh) is green. Report "suite" red when
the run fails, and "gates" errors when the gate does`

// Where a fix round's cases go: beside the behaviour, so the suite reads by feature, not by history.
const TEST_HOME = `Put each new case in the existing test file for the behaviour it covers, beside the cases
already there, and never in a new file named after a review, a finding or this round.`

// What every later ticket is told about the earlier ones, so it builds on them rather than
// alongside them. Nothing of it is on the base yet: it lands with the epic's one pull request.
function alreadyDelivered(done){
  if (!done.length) return ''
  return `\n\n## Already delivered in this run\n\nThese tickets of epic #${epic} are already committed on this branch, and are not on ${base}.
Build on what they added; do not add it again.\n\n${done.map(d => `- #${d.number} ${d.title}: ${d.summary}${d.changedFiles ? ` (${d.changedFiles.join(', ')})` : ''}`).join('\n')}`
}

// A per-ticket result cut down to what the conductor verifies and the pull request lists. The
// review reports stay in the journal: only the findings still standing come back.
function compact(ticket, run){
  const fixed = new Set((run.fix?.outcomes || []).filter(o => o.outcome === 'fixed').map(o => o.id))
  const notes = new Map((run.fix?.outcomes || []).map(o => [o.id, o.note]))
  const reviews = [run.review.code, run.review.standards].filter(Boolean)
  return {
    number: ticket.number,
    title: ticket.title,
    redCommit: run.red.commit,
    testFiles: run.red.testFiles,
    head: run.fix?.head || run.green.head,
    changedFiles: run.green.changedFiles,
    summary: run.green.summary,
    suitesRun: run.green.suitesRun,
    level: run.review.level,
    untested: run.red.untested,
    redTestsEdited: run.green.redTestsEdited,
    outstanding: [
      ...reviews.flatMap(r => r.blocking).filter(f => !fixed.has(f.id)).map(f => ({ ...f, kind: 'blocking', note: notes.get(f.id) || 'no fix round ran' })),
      ...reviews.flatMap(r => r.advisory || []),
    ].map(f => ({ ...f, key: `#${ticket.number}/${f.id}` })),
  }
}

// ── Tickets ─────────────────────────────────────────────────────────────────
phase('Tickets')
const done = []
let head = startHead

for (const ticket of tickets) {
  log(`#${ticket.number}: ${ticket.title}`)
  const run = await workflow('deliver-stages', {
    ticket: ticket.number,
    epic,
    brief: ticket.brief + alreadyDelivered([...delivered, ...done]),
    labels: ticket.labels,
    base: head,
    runner: 'local',
    red: null,
    workdir: null,
    implementer: null,
  })

  // A ticket that did not finish green is not delivered. Its commits sit on top of `head`, which
  // the conductor resets to, so the pull request carries only whole tickets.
  const fixBroke = run?.fix && (run.fix.suite !== 'green' || run.fix.gates !== 'clean')
  if (!run || run.stage !== 'done' || fixBroke) {
    const last = fixBroke ? run.fix : run?.green
    return {
      stage: 'stopped',
      tickets: done,
      stopped: {
        number: ticket.number,
        title: ticket.title,
        stage: !run ? 'workflow' : run.stage !== 'done' ? run.stage : 'fix',
        resetTo: head,
        blocked: run?.red?.blocked || null,
        suite: last?.suite || null,
        gates: last?.gates || null,
      },
      final: null,
    }
  }

  const result = compact(ticket, run)
  done.push(result)
  head = result.head
}

// ── Final review ────────────────────────────────────────────────────────────
// Sized at the highest level any ticket reached this run, and never below high: it reads the
// whole epic's diff, which no per-ticket review saw at once.
phase('Final review')
const level = done.map(t => t.level).concat('high').reduce((a, b) => LEVELS.indexOf(b) > LEVELS.indexOf(a) ? b : a)
log(`final review at ${level} on opus over ${base}...HEAD`)

const testFiles = [...new Set([...delivered, ...done].flatMap(t => t.testFiles || []))]

const SHARED = `You are the final pass of /deliver-epic for photonle/Photon Epic #${epic}: every ticket of it is already
delivered on this branch, one after another, each reviewed and fixed on its own. Your concern is the
epic as a whole: what only shows across tickets, and whether together they meet the epic's spec.
Work in the current checkout and on the current branch. Never push, never open or edit a pull
request, never comment on an issue: the conductor owns every forge write.

The epic, which is the spec:

${epicBrief}

The tickets delivered on this branch:

${[...delivered, ...done].map(d => `- #${d.number} ${d.title}: ${d.summary}`).join('\n')}`

const FINDINGS = {
  type: 'object',
  properties: {
    report: { type: 'string' },
    blocking: {
      type: 'array',
      items: {
        type: 'object',
        properties: { id: { type: 'string' }, file: { type: 'string' }, line: { type: 'integer' }, summary: { type: 'string' } },
        required: ['id', 'file', 'summary'],
      },
    },
    advisory: {
      type: 'array',
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

const READ_ONLY = 'This stage is read-only: change no file, make no commit.'

// What the per-ticket reviews left standing, for the final review to re-judge against the whole epic.
const standing = done.flatMap(t => t.outstanding)

const [codeReview, standardsReview] = await parallel([
  () => agent(`${SHARED}

Your stage is CODE REVIEW. ${READ_ONLY}

Call the Skill tool with skill "code-review" and args "${level} ${base}...HEAD", so it reviews the
whole epic's commits against ${base} at effort ${level}. Report its findings without filtering. Put
every correctness finding in "blocking", with ids fcr-1, fcr-2, …, and every other finding in
"advisory", with ids fca-1, fca-2, …, each with a note on why it stands.`,
    { label: `final-code-review:${level}`, phase: 'Final review', model: 'opus', agentType: 'general-purpose', schema: FINDINGS }),
  () => agent(`${SHARED}

Your stage is STANDARDS REVIEW. ${READ_ONLY}

Read .claude/skills/standards-review/SKILL.md and follow it with ${base} as the fixed point. The spec
is the epic above; you need not search for it, and each ticket's own acceptance criteria were
already checked when it was delivered. Put in "blocking", with ids fsr-1, fsr-2, …: every hard
violation of a documented standard, and every requirement of the epic the Spec axis finds missing,
partial or implemented wrongly. Baseline smells, scope creep, judgement calls and spec hand-offs go
in "advisory" instead, with ids fsa-1, fsa-2, …, the kind that fits, and a note on why it stands.
${standing.length ? `
Each ticket's own review left the findings below standing, judged against that ticket's code alone.
A later ticket may have settled one since. Judge each against the code at HEAD: put its key in
"settled" when the problem it names is gone there, and leave it out when it still stands or you
cannot tell. Raise nothing about them in "blocking" or "advisory": they are listed already.

${JSON.stringify(standing.map(({ key, file, summary }) => ({ key, file, summary })), null, 2)}` : ''}`,
    { label: 'final-standards-review', phase: 'Final review', model: 'opus', agentType: 'general-purpose', schema: { ...FINDINGS, properties: { ...FINDINGS.properties, settled: { type: 'array', items: { type: 'string' }, description: 'Keys of the earlier findings the code at HEAD has settled' } } } }),
])

const reviews = [codeReview, standardsReview].filter(Boolean)

// A finding a later ticket settled is not open any more: drop it rather than ask a person to check.
const settled = new Set(standardsReview?.settled || [])
for (const t of done) t.outstanding = t.outstanding.filter(f => !settled.has(f.key))
if (settled.size) log(`${settled.size} earlier finding${settled.size === 1 ? '' : 's'} settled by later tickets`)
const blocking = reviews.flatMap(r => r.blocking)
const advisory = reviews.flatMap(r => r.advisory || [])

// ── Final fix ───────────────────────────────────────────────────────────────
phase('Final fix')
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
    redTestsEdited: {
      type: 'array',
      items: { type: 'object', properties: { file: { type: 'string' }, why: { type: 'string' } }, required: ['file', 'why'] },
    },
    suite: { type: 'string', enum: ['green', 'red'] },
    gates: { type: 'string', enum: ['clean', 'errors'] },
  },
  required: ['head', 'outcomes', 'redTestsEdited', 'suite', 'gates'],
}

const REPAIR = {
  type: 'object',
  properties: {
    head: { type: 'string' },
    redTestsEdited: {
      type: 'array',
      items: { type: 'object', properties: { file: { type: 'string' }, why: { type: 'string' } }, required: ['file', 'why'] },
    },
    suite: { type: 'string', enum: ['green', 'red'] },
    gates: { type: 'string', enum: ['clean', 'errors'] },
    note: { type: 'string' },
  },
  required: ['head', 'redTestsEdited', 'suite', 'gates', 'note'],
}

const KEEP_RED = `The red cases of every ticket stay as they are: ${testFiles.join(', ')}. If one genuinely must change,
change the least you can and record the file and the reason in "redTestsEdited".`

let fix = null
let repair = null
let reverted = false

if (blocking.length) {
  fix = await agent(`${SHARED}

Your stage is FIX: one round over the final review's blocking findings, below.

${JSON.stringify(blocking, null, 2)}

Verify each before touching code: reproduce it, ideally as a failing case. Fix what reproduces, with
a regression case where the finding is a behaviour bug; mark the rest not-reproduced with what you
checked. Leave a finding as "left" only when fixing it would widen the epic, and say why. ${KEEP_RED}
${TEST_HOME}

Commit as fix: …, then re-run the checks: done when ${CHECKS}. There is no re-review after you.`, { label: `final-fix:${blocking.length}`, phase: 'Final fix', model: 'sonnet', agentType: 'general-purpose', schema: FIX })

  // One repair round, to make the suite green again and nothing else. Still red after it, the fix
  // round is undone: every ticket's head was proven green, and nothing re-reviews the final fix.
  if (!fix || fix.suite !== 'green' || fix.gates !== 'clean') {
    repair = await agent(`${SHARED}

Your stage is REPAIR. The final fix round, committed on top of ${head}, left the checks failing.
Run them, read the failures, and change only what makes them pass again: no new behaviour, no
review findings beyond the ones already fixed. ${KEEP_RED} ${TEST_HOME}

Commit as fix: …, re-run the checks, and report where they stand: done when ${CHECKS}.`, { label: 'final-repair', phase: 'Final fix', model: 'sonnet', agentType: 'general-purpose', schema: REPAIR })
    reverted = !repair || repair.suite !== 'green' || repair.gates !== 'clean'
  }
} else {
  log('no blocking findings in the final review: fix round skipped')
}

const fixed = new Set(reverted ? [] : (fix?.outcomes || []).filter(o => o.outcome === 'fixed').map(o => o.id))
const notes = new Map((fix?.outcomes || []).map(o => [o.id, o.note]))

return {
  stage: 'done',
  tickets: done,
  stopped: null,
  final: {
    level,
    model: 'opus',
    // When the fix round is undone, the conductor resets to the last ticket's head.
    reverted,
    resetTo: reverted ? head : null,
    head: reverted ? head : repair?.head || fix?.head || head,
    repaired: !!repair && !reverted,
    repairNote: repair?.note || null,
    // Red cases of any ticket the kept fix and repair rounds edited, each with its reason.
    redTestsEdited: reverted ? [] : [...(fix?.redTestsEdited || []), ...(repair?.redTestsEdited || [])],
    outstanding: [
      ...blocking.filter(f => !fixed.has(f.id)).map(f => ({ ...f, kind: 'blocking', note: reverted ? 'the final fix round was undone: it left the suite failing' : notes.get(f.id) || 'no fix round ran' })),
      ...advisory,
    ],
  },
}
