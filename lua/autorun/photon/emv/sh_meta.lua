--[[-- Emergency Lighting Vehicle Meta
@copyright Photon Team
@release development
@author Photon Team
@module VEHICLE
@alias ENT
--]]--

local ENT = FindMetaTable("Entity")

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
	return self:GetPhotonNet_SelectionString(".")
end

function ENT:Photon_SelectionTable()
	return string.Split(self:Photon_SelectionString(), ".")
end

--- Whether the vehicle is blacked out, suppressing its running lights.
--- @return boolean blackout Whether the vehicle is blacked out.
--- @note `CAR_IsBlackedOut`, in `sv_photon_meta.lua`, is now nothing but an
--- alias for this. Its one caller is the `PlayerEnteredVehicle` hook, which
--- could call this directly and let the alias go.
--- @state shared
function ENT:Photon_Blackout()
	return self:GetPhotonNet_Blackout(false)
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
