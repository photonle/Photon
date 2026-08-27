-- Both ways an indicator gets cancelled, each of which has silently regressed
-- before.
--
-- Over the network: the client cancels by sending CAR_BLINKER_NONE, either from
-- the auto-cancel in cl_photon_hooks.lua (driving straight for a second above
-- speed 25) or from an explicit "none" bind. A server guard that accepts only
-- the three active states drops every one of those, so the indicator latches on
-- and can only be cleared by pressing the same direction again.
--
-- Through the accessors: CAR_TurnLeft/TurnRight/Hazards take true to set, false
-- to clear and nil to query. Testing the argument for non-nil rather than for
-- true turns the signal on when asked to turn it off.

local function NewCar()
	local ent = ents.Create("prop_physics")
	ent:SetModel("models/error.mdl")
	ent:Spawn()
	Photon:SetupCar(ent, "gluatest_car")
	return ent
end

return {
	groupName = "Photon signal reset",

	cases = {
		{
			name = "the cancel value is accepted by the net guard",
			func = function()
				expect(Photon.Net.IsValidSignal(CAR_BLINKER_NONE)).to.beTrue()
			end
		},
		{
			name = "every active signal is accepted by the net guard",
			func = function()
				expect(Photon.Net.IsValidSignal(CAR_TURNING_LEFT)).to.beTrue()
				expect(Photon.Net.IsValidSignal(CAR_TURNING_RIGHT)).to.beTrue()
				expect(Photon.Net.IsValidSignal(CAR_HAZARD)).to.beTrue()
			end
		},
		{
			name = "out of range values are rejected",
			func = function()
				expect(Photon.Net.IsValidSignal(CAR_BLINKER_HAZARD + 1)).to.beFalse()
				expect(Photon.Net.IsValidSignal(-1)).to.beFalse()
			end
		},
		{
			name = "cancelling clears a signal that is already on",
			func = function(state)
				local car = NewCar()
				state.car = car

				car:CAR_Signal(CAR_TURNING_LEFT)
				expect(car:GetPhotonNet_CurrentSignal(CAR_BLINKER_NONE)).to.equal(CAR_TURNING_LEFT)

				car:CAR_Signal(CAR_BLINKER_NONE)
				expect(car:GetPhotonNet_CurrentSignal(CAR_TURNING_LEFT)).to.equal(CAR_BLINKER_NONE)
			end
		},
		{
			name = "passing true turns the signal on",
			func = function(state)
				local car = NewCar()
				state.car = car

				expect(car:CAR_TurnLeft(true)).to.beTrue()
				expect(car:GetPhotonNet_CurrentSignal(CAR_BLINKER_NONE)).to.equal(CAR_TURNING_LEFT)
			end
		},
		{
			name = "passing false clears the signal instead of setting it",
			func = function(state)
				local car = NewCar()
				state.car = car

				car:CAR_TurnLeft(true)
				expect(car:CAR_TurnLeft(false)).to.beFalse()
				expect(car:GetPhotonNet_CurrentSignal(CAR_TURNING_LEFT)).to.equal(CAR_BLINKER_NONE)
			end
		},
		{
			name = "cancelling one indicator leaves another running",
			func = function(state)
				local car = NewCar()
				state.car = car

				car:CAR_TurnRight(true)
				car:CAR_TurnLeft(false)
				expect(car:GetPhotonNet_CurrentSignal(CAR_BLINKER_NONE)).to.equal(CAR_TURNING_RIGHT)

				car:CAR_Hazards(false)
				expect(car:GetPhotonNet_CurrentSignal(CAR_BLINKER_NONE)).to.equal(CAR_TURNING_RIGHT)
			end
		},
		{
			name = "passing nil only reports the current state",
			func = function(state)
				local car = NewCar()
				state.car = car

				car:CAR_TurnRight(true)
				expect(car:CAR_TurnRight()).to.beTrue()
				expect(car:CAR_TurnLeft()).to.beFalse()
				expect(car:GetPhotonNet_CurrentSignal(CAR_BLINKER_NONE)).to.equal(CAR_TURNING_RIGHT)
			end
		},
	},

	afterEach = function(state)
		if IsValid(state.car) then state.car:Remove() end
		state.car = nil
	end,
}
