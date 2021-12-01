AddCSLuaFile()

local A = "AMBER"
local R = "RED"
local DR = "D_RED"
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
		W = 8.6,
		H = 8.6,
		Sprite = "sprites/emv/tdm_fpis_reverse",
		WMult = 2,
		Scale = 1.4
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
		W = 14.5,
		H = 17,
		Sprite = "sprites/emv/tdm_fpis_brake",
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
		Sprite = "sprites/emv/tdm_fpis_forward_1",
		Scale = 1,
	},

	front_2 = {
		AngleOffset = -90,
		W = 4,
		H = 4,
		Sprite = "sprites/emv/tdm_fpis_forward_2",
		Scale = 1,
	},

	front_3 = {
		AngleOffset = -90,
		W = 9,
		H = 9,
		Sprite = "sprites/emv/tdm_fpis_forward_3",
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
		W = 6,
		H = 6,
		Sprite = "sprites/emv/tdm_fpis_forward_out",
		Scale = 2
	},

	rear_signal = {
		AngleOffset = 90,
		W = 3.6,
		H = 4.1,
		Sprite = "sprites/emv/square_src",
		Scale = 1
	},

	brake_upper = {
		AngleOffset = 90,
		W = 8,
		H = 7.5,
		Sprite = "sprites/emv/tdm_fpis_brake_upper",
		Scale = 1.6,
		WMult = 2
	},

	brake_lower = {
		AngleOffset = 90,
		W = 10,
		H = 8.5,
		Sprite = "sprites/emv/tdm_fpis_brake_upper",
		Scale = 1.6,
		WMult = 2
	},

}

PI.Positions = {

	 [1] = { Vector( -27.78, -112.7, 52.59 ), Angle( 0, -29, -16 ), "tail_light_src" }, -- 1
	 [2] = { Vector( 27.78, -112.7, 52.59 ), Angle( 0, 29, 180-16 ), "tail_light_src" }, -- 2

	 [3] = { Vector( -25.92, -115.48, 48.51 ), Angle( 0, -22, -16 ), "tail_light_src" }, -- 3
	 [4] = { Vector( 25.92, -115.48, 48.51 ), Angle( 0, 22, 180-16 ), "tail_light_src" }, -- 4

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

	[15] = { Vector( -33.3, 107.4, 38.5 ), Angle( 0, 0, 0 ), "headlight" }, -- 15
	[16] = { Vector( 33.3, 107.4, 38.5 ), Angle( 0, 0, 0 ), "headlight" }, -- 16

	[17] = { Vector( -1, -64.2, 71.15 ), Angle( 0, 0, 0 ), "brake_led" },
	[18] = { Vector( 1, -64.2, 71.15 ), Angle( 0, 0, 0 ), "brake_led" },

	[19] = { Vector( -3, -64.2, 71.15 ), Angle( 0, 0, 0 ), "brake_led" },
	[20] = { Vector( 3, -64.2, 71.15 ), Angle( 0, 0, 0 ), "brake_led" },

	[21] = { Vector( -5, -64.2, 71.15 ), Angle( 0, 0, 0 ), "brake_led" },
	[22] = { Vector( 5, -64.2, 71.15 ), Angle( 0, 0, 0 ), "brake_led" },

	[23] = { Vector( 0, -64.3, 71.16 ), Angle( 0, 0, 0 ), "brake_src" },

	[24] = { Vector( -30.26, 111.97, 36.12 ), Angle( 0, 27, 0 ), "front_marker" },
	[25] = { Vector( 30.26, 111.97, 36.12 ), Angle( 0, -27, 180 ), "front_marker" },

	[26] = { Vector( -26.4, -108.9, 49.2 ), Angle( 177, -20, 200 ), "reverse_lights" },
	[27] = { Vector( 26.4, -108.9, 49.2 ), Angle( 3, 20, -20 ), "reverse_lights" },

	[28] = { Vector( -37.84, 102.9, 39 ), Angle( 0, 60, 0 ), "front_signal" },
	[29] = { Vector( 37.84, 102.9, 39 ), Angle( 0, -60, 180 ), "front_signal" },

	[30] = { Vector( -31.4, -104.41, 49.2 ), Angle( -4.5, 0.2, -16.6 ), "rear_signal" },
	[31] = { Vector( 31.4, -104.41, 49.2 ), Angle( 4.5, -0.2, -16.6 ), "rear_signal" },

	[32] = { Vector( -28.15, 111.57, 39.32 ), Angle( 0, 35, 0 ), "front_3" },
	[33] = { Vector( 28.15, 111.57, 39.32 ), Angle( 180, -35, 180 ), "front_3" },

	[34] = { Vector( -28.97, 112.2, 37.62 ), Angle( 0, 35, 0 ), "front_2" },
	[35] = { Vector( 28.97, 112.2, 37.62 ), Angle( 180, -35, 180 ), "front_2" },

	[36] = { Vector( -34.22, -108.28, 52.51 ), Angle( -2, -42, -25 ), "brake_upper" }, -- 3
	[37] = { Vector( 34.22, -108.28, 52.51 ), Angle( 182, 42, 205 ), "brake_upper" },

	[38] = { Vector( -33.82, -110.78, 48.41 ), Angle( -2, -42, -25 ), "brake_lower" }, -- 3
	[39] = { Vector( 33.82, -110.78, 48.41 ), Angle( 182, 42, 205 ), "brake_lower" },

}

PI.States = {}

PI.States.Headlights = { -- NOT YET IMPLEMENTED

}

PI.States.Brakes = {
	{ 17, DR, 1 }, { 18, DR, 1 }, { 19, DR, 1 }, { 20, DR, 1 }, { 21, DR, 1 }, { 22, DR, 1 }, { 23, DR, 1 },
	{ 36, R }, { 37, R }, { 38, R }, { 39, R },
}

PI.States.Blink_Left = {
	{ 28, A, 2 }, { 1, A }
}
PI.States.Blink_Right = {
	{ 29, A, 2 }, { 2, A }
}

PI.States.Reverse = {
	{ 3, SW }, { 4, SW }
}

PI.States.Running = {
	{ 15, SW, 1}, { 16, SW, 1 },
	{ 24, A, 1 }, { 25, A, 1 }, { 28, A, .6 }, { 29, A, .6 },
	{ 36, R, .2 }, { 37, R, .2 }, { 38, R, .2 }, { 39, R, .2 },
}

Photon.VehicleLibrary["fortauruspoltdm"] = PI
-- Photon:OverwriteIndex("Ford Taurus 2013", PI)

-- INDEX 21