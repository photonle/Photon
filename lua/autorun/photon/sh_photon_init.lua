AddCSLuaFile()

if not Photon then 
	Photon = {}

	Photon.Net = {}

	Photon.Vehicles = {}
	Photon.Vehicles.Positions = {}
	Photon.Vehicles.Meta = {}
	Photon.Vehicles.Config = {}
	Photon.Vehicles.StateMaterials = {}
	Photon.Vehicles.States = {}

	Photon.Vehicles.States.Headlights = {}
	Photon.Vehicles.States.Brakes = {}
	Photon.Vehicles.States.Blink_Left = {}
	Photon.Vehicles.States.Blink_Right = {}
	Photon.Vehicles.States.Reverse = {}
	Photon.Vehicles.States.Running = {}
end

AddCSLuaFile( "cl_photon_eng.lua" )
AddCSLuaFile( "cl_photon_meta.lua" )
AddCSLuaFile( "cl_photon_hooks.lua" )
AddCSLuaFile( "cl_photon_settings.lua" )
AddCSLuaFile( "library/photon_vehicles.lua" )
AddCSLuaFile( "sh_photon_vehicles.lua" )
AddCSLuaFile( "cl_photon_hud.lua" )
AddCSLuaFile( "cl_photon_toolmenu.lua" )
AddCSLuaFile( "cl_auto_livery.lua" )

if CLIENT then
	include( "cl_photon_eng.lua" )
	include( "cl_photon_meta.lua" )
	include( "cl_photon_hooks.lua" )
	include( "cl_photon_hud.lua" )
	include( "cl_photon_settings.lua" )
	include( "cl_photon_toolmenu.lua" )
	include( "cl_auto_livery.lua" )
end

if SERVER then
	include( "sv_photon_meta.lua" )
	include( "sv_photon_hooks.lua" )
	include( "sv_photon_settings.lua" )
end

include( "library/photon_vehicles.lua" )
include( "sh_photon_vehicles.lua" )

include( "cl_photon_context.lua" )
include( "cl_photon_menubar.lua" )


local photonVehicleTable = {}
local photonLastScan = 0

function Photon:AllVehicles()
	if CurTime() > photonLastScan + .5 then
		self:UpdateVehicles()
	end
	return photonVehicleTable
end

function Photon:UpdateVehicles()
	for k,_ in pairs( photonVehicleTable ) do
		photonVehicleTable[k] = nil
	end

	for _,ent in pairs( ents.GetAll() ) do
		if IsValid( ent ) and ent:Photon() then
			photonVehicleTable[ #photonVehicleTable + 1 ] = ent
		end
	end
	photonLastScan = CurTime()
end
