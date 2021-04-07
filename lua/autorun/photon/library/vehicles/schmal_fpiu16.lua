AddCSLuaFile()

local A = "AMBER"
local R = "RED"
local DR = "D_RED"
local W = "WHITE"
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
		W = 7.5,
		H = 10,
		Sprite = "sprites/emv/fpiu_running",
		Scale = 2.5,
		WMult = 1
	},

	side_marker = {
		AngleOffset = -90,
		W = 13,
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
		W = 12,
		H = 10,
		Sprite = "sprites/emv/fpiu_brakelight",
		Scale = 1.5,
		WMult = 2.5
	},

	taillight = {
		AngleOffset = 90,
		W = 8,
		H = 8,
		Sprite = "sprites/emv/fpiu_taillight",
		Scale = 1.5,
		WMult = 1
	},

	rear_turn = {
		AngleOffset = 90,
		W = 14,
		H = 14,
		Sprite = "sprites/emv/fpiu_rearturn",
		Scale = 2,
		WMult = .75
	},

	rear_marker = {
		AngleOffset = 90,
		W = 10,
		H = 10,
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
	[2] = { Vector( 28, 103.33, 44.13 ), Angle( 180, -31, 180-17 ), "headlight" },

	[3] = { Vector( -39.27, 91.78, 44.53 ), Angle( 0, 65, 20 ), "side_marker" },
	[4] = { Vector( 39.27, 91.78, 44.53 ), Angle( 180, -65, 180-20 ), "side_marker" },

	[5] = { Vector( -34.04, 98.06, 44.38 ), Angle( 0, 37, 17 ), "running" },
	[6] = { Vector( 34.04, 98.06, 44.38 ), Angle( 180, -37, 180-17 ), "running" },

	[7] = { Vector( -37.39, 97.14, 41.43 ), Angle( 1, 58.9, 14 ), "turn_signal" },
	[8] = { Vector( 37.39, 97.14, 41.43 ), Angle( 180-1, -58.9, 180-14 ), "turn_signal" },

	[9] = { Vector( -25.89, 107.04, 41.23 ), Angle( 1, 30, 0 ), "front_hideaway" },
	[10] = { Vector( 25.89, 107.04, 41.23 ), Angle( 180-1, -30, 180 ), "front_hideaway" },

	[11] = { Vector( -37.96, 98.48, 30.03 ), Angle( 1, 47, 0 ), "fog_lamp" },
	[12] = { Vector( 37.96, 98.48, 30.03 ), Angle( 180-1, -47, 180 ), "fog_lamp" },

	[13] = { Vector( 0, -96.1, 76.35 ), Angle( 0, 0, 39.3 ), "brake_light" },

	[14] = { Vector( -32.8, -104.4, 50 ), Angle( 0, -30, -10 ), "taillight" },
	[15] = { Vector( 32.8, -104.4, 50 ), Angle( 180, 30, 190 ), "taillight" },

	[16] = { Vector( -35.02, -103.73, 47.67 ), Angle( -5.19, -30.14, -6.99 ), "rear_turn" },
	[17] = { Vector( 35.02, -103.73, 47.67 ), Angle( 185.19, 30.14, 186.99 ), "rear_turn" },

	[18] = { Vector( -38.97, -93.45, 55.67 ), Angle( 0, -75, -13 ), "rear_marker" },
	[19] = { Vector( 38.97, -93.45, 55.67 ), Angle( 180, 75, 193 ), "rear_marker" },

	[20] = { Vector( -32.32, -104.33, 53.92 ), Angle( 0, -30.14, 0 ), "reverse" },
	[21] =  {Vector( 32.32, -104.33, 53.92 ), Angle( 180, 30.14, 180), "reverse" },
}

PI.States = {}

PI.States.Headlights = {}
PI.States.Brakes = {
	{ 13, R }, { 14, DR }, { 15, DR }
}
PI.States.Blink_Left = {
	{ 16, A }, { 7, A },
}
PI.States.Blink_Right = {
	{ 17, A }, { 8, A },
}
PI.States.Reverse = {
	{ 20, W }, { 21, W },
}
PI.States.Running = {
	{ 3, A }, { 4, A }, { 5, CW, .5 }, { 6, CW, .5 },
	{ 14, DR, .5 }, { 15, DR, .5 },
	{ 18, DR, .5 }, { 19, DR, .5 },
}


Photon.VehicleLibrary["2016 Ford Police Interceptor Utility"] = PI