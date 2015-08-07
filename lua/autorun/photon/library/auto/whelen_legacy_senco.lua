AddCSLuaFile()

local A = "AMBER"
local R = "RED"
local DR = "D_RED"
local B = "BLUE"
local W = "WHITE"
local CW = "C_WHITE"
local SW = "S_WHITE"
local G = "GREEN"

local name = "Whelen Legacy SenCo Front"

local COMPONENT = {}

COMPONENT.Model = "models/schmal/whelen_legacy/legacy_lightbar.mdl"
COMPONENT.Skin = 0
COMPONENT.Bodygroups = {}
COMPONENT.UsePhases = true

COMPONENT.Meta = {
	legacy_forward = {
		AngleOffset = -90,
		W = 3.35,
		H = 3.2,
		Sprite = "sprites/emv/legacy_direct",
		Scale = 1,
		WMult = 1.25,
	},
	legacy_illum = {
		AngleOffset = -90,
		W = 3.35,
		H = 3.2,
		Sprite = "sprites/emv/legacy_illum",
		Scale = 1.25,
		WMult = 1.25,
	},
	legacy_rear = {
		AngleOffset = 90,
		W = 3.35,
		H = 3.2,
		Sprite = "sprites/emv/legacy_direct",
		Scale = .85,
		WMult = 1.25,
	},
}

COMPONENT.Positions = {

	[1] = { Vector( -5.16, 6.18, 0.48 ), Angle( 0, 0, 0 ), "legacy_forward" },
	[2] = { Vector( 5.16, 6.18, 0.48 ), Angle( 0, 0, 0 ), "legacy_forward" },

	[3] = { Vector( -8.25, 6.18, 0.48 ), Angle( 0, 0, 0 ), "legacy_forward" },
	[4] = { Vector( 8.25, 6.18, 0.48 ), Angle( 0, 0, 0 ), "legacy_forward" },

	[5] = { Vector( -11.47, 6.18, 0.48 ), Angle( 0, 0, 0 ), "legacy_forward" },
	[6] = { Vector( 11.47, 6.18, 0.48 ), Angle( 0, 0, 0 ), "legacy_forward" },

	[7] = { Vector( -14.56, 6.18, 0.48 ), Angle( 0, 0, 0 ), "legacy_forward" },
	[8] = { Vector( 14.56, 6.18, 0.48 ), Angle( 0, 0, 0 ), "legacy_forward" },

	[9] = { Vector( -17.75, 6.18, 0.48 ), Angle( 0, 0, 0 ), "legacy_forward" },
	[10] = { Vector( 17.75, 6.18, 0.48 ), Angle( 0, 0, 0 ), "legacy_forward" },

	[11] = { Vector( -20.83, 6.18, 0.48 ), Angle( 0, 0, 0 ), "legacy_forward" },
	[12] = { Vector( 20.83, 6.18, 0.48 ), Angle( 0, 0, 0 ), "legacy_forward" },

	[13] = { Vector( -24, 6.18, 0.48 ), Angle( 0, 0, 0 ), "legacy_forward" },
	[14] = { Vector( 24, 6.18, 0.48 ), Angle( 0, 0, 0 ), "legacy_forward" },

	[15] = { Vector( -26.67, 5.09, 0.48 ), Angle( 0, 45, 0 ), "legacy_forward" },
	[16] = { Vector( 26.67, 5.09, 0.48 ), Angle( 0, -45, 0 ), "legacy_forward" },

	[17] = { Vector( -28.8, 2.88, 0.48 ), Angle( 0, 45, 0 ), "legacy_forward" },
	[18] = { Vector( 28.8, 2.88, 0.48 ), Angle( 0, -45, 0 ), "legacy_forward" },

	[19] = { Vector( -28.86, -2.79, 0.48 ), Angle( 0, -45, 0 ), "legacy_rear" },
	[20] = { Vector( 28.86, -2.79, 0.48 ), Angle( 0, 45, 0 ), "legacy_rear" },

	[21] = { Vector( -26.69, -4.97, 0.48 ), Angle( 0, -45, 0 ), "legacy_rear" },
	[22] = { Vector( 26.69, -4.97, 0.48 ), Angle( 0, 45, 0 ), "legacy_rear" },

	[23] = { Vector( -24.05, -6.08, 0.48 ), Angle( 0, 0, 0 ), "legacy_rear" },
	[24] = { Vector( 24.05, -6.08, 0.48 ), Angle( 0, 0, 0 ), "legacy_rear" },

	[25] = { Vector( -20.87, -6.08, 0.48 ), Angle( 0, 0, 0 ), "legacy_rear" },
	[26] = { Vector( 20.87, -6.08, 0.48 ), Angle( 0, 0, 0 ), "legacy_rear" },

	[27] = { Vector( -17.7, -6.08, 0.48 ), Angle( 0, 0, 0 ), "legacy_rear" },
	[28] = { Vector( 17.7, -6.08, 0.48 ), Angle( 0, 0, 0 ), "legacy_rear" },

	[29] = { Vector( -14.62, -6.08, 0.48 ), Angle( 0, 0, 0 ), "legacy_rear" },
	[30] = { Vector( 14.62, -6.08, 0.48 ), Angle( 0, 0, 0 ), "legacy_rear" },

	[31] = { Vector( -11.42, -6.08, 0.48 ), Angle( 0, 0, 0 ), "legacy_rear" },
	[32] = { Vector( 11.42, -6.08, 0.48 ), Angle( 0, 0, 0 ), "legacy_rear" },

	[33] = { Vector( -8.33, -6.08, 0.48 ), Angle( 0, 0, 0 ), "legacy_rear" },
	[34] = { Vector( 8.33, -6.08, 0.48 ), Angle( 0, 0, 0 ), "legacy_rear" },

	[35] = { Vector( -5.11, -6.08, 0.48 ), Angle( 0, 0, 0 ), "legacy_rear" },
	[36] = { Vector( 5.11, -6.08, 0.48 ), Angle( 0, 0, 0 ), "legacy_rear" },

	[37] = { Vector( -2.04, -6.08, 0.48 ), Angle( 0, 0, 0 ), "legacy_rear" },
	[38] = { Vector( 2.04, -6.08, 0.48 ), Angle( 0, 0, 0 ), "legacy_rear" },

	[39] = { Vector( -2.01, 6.18, 0.48 ), Angle( 0, 0, 0 ), "legacy_illum" },
	[40] = { Vector( 2.01, 6.18, 0.48 ), Angle( 0, 0, 0 ), "legacy_illum" },

	[41] = { Vector( -30.01, 0.05, 0.5 ), Angle( 0, 90, 0 ), "legacy_illum" },
	[42] = { Vector( 30.01, 0.05, 0.5 ), Angle( 0, -90, 0 ), "legacy_illum" },

}

