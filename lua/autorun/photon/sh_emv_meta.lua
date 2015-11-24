AddCSLuaFile()
local ent = FindMetaTable( "Entity" )

function ent:IsEMV()
	if not IsValid( self ) then return false end
	if not EMV_INDEX then return false end
	local str = self:GetDTString( EMV_INDEX )
	if string.StartWith( tostring(str), "ö" ) then return true end
	return false
end

function ent:Photon()
	return self:GetNWString( "PhotonVehicle", false )
end

function ent:HasELS()
	if not IsValid( self ) then return false end
	if not EMV_INDEX then return false end
	if not self:IsEMV() then return false end
	if not self:GetDTBool( CAR_USE_EL ) then return false end
	return true
end

function ent:EMVName()
	if not IsValid( self ) then return "" end
	if not EMV_INDEX then return "" end
	if self:IsEMV() then
		return string.Explode( "ö", self:GetDTString( EMV_INDEX ), false )[2]
	end
	return ""
end

function ent:Photon_GetSpeed()
	if not IsValid( self ) then return false end
	return self:GetVelocity():Length()
end

function ent:Photon_AdjustedSpeed()
	if not IsValid( self ) then return false end
	return self:GetVelocity():Length() / 10
end

function ent:Photon_GetUnitNumber()
	return string.Explode( "ö", self:GetDTString( EMV_INDEX ), false )[3] or ""
end

function ent:Photon_GetLiveryID()
	return string.Explode( "ö", self:GetDTString( EMV_INDEX ), false )[4] or ""
end

function ent:Photon_GetAutoSkinIndex()
	local materials = self:GetMaterials()
	for i=1,#materials do
		local thisMat = tostring( materials[i] )
		if string.EndsWith( thisMat, "/skin" ) or string.EndsWith( thisMat, "/skin0" ) then
			return i - 1
		end
	end
	return false
end

ent.LegacySetSkin = ent.SetSkin
function ent:SetSkin( index )
	self:LegacySetSkin( index )
	hook.Call( "Photon.EntityChangedSkin", GM, self, index )
end

function ent:Photon_SelectionString()
	return string.Explode( "ö", self:GetDTString( EMV_INDEX ), false )[5]
end

function ent:Photon_SelectionTable()
	-- print(tostring(self:GetDTString( EMV_INDEX )))
	local selectionString =  string.Explode( "ö", self:GetDTString( EMV_INDEX ), false )[5]
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

function ent:Photon_GetUtilStringTable()
	return string.Explode( "ö", self:GetDTString( EMV_INDEX ), false )
end

function ent:Photon_SelectionEnabled()
	return istable( EMVU.Selections[ self:EMVName() ] )
end