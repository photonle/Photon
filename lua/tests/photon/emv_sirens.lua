return {
	groupName = "EMVU.IncludeSiren",

	cases = {
		{
			name = "A siren file that errors on include is isolated and logged instead of aborting",
			func = function(state)
				stub(_G, "include").with(function(path)
					error("bad syntax in " .. path)
				end)
				stub(_G, "AddCSLuaFile")
				local photonError = stub(_G, "PhotonError")

				expect(function()
					EMVU.IncludeSiren("zz_broken_test_siren.lua")
				end).to.succeed()

				expect(photonError).was.called()
			end
		},
		{
			name = "A siren file that includes successfully is not reported as an error",
			func = function(state)
				stub(_G, "include").returns(true)
				stub(_G, "AddCSLuaFile")
				local photonError = stub(_G, "PhotonError")

				expect(function()
					EMVU.IncludeSiren("zz_working_test_siren.lua")
				end).to.succeed()

				expect(photonError).toNot.called()
			end
		}
	}
}
