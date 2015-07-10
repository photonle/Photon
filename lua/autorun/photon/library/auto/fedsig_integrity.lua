AddCSLuaFile()

local A = "AMBER"
local R = "RED"
local DR = "D_RED"
local B = "BLUE"
local W = "WHITE"
local CW = "C_WHITE"
local SW = "S_WHITE"
local G = "GREEN"

local name = "Federal Signal Integrity"

local COMPONENT = {}

COMPONENT.Model = "models/schmal/fedsig_integrity/integrity_lightbar.mdl"
COMPONENT.Skin = 0
COMPONENT.Bodygroups = {}

COMPONENT.Meta = {
	integrity_forward = {
		AngleOffset = -90,
		W = 6.1,
		H = 4.4,
		Sprite = "sprites/emv/fs_valor",
		Scale = 1.25,
		WMult = 1.5,
	},
	integrity_forward_outer = {
		AngleOffset = -90,
		W = 5.8,
		H = 4.4,
		Sprite = "sprites/emv/fs_valor",
		Scale = 1.25,
		WMult = 1.5,
	},
	integrity_forward_corner = {
		AngleOffset = -90,
		W = 6,
		H = 4.4,
		Sprite = "sprites/emv/fs_valor",
		Scale = 1.25,
		WMult = 1.75,
	},
	integrity_side = {
		AngleOffset = -90,
		W = 6.8,
		H = 4.4,
		Sprite = "sprites/emv/fs_valor",
		Scale = 1.25,
		WMult = 1.5,
	},
	integrity_rear = {
		AngleOffset = 90,
		W = 5.5,
		H = 4.4,
		Sprite = "sprites/emv/fs_valor",
		Scale = 1.25,
		WMult = 1.5,
	},
	integrity_rear_inner = {
		AngleOffset = 90,
		W = 6.35,
		H = 4.4,
		Sprite = "sprites/emv/fs_valor",
		Scale = 1.25,
		WMult = 1.5,
	}

}

COMPONENT.Positions = {

	[1] = { Vector( 3.1, 7.97, 0.87 ), Angle( 0, 0, 0 ), "integrity_forward" },
	[2] = { Vector( -3.1, 7.97, 0.87 ), Angle( 0, 0, 0 ), "integrity_forward" },

	[3] = { Vector( 9.11, 7.97, 0.87 ), Angle( 0, 0, 0 ), "integrity_forward" },
	[4] = { Vector( -9.11, 7.97, 0.87 ), Angle( 0, 0, 0 ), "integrity_forward" },

	[5] = { Vector( 15.07, 7.97, 0.87 ), Angle( 0, 0, 0 ), "integrity_forward" },
	[6] = { Vector( -15.07, 7.97, 0.87 ), Angle( 0, 0, 0 ), "integrity_forward" },

	[7] = { Vector( 20.87, 7.97, 0.87 ), Angle( 0, 0, 0 ), "integrity_forward_outer" },
	[8] = { Vector( -20.87, 7.97, 0.87 ), Angle( 0, 0, 0 ), "integrity_forward_outer" },

	[9] = { Vector( 25.87, 5.97, 0.87 ), Angle( 0, -44, 0 ), "integrity_forward_corner" },
	[10] = { Vector( -25.87, 5.97, 0.87 ), Angle( 0, 44, 0 ), "integrity_forward_corner" },

	[11] = { Vector( 28.55, 0.6, 0.87 ), Angle( 0, -79.8, 0 ), "integrity_side" },
	[12] = { Vector( -28.55, 0.6, 0.87 ), Angle( 0, 79.8, 0 ), "integrity_side" },

	[13] = { Vector( 25.61, -4.93, 0.87 ), Angle( 0, 0, 0 ), "integrity_rear" },
	[14] = { Vector( -25.61, -4.93, 0.87 ), Angle( 0, 0, 0 ), "integrity_rear" },

	[15] = { Vector( 20.13, -4.93, 0.87 ), Angle( 0, 0, 0 ), "integrity_rear" },
	[16] = { Vector( -20.13, -4.93, 0.87 ), Angle( 0, 0, 0 ), "integrity_rear" },

	[17] = { Vector( 14.64, -4.93, 0.87 ), Angle( 0, 0, 0 ), "integrity_rear" },
	[18] = { Vector( -14.64, -4.93, 0.87 ), Angle( 0, 0, 0 ), "integrity_rear" },

	[19] = { Vector( 9.17, -4.93, 0.87 ), Angle( 0, 0, 0 ), "integrity_rear" },
	[20] = { Vector( -9.17, -4.93, 0.87 ), Angle( 0, 0, 0 ), "integrity_rear" },

	[21] = { Vector( 3.24, -4.93, 0.87 ), Angle( 0, 0, 0 ), "integrity_rear_inner" },
	[22] = { Vector( -3.24, -4.93, 0.87 ), Angle( 0, 0, 0 ), "integrity_rear_inner" },

}

COMPONENT.Sections = {
	["auto_fedsig_integrity"] = {
		{
			{ 1, B }, { 2, R },
			{ 3, B }, { 4, R },
			{ 5, B }, { 6, R },
			{ 7, B }, { 8, R },
			{ 9, B }, { 10, R },
			{ 11, B }, { 12, R },
			{ 13, B }, { 14, R },
			{ 15, B }, { 16, R },
			{ 17, B }, { 18, R },
			{ 19, B }, { 20, R },
			{ 21, B }, { 22, R },
		}
	}
}

COMPONENT.Patterns = {
	["auto_fedsig_integrity"] = {
		["all"] = { 1, 0, 1, 0, 1, 0 }
	}
}

EMVU:AddAutoComponent( COMPONENT, name )