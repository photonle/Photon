--[[-- Regular Lighting Vehicle Meta
@copyright Photon Team
@release development
@author Photon Team
@module VEHICLE
@alias ENT
--]]--

local ENT = FindMetaTable("Vehicle")

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

	local vel = self:Photon_WorldVelocity()
	return (driver:KeyDown(IN_BACK) and vel.y > 1) or (driver:KeyDown(IN_FORWARD) and vel.y < -1) or driver:KeyDown(IN_JUMP)
end

--- Set a new signal value.
-- @int[opt] val New signal value.
-- @rint Set signal value.
function ENT:Photon_Signal(val)
	if val ~= nil then
		self:SetPhotonNet_CurrentSignal(val)
	end

	return self:GetPhotonNet_CurrentSignal(0)
end

--- Stop any signals.
-- @rint New signal value.
function ENT:Photon_SignalStop()
	return self:Photon_Signal(CAR_BLINKER_NONE)
end

--- Set the left signal.
-- @bool[opt] bool If the signal should be enabled / disabled / unchanged.
-- @rint New signal value.
function ENT:Photon_TurnLeft(bool)
	if bool == true then
		return self:Photon_Signal(CAR_BLINKER_LEFT)
	elseif bool == false then
		return self:Photon_SignalStop()
	else
		return self:Photon_Signal() == CAR_BLINKER_LEFT
	end
end

--- Set the right signal.
-- @bool[opt] bool If the signal should be enabled / disabled / unchanged.
-- @rint New signal value.
function ENT:Photon_TurnRight(bool)
	if bool == true then
		return self:Photon_Signal(CAR_BLINKER_RIGHT)
	elseif bool == false then
		return self:Photon_SignalStop()
	else
		return self:Photon_Signal() == CAR_BLINKER_RIGHT
	end
end

--- Set the hazard signals.
-- @bool[opt] If the signal should be enabled / disabled / unchanged.
-- @rint New signal value.
function ENT:Photon_Hazards(bool)
	if bool == true then
		return self:Photon_Signal(CAR_BLINKER_HAZARD)
	elseif bool == false then
		return self:Photon_SignalStop()
	else
		return self:Photon_Signal() == CAR_BLINKER_HAZARD
	end
end
