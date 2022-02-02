--[[-- Emergency Lighting Vehicle Meta
@copyright Photon Team
@release development
@author Photon Team
@module VEHICLE
@alias ENT
--]]--

local ENT = FindMetaTable("Vehicle")

local global_stayon = GetConVar("photon_emv_stayon")
local global_stayon_value = global_stayon:GetBool()
cvars.AddChangeCallback("photon_env_stayon", function()
	global_stayon_value = global_stayon:GetBool()
end)

--- Gets the Siren StayOn State.
-- @rbool
function ENT:GetPhotonLEStayOn()
	if global_stayon_value then
		return true
	end

	return self:GetPhotonNet_LEStayOn(false)
end

--- Sets the new Siren Stay On State.
-- @bool val New siren state.
function ENT:SetPhotonLEStayOn(val)
	self:SetPhotonNet_LEStayOn(val)
end
