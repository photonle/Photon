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

local name = "Whelen Liberty SX A"

local COMPONENT = {}

COMPONENT.Model = "models/schmal/whelen_liberty.mdl"
COMPONENT.NotLegacy = true
-- COMPONENT.Lightbar = true
COMPONENT.Skin = 0
COMPONENT.Category = "Lightbar"
COMPONENT.Bodygroups = {}
COMPONENT.DefaultColors = {
	[1] = "RED",
	[2] = "BLUE"
}

COMPONENT.Meta = {
	liberty_f_main = {
		AngleOffset = -90,
		W = 8,
		H = 8.6,
		Sprite = "sprites/emv/freedom_main",
		WMult = 1.4,
		Scale = 1,
		EmitArray = {
			Vector( 1.6, 0, 0 ),
			Vector( 0, 0, 0 ),
			Vector( -1.6, 0, 0 )
		}
	},
	liberty_takedown = {
		AngleOffset = -90,
		W = 4.7,
		H = 4.7,
		Sprite = "sprites/emv/emv_whelen_tri",
		WMult = 1,
		Scale = 1,
		EmitArray = {
			Vector( -.6, -.45, 0 ),
			Vector( 0, .6, 0 ),
			Vector( .6, -.45, 0 )
		}
	},
	liberty_alley = {
		AngleOffset = -90,
		W = 4.7,
		H = 4.7,
		Sprite = "sprites/emv/emv_whelen_tri",
		WMult = 1,
		Scale = 1,
		EmitArray = {
			Vector( -.6, -.45, 0 ),
			Vector( 0, .6, 0 ),
			Vector( .6, -.45, 0 )
		}
	},
	liberty_f_ang = {
		AngleOffset = -90,
		W = 12,
		H = 12.2,
		Sprite = "sprites/emv/freedom_corner",
		WMult = 1.4,
		Scale = 1,
		EmitArray = {
			Vector( 3.2, 0, 0 ),
			Vector( 1.6, 0, 0 ),
			Vector( 0, 0, 0 ),
			Vector( -1.6, 0, 0 ),
			Vector( -3.2, 0, 0 )
		}
	},
	liberty_r_ang = {
		AngleOffset = 90,
		W = 12,
		H = 12.2,
		Sprite = "sprites/emv/freedom_corner",
		WMult = 1.4,
		Scale = 1,
		EmitArray = {
			Vector( 3.2, 0, 0 ),
			Vector( 1.6, 0, 0 ),
			Vector( 0, 0, 0 ),
			Vector( -1.6, 0, 0 ),
			Vector( -3.2, 0, 0 )
		}
	},
	liberty_r_main = {
		AngleOffset = 90,
		W = 8,
		H = 8.6,
		Sprite = "sprites/emv/freedom_main",
		WMult = 1.4,
		Scale = 1,
		EmitArray = {
			Vector( 1.6, 0, 0 ),
			Vector( 0, 0, 0 ),
			Vector( -1.6, 0, 0 )
		}
	},
}

COMPONENT.Positions = {

	[1] = { Vector( -4.31, 8.96, 6.24 ), Angle( 0, 0, 0 ), "liberty_f_main" },
	[2] = { Vector( 4.31, 8.96, 6.24 ), Angle( 0, 0, 0 ), "liberty_f_main" },

	[3] = { Vector( -19.66, 8.96, 6.24 ), Angle( 0, 0, 0 ), "liberty_f_main" },
	[4] = { Vector( 19.66, 8.96, 6.24 ), Angle( 0, 0, 0 ), "liberty_f_main" },

	[5] = { Vector( -31.04, 5.57, 6.24 ), Angle( 0, 32.6, 0 ), "liberty_f_ang", 1 },
	[6] = { Vector( 31.04, 5.57, 6.24 ), Angle( 0, -32.6, 0 ), "liberty_f_ang", 2 },

	[7] = { Vector( -31.04, -5.92, 6.24 ), Angle( 0, -32.6, 0 ), "liberty_r_ang", 3 },
	[8] = { Vector( 31.04, -5.92, 6.24 ), Angle( 0, 32.6, 0 ), "liberty_r_ang", 4 },

	[9] = { Vector( -19.85, -9.01, 6.23 ), Angle( 0, 0, 0 ), "liberty_r_main" },
	[10] = { Vector( 19.85, -9.01, 6.23 ), Angle( 0, 0, 0 ), "liberty_r_main" },

	[11] = { Vector( -12.07, -9.01, 6.23 ), Angle( 0, 0, 0 ), "liberty_r_main" },
	[12] = { Vector( 12.07, -9.01, 6.23 ), Angle( 0, 0, 0 ), "liberty_r_main" },

	[13] = { Vector( -4.29, -9.01, 6.23 ), Angle( 0, 0, 0 ), "liberty_r_main" },
	[14] = { Vector( 4.29, -9.01, 6.23 ), Angle( 0, 0, 0 ), "liberty_r_main" },

	[15] = { Vector( -10.3, 9.18, 6.04 ), Angle( 0, 0, 0 ), "liberty_takedown" },
	[16] = { Vector( 10.3, 9.18, 6.04 ), Angle( 0, 0, 0 ), "liberty_takedown" },

	[17] = { Vector( -13.9, 9.18, 6.04 ), Angle( 0, 0, 0 ), "liberty_takedown" },
	[18] = { Vector( 13.9, 9.18, 6.04 ), Angle( 0, 0, 0 ), "liberty_takedown" },

	[19] = { Vector( -36.85, -0.23, 6.04 ), Angle( 0, 90, 0 ), "liberty_alley" },
	[20] = { Vector( 36.85, -0.23, 6.04 ), Angle( 0, -90, 0 ), "liberty_alley" },


}

