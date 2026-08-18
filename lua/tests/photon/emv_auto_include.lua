return {
	groupName = "EMVU.IncludeAutoComponent",

	cases = {
		{
			name = "A component file that fails to compile is isolated and logged instead of aborting",
			func = function(state)
				stub(_G, "CompileFile").returns(nil)
				stub(_G, "AddCSLuaFile")
				local photonError = stub(_G, "PhotonError")

				expect(function()
					EMVU.IncludeAutoComponent("zz_broken_test_component.lua")
				end).to.succeed()

				expect(photonError).was.called()
			end
		},
		{
			name = "A component file that compiles but errors on run is isolated and logged instead of aborting",
			func = function(state)
				stub(_G, "CompileFile").returns(function()
					error("bad runtime code in component file")
				end)
				stub(_G, "AddCSLuaFile")
				local photonError = stub(_G, "PhotonError")

				expect(function()
					EMVU.IncludeAutoComponent("zz_broken_test_component.lua")
				end).to.succeed()

				expect(photonError).was.called()
			end
		},
		{
			name = "A component file that compiles and runs successfully is not reported as an error",
			func = function(state)
				stub(_G, "CompileFile").returns(function() end)
				stub(_G, "AddCSLuaFile")
				local photonError = stub(_G, "PhotonError")

				expect(function()
					EMVU.IncludeAutoComponent("zz_working_test_component.lua")
				end).to.succeed()

				expect(photonError).toNot.called()
			end
		}
	}
}
