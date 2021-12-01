AddCSLuaFile()

local name = "Dodge Charger SRT8 2012 Police"

local A = "AMBER"
local R = "RED"
local B = "BLUE"
local W = "WHITE"
local SW = "S_WHITE"

local EMV = {}

EMV.Siren = 7

EMV.Color = nil
EMV.Skin = 0

EMV.BodyGroups = {}
EMV.Props = {}

EMV.Meta = {
	grille_leds = {
		AngleOffset = -90,
		W = 5.7,
		H = 5.4,
		Sprite = "sprites/emv/tdm_grille_leds",
		Scale = 1,
		WMult = 1.4,
	},
	side_leds = {
		AngleOffset = -90,
		W = 5.7,
		H = 5.4,
		Sprite = "sprites/emv/tdm_grille_leds",
		Scale = 1,
		WMult = 1.4,
	},
	freedom_f_inner = {
		AngleOffset = -90,
		W = 7.2,
		H = 8.4,
		Sprite = "sprites/emv/whelen_freedom_main",
		Scale = 1.75,
		WMult = 1.24,
	},
	freedom_f_corner = {
		AngleOffset = -90,
		W = 9.5,
		H = 8,
		Sprite = "sprites/emv/whelen_freedom_main",
		Scale = 1.75,
		WMult = 2,
	},
	freedom_r_corner = {
		AngleOffset = 90,
		W = 9.5,
		H = 8,
		Sprite = "sprites/emv/whelen_freedom_main",
		Scale = 1.75,
		WMult = 2,
	},
	freedom_r_inner = {
		AngleOffset = 90,
		W = 7.2,
		H = 8.4,
		Sprite = "sprites/emv/whelen_freedom_main",
		Scale = 1.75,
		WMult = 1.24,
	},
	freedom_takedown = {
		AngleOffset = -90,
		W = 6.7,
		H = 7.5,
		Sprite = "sprites/emv/tdm_halogen2",
		Scale = 1.2,
		WMult = 1.3,
	},
	freedom_r_halogen = {
		AngleOffset = 90,
		W = 6.4,
		H = 7.5,
		Sprite = "sprites/emv/tdm_halogen2",
		Scale = 1.2,
		WMult = 1.3,
	},
	freedom_alley = {
		AngleOffset = -90,
		W = 5.5,
		H = 6,
		Sprite = "sprites/emv/whelen_freedom_alley",
		Scale = 1.2,
		WMult = 1.3,
	},
	liberty_front = {
		AngleOffset = -90,
		W = 7.4,
		H = 7.5,
		Sprite = "sprites/emv/emv_whelen_src",
		Scale = 1,
		WMult = 1.66,
	},
	liberty_rear = {
		AngleOffset = 90,
		W = 7.4,
		H = 7.5,
		Sprite = "sprites/emv/emv_whelen_src",
		Scale = 1,
		WMult = 1.66,
	},
	liberty_f_corner = {
		AngleOffset = -90,
		W = 14.5,
		H = 14.4,
		Sprite = "sprites/emv/emv_whelen_corner",
		Scale = 1,
		WMult = 2.2,
	},
	liberty_r_corner = {
		AngleOffset = 90,
		W = 14.5,
		H = 14.4,
		Sprite = "sprites/emv/emv_whelen_corner",
		Scale = 1,
		WMult = 2.2,
	},
	liberty_takedown = {
		AngleOffset = -90,
		W = 7,
		H = 7,
		Sprite = "sprites/emv/emv_whelen_6x2",
		Scale = 1,
		WMult = 2.2,
	},
	liberty_alley = {
		AngleOffset = -90,
		W = 2.2,
		H = 2.2,
		Sprite = "sprites/emv/emv_whelen_tri",
		Scale = 1,
		WMult = 1,
	},
	rear_int_bar = {
		AngleOffset = 90,
		W = 4,
		H = 3,
		Sprite = "sprites/emv/tdm_charger_rear_int",
		Scale = 1,
		WMult = 1.5,
	},
	front_inner_default = {
		AngleOffset = -90,
		W = 4.1,
		H = 3.2,
		Sprite = "sprites/emv/tdm_charger_rear_int",
		Scale = 1,
		WMult = 1.5,
	},
	front_vipers = {
		AngleOffset = -90,
		W = 4,
		H = 4,
		Sprite = "sprites/emv/tdm_viper",
		Scale = 1,
		WMult = 1,
	},
	front_viper_low = {
		AngleOffset = -90,
		W = 4,
		H = 4,
		Sprite = "sprites/emv/tdm_viper",
		Scale = 1,
		WMult = 1,
	},
	rear_vipers = {
		AngleOffset = 90,
		W = 4,
		H = 4,
		Sprite = "sprites/emv/tdm_viper",
		Scale = 1,
		WMult = 1,
	},
	bumper_vertex = {
		AngleOffset = -90,
		W = 2,
		H = 2,
		Sprite = "sprites/emv/emv_whelen_vertex",
		Scale = 1,
		WMult = 1,
	},
	bumper_upper = {
		AngleOffset = -90,
		W = 4,
		H = 4,
		Sprite = "sprites/emv/emv_1x3",
		Scale = 1,
		WMult = 1,
	},
	bumper_side = {
		AngleOffset = -90,
		W = 4.6,
		H = 4.6,
		Sprite = "sprites/emv/emv_whelen_src",
		Scale = 1,
		WMult = 1,
	},
	valor_forward = {
		AngleOffset = -90,
		W = 5.2,
		H = 5,
		Sprite = "sprites/emv/fs_valor",
		Scale = 1,
		WMult = 1.5,
	},
	valor_side = {
		AngleOffset = -90,
		W = 4.5,
		H = 5,
		Sprite = "sprites/emv/fs_valor",
		Scale = 1,
		WMult = 1.2,
	},
	valor_backward = {
		AngleOffset = 90,
		W = 5.8,
		H = 5,
		Sprite = "sprites/emv/fs_valor",
		Scale = 1,
		WMult = 1.7,
	},
	headlight = {
		AngleOffset = -90,
		W = 3.5,
		H = 3.5,
		Sprite = "sprites/emv/light_circle",
		Scale = 2.5,
		WMult = 1
	},

	tail_light = {
		AngleOffset = 90,
		W = 28,
		H = 16,
		Sprite = "sprites/emv/tdm_charger_tail",
		Scale = 1,
		SourceOnly = true,
		WMult = 1.5,
	},

	tail_glow = {
		AngleOffset = 90,
		W = 0,
		H = 0,
		Sprite = "sprites/emv/light_circle",
		Scale = 2,
		WMult = 1
	},

	reverse = {
		AngleOffset = 90,
		W = 8,
		H = 7,
		Sprite = "sprites/emv/tdm_charger_reverse",
		Scale = 1,
		WMult = 1.2
	},
	spotlight = {
		AngleOffset = -90,
		W = 7,
		H = 7,
		Sprite = "sprites/emv/light_circle",
		Scale = 3,
	}
}

