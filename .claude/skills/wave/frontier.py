#!/usr/bin/env python3
"""Resolve the next /wave for photonle/Photon: walk the issues named, and route every child to the
skill that advances it.

    frontier.py fetch <issue>... > wave.json     reads GitHub through gh
    frontier.py classify wave.json               pure: no network, no clock

`fetch` walks each argument down its native sub-issues, uncapped, and records every issue it reaches.
`classify` buckets them by the ladder below and prints one JSON document. Keeping the two apart puts
the ladder in the unit suite (test_frontier.py) rather than beside it.
"""
import json
import re
import subprocess
import sys

REPO_OWNER, REPO_NAME = "photonle", "Photon"
CONTAINERS = {"Epic", "Initiative"}

# What each dispatched session asks of the maintainer once it runs, which splits the report into
# work and homework. with_parent gives the skill its ticket as <parent>/<n>, so it reads the
# parent's spec.
SKILLS = {
    "triage": {"waits_for_you": True, "multi_round": False},
    "grill-to-spec": {"waits_for_you": True, "multi_round": True},
    "to-tickets": {"waits_for_you": True, "multi_round": False},
    "research": {"waits_for_you": False, "multi_round": False},
    "deliver": {"waits_for_you": False, "multi_round": False, "with_parent": True},
}

QUERY = """
query($owner: String!, $name: String!, $number: Int!) {
  repository(owner: $owner, name: $name) {
    issue(number: $number) {
      number
      title
      state
      issueType { name }
      assignees(first: 5) { nodes { login } }
      parent { number }
      blockedBy(first: 50) { nodes { number state } }
      closedByPullRequestsReferences(first: 10, includeClosedPrs: false) { nodes { number state } }
      subIssues(first: 100) { nodes { number } }
      issueFieldValues(first: 10) {
        nodes {
          ... on IssueFieldSingleSelectValue { name field { ... on IssueFieldSingleSelect { name } } }
        }
      }
    }
  }
}
"""


def parse_reference(argument):
    """A bare number, #number, or a photonle/Photon issue URL; None for anything else."""
    match = re.fullmatch(r"#?(\d+)", argument.strip())
    if match:
        return int(match.group(1))
    match = re.fullmatch(r"https://github\.com/photonle/Photon/issues/(\d+)/?", argument.strip(), re.I)
    return int(match.group(1)) if match else None


def read_issue(number):
    """One issue's routing facts, or None when it can't be read (a PR number, a missing issue)."""
    result = subprocess.run(
        ["gh", "api", "graphql", "-H", "GraphQL-Features: issue_fields",
         "-F", f"owner={REPO_OWNER}", "-F", f"name={REPO_NAME}", "-F", f"number={number}",
         "-f", f"query={QUERY}"],
        capture_output=True, text=True, encoding="utf-8")
    if result.returncode != 0:
        return None
    issue = (json.loads(result.stdout).get("data") or {}).get("repository", {}).get("issue")
    if not issue:
        return None
    fields = {v["field"]["name"]: v["name"] for v in issue["issueFieldValues"]["nodes"] if v.get("field")}
    return {
        "number": issue["number"],
        "title": issue["title"],
        "state": issue["state"].lower(),
        "type": (issue["issueType"] or {}).get("name"),
        "stage": fields.get("Stage"),
        "assignees": [a["login"] for a in issue["assignees"]["nodes"]],
        "parent": (issue["parent"] or {}).get("number"),
        "blocked_by": [b["number"] for b in issue["blockedBy"]["nodes"] if b["state"] == "OPEN"],
        "open_prs": [p["number"] for p in issue["closedByPullRequestsReferences"]["nodes"] if p["state"] == "OPEN"],
        "children": [c["number"] for c in issue["subIssues"]["nodes"]],
    }


def fetch(arguments):
    """Reads every issue the arguments reach, each once."""
    roots, issues, pending = [], {}, []
    for argument in arguments:
        number = parse_reference(argument)
        roots.append({"argument": argument, "number": number})
        if number is not None:
            pending.append(number)
    while pending:
        number = pending.pop()
        if number in issues:
            continue
        issue = read_issue(number)
        issues[number] = issue
        if issue and issue["state"] == "open":
            pending.extend(issue["children"])
    return {"roots": roots, "issues": {str(k): v for k, v in issues.items()}}


