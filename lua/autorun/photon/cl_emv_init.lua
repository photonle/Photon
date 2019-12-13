--[[-- Photon EMV Client Loader.
@copyright Photon Team
@release v74 Hot Sulphur Springs
@author Photon Team
@module EMVU
--]]--
AddCSLuaFile()

if not CLIENT then return end

include("cl_emv_meta.lua")
include("cl_emv_listener.lua")
include("cl_emv_net.lua")
include("cl_photon_builder.lua")
include("cl_photon_menu.lua")
include("cl_photon_editor.lua")
include("cl_emv_airel.lua")

local IsValid = IsValid
local pairs = pairs
local string = string
local tostring = tostring
local istable = istable
local EMVU = EMVU

local should_render = GetConVar("photon_emerg_enabled")
local should_render_reg = GetConVar("photon_stand_enabled")
local photon_ready = photon_ready or false

hook.Add("InitPostEntity", "Photon.ReadyEL", function()
	should_render = GetConVar("photon_emerg_enabled")
	should_render_reg = GetConVar("photon_stand_enabled")
	photon_ready = true
end)

--- Render function to draw Emergency and Illumination lighting.
local function DrawEMVLights()
	if not photon_ready then return end
	if not should_render:GetBool() then return end

	for k, v in pairs(EMVU:AllVehicles()) do
		if IsValid(v) and v.IsEMV and v:IsEMV() then
			if v.Photon_RenderEL then
				v:Photon_RenderEL()
			else
				EMVU:MakeEMV(v, v:EMVName())
			end
			if v.Photon_RenderIllum then
				v:Photon_RenderIllum()
			end
		end
	end
end

--- Render function for vehicle running lights.
local function DrawCarLights()
	if not photon_ready then return end

	Photon:ClearLightQueue()
	local photonDebug = PHOTON_DEBUG

	for _, ent in pairs(Photon:AllVehicles() ) do
		if IsValid(ent) and ent:Photon() then
			if not ent.Photon_RenderLights then
				Photon:SetupCar(ent, ent:EMVName())
			else
				if should_render_reg:GetBool() then
					ent:Photon_RenderLights(
						ent:Photon_HeadlightsOn(),
						ent:Photon_IsRunning(),
						ent:Photon_IsReversing(),
						ent:Photon_IsBraking(),
						ent:Photon_TurningLeft(),
						ent:Photon_TurningRight(),
						ent:Photon_Hazards(),
						photonDebug
					)
				end
				if ent:IsEMV() and ent.Photon_ScanEMVProps then
					ent:Photon_ScanEMVProps()
				end
				if ent:Photon_WheelEnabled() and ent.Photon_ScanWheels then
					ent:Photon_ScanWheels()
				end
			end
		end
	end
end

hook.Add( "PreRender", "Photon.RenderScan", function()
	DrawCarLights()
	DrawEMVLights()
end)

hook.Add("PostDrawTranslucentRenderables", "Photon.DebugRender", function()
	if not PHOTON_DEBUG then return end

	for _, ent in ipairs(Photon:AllVehicles()) do
		if IsValid(ent) and ent.VehicleName and EMVU.Sequences[ent.VehicleName] and EMVU.Sequences[ent.VehicleName].Illumination and ent.Photon_Illumination and ent:Photon_Illumination() then
			local options = EMVU.Sequences[ent.VehicleName].Illumination
			for _, lamps in ipairs(options) do
				if #lamps.Lights ~= 0 then
					for _, lamp in ipairs(lamps.Lights) do
						local meta = EMVU.Helper:GetLampMeta(ent.VehicleName, lamp[3])
						local start = ent:LocalToWorld(lamp[1])
						local endpos = ent:LocalToWorld(lamp[1] + (lamp[2]:Forward() * meta.Distance))
						local res = util.TraceLine({
							start = start,
							endpos = endpos,
							filter = {ent}
						})
						render.DrawWireframeSphere(start, 1, 5, 5, meta.Color)
						if res.HitPos == endpos then
							render.DrawLine(start, endpos, meta.Color)
						else
							render.DrawLine(start, res.HitPos, meta.Color)
							render.DrawLine(res.HitPos, endpos, Color(200, 0, 0, 100))
						end
					end
				end
			end
		end
	end
end)

