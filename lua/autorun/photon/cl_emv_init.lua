AddCSLuaFile()

if not CLIENT then return end

include( "cl_emv_meta.lua" )
include( "cl_emv_listener.lua" )
include( "cl_emv_net.lua" )
include( "cl_photon_builder.lua" )
include( "cl_photon_menu.lua" )
include( "cl_photon_editor.lua" )
include( "cl_emv_airel.lua" )

local IsValid = IsValid
local pairs = pairs
local string = string
local tostring = tostring
local istable = istable

local should_render = GetConVar( "photon_emerg_enabled" )

local photon_ready = photon_ready or false

hook.Add( "InitPostEntity", "Photon.ReadyEL", function()
	should_render = GetConVar( "photon_emerg_enabled" )
	photon_ready = true
end)

local function DrawEMVLights()
	if not photon_ready then return end
	if not should_render:GetBool() then return end
	for k,v in pairs( EMVU:AllVehicles() ) do
		if IsValid( v ) and v.IsEMV and v:IsEMV() and v.Photon_RenderEL then v:Photon_RenderEL() elseif v:IsEMV() then EMVU:MakeEMV(v, v:EMVName()) end
		if IsValid( v ) and v.IsEMV and v:IsEMV() and v.Photon_RenderIllum then v:Photon_RenderIllum() end
	end	
end
hook.Add("PreRender", "EMVU.Scan", DrawEMVLights)

local function PhotonManualWindScan()
	if not photon_ready then return end
	for _, emv in pairs( EMVU:AllVehicles() ) do
		if IsValid( emv ) and emv.Photon_ManualWindUpdate then emv:Photon_ManualWindUpdate() end
	end
end
-- hook.Add("PreRender", "EMVU.ScanSound", PhotonManualWindScan)
timer.Create( "Photon.ManualWindScan", .01, 0, function()
	PhotonManualWindScan()
end )

local function PhotonManualWindFocus()
	if not photon_ready or not should_render:GetBool() then return end
	for _, emv in pairs( EMVU:AllVehicles() ) do
		if IsValid( emv ) and emv.Photon_ManualWindFocus then emv:Photon_ManualWindFocus() end
	end
	for _,sndData in pairs( EMVU.ManualSirenTable ) do
		if not IsValid( sndData[2] ) then sndData[1]:Stop(); EMVU.ManualSirenTable[_] = nil end
	end
end
hook.Add( "PreRender", "Photon.ManualFocusCheck", function() PhotonManualWindFocus() end )

local function PhotonRadarScan()
	if not photon_ready or not should_render:GetBool() then return end
	for _, emv in pairs( EMVU:AllVehicles() ) do
		if IsValid( emv ) and emv.Photon_RadarActive and emv:Photon_RadarActive() then emv:Photon_RadarTick() end
	end
end
hook.Add( "Tick", "Photon.RadarScan", function() PhotonRadarScan() end)

local photon_pause = false

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
	photon_pause = !photon_pause
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


EMVU.ManualSirenTable = {}

EMVU.Configurations.GenerateName = function( data )
	local keyId = EMVU.Configurations.Supported[ data.VehicleName ]
	local userId = LocalPlayer():SteamID64()
	local name = string.lower( string.Replace( data.Name, " ", "_" ) )
	return keyId .. "_" .. userId .. "_" .. name
end

EMVU.Configurations.GetConfigText = function( name, category, author, data )
	if not istable( data ) then return false end
	data.Name = tostring( name )
	data.Category = tostring( category )
	data.Author = LocalPlayer():Name()
	return util.TableToJSON( data )
end

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

EMVU.Configurations.ConfigurationLua = function( name, category, author, data )
	if not istable( data ) then return false end
	local output = EMVU.Configurations.GetConfigText( name, category, author, data )
	local listName = EMVU.Configurations.GenerateName( data )
	return string.format( luaConfigCopyTemplate, listName, "[[" .. output .. "]]" )
end

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

Photon.AutoSkins.LoadAvailable = function()
	if not istable( Photon.AutoSkins.TranslationTable ) then return end
	for _,id in pairs( Photon.AutoSkins.TranslationTable ) do
		local skinTable = Photon.AutoSkins.ParseSkins( id )
		Photon.AutoSkins.Available[id] = skinTable
	end
end

hook.Add( "InitPostEntity", "Photon.LoadAvailableMaterials", function() timer.Simple( 3, Photon.AutoSkins.LoadAvailable ) end )

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