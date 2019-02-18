--[[-- Photon Init
@copyright Photon Team
@release v71 Denver
@author Photon Team
--]]--

if SERVER then
	AddCSLuaFile( "photon/sh_emv_init.lua" )
	AddCSLuaFile( "photon/sh_photon_init.lua" )
end

include( "photon/sh_photon_init.lua" )
include( "photon/sh_emv_init.lua" )