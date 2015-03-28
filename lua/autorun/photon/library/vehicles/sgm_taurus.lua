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
		W = 2,
		H = 2,
		--Sprite = "sprites/emv/led_single",
		Sprite = "sprites/emv/blank",
	},

	tail_light_src = {
		AngleOffset = 90,
		W = 13,
		H = 13,
		Sprite = "sprites/emv/taurus_tail",
		SourceOnly = true,
	},

	headlight = {
		AngleOffset = -90,
		W = 4,
		H = 4,
		Sprite = "sprites/emv/light_circle",
		Scale = 2,
		VisRadius = 0
	},

	brake_src = {
		AngleOffset = 90,
		W = 13,
		H = 4,
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
		W = 4,
		H = 4,
		Sprite = "sprites/emv/taurus_front_side",
		Scale = 1,
	},

	reverse_lights = {
		AngleOffset = 90,
		W = 7,
		H = 6.2,
		Sprite = "sprites/emv/taurus_reverse",
		Scale = 1.6,
		WMult = .1
	},

	front_signal = {
		AngleOffset = -90,
		W = 4.7,
		H = 2.35,
		Sprite = "sprites/emv/square_src",
		Scale = 1
	},

	rear_signal = {
		AngleOffset = 90,
		W = 3.6,
		H = 4.1,
		Sprite = "sprites/emv/square_src",
		Scale = 1
	}

}

PI.Positions = {

	 [1] = { Vector( -31.7, -105.9, 48.7 ), Angle( -12, -40, -20 ), "tail_light_src" }, -- 1
	 [2] = { Vector( 31.7, -105.9, 48.7 ), Angle( 192, 40, 200 ), "tail_light_src" }, -- 2

	 [3] = { Vector(-34.1,-103,49), Angle(0,-49,-12), "tail_light" }, -- 3
	 [4] = { Vector(34.1,-103,49), Angle(0,49,-12), "tail_light" }, -- 4

	 [5] = { Vector(-34.4,-101.6,51), Angle(0,-49,-12), "tail_light" }, -- 5
	 [6] = { Vector(34.4,-101.6,51), Angle(0,49,-12), "tail_light" }, -- 6

	 [7] = { Vector(-33.8,-104.5, 47), Angle(0,-49,-12), "tail_light" }, -- 7
	 [8] = { Vector(33.8,-104.5, 47), Angle(0,49,-12), "tail_light" }, -- 8

	 [9] = { Vector( -32,-106.8, 46), Angle(0,-40,-12), "tail_light" }, -- 9
	[10] = { Vector( 32,-106.8, 46), Angle(0,40,-12), "tail_light" }, -- 10

	[11] = { Vector( -29.4, -108.6, 46 ), Angle( 0, -40, -20 ), "tail_light" }, -- 11
	[12] = { Vector( 29.4, -108.6, 46 ), Angle( 0, 40, -20 ), "tail_light" }, -- 12

	[13] = { Vector( -32.4, -103.1, 52 ), Angle( 0, -49, -12 ), "tail_light" }, -- 13
	[14] = { Vector( 32.4, -103.1, 52 ), Angle( 0, 49, -12 ), "tail_light" }, -- 14

	[15] = { Vector( -30.5, 104, 37 ), Angle( 0, 0, 0 ), "headlight" }, -- 15
	[16] = { Vector( 30.5, 104, 37 ), Angle( 0, 0, 0 ), "headlight" }, -- 16

	[17] = { Vector( -1, -62, 68.8 ), Angle( 0, 0, 0 ), "brake_led" },
	[18] = { Vector( 1, -62, 68.8 ), Angle( 0, 0, 0 ), "brake_led" },

	[19] = { Vector( -3, -62, 68.8 ), Angle( 0, 0, 0 ), "brake_led" },
	[20] = { Vector( 3, -62, 68.8 ), Angle( 0, 0, 0 ), "brake_led" },

	[21] = { Vector( -5, -62, 68.8 ), Angle( 0, 0, 0 ), "brake_led" },
	[22] = { Vector( 5, -62, 68.8 ), Angle( 0, 0, 0 ), "brake_led" },

	[23] = { Vector( 0, -61.3, 68.7 ), Angle( 0, 0, 0 ), "brake_src" },

	[24] = { Vector( -37.5, 97.7, 38.4 ), Angle( 8, 64, 25 ), "front_marker" },
	[25] = { Vector( 37.5, 97.7, 38.4 ), Angle( 172, -64, 155 ), "front_marker" },

	[26] = { Vector( -26.4, -108.9, 49.2 ), Angle( 177, -20, 200 ), "reverse_lights" },
	[27] = { Vector( 26.4, -108.9, 49.2 ), Angle( 3, 20, -20 ), "reverse_lights" },

	[28] = { Vector( -25.1, 108.8, 35.1 ), Angle( 0, 29.3, 0 ), "front_signal" },
	[29] = { Vector( 25.1, 108.8, 35.1 ), Angle( 0, -29.3, 0 ), "front_signal" },

	[30] = { Vector( -31.4, -104.41, 49.2 ), Angle( -4.5, 0.2, -16.6 ), "rear_signal" },
	[31] = { Vector( 31.4, -104.41, 49.2 ), Angle( 4.5, -0.2, -16.6 ), "rear_signal" },

}

PI.States = {}

PI.States.Headlights = { -- NOT YET IMPLEMENTED
	
}

PI.States.Brakes = {
	{ 1, R, .6 }, { 2, R, .6 }, { 3, R, 1 }, { 4, R, 1 }, { 5, R, 1 }, { 6, R, 1 }, { 7, R, 1 }, { 8, R, 1 }, { 9, R, 1 }, { 10, R, 1 }, { 11, R, 1 }, { 12, R, 1 }, { 13, R, 1 }, { 14, R, 1 },
	{ 17, DR, 1 }, { 18, DR, 1 }, { 19, DR, 1 }, { 20, DR, 1 }, { 21, DR, 1 }, { 22, DR, 1 }, { 23, DR, 1 },
}

PI.States.Blink_Left = {
	{ 28, A }, { 30, A }
}
PI.States.Blink_Right = {
	{ 29, A }, { 31, A }
}

PI.States.Reverse = {
	{ 26, SW, 1 }, { 27, SW, 1 }, 
}

PI.States.Running = {
	{ 1, DR, .25 }, { 2, DR, .25 }, { 3, DR, .25 }, { 4, DR, .25 }, { 5, DR, .25 }, { 6, DR, .25 }, { 7, DR, .25 }, { 8, DR, .25 }, { 9, DR, .25 }, { 10, DR, .25 }, { 11, DR, .25 }, { 12, DR, .25 }, { 13, DR, .25 }, { 14, DR, .25 }, { 15, SW, 1}, { 16, SW, 1 },
	{ 24, A, 1 }, { 25, A, 1 }, 
}

Photon.VehicleLibrary["sgm_taurus"] = PI