-- Glide compatibility helpers: seat→chassis resolution and forward-axis selection.

local function NewEnt()
	local ent = ents.Create("prop_physics")
	ent:SetModel("models/error.mdl")
	ent:Spawn()
	return ent
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
			name = "LookupVehiclesEntry ignores model match on bare Glide SENTs",
			func = function(state)
				local ent = NewEnt()
				state.ent = ent
				ent.IsGlideVehicle = true
				ent:SetModel("models/error.mdl")
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
			name = "LookupVehiclesEntry still resolves Glide when VehicleName is set",
			func = function(state)
				local ent = NewEnt()
				state.ent = ent
				ent.IsGlideVehicle = true
				ent:SetModel("models/error.mdl")
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
			name = "RecoverVehicleName ignores CityRP item VehicleName with matching chassis model",
			func = function(state)
				local ent = NewEnt()
				state.ent = ent
				ent.IsGlideVehicle = true
				ent:SetModel("models/error.mdl")
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
				expect(Photon.HasExplicitVehicleIdentity(ent)).to.beFalse()
				expect(Photon.LookupVehiclesEntry(ent)).to.beNil()
				expect(Photon:RecoverVehicleName(ent)).to.beFalse()
			end
		},
		{
			name = "LookupVehiclesEntry uses VehicleTable when VehicleName is a CityRP item id",
			func = function(state)
				local ent = NewEnt()
				state.ent = ent
				ent.IsGlideVehicle = true
				ent:SetModel("models/error.mdl")
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
				local entry = Photon.LookupVehiclesEntry(ent)
				expect(entry).to.beA("table")
				expect(entry.Name).to.equal(key)
				expect(Photon.HasExplicitVehicleIdentity(ent)).to.beTrue()
			end
		},
		{
			name = "UsesNativeVehicleLights is true for Glide",
			func = function(state)
				local ent = NewEnt()
				state.ent = ent
				ent.IsGlideVehicle = true
				expect(Photon.UsesNativeVehicleLights(ent)).to.beTrue()
			end
		},
		{
			name = "UsesNativeVehicleLights is false for stock",
			func = function(state)
				local ent = NewEnt()
				state.ent = ent
				expect(Photon.UsesNativeVehicleLights(ent)).to.beFalse()
			end
		},
		{
			name = "CycleGlideHeadlights advances Off to On",
			func = function(state)
				local ent = NewEnt()
				state.ent = ent
				ent.IsGlideVehicle = true
				ent._hs = 0
				ent.GetHeadlightState = function(self) return self._hs end
				ent.SetHeadlightState = function(self, s) self._hs = s end
				ent.SetPhotonNet_Blackout = function() end
				Photon.CycleGlideHeadlights(ent)
				expect(ent._hs).to.equal(1)
			end
		},
		{
			name = "ApplyGlideELSHeadlights does not force off from latched blackout alone",
			func = function(state)
				local ent = NewEnt()
				state.ent = ent
				ent.IsGlideVehicle = true
				ent._hs = 1
				ent.GetHeadlightState = function(self) return self._hs end
				ent.SetHeadlightState = function(self, s) self._hs = s end
				ent.Photon_Blackout = function() return true end
				ent.HasPhotonELS = function() return false end
				Photon.ApplyGlideELSHeadlights(ent)
				expect(ent._hs).to.equal(1)
			end
		},
		{
			name = "SyncGlideTurnSignals writes TurnSignalState",
			func = function(state)
				local ent = NewEnt()
				state.ent = ent
				ent.IsGlideVehicle = true
				ent._sig = 0
				ent.SetTurnSignalState = function(self, s) self._sig = s end
				Photon.SyncGlideTurnSignals(ent, 3)
				expect(ent._sig).to.equal(3)
			end
		},
	},

	afterEach = function(state)
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
