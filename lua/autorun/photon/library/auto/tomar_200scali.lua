AddCSLuaFile()

local A = "AMBER"
local R = "RED"
local DR = "D_RED"
local B = "BLUE"
local W = "WHITE"
local CW = "C_WHITE"
local SW = "S_WHITE"
local G = "GREEN"

local name = "Tomar 200S Rear Cali"

local COMPONENT = {}

COMPONENT.Model = "models/tdmcars/emergency/equipment/tomar_200s.mdl"
COMPONENT.Skin = 0
COMPONENT.Bodygroups = {}
COMPONENT.NotLegacy = true
COMPONENT.Category = "Auxiliary"
COMPONENT.DefaultColors = {
	[1] = "RED",
	[2] = "BLUE",
	[3] = "AMBER"
}

COMPONENT.Meta = {
	tomar_src = {
		AngleOffset = 0,
		W = 8.1,
		H = 7,
		Sprite = "sprites/emv/emv_whelen_src",
		Scale = 1,
		WMult = 1.5,
		NoLegacy = true,
		DirAxis = "Up",
		DirOffset = -90
	}
}

COMPONENT.Positions = {
	[1] = { Vector( 1.48, -3.56, 1.13 ), Angle( 0, 90, 0 ), "tomar_src" },
	[2] = { Vector( 1.48, 3.56, 1.13 ), Angle( 0, 90, 0 ), "tomar_src" },

	[3] = { Vector( 1.48, -10.64, 1.13 ), Angle( 0, 90, 0 ), "tomar_src" },
	[4] = { Vector( 1.48, 10.64, 1.13 ), Angle( 0, 90, 0 ), "tomar_src" },

	[5] = { Vector( 1.48, -17.72, 1.13 ), Angle( 0, 90, 0 ), "tomar_src" },
	[6] = { Vector( 1.48, 17.72, 1.13 ), Angle( 0, 90, 0 ), "tomar_src" },

	[7] = { Vector( 1.48, -24.8, 1.13 ), Angle( 0, 90, 0 ), "tomar_src" },
	[8] = { Vector( 1.48, 24.8, 1.13 ), Angle( 0, 90, 0 ), "tomar_src" },
}

COMPONENT.Sections = {
	["auto_tomar_200s_amber"] = {
		[1] = { { 3, A }, { 5, A } },
		[2] = { { 4, A }, { 6, A } },
		[3] = { { 4, A }, { 6, A }, { 3, A }, { 5, A } },
		[4] = { { 1, A }, { 2, A } },
	},
	["auto_tomar_200s_redblue"] = {
		[1] = { { 7, "_1" }, },
		[2] = { { 8, "_2" }, },
		
		[3] = { { 7, "_1" }, },
		[4] = { { 8, "_2" }, },
		[5] = {},
		[6] = {},
		[7] = {},
		[8] = {},
		[9] = {},
		[10] = {},
		[11] = {},
		[12] = {},
		-- TRAFFIC PAT
		[13] = { { 8, "_3" } },
		[14] = { { 6, "_3" }, { 8, "_3" } },
		[15] = { { 4, "_3" }, { 6, "_3" }, { 8, "_3" } },
		[16] = { { 2, "_3" }, { 4, "_3" }, { 6, "_3" }, { 8, "_3" } },
		[17] = { { 1, "_3" }, { 2, "_3" }, { 4, "_3" }, { 6, "_3" } },
		[18] = { { 3, "_3" }, { 1, "_3" }, { 2, "_3" }, { 4, "_3" } },
		[19] = { { 5, "_3" }, { 3, "_3" }, { 1, "_3" }, { 2, "_3" } },
		[20] = { { 7, "_3" }, { 5, "_3" }, { 3, "_3" }, { 1, "_3" } },
		[21] = { { 7, "_3" }, { 5, "_3" }, { 3, "_3" }, },
		[22] = { { 7, "_3" }, { 5, "_3" } },
		[23] = { { 7, "_3" } },

		[24] = { { 1, "_3" }, { 2, "_3" } },
		[25] = { { 3, "_3" }, { 1, "_3" }, { 2, "_3" }, { 4, "_3" } },
		[26] = { { 5, "_3" }, { 3, "_3" }, { 1, "_3" }, { 2, "_3" }, { 4, "_3" }, { 6, "_3" } },
		[27] = { { 7, "_3" }, { 5, "_3" }, { 3, "_3" }, { 1, "_3" }, { 2, "_3" }, { 4, "_3" }, { 6, "_3" }, { 8, "_3" } },
		[28] = { { 7, "_3" }, { 5, "_3" }, { 3, "_3" }, { 4, "_3" }, { 6, "_3" }, { 8, "_3" } },
		[29] = { { 7, "_3" }, { 5, "_3" }, { 6, "_3" }, { 8, "_3" } },
		[30] = { { 7, "_3" }, { 8, "_3" } },
	}
}

COMPONENT.Patterns = {
	["auto_tomar_200s_redblue"] = {
		
		-- STICK CODE PAT
		["code1"] = { 1, 1, 1, 1, 1, 2, 2, 2, 2, 2 },
		
		["code2"] = { 1, 1, 1, 1, 1, 2, 2, 2, 2, 2 },
		
		["code3"] = { 1, 0, 1, 0, 1, 2, 0, 2, 0, 2 },
		
		-- TRAFFIC PAT
		["left"] = { 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 0, 0, 0, 0 },
		
		["right"] = { 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 0, 0, 0, 0 },
		
		["diverge"] = { 24, 25, 26, 27, 28, 29, 30, 0, 0, 0, 0 }
	},
	["auto_tomar_200s_amber"] = {
		["code1"] = { 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2 },
		["code2"] = { 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4 },
	},
}

COMPONENT.TrafficDisconnect = { }

COMPONENT.Modes = {
	Primary = {
		M1 = {
			["auto_tomar_200s_redblue"] = "code1",
			["auto_tomar_200s_amber"] = "code1"
		},
		M2 = {
			["auto_tomar_200s_redblue"] = "code2",
			["auto_tomar_200s_amber"] = "code2"
		},
		M3 = {
			["auto_tomar_200s_redblue"] = "code3",
			["auto_tomar_200s_amber"] = "code2"
		}
	},
	Auxiliary = {
		L = {
			["auto_tomar_200s_redblue"] = "left"
		},
		R = {
			["auto_tomar_200s_redblue"] = "right"
		},
		D = {
			["auto_tomar_200s_redblue"] = "diverge"
		},
		C = {
			["auto_tomar_200s_amber"] = "code1"
		},
	}
}

EMVU:AddAutoComponent( COMPONENT, name )