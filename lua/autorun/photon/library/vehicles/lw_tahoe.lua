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
		W = 5,
		H = 5.7,
		Sprite = "sprites/emv/square_src",
		Scale = 1.8
	},

	tail_top = {
		AngleOffset = 90,
		W = 4,
		H = 4.1,
		Sprite = "sprites/emv/square_src",
		Scale = 1.8
	},

	headlight = {
		AngleOffset = -90,
		W = 6,
		H = 6,
		Sprite = "sprites/emv/light_circle",
		Scale = 2,
		VisRadius = 0
	},

	brake_src = {
		AngleOffset = 90,
		W = 20,
		H = 5,
		Sprite = "sprites/emv/generic_brakelight",
		SourceOnly = true,
	},

	brake_led = {
		AngleOffset = 90,
		W = 1,
		H = 1,
		Sprite = "sprites/emv/led_single",
		Scale = .5,
	},

	front_marker = {
		AngleOffset = -90,
		W = 8,
		H = 2.2,
		Sprite = "sprites/emv/square_src",
		Scale = 1,
		WMult = 1.3
	},

	front_signal = {
		AngleOffset = -90,
		W = 6,
		H = 2.2,
		Sprite = "sprites/emv/square_src",
		Scale = 1,
		WMult = 1.3
	},

	reverse_lights = {
		AngleOffset = 90,
		W = 4,
		H = 4,
		Sprite = "sprites/emv/square_src",
		Scale = 1
	},

}

PI.Positions = {

	 [1] = { Vector( -40, -108, 45.7 ), Angle( 0,-37,0 ), "tail_light" },
	 [2] = { Vector( 40, -108, 45.7 ), Angle( 0,37,0 ), "tail_light" },

	 [3] = { Vector( -39.6, -108.2, 51 ), Angle( 0,-37,0 ), "reverse_lights" },
	 [4] = { Vector( 39.6, -108.2, 51 ), Angle( 0,37,0 ), "reverse_lights" },
	 
	 [5] = { Vector( 0, -103.8, 83.3 ), Angle( 0,0,-35 ), "brake_src" },
	 
	 [6] = { Vector( -1, -103.8, 83.3 ), Angle( 0,0,-35 ), "brake_led" },
	 [7] = { Vector( 1, -103.8, 83.3 ), Angle( 0,0,-35 ), "brake_led" },

	 [8] = { Vector( -3, -103.8, 83.3 ), Angle( 0,0,-35 ), "brake_led" },
	 [9] = { Vector( 3, -103.8, 83.3 ), Angle( 0,0,-35 ), "brake_led" },

	[10] = { Vector( -5, -103.8, 83.3 ), Angle( 0,0,-35 ), "brake_led" },
	[11] = { Vector( 5, -103.8, 83.3 ), Angle( 0,0,-35 ), "brake_led" },

	[12] = { Vector( -7, -103.8, 83.3 ), Angle( 0,0,-35 ), "brake_led" },
	[13] = { Vector( 7, -103.8, 83.3 ), Angle( 0,0,-35 ), "brake_led" },

	[14] = { Vector( -36.5, 100.5, 46 ), Angle( 0,0,0 ), "headlight" },
	[15] = { Vector( 36.5, 100.5, 46 ), Angle( 0,0,0 ), "headlight" },

	[16] = { Vector( -31.7, 103.8, 40.35 ), Angle( 0,18,0 ), "front_marker" },
	[17] = { Vector( 31.7, 103.8, 40.35 ), Angle( 0,-18,0 ), "front_marker" },

	[18] = { Vector( -38.57, 101.74, 40.35 ), Angle( 0, 18, 0 ), "front_signal" },
	[19] = { Vector( 38.57, 101.74, 40.35 ), Angle( 0, -18, 0 ), "front_signal" },

	[20] = { Vector( -39.2, -108.12, 55.7 ), Angle( 0, -37, 0 ), "tail_top" },
	[21] = { Vector( 39.2, -108.12, 55.7 ), Angle( 0, 37, 0 ), "tail_top" },

}

PI.States = {}

PI.States.Headlights = { -- NOT YET IMPLEMENTED
	
}

PI.States.Brakes = {
	{ 1, DR, 1 }, { 2, DR, 1 }, 
	{ 5, DR, .5 },
	{ 6, DR, 1 }, { 7, DR, 1 }, { 8, DR, 1 }, { 9, DR, 1 }, { 10, DR, 1 }, { 11, DR, 1 }, { 12, DR, 1 }, { 13, DR, 1 },
}

PI.States.Blink_Left = {
	{ 20, DR }, { 18, A }
}
PI.States.Blink_Right = {
	{ 21, DR }, { 19, A }
}

PI.States.Reverse = {
	{ 3, SW }, { 4, SW }
}

PI.States.Running = {
	{ 14, SW, 1 }, { 15, SW, 1 }, 
	{ 16, A, 1 }, { 17, A, 1 }, 
	{ 1, DR, .25 }, { 2, DR, .25 },
	{ 20, DR, .25 }, { 21, DR, .25 }
}

Photon.VehicleLibrary["lw_tahoe"] = PI