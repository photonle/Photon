-- Keeps the copyable skeletons in the docs-site lighting-table topics honest.
--
-- Each topic under docs/ opens its first ```lua fence with a skeleton: a whole
-- file a reader can copy and fill in. These cases pull that block out of the
-- Markdown and compile it. The vehicle lights, vehicle emergency lights and
-- Auto component skeletons are also run, and what they hand to list.Set and
-- EMVU:AddAutoComponent is fed through the real Photon library, so a skeleton
-- that drifts from what Photon accepts goes red here rather than on a reader's
-- server. The EMV Meta skeleton is a bare table with nothing to hand over, so
-- it is only compiled.
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

-- The skeleton compiled, or an error carrying the compiler's message.
local function Compile(fileName)
	local fn = CompileString(Skeleton(fileName), "docs/" .. fileName, false)
	if not isfunction(fn) then
		error("docs/" .. fileName .. "'s skeleton does not compile: " .. tostring(fn))
	end
	return fn
end

-- Runs a topic's skeleton in a sandbox. Returns whether it ran, its error if
-- not, and what it handed to EMVU:AddAutoComponent and list.Set, one { ... } of
-- arguments per call.
local function Execute(fileName)
	local fn = Compile(fileName)

	local autoCalls, listCalls = {}, {}
	local env = setmetatable({
		AddCSLuaFile = function() end,
		EMVU = setmetatable({
			AddAutoComponent = function(_, component, name, base)
				autoCalls[#autoCalls + 1] = { component, name, base }
			end,
		}, { __index = _G.EMVU }),
		list = setmetatable({
			Set = function(category, name, data)
				listCalls[#listCalls + 1] = { category, name, data }
			end,
		}, { __index = _G.list }),
	}, { __index = _G })
	setfenv(fn, env)

	local ok, err = pcall(fn)
	return ok, err, autoCalls, listCalls
end

-- As Execute, but a skeleton that errors fails the case with its error.
local function Run(fileName)
	local ok, err, autoCalls, listCalls = Execute(fileName)
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

-- The component the Auto skeleton registers and the name it registers it
-- under, with Name set the way EMVU:AddAutoComponent sets it.
local function AutoComponent()
	local autoCalls = Run(TOPICS.Auto)
	Check(#autoCalls == 1, "the Auto skeleton calls EMVU:AddAutoComponent " .. #autoCalls .. " times, not once")

	local component, name = autoCalls[1][1], autoCalls[1][2]
	Check(istable(component), "the Auto skeleton registers a " .. type(component) .. ", not a table")
	Check(isstring(name), "the Auto skeleton registers its component under a " .. type(name) .. ", not a string")
	component.Name = name

	return component, name
end

-- The key and entry of the one vehicle a topic's skeleton lists.
local function ListEntry(key)
	local _, listCalls = Run(TOPICS[key])
	Check(#listCalls == 1, "docs/" .. TOPICS[key] .. "'s skeleton calls list.Set " .. #listCalls .. " times, not once")
	Check(istable(listCalls[1][3]), "docs/" .. TOPICS[key] .. "'s skeleton lists a " .. type(listCalls[1][3]) .. ", not a table")
	return listCalls[1][2], listCalls[1][3]
end

-- The EMV table of the vehicle the vehicle EMV skeleton lists.
local function VehicleEMV()
	local _, entry = ListEntry("Vehicle")
	Check(istable(entry.EMV), "the vehicle EMV skeleton's vehicle has no EMV table")
	return entry.EMV
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
		name = "The " .. label .. " skeleton lists exactly one vehicle under Vehicles",
		func = function()
			local _, listCalls = Run(TOPICS[key])
			expect(#listCalls).to.equal(1)
			expect(listCalls[1][1]).to.equal("Vehicles")
			expect(listCalls[1][2]).to.beA("string")
			expect(listCalls[1][3]).to.beA("table")
		end
	}
end

-- Photon:LoadVehicles and Photon:SpawnedVehicle key on HasPhoton and Name, and
-- EMVU on IsEMV; flags lists the boolean fields that must be true.
local function ListEntryFlagsCase(key, label, flags)
	return {
		name = "The " .. label .. " skeleton's list entry sets " .. table.concat(flags, " and ") .. " to true and Name to its list.Set key",
		func = function()
			local listKey, entry = ListEntry(key)
			expect(entry.Name).to.beA("string")
			expect(entry.Name).to.equal(listKey)
			for _, flag in ipairs(flags) do
				expect(entry[flag]).to.beTrue()
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
			name = "The Auto component skeleton registers exactly one component under a string name",
			func = function()
				local autoCalls = Run(TOPICS.Auto)
				expect(#autoCalls).to.equal(1)
				expect(autoCalls[1][1]).to.beA("table")
				expect(autoCalls[1][2]).to.beA("string")
				expect(autoCalls[1][2]).toNot.equal("")
			end
		},
		{
			name = "The Auto component skeleton stands alone, with no Base",
			func = function()
				local autoCalls = Run(TOPICS.Auto)
				expect(#autoCalls).to.equal(1)
				expect(autoCalls[1][1].Base).to.beNil()
				expect(autoCalls[1][3]).to.beNil()
			end
		},
		{
			name = "The Auto component skeleton's component passes EMVU.ValidateAutoComponent",
			func = function()
				local component = AutoComponent()
				expect(component.Base).to.beNil()

				local valid, reason = EMVU.ValidateAutoComponent(component)
				expect(reason).to.beNil()
				expect(valid).to.beTrue()
			end
		},

		ListsVehicleCase("PI", "vehicle lights"),
		ListsVehicleCase("Vehicle", "vehicle emergency lights"),
		ListEntryFlagsCase("PI", "vehicle lights", { "HasPhoton" }),
		ListEntryFlagsCase("Vehicle", "vehicle emergency lights", { "HasPhoton", "IsEMV" }),

		{
			name = "The vehicle lights skeleton's Photon table loads through Photon:OverwriteIndex on the server",
			func = function()
				local _, entry = ListEntry("PI")
				local pi = entry.Photon
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
			name = "The vehicle EMV skeleton's EMV.Auto places the component the Auto skeleton registers",
			func = function()
				local _, name = AutoComponent()
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
				local component, name = AutoComponent()
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
