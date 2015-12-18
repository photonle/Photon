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

local name = "Small Front Interior Trio"

local COMPONENT = {}

COMPONENT.Model = "models/tdmcars/emergency/equipment/int_5led.mdl"
COMPONENT.Skin = 0
COMPONENT.Bodygroups = {}
COMPONENT.NotLegacy = true
COMPONENT.ColorInput = 1
COMPONENT.UsePhases = true
COMPONENT.Category = "Exterior"
COMPONENT.DefaultColors = {
	[1] = "RED",
	[2] = "BLUE",
	[3] = "WHITE",
}

COMPONENT.Meta = {
	int_led = {
		AngleOffset = 0,
		W = 3.8,
		H = 3.8,
		WMult = 1.25,
		Sprite = "sprites/emv/tdm_small_interior",
		Scale = 1,
		NoLegacy = true,
		DirAxis = "Up",
		DirOffset = 90
	}
}

COMPONENT.Positions = {

	[1] = { Vector( -1.4, 0, 0.58 ), Angle( 0, 90, 0 ), "int_led" },
	[2] = { Vector( -1.4, 3.72, 0.58 ), Angle( 0, 90, 0 ), "int_led" },
	[3] = { Vector( -1.4, -3.72, 0.58 ), Angle( 0, 90, 0 ), "int_led" },
	[4] = { Vector( -1.4, 7.44, 0.58 ), Angle( 0, 90, 0 ), "int_led" },
	[5] = { Vector( -1.4, -7.44, 0.58 ), Angle( 0, 90, 0 ), "int_led" },

}

COMPONENT.Sections = {
	["auto_int5led"] = {
		[1] = { { 1, "_1" }, { 2, "_1" }, { 3, "_1" }, { 4, "_1" }, { 5, "_1" }, }
	},
}

COMPONENT.Patterns = {
	["auto_int5led"] = {
		["code1"] = { 1 },
		["code1A"] = { 1, 1, 1, 0, 0, 0, 0, 0, },
		["code1B"] = { 0, 0, 0, 0, 1, 1, 1, 0 },
		["code1CHPA"] = { 1 },
		["code1CHPB"] = { 1 },
		["code2"] = { 1, 0, 1, 1, 1, 0, 0, 0 },
		["code2A"] = { 1, 0, 1, 1, 1, 0, 0, 0, 0, 0 },
		["code2B"] = { 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, },
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
		M1 = { ["auto_int5led"] = "code1", },
		M2 = { ["auto_int5led"] = "code2", },
		M3 = { ["auto_int5led"] = "code3", }
	},
	Auxiliary = {},
	Illumination = {}
}

EMVU:AddAutoComponent( COMPONENT, name )