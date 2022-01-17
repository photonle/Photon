--[[-- Regular Lighting Vehicle Meta
@copyright Photon Team
@release development
@author Photon Team
@module VEHICLE
@alias ENT
--]]--

local ENT = FindMetaTable("Vehicle")

function ENT:Photon_WorldVelocity()
	return self:WorldToLocal(self:GetPos() + self:GetVelocity())
end

function ENT:Photon_IsReversing()
	local driver = self:GetDriver()
	if not IsValid(driver) then return false end
	if not driver:IsPlayer() then return false end

	return self:Photon_WorldVelocity().y < 1 and ply:KeyDown(IN_BACK)
end

function ENT:Photon_IsBraking()
	if self:Photon_IsReversing() then return false end

	local driver = self:GetDriver()
	if not IsValid(driver) then return false end
	if not driver:IsPlayer() then return false end

	local vel = self:Photon_WorldVelocity()
	return (driver:KeyDown(IN_BACK) and vel.y > 1) or (driver:KeyDown(IN_FORWARD) and vel.y < -1) or driver:KeyDown(IN_JUMP)
end

function ENT:Photon_Signal(val)
	if val ~= nil then
		self.Photon_SignalVal = val
		Photon.Net.SignalChanged(self, val)
	end

	if self.Photon_SignalVal == nil then
		return 0
	else
		return self.Photon_SignalVal
	end
end

function ENT:Photon_SignalStop()
	return self:Photon_Signal(CAR_BLINKER_NONE)
end

function ENT:Photon_TurnLeft(bool)
	if bool == true then
		return self:Photon_Signal(CAR_BLINKER_LEFT)
	elseif bool == false then
		return self:Photon_SignalStop()
	else
		return self:Photon_Signal() == CAR_BLINKER_LEFT
	end
end

function ENT:Photon_TurnRight(bool)
	if bool == true then
		return self:Photon_Signal(CAR_BLINKER_RIGHT)
	elseif bool == false then
		return self:Photon_SignalStop()
	else
		return self:Photon_Signal() == CAR_BLINKER_RIGHT
	end
end

function ENT:Photon_Hazards(bool)
	if bool == true then
		return self:Photon_Signal(CAR_BLINKER_HAZARD)
	elseif bool == false then
		return self:Photon_SignalStop()
	else
		return self:Photon_Signal() == CAR_BLINKER_HAZARD
	end
end
