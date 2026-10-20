#!/bin/sh
# Entry point for the gmod skill's environment check. Plain sh, so it runs, and refuses, anywhere:
# a cloud session, Linux, macOS, or Windows without PowerShell 7. On Windows it hands the rest of the
# check to preflight.ps1.

fail() {
	printf 'gmod-preflight FATAL: %s\n' "$*"
	exit 1
}

if [ "${CLAUDE_CODE_REMOTE:-}" = "true" ] || [ "${CURSOR_CLOUD_AGENT:-}" = "true" ]; then
	fail "this is a cloud session; there is no Garry's Mod here."
fi

case "$(uname -s 2>/dev/null)" in
	MINGW* | MSYS* | CYGWIN*) ;;
	*) fail "$(uname -s 2>/dev/null || echo 'this OS') is not Windows; the local GMod setup is Windows-only." ;;
esac

command -v pwsh >/dev/null 2>&1 || fail "pwsh (PowerShell 7) is not on PATH; the launcher needs it. Install it with: winget install Microsoft.PowerShell"

dir=$(cd "$(dirname "$0")" && pwd)
exec pwsh -NoProfile -NonInteractive -ExecutionPolicy Bypass -File "$(cygpath -w "$dir/preflight.ps1")" "$@"
