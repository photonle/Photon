AddCSLuaFile()

local A = "AMBER"
local R = "RED"
local B = "BLUE"
local W = "WHITE"

local name = "Whelen Liberty II"

local COMPONENT = {}

COMPONENT.Model = "models/schmal/liberty_ii.mdl"
COMPONENT.Lightbar = true
COMPONENT.Skin = 0
COMPONENT.Category = "Lightbar"
COMPONENT.Bodygroups = {}
COMPONENT.DefaultColors = {
	[1] = R,
	[2] = B,
	[3] = A,
	[4] = A,
	[5] = W,
}

COMPONENT.Meta = {
	liberty2_f_main = {
		AngleOffset = -90,
		W = 7.9,
		H = 7.5,
		Sprite = "sprites/emv/emv_whelen_src",
		WMult = 2,
		Scale = 1.4
	},
	liberty2_takedown = {
		AngleOffset = -90,
		W = 4.7,
		H = 4.7,
		Sprite = "sprites/emv/emv_whelen2_takedown",
		WMult = 1.4,
		Scale = 1.5
	},
	liberty2_alley = {
		AngleOffset = -90,
		W = 3,
		H = 3,
		Sprite = "sprites/emv/emv_whelen2_alley",
		WMult = .5,
		Scale = 1
	},
	liberty2_f_ang = {
		AngleOffset = -90,
		W = 17,
		H = 15,
		Sprite = "sprites/emv/emv_whelen2_corner",
		WMult = 3,
		Scale = 1.6,
		VisRadius = 0
	},
	liberty2_f2_ang = {
		AngleOffset = -90,
		W = 17,
		H = 15,
		Sprite = "sprites/emv/emv_whelen2_corner2",
		WMult = 3,
		Scale = 1.6,
		VisRadius = 0
	},
	liberty2_r_ang = {
		AngleOffset = 90,
		W = 16,
		H = 15,
		Sprite = "sprites/emv/emv_whelen2_corner",
		WMult = 3,
		Scale = 1.6
	},
	liberty2_r2_ang = {
		AngleOffset = 90,
		W = 16,
		H = 15,
		Sprite = "sprites/emv/emv_whelen2_corner2",
		WMult = 3,
		Scale = 1.6
	},
	liberty2_r_main = {
		AngleOffset = 90,
		W = 7.9,
		H = 7.5,
		Sprite = "sprites/emv/emv_whelen_src",
		WMult = 2,
		Scale = 1.4
	},
}

COMPONENT.Positions = {

	[1] = { Vector( -10.18, 6.51, 0.67 ), Angle( 0, 0, 0 ), "liberty2_f_main" },
	[2] = { Vector( 10.18, 6.51, 0.67 ), Angle( 0, 0, 0 ), "liberty2_f_main" },

	[3] = { Vector( -16.96, 6.51, 0.67 ), Angle( 0, 0, 0 ), "liberty2_f_main" },
	[4] = { Vector( 16.96, 6.51, 0.67 ), Angle( 0, 0, 0 ), "liberty2_f_main" },

	[5] = { Vector( -23.85, 3.87, 0.64 ), Angle( 0, 38.4, 0 ), "liberty2_f_ang", 1 },
	[6] = { Vector( 24.25, 3.67, 0.64 ), Angle( 0, -38.4, 0 ), "liberty2_f2_ang", 2 },

	[7] = { Vector( -23.85, -4.22, 0.64 ), Angle( 0, -38.4, 0 ), "liberty2_r_ang", 3 },
	[8] = { Vector( 23.85, -4.02, 0.64 ), Angle( 0, 38.4, 0 ), "liberty2_r2_ang", 4 },

	[9] = { Vector( -16.94, -7.06, 0.59 ), Angle( 0, 0, 0 ), "liberty2_r_main" },
	[10] = { Vector( 16.94, -7.06, 0.59 ), Angle( 0, 0, 0 ), "liberty2_r_main" },

	[11] = { Vector( -10.18, -7.06, 0.59 ), Angle( 0, 0, 0 ), "liberty2_r_main" },
	[12] = { Vector( 10.18, -7.06, 0.59 ), Angle( 0, 0, 0 ), "liberty2_r_main" },

	[13] = { Vector( -3.4, -7.06, 0.59 ), Angle( 0, 0, 0 ), "liberty2_r_main" },
	[14] = { Vector( 3.4, -7.06, 0.59 ), Angle( 0, 0, 0 ), "liberty2_r_main" },

	[15] = { Vector( -3.37, 6.28, 0.6 ), Angle( 0, 0, 0 ), "liberty2_takedown" },
	[16] = { Vector( 3.37, 6.28, 0.6 ), Angle( 0, 0, 0 ), "liberty2_takedown" },

	[17] = { Vector( -27.9, -0.23, 0.58 ), Angle( 0, 90, 0 ), "liberty2_alley" },
	[18] = { Vector( 27.9, -0.23, 0.58 ), Angle( 0, -90, 0 ), "liberty2_alley" },


}

