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
		if IsValid( emv ) and emv:Photon_RadarActive() then emv:Photon_RadarTick() end
	end
end
hook.Add( "Tick", "Photon.RadarScan", function() PhotonRadarScan() end)

local photon_pause = false

function EMVU:CalculateFrames()
	if not photon_ready then return end
	if photon_pause then return end
	if not should_render:GetBool() then return end
	for _,ent in pairs( EMVU:AllVehicles() ) do
		if IsValid( ent ) and ent.HasELS and ent:HasELS() and (ent.Photon_Lights and ent:Photon_Lights() or ent.Photon_TrafficAdvisor and ent:Photon_TrafficAdvisor() or ent.Photon_Illumination and ent:Photon_Illumination()) then ent:Photon_CalculateELFrames() end
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