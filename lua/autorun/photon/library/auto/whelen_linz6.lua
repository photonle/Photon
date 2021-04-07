AddCSLuaFile()

local name = "Whelen LINZ6"

local COMPONENT = {}

COMPONENT.Model = "models/schmal/whelen_linz6.mdl"
COMPONENT.Bodygroups = {}
COMPONENT.NotLegacy = true
COMPONENT.UsePhases = true
COMPONENT.Category = "Exterior"
COMPONENT.DefaultColors = {
	[1] = "RED",
	[2] = "BLUE",
	[3] = "WHITE"
}

COMPONENT.Meta = {
	whelen_linz6_left = {
		AngleOffset = -90,
		W = 3.765,
		H = 5,
		Sprite = "sprites/emv/whelen_reflector_left",
		WMult = 1,
		Scale = 1
	},
	whelen_linz6_right = {
		AngleOffset = -90,
		W = 3.765,
		H = 5,
		Sprite = "sprites/emv/whelen_reflector_right",
		WMult = 1,
		Scale = 1
	},
}

COMPONENT.Positions = {

	[1] = { Vector( 0.85, 0.72, 0 ), Angle( 0, 0, 0 ), "whelen_linz6_left" },
	[2] = { Vector( -0.85, 0.72, 0 ), Angle( 0, 0, 0 ), "whelen_linz6_right" },

}

COMPONENT.Sections = {
	["auto_whelen_linz6"] = {
		[1] = { { 1, "_1" }, { 2, "_1" } },
		[2] = { { 1, "_2" }, { 2, "_2" } },
		[3] = { { 1, "_3" }, { 2, "_3" } },
		[4] = { { 1, "_1" } },
		[5] = { { 2, "_2" } },
	},
}

COMPONENT.Patterns = {
	["auto_whelen_linz6"] = {
		["code1"] = { 1, 1, 1, 0, 0, 0 },
		["code2"] = { 1, 1, 0, 0 },
		["code3"] = {0, 0, 0, 0, 0, 1, 0, 1, 0, 1},

		["code1A"] = {1, 1, 1, 1, 0, 0, 0, 0},
		["code2A"] = {1, 1, 0, 0},
		["code3A"] = {1, 0, 1, 0, 1, 0, 0, 0, 0, 0},

		["code1B"] = {0, 0, 0, 0, 1, 1, 1, 1},
		["code2B"] = {0, 0, 1, 1},
		["code3B"] = {0, 0, 0, 0, 0, 1, 0, 1, 0, 1},

		["code1split"] = { 4, 0, 4, 0, 4, 4, 4, 4, 0, 5, 0, 5, 0, 5, 5, 5, 5, 0 },
		["code2split"] = { 4, 0, 4, 0, 4, 4, 4, 4, 0, 5, 0, 5, 0, 5, 5, 5, 5, 0 },
		["code3split"] = { 4, 0, 4, 4, 0, 5, 0, 5, 5 },
	}
}

COMPONENT.Modes = {
	Primary = {
		M1 = { ["auto_whelen_linz6"] = "code1", },
		M2 = { ["auto_whelen_linz6"] = "code1", },
		M3 = { ["auto_whelen_linz6"] = "code3", }
	},
	Auxiliary = {},
	Illumination = {}
}

EMVU:AddAutoComponent( COMPONENT, name )
