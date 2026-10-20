# GMod reference

Reference for the [gmod skill](SKILL.md): booting Photon in a local Windows Garry's Mod on sandbox,
and driving it through GTerm.

## What the machine needs

`scripts/preflight.sh` checks all of it and names whatever is missing:

- Windows, with PowerShell 7 (`pwsh`) on `PATH`.
- Steam, installed and signed in, with Garry's Mod (app 4000).
- GTerm, with MCP on in its `Config.json`, registered with Claude Code as the `gterm` MCP server. The
  secret in that registration must match `MCPSecret`.

### Local config

What can't be discovered goes in `.claude/gmod.local.json` in the **main checkout** (gitignored;
worktrees read the main checkout's copy):

```json
{
	"gtermExe": "C:/Users/you/Tools/GTerm/gterm.exe",
	"gmodRoot": "only if Steam's library list doesn't find GMod"
}
```

Steam and GMod are found through Steam's registry key and `libraryfolders.vdf`.

## What the launcher does

`scripts/launch.ps1`, after the preflight checks:

1. **Photon junction.** Points `garrysmod\addons\photon` at `-Worktree`. It refuses a real folder
   there, so a copy you installed by hand is never deleted.
2. **CityRP's leftovers.** Takes down the `addons\cityrp2_*` junctions and `addons\cityrp2_root`
   that CityRP's launcher leaves, and moves anything in `addons_cityrp2_aside\` back, the same as
   CityRP's own launcher does for a non-CityRP boot. Its next launch puts them back.
3. **Dev addons**, from `addons/` here: `gterm_ready`, the ready probe, and `gterm_dev`, which sets
   `sv_allowcslua 1` once a listen server initialises so GTerm can reach the client realm. A
   `+sv_allowcslua 1` launch argument doesn't survive to the map. CityRP's launcher installs the
   same two files.
4. **GTerm.** Starts it if nothing listens on its port.
5. **Game.** Starts GMod through Steam (`steam.exe -applaunch 4000 -console -novid -condebug`) to the
   **main menu**, waits for the workshop to mount and stop remounting, then sends
   `maxplayers; sv_lan 1; gamemode; map` through GTerm's HTTP endpoint, resending until the console
   shows the map starting.

`-Restore` runs step 1 only, against the main checkout.

Why it works this way:

- **Steam, not `gmod.exe`.** Started directly, GMod mounts no workshop addons. A `steam://run` URL
  with launch options makes Steam ask for confirmation; `-applaunch` doesn't.
- **Menu first, then the map.** A `+map` on the command line starts the server before the workshop
  has mounted; the server load then blocks the main thread the mount needs, and the game hangs on
  "fetching subscriptions".

## Sharing the install with CityRP

CityRP's `gmod` skill boots the same Garry's Mod and keeps `addons\photon` in place as the only copy
of Photon, so it loads whichever checkout that junction points at. Leaving it on a worktree means
CityRP's next boot tests that worktree's Photon, and fails outright once the worktree is removed.
That is why the skill ends with `-Restore`.

## Reading a failed boot

`-condebug` makes `garrysmod\console.log` hold the whole session; GTerm's buffer holds recent lines
only. Search it for `[Photon`, `lua/autorun/photon`, `Couldn't include file` and `gterm-ready`.

Boot noise that isn't Photon's: missing fonts from other addons, and
`Unhandled Lua Refresh: [NAME:gterm/<uuid>.lua]` on every GTerm call.

## GTerm

- `ECONNREFUSED` means `gterm.exe` isn't running. A status stuck on "another command is in progress"
  clears after restarting it. `gterm.log` beside it lists every command injected.
- `NO_SESSION` while the game is loading is normal; wait for the ready probe.
- The HTTP endpoint takes plain JSON-RPC POSTs (`tools/call`) with no session, which is how the
  launcher starts the map.
- `read_gmod_file` reads the disk; `read_game_file` reads the running game's mounted filesystem.
- `run_gmod_command` `bot` adds a bot player, for a step that needs a second player, such as checking
  what another client sees of a vehicle's lights.

## Capturing the screen

`take_screenshot` and `take_screenshot_region` call `render.Capture` from a `PostRender` hook, which
runs before VGUI paints: their frames hold the 3D world, lights included, and nothing else. To see
the menu or HUD, run the engine's capture through `run_gmod_command` and read the file the console
line names (`Wrote 'screenshots/gm_construct0004.jpg'`):

| Command | Writes to `garrysmod\screenshots\` | UI |
| --- | --- | --- |
| `jpeg` | `<map><NNNN>.jpg`, quality 90 | VGUI panels and HUD |
| `screenshot` | `<map><NNNN>.tga` | VGUI panels and HUD |

Use `jpeg`; it works with the window minimised. Crop the frame to the area that matters before
reading it, and delete it afterwards. `render.Capture` returns nil while the escape menu is open.
