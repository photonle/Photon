AddCSLuaFile()

local name = "LW Interior Lightbar %s"

local R = "RED"
local B = "BLUE"
local A = "AMBER"

local TMPL = {}
TMPL.Model = "models/lonewolfie/intlightbarmedium.mdl"
TMPL.Skin = 1
TMPL.Bodygroups = {}
TMPL.NotLegacy = true
TMPL.ColorInput = 0
TMPL.Category = "Interior"
TMPL.DefaultColors = {[1] = "WHITE", [2] = "WHITE"}
TMPL.Meta = {
	main = {
		AngleOffset = 90,
		W = 8.5,
		H = 14,
		Sprite = "sprites/emv/led_lightbar",
		Scale = 1,
	},
	ta = {
		AngleOffset = 90,
		W = 8.5,
		H = 2,
		Sprite = "sprites/emv/led_lightbar",
		Scale = 1,
	},
}
TMPL.Positions = {
	{Vector(0.7, -21.3, 1.8), Angle(0, 90, 0), "main"},
	{Vector(0.7, -12.8, 1.8), Angle(0, 90, 0), "main"},
	{Vector(0.7, -4.15, 1.8), Angle(0, 90, 0), "main"},
	{Vector(0.7, 5.3, 1.8), Angle(0, 90, 0), "main"},
	{Vector(0.7, 13.9, 1.8), Angle(0, 90, 0), "main"},
	{Vector(0.7, 22.5, 1.8), Angle(0, 90, 0), "main"},
	{Vector(0.7, -21.3, 4.0), Angle(0, 90, 0), "ta"},
	{Vector(0.7, -12.8, 4.0), Angle(0, 90, 0), "ta"},
	{Vector(0.7, -4.15, 4.0), Angle(0, 90, 0), "ta"},
	{Vector(0.7, 5.3, 4.0), Angle(0, 90, 0), "ta"},
	{Vector(0.7, 13.9, 4.0), Angle(0, 90, 0), "ta"},
	{Vector(0.7, 22.5, 4.0), Angle(0, 90, 0), "ta"}
}
TMPL.Sections = {
	["auto_internet_lightbar"] = {},
	["auto_internet_lightbar_traffic"] = {}
}

local function simple(min, ...)
	local out
	if isstring(min) then
		out = {min, ...}
		for i = 1, #out do
			out[i] = {i, out[i]}
		end
	else
		out = {...}
		for i = 1, #out do
			out[i] = {min + i, out[i]}
		end
	end

	return out
end
local function all(color, max, min)
	if not min then min = 0 end

	local out = {}
	for i = 1, max do
		out[i] = {min + i, color}
	end
	return out
end

local function colours(tab, min)
	if not min then min = 0 end

	local out = {}
	for i, col in ipairs(tab) do
		out[id] = {min + i, col}
	end
	return out
end

local function alt(color1, color2, max, min)
	if not min then min = 0 end

	local out = {}
	for i = 1, max do
		out[i] = {min + i, i % 2 == 0 and color1 or color2}
	end
	return out
end

local function altonly(color, max, min)
	if not min then min = 0 end

	local out = {}
	for i = 1, max, 2 do
		out[math.ceil(i / 2)] = {min + i, color}
	end
	return out
end

local function filling(color, max, min)
	if not min then min = 0 end
	if not inc then inc = 1 end

	local out = {}
	local diff = max - min
	for i = 1, diff do
		out[i] = {}
		for i2 = 1, i, 1 do
			out[i][i2] = {min + i2, color}
		end
	end
	return out
end

local function emptying(color, max, min)
	if not min then min = 0 end
	if not inc then inc = 1 end

	local out = {}
	local diff = max - min
	for i = 1, diff do
		out[i] = {}
		for i2 = diff, diff - i + 1, -1 do
			out[i][i2] = {min + i2, color}
		end
	end
	return out
end

