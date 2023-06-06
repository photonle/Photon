--[[-- Regular Lighting Vehicle Meta
@copyright Photon Team
@release development
@author Photon Team
@module VEHICLE
@alias ENT
--]]--

local ENT = FindMetaTable("Vehicle")

--- Get if the Vehicle is Reversing.
-- @warns This function will only natively work on the Server or Local Client.
-- @warns It will not work for other players in the Client realm.
-- @warns Instead, a cached value is fetched from the server.
-- @rbool
function ENT:Photon_IsReversing()
	local driver = self:GetDriver()
	if not IsValid(driver) then return false end
	if not driver:IsPlayer() then return false end

	return self:Photon_WorldVelocity().y < 1 and driver:KeyDown(IN_BACK)
end

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

--- Gets the running lights state.
-- @rbool The running light state.
function ENT:Photon_IsRunning()
	if self.HasPhotonELS and self:HasPhotonELS() and self.ELS and self.ELS.Blackout then
		return false
	end

	return IsValid(self:GetDriver())
end

--- Get if this vehicle has wheels.
-- @rbool
function ENT:Photon_WheelEnabled()
	return istable(Photon.Vehicles.WheelPositions[self.VehicleName]) and istable(Photon.Vehicles.WheelOptions[self.VehicleName])
end

--- Set the wheel index.
-- @int val New wheel index.
function ENT:Photon_PlayerSetWheelIndex(val)
	if not self:Photon_WheelEnabled() then
		return false
	end

	local max = math.min(#Photon.Vehicles.WheelOptions[self.VehicleName], 63)
	if val > max then
		val = 1
	end

	self:SetPhotonNet_WheelIndex(val)
end
