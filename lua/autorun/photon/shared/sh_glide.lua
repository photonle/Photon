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

--- Forward-axis component of a localised velocity vector.
-- HL2 jeeps use +Y forward; Glide chassis use +X forward.
-- @ent ent
-- @tparam Vector localVel Result of WorldToLocal(pos + velocity).
-- @treturn number
function Photon.GetForwardSpeedComponent(ent, localVel)
	if Photon.IsGlideVehicle(ent) then
		return localVel.x
	end
	return localVel.y
end
