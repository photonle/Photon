#!/usr/bin/env bash
# Print the CI state of a pull request's head: pending, green or red, then one line per check.
# Only pull_request-event checks count: a push to the branch runs some workflows a second time, and
# those runs do not gate the pull request.
#
#   .claude/skills/deliver/ci-state.sh <pr-number>
#
# Checks register a few seconds after a push, so no checks yet, or no GLuaTest check (gluatest.yml
# runs on every pull request), reads as pending rather than green.
#
# Exit codes: 0 green, 1 red, 2 pending, 3 the read failed.
set -euo pipefail

pr=${1:?usage: ci-state.sh <pr-number>}

# gh pr checks exits 8 while checks are pending and 1 when one failed, so its exit code says nothing
# about whether the read worked; an empty or non-JSON answer does.
json=$(gh pr checks "$pr" --repo photonle/Photon --json name,workflow,bucket,event 2>/dev/null || true)
if ! jq -e 'type == "array"' <<<"$json" >/dev/null 2>&1; then
	if gh pr view "$pr" --repo photonle/Photon --json number >/dev/null 2>&1; then
		echo pending
		exit 2
	fi
	echo "ci-state: could not read the checks of pull request $pr" >&2
	exit 3
fi

checks=$(jq -r 'map(select(.event == "pull_request")) | sort_by(.workflow, .name)
  | .[] | "\(.bucket)\t\(.workflow) / \(.name)"' <<<"$json")

if grep -qE '^(fail|cancel)'$'\t' <<<"$checks"; then
	verdict=red code=1
elif ! grep -q $'\t''GLuaTest Runner / ' <<<"$checks" || grep -qvE '^(pass|skipping)'$'\t' <<<"$checks"; then
	verdict=pending code=2
else
	verdict=green code=0
fi

echo "$verdict"
[[ -n $checks ]] && echo "$checks"
exit $code
