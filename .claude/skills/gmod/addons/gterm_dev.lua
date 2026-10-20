-- Installed by .claude/skills/gmod/scripts/launch.ps1 as garrysmod/addons/gterm_dev/lua/autorun/gterm_dev.lua.
-- Opens the client realm to GTerm on a local listen server. A +sv_allowcslua 1 launch argument
-- does not survive to the map, so it is set once the gamemode initialises instead.
AddCSLuaFile()

if CLIENT then return end

hook.Add("Initialize", "gterm_dev", function()
	if game.IsDedicated() then return end
	RunConsoleCommand("sv_allowcslua", "1")
end)
