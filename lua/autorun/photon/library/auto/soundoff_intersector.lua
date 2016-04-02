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

local name = "SoundOff Intersector"

local COMPONENT = {}

COMPONENT.Model = "models/schmal/soundoff_intersector.mdl"
COMPONENT.Bodygroups = {}
COMPONENT.NotLegacy = true
COMPONENT.UsePhases = true
COMPONENT.Category = "Exterior"
COMPONENT.DefaultColors = {
	[1] = "RED",
	[2] = "BLUE",
	[3] = "WHITE",
}

COMPONENT.Meta = {
	soundoff_cir = {
		AngleOffset = -90,
		W = .7,
		H = .7,
		Sprite = "sprites/emv/circular_src",
		WMult = 1.25,
		Scale = .5,
		NoLegacy = true,
		DirAxis = "Up",
		DirOffset = 90
	},
}

COMPONENT.Positions = {

	[1] = { Vector( 0, 0.87, 0.67 ), Angle( 0, 0, 0 ), "soundoff_cir" },
	[2] = { Vector( 0.3, 0.82, 0.67 ), Angle( 0, -22.5, 0), "soundoff_cir" },
	[3] = { Vector( -0.3, 0.82, 0.67 ), Angle( 0, 22.5, 0), "soundoff_cir" },
	[4] = { Vector( 0.58, 0.62, 0.67 ), Angle( 0, -45, 0 ), "soundoff_cir" },
	[5] = { Vector( -0.58, 0.62, 0.67 ), Angle( 0, 45, 0 ), "soundoff_cir" },

}

COMPONENT.Sections = {
	["auto_intersector"] = {
		[1] = { { 1, "_1" }, { 2, "_1" }, { 3, "_1" }, { 4, "_1" }, { 5, "_1" },  },
		[2] = { { 1, "_2" }, { 2, "_2" }, { 3, "_2" }, { 4, "_2" }, { 5, "_2" },  },
		[3] = { { 1, "_3" }, { 2, "_3" }, { 3, "_3" }, { 4, "_3" }, { 5, "_3" },  },
	},
}

COMPONENT.Patterns = {
	["auto_intersector"] = {
		["mode1"] = { 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 2, 0, 2, 0, 2, 2, 2, 2, 2 },
		["mode1A"] = { 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 2, 0, 2, 2, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		["mode1B"] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 2, 0, 2, 2, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1 },
		["mode3"] = { 1, 0, 2, 0, 1, 0, 2, 0, 3, 0, 3, 0, 3, 0 },
		["mode3A"] = { 1, 0, 2, 0, 1, 0, 2, 0, 3, 0, 3, 0, 3, 0 },
		["mode3B"] = { 0, 1, 0, 2, 0, 1, 0, 2, 0, 3, 0, 3, 0, 3 },
	}
}

COMPONENT.Modes = {
	Primary = {
		M1 = { ["auto_intersector"] = "mode1", },
		M2 = { ["auto_intersector"] = "mode1", },
		M3 = { ["auto_intersector"] = "mode3", }
	},
	Auxiliary = {},
	Illumination = {}
}

EMVU:AddAutoComponent( COMPONENT, name )
