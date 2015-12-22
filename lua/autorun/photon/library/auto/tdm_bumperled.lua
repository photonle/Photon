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

local name = "TDM Pushbar LED"

local COMPONENT = {}

COMPONENT.Model = "models/tdmcars/emergency/equipment/pushbar_6led.mdl"
COMPONENT.Required = "489864412"
COMPONENT.Skin = 0
COMPONENT.Bodygroups = {}
COMPONENT.NotLegacy = true
COMPONENT.Category = "Exterior"
COMPONENT.DefaultColors = {
	[1] = "RED",
	[2] = "BLUE"
}

COMPONENT.Meta = {
	tdm_grille_leds = {
		W = 3.8,
		H = 3.8,
		Sprite = "sprites/emv/emv_whelen_mini_3",
		Scale = 1,
		WMult = 1.5,
		NoLegacy = true,
		DirAxis = "Up",
		DirOffset = -90
	},
}

COMPONENT.Positions = {

	[1] = { Vector( -0.8, -2.53, 23.51 ), Angle( 0, -90, 0 ), "tdm_grille_leds" },
	[2] = { Vector( -0.8, 2.53, 23.51 ), Angle( 0, -90, 0 ), "tdm_grille_leds" },

	[3] = { Vector( -0.8, -7.58, 23.51 ), Angle( 0, -90, 0 ), "tdm_grille_leds" },
	[4] = { Vector( -0.8, 7.58, 23.51 ), Angle( 0, -90, 0 ), "tdm_grille_leds" },

	[5] = { Vector( -0.8, -12.61, 23.51 ), Angle( 0, -90, 0 ), "tdm_grille_leds" },
	[6] = { Vector( -0.8, 12.61, 23.51 ), Angle( 0, -90, 0 ), "tdm_grille_leds" },

}

COMPONENT.Sections = {
	["auto_tdm_pushbar"] = {
		[1] = { { 1, "_1" }, { 2, "_2" }, { 3, "_2" }, { 4, "_1" }, { 5, "_1" }, { 6, "_2" } },
		[2] = { { 1, "_1" }, { 4, "_1" }, { 5, "_1" } },
		[3] = { { 2, "_2" }, { 3, "_2" }, { 6, "_2" } },
	},
	["auto_tdm_pushbar_inner"] = {
		[1] = { { 1, "_1" }, },
		[2] = { { 2, "_2" }, },
	},
	["auto_tdm_pushbar_mid"] = {
		[1] = { { 3, "_2" }, },
		[2] = { { 4, "_1" }, },
		[3] = { { 4, "_1" }, { 3, "_2" }, },
	},
	["auto_tdm_pushbar_outter"] = {
		[1] = { { 5, "_1" }, },
		[2] = { { 6, "_2" }, },
	},
}

COMPONENT.Patterns = {
	["auto_tdm_pushbar"] = {
		["code1"] = { 
			2, 0, 2, 2, 2, 0, 0, 0, 3, 0, 3, 3, 3, 0, 0, 0,
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
		},
		["alert"] = {
			2, 3
		}
	},
	["auto_tdm_pushbar_inner"] = {
		["code2"] = { 1, 1, 0, 2, 2, 0 },
		["code3"] = { 1, 0, 2, 0 },
	},
	["auto_tdm_pushbar_mid"] = {
		["code2"] = { 1, 1, 1, 0, 2, 2, 2, 0 },
		["code3"] = { 0, 3, 0, 3, 0, 0, 1, 2, 1, 2, 1, 2, 0, 0 },
	},
	["auto_tdm_pushbar_outter"] = {
		["code2"] = { 1, 0, 1, 1, 1, 0, 2, 0, 2, 2, 2, 0 },
		["code3"] = { 1, 2, 0, 2, 1, 0, 2, 2, 1, 1, 0, 1, 1, 2, 2, 0, 1, 2, 1, 2 },
	},
}

COMPONENT.Modes = {
	Primary = {
		M1 = { ["auto_tdm_pushbar"] = "code1", },
		M2 = { 
			["auto_tdm_pushbar_inner"] = "code2",
			["auto_tdm_pushbar_mid"] = "code2",
			["auto_tdm_pushbar_outter"] = "code2",
		},
		M3 = { 
			["auto_tdm_pushbar_inner"] = "code3",
			["auto_tdm_pushbar_mid"] = "code3",
			["auto_tdm_pushbar_outter"] = "code3",
		},
		ALERT = {
			["auto_tdm_pushbar"] = "alert"
		}
	},
	Auxiliary = {},
	Illumination = {}
}

EMVU:AddAutoComponent( COMPONENT, name )