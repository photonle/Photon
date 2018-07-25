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
		W = 8,
		H = 8,
		Sprite = "sprites/emv/crownvic_tail",
		Scale = 1,
		WMult = 1.5,
	},

	tail_glow = {
		AngleOffset = 90,
		W = 0,
		H = 0,
		Sprite = "sprites/emv/blank",
		Scale = 3,
	},
	
	brake_light = {
		AngleOffset = 90,
		W = 8,
		H = 8,
		Sprite = "sprites/emv/crownvic_brake",
		Scale = 1,
		WMult = 2
	},

	headlight = {
		AngleOffset = -90,
		W = 13,
		H = 14,
		-- Sprite = "sprites/emv/blank",
		Sprite = "sprites/emv/crownvic_headlight",
		Scale = 2,
		WMult = 1
	},

	marker = {
		AngleOffset = -90,
		W = 14,
		H = 14,
		-- Sprite = "sprites/emv/blank",
		Sprite = "sprites/emv/crownvic_marker",
		Scale = 3,
		WMult = .4
	},

	reverse = {
		AngleOffset = 90,
		W = 10,
		H = 11,
		Sprite = "sprites/emv/crownvic_reverse",
		Scale = .75,
		WMult = .1
	},

	out_markers = {
		AngleOffset = -90,
		W = 9,
		H = 9.8,
		Sprite = "sprites/emv/cvpi_corner_marker",
		-- Sprite = "sprites/emv/blank",
		Scale = 1.6,
	}

}

PI.StateMaterials = {
	["basic_lights"] = {
		Index = 30,
		States = {
			["running"] = "photon/override/tdm_cvpi_running"
		}
	}
}

PI.Positions = {

	-- TOP --
	[1] = { Vector( -32.3, -123.2, 39.6 ), Angle( 0, -11.2, -4 ), "tail_light" },
	[2] = { Vector( 32.3, -123.2, 39.6 ), Angle( 0, 11.2, 176 ), "tail_light" },

	-- BOTTOM --
	[3] = { Vector( -33.6, -122.7, 42.2 ), Angle( 0, -16.2, -4 ), "tail_light" },
	[4] = { Vector( 33.6, -122.7, 42.2 ), Angle( 0, 16.2, 176 ), "tail_light" },
	
	-- BRAKE --
	[5] = { Vector( 0, -81.7, 53.6 ), Angle( 0, 0, 0 ), "brake_light" },

	-- HEADLIGHTS --
	[6] = { Vector( -29.2, 114, 34.6 ), Angle( 0, 14, 20 ), "headlight" },
	[7] = { Vector( 29.2, 114, 34.6 ), Angle( 180, -14, 160 ), "headlight" },

	-- MARKER --

	[8] = { Vector( -23.6, 115.2, 34.9 ), Angle( 0, 14, 20 ), "marker" },
	[9] = { Vector( 23.6, 115.2, 34.9 ), Angle( 180, -14, 160 ), "marker" },

	-- REVERSE --

	[10] = { Vector( -11.7, -125.4, 38.3 ), Angle( 180, -1, 183.1 ), "reverse" },
	[11] = { Vector( 11.7, -125.4, 38.3 ), Angle( 0, 1, -3.1 ), "reverse" },

	-- TAIL GLOWS --
	[12] = { Vector(-32.3,-125.5,40), Angle(0,20,-30), "tail_glow" },
	[13] = { Vector(32.3,-125.5,40), Angle(0,20,30), "tail_glow" },

	-- OUT MARKERS --
	[14] = { Vector( -36.65, 110.57, 34.3 ), Angle( -1.72 - 180, 48.57, 180 - 11.47 ), "out_markers" },
	[15] = { Vector( 36.65, 110.57, 34.3 ), Angle( -1.72, -48.57, 11.47 ), "out_markers" },

}

PI.States = {}

PI.States.Headlights = {}
PI.States.Brakes = {
	{ 1, DR, 1 }, { 2, DR, 1 }, { 3, DR, 1 }, { 4, DR, 1 }, { 5, DR, 1 }
}
PI.States.Blink_Left = {
	{ 1, R }, { 3, R }, --{ 12, R }, 
	{ 8, A, 1 },
}
PI.States.Blink_Right = {
	{ 2, R }, { 4, R }, --{ 13, R }, 
	{ 9, A, 1 },
}
PI.States.Reverse = {
	{ 10, SW }, { 11, SW }
}
PI.States.Running = {
	{ 1, DR, .25 }, { 2, DR, .25 }, { 3, DR, .25 }, { 4, DR, .25 },  --{ 12, DR, .25 }, { 13, DR, .25 }, 
	{ 6, SW, 1 }, { 7, SW, 1 },
	{ 15, A, .88 }, { 14, A, .88 },
	{ 8, A, .5 }, { 9, A, .5 },
	{ "_basic_lights", "running" }
}

Photon.VehicleLibrary["tdm_cvpi"] = PI