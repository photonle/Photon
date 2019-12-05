AddCSLuaFile()

local R = "RED"
local B = "BLUE"
local W = "WHITE"

local name = "NYPD Whelen Slimlighter"

local COMPONENT = {}

COMPONENT.Model = "models/tdmcars/emergency/equipment/whelen_slimlighter.mdl"
COMPONENT.Required = "489864412"
COMPONENT.Skin = 0
COMPONENT.Bodygroups = {}
COMPONENT.NotLegacy = true
COMPONENT.ColorInput = 1
COMPONENT.Category = "Interior"
COMPONENT.DefaultColors = {
	[1] = R,
	[2] = B,
}

COMPONENT.Meta = {
	auto_int_lb = {
		W = 10,
		H = 4,
		Sprite = "sprites/emv/whelen_slimlighter",
		Scale = 1,
		WMult = 1.6,
		NoLegacy = true,
		DirAxis = "Up",
		DirOffset = -90
	},
}

COMPONENT.Positions = {

	[1] = { Vector( 1.3, -9, 2.4 ), Angle( 0, 90, 0 ), "auto_int_lb" },
	[2] = { Vector( 1.3, 7, 2.4 ), Angle( 0, 90, 0 ), "auto_int_lb" },

}

COMPONENT.Sections = {
	["whelen_sl"] = {
		[1] = { { 1, "_1" }, },
		[2] = { { 2, "_2" }, },
	},
}
COMPONENT.Patterns = {
	["whelen_sl"] = {
		["stage1"] = { 1, 1, 1, 1, 2, 2, 2, 2 },
		["stage1NYA"] = { 1, 1, 1, 1, 2, 2, 2, 2, },
		["stage1NYB"] = { 2, 2, 2, 2, 1, 1, 1, 1, }
	},
}

COMPONENT.Modes = {
	Primary = {
		M1 = { ["whelen_sl"] = "stage1", },
		M2 = { ["whelen_sl"] = "stage1", },
		M3 = { ["whelen_sl"] = "stage1", },
	},
	Auxiliary = {},
	Illumination = {
		T = {
			{ 1, W }, { 2, W }
		}
	}
}

EMVU:AddAutoComponent( COMPONENT, name )