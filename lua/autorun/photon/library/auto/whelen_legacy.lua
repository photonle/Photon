AddCSLuaFile()

local A = "AMBER"
local R = "RED"
local DR = "D_RED"
local B = "BLUE"
local W = "WHITE"
local CW = "C_WHITE"
local SW = "S_WHITE"
local G = "GREEN"

local name = "Whelen Legacy"

local COMPONENT = {}

COMPONENT.Model = "models/schmal/whelen_legacy/legacy_lightbar.mdl"
COMPONENT.Skin = 0
COMPONENT.Bodygroups = {}

COMPONENT.Meta = {
	legacy_forward = {
		AngleOffset = -90,
		W = 3.35,
		H = 3.2,
		Sprite = "sprites/emv/legacy_direct",
		Scale = 1,
		WMult = 1.25,
	},
	legacy_illum = {
		AngleOffset = -90,
		W = 3.35,
		H = 3.2,
		Sprite = "sprites/emv/legacy_illum",
		Scale = 1.25,
		WMult = 1.25,
	},
	legacy_rear = {
		AngleOffset = 90,
		W = 3.35,
		H = 3.2,
		Sprite = "sprites/emv/legacy_direct",
		Scale = .85,
		WMult = 1.25,
	},
}

COMPONENT.Positions = {

	[1] = { Vector( -5.16, 6.18, 0.48 ), Angle( 0, 0, 0 ), "legacy_forward" },
	[2] = { Vector( 5.16, 6.18, 0.48 ), Angle( 0, 0, 0 ), "legacy_forward" },

	[3] = { Vector( -8.25, 6.18, 0.48 ), Angle( 0, 0, 0 ), "legacy_forward" },
	[4] = { Vector( 8.25, 6.18, 0.48 ), Angle( 0, 0, 0 ), "legacy_forward" },

	[5] = { Vector( -11.47, 6.18, 0.48 ), Angle( 0, 0, 0 ), "legacy_forward" },
	[6] = { Vector( 11.47, 6.18, 0.48 ), Angle( 0, 0, 0 ), "legacy_forward" },

	[7] = { Vector( -14.56, 6.18, 0.48 ), Angle( 0, 0, 0 ), "legacy_forward" },
	[8] = { Vector( 14.56, 6.18, 0.48 ), Angle( 0, 0, 0 ), "legacy_forward" },

	[9] = { Vector( -17.75, 6.18, 0.48 ), Angle( 0, 0, 0 ), "legacy_forward" },
	[10] = { Vector( 17.75, 6.18, 0.48 ), Angle( 0, 0, 0 ), "legacy_forward" },

	[11] = { Vector( -20.83, 6.18, 0.48 ), Angle( 0, 0, 0 ), "legacy_forward" },
	[12] = { Vector( 20.83, 6.18, 0.48 ), Angle( 0, 0, 0 ), "legacy_forward" },

	[13] = { Vector( -24, 6.18, 0.48 ), Angle( 0, 0, 0 ), "legacy_forward" },
	[14] = { Vector( 24, 6.18, 0.48 ), Angle( 0, 0, 0 ), "legacy_forward" },

	[15] = { Vector( -26.67, 5.09, 0.48 ), Angle( 0, 45, 0 ), "legacy_forward" },
	[16] = { Vector( 26.67, 5.09, 0.48 ), Angle( 0, -45, 0 ), "legacy_forward" },

	[17] = { Vector( -28.8, 2.88, 0.48 ), Angle( 0, 45, 0 ), "legacy_forward" },
	[18] = { Vector( 28.8, 2.88, 0.48 ), Angle( 0, -45, 0 ), "legacy_forward" },

	[19] = { Vector( -28.86, -2.79, 0.48 ), Angle( 0, -45, 0 ), "legacy_rear" },
	[20] = { Vector( 28.86, -2.79, 0.48 ), Angle( 0, 45, 0 ), "legacy_rear" },

	[21] = { Vector( -26.69, -4.97, 0.48 ), Angle( 0, -45, 0 ), "legacy_rear" },
	[22] = { Vector( 26.69, -4.97, 0.48 ), Angle( 0, 45, 0 ), "legacy_rear" },

	[23] = { Vector( -24.05, -6.08, 0.48 ), Angle( 0, 0, 0 ), "legacy_rear" },
	[24] = { Vector( 24.05, -6.08, 0.48 ), Angle( 0, 0, 0 ), "legacy_rear" },

	[25] = { Vector( -20.87, -6.08, 0.48 ), Angle( 0, 0, 0 ), "legacy_rear" },
	[26] = { Vector( 20.87, -6.08, 0.48 ), Angle( 0, 0, 0 ), "legacy_rear" },

	[27] = { Vector( -17.7, -6.08, 0.48 ), Angle( 0, 0, 0 ), "legacy_rear" },
	[28] = { Vector( 17.7, -6.08, 0.48 ), Angle( 0, 0, 0 ), "legacy_rear" },

	[29] = { Vector( -14.62, -6.08, 0.48 ), Angle( 0, 0, 0 ), "legacy_rear" },
	[30] = { Vector( 14.62, -6.08, 0.48 ), Angle( 0, 0, 0 ), "legacy_rear" },

	[31] = { Vector( -11.42, -6.08, 0.48 ), Angle( 0, 0, 0 ), "legacy_rear" },
	[32] = { Vector( 11.42, -6.08, 0.48 ), Angle( 0, 0, 0 ), "legacy_rear" },

	[33] = { Vector( -8.33, -6.08, 0.48 ), Angle( 0, 0, 0 ), "legacy_rear" },
	[34] = { Vector( 8.33, -6.08, 0.48 ), Angle( 0, 0, 0 ), "legacy_rear" },

	[35] = { Vector( -5.11, -6.08, 0.48 ), Angle( 0, 0, 0 ), "legacy_rear" },
	[36] = { Vector( 5.11, -6.08, 0.48 ), Angle( 0, 0, 0 ), "legacy_rear" },

	[37] = { Vector( -2.04, -6.08, 0.48 ), Angle( 0, 0, 0 ), "legacy_rear" },
	[38] = { Vector( 2.04, -6.08, 0.48 ), Angle( 0, 0, 0 ), "legacy_rear" },

	[39] = { Vector( -2.01, 6.18, 0.48 ), Angle( 0, 0, 0 ), "legacy_illum" },
	[40] = { Vector( 2.01, 6.18, 0.48 ), Angle( 0, 0, 0 ), "legacy_illum" },

	[41] = { Vector( -30.01, 0.05, 0.5 ), Angle( 0, 90, 0 ), "legacy_illum" },
	[42] = { Vector( 30.01, 0.05, 0.5 ), Angle( 0, -90, 0 ), "legacy_illum" },

}

COMPONENT.Sections = {
	["auto_whelen_legacy"] = {
		{
			{ 1, R },{ 2, B },
			{ 3, R },{ 4, B },
			{ 5, R },{ 6, B },
			{ 7, R },{ 8, B },
			{ 9, R },{ 10, B },
			{ 11, R },{ 12, B },
			{ 13, R },{ 14, B },
			{ 15, R },{ 16, B },
			{ 17, R },{ 18, B },
			{ 19, R },{ 20, B },
			{ 21, R },{ 22, B },
			{ 23, R },{ 24, B },
			{ 25, R },{ 26, B },
			{ 27, R },{ 28, B },
			{ 29, R },{ 30, B },
			{ 31, R },{ 32, B },
			{ 33, R },{ 34, B },
			{ 35, R },{ 36, B },
			{ 37, R },{ 38, B },
			{ 39, W },{ 40, W },
			{ 41, W },{ 42, W },
		}
	}
}

COMPONENT.Patterns = {
	["auto_whelen_legacy"] = {
		["all"] = { 1, 0, 1, 0, 1, 0 }
	}
}

EMVU:AddAutoComponent( COMPONENT, name )