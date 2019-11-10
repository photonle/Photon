AddCSLuaFile()

local A = "AMBER"
local R = "RED"
local B = "BLUE"
local W = "WHITE"

local TEMPLATE = {}
TEMPLATE.Model = "models/lonewolfie/lightbar.mdl"
TEMPLATE.Category = "Lightbar"
TEMPLATE.Skin = 0
TEMPLATE.Lightbar = true
TEMPLATE.Bodygroups = {}
TEMPLATE.ColorInput = 0

TEMPLATE.Meta = {
	driver_forward = {
		AngleOffset = -90,
		W = 6.8,
		H = 6.3,
		Sprite = "sprites/emv/fs_valor",
		Scale = 1,
		WMult = 1
	},
	driver_forward_ang = {
		AngleOffset = -90,
		W = 6.8,
		H = 1.6,
		Sprite = "sprites/emv/fs_valor",
		Scale = 1,
		SourceOnly = true
	},
	driver_forward_narrow = {
		AngleOffset = -90,
		W = 6.1,
		H = 6.3,
		Sprite = "sprites/emv/fs_valor",
		Scale = 1.25
	},
	driver_forward_narrow_ang = {
		AngleOffset = -90,
		W = 6.1,
		H = 1.6,
		Sprite = "sprites/emv/fs_valor",
		Scale = 1.25,
		SourceOnly = true,
	},
	driver_forward_wide = {
		AngleOffset = -90,
		W = 7.3,
		H = 6.3,
		Sprite = "sprites/emv/fs_valor",
		Scale = 1
	},
	driver_forward_wide_ang = {
		AngleOffset = -90,
		W = 7.3,
		H = 1.6,
		Sprite = "sprites/emv/fs_valor",
		Scale = 1,
		SourceOnly = true
	},
	driver_illum_s = {
		AngleOffset = -90,
		W = 6,
		H = 6.8,
		Sprite = "sprites/emv/fs_valor",
		Scale = 1.25,
		WMult = 1.5,
	},
	driver_rear = {
		AngleOffset = 90,
		W = 6.8,
		H = 6.3,
		Sprite = "sprites/emv/fs_valor",
		Scale = 1,
		WMult = 1
	},
	driver_rear_ang = {
		AngleOffset = 90,
		W = 6.8,
		H = 1.6,
		Sprite = "sprites/emv/fs_valor",
		Scale = 1,
		SourceOnly = true
	},
	driver_rear_narrow = {
		AngleOffset = 90,
		W = 6.1,
		H = 6.3,
		Sprite = "sprites/emv/fs_valor",
		Scale = 1.25
	},
	driver_rear_narrow_ang = {
		AngleOffset = 90,
		W = 6.1,
		H = 1.6,
		Sprite = "sprites/emv/fs_valor",
		Scale = 1.25
	},
	driver_rear_wide = {
		AngleOffset = 90,
		W = 7.3,
		H = 6.3,
		Sprite = "sprites/emv/fs_valor",
		Scale = 1
	},
	driver_rear_wide_ang = {
		AngleOffset = 90,
		W = 7.3,
		H = 1.6,
		Sprite = "sprites/emv/fs_valor",
		Scale = 1
	},
}

