AddCSLuaFile()

local name = "Feniex Apollo Interior"

local COMPONENT = {}

COMPONENT.Model = "models/tdmcars/emergency/equipment/feniex_apollo.mdl"
COMPONENT.Required = "489864412"
COMPONENT.Skin = 0
COMPONENT.Bodygroups = {}
COMPONENT.NotLegacy = true
COMPONENT.ColorInput = 1
COMPONENT.Category = "Interior"
COMPONENT.DefaultColors = {
	[1] = "RED",
	[2] = "BLUE",
	[3] = "AMBER"
}

COMPONENT.Meta = {
	feniex_apollo_int = {
		W = 3.5,
		H = 3.5,
		Sprite = "sprites/emv/feniex_apollo_3",
		Scale = .5,
		WMult = 1,
		NoLegacy = true,
		DirAxis = "Up",
		DirOffset = -90,
		EmitArray = {
			Vector( 1.09, 0, 0 ),
			Vector( 0, 0, 0 ),
			Vector( -1.09, 0, 0 )
		}
	},
}

COMPONENT.Positions = {

	[1] = { Vector( 5.08, -1.87, 0.39 ), Angle( 0, 90, 0 ), "feniex_apollo_int" },
	[2] = { Vector( 5.08, 1.87, 0.39 ), Angle( 0, 90, 0 ), "feniex_apollo_int" },

	[3] = { Vector( 4.85, -5.62, 0.39 ), Angle( 0, 90, 0 ), "feniex_apollo_int" },
	[4] = { Vector( 4.85, 5.62, 0.39 ), Angle( 0, 90, 0 ), "feniex_apollo_int" },

	[5] = { Vector( 4.27, -9.32, 0.39 ), Angle( 0, 90, 0 ), "feniex_apollo_int" },
	[6] = { Vector( 4.27, 9.32, 0.39 ), Angle( 0, 90, 0 ), "feniex_apollo_int" },

	[7] = { Vector( 3.46, -12.97, 0.39 ), Angle( 0, 90, 0 ), "feniex_apollo_int" },
	[8] = { Vector( 3.46, 12.97, 0.39 ), Angle( 0, 90, 0 ), "feniex_apollo_int" },

	[9] = { Vector( 2.36, -16.44, 0.39 ), Angle( 0, 90, 0 ), "feniex_apollo_int" },
	[10] = { Vector( 2.36, 16.44, 0.39 ), Angle( 0, 90, 0 ), "feniex_apollo_int" },

}

COMPONENT.Sections = {
	["auto_feniex_apollo_int"] = {
		[1] = {
			{ 1, "_1" }, { 2, "_2" }, { 3, "_1" }, { 4, "_2" }, { 5, "_1" }, { 6, "_2" },
			{ 7, "_1" }, { 8, "_2" }, { 9, "_1" }, { 10, "_2" },
		}
	}
}

COMPONENT.Patterns = {
	["auto_feniex_apollo_int"] = {
		["all"] = { 1 }
	}
}

COMPONENT.Modes = {
	Primary = {
		M1 = { ["auto_feniex_apollo_int"] = "all", },
		M2 = { ["auto_feniex_apollo_int"] = "code2", },
		M3 = { ["auto_feniex_apollo_int"] = "code3", },
	},
	Auxiliary = {
		L = { ["auto_feniex_apollo_int"] = "left" },
		R = { ["auto_feniex_apollo_int"] = "right" },
		D = { ["auto_feniex_apollo_int"] = "diverge" },
	},
	Illumination = {}
}

EMVU:AddAutoComponent( COMPONENT, name )