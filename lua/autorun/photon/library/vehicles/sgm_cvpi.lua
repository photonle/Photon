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
		Sprite = "sprites/emv/crownvic_headlight",
		Scale = 2,
		WMult = 1
	},

	marker = {
		AngleOffset = -90,
		W = 14,
		H = 14,
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
		W = 11,
		H = 9,
		Sprite = "sprites/emv/taurus_reverse",
		Scale = 1.6,
	}

}

PI.Positions = {

	-- TOP --
	[1] = { Vector(-32.3,-109.5,40), Angle(0,-17,-4), "tail_light" },
	[2] = { Vector(32.3,-109.5,40), Angle(0,17,176), "tail_light" },

	-- BOTTOM --
	[3] = { Vector(-31,-110,37.6), Angle(0,-12,-4), "tail_light" },
	[4] = { Vector(31,-110,37.6), Angle(0,12,176), "tail_light" },
	
	-- BRAKE --
	[5] = { Vector(0,-70.4,51.05), Angle(0,0,0), "brake_light" },

	-- HEADLIGHTS --
	[6] = { Vector( -28, 116.7, 32 ), Angle(0,14,20), "headlight" },
	[7] = { Vector( 28, 116.7, 32 ), Angle(180,-14,160), "headlight" },

	-- MARKER --

	[8] = { Vector( -22.5, 118, 32 ), Angle( 0, 14, 20 ), "marker" },
	[9] = { Vector( 22.5, 118, 32 ), Angle( 180, -14, 160 ), "marker" },

	-- REVERSE --

	[10] = { Vector( -11.3, -112.2, 36.2 ), Angle( 180, -1, 183.1 ), "reverse" },
	[11] = { Vector( 11.3, -112.2, 36.2 ), Angle( 0, 1, -3.1 ), "reverse" },

	-- TAIL GLOWS --
	[12] = { Vector(-32.3,-109.5,40), Angle(0,20,-30), "tail_glow" },
	[13] = { Vector(32.3,-109.5,40), Angle(0,20,30), "tail_glow" },

	-- OUT MARKERS --
	[14] = { Vector( -35.4, 112.99, 32.1 ), Angle( 10.68 - 180, 41, 180 - 28.4 ), "out_markers" },
	[15] = { Vector( 35.4, 112.99, 32.1 ), Angle( -10.68, -41, 28.4 ), "out_markers" },

}

PI.States = {}

PI.States.Headlights = {}
PI.States.Brakes = {
	{ 1, DR, 1 }, { 2, DR, 1 }, { 3, DR, 1 }, { 4, DR, 1 }, { 5, DR }
}
PI.States.Blink_Left = {
	{ 1, R }, { 3, R }, { 12, R }, { 14, A },
}
PI.States.Blink_Right = {
	{ 2, R }, { 4, R }, { 13, R }, { 15, A }
}
PI.States.Reverse = {
	{ 10, SW }, { 11, SW }
}
PI.States.Running = {
	{ 1, DR, .25 }, { 2, DR, .25 }, { 3, DR, .25 }, { 4, DR, .25 },  { 12, DR, .25 }, { 13, DR, .25 }, 
	{ 6, SW, 1 }, { 7, SW, 1 },
	{ 8, A, 1 }, { 9, A, 1 },
}

Photon.VehicleLibrary["sgm_cvpi"] = PI
-- Photon:OverwriteIndex("Crown Victoria PI Whelen Liberty", PI)