EMV.Positions = {

	[1] = { Vector( 8.75, 117.13, 32.07 ), Angle( 0, -12, 0 ), "grille_leds" }, -- 1
	[2] = { Vector( -8.75, 117.13, 32.07 ), Angle( 0, 12, 0 ), "grille_leds" }, -- 2

	[3] = { Vector( 38.29, -52.3, 56.7 ), Angle( -2.7, -92.5, 22 ), "side_leds" },
	[4] = { Vector( -38.29, -52.3, 56.7 ), Angle( 2, 91, 22 ), "side_leds" },

	[5] = { Vector( 22.7, -84, 59.1 ), Angle( 0, 0, 0 ), "rear_int_bar" },
	[6] = { Vector( -22.7, -84, 59.1 ), Angle( 0, 0, 0 ), "rear_int_bar" },

	[7] = { Vector( 18.78, -84, 59.1 ), Angle( 0, 0, 0 ), "rear_int_bar" },
	[8] = { Vector( -18.78, -84, 59.1 ), Angle( 0, 0, 0 ), "rear_int_bar" },

	[9] = { Vector( 14.81, -84, 59.1 ), Angle( 0, 0, 0 ), "rear_int_bar" },
	[10] = { Vector( -14.81, -84, 59.1 ), Angle( 0, 0, 0 ), "rear_int_bar" },

	[11] = { Vector( 10.9, -84, 59.1 ), Angle( 0, 0, 0 ), "rear_int_bar" },
	[12] = { Vector( -10.9, -84, 59.1 ), Angle( 0, 0, 0 ), "rear_int_bar" },

	[13] = { Vector( 7, -84, 59.1 ), Angle( 0, 0, 0 ), "rear_int_bar" },
	[14] = { Vector( -7, -84, 59.1 ), Angle( 0, 0, 0 ), "rear_int_bar" },

	[15] = { Vector( 5.18, 26.19, 66.56 ), Angle( 0, 0, 0 ), "front_inner_default" },
	[16] = { Vector( -5.18, 26.19, 66.56 ), Angle( 0, 0, 0 ), "front_inner_default" },

	[17] = { Vector( 24.87, 19.29, 66.97 ), Angle( 5, 0, 0 ), "front_vipers" },
	[18] = { Vector( -24.87, 19.29, 66.97 ), Angle( -5, 0, 0 ), "front_vipers" },

	[19] = { Vector( 2.05, 47.29, 55.07 ), Angle( 0, 0, 0 ), "front_viper_low" },
	[20] = { Vector( -2.05, 47.29, 55.07 ), Angle( 0, 0, 0 ), "front_viper_low" },

	[21] = { Vector( 22.58, -64.83, 66.18 ), Angle( 4, 0, 0 ), "rear_vipers" },
	[22] = { Vector( -22.58, -64.83, 66.18 ), Angle( -4, 0, 0 ), "rear_vipers" },

	[23] = { Vector( 18.5, -64.83, 66.45 ), Angle( 4, 0, 0 ), "rear_vipers" },
	[24] = { Vector( -18.5, -64.83, 66.45 ), Angle( -4, 0, 0 ), "rear_vipers" },

	[25] = { Vector( 25.65, 114.73, 34.57 ), Angle( -9.65, -75.94, 33.81 ), "bumper_vertex" },
	[26] = { Vector( -25.65, 114.73, 34.57 ), Angle( 9.65, 75.94, 33.81 ), "bumper_vertex" },

	[27] = { Vector( 8.55, 123.96, 41.57 ), Angle( 0, 0, 0 ), "bumper_upper" },
	[28] = { Vector( -8.55, 123.96, 41.57 ), Angle( 0, 0, 0 ), "bumper_upper" },

	[29] = { Vector( 20.05, 123.93, 35.01 ), Angle( -90, -90, 0 ), "bumper_side" },
	[30] = { Vector( -20.15, 123.93, 35.01 ), Angle( 90, 90, 0 ), "bumper_side" },

	-- WHELEN AMERICA --

	[31] = { Vector( 9.64, -13.76, 78.4 ), Angle( 0, 0, 0 ), "freedom_f_inner" },
	[32] = { Vector( -9.64, -13.76, 78.4 ), Angle( 0, 0, 0 ), "freedom_f_inner" },

	[33] = { Vector( 25.15, -15.22, 78.41 ), Angle( 0, -16.3, 0 ), "freedom_f_corner" },
	[34] = { Vector( -25.15, -15.22, 78.41 ), Angle( 0, 16.3, 0 ), "freedom_f_corner" },

	[35] = { Vector( 25.15, -23.24, 78.41 ), Angle( 0, 16.3, 0 ), "freedom_r_corner" },
	[36] = { Vector( -25.15, -23.24, 78.41 ), Angle( 0, -16.3, 0 ), "freedom_r_corner" },

	[37] = { Vector( 9.64, -24.7, 78.41 ), Angle( 0, 0, 0 ), "freedom_r_inner" },
	[38] = { Vector( -9.64, -24.7, 78.41 ), Angle( 0, 0, 0 ), "freedom_r_inner" },

	[39] = { Vector( 16.79, -13.89, 78.43 ), Angle( 0, 0, 0 ), "freedom_takedown" },
	[40] = { Vector( -16.79, -13.89, 78.43 ), Angle( 0, 0, 0 ), "freedom_takedown" },

	[41] = { Vector( 16.79, -24.7, 78.43 ), Angle( 0, 0, 0 ), "freedom_r_halogen" },
	[42] = { Vector( -16.79, -24.7, 78.43 ), Angle( 0, 0, 0 ), "freedom_r_halogen" },

	[43] = { Vector( 29.8, -19.26, 78.42 ), Angle( 0, -90, 0 ), "freedom_alley" },
	[44] = { Vector( -29.8, -19.26, 78.42 ), Angle( 0, 90, 0 ), "freedom_alley" },

	-- WHELEN LIBERTY --

	[45] = { Vector( 10.19, -13.72, 77.88 ), Angle( 0, 0, 0 ), "liberty_front" },
	[46] = { Vector( -10.19, -13.72, 77.88 ), Angle( 0, 0, 0 ), "liberty_front" },

	[47] = { Vector( 16.96, -13.72, 77.88 ), Angle( 0, 0, 0 ), "liberty_front" },
	[48] = { Vector( -16.96, -13.72, 77.88 ), Angle( 0, 0, 0 ), "liberty_front" },

	[49] = { Vector( 25.2, -16.03, 77.88 ), Angle( 0, -23, 0 ), "liberty_f_corner" },
	[50] = { Vector( -25.2, -16.03, 77.88 ), Angle( 0, 23, 0 ), "liberty_f_corner" },

	[51] = { Vector( 25.2, -22.47, 77.88 ), Angle( 0, 23, 0 ), "liberty_r_corner" },
	[52] = { Vector( -25.2, -22.47, 77.88 ), Angle( 0, -23, 0 ), "liberty_r_corner" },

	[53] = { Vector( 16.96, -24.72, 77.88 ), Angle( 0, 0, 0 ), "liberty_rear" },
	[54] = { Vector( -16.96, -24.72, 77.88 ), Angle( 0, 0, 0 ), "liberty_rear" },

	[55] = { Vector( 10.19, -24.72, 77.88 ), Angle( 0, 0, 0 ), "liberty_rear" },
	[56] = { Vector( -10.19, -24.72, 77.88 ), Angle( 0, 0, 0 ), "liberty_rear" },

	[57] = { Vector( 3.45, -24.72, 77.88 ), Angle( 0, 0, 0 ), "liberty_rear" },
	[58] = { Vector( -3.45, -24.72, 77.88 ), Angle( 0, 0, 0 ), "liberty_rear" },

	[59] = { Vector( 3.39, -13.61, 77.88 ), Angle( 0, 0, 0 ), "liberty_takedown" },
	[60] = { Vector( -3.39, -13.61, 77.88 ), Angle( 0, 0, 0 ), "liberty_takedown" },

	[61] = { Vector( 29.91, -19.26, 77.91 ), Angle( 0, -90, 0 ), "liberty_alley" },
	[62] = { Vector( -29.91, -19.26, 77.91 ), Angle( 0, 90, 0 ), "liberty_alley" },

	-- IT'S THE MOTHEFUCKING FEDERAL SIGNAL VALOR BABY AWWW FUCK YEAH --

	[63] = { Vector( 2.36, -3.53, 77.56 ), Angle( 0, -40.07, 0 ), "valor_forward" },
	[64] = { Vector( -2.36, -3.53, 77.56 ), Angle( 0, 40.07, 0 ), "valor_forward" },

	[65] = { Vector( 6.5, -7.02, 77.56 ), Angle( 0, -40.07, 0 ), "valor_forward" },
	[66] = { Vector( -6.5, -7.02, 77.56 ), Angle( 0, 40.07, 0 ), "valor_forward" },

	[67] = { Vector( 10.64, -10.51, 77.56 ), Angle( 0, -40.07, 0 ), "valor_forward" },
	[68] = { Vector( -10.64, -10.51, 77.56 ), Angle( 0, 40.07, 0 ), "valor_forward" },

	[69] = { Vector( 14.78, -14, 77.56 ), Angle( 0, -40.07, 0 ), "valor_forward" },
	[70] = { Vector( -14.78, -14, 77.56 ), Angle( 0, 40.07, 0 ), "valor_forward" },

	[71] = { Vector( 19.52, -15.66, 77.56 ), Angle( 0, 0, 0 ), "valor_forward" },
	[72] = { Vector( -19.52, -15.66, 77.56 ), Angle( 0, 0, 0 ), "valor_forward" },

	[73] = { Vector( 25.28, -17.71, 77.56 ), Angle( 0, -40, 0 ), "valor_forward" },
	[74] = { Vector( -25.28, -17.71, 77.56 ), Angle( 0, 40, 0 ), "valor_forward" },

	[75] = { Vector( 27.32, -22.44, 77.56 ), Angle( 0, -85, 0 ), "valor_side" },
	[76] = { Vector( -27.32, -22.44, 77.56 ), Angle( 0, 85, 0 ), "valor_side" },

	[77] = { Vector( 22.1, -25.9, 77.56 ), Angle( 0, 0, 0 ), "valor_backward" },
	[78] = { Vector( -22.1, -25.9, 77.56 ), Angle( 0, 0, 0 ), "valor_backward" },

	[79] = { Vector( 15.8, -25.9, 77.56 ), Angle( 0, 0, 0 ), "valor_backward" },
	[80] = { Vector( -15.8, -25.9, 77.56 ), Angle( 0, 0, 0 ), "valor_backward" },

	[81] = { Vector( 9.48, -25.9, 77.56 ), Angle( 0, 0, 0 ), "valor_backward" },
	[82] = { Vector( -9.48, -25.9, 77.56 ), Angle( 0, 0, 0 ), "valor_backward" },

	[83] = { Vector( 3.16, -25.9, 77.56 ), Angle( 0, 0, 0 ), "valor_backward" },
	[84] = { Vector( -3.16, -25.9, 77.56 ), Angle( 0, 0, 0 ), "valor_backward" },

	[85] = { Vector( 36.9, 104.91, 38.5 ), Angle( 0, 2, 0 ), "headlight" },
	[86] = { Vector( -36.9, 104.91, 38.5 ), Angle( 0, -2, 0 ), "headlight" },

	[87] = { Vector( 37.3, -116.57, 46.6 ), Angle( 0, 13.2, 0 ), "tail_light" },
	[88] = { Vector( -37.3, -116.57, 46.6 ), Angle( 180, -13.2, 0 ), "tail_light" },

	[89] = { Vector( 33.5, -118.17, 46.6 ), Angle( 0, 13.2, 0 ), "tail_glow" },
	[90] = { Vector( -33.5, -118.17, 46.6 ), Angle( 0, -13.2, 0 ), "tail_glow" },

	[91] = { Vector( 23.92, -119.92, 46.9 ), Angle( 0, 10.7, 0 ), "reverse" },
	[92] = { Vector( -23.92, -119.92, 46.9 ), Angle( 180, -10.7, 180 ), "reverse" },

	[93] = { Vector( 39.74, 40.84, 62.89 ), Angle( 17.26, 0, 0 ), "spotlight" },
	[94] = { Vector( -39.74, 40.84, 62.89 ), Angle( -17.26, 0, 0 ), "spotlight" },

}

