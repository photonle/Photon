--[[-- AirEl Client Handler.
@copyright Photon Team
@release v71 Denver
@author Photon Team
@module Photon.AirEL
--]]--
AddCSLuaFile()

--- Global table defined to hold stuff.
Photon.AirEL = {}

--- Translation between models and remote materials.
Photon.AirEL.TranslationTable = {
	["models/schmal/fpiu_airel.mdl"] = "fpius",
	["models/schmal/tahoe_airel.mdl"] = "fpius",
	["models/schmal/lwdodch_airel.mdl"] = "fpius",
}

--- Translation between models and material indexes.
Photon.AirEL.TranslationTableIndex = {
	["models/schmal/fpiu_airel.mdl"] = 1,
	["models/schmal/lwdodch_airel.mdl"] = 0,
	["models/schmal/tahoe_airel.mdl"] = 0
}

Photon.AirEL.MaterialIndex = {}

Photon.AirEL.DownloadMaterial = function( id, unitString, ent, cback, failed )
	if not file.Exists( "photon", "DATA" ) then file.CreateDir( "photon" ) end
	if not file.Exists( "photon/airel", "DATA" ) then file.CreateDir( "photon/airel" ) end
	ent.PhotonMaterialDownloadInProgress = true
	local fetchUrl = string.format( "https://photon.lighting/generator/airel.php?num=%s&id=%s", tostring( unitString ), tostring( id ) )
	http.Fetch( fetchUrl,
		function( body, len, headers, code )
			file.Write( "photon/airel/" .. Photon.AirEL.FormatName( id, unitString ), body )
			if isfunction( cback ) then
				cback( id, unitString, ent )
			end
			print("AIREL SUCCESS")
		end,
		function( error )
			if isfunction( failed ) then
				failed( id, unitString, ent )
				print("AIREL FAILURE")
			end
		end
	);
end

Photon.AirEL.FormatName = function( id, unitString )
	return string.format( "photon_airel_%s_%s.png", tostring( id ), tostring( unitString ) )
end

Photon.AirEL.LoadMaterial = function( id, unitString, ent )
	local checkFile = "photon/airel/" .. Photon.AirEL.FormatName( id, unitString )
	-- Photon.AirEL.DownloadMaterial( id, unitString, ent, Photon.AirEL.LoadCallbackSuccess, Photon.AirEL.LoadCallbackFail )
	if file.Exists( checkFile, "DATA" ) then
		Photon.AirEL.ApplyTexture( Photon.AirEL.LoadMaterialFromFile( id, unitString ), ent, id, unitString )
	else
		Photon.AirEL.DownloadMaterial( id, unitString, ent, Photon.AirEL.LoadCallbackSuccess, Photon.AirEL.LoadCallbackFail )
	end
end

Photon.AirEL.LoadCallbackSuccess = function( id, unitString, ent )
	ent.PhotonMaterialDownloadInProgress = false
	Photon.AirEL.ApplyTexture( Photon.AirEL.LoadMaterialFromFile( id, unitString ), ent, id, unitString )
end

Photon.AirEL.LoadCallbackFail = function( error )
	print( "[Photon] An error occurred: " .. tostring( error ) )
end

