-- Keeps the copyable skeletons in the docs-site lighting-table topics honest.
--
-- Each topic under docs/ opens its first ```lua fence with a skeleton: a whole
-- file a reader can copy and fill in. These cases pull that block out of the
-- Markdown and compile it. The vehicle lights, vehicle emergency lights and
-- Auto component skeletons are also run, and what they hand to list.Set and
-- EMVU:AddAutoComponent is fed through the real Photon library, so a skeleton
-- that drifts from what Photon accepts goes red here rather than on a reader's
-- server. The EMV Meta skeleton is a bare local table with nothing to hand
-- over, so it is compiled with a return appended and its entries checked.
--
-- The renderer silently skips a light whose references do not resolve (a
-- position naming a missing meta, a frame naming a missing light), so a
-- skeleton with a dangling reference would load cleanly and draw nothing. The
-- cross-reference cases walk the tables each skeleton produces and name the
-- first reference that does not resolve.
--
-- The skeletons run in a sandbox environment whose __index is _G. Their side
-- effects (EMVU:AddAutoComponent, list.Set) are captured there instead of
-- reaching the real registries, and their global writes stay in the sandbox.
--
-- docs/ is not part of the shipped Lua; it is reachable because the runner
-- stages the whole working tree as an addon (addons/project in CI and locally).

local TOPICS = {
	PI = "vehicle-lights.md",
	Meta = "emv-meta.md",
	Vehicle = "vehicle-emergency-lights.md",
	Auto = "auto-components.md",
}

-- A vehicle name no real definition uses, for the cases that load the vehicle
-- EMV skeleton into the EMVU tables.
local VEHICLE = "photon_test_docs_skeleton_vehicle"

-- Every EMVU table EMVU:OverwriteIndex or EMVU:CalculateAuto writes under the
-- vehicle name, on either realm.
local VEHICLE_TABLES = {
	"Attributes", "LightMeta", "Positions", "Patterns", "Sequences", "Sections",
	"Lamps", "Props", "PresetIndex", "Selections", "Liveries", "SubMaterials",
	"AutoInsert", "AutoIndex", "DisabledRadars",
}

-- A vehicle name no real definition uses, for the case that loads the vehicle
-- lights skeleton into the Photon.Vehicles stores.
local PI_VEHICLE = "photon_test_docs_skeleton_pi"

-- The PI states Photon:OverwriteIndex copies, each into its own store under
-- Photon.Vehicles.States.
local PI_STATES = { "Headlights", "Brakes", "Blink_Left", "Blink_Right", "Reverse", "Running" }

-- Every Photon.Vehicles store Photon:OverwriteIndex can write under a name
-- (created in sh_photon_init.lua), as a function returning the store.
local PI_STORES = {}
for _, store in ipairs({ "Positions", "Meta", "WheelPositions", "WheelOptions", "Config", "StateMaterials" }) do
	PI_STORES[#PI_STORES + 1] = function() return Photon.Vehicles[store] end
end
for _, state in ipairs(PI_STATES) do
	PI_STORES[#PI_STORES + 1] = function() return Photon.Vehicles.States[state] end
end

-- The addon folder Photon is mounted from: "project" under both runners, found
-- by looking for Photon's own files so another folder name still resolves.
local function AddonRoot()
	local marker = "/lua/autorun/photon/sh_emv_vehicles.lua"
	if file.Exists("addons/project" .. marker, "GAME") then return "addons/project" end

	local _, dirs = file.Find("addons/*", "GAME", "nameasc")
	for _, dir in ipairs(dirs or {}) do
		if file.Exists("addons/" .. dir .. marker, "GAME") then return "addons/" .. dir end
	end

	error("Could not find the addon folder Photon is mounted from (looked for addons/*" .. marker .. ")")
end

-- The first block fenced with exactly ```lua in a Markdown string; label names
-- the source in errors.
local function Extract(markdown, label)
	local lines, inside = {}, false
	for line in (markdown .. "\n"):gmatch("(.-)\n") do
		line = line:gsub("\r$", "")
		if inside then
			if line:match("^```%s*$") then
				return table.concat(lines, "\n")
			end
			lines[#lines + 1] = line
		elseif line:match("^```lua%s*$") then
			inside = true
		end
	end

	if inside then
		error(label .. ": the first ```lua block is never closed")
	end
	error(label .. " has no block fenced with ```lua")
end

-- The skeleton in docs/<fileName>.
local function Skeleton(fileName)
	local path = AddonRoot() .. "/docs/" .. fileName
	local markdown = file.Read(path, "GAME")
	if not markdown then
		error("docs/" .. fileName .. " does not exist (read " .. path .. ")")
	end
	return Extract(markdown, "docs/" .. fileName)
end

-- The skeleton compiled, or an error carrying the compiler's message. suffix,
-- if given, is appended to the source first.
local function Compile(fileName, suffix)
	local fn = CompileString(Skeleton(fileName) .. (suffix or ""), "docs/" .. fileName, false)
	if not isfunction(fn) then
		error("docs/" .. fileName .. "'s skeleton does not compile: " .. tostring(fn))
	end
	return fn
end

-- Runs a topic's skeleton in a sandbox and returns what it handed to
-- EMVU:AddAutoComponent ({ component, name, base } per call) and list.Set
-- ({ category, key, entry } per call). A skeleton that errors fails the case
-- with its error.
local function Run(fileName)
	local fn = Compile(fileName)

	local autoCalls, listCalls = {}, {}
	local env = setmetatable({
		AddCSLuaFile = function() end,
		EMVU = setmetatable({
			AddAutoComponent = function(_, component, name, base)
				autoCalls[#autoCalls + 1] = { component = component, name = name, base = base }
			end,
		}, { __index = _G.EMVU }),
		list = setmetatable({
			Set = function(category, key, entry)
				listCalls[#listCalls + 1] = { category = category, key = key, entry = entry }
			end,
		}, { __index = _G.list }),
	}, { __index = _G })
	setfenv(fn, env)

	local ok, err = pcall(fn)
	if not ok then
		error("docs/" .. fileName .. "'s skeleton errors when run: " .. tostring(err))
	end
	return autoCalls, listCalls
end

-- The helpers below run outside the cases' environment, where GLuaTest's
-- expect is not visible, so they fail with error() instead.
local function Check(condition, message)
	if not condition then error(message, 2) end
end

-- A value as it would be written in Lua, for failure messages.
local function Show(value)
	if isstring(value) then return string.format("%q", value) end
	return tostring(value)
end

-- A function that fails with message, naming the topic label it came from.
-- The error carries the caller's file:line prefix: GLuaTest splits a failure on
-- ": " and drops the first piece as that position, so without one it would
-- drop the topic instead.
local function Failer(label)
	return function(message)
		error(label .. ": " .. message, 2)
	end
end

-- The call the Auto skeleton makes to EMVU:AddAutoComponent, with the
-- component's Name set the way EMVU:AddAutoComponent sets it.
local function AutoComponent()
	local autoCalls = Run(TOPICS.Auto)
	Check(#autoCalls == 1, "the Auto skeleton calls EMVU:AddAutoComponent " .. #autoCalls .. " times, not once")

	local call = autoCalls[1]
	Check(istable(call.component), "the Auto skeleton registers a " .. type(call.component) .. ", not a table")
	Check(isstring(call.name), "the Auto skeleton registers its component under a " .. type(call.name) .. ", not a string")
	call.component.Name = call.name

	return call
end

-- The list.Set call of the one vehicle a topic's skeleton lists.
local function ListEntry(key)
	local _, listCalls = Run(TOPICS[key])
	Check(#listCalls == 1, "docs/" .. TOPICS[key] .. "'s skeleton calls list.Set " .. #listCalls .. " times, not once")
	Check(istable(listCalls[1].entry), "docs/" .. TOPICS[key] .. "'s skeleton lists a " .. type(listCalls[1].entry) .. ", not a table")
	return listCalls[1]
end

-- The EMV table of the vehicle the vehicle EMV skeleton lists.
local function VehicleEMV()
	local entry = ListEntry("Vehicle").entry
	Check(istable(entry.EMV), "the vehicle EMV skeleton's vehicle has no EMV table")
	return entry.EMV
end

-- Why a colour fails to name an EMVU.Colors entry, or nil when it names one.
local function EMVColorProblem(color)
	if isstring(color) and istable(EMVU.Colors[color]) then return nil end
	return "which is not a key of EMVU.Colors"
end

-- As EMVColorProblem, but also accepting the "_N" placeholders an Auto
-- component resolves through its DefaultColors (EMVU:CalculateAuto).
local function AutoColorProblem(owner, component)
	return function(color)
		if not (isstring(color) and string.StartWith(color, "_")) then
			return EMVColorProblem(color)
		end

		local index = tonumber(string.sub(color, 2))
		local default = istable(component.DefaultColors) and index and component.DefaultColors[index]
		if not default then
			return "but " .. owner .. ".DefaultColors has no entry " .. string.sub(color, 2)
		end
		if EMVColorProblem(default) then
			return "whose " .. owner .. ".DefaultColors entry " .. Show(default) .. " is not a key of EMVU.Colors"
		end
		return nil
	end
end

-- Walks the Meta, Positions, Sections and Patterns tables a vehicle EMV table
-- or Auto component carries and fails on the first reference that does not
-- resolve. label names the topic, owner the table the four hang off (EMV,
-- COMPONENT), and colorProblem(color) says why a Sections colour is invalid,
-- or returns nil.
local function CheckLightTables(label, owner, tables, colorProblem)
	local Fail = Failer(label)

	for _, field in ipairs({ "Meta", "Positions", "Sections", "Patterns" }) do
		if not istable(tables[field]) then
			Fail(owner .. "." .. field .. " is a " .. type(tables[field]) .. ", not a table")
		end
	end
	local meta, positions, sections, patterns = tables.Meta, tables.Positions, tables.Sections, tables.Patterns

	local count = #positions
	for key in pairs(positions) do
		if not (isnumber(key) and key % 1 == 0 and key >= 1 and key <= count) then
			Fail(owner .. ".Positions has key " .. Show(key) .. ", outside the sequence 1.." .. count)
		end
	end
	for index = 1, count do
		local position = positions[index]
		if not istable(position) then
			Fail(owner .. ".Positions[" .. index .. "] is a " .. type(position) .. ", not a table")
		end
		if position[3] == nil or meta[position[3]] == nil then
			Fail(owner .. ".Positions[" .. index .. "] names meta " .. Show(position[3]) .. ", which " .. owner .. ".Meta does not have")
		end
	end

	for sectionName, frames in pairs(sections) do
		local where = owner .. ".Sections." .. tostring(sectionName)
		if not istable(frames) then Fail(where .. " is a " .. type(frames) .. ", not a table") end

		for frameIndex, frame in pairs(frames) do
			if not istable(frame) then
				Fail(where .. " frame " .. Show(frameIndex) .. " is a " .. type(frame) .. ", not a table")
			end
			for lightIndex, light in pairs(frame) do
				local lightWhere = where .. " frame " .. Show(frameIndex) .. " light " .. Show(lightIndex)
				if not istable(light) then
					Fail(lightWhere .. " is a " .. type(light) .. ", not a { position, colour } table")
				end
				if light[1] == nil or positions[light[1]] == nil then
					Fail(lightWhere .. " names position " .. Show(light[1]) .. ", which " .. owner .. ".Positions does not have")
				end
				local problem = colorProblem(light[2])
				if problem then
					Fail(lightWhere .. " has colour " .. Show(light[2]) .. ", " .. problem)
				end
			end
		end
	end

	for sectionName, sectionPatterns in pairs(patterns) do
		local where = owner .. ".Patterns." .. tostring(sectionName)
		local frames = sections[sectionName]
		if not istable(frames) then
			Fail(where .. " is for a section " .. owner .. ".Sections does not have")
		end
		if not istable(sectionPatterns) then Fail(where .. " is a " .. type(sectionPatterns) .. ", not a table") end

		for patternName, steps in pairs(sectionPatterns) do
			local patternWhere = where .. "." .. tostring(patternName)
			if not istable(steps) then Fail(patternWhere .. " is a " .. type(steps) .. ", not a table") end

			for step, value in pairs(steps) do
				local frameIndices = istable(value) and value or { value }
				for _, frameIndex in pairs(frameIndices) do
					local dark = frameIndex == 0 and not istable(value)
					if not dark and (frameIndex == nil or frames[frameIndex] == nil) then
						Fail(patternWhere .. " step " .. Show(step) .. " names frame " .. Show(frameIndex) .. ", which " .. owner .. ".Sections." .. tostring(sectionName) .. " does not have")
					end
				end
			end
		end
	end
end

-- Fails when a { [section] = patternName } map, found at where, names a
-- section or pattern patterns does not have.
local function CheckPatternMap(label, owner, where, map, patterns)
	local Fail = Failer(label)
	if not istable(map) then
		Fail(where .. " is a " .. type(map) .. ", not a table")
	end
	for sectionName, patternName in pairs(map) do
		local sectionPatterns = patterns[sectionName]
		if not istable(sectionPatterns) or sectionPatterns[patternName] == nil then
			Fail(where .. " plays pattern " .. Show(patternName) .. " on section " .. Show(sectionName) .. ", which " .. owner .. ".Patterns." .. tostring(sectionName) .. " does not have")
		end
	end
end

local function CompilesCase(key, label)
	return {
		name = "The " .. label .. " skeleton in docs/" .. TOPICS[key] .. " compiles as plain Lua",
		func = function()
			expect(Compile(TOPICS[key])).to.beA("function")
		end
	}
end

local function ListsVehicleCase(key, label)
	return {
		name = "The " .. label .. " skeleton lists its vehicle in the Vehicles category",
		func = function()
			expect(ListEntry(key).category).to.equal("Vehicles")
		end
	}
end

-- Photon:LoadVehicles and Photon:SpawnedVehicle key on HasPhoton and Name, and
-- EMVU on IsEMV; flags lists the boolean fields that must be true.
local function ListEntryFlagsCase(key, label, flags)
	return {
		name = "The " .. label .. " skeleton's list entry sets " .. table.concat(flags, " and ") .. " to true and Name to its list.Set key",
		func = function()
			local call = ListEntry(key)
			expect(call.entry.Name).to.beA("string")
			expect(call.entry.Name).to.equal(call.key)
			for _, flag in ipairs(flags) do
				expect(call.entry[flag]).to.beTrue()
			end
		end
	}
end

return {
	groupName = "Docs lighting table skeletons",

	beforeEach = function(state)
		state.saved = {}
		for _, tbl in ipairs(VEHICLE_TABLES) do
			if istable(EMVU[tbl]) then
				state.saved[tbl] = EMVU[tbl][VEHICLE]
			end
		end
		state.supported = EMVU.Configurations.Supported[VEHICLE]

		state.savedPI = {}
		for index, store in ipairs(PI_STORES) do
			state.savedPI[index] = store()[PI_VEHICLE]
		end
	end,

	afterEach = function(state)
		for _, tbl in ipairs(VEHICLE_TABLES) do
			if istable(EMVU[tbl]) then
				EMVU[tbl][VEHICLE] = state.saved[tbl]
			end
		end
		EMVU.Configurations.Supported[VEHICLE] = state.supported

		if state.autoId then
			EMVU.Auto[state.autoId] = state.autoPrevious
		end

		for index, store in ipairs(PI_STORES) do
			store()[PI_VEHICLE] = state.savedPI[index]
		end
	end,

	cases = {
		{
			name = "The skeleton extractor takes only the first ```lua block, past other fences and CRLF line ends",
			func = function()
				local markdown = table.concat({
					"# Topic",
					"```",
					"not lua",
					"```",
					"```lua",
					"local first = 1",
					"local second = 2",
					"```",
					"",
					"```lua",
					"local later = 3",
					"```",
				}, "\r\n")
				expect(Extract(markdown, "inline")).to.equal("local first = 1\nlocal second = 2")
			end
		},

		CompilesCase("PI", "vehicle lights"),
		CompilesCase("Meta", "EMV Meta"),
		CompilesCase("Vehicle", "vehicle emergency lights"),
		CompilesCase("Auto", "Auto component"),

		{
			name = "The Auto component skeleton registers its one component under a non-empty name",
			func = function()
				expect(AutoComponent().name).toNot.equal("")
			end
		},
		{
			name = "The Auto component skeleton stands alone, with no Base",
			func = function()
				local call = AutoComponent()
				expect(call.component.Base).to.beNil()
				expect(call.base).to.beNil()
			end
		},
		{
			name = "The Auto component skeleton's component passes EMVU.ValidateAutoComponent",
			func = function()
				local valid, reason = EMVU.ValidateAutoComponent(AutoComponent().component)
				expect(reason).to.beNil()
				expect(valid).to.beTrue()
			end
		},
		{
			name = "Every light, frame and mode pattern the Auto component skeleton references exists",
			func = function()
				local label = "docs/" .. TOPICS.Auto
				local component = AutoComponent().component
				CheckLightTables(label, "COMPONENT", component, AutoColorProblem("COMPONENT", component))

				-- Primary lookups get the placement's Phase appended; the skeleton
				-- places no Phase, so the plain name is what is looked up.
				expect(component.Modes).to.beA("table")
				for _, mode in ipairs({ "Primary", "Auxiliary" }) do
					local stages = component.Modes[mode]
					expect(stages).to.beA("table")
					for stage, map in pairs(stages) do
						CheckPatternMap(label, "COMPONENT", "COMPONENT.Modes." .. mode .. "." .. tostring(stage), map, component.Patterns)
					end
				end
			end
		},

		ListsVehicleCase("PI", "vehicle lights"),
		ListsVehicleCase("Vehicle", "vehicle emergency lights"),
		ListEntryFlagsCase("PI", "vehicle lights", { "HasPhoton" }),
		ListEntryFlagsCase("Vehicle", "vehicle emergency lights", { "HasPhoton", "IsEMV" }),

		{
			name = "The vehicle lights skeleton's Photon table loads through Photon:OverwriteIndex on the server",
			func = function()
				local pi = ListEntry("PI").entry.Photon
				expect(pi).to.beA("table")
				expect(pi.States).to.beA("table")

				local ok, err = pcall(Photon.OverwriteIndex, Photon, PI_VEHICLE, pi)
				expect(err).to.beNil()
				expect(ok).to.beTrue()

				expect(Photon.Vehicles.Positions[PI_VEHICLE]).to.equal(pi.Positions)
				expect(Photon.Vehicles.Meta[PI_VEHICLE]).to.equal(pi.Meta)
				for _, stateName in ipairs(PI_STATES) do
					expect(pi.States[stateName]).to.beA("table")
					expect(Photon.Vehicles.States[stateName][PI_VEHICLE]).to.equal(pi.States[stateName])
				end
			end
		},
		{
			-- Photon_RenderLights routes a state entry whose key starts with "_"
			-- to SetStateMaterial (cl_photon_meta.lua) and draws every other one
			-- as { position, colour, [brightness] }.
			name = "Every meta, position, colour and state material the vehicle lights skeleton's states reference exists",
			func = function()
				local label = "docs/" .. TOPICS.PI
				local Fail = Failer(label)

				local pi = ListEntry("PI").entry.Photon
				expect(pi).to.beA("table")
				expect(pi.Meta).to.beA("table")
				expect(pi.Positions).to.beA("table")
				expect(pi.States).to.beA("table")

				for index, position in pairs(pi.Positions) do
					if not istable(position) or position[3] == nil or pi.Meta[position[3]] == nil then
						Fail("PI.Positions[" .. Show(index) .. "] names meta " .. Show(istable(position) and position[3]) .. ", which PI.Meta does not have")
					end
				end

				for stateName, entries in pairs(pi.States) do
					if not istable(entries) then Fail("PI.States." .. tostring(stateName) .. " is a " .. type(entries) .. ", not a table") end

					for index, entry in pairs(entries) do
						local where = "PI.States." .. tostring(stateName) .. " entry " .. Show(index)
						if not istable(entry) then Fail(where .. " is a " .. type(entry) .. ", not a table") end

						if isstring(entry[1]) and string.StartWith(entry[1], "_") then
							local materials = pi.StateMaterials
							if not istable(materials) or materials[string.sub(entry[1], 2)] == nil then
								Fail(where .. " names state material " .. Show(entry[1]) .. ", which PI.StateMaterials does not have")
							end
						else
							if entry[1] == nil or pi.Positions[entry[1]] == nil then
								Fail(where .. " names position " .. Show(entry[1]) .. ", which PI.Positions does not have")
							end
							local problem = EMVColorProblem(entry[2])
							if problem then
								Fail(where .. " has colour " .. Show(entry[2]) .. ", " .. problem)
							end
							if entry[3] ~= nil and not isnumber(entry[3]) then
								Fail(where .. " has brightness " .. Show(entry[3]) .. ", which is not a number")
							end
						end
					end
				end
			end
		},

		{
			-- cl_photon_eng.lua reads Sprite, W and H unguarded, reads AngleOffset
			-- unless NoLegacy is set, and subtracts DirOffset whenever DirAxis is
			-- set. The skeleton is a bare local, so a return is appended to read it.
			name = "Every entry in the EMV Meta skeleton has a Sprite, numeric W and H, an AngleOffset or NoLegacy, and a DirOffset with its DirAxis",
			func = function()
				local label = "docs/" .. TOPICS.Meta
				local Fail = Failer(label)

				local meta = Compile(TOPICS.Meta, "\nreturn Meta")()
				expect(meta).to.beA("table")
				expect(next(meta)).toNot.beNil()

				for name, entry in pairs(meta) do
					local where = "Meta." .. tostring(name)
					if not istable(entry) then Fail(where .. " is a " .. type(entry) .. ", not a table") end
					if not isstring(entry.Sprite) then Fail(where .. " has no Sprite") end
					if not isnumber(entry.W) then Fail(where .. " has W " .. Show(entry.W) .. ", not a number") end
					if not isnumber(entry.H) then Fail(where .. " has H " .. Show(entry.H) .. ", not a number") end
					if entry.AngleOffset == nil and entry.NoLegacy ~= true then
						Fail(where .. " has neither an AngleOffset nor NoLegacy = true")
					end
					if entry.DirAxis ~= nil and entry.DirOffset == nil then
						Fail(where .. " sets DirAxis but no DirOffset")
					end
				end
			end
		},

		{
			name = "Every EMV.Auto entry in the vehicle EMV skeleton has a string ID, a Vector Pos and an Angle Ang",
			func = function()
				local emv = VehicleEMV()
				expect(emv.Auto).to.beA("table")
				expect(#emv.Auto >= 1).to.beTrue()

				for _, auto in ipairs(emv.Auto) do
					expect(auto.ID).to.beA("string")
					expect(isvector(auto.Pos)).to.beTrue()
					expect(isangle(auto.Ang)).to.beTrue()
				end
			end
		},
		{
			name = "Every light, frame and sequence pattern the vehicle EMV skeleton references exists",
			func = function()
				local label = "docs/" .. TOPICS.Vehicle
				local emv = VehicleEMV()
				CheckLightTables(label, "EMV", emv, EMVColorProblem)

				expect(emv.Sequences).to.beA("table")
				for _, group in ipairs({ "Sequences", "Traffic" }) do
					local sequences = emv.Sequences[group]
					expect(sequences).to.beA("table")
					for index, sequence in ipairs(sequences) do
						local where = "EMV.Sequences." .. group .. "[" .. index .. "] (" .. tostring(sequence.Name) .. ").Components"
						CheckPatternMap(label, "EMV", where, sequence.Components, emv.Patterns)
					end
				end
			end
		},
		{
			name = "The vehicle EMV skeleton's EMV.Auto places the component the Auto skeleton registers",
			func = function()
				local name = AutoComponent().name
				local emv = VehicleEMV()
				expect(emv.Auto).to.beA("table")
				expect(#emv.Auto >= 1).to.beTrue()

				for _, auto in ipairs(emv.Auto) do
					expect(auto.ID).to.equal(name)
				end
			end
		},
		{
			name = "The vehicle EMV skeleton's EMV table loads through EMVU:OverwriteIndex on the server",
			func = function()
				local emv = VehicleEMV()

				local ok, err = pcall(EMVU.OverwriteIndex, EMVU, VEHICLE, emv)
				expect(err).to.beNil()
				expect(ok).to.beTrue()

				expect(EMVU.LightMeta[VEHICLE]).to.equal(emv.Meta)
				expect(EMVU.Sequences[VEHICLE]).to.equal(emv.Sequences)
				expect(EMVU.AutoIndex[VEHICLE]).to.equal(emv.Auto)
			end
		},
		{
			-- CalculateAuto only expands components on the client; the realm flags
			-- are flipped for the call, as emv_auto_preset_components.lua does.
			name = "The vehicle EMV skeleton's EMV.Auto expands the Auto skeleton's component in CalculateAuto's client half",
			func = function(state)
				local call = AutoComponent()
				local component, name = call.component, call.name
				local emv = VehicleEMV()

				state.autoId = name
				state.autoPrevious = EMVU.Auto[name]
				EMVU.Auto[name] = component

				local ok, err = pcall(EMVU.OverwriteIndex, EMVU, VEHICLE, emv)
				expect(err).to.beNil()
				expect(ok).to.beTrue()
				EMVU.Positions[VEHICLE] = emv.Positions or {}

				local wasServer, wasClient = _G.SERVER, _G.CLIENT
				_G.SERVER, _G.CLIENT = false, true
				ok, err = pcall(EMVU.CalculateAuto, EMVU, VEHICLE, emv.Auto, emv.AutoInsert)
				_G.SERVER, _G.CLIENT = wasServer, wasClient
				expect(err).to.beNil()
				expect(ok).to.beTrue()

				for index = 1, #emv.Auto do
					for id in pairs(component.Meta) do
						expect(EMVU.LightMeta[VEHICLE][tostring(id) .. "_" .. index]).to.beA("table")
					end
				end
			end
		},
	}
}
