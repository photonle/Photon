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
		W = 10,
		H = 7,
		Sprite = "sprites/emv/light_circle",
		Scale = 2,
		VisRadius = 10
	},
	running_head = {
		AngleOffset = -90,
		W = 2.75,
		H = 4,
		Sprite = "sprites/emv/light_circle",
		Scale = 1,
		VisRadius = 10
	},
	tail_light = {
		AngleOffset = 90,
		W = 3.5,
		H = 5.7,
		Sprite = "sprites/emv/light_circle",
		Scale = 1,
		VisRadius = 10
	},
	rear_light = {
		AngleOffset = 90,
		W = 5.8,
		H = 8,
		Sprite = "sprites/emv/light_half_circle",
		Scale = 1,
		VisRadius = 10
	},
}

PI.Positions = {
	
	[1] = { Vector( -27, 68.03, 38.4 ), Angle( 28.4, 36.6, 39.7 ), "headlight" },
	[2] = { Vector( 27.6, 68.03, 38.4 ), Angle( -28.4, -36.6, 39.7 ), "headlight" },

	[3] = { Vector( -29.4, -69.04, 56.04 ), Angle( -12.9, -25, -35 ), "tail_light" },
	[4] = { Vector( 30.09, -69.04, 56.04 ), Angle( 12.9, 25, -35 ), "tail_light" },

	[5] = { Vector( -31, 60.89, 42.81 ), Angle( -58.43, -16.91, 61 ), "running_head" },
	[6] = { Vector( 31.7, 60.89, 42.81 ), Angle( 58.43, 16.91, 61 ), "running_head" },

	[7] = { Vector( -31.28, -71.65, 49.74 ), Angle( -5.4, -34.1, -25 ), "rear_light" },
	[8] = { Vector( 31.28, -71.65, 49.74 ), Angle( 5.4, 34.1, -25 ), "rear_light" },

	[9] = { Vector( -31.28, -71.65, 40 ), Angle( 0,0,0 ), "rear_light" },
	[10] = { Vector( 31.28, -71.65, 49.74 ), Angle( 5.4, 34.1, -25 ), "rear_light" },
}

PI.States = {}

PI.States.Headlights = { -- NOT YET IMPLEMENTED
	
}

PI.States.Brakes = {

}

PI.States.Blink_Left = {

}
PI.States.Blink_Right = {

}

PI.States.Reverse = {

}

PI.States.Running = {
	{ 1, SW, 1 }, { 2, SW, 1 },
	{ 3, DR }, { 4, DR },
	{ 5, SW, .5 }, { 6, SW, .5 },
	{ 7, DR }, { 8, DR }
}

if Photon.OverwriteIndex then Photon:OverwriteIndex("Police Nationale - Citroen C1", PI) end
Photon.VehicleLibrary["tdm_citroenc1"] = PI