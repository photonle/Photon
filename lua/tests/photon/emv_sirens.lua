return {
	groupName = "EMVU.IncludeSiren",

	cases = {
		{
			name = "A siren file that fails to compile is isolated and logged instead of aborting",
			func = function(state)
				stub(_G, "CompileFile").returns(nil)
				stub(_G, "AddCSLuaFile")
				local photonError = stub(_G, "PhotonError")

				expect(function()
					EMVU.IncludeSiren("zz_broken_test_siren.lua")
				end).to.succeed()

				expect(photonError).was.called()
			end
		},
		{
			name = "A siren file that compiles but errors on run is isolated and logged instead of aborting",
			func = function(state)
				stub(_G, "CompileFile").returns(function()
					error("bad runtime code in siren file")
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
			name = "A siren file that compiles and runs successfully is not reported as an error",
			func = function(state)
				stub(_G, "CompileFile").returns(function() end)
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
