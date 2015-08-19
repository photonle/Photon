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
	if not IsValid( self ) then return false end
	if not EMV_INDEX then return false end
	if self:IsEMV() then
		return string.Explode( "ö", self:GetDTString( EMV_INDEX ), false )[2]
	end
	return false
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