--- Manual siren windup/winddown.
local function PhotonManualWindScan()
	if not photon_ready then return end
	for _, emv in pairs( EMVU:AllVehicles() ) do
		if IsValid( emv ) and emv.Photon_ManualWindUpdate then emv:Photon_ManualWindUpdate() end
	end
end
-- hook.Add("PreRender", "EMVU.ScanSound", PhotonManualWindScan)
-- timer.Create( "Photon.ManualWindScan", .01, 0, function()
-- 	PhotonManualWindScan()
-- end )

--- Manual siren windup/down.
local function PhotonManualWindFocus()
	if not photon_ready or not should_render:GetBool() then return end
	for _, emv in pairs( EMVU:AllVehicles() ) do
		if IsValid( emv ) and emv.Photon_ManualWindFocus then emv:Photon_ManualWindFocus() end
	end
	for _,sndData in pairs( EMVU.ManualSirenTable ) do
		if not IsValid( sndData[2] ) then sndData[1]:Stop(); EMVU.ManualSirenTable[_] = nil end
	end
end
-- hook.Add( "PreRender", "Photon.ManualFocusCheck", function() PhotonManualWindFocus() end )

--- Render function to tick the radar.
local function PhotonRadarScan()
	if not photon_ready or not should_render:GetBool() then return end
	for _, emv in pairs( EMVU:AllVehicles() ) do
		if IsValid( emv ) and emv.Photon_RadarActive and emv:Photon_RadarActive() then emv:Photon_RadarTick() end
	end
end
hook.Add( "Tick", "Photon.RadarScan", function() PhotonRadarScan() end)

local photon_pause = false

--- Timer to update frame calculations.
function EMVU:CalculateFrames()
	if not photon_ready then return end
	if photon_pause then return end
	if not should_render:GetBool() then return end
	for _,ent in pairs( EMVU:AllVehicles() ) do
		if IsValid( ent ) and ent.HasPhotonELS and ent:HasPhotonELS() and (ent.Photon_Lights and ent:Photon_Lights() or ent.Photon_TrafficAdvisor and ent:Photon_TrafficAdvisor() or ent.Photon_Illumination and ent:Photon_Illumination()) then ent:Photon_CalculateELFrames() end
	end
end
timer.Create("EMVU.CalculateFrames", .03, 0, function()
	EMVU:CalculateFrames()
end)

concommand.Add( "photon_pause", function()
	photon_pause = not photon_pause
end)

-- concommand.Add( "photon_selectiondata", function( ply )
-- 	local veh = ply:GetVehicle()
-- 	if not IsValid( veh ) then return end
-- 	-- print("BEFORE:::::::::::::::::::::::")
-- 	-- PrintTable( veh:Photon_SelectionTable() )
-- 	-- print( "AFTER:::::::::::::::::::::::")
-- 	-- PrintTable( veh:Photon_ImportSelectionData( veh:Photon_GetSelectionJSON() ) )
-- 	//veh:Photon_ImportSelectionData( CHP_CONFIGDATA )
-- 	EMVU.Configurations.SaveConfiguration( "NYPD", "Default", "Schmal", veh:Photon_ExportConfiguration( true, true, true, true, true ) )
-- end )

-- CHP_CONFIGDATA = [[
-- {"Pushbars":"Setina Pushbar=CHP - Red","Front Upper Deck":"None","Lightbar":"Whelen Liberty II=CHP","Rear Upper Deck":"None","Grille":"None","Reverse Light Hideaways":"None","Rear Lower Deck":"None","Turn Signal Hideaways":"None","Bumper Layout":"Fog Lights=CHP - White","Spotlight":"Full","Forward Hideaways":"None","Roof":"AirEL=All","Forward ALPR":"None","Headlight Wig-Wag":"On","Mid-Level Side":"None","Mirror Lights":"Whelen Ion=CHP - Red","Interior Equipment":"Full"}
-- ]]

--- List of manual sirens.
EMVU.ManualSirenTable = {}

