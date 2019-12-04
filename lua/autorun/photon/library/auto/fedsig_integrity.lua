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
COMPONENT.Category = "Lightbar"
COMPONENT.Skin = 0
COMPONENT.Lightbar = true
COMPONENT.Bodygroups = {}
COMPONENT.ColorInput = 1
COMPONENT.DefaultColors = {
	[1] = "RED",
	[2] = "BLUE"
}

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

	[9] = { Vector( 25.87, 5.97, 0.87 ), Angle( 0, -44, 0 ), "integrity_forward_corner", 1 },
	[10] = { Vector( -25.87, 5.97, 0.87 ), Angle( 0, 44, 0 ), "integrity_forward_corner", 2 },

	[11] = { Vector( 28.55, 0.6, 0.87 ), Angle( 0, -79.8, 0 ), "integrity_side" },
	[12] = { Vector( -28.55, 0.6, 0.87 ), Angle( 0, 79.8, 0 ), "integrity_side" },

	[13] = { Vector( 25.61, -4.93, 0.87 ), Angle( 0, 0, 0 ), "integrity_rear", 3 },
	[14] = { Vector( -25.61, -4.93, 0.87 ), Angle( 0, 0, 0 ), "integrity_rear", 4 },

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
			{ 1, "_2" }, { 2, "_1"},
			{ 3, "_2" }, { 4, "_1"},
			{ 5, "_2" }, { 6, "_1"},
			{ 7, "_2" }, { 8, "_1"},
			{ 9, "_2" }, { 10, "_1"},
			{ 11, "_2" }, { 12, "_1"},
			{ 13, "_2" }, { 14, "_1"},
			{ 15, "_2" }, { 16, "_1"},
			{ 17, "_2" }, { 18, "_1"},
			{ 19, "_2" }, { 20, "_1"},
			{ 21, "_2" }, { 22, "_1"},
		},
		{
			{ 1, "_2" }, { 3, "_2" }, { 5, "_2" }, { 7, "_2" }, { 9, "_2" },
			{ 11, "_2" }, { 13, "_2" }, { 15, "_2" }, { 17, "_2" }, { 19, "_2" }, { 21, "_2" }
		},
		{
			{ 2, "_1"}, { 4, "_1"}, { 6, "_1"}, { 8, "_1"}, { 10, "_1"}, { 12, "_1"},
			{ 14, "_1"}, { 16, "_1"}, { 18, "_1"}, { 20, "_1"}, { 22, "_1"}
		},
		{
			{ 8, "_1"}, { 10, "_1"}, { 12, "_1"}, { 14, "_1"}
		},
		{ 
			{ 7, "_2" }, { 9, "_2" }, { 11, "_2" }, { 13, "_2" }
		},
		{
			{ 2, "_1"}, { 4, "_1"}, { 6, "_1"},
			{ 22, "_1"}, { 16, "_1"}, { 18, "_1"}, { 20, "_1"}
		},
		{
			{ 1, "_2" }, { 3, "_2" }, { 5, "_2" },
			{ 21, "_2" }, { 19, "_2" }, { 17, "_2" }, { 15, "_2" }
		},
		[8] = {
			{ 6, "_1"}, { 2, "_1"}, { 16, "_1"}, { 22, "_1"}
		},
		[9] = {
			{ 1, "_2" }, { 5, "_2" }, { 21, "_2" }, { 15, "_2" }
		},
		[10] = {
			{ 4, "_1"}, { 18, "_1"}, { 20, "_1"},
		},
		[11] = {
			{ 3, "_2" }, { 17, "_2" }, { 19, "_2" }
		},
		[12] = {
			{ 6, "_1"}, { 4, "_1"}, { 3, "_2" }, { 5, "_2" },
			{ 16, "_1"}, { 18, "_1"}, { 15, "_2" }, { 17, "_2" }
		},
		[13] = {
			{ 2, W }, { 1, W },
			{ 20, "_1"}, { 22, "_1"},
			{ 21, "_2" }, { 19, "_2" }
		},
		[14] = {
			{ 2, W }, { 4, W }, { 6, W }, { 8, W }, { 10, W }, { 12, W },
			{ 14, A }, { 16, A }, { 18, A }, { 20, A }, { 22, A },
		},
		[15] = {
			{ 1, W }, { 3, W }, { 5, W }, { 7, W }, { 9, W },
			{ 11, A }, { 13, A }, { 15, A }, { 17, A }, { 19, A }, { 21, A }
		},
	},
	["auto_fedsig_integrity_corner"] = {
		{
			{ 8, "_1"}, { 10, "_1"}, { 12, "_1"}, { 14, "_1"}
		},
		{
			{ 7, "_2" }, { 9, "_2" }, { 11, "_2" }, { 13, "_2" }
		},
		{
			{ 7, "_2" }, { 9, "_2" }, { 11, "_2" }, { 13, "_2" },
			{ 8, "_1"}, { 10, "_1"}, { 12, "_1"}, { 14, "_1"}
		},
		{
			{ 7, "_2", .55 }, { 9, "_2", .55 }, { 11, "_2", .55 }, { 13, "_2", .55 },
			{ 8, "_1", .66}, { 10, "_1", .66, .66, .66}, { 12, "_1", .66, .66}, { 14, "_1", .66}
		},
		{
			{ 7, "_2", .66 }, { 9, "_2", .66 }, { 11, "_2", .66 }, { 13, "_2", .66 },
			{ 8, "_1", .55}, { 10, "_1", .55, .55, .55}, { 12, "_1", .55, .55}, { 14, "_1", .55}
		}
	},
	["auto_fedsig_integrity_signalmaster"] = {
		-- center out
		[1] = { { 22, A }, { 21, A }, },
		[2] = { { 20, A }, { 22, A }, { 21, A }, { 19, A }, },
		[3] = { { 18, A }, { 20, A }, { 22, A }, { 21, A }, { 19, A }, { 17, A }, },
		[4] = { { 18, A }, { 20, A }, { 22, A }, { 21, A }, { 19, A }, { 17, A }, { 15, A }, { 16, A }, },
		---left
		[5] = { { 15, A }, },
		[6] = { { 15, A }, { 17, A }, },
		[7] = { { 15, A }, { 17, A }, { 19, A }, },
		[8] = { { 15, A }, { 17, A }, { 19, A }, { 21, A }, },
		[9] = { { 15, A }, { 17, A }, { 19, A }, { 21, A }, { 22, A }, },
		[10] = { { 15, A }, { 17, A }, { 19, A }, { 21, A }, { 22, A }, { 20, A }, },
		[11] = { { 15, A }, { 17, A }, { 19, A }, { 21, A }, { 22, A }, { 20, A }, { 18, A }, },
		[12] = { { 15, A }, { 17, A }, { 19, A }, { 21, A }, { 22, A }, { 20, A }, { 18, A }, { 16, A }, },
		---right
		[13] = { { 16, A }, },
		[14] = { { 16, A }, { 18, A }, },
		[15] = { { 16, A }, { 18, A }, { 20, A }, },
		[16] = { { 16, A }, { 18, A }, { 20, A }, { 22, A }, },
		[17] = { { 16, A }, { 18, A }, { 20, A }, { 22, A }, { 21, A }, },
		[18] = { { 16, A }, { 18, A }, { 20, A }, { 22, A }, { 21, A }, { 19, A }, },
		[19] = { { 16, A }, { 18, A }, { 20, A }, { 22, A }, { 21, A }, { 19, A }, { 17, A }, },
		[20] = { { 16, A }, { 18, A }, { 20, A }, { 22, A }, { 21, A }, { 19, A }, { 17, A }, { 15, A }, },
	},
}