TEMPLATE.Positions = {
	{Vector(3.55, 6.08, 9.87), Angle(0, 0, 0), "driver_forward"},
	{Vector(3.55, 5.92, 11), Angle(0, 0, 44), "driver_forward_ang"},
	{Vector(3.55, 5.9, 8.73), Angle(0, 0, -41), "driver_forward_ang"},

	{Vector(-3.25, 6.08, 9.87), Angle(0, 0, 0), "driver_forward"},
	{Vector(-3.25, 5.92, 11), Angle(0, 0, 44), "driver_forward_ang"},
	{Vector(-3.25, 5.9, 8.73), Angle(0, 0, -41), "driver_forward_ang"},

	{Vector(10, 6.08, 9.87), Angle(0, 0, 0), "driver_forward"},
	{Vector(10, 5.92, 11), Angle(0, 0, 44), "driver_forward_ang"},
	{Vector(10, 5.9, 8.73), Angle(0, 0, -41), "driver_forward_ang"},

	{Vector(-10, 6.08, 9.87), Angle(0, 0, 0), "driver_forward"},
	{Vector(-10, 5.92, 11), Angle(0, 0, 44), "driver_forward_ang"},
	{Vector(-10, 5.9, 8.73), Angle(0, 0, -41), "driver_forward_ang"},

	{Vector(16.35, 6.08, 9.87), Angle(0, 0, 0), "driver_forward_narrow"},
	{Vector(16.35, 5.92, 11), Angle(0, 0, 44), "driver_forward_narrow_ang"},
	{Vector(16.35, 5.9, 8.73), Angle(0, 0, -41), "driver_forward_narrow_ang"},

	{Vector(-16.27, 6.08, 9.87), Angle(0, 0, 0), "driver_forward_narrow"},
	{Vector(-16.27, 5.92, 11), Angle(0, 0, 44), "driver_forward_narrow_ang"},
	{Vector(-16.27, 5.9, 8.73), Angle(0, 0, -41), "driver_forward_narrow_ang"},

	{Vector(22.9, 6.08, 9.87), Angle(0, 0, 0), "driver_forward_wide"},
	{Vector(22.9, 5.92, 11), Angle(0, 0, 44), "driver_forward_wide_ang"},
	{Vector(22.9, 5.9, 8.73), Angle(0, 0, -41), "driver_forward_wide_ang"},

	{Vector(-22.9, 6.08, 9.87), Angle(0, 0, 0), "driver_forward_wide"},
	{Vector(-22.9, 5.92, 11), Angle(0, 0, 44), "driver_forward_wide_ang"},
	{Vector(-22.9, 5.9, 8.73), Angle(0, 0, -41), "driver_forward_wide_ang"},

	{Vector(-28, 0.02, 9.87), Angle(0, 90, 0), "driver_illum_s"},
	{Vector(28, 0.02, 9.87), Angle(0, -90, 0), "driver_illum_s"},

	{Vector(3.55, -6.08, 9.87), Angle(0, 0, 0), "driver_rear"},
	{Vector(3.55, -5.92, 11), Angle(0, 0, -44), "driver_rear_ang"},
	{Vector(3.55, -5.9, 8.73), Angle(0, 0, 41), "driver_rear_ang"},

	{Vector(-3.25, -6.08, 9.87), Angle(0, 0, 0), "driver_rear"},
	{Vector(-3.25, -5.92, 11), Angle(0, 0, -44), "driver_rear_ang"},
	{Vector(-3.25, -5.9, 8.73), Angle(0, 0, 41), "driver_rear_ang"},

	{Vector(10, -6.08, 9.87), Angle(0, 0, 0), "driver_rear"},
	{Vector(10, -5.92, 11), Angle(0, 0, -44), "driver_rear_ang"},
	{Vector(10, -5.9, 8.73), Angle(0, 0, 41), "driver_rear_ang"},

	{Vector(-10, -6.08, 9.87), Angle(0, 0, 0), "driver_rear"},
	{Vector(-10, -5.92, 11), Angle(0, 0, -44), "driver_rear_ang"},
	{Vector(-10, -5.9, 8.73), Angle(0, 0, 41), "driver_rear_ang"},

	{Vector(16.35, -6.08, 9.87), Angle(0, 0, 0), "driver_rear_narrow"},
	{Vector(16.35, -5.92, 11), Angle(0, 0, -44), "driver_rear_narrow_ang"},
	{Vector(16.35, -5.9, 8.73), Angle(0, 0, 41), "driver_rear_narrow_ang"},

	{Vector(-16.27, -6.08, 9.87), Angle(0, 0, 0), "driver_rear_narrow"},
	{Vector(-16.27, -5.92, 11), Angle(0, 0, -44), "driver_rear_narrow_ang"},
	{Vector(-16.27, -5.9, 8.73), Angle(0, 0, 41), "driver_rear_narrow_ang"},

	{Vector(22.9, -6.08, 9.87), Angle(0, 0, 0), "driver_rear_wide"},
	{Vector(22.9, -5.92, 11), Angle(0, 0, -44), "driver_rear_wide_ang"},
	{Vector(22.9, -5.9, 8.73), Angle(0, 0, 41), "driver_rear_wide_ang"},

	{Vector(-22.9, -6.08, 9.87), Angle(0, 0, 0), "driver_rear_wide"},
	{Vector(-22.9, -5.92, 11), Angle(0, 0, -44), "driver_rear_wide_ang"},
	{Vector(-22.9, -5.9, 8.73), Angle(0, 0, 41), "driver_rear_wide_ang"},
}
TEMPLATE.Sections = {
	["auto_driver_main"] = {
		{
			-- Inner Pair
			{1, "_1"}, {2, "_1"}, {3, "_1"},
			{4, "_2"}, {5, "_2"}, {6, "_2"},
			{7, "_1"}, {8, "_1"}, {9, "_1"},
			{10, "_2"}, {11, "_2"}, {12, "_2"},

			-- Takedowns.
			-- {13, "_3"}, {14, "_3"}, {15, "_3"},
			-- {16, "_3"}, {17, "_3"}, {18, "_3"},

			-- Outer Single.
			{19, "_1"}, {20, "_1"}, {21, "_1"},
			{22, "_2"}, {23, "_2"}, {24, "_2"},
		},
		{
			{1, "_1"}, {2, "_1"}, {3, "_1"},
			{7, "_1"}, {8, "_1"}, {9, "_1"},
			-- {13, "_3"}, {14, "_3"}, {15, "_3"},
			{19, "_1"}, {20, "_1"}, {21, "_1"},
		},
		{
			{4, "_2"}, {5, "_2"}, {6, "_2"},
			{10, "_2"}, {11, "_2"}, {12, "_2"},
			-- {16, "_3"}, {17, "_3"}, {18, "_3"},
			{22, "_2"}, {23, "_2"}, {24, "_2"},
		}
	},
	["auto_driver_main_tkdn"] = {
		{
			{13, "_3"}, {14, "_3"}, {15, "_3"},
			{16, "_3"}, {17, "_3"}, {18, "_3"},
		},
		{
			{13, "_3"}, {14, "_3"}, {15, "_3"},
		},
		{
			{16, "_3"}, {17, "_3"}, {18, "_3"},
		},
		{
			{13, "_3", {10, 0.2, 0}}, {14, "_3", {10, 0.2, 0}}, {15, "_3", {10, 0.2, 0}},
			{16, "_3", {10, 0.2, 16}}, {17, "_3", {10, 0.2, 16}}, {18, "_3", {10, 0.2, 16}},
		}
	},
	["auto_driver_side"] = {
		{
			-- Side Takedown
			{25, "_4"}, {26, "_4"},
		}, {
			{25, "_4"}
		}, {
			{26, "_4"},
		}
	},
	["auto_driver_rear"] = {
		{
			-- Rear Inner
			{27, "_1"}, {28, "_1"}, {29, "_1"},
			{30, "_2"}, {31, "_2"}, {32, "_2"},
			{33, "_1"}, {34, "_1"}, {35, "_1"},
			{36, "_2"}, {37, "_2"}, {38, "_2"},

			-- Rear "Takedown"
			{39, "_3"}, {40, "_3"}, {41, "_3"},
			{42, "_3"}, {43, "_3"}, {44, "_3"},

			-- Rear Outer
			{45, "_1"}, {46, "_1"}, {47, "_1"},
			{48, "_2"}, {49, "_2"}, {50, "_2"},
		},
		{
			{27, "_1"}, {28, "_1"}, {29, "_1"},
			{33, "_1"}, {34, "_1"}, {35, "_1"},
			{39, "_3"}, {40, "_3"}, {41, "_3"},
			{45, "_1"}, {46, "_1"}, {47, "_1"},
		},
		{
			{30, "_2"}, {31, "_2"}, {32, "_2"},
			{36, "_2"}, {37, "_2"}, {38, "_2"},
			{42, "_3"}, {43, "_3"}, {44, "_3"},
			{48, "_2"}, {49, "_2"}, {50, "_2"},
		}
	},
	["auto_driver_traffic"] = {
		-- right
		[1] = {{16, "_2"},},
		[2] = {{16, "_2"}, {18, "_3"},},
		[3] = {{16, "_2"}, {18, "_3"}, {20, "_2"}},
		[4] = {{16, "_2"}, {18, "_3"}, {20, "_2"}, {22, "_2"},},
		[5] = {{16, "_2"}, {18, "_3"}, {20, "_2"}, {22, "_2"}, {21, "_1"},},
		[6] = {{16, "_2"}, {18, "_3"}, {20, "_2"}, {22, "_2"}, {21, "_1"}, {19, "_1"},},
		-- all
		[7] = {{16, "_2"}, {18, "_3"}, {20, "_2"}, {22, "_2"}, {21, "_1"}, {19, "_1"}, {17, "_3"}, {15, "_1"},},
		-- left
		[8] = {{15, "_1"},},
		[9] = {{17, "_3"}, {15, "_1"},},
		[10] = {{19, "_1"}, {17, "_3"}, {15, "_1"},},
		[11] = {{21, "_1"}, {19, "_1"}, {17, "_3"}, {15, "_1"},},
		[12] = {{22, "_2"}, {21, "_1"}, {19, "_1"}, {17, "_3"}, {15, "_1"},},
		[13] = {{18, "_3"}, {20, "_2"}, {22, "_2"}, {21, "_1"}, {19, "_1"}, {17, "_3"}, {15, "_1"},},
		-- center out
		[14] = {{22, "_2"}, {21, "_1"},},
		[15] = {{20, "_2"}, {22, "_2"}, {21, "_1"}, {19, "_1"},},
		[16] = {{18, "_3"}, {20, "_2"}, {22, "_2"}, {21, "_1"}, {19, "_1"}, {17, "_3"},},
	}
}

