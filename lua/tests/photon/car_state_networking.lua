-- The client reads regular (non-emergency) lighting state exclusively through
-- the SimpleNet accessors in photon/cl_meta.lua (GetPhotonNet_*). The server
-- writes that state through the CAR_* accessors installed by Photon:SetupCar.
-- If a CAR_* setter only writes its legacy NW2 var, the value never reaches
-- any client that is not locally predicting it, so the light is invisible to
-- everyone except the driver.

local function NewCar()
	local ent = ents.Create("prop_physics")
	ent:SetModel("models/error.mdl")
	ent:Spawn()
	Photon:SetupCar(ent, "gluatest_car")
	return ent
end

return {
	groupName = "Photon regular lighting networking",

	cases = {
		{
			name = "CAR_Braking publishes to the value the client reads",
			func = function(state)
				local car = NewCar()
				state.car = car
				expect(IsValid(car)).to.beTrue()

				car:CAR_Braking(true)
				expect(car:GetPhotonNet_Braking(false)).to.beTrue()

				car:CAR_Braking(false)
				expect(car:GetPhotonNet_Braking(true)).to.beFalse()
			end
		},
		{
			name = "CAR_Reversing publishes to the value the client reads",
			func = function(state)
				local car = NewCar()
				state.car = car

				car:CAR_Reversing(true)
				expect(car:GetPhotonNet_Reversing(false)).to.beTrue()

				car:CAR_Reversing(false)
				expect(car:GetPhotonNet_Reversing(true)).to.beFalse()
			end
		},
		{
			name = "CAR_Running publishes to the value the client reads",
			func = function(state)
				local car = NewCar()
				state.car = car

				car:CAR_Running(true)
				expect(car:GetPhotonNet_Running(false)).to.beTrue()
			end
		},
		{
			name = "CAR_Signal publishes to the value the client reads",
			func = function(state)
				local car = NewCar()
				state.car = car

				car:CAR_Signal(CAR_TURNING_LEFT)
				expect(car:GetPhotonNet_CurrentSignal(CAR_BLINKER_NONE)).to.equal(CAR_TURNING_LEFT)

				car:CAR_Signal(CAR_TURNING_RIGHT)
				expect(car:GetPhotonNet_CurrentSignal(CAR_BLINKER_NONE)).to.equal(CAR_TURNING_RIGHT)

				car:CAR_StopSignals()
				expect(car:GetPhotonNet_CurrentSignal(CAR_TURNING_LEFT)).to.equal(CAR_BLINKER_NONE)
			end
		},
		{
			name = "CAR_Hazards publishes to the value the client reads",
			func = function(state)
				local car = NewCar()
				state.car = car

				car:CAR_Hazards(true)
				expect(car:GetPhotonNet_CurrentSignal(CAR_BLINKER_NONE)).to.equal(CAR_HAZARD)
			end
		},
	},

	afterEach = function(state)
		if IsValid(state.car) then state.car:Remove() end
		state.car = nil
	end,
}
