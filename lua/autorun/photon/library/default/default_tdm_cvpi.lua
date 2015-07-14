AddCSLuaFile()

local name = "Ford Crown Victoria"

local A = "AMBER"
local R = "RED"
local DR = "D_RED"
local B = "BLUE"
local W = "WHITE"
local CW = "C_WHITE"
local SW = "S_WHITE"

local EMV = {}

EMV.Siren = 3

EMV.Color = nil
EMV.Skin = 0

EMV.BodyGroups = {}

EMV.Props = {}

local height = 76.4

local alphaOffset = 10
local betaOffset = -10
local gammaOffset = 5

EMV.Meta = {
	grille_leds = {
		AngleOffset = -90,
		W = 5.7,
		H = 5.4,
		Sprite = "sprites/emv/tdm_grille_leds",
		Scale = 1,
		WMult = 1,
	},
	pushbar_leds = {
		AngleOffset = -90,
		W = 6,
		H = 6.3,
		Sprite = "sprites/emv/led_1x4",
		Scale = 1,
		WMult = 1,
	},
	front_viper = {
		AngleOffset = -90,
		W = 4,
		H = 4,
		Sprite = "sprites/emv/tdm_viper",
		Scale = 1,
		WMult = 1,
	},
	font_interior_leds = {
		AngleOffset = -90,
		W = 3.5,
		H = 2.5,
		Sprite = "sprites/emv/led_1x4",
		Scale = 1,
		WMult = 1,
	},
	mirror_leds = {
		AngleOffset = -90,
		W = 6.4,
		H = 5,
		Sprite = "sprites/emv/emv_whelen_src",
		Scale = 1,
		WMult = 1,
	},
	rear_200 = {
		AngleOffset = 90,
		W = 6.4,
		H = 5.2,
		Sprite = "sprites/emv/emv_whelen_src",
		Scale = 1,
		WMult = 1.5,
	},
	rear_vipers = {
		AngleOffset = 90,
		W = 4,
		H = 4,
		Sprite = "sprites/emv/tdm_viper",
		Scale = 1,
		WMult = 1,
	},
	rear_fluor = {
		AngleOffset = 90,
		W = 9.5,
		H = 9.6,
		Sprite = "sprites/emv/tdm_fluorescent",
		Scale = 2,
		WMult = 1.4,
	},
	halogen_front = {
		AngleOffset = -90,
		W = 7,
		H = 7,
		Sprite = "sprites/emv/tdm_halogen",
		Scale = 1.5,
		WMult = 1,
	},
	halogen_rear = {
		AngleOffset = 90,
		W = 7,
		H = 7,
		Sprite = "sprites/emv/tdm_halogen",
		Scale = 1.5,
		WMult = 1,
	},
	halogen_l_front = {
		AngleOffset = -90,
		W = 5,
		H = 5,
		Sprite = "sprites/emv/tdm_halogen2",
		Scale = 1.2,
		WMult = 1.3,
	},
	halogen_l_rear = {
		AngleOffset = 90,
		W = 5,
		H = 5,
		Sprite = "sprites/emv/tdm_halogen2",
		Scale = 1.2,
		WMult = 1.3,
	},
	halogen_rotating_a = {
		AngleOffset = "R",
		W = 7,
		H = 7,
		Sprite = "sprites/emv/circular_src",
		Scale = 2,
		Speed = alphaOffset,
	},
	halogen_rotating_b = {
		AngleOffset = "R",
		W = 7,
		H = 7,
		Sprite = "sprites/emv/circular_src",
		Scale = 2,
		Speed = betaOffset,
	},
	halogen_rotating_c = {
		AngleOffset = "R",
		W = 4,
		H = 4,
		Sprite = "sprites/emv/circular_src",
		Scale = 1,
		Speed = alphaOffset,
	},
	halogen_rotating_d = {
		AngleOffset = "R",
		W = 4,
		H = 4,
		Sprite = "sprites/emv/circular_src",
		Scale = 1,
		Speed = betaOffset,
	},
	halogen_rotating_e = {
		AngleOffset = "R",
		W = 2,
		H = 2,
		Sprite = "sprites/emv/circular_src",
		Scale = 1,
		Speed = gammaOffset,
	},
	halogen_alley = {
		AngleOffset = -90,
		W = 2.7,
		H = 2.5,
		Sprite = "sprites/emv/tdm_halogen2",
		Scale = 1,
		WMult = 1,
	},
	freedom_f_inner = {
		AngleOffset = -90,
		W = 7,
		H = 8,
		Sprite = "sprites/emv/whelen_freedom_main",
		Scale = 1.75,
		WMult = 1.24,
	},
	freedom_f_corner = {
		AngleOffset = -90,
		W = 9,
		H = 7,
		Sprite = "sprites/emv/whelen_freedom_main",
		Scale = 1.75,
		WMult = 2,
	},
	freedom_r_corner = {
		AngleOffset = 90,
		W = 9,
		H = 7,
		Sprite = "sprites/emv/whelen_freedom_main",
		Scale = 1.75,
		WMult = 2,
	},
	freedom_r_inner = {
		AngleOffset = 90,
		W = 7,
		H = 8,
		Sprite = "sprites/emv/whelen_freedom_main",
		Scale = 1.75,
		WMult = 1.24,
	},
	freedom_takedown = {
		AngleOffset = -90,
		W = 5,
		H = 5.7,
		Sprite = "sprites/emv/tdm_halogen2",
		Scale = 1.2,
		WMult = 1.3,
	},
	freedom_r_halogen = {
		AngleOffset = 90,
		W = 5,
		H = 5.7,
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
		W = 7,
		H = 7,
		Sprite = "sprites/emv/emv_whelen_src",
		Scale = 1,
		WMult = 1.66,
	},
	liberty_rear = {
		AngleOffset = 90,
		W = 7,
		H = 7,
		Sprite = "sprites/emv/emv_whelen_src",
		Scale = 1,
		WMult = 1.66,
	},
	liberty_f_corner = {
		AngleOffset = -90,
		W = 13.5,
		H = 13.4,
		Sprite = "sprites/emv/emv_whelen_corner",
		Scale = 1,
		WMult = 2.2,
	},
	liberty_r_corner = {
		AngleOffset = 90,
		W = 13.5,
		H = 13.4,
		Sprite = "sprites/emv/emv_whelen_corner",
		Scale = 1,
		WMult = 2.2,
	},
	liberty_takedown = {
		AngleOffset = -90,
		W = 6.6,
		H = 6.6,
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
	vector_trf = {
		AngleOffset = 90,
		W = 5.8,
		H = 6.5,
		Sprite = "sprites/emv/emv_whelen_src",
		Scale = 1,
		WMult = 1.66,
	},
	headlight = {
		AngleOffset = -90,
		W = 13,
		H = 14,
		Sprite = "sprites/emv/blank",
		Scale = 2,
		WMult = 1
	},
	reverse = {
		AngleOffset = 90,
		W = 10,
		H = 11,
		Sprite = "sprites/emv/crownvic_reverse",
		Scale = .75,
		WMult = .1
	},
	tail_glow = {
		AngleOffset = 90,
		W = 0,
		H = 0,
		Sprite = "sprites/emv/blank",
		Scale = 3,
	},
	tail_light = {
		AngleOffset = 90,
		W = 8,
		H = 8,
		Sprite = "sprites/emv/crownvic_tail",
		Scale = 1,
		WMult = 1.5,
	},
	spotlight = {
		AngleOffset = -90,
		W = 5,
		H = 5,
		Sprite = "sprites/emv/light_circle",
		Scale = 3,
	}
	
}

EMV.Positions = {
	
	[1] = { Vector( 10.16, 118.2, 35.17 ), Angle( 0, 0, 15.2 ), "grille_leds" }, -- 1
	[2] = { Vector( -10.16, 118.2, 35.17 ), Angle( 0, 0, 15.2 ), "grille_leds" }, -- 2
	
	[3] = { Vector( 9.24, 128.7, 31.13 ), Angle( 0, 0, 0 ), "pushbar_leds" },
	[4] = { Vector( -9.24, 128.7, 31.13 ), Angle( 0, 0, 0 ), "pushbar_leds" },
	
	[5] = { Vector( 2.97, 128.7, 31.13 ), Angle( 0, 0, 0 ), "pushbar_leds" },
	[6] = { Vector( -2.97, 128.7, 31.13 ), Angle( 0, 0, 0 ), "pushbar_leds" },
	
	[7] = { Vector( 2.05, 16.68, 65.43 ), Angle( 0, 0, 0 ), "front_viper" },
	[8] = { Vector( -2.05, 16.68, 65.43 ), Angle( 0, 0, 0 ), "front_viper" },
	
	[9] = { Vector( 11.32, 13.68, 65.57 ), Angle( 0, 0, 0 ), "font_interior_leds" },
	[10] = { Vector( -11.32, 13.68, 65.57 ), Angle( 0, 0, 0 ), "font_interior_leds" },
	
	[11] = { Vector( 15.01, 13.68, 65.57 ), Angle( 0, 0, 0 ), "font_interior_leds" },
	[12] = { Vector( -15.01, 13.68, 65.57 ), Angle( 0, 0, 0 ), "font_interior_leds" },
	
	[13] = { Vector( 18.69, 13.68, 65.57 ), Angle( 0, 0, 0 ), "font_interior_leds" },
	[14] = { Vector( -18.69, 13.68, 65.57 ), Angle( 0, 0, 0 ), "font_interior_leds" },
	
	[15] = { Vector( 22.4, 13.68, 65.57 ), Angle( 0, 0, 0 ), "font_interior_leds" },
	[16] = { Vector( -22.4, 13.68, 65.57 ), Angle( 0, 0, 0 ), "font_interior_leds" },
	
	[17] = { Vector( 26.07, 13.68, 65.57 ), Angle( 0, 0, 0 ), "font_interior_leds" },
	[18] = { Vector( -26.07, 13.68, 65.57 ), Angle( 0, 0, 0 ), "font_interior_leds" },
	
	[19] = { Vector( 47.97, 30.5, 51.77 ), Angle( 1.18 - 180, -28.66, 180 - 6.3 ), "mirror_leds" },
	[20] = { Vector( -47.97, 30.5, 51.77 ), Angle( 1.18, 28.66, 6.3 ), "mirror_leds" },
	
	[21] = { Vector( 19.87, -75.72, 56.07 ), Angle( 0, 0, 0 ), "rear_200" },
	[22] = { Vector( -19.87, -75.72, 56.07 ), Angle( 0, 0, 0 ), "rear_200" },
	
	[23] = { Vector( 14.19, -75.72, 56.07 ), Angle( 0, 0, 0 ), "rear_200" },
	[24] = { Vector( -14.19, -75.72, 56.07 ), Angle( 0, 0, 0 ), "rear_200" },
	
	[25] = { Vector( 8.54, -75.72, 56.07 ), Angle( 0, 0, 0 ), "rear_200" },
	[26] = { Vector( -8.54, -75.72, 56.07 ), Angle( 0, 0, 0 ), "rear_200" },
	
	[27] = { Vector( 2.84, -75.72, 56.07 ), Angle( 0, 0, 0 ), "rear_200" },
	[28] = { Vector( -2.84, -75.72, 56.07 ), Angle( 0, 0, 0 ), "rear_200" },
	
	[29] = { Vector( 26.53, -67.68, 61.47 ), Angle( 0, 15, 0 ), "rear_vipers" },
	[30] = { Vector( -26.53, -67.68, 61.47 ), Angle( 0, -15, 0 ), "rear_vipers" },
	
	[31] = { Vector( 22.63, -68.78, 61.47 ), Angle( 0, 15, 0 ), "rear_vipers" },
	[32] = { Vector( -22.63, -68.78, 61.47 ), Angle( 0, -15, 0 ), "rear_vipers" },
	
	[33] = { Vector( 11.13, -80.48, 53.97 ), Angle( 0, 0, -14 ), "rear_fluor" },
	[34] = { Vector( -11.13, -80.48, 53.97 ), Angle( 0, 0, -14 ), "rear_fluor" },
	
	[35] = { Vector( 19.87, -62.42, 64.67 ), Angle( 0, 0, 0 ), "rear_200" },
	[36] = { Vector( -19.87, -62.42, 64.67 ), Angle( 0, 0, 0 ), "rear_200" },
	
	[37] = { Vector( 14.19, -62.42, 64.67 ), Angle( 0, 0, 0 ), "rear_200" },
	[38] = { Vector( -14.19, -62.42, 64.67 ), Angle( 0, 0, 0 ), "rear_200" },
	
	[39] = { Vector( 8.54, -62.42, 64.67 ), Angle( 0, 0, 0 ), "rear_200" },
	[40] = { Vector( -8.54, -62.42, 64.67 ), Angle( 0, 0, 0 ), "rear_200" },
	
	[41] = { Vector( 2.84, -62.42, 64.67 ), Angle( 0, 0, 0 ), "rear_200" },
	[42] = { Vector( -2.84, -62.42, 64.67 ), Angle( 0, 0, 0 ), "rear_200" },
	
	-- HALOGEN LIGHTBAR --
	
	[43] = { Vector( 12.34, -14.42, 77.58 ), Angle( 0, 0, 0 ), "halogen_front" },
	[44] = { Vector( -12.34, -14.42, 77.58 ), Angle( 0, 0, 0 ), "halogen_front" },
	
	[45] = { Vector( 8.64, -13.92, 74.58 ), Angle( 0, 0, 0 ), "halogen_l_front" },
	[46] = { Vector( -8.64, -13.92, 74.58 ), Angle( 0, 0, 0 ), "halogen_l_front" },
	
	[47] = { Vector( 14.39, -13.92, 74.58 ), Angle( 0, 0, 0 ), "halogen_l_front" },
	[48] = { Vector( -14.39, -13.92, 74.58 ), Angle( 0, 0, 0 ), "halogen_l_front" },
	
	[49] = { Vector( 22.89, -17.22, 77.78 ), Angle( 0, 0, 0 ), "halogen_rotating_b" },
	[50] = { Vector( -22.89, -17.22, 77.78 ), Angle( 0, 0, 0 ), "halogen_rotating_a" },
	
	[51] = { Vector( 22.89, -16.32, 77.78 ), Angle( 0, 0, 0 ), "halogen_rotating_b" },
	[52] = { Vector( -22.89, -16.32, 77.78 ), Angle( 0, 0, 0 ), "halogen_rotating_a" },
	
	[53] = { Vector( 19.39, -14.72, 77.78 ), Angle( 0, 0, 0 ), "halogen_rotating_c" },
	[54] = { Vector( -19.39, -14.72, 77.78 ), Angle( 0, 0, 0 ), "halogen_rotating_d" },
	
	[55] = { Vector( 19.39, -18.82, 77.78 ), Angle( 0, 0, 0 ), "halogen_rotating_c" },
	[56] = { Vector( -19.39, -18.82, 77.78 ), Angle( 0, 0, 0 ), "halogen_rotating_d" },
	
	[57] = { Vector( 12.34, -19.22, 77.58 ), Angle( 0, 0, 0 ), "halogen_rear" },
	[58] = { Vector( -12.34, -19.22, 77.58 ), Angle( 0, 0, 0 ), "halogen_rear" },
	
	[59] = { Vector( 8.64, -19.92, 74.58 ), Angle( 0, 0, 0 ), "halogen_l_rear" },
	[60] = { Vector( -8.64, -19.92, 74.58 ), Angle( 0, 0, 0 ), "halogen_l_rear" },
	
	[61] = { Vector( 14.14, -19.92, 74.58 ), Angle( 0, 0, 0 ), "halogen_l_rear" },
	[62] = { Vector( -14.14, -19.92, 74.58 ), Angle( 0, 0, 0 ), "halogen_l_rear" },
	
	[63] = { Vector( 27.14, -16.93, 74.98 ), Angle( 0, -90, 0 ), "halogen_alley" },
	[64] = { Vector( -27.14, -16.93, 74.98 ), Angle( 0, 90, 0 ), "halogen_alley" },
	
	[65] = { Vector( 21.24, -18.42, 74.58 ), Angle( 0, 0, 0 ), "halogen_rotating_e" },
	[66] = { Vector( -21.24, -18.42, 74.58 ), Angle( 0, 0, 0 ), "halogen_rotating_e" },
	
	[67] = { Vector( 21.24, -14.42, 74.58 ), Angle( 0, 0, 0 ), "halogen_rotating_e" },
	[68] = { Vector( -21.24, -14.42, 74.58 ), Angle( 0, 0, 0 ), "halogen_rotating_e" },
	
	-- WHELEN FREEDOM --
	
	[69] = { Vector( 9.04, -11.62, 75.24 ), Angle( 0, 0, 0 ), "freedom_f_inner" },
	[70] = { Vector( -9.04, -11.62, 75.24 ), Angle( 0, 0, 0 ), "freedom_f_inner" },
	
	[71] = { Vector( 23.55, -12.92, 75.24 ), Angle( 0, -16.3, 0 ), "freedom_f_corner" },
	[72] = { Vector( -23.55, -12.92, 75.24 ), Angle( 0, 16.3, 0 ), "freedom_f_corner" },
	
	[73] = { Vector( 23.55, -20.61, 75.24 ), Angle( 0, 16.3, 0 ), "freedom_r_corner" },
	[74] = { Vector( -23.55, -20.61, 75.24 ), Angle( 0, -16.3, 0 ), "freedom_r_corner" },
	
	[75] = { Vector( 9.04, -21.92, 75.24 ), Angle( 0, 0, 0 ), "freedom_r_inner" },
	[76] = { Vector( -9.04, -21.92, 75.24 ), Angle( 0, 0, 0 ), "freedom_r_inner" },
	
	[77] = { Vector( 15.79, -11.92, 75.28 ), Angle( 0, 0, 0 ), "freedom_takedown" },
	[78] = { Vector( -15.79, -11.92, 75.28 ), Angle( 0, 0, 0 ), "freedom_takedown" },
	
	[79] = { Vector( 15.79, -21.52, 75.28 ), Angle( 0, 0, 0 ), "freedom_r_halogen" },
	[80] = { Vector( -15.79, -21.52, 75.28 ), Angle( 0, 0, 0 ), "freedom_r_halogen" },
	
	[81] = { Vector( 28.14, -16.72, 75.2 ), Angle( 0, -90, 0 ), "freedom_alley" },
	[82] = { Vector( -28.14, -16.72, 75.2 ), Angle( 0, 90, 0 ), "freedom_alley" },
	
	-- WHELEN LIBERTY --
	
	[83] = { Vector( 9.48, -11.72, 74.74 ), Angle( 0, 0, 0 ), "liberty_front" },
	[84] = { Vector( -9.44, -11.72, 74.74 ), Angle( 0, 0, 0 ), "liberty_front" },
	
	[85] = { Vector( 15.86, -11.72, 74.74 ), Angle( 0, 0, 0 ), "liberty_front" },
	[86] = { Vector( -15.86, -11.72, 74.74 ), Angle( 0, 0, 0 ), "liberty_front" },
	
	[87] = { Vector( 23.6, -13.73, 74.74 ), Angle( 0, -23, 0 ), "liberty_f_corner" },
	[88] = { Vector( -23.6, -13.73, 74.74 ), Angle( 0, 23, 0 ), "liberty_f_corner" },
	
	[89] = { Vector( 23.6, -20.33, 74.74 ), Angle( 0, 23, 0 ), "liberty_r_corner" },
	[90] = { Vector( -23.6, -20.33, 74.74 ), Angle( 0, -23, 0 ), "liberty_r_corner" },
	
	[91] = { Vector( 15.86, -21.92, 74.74 ), Angle( 0, 0, 0 ), "liberty_rear" },
	[92] = { Vector( -15.86, -21.92, 74.74 ), Angle( 0, 0, 0 ), "liberty_rear" },
	
	[93] = { Vector( 9.48, -21.92, 74.74 ), Angle( 0, 0, 0 ), "liberty_rear" },
	[94] = { Vector( -9.48, -21.92, 74.74 ), Angle( 0, 0, 0 ), "liberty_rear" },
	
	[95] = { Vector( 3.21, -21.92, 74.74 ), Angle( 0, 0, 0 ), "liberty_rear" },
	[96] = { Vector( -3.21, -21.92, 74.74 ), Angle( 0, 0, 0 ), "liberty_rear" },
	
	[97] = { Vector( 3.21, -11.52, 74.74 ), Angle( 0, 0, 0 ), "liberty_takedown" },
	[98] = { Vector( -3.21, -11.52, 74.74 ), Angle( 0, 0, 0 ), "liberty_takedown" },
	
	[99] = { Vector( 28.01, -16.87, 74.81 ), Angle( 0, -90, 0 ), "liberty_alley" },
	[100] = { Vector( -28.01, -16.87, 74.81 ), Angle( 0, 90, 0 ), "liberty_alley" },
	
	-- VECTOR LIGHTBAR --
	
	[101] = { Vector( 0, -2.17, 78.41 ), Angle( 0, 0, 0 ), "halogen_rotating_a" },
	[102] = { Vector( 0, -4.87, 78.41 ), Angle( 0, 0, 0 ), "halogen_rotating_a" },
	
	[103] = { Vector( 7.11, -7.07, 78.41 ), Angle( 0, 0, 0 ), "halogen_rotating_b" },
	[104] = { Vector( -7.11, -7.07, 78.41 ), Angle( 0, 0, 0 ), "halogen_rotating_b" },
	
	[105] = { Vector( 7.11, -9.87, 78.41 ), Angle( 0, 0, 0 ), "halogen_rotating_b" },
	[106] = { Vector( -7.11, -9.87, 78.41 ), Angle( 0, 0, 0 ), "halogen_rotating_b" },
	
	[107] = { Vector( 14.21, -11.97, 78.41 ), Angle( 0, 0, 0 ), "halogen_rotating_a" },
	[108] = { Vector( -14.21, -11.97, 78.41 ), Angle( 0, 0, 0 ), "halogen_rotating_a" },
	
	[109] = { Vector( 14.21, -14.97, 78.41 ), Angle( 0, 0, 0 ), "halogen_rotating_a" },
	[110] = { Vector( -14.21, -14.97, 78.41 ), Angle( 0, 0, 0 ), "halogen_rotating_a" },
	
	[111] = { Vector( 21.41, -17.07, 78.41 ), Angle( 0, 0, 0 ), "halogen_rotating_b" },
	[112] = { Vector( -21.41, -17.07, 78.41 ), Angle( 0, 0, 0 ), "halogen_rotating_b" },
	
	[113] = { Vector( 21.41, -19.97, 78.41 ), Angle( 0, 0, 0 ), "halogen_rotating_a" },
	[114] = { Vector( -21.41, -19.97, 78.41 ), Angle( 0, 0, 0 ), "halogen_rotating_a" },
	
	[115] = { Vector( 19.41, -31.82, 74.45 ), Angle( 0, 0, 0 ), "vector_trf" },
	[116] = { Vector( -19.41, -31.82, 74.45 ), Angle( 0, 0, 0 ), "vector_trf" },
	
	[117] = { Vector( 13.91, -31.82, 74.45 ), Angle( 0, 0, 0 ), "vector_trf" },
	[118] = { Vector( -13.91, -31.82, 74.45 ), Angle( 0, 0, 0 ), "vector_trf" },
	
	[119] = { Vector( 8.33, -31.82, 74.45 ), Angle( 0, 0, 0 ), "vector_trf" },
	[120] = { Vector( -8.33, -31.82, 74.45 ), Angle( 0, 0, 0 ), "vector_trf" },
	
	[121] = { Vector( 2.8, -31.82, 74.45 ), Angle( 0, 0, 0 ), "vector_trf" },
	[122] = { Vector( -2.8, -31.82, 74.45 ), Angle( 0, 0, 0 ), "vector_trf" },
	
	[123] = { Vector( -29.2, 114, 34.6 ), Angle( 0, 14, 20 ), "headlight" },
	[124] = { Vector( 29.2, 114, 34.6 ), Angle( 180, -14, 160 ), "headlight" },
	
	[125] = { Vector( -32.3, -123.2, 39.6 ), Angle( 0, -11.2, -4 ), "tail_light" },
	[126] = { Vector( 32.3, -123.2, 39.6 ), Angle( 0, 11.2, 176 ), "tail_light" },

	-- BOTTOM --
	[127] = { Vector( -33.6, -122.7, 42.2 ), Angle( 0, -16.2, -4 ), "tail_light" },
	[128] = { Vector( 33.6, -122.7, 42.2 ), Angle( 0, 16.2, 176 ), "tail_light" },
	
	-- TAIL GLOWS --
	[129] = { Vector(-32.3,-109.5,40), Angle(0,20,-30), "tail_glow" },
	[130] = { Vector(32.3,-109.5,40), Angle(0,20,30), "tail_glow" },
	
	[131] = { Vector( -11.7, -125.4, 38.3 ), Angle( 180, -1, 183.1 ), "reverse" },
	[132] = { Vector( 11.7, -125.4, 38.3 ), Angle( 0, 1, -3.1 ), "reverse" },
	
	[133] = { Vector( 40.96, 37.09, 56.85 ), Angle( -17.26, 0, 0 ), "spotlight" },
	[134] = { Vector( -40.96, 37.09, 56.85 ), Angle( -17.26, 0, 0 ), "spotlight" },
	
}

EMV.Sections = {
	["grille_leds"] = {
		{ { 1, B }, { 2, R } },
		{ { 1, B } },
		{ { 2, R } },
	},
	["pushbar_leds"] = {
		{ { 3, B }, { 4, R }, { 5, B }, { 6, R } },
		{ { 4, R }, { 6, R } },
		{ { 3, B }, { 5, B } },
		{ { 3, B }, { 4, R } },
		{ { 5, B }, { 6, R } },
	},
	["front_viper"] = {
		{ { 7, R }, { 8, B } },
		{ { 7, R } },
		{ { 8, B } }
	},
	["front_interior"] = {
		{ { 9, B }, { 10, R }, { 11, B }, { 12, R }, { 13, B }, { 14, R }, { 15, B }, { 16, R }, { 17, B }, { 18, R } },
		
		{ { 9, B }, { 11, B }, { 13, B }, { 15, B }, { 17, B } },
		{ { 10, R }, { 12, R }, { 14, R }, { 16, R }, { 18, R } },
		
		{ { 9, B }, { 10, R }, { 17, B }, { 18, R } },
		{ { 11, B }, { 12, R }, { 13, B }, { 14, R }, { 15, B }, { 16, R } },
		
		{ { 9, B }, { 13, B }, { 17, B }, { 12, R }, { 16, R } },
		{ { 10, R }, { 14, R }, { 18, R }, { 11, B }, { 15, B } }
	},
	["mirror_leds"] = {
		{ { 19, B }, { 20, R } },
		{ { 19, B } },
		{ { 20, R } },
	},
	["rear_200"] = {
		{ { 21, R }, { 22, B }, { 23, R }, { 24, B }, { 25, R }, { 26, B }, {27, R }, { 28, B} },
		
		{ { 21, R }, { 23, R }, { 25, R }, { 27, R } },
		{ { 22, B }, { 24, B }, { 26, B }, { 28, B } },
		
		{ { 21, R }, { 23, R }, { 22, B }, { 24, B } },
		{ { 25, R }, { 27, R }, { 26, B }, { 28, B } },
		
		{ { 21, R }, { 27, R }, { 24, B }, { 26, B } },
		{ { 22, B }, { 28, B }, { 25, R }, { 23, R } },
		
		{ { 21, R }, { 23, R } },
		{ { 22, B }, { 24, B } }
	},
	["rear_vipers"] = {
		{ { 29, R }, { 30, B }, { 31, R }, { 32, B } },
		
		{ { 29, B }, { 31, B } },
		{ { 30, R }, { 32, R } },
		
		{ { 29, B }, { 30, R } },
		{ { 31, B }, { 32, R } },
	},
	["rear_fluor"] = {
		{ { 33, R }, { 34, B } },
		{ { 33, B, { 24, 0, 24 } }, { 34, R, { 24, 0, 0 } } }
	},
	
	-- TRAFFIC --
	-- 36 38 40 42 41 39 37 35 --
	["traffic"] = {
		--{ { 35, A }, { 36, A }, { 37, A }, { 38, A }, { 39, A }, { 40, A }, { 41, A }, { 42, A } },
		-- 2 -> 8
		-- 8 <- 2
		{ { 36, A } },
		{ { 36, A }, { 38, A } },
		{ { 38, A }, { 40, A } },
		{ { 40, A }, { 42, A } },
		{ { 42, A }, { 41, A } },
		{ { 41, A }, { 39, A } },
		{ { 39, A }, { 37, A } },
		{ { 37, A }, { 35, A } },
		{ { 35, A } },
		
		-- 10
		{ { 42, A }, { 41, A } },
		{ { 40, A }, { 39, A } },
		{ { 38, A }, { 37, A } },
		{ { 36, A }, { 35, A } },
		
		-- 14
		{ { 36, A }, { 38, A }, { 35, A }, { 37, A } },
		{ { 40, A }, { 42, A }, { 41, A }, { 39, A } },
		-- 16
		{ { 36, A }, { 38, A }, { 41, A }, { 39, A } },
		{ { 40, A }, { 42, A }, { 37, A }, { 35, A } },
		-- 18
		{ { 35, A }, { 37, A }, { 39, A }, { 41, A } },
		{ { 36, A }, { 38, A }, { 40, A }, { 42, A } }
	},
	
	-- HALOGEN LIGHTBAR --
	
	["lightbar_halogen"] = {
		{ 
			{ 43, B }, { 44, R }, { 45, SW }, { 46, SW }, { 47, B }, { 48, R }, { 49, B }, { 50, R }, { 51, B }, { 52, R }, 
			{ 53, B }, { 54, R }, { 55, B }, { 56, R }, { 57, B }, { 58, R }, { 59, A }, { 60, A }, { 61, A }, { 62, A }, 
			{ 63, SW }, { 64, SW }, { 65, SW }, { 66, SW }, { 67, SW }, { 68, SW } 
		}
	},
	["lightbar_halogen_rear"] = {
		[1] = { 
			{ 59, A, { 16, 0, 0 } }, 
			{ 60, A, { 16, 0, 0 } }, 
			{ 61, A, { 16, 0, 8 } }, 
			{ 62, A, { 16, 0, 8 } }, 
		},
		[2] = {
			{ 59, A, { 16, 0, 8 } }, 
			{ 60, A, { 16, 0, 0 } }, 
			{ 61, A, { 16, 0, 8 } }, 
			{ 62, A, { 16, 0, 0 } }, 
		}
	},
	["lightbar_halogen_xenon_rear"] = {
		{ { 57, B }, { 58, R } },
		{ { 57, B } },
		{ { 58, R } }
	},
	["lightbar_halogen_xenon_front"] = {
		{ { 43, B } },
		{ { 44, R } }
	},
	["lightbar_halogen_front"] = {
		{ { 47, B, { 16, 0, 0 } }, { 48, R, { 16, 0, 8 } } }
	},
	["lightbar_halogen_rotators"] = {
		{ { 49, B }, { 50, R }, { 51, B }, { 52, R }, { 53, B }, { 54, R }, { 55, B }, { 56, R }, { 65, SW }, { 66, SW }, { 67, SW }, { 68, SW } }
	},
	["lightbar_halogen_takedowns"] ={
		{ { 45, SW, { 10, 0, 0 } }, { 46, SW, { 10, 0, 0 } }, { 63, SW, { 10, 0, 0 } }, { 64, SW, { 10, 0, 0 } } }
	},
	
	-- WHELEN FREEDOM LIGHTBAR --
	
	["lightbar_freedom_rb"] = {
		{
			{ 69, B }, { 70, R }, { 71, B }, { 72, R }, { 73, B }, { 74, R }, { 75, B }, { 76, R }, { 77, SW }, { 78, SW }, 
			{ 79, B }, { 80, R }, { 81, SW }, { 82, SW }
		}
	},
	
	["lightbar_freedom_rb_outer"] = {
		{ { 71, B }, { 72, R }, { 73, B }, { 74, R } },
		
		{ { 71, B }, { 73, B } },
		{ { 72, R }, { 74, R } },
	},
	
	["lightbar_freedom_rb_inner"] = {
		{ { 69, B }, { 70, R }, { 75, B }, { 76, R } },
		{ { 69, B }, { 75, B } },
		{ { 70, R }, { 76, R } }
	},
	
	["lightbar_freedom_rb_halogen"] = {
		{ 
			{ 79, B, { 10, 0, 0 } }, 
			{ 80, R, { 10, 0, 5 } } 
		},
		{ 
			{ 79, B, { 24, 0, 0 } }, 
			{ 80, R, { 24, 0, 24 } } 
		},
	},
	
	-- WHELEN FREEDOM LIGHTBAR BLUE --
	
	["lightbar_freedom_b_outer"] = {
		{ { 71, B }, { 72, B }, { 73, B }, { 74, B } },
		
		{ { 71, B }, { 73, B } },
		{ { 72, B }, { 74, B } },
	},
	
	["lightbar_freedom_b_inner"] = {
		{ { 69, B }, { 70, B }, { 75, B }, { 76, B } },
		{ { 69, B }, { 75, B } },
		{ { 70, B }, { 76, B } }
	},
	
	["lightbar_freedom_b_halogen"] = {
		{ 
			{ 79, B, { 10, 0, 0 } }, 
			{ 80, B, { 10, 0, 5 } } 
		},
		{ 
			{ 79, B, { 24, 0, 0 } }, 
			{ 80, B, { 24, 0, 24 } } 
		},
	},
	
	["lightbar_freedom_illum"] = {
		{ { 77, SW }, { 78, SW } },
		{ 
			{ 77, SW, { 10, 0, 0 } }, 
			{ 78, SW, { 10, 0, 10 } },
			{ 81, SW, { 10, 0, 10 } },
			{ 82, SW, { 10, 0, 0 } }
		}
	},
	
	-- WHELEN LIBERTY LIGHTBAR --
	
	["lightbar_liberty"] = {
		{
			{ 83, B }, { 84, R }, { 85, B }, { 86, R }, { 87, B }, { 88, R }, { 89, B }, { 90, R }, { 91, B }, { 92, R },
			{ 93, B }, { 94, R }, { 95, B }, { 96, R }, { 97, W }, { 98, W }, { 99, W }, { 100, W }
		},
		{
			{ 83, B }, { 85, B }, { 87, B }, { 89, B }, { 91, B }, { 93, B }, { 95, B }
		},
		{
			{ 84, R }, { 86, R }, { 88, R }, { 90, R }, { 92, R }, { 94, R }, { 96, R }
		},
		{ { 91, B }, { 85, B } },
		{ { 92, R }, { 86, R } },
	},
	
	["lightbar_liberty_corner"] = {
		{ { 87, B, .5 }, { 88, R, .5 }, { 89, B, .5 }, { 90, R, .5 } },
		{ { 87, B, 1 }, { 88, R, .5 }, { 89, B, 1 }, { 90, R, .5 } },
		{ { 87, B, .5 }, { 88, R, 1 }, { 89, B, .5 }, { 90, R, 1 } },
		{ { 87, B }, { 89, B } },
		{ { 88, R }, { 90, R } }
	},
	["lightbar_liberty_inner"] = {
		{ { 92, R }, { 94, R } },
		{ { 93, B }, { 91, B } },
		{ { 93, B }, { 95, B }, { 83, B } },
		{ { 94, R }, { 96, R }, { 84, R } },
	},
	["lightbar_liberty_illum"] = {
		{ { 97, W }, { 98, W }, { 99, W }, { 100, W } },
		{ { 97, W }, { 99, W } },
		{ { 98, W }, { 100, W } }
	},
	
	-- FEDERAL SIGNAL VECTOR --
	["lightbar_vector_r"] = {
		{
			{ 101, W }, { 102, W }, 
			
			{ 103, R }, { 104, R },
			{ 105, R }, { 106, R },
			
			{ 107, W }, { 108, W },
			{ 109, W }, { 110, W },
			
			{ 111, R }, { 112, R },
			{ 113, R }, { 114, R },
			
			{ 115, A }, { 116, A },
			{ 117, A }, { 118, A },
			{ 119, A }, { 120, A },
			{ 121, A }, { 122, A },
		},
		{
			{ 111, R }, { 112, R },
			{ 113, R }, { 114, R },
		},
		{
			{ 103, R }, { 104, R },
			{ 105, R }, { 106, R },
			
			{ 111, R }, { 112, R },
			{ 113, R }, { 114, R },
		},
		{
			{ 101, W }, { 102, W }, 
			
			{ 103, R }, { 104, R },
			{ 105, R }, { 106, R },
			
			{ 107, W }, { 108, W },
			{ 109, W }, { 110, W },
			
			{ 111, R }, { 112, R },
			{ 113, R }, { 114, R },
		}
		
	},
	["lightbar_vector_rb"] = {
		{
			{ 111, R }, { 112, R },
			{ 113, R }, { 114, R },
		},
		{
			{ 107, B }, { 108, B },
			{ 109, B }, { 110, B },
			
			{ 111, R }, { 112, R },
			{ 113, R }, { 114, R },
		},
		{
			{ 101, R }, { 102, R }, 
			
			{ 103, W }, { 104, W },
			{ 105, W }, { 106, W },
			
			{ 107, B }, { 108, B },
			{ 109, B }, { 110, B },
			
			{ 111, R }, { 112, R },
			{ 113, R }, { 114, R },
		}
	},
	["lightbar_vector_ta"] = {
		[1] = {
			{ 115, A }, { 116, A },
			{ 117, A }, { 118, A },
		},
		[2] = {
			{ 119, A }, { 120, A },
			{ 121, A }, { 122, A },
		}
	},
	["headlights"] = {
		[1] = {
			{ 123, SW, { 16, .25, 0 } },
			{ 124, SW, { 16, .25, 10 } }
		}
	},
	["reverse"] = {
		[1] = {
			{ 125, DR, { 16, 0, 0} },
			{ 126, DR, { 16, 0, 0} },
			{ 127, DR, { 16, 0, 0} },
			{ 128, DR, { 16, 0, 0} },
			{ 129, DR, { 16, 0, 0} },
			{ 130, DR, { 16, 0, 0} },
			
			{ 131, SW, { 16, 0, 10} },
			{ 132, SW, { 16, 0, 10} },
		}
	}
	
}

EMV.Patterns = { -- 0 = blank
	["grille_leds"] = {
		["flash"] = { 1, 0, 1, 0, 0, 0, },
		["code2"] = { 2, 2, 2, 0, 0, 3, 3, 3, 0, 0 },
		["code3"] = { 2, 0, 2, 0, 3, 0, 3, 0 }
	},
	["pushbar_leds"] = {
		["flash"] = { 1, 0, 1, 0, 0, 0, 0, 0 },
		["code2"] = { 4, 4, 4, 0, 5, 5, 5, 0, 1, 1, 1, 0 },
		["code3"] = { 
			2, 0, 2, 0, 2, 0, 3, 0, 3, 0, 3, 0,
			2, 0, 2, 0, 2, 0, 3, 0, 3, 0, 3, 0,
			2, 0, 2, 0, 2, 0, 3, 0, 3, 0, 3, 0,
			4, 0, 4, 0, 4, 0, 5, 0, 5, 0, 5, 0,
			4, 0, 4, 0, 4, 0, 5, 0, 5, 0, 5, 0,
			4, 0, 4, 0, 4, 0, 5, 0, 5, 0, 5, 0,
		},
	},
	["front_viper"] = {
		["flash"] = { 1, 1, 0, 0 },
		["code2"] = { 
			2, 0, 2, 0, 2, 0,
			3, 0, 3, 0, 3, 0
		},
		["code3"] = {
			2, 0, 2, 0,
			3, 0, 3, 0
		}
	},
	["front_interior"] = {
		["flash"] = { 1, 1, 1, 0, 0, 0 },
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
	["mirror_leds"] = {
		["code1"] = { 1 },
		["code2"] = { 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0 },
		["code3"] = { 2, 0, 2, 0, 2, 0, 0, 0, 3, 0, 3, 0, 3, 0, 0, 0 }
	},
	["rear_200"] = {
		["flash"] = { 1, 1, 1, 1, 0, 0, 0, 0 },
		["code1"] = { 8, 8, 8, 0, 9, 9, 9, 0 },
		["code2"] = { 2, 2, 2, 0, 3, 3, 3, 0 },
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
		}
	},
	["rear_vipers"] = {
		["flash"] = { 1, 1, 0, 0 },
		["code1"] = { 2, 2, 2, 0, 3, 3, 3, 0 },
		["code2"] = { 2, 2, 0, 3, 3, 0 },
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
			5, 0, 5, 0, 5, 0
		}
	},
	["rear_fluor"] = {
		["flash"] = { 1, 1, 0, 0 },
		["alt"] = { 2 }
	},
	-- 	HALOGEN LIGHTBAR --
	["lightbar_halogen"] = {
		["all"] = { 1 }
	},
	["lightbar_halogen_rear"] = {
		["code1"] = { 1 },
		["alt"] = { 2 },
	},
	["lightbar_halogen_front"] = {
		["alt"] = { 1 }
	},
	["lightbar_halogen_xenon_rear"] = {
		["code1"] = { 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	},
	["lightbar_halogen_xenon_front"] = {
		["code2"] = { 1, 0, 1, 0, 1, 0, 2, 0, 2, 0, 2, 0 }
	},
	["lightbar_halogen_rotators"] = {
		["code3"] = { 1 }
	},
	["lightbar_halogen_takedowns"] ={
		["code3"] = { 1 }
	},
	
	-- WHELEN FREEDOM --
	["lightbar_freedom_rb"] = {
		["all"] = { 1 }
	},
	["lightbar_freedom_rb_outer"] = {
		["code1"] = { 
			2, 0, 2, 0, 2, 
			0, 0, 0, 0, 0,
			3, 0, 3, 0, 3,
			0, 0, 0, 0, 0,
		},
		["code3"] = {
			2, 0, 2, 0, 2, 0,
			3, 0, 3, 0, 3, 0
		}
	},
	["lightbar_freedom_rb_inner"] = {
		["code2"] = {
			2, 0, 2, 0,
			0, 0, 0, 0,
			3, 0, 3, 0,
			0, 0, 0, 0,
		},
		["code3"] = {
			2, 0, 3, 0
		}
	},
	["lightbar_freedom_rb_halogen"] = {
		["code1"] = { 1 },
		["code3"] = { 2 }
	},
	["lightbar_freedom_b_halogen"] = {
		["code1"] = { 1 },
		["code3"] = { 2 }
	},
	["lightbar_freedom_b_outer"] = {
		["code1"] = { 
			2, 0, 2, 0, 2, 
			0, 0, 0, 0, 0,
			3, 0, 3, 0, 3,
			0, 0, 0, 0, 0,
		},
		["code3"] = {
			2, 0, 2, 0, 2, 0,
			3, 0, 3, 0, 3, 0
		}
	},
	["lightbar_freedom_b_inner"] = {
		["code2"] = {
			2, 0, 2, 0,
			0, 0, 0, 0,
			3, 0, 3, 0,
			0, 0, 0, 0,
		},
		["code3"] = {
			2, 0, 3, 0
		}
	},
	["lightbar_freedom_b_halogen"] = {
		["code1"] = { 1 },
		["code3"] = { 2 }
	},
	["lightbar_freedom_illum"] = {
		["code1"] = { 1 },
		["code3"] = { 2 }
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
	
	["lightbar_vector_r"] = {
		["all"] = { 1 },
		["code1"] = { 2 },
		["code2"] = { 3 },
		["code3"] = { 4 }
	},
	["lightbar_vector_rb"] = {
		["code1"] = { 1 },
		["code2"] = { 2 },
		["code3"] = { 3 }
	},
	["lightbar_vector_ta"] = {
		["code1"] = { 1, 1, 1, 0, 2, 2, 2 },
		["code2"] = { 1, 1, 1, 0, 2, 2, 2 },
		["code3"] = { 1, 0, 1, 0, 1, 2, 0, 2, 0, 2, 0 },
	},
	
	-- TRAFFIC --
	
	["traffic"] = {
		["right"] = {
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
		["left"] = {
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
		["warn"] = {
			14, 0, 14, 0,
			15, 0, 15, 0,
			14, 0, 14, 0,
			15, 0, 15, 0,
			14, 0, 14, 0,
			15, 0, 15, 0,
			
			16, 0, 16, 0,
			17, 0, 17, 0,
			16, 0, 16, 0,
			17, 0, 17, 0,
			16, 0, 16, 0,
			17, 0, 17, 0,
			
			18, 0, 18, 0,
			19, 0, 19, 0,
			18, 0, 18, 0,
			19, 0, 19, 0,
			18, 0, 18, 0,
			19, 0, 19, 0,
		}
	},
	["headlights"] = {
		["code3"] = { 1 }
	},
	["reverse"] = {
		["flash"] = { 1 }
	}
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
				["mirror leds"] = {
					["0"] = {
						["mirror_leds"] = "code1"
					}
				},
				["rear interior lightbar"] = {
					["0"] = {
						["rear_200"] = "code1"
					},
					["1"] = {
						["rear_vipers"] = "code1"
					},
					["2"] = {
						["rear_fluor"] = "alt"
					}
				},
				["lightbar"] = {
					["0"] = {
						--["lightbar_halogen"] = "all"
						["lightbar_halogen_rear"] = "code1",
						["lightbar_halogen_xenon_rear"] = "code1"
					},
					["1"] = {
						["lightbar_freedom_rb_outer"] = "code1",
						["lightbar_freedom_rb_halogen"] = "code1",
						["lightbar_freedom_illum"] = "code1",
					},
					["2"] = {
						["lightbar_freedom_b_outer"] = "code1",
						["lightbar_freedom_b_halogen"] = "code1",
						["lightbar_freedom_illum"] = "code1",
					},
					["3"] = {
						["lightbar_liberty_corner"] = "code1",
						["lightbar_liberty_inner"] = "code1",
						["lightbar_liberty_illum"] = "all"
					},
					["4"] = {
						["lightbar_vector_r"] = "code1",
						["lightbar_vector_ta"] = "code2",
					},
					["5"] = {
						["lightbar_vector_rb"] = "code1",
						["lightbar_vector_ta"] = "code2",
					}
				}
			},
			Disconnect = {
				1, 2, 3, 4, 10, 11, 12, 13
			}
		},
		{
			Name = "CODE 2",
			Components = {
				["reverse"] = "flash"
			},
			BG_Components = {
				["front interior lightbar"] = {
					["0"] = {
						["front_viper"] = "code2"
					},
					["1"] = {
						["front_interior"] = "code2"
					}
				},
				["rear interior lightbar"] = {
					["0"] = {
						["rear_200"] = "code2"
					},
					["1"] = {
						["rear_vipers"] = "code2"
					},
					["2"] = {
						["rear_fluor"] = "alt"
					}
				},
				["grille leds"] = {
					["1"] = {
						["grille_leds"] = "code2"
					}
				},
				["push bar"] = {
					["0"] = {
						["pushbar_leds"] = "code2"
					}
				},
				["mirror leds"] = {
					["0"] = {
						["mirror_leds"] = "code2"
					}
				},
				["lightbar"] = {
					["0"] = {
						--["lightbar_halogen"] = "all"
						["lightbar_halogen_rear"] = "code1",
						["lightbar_halogen_front"] = "alt",
						["lightbar_halogen_xenon_rear"] = "code1",
						["lightbar_halogen_xenon_front"] = "code2"
					},
					["1"] = {
						["lightbar_freedom_rb_outer"] = "code1",
						["lightbar_freedom_rb_inner"] = "code2",
						["lightbar_freedom_rb_halogen"] = "code1",
					},
					["2"] = {
						["lightbar_freedom_b_outer"] = "code1",
						["lightbar_freedom_b_inner"] = "code2",
						["lightbar_freedom_b_halogen"] = "code1",
					},
					["3"] = {
						["lightbar_liberty"] = "code2"
					},
					["4"] = {
						["lightbar_vector_r"] = "code2",
						["lightbar_vector_ta"] = "code2",
					},
					["5"] = {
						["lightbar_vector_rb"] = "code2",
						["lightbar_vector_ta"] = "code2",
					}
				}	
			},
			Disconnect = {
				1, 2, 3, 4, 10, 11, 12, 13
			}
		},
		{
			Name = "CODE 3",
			Components = {
				["reverse"] = "flash",
				["headlights"] = "code3"
			},
			BG_Components = {
				["front interior lightbar"] = {
					["0"] = {
						["front_viper"] = "code3"
					},
					["1"] = {
						["front_interior"] = "code3"
					}
				},
				["rear interior lightbar"] = {
					["0"] = {
						["rear_200"] = "code3"
					},
					["1"] = {
						["rear_vipers"] = "code3"
					},
					["2"] = {
						["rear_fluor"] = "alt"
					}
				},
				["grille leds"] = {
					["1"] = {
						["grille_leds"] = "code3"
					}
				},
				["push bar"] = {
					["0"] = {
						["pushbar_leds"] = "code3"
					}
				},
				["mirror leds"] = {
					["0"] = {
						["mirror_leds"] = "code3"
					}
				},
				["lightbar"] = {
					["0"] = {
						["lightbar_halogen_rear"] = "code1",
						["lightbar_halogen_front"] = "alt",
						["lightbar_halogen_xenon_rear"] = "code1",
						["lightbar_halogen_xenon_front"] = "code2",
						["lightbar_halogen_rotators"] = "code3",
						["lightbar_halogen_takedowns"] = "code3"
					},
					["1"] = {
						["lightbar_freedom_rb_outer"] = "code3",
						["lightbar_freedom_rb_inner"] = "code3",
						["lightbar_freedom_rb_halogen"] = "code3",
						["lightbar_freedom_illum"] = "code3"
					},
					["2"] = {
						["lightbar_freedom_b_outer"] = "code3",
						["lightbar_freedom_b_inner"] = "code3",
						["lightbar_freedom_b_halogen"] = "code3",
						["lightbar_freedom_illum"] = "code3"
					},
					["3"] = {
						["lightbar_liberty_corner"] = "code3",
						["lightbar_liberty_inner"] = "code3",
						["lightbar_liberty"] = "code3",
						["lightbar_liberty_illum"] = "alt"
					},
					["4"] = {
						["lightbar_vector_r"] = "code3",
						["lightbar_vector_ta"] = "code3",
					},
					["5"] = {
						["lightbar_vector_rb"] = "code3",
						["lightbar_vector_ta"] = "code3",
					}
				}		
			},
			Disconnect = { 6, 7, 1, 2, 3, 4, 10, 11, 12, 13 }
		},
	},
	Traffic = {
		{
			Name = "LEFT",
			Components = {},
			BG_Components = {
				["rear interior traffic advisor"] = {
					["0"] = {
						["traffic"] = "left"
					}
				}
			},
			Disconnect = {}
		},
	    {
			Name = "RIGHT",
			Components = {},
			BG_Components = {
				["rear interior traffic advisor"] = {
					["0"] = {
						["traffic"] = "right"
					}
				}
			},
			Disconnect = {}
		},
	    {
			Name = "DIVERGE",
			Components = {},
			BG_Components = {
				["rear interior traffic advisor"] = {
					["0"] = {
						["traffic"] = "diverge"
					}
				}
			},
			Disconnect = {}
		},
		{
			Name = "WARN",
			Components = {},
			BG_Components = {
				["rear interior traffic advisor"] = {
					["0"] = {
						["traffic"] = "warn"
					}
				}
			},
			Disconnect = {}
		},
	},
	Illumination = {
		{
			Name = "LAMP",
			Components = {
				
			},
			BG_Components = {
				["spotlights"] = {
					["0"] = {
						{ 133, SW, 2 },
						{ 134, SW, 2 }
					},
					["1"] = {
						{ 133, SW, 2 },
						{ 134, SW, 2 }
					}
				},
				["lightbar"] = {
					["0"] = {
						{ 45, SW, 1.5 },
						{ 46, SW, 1.5 }
					},
					["1"] = {
						{ 77, SW, 1.5 },
						{ 78, SW, 1.5 }
					},
					["2"] = {
						{ 77, SW, 1.5 },
						{ 78, SW, 1.5 }
					},
					["3"] = {
						{ 97, W, 1.5 },
						{ 98, W, 1.5 }
					}
				}
			},
			Lights = {
				{ Vector( 40.96, 37.09, 56.85 ), Angle( 20, 90, -0 ), "lamp" },
				{ Vector( -40.96, 37.09, 56.85 ), Angle( 20, 90, -0 ), "lamp" },
			},
			Disconnect = { 45, 46, 77, 78 }
		},
	}
}


EMV.Lamps = {
	["lamp"] = {
		Color = Color(106,96,96,255),
		Texture = "effects/flashlight001",
		Near = 200,
		FOV = 70,
		Distance = 700,
	}
}

Photon.EMVLibrary[name] = EMV