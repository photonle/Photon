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

local name = "Whelen Liberty II CHP"

local COMPONENT = {}

COMPONENT.Model = "models/schmal/liberty_ii.mdl"
COMPONENT.Lightbar = true
COMPONENT.Skin = 0
COMPONENT.Category = "Lightbar"
COMPONENT.Bodygroups = {}

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
		{ { 11, A }, { 13, A }, { 14, A }, { 12, A }, { 5, R }, { 3, R }, { 1, R } },
		{ { 2, B }, { 4, B }, { 6, B }, { 1, R }, { 7, B }, { 9, B }, { 10, R }, { 8, R } },
		{ { 1, R }, { 3, R }, { 6, B }, { 11, A }, { 13, A }, { 14, A }, { 12, A }, },
		{ { 1, R }, { 3, R }, { 5, R }, { 7, B }, { 9, B }, { 10, R }, { 8, R } },
	},
	["auto_whelen_liberty_ii_front"] = {
		{ { 5, R }, { 3, R, .66 }, { 1, R, .66 } },
		{ { 5, R }, { 3, R }, { 1, R } },
		{ { 2, B }, { 4, B }, { 6, B }, { 1, R } },
		{ { 3, R }, { 1, R } },
	},
	["auto_whelen_liberty_ii_rear"] = {
		{ { 11, A }, { 13, A }, { 14, A }, { 12, A }, },
		{ { 7, B }, { 9, B } },
		{ { 7, B }, { 9, B }, { 10, R }, { 8, R } },
	},
}

COMPONENT.Patterns = {
	["auto_whelen_liberty_ii_front"] = {
		["code1"] = { 1 },
		["code2"] = { 4 },
		["code3"] = { 2, 2, 2, 2, 2, 3, 3, 3, 3, 3 },
	},
	["auto_whelen_liberty_ii_rear"] = {
		["code1"] = { 2, 2, 2, 2, 2, 1, 1, 1, 1, 1 },
		["code2"] = { 3, 3, 3, 3, 2, 1, 1, 1, 1, 1 },
	},
	["auto_whelen_liberty_ii"] = {
		["code2"] = { 3, 3, 3, 3, 3, 4, 4, 4, 4, 4 },
		["code3"] = { 1, 1, 1, 1, 1, 2, 2, 2, 2, 2 }
	}
}

COMPONENT.TrafficDisconnect = { 
	["auto_whelen_liberty_traffic"] = {
		
	}
}

COMPONENT.Modes = {
	Primary = {
			M1 = {
				["auto_whelen_liberty_ii_front"] = "code1",
				["auto_whelen_liberty_ii_rear"] = "code1"
			},
			M2 = {
				["auto_whelen_liberty_ii"] = "code2",
			},
			M3 = {
				["auto_whelen_liberty_ii"] = "code3"
			}
		},
	Auxiliary = {
			-- L = {
			-- 	["auto_whelen_liberty_ii_traffic"] = "left"
			-- },
			-- R = {
			-- 	["auto_whelen_liberty_ii_traffic"] = "right"
			-- },
			-- D = {
			-- 	["auto_whelen_liberty_ii_traffic"] = "diverge"
			-- }
		},
	Illumination = {
		T = {
			{ 15, W }, { 16, W }
		}
	}
}

EMVU:AddAutoComponent( COMPONENT, name )