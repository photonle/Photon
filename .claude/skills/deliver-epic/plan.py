#!/usr/bin/env python3
"""Plan a /deliver-epic run for photonle/Photon: read the Epic and its sub-issues, check every one is
ready, order them by their blocked-by links, and bake the plan into a copy of the deliver-epic
workflow, so the tickets' briefs never pass through the conversation.

    plan.py <epic> --as <login> --script <path> [--resume-pr <n>]

Prints one JSON document:
    ok        true when every open sub-issue is ready; the plan is all or nothing
    stops     [{number, reason, skill}]: what stops the plan, and the skill that fixes it
    done      sub-issues already closed
    tickets   [{number, title, criteria, comments, open_references, resume_pr}] in delivery order:
              criteria from the body or the latest triage brief; open_references, the open issues
              and pull requests that mention it; resume_pr, delivered already by an earlier run's
              draft, which the script leaves out
    script    the baked workflow, written only when ok

Every baked brief, the Epic's included, carries the body, the whole comment thread and what mentions
it: later decisions and follow-ups are recorded there, not in the body.
A failed read exits 1 and prints nothing.
"""
import argparse
import json
import re
import subprocess
import sys
from pathlib import Path

QUERY = """
query($number: Int!) {
  repository(owner: "photonle", name: "Photon") {
    issue(number: $number) {
      number title body state
      issueType { name }
      assignees(first: 5) { nodes { login } }
      blockedBy(first: 50) { nodes { number state } }
      subIssues(first: 100) { nodes { number } }
      comments(first: 100) { nodes { author { login } createdAt body } }
      timelineItems(first: 50, itemTypes: [CROSS_REFERENCED_EVENT]) {
        nodes { ... on CrossReferencedEvent { source {
          __typename
          ... on Issue { number title state }
          ... on PullRequest { number title state }
        } } }
      }
      issueFieldValues(first: 10) {
        nodes { ... on IssueFieldSingleSelectValue { name field { ... on IssueFieldSingleSelect { name } } } }
      }
    }
  }
}
"""


class ReadFailed(Exception):
    pass


def read_issue(number):
    result = subprocess.run(
        ["gh", "api", "graphql", "-H", "GraphQL-Features: issue_fields", "-F", f"number={number}",
         "-f", f"query={QUERY}"], capture_output=True, text=True, encoding="utf-8")
    issue = None
    if result.returncode == 0:
        issue = ((json.loads(result.stdout).get("data") or {}).get("repository") or {}).get("issue")
    if not issue:
        raise ReadFailed(f"#{number} could not be read")
    fields = {v["field"]["name"]: v["name"] for v in issue["issueFieldValues"]["nodes"] if v.get("field")}
    return {
        "number": issue["number"], "title": issue["title"], "body": issue["body"] or "",
        "state": issue["state"].lower(), "type": (issue["issueType"] or {}).get("name"),
        "stage": fields.get("Stage"), "priority": fields.get("Priority"), "effort": fields.get("Effort"),
        "assignees": [a["login"] for a in issue["assignees"]["nodes"]],
        "blocked_by": [b["number"] for b in issue["blockedBy"]["nodes"] if b["state"] == "OPEN"],
        "children": [c["number"] for c in issue["subIssues"]["nodes"]],
        "comments": [{"author": (c["author"] or {}).get("login", "ghost"), "at": c["createdAt"][:10], "body": c["body"]}
                     for c in issue["comments"]["nodes"]],
        "references": [{"kind": "pull request" if r["source"]["__typename"] == "PullRequest" else "issue",
                        "number": r["source"]["number"], "title": r["source"]["title"],
                        "state": r["source"]["state"].lower()}
                       for r in issue["timelineItems"]["nodes"] if (r.get("source") or {}).get("number")],
    }


def section(body, name):
    """The text under a `## <name>` heading, up to the next heading of the same level, or None."""
    match = re.search(rf"^##\s+{re.escape(name)}\s*$(.*?)(?=^##\s|\Z)", body, re.M | re.S | re.I)
    return match.group(1).strip() if match else None


def checklist(text):
    return [m.group(1).strip() for m in re.finditer(r"^\s*-\s*\[[ xX]\]\s*(.+)$", text or "", re.M)]


def latest_brief(issue):
    """The newest comment holding a `## Brief` heading, as /triage posts it, or None."""
    briefs = [c["body"] for c in issue["comments"] if re.search(r"^##\s+Brief\s*$", c["body"], re.M)]
    return briefs[-1] if briefs else None


def brief_field(brief, name):
    """The text after a `**<name>:**` line of a triage brief, up to the next bold field."""
    match = re.search(rf"^\*\*{re.escape(name)}:\*\*(.*?)(?=^\*\*[^*\n]+:\*\*|\Z)", brief or "", re.M | re.S)
    return match.group(1).strip() if match else None


def criteria(issue):
    """The body's `## Acceptance criteria`, or failing that the latest triage brief's."""
    return (checklist(section(issue["body"], "Acceptance criteria"))
            or checklist(brief_field(latest_brief(issue), "Acceptance criteria")))


def seams(issue):
    """The ticket's own testing seams: its `## Testing Decisions`, or a triage brief's key interfaces."""
    return section(issue["body"], "Testing Decisions") or brief_field(latest_brief(issue), "Key interfaces")


