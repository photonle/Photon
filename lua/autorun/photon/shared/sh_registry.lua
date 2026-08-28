--- Vehicle Registry.
--- Keeps a live list of every Photon vehicle, and of the emergency vehicles
--- among them, without scanning the entity list to find them.
---
--- Membership is derived from networked state, so it is maintained by
--- subscribing to `Photon.SimpleNet.ValueChanged` rather than by polling.
--- Neither `HasPhoton` nor `VehicleIndex` is knowable when an entity is
--- created — both arrive later, over the wire — so entity-creation hooks are
--- not a usable trigger and are deliberately not used here.
--- @copyright Photon Team
--- @release development
--- @author Photon Team
--- @namespace Photon.Registry
--- @state shared

-- Declared local-first, then published, so LuaLS can attribute the functions
-- below to a table it can name. See the same note in sh_simplenet.lua.

--- @class Photon.Registry
local REGISTRY = Photon.Registry or {}
Photon.Registry = REGISTRY

--- A set of vehicles, held as a dense array plus its length.
---
--- The length is tracked rather than measured because `#` costs roughly as much
--- as a loop iteration, and these are read every frame. `list` stays dense from
--- `1` to `count`, so `#list` and `count` agree; prefer `count`.
--- @class Photon.Registry.Set
--- @field list Entity[] Members, `1` through `count`.
--- @field count integer Number of members.
--- @field flag string Field set on a member entity to mark it as one.
--- @state shared

--- Every vehicle `Photon:SetupCar` has run on.
--- @type Photon.Registry.Set
--- @state shared
--- @section Sets
REGISTRY.Vehicles = REGISTRY.Vehicles or {list = {}, count = 0, flag = "Photon_InVehicleRegistry"}

--- Every registered vehicle that is also an emergency vehicle. A strict subset
--- of `Photon.Registry.Vehicles`.
--- @type Photon.Registry.Set
--- @state shared
REGISTRY.EMVs = REGISTRY.EMVs or {list = {}, count = 0, flag = "Photon_InEMVRegistry"}

--- Add an entity to a set, if it is not already in it.
--- @param set Photon.Registry.Set Set to add to.
--- @param ent Entity Entity to add.
--- @internal
--- @state shared
--- @section Membership
local function Add(set, ent)
	if ent[set.flag] then return end

	local count = set.count + 1
	set.list[count] = ent
	set.count = count
	ent[set.flag] = true
end

--- Remove an entity from a set, if it is in it.
---
--- Shifts the tail down rather than swapping the last member into the gap:
--- removals happen on spawn and despawn, iteration happens every frame, so the
--- cost belongs on the rare operation. Holding order steady also means a loop
--- running while this happens skips at most the one member that shifted past
--- it, which every caller's `IsValid` guard already tolerates.
--- @param set Photon.Registry.Set Set to remove from.
--- @param ent Entity Entity to remove.
--- @internal
--- @state shared
local function Remove(set, ent)
	-- The flag is a field on the entity, so it dies with the entity and cannot
	-- be trusted once the entity is gone. An invalid entity always takes the
	-- scan; a valid one that was never a member returns immediately.
	local valid = IsValid(ent)
	if valid and not ent[set.flag] then return end

	local list = set.list
	for i = 1, set.count do
		if list[i] == ent then
			table.remove(list, i)
			set.count = set.count - 1
			break
		end
	end

	if valid then ent[set.flag] = nil end
end

--- Add or remove an entity from a set to match a membership test.
--- @param set Photon.Registry.Set Set to update.
--- @param ent Entity Entity to place.
--- @param member boolean Whether the entity belongs in the set.
--- @internal
--- @state shared
local function Apply(set, ent, member)
	if member then
		Add(set, ent)
	else
		Remove(set, ent)
	end
end

--- Empty a set, clearing the membership flag off everything still in it.
--- @param set Photon.Registry.Set Set to empty.
--- @internal
--- @state shared
local function Clear(set)
	local list = set.list
	for i = 1, set.count do
		local ent = list[i]
		if IsValid(ent) then ent[set.flag] = nil end
		list[i] = nil
	end

	set.count = 0
end

--- Recheck which sets an entity belongs to and correct both.
---
--- Membership is recomputed from scratch every call rather than added to as
--- values arrive. A resync sends an entity's fields in table order, so
--- `VehicleIndex` can land before `HasPhoton`; deriving both answers together
--- makes the result the same whichever order they turn up in.
---
--- Safe to call repeatedly with no change, which it is: the client runs
--- `Photon.SimpleNet.ValueChanged` on every receipt, not only on a change.
--- @param ent Entity Entity to recheck.
--- @state shared
--- @section Maintenance
function REGISTRY.Update(ent)
	if not IsValid(ent) or not ent:IsVehicle() then
		REGISTRY.Forget(ent)
		return
	end

	local hasPhoton = ent:GetPhotonNet_HasPhoton(false)
	Apply(REGISTRY.Vehicles, ent, hasPhoton)

	-- An emergency vehicle is a Photon vehicle that also has a vehicle index,
	-- so the EMV set can never hold something the vehicle set does not.
	Apply(REGISTRY.EMVs, ent, hasPhoton and ent:GetPhotonNet_VehicleIndex("") ~= "")
end

--- Drop an entity from every set.
--- @param ent Entity Entity to drop.
--- @state shared
function REGISTRY.Forget(ent)
	Remove(REGISTRY.Vehicles, ent)
	Remove(REGISTRY.EMVs, ent)
end

--- Rebuild both sets from the entity list.
---
--- The one place the registry scans, run on load and on the events that can
--- invalidate it wholesale. Idempotent, because `GM:OnReloaded` can fire more
--- than once for a single refresh.
---
--- Also the recovery path if a membership flag ever desyncs from its list,
--- which is why it clears flags across the entity list rather than only
--- through the lists themselves: an entity flagged as a member of a set that
--- does not contain it would otherwise be skipped by `Add` forever.
--- @state shared
function REGISTRY.Rebuild()
	Clear(REGISTRY.Vehicles)
	Clear(REGISTRY.EMVs)

	local vehicleFlag, emvFlag = REGISTRY.Vehicles.flag, REGISTRY.EMVs.flag
	for _, ent in ents.Iterator() do
		ent[vehicleFlag] = nil
		ent[emvFlag] = nil
		REGISTRY.Update(ent)
	end
end

hook.Add("Photon.SimpleNet.ValueChanged", "Photon.Registry.Update", function(name, _, _, ent)
	if name ~= "HasPhoton" and name ~= "VehicleIndex" then return end
	REGISTRY.Update(ent)
end)

-- Fires for every entity in the game, so the early-out in Remove is what keeps
-- this cheap. The fullUpdate case is left to heal itself: a client that loses
-- an entity to a full update gets it back through NetworkEntityCreated, which
-- requests a resync, which runs ValueChanged and re-registers it.
hook.Add("EntityRemoved", "Photon.Registry.Forget", function(ent)
	REGISTRY.Forget(ent)
end)

hook.Add("InitPostEntity", "Photon.Registry.Rebuild", REGISTRY.Rebuild)
hook.Add("PostCleanupMap", "Photon.Registry.Rebuild", REGISTRY.Rebuild)
hook.Add("OnReloaded", "Photon.Registry.Rebuild", REGISTRY.Rebuild)
