AddCSLuaFile()

local A = "AMBER"
local R = "RED"
local DR = "D_RED"
local B = "BLUE"
local W = "WHITE"
local CW = "C_WHITE"
local SW = "S_WHITE"
local G = "GREEN"

local name = "Federal Signal Integrity Single"

local COMPONENT = {}

COMPONENT.Model = "models/schmal/fedsig_integrity/integrity_lightbar.mdl"
COMPONENT.Skin = 0
COMPONENT.Bodygroups = {}
COMPONENT.Category = "Lightbar"

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
	["auto_fedsig_integrity_amb"] = {
		{
			{ 1, A }, { 2, A },
			{ 3, A }, { 4, A },
			{ 5, A }, { 6, A },
			{ 7, A }, { 8, A },
			{ 9, A }, { 10, A },
			{ 11, A }, { 12, A },
			{ 13, A }, { 14, A },
			{ 15, A }, { 16, A },
			{ 17, A }, { 18, A },
			{ 19, A }, { 20, A },
			{ 21, A }, { 22, A },
		},
		{
			{ 1, A }, { 3, A }, { 5, A }, { 7, A }, { 9, A },
			{ 11, A }, { 13, A }, { 15, A }, { 17, A }, { 19, A }, { 21, A }
		},
		{
			{ 2, A }, { 4, A }, { 6, A }, { 8, A }, { 10, A }, { 12, A },
			{ 14, A }, { 16, A }, { 18, A }, { 20, A }, { 22, A }
		},
		{
			{ 8, A }, { 10, A }, { 12, A }, { 14, A }
		},
		{ 
			{ 7, A }, { 9, A }, { 11, A }, { 13, A }
		},
		{
			{ 2, A }, { 4, A }, { 6, A },
			{ 22, A }, { 16, A }, { 18, A }, { 20, A }
		},
		{
			{ 1, A }, { 3, A }, { 5, A },
			{ 21, A }, { 19, A }, { 17, A }, { 15, A }
		},
		[8] = {
			{ 6, A }, { 2, A }, { 16, A }, { 22, A }
		},
		[9] = {
			{ 1, A }, { 5, A }, { 21, A }, { 15, A }
		},
		[10] = {
			{ 4, A }, { 18, A }, { 20, A },
		},
		[11] = {
			{ 3, A }, { 17, A }, { 19, A }
		},
		[12] = {
			{ 6, A }, { 4, A }, { 3, A }, { 5, A },
			{ 16, A }, { 18, A }, { 15, A }, { 17, A }
		},
		[13] = {
			{ 2, W }, { 1, W },
			{ 20, A }, { 22, A },
			{ 21, A }, { 19, A }
		}
	},
	["auto_fedsig_integrity_amb_corner"] = {
		{
			{ 8, A }, { 10, A }, { 12, A }, { 14, A }
		},
		{
			{ 7, A }, { 9, A }, { 11, A }, { 13, A }
		},
		{
			{ 7, A }, { 9, A }, { 11, A }, { 13, A },
			{ 8, A }, { 10, A }, { 12, A }, { 14, A }
		}
	},
	["auto_fedsig_integrity_amb_signalmaster"] = {
		-- right
		[1] = { { 16, A }, },
		[2] = { { 16, A }, { 18, A }, },
		[3] = { { 16, A }, { 18, A }, { 20, A } },
		[4] = { { 16, A }, { 18, A }, { 20, A }, { 22, A }, },
		[5] = { { 16, A }, { 18, A }, { 20, A }, { 22, A }, { 21, A }, },
		[6] = { { 16, A }, { 18, A }, { 20, A }, { 22, A }, { 21, A }, { 19, A }, },
		-- all
		[7] = { { 16, A }, { 18, A }, { 20, A }, { 22, A }, { 21, A }, { 19, A }, { 17, A }, { 15, A }, },
		-- left
		[8] = { { 15, A }, },
		[9] = { { 17, A }, { 15, A }, },
		[10] = { { 19, A }, { 17, A }, { 15, A }, },
		[11] = { { 21, A }, { 19, A }, { 17, A }, { 15, A }, },
		[12] = { { 22, A }, { 21, A }, { 19, A }, { 17, A }, { 15, A }, },
		[13] = { { 18, A }, { 20, A }, { 22, A }, { 21, A }, { 19, A }, { 17, A }, { 15, A }, },
		-- center out
		[14] = { { 22, A }, { 21, A }, },
		[15] = { { 20, A }, { 22, A }, { 21, A }, { 19, A }, },
		[16] = { { 18, A }, { 20, A }, { 22, A }, { 21, A }, { 19, A }, { 17, A }, },
	}
}

COMPONENT.Patterns = {
	["auto_fedsig_integrity_amb_signalmaster"] = {
		["left"] = {
			8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13, 7, 7, 7, 7, 0, 0, 0, 0,
		},
		["right"] = {
			1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 7, 7, 0, 0, 0, 0,
		},
		["diverge"] = {
			14, 14, 15, 15, 16, 16, 7, 7, 7, 7, 0, 0, 0, 0
		}
	},
	["auto_fedsig_integrity_amb"] = {
		["all"] = { 1, 0, 1, 0, 1, 0 },
		["pattern_1"] = { 2, 2, 2, 2, 3, 3, 3, 3, },
		["code2"] = { 
			6, 6, 0, 7, 7, 0,
			6, 6, 0, 7, 7, 0,
			6, 6, 0, 7, 7, 0,
			6, 6, 0, 7, 7, 0,
			6, 0, 6, 0, 6, 0, 7, 0, 7, 0, 7, 0,
			6, 0, 6, 0, 6, 0, 7, 0, 7, 0, 7, 0,
			6, 0, 6, 0, 6, 0, 7, 0, 7, 0, 7, 0,
			6, 0, 6, 0, 6, 0, 7, 0, 7, 0, 7, 0,
		},
		["code3"] = {
			0, 6, 0, 7, 0,
			6, 0, 7, 0,
			6, 0, 7, 0,
			6, 0, 7, 0,
			6, 0, 7, 0,
			6, 0, 6, 0, 6, 0,
			7, 0, 7, 0, 7, 0,
			6, 0, 6, 0, 6, 0,
			7, 0, 7, 0, 7, 0,
			6, 0, 6, 0, 6, 0,
			7, 0, 7, 0, 7, 0,
			8, 8, 0, 9, 9, 0,
			8, 8, 0, 9, 9, 0,
			{ 8, 11 }, { 9, 10 },
			{ 8, 11 }, { 9, 10 },
			{ 8, 11 }, { 9, 10 },
			{ 8, 11 }, { 9, 10 },
			{ 8, 11 }, { 9, 10 },
			{ 8, 11 }, { 9, 10 },
			12, 0, 12, 0, 12, 0,
			13, 0, 13, 0, 13, 0,
			12, 0, 12, 0, 12, 0,
			13, 0, 13, 0, 13, 0,
			12, 0, 12, 0, 12, 0,
			13, 0, 13, 0, 13, 0,
		}
	},
	["auto_fedsig_integrity_amb_corner"] = {
		["alt_slow"] = { 1, 1, 1, 1, 2, 2, 2, },
		["code3"] = { 
			1, 0, 1, 0, 1,
			2, 0, 2, 0, 2,
		}
	}
}

COMPONENT.TrafficDisconnect = { 
	["auto_fedsig_integrity_amb_signalmaster"] = {
		15, 16, 17, 18, 19, 20, 21, 22 
	}
}

EMVU:AddAutoComponent( COMPONENT, name )