AddCSLuaFile()
local ent = FindMetaTable( "Entity" )
local IsValid = IsValid
local string = string
local isstring = isstring
local tostring = tostring
local istable = istable

function ent:IsEMV()
	if not IsValid( self ) then return false end
	if not EMV_INDEX then return false end
	local str = self:GetNW2String( "PhotonLE.EMV_INDEX" )
	if string.StartWith( tostring(str), "ö" ) then return true end
	return false
end

function ent:Photon()
	-- return self:GetNWString( "PhotonVehicle", false )
	return ( IsValid( self ) and self:IsVehicle() and self:GetNW2Bool( "PhotonLE.CAR_HAS_PHOTON" ) ) or false
end

function ent:HasPhotonELS()
	if not IsValid( self ) then return false end
	if not EMV_INDEX then return false end
	if not self:IsEMV() then return false end
	if not self:GetNW2Bool( "PhotonLE.CAR_USE_EL" ) then return false end
	return true
end

function ent:EMVName()
	if not IsValid( self ) then return "" end
	if not EMV_INDEX then return "" end
	if self:IsEMV() then
		return string.Explode( "ö", self:GetNW2String( "PhotonLE.EMV_INDEX" ), false )[2]
	end
	return ""
end

function ent:Photon_GetSpeed()
	if not IsValid( self ) then return 0 end
	return self:GetVelocity():Length()
end

function ent:Photon_AdjustedSpeed()
	if not IsValid( self ) then return 0 end
	return ( self:GetVelocity():Length() * ( 3600 / 63360 ) )
end

function ent:Photon_GetUnitNumber()
	return string.Explode( "ö", self:GetNW2String( "PhotonLE.EMV_INDEX" ), false )[3] or ""
end

function ent:Photon_GetLiveryID()
	return string.Explode( "ö", self:GetNW2String( "PhotonLE.EMV_INDEX" ), false )[4] or ""
end

function ent:Photon_GetAutoSkinIndex()
	local materials = self:GetMaterials()
	for i=1,#materials do
		local thisMat = tostring( materials[i] )
		if string.EndsWith( thisMat, "/skin" ) or string.EndsWith( thisMat, "/skin0" ) or string.EndsWith( thisMat, "/carpaint" ) then
			return i - 1
		end
	end
	return false
end

function ent:Photon_GetAutoSkinData()
	if self:GetSkin() == 0 then return self:GetSubMaterial( self:Photon_GetAutoSkinIndex() ) end
	return self:GetSkin()
end

ent.LegacySetSkin = ent.LegacySetSkin or ent.SetSkin
function ent:SetSkin( index )
	self:LegacySetSkin( index )
	hook.Call( "Photon.EntityChangedSkin", GM, self, index )
end

function ent:Photon_SelectionString()
	return string.Explode( "ö", self:GetNW2String( "PhotonLE.EMV_INDEX" ), false )[5]
end

function ent:Photon_SelectionTable()
	-- print(tostring(self:GetNW2String( EMV_INDEX )))
	local selectionString =  string.Explode( "ö", self:GetNW2String( "PhotonLE.EMV_INDEX" ), false )[5]
	-- print(tostring(selectionString))
	return string.Explode( ".", selectionString, false )
end

function ent:Photon_SelectionOption( index )
	local bgTable = self:Photon_SelectionTable()
	if not istable( bgTable ) then return 1 end
	if index > #bgTable then return 1 end
	if index < 1 then return 1 end 
	-- print("index is: " .. tostring( index ))
	return tonumber( bgTable[ index ] )
end

function ent:Photon_ExportSelections()
	local selectTable = self:Photon_SelectionTable()
	local resultTable = {}
	local selectRef = EMVU.Selections[ self:EMVName() ]
	if not istable( selectTable ) or not istable( selectRef ) then return {} end 
	-- PrintTable( selectRef )
	-- PrintTable( selectTable )
	for key,value in pairs( selectTable ) do
		local keyName = selectRef[key].Name
		-- print(tostring(keyName))
		-- print(tostring(selectRef[key].Options[1]))
		local valueData = selectRef[key].Options[tonumber(value)]
		local valueName = ""
		if valueData.Category then valueName = valueData.Category .. "=" end
		valueName = valueName .. valueData.Name
		resultTable[keyName] = valueName
	end
	return resultTable
end

function ent:Photon_GetSelectionJSON()
	return util.TableToJSON( self:Photon_ExportSelections() )
end

function ent:Photon_SupportsConfigurations()
	return EMVU.Configurations.Supported[ self:EMVName() ] != nil
end

local function FormatBodygroupChoices( ent )
	local groups = ent:GetBodyGroups()
	local resultTable = {}
	for _,bg in pairs( groups ) do
		resultTable[tostring(bg.id)] = tostring( ent:GetBodygroup(bg.id) )
	end
	return resultTable
end

function ent:Photon_ExportConfiguration( selections, skin, color, siren, bodygroups )
	if not self:Photon_SupportsConfigurations() then print( "[Photon] Attempt to export configuration of unsupported vehicle." ) return false end
	local resultTable = {}
	resultTable.VehicleName = self:EMVName()
	if selections then resultTable.Selections = self:Photon_ExportSelections() end
	if skin then resultTable.Skin = self:Photon_GetAutoSkinData() end
	if color then resultTable.Color = self:GetColor() end
	if siren then
		resultTable.Siren = self:Photon_SirenSet()
		resultTable.AuxSiren = self:Photon_AuxSirenSet()
	end
	if bodygroups then resultTable.Bodygroups = FormatBodygroupChoices( self ) end
	return resultTable
end

function ent:Photon_ImportSelectionData( inputData )
	-- local inputData = util.JSONToTable( json )
	if not istable( inputData ) then return {} end
	local selectRef = EMVU.Selections[ self:EMVName() ]
	if not istable( selectRef ) then return {} end
	local resultTable = {}
	for keyName, valueData in pairs( inputData ) do

		local selectCategory, selectName
		if string.find( valueData, "=" ) then
			local splitResult = string.Split( valueData, "=" )
			selectCategory = splitResult[1]
			selectName = splitResult[2]
		else
			selectCategory = nil
			selectName = valueData
		end

		local matchKey, matchVal

		for key, selData in pairs( selectRef ) do
			if selData.Name == keyName then
				matchKey = key
				for valIndex, valData in pairs( selData.Options ) do
					if valData.Name == selectName and valData.Category == selectCategory then
						matchVal = valIndex
					end
				end
			end
		end

		if matchKey and matchVal then resultTable[matchKey] = matchVal end

	end
	if CLIENT then
		self:Photon_ApplyEquipmentPreset( resultTable )
	end
	return resultTable
end

function ent:Photon_GetUtilStringTable()
	return string.Explode( "ö", self:GetNW2String( "PhotonLE.EMV_INDEX" ), false )
end

function ent:Photon_SelectionEnabled()
	return istable( EMVU.Selections[ self:EMVName() ] )
end

function ent:Photon_LicensePlate()
	local materials = self:GetMaterials()
	for index, mat in pairs( materials ) do
		if string.EndsWith( mat, "license_plate" ) then
			return index - 1
		end
	end
	return false
end