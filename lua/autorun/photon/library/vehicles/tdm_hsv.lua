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
	headlight = {
		AngleOffset = -90,
		W = 6,
		H = 6,
		Sprite = "sprites/emv/light_circle",
		Scale = 2,
		VisRadius = 5
	},

	head_running = {
		AngleOffset = -90,
		W = 4.4,
		H = 4.4,
		Sprite = "sprites/emv/light_circle",
		Scale = 1.5,
		VisRadius = 5
	},

	front_signal = {
		AngleOffset = -90,
		Sprite = "sprites/emv/square_src",
		W = 4,
		H = 10,
	},

	reverse = {
		AngleOffset = 90,
		Sprite = "sprites/emv/light_circle",
		W = 5,
		H = 5,
		VisRadius = 10
	},

	tail_brake = {
		AngleOffset = 90,
		Sprite = "sprites/emv/light_circle",
		W = 5,
		H = 5,
		VisRadius = 10,
		Scale = 2
	},

	brake_src = {
		AngleOffset = 90,
		W = 14,
		H = 3,
		Sprite = "sprites/emv/generic_brakelight",
		SourceOnly = true,
	},

	brake_led = {
		AngleOffset = 90,
		W = 1,
		H = 1,
		Sprite = "sprites/emv/led_single",
		Scale = .6,
	}
}

PI.Positions = {

	[1] = { Vector( -25.9, 109.8, 33.7 ), Angle( -5.47, 14.52, 20.2 ), "headlight" },
	[2] = { Vector( 25.9, 109.8, 33.7 ), Angle( 5.47, -14.52, 20.2 ), "headlight" },

	[3] = { Vector( -32.7, 106.56, 34.03 ), Angle( 0, 9.3, 0 ), "head_running" },
	[4] = { Vector( 32.7, 106.56, 34.03 ), Angle( 0, -9.3, 0 ), "head_running" },

	[5] = { Vector( -37.11, 102.37, 34.03 ), Angle( -18.81, 34.83, 23.19 ), "front_signal" },
	[6] = { Vector( 37.11, 102.37, 34.03 ), Angle( 18.81, -34.83, 23.19 ), "front_signal" },

	[7] = { Vector( -31.31, -108.6, 43.03 ), Angle( 0, -16.3, 0 ), "reverse" },
	[8] = { Vector( 31.31, -108.6, 43.03 ), Angle( 0, 16.3, 0 ), "reverse" },

	[9] = { Vector( -35.49, -104.59, 42.87 ), Angle( 0, -26.5, 0 ), "tail_brake" },
	[10] = { Vector( 35.49, -104.59, 42.87 ), Angle( 0, 26.5, 0 ), "tail_brake" },

	[11] = { Vector( 0, -55.4, 67.6 ), Angle( 0, 0, 0 ), "brake_led" },

	[12] = { Vector( -2, -55.4, 67.6 ), Angle( 0, 0, 0 ), "brake_led" },
	[13] = { Vector( 2, -55.4, 67.6 ), Angle( 0, 0, 0 ), "brake_led" },

	[14] = { Vector( -4, -55.4, 67.6 ), Angle( 0, 0, 0 ), "brake_led" },
	[15] = { Vector( 4, -55.4, 67.6 ), Angle( 0, 0, 0 ), "brake_led" },

	[16] = { Vector( -6, -55.4, 67.6 ), Angle( 0, 0, 0 ), "brake_led" },
	[17] = { Vector( 6, -55.4, 67.6 ), Angle( 0, 0, 0 ), "brake_led" },

	[18] = { Vector( 0, -55.4, 67.6 ), Angle( 0, 0, 0 ), "brake_src" },



}

PI.States = {}

PI.States.Headlights = {}

PI.States.Brakes = {

	{ 9, DR }, { 10, DR },

	{ 18, DR }, { 11, DR },
	{ 12, DR }, { 13, DR },
	{ 14, DR }, { 15, DR },
	{ 16, DR }, { 17, DR },
}

PI.States.Blink_Left = {
	{ 5, A }, { 9, DR }
}

PI.States.Blink_Right = {
	{ 6, A }, { 10, DR }
}

PI.States.Reverse = {
	{ 7, SW }, { 8, SW }
}

PI.States.Running = {
	{ 1, SW }, { 2, SW }, { 3, CW }, { 4, CW }, 
	{ 9, DR, .25 }, { 10, DR, .25 }
}

Photon.VehicleLibrary["tdm_hsv"] = PI