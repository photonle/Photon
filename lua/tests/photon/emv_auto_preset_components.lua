-- EMVU.LoadModeData only gives the Alert, Braking, Reverse and Park sequences a
-- Preset_Components table when it creates them itself. A vehicle that defines
-- one of them leaves it without that table, and EMVU:CalculateAuto then indexed
-- it while copying an auto component's ALERT/BRAKE/REVERSE/PARK mode into it.
--
-- That part of CalculateAuto only runs on the client, so the suite flips the
-- realm flags for the duration of the call and hands it a stand-in component
-- with a single light, which is the least it needs to reach the mode copy.

local VEHICLE = "photon_test_auto_preset_components"
local COMPONENT = "photon_test_auto_preset_components"

-- The EMVU tables CalculateAuto reads or writes for the vehicle being built.
local VEHICLE_TABLES = { "Sequences", "PresetIndex", "Selections", "LightMeta", "Positions", "Sections", "Patterns" }

local function Component()
	return {
		Meta = {},
		-- Position hashing reads the first and last position, so there has to be one.
		Positions = { { Vector(), Angle(), "lamp" } },
		Sections = {},
		Patterns = { lamp = { ALL = { 1 } } },
		Modes = {
			Primary = {
				ALERT = { lamp = "ALL" },
				BRAKE = { lamp = "ALL" },
				REVERSE = { lamp = "ALL" },
				PARK = { lamp = "ALL" },
			},
		},
	}
end

-- Builds the vehicle the way EMVU:OverwriteIndex does, with `sequences` as its
-- EMV.Sequences, and runs CalculateAuto over one component in one preset.
local function Calculate(sequences)
	EMVU.LoadModeData(VEHICLE, sequences)
	EMVU.PresetIndex[VEHICLE] = { { Name = "Default", Auto = { 1 } } }
	EMVU.Selections[VEHICLE] = nil
	EMVU.LightMeta[VEHICLE] = {}
	EMVU.Positions[VEHICLE] = {}
	EMVU.Sections[VEHICLE] = {}
	EMVU.Patterns[VEHICLE] = {}

	local wasServer, wasClient = SERVER, CLIENT
	SERVER, CLIENT = false, true
	local ok, err = pcall(EMVU.CalculateAuto, EMVU, VEHICLE, {
		{ ID = COMPONENT, Pos = Vector(), Ang = Angle() },
	})
	SERVER, CLIENT = wasServer, wasClient

	return ok, err
end

local function DefinedSequenceCase(key)
	return {
		name = "A vehicle that defines its own " .. key .. " sequence without Preset_Components gets the component's pattern in it",
		func = function()
			local ok, err = Calculate({ Sequences = {}, [key] = {} })
			expect(ok).to.beTrue()
			expect(err).to.beNil()

			local presets = EMVU.Sequences[VEHICLE][key].Preset_Components
			expect(presets).to.beA("table")
			expect(presets[1]).to.beA("table")
			expect(presets[1].lamp_1).to.equal("ALL")
		end
	}
end

return {
	groupName = "EMV auto preset components",

	beforeEach = function(state)
		state.component = EMVU.Auto[COMPONENT]
		EMVU.Auto[COMPONENT] = Component()

		state.saved = {}
		for _, tbl in ipairs(VEHICLE_TABLES) do
			state.saved[tbl] = EMVU[tbl][VEHICLE]
		end
	end,

	afterEach = function(state)
		EMVU.Auto[COMPONENT] = state.component
		for _, tbl in ipairs(VEHICLE_TABLES) do
			EMVU[tbl][VEHICLE] = state.saved[tbl]
		end
	end,

	cases = {
		DefinedSequenceCase("Alert"),
		DefinedSequenceCase("Braking"),
		DefinedSequenceCase("Reverse"),
		DefinedSequenceCase("Park"),
		{
			name = "Regression guard: sequences LoadModeData creates still get the component's pattern",
			func = function()
				local ok, err = Calculate({ Sequences = {} })
				expect(ok).to.beTrue()
				expect(err).to.beNil()

				for _, key in ipairs({ "Alert", "Braking", "Reverse", "Park" }) do
					expect(EMVU.Sequences[VEHICLE][key].Preset_Components[1].lamp_1).to.equal("ALL")
				end
			end
		},
	}
}
