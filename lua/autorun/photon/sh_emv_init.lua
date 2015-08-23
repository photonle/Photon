AddCSLuaFile()

if not EMVU then EMVU = {} end
EMVU.Liveries = {}
EMVU.SubMaterials = {}

AddCSLuaFile( "sh_emv_init.lua" )
AddCSLuaFile( "sh_emv_meta.lua" )
AddCSLuaFile( "sh_emv_vehicles.lua")
AddCSLuaFile( "cl_emv_init.lua" )
AddCSLuaFile( "cl_emv_meta.lua" )
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
include( "library/emv_auto.lua" )
include( "library/emv_presets.lua" )

local emvVehicleTable = {}
local emvLastScan = 0

function EMVU:AllVehicles()
	if CurTime() > emvLastScan + .5 then
		self:UpdateVehicles()
	end
	return emvVehicleTable
end

function EMVU:UpdateVehicles()
	for k,_ in pairs( emvVehicleTable ) do
		emvVehicleTable[k] = nil
	end

	for _,ent in pairs( ents.GetAll() ) do
		if IsValid( ent ) and ent.IsEMV and ent:IsEMV() then
			emvVehicleTable[ #emvVehicleTable + 1 ] = ent
		end
	end
	emvLastScan = CurTime()
end