EMV.Sections = {
	["headlights"] = {
		{ { 85, SW, { 16, .25, 0 } }, { 86, SW, { 16, .25, 10 } } }
	},
	["reverse"] = {
		{ { 87, R }, { 89, R }, { 92, B } },
		{ { 88, R }, { 90, R }, { 91, B } }
	},
	["grille_leds"] = {
		{ { 1, B }, { 2, R } },
		{ { 1, B } },
		{ { 2, R } },
		{ { 1, B }, { 2, B } },
		{ { 1, R }, { 2, R } },
		{ { 1, B }, { 2, R } },
		{ { 2, B } },
		{ { 1, R } }
	},
	["bumper_vertex"] = {
		{ { 25, B }, { 26, R } },
		{ { 26, R } },
		{ { 27, B } }
	},
	["bumper_upper"] = {
		{ { 27, B }, { 28, R } },
		{ { 27, B } },
		{ { 28, R } }
	},
	["bumper_side"] = {
		{ { 29, B }, { 30, R } }
	},
	["side_leds"] = {
		{ { 3, R }, { 4, R } },
		{ { 3, B }, { 4, B } },
		{ { 3, W }, { 4, W } },
	},

	["rear_int_bar"] = {
		{ { 5, A }, { 6 , A }, { 7 , A }, { 8 , A }, { 9 , A }, { 10, A }, { 11, A }, { 12, A }, { 13, A }, { 14, A }, },

		{ { 5, B }, { 7, B }, { 9, B }, { 11, B }, { 13, B } },
		{ { 6, R }, { 8, R }, { 10, R }, { 12, R }, { 14, R } },

		{ { 5, B }, { 6, R }, { 13, B }, { 14, R } },
		{ { 7, B }, { 8, R }, { 9, B }, { 10, R }, { 11, B }, { 12, R } },

		{ { 5, B }, { 9, B }, { 13, B }, { 8, R }, { 12, R } },
		{ { 6, R }, { 10, R }, { 14, R }, { 7, B }, { 11, B } },

		{ { 5, B }, { 7, B } },
		{ { 6, R }, { 8, R } }
	},

	["traffic_rb"] = {
		{ { 6, B } },
		{ { 5, R } }
	},

	["traffic"] = {
		--  { 6 , A }, { 7 , A }, { 8 , A }, { 9 , A }, { 10, A }, { 11, A }, { 12, A }, { 13, A },
		--{ { 35, A }, { 36, A }, { 37, A }, { 38, A }, { 39, A }, { 40, A }, { 41, A }, { 42, A } },
		-- 2 -> 8
		-- 8 <- 2

		{ { 7, A } },
		{ { 7, A }, { 9, A } },
		{ { 9, A }, { 11, A } },
		{ { 11, A }, { 13, A } },
		{ { 13, A }, { 14, A } },
		{ { 14, A }, { 12, A } },
		{ { 12, A }, { 10, A } },
		{ { 10, A }, { 8, A } },
		{ { 8, A } },

		-- 10
		{ { 13, A }, { 14, A } },
		{ { 11, A }, { 12, A } },
		{ { 9, A }, { 10, A } },
		{ { 7, A }, { 8, A } },

		-- 14
		{ { 7, A }, { 9, A }, { 6, A }, { 10, A } },
		{ { 11, A }, { 13, A }, { 14, A }, { 12, A } },
		-- 16
		{ { 7, A }, { 9, A }, { 14, A }, { 12, A } },
		{ { 11, A }, { 13, A }, { 10, A }, { 8, A } },
		-- 18
		{ { 8, A }, { 10, A }, { 12, A }, { 14, A } },
		{ { 7, A }, { 9, A }, { 11, A }, { 13, A } },

		-- 20
		{},

		{ { 5, A }, { 6 , A }, { 7 , A }, { 8 , A }, { 9 , A }, { 10, A }, { 11, A }, { 12, A }, { 13, A }, { 14, A }, }, -- 1 -> 21

		{ { 5, B }, { 7, B }, { 9, B }, { 11, B }, { 13, B } },
		{ { 6, R }, { 8, R }, { 10, R }, { 12, R }, { 14, R } },

		{ { 5, B }, { 6, R }, { 13, B }, { 14, R } },
		{ { 7, B }, { 8, R }, { 9, B }, { 10, R }, { 11, B }, { 12, R } },

		{ { 5, B }, { 9, B }, { 13, B }, { 8, R }, { 12, R } },
		{ { 6, R }, { 10, R }, { 14, R }, { 7, B }, { 11, B } },

		{ { 5, B }, { 7, B } },
		{ { 6, R }, { 8, R } }
	},

	["rear_int_vipers"] = {
		{ { 21, R }, { 22, B }, { 23, R }, { 24, B} },
		{ { 21, R }, { 22, B } },
		{ { 23, R }, { 24, B } },
	},
	["front_inner_default"] = {
		{ { 15, R }, { 16, B } },
		{ { 15, R } },
		{ { 16, B } }
	},
	["front_vipers"] = {
		{ { 17, B }, { 18, R } },
		{ { 17, B } },
		{ { 18, R } }
	},
	["front_low_viper"] = {
		{ { 19, B }, { 20, R } },
		{ { 19, B } },
		{ { 20, R } }
	},

	-- WHELEN FREEDOM --
	["lightbar_freedom"] = {
		{
			{ 31, B }, { 32, R }, { 33, B }, { 34, R }, { 35, B }, { 36, R }, { 37, B }, { 38, R }, { 39, W }, { 40, W }, { 41, R }, { 42, B }, { 43, W }, { 44, W }
		}
	},

	["lightbar_freedom_corner"] = {
		{ { 33, B }, { 34, R }, { 35, B }, { 36, R } },
		{ { 33, B }, { 35, B } },
		{ { 34, R }, { 36, R } }
	},

	["lightbar_freedom_inner"] = {
		{ { 37, B }, { 42, B } },
		{ { 38, R }, { 41, R } },
		{ { 37, B }, { 31, B }, { 42, B } },
		{ { 38, R }, { 32, R }, { 41, R } }
	},

	["lightbar_freedom_illum"] = {
		{ { 39, W }, { 43, W } },
		{ { 40, W }, { 44, W } }
	},

	-- WHELEN LIBERTY LIGHTBAR --

	["lightbar_liberty"] = {
		{
			{ 45, B }, { 46, R }, { 47, B }, { 48, R }, { 49, B }, { 50, R }, { 51, B }, { 52, R }, { 53, B }, { 54, R },
			{ 55, B }, { 56, R }, { 57, B }, { 58, R }, { 59, W }, { 60, W }, { 61, W }, { 62, W }
		},
		{
			{ 45, B }, { 47, B }, { 49, B }, { 51, B }, { 53, B }, { 55, B }, { 57, B }
		},
		{
			{ 46, R }, { 48, R }, { 50, R }, { 52, R }, { 54, R }, { 56, R }, { 58, R }
		},
		{ { 53, B }, { 47, B } },
		{ { 54, R }, { 48, R } },
	},

	["lightbar_liberty_corner"] = {
		{ { 49, B, .5 }, { 50, R, .5 }, { 51, B, .5 }, { 52, R, .5 } },
		{ { 49, B, 1 }, { 50, R, .5 }, { 51, B, 1 }, { 52, R, .5 } },
		{ { 49, B, .5 }, { 50, R, 1 }, { 51, B, .5 }, { 52, R, 1 } },
		{ { 49, B }, { 51, B } },
		{ { 50, R }, { 52, R } }
	},
	["lightbar_liberty_inner"] = {
		{ { 54, R }, { 56, R } },
		{ { 55, B }, { 53, B } },
		{ { 55, B }, { 57, B }, { 45, B } },
		{ { 56, R }, { 58, R }, { 46, R } },
	},
	["lightbar_liberty_illum"] = {
		{ { 59, W }, { 60, W }, { 61, W }, { 62, W } },
		{ { 59, W }, { 61, W } },
		{ { 60, W }, { 62, W } }
	},

	-- MOTHERFUCKIN VALOR --
	["lightbar_valor"] = {
		{
			{ 63, B }, { 64, R },
			{ 65, B }, { 66, R },
			{ 67, B }, { 68, R }, { 69, B }, { 70, R }, { 71, B }, { 72, R }, { 73, B }, { 74, R }, { 75, B }, { 76, R },
			{ 77, B }, { 78, R }, { 79, B }, { 80, R }, { 81, B }, { 82, R }, { 83, B }, { 84, R }
		},

		{ { 63, B }, { 65, B }, { 67, B }, { 69, B }, { 71, B }, { 73, B }, { 75, B }, { 77, B }, { 79, B }, { 81, B }, { 83, B } },
		{ { 64, R }, { 66, R }, { 68, R }, { 70, R }, { 72, R }, { 74, R }, { 76, R }, { 78, R }, { 80, R }, { 82, R }, { 84, R } },

		{ { 63, R }, { 65, R }, { 67, R }, { 69, R }, { 71, R }, { 73, R }, { 75, R }, { 77, R }, { 79, R }, { 81, R }, { 83, R } },
		{ { 64, B }, { 66, B }, { 68, B }, { 70, B }, { 72, B }, { 74, B }, { 76, B }, { 78, B }, { 80, B }, { 82, B }, { 84, B } },

		-- 6 -> 9

		{ { 63, B }, { 67, B }, { 71, B }, { 75, B }, { 79, B }, { 83, B }, { 82, B }, { 78, B }, { 74, B }, { 70, B }, { 66, B } },
		{ { 64, R }, { 68, R }, { 72, R }, { 76, R }, { 80, R }, { 84, R }, { 81, R }, { 77, R }, { 73, R }, { 69, R }, { 65, R } },

		{ { 63, R }, { 67, R }, { 71, R }, { 75, R }, { 79, R }, { 83, R }, { 82, R }, { 78, R }, { 74, R }, { 70, R }, { 66, R } },
		{ { 64, B }, { 68, B }, { 72, B }, { 76, B }, { 80, B }, { 84, B }, { 81, B }, { 77, B }, { 73, B }, { 69, B }, { 65, B } },

		-- 10 -> 13

		{ { 63, B }, { 67, R }, { 71, B }, { 75, R }, { 79, B }, { 83, R }, { 82, B }, { 78, R }, { 74, B }, { 70, R }, { 66, B } },
		{ { 64, R }, { 68, B }, { 72, R }, { 76, B }, { 80, R }, { 84, B }, { 81, R }, { 77, B }, { 73, R }, { 69, B }, { 65, R } },

		{ { 63, R }, { 67, B }, { 71, R }, { 75, B }, { 79, R }, { 83, B }, { 82, R }, { 78, B }, { 74, R }, { 70, B }, { 66, R } },
		{ { 64, B }, { 68, R }, { 72, B }, { 76, R }, { 80, B }, { 84, R }, { 81, B }, { 77, R }, { 73, B }, { 69, R }, { 65, B } },

		-- 14

		{ { 63, B }, { 67, B }, { 71, R }, { 75, B }, { 79, B }, { 81, B }, { 64, R }, { 68, R }, { 72, B }, { 76, R }, { 80, R }, { 82, R } },
		{ { 65, R }, { 69, R }, { 73, B }, { 77, R }, {83, R }, { 84, B }, { 78, B }, { 74, R }, { 70, B }, { 66, B } },

		-- 16

		{ { 63, W }, { 65, W }, { 67, W }, { 69, W }, { 71, W }, { 73, W }, { 75, W }, { 77, W }, { 79, W }, { 81, W }, { 83, W } },
		{ { 64, W }, { 66, W }, { 68, W }, { 70, W }, { 72, W }, { 74, W }, { 76, W }, { 78, W }, { 80, W }, { 82, W }, { 84, W } },


	},



}

