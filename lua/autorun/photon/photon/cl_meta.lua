--[[-- Regular Lighting Vehicle Meta
@copyright Photon Team
@release development
@author Photon Team
@module VEHICLE
@alias ENT
--]]--

local ENT = FindMetaTable("Vehicle")
local lp = LocalPlayer

--- Get if the Vehicle is Braking.
-- @warns This function will only natively work on the Server or Local Client.
-- @warns It will not work for other players in the Client realm.
-- @warns Instead, a cached value is fetched from the server.
-- @rbool
function ENT:Photon_IsBraking()
	if self:Photon_IsReversing() then return false end

	local driver = self:GetDriver()
	if not IsValid(driver) then return false end
	if not driver:IsPlayer() then return false end

	if driver == lp() then
		local vel = self:Photon_WorldVelocity()
		return (driver:KeyDown(IN_BACK) and vel.y > 1) or (driver:KeyDown(IN_FORWARD) and vel.y < -1) or driver:KeyDown(IN_JUMP)
	end

	return self:GetPhotonNet_Reversing(false)
end
