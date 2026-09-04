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
