AddCSLuaFile()

local name = "Whelen Vertex"

local COMPONENT = {}

COMPONENT.Model = "models/tdmcars/emergency/equipment/small_led.mdl"
COMPONENT.Required = "489864412"
COMPONENT.Skin = 0
COMPONENT.Bodygroups = {}
COMPONENT.Category = "Exterior"
COMPONENT.NotLegacy = true
COMPONENT.DefaultColors = {
	[1] = "WHITE"
}

COMPONENT.Meta = {
	auto_vertex = {
		AngleOffset = 0,
		W = 1.25,
		H = 1.25,
		Sprite = "sprites/emv/emv_whelen_vertex",
		Scale = 1,
		NoLegacy = true,
		DirAxis = "Up",
		DirOffset = -90
	},
}

COMPONENT.Positions = {

	[1] = { Vector( 0, 0, 0.32 ), Angle( 0, 0, -90 ), "auto_vertex" },

}

COMPONENT.Sections = {
	["auto_whelen_vertex"] = {
		[1] = { { 1, "_1" } }
	},
}

COMPONENT.Patterns = {
	["auto_whelen_vertex"] = {
		["code1"] = { 1, 0, 1, 1, 1, 0, 0, 0 },
		["code1A"] = { 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
		["code1B"] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, },
		["code2"] = { 1, 0, 1, 1, 1, 0, },
		["code2A"] = { 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
		["code2B"] = { 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 0, 0, },
		["code3"] = { 1, 0 },
		["code3A"] = { 1, 0, 1, 0, 1, 0, 0, 0, 0, 0 },
		["code3B"] = { 0, 0, 0, 0, 0, 1, 0, 1, 0, 1 },
		["all"] = { 1 },
	}
}

COMPONENT.Modes = {
	Primary = {
			M1 = {
				["auto_whelen_vertex"] = "code1",
			},
			M2 = {
				["auto_whelen_vertex"] = "code2",
			},
			M3 = {
				["auto_whelen_vertex"] = "code3",
			}
		},
	Auxiliary = {},
	Illumination = {

	}
}

EMVU:AddAutoComponent( COMPONENT, name )