--- Generate a configuration name for a vehicle.
-- @tab data Configuration data to generate a name for.
-- @treturn string Name of the generated configuration.
EMVU.Configurations.GenerateName = function( data )
	local keyId = EMVU.Configurations.Supported[ data.VehicleName ]
	local userId = LocalPlayer():SteamID64()
	local name = string.lower( string.Replace( data.Name, " ", "_" ) )
	return keyId .. "_" .. userId .. "_" .. name
end

--- Serialize a configuration.
-- @string name The name of the config.
-- @string category The configuration category.
-- @string author Unused.
-- @tab data Configuration data.
-- @treturn string Serialized data.
EMVU.Configurations.GetConfigText = function( name, category, author, data )
	if not istable( data ) then return false end
	data.Name = tostring( name )
	data.Category = tostring( category )
	data.Author = LocalPlayer():Name()
	return util.TableToJSON( data )
end

--- Save a configuration.
-- @string name The name of the config.
-- @string category The configuration category.
-- @string author Unused.
-- @tab data Configuration data.
-- @treturn boolean If the configuration saved.
EMVU.Configurations.SaveConfiguration = function( name, category, author, data )
	if not istable( data ) then return false end
	local output = EMVU.Configurations.GetConfigText( name, category, author, data )
	local fileName = EMVU.Configurations.GenerateName( data )
	if not file.Exists( "photon", "DATA" ) then file.CreateDir( "photon" ) end
	if not file.Exists( "photon/equip_configs", "DATA" ) then file.CreateDir( "photon/equip_configs" ) end
	file.Write( "photon/equip_configs/" .. fileName .. ".txt", output )
	EMVU.Configurations.ResetConfigurations()
	return true
end

local luaConfigCopyTemplate = [[
AddCSLuaFile()
list.Set( "PhotonConfigurationLibrary", "%s", %s )
]]

--- Generate lua code for a given configuration.
-- @string name The name of the config.
-- @string category The configuration category.
-- @string author Unused.
-- @tab data Configuration data.
-- @treturn string The generated lua string.
EMVU.Configurations.ConfigurationLua = function( name, category, author, data )
	if not istable( data ) then return false end
	local output = EMVU.Configurations.GetConfigText( name, category, author, data )
	local listName = EMVU.Configurations.GenerateName( data )
	return string.format( luaConfigCopyTemplate, listName, "[[" .. output .. "]]" )
end

