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
function Photon.include(path)
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

Photon.include("photon/sh_photon_init.lua")
Photon.include("photon/sh_emv_init.lua")
