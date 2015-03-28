AddCSLuaFile()

local A = "AMBER"
local DA = "D_AMBER"
local R = "RED"
local DR = "D_RED"
local B = "BLUE"
local W = "WHITE"
local SW = "S_WHITE"

local PI = {}

PI.Meta = {

	tail_light = {
		AngleOffset = 90,
		W = 6.9,
		H = 6.9,
		--Sprite = "sprites/emv/led_single",
		Sprite = "sprites/emv/explorer_turn",
		WMult = .1,
		Scale = 2
	},

	tail_light_src = {
		AngleOffset = 90,
		W = 13,
		H = 13,
		Sprite = "sprites/emv/explorer_turn",
		-- SourceOnly = true,
	},

	headlight = {
		AngleOffset = -90,
		W = 4.4,
		H = 4.4,
		Sprite = "sprites/emv/light_circle",
		Scale = 2,
		VisRadius = 5
	},

	foglight = {
		AngleOffset = -90,
		W = 4.6,
		H = 4.6,
		Sprite = "sprites/emv/light_circle",
		Scale = 1,
		VisRadius = 5
	},

	brake = {
		AngleOffset = 90,
		W = 13,
		H = 9,
		Sprite = "sprites/emv/generic_brakelight",
		-- SourceOnly = true,
		Scale = 2,
		WMult = 3
	},

	brake_led = {
		AngleOffset = 90,
		W = 1,
		H = 1,
		Sprite = "sprites/emv/led_single",
		Scale = .3,
	},

	front_marker = {
		AngleOffset = -90,
		W = 13,
		H = 14,
		Sprite = "sprites/emv/impala_reverse",
		Scale = 2,
		WMult = 3
	},

	reverse_lights = {
		AngleOffset = 90,
		W = 8,
		H = 6.9,
		Sprite = "sprites/emv/impala_reverse",
		Scale = 1,
		WMult = 2
	},

}

