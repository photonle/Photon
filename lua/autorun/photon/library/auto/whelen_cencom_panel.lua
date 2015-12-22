AddCSLuaFile()

local A = "AMBER"
local R = "RED"
local DR = "D_RED"
local B = "BLUE"
local W = "WHITE"
local CW = "C_WHITE"
local SW = "S_WHITE"
local G = "GREEN"
local RB = "BLUE/RED"

local name = "Whelen CenCom Panel"

local COMPONENT = {}

COMPONENT.Model = "models/schmal/whelen_cencom_panel.mdl"
COMPONENT.Skin = 0
COMPONENT.Bodygroups = {}
COMPONENT.NotLegacy = true
COMPONENT.Category = "Equipment"
COMPONENT.DefaultColors = {
	[1] = "RED",
	[2] = "GREEN",
	[3] = "AMBER",
}

COMPONENT.Meta = {
	auto_cencom_led = {
		AngleOffset = 0,
		W = .15,
		H = .15,
		WMult = .8,
		Sprite = "sprites/emv/small_led",
		Scale = .04,
		NoLegacy = true,
		DirAxis = "Right",
		DirOffset = 0
	},
}

COMPONENT.Positions = {

	[1] = { Vector( -2.44, 1.18, 0.26 ), Angle( 0, 0, -90 ), "auto_cencom_led" },
	[2] = { Vector( -1.71, 1.18, 0.26 ), Angle( 0, 0, -90 ), "auto_cencom_led" },
	[3] = { Vector( -.98, 1.18, 0.26 ), Angle( 0, 0, -90 ), "auto_cencom_led" },
	[4] = { Vector( -.27, 1.18, 0.26 ), Angle( 0, 0, -90 ), "auto_cencom_led" },
	[5] = { Vector( .45, 1.18, 0.26 ), Angle( 0, 0, -90 ), "auto_cencom_led" },
	[6] = { Vector( 1.18, 1.18, 0.26 ), Angle( 0, 0, -90 ), "auto_cencom_led" },
	[7] = { Vector( 1.91, 1.18, 0.26 ), Angle( 0, 0, -90 ), "auto_cencom_led" },
	[8] = { Vector( 2.62, 1.18, 0.26 ), Angle( 0, 0, -90 ), "auto_cencom_led" },
	[9] = { Vector( -.27, .27, 0.26 ), Angle( 0, 0, -90 ), "auto_cencom_led" },
	[10] = { Vector( .45, .27, 0.26 ), Angle( 0, 0, -90 ), "auto_cencom_led" },
	[11] = { Vector( 1.18, .27, 0.26 ), Angle( 0, 0, -90 ), "auto_cencom_led" },
	[12] = { Vector( 1.91, .27, 0.26 ), Angle( 0, 0, -90 ), "auto_cencom_led" },
	[13] = { Vector( 2.62, .27, 0.26 ), Angle( 0, 0, -90 ), "auto_cencom_led" },
	[14] = { Vector( -.27, -.64, 0.26 ), Angle( 0, 0, -90 ), "auto_cencom_led" },
	[15] = { Vector( .45, -.64, 0.26 ), Angle( 0, 0, -90 ), "auto_cencom_led" },
	[16] = { Vector( 1.18, -.64, 0.26 ), Angle( 0, 0, -90 ), "auto_cencom_led" },
	[17] = { Vector( 1.91, -.64, 0.26 ), Angle( 0, 0, -90 ), "auto_cencom_led" },
	[18] = { Vector( 2.62, -.64, 0.26 ), Angle( 0, 0, -90 ), "auto_cencom_led" },
	[19] = { Vector( -2.05, -0.26, 0.26 ), Angle( 0, 0, -90 ), "auto_cencom_led" },
	[20] = { Vector( -1.57, -0.26, 0.26 ), Angle( 0, 0, -90 ), "auto_cencom_led" },
	[21] = { Vector( -1.08, -0.26, 0.26 ), Angle( 0, 0, -90 ), "auto_cencom_led" },
	[22] = { Vector( -2.7, -1.14, 0.26 ), Angle( 0, 0, -90 ), "auto_cencom_led" },
	[23] = { Vector( -2.45, -1.14, 0.26 ), Angle( 0, 0, -90 ), "auto_cencom_led" },
	[24] = { Vector( -2.21, -1.14, 0.26 ), Angle( 0, 0, -90 ), "auto_cencom_led" },
	[25] = { Vector( -1.96, -1.14, 0.26 ), Angle( 0, 0, -90 ), "auto_cencom_led" },
	[26] = { Vector( -1.74, -1.14, 0.26 ), Angle( 0, 0, -90 ), "auto_cencom_led" },
	[27] = { Vector( -1.49, -1.14, 0.26 ), Angle( 0, 0, -90 ), "auto_cencom_led" },
	[28] = { Vector( -1.25, -1.14, 0.26 ), Angle( 0, 0, -90 ), "auto_cencom_led" },
	[29] = { Vector( -1, -1.14, 0.26 ), Angle( 0, 0, -90 ), "auto_cencom_led" },

}

