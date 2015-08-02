AddCSLuaFile()

local A = "AMBER"
local R = "RED"
local DR = "D_RED"
local B = "BLUE"
local W = "WHITE"
local CW = "C_WHITE"
local SW = "S_WHITE"
local G = "GREEN"

local name = "Whelen Legacy"

local COMPONENT = {}

COMPONENT.Model = "models/schmal/whelen_legacy/legacy_lightbar.mdl"
COMPONENT.Skin = 0
COMPONENT.Bodygroups = {}

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
			{ 1, R }, { 3, R }, { 5, R }, { 7, R }, { 9, R }, { 11, R }, { 13, R }, { 15, R }, { 17, R }, { 19, R }, { 21, R }, { 23, R }, { 25, R }, { 27, R }, { 29, R }, { 31, R }, { 33, R }, { 35, R }, { 37, R }, 
		},
		{
			{ 2, B }, { 4, B }, { 6, B }, { 8, B }, { 10, B }, { 12, B }, { 14, B }, { 16, B }, { 18, B }, { 20, B }, { 22, B }, { 24, B }, { 26, B }, { 28, B }, { 30, B }, { 32, B }, { 34, B }, { 36, B }, { 38, B }, 
		},
		[4] = {
			{ 9, R }, { 11, R }, { 25, R }, { 27, R }, { 29, R }, { 2, B }, { 4, B }, { 36, B }, { 38, B }
		},
		[5] = {
			{ 5, R }, { 7, R }, { 31, R }, { 33, R }, { 6, B }, { 8, B }, { 32, B }, { 34, B },
		},
		[6] = {
			{ 1, R }, { 3, R }, { 35, R }, { 37, R }, { 10, B }, { 12, B },  { 26, B }, { 28, B }, { 30, B },
		},
		[7] = {
			{ 9, R }, { 11, R }, 
			{ 1, R }, { 3, R }, 
			{ 25, R }, { 27, R }, { 29, R }, 
			{ 35, R }, { 37, R }, 
			{ 6, W }, { 8, W }, 
			{ 32, A }, { 34, A }, 
		},
		[8] = {
			{ 2, B }, { 4, B }, 
			{ 10, B }, { 12, B },  
			{ 36, B }, { 38, B }, 
			{ 26, B }, { 28, B }, { 30, B }, 
			{ 5, W }, { 7, W }, 
			{ 31, A }, { 33, A },
		},
		[9] = {
			{ 9, W }, { 11, W }, 
			{ 1, W }, { 3, W }, 
			{ 25, A }, { 27, A }, { 29, A }, 
			{ 35, A }, { 37, A }, 
			{ 6, B }, { 8, B }, 
			{ 32, B }, { 34, B }, 
		},
		[10] = {
			{ 2, W }, { 4, W }, 
			{ 10, W }, { 12, W },  
			{ 36, A }, { 38, A }, 
			{ 26, A }, { 28, A }, { 30, A }, 
			{ 5, R }, { 7, R }, 
			{ 31, R }, { 33, R },
		},
		[11] = {
			 { 5, R }, { 7, R }, { 9, R }, { 11, R }, { 25, R }, { 27, R }, { 29, R }, { 31, R }, { 33, R },
		},
		[12] = {
			{ 5, R }, { 7, R }, { 31, R }, { 33, R }, { 1, R }, { 3, R }, { 35, R }, { 37, R },
		},
		[13] = {
			{ 35, R }, { 37, R }, { 1, R }, { 3, R }, { 2, B }, { 4, B }, { 36, B }, { 38, B },
		},
		[14] = {
			 { 2, B }, { 4, B }, { 36, B }, { 38, B }, { 6, B }, { 8, B }, { 32, B }, { 34, B }, 
		},
		[15] = {
			{ 6, B }, { 8, B }, { 32, B }, { 34, B }, { 10, B }, { 12, B },  { 26, B }, { 28, B }, { 30, B },
		}
	},
	["auto_whelen_legacy_corner"] = {
		[1] = { { 13, R }, { 15, R }, { 17, R }, { 19, R }, { 21, R }, { 23, R } },
		[2] = { { 14, B }, { 16, B }, { 18, B }, { 20, B }, { 22, B }, { 24, B } },
		[3] = { { 13, R }, { 15, R }, { 17, R }, { 19, R }, { 21, R }, { 23, R }, { 14, W }, { 16, W }, { 18, W }, { 20, W }, { 22, W }, { 24, W } },
		[4] = { { 14, B }, { 16, B }, { 18, B }, { 20, B }, { 22, B }, { 24, B }, { 13, W }, { 15, W }, { 17, W }, { 19, W }, { 21, W }, { 23, W } },
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
	}
}

COMPONENT.Patterns = {
	["auto_whelen_legacy_traffic"] = {
		["left"] = { 7, 7, 8, 8, 9, 9, 10, 10, 11, 11, 6, 6, 6, 6, 0, 0 },
		["right"] = { 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 6, 6, 0, 0 },
		["diverge"] = { 12, 12, 12, 13, 13, 13, 6, 6, 6, 6, 0, 0 },
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
			}
		},
	Auxiliary = {
			L = {
				["auto_whelen_legacy_traffic"] = "left"
			},
			R = {
				["auto_whelen_legacy_traffic"] = "right"
			},
			D = {
				["auto_whelen_legacy_traffic"] = "diverge"
			}
		},
	Illumination = {

	}
}

EMVU:AddAutoComponent( COMPONENT, name )