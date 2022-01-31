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

--- Get if the Vehicle is Reversing.
-- @rbool
function ENT:Photon_IsReversing()
	local driver = self:GetDriver()
	if not IsValid(driver) then return false end
	if not driver:IsPlayer() then return false end

	return self:Photon_WorldVelocity().y < 1 and ply:KeyDown(IN_BACK)
end
