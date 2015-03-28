AddCSLuaFile()

if not Photon then 
	Photon = {}

	Photon.Net = {}

	Photon.Vehicles = {}
	Photon.Vehicles.Positions = {}
	Photon.Vehicles.Meta = {}
	Photon.Vehicles.Config = {}
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
AddCSLuaFile( "library/photon_vehicles.lua" )
AddCSLuaFile( "sh_photon_vehicles.lua" )

if CLIENT then
	include( "cl_photon_eng.lua" )
	include( "cl_photon_meta.lua" )
	include( "cl_photon_hooks.lua" )
end

if SERVER then
	include( "sv_photon_meta.lua" )
	include( "sv_photon_hooks.lua" )
end

include( "library/photon_vehicles.lua" )
include( "sh_photon_vehicles.lua" )