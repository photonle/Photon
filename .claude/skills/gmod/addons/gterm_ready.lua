-- Installed by .claude/skills/gmod/scripts/launch.ps1 as garrysmod/addons/gterm_ready/lua/autorun/gterm_ready.lua.
-- Prints one line per realm once that realm has finished loading, and writes the same line to
-- data/gterm_ready/<realm>.txt, so an agent can wait for the game by reading the console or that
-- file instead of queueing Lua through GTerm while the game is still loading.
AddCSLuaFile()

local realm = SERVER and "server" or "client"

hook.Add("InitPostEntity", "gterm_ready", function()
	local gm = GAMEMODE and GAMEMODE.FolderName or "none"
	local glibLocal = ConVarExists("glib_use_local_files") and GetConVar("glib_use_local_files"):GetString() or "n/a"
	local line = ("[gterm-ready] yippee, %s is live and ready for MCP calls: map=%s gamemode=%s gamemode_loaded=%s sv_allowcslua=%s glib_use_local_files=%s time=%d"):format(
		realm, game.GetMap(), engine.ActiveGamemode(), tostring(gm == engine.ActiveGamemode()),
		GetConVar("sv_allowcslua"):GetString(), glibLocal, os.time()
	)
	print(line)
	file.CreateDir("gterm_ready")
	file.Write("gterm_ready/" .. realm .. ".txt", line)
end)
