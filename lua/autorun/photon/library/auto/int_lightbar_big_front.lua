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

local name = "TDM Front Interior Lightbar"

local COMPONENT = {}

COMPONENT.Model = "models/tdmcars/emergency/equipment/int_lightbar_big.mdl"
COMPONENT.Required = "489864412"
COMPONENT.Skin = 0
COMPONENT.Bodygroups = {}
COMPONENT.NotLegacy = true
COMPONENT.ColorInput = 1
COMPONENT.DefaultColors = {
	[1] = "RED",
	[2] = "BLUE",
	[3] = "WHITE"
}

COMPONENT.Meta = {
	auto_int_lb = {
		W = 4.1,
		H = 3.1,
		Sprite = "sprites/emv/tdm_charger_rear_int",
		Scale = 1,
		WMult = 1.5,
		NoLegacy = true,
		DirAxis = "Up",
		DirOffset = -90
	},
}

COMPONENT.Positions = {

	[1] = { Vector( -1.8, -6.8, 0.82 ), Angle( 0, 90, 0 ), "auto_int_lb" },
	[2] = { Vector( -1.8, 6.8, 0.82 ), Angle( 0, 90, 0 ), "auto_int_lb" },

	[3] = { Vector( -1.8, -10.8, 0.82 ), Angle( 0, 90, 0 ), "auto_int_lb" },
	[4] = { Vector( -1.8, 10.8, 0.82 ), Angle( 0, 90, 0 ), "auto_int_lb" },

	[5] = { Vector( -1.8, -14.8, 0.82 ), Angle( 0, 90, 0 ), "auto_int_lb" },
	[6] = { Vector( -1.8, 14.8, 0.82 ), Angle( 0, 90, 0 ), "auto_int_lb" },

	[7] = { Vector( -1.8, -18.8, 0.82 ), Angle( 0, 90, 0 ), "auto_int_lb" },
	[8] = { Vector( -1.8, 18.8, 0.82 ), Angle( 0, 90, 0 ), "auto_int_lb" },

	[9] = { Vector( -1.8, -22.8, 0.82 ), Angle( 0, 90, 0 ), "auto_int_lb" },
	[10] = { Vector( -1.8, 22.8, 0.82 ), Angle( 0, 90, 0 ), "auto_int_lb" },

}

COMPONENT.Sections = {
	["auto_tdm_int_lightbar"] = {
		[1] = { { 1, "_1" }, { 2, "_2" }, { 3, "_1" }, { 4, "_2" }, { 5, "_1" }, { 6, "_2" }, { 7, "_1" }, { 8, "_2" }, { 9, "_1" }, { 10, "_2" } },
		[2] = {
			{ 1, "_1" }, { 3, "_1" }, { 8, "_2" }, { 10, "_2" }
		},
		[3] = {
			{ 9, "_1" }, { 7, "_1" }, { 2, "_2" }, { 4, "_2" }
		},
		[4] = {
			{ 1, "_1" }, { 3, "_1" }, { 5, "_1" }, { 7, "_1" }, { 9, "_1" },
			{ 2, "_3" }, { 4, "_3" }, { 6, "_3" }, { 8, "_3" }, { 10, "_3" }
		},
		[5] = {
			{ 1, "_3" }, { 3, "_3" }, { 5, "_3" }, { 7, "_3" }, { 9, "_3" },
			{ 2, "_2" }, { 4, "_2" }, { 6, "_2" }, { 8, "_2" }, { 10, "_2" }
		},
		[6] = {
			{ 3, "_1" }, { 5, "_1" }, { 6, "_2" }, { 8, "_2" }
		},
		[7] = {
			{ 5, "_1" }, { 7, "_1" }, { 6, "_2" }, { 4, "_2" }
		},
		[8] = {
			{ 1, "_1" }, { 4, "_3" }, { 5, "_1" }, { 8, "_3" }, { 9, "_1" },
		},
		[9] = {
			{ 2, "_2" }, { 3, "_3" }, { 6, "_2" }, { 7, "_3" }, { 10, "_2" }
		},
		[10] = {
			{ 1, "_3" }, { 4, "_2" }, { 5, "_3" }, { 8, "_2" }, { 9, "_3" },
		},
		[11] = {
			{ 2, "_3" }, { 3, "_1" }, { 6, "_3" }, { 7, "_1" }, { 10, "_3" }
		},
	},
}

COMPONENT.Patterns = {
	["auto_tdm_int_lightbar"] = {
		["code1"] = { 
			0, 2, 0, 2, 2, 2, 0, 0, 3, 0, 3, 3, 3, 0,
		},
		["code2"] = {
			2, 6, 7, 3, 0, 3, 7, 6, 2, 0,
			2, 6, 7, 3, 0, 3, 7, 6, 2, 0,
			2, 6, 7, 3, 0, 3, 7, 6, 2, 0,
			8, 0, 8, 8, 0, 9, 0, 9, 9, 0,
			10, 0, 10, 10, 0, 11, 0, 11, 11, 0,
			8, 0, 8, 8, 0, 9, 0, 9, 9, 0,
			10, 0, 10, 10, 0, 11, 0, 11, 11, 0,
			8, 0, 8, 8, 0, 9, 0, 9, 9, 0,
			10, 0, 10, 10, 0, 11, 0, 11, 11, 0,
		},
		["code3"] = {
			1, 0, 1, 0, 1,
			2, 0, 2, 0, 3, 0, 3, 0,
			2, 0, 2, 0, 3, 0, 3, 0,
			2, 0, 2, 0, 3, 0, 3, 0,
			4, 0, 4, 0, 5, 0, 5, 0,
			8, 0, 9, 0, 10, 0, 11, 0,
			8, 0, 9, 0, 10, 0, 11, 0,
			8, 0, 9, 0, 10, 0, 11, 0,
		}
	}
}

COMPONENT.Modes = {
	Primary = {
		M1 = { ["auto_tdm_int_lightbar"] = "code1", },
		M2 = { ["auto_tdm_int_lightbar"] = "code2", },
		M3 = { ["auto_tdm_int_lightbar"] = "code3", },
	},
	Auxiliary = {},
	Illumination = {}
}

EMVU:AddAutoComponent( COMPONENT, name )