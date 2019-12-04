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

local name = "Code 3 Solex"

local COMPONENT = {}

COMPONENT.Model = "models/tdmcars/emergency/equipment/code3_solex.mdl"
COMPONENT.NotLegacy = true
COMPONENT.Skin = 0
COMPONENT.Category = "Lightbar"
COMPONENT.Bodygroups = {}
COMPONENT.DefaultColors = {
	[1] = "RED",
	[2] = "BLUE",
	[3] = "AMBER",
	[4] = "AMBER"
}

COMPONENT.Meta = {
	solex_main = {
		AngleOffset = -90,
		W = 6,
		H = 5.6,
		Sprite = "sprites/emv/solex_main",
		WMult = 1.25,
		Scale = 1,
		EmitArray = {
			Vector( 1.25, 0, 0 ),
			Vector( -1.25, 0, 0 )
		}
	},
	solex_takedown = {
		AngleOffset = -90,
		W = 3.1,
		H = 3.1,
		Sprite = "sprites/emv/legacy_illum",
		WMult = .9,
		Scale = .5,
		EmitArray = {
			Vector( 0, 0, 0 ),
			Vector( .95, 0, 0 ),
			Vector( -.95, 0, 0 ),
		}
	},
	solex_rear = {
		AngleOffset = 90,
		W = 6,
		H = 5.6,
		Sprite = "sprites/emv/solex_main",
		WMult = 1.25,
		Scale = 1,
		EmitArray = {
			Vector( 1.25, 0, 0 ),
			Vector( -1.25, 0, 0 )
		}
	}
}

COMPONENT.Positions = {

	[1] = { Vector( -3.66, 7, 2.52 ), Angle( 0, 0, 0 ), "solex_main" },
	[2] = { Vector( 3.66, 7, 2.52 ), Angle( 0, 0, 0 ), "solex_main" },

	[3] = { Vector( -12.72, 7, 2.52 ), Angle( 0, 0, 0 ), "solex_main" },
	[4] = { Vector( 12.72, 7, 2.52 ), Angle( 0, 0, 0 ), "solex_main" },

	[5] = { Vector( -19.12, 6.09, 2.52 ), Angle( 0, 0, 0 ), "solex_main" },
	[6] = { Vector( 19.12, 6.09, 2.52 ), Angle( 0, 0, 0 ), "solex_main" },

	[7] = { Vector( -25.09, 4.06, 2.52 ), Angle( 0, 42.8, 0 ), "solex_main", 1 },
	[8] = { Vector( 25.09, 4.06, 2.52 ), Angle( 0, -42.8, 0 ), "solex_main", 2 },

	[9] = { Vector( -25.09, -4.06, 2.52 ), Angle( 0, -42.8, 0 ), "solex_rear", 3 },
	[10] = { Vector( 25.09, -4.06, 2.52 ), Angle( 0, 42.8, 0 ), "solex_rear", 4 },

	[11] = { Vector( -19.12, -6.09, 2.52 ), Angle( 0, 0, 0 ), "solex_rear" },
	[12] = { Vector( 19.12, -6.09, 2.52 ), Angle( 0, 0, 0 ), "solex_rear" },

	[13] = { Vector( -12.72, -7, 2.52 ), Angle( 0, 0, 0 ), "solex_rear" },
	[14] = { Vector( 12.72, -7, 2.52 ), Angle( 0, 0, 0 ), "solex_rear" },

	[15] = { Vector( -3.66, -7, 2.52 ), Angle( 0, 0, 0 ), "solex_rear" },
	[16] = { Vector( 3.66, -7, 2.52 ), Angle( 0, 0, 0 ), "solex_rear" },

	[17] = { Vector( -3.66, -7, 4.05 ), Angle( 0, 0, 0 ), "solex_rear" },
	[18] = { Vector( 3.66, -7, 4.05 ), Angle( 0, 0, 0 ), "solex_rear" },

	[19] = { Vector( -1.86, 7.36, 4.12 ), Angle( 0, 0, 0 ), "solex_takedown" },
	[20] = { Vector( 1.86, 7.36, 4.12 ), Angle( 0, 0, 0 ), "solex_takedown" },

	[21] = { Vector( -5.26, 7.36, 4.12 ), Angle( 0, 0, 0 ), "solex_takedown" },
	[22] = { Vector( 5.26, 7.36, 4.12 ), Angle( 0, 0, 0 ), "solex_takedown" },

	[23] = { Vector( -27.32, 0, 2.6 ), Angle( 0, 90, 0 ), "solex_takedown" },
	[24] = { Vector( 27.32, 0, 2.6 ), Angle( 0, -90, 0 ), "solex_takedown" },

}

