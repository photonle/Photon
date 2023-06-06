--[[-- Emergency Lighting Vehicle Meta
@copyright Photon Team
@release development
@author Photon Team
@classmod VEHICLE
@alias ENT
--]]--

local ENT = FindMetaTable("Vehicle")

--- Get lighting state.
-- @rbool
function ENT:Photon_Lights()
	if not IsValid(self) then
		return false
	end

	return self:GetNW2Bool("PhotonLE.EMV_LIGHTS_ON", false)
end