EMV.Patterns = {
	["headlights"] = {
		["code3"] = { 1 }
	},
	["reverse"] = {
		["flash"] = { 1, 0, 1, 0, 2, 0, 2, 0 }
	},
	["grille_leds"] = {
		["flash"] = { 1, 0, 1, 0, 0, 0, },
		["code2"] = { 2, 2, 2, 0, 0, 3, 3, 3, 0, 0 },
		["code3"] = { 2, 0, 2, 0, 2, 0, 3, 0, 3, 0, 3, 0 }
	},
	["side_leds"] = {
		["flash"] = {
			1, 0, 1, 0, 1,
			0, 0, 0, 0, 0,
			2, 0, 2, 0, 2,
			0, 0, 0, 0, 0,
			3, 0, 3, 0, 3,
			0, 0, 0, 0, 0
		}
	},
	["rear_int_vipers"] = {
		["all"] = { 1 },
		["code1"] = { 2, 2, 0, 3, 3, 0 },
		["code2"] = { 2, 0, 2, 0, 2, 0, 3, 0, 3, 0, 3, 0 }
	},

	-- FRONT INNER --

	["front_inner_default"] = {
		["all"] = { 1 },
		["code1"] = { 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0 },
		["code2"] = { 2, 2, 0, 3, 3, 0 },
		["code3"] = { 2, 0, 2, 0, 3, 0, 3, 0 }
	},
	["front_vipers"] = {
		["all"] = { 1 },
		["code1"] = { 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0 },
		["code2"] = { 2, 2, 0, 3, 3, 0 },
		["code3"] = { 2, 0, 2, 0, 3, 0, 3, 0 }
	},
	["front_low_viper"] = {
		["all"] = { 1 },
		["code1"] = { 2, 2, 2, 2, 0, 3, 3, 3, 3, 0 },
		["code2"] = { 2, 2, 0, 3, 3, 0 },
		["code3"] = { 2, 0, 2, 0, 3, 0, 3, 0 }
	},

	-- BUMPER RELATED --

	["bumper_vertex"] = {
		["all"] = { 1 },
		["code2"] = { 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0 }
	},
	["bumper_upper"] = {
		["all"] = { 1 },
		["code2"] = { 2, 2, 0, 0, 3, 3, 0, 0 },
		["code3"] = {
			2, 2, 0, 3, 3, 0,
			2, 2, 0, 3, 3, 0,
			2, 2, 0, 3, 3, 0, 0,
		}
	},
	["bumper_side"] = {
		["all"] = { 1 },
		["code2"] = { 1, 0, 0 }
	},

	["rear_int_bar"] = {
		["all"] = { 1 },
		["flash"] = { 1, 1, 1, 0, 0, 0 },
		["code1"] = {
			8, 0, 8, 0, 9, 0, 9, 0
		},
		["code2"] = {
			2, 2, 2, 0, 3, 3, 3, 0
		},
		["code3"] = {
			2, 0, 2, 0, 2, 0,
			3, 0, 3, 0, 3, 0,
			2, 0, 2, 0, 2, 0,
			3, 0, 3, 0, 3, 0,
			2, 0, 2, 0, 2, 0,
			3, 0, 3, 0, 3, 0,

			4, 0, 4, 0, 4, 0,
			5, 0, 5, 0, 5, 0,
			4, 0, 4, 0, 4, 0,
			5, 0, 5, 0, 5, 0,
			4, 0, 4, 0, 4, 0,
			5, 0, 5, 0, 5, 0,

			6, 0, 6, 0, 6, 0,
			7, 0, 7, 0, 7, 0,
			6, 0, 6, 0, 6, 0,
			7, 0, 7, 0, 7, 0,
			6, 0, 6, 0, 6, 0,
			7, 0, 7, 0, 7, 0,

			1, 0, 1, 0, 1, 0,
			0, 0, 0, 0, 0, 0,
			1, 0, 1, 0, 1, 0,
			0, 0, 0, 0, 0, 0,
			1, 0, 1, 0, 1, 0,
			0, 0, 0, 0, 0, 0,
		}
	},

	-- WHELEN FREEDOM --

	["lightbar_freedom"] = {
		["all"] = { 1 }
	},

	["lightbar_freedom_corner"] = {
		["code1"] = { 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		["code2"] = { 2, 2, 0, 3, 3, 0 },
		["code3"] = {
			0, 2, 0, 2, 0,
			0, 3, 0, 3, 0,
			0, 2, 0, 2, 0,
			0, 3, 0, 3, 0,
			0, 2, 0, 2, 0,
			0, 3, 0, 3, 0,
			2, 0, 3, 0,
			2, 0, 3, 0,
			2, 0, 3, 0,
			1, 0, 1, 0, 1,
			0, 0, 0, 0, 0,
			1, 0, 1, 0, 1,
			0, 0, 0, 0, 0,
			1, 0, 1, 0, 1,
			0, 0, 0, 0, 0,
			1, 0, 1, 0, 1,
		}
	},

	["lightbar_freedom_inner"] = {
		["code1"] = { 1, 1, 1, 1, 0, 2, 2, 2, 2, 0 },
		["code2"] = {
			3, 0, 3, 0, 3, 0,
			4, 0, 4, 0, 4, 0,
			3, 0, 3, 0, 3, 0,
			4, 0, 4, 0, 4, 0,
			3, 0, 3, 0, 3, 0,
			4, 0, 4, 0, 4, 0,
			3, 3, 3, 0,
			4, 4, 4, 0,
			3, 3, 3, 0,
			4, 4, 4, 0,
			3, 3, 3, 0,
			4, 4, 4, 0,
		},
		["code3"] = {
			3, 0, 3, 0,
			4, 0, 4, 0,
			3, 0, 3, 0,
			4, 0, 4, 0,
			3, 0, 3, 0,
			4, 0, 4, 0,
			4, 4, 0,
			3, 3, 0,
			4, 4, 0,
			3, 3, 0,
			4, 4, 0,
			3, 3, 0,
			4, 4, 0,
			3, 3, 0,
		}
	},

	["lightbar_freedom_illum"] = {
		["code3"] = { 1, 1, 0, 2, 2, 0 }
	},

	-- WHELEN LIBERTY --

	["lightbar_liberty"] = {
		["all"] = { 1 },
		["code2"] = { 2, 2, 0, 3, 3, 0 },
		["code3"] = { 4, 4, 0, 5, 5, 0 }
	},
	["lightbar_liberty_corner"] = {
		["code1"] = {
			2, 1, 2, 1, 2,
			1, 1, 1, 1, 1,
			3, 1, 3, 1, 3,
			1, 1, 1, 1, 1,
		},
		["code3"] = {
			4, 0, 4, 0, 4, 0,
			5, 0, 5, 0, 5, 0,
			4, 0, 4, 0, 4, 0,
			5, 0, 5, 0, 5, 0,
			4, 0, 4, 0, 4, 0,
			5, 0, 5, 0, 5, 0,
			4, 4, 4, 0,
			5, 5, 5, 0,
			4, 4, 4, 0,
			5, 5, 5, 0,
			4, 4, 4, 0,
			5, 5, 5, 0,
		}
	},
	["lightbar_liberty_inner"] = {
		["code1"] = {
			1, 0, 1, 0, 1, 0, 1,
			0, 0, 0, 0, 0, 0, 0,
			2, 0, 2, 0, 2, 0, 2,
			0, 0, 0, 0, 0, 0, 0,
		},
		["code3"] = {
			3, 0, 3, 0,
			4, 0, 4, 0,
		}
	},
	["lightbar_liberty_illum"] = {
		["all"] = { 1 },
		["alt"] = { 2, 2, 3, 3 }
	},

	["lightbar_valor"] = {
		["all"] = { 1 },
		["code1"] = {
			2, 2, 2, 2, 0,
			5, 5, 5, 5, 0,
			4, 4, 4, 4, 0,
			3, 3, 3, 3, 0
		},
		["code2"] = {
			7, 0, 7, 0,
			6, 0, 6, 0,
			9, 0, 9, 0,
			8, 0, 8, 0,
			7, 0, 7, 0,
			6, 0, 6, 0,
			9, 0, 9, 0,
			8, 0, 8, 0,
			2, 2, 0,
			4, 4, 0,
			5, 5, 0,
			3, 3, 0,
			2, 2, 0,
			4, 4, 0,
			5, 5, 0,
			3, 3, 0,
			2, 2, 0,
			4, 4, 0,
			5, 5, 0,
			3, 3, 0,
			2, 2, 0,
			4, 4, 0,
			5, 5, 0,
			3, 3, 0,
			10, 10, 0, 11, 11, 0,
			12, 12, 0, 13, 13, 0,
			10, 10, 0, 11, 11, 0,
			12, 12, 0, 13, 13, 0,
			10, 10, 0, 11, 11, 0,
			12, 12, 0, 13, 13, 0,
			10, 10, 0, 11, 11, 0,
			12, 12, 0, 13, 13, 0,
		},
		 -- 2, 4, 16
		 -- 3, 5, 17
		["code3"] = {
			14, 0, 14, 0,
			15, 0, 15, 0,
			14, 0, 14, 0,
			15, 0, 15, 0,
			14, 0, 14, 0,
			15, 0, 15, 0,
			14, 0, 14, 0,
			15, 0, 15, 0,
			14, 0, 14, 0,
			15, 0, 15, 0,
			14, 0, 14, 0,
			15, 0, 15, 0,
			14, 0, 14, 0,
			15, 0, 15, 0,
			14, 0, 14, 0,
			15, 0, 15, 0,
			14, 0, 14, 0,
			15, 0, 15, 0,
			2, 0,
			16, 0,
			3, 0,
			17, 0,
			4, 0,
			16, 0,
			5, 0,
			17, 0,
			2, 0,
			16, 0,
			3, 0,
			17, 0,
			4, 0,
			16, 0,
			5, 0,
			17, 0,
			2, 0,
			16, 0,
			3, 0,
			17, 0,
			4, 0,
			16, 0,
			5, 0,
			17, 0,
			2, 0,
			16, 0,
			3, 0,
			17, 0,
			4, 0,
			16, 0,
			5, 0,
			17, 0,
			2, 0,
			16, 0,
			3, 0,
			17, 0,
			4, 0,
			16, 0,
			5, 0,
			17, 0,
			2, 0,
			16, 0,
			3, 0,
			17, 0,
			4, 0,
			16, 0,
			5, 0,
			17, 0,
			2, 0,
			16, 0,
			3, 0,
			17, 0,
			4, 0,
			16, 0,
			5, 0,
			17, 0,
			2, 0,
			16, 0,
			3, 0,
			17, 0,
			4, 0,
			16, 0,
			5, 0,
			17, 0,
			2, 0,
			16, 0,
			3, 0,
			17, 0,
			4, 0,
			16, 0,
			5, 0,
			17, 0,
			2, 4, 5, 3,
			2, 4, 5, 3,
			2, 4, 5, 3,
			2, 4, 5, 3,
			2, 4, 5, 3,
			2, 4, 5, 3,
			2, 4, 5, 3,
			2, 4, 5, 3,
			2, 4, 5, 3,
			10, 0, 11, 0,
			12, 0, 13, 0,
			10, 0, 11, 0,
			12, 0, 13, 0,
			10, 0, 11, 0,
			12, 0, 13, 0,
			10, 0, 11, 0,
			12, 0, 13, 0,
			10, 0, 11, 0,
			12, 0, 13, 0,
			10, 0, 11, 0,
			12, 0, 13, 0,

		}
	},

	["traffic_rb"] =
	{
		["flash"] = { 1, 1, 1, 0, 2, 2, 2, 0 }
	},

	["traffic"] = {
		["left"] = {
			1, 1,
			2, 2,
			3, 3,
			4, 4,
			5, 5,
			6, 6,
			7, 7,
			8, 0,
			8, 0,
			8, 0,
			8, 0,
			8, 8, 8, 8,
			0, 0, 0, 0,
			0, 0, 0, 0,
		},
		["right"] = {
			9, 9,
			8, 8,
			7, 7,
			6, 6,
			5, 5,
			4, 4,
			3, 3,
			2, 0,
			2, 0,
			2, 0,
			2, 0,
			2, 2, 2, 2,
			0, 0, 0, 0,
		},
		["diverge"] = {
			10, 10,
			11, 11,
			12, 12,
			13, 0,
			13, 0,
			13, 0,
			13, 0,
			13, 13, 13, 13,
			0, 0, 0, 0,
			0, 0, 0, 0
		},
		["code1"] = {
			28, 0, 28, 0, 29, 0, 29, 0
		},
		["code2"] = {
			22, 22, 22, 0, 23, 23, 23, 0
		},
		["code3"] = {
			22, 0, 22, 0, 22, 0,
			23, 0, 23, 0, 23, 0,
			22, 0, 22, 0, 22, 0,
			23, 0, 23, 0, 23, 0,
			22, 0, 22, 0, 22, 0,
			23, 0, 23, 0, 23, 0,

			24, 0, 24, 0, 24, 0,
			25, 0, 25, 0, 25, 0,
			24, 0, 24, 0, 24, 0,
			25, 0, 25, 0, 25, 0,
			24, 0, 24, 0, 24, 0,
			25, 0, 25, 0, 25, 0,


			26, 0, 26, 0, 26, 0,
			27, 0, 27, 0, 27, 0,
			26, 0, 26, 0, 26, 0,
			27, 0, 27, 0, 27, 0,
			26, 0, 26, 0, 26, 0,
			27, 0, 27, 0, 27, 0,


			21, 0, 21, 0, 21, 0,
			0, 0, 0, 0, 0, 0,
			21, 0, 21, 0, 21, 0,
			0, 0, 0, 0, 0, 0,
			21, 0, 21, 0, 21, 0,
			0, 0, 0, 0, 0, 0,

		}
	},
}

EMV.Lamps = {

}

EMV.Sequences = {
		Sequences = {
		{
			Name = "CODE 1",
			Components = {
				["reverse"] = "flash"
			},
			BG_Components = {
				["rear interior lightbar"] = {
					["0"] = {
						["traffic"] = "code1"
					},
					["1"] = {
						["rear_int_vipers"] = "code1"
					}
				},
				["front interior lightbar"] = {
					["0"] = {
						["front_inner_default"] = "code1"
					},
					["1"] = {
						["front_vipers"] = "code1"
					},
					["2"] = {
						["front_low_viper"] = "code1"
					}
				},
				["lightbar"] = {
					["0"] = {
						["lightbar_freedom_corner"] = "code1",
						["lightbar_freedom_inner"] = "code1"
					},
					["2"] = {
						["lightbar_liberty_corner"] = "code1",
						["lightbar_liberty_inner"] = "code1"
					},
					["3"] = {
						["lightbar_valor"] = "code1"
					}
				}
			},
			Disconnect = {

			}
		},
		{
			Name = "CODE 2",
			Components = {
				["reverse"] = "flash"
			},
			BG_Components = {
				["grille leds"]	= {
					["0"] = {
						["grille_leds"] = "code2"
					}
				},
				["front bumper leds"] = {
					["0"] = {
						["bumper_vertex"] = "code2"
					}
				},
				["rear passenger leds"] = {
					["0"] = {
						["side_leds"] = "flash"
					}
				},
				["rear interior lightbar"] = {
					["0"] = {
						["traffic"] = "code2"
					},
					["1"] = {
						["rear_int_vipers"] = "code2"
					}
				},
				["front interior lightbar"] = {
					["0"] = {
						["front_inner_default"] = "code2"
					},
					["1"] = {
						["front_vipers"] = "code2"
					},
					["2"] = {
						["front_low_viper"] = "code2"
					}
				},
				["push bar"] = {
					["0"] = {
						["bumper_upper"] = "code2",
						["bumper_side"] = "code2"
					},
					["1"] = {
						["bumper_upper"] = "code2",
						["bumper_side"] = "all"
					}
				},
				["lightbar"] = {
					["0"] = {
						["lightbar_freedom_corner"] = "code2",
						["lightbar_freedom_inner"] = "code2"
					},
					["2"] = {
						["lightbar_liberty"] = "code2"
					},
					["3"] = {
						["lightbar_valor"] = "code2"
					}
				}
			},
			Disconnect = {}
		},
		{
			Name = "CODE 3",
			Components = {
				["reverse"] = "flash",
				["headlights"] = "code3"
			},
			BG_Components = {
				["grille leds"]	= {
					["0"] = {
						["grille_leds"] = "code3"
					}
				},
				["front bumper leds"] = {
					["0"] = {
						["bumper_vertex"] = "code2"
					}
				},
				["front interior lightbar"] = {
					["0"] = {
						["front_inner_default"] = "code3"
					},
					["1"] = {
						["front_vipers"] = "code3"
					},
					["2"] = {
						["front_low_viper"] = "code3"
					}
				},
				["rear passenger leds"] = {
					["0"] = {
						["side_leds"] = "flash"
					}
				},
				["rear interior lightbar"] = {
					["0"] = {
						["traffic"] = "code3"
					},
					["1"] = {
						["rear_int_vipers"] = "code2"
					}
				},
				["push bar"] = {
					["0"] = {
						["bumper_upper"] = "code3",
						["bumper_side"] = "code2"
					},
					["1"] = {
						["bumper_upper"] = "code3",
						["bumper_side"] = "code2"
					}
				},
				["lightbar"] = {
					["0"] = {
						["lightbar_freedom_corner"] = "code3",
						["lightbar_freedom_inner"] = "code3",
						["lightbar_freedom_illum"] = "code3"
					},
					["2"] = {
						["lightbar_liberty_corner"] = "code3",
						["lightbar_liberty_inner"] = "code3",
						["lightbar_liberty"] = "code3",
						["lightbar_liberty_illum"] = "alt"
					},
					["3"] = {
						["lightbar_valor"] = "code3"
					}
				}
			},
			Disconnect = { 1, 2 }
		},
	},
	Traffic = {
		{
			Name = "LEFT",
			Components = {},
			BG_Components = {
				["rear interior lightbar"] = {
					["0"] = {
						["traffic"] = "left",
						["traffic_rb"] = "flash"
					},
				},
			},
			Disconnect = { 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 }
		},
	    {
			Name = "RIGHT",
			Components = {},
			BG_Components = {
				["rear interior lightbar"] = {
					["0"] = {
						["traffic"] = "right",
						["traffic_rb"] = "flash"
					},
				},
			},
			Disconnect = {}
		},
	    {
			Name = "DIVERGE",
			Components = {},
			BG_Components = {
				["rear interior lightbar"] = {
					["0"] = {
						["traffic"] = "diverge",
						["traffic_rb"] = "flash"
					},
				},
			},
			Disconnect = { 5, 6, 7, 8,
				9, 10, 11, 12, 13, 14 }
		}
	},
	Illumination = {
		{
			Name = "LAMP",
			Components = {},
			BG_Components = {
				["spotlights"] = {
					["0"] = {
						{ 93, W, 2 },
						{ 94, W, 2 }
					},
					["1"] = {
						{ 93, W, 2 },
						{ 94, W, 2 }
					}
				},
			},
			Lights = {
				{ Vector( 40.96, 37.09, 56.85 ), Angle( 20, 90, -0 ), "lamp" },
				{ Vector( -40.96, 37.09, 56.85 ), Angle( 20, 90, -0 ), "lamp" },
			},
			Disconnect = { }
		},
	}
}


EMV.Lamps = {
	["lamp"] = {
		Color = Color(96,96,106,255),
		Texture = "effects/flashlight001",
		Near = 200,
		FOV = 70,
		Distance = 700,
	}
}

EMV.Configuration = true
Photon.EMVLibrary[name] = EMV