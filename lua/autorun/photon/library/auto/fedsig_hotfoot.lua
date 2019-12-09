AddCSLuaFile()

local W = "WHITE"

local name = "Federal Signal Hotfoot"

local COMPONENT = {}

COMPONENT.Model = "models/schmal/whelen_ion.mdl"
COMPONENT.Skin = 0
COMPONENT.Bodygroups = {}
COMPONENT.NotLegacy = true
COMPONENT.ColorInput = 1
COMPONENT.UsePhases = true
COMPONENT.Category = "Exterior"
COMPONENT.DefaultColors = {
	[1] = "WHITE"
}

COMPONENT.Meta = {
	auto_ion_left = {
		AngleOffset = 0,
		W = 6.9,
		H = 6.9,
		WMult = 1.5,
		Sprite = "sprites/emv/whelen_ion_left",
		Scale = .66,
		NoLegacy = true,
		DirAxis = "Up",
		DirOffset = 90
	},
	auto_ion_right = {
		AngleOffset = 0,
		W = 6.9,
		H = 6.9,
		WMult = 1.5,
		Sprite = "sprites/emv/whelen_ion_right",
		Scale = .66,
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
		[1] = { { 1, "_1", .88 }, { 2, "_1", .88 },  }
	},
}

COMPONENT.Patterns = {
	["auto_ion"] = {
		["code1"] = { 1, 1, 1, 0, },
		["code1A"] = { 1, 1, 1, 0, 0, 0, 0, 0, },
		["code1B"] = { 0, 0, 0, 0, 1, 1, 1, 0 },
		["code1CHPA"] = { 1 },
		["code1CHPB"] = { 1 },
		["code1NYPDA"] = { 1, 1, 1, 1, 0, 0, 0, 0 },
		["code2NYPDA"] = { 1, 1, 1, 1, 0, 0, 0, 0 },
		["code3NYPDA"] = { 1, 1, 1, 1, 0, 0, 0, 0 },
		["code1NYPDB"] = { 0, 0, 0, 0, 1, 1, 1, 1 },
		["code2NYPDB"] = { 0, 0, 0, 0, 1, 1, 1, 1 },
		["code3NYPDB"] = { 0, 0, 0, 0, 1, 1, 1, 1 },
		["code2"] = { 1, 0, 1, 1, 1, 0, 0, 0 },
		["code2A"] = { 1, 0, 1, 1, 1, 0, 0, 0, 0, 0 },
		["code2B"] = { 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, },
		["code1CA"] = { 1 },
		["code2CA"] = { 1 },
		["code3CA"] = { 1 },
		["code2CHPA"] = { 1, 1, 1, 1, 1, 0, 0, 0, 0, 0 },
		["code3CHPA"] = { 1, 1, 1, 1, 1, 0, 0, 0, 0, 0 },
		["code2CHPB"] = { 0, 0, 0, 0, 0, 1, 1, 1, 1, 1 },
		["code3CHPB"] = { 0, 0, 0, 0, 0, 1, 1, 1, 1, 1 },
		["code3"] = { 1, 0 },
		["code3A"] = { 1, 0, 1, 0, 0, 0 },
		["code3B"] = { 0, 0, 0, 1, 0, 1 },
		["alert"] = { 1, 0 },
		["alertA"] = { 0, 1 },
		["alertB"] = { 1, 0 },
		["all"] = { 1 },
		["allA"] = { 1 },
		["allB"] = { 1 },
	}
}

COMPONENT.Modes = {
	Primary = {
		M1 = { ["auto_ion"] = "code1", },
		M2 = { ["auto_ion"] = "code2", },
		M3 = { ["auto_ion"] = "code3", }
	},
	Auxiliary = {},
	Illumination = {
		T = {
			{ 1, W }, { 2, W }
		},
		F = {
			{ 1, W }, { 2, W }
		}
	}
}

EMVU:AddAutoComponent( COMPONENT, name )