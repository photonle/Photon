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
				-- prop_physics class after spawn; flag alone is enough for the Glide branch
				expect(Photon.ResolveVehicleListClass(ent)).to.equal(ent:GetClass())
			end
		}
	},

	afterEach = function(state)
		if IsValid(state.ent) then state.ent:Remove() end
		if IsValid(state.chassis) then state.chassis:Remove() end
		state.ent = nil
		state.chassis = nil
	end,
}
