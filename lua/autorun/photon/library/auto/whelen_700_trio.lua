AddCSLuaFile()

local name = "Whelen 700 Trio"

local COMPONENT = {}

COMPONENT.Model = "models/tdmcars/emergency/equipment/whelen_700s.mdl"
COMPONENT.Required = "489864412"
COMPONENT.Skin = 0
COMPONENT.Bodygroups = {}
COMPONENT.NotLegacy = true
COMPONENT.ColorInput = 3
COMPONENT.UsePhases = false
COMPONENT.Category = "Exterior"
COMPONENT.DefaultColors = {
	[1] = "RED",
	[2] = "WHITE",
	[3] = "BLUE",
}

COMPONENT.Meta = {
	auto_700 = {
		AngleOffset = 0,
		W = 5,
		H = 5,
		WMult = 2,
		Sprite = "sprites/emv/tdm_grille_leds",
		Scale = 1.25,
		NoLegacy = true,
		DirAxis = "Up",
		DirOffset = -90
	},
}

COMPONENT.Positions = {

	[1] = { Vector( 0, -0.08, 0.48 ), Angle( 0, 0, -90 ), "auto_700" },

}

COMPONENT.Sections = {
	["auto_whelen_700_tri"] = {
		[1] = { { 1, "_1" } },
		[2] = { { 1, "_2" } },
		[3] = { { 1, "_3" } },
	},
}

COMPONENT.Patterns = {
	["auto_whelen_700_tri"] = {
		["code1"] = { 1, 1, 1, 0, 2, 2, 2, 0, 3, 3, 3, 0 },
		["code2"] = { 1, 0, 1, 1, 1, 0, 2, 0, 2, 2, 2, 0, 3, 0, 3, 3, 3, 0 },
		["code3"] = { 1, 0, 1,  0, 0, 0, 2, 0, 2, 0, 0, 0, 3, 0, 3, 0, 0, 0 },
		["code1A"] = { 1, 1, 1, 2, 2, 2 },
		["code1B"] = { 2, 2, 2, 1, 1, 1 },
		["code2A"] = { 1, 0, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 2, 0, 2, 0, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0 },
		["code2B"] = { 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 2, 0, 2, 0, 2, 2, 2 },
		["code3A"] = { 1, 1, 0, 2, 2, 0, 1, 1, 0, 2, 2, 0, 1, 1, 0, 2, 2, 0, 1, 1, 0, 2, 2, 0, 1, 1, 0, 2, 2, 0, 3, 0, 3, 0, 0, 0, 0, 0, 3, 0, 3, 0, 0, 0, 0, 0, 3, 0, 3, 0, 0, 0, 0, 0, 3, 0, 3, 0, 0, 0, 0, 0, },
		["code3B"] = { 2, 2, 0, 1, 1, 0, 2, 2, 0, 1, 1, 0, 2, 2, 0, 1, 1, 0, 2, 2, 0, 1, 1, 0, 2, 2, 0, 1, 1, 0, 0, 0, 0, 0, 3, 0, 3, 0, 0, 0, 0, 0, 3, 0, 3, 0, 0, 0, 0, 0, 3, 0, 3, 0, 0, 0, 0, 0, 3, 0, 3, 0, },
		["alert"] = { 1, 0, 2, 0, 3, 0 },
		["alertA"] = { 1, 0, 2, 0, 3, 0 },
		["alertB"] = { 0, 1, 0, 2, 0, 3 },
		["all"] = { 1 },
	}
}

COMPONENT.Modes = {
	Primary = {
		M1 = { ["auto_whelen_700_tri"] = "code1", },
		M2 = { ["auto_whelen_700_tri"] = "code2", },
		M3 = { ["auto_whelen_700_tri"] = "code3", }
	},
	Auxiliary = {},
	Illumination = {}
}

EMVU:AddAutoComponent( COMPONENT, name )