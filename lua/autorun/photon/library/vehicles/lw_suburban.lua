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
		W = 4.2,
		H = 5.7,
		Sprite = "sprites/emv/square_src",
		Scale = 1.8
	},

	tail_light_src = {
		AngleOffset = 90,
		W = 13,
		H = 13,
		Sprite = "sprites/emv/taurus_tail",
		SourceOnly = true,
	},

	top_tail = {
		AngleOffset = 90,
		W = 3.1,
		H = 6,
		Sprite = "sprites/emv/square_src",
	},

	headlight = {
		AngleOffset = -90,
		W = 7,
		H = 7,
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

	reverse_lights = {
		AngleOffset = 90,
		W = 4,
		H = 3,
		Sprite = "sprites/emv/square_src",
		Scale = 1
	},

}

PI.Positions = {

	 [1] = { Vector( -40, -124.74, 47.5 ), Angle( 0,-23,2 ), "tail_light" },
	 [2] = { Vector( 40, -124.74, 47.5 ), Angle( 0,23,2 ), "tail_light" },

	 [3] = { Vector( -40, -124.8, 53.1 ), Angle( 0,-21,-2 ), "reverse_lights" },
	 [4] = { Vector( 40, -124.8, 53.1 ), Angle( 0,21, -2 ), "reverse_lights" },
	 
	 [5] = { Vector( 0, -120.4, 86.1 ), Angle( 0,0,-30 ), "brake_src" },
	 
	 [6] = { Vector( -1, -120.4, 86.1 ), Angle( 0,0,-35 ), "brake_led" },
	 [7] = { Vector( 1, -120.4, 86.1 ), Angle( 0,0,-35 ), "brake_led" },

	 [8] = { Vector( -3, -120.4, 86.1 ), Angle( 0,0,-35 ), "brake_led" },
	 [9] = { Vector( 3, -120.4, 86.1 ), Angle( 0,0,-35 ), "brake_led" },

	[10] = { Vector( -5, -120.4, 86.1 ), Angle( 0,0,-35 ), "brake_led" },
	[11] = { Vector( 5, -120.4, 86.1 ), Angle( 0,0,-35 ), "brake_led" },

	[12] = { Vector( -7, -120.4, 86.1 ), Angle( 0,0,-35 ), "brake_led" },
	[13] = { Vector( 7, -120.4, 86.1 ), Angle( 0,0,-35 ), "brake_led" },

	[14] = { Vector( -37.8, 124.8, 48.15 ), Angle( 0,0,0 ), "headlight" },
	[15] = { Vector( 37.8, 124.8, 48.15 ), Angle( 0,0,0 ), "headlight" },

	[16] = { Vector( -31, 130.3, 43 ), Angle( 0,18,0 ), "front_marker" },
	[17] = { Vector( 31, 130.3, 43 ), Angle( 0,-18,0 ), "front_marker" },

	[18] = { Vector( -39.3, -124.37, 58.6 ), Angle( 6.9, -21.5, -6.3 ), "top_tail" },
	[19] = { Vector( 39.3, -124.37, 58.6 ), Angle( -6.9, 21.5, -6.3 ), "top_tail" },

	[20] = { Vector( -37.9, 126.76, 43.1 ), Angle( 0, 35.4, 0 ), "front_marker" },
	[21] = { Vector( 37.9, 126.76, 43.1 ), Angle( 0, -35.4, 0 ), "front_marker" },

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
	{ 20, A }, { 18, DR }
}

PI.States.Blink_Right = {
	{ 21, A }, { 19, DR }
}

PI.States.Reverse = {
	{ 3, SW }, { 4, SW }
}

PI.States.Running = {
	{ 14, SW, 1 }, { 15, SW, 1 }, 
	{ 16, A, 1 }, { 17, A, 1 }, 
	{ 1, DR, .25 }, { 2, DR, .25 },
	{ 18, DR, .25 }, { 19, DR, .25 }
}

Photon.VehicleLibrary["lw_suburban"] = PI