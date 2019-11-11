AddCSLuaFile()

local name = "LW Interior LED Light %s"

local R = "RED"
local B = "BLUE"
local A = "AMBER"
local W = "WHITE"

local TMPL = {}
TMPL.Model = "models/lonewolfie/lightholder_doublev3.mdl"
TMPL.Skin = 1
TMPL.Bodygroups = {}
TMPL.NotLegacy = true
TMPL.ColorInput = 0
TMPL.Category = "Interior"
TMPL.DefaultColors = {W}
TMPL.UsePhases = true

TMPL.Meta = {
	main = {
		AngleOffset = 90,
		W = 8,
		H = 9.5,
		Sprite = "sprites/emv/led_lightbar",
		Scale = 1,
	},
	reflector = {
		AngleOffset = 90,
		W = 8.2,
		H = 2,
		Sprite = "sprites/emv/led_lightbar",
		Scale = 1,
	},
}

TMPL.Positions = {
	{Vector(0.5, -0.2, 3.65), Angle(0, 90, -6), "main"},
	{Vector(0.77, -0.2, 1.35), Angle(0, 90, -7.6), "main"},
	{Vector(0.32, -0.25, 5.26), Angle(0, 90, 0), "reflector"}
}
TMPL.Sections = {
	auto_internet_lw_led = {},
}

local function build(id, color1, skin)
	if not skin then skin = 0 end

	local CPMT = table.Copy(TMPL)
	CPMT.Skin = skin
	CPMT.ColorInput = color1:StartWith("_") and 1 or 0

	CPMT.Sections.auto_internet_lw_led = {}
	CPMT.Sections.auto_internet_lw_led[1] = {{1, color1}, {2, color1}, {3, A}}
	CPMT.Sections.auto_internet_lw_led[2] = {{1, color1}, {2, color1}}
	CPMT.Sections.auto_internet_lw_led[3] = {{3, A}}

	CPMT.Patterns = {}
	CPMT.Patterns.auto_internet_lw_led = {}
	CPMT.Patterns.auto_internet_lw_led.code1 = {2, 2, 2, 2, 2, 3, 3, 3, 3, 3}
	CPMT.Patterns.auto_internet_lw_led.code1A = {2, 2, 2, 2, 3, 3, 3, 3}
	CPMT.Patterns.auto_internet_lw_led.code1B = {3, 3, 3, 3, 2, 2, 2, 2}
	CPMT.Patterns.auto_internet_lw_led.code2 = {1, 1, 1, 0, 0, 2, 2, 2, 3, 3}
	CPMT.Patterns.auto_internet_lw_led.code2A = {1, 1, 1, 0, 0, 0, 2, 2, 2, 3, 3, 3}
	CPMT.Patterns.auto_internet_lw_led.code2B = {2, 2, 2, 3, 3, 3, 0, 0, 0, 1, 1, 1}
	CPMT.Patterns.auto_internet_lw_led.code3 = {2, 2, 0, 0, 1, 1, 0, 0}
	CPMT.Patterns.auto_internet_lw_led.code3A = {2, 2, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0}
	CPMT.Patterns.auto_internet_lw_led.code3B = {0, 0, 0, 0, 0, 0, 2, 2, 0, 1, 1, 0}
	CPMT.Patterns.auto_internet_lw_led.alert = {2, 3}
	CPMT.Patterns.auto_internet_lw_led.alertA = {2, 3, 1, 0}
	CPMT.Patterns.auto_internet_lw_led.alertB = {0, 1, 3, 2}

	CPMT.Modes = {
		Primary = {
			M1 = {auto_internet_lw_led = "code1"},
			M2 = {auto_internet_lw_led = "code2"},
			M3 = {auto_internet_lw_led = "code3"},
			ALERT = {auto_internet_lw_led = "alert"}
		},
		Auxiliary = {
			L = {},
			R = {},
			D = {}
		},
		Illumination = {}
	}

	EMVU:AddAutoComponent(CPMT, Format(name, id))
end

build("Blue", B, 3)
build("Red", R, 4)
build("Clear", "_1", 5)