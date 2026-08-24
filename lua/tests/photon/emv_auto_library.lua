return {
	groupName = "EMVU.Auto component library",

	cases = {
		{
			-- Guards against the whole library silently failing to load. Without this,
			-- the validation case below passes vacuously on an empty EMVU.Auto - which
			-- is exactly what happened when every component file errored on its bare
			-- AddCSLuaFile() call and the suite still reported green.
			name = "Every component file contributes at least one registered component",
			func = function(state)
				local files = file.Find("autorun/photon/library/auto/*.lua", "LUA")
				local registered = table.Count(EMVU.Auto)

				expect(#files > 0).to.beTrue()
				expect(registered >= #files).to.beTrue()
			end
		},
		{
			name = "Every component registered by the stock library passes EMVU.ValidateAutoComponent",
			func = function(state)
				local failures = {}

				for name, component in pairs(EMVU.Auto) do
					local valid, err = EMVU.ValidateAutoComponent(component)
					if not valid then
						table.insert(failures, tostring(name) .. " (" .. tostring(component.Source) .. "): " .. tostring(err))
					end
				end

				expect(table.concat(failures, "\n")).to.equal("")
			end
		}
	}
}
