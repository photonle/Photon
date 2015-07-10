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

local name = "Whelen Liberty SX"

local COMPONENT = {}

COMPONENT.Model = "models/schmal/whelen_liberty/liberty_lightbar.mdl"
COMPONENT.Skin = 0
COMPONENT.Bodygroups = {}

COMPONENT.Meta = {
	liberty_f_main = {
		AngleOffset = -90,
		W = 8.2,
		H = 7.5,
		Sprite = "sprites/emv/emv_whelen_src",
		WMult = 2,
		Scale = 1.4
	},
	liberty_takedown = {
		AngleOffset = -90,
		W = 4.2,
		H = 4.2,
		Sprite = "sprites/emv/emv_whelen_tri",
		WMult = 1,
		Scale = 1.2
	},
	liberty_alley = {
		AngleOffset = -90,
		W = 4.2,
		H = 4.2,
		Sprite = "sprites/emv/emv_whelen_tri",
		WMult = 1,
		Scale = 1.2
	},
	liberty_f_ang = {
		AngleOffset = -90,
		W = 16,
		H = 15,
		Sprite = "sprites/emv/emv_whelen_corner",
		WMult = 3,
		Scale = 1.6,
		VisRadius = 0
	},
	liberty_r_ang = {
		AngleOffset = 90,
		W = 16,
		H = 15,
		Sprite = "sprites/emv/emv_whelen_corner",
		WMult = 3,
		Scale = 1.6
	},
	liberty_r_main = {
		AngleOffset = 90,
		W = 8.2,
		H = 7.5,
		Sprite = "sprites/emv/emv_whelen_src",
		WMult = 2,
		Scale = 1.4
	},
}

COMPONENT.Positions = {

	[1] = { Vector( -3.74, 7.51, 1.47 ), Angle( 0, 0, 0 ), "liberty_f_main" },
	[2] = { Vector( 3.74, 7.51, 1.47 ), Angle( 0, 0, 0 ), "liberty_f_main" },

	[3] = { Vector( -10.61, 7.51, 1.47 ), Angle( 0, 0, 0 ), "liberty_f_main" },
	[4] = { Vector( 10.61, 7.51, 1.47 ), Angle( 0, 0, 0 ), "liberty_f_main" },

	[5] = { Vector( -27.26, 4.88, 1.48 ), Angle( 0, 32.6, 0 ), "liberty_f_ang" },
	[6] = { Vector( 27.16, 4.88, 1.48 ), Angle( 0, -32.6, 0 ), "liberty_f_ang" },

	[7] = { Vector( -27.16, -5.4, 1.48 ), Angle( 0, -32.6, 0 ), "liberty_r_ang" },
	[8] = { Vector( 27.16, -5.4, 1.48 ), Angle( 0, 32.6, 0 ), "liberty_r_ang" },

	[9] = { Vector( -17.41, -8.01, 1.47 ), Angle( 0, 0, 0 ), "liberty_r_main" },
	[10] = { Vector( 17.41, -8.01, 1.47 ), Angle( 0, 0, 0 ), "liberty_r_main" },

	[11] = { Vector( -10.61, -8.01, 1.47 ), Angle( 0, 0, 0 ), "liberty_r_main" },
	[12] = { Vector( 10.61, -8.01, 1.47 ), Angle( 0, 0, 0 ), "liberty_r_main" },

	[13] = { Vector( -3.74, -8.01, 1.47 ), Angle( 0, 0, 0 ), "liberty_r_main" },
	[14] = { Vector( 3.74, -8.01, 1.47 ), Angle( 0, 0, 0 ), "liberty_r_main" },

	[15] = { Vector( -17.6, 7.98, 1.41 ), Angle( 0, 0, 0 ), "liberty_takedown" },
	[16] = { Vector( 17.6, 7.98, 1.41 ), Angle( 0, 0, 0 ), "liberty_takedown" },

	[17] = { Vector( -32.38, -0.23, 1.41 ), Angle( 0, 90, 0 ), "liberty_alley" },
	[18] = { Vector( 32.38, -0.23, 1.41 ), Angle( 0, -90, 0 ), "liberty_alley" },


}

COMPONENT.Sections = {
	["auto_whelen_liberty_sx"] = {
		{
			{ 1, R }, { 2, B },
			{ 3, R }, { 4, B },
			{ 5, R }, { 6, B },
			{ 7, R }, { 8, B },
			{ 9, R }, { 10, B },
			{ 11, R }, { 12, B },
			{ 13, R }, { 14, B },
			{ 15, W }, { 16, W },
			{ 17, W }, { 18, W },
		}
	}
}

COMPONENT.Patterns = {
	["auto_whelen_liberty_sx"] = {
		["all"] = { 1 },
	}
}

EMVU:AddAutoComponent( COMPONENT, name )