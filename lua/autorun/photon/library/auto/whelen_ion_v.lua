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

local name = "Whelen Ion V"

local COMPONENT = {}

COMPONENT.Model = "models/schmal/whelen_v_series.mdl"
COMPONENT.Bodygroups = {}
COMPONENT.NotLegacy = true
COMPONENT.UsePhases = true
COMPONENT.Category = "Exterior"
COMPONENT.DefaultColors = {
	[1] = "WHITE",
}

COMPONENT.Meta = {
	ion_v_ang = {
		AngleOffset = -90,
		W = .75,
		H = 1.2,
		Sprite = "sprites/emv/emv_whelen_src",
		WMult = 1.5,
		Scale = .66,
		NoLegacy = true,
		DirAxis = "Up",
		DirOffset = 90
	},
	ion_v_cir = {
		AngleOffset = -90,
		W = .7,
		H = .7,
		Sprite = "sprites/emv/circular_src",
		WMult = .6,
		Scale = .5,
		NoLegacy = true,
		DirAxis = "Up",
		DirOffset = 90
	},
}

COMPONENT.Positions = {

	[1] = { Vector( -0.61, 0.37, -0.01 ), Angle( 0, 19, 0 ), "ion_v_ang" },
	[2] = { Vector( 0.61, 0.37, -0.01 ), Angle( 0, -19, 0 ), "ion_v_ang" },
	[3] = { Vector( 0, 0.47, -0.02 ), Angle( 0, 0, 0 ), "ion_v_cir" },
	[4] = { Vector( -1.35, 0, 0.02 ), Angle( 0, 0, 0 ), "ion_v_cir" },
	[5] = { Vector( 1.35, 0, 0.02 ), Angle( 0, 0, 0 ), "ion_v_cir" },

}

COMPONENT.Sections = {
	["auto_ion_v"] = {
		[1] = { { 1, "_1", .88 }, { 2, "_1", .88 },  }
	},
}

COMPONENT.Patterns = {
	["auto_ion_v"] = {
		["code1"] = { 1, 1, 1, 0, },
		["code1A"] = { 1, 1, 1, 0, 0, 0, 0, 0, },
		["code1B"] = { 0, 0, 0, 0, 1, 1, 1, 0 },
		["code2"] = { 1, 0, 1, 1, 1, 0, 0, 0 },
		["code2A"] = { 1, 0, 1, 1, 1, 0, 0, 0, 0, 0 },
		["code2B"] = { 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, },
		["code3"] = { 1, 0 },
		["code3A"] = { 1, 0, 1, 0, 0, 0 },
		["code3B"] = { 0, 0, 0, 1, 0, 1 },
		["alert"] = { 1, 0 },
		["alertA"] = { 0, 1 },
		["alertB"] = { 1, 0 },
		["alertCA"] = { 1 },
		["all"] = { 1 },
		["allA"] = { 1 },
		["allB"] = { 1 },
	},
}

COMPONENT.Modes = {
	Primary = {
		M1 = { ["auto_ion_v"] = "code1", },
		M2 = { ["auto_ion_v"] = "code2", },
		M3 = { ["auto_ion_v"] = "code3", },
		ALERT = { ["auto_ion_v"] = "alert", },
	},
	Auxiliary = {},
	Illumination = {
		T = { 
			{ 3, W }, { 4, W }, { 5, W }, 
		},
		F = { 
			{ 3, W }, { 4, W }, { 5, W }, 
		}
	}
}

EMVU:AddAutoComponent( COMPONENT, name )
