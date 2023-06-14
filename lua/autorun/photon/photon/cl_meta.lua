--[[-- Regular Lighting Vehicle Meta
@copyright Photon Team
@release development
@author Photon Team
@classmod VEHICLE
@alias ENT
--]]--

local ENT = FindMetaTable("Vehicle")
local lp = LocalPlayer


--- Get if the Vehicle is Reversing.
-- @warns This function will only natively work on the Server or Local Client.
-- @warns It will not work for other players in the Client realm.
-- @warns Instead, a cached value is fetched from the server.
-- @rbool
function ENT:Photon_IsReversing()
	local ply = self:GetDriver()
	if not IsValid(ply) then return false end
	if not ply:IsPlayer() then return false end

	if ply == lp() then
		return self:Photon_WorldVelocity().y < 1 and ply:KeyDown(IN_BACK)
	end

	return self:GetPhotonNet_Reversing(false)
end

--- Get if the Vehicle is Braking.
-- @warns This function will only natively work on the Server or Local Client.
-- @warns It will not work for other players in the Client realm.
-- @warns Instead, a cached value is fetched from the server.
-- @rbool
function ENT:Photon_IsBraking()
	if self:Photon_IsReversing() then return false end

	local ply = self:GetDriver()
	if not IsValid(ply) then return false end
	if not ply:IsPlayer() then return false end

	if ply == lp() then
		local vel = self:Photon_WorldVelocity()
		return (ply:KeyDown(IN_BACK) and vel.y > 1) or (ply:KeyDown(IN_FORWARD) and vel.y < -1) or ply:KeyDown(IN_JUMP)
	end

	return self:GetPhotonNet_Braking(false)
end

--- Gets the running lights state.
-- @rbool The running light state.
function ENT:Photon_IsRunning()
	return self:GetPhotonNet_Running(false)
end

--- Gets the turn signal value.
-- @rint Blinker State
function ENT:Photon_BlinkState()
	return self:GetPhotonNet_CurrentSignal(CAR_BLINKER_NONE)
end

--- Gets if the left turn indicator is enabled
-- @rbool
function ENT:Photon_TurningLeft()
	return self:Photon_BlinkState() == CAR_BLINKER_LEFT
end

--- Gets if the right turn indicator is enabled
-- @rbool
function ENT:Photon_TurningRight()
	return self:Photon_BlinkState() == CAR_BLINKER_RIGHT
end

--- Gets if the hazard lights are enabled
-- @rbool
function ENT:Photon_Hazards()
	return self:Photon_BlinkState() == CAR_BLINKER_HAZARD
end