--- Fetch autoskins for a given vehicle.
-- @string id Auto Skin ID of the vehicle.
-- @treturn table Found skins.
-- @treturn string Base material directory.
Photon.AutoSkins.FetchSkins = function( id )
	local result = {}
	local baseDir = "materials/" .. tostring(id) .. "_liveries/"
	local files = file.Find( baseDir .. "*.vmt", "GAME" )
	result["/"] = {}
	for _,foundFile in pairs( files ) do
		result["/"][ #result["/"] + 1 ] = foundFile
	end
	local _,dirs = file.Find( baseDir .. "*", "GAME" )
	for _,foundDir in pairs( dirs ) do
		if not result[foundDir] then result[foundDir] = {} end
		local subFiles = file.Find( baseDir .. foundDir .. "/*.vmt", "GAME" )
		for __,foundFile in pairs( subFiles ) do
			result[foundDir][ #result[foundDir] + 1 ] = foundFile
		end
	end
	return result, baseDir
end

--- Parse the skins of an id.
-- Generates names and texture paths.
-- @string id Vehicle ID.
-- @treturn table Parsed results.
Photon.AutoSkins.ParseSkins = function( id )
	local fileTable, baseDir = Photon.AutoSkins.FetchSkins( id )
	local result = {}
	for key,subFiles in pairs( fileTable ) do
		if key == "/" then
			result["/"] = {}
			local newKey = key
			for _,mat in pairs( subFiles ) do
				result[ newKey ][ #result[ newKey ] + 1 ] = {}
				local matInfo = result[ newKey ][ #result[ newKey ] ]
				matInfo.Name = string.Replace( string.Replace( mat, "_", " " ), ".vmt", "" )
				matInfo.Texture = string.format( "%s%s/%s", string.Replace( baseDir, "materials/", "" ), key, string.StripExtension( mat ) )
			end
		else
			local newKey = string.Replace( key, "_", " ")
			result[ newKey ] = {}
			for _,mat in pairs( subFiles ) do
				result[ newKey ][ #result[ newKey ] + 1 ] = {}
				local matInfo = result[ newKey ][ #result[ newKey ] ]
				matInfo.Name = string.Replace( string.Replace( mat, "_", " " ), ".vmt", "" )
				matInfo.Texture = string.format( "%s%s/%s", string.Replace( baseDir, "materials/", "" ), key, string.StripExtension( mat ) )
			end
		end
	end
	return result
end

--- Load all available autoskins into the cache.
Photon.AutoSkins.LoadAvailable = function()
	if not istable( Photon.AutoSkins.TranslationTable ) then return end
	for _,id in pairs( Photon.AutoSkins.TranslationTable ) do
		local skinTable = Photon.AutoSkins.ParseSkins( id )
		Photon.AutoSkins.Available[id] = skinTable
	end
end

hook.Add( "InitPostEntity", "Photon.LoadAvailableMaterials", function() timer.Simple( 3, Photon.AutoSkins.LoadAvailable ) end )

--- Available license plate materials.
Photon.LicensePlates.Available = {}

--- Fetch the license plate materials.
Photon.LicensePlates.FetchMaterials = function()
	local result = {}
	local baseDir = "materials/photon_plates/"
	local files = file.Find( baseDir .. "*.vmt", "GAME" )
	result["/"] = {}
	for _,foundFile in pairs( files ) do
		result["/"][ #result["/"] + 1 ] = foundFile
	end
	local _,dirs = file.Find( baseDir .. "*", "GAME" )
	for _,foundDir in pairs( dirs ) do
		if not result[foundDir] then result[foundDir] = {} end
		local subFiles = file.Find( baseDir .. foundDir .. "/*.vmt", "GAME" )
		for __,foundFile in pairs( subFiles ) do
			result[foundDir][ #result[foundDir] + 1 ] = foundFile
		end
	end
	return result, baseDir
end

--- Parse materials into key/pairs.
Photon.LicensePlates.ParseMaterials = function()
	local fileTable, baseDir = Photon.LicensePlates.FetchMaterials()
	local result = {}
	for key,subFiles in pairs( fileTable ) do
		if key == "/" then
			result["/"] = {}
			local newKey = key
			for _,mat in pairs( subFiles ) do
				result[ newKey ][ #result[ newKey ] + 1 ] = {}
				local matInfo = result[ newKey ][ #result[ newKey ] ]
				matInfo.Name = string.Replace( string.Replace( mat, "_", " " ), ".vmt", "" )
				matInfo.Texture = string.format( "%s%s/%s", string.Replace( baseDir, "materials/", "" ), key, string.StripExtension( mat ) )
			end
		else
			local newKey = string.Replace( key, "_", " ")
			result[ newKey ] = {}
			for _,mat in pairs( subFiles ) do
				result[ newKey ][ #result[ newKey ] + 1 ] = {}
				local matInfo = result[ newKey ][ #result[ newKey ] ]
				matInfo.Name = string.Replace( string.Replace( mat, "_", " " ), ".vmt", "" )
				matInfo.Texture = string.format( "%s%s/%s", string.Replace( baseDir, "materials/", "" ), key, string.StripExtension( mat ) )
			end
		end
	end
	return result
end

--- Load all license plates.
Photon.LicensePlates.LoadAvailable = function()
	Photon.LicensePlates.Available = Photon.LicensePlates.ParseMaterials()
end

hook.Add( "InitPostEntity", "Photon.LoadAvailablePlateMaterials", function() timer.Simple( 3, Photon.LicensePlates.LoadAvailable ) end )

function PrintPhotonDebugInformation()
	if CLIENT then
		local emergEnabled = GetConVar( "photon_emerg_enabled" )
		local standEnabled = GetConVar( "photon_stand_enabled" )
		local expEdit = GetConVar("photon_express_edit")
		local car = LocalPlayer():GetVehicle()
		print( [[---------- PHOTON LIGHTING ENGINE DEBUG INFORMATION (CLIENT) ----------]] )
		print( [[VERSION: ]] .. tostring( PHOTON_UPDATE ) )
		print( [[EMERGENCY LIGHTS ENABLED: ]] .. tostring( emergEnabled:GetBool() ) )
		print( [[STANDARD LIGHTS ENABLED: ]] .. tostring( standEnabled:GetBool() ) )
		print( [[EXPRESS EDIT ENGAGED: ]] .. tostring( expEdit:GetBool() ) )
		print( [[PHOTON LOADED VEHICLES-------------------------------------------------]])
		local total = 0
		for carName,_ in pairs( EMVU.Positions ) do
			print( tostring( carName ) )
			total = total + 1 --# was not working??????
		end
		print( [[END ALL LOADED VEHICLES, TOTAL: ]] .. tostring( total ) .. "-------------------------" )
		if IsValid( car ) then
			if car.EMVName then
				print( [[CURRENT VEHICLE: ]] .. tostring( car:EMVName() ) )
			else
				print( [[CURRENT VEHICLE NAME NOT VALID, METATABLE FAILURE (E1)]]) -- E1
			end
			if car.Photon then
				print( [[CURRENT VEHICLE HAS PHOTON: ]] .. tostring( car:Photon() ) )
			else
				print( [[CURRENT VEHICLE PHOTON STATUS NOT VALID, METATABLE FAILURE (E4)]]) -- E4
			end
			if car.HasPhotonELS then
				print( [[CURRENT VEHICLE HAS ELS: ]] .. tostring( car:HasPhotonELS() ) )
			else
				print( [[CURRENT VEHICLE ELS STATUS NOT VALID, METATABLE FAILURE (E2)]]) -- E2
			end
			if car.IsEMV then
				print( [[CURRENT VEHICLE IS EMV: ]] .. tostring( car:IsEMV() ) )
				if car:IsEMV() then
					print( [[CURRENT VEHICLE SELECTION_ENABLED: ]] .. tostring( car:Photon_SelectionEnabled() ) )
					print( [[CURRENT VEHICLE SUPPPORTS CONFIGS: ]] .. tostring( car:Photon_SupportsConfigurations() ) )
					print( [[CURRENT VEHICLE SIREN MODEL: ]] .. tostring( car:Photon_SirenSet() ) )
					print( [[CURRENT VEHICLE SIREN ON: ]] .. tostring( car:Photon_Siren() ) )
					print( [[CURRENT VEHICLE WARNING LIGHTS: ]] .. tostring( car:Photon_Lights() ) )
					print( [[CURRENT VEHICLE LIGHT STAGE: ]] .. tostring( car:Photon_LightOption() ) )
					print( [[CURRENT VEHICLE FINISHED INIT: ]] .. tostring( car.PhotonFinishedInit ) )
					print( [[CURRENT VEHICLE POSITIONS: ]] .. tostring( #EMVU.Positions[car:EMVName()] ))
				end
			else
				print( [[CURRENT VEHICLE EMV STATUS NOT VALID, METATABLE FAILURE (E3)]]) -- E3
			end
		else
			print( [[PLAYER NOT IN VEHICLE OR VEHICLE IS INVALID]] )
		end
		print( [[---------- PHOTON END DEBUG READOUT ----------------------------------]] )
	end
end

concommand.Add( "photon_debugprint", function()
	PrintPhotonDebugInformation()
end)

-- timer.Create("photon_spinnnnnn", .01, 0, function()
-- 	-- if true then return end
-- 	Photon.BoneRotation()
-- end )
local _rotationEntCache = {}
local _lastRotationCache = 0
local function getPhotonRotationEnts()
	if not _rotationEntCache or CurTime() > (_lastRotationCache + 2) then
		table.Empty(_rotationEntCache)
		for _,ent in pairs(ents.GetAll()) do
			if IsValid(ent) and ent.PhotonRotationEnabled then
				table.insert(_rotationEntCache, ent)
			end
		end
		_lastRotationCache = CurTime()
	end
	return _rotationEntCache
end

--- Run bone rotation.
Photon.BoneRotation = function()
	if photon_pause then return end
	-- if true then return end
	for _,ent in pairs( getPhotonRotationEnts() ) do
		if not IsValid(ent) then return end
		if ent.PhotonRotationEnabled then
			local emv = ent:GetParent()
			if not IsValid( emv ) or not emv.Photon_LightOptionID then continue end
			if true then
				local stageId = emv:Photon_LightOptionID()
				local auxState = emv:Photon_AuxOptionID()
				local illumStage = emv:Photon_IllumOptionID()
				local componentBoneData = ent.PhotonBoneAnimationData
				for boneIndex, boneData in pairs( componentBoneData ) do
					local currentAnimation
					if boneData.Default then
						currentAnimation = boneData.Default
					end
					if emv:Photon_Lights() and boneData.Primary and boneData.Primary[ stageId ] then
						currentAnimation = boneData.Primary[ stageId ]
					end
					if emv:Photon_AuxLights() and boneData.Auxiliary and boneData.Auxiliary[ auxState ] then
						currentAnimation = boneData.Auxiliary[ auxState ]
					end
					if emv:Photon_Illumination() and boneData.Illumination and boneData.Illumination[ illumStage ] then
						currentAnimation = boneData.Illumination[ illumStage ]
					end

					if not currentAnimation then continue end
					local animAction = currentAnimation[1] or "RP"
					local animAngle = currentAnimation[2] or 0
					local animSpeed = currentAnimation[3] or 25
					local currentAngles = ent:GetManipulateBoneAngles( boneIndex )
					local currentAngle = currentAngles[3]
					local difAng = ( FrameTime() * animSpeed ) * 10
					local addAng = (currentAngles.r + difAng) % 360
					local subAng = (currentAngles.r - difAng) % 360
					if animAction == "S" then
						if animAngle < 0 then animAngle = 360 + animAngle end
						local lt = animAngle > currentAngle
						local eq = animAngle == currentAngle
						if not eq then
							if lt then
								if difAng + currentAngle > animAngle then addAng = animAngle end
								ent:ManipulateBoneAngles( boneIndex, Angle( currentAngles.p, currentAngles.y, addAng ) )
							else
								if currentAngle - difAng < animAngle then subAng = animAngle end
								ent:ManipulateBoneAngles( boneIndex, Angle( currentAngles.p, currentAngles.y, subAng ) )
							end
						end
					elseif (animAction == "A" or animAction == "AN") and istable( animAngle ) then
						if not ent.PhotonBonesAlt then ent.PhotonBonesAlt = {} end
						if not ent.PhotonBonesAlt[ boneIndex ] then ent.PhotonBonesAlt[ boneIndex ] = 1 end
						local currentDir = ent.PhotonBonesAlt[ boneIndex ] or 1
						local gotoAngle = animAngle[ currentDir ]
						local ang1 = animAngle[1]
						local ang2 = animAngle[2]
						local eq = gotoAngle == currentAngle
						if not eq then
							if animAction == "A" then
								if currentDir == 2 then -- even
									if subAng > ang1 and subAng < ang2 then subAng = gotoAngle end
									ent:ManipulateBoneAngles( boneIndex, Angle( currentAngles.p, currentAngles.y, subAng ) )
								else -- odd
									if addAng > ang1 and addAng < ang2 then addAng = gotoAngle end
									ent:ManipulateBoneAngles( boneIndex, Angle( currentAngles.p, currentAngles.y, addAng ) )
								end
							else
								if currentDir == 2 then -- even
									if subAng < ang1 and subAng > ang2 then subAng = gotoAngle end
									ent:ManipulateBoneAngles( boneIndex, Angle( currentAngles.p, currentAngles.y, subAng ) )
								else -- odd
									if addAng < ang1 and addAng > ang2 then addAng = gotoAngle end
									ent:ManipulateBoneAngles( boneIndex, Angle( currentAngles.p, currentAngles.y, addAng ) )
								end
							end

						else
							local max = #animAngle
							if max > currentDir then ent.PhotonBonesAlt[ boneIndex ] = currentDir + 1
							else  ent.PhotonBonesAlt[ boneIndex ] = 1 end
						end
					elseif animAction == "RP" or animAction == "R" then
						ent:ManipulateBoneAngles( boneIndex, Angle( currentAngles.p, currentAngles.y, addAng ) )
					elseif animAction == "RN" then
						ent:ManipulateBoneAngles( boneIndex, Angle( currentAngles.p, currentAngles.y, subAng ) )
					end
				end
			end
		end
	end
end

hook.Add( "PreRender", "Photon.RotationAnimation", function()
	Photon.BoneRotation()
end )