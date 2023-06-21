--[[-- Photon Init
@copyright Photon Team
@release v74 Hot Sulphur Springs
@author Photon Team
@module Photon
--]]--

local match = string.match

Photon = Photon or {}

--- Include a file with the given path, automatically setting AddCSLuaFile or include as appropriate.
-- @str path File path to include.
	if debug.getinfo(2, "S").short_src:EndsWith("autorun/emv_init.lua") and not force_full then
		path = "photon/" .. path
	end
	local prefix = match(path, "/?(%w%w)[%w_]*.lua$") or "sh"
	if PhotonDebug then
		PhotonDebug(path, " => ", prefix)
	else
		print(string.format("[Photon Bootstrapper] %s => %s", path, prefix))
	end

	if prefix ~= "sv" then
		AddCSLuaFile(path)
		if CLIENT or prefix == "sh" then
			include(path)
		end
	elseif SERVER then
		include(path)
	end
end

Photon.include("shared/sh_functional.lua")
Photon.include("shared/sh_logging.lua")
Photon.include("sh_photon_init.lua")
Photon.include("sh_emv_init.lua")
