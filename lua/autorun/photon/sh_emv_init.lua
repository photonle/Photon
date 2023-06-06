AddCSLuaFile()

Photon.include("emv/cl_meta.lua")
Photon.include("emv/sv_meta.lua")

if not EMVU then EMVU = {} end
EMVU.Liveries = {}
EMVU.SubMaterials = {}
EMVU.Index = {}
EMVU.AutoInsert = {}
EMVU.Selections = {}
EMVU.Configurations = {}
EMVU.LicensePlates = {}

EMVU_NET_SIREN_OFF = 0
EMVU_NET_SIREN_ON = 1
EMVU_NET_SIREN_FORWARD = 2
EMVU_NET_SIREN_REVERSE = 3
EMVU_NET_SIREN_SET_1 = 4
EMVU_NET_SIREN_SET_2 = 5
EMVU_NET_SIREN_SET_3 = 6
EMVU_NET_SIREN_SET_4 = 7
EMVU_NET_SIREN_HORN_ON = 8
EMVU_NET_SIREN_HORN_OFF = 9

EMVU_NET_ELS_OFF = 0
EMVU_NET_ELS_ON = 1
EMVU_NET_ELS_FORWARD = 2
EMVU_NET_ELS_REVERSE = 3

EMVU_NET_ILLUM_OFF = 0
EMVU_NET_ILLUM_ON = 1
EMVU_NET_ILLUM_FORWARD = 2
EMVU_NET_ILLUM_REVERSE = 3

AddCSLuaFile( "sh_emv_init.lua" )
AddCSLuaFile( "sh_emv_meta.lua" )
AddCSLuaFile( "sh_emv_vehicles.lua")
AddCSLuaFile( "cl_emv_init.lua" )
AddCSLuaFile( "cl_emv_meta.lua" )
AddCSLuaFile( "cl_emv_net.lua" )
AddCSLuaFile( "cl_emv_listener.lua" )
AddCSLuaFile( "cl_photon_builder.lua" )
AddCSLuaFile( "cl_photon_menu.lua" )
AddCSLuaFile( "cl_photon_editor.lua" )
AddCSLuaFile( "cl_emv_airel.lua" )
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

include( "library/emv_other.lua" )
include( "library/emv_sirens.lua" )
include( "library/emv_colors.lua" )
include( "library/emv_sounds.lua" )
include( "library/emv_auto.lua" )

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

EMVU.Configurations.Supported = {
	["2016 Ford Police Interceptor Utility"] = "fpiu16",
	["Ford Taurus 2013"] = "fpis13",
}
