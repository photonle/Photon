AddCSLuaFile()
if not EMVU then EMVU = {} end

AddCSLuaFile( "sh_emv_init.lua" )
AddCSLuaFile( "sh_emv_meta.lua" )
AddCSLuaFile( "sh_emv_vehicles.lua")
AddCSLuaFile( "cl_emv_init.lua" )
AddCSLuaFile( "cl_emv_meta.lua" )
AddCSLuaFile( "cl_emv_hud.lua" )
AddCSLuaFile( "cl_emv_net.lua" )
AddCSLuaFile( "cl_frame_adjust.lua" )
AddCSLuaFile( "cl_emv_listener.lua" )
AddCSLuaFile( "cl_photon_builder.lua" )
AddCSLuaFile( "cl_photon_menu.lua" )
AddCSLuaFile( "library/emv_sirens.lua" )

include( "sh_emv_config.lua" )
include( "sh_emv_meta.lua" )
include( "sh_emv_vehicles.lua" )
include( "sh_emv_helper.lua" )

if CLIENT then
	include( "cl_emv_init.lua" )
end

if SERVER then
	include( "sv_emv_meta.lua" )
	include( "sv_emv_net.lua" )
end

include( "library/emv_sirens.lua" )
include( "library/emv_colors.lua" )
include( "library/emv_sounds.lua" )
include( "library/emv_patterns.lua" )
include( "library/emv_position_meta.lua" )
include( "library/emv_positions.lua" )
include( "library/emv_sequences.lua" )
include( "library/emv_sections.lua" )
include( "library/emv_props.lua" )
include( "library/emv_lamps.lua" )
