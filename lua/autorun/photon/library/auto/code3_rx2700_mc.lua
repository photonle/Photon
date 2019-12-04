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

local name = "Code 3 RX2700 MC"

local COMPONENT = {}

COMPONENT.Model = "models/schmal/code3_rx2700.mdl"
COMPONENT.Lightbar = true
COMPONENT.Skin = 1
COMPONENT.Category = "Lightbar"
COMPONENT.Bodygroups = {}
COMPONENT.DefaultColors = {
	[1] = "RED",
	[2] = "BLUE",
	[3] = "AMBER",
}

COMPONENT.Meta = {
	rx2700_front = {
		AngleOffset = -90,
		W = 8.2,
		H = 7.5,
		Sprite = "sprites/emv/2700_main",
		WMult = 2,
		Scale = 2
	},
	rx2700_takedown = {
		AngleOffset = -90,
		W = 4.7,
		H = 4.7,
		Sprite = "sprites/emv/2700_takedown",
		WMult = 1.4,
		Scale = 1.5
	},
	rx2700_rear = {
		AngleOffset = 90,
		W = 8.2,
		H = 7.5,
		Sprite = "sprites/emv/2700_main",
		WMult = 2,
		Scale = 2
	},
	rx2700_feet = {
		AngleOffset = -90,
		W = 4,
		H = 4,
		Sprite = "sprites/emv/emv_whelen_mini_3",
		WMult = 1.5,
		Scale = 1
	},
}

COMPONENT.Positions = {

	[1] = { Vector( -11.41, 8.21, 1.17 ), Angle( 0, 0, 0 ), "rx2700_front" },
	[2] = { Vector( 11.41, 8.21, 1.17 ), Angle( 0, 0, 0 ), "rx2700_front" },

	[3] = { Vector( -19.08, 8.21, 1.17 ), Angle( 0, 0, 0 ), "rx2700_front" },
	[4] = { Vector( 19.08, 8.21, 1.17 ), Angle( 0, 0, 0 ), "rx2700_front" },

	[5] = { Vector( -26.34, 5.99, 1.17 ), Angle( 0, 32.6, 0 ), "rx2700_front", 1 },
	[6] = { Vector( 26.34, 5.99, 1.17 ), Angle( 0, -32.6, 0 ), "rx2700_front", 2 },

	[7] = { Vector( -26.34, -5.85, 1.17 ), Angle( 0, -32.6, 0 ), "rx2700_rear", 3 },
	[8] = { Vector( 26.34, -5.85, 1.17 ), Angle( 0, 32.6, 0 ), "rx2700_rear", 4 },

	[9] = { Vector( -19.08, -8.01, 1.17 ), Angle( 0, 0, 0 ), "rx2700_rear" },
	[10] = { Vector( 19.08, -8.01, 1.17 ), Angle( 0, 0, 0 ), "rx2700_rear" },

	[11] = { Vector( -11.41, -8.01, 1.17 ), Angle( 0, 0, 0 ), "rx2700_rear" },
	[12] = { Vector( 11.41, -8.01, 1.17 ), Angle( 0, 0, 0 ), "rx2700_rear" },

	[13] = { Vector( 0, 8.21, 1.17 ), Angle( 0, 0, 0 ), "rx2700_front" },
	[14] = { Vector( 0, -8.01, 1.17 ), Angle( 0, 0, 0 ), "rx2700_rear" },

	[15] = { Vector( -5.4, 8.41, 1.2 ), Angle( 0, 0, 0 ), "rx2700_takedown" },
	[16] = { Vector( 5.4, 8.41, 1.2 ), Angle( 0, 0, 0 ), "rx2700_takedown" },

	[17] = { Vector( -29.7, 0.1, 1.2 ), Angle( 0, 90, 0 ), "rx2700_takedown" },
	[18] = { Vector( 29.8, 0.1, 1.2 ), Angle( 0, -90, 0 ), "rx2700_takedown" },

	[19] = { Vector( -27.57, 8.42, -1.44 ), Angle( 0, 0, 0 ), "rx2700_feet" },
	[20] = { Vector( 27.57, 8.42, -1.44 ), Angle( 0, 0, 0 ), "rx2700_feet" },

	[21] = { Vector( -29.4, -6.5, -1.44 ), Angle( 0, 90, 0 ), "rx2700_feet" },
	[22] = { Vector( 29.44, -6.5, -1.44 ), Angle( 0, -90, 0 ), "rx2700_feet" },

}