local ALT_NONE = 0
local ALT_CAN = 1
local ALT_MUST = 2
local function build(id, color1, color2, skin, alternater, mainHasTraffic)
	if not skin then skin = 0 end
	if not alternater then alternater = ALT_NONE end

	local CPMT = table.Copy(TMPL)
	CPMT.Skin = skin

	local colors = 0
	if color1:StartWith("_") then colors = colors + 1 end
	if color2:StartWith("_") then colors = colors + 1 end
	CPMT.ColorInput = colors

	CPMT.UsePhases = alternater == ALT_CAN

	CPMT.Sections.auto_internet_lightbar = {}
	CPMT.Sections.auto_internet_lightbar_ta = {}
	CPMT.Sections.auto_internet_lightbar[1] = simple(color1, color1, color1, color2, color2, color2)
	CPMT.Sections.auto_internet_lightbar[2] = simple(color1, color1, color1)
	CPMT.Sections.auto_internet_lightbar[3] = simple(3, color2, color2, color2)
	CPMT.Sections.auto_internet_lightbar[4] = alt(color1, color2, 6)
	CPMT.Sections.auto_internet_lightbar[5] = alt(color1, color2, 3)
	CPMT.Sections.auto_internet_lightbar[6] = alt(color1, color2, 3, 3)
	CPMT.Sections.auto_internet_lightbar[7] = altonly(color1, 6)
	CPMT.Sections.auto_internet_lightbar[8] = altonly(color2, 6, 1)

	local left = filling("AMBER", 6)
	CPMT.Sections.auto_internet_lightbar[9] = left[1]
	CPMT.Sections.auto_internet_lightbar[10] = left[2]
	CPMT.Sections.auto_internet_lightbar[11] = left[3]
	CPMT.Sections.auto_internet_lightbar[12] = left[4]
	CPMT.Sections.auto_internet_lightbar[13] = left[5]
	CPMT.Sections.auto_internet_lightbar[14] = left[6]

	local right = emptying("AMBER", 6)
	CPMT.Sections.auto_internet_lightbar[15] = right[6]
	CPMT.Sections.auto_internet_lightbar[16] = right[5]
	CPMT.Sections.auto_internet_lightbar[17] = right[4]
	CPMT.Sections.auto_internet_lightbar[18] = right[3]
	CPMT.Sections.auto_internet_lightbar[19] = right[2]
	CPMT.Sections.auto_internet_lightbar[20] = right[1]

	CPMT.Sections.auto_internet_lightbar[21] = simple(2, "AMBER", "AMBER")
	CPMT.Sections.auto_internet_lightbar[22] = simple(1, "AMBER", "AMBER", "AMBER", "AMBER")
	CPMT.Sections.auto_internet_lightbar[23] = table.Add(simple("AMBER", "AMBER"), simple(4, "AMBER", "AMBER"))
	CPMT.Sections.auto_internet_lightbar[24] = table.Add(simple("AMBER"), simple(5, "AMBER"))

	local left_ta = filling("AMBER", 12, 6)
	CPMT.Sections.auto_internet_lightbar_ta[1] = left_ta[1]
	CPMT.Sections.auto_internet_lightbar_ta[2] = left_ta[2]
	CPMT.Sections.auto_internet_lightbar_ta[3] = left_ta[3]
	CPMT.Sections.auto_internet_lightbar_ta[4] = left_ta[4]
	CPMT.Sections.auto_internet_lightbar_ta[5] = left_ta[5]
	CPMT.Sections.auto_internet_lightbar_ta[6] = left_ta[6]

	local right_ta = emptying("AMBER", 12, 6)
	CPMT.Sections.auto_internet_lightbar_ta[7] = right_ta[6]
	CPMT.Sections.auto_internet_lightbar_ta[8] = right_ta[5]
	CPMT.Sections.auto_internet_lightbar_ta[9] = right_ta[4]
	CPMT.Sections.auto_internet_lightbar_ta[10] = right_ta[3]
	CPMT.Sections.auto_internet_lightbar_ta[11] = right_ta[2]
	CPMT.Sections.auto_internet_lightbar_ta[12] = right_ta[1]

	CPMT.Sections.auto_internet_lightbar_ta[13] = simple(8, "AMBER", "AMBER")
	CPMT.Sections.auto_internet_lightbar_ta[14] = table.Add(simple(7, "AMBER", "AMBER"), simple(9, "AMBER", "AMBER"))
	CPMT.Sections.auto_internet_lightbar_ta[15] = table.Add(simple(6, "AMBER", "AMBER"), simple(10, "AMBER", "AMBER"))
	CPMT.Sections.auto_internet_lightbar_ta[16] = table.Add(simple(6, "AMBER"), simple(11, "AMBER"))

	CPMT.Patterns = {}
	CPMT.Patterns.auto_internet_lightbar = {}
	CPMT.Patterns.auto_internet_lightbar_ta = {}

	if alternater == ALT_NONE then
		CPMT.Patterns.auto_internet_lightbar.code1 = {2,2,2,2,2,2,3,3,3,3,3,3}
		CPMT.Patterns.auto_internet_lightbar.code2 = {2,2,0,0,2,2,0,0,3,3,0,0,3,3,0,0}
		CPMT.Patterns.auto_internet_lightbar.code3 = {0,0,2,3,0,0,3,2,0,0,1,1,0,0,3,2,0,0,2,3,0,0,1,1}
	elseif alternater == ALT_MUST then
		CPMT.Patterns.auto_internet_lightbar.code1 = {7,7,7,7,7,7,8,8,8,8,8,8}
		CPMT.Patterns.auto_internet_lightbar.code2 = {7,7,0,0,7,7,0,0,3,3,0,0,8,8,0,0}
		CPMT.Patterns.auto_internet_lightbar.code3 = {0,0,7,8,0,0,8,7,0,0,4,4,0,0,8,7,0,0,7,8,0,0,4,4}
	else
		CPMT.Patterns.auto_internet_lightbar.code1 = {2,2,2,2,2,2,3,3,3,3,3,3}
		CPMT.Patterns.auto_internet_lightbar.code2 = {2,2,0,0,2,2,0,0,3,3,0,0,3,3,0,0}
		CPMT.Patterns.auto_internet_lightbar.code3 = {0,0,2,3,0,0,3,2,0,0,1,1,0,0,3,2,0,0,2,3,0,0,1,1}
		CPMT.Patterns.auto_internet_lightbar.code1Alt = {7,7,7,7,7,7,8,8,8,8,8,8}
		CPMT.Patterns.auto_internet_lightbar.code2Alt = {7,7,0,0,7,7,0,0,3,3,0,0,8,8,0,0}
		CPMT.Patterns.auto_internet_lightbar.code3Alt = {0,0,7,8,0,0,8,7,0,0,4,4,0,0,8,7,0,0,7,8,0,0,4,4}
	end

	CPMT.Patterns.auto_internet_lightbar.right = {9,10,11,12,13,14,15,16,17,18,19,20,0}
	CPMT.Patterns.auto_internet_lightbar.left = table.Reverse({0,9,10,11,12,13,14,15,16,17,18,19,20})
	CPMT.Patterns.auto_internet_lightbar.diverge = {21,21,22,22,23,23,24,24,0,0}

	CPMT.Patterns.auto_internet_lightbar_ta.code1 = {0}
	CPMT.Patterns.auto_internet_lightbar_ta.code2 = {0}
	CPMT.Patterns.auto_internet_lightbar_ta.code3 = {0}
	CPMT.Patterns.auto_internet_lightbar_ta.right = {1,2,3,4,5,6,7,8,10,11,12,0}
	CPMT.Patterns.auto_internet_lightbar_ta.left = table.Reverse({0,1,2,3,4,5,6,7,8,10,11,12})
	CPMT.Patterns.auto_internet_lightbar_ta.diverge = {13,13,14,14,15,15,16,16,0,0}

	CPMT.Modes = {
		Primary = {
			M1 = {},
			M2 = {},
			M3 = {}
		},
		Auxiliary = {
			L = {},
			R = {},
			D = {}
		},
		Illumination = {}
	}

	CPMT.Modes.Primary.M1.auto_internet_lightbar = "code1"
	CPMT.Modes.Primary.M1.auto_internet_lightbar_ta = "code1"
	CPMT.Modes.Primary.M2.auto_internet_lightbar = "code2"
	CPMT.Modes.Primary.M2.auto_internet_lightbar_ta = "code2"
	CPMT.Modes.Primary.M3.auto_internet_lightbar = "code3"
	CPMT.Modes.Primary.M3.auto_internet_lightbar_ta = "code3"

	CPMT.Modes.Auxiliary.L.auto_internet_lightbar_ta = "left"
	CPMT.Modes.Auxiliary.R.auto_internet_lightbar_ta = "right"
	CPMT.Modes.Auxiliary.D.auto_internet_lightbar_ta = "diverge"
	if mainHasTraffic then
		CPMT.Modes.Auxiliary.L.auto_internet_lightbar = "left"
		CPMT.Modes.Auxiliary.R.auto_internet_lightbar = "right"
		CPMT.Modes.Auxiliary.D.auto_internet_lightbar = "diverge"
	end

	EMVU:AddAutoComponent(CPMT, Format(name, id))
end

build("Clear/Red", "_1", R, 0, ALT_NONE)
build("Blue/Red", B, R, 1, ALT_NONE)
build("Red", R, R, 2, ALT_CAN)
build("Amber", A, A, 3, ALT_CAN, true)
build("Clear", "_1", "_2", 4, ALT_CAN, true)
build("Blue/Red Alt", B, R, 5, ALT_MUST)
build("Clear/Red Alt", R, "_1", 6, ALT_MUST)
build("Clear/Blue Alt", B, "_1", 8, ALT_MUST)