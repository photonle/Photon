AddCSLuaFile()

if not Photon.Net then
	Photon.Net = {}

	Photon.Vehicles = {}
	Photon.Vehicles.Positions = {}
	Photon.Vehicles.Meta = {}
	Photon.Vehicles.WheelPositions = {}
	Photon.Vehicles.WheelOptions = {}
	Photon.Vehicles.Config = {}
	Photon.Vehicles.StateMaterials = {}
	Photon.Vehicles.States = {}

	Photon.Vehicles.States.Headlights = {}
	Photon.Vehicles.States.Brakes = {}
	Photon.Vehicles.States.Blink_Left = {}
	Photon.Vehicles.States.Blink_Right = {}
	Photon.Vehicles.States.Reverse = {}
	Photon.Vehicles.States.Running = {}
	Photon.AutoSkins = {}
	Photon.LicensePlates = {}

	Photon.AutoSkins.TranslationTable = {
		["models/schmal/fpiu/ford_utility.mdl"] = "fpiu16"
	}

	Photon.AutoSkins.Available = {}

	Photon.AutoSkins.IsSkinAvailable = function( id, skin )
		if not istable( Photon.AutoSkins.Available[ id ] ) then return false end
		local skinTable = Photon.AutoSkins.Available[ id ]
		for key,subSkinTable in pairs( skinTable ) do
			if istable( subSkinTable ) then
				for _,skinInfo in pairs( subSkinTable ) do
					if skinInfo.Texture == skin then return true end
				end
			end
		end
		return false
	end
end

AddCSLuaFile("cl_photon_eng.lua")
AddCSLuaFile("cl_photon_meta.lua")
AddCSLuaFile("cl_photon_hooks.lua")
AddCSLuaFile("cl_photon_settings.lua")
AddCSLuaFile("library/photon_vehicles.lua")
AddCSLuaFile("sh_photon_vehicles.lua")
AddCSLuaFile("cl_photon_hud.lua")
AddCSLuaFile("cl_photon_editor.lua")
AddCSLuaFile("cl_photon_toolmenu.lua")
AddCSLuaFile("cl_emv_livery.lua")
AddCSLuaFile("cl_photon_vgui.lua")

if CLIENT then
	include("cl_photon_eng.lua")
	include("cl_photon_meta.lua")
	include("cl_photon_hooks.lua")
	include("cl_photon_hud.lua")
	include("cl_photon_settings.lua")
	include("cl_photon_editor.lua")
	include("cl_photon_toolmenu.lua")
	include("cl_emv_livery.lua")
	include("cl_photon_vgui.lua")
end

if SERVER then
	include("sv_photon_meta.lua")
	include("sv_photon_hooks.lua")
	include("sv_photon_settings.lua")
end

include("library/photon_vehicles.lua")
include("sh_photon_vehicles.lua")
include("cl_photon_context.lua")
include("cl_photon_menubar.lua")
include("sh_photon_xml.lua")

Photon.include("shared/sh_simplenet.lua")
Photon.include("photon/cl_meta.lua")
Photon.include("photon/sh_meta.lua")

local photonVehicleTable = {}
local photonLastScan = 0

--- Get the list of all photon enabled vehicles.
-- Updates every .5 seconds.
function Photon:AllVehicles()
	if CurTime() > photonLastScan + .5 then
		self:UpdateVehicles()
	end

	return photonVehicleTable
end

--- Update the stored vehicle table.
function Photon:UpdateVehicles()
	local i = 1
	for _, ent in ipairs(ents.GetAll()) do
		if IsValid(ent) and ent:Photon() then
			photonVehicleTable[i] = ent
			i = i + 1
		end
	end

	local m = #photonVehicleTable
	if i < m then
		for next = i, m do
			photonVehicleTable[next] = nil
		end
	end

	photonLastScan = CurTime()
end
