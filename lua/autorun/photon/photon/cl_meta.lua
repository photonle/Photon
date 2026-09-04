--[[-- Regular Lighting Vehicle Meta
@copyright Photon Team
@release development
@author Photon Team
@classmod VEHICLE
@alias ENT
--]]--

local ENT = FindMetaTable("Entity")
local lp = LocalPlayer


--- Get if the Vehicle is Reversing.
-- @warns This function will only natively work on the Server or Local Client.
-- @warns It will not work for other players in the Client realm.
-- @warns Instead, a cached value is fetched from the server.
-- @rbool
function ENT:Photon_IsReversing()
	local ply = Photon.GetVehicleDriver(self)
	if not IsValid(ply) then return false end
	if not ply:IsPlayer() then return false end

	if ply == lp() then
		local forward = Photon.GetForwardSpeedComponent(self, self:Photon_WorldVelocity())
		return forward < 1 and ply:KeyDown(IN_BACK)
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

	local ply = Photon.GetVehicleDriver(self)
	if not IsValid(ply) then return false end
	if not ply:IsPlayer() then return false end

	if ply == lp() then
		local forward = Photon.GetForwardSpeedComponent(self, self:Photon_WorldVelocity())
		-- Glide uses IN_FORWARD+IN_BACK as brake (Photon 2 parity).
		if Photon.IsGlideVehicle(self) and ply:KeyDown(IN_FORWARD) and ply:KeyDown(IN_BACK) then
			return true
		end
		return (ply:KeyDown(IN_BACK) and forward > 1) or (ply:KeyDown(IN_FORWARD) and forward < -1) or ply:KeyDown(IN_JUMP)
	end

	return self:GetPhotonNet_Braking(false)
end

--- Gets the running lights state.
--- @return boolean running The running light state.
--- @note `Running` is a networked cache of something both realms can derive:
--- a vehicle is running when someone is driving it and it is not blacked out.
--- Computing it here would let `Photon.SNet` drop the mapping entirely, and let
--- `ELS_Blackout` stop writing `CAR_Running` to keep the two in step.
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
