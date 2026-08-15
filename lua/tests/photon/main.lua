return {
	groupName = "Photon Startup",

	cases = {
		{
			name = "Photon global table is registered",
			func = function(state)
				expect(type(Photon)).to.equal("table")
			end
		}
	}
}