def route(issue):
    """The bucket a leaf belongs in, with the reason or the action that advances it."""
    kind, stage = issue["type"], issue["stage"]
    if issue["state"] == "closed":
        return "done", None
    if issue["assignees"] or issue["open_prs"]:
        return "in_flight", None
    if stage == "Needs Information":
        return "human", "waiting on its reporter (Needs Information)"
    if kind == "Wayfinder":
        return "human", "a wayfinder map is worked with /wayfinder, by a person"
    if issue["blocked_by"] or stage == "Blocked":
        return "blocked", None
    if stage in (None, "New"):
        return "frontier", "triage"
    if kind == "Feature" and stage in ("Awaiting Review", "Triaged"):
        return "frontier", "grill-to-spec"
    if kind == "Stub":
        return "frontier", "grill-to-spec"
    if kind == "Spec" and stage == "Awaiting Review":
        return "frontier", "to-tickets"
    if kind in CONTAINERS and not issue["children"]:
        return "frontier", "to-tickets"
    if kind == "Research":
        return "frontier", "research"
    if kind in ("Task", "Bug") and stage == "Triaged":
        return "frontier", "deliver"
    return "human", f"no skill advances a {kind or 'untyped issue'} at {stage}"


def classify(payload):
    issues = {int(k): v for k, v in payload["issues"].items()}
    buckets = {name: [] for name in ("frontier", "in_flight", "blocked", "human", "done")}
    arguments, parents, warnings = [], {}, []
    placed = set()

    def place(issue, parent, root):
        if issue["number"] in placed:
            return
        placed.add(issue["number"])
        entry = {"number": issue["number"], "title": issue["title"], "type": issue["type"],
                 "stage": issue["stage"], "parent": parent, "root": root}
        bucket, detail = route(issue)
        if bucket == "frontier":
            skill = SKILLS[detail]
            argument = f"{parent}/{issue['number']}" if parent and skill.get("with_parent") else str(issue["number"])
            entry["action"] = {"skill": detail, "argument": argument,
                               "waits_for_you": skill["waits_for_you"], "multi_round": skill["multi_round"]}
        elif bucket == "in_flight":
            entry["assignees"], entry["open_prs"] = issue["assignees"], issue["open_prs"]
        elif bucket == "blocked":
            entry["blocked_by"], entry["held"] = issue["blocked_by"], issue["stage"] == "Blocked"
        elif bucket == "human":
            entry["reason"] = detail
        buckets[bucket].append(entry)

    def walk(number, parent, root, path):
        issue = issues.get(number)
        if issue is None:
            warnings.append(f"#{number}, under #{parent}, could not be read")
            return
        is_container = issue["type"] in CONTAINERS and issue["children"] and issue["state"] == "open"
        if not is_container:
            place(issue, parent, root)
            return
        # An Epic or Initiative stopped by hand holds its children back with it, unwalked.
        if issue["stage"] == "Blocked" or issue["blocked_by"]:
            place(dict(issue, children=[]), parent, root)
            return
        children = [issues.get(c) for c in issue["children"]]
        parents[number] = {"title": issue["title"],
                           "all_done": all(c is not None and c["state"] == "closed" for c in children)}
        for child in issue["children"]:
            if child in path:
                warnings.append(f"#{child} is its own ancestor under #{number}; not walked again")
                continue
            walk(child, number, root, path | {child})

    for root in payload["roots"]:
        number = root["number"]
        issue = issues.get(number) if number is not None else None
        if number is None:
            arguments.append({"argument": root["argument"], "status": "skipped",
                              "reason": "not an issue number or photonle/Photon issue URL"})
        elif issue is None:
            arguments.append({"argument": root["argument"], "status": "skipped",
                              "reason": f"#{number} could not be read: it may be a pull request or not exist"})
        elif issue["state"] == "closed":
            arguments.append({"argument": root["argument"], "status": "skipped", "reason": f"#{number} is closed"})
        else:
            arguments.append({"argument": root["argument"], "status": "ok"})
            walk(number, None, number, {number})

    for entries in buckets.values():
        entries.sort(key=lambda e: e["number"])
    return {"arguments": arguments, "buckets": buckets, "parents": parents, "warnings": warnings,
            "counts": {name: len(entries) for name, entries in buckets.items()}}


def main(argv):
    if len(argv) >= 2 and argv[0] == "fetch":
        json.dump(fetch(argv[1:]), sys.stdout, indent=1)
    elif len(argv) == 2 and argv[0] == "classify":
        with open(argv[1], encoding="utf-8") as handle:
            json.dump(classify(json.load(handle)), sys.stdout, indent=1)
    else:
        sys.exit(__doc__)
    print()


if __name__ == "__main__":
    main(sys.argv[1:])
