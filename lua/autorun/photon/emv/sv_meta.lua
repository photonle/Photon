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
-- @bool[opt] val New siren state.
-- @rbool The new set value.
function ENT:SetPhotonLEStayOn(val)
	return self:SetPhotonNet_LEStayOn(val)
end

--- Sets if the vehicle has ELS enabled.
-- @bool[opt] val New enable state
-- @rbool The set value.
function ENT:ELS_Enabled(val)
	if val ~= nil then
		self:SetPhotonNet_Enabled(val)
	end

	return self:GetPhotonNet_Enabled()
end

--- Sets if the vehicle has ELS lights running.
-- @bool[opt] val New enable state
-- @rbool The set value.
function ENT:ELS_Lights(val)
	if val ~= nil then
		self:SetPhotonNet_LightOn(val)
	end

	return self:GetPhotonNet_LightOn()
end

--- Sets the active light value.
-- @int[opt] val New active option
-- @rint The set value.
function ENT:ELS_LightOption(val)
	if val ~= nil then
		self:SetPhotonNet_LightOption(val)
	end

	return self:GetPhotonNet_LightOption()
end

--- Sets if the vehicle has siren running.
-- @bool[opt] val New enable state
-- @rbool The set value.
function ENT:ELS_Siren(val)
	if val ~= nil then
		self:SetPhotonNet_SirenOn(val)
	end

	return self:GetPhotonNet_SirenOn()
end

--- Sets the active siren.
-- @int[opt] val Siren option.
-- @rint The set value.
function ENT:ELS_SirenOption(val)
	if val ~= nil then
		self:SetPhotonNet_SirenOption(val)
	end

	return self:GetPhotonNet_SirenOption()
end

--- Sets the set of sirens.
-- @int[opt] val Siren set.
-- @rint The set value.
function ENT:ELS_SirenSet(val)
	if val ~= nil then
		self:SetPhotonNet_SirenSet(val)
	end

	return self:GetPhotonNet_SirenSet()
end

--- Sets the set of sirens.
-- @int[opt] val Siren set.
-- @rint The set value.
function ENT:ELS_AuxSirenSet(val)
	if val ~= nil then
		self:SetPhotonNet_AuxSirenSet(val)
	end

	return self:GetPhotonNet_AuxSirenSet()
end

--- Checks if the vehicle has aux sirens.
-- @rbool
function ENT:ELS_HasAuxSiren()
	return self:ELS_AuxSirenSet() ~= 0
end

--- Gets/Sets Traffic Advisor enable state.
-- @int[opt] val TA enabled.
-- @rint The set value.
function ENT:ELS_Traffic(val)
	if val ~= nil then
		self:SetPhotonNet_TrafficOn(val)
	end

	return self:GetPhotonNet_TrafficOn()
end

--- Gets/Sets Traffic Advisor option.
-- @int[opt] val TA direction.
-- @rint The set value.
function ENT:ELS_TrafficOption(val)
	if val ~= nil then
		self:SetPhotonNet_TrafficOption(val)
	end

	return self:GetPhotonNet_TrafficOption()
end

--- Gets/Sets illumination enabled.
-- @int[opt] val Illumination State.
-- @rint The set value.
function ENT:ELS_Illuminate(val)
	if val ~= nil then
		self:SetPhotonNet_IlluminationOn(val)
	end

	return self:GetPhotonNet_IlluminationOn()
end

--- Gets/Sets Illumination option.
-- @int[opt] val New Illumination Option.
-- @rint The set value.
function ENT:ELS_IlluminateOption(val)
	if val ~= nil then
		self:SetPhotonNet_IlluminationOption(val)
	end

	return self:GetPhotonNet_IlluminationOption()
end

--- Gets/Sets the a EMV preset.
-- @int[opt] New preset value.
-- @rint The current preset value.
function ENT:ELS_PresetOption(val)
	local idxs = EMVU.PresetIndex[self.Name]
	if not idxs then
		PhotonWarning("No presets found for " .. tostring( self.Name ) .. ".")
		PhotonWarning("Please check for errors above.")
		return 0
	end

	if val ~= nil then
		val = math.Clamp(val, 0, #idxs)
		self:SetPhotonNet_Preset(val)

		local bgData = EMVU.Helper:BodygroupPreset(self, val)
		for _, bg in ipairs(bgData) do
			self:SetBodygroup(bg[1], bg[2])
		end
	end

	return self:GetPhotonNet_Preset()
end