COMPONENT.Sections = {
	["auto_whelen_liberty_ii"] = {
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
		},
	},
	["auto_whelen_liberty_ii_f_inner"] = {
		[1] = { { 1, "_1", .5 }, { 2, "_2" } },
		[2] = { { 1, "_1" }, { 2, "_2", .5 } },
		[3] = { { 1, "_1" }, { 2, "_2" }, { 11, "_1" }, { 12, "_4" } },
		[4] = { { 1, "_2" }, { 2, "_1" }, { 11, "_3" }, { 12, "_2" }  },
		[5] = { { 1, "_1" }, { 11, "_1" } },
		[6] = { { 2, "_2" }, { 12, "_2" } },
		[7] = { { 1, "_5" }, { 11, "_5" } },
		[8] = { { 2, "_5" }, { 12, "_5" } },
	},
	["auto_whelen_liberty_ii_f_outer"] = {
		[1] = { { 3, "_1" }, { 4, "_2" }, { 9, "_1" }, { 10, "_4" } },
		[2] = { { 3, "_2" }, { 4, "_1" }, { 9, "_3" }, { 10, "_2" }  },
		[3] = { { 3, "_5" }, { 4, "_5" }, { 9, "_5" }, { 10, "_5" }  },
		[4] = { { 3, "_1" }, { 9, "_1" } },
		[5] = { { 4, "_1" }, { 10, "_4" } },
		[6] = { { 3, "_2" }, { 9, "_3" } },
		[7] = { { 4, "_2" }, { 10, "_3" } },
		[8] = { { 3, "_5" }, { 9, "_5" } },
		[9] = { { 4, "_5" }, { 10, "_5" } },
	},
	["auto_whelen_liberty_ii_r_inner"] = {
		[1] = { { 13, "_1" } },
		[2] = { { 14, "_2" } },
	},
	["auto_whelen_liberty_ii_corner"] = {
		[1] = { { 7, "_1" } },
		[2] = { { 8, "_2" } },
		[3] = { { 5, "_1" }, { 7, "_1" } },
		[4] = { { 6, "_2" }, { 8, "_2" } },
		[5] = { { 5, "_2" }, { 7, "_2" } },
		[6] = { { 6, "_1" }, { 8, "_1" } },
		[7] = { { 5, "_5" }, { 7, "_5" } },
		[8] = { { 6, "_5" }, { 8, "_5" } },
		[9] = { { 6, "_2", .55 }, { 8, "_2", .55 }, { 5, "_1", .55 }, { 7, "_1", .55 } },
		[10] = { { 6, "_2", .66 }, { 8, "_2", .66 }, { 5, "_1", .66 }, { 7, "_1", .66 } },
	},
	["auto_whelen_liberty_ii_rear_outer"] = {
		[1] = { { 9, "_3", .5 }, { 10, "_4", .5 } },
		[2] = { { 9, "_3" }, { 10, "_4" } },
	},
	["auto_whelen_liberty_ii_takedown"] = {
		[1] = { { 15, W }, { 17, W } },
		[2] = { { 16, W }, { 18, W } },
	},
	["auto_whelen_liberty_ii_traffic"] = {
		[1] = { { 9, "_3" }, { 11, "_3" }, { 13, "_3" }, { 14, "_4" }, { 12, "_4" }, { 10, "_4" } },
		[2] = { { 9, "_3" } },
		[3] = { { 9, "_3" }, { 11, "_3" } },
		[4] = { { 9, "_3" }, { 11, "_3" }, { 13, "_3" } },
		[5] = { { 9, "_3" }, { 11, "_3" }, { 13, "_3" }, { 14, "_4" } },
		[6] = { { 9, "_3" }, { 11, "_3" }, { 13, "_3" }, { 14, "_4" }, { 12, "_4" } },

		[7] = { { 11, "_3" }, { 13, "_3" }, { 14, "_4" }, { 12, "_4" }, { 10, "_4" } },
		[8] = { { 13, "_3" }, { 14, "_4" }, { 12, "_4" }, { 10, "_4" } },
		[9] = { { 14, "_4" }, { 12, "_4" }, { 10, "_4" } },
		[10] = { { 12, "_4" }, { 10, "_4" } },
		[11] = { { 10, "_4" } },

		[12] = { { 13, "_3" }, { 14, "_4" } },
		[13] = { { 11, "_3" }, { 13, "_3" }, { 14, "_4" }, { 12, "_4" } },
		[14] = { { 9, "_3" }, { 11, "_3" },  { 12, "_4" }, { 10, "_4" } },
		[15] = { { 9, "_3" }, { 10, "_4" } },
	}
}

