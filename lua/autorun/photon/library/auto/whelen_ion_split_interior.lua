AddCSLuaFile()

local name = "Whelen Ion Interior Split"

local COMPONENT = {}

COMPONENT.Model = "models/schmal/whelen_ion_interior.mdl"
COMPONENT.Skin = 0
COMPONENT.Bodygroups = {}
COMPONENT.NotLegacy = true
COMPONENT.ColorInput = 1
COMPONENT.UsePhases = true
COMPONENT.Category = "Exterior"
COMPONENT.DefaultColors = {
	[1] = "RED",
	[2] = "BLUE"
}

COMPONENT.Meta = {
	auto_ion_left = {
		AngleOffset = 0,
		W = 6.9,
		H = 6.9,
		WMult = 1,
		Sprite = "sprites/emv/whelen_ion_left",
		Scale = 1,
		NoLegacy = true,
		DirAxis = "Up",
		DirOffset = 90
	},
	auto_ion_right = {
		AngleOffset = 0,
		W = 6.9,
		H = 6.9,
		WMult = 1,
		Sprite = "sprites/emv/whelen_ion_right",
		Scale = 1,
		NoLegacy = true,
		DirAxis = "Up",
		DirOffset = 90
	},
}

COMPONENT.Positions = {

	[1] = { Vector( 1.46, 0.5, 0 ), Angle( 0, 0, 0 ), "auto_ion_left" },
	[2] = { Vector( -1.46, 0.5, 0 ), Angle( 0, 0, 0 ), "auto_ion_right" },

}

COMPONENT.Sections = {
	["auto_ion"] = {
		[1] = { { 1, "_1" }, { 2, "_2" } },
		[2] = { { 1, "_1" } },
		[3] = { { 2, "_2" } }
	},
}

COMPONENT.Patterns = {
	["auto_ion"] = {
		["code1"] = { 2, 0, 2, 0, 2, 2, 2, 0, 3, 0, 3, 0, 3, 3, 3, 0 },
	}
}

COMPONENT.Modes = {
	Primary = {
		M1 = { ["auto_ion"] = "code1", },
		M2 = { ["auto_ion"] = "code2", },
		M3 = { ["auto_ion"] = "code3", }
	},
	Auxiliary = {},
	Illumination = {}
}

EMVU:AddAutoComponent( COMPONENT, name )