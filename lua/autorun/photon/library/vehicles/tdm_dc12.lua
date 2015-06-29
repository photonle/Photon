AddCSLuaFile()

local name = "Dodge Charger SRT8 2012 Police"

local A = "AMBER"
local DA = "D_AMBER"
local R = "RED"
local DR = "D_RED"
local B = "BLUE"
local W = "WHITE"
local SW = "S_WHITE"

local PI = {}

PI.Meta = {
	
	tail_glow_v = {
		AngleOffset = 90,
		W = 0,
		H = 0,
		Sprite = "sprites/emv/light_circle",
		Scale = 2,
		WMult = .5
	},
	
	brake_light = {
		AngleOffset = 90,
		W = 12,
		H = 10,
		Sprite = "sprites/emv/tdm_charger_brake",
		Scale = 1,
		WMult = 2
	},

	headlight = {
		AngleOffset = -90,
		W = 3.5,
		H = 3.5,
		Sprite = "sprites/emv/light_circle",
		Scale = 2.5,
		WMult = 1
	},

	marker = {
		AngleOffset = -90,
		W = 10,
		H = 8,
		Sprite = "sprites/emv/tdm_charger_f_marker",
		Scale = 1,
		WMult =1.5
	},
	
	headlight = {
		AngleOffset = -90,
		W = 3.5,
		H = 3.5,
		Sprite = "sprites/emv/light_circle",
		Scale = 2.5,
		WMult = 1
	},
	
	tail_light = {
		AngleOffset = 90,
		W = 28,
		H = 16,
		Sprite = "sprites/emv/tdm_charger_tail",
		Scale = 1,
		SourceOnly = true,
		WMult = 1.5,
	},

	tail_glow = {
		AngleOffset = 90,
		W = 0,
		H = 0,
		Sprite = "sprites/emv/light_circle",
		Scale = 3,
		WMult = 1
	},
	
	reverse = {
		AngleOffset = 90,
		W = 8,
		H = 7,
		Sprite = "sprites/emv/tdm_charger_reverse",
		Scale = 1.5,
		WMult = 1.2
	},

	out_markers = {
		AngleOffset = -90,
		W = 9,
		H = 9.8,
		Sprite = "sprites/emv/cvpi_corner_marker",
		Scale = 1.6,
	}
}

PI.Positions = {

	[1] = { Vector( 36.9, 104.91, 38.5 ), Angle( 0, 2, 0 ), "headlight" },
	[2] = { Vector( -36.9, 104.91, 38.5 ), Angle( 0, -2, 0 ), "headlight" },
	
	[3] = { Vector( 29.3, 108.91, 34.2 ), Angle( 180, -23, 180 ), "marker" },
	[4] = { Vector( -29.3, 108.91, 34.2 ), Angle( 0, 23, 0 ), "marker" },
	
	[5] = { Vector( 37.3, -116.57, 46.6 ), Angle( 0, 13.2, 0 ), "tail_light" },
	[6] = { Vector( -37.3, -116.57, 46.6 ), Angle( 180, -13.2, 0 ), "tail_light" },
	
	[7] = { Vector( 23.92, -119.92, 46.9 ), Angle( 0, 10.7, 0 ), "reverse" },
	[8] = { Vector( -23.92, -119.92, 46.9 ), Angle( 180, -10.7, 180 ), "reverse" },
	
	[9] = { Vector( 0.08, -122.52, 54.6 ), Angle( 0, 0, 32.1 ), "brake_light" },
	
	[10] = { Vector( 33.5, -118.17, 46.6 ), Angle( 0, 13.2, 0 ), "tail_glow" },
	[11] = { Vector( -33.5, -118.17, 46.6 ), Angle( 0, -13.2, 0 ), "tail_glow" },

}

PI.States = {}

PI.States.Headlights = {}
PI.States.Brakes = {
	{ 9, DR }, 
	{ 10, DR, .5 }, { 11, DR, .5 },
	{ 5, R }, { 6, R },
}
PI.States.Blink_Left = {
	{ 4, A, 2 }, { 11, DR }, { 6, R }
}
PI.States.Blink_Right = {
	{ 3, A, 2 }, { 10, DR }, { 5, R }
}
PI.States.Reverse = {
	{ 7, SW }, { 8, SW }
}
PI.States.Running = {
	{ 1, SW }, { 2, SW },
	{ 3, A }, { 4, A },
	{ 5, DR }, { 6, DR }
}

Photon.VehicleLibrary[ "tdm_dc12" ] = PI
