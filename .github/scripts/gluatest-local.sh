#!/usr/bin/env bash
# Runs Photon's GLuaTest suites (lua/tests/photon/) locally in Docker, the way
# .github/workflows/gluatest.yml runs them in CI, so a case can go red or green
# before anything is pushed.
#
# Usage: .github/scripts/gluatest-local.sh
#
# CI calls CFC-Servers/GLuaTest's reusable run_tests.yml, which copies the repo
# into garrysmod/addons/project/, appends "gluatest_github_output 1" to the
# server config, and starts the ghcr.io/cfc-servers/gluatest/public image on
# sandbox / gm_construct through docker/docker-compose.yml. That image already
# holds GLuaTest and the entrypoint, so nothing is cloned here: the container is
# created from the same image with the same environment, and the project and
# config are copied in where compose would bind-mount them. The working tree is
# tested (tracked and untracked files, minus ignored ones), so uncommitted
# suites run without a commit first.
#
# The exit status is the container's: 0 when every case passed, non-zero when a
# case failed, a suite errored, or the server crashed or timed out (124). One
# deliberate difference from CI: a suite file that fails to compile runs as a
# group with no cases and GLuaTest still exits 0, so this script exits 3 for it.
#
# The output is a summary: GLuaTest's per-group and per-case lines and totals,
# then each failure as file:line: reason followed by GLuaTest's context for it
# (the case's locals and the source around the failing line), then any group
# that ran no cases. A run that never reached the totals
# (a crash, a timeout, an error before the suites ran) ends with the tail of
# the server log instead, since that is where the cause is.
#
# GLUATEST_VERBOSE=1 streams the whole server log (about 2000 lines) as well.
# GLUATEST_IMAGE   image to run (default ghcr.io/cfc-servers/gluatest/public:latest,
#                  which is what CI runs; it is pulled first unless
#                  GLUATEST_PULL=0). The resolved digest is printed, so a run can
#                  be repeated against exactly that image by passing it here.
# GLUATEST_TIMEOUT minutes before the server is killed (default 2, as in CI).
# GLUATEST_LOG     file to keep the full server log in (default: a temp file,
#                  removed afterwards).
set -euo pipefail

root="$(git rev-parse --show-toplevel)"
image="${GLUATEST_IMAGE:-ghcr.io/cfc-servers/gluatest/public:latest}"
timeout="${GLUATEST_TIMEOUT:-2}"

# Git Bash would otherwise rewrite the container-side paths below.
export MSYS_NO_PATHCONV=1

if [ "${GLUATEST_PULL:-1}" != 0 ]; then
	echo "Pulling $image"
	docker pull --quiet "$image" >/dev/null
fi
echo "Image: $(docker image inspect --format '{{index .RepoDigests 0}}' "$image" 2>/dev/null || echo "$image")"

stage="$(mktemp -d)"
name="gluatest-photon-$(od -An -N6 -tx1 /dev/urandom | tr -d ' \n')"
log="${GLUATEST_LOG:-$stage/server.log}"

cleanup() {
	docker rm --force "$name" >/dev/null 2>&1 || true
	rm -rf "$stage"
}
trap cleanup EXIT

# run_tests.yml copies the checkout with `cp project/* dest/`, which skips
# dotfiles, so .github/ and .claude/ are left out here too.
echo "Staging the working tree as addons/project"
mkdir -p "$stage/override/addons/project"
git -C "$root" ls-files -z --cached --others --exclude-standard \
	| grep -zv '^\.' \
	| tar -C "$root" --null --ignore-failed-read -T - -cf - \
	| tar -C "$stage/override/addons/project" -xf -

# The custom server config run_tests.yml builds: the project's own
# gluatest_custom.cfg, if any, plus the line that turns on GitHub annotations.
{
	if [ -f "$root/gluatest_custom.cfg" ]; then
		cat "$root/gluatest_custom.cfg"
		echo
	fi
	echo "gluatest_github_output 1"
} > "$stage/custom_server.cfg"

if [ -f "$root/gluatest_requirements.txt" ]; then
	cp "$root/gluatest_requirements.txt" "$stage/custom_requirements.txt"
else
	: > "$stage/custom_requirements.txt"
fi

src="$stage"
if command -v cygpath >/dev/null 2>&1; then
	src="$(cygpath -w "$stage")"
fi

docker create --name "$name" \
	-e GAMEMODE=sandbox \
	-e MAP=gm_construct \
	-e TIMEOUT="$timeout" \
	-e GMOD_BRANCH=public \
	-e COLLECTION_ID= \
	-e EXTRA_STARTUP_ARGS= \
	"$image" >/dev/null

docker cp "$src/override/." "$name:/home/steam/garrysmod_override"
docker cp "$src/custom_server.cfg" "$name:/home/steam/gmodserver/custom_server.cfg"
docker cp "$src/custom_requirements.txt" "$name:/home/steam/gmodserver/custom_requirements.txt"

echo "Starting the server (sandbox / gm_construct, ${timeout}m timeout)"
if [ "${GLUATEST_VERBOSE:-0}" = 1 ]; then
	docker start --attach "$name" 2>&1 | tee "$log" || true
else
	docker start --attach "$name" > "$log" 2>&1 || true
fi
status="$(docker inspect --format '{{.State.ExitCode}}' "$name" | tr -d '\r')"

plain="$stage/server.plain.log"
sed -e 's/\x1b\[[0-9;]*m//g' -e 's/\r$//' "$log" > "$plain"

echo
echo "=== GLuaTest summary ==="
grep -E '^\[GLuaTest\] ' "$plain" | grep -vE 'Test Run starting|Version:|Test run complete' || true

if grep -q '^::error' "$plain"; then
	echo
	echo "Failures:"
	grep '^::error' "$plain" | awk '!seen[$0]++' | sed -E 's/^::error file=([^,]*),line=([0-9]*)::/  \1:\2: /'
	# GLuaTest's closing "Test failures:" block, up to its last annotation.
	echo
	awk '
		/^Test failures:/ { on = 1 }
		on { buf[++n] = $0; if ($0 ~ /^::error/) last = n }
		END { for (i = 1; i <= last; i++) if (buf[i] !~ /^::error/) print buf[i] }
	' "$plain"
fi

# A suite that fails to compile still prints its group header, then no cases
# and no error, and GLuaTest exits 0 for it, in CI as well. Caught here.
empty_groups="$(grep -E '^\[GLuaTest\] (=== Running|PASS|FAIL|EMPTY|SKIP|Ran )' "$plain" | awk '
	/=== Running/ { if (open) print group; group = $0; sub(/^.*=== Running /, "", group); sub(/\.\.\. ===$/, "", group); open = 1; next }
	/\] Ran / { if (open) print group; open = 0; next }
	{ open = 0 }
')"
if [ -n "$empty_groups" ]; then
	echo
	echo "Groups that ran no cases (the file failed to load; CI would still pass):"
	printf '%s\n' "$empty_groups" | sed 's/^/  /'
	if [ "$status" = 0 ]; then
		status=3
	fi
fi

if ! grep -q '^\[GLuaTest\] Ran ' "$plain"; then
	echo
	echo "GLuaTest never reported its totals. The end of the server log:"
	tail -n 60 "$plain"
fi
echo

if [ "$status" = 0 ]; then
	echo "PASS: every case passed"
else
	echo "FAIL: the run exited $status"
fi
exit "$status"
