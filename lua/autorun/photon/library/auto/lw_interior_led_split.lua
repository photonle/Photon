AddCSLuaFile()

local name = "LW Interior LED Light %s Split"

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
TMPL.DefaultColors = {W, W}
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

local function build(id, color1, color2, skin)
	if not skin then skin = 0 end

	local CPMT = table.Copy(TMPL)
	CPMT.Skin = skin

	local colors = 0
	if color1:StartWith("_") then colors = colors + 1 end
	if color2:StartWith("_") then colors = colors + 1 end
	CPMT.ColorInput = colors

	CPMT.Sections.auto_internet_lw_led = {}
	CPMT.Sections.auto_internet_lw_led[1] = {{1, color1}, {2, color2}, {3, A}}
	CPMT.Sections.auto_internet_lw_led[2] = {{1, color1}, {3, A}}
	CPMT.Sections.auto_internet_lw_led[3] = {{2, color2}, {3, A}}
	CPMT.Sections.auto_internet_lw_led[4] = {{1, color1}}
	CPMT.Sections.auto_internet_lw_led[5] = {{2, color2}}
	CPMT.Sections.auto_internet_lw_led[6] = {{3, A}}

	CPMT.Patterns = {}
	CPMT.Patterns.auto_internet_lw_led = {}
	CPMT.Patterns.auto_internet_lw_led.code1 = {2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 5, 5, 5}
	CPMT.Patterns.auto_internet_lw_led.code1A = {3, 3, 3, 3, 2, 2, 2, 2, 5, 5, 5, 5, 4, 4, 4, 4}
	CPMT.Patterns.auto_internet_lw_led.code1B = {4, 4, 4, 4, 5, 5, 5, 5, 2, 2, 2, 2, 3, 3, 3, 3}
	CPMT.Patterns.auto_internet_lw_led.code2 = {2, 2, 4, 5, 5, 3, 4, 4, 2, 3, 5, 5}
	CPMT.Patterns.auto_internet_lw_led.code2A = {3, 3, 5, 4, 4, 2, 5, 5, 3, 2, 4, 4}
	CPMT.Patterns.auto_internet_lw_led.code2B = {4, 4, 2, 3, 3, 5, 2, 2, 4, 5, 3, 3}
	CPMT.Patterns.auto_internet_lw_led.code3 = {2, 4, 0, 3, 0, 3, 5, 0, 2, 0}
	CPMT.Patterns.auto_internet_lw_led.code3A = {2, 6, 4, 0, 3, 6, 4, 0, 2, 6, 5, 0}
	CPMT.Patterns.auto_internet_lw_led.code3B = {3, 6, 5, 0, 2, 6, 5, 0, 3, 6, 4, 0}
	CPMT.Patterns.auto_internet_lw_led.alert = {2, 5}
	CPMT.Patterns.auto_internet_lw_led.alertA = {3, 4}
	CPMT.Patterns.auto_internet_lw_led.alertB = {4, 3}

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

build("Clear/Red", "_1", R, 0)
build("Clear/Blue", "_1", B, 1)
build("Red/Blue", R, B, 2)
build("Blue", B, B, 3)
build("Red", R, R, 4)
build("Clear", "_1", "_2", 5)