COMPONENT.Sections = {
	["auto_rx2700_main"] = {
		{
			{ 1, "_1" }, { 2, "_2" },
			{ 3, "_1" }, { 4, "_2" },
			{ 5, "_1" }, { 6, "_2" },
			{ 7, "_1" }, { 8, "_2" },
			{ 9, "_1" }, { 10, "_2" },
			{ 11, "_1" }, { 12, "_2" },
			{ 13, W }, { 14, A },
			{ 15, W }, { 16, W },
			{ 17, W }, { 18, W },
			{ 19, W }, { 20, W },
			{ 21, W }, { 22, W },
		},
		[2] = { { 1, "_1" }, { 11, "_1" }, { 5, "_1" }, { 7, "_1" }, { 4,"_1" }, { 10,"_1" } },
		[3] = { { 2,"_1" }, { 12,"_1" }, { 6,"_1" }, { 8,"_1" }, { 3, "_1" }, { 9, "_1" } },
		[4] = { { 1, "_2" }, { 11, "_2" }, { 5, "_2" }, { 7, "_2" }, { 4,"_2" }, { 10,"_2" } },
		[5] = { { 2,"_2" }, { 12,"_2" }, { 6,"_2" }, { 8,"_2" }, { 3, "_2" }, { 9, "_2" } },
	},
	["auto_rx2700_feet"] = {
		[1] = { { 19, "_1" }, { 20,"_2" }, { 21, "_1" }, { 22, "_2" } },
	},
	["auto_rx2700_traffic"] = {
		[1] = { { 14, A } },
	},
	["auto_rx2700_center"] = {
		[1] = { { 13, "_1" }, { 14, A } },
		[2] = { { 13,"_2" }, { 14, A } },
	},
	["auto_rx2700_inner"] = {
		[1] = { { 1, "_1" }, { 11, "_1" } },
		[2] = { { 2,"_1" }, { 12,"_1" } },
		[3] = { { 1, "_2" }, { 11, "_2" } },
		[4] = { { 2,"_2" }, { 12,"_2" } },
	},
	["auto_rx2700_mid"] = {
		[1] = { { 3, "_1" }, { 9, "_1" } },
		[2] = { { 4,"_1" }, { 10,"_1" } },
		[3] = { { 3, "_2" }, { 9, "_2" } },
		[4] = { { 4,"_2" }, { 10,"_2" } },
	},
	["auto_rx2700_outer"] = {
		[1] = { { 5, "_1" }, { 7, "_1" } },
		[2] = { { 6,"_1" }, { 8,"_1" } },
		[3] = { { 5, "_2" }, { 7, "_2" } },
		[4] = { { 6,"_2" }, { 8,"_2" } },
	},
	["auto_rx2700_takedown"] = {
		[1] = { { 15, W }, { 17, W } },
		[2] = { { 16, W }, { 18, W } },
	},
	["auto_rx2700_main_traffic"] = {
		[1] = { { 9, "_3" }, { 11, "_3" }, { 14, "_3" }, { 12, "_3" }, { 10, "_3" } },
		[2] = { { 9, "_3" } },
		[3] = { { 9, "_3" }, { 11, "_3" } },
		[4] = { { 9, "_3" }, { 11, "_3" }, { 14, "_3" } },
		[5] = { { 9, "_3" }, { 11, "_3" }, { 14, "_3" }, { 12, "_3" } },
		[6] = { { 10, "_3" } },
		[7] = { { 12, "_3" }, { 10, "_3" } },
		[8] = { { 14, "_3" }, { 12, "_3" }, { 10, "_3" } },
		[9] = { { 11, "_3" }, { 14, "_3" }, { 12, "_3" }, { 10, "_3" } },
		[10] = { { 14, "_3" } },
		[11] = { { 11, "_3" }, { 14, "_3" }, { 12, "_3" } },
	}
}

