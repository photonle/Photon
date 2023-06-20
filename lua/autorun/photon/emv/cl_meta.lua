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

	return self:GetPhotonNet_LightOn(false)
end

function ENT:Photon_LightOption()
	if not IsValid(self) then return 1 end
	return self:GetPhotonNet_LightOption(1)
end

function ENT:Photon_LightOptionID()
	return EMVU.Sequences[self:EMVName()].Sequences[self:Photon_LightOption()].Stage or ""
end

function ENT:Photon_AuxOptionID()
	return EMVU.Sequences[self:EMVName()].Traffic[self:Photon_TrafficAdvisorOption()].Stage or ""
end

function ENT:Photon_IllumOptionID()
	local currentIndex, name = self:Photon_IllumOption(), self:EMVName()
	if not EMVU.Sequences[name] or not EMVU.Sequences[name].Illumination then return "" end
	return EMVU.Sequences[name].Illumination[currentIndex].Stage or ""
end

function ENT:Photon_Siren()
	if not IsValid(self) then return false end
	return self:GetPhotonNet_SirenOn(false)
end

function ENT:Photon_SirenOption()
	if not IsValid(self) then return 1 end
	return self:GetPhotonNet_SirenOption(1)
end

function ENT:Photon_AuxSirenSet()
	if not IsValid(self) then return end
	return self:GetPhotonNet_AuxSirenSet()
end

function ENT:Photon_SirenSet()
	if not IsValid(self) then return 1 end
	return self:GetPhotonNet_SirenSet(1)
end

function ENT:Photon_Illumination()
	if not IsValid(self) then return false end
	return self:GetPhotonNet_IlluminationOn()
end

function ENT:Photon_IllumOption()
	if not IsValid(self) then return 1 end
	return self:GetPhotonNet_IlluminationOption(1)
end

function ENT:Photon_TrafficAdvisor()
	if not IsValid(self) then return false end
	return self:GetPhotonNet_TrafficOn(false)
end

function ENT:Photon_ELPresetOption()
	if not IsValid(self) then return 0 end
	return self:GetPhotonNet_Preset(0)
end

function ENT:Photon_TrafficAdvisorOption()
	if not IsValid(self) then return 1 end
	return self:GetPhotonNet_TrafficOption(1)
end
