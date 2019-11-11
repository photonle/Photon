AddCSLuaFile()

local A = "AMBER"
local DA = "D_AMBER"
local R = "RED"
local DR = "D_RED"
local B = "BLUE"
local W = "WHITE"
local SW = "S_WHITE"
local CW = "C_WHITE"

local PI = {}

PI.Meta = {

	headlight = {
		AngleOffset = -90,
		W = 10,
		H = 10,
		Sprite = "sprites/emv/fpiu_headlight",
		Scale = 2.5,
		WMult = 1
	},

	running = {
		AngleOffset = -90,
		W = 9.5,
		H = 12,
		Sprite = "sprites/emv/fpiu_running",
		Scale = 2.5,
		WMult = 1
	},

	side_marker = {
		AngleOffset = -90,
		W = 14,
		H = 13,
		Sprite = "sprites/emv/fpiu_sidemarker",
		Scale = 1.5,
		WMult = .5
	},

	turn_signal = {
		AngleOffset = -90,
		W = 10,
		H = 12,
		Sprite = "sprites/emv/fpiu_turnsignal",
		Scale = 1,
		WMult = 1
	},

	front_hideaway = {
		AngleOffset = -90,
		W = 17,
		H = 15,
		Sprite = "sprites/emv/fpiu_hideaway",
		Scale = 1,
		WMult = 1
	},

	fog_lamp = {
		AngleOffset = -90,
		W = 22,
		H = 17,
		Sprite = "sprites/emv/fpiu_foglamp",
		Scale = 2,
		WMult = .6
	},

	brake_light = {
		AngleOffset = 90,
		W = 11.5,
		H = 11,
		Sprite = "sprites/emv/fpiu_brakelight",
		Scale = 1.5,
		WMult = 2.5
	},

	taillight = {
		AngleOffset = 90,
		W = 10,
		H = 10,
		Sprite = "sprites/emv/fpiu_taillight",
		Scale = 1.5,
		WMult = 1
	},

	rear_turn = {
		AngleOffset = 90,
		W = 14.5,
		H = 14,
		Sprite = "sprites/emv/fpiu_rearturn",
		Scale = 2,
		WMult = .75
	},

	rear_marker = {
		AngleOffset = 90,
		W = 11,
		H = 12,
		Sprite = "sprites/emv/fpiu_rearmarker",
		Scale = .5,
		WMult = 2
	},

	reverse = {
		AngleOffset = 90,
		W = 8,
		H = 8,
		Sprite = "sprites/emv/fpiu_reverse",
		Scale = 1,
		WMult = 1
	},

}

PI.Positions = {
	[1] = { Vector( -28, 103.33, 44.13 ), Angle( 0, 31, 17 ), "headlight" },
	[2] = { Vector( 28, 103.33, 44.13 ), Angle( 180, -31, 163 ), "headlight" },

	[3] = { Vector( -41.87, 89.88, 48.53 ), Angle( 0, 65, 19.15 ), "side_marker" },
	[4] = { Vector( 41.87, 89.88, 48.53 ), Angle( 180, -65, 159.15 ), "side_marker" },

	[5] = { Vector( -36.44, 96.56, 48.18 ), Angle( 0, 42.9, 17 ), "running" },
	[6] = { Vector( 36.44, 96.56, 48.18 ), Angle( 180, -37, 163 ), "running" },

	[7] = { Vector( -28.29, 104.14, 44.73 ), Angle( 1, 31.2, 14 ), "turn_signal" },
	[8] = { Vector( 28.29, 104.14, 44.73 ), Angle( 179, -31.2, 166 ), "turn_signal" },

	[9] = { Vector( -25.89, 107.04, 41.23 ), Angle( 1, 30, 0 ), "front_hideaway" },
	[10] = { Vector( 25.89, 107.04, 41.23 ), Angle( 179, -30, 180 ), "front_hideaway" },

	[11] = { Vector( -37.96, 98.48, 30.03 ), Angle( 1, 47, 0 ), "fog_lamp" },
	[12] = { Vector( 37.96, 98.48, 30.03 ), Angle( 179, -47, 180 ), "fog_lamp" },

	[13] = { Vector( -0.2, -108.9, 81.75 ), Angle( 0, 0, 53 ), "brake_light" },

	[14] = { Vector( -34.1, -117, 53.8 ), Angle( 1.8, -29.95, -6.88 ), "taillight" },
	[15] = { Vector( 34.1, -117, 53.8 ), Angle( 180, 30, 190 ), "taillight" },

	[16] = { Vector( -36.32, -115.73, 50.97 ), Angle( -5.19, -30.14, -6.99 ), "rear_turn" },
	[17] = { Vector( 36.32, -115.73, 50.97 ), Angle( 185.19, 30.14, 186.99 ), "rear_turn" },

	[18] = { Vector( -41.07, -104.95, 59.77 ), Angle( 0, -75, -13 ), "rear_marker" },
	[19] = { Vector( 41.07, -104.95, 59.77 ), Angle( 180, 75, 193 ), "rear_marker" },

	[20] = { Vector( -33.62, -116.33, 58.12 ), Angle( 0, -30.14, 0 ), "reverse" },
	[21] =  {Vector( 33.62, -116.33, 58.12 ), Angle( 180, 30.14, 180), "reverse" },
}

PI.States = {}

PI.States.Headlights = {}
PI.States.Brakes = {
	{ 13, R, 1 }, { 14, DR, 1 }, { 15, DR, 1 }
}
PI.States.Blink_Left = {
	{ 16, A, 1 }, { 7, A, 1 },
}
PI.States.Blink_Right = {
	{ 17, A, 1 }, { 8, A, 1 }, 
}
PI.States.Reverse = {
	{ 20, W, 1 }, { 21, W, 1 },
}
PI.States.Running = {
	{ 3, A }, { 4, A }, { 5, CW, .5 }, { 6, CW, .5 }, 
	{ 14, DR, .5 }, { 15, DR, .5 },
	{ 18, DR, .5 }, { 19, DR, .5 }, 
}


Photon.VehicleLibrary["sm_fpiu17"] = PI