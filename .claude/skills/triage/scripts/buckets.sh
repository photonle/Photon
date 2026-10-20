#!/usr/bin/env bash
# Triage buckets for photonle/Photon, oldest first.
#
#   buckets.sh                  new and needs-info: the default /triage view
#   buckets.sh all              those two, plus awaiting-review, specs and blocked
#   buckets.sh <bucket>...      named buckets: new, needs-info, awaiting-review, specs, blocked,
#                               triaged
#   buckets.sh --oldest [...]   only the first issue in each bucket, for auto mode
#
# Prints a "== <bucket> (<count>)" header per bucket, then one line per issue:
#   #<number> <tab> <filed> <tab> <title> <tab> <type>/<priority>/<effort>
#
# new includes open issues with no Stage: they predate the field and were never triaged.
# needs-info lists only issues whose last comment is the reporter's, so it is their move answered.
# triaged is the work ready to pick up: unassigned Triaged issues with no open blocker, other than
# Epics, Initiatives and Wayfinders, highest Priority first, then oldest.
#
# Needs gh logged in, and jq.
set -euo pipefail

ISSUES="$(dirname "$0")/../../github-issues/issues.sh"
OLDEST=0
BUCKETS=()
for arg in "$@"; do
	case "$arg" in
		--oldest) OLDEST=1 ;;
		all) BUCKETS+=(new needs-info awaiting-review specs blocked) ;;
		new | needs-info | awaiting-review | specs | blocked | triaged) BUCKETS+=("$arg") ;;
		-h | --help) awk 'NR > 1 && /^#/ { sub(/^# ?/, ""); print; next } NR > 1 { exit }' "$0"; exit 0 ;;
		*) echo "unknown argument: $arg (try --help)" >&2; exit 2 ;;
	esac
done
[ ${#BUCKETS[@]} -eq 0 ] && BUCKETS=(new needs-info)

all=$("$ISSUES" OPEN)

select_bucket() {
	case "$1" in
		new) jq -c 'select(.stage == null or .stage == "New")' ;;
		needs-info) jq -c 'select(.stage == "Needs Information" and .lastCommenter == .author)' ;;
		awaiting-review) jq -c 'select(.stage == "Awaiting Review" and .type != "Spec")' ;;
		specs) jq -c 'select(.type == "Spec")' ;;
		blocked) jq -c 'select(.stage == "Blocked")' ;;
		triaged) jq -c 'select(.stage == "Triaged" and .assignees == [] and .blockedBy == []
			and (.type | IN("Epic", "Initiative", "Wayfinder") | not))
			| .rank = ({"Urgent": 0, "High": 1, "Medium": 2, "Low": 3}[.priority // ""] // 4)' ;;
	esac
}

for bucket in "${BUCKETS[@]}"; do
	sorted=$(select_bucket "$bucket" <<<"$all" | jq -s -c 'sort_by(.rank // 0, .created, .number) | .[]')
	count=$(grep -c . <<<"$sorted" || true)
	echo "== $bucket ($count)"
	[ "$count" -eq 0 ] && continue
	[ "$OLDEST" -eq 1 ] && sorted=$(head -n 1 <<<"$sorted")
	jq -r '([.type, .priority, .effort] | map(. // "-") | join(" · ")) as $meta
		| "#\(.number)\t\(.created)\t\(.title)\t\($meta)"' <<<"$sorted"
done
