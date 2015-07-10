AddCSLuaFile()

local A = "AMBER"
local R = "RED"
local DR = "D_RED"
local B = "BLUE"
local W = "WHITE"
local CW = "C_WHITE"
local SW = "S_WHITE"
local G = "GREEN"

local name = "Whelen Justice"

local COMPONENT = {}

COMPONENT.Model = "models/schmal/whelen_justice/justice_lightbar.mdl"
COMPONENT.Skin = 0
COMPONENT.Bodygroups = {}

COMPONENT.Meta = {
	justice_forward = {
		AngleOffset = -90,
		W = 4.2,
		H = 4.2,
		Sprite = "sprites/emv/justice_1x3",
		Scale = 1.25,
		WMult = 1.5,
	},
	justice_rear = {
		AngleOffset = 90,
		W = 4.2,
		H = 4.2,
		Sprite = "sprites/emv/justice_1x3",
		Scale = 1.5,
		WMult = 1.5,
	},
	justice_illum = {
		AngleOffset = -90,
		W = 3,
		H = 3,
		Sprite = "sprites/emv/emv_whelen_tri",
		Scale = 2,
		WMult = 1,
	},
	justice_corner_forward = {
		AngleOffset = -90,
		W = 10,
		H = 10,
		Sprite = "sprites/emv/emv_whelen_corner",
		Scale = 1.25,
		WMult = 2,
	},
	justice_corner_rear = {
		AngleOffset = 90,
		W = 10,
		H = 10,
		Sprite = "sprites/emv/emv_whelen_corner",
		Scale = 1.5,
		WMult = 2,
	},
}

COMPONENT.Positions = {

	[1] = { Vector( 0, 5.68, -0.69 ), Angle( 0, 0, 0 ), "justice_forward" },

	[2] = { Vector( -6.48, 5.68, -0.69 ), Angle( 0, 0, 0 ), "justice_forward" },
	[3] = { Vector( 6.48, 5.68, -0.69 ), Angle( 0, 0, 0 ), "justice_forward" },

	[4] = { Vector( -11.66, 5.68, -0.69 ), Angle( 0, 0, 0 ), "justice_forward" },
	[5] = { Vector( 11.66, 5.68, -0.69 ), Angle( 0, 0, 0 ), "justice_forward" },

	[6] = { Vector( -16.77, 5.68, -0.69 ), Angle( 0, 0, 0 ), "justice_forward" },
	[7] = { Vector( 16.77, 5.68, -0.69 ), Angle( 0, 0, 0 ), "justice_forward" },

	[8] = { Vector( -24.74, 3.17, -0.57 ), Angle( 0, 36, 0 ), "justice_corner_forward" },
	[9] = { Vector( 24.74, 3.17, -0.57 ), Angle( 0, -36, 0 ), "justice_corner_forward" },

	[10] = { Vector( -24.74, -3.91, -0.49 ), Angle( 0, -36, 0 ), "justice_corner_rear" },
	[11] = { Vector( 24.74, -3.91, -0.49 ), Angle( 0, 36, 0 ), "justice_corner_rear" },

	[12] = { Vector( -18.82, -6.38, -0.56 ), Angle( 0, 0, 0 ), "justice_rear" },
	[13] = { Vector( 18.82, -6.38, -0.56 ), Angle( 0, 0, 0 ), "justice_rear" },

	[14] = { Vector( -12.61, -6.38, -0.56 ), Angle( 0, 0, 0 ), "justice_rear" },
	[15] = { Vector( 12.61, -6.38, -0.56 ), Angle( 0, 0, 0 ), "justice_rear" },

	[16] = { Vector( -6.47, -6.38, -0.56 ), Angle( 0, 0, 0 ), "justice_rear" },
	[17] = { Vector( 6.47, -6.38, -0.56 ), Angle( 0, 0, 0 ), "justice_rear" },

	[18] = { Vector( 0, -6.38, -0.56 ), Angle( 0, 0, 0 ), "justice_rear" },

	[19] = { Vector( -20.72, 5.58, -0.64 ), Angle( 0, 0, 0 ), "justice_illum" },
	[20] = { Vector( 20.72, 5.58, -0.64 ), Angle( 0, 0, 0 ), "justice_illum" },

	[21] = { Vector( -27.72, -0.34, -0.59 ), Angle( 0, 90, 0 ), "justice_illum" },
	[22] = { Vector( 27.72, -0.34, -0.59 ), Angle( 0, -90, 0 ), "justice_illum" },

}

COMPONENT.Sections = {
	["auto_whelen_justice"] = {
		{
			{ 1, W }, { 2, R },
			{ 3, B }, { 4, R },
			{ 5, B }, { 6, R },
			{ 7, B }, { 8, R },
			{ 9, B }, { 10, R },
			{ 11, B }, { 12, A },
			{ 13, A }, { 14, A },
			{ 15, A }, { 16, A },
			{ 17, A }, { 18, A },
			{ 19, W }, { 20, W },
			{ 21, W }, { 22, W },
		}
	}
}

COMPONENT.Patterns = {
	["auto_whelen_justice"] = {
		["all"] = { 1, 0, 1, 0, 1, 0 }
	}
}

EMVU:AddAutoComponent( COMPONENT, name )