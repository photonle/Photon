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

local name = "Federal Signal Viper Dual"

local COMPONENT = {}

COMPONENT.Model = "models/tdmcars/emergency/equipment/fedsig_viper_dual.mdl"
COMPONENT.Required = "489864412"
COMPONENT.Skin = 0
COMPONENT.Category = "Interior"
COMPONENT.Bodygroups = {}
COMPONENT.NotLegacy = true
COMPONENT.ForwardTranslation = true
COMPONENT.DefaultColors = {
	[1] = "RED",
	[2] = "BLUE",
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
		DirOffset = -90,
	},
}

COMPONENT.Positions = {

	[1] = { Vector( 0.63, 2.1, 0.78 ), Angle( 0, 90, 0 ), "auto_viper" },
	[2] = { Vector( 0.63, -2.1, 0.78 ), Angle( 0, 90, 0 ), "auto_viper" },

}

COMPONENT.Sections = {
	["auto_fedsig_viper_dual"] = {
		[1] = { { 1, "_1" }, { 2, "_2" } },
		[2] = { { 1, "_1" } },
		[3] = { { 2, "_2" } },
	},
}

COMPONENT.Patterns = {
	["auto_fedsig_viper_dual"] = {
		["code1"] = { 2, 0, 2, 2, 2, 0, 0, 0, 3, 0, 3, 3, 3, 0, 0, 0, 1, 0, 1, 1, 1, 0, 0, 0 },
		["code1A"] = { 2, 0, 2, 2, 2, 0, 0, 0, 3, 0, 3, 3, 3, 0, 0, 0, 1, 0, 1, 1, 1, 0, 0, 0 },
		["code1B"] = { 3, 0, 3, 3, 3, 0, 0, 0, 2, 0, 2, 2, 2, 0, 0, 0, 1, 0, 1, 1, 1, 0, 0, 0 },
		["code1C"] = { 2, 2, 2, 2, 3, 3, 3, 3 },
		["code1D"] = { 3, 3, 3, 3, 2, 2, 2, 2 },
		["code1NYA"] = { 2, 2, 2, 2, 3, 3, 3, 3 },
		["code2NYA"] = { 2, 2, 2, 2, 3, 3, 3, 3 },
		["code3NYA"] = { 2, 2, 2, 2, 3, 3, 3, 3 },
		["code1NYB"] = { 3, 3, 3, 3, 2, 2, 2, 2 },
		["code2NYB"] = { 3, 3, 3, 3, 2, 2, 2, 2 },
		["code3NYB"] = { 3, 3, 3, 3, 2, 2, 2, 2 },
		["code2"] = { 2, 2, 0, 3, 3, 0 },
		["code2A"] = { 2, 2, 0, 3, 3, 0 },
		["code2B"] = { 3, 3, 0, 2, 2, 0 },
		["code2C"] = { 3, 3, 0, 3, 3, 0, 2, 2, 0, 2, 2, 0, 3, 3, 0, 2, 2, 0 },
		["code3A"] = { 3, 0, 3, 0, 2, 0, 2, 0 },
		["code3C"] = { 3, 0, 3, 0, 2, 0, 2, 0 },
		["code3B"] = { 0, 2, 0, 2, 0, 3, 0, 3 },
		["code3D"] = { 0, 2, 0, 2, 0, 3, 0, 3 },
		["code3"] = { 
			2, 0, 2, 0, 3, 0, 3, 0,
			2, 0, 2, 0, 3, 0, 3, 0,
			2, 0, 2, 0, 3, 0, 3, 0,
			2, 0, 2, 0, 3, 0, 3, 0,
			2, 3, 2, 3, 2, 3, 2, 3,
			2, 3, 2, 3, 2, 3, 2, 3,
		},
		["alert"] = { 2, 3 },
		["alertA"] = { 2, 3 },
		["alertB"] = { 3, 2 },
		["alertC"] = { 2, 3 },
		["alertD"] = { 2, 3 },
		["alertNYA"] = { 2, 3 },
		["alertNYB"] = { 3, 2 },
	}
}

COMPONENT.Modes = {
	Primary = {
		M1 = { ["auto_fedsig_viper_dual"] = "code1", },
		M2 = { ["auto_fedsig_viper_dual"] = "code2", },
		M3 = { ["auto_fedsig_viper_dual"] = "code3", },
		ALERT = { ["auto_fedsig_viper_dual"] = "alert", },
	},
	Auxiliary = {},
	Illumination = {}
}

EMVU:AddAutoComponent( COMPONENT, name )