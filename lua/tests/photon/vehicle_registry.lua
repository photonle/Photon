-- The registry only ever asks an entity four questions, so these cases drive it
-- with stand-ins rather than real vehicles: IsValid accepts any table with an
-- IsValid method, which keeps the membership cases free of entity setup and of
-- the networking that would otherwise have to be faked to reach it.

local created = {}

--- Build a stand-in vehicle. `hasPhoton` of nil means the value has not been
--- networked yet, so the getter falls through to its default.
local function vehicle(hasPhoton, index, isVehicle)
	local ent = {}

	function ent:IsValid() return true end
	function ent:IsVehicle() return isVehicle ~= false end
	function ent:GetPhotonNet_HasPhoton(default)
		if hasPhoton == nil then return default end
		return hasPhoton
	end
	function ent:GetPhotonNet_VehicleIndex(default) return index or default end
	function ent:Networked(newHasPhoton, newIndex)
		hasPhoton, index = newHasPhoton, newIndex
		Photon.Registry.Update(self)
	end

	created[#created + 1] = ent
	return ent
end

--- Drop every stand-in from previous cases. Runs at the start of a case rather
--- than the end so a case that errors cannot leak into the next one.
local function fresh()
	for i = #created, 1, -1 do
		Photon.Registry.Forget(created[i])
		created[i] = nil
	end
end

local function memberOf(set, ent)
	for i = 1, set.count do
		if set.list[i] == ent then return true end
	end

	return false
end

local function isDense(set)
	if #set.list ~= set.count then return false end

	for i = 1, set.count do
		if set.list[i] == nil then return false end
	end

	return true
end

local function emvsAreSubsetOfVehicles()
	local emvs = Photon.Registry.EMVs
	for i = 1, emvs.count do
		if not memberOf(Photon.Registry.Vehicles, emvs.list[i]) then return false end
	end

	return true
end

return {
	groupName = "Photon.Registry",

	cases = {
		{
			name = "A vehicle with Photon but no vehicle index is a vehicle and not an EMV",
			func = function(state)
				fresh()
				local car = vehicle(true, nil)
				Photon.Registry.Update(car)

				expect(memberOf(Photon.Registry.Vehicles, car)).to.equal(true)
				expect(memberOf(Photon.Registry.EMVs, car)).to.equal(false)
			end
		},
		{
			name = "A vehicle index arriving after Photon promotes the vehicle to an EMV",
			func = function(state)
				fresh()
				local car = vehicle(true, nil)
				Photon.Registry.Update(car)
				car:Networked(true, "fpiu16")

				expect(memberOf(Photon.Registry.Vehicles, car)).to.equal(true)
				expect(memberOf(Photon.Registry.EMVs, car)).to.equal(true)
			end
		},
		{
			name = "A vehicle index arriving before Photon reaches the same result",
			func = function(state)
				-- A resync sends an entity's fields in table order, so the two
				-- values can arrive either way round.
				fresh()
				local car = vehicle(nil, "fpiu16")
				Photon.Registry.Update(car)

				expect(memberOf(Photon.Registry.Vehicles, car)).to.equal(false)
				expect(memberOf(Photon.Registry.EMVs, car)).to.equal(false)

				car:Networked(true, "fpiu16")

				expect(memberOf(Photon.Registry.Vehicles, car)).to.equal(true)
				expect(memberOf(Photon.Registry.EMVs, car)).to.equal(true)
			end
		},
		{
			name = "Repeated updates with no change do not duplicate the entry",
			func = function(state)
				-- Clientside the hook runs on every receipt, not every change,
				-- so a resync replays values that have not moved.
				fresh()
				local car = vehicle(true, "fpiu16")
				local vehicles, emvs = Photon.Registry.Vehicles, Photon.Registry.EMVs
				local beforeVehicles, beforeEMVs = vehicles.count, emvs.count

				for _ = 1, 5 do Photon.Registry.Update(car) end

				expect(vehicles.count).to.equal(beforeVehicles + 1)
				expect(emvs.count).to.equal(beforeEMVs + 1)
			end
		},
		{
			name = "Clearing the vehicle index demotes an EMV without dropping the vehicle",
			func = function(state)
				fresh()
				local car = vehicle(true, "fpiu16")
				Photon.Registry.Update(car)
				car:Networked(true, "")

				expect(memberOf(Photon.Registry.Vehicles, car)).to.equal(true)
				expect(memberOf(Photon.Registry.EMVs, car)).to.equal(false)
			end
		},
		{
			name = "Clearing Photon drops the vehicle from both sets",
			func = function(state)
				fresh()
				local car = vehicle(true, "fpiu16")
				Photon.Registry.Update(car)
				car:Networked(false, "fpiu16")

				expect(memberOf(Photon.Registry.Vehicles, car)).to.equal(false)
				expect(memberOf(Photon.Registry.EMVs, car)).to.equal(false)
			end
		},
		{
			name = "A vehicle can be registered again after being dropped",
			func = function(state)
				fresh()
				local car = vehicle(true, "fpiu16")
				Photon.Registry.Update(car)
				car:Networked(false, "")
				car:Networked(true, "fpiu16")

				expect(memberOf(Photon.Registry.Vehicles, car)).to.equal(true)
				expect(memberOf(Photon.Registry.EMVs, car)).to.equal(true)
			end
		},
		{
			name = "A non-vehicle is never registered",
			func = function(state)
				fresh()
				local prop = vehicle(true, "fpiu16", false)
				Photon.Registry.Update(prop)

				expect(memberOf(Photon.Registry.Vehicles, prop)).to.equal(false)
				expect(memberOf(Photon.Registry.EMVs, prop)).to.equal(false)
			end
		},
		{
			name = "Forgetting a vehicle from the middle keeps the list dense and ordered",
			func = function(state)
				fresh()
				local first, second, third = vehicle(true, "a"), vehicle(true, "b"), vehicle(true, "c")
				Photon.Registry.Update(first)
				Photon.Registry.Update(second)
				Photon.Registry.Update(third)

				Photon.Registry.Forget(second)

				local vehicles = Photon.Registry.Vehicles
				expect(memberOf(vehicles, second)).to.equal(false)
				expect(isDense(vehicles)).to.equal(true)
				expect(isDense(Photon.Registry.EMVs)).to.equal(true)

				-- The survivors keep their relative order: the tail shifts down
				-- into the gap rather than the last member being swapped in.
				local firstAt, thirdAt
				for i = 1, vehicles.count do
					if vehicles.list[i] == first then firstAt = i end
					if vehicles.list[i] == third then thirdAt = i end
				end

				expect(firstAt < thirdAt).to.equal(true)
			end
		},
		{
			name = "Forgetting a vehicle that was never registered is harmless",
			func = function(state)
				fresh()
				local car = vehicle(true, "fpiu16")
				local before = Photon.Registry.Vehicles.count

				expect(function() Photon.Registry.Forget(car) end).to.succeed()
				expect(Photon.Registry.Vehicles.count).to.equal(before)
			end
		},
		{
			name = "Rebuilding leaves the sets consistent and is safe to repeat",
			func = function(state)
				-- OnReloaded can fire more than once for a single refresh, and
				-- rebuild runs against the real entity list, so this asserts the
				-- invariants rather than a fixed membership.
				fresh()

				expect(function()
					Photon.Registry.Rebuild()
					Photon.Registry.Rebuild()
				end).to.succeed()

				expect(isDense(Photon.Registry.Vehicles)).to.equal(true)
				expect(isDense(Photon.Registry.EMVs)).to.equal(true)
				expect(emvsAreSubsetOfVehicles()).to.equal(true)
			end
		},
		{
			name = "A membership flag left set without a matching entry blocks registration",
			func = function(state)
				-- The flag is what makes the membership test O(1), so Add trusts
				-- it. That trust is the reason rebuild has to clear flags across
				-- the entity list, not just through the lists it holds.
				fresh()
				local car = vehicle(true, "fpiu16")
				car[Photon.Registry.Vehicles.flag] = true

				Photon.Registry.Update(car)

				expect(memberOf(Photon.Registry.Vehicles, car)).to.equal(false)
			end
		},
		{
			name = "Rebuilding recovers a vehicle whose membership flag desynced from its list",
			func = function(state)
				fresh()
				local car = vehicle(true, "fpiu16")
				car[Photon.Registry.Vehicles.flag] = true
				car[Photon.Registry.EMVs.flag] = true

				-- Rebuild reads the entity list, which a stand-in is not in, so
				-- point it at one containing the stand-in for the duration.
				local world = {car}
				local realIterator = ents.Iterator
				ents.Iterator = function() return ipairs(world) end
				local rebuilt = pcall(Photon.Registry.Rebuild)
				ents.Iterator = realIterator

				expect(rebuilt).to.equal(true)
				expect(memberOf(Photon.Registry.Vehicles, car)).to.equal(true)
				expect(memberOf(Photon.Registry.EMVs, car)).to.equal(true)

				-- Leave the registry describing the real world again.
				fresh()
				Photon.Registry.Rebuild()
			end
		}
	}
}