def context(issue):
    """The issue as a whole: its body, the thread where later decisions land, and every issue and
    pull request that mentions it, so a follow-up filed elsewhere is not missed."""
    parts = [f"{issue['title']}\n\n{issue['body']}"]
    if issue["comments"]:
        parts.append("## Thread (oldest first; a later comment overrides an earlier one and the body)\n\n"
                     + "\n\n".join(f"### {c['author']}, {c['at']}\n\n{c['body']}" for c in issue["comments"]))
    if issue["references"]:
        parts.append("## Issues and pull requests that mention it\n\nRead any still open before building: "
                     "a follow-up may narrow or extend this one.\n\n"
                     + "\n".join(f"- {r['kind']} #{r['number']} [{r['state']}] {r['title']}" for r in issue["references"]))
    return "\n\n".join(parts)


def closes_in(pr):
    """Issue numbers an earlier run's draft already carries a `Closes #n.` line for."""
    result = subprocess.run(["gh", "pr", "view", str(pr), "--repo", "photonle/Photon", "--json", "body",
                             "--jq", ".body"], capture_output=True, text=True, encoding="utf-8")
    if result.returncode != 0:
        raise ReadFailed(f"pull request #{pr} could not be read")
    return {int(n) for n in re.findall(r"^Closes #(\d+)\.", result.stdout, re.M)}


def plan(epic_number, login, resume_pr=None):
    epic = read_issue(epic_number)
    if epic["type"] != "Epic":
        hint = "/deliver" if epic["type"] in ("Task", "Bug") else "/wave, one Epic at a time"
        return {"ok": False, "stops": [{"number": epic_number, "reason": f"#{epic_number} is a {epic['type']}, not an Epic", "skill": hint}],
                "done": [], "tickets": []}
    if epic["state"] != "open":
        return {"ok": False, "stops": [{"number": epic_number, "reason": "the Epic is closed", "skill": None}], "done": [], "tickets": []}

    children = [read_issue(n) for n in epic["children"]]
    delivered = closes_in(resume_pr) if resume_pr else set()
    epic_seams = section(epic["body"], "Testing Decisions")
    stops, done, open_children = [], [], []

    def stop(number, reason, skill=None):
        stops.append({"number": number, "reason": reason, "skill": skill})

    for child in children:
        if child["state"] == "closed":
            done.append(child["number"])
            continue
        open_children.append(child)
        n = child["number"]
        if child["number"] in delivered:
            continue
        if child["type"] not in ("Task", "Bug"):
            stop(n, f"a {child['type']} is not a ticket", "/to-tickets" if child["type"] == "Spec" else "/wave")
        if child["stage"] != "Triaged":
            stop(n, f"Stage is {child['stage'] or 'unset'}, not Triaged", "/triage")
        if any(a != login for a in child["assignees"]):
            stop(n, f"claimed by {', '.join(child['assignees'])}", None)
        if not criteria(child):
            stop(n, "no acceptance criteria in its body or a triage brief", "/to-tickets")
        if not seams(child) and not epic_seams:
            stop(n, "no `## Testing Decisions` in the ticket or the Epic, and no brief's key interfaces", "/to-spec")

    siblings = {c["number"] for c in open_children}
    for child in open_children:
        outside = [b for b in child["blocked_by"] if b not in siblings]
        if outside:
            stop(child["number"], f"blocked by {', '.join(f'#{b}' for b in outside)}, outside this Epic", None)

    # Blockers first; ties keep the Epic's sub-issue order, which is the build order /to-tickets set.
    ordered, placed, remaining = [], set(), list(open_children)
    while remaining:
        ready = [c for c in remaining if all(b in placed or b not in siblings for b in c["blocked_by"])]
        if not ready:
            for c in remaining:
                stop(c["number"], "its blocked-by links form a cycle with its siblings", "/to-tickets")
            break
        ordered.append(ready[0])
        placed.add(ready[0]["number"])
        remaining.remove(ready[0])

    tickets = [{"number": c["number"], "title": c["title"], "criteria": criteria(c),
                "comments": len(c["comments"]),
                "open_references": [r["number"] for r in c["references"] if r["state"] == "open"],
                "resume_pr": c["number"] in delivered} for c in ordered]
    result = {"ok": not stops, "stops": stops, "done": done, "tickets": tickets}
    result["_bake"] = {
        "epic": epic_number,
        "epicBrief": context(epic),
        "base": "origin/development",
        "tickets": [{
            "number": c["number"], "title": c["title"],
            "brief": context(c) + (
                "" if seams(c) else f"\n\n## Testing Decisions (from Epic #{epic_number})\n\n{epic_seams}"),
            "labels": {"type": c["type"], "priority": c["priority"], "effort": c["effort"]},
        } for c in ordered if c["number"] not in delivered],
    }
    return result


def main(argv):
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("epic", type=lambda s: int(s.lstrip("#")))
    parser.add_argument("--as", dest="login", required=True)
    parser.add_argument("--script", required=True)
    parser.add_argument("--resume-pr", type=int)
    options = parser.parse_args(argv)
    try:
        result = plan(options.epic, options.login, options.resume_pr)
    except ReadFailed as error:
        print(error, file=sys.stderr)
        return 1
    bake = result.pop("_bake", None)
    if result["ok"] and bake:
        template = (Path(__file__).resolve().parents[2] / "workflows" / "deliver-epic.js").read_text(encoding="utf-8")
        if "const PLAN = null" not in template:
            print("deliver-epic.js has no `const PLAN = null` line to bake into", file=sys.stderr)
            return 1
        Path(options.script).write_text(template.replace("const PLAN = null", f"const PLAN = {json.dumps(bake)}", 1), encoding="utf-8")
        result["script"] = options.script
    json.dump(result, sys.stdout, indent=1)
    print()
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
