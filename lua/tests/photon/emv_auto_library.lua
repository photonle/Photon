return {
	groupName = "EMVU.Auto component library",

	cases = {
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