COMPONENT.Sections = {
	["auto_cencom"] = {
		[1] = {
			{ 1, "_1" }, { 2, "_1" }, { 3, "_1" }, { 4, "_1" }, { 5, "_1" }, { 6, "_1" }, { 7, "_1" }, { 8, "_1" }, 
			{ 9, "_1" }, { 10, "_1" }, { 11, "_1" }, { 12, "_1" }, { 13, "_1" }, 
			{ 14, "_1" }, { 15, "_1" }, { 16, "_1" }, { 17, "_1" }, { 18, "_1" },
			{ 19, "_1" }, { 20, "_1" }, { 21, "_1" }, 
			{ 22, "_1" }, { 23, "_1" }, { 24, "_1" }, { 25, "_1" }, { 26, "_1" }, { 27, "_1" }, { 28, "_1" }, { 29, "_1" }, 
		}
	},
	["slider_stages"] = {
		[1] = { { 19, "_2" } },
		[2] = { { 19, "_2" }, { 20, "_3" } },
		[3] = { { 19, "_2" }, { 20, "_3" }, { 21, "_1" } },
	},
	["mini_lb"] = {
		[1] = { { 22, "_1" }, { 23, "_1" }, { 28, "_1" }, { 29, "_1" }, },
		[2] = { { 24, "_1" }, { 25, "_1" }, { 26, "_1" }, { 27, "_1" }, },

		[3] = { { 22, "_1" }, { 23, "_1" }, { 24, "_1" }, { 25, "_1" }, },
		[4] = { { 26, "_1" }, { 27, "_1" }, { 28, "_1" }, { 29, "_1" }, },

		[5] = { { 22, "_1" }, { 23, "_1" }, { 26, "_1" }, { 27, "_1" }, },
		[6] = { { 24, "_1" }, { 25, "_1" }, { 28, "_1" }, { 29, "_1" }, },

		[7] = { { 22, "_3" }, },
		[8] = { { 22, "_3" }, { 23, "_3" }, },
		[9] = { { 22, "_3" }, { 23, "_3" }, { 24, "_3" }, },
		[10] = { { 22, "_3" }, { 23, "_3" }, { 24, "_3" }, { 25, "_3" }, },
		[11] = { { 22, "_3" }, { 23, "_3" }, { 24, "_3" }, { 25, "_3" }, { 26, "_3" }, },
		[12] = { { 22, "_3" }, { 23, "_3" }, { 24, "_3" }, { 25, "_3" }, { 26, "_3" }, { 27, "_3" }, },
		[13] = { { 22, "_3" }, { 23, "_3" }, { 24, "_3" }, { 25, "_3" }, { 26, "_3" }, { 27, "_3" }, { 28, "_3" }, },

		[14] = { { 22, "_3" }, { 23, "_3" }, { 24, "_3" }, { 25, "_3" }, { 26, "_3" }, { 27, "_3" }, { 28, "_3" }, { 29, "_3" }, },

		[15] = { { 23, "_3" }, { 24, "_3" }, { 25, "_3" }, { 26, "_3" }, { 27, "_3" }, { 28, "_3" }, { 29, "_3" }, },
		[16] = { { 24, "_3" }, { 25, "_3" }, { 26, "_3" }, { 27, "_3" }, { 28, "_3" }, { 29, "_3" }, },
		[17] = { { 25, "_3" }, { 26, "_3" }, { 27, "_3" }, { 28, "_3" }, { 29, "_3" }, },
		[18] = { { 26, "_3" }, { 27, "_3" }, { 28, "_3" }, { 29, "_3" }, },
		[19] = { { 27, "_3" }, { 28, "_3" }, { 29, "_3" }, },
		[20] = { { 28, "_3" }, { 29, "_3" }, },
		[21] = { { 29, "_3" }, },

		[22] = { { 25, "_3" }, { 26, "_3" }, },
		[23] = { { 24, "_3" }, { 25, "_3" }, { 26, "_3" }, { 27, "_3" } },
		[24] = { { 23, "_3" }, { 24, "_3" }, { 25, "_3" }, { 26, "_3" }, { 27, "_3" }, { 28, "_3" }, },

		[25] = { { 22, "_3" }, { 23, "_3" }, { 28, "_3" }, { 29, "_3" }, },
	},
	["trf_button"] = { [1] = { { 9, "_1" } } },
	["cruise_button"] = { [1] = { { 10, "_1" } } },
	["emrg_button"] = { [1] = { { 12, "_1" } } },
}

