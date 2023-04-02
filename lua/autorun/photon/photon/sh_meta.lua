--[[-- Regular Lighting Vehicle Meta
@copyright Photon Team
@release development
@author Photon Team
@module VEHICLE
@alias ENT
--]]--

local ENT = FindMetaTable("Vehicle")

--- Get the World Localised Velocity
-- @rvec
function ENT:Photon_WorldVelocity()
	return self:WorldToLocal(self:GetPos() + self:GetVelocity())
end
