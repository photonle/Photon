AddCSLuaFile()

local A = "AMBER"
local R = "RED"
local DR = "D_RED"
local B = "BLUE"
local W = "WHITE"
local CW = "C_WHITE"
local SW = "S_WHITE"
local G = "GREEN"
local RB = "BLUE/RED"

local name = "Small Front Interior Trio"

local COMPONENT = {}

COMPONENT.Model = "models/tdmcars/emergency/equipment/int_5led.mdl"
COMPONENT.Skin = 0
COMPONENT.Bodygroups = {}
COMPONENT.NotLegacy = true
COMPONENT.ColorInput = 1
COMPONENT.UsePhases = true
COMPONENT.Category = "Exterior"
COMPONENT.DefaultColors = {
	[1] = "RED",
	[2] = "BLUE",
	[3] = "WHITE",
}

COMPONENT.Meta = {
	int_led = {
		AngleOffset = 0,
		W = 3.8,
		H = 3.8,
		WMult = 1.25,
		Sprite = "sprites/emv/tdm_small_interior",
		Scale = 1,
		NoLegacy = true,
		DirAxis = "Up",
		DirOffset = 90
	}
}

COMPONENT.Positions = {

	[1] = { Vector( -1.4, 0, 0.58 ), Angle( 0, 90, 0 ), "int_led" },
	[2] = { Vector( -1.4, 3.72, 0.58 ), Angle( 0, 90, 0 ), "int_led" },
	[3] = { Vector( -1.4, -3.72, 0.58 ), Angle( 0, 90, 0 ), "int_led" },
	[4] = { Vector( -1.4, 7.44, 0.58 ), Angle( 0, 90, 0 ), "int_led" },
	[5] = { Vector( -1.4, -7.44, 0.58 ), Angle( 0, 90, 0 ), "int_led" },

}

COMPONENT.Sections = {
	["auto_int5led"] = {
		[1] = { { 1, "_1" }, { 2, "_1" }, { 3, "_1" }, { 4, "_1" }, { 5, "_1" }, },
		[2] = { { 1, "_2" }, { 2, "_2" }, { 3, "_2" }, { 4, "_2" }, { 5, "_2" }, },
		[3] = { { 1, "_3" }, { 2, "_3" }, { 3, "_3" }, { 4, "_3" }, { 5, "_3" }, },
		[4] = { { 1, "_3" }, { 2, "_3" }, { 3, "_3" }, { 4, "_3" }, { 5, "_3" }, },

		[5] = { { 1, "_1" } },
		[6] = { { 1, "_1" }, { 2, "_1" }, { 3, "_1" } },
		[7] = { { 1, "_1" }, { 2, "_1" }, { 3, "_1" }, { 4, "_1" }, { 5, "_1" }, },
		[8] = { { 1, "_2" }, { 2, "_1" }, { 3, "_1" }, { 4, "_1" }, { 5, "_1" }, },
		[9] = { { 1, "_2" }, { 2, "_2" }, { 3, "_2" }, { 4, "_1" }, { 5, "_1" }, },
		[10] = { { 1, "_2" }, { 2, "_2" }, { 3, "_2" }, { 4, "_2" }, { 5, "_2" }, },
		[11] = { { 2, "_2" }, { 3, "_2" }, { 4, "_2" }, { 5, "_2" }, },
		[12] = { { 4, "_2" }, { 5, "_2" }, },

		[13] = { { 5, "_1" }, { 3, "_1" }, { 1, "_1" } },
		[14] = { { 4, "_2" }, { 2, "_2" }, { 1, "_2" } },

		[15] = { { 5, "_3" }, { 3, "_3" }, { 1, "_3" }, { 2, "_2" }, { 4, "_2" }, },
		[16] = { { 5, "_1" }, { 3, "_1" }, { 1, "_3" }, { 2, "_3" }, { 4, "_3" }, },
	},
	["auto_int5cruise"] = {
		[1] = { { 5, "_1" }, { 4, "_2" } }
	}
}

COMPONENT.Patterns = {
	["auto_int5led"] = {
		["slide"] = { 5, 6, 7, 8, 9, 10, 11, 12, 0, 0, 0, 0 },
		["code3"] = { 
			5, 6, 7, 8, 9, 10, 11, 12,
			5, 6, 7, 8, 9, 10, 11, 12,
			5, 6, 7, 8, 9, 10, 11, 12,
			1, 0, 2, 0, 3, 0, 1, 0, 2, 0, 3, 0, 1, 0, 2, 0, 3, 0,
			13, 0, 13, 0, 14, 0, 14, 0, 13, 0, 13, 0, 14, 0, 14, 0, 13, 0, 13, 0, 14, 0, 14, 0, 
			13, 13, 13, 14, 14, 14, 13, 13, 13, 14, 14, 14, 13, 13, 14, 14, 13, 13, 14, 14, 13, 13, 14, 14,
			13, 14, 13, 14, 13, 14, 13, 14, 13, 14, 13, 14, 13, 14, 13, 14,  13, 14, 
		},
		["code1"] = { 1, 0, 1, 0, 1, 1, 1, 1, 0, 0, 0, 2, 0, 2, 0, 2, 2, 2, 2, 0, 0, 0 },
		["alert"] = { 15, 16 },
	},
	["auto_int5cruise"] = {
		["cruise"] = { 1 },
		["off"] = { 0 },
	}
}

COMPONENT.TrafficDisconnect = { 
	["auto_int5cruise"] = {
		4, 5
	}
}

COMPONENT.Modes = {
	Primary = {
		M1 = { ["auto_int5led"] = "code1", },
		M2 = { ["auto_int5led"] = "slide", },
		M3 = { ["auto_int5led"] = "code3", },
		ALERT = { ["auto_int5led"] = "alert" }
	},
	Auxiliary = {
		C = { ["auto_int5cruise"] = "cruise" }	
	},
	Illumination = {
		T = {
			{ 4, W }, { 5, W }
		},
		F = {
			{ 1, W }, { 2, W }, { 3, W }, { 4, W }, { 5, W }
		}
	}
}

EMVU:AddAutoComponent( COMPONENT, name )