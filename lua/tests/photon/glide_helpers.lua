-- Glide compatibility helpers: seat→chassis resolution and forward-axis selection.

local function NewEnt()
	local ent = ents.Create("prop_physics")
	ent:SetModel("models/error.mdl")
	ent:Spawn()
	return ent
end

-- Stands in for a player sitting in `seat`, as Glide's seat index reports it.
local function FakePlayer(seat, seatIndex)
	return {
		IsValid = function() return true end,
		GetVehicle = function() return seat end,
		GlideGetSeatIndex = function() return seatIndex end,
	}
end

return {
	groupName = "Photon Glide helpers",

	cases = {
		{
			name = "IsGlideVehicle detects the IsGlideVehicle flag",
			func = function(state)
				local ent = NewEnt()
				state.ent = ent
				ent.IsGlideVehicle = true
				expect(Photon.IsGlideVehicle(ent)).to.beTrue()
			end
		},
		{
			name = "IsGlideVehicle detects a glide Base string",
			func = function(state)
				local ent = NewEnt()
				state.ent = ent
				ent.Base = "base_glide_car"
				expect(Photon.IsGlideVehicle(ent)).to.beTrue()
			end
		},
		{
			name = "IsGlideVehicle reads the class definition before the entity's own fields exist",
			func = function(state)
				-- What a client sees in NetworkEntityCreated: a valid entity of a Glide class
				-- whose IsGlideVehicle and Base cannot be read yet.
				local early = {
					IsValid = function() return true end,
					GetClass = function() return "photon_test_early_glide" end,
				}
				local plain = {
					IsValid = function() return true end,
					GetClass = function() return "photon_test_plain" end,
				}
				local getStored = scripted_ents.GetStored
				state.restoreGetStored = getStored
				scripted_ents.GetStored = function(class)
					if class == "photon_test_early_glide" then return {t = {Base = "base_glide_car"}} end
					return getStored(class)
				end

				expect(Photon.IsGlideVehicle(early)).to.beTrue()
				expect(Photon.IsPhotonChassis(setmetatable(early, {__index = {IsVehicle = function() return false end}}))).to.beTrue()
				expect(Photon.IsGlideVehicle(plain)).to.beFalse()
			end
		},
		{
			name = "IsGlideVehicle is false for stock vehicles",
			func = function(state)
				local ent = NewEnt()
				state.ent = ent
				ent.Base = "prop_vehicle_jeep"
				expect(Photon.IsGlideVehicle(ent)).to.beFalse()
			end
		},
		{
			name = "GetVehicleEntity is identity without a Glide parent",
			func = function(state)
				local seat = NewEnt()
				state.ent = seat
				expect(Photon.GetVehicleEntity(seat)).to.equal(seat)
			end
		},
		{
			name = "GetVehicleEntity walks up to a Glide chassis parent",
			func = function(state)
				local chassis = NewEnt()
				local seat = NewEnt()
				state.chassis = chassis
				state.ent = seat
				chassis.IsGlideVehicle = true
				seat:SetParent(chassis)
				expect(Photon.GetVehicleEntity(seat)).to.equal(chassis)
			end
		},
		{
			name = "GetPlayerVehicle gives the Glide driver the chassis",
			func = function(state)
				local chassis = NewEnt()
				local seat = NewEnt()
				state.chassis = chassis
				state.ent = seat
				chassis.IsGlideVehicle = true
				seat:SetParent(chassis)
				expect(Photon.GetPlayerVehicle(FakePlayer(seat, 1))).to.equal(chassis)
			end
		},
		{
			name = "GetPlayerVehicle gives a Glide passenger their seat",
			func = function(state)
				local chassis = NewEnt()
				local seat = NewEnt()
				state.chassis = chassis
				state.ent = seat
				chassis.IsGlideVehicle = true
				seat:SetParent(chassis)
				expect(Photon.GetPlayerVehicle(FakePlayer(seat, 2))).to.equal(seat)
			end
		},
		{
			name = "GetPlayerVehicle ignores the Glide seat index on stock vehicles",
			func = function(state)
				local car = NewEnt()
				state.ent = car
				expect(Photon.GetPlayerVehicle(FakePlayer(car, 0))).to.equal(car)
			end
		},
		{
			name = "GetForwardSpeedComponent uses Y for stock vehicles",
			func = function(state)
				local ent = NewEnt()
				state.ent = ent
				local vel = Vector(10, 25, 0)
				expect(Photon.GetForwardSpeedComponent(ent, vel)).to.equal(25)
			end
		},
		{
			name = "GetForwardSpeedComponent uses X for Glide vehicles",
			func = function(state)
				local ent = NewEnt()
				state.ent = ent
				ent.IsGlideVehicle = true
				local vel = Vector(40, 5, 0)
				expect(Photon.GetForwardSpeedComponent(ent, vel)).to.equal(40)
			end
		},
		{
			name = "ResolveVehicleListClass prefers GetClass on Glide",
			func = function(state)
				local ent = NewEnt()
				state.ent = ent
				ent.IsGlideVehicle = true
				expect(Photon.ResolveVehicleListClass(ent)).to.equal(ent:GetClass())
			end
		},
		{
			name = "IsPhotonChassis accepts Glide when IsVehicle is false",
			func = function(state)
				local ent = NewEnt()
				state.ent = ent
				ent.IsGlideVehicle = true
				-- prop_physics is not an engine vehicle; helper must still accept Glide flag
				expect(Photon.IsPhotonChassis(ent)).to.beTrue()
			end
		},
		{
			name = "LookupVehiclesEntry finds by VehicleName display Name",
			func = function(state)
				local ent = NewEnt()
				state.ent = ent
				local key = "photon_glide_test_" .. ent:EntIndex()
				list.Set("Vehicles", key, {
					Name = "Photon Glide Test Car",
					Model = "models/error.mdl",
					Class = "prop_vehicle_jeep",
				})
				state.listKey = key
				ent.VehicleName = "Photon Glide Test Car"
				local entry = Photon.LookupVehiclesEntry(ent)
				expect(entry).to.beA("table")
				expect(entry.Name).to.equal("Photon Glide Test Car")
			end
		},
		{
			name = "LookupVehiclesEntry ignores a chassis model match on a bare Glide chassis",
			func = function(state)
				local ent = NewEnt()
				state.ent = ent
				ent.IsGlideVehicle = true
				local key = "photon_glide_hijack_" .. ent:EntIndex()
				list.Set("Vehicles", key, {
					Name = "Photon Hijack Car",
					Model = "models/error.mdl",
					Class = "glide_fake",
					HasPhoton = true,
					IsEMV = true,
				})
				state.listKey = key
				expect(Photon.LookupVehiclesEntry(ent)).to.beNil()
				expect(Photon:RecoverVehicleName(ent)).to.beFalse()
			end
		},
		{
			name = "LookupVehiclesEntry resolves a Glide chassis by VehicleName",
			func = function(state)
				local ent = NewEnt()
				state.ent = ent
				ent.IsGlideVehicle = true
				local key = "photon_glide_named_" .. ent:EntIndex()
				list.Set("Vehicles", key, {
					Name = "Photon Named Glide",
					Model = "models/error.mdl",
					Class = "glide_fake",
					HasPhoton = true,
				})
				state.listKey = key
				ent.VehicleName = key
				local entry = Photon.LookupVehiclesEntry(ent)
				expect(entry).to.beA("table")
				expect(entry.Name).to.equal("Photon Named Glide")
			end
		},
		{
			name = "RecoverVehicleName does not guess for a Glide chassis with an unrelated VehicleName",
			func = function(state)
				local ent = NewEnt()
				state.ent = ent
				ent.IsGlideVehicle = true
				ent.VehicleName = "cityrp_item_focus_rs"
				local key = "photon_glide_els_" .. ent:EntIndex()
				list.Set("Vehicles", key, {
					Name = key,
					Model = "models/error.mdl",
					Class = "glide_fake",
					HasPhoton = true,
					IsEMV = true,
				})
				state.listKey = key
				expect(Photon.LookupVehiclesEntry(ent)).to.beNil()
				expect(Photon:RecoverVehicleName(ent)).to.beFalse()
				expect(ent.VehicleName).to.equal("cityrp_item_focus_rs")
			end
		},
		{
			name = "PhotonVehicleName picks the pack without changing VehicleName",
			func = function(state)
				local ent = NewEnt()
				state.ent = ent
				ent.IsGlideVehicle = true
				local key = "photon_glide_kit_" .. ent:EntIndex()
				list.Set("Vehicles", key, {
					Name = "Kit " .. key,
					Model = "models/error.mdl",
					Class = "glide_fake",
					HasPhoton = true,
					IsEMV = true,
				})
				state.listKey = key
				ent.VehicleName = "cityrp_item_corolla"
				expect(Photon.LookupVehiclesEntry(ent)).to.beNil()

				ent.PhotonVehicleName = key
				local entry = Photon.LookupVehiclesEntry(ent)
				expect(entry).to.beA("table")
				expect(entry.Name).to.equal("Kit " .. key)
				expect(ent.VehicleName).to.equal("cityrp_item_corolla")
			end
		},
		{
			name = "An unresolved PhotonVehicleName stops the lookup even when VehicleName resolves",
			func = function(state)
				local ent = NewEnt()
				state.ent = ent
				ent.IsGlideVehicle = true
				local key = "photon_glide_shadowed_" .. ent:EntIndex()
				list.Set("Vehicles", key, {
					Name = key,
					Model = "models/error.mdl",
					Class = "glide_fake",
					HasPhoton = true,
				})
				state.listKey = key
				ent.VehicleName = key
				ent.PhotonVehicleName = "no_such_pack"
				expect(Photon.LookupVehiclesEntry(ent)).to.beNil()
			end
		},
		{
			name = "LookupVehiclesEntry uses VehicleTable when VehicleName is unrelated",
			func = function(state)
				local ent = NewEnt()
				state.ent = ent
				ent.IsGlideVehicle = true
				local key = "photon_glide_table_" .. ent:EntIndex()
				local listed = {
					Name = key,
					Model = "models/error.mdl",
					Class = "glide_fake",
					HasPhoton = true,
					IsEMV = true,
				}
				list.Set("Vehicles", key, listed)
				state.listKey = key
				ent.VehicleName = "cityrp_item_focus_rs"
				ent.VehicleTable = listed
				expect(Photon.LookupVehiclesEntry(ent)).to.equal(listed)
			end
		}
	},

	afterEach = function(state)
		if state.restoreGetStored then
			scripted_ents.GetStored = state.restoreGetStored
			state.restoreGetStored = nil
		end
		if IsValid(state.ent) then state.ent:Remove() end
		if IsValid(state.chassis) then state.chassis:Remove() end
		if state.listKey then
			list.Set("Vehicles", state.listKey, nil)
		end
		state.ent = nil
		state.chassis = nil
		state.listKey = nil
	end,
}
