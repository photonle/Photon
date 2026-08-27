-- The client cancels a turn signal by sending CAR_BLINKER_NONE: either from the
-- auto-cancel in cl_photon_hooks.lua (driving straight for a second above speed
-- 25) or from an explicit "none" bind. A server-side guard that only accepts the
-- three active states drops every one of those, so the indicator latches on and
-- can only be cleared by pressing the same direction again.

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
				local car = ents.Create("prop_physics")
				car:SetModel("models/error.mdl")
				car:Spawn()
				Photon:SetupCar(car, "gluatest_car")
				state.car = car

				car:CAR_Signal(CAR_TURNING_LEFT)
				expect(car:GetPhotonNet_CurrentSignal(CAR_BLINKER_NONE)).to.equal(CAR_TURNING_LEFT)

				car:CAR_Signal(CAR_BLINKER_NONE)
				expect(car:GetPhotonNet_CurrentSignal(CAR_TURNING_LEFT)).to.equal(CAR_BLINKER_NONE)
			end
		},
	},

	afterEach = function(state)
		if IsValid(state.car) then state.car:Remove() end
		state.car = nil
	end,
}