COMPONENT.Sections = {
	["auto_whelen_legacy"] = {
		{
			{ 1, R },{ 2, B },
			{ 3, R },{ 4, B },
			{ 5, R },{ 6, B },
			{ 7, R },{ 8, B },
			{ 9, R },{ 10, B },
			{ 11, R },{ 12, B },
			{ 13, R },{ 14, B },
			{ 15, R },{ 16, B },
			{ 17, R },{ 18, B },
			{ 19, R },{ 20, B },
			{ 21, R },{ 22, B },
			{ 23, R },{ 24, B },
			{ 25, R },{ 26, B },
			{ 27, R },{ 28, B },
			{ 29, R },{ 30, B },
			{ 31, R },{ 32, B },
			{ 33, R },{ 34, B },
			{ 35, R },{ 36, B },
			{ 37, R },{ 38, B },
			{ 39, W },{ 40, W },
			{ 41, W },{ 42, W },
		},
		{
			{ 1, A }, { 3, A }, { 5, A }, { 7, A }, { 9, A }, { 11, A }, { 13, A }, { 15, G }, { 17, G },
		},
		{
			{ 2, A }, { 4, A }, { 6, A }, { 8, A }, { 10, A }, { 12, A }, { 14, A }, { 16, G }, { 18, G },
		},
		[4] = {
			{ 9, A }, { 11, A },
		},
		[5] = {
			{ 5, A }, { 7, A }, { 6, A }, { 8, A }, 
		},
		[6] = {
			{ 1, A }, { 3, A }, { 10, A }, { 12, A },
		},
		[7] = {
			{ 9, A }, { 11, A }, 
			{ 1, A }, { 3, A }, 
			{ 6, A }, { 8, A }, 
		},
		[8] = {
			{ 2, A }, { 4, A }, 
			{ 10, A }, { 12, A },  
			{ 5, A }, { 7, A }, 
		},
		[9] = {
			{ 9, A }, { 11, A }, 
			{ 1, A }, { 3, A }, 
			{ 6, A }, { 8, A }, 
		},
		[10] = {
			{ 2, A }, { 4, A }, 
			{ 10, A }, { 12, A },  
			{ 5, A }, { 7, A }, 
		},
		[11] = {
			 { 5, A }, { 7, A }, { 9, A }, { 11, A }, 
		},
		[12] = {
			{ 5, A }, { 7, A }, { 1, A }, { 3, A },
		},
		[13] = {
			{ 1, A }, { 3, A }, { 2, A }, { 4, A },
		},
		[14] = {
			 { 2, A }, { 4, A }, { 6, A }, { 8, A },
		},
		[15] = {
			{ 6, A }, { 8, A }, { 10, A }, { 12, A },
		}
	},
	["auto_whelen_legacy_corner"] = {
		[1] = { { 13, G }, { 15, G }, { 17, G } },
		[2] = { { 14, G }, { 16, G }, { 18, G } },
	},
	["auto_whelen_legacy_traffic"] = {
		[1] = { { 25, A }, { 27, A }, { 29, A } },
		[2] = { { 25, A }, { 27, A }, { 29, A }, { 31, A }, { 33, A } },
		[3] = { { 25, A }, { 27, A }, { 29, A }, { 31, A }, { 33, A }, { 35, A }, { 37, A } },
		[4] = { { 25, A }, { 27, A }, { 29, A }, { 31, A }, { 33, A }, { 35, A }, { 37, A }, { 38, A }, { 36, A } },
		[5] = { { 25, A }, { 27, A }, { 29, A }, { 31, A }, { 33, A }, { 35, A }, { 37, A }, { 38, A }, { 36, A }, { 34, A }, { 32, A } },
		[6] = { { 25, A }, { 27, A }, { 29, A }, { 31, A }, { 33, A }, { 35, A }, { 37, A }, { 38, A }, { 36, A }, { 34, A }, { 32, A }, { 30, A }, { 28, A }, { 26, A } },
		[7] = { { 30, A }, { 28, A }, { 26, A } },
		[8] = { { 34, A }, { 32, A }, { 30, A }, { 28, A }, { 26, A } },
		[9] = { { 38, A }, { 36, A }, { 34, A }, { 32, A }, { 30, A }, { 28, A }, { 26, A } },
		[10] = { { 35, A }, { 37, A }, { 38, A }, { 36, A }, { 34, A }, { 32, A }, { 30, A }, { 28, A }, { 26, A } },
		[11] = { { 31, A }, { 33, A }, { 35, A }, { 37, A }, { 38, A }, { 36, A }, { 34, A }, { 32, A }, { 30, A }, { 28, A }, { 26, A } },
		[12] = { { 35, A }, { 37, A }, { 38, A }, { 36, A } },
		[13] = { { 31, A }, { 33, A }, { 35, A }, { 37, A }, { 38, A }, { 36, A }, { 34, A }, { 32, A } },
		[14] = { { 25, W }, { 27, W }, { 29, W }, { 31, W }, { 33, W }, { 35, W }, { 37, W }, { 38, W }, { 36, W }, { 34, W }, { 32, W }, { 30, W }, { 28, W }, { 26, W } },
	}
}

