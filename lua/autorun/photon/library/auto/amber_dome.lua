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

local name = "Dome Light Amber"

local COMPONENT = {}

COMPONENT.Model = "models/schmal/dome_light.mdl"
COMPONENT.Skin = 0
COMPONENT.Bodygroups = {}
COMPONENT.NotLegacy = true
COMPONENT.ForwardTranslation = true
COMPONENT.UsePhases = true

COMPONENT.Meta = {
	auto_dome = {
		NoLegacy = true,
		AngleOffset = "R",
		DirAxis = "Up",
		DirOffset = -90,
		Speed = 10,
		W = 6,
		H = 8,
		Sprite = "sprites/emv/visionslr",
		Scale = 2.75,
		WMult = 1,
	},
}

COMPONENT.Positions = {

	[1] = { Vector( 0, 0, 2.5 ), Angle( 0, -90, 0 ), "auto_dome" },

}

COMPONENT.Sections = {
	["auto_light_dome"] = {
		[1] = { { 1, A } },
	},
}

COMPONENT.Patterns = {
	["auto_light_dome"] = {
		["mode1"] = { 1 },
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