COMPONENT.Sections = {
	["auto_solex_main"] = {
		[1] = {
			{ 1, "_1" }, { 2, "_2" }, { 3, "_1" }, { 4, "_2" }, { 5, "_1" }, { 6, "_2" }, { 7, "_1" }, { 8, "_2" },
			{ 9, "_1" }, { 10, "_2" }, { 11, "_1" }, { 12, "_2" }, { 13, "_1" }, { 14, "_2" }, { 15, "_1" }, { 16, "_2" },
			{ 17, "_1" }, { 18, "_2" }, { 19, W }, { 20, W }, { 21, W }, { 22, W }, { 23, W }, { 24, W }
		}
	},
	["auto_solex_outer"] = {
		[1] = {
			{ 5, "_1" }, { 7, "_1" }, { 9, "_1" }, { 11, "_1" }, { 4, "_1" }
		},
		[2] = {
			{ 7, "_1" }, { 9, "_1" }, { 4, "_2" }
		},
		[3] = {
			{ 3, "_2" }, { 6, "_2" }, { 8, "_2" }, { 10, "_2" }, { 12, "_2" }
		},
		[4] = {
			{ 3, "_1" }, { 8, "_2" }, { 10, "_2" }
		}
	},
	["auto_solex_rear"] = {
		[1] = {
			{ 13, "_3" }, { 14, "_4" }
		},
		[2] = {
			{ 15, "_3" }, { 16, "_4" }
		},
		[3] = {
			{ 13, "_3" }, { 15, "_3" }
		},
		[4] = {
			{ 14, "_4" }, { 16, "_4" }
		}
	},
	["auto_solex_takedown"] = {
		[1] = { { 21, W }, { 22, W } },
		[2] = { { 19, W }, { 20, W } }
	},
	["auto_solex_alley"] = {
		[1] = { { 23, W } },
		[2] = { { 24, W } },
		[3] = { { 23, W }, { 24, W } },
	},
	["auto_solex_corner"] = {
		[1] = { { 7, "_1"}, { 8, "_2"}, { 9, "_2" }, { 10, "_1" } },
		[2] = { { 7, "_2"}, { 8, "_1"}, { 9, "_1" }, { 10, "_2" } },

		[3] = { { 7, "_1"}, { 10, "_1"} },
		[4] = { { 7, "_2"}, { 10, "_2"} },

		[5] = { { 8, "_1"}, { 9, "_1"} },
		[6] = { { 8, "_2"}, { 9, "_2"} },
	},
	["auto_solex_inner"] = {
		[1] = { { 17, "_1" }, { 1,"_1" } },
		[2] = { { 18, "_1" }, { 2,"_1" } },
		[3] = { { 17, "_2" }, { 1,"_2" } },
		[4] = { { 18, "_2" }, { 2,"_2" } },
	},
	["auto_solex_mid"] = {
		[1] = { { 5, "_1" }, { 6, "_1" } },
		[2] = { { 5, "_2" }, { 6, "_2" } },

		[3] = { { 3, "_1" }, { 4, "_1" } },
		[4] = { { 3, "_2" }, { 4, "_2" } },

		[5] = { { 5, "_1" }, { 6, "_1" } },
		[6] = { { 5, "_2" }, { 6, "_2" } },

		[7] = { { 3, "_1" }, { 4, "_1" } },
		[8] = { { 3, "_2" }, { 4, "_2" } },

		[9] = { { 5, "_1" }, { 6, "_2" } },
		[10] = { { 5, "_2" }, { 6, "_1" } },

		[11] = { { 3, "_1" }, { 4, "_2" } },
		[12] = { { 3, "_2" }, { 4, "_1" } },
	}
}

COMPONENT.Patterns = {
	["auto_solex_main"] = {
		["all"] = { 1 },
	},
	["auto_solex_outer"] = {
		["alt"] = { 1, 1, 1, 0, 3, 3, 3, 0 }
	},
	["auto_solex_rear"] = {
		["in-out"] = { 1, 1, 1, 1, 0, 2, 2, 2, 2, 0 },
		["alt"] = { 1, 1, 1, 1, 2, 2, 2, 2, 1, 1, 1, 1, 2, 2, 2, 2, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4,  3, 3, 3, 3, 4, 4, 4, 4,  3, 3, 3, 3, 4, 4, 4, 4 }
	},
	["auto_solex_takedown"] = {
		["in-out"] = { 1, 1, 1, 1, 0, 2, 2, 2, 2, 0 }
	},
	["auto_solex_alley"] = {
		["stage_3"] = { 3, 3, 3, 3, 0, 0, 0, 0 }
	},
	["auto_solex_corner"] = {
		["stage_3"] = { 1, 0, 1, 0, 1, 1, 1, 1, 0, 2, 0, 2, 0, 2, 2, 2, 2, 0, 0, 3, 3, 3, 6, 6, 6, 4, 4, 4, 5, 5, 5, 0, 0, 0 }
	},
	["auto_solex_inner"] = {
		["on"] = { 1, 1, 1, 1, 2, 2, 2, 2, 1, 1, 1, 1, 4, 4, 4, 4, 3, 3, 3, 3, 2, 2, 2, 2, 1, 1, 1, 1, 4, 4, 4, 4, 3, 3, 3, 3, 2, 2, 2, 2 }
	},
	["auto_solex_mid"] = {
		["stage_3"] = { 1, 1, 1, 0, 3, 3, 3, 0, 2, 2, 2, 0, 4, 4, 4, 0, 5, 5, 5, 0, 7, 7, 7, 0, 6, 6, 6, 0, 8, 8, 8, 0, 9, 9, 9, 0, 11, 11, 11, 0, 10, 10, 10, 0, 12, 12, 12, 0 }
	}
}

COMPONENT.TrafficDisconnect = {

}

COMPONENT.Modes = {
	Primary = {
			M1 = {
				["auto_solex_outer"] = "alt",
				["auto_solex_rear"] = "in-out"
			},
			M2 = {
				["auto_solex_inner"] = "on"
			},
			M3 = {
				["auto_solex_corner"] = "stage_3",
				["auto_solex_rear"] = "in-out",
				["auto_solex_alley"] = "stage_3",
				["auto_solex_takedown"] = "in-out",
				["auto_solex_inner"] = "on",
				["auto_solex_mid"] = "stage_3",
			}
	},
	Auxiliary = {
			C = {},
			L = {},
			R = {},
			D = {}
	},
	Illumination = {
		R = {
			{ 24, W }
		},
		L = {
			{ 23, W }
		},
		F = {},
		T = {}
	}
}

EMVU:AddAutoComponent( COMPONENT, name )