COMPONENT.Patterns = {
	["auto_whelen_legacy_traffic"] = {
		["left"] = { 7, 7, 8, 8, 9, 9, 10, 10, 11, 11, 6, 6, 6, 6, 0, 0 },
		["right"] = { 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 6, 6, 0, 0 },
		["diverge"] = { 12, 12, 12, 13, 13, 13, 6, 6, 6, 6, 0, 0 },
		["flooed"] = { 12, 12, 12, 13, 13, 13, 6, 6, 6, 6, 0, 0 },
	},
	["auto_whelen_legacy"] = {
		["all"] = { 1, 0, 1, 0, 1, 0 },
		["code1"] = { 2, 2, 2, 2, 0, 3, 3, 3, 3, 0 },
		["code2"] = { 4, 5, 6, 5 },
		["code3"] = { 
			4, 0, 5, 0, 6, 0, 5, 0,
			4, 0, 5, 0, 6, 0, 5, 0,
			4, 0, 5, 0, 6, 0, 5, 0,
			7, 0, 8, 0, 7, 0, 8, 0,
			7, 0, 8, 0, 7, 0, 8, 0,
			7, 0, 8, 0, 7, 0, 8, 0,
			10, 10, 9, 9, 10, 10, 9, 9, 
			10, 10, 9, 9, 10, 10, 9, 9, 
			10, 10, 9, 9, 10, 10, 9, 9, 0,
			7, 0, 8, 0, 7, 0, 8, 0,
			7, 0, 8, 0, 7, 0, 8, 0,
			7, 0, 8, 0, 7, 0, 8, 0,
			11, 12, 13, 14, 15, 14, 13, 12,
			11, 12, 13, 14, 15, 14, 13, 12,
			11, 12, 13, 14, 15, 14, 13, 12,
			7, 0, 8, 0, 7, 0, 8, 0,
			7, 0, 8, 0, 7, 0, 8, 0,
			7, 0, 8, 0, 7, 0, 8, 0,
		},
	},
	["auto_whelen_legacy_corner"] = {
		["code2"] = { 1, 1, 0, 2, 2, 0 },
		["code3"] = { 1, 2, 1, 2, 1, 2, 3, 4, 3, 4, 3, 4 },
	}
}

COMPONENT.TrafficDisconnect = { 
	["auto_whelen_legacy_traffic"] = {
		25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38
	}
}

COMPONENT.Modes = {
	Primary = {
			M1 = {
				["auto_whelen_legacy"] = "code1"
			},
			M2 = {
				["auto_whelen_legacy"] = "code2",
				["auto_whelen_legacy_corner"] = "code2"	
			},
			M3 = {
				["auto_whelen_legacy"] = "code3",
				["auto_whelen_legacy_corner"] = "code3"	
			},
			M4 = {
				["auto_whelen_legacy_corner"] = "code2"
			},
		},
	Auxiliary = {},
	Illumination = {}
}

EMVU:AddAutoComponent( COMPONENT, name )