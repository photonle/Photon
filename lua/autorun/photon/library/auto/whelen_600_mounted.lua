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

local name = "Whelen 600 Mounted"

local COMPONENT = {}

COMPONENT.Deprecated = "This component is replaced with the 'Whelen 400 Mounted' for ELS and the 'Whelen 400 Mounted Illumination'"

COMPONENT.Model = "models/schmal/whelen_400_6x6.mdl"
COMPONENT.Bodygroups = {}
COMPONENT.NotLegacy = true
COMPONENT.UsePhases = true
COMPONENT.Category = "Exterior"

COMPONENT.Meta = {
	whelen_600 = {
		AngleOffset = -90,
		W = 7.25,
		H = 6.9,
		Sprite = "sprites/emv/freedom_main",
		WMult = 1,
		Scale = 1,
		EmitArray = {
			Vector( 1.75, 0, 0 ),
			Vector( 0, 0, 0 ),
			Vector( -1.75, 0, 0 )
		}
	},
}

COMPONENT.Positions = {

	[1] = { Vector( 0, 1.09, 1.1 ), Angle( 0, 0, 0 ), "whelen_600" },
	[2] = { Vector( 0, 1.09, -0.83 ), Angle( 0, 0, 0 ), "whelen_600" },

}

COMPONENT.Sections = {
	["auto_light_dome"] = {
		[1] = { { 1, W }, { 2, W } },
	},
}

COMPONENT.Patterns = {
	["auto_light_dome"] = {
		["mode1"] = { 1 },
		["mode1A"] = { 1 },
		["mode1B"] = { 2 },
	}
}

COMPONENT.Modes = {
	Primary = {
		M1 = { ["auto_light_dome"] = "mode1", },
		M2 = { ["auto_light_dome"] = "mode1", },
		M3 = { ["auto_light_dome"] = "mode1", }
	},
	Auxiliary = {},
	Illumination = {}
}

EMVU:AddAutoComponent( COMPONENT, name )