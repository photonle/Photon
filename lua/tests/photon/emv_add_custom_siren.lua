return {
	groupName = "EMVU.AddCustomSiren",

	cases = {
		{
			name = "A valid custom siren is added to the siren table",
			func = function(state)
				local before = #EMVU.GetSirenTable()

				EMVU.AddCustomSiren("gluatest_valid_siren", {
					Name = "Example Siren",
					Category = "Examples",
					Set = {
						{Name = "WAIL", Sound = "emv/sirens/example/example.wav", Icon = "wail"}
					}
				})

				expect(#EMVU.GetSirenTable()).to.equal(before + 1)
				expect(EMVU.GetSiren("gluatest_valid_siren").Name).to.equal("Example Siren")
			end
		},
		{
			name = "An invalid custom siren is rejected and logged instead of being added",
			func = function(state)
				local photonError = stub(_G, "PhotonError")
				local before = #EMVU.GetSirenTable()

				EMVU.AddCustomSiren("gluatest_invalid_siren", {
					Category = "Examples",
					Set = {
						{Name = "WAIL", Sound = "emv/sirens/example/example.wav"}
					}
				})

				expect(#EMVU.GetSirenTable()).to.equal(before)
				expect(photonError).was.called()
			end
		}
	}
}
