#!/usr/bin/env python3
"""Runs glualint lint against changed .lua files, but only reports issues that fall on lines
actually touched between --base and --head. Pre-existing issues elsewhere in a touched file are
ignored so the gate doesn't block on legacy lint debt.
"""
import argparse
import re
import subprocess
import sys
from collections import defaultdict

HUNK_HEADER_RE = re.compile(r"^@@ -(\d+)(?:,(\d+))? \+(\d+)(?:,(\d+))? @@")
GITHUB_ANNOTATION_RE = re.compile(
    r'^::(?P<level>error|warning) file=(?P<file>[^,]*),line=(?P<line>\d+),col=(?P<col>\d+),'
    r'endLine=(?P<endLine>\d+),endColumn=(?P<endColumn>\d+),title="(?P<title>[^"]*)"::'
    r'(?P<message>.*)$'
)

# The workflow falls back to the empty tree when a branch has no branch point to scope
# against. It is a tree rather than a commit, so it is never worth a reachability check.
EMPTY_TREE = "4b825dc642cb6eb9a060e54bf8d69288fbee4904"


def sh(*args):
    return subprocess.run(args, capture_output=True, text=True)


def unresolvable(*revs):
    """Returns the given revs that this checkout cannot resolve to a commit."""
    return [
        rev
        for rev in revs
        if rev != EMPTY_TREE
        and sh("git", "rev-parse", "--verify", "--quiet", f"{rev}^{{commit}}").returncode != 0
    ]


def changed_lines_by_file(base, head):
    """Returns {file: set(line numbers touched in the new version)} for *.lua files."""
    diff = sh("git", "diff", "--unified=0", "--diff-filter=d", base, head, "--", "*.lua")
    if diff.returncode != 0:
        sys.exit(f"git diff {base}..{head} failed:\n{diff.stderr}")

    result = defaultdict(set)
    current_file = None
    for line in diff.stdout.splitlines():
        if line.startswith("+++ "):
            path = line[4:]
            current_file = None if path == "/dev/null" else path[2:]
            continue
        m = HUNK_HEADER_RE.match(line)
        if m and current_file:
            start = int(m.group(3))
            count = int(m.group(4)) if m.group(4) is not None else 1
            if count:
                result[current_file].update(range(start, start + count))
    return result


def gate_lint(base, head):
    missing = unresolvable(base, head)
    if missing:
        # A force-push orphans the commit github.event.before named, and nothing refetches it,
        # so there is no diff left to scope the lint to. That is a state of the CI harness
        # rather than a fault in the code being pushed, so say so and pass instead of failing
        # the run, which would read as a lint finding against the push.
        print(
            "::warning title=GLua lint skipped::Cannot resolve {} in this checkout, so there is "
            "no diff to scope the lint to. Skipped - this is a CI harness condition, not a lint "
            "finding.".format(", ".join(missing))
        )
        return 0

    changed = changed_lines_by_file(base, head)
    files = sorted(changed)
    if not files:
        print("No changed .lua files to lint.")
        return 0

    proc = sh("glualint", "--output-format", "github", "lint", *files)

    failed = False
    for line in proc.stdout.splitlines():
        m = GITHUB_ANNOTATION_RE.match(line)
        if not m:
            continue
        touched = changed.get(m.group("file"), set())
        span = range(int(m.group("line")), int(m.group("endLine")) + 1)
        if not any(l in touched for l in span):
            continue
        print(line)
        if m.group("level") == "error":
            failed = True

    if proc.returncode != 0 and not failed and proc.stderr.strip():
        # glualint failed for a reason other than reportable lint messages (e.g. a parse
        # error it couldn't attribute to a line range) - surface it rather than staying silent.
        print(proc.stderr, file=sys.stderr)
        failed = True

    return 1 if failed else 0


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--base", required=True)
    parser.add_argument("--head", required=True)
    args = parser.parse_args()

    sys.exit(gate_lint(args.base, args.head))


if __name__ == "__main__":
    main()