PI.Positions = {

	[1] = { Vector( -32.3, 106.4, 41.7 ), Angle( 0, 0, 0 ), "headlight" },
	[2] = { Vector( 32.3, 106.4, 41.7 ), Angle( 0, 0, 0 ), "headlight" },

	[3] = { Vector( -38.2, -107.25, 50.6 ), Angle( 0, -40, 0 ), "brake_led" },
	[4] = { Vector( 38.2, -107.25, 50.6 ), Angle( 0, 40, 0 ), "brake_led" },

	[5] = { Vector( -38.5, -107.1, 49.8 ), Angle( 0, -40, 0 ), "brake_led" },
	[6] = { Vector( 38.5, -107.1, 49.8 ), Angle( 0, 40, 0 ), "brake_led" },

	[7] = { Vector( -38.5, -107.1, 48.8 ), Angle( 0, -40, 0 ), "brake_led" },
	[8] = { Vector( 38.5, -107.1, 48.8 ), Angle( 0, 40, 0 ), "brake_led" },

	[9] = { Vector( -38.4, -107.16, 47.9 ), Angle( 0, -35, 0 ), "brake_led" },
	[10] = { Vector( 38.4, -107.16, 47.9 ), Angle( 0, 35, 0 ), "brake_led" },

	[11] = { Vector( -38.2, -107.3, 46.9 ), Angle( 0, -35, 0 ), "brake_led" },
	[12] = { Vector( 38.2, -107.3, 46.9 ), Angle( 0, 35, 0 ), "brake_led" },

	[13] = { Vector( -38.05, -107.4, 46.1 ), Angle( 0, -37, 0 ), "brake_led" },
	[14] = { Vector( 38.05, -107.4, 46.1 ), Angle( 0, 37, 0 ), "brake_led" },

	[15] = { Vector( -37.84, -107.6, 45.2 ), Angle( 0, -37, 0 ), "brake_led" },
	[16] = { Vector( 37.84, -107.6, 45.2 ), Angle( 0, 37, 0 ), "brake_led" },

	[17] = { Vector( -37.5, -107.8, 44.4 ), Angle( 0, -37, 0 ), "brake_led" },
	[18] = { Vector( 37.5, -107.8, 44.4 ), Angle( 0, 37, 0 ), "brake_led" },

	[19] = { Vector( -37.1, -108.1, 43.8 ), Angle( 0, -37, 0 ), "brake_led" },
	[20] = { Vector( 37.1, -108.1, 43.8 ), Angle( 0, 37, 0 ), "brake_led" },

	[21] = { Vector( -36.3, -108.6, 43.5 ), Angle( 0, -37, 0 ), "brake_led" },
	[22] = { Vector( 36.3, -108.6, 43.5 ), Angle( 0, 37, 0 ), "brake_led" },

	[23] = { Vector( -35.49, -109.1, 43.4 ), Angle( 0, -37, 0 ), "brake_led" },
	[24] = { Vector( 35.49, -109.1, 43.4 ), Angle( 0, 37, 0 ), "brake_led" },

	[25] = { Vector( -34.8, -109.6, 43.8 ), Angle( 0, -30, 0 ), "brake_led" },
	[26] = { Vector( 34.8, -109.6, 43.8 ), Angle( 0, 30, 0 ), "brake_led" },

	[27] = { Vector( -34.7, -109.6, 44.6 ), Angle( 0, -26, 0 ), "brake_led" },
	[28] = { Vector( 34.7, -109.6, 44.6 ), Angle( 0, 26, 0 ), "brake_led" },

	[29] = { Vector( -34.7, -109.6, 45.5 ), Angle( 0, -26, 0 ), "brake_led" },
	[30] = { Vector( 34.7, -109.6, 45.5 ), Angle( 0, 26, 0 ), "brake_led" },

	[31] = { Vector( -34.72, -109.6, 46.2 ), Angle( 0, -26, 0 ), "brake_led" },
	[32] = { Vector( 34.72, -109.6, 46.2 ), Angle( 0, 26, 0 ), "brake_led" },

	[33] = { Vector( -34.77, -109.6, 46.9 ), Angle( 0, -26, 0 ), "brake_led" },
	[34] = { Vector( 34.77, -109.6, 46.9 ), Angle( 0, 26, 0 ), "brake_led" },

	[35] = { Vector( -34.8, -109.6, 47.7 ), Angle( 0, -26, 0 ), "brake_led" },
	[36] = { Vector( 34.8, -109.6, 47.7 ), Angle( 0, 26, 0 ), "brake_led" },

	[37] = { Vector( -34.9, -109.6, 48.5 ), Angle( 0, -26, 0 ), "brake_led" },
	[38] = { Vector( 34.9, -109.6, 48.5 ), Angle( 0, 26, 0 ), "brake_led" },

	[39] = { Vector( -34.91, -109.6, 49.3 ), Angle( 0, -26, 0 ), "brake_led" },
	[40] = { Vector( 34.91, -109.6, 49.3 ), Angle( 0, 26, 0 ), "brake_led" },

	[41] = { Vector( -34.98, -109.5, 50.0 ), Angle( 0, -30, 0 ), "brake_led" },
	[42] = { Vector( 34.98, -109.5, 50.0 ), Angle( 0, 30, 0 ), "brake_led" },

	[43] = { Vector( -35.1, -109.4, 50.7 ), Angle( 0, -30, 0 ), "brake_led" },
	[44] = { Vector( 35.1, -109.4, 50.7 ), Angle( 0, 30, 0 ), "brake_led" },

	[45] = { Vector( -35.77, -109, 50.97 ), Angle( 0, -30, 0 ), "brake_led" },
	[46] = { Vector( 35.77, -109, 50.97 ), Angle( 0, 30, 0 ), "brake_led" },

	[47] = { Vector( -36.66, -108.4, 51 ), Angle( 0, -30, 0 ), "brake_led" },
	[48] = { Vector( 36.66, -108.4, 51 ), Angle( 0, 30, 0 ), "brake_led" },

	[49] = { Vector( -37.5, -107.85, 51 ), Angle( 0, -30, 0 ), "brake_led" },
	[50] = { Vector( 37.5, -107.85, 51 ), Angle( 0, 30, 0 ), "brake_led" },

	[51] = { Vector( -36.45, -108.6, 47.3 ), Angle( -2, -35, 0 ), "tail_light" },
	[52] = { Vector( 36.45, -108.6, 47.3 ), Angle( 182, 35, 180 ), "tail_light" },

	[53] = { Vector( -34.2, 111.4, 18.3 ), Angle( 0, 0, 0 ), "foglight" },
	[54] = { Vector( 34.2, 111.4, 18.3 ), Angle( 0, 0, 0 ), "foglight" },

	[55] = { Vector( -34.4, 104.9, 46.9 ), Angle( 3, 45, 20 ), "front_marker" },
	[56] = { Vector( 34.4, 104.9, 46.9 ), Angle( -3, -45, 20 ), "front_marker" },

	[57] = { Vector( -37.8, -106.8, 53 ), Angle( 0, -48, -15 ), "reverse_lights" },
	[58] = { Vector( 37.8, -106.8, 53 ), Angle( 0, 48, -15 ), "reverse_lights" },

	[59] = { Vector( 0, -102.9, 76.7 ), Angle( 0, 0, 60 ), "brake" },


}

