---
name: gmod
description: "Photon running in the local Garry's Mod, driven through the GTerm MCP. Use when a change needs checking in the live game, when asked to launch, boot or screenshot GMod, or before any `mcp__gterm__*` call. Stops at once where no local GMod exists: a cloud session, no Windows, PowerShell, Steam or GMod."
argument-hint: "[worktree to boot] [-Map <map>] [-Gamemode <gamemode>]"
---

# GMod

Boot a checkout's Photon in the local Garry's Mod on sandbox, wait until both realms have loaded, and
drive it through GTerm. You are done when the question you came with is answered from the game's own
state, and the game, and its `addons\photon` junction, hold nothing you added.

This only works on the Windows machine that has the setup. Everywhere else the preflight refuses, and
that refusal is the answer: stop and report it.

## 1. Preflight

```bash
sh .claude/skills/gmod/scripts/preflight.sh
```

On a non-zero exit, **stop**. Report its `gmod-preflight FATAL:` lines to the user verbatim, and say
the in-game check could not run here. Leave the environment as it is: installing software or writing
`.claude/gmod.local.json` needs the user. Any skill that called this one stops with you, and records
its game-dependent work as not run.

On success it prints `key=value` lines. Keep them: `main_checkout`, `console_log`, `ready_dir`,
`photon_addon`, `gterm_listening` and `gmod_running` are used below.

Then confirm the GTerm tools are in this session: `ToolSearch` for `select:mcp__gterm__get_game_status`.
If it finds nothing, GTerm is not registered with Claude Code here; stop and report that the same way.

## 2. Get the game

The user plays and tests in this GMod too, and CityRP's sessions share it, so one session at a time
can use it. If `CLAUDE.local.md` says how this machine shares it (a slot holder to register with, a
standing permission to relaunch), follow it. Where it says nothing, ask the user before you launch,
quit or kill `gmod.exe`.

`gmod_running=True` means someone has the game open. With the slot or the user's yes, quit it with
`run_gmod_command` `quit` (or stop `gmod.exe` if GTerm can't reach it), and wait for the process to
exit: its CEF helpers can take a minute.

## 3. Launch

Run the launcher in the background, since the workshop mount alone can take minutes:

```bash
pwsh -NoProfile -ExecutionPolicy Bypass -File "$(cygpath -w .claude/skills/gmod/scripts/launch.ps1)" -Worktree '<checkout to test>'
```

- `-Worktree`: the checkout whose Photon loads; `addons\photon` is pointed at it. Defaults to
  `main_checkout`.
- `-Map` (default `gm_construct`) and `-Gamemode` (default `sandbox`): only installed ones work.
- `-MaxPlayers` (default 2) and `-TickRate` (default: the game's own; it cannot change once the game
  runs) shape the listen server.

The launcher re-runs the preflight and throws on the same failures, and when GMod is running. It ends
by printing `Started: ...`; a throw before that is a failed launch, so report its message.

## 4. Wait for the ready probe

Each realm writes `<ready_dir>\server.txt` and `client.txt` once it has loaded. Wait with `Monitor`,
using an until-loop on both files, for up to 15 minutes: Windows shows the game as Not Responding
while it loads. A quiet console proves nothing.

Ready means both files exist. Then check Photon itself loaded: `type(Photon) == "table"` in both
realms. If it isn't, read `console_log` for the first Photon error and report it; nothing that needs
Photon can be checked in that boot.

## 5. Drive it

Through the `mcp__gterm__*` tools. Read the `[GTerm]` status line heading every result.

- `execute_lua_code` needs `realm`: `server` for vehicles, `Photon:SetupCar`, SimpleNet values and
  anything the server holds; `client` for rendering, the menu, the HUD and what the client received.
  Prefer the server realm for setup.
- Most Photon checks need a vehicle: spawn one in the server realm from the vehicle list (`list.Get("Vehicles")`)
  and let it network to the client before reading the client side.
- Prove a claim with values read from the game: `IsValid`, positions, SimpleNet getters on both
  realms, the render queue's size. A networking claim holds only when the client's value matches
  the server's after a change.
- Pixels are a last resort, for a claim that is purely visual, such as a light pattern's look. GTerm's
  screenshot tools show the 3D world but never UI; the engine's `jpeg` command shows both
  ([REFERENCE.md](REFERENCE.md#capturing-the-screen)).
- `capture_console_output` reads recent output, newest first; `console_log` holds the whole session.

## 6. Leave it as found

Remove every hook, timer, wrapper and entity you added. Then hand the game back the way
`CLAUDE.local.md` describes, or quit it. Once GMod has exited, point `addons\photon` back at the main
checkout, since CityRP's launcher loads whatever it points at:

```bash
pwsh -NoProfile -ExecutionPolicy Bypass -File "$(cygpath -w .claude/skills/gmod/scripts/launch.ps1)" -Restore
```

After that, any further GMod action needs the slot again.

## Reference

[REFERENCE.md](REFERENCE.md): what the launcher does and why, the local config, sharing the install
with CityRP, capturing the screen, and reading a failed boot.