COMPONENT.Patterns = {
	["auto_fedsig_integrity_signalmaster"] = {
		["left"] = { 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 12, 12, 0, 0, 0, 0, 0, 0 },
		["right"] = { 13, 13, 14, 14, 15, 15, 16, 16, 17, 17, 18, 18, 19, 19, 20, 20, 20, 20, 0, 0, 0, 0, 0, 0 },
		["diverge"] = { 1, 1, 2, 2, 3, 3, 4, 4, 4, 4, 0, 0, 0, 0, 0, 0 },
	},
	["auto_fedsig_integrity"] = {
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
		},
		["alert"] = { 3, 15, 14, 2 }
	},
	["auto_fedsig_integrity_corner"] = {
		["cruise"] = {
			4, 4, 4, 5, 5, 5
		},
		["alt_slow"] = { 1, 1, 1, 1, 2, 2, 2, },
		["code3"] = { 
			1, 0, 1, 0, 1,
			2, 0, 2, 0, 2,
		}
	}
}

COMPONENT.TrafficDisconnect = { 
	["auto_fedsig_integrity_signalmaster"] = {
		15, 16, 17, 18, 19, 20, 21, 22 
	}
}

COMPONENT.Modes = {
	Primary = {
		M1 = {
			["auto_fedsig_integrity"] = "pattern_1",
		},
		M2 = {
			["auto_fedsig_integrity"] = "code2",
			["auto_fedsig_integrity_corner"] = "alt_slow"
		},
		M3 = {
			["auto_fedsig_integrity"] = "code3",
			["auto_fedsig_integrity_corner"] = "code3"
		},
		ALERT = {
			["auto_fedsig_integrity"] = "alert",
		}
	},
	Auxiliary = {
		C = {
			["auto_fedsig_integrity_corner"] = "cruise"
		},
		L = {
			["auto_fedsig_integrity_signalmaster"] = "left"
		},
		R = {
			["auto_fedsig_integrity_signalmaster"] = "right"
		},
		D = {
			["auto_fedsig_integrity_signalmaster"] = "diverge"
		}
	},
	Illumination = {
		F = {
			{ 8, W }, { 6, W }, { 4, W }, { 2, W }, { 1, W }, { 3, W }, { 5, W }, { 7, W }, 
		},
		R = {
			{ 11, W }
		},
		L = {
			{ 12, W }
		},
		T = {
			{ 1, W }, { 2, W }
		}
	}
}

EMVU:AddAutoComponent( COMPONENT, name )