PI.States = {}

PI.States.Headlights = { -- NOT YET IMPLEMENTED
	
}

PI.States.Brakes = {
	{ 3, R }, { 4, R }, { 5, R }, { 6, R }, { 7, R }, { 8, R }, { 9, R }, { 10, R }, { 11, R }, { 12, R }, { 13, R }, { 14, R }, 
	{ 15, R }, { 16, R }, { 17, R }, { 18, R }, { 19, R }, { 20, R }, { 21, R }, { 22, R }, { 23, R }, { 24, R }, 
	{ 25, R }, { 26, R }, { 27, R }, { 28, R }, { 29, R }, { 30, R }, { 31, R }, { 32, R }, { 33, R }, { 34, R }, 
	{ 35, R }, { 36, R }, { 37, R }, { 38, R }, { 39, R }, { 40, R }, { 41, R }, { 42, R }, { 43, R }, { 44, R }, 
	{ 45, R }, { 46, R }, { 47, R }, { 48, R }, { 49, R }, { 50, R },

	{ 59, DR },
}

PI.States.Blink_Left = {
	{ 51, A },
	{ 55, A }
}
PI.States.Blink_Right = {
	 { 52, A },
	 { 56, A }, 
}

PI.States.Reverse = {
	{ 57, W }, { 58, W }
}

PI.States.Running = {
	{ 1, SW, 1 }, { 2, SW, 1 },

	{ 3, DR, .15 }, { 4, DR, .15 }, { 5, DR, .15 }, { 6, DR, .15 }, { 7, DR, .15 }, { 8, DR, .15 }, { 9, DR, .15 }, { 10, DR, .15 }, { 11, DR, .15 }, { 12, DR, .15 }, { 13, DR, .15 }, { 14, DR, .15 }, 
	{ 15, DR, .15 }, { 16, DR, .15 }, { 17, DR, .15 }, { 18, DR, .15 }, { 19, DR, .15 }, { 20, DR, .15 }, { 21, DR, .15 }, { 22, DR, .15 }, { 23, DR, .15 }, { 24, DR, .15 }, 
	{ 25, DR, .15 }, { 26, DR, .15 }, { 27, DR, .15 }, { 28, DR, .15 }, { 29, DR, .15 }, { 30, DR, .15 }, { 31, DR, .15 }, { 32, DR, .15 }, { 33, DR, .15 }, { 34, DR, .15 }, 
	{ 35, DR, .15 }, { 36, DR, .15 }, { 37, DR, .15 }, { 38, DR, .15 }, { 39, DR, .15 }, { 40, DR, .15 }, { 41, DR, .15 }, { 42, DR, .15 }, { 43, DR, .15 }, { 44, DR, .15 }, 
	{ 45, DR, .15 }, { 46, DR, .15 }, { 47, DR, .15 }, { 48, DR, .15 }, { 49, DR, .15 }, { 50, DR, .15 }, 

	{ 53, W, 1 }, { 54, W, 1 }, 

	{ 55, A, .5 }, { 56, A, .5 }, 
}

Photon.VehicleLibrary["sgm_explorer"] = PI