COMPONENT.Patterns = {
	["slider_stages"] = {
		["code1"] = { 1 },
		["code2"] = { 2 },
		["code3"] = { 3 },
	},
	["mini_lb"] = {
		["code1"] = { 1, 1, 1, 1, 2, 2, 2, 2 },
		["code2"] = { 3, 3, 3, 4, 4, 4, 3, 3, 3, 4, 4, 4, 3, 3, 3, 4, 4, 4, 3, 3, 3, 4, 4, 4, 5, 5, 5, 6, 6, 6, 5, 5, 5, 6, 6, 6, 5, 5, 5, 6, 6, 6, 5, 5, 5, 6, 6, 6 },
		["code3"] = { 1, 1, 2, 2, 1, 1, 2, 2, 1, 1, 2, 2, 5, 5, 6, 6, 5, 5, 6, 6, 5, 5, 6, 6, 3, 3, 4, 4, 3, 3, 4, 4, 3, 3, 4, 4 },
		["left"] = { 21, 21, 20, 20, 19, 19, 18, 18, 17, 17, 16, 16, 15, 15, 14, 14, 14, 14, 14, 0, 0, 0, 0 },
		["right"] = { 7, 7, 8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 14, 14, 14, 14, 0, 0, 0, 0 },
		["diverge"] = { 22, 22, 22, 23, 23, 23, 24, 24, 24, 14, 14, 14, 14, 14, 14, 0, 0, 0, 0 },
		["cruise"] = { 25 },
	},
	["trf_button"] = { 
		["on"] = { 1 }, 
		["off"] = { 0 }, 
	},
	["cruise_button"] = { 
		["on"] = { 1 }, 
	},
	["emrg_button"] = { 
		["on"] = { 1 }, 
	},
	["auto_cencom"] = {
		["code1"] = { 1 },
		["code1A"] = { 1, 1, 1, 0, 0, 0, 0, 0, },
		["code1B"] = { 0, 0, 0, 0, 1, 1, 1, 0 },
		["code1CHPA"] = { 1 },
		["code1CHPB"] = { 1 },
		["code2"] = { 1, 0, 1, 1, 1, 0, 0, 0 },
		["code2A"] = { 1, 0, 1, 1, 1, 0, 0, 0, 0, 0 },
		["code2B"] = { 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, },
		["code2CHPA"] = { 1, 1, 1, 1, 1, 0, 0, 0, 0, 0 },
		["code3CHPA"] = { 1, 1, 1, 1, 1, 0, 0, 0, 0, 0 },
		["code2CHPB"] = { 0, 0, 0, 0, 0, 1, 1, 1, 1, 1 },
		["code3CHPB"] = { 0, 0, 0, 0, 0, 1, 1, 1, 1, 1 },
		["code3"] = { 1, 0 },
		["code3A"] = { 1, 0, 1, 0, 0, 0 },
		["code3B"] = { 0, 0, 0, 1, 0, 1 },
		["alert"] = { 1, 0 },
		["alertA"] = { 0, 1 },
		["alertB"] = { 1, 0 },
		["all"] = { 1 },
		["allA"] = { 1 },
		["allB"] = { 1 },
	}
}

COMPONENT.Modes = {
	Primary = {
		M1 = { 
			["slider_stages"] = "code1", 
			["mini_lb"] = "code1",
			["emrg_button"] = "on",
			["trf_button"] = "off",
		},
		M2 = { 
			["slider_stages"] = "code2", 
			["mini_lb"] = "code2",
			["emrg_button"] = "on",
			["trf_button"] = "off",
		},
		M3 = { 
			["slider_stages"] = "code3", 
			["mini_lb"] = "code3",
			["emrg_button"] = "on",
			["trf_button"] = "off",
		}
	},
	Auxiliary = {
		L = {
			["trf_button"] = "on",
			["mini_lb"] = "left"
		},
		R = {
			["trf_button"] = "on",
			["mini_lb"] = "right"
		},
		D = {
			["trf_button"] = "on",
			["mini_lb"] = "diverge"
		},
		C = {
			["emrg_button"] = "on",
			["mini_lb"] = "cruise"
		},
	},
	Illumination = {
		T = {
			{ 11, R }, { 16, R }
		},
		F = {
			{ 11, R }, { 16, R }, { 14, R }, { 15, R }
		}
	}
}

EMVU:AddAutoComponent( COMPONENT, name )