TEMPLATE.Patterns = {
	auto_driver_main = {
		code1 = {2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3},
		code2 = {2, 2, 2, 0, 0, 3, 3, 3, 0, 0},
		code3 = {
			2, 3, 0, 3, 2, 0, 2, 3, 0, 3, 2, 0, 2, 3, 0, 3, 2, 0, 2, 3, 0, 3, 2, 0,
			2, 3, 0, 3, 2, 0, 2, 3, 0, 3, 2, 0, 2, 3, 0, 3, 2, 0, 2, 3, 0, 3, 2, 0,
			2, 2, 0, 2, 2, 0, 3, 3, 0, 3, 3, 0, 2, 2, 0, 2, 2, 0, 3, 3, 0, 3, 3, 0,
			2, 2, 0, 2, 2, 0, 3, 3, 0, 3, 3, 0, 2, 2, 0, 2, 2, 0, 3, 3, 0, 3, 3, 0,
		},
		alert = {2, 3, 0, 3, 2, 0},
	},
	auto_driver_rear = {
		code1 = {2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3},
		code2 = {2, 2, 2, 3, 3, 0, 3, 3, 3, 2, 2, 0},
		code3 = {2, 2, 0, 3, 3, 0},
		alert = {2, 3, 0, 3, 2, 0}
	},
	auto_driver_main_tkdn = {
		code1 = {0},
		code2 = {4},
		code3 = {2, 2, 0, 3, 3, 0, 3, 3, 0, 2, 2, 0},
		alert = {2, 2, 0, 3, 3, 0},
		cruise = {4}
	},
	auto_driver_side = {
		code1 = {1, 1, 1, 0, 0, 0},
		code2 = {2, 2, 2, 3, 3, 3},
		code3 = {2, 2, 0, 3, 3, 0},
		alert = {2, 3, 0, 3, 2, 0},
	}
}