COMPONENT.Patterns = {
	["auto_whelen_liberty_ii_traffic"] = {
		["right"] = { 2, 3, 4, 5, 6, 1, 1, 1, 1, 7, 8, 9, 10, 11, 0, 0, 0, 0 },
		["left"] = { 11, 10, 9, 8, 7, 1, 1, 1, 6, 5, 4, 3, 2, 0, 0, 0, 0 },
		["diverge"] = { 12, 12, 13, 13, 1, 1, 1, 1, 14, 14, 15, 15, 0, 0, 0, 0 },
	},
	["auto_whelen_liberty_ii"] = {
		["all"] = { 1 },
	},
	["auto_whelen_liberty_ii_f_inner"] = {
		["stage_1"] = { 1, 2 },
		["stage_2"] = { 3, 3, 3, 0, 4, 4, 4, 0, 3, 3, 3, 0, 4, 4, 4, 0, 3, 0, 3, 0, 4, 0, 4, 0, 5, 5, 0, 6, 6, 0, 5, 5, 0, 6, 6, 0, 5, 5, 0, 6, 6, 0 },
		["stage_3"] = { 5, 0, 5, 0, 6, 0, 6, 0, 7, 0, 7, 0, 8, 0, 8, 0 }
	},
	["auto_whelen_liberty_ii_f_outer"] = {
		["stage_2"] = { 1, 0, 1, 0, 1, 1, 0, 2, 0, 2, 0, 2, 2, 0 },
		["stage_3"] = { 4, 5, 6, 7, 8, 9, 8, 7, 6, 5 },
	},
	["auto_whelen_liberty_ii_corner"] = {
		["stage_1"] = { 1, 0, 1, 0, 2, 0, 2, 0, 1, 0, 1, 0, 2, 0, 2, 0, 1, 0, 1, 0, 2, 0, 2, 0, 1, 1, 1, 0, 2, 2, 2, 0, 1, 1, 1, 0, 2, 2, 2, 0, 1, 1, 1, 0, 2, 2, 2, },
		["stage_2"] = { 3, 0, 3, 0, 6, 0, 6, 0, 5, 0, 5, 0, 4, 0, 4, 0 },
		["stage_3"] = { 3, 0, 6, 0, 4, 0, 5, 0, 7, 0, 8, 0 },
		["cruise"] = { 9, 9, 10, 10 },
	},
	["auto_whelen_liberty_ii_rear_outer"] = {
		["stage_1"] = { 1, 2 }
	},
	["auto_whelen_liberty_ii_r_inner"] = {
		["off"] = { 0 },
		["stage_2"] = { 1, 1, 0, 2, 2, 0 }
	},
	["auto_whelen_liberty_ii_takedown"] = {
		["stage_3"] = { 1, 1, 2, 2 },
		["off"] = { 0 }
	}
}

COMPONENT.TrafficDisconnect = {
	["auto_whelen_liberty_ii_traffic"] = {
		9, 11, 13, 14, 12, 10
	}
}

COMPONENT.Modes = {
	Primary = {
			M1 = {
				["auto_whelen_liberty_ii_f_inner"] = "stage_1",
				["auto_whelen_liberty_ii_corner"] = "stage_1",
				["auto_whelen_liberty_ii_rear_outer"] = "stage_1",
				["auto_whelen_liberty_ii_r_inner"] = "off",
				["auto_whelen_liberty_ii_takedown"] = "off"
			},
			M2 = {
				["auto_whelen_liberty_ii_corner"] = "stage_2",
				["auto_whelen_liberty_ii_f_outer"] = "stage_2",
				["auto_whelen_liberty_ii_f_inner"] = "stage_2",
				["auto_whelen_liberty_ii_r_inner"] = "stage_2",
			},
			M3 = {
				["auto_whelen_liberty_ii_corner"] = "stage_3",
				["auto_whelen_liberty_ii_f_outer"] = "stage_3",
				["auto_whelen_liberty_ii_f_inner"] = "stage_3",
				["auto_whelen_liberty_ii_r_inner"] = "stage_2",
				["auto_whelen_liberty_ii_takedown"] = "stage_3",
			}
		},
	Auxiliary = {
			C = {
				["auto_whelen_liberty_ii_corner"] = "cruise"
			},
			L = {
				["auto_whelen_liberty_ii_traffic"] = "left"
			},
			R = {
				["auto_whelen_liberty_ii_traffic"] = "right"
			},
			D = {
				["auto_whelen_liberty_ii_traffic"] = "diverge"
			}
		},
	Illumination = {
		T = {
			{ 15, W }, { 16, W }
		},
		F = {
			{ 15, W }, { 16, W }, { 1, W }, { 2, W }, { 3, W }, { 4, W }
		},
		L = {
			{ 17, W }
		},
		R = {
			{ 18, W }
		}
	}
}

EMVU:AddAutoComponent( COMPONENT, name )