COMPONENT.Patterns = {
	["auto_rx2700_main"] = {
		["all"] = { 1 },
		["stage_1"] = {
			2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5
		}
	},
	["auto_rx2700_traffic"] = {
		["stage_1"] = { 1, 1, 1, 0 }
	},
	["auto_rx2700_feet"] = {
		["stage_1"] = { 1 },
	},
	["auto_rx2700_center"] = {
		["stage_3"] = { 1, 1, 0, 2, 2, 0, 1, 0, 2, 0, 0 }
	},
	["auto_rx2700_inner"] = {
		["stage_2"] = { 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4 },
		["stage_3"] = { 1, 2, 0, 2, 1, 0, 3, 4, 0, 4, 3, 0 }
	},
	["auto_rx2700_mid"] = {
		["stage_2"] = { 2, 2, 2, 0, 0, 1, 1, 1, 0, 1, 0, 2, 0, 3, 3, 3, 0, 0, 4, 4, 4, 0, 3, 0, 4, 0 },
		["stage_3"] = {
			1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 1, 2, 2, 1, 1, 2, 2, 0, 
			3, 4, 3, 4, 3, 4, 3, 4, 3, 4, 3, 3, 4, 4, 3, 3, 4, 4, 0, 
		}
	},
	["auto_rx2700_outer"] = {
		["stage_2"] = { 0, 1, 0, 1, 0, 0, 2, 0, 2, 0, 0, 3, 0, 3, 0, 0, 4, 0, 4, 0 },
		["stage_3"] = { 1, 2, 3, 4 },
	},
	["auto_rx2700_takedown"] = {
		["stage_3"] = { 2, 2, 1, 1 }
	},
	["auto_rx2700_main_traffic"] = {
		["left"] = { 6, 6, 6, 7, 7, 7, 8, 8, 8, 9, 9, 9, 1, 1, 1, 1, 1, 0, 0, 0, 0 },
		["right"] = { 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5, 1, 1, 1, 1, 1, 0, 0, 0, 0 },
		["diverge"] = { 10, 10, 10, 10, 11, 11, 11, 11, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0 },
	}
}

COMPONENT.TrafficDisconnect = {
	["auto_rx2700_main_traffic"] = {
		9, 11, 14, 12, 10
	}
}

COMPONENT.Modes = {
	Primary = {
			M1 = {
				["auto_rx2700_main"] = "stage_1",
				["auto_rx2700_feet"] = "stage_1",
				["auto_rx2700_traffic"] = "stage_1",
			},
			M2 = {
				["auto_rx2700_inner"] = "stage_2",
				["auto_rx2700_mid"] = "stage_2",
				["auto_rx2700_feet"] = "stage_1",
				["auto_rx2700_outer"] = "stage_2",
			},
			M3 = {
				["auto_rx2700_center"] = "stage_3",
				["auto_rx2700_inner"] = "stage_3",
				["auto_rx2700_mid"] = "stage_3",
				["auto_rx2700_feet"] = "stage_1",
				["auto_rx2700_outer"] = "stage_3",
				["auto_rx2700_takedown"] = "stage_3",
			}
	},
	Auxiliary = {
			C = {
				["auto_rx2700_feet"] = "stage_1",
			},
			L = {
				["auto_rx2700_main_traffic"] = "left"
			},
			R = {
				["auto_rx2700_main_traffic"] = "right"
			},
			D = {
				["auto_rx2700_main_traffic"] = "diverge"
			}
	},
	Illumination = {
		R = {
			{ 18, W }
		},
		L = {
			{ 17, W }
		},
		F = {
			{ 15, W }, { 16, W }
		},
		T = {
			{ 15, W }, { 16, W }
		}
	}
}

EMVU:AddAutoComponent( COMPONENT, name )