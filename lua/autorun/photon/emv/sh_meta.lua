--[[-- Emergency Lighting Vehicle Meta
@copyright Photon Team
@release development
@author Photon Team
@module VEHICLE
@alias ENT
--]]--

local ENT = FindMetaTable("Vehicle")

function ENT:EMVName()
	return self:GetPhotonNet_VehicleIndex("")
end

function ENT:Photon_GetUnitNumber()
	return self:GetPhotonNet_UnitNumber("")
end

function ENT:Photon_GetLiveryID()
	return self:GetPhotonNet_LiveryID("")
end

function ENT:Photon_SelectionString()
	return self:GetPhotonNet_SelectionString("")
end

function ENT:Photon_SelectionTable()
	return string.Split(self:Photon_SelectionString(), ".")
end

function ENT:Photon_GetUtilStringTable()
	return {
		"",
		self:EMVName(),
		self:Photon_GetUnitNumber(),
		self:Photon_GetLiveryID(),
		self:Photon_SelectionString()
	}
end
