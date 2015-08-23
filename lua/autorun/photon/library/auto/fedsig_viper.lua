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

local name = "Federal Signal Viper"

local COMPONENT = {}

COMPONENT.Model = "models/tdmcars/emergency/equipment/fedsig_viper.mdl"
COMPONENT.Required = "489864412"
COMPONENT.Skin = 0
COMPONENT.Bodygroups = {}
COMPONENT.NotLegacy = true
COMPONENT.ForwardTranslation = true
COMPONENT.UsePhases = true
COMPONENT.DefaultColors = {
	[1] = "WHITE",
	[2] = "WHITE",
}

COMPONENT.Meta = {
	auto_viper = {
		AngleOffset = 0,
		W = 4.5,
		H = 4,
		WMult = 2,
		Sprite = "sprites/emv/tdm_viper",
		Scale = 1.5,
		NoLegacy = true,
		DirAxis = "Up",
		DirOffset = -90
	},
}

COMPONENT.Positions = {

	[1] = { Vector( 0.63, 0, 0.78 ), Angle( 0, 90, 0 ), "auto_viper" },

}

COMPONENT.Sections = {
	["auto_fedsig_viper"] = {
		[1] = { { 1, "_1" } },
		[2] = { { 1, "_2" } },
	},
}

COMPONENT.Patterns = {
	["auto_fedsig_viper"] = {
		["code1"] = { 1, 1, 1, 0, },
		["code1A"] = { 1, 1, 1, 0, 0, 0, 0, 0, },
		["code1B"] = { 0, 0, 0, 0, 1, 1, 1, 0 },
		["code2"] = { 1, 0, 1, 1, 1, 0, 0, 0 },
		["code2A"] = { 1, 0, 1, 1, 1, 0, 2, 2, 2, 0 },
		["code2B"] = { 0, 2, 2, 2, 0, 1, 0, 1, 1, 1 },
		["code3"] = { 1, 0 },
		["code3A"] = { 1, 1, 1, 0, 1, 0, 2, 0, 2, 0, 2, 0 },
		["code3B"] = { 2, 0, 2, 0, 2, 0, 1, 1, 1, 0, 1, 0 },
		["all"] = { 1 },
		["alert"] = { 1, 0 },
		["alertA"] = { 1, 0 },
		["alertB"] = { 0, 1 },
	}
}

COMPONENT.Modes = {
	Primary = {
		M1 = { ["auto_fedsig_viper"] = "code1", },
		M2 = { ["auto_fedsig_viper"] = "code2", },
		M3 = { ["auto_fedsig_viper"] = "code3", },
		ALERT = { ["auto_fedsig_viper"] = "alert" }
	},
	Auxiliary = {},
	Illumination = {}
}

EMVU:AddAutoComponent( COMPONENT, name )