COMPONENT.Sections = {
	["auto_whelen_liberty_sx"] = {
		{
			{ 1, "_1" }, { 2, "_2" },
			{ 3, "_1" }, { 4, "_2" },
			{ 5, "_1" }, { 6, "_2" },
			{ 7, "_1" }, { 8, "_2" },
			{ 9, "_1" }, { 10, "_2" },
			{ 11, A }, { 12, A },
			{ 13, A }, { 14, A },
			{ 15, W }, { 16, W },
			{ 17, W }, { 18, W },
			{ 19, W }, { 20, W },
		},
		[2] = {
			{ 1, "_1" }, { 4, "_1" }, { 10, "_2" }, 
		},
		[3] = {
			{ 2, "_2" }, { 3, "_2" }, { 9, "_1" }, 
		},
		[4] = {
			{ 3, "_2" }, { 4, "_1" },
		},
		[5] = {
			{ 1, "_1" }, { 2, "_2" }, { 9, "_1" }, { 10, "_2" }
		}
	},
	["auto_whelen_liberty_sx_corner"] = {
		[1] = {
			{ 5, "_1" }, { 7, "_1" }
		},
		[2] = {
			{ 6, "_2" }, { 8, "_2" }
		},
		[3] = { { 5, "_1", .55 }, { 7, "_1", .55 }, { 6, "_2", .55 }, { 8, "_2", .55 } },
		[4] = { { 5, "_1", .66 }, { 7, "_1", .66 }, { 6, "_2", .66 }, { 8, "_2", .66 } },
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
		[5] = { { 9, "_1" }, { 11, A }, { 13, A }, { 14, A }, { 12, A }, { 10, "_2" } },
		[6] = { { 9, "_1" } },
		[7] = { { 9, "_1" }, { 11, A } },
		[8] = { { 9, "_1" }, { 11, A }, { 13, A } },
		[9] = { { 9, "_1" }, { 11, A }, { 13, A }, { 14, A } },
		[10] = { { 9, "_1" }, { 11, A }, { 13, A }, { 14, A }, { 12, A } },
		[11] = { { 10, "_2" } },
		[12] = { { 12, A }, { 10, "_2" } },
		[13] = { { 14, A }, { 12, A }, { 10, "_2" } },
		[14] = { { 13, A }, { 14, A }, { 12, A }, { 10, "_2" } },
		[15] = { { 11, A }, { 13, A }, { 14, A }, { 12, A }, { 10, "_2" } },
		[16] = { { 13, A }, { 14, A } },
		[17] = { { 11, A }, { 13, A }, { 14, A }, { 12, A } },
	},
	["auto_whelen_liberty_sx_corner_illum"] = {
		[1] = { { 15, W }, { 17, W }, { 20, W } },
		[2] = { { 16, W }, { 18, W }, { 19, W } },
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
		["cruise"] = { 3, 3, 4, 4 }
	},
	["auto_whelen_liberty_sx_corner_illum"] = {
		["code3"] = {
			1, 1, 1, 1, 0, 2, 2, 2, 2, 0
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
			C = {
				["auto_whelen_liberty_sx_corner"] = "cruise"
			},
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
		L = {
			{ 19, W }
		},
		R = {
			{ 20, W }
		},
		F = {
			{ 15, W }, { 16, W }, { 17, W }, { 18, W }
		},
		T = {
			{ 15, W }, { 16, W }, { 17, W }, { 18, W }
		}
	}
}

EMVU:AddAutoComponent( COMPONENT, name )