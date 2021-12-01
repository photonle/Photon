AddCSLuaFile()

local A = "AMBER"
local R = "RED"
local B = "BLUE"
local W = "WHITE"

local name = "Whelen Legacy SenCo Front"

local COMPONENT = {}

COMPONENT.Model = "models/schmal/whelen_legacy/legacy_lightbar.mdl"
COMPONENT.Skin = 0
COMPONENT.Bodygroups = {}
COMPONENT.Category = "Lightbar"
COMPONENT.UsePhases = true
COMPONENT.DefaultColors = {
	[1] = R,
	[2] = B,
	[3] = R,
	[4] = B,
}


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
		[1] = {
			{ 1, "_1" },{ 2, "_2" },
			{ 3, "_1" },{ 4, "_2" },
			{ 5, "_1" },{ 6, "_2" },
			{ 7, "_1" },{ 8, "_2" },
			{ 9, "_1" },{ 10, "_2" },
			{ 11, "_1" },{ 12, "_2" },
			{ 13, "_1" },{ 14, "_2" },
			{ 15, "_1" },{ 16, "_2" },
			{ 17, "_1" },{ 18, "_2" },
			{ 19, "_1" },{ 20, "_2" },
			{ 21, "_1" },{ 22, "_2" },
			{ 23, "_1" },{ 24, "_2" },
			{ 25, "_1" },{ 26, "_2" },
			{ 27, "_1" },{ 28, "_2" },
			{ 29, "_1" },{ 30, "_2" },
			{ 31, "_1" },{ 32, "_2" },
			{ 33, "_1" },{ 34, "_2" },
			{ 35, "_1" },{ 36, "_2" },
			{ 37, "_1" },{ 38, "_2" },
			{ 39, W },{ 40, W },
			{ 41, W },{ 42, W },
		},
		[2] = {
			{ 1, "_1" }, { 3, "_1" }, { 5, "_1" }, { 7, "_1" }, { 9, "_1" }, { 11, "_1" }, { 13, "_1" }, { 15, "_1" }, { 17, "_1" },
		},
		[3] = {
			{ 2, "_2" }, { 4, "_2" }, { 6, "_2" }, { 8, "_2" }, { 10, "_2" }, { 12, "_2" }, { 14, "_2" }, { 16, "_2" }, { 18, "_2" },
		},
		[4] = {
			{ 9, "_1" }, { 11, "_1" },
		},
		[5] = {
			{ 5, "_1" }, { 7, "_1" }, { 6, "_2" }, { 8, "_2" },
		},
		[6] = {
			{ 1, "_1" }, { 3, "_1" }, { 10, "_2" }, { 12, "_2" },
		},
		[7] = {
			{ 9, "_1" }, { 11, "_1" },
			{ 1, "_1" }, { 3, "_1" },
			{ 6, "_2" }, { 8, "_2" },
		},
		[8] = {
			{ 2, "_2" }, { 4, "_2" },
			{ 10, "_2" }, { 12, "_2" },
			{ 5, "_1" }, { 7, "_1" },
		},
		[9] = {
			{ 9, "_1" }, { 11, "_1" },
			{ 1, "_1" }, { 3, "_1" },
			{ 6, "_2" }, { 8, "_2" },
		},
		[10] = {
			{ 2, "_2" }, { 4, "_2" },
			{ 10, "_2" }, { 12, "_2" },
			{ 5, "_1" }, { 7, "_1" },
		},
		[11] = {
			 { 5, "_1" }, { 7, "_1" }, { 9, "_1" }, { 11, "_1" },
		},
		[12] = {
			{ 5, "_1" }, { 7, "_1" }, { 1, "_1" }, { 3, "_1" },
		},
		[13] = {
			{ 1, "_1" }, { 3, "_1" }, { 2, "_2" }, { 4, "_2" },
		},
		[14] = {
			 { 2, "_2" }, { 4, "_2" }, { 6, "_2" }, { 8, "_2" },
		},
		[15] = {
			{ 6, "_2" }, { 8, "_2" }, { 10, "_2" }, { 12, "_2" },
		}
	},
	["auto_whelen_legacy_corner"] = {
		[1] = { { 13, "_3" }, { 15, "_3" }, { 17, "_3" } },
		[2] = { { 14, "_4" }, { 16, "_4" }, { 18, "_4" } },
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