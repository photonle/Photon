AddCSLuaFile()

local W = "WHITE"

local name = "Whelen PAR-46 Spotlight"

local COMPONENT = {}

COMPONENT.Model = "models/schmal/whelen_spotlight.mdl"
COMPONENT.Skin = 0
COMPONENT.Bodygroups = {}
COMPONENT.NotLegacy = true
COMPONENT.ColorInput = 1
COMPONENT.UsePhases = true
COMPONENT.Category = "Exterior"
COMPONENT.DefaultColors = {
	[1] = W
}

COMPONENT.Meta = {
	auto_whelen_spotlight = {
		AngleOffset = 0,
		W = 12,
		H = 12,
		WMult = .9,
		Sprite = "sprites/emv/whelen_spotlight",
		Scale = 2,
		NoLegacy = true,
		DirAxis = "Up",
		DirOffset = 90
	}
}

COMPONENT.Positions = {

	[1] = { Vector( 8.62, -2.38, 4.19 ), Angle( 20, -128, 5 ), "auto_whelen_spotlight" },

}

COMPONENT.Sections = {
	["auto_whelen_spotlight"] = {
		[1] = { { 1, "_1" } }
	},
}

COMPONENT.Patterns = {
	["auto_whelen_spotlight"] = {
		["c1"] = { 1 }
	}
}

COMPONENT.Modes = {
	Primary = {
		M1 = { ["auto_whelen_spotlight"] = "c1" },
		M2 = {},
		M3 = {}
	},
	Auxiliary = {},
	Illumination = {
		T = {
			{ 1, W }
		}
	}
}

EMVU:AddAutoComponent( COMPONENT, name )