TEMPLATE.TrafficDisconnect = {

}

TEMPLATE.Modes = {
	Primary = {
		M1 = {
			auto_driver_main = "code1",
			auto_driver_rear = "code1",
			auto_driver_main_tkdn = "code1",
			auto_driver_side = "code1"
		},
		M2 = {
			auto_driver_main = "code2",
			auto_driver_rear = "code2",
			auto_driver_main_tkdn = "code2",
			auto_driver_side = "code2"
		},
		M3 = {
			auto_driver_main = "code3",
			auto_driver_rear = "code3",
			auto_driver_main_tkdn = "code3",
			auto_driver_side = "code3"
		},
		ALERT = {
			auto_driver_main = "alert",
			auto_driver_rear = "alert",
			auto_driver_main_tkdn = "alert",
			auto_driver_side = "alert"
		}
	},
	Auxiliary = {
		C = {
			auto_driver_main_tkdn = "cruise"
		}
	},
	Illumination = {
		R = {
			{26, "_4"}
		},
		L = {
			{25, "_4"}
		},
		T = {
			{13, "_3"}, {14, "_3"}, {15, "_3"},
			{16, "_3"}, {17, "_3"}, {18, "_3"},
		}
	}
}

local function build(name, skin, color1, color2, color3, color4)
	if not color4 then color4 = color3 end

	local COMPONENT = table.Copy(TEMPLATE)
	COMPONENT.Skin = skin
	for sectionID, sectionData in pairs(COMPONENT.Sections) do
		for frameIdx, frameData in ipairs(sectionData) do
			for lightIdx, lightData in ipairs(frameData) do
				if lightData[2] == "_1" then
					lightData[2] = color1
				end
				if lightData[2] == "_2" then
					lightData[2] = color2
				end
				if lightData[2] == "_3" then
					lightData[2] = color3
				end
				if lightData[2] == "_4" then
					lightData[2] = color4
				end
			end
		end
	end
	for mode, modeData in pairs(COMPONENT.Modes.Illumination) do
		for lightIdx, lightData in ipairs(modeData) do
			if lightData[2] == "_1" then
				lightData[2] = color1
			end
			if lightData[2] == "_2" then
				lightData[2] = color2
			end
			if lightData[2] == "_3" then
				lightData[2] = color3
			end
			if lightData[2] == "_4" then
				lightData[2] = color4
			end
		end
	end

	EMVU:AddAutoComponent(COMPONENT, name)
end

build("Driver SF Lightbar Red/Blue", 0, B, R, W)
build("Driver SF Lightbar Blue", 1, B, B, W)
build("Driver SF Lightbar Red/White", 2, R, W, A, W)