Photon.AirEL.ApplyTexture = function( mat, ent, id, unitString )
	if not IsValid( ent ) then return end

	local matParams = {
		["$basetexture"] = mat:GetString( "$basetexture" ) .. ".png",
		["$model"] = 1,
		["$nocull"] = 1,
		["$additive"] = 1,
		["$colorfix"] = "{185 255 255}",
		["Proxies"] = {
			["Equals"] = {
				["srcVar1"] = "$colorfix",
				["resultVar"] = "$color"
			}
		}
	}
	
	local matName = string.format( "photon_airel_%s_%s", id, unitString )
	Photon.AirEL.MaterialIndex[matName .. "_lit"] = CreateMaterial( string.format( "photon_airel_%s_%s_lit", id, unitString ), "UnlitGeneric", matParams )

	matParams = {
		["$basetexture"] = mat:GetString( "$basetexture" ) .. ".png",
		["$model"] = 1,
		["$nocull"] = 1,
		["$additive"] = 1,
		["$colorfix"] = "{205 205 205}",
		["Proxies"] = {
			["Equals"] = {
				["srcVar1"] = "$colorfix",
				["resultVar"] = "$color"
			}
		}
	}

	Photon.AirEL.MaterialIndex[matName .. "_unlit"] = CreateMaterial( string.format( "photon_airel_%s_%s_unlit", id, unitString ), "VertexlitGeneric", matParams )
	local subIndex = Photon.AirEL.TranslationTableIndex[ ent:GetModel() ] or 0
	ent:SetSubMaterial( subIndex, "!" .. tostring( Photon.AirEL.MaterialIndex[matName .. "_unlit"]:GetName() ) )
	ent.Photon_LitAirelTexture = Photon.AirEL.MaterialIndex[matName .. "_lit"]
	ent.Photon_UnlitAirelTexture = Photon.AirEL.MaterialIndex[matName .. "_unlit"]
	ent.Photon_UnitID = unitString
end

Photon.AirEL.LoadMaterialFromFile = function( id, unitString )
	return Material( string.format( "../data/photon/airel/photon_airel_%s_%s.png", id, unitString ), "nocull smooth noclamp mips" )
end

Photon.AirEL.Apply = function( unitString, ent )
	if not IsValid( ent ) or not ent.AirEL then return end
	local mdl = ent:GetModel()
	local mdlId = Photon.AirEL.TranslationTable[ tostring( mdl ) ]
	if not mdlId then print( string.format( "[Photon] %s is not a supported AirEL model.", tostring( mdl ) ) ); return false end
	Photon.AirEL.LoadMaterial( mdlId, unitString, ent )
end

Photon.AirEL.Scan = function()
	for _,car in pairs( EMVU:AllVehicles() ) do
		if not IsValid( car ) then continue end
		if not car.AirELEntity or not IsValid( car.AirELEntity ) then continue end
		local airEL = car.AirELEntity
		if car:Photon_GetUnitNumber() == "" then continue end
		if airEL.PhotonMaterialDownloadInProgress == true then continue end
		if airEL.Photon_UnitID and airEL.Photon_UnitID == car:Photon_GetUnitNumber() then continue end
		Photon.AirEL.Apply( car:Photon_GetUnitNumber(), car.AirELEntity )
	end
end

timer.Create("Photon.AirELUnitScan", 5, 0, function()
	Photon.AirEL.Scan()
end)

Photon.AirEL.IllumScan = function()
	for _,car in pairs( EMVU:AllVehicles() ) do
		if not IsValid( car ) then continue end
		if not car.AirELEntity or not IsValid( car.AirELEntity ) then continue end
		local airEL = car.AirELEntity
		if not airEL.Photon_UnitID or not airEL.Photon_UnitID == car:Photon_GetUnitNumber() then continue end
		if not airEL.Photon_LitAirelTexture or not airEL.Photon_UnlitAirelTexture then continue end
		local subIndex = Photon.AirEL.TranslationTableIndex[ airEL:GetModel() ] or 0
		if car:Photon_Lights() or car:Photon_TrafficAdvisor() or car:Photon_Illumination() then
			airEL:SetSubMaterial( subIndex, "!" .. tostring( airEL.Photon_LitAirelTexture:GetName() ) )
		else
			airEL:SetSubMaterial( subIndex, "!" .. tostring( airEL.Photon_UnlitAirelTexture:GetName() ) )
		end
	end
end

timer.Create("Photon.AirELIllumScan", .25, 0, function()
	Photon.AirEL.IllumScan()
end)

concommand.Add("photon_clearmatcache", function()
	table.Empty(Photon.AirEL.MaterialIndex)
end)