--[[-- Glide vehicle compatibility helpers.
@copyright Photon Team
@module Photon
--]]--

local IsValid = IsValid
local string_find = string.find

--- Whether the entity is a Glide chassis (or inherits a Glide base).
-- Mirrors Photon 2's Base-contains-"glide" heuristic, plus Glide's own flag.
-- @ent ent
-- @treturn bool
function Photon.IsGlideVehicle(ent)
	if not IsValid(ent) then return false end
	if ent.IsGlideVehicle then return true end
	local base = ent.Base
	return isstring(base) and string_find(base, "glide", 1, true) ~= nil
end

--- Whether Photon may treat this entity as a vehicle chassis.
-- Prefers engine/Glide `IsVehicle()` (Glide patches the meta), and also accepts
-- Glide chassis if that patch is absent or not yet applied.
-- @ent ent
-- @treturn bool
function Photon.IsPhotonChassis(ent)
	if not IsValid(ent) then return false end
	if ent:IsVehicle() then return true end
	return Photon.IsGlideVehicle(ent)
end

--- Resolve the Vehicles-list key for an entity (stock class or Glide ent class).
-- @ent ent
-- @treturn string|nil
function Photon.ResolveVehicleListClass(ent)
	if not IsValid(ent) then return nil end
	if Photon.IsGlideVehicle(ent) then
		return ent:GetClass()
	end
	if isfunction(ent.GetVehicleClass) then
		return ent:GetVehicleClass()
	end
	return ent:GetClass()
end

--- Resolve a seat or vehicle entity to the Photon-bearing chassis.
-- On Glide, players sit in child seats parented to the chassis; Photon state
-- lives on the chassis. Stock HL2 vehicles are returned unchanged.
-- @ent entOrSeat
-- @treturn Entity|nil
function Photon.GetVehicleEntity(entOrSeat)
	if not IsValid(entOrSeat) then return entOrSeat end
	local parent = entOrSeat:GetParent()
	if IsValid(parent) and Photon.IsGlideVehicle(parent) then
		return parent
	end
	return entOrSeat
end

--- The Photon vehicle the player is currently in (chassis when on Glide).
-- @tparam Player ply
-- @treturn Entity|nil
function Photon.GetPlayerVehicle(ply)
	if not IsValid(ply) then return nil end
	return Photon.GetVehicleEntity(ply:GetVehicle())
end

--- Driver of a Photon chassis (Glide seat 1 when available).
-- @ent ent
-- @treturn Player|Entity|nil
function Photon.GetVehicleDriver(ent)
	if not IsValid(ent) then return nil end
	if Photon.IsGlideVehicle(ent) and isfunction(ent.GetSeatDriver) then
		return ent:GetSeatDriver(1)
	end
	if isfunction(ent.GetDriver) then
		return ent:GetDriver()
	end
end

--- Forward-axis component of a localised vector (velocity or position).
-- HL2 jeeps use +Y forward; Glide chassis use +X forward.
-- @ent ent
-- @tparam Vector localVec Result of WorldToLocal(...).
-- @treturn number
function Photon.GetForwardSpeedComponent(ent, localVec)
	if Photon.IsGlideVehicle(ent) then
		return localVec.x
	end
	return localVec.y
end

--- Look up a `list.Get("Vehicles")` entry for an entity, with Glide-safe fallbacks.
-- @ent ent
-- @treturn table|nil
function Photon.LookupVehiclesEntry(ent)
	if not IsValid(ent) then return nil end

	if ent.VehicleTable and istable(ent.VehicleTable) then
		return ent.VehicleTable
	end

	local vehicles = list.GetForEdit("Vehicles")

	local vehicleName = ent.VehicleName
	if isstring(vehicleName) and vehicleName ~= "" then
		local byKey = vehicles[vehicleName]
		if istable(byKey) then return byKey end
		for _, car in pairs(vehicles) do
			if istable(car) and car.Name == vehicleName then
				return car
			end
		end
	end

	local class = Photon.ResolveVehicleListClass(ent)
	if class and istable(vehicles[class]) then
		return vehicles[class]
	end

	local model = ent:GetModel()
	if isstring(model) then
		local modelLower = string.lower(model)
		for _, car in pairs(vehicles) do
			if istable(car) and isstring(car.Model) and string.lower(car.Model) == modelLower then
				return car
			end
		end
	end
end

-- Glide HeadlightState: 0 = off (Photon blackout), 1 = low / on, 2 = high / fullbeam.
-- TurnSignalState matches Photon: 0 none, 1 left, 2 right, 3 hazard.
--
-- Glide already owns KEY_H for headlights (same default as Photon's blackout key) and
-- has auto-headlights for dark areas. Photon must not drive HeadlightState from H or
-- from a latched Blackout bit — only mirror Glide → Photon, and briefly pulse for ELS.

--- Whether Photon should draw PI sprites for headlights/running/brakes/signals.
-- Glide cars use native lighting for those; Photon still draws ELS props.
-- @ent ent
-- @treturn bool
function Photon.UsesNativeVehicleLights(ent)
	return Photon.IsGlideVehicle(ent)
end

--- Mirror Glide HeadlightState into Photon's Blackout / Running flags.
-- Glide is authoritative. Do not call this to *force* Glide lights.
-- Skips while ELS is mid-flash so temporary Off frames do not latch blackout.
-- @ent ent
-- @tparam[opt] bool force Sync even while flashing.
function Photon.SyncPhotonBlackoutFromGlide(ent, force)
	if not IsValid(ent) or not Photon.IsGlideVehicle(ent) then return end
	if not isfunction(ent.GetHeadlightState) then return end
	if ent.PhotonGlideELSFlashing and not force then return end

	local state = ent:GetHeadlightState() or 0
	if state > 0 then
		ent.PhotonGlidePreferredBeam = state
	end

	local blackout = state == 0
	if ent.SetPhotonNet_Blackout then
		ent:SetPhotonNet_Blackout(blackout)
	end
	if isfunction(ent.CAR_Running) then
		ent:CAR_Running(not blackout and IsValid(Photon.GetVehicleDriver(ent)))
	end
end

--- Advance Glide headlights Off → On → Fullbeam → Off.
-- Prefer letting Glide's own headlights bind do this (also KEY_H by default).
-- Kept for API / non-overlapping binds; Photon's H listener does not call this.
-- @ent ent
function Photon.CycleGlideHeadlights(ent)
	if not IsValid(ent) or not Photon.IsGlideVehicle(ent) then return end
	if not isfunction(ent.SetHeadlightState) and not isfunction(ent.ChangeHeadlightState) then return end

	ent.PhotonGlideELSFlashing = false

	local cur = isfunction(ent.GetHeadlightState) and (ent:GetHeadlightState() or 0) or 0
	local nextState = cur + 1
	if nextState > 2 then nextState = 0 end

	-- SetHeadlightState avoids ChangeHeadlightState's CanSwitchHeadlights early-out
	-- and click sound when Photon is not the primary input path.
	if isfunction(ent.SetHeadlightState) then
		ent:SetHeadlightState(nextState)
	else
		ent:ChangeHeadlightState(nextState, true)
	end

	Photon.SyncPhotonBlackoutFromGlide(ent, true)
end

--- Apply a Photon blinker value to Glide turn signals.
-- Uses SetTurnSignalState so Photon stays authoritative even when
-- CanSwitchTurnSignals is false, and avoids click spam.
-- @ent ent
-- @tparam number signal CAR_BLINKER_* / Glide TurnSignalState
function Photon.SyncGlideTurnSignals(ent, signal)
	if not IsValid(ent) or not Photon.IsGlideVehicle(ent) then return end
	signal = tonumber(signal) or 0
	if signal < 0 then signal = 0 end
	if signal > 3 then signal = 3 end

	if isfunction(ent.SetTurnSignalState) then
		ent:SetTurnSignalState(signal)
	elseif isfunction(ent.ChangeTurnSignalState) then
		ent:ChangeTurnSignalState(signal, true)
	end
end

--- Whether the active primary ELS sequence should flash native Glide headlights.
-- True when the sequence sets `Headlights` / `GlideHeadlights`, or any Components
-- key contains "headlight" (e.g. auto_fpiu16_headlights).
-- @ent ent
-- @treturn bool
function Photon.GlideSequenceUsesHeadlights(ent)
	if not IsValid(ent) or not ent:HasPhotonELS() then return false end
	if not ent:GetPhotonNet_LightOn(false) then return false end

	local name = ent:EMVName()
	if not isstring(name) or name == "" then return false end
	local sequences = EMVU and EMVU.Sequences and EMVU.Sequences[name]
	if not istable(sequences) or not istable(sequences.Sequences) then return false end

	local option = ent:GetPhotonNet_LightOption(1)
	local seq = sequences.Sequences[option]
	if not istable(seq) then return false end

	if seq.Headlights or seq.GlideHeadlights then return true end

	if istable(seq.Components) then
		for key in pairs(seq.Components) do
			if isstring(key) and string.find(string.lower(key), "headlight", 1, true) then
				return true
			end
		end
	end
	return false
end

--- Pulse Glide headlights for ELS when the active stage asks for it.
-- Never forces lights off for Photon blackout (that fought Glide auto-headlights).
-- Only starts flashing when headlights are already on; Off stays Off.
-- @ent ent
function Photon.ApplyGlideELSHeadlights(ent)
	if not IsValid(ent) or not Photon.IsGlideVehicle(ent) then return end
	if not isfunction(ent.SetHeadlightState) or not isfunction(ent.GetHeadlightState) then return end

	local state = ent:GetHeadlightState() or 0
	local wantsFlash = Photon.GlideSequenceUsesHeadlights(ent)

	if wantsFlash then
		-- Do not wake headlights from blackout / auto-off; only pulse an already-on beam.
		if state == 0 and not ent.PhotonGlideELSFlashing then
			return
		end

		if state > 0 then
			ent.PhotonGlidePreferredBeam = state
		end

		local preferred = ent.PhotonGlidePreferredBeam or 1
		if preferred < 1 then preferred = 1 end
		if preferred > 2 then preferred = 2 end

		ent.PhotonGlideELSFlashing = true
		local on = (CurTime() % 0.4) < 0.2
		local target = on and preferred or 0
		if state ~= target then
			ent:SetHeadlightState(target)
		end
		return
	end

	if ent.PhotonGlideELSFlashing then
		ent.PhotonGlideELSFlashing = false
		local preferred = ent.PhotonGlidePreferredBeam or 1
		if preferred < 1 then preferred = 1 end
		if preferred > 2 then preferred = 2 end
		if state ~= preferred then
			ent:SetHeadlightState(preferred)
		end
		Photon.SyncPhotonBlackoutFromGlide(ent, true)
	end
end
