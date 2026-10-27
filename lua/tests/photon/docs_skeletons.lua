-- Keeps the copyable skeletons in the docs-site lighting-table topics honest.
--
-- Each topic under docs/ opens its first ```lua fence with a skeleton: a whole
-- file a reader can copy and fill in. These cases pull that block out of the
-- Markdown, compile it, and run it against the real Photon library, so a
-- skeleton that drifts from what Photon accepts goes red here rather than on a
-- reader's server.
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

-- The first block fenced with exactly ```lua in docs/<fileName>.
local function Skeleton(fileName)
	local path = AddonRoot() .. "/docs/" .. fileName
	local markdown = file.Read(path, "GAME")
	if not markdown then
		error("docs/" .. fileName .. " does not exist (read " .. path .. ")")
	end

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
		error("docs/" .. fileName .. ": the first ```lua block is never closed")
	end
	error("docs/" .. fileName .. " has no block fenced with ```lua")
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

-- The EMV table of the vehicle the vehicle EMV skeleton lists.
local function VehicleEMV()
	local _, listCalls = Run(TOPICS.Vehicle)
	Check(#listCalls == 1, "the vehicle EMV skeleton calls list.Set " .. #listCalls .. " times, not once")
	Check(istable(listCalls[1][3]), "the vehicle EMV skeleton lists a " .. type(listCalls[1][3]) .. ", not a table")

	local emv = listCalls[1][3].EMV
	Check(istable(emv), "the vehicle EMV skeleton's vehicle has no EMV table")
	return emv
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
	end,

	cases = {
		CompilesCase("PI", "vehicle lights"),
		CompilesCase("Meta", "EMV Meta"),
		CompilesCase("Vehicle", "vehicle emergency lights"),
		CompilesCase("Auto", "Auto component"),

		{
			name = "The EMV Meta skeleton runs without error",
			func = function()
				local ok, err = Execute(TOPICS.Meta)
				expect(err).to.beNil()
				expect(ok).to.beTrue()
			end
		},

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
