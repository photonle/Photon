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
			{ 11, A }, { 12, A },
			{ 13, A }, { 14, A },
			{ 15, W }, { 16, W },
			{ 17, W }, { 18, W },
		},
		[2] = {
			{ 1, R }, { 4, R }, { 10, B }, 
		},
		[3] = {
			{ 2, B }, { 3, B }, { 9, R }, 
		},
		[4] = {
			{ 3, B }, { 4, R },
		},
		[5] = {
			{ 1, R }, { 2, B }, { 9, R }, { 10, B }
		}
	},
	["auto_whelen_liberty_sx_corner"] = {
		[1] = {
			{ 5, R }, { 7, R }
		},
		[2] = {
			{ 6, B }, { 8, B }
		}
	},
	["auto_whelen_liberty_sx_traffic"] = {
		[1] = {
			{ 11, A }, { 13, A }
		},
		[2] = {
			{ 12, A }, { 14, A }
		},
		[3] = {
			{ 11, A }, { 12, A }
		},
		[4] = {
			{ 13, A }, { 14, A }
		},
		[5] = { { 9, R }, { 11, A }, { 13, A }, { 14, A }, { 12, A }, { 10, B } },
		[6] = { { 9, R } },
		[7] = { { 9, R }, { 11, A } },
		[8] = { { 9, R }, { 11, A }, { 13, A } },
		[9] = { { 9, R }, { 11, A }, { 13, A }, { 14, A } },
		[10] = { { 9, R }, { 11, A }, { 13, A }, { 14, A }, { 12, A } },
		[11] = { { 10, B } },
		[12] = { { 12, A }, { 10, B } },
		[13] = { { 14, A }, { 12, A }, { 10, B } },
		[14] = { { 13, A }, { 14, A }, { 12, A }, { 10, B } },
		[15] = { { 11, A }, { 13, A }, { 14, A }, { 12, A }, { 10, B } },
		[16] = { { 13, A }, { 14, A } },
		[17] = { { 11, A }, { 13, A }, { 14, A }, { 12, A } },
	},
	["auto_whelen_liberty_sx_corner_illum"] = {
		[1] = { { 15, W }, { 17, W } },
		[2] = { { 16, W }, { 18, W } },
	}
}

COMPONENT.Patterns = {
	["auto_whelen_liberty_sx"] = {
		["all"] = { 1 },
		["code1"] = { 2, 2, 2, 2, 0, 3, 3, 3, 3, 0 },
		["code2"] = { 2, 0, 2, 2, 2, 0, 3, 0, 3, 3, 3, 0, },
		["code3"] = { 
			4, 4, 5, 5, 4, 4, 5, 5, 4, 4, 5, 5, 4, 4, 5, 5, 
			2, 2, 3, 3, 2, 2, 3, 3, 2, 2, 3, 3, 2, 2, 3, 3,
			2, 2, 3, 3, 2, 2, 3, 3, 2, 2, 3, 3, 2, 2, 3, 3,
			2, 3, 2, 3,2, 3, 2, 3,2, 3, 2, 3,2, 3, 2, 3,2, 3, 2, 3,
		},
	},
	["auto_whelen_liberty_sx_traffic"] = {
		["code1"] = { 1, 1, 2, 2 },
		["code2"] = { 3, 3, 4, 4 },
		["code3"] = { 
			3, 3, 4, 4, 1, 1, 2, 2,
		},
		["left"] = {
			11, 11, 12, 12, 13, 13, 14, 14, 15, 15, 5, 5, 5, 5, 0, 0
		},
		["right"] = {
			6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 5, 5, 5, 5, 0, 0
		},
		["diverge"] = {
			16, 16, 16, 17, 17, 17, 5, 5, 5, 5, 0, 0
		}
	}, 
	["auto_whelen_liberty_sx_corner"] = {
		["code1"] = { 1, 1, 1, 0, 2, 2, 2, 0 },
		["code2"] = { 1, 1, 0, 2, 2, 0 },
		["code3"] = { 1, 2 },
	},
	["auto_whelen_liberty_sx_corner_illum"] = {
		["code3"] = {
			1, 1, 2, 2,
		}
	}
}

COMPONENT.TrafficDisconnect = { 
	["auto_whelen_legacy_traffic"] = {
		9, 10, 11, 12, 13, 14
	}
}

COMPONENT.Modes = {
	Primary = {
			M1 = {
				["auto_whelen_liberty_sx"] = "code1",
				["auto_whelen_liberty_sx_corner"] = "code1",
				["auto_whelen_liberty_sx_traffic"] = "code1"
			},
			M2 = {
				["auto_whelen_liberty_sx"] = "code2",
				["auto_whelen_liberty_sx_corner"] = "code2",
				["auto_whelen_liberty_sx_traffic"] = "code2"
			},
			M3 = {
				["auto_whelen_liberty_sx"] = "code3",
				["auto_whelen_liberty_sx_corner"] = "code3",
				["auto_whelen_liberty_sx_traffic"] = "code3",
				["auto_whelen_liberty_sx_corner_illum"] = "code3"
			}
		},
	Auxiliary = {
			L = {
				["auto_whelen_liberty_sx_traffic"] = "left"
			},
			R = {
				["auto_whelen_liberty_sx_traffic"] = "right"
			},
			D = {
				["auto_whelen_liberty_sx_traffic"] = "diverge"
			}
		},
	Illumination = {

	}
}

EMVU:AddAutoComponent( COMPONENT, name )