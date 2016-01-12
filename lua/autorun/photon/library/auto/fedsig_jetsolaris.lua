

local COMPONENT = {}

AddCSLuaFile()

local A = "AMBER"
local R = "RED"
local DR = "D_RED"
local B = "BLUE"
local W = "WHITE"
local CW = "C_WHITE"
local SW = "S_WHITE"
local G = "GREEN"

local name = "Federal Signal Jetsolaris"

local COMPONENT = {}

COMPONENT.Model = "models/schmal/fedsig_jetsolaris.mdl"
COMPONENT.Skin = 0
COMPONENT.Lightbar = true
COMPONENT.NotLegacy = true
COMPONENT.Bodygroups = {
}
COMPONENT.Category = "Lightbar"
COMPONENT.DefaultColors = {
	[1] = "RED", -- 2+4+8
	[2] = "BLUE", -- 1
	[3] = "RED", -- 3+5+9
	[4] = "RED", -- 10
	[5] = "BLUE", -- 12
	[6] = "RED", -- 11
	[7] = "WHITE", -- 6
	[8] = "WHITE" -- 7
}

COMPONENT.Meta = {
	legend_forward = {
		AngleOffset = -90,
		W = 7.4,
		H = 7.4,
		Sprite = "sprites/emv/legend_wide",
		Scale = 1.5,
		WMult = 1.5,
	},
	legend_forward_nar = {
		AngleOffset = -90,
		W = 7.4,
		H = 7.4,
		Sprite = "sprites/emv/legend_narrow",
		Scale = 1.5,
		WMult = 1,
	},
	legend_rear_nar = {
		AngleOffset = 90,
		W = 7.2,
		H = 7.2,
		Sprite = "sprites/emv/legend_narrow",
		Scale = 1.5,
		WMult = 1,
	},
	legend_rear = {
		AngleOffset = 90,
		W = 7.2,
		H = 7.2,
		Sprite = "sprites/emv/legend_wide",
		Scale = 1.5,
		WMult = 1.5,
	},
}

COMPONENT.Positions = {

	[1] = { Vector( 0, 6.11, 0 ), Angle( 0, 0, 0 ), "legend_forward" },
	[2] = { Vector( -6.58, 6.11, 0 ), Angle( 0, 0, 0 ), "legend_forward" },
	[3] = { Vector( 6.58, 6.11, 0 ), Angle( 0, 0, 0 ), "legend_forward" },

	[4] = { Vector( -12.75, 3.71, 0.06 ), Angle( 0, 74, 0 ), "legend_forward_nar", 1 },
	[5] = { Vector( 12.75, 3.71, 0.06 ), Angle( 0, -74, 0 ), "legend_forward_nar", 2 },

	[6] = { Vector( -13.24, 0, 0.06 ), Angle( 0, 90, 0 ), "legend_forward_nar" },
	[7] = { Vector( 13.24, 0, 0.06 ), Angle( 0, -90, 0 ), "legend_forward_nar" },

	[8] = { Vector( -12.75, -3.71, 0.06 ), Angle( 0, -74, 0 ), "legend_rear_nar", 3 },
	[9] = { Vector( 12.75, -3.71, 0.06 ), Angle( 0, 74, 0 ), "legend_rear_nar", 4 },

	[10] = { Vector( -6.58, -6.11, 0 ), Angle( 0, 0, 0 ), "legend_rear" },
	[11] = { Vector( 6.58, -6.11, 0 ), Angle( 0, 0, 0 ), "legend_rear" },
	[12] = { Vector( 0, -6.11, 0 ), Angle( 0, 0, 0 ), "legend_rear" },

}

COMPONENT.Sections = {
	["auto_fedsig_jetsolaris"] = {
		[1] = { { 1, "_2" }, { 12, "_5" } },
		[2] = { { 3, "_3" }, { 10, "_4" } },
		[3] = { { 5, "_3" }, { 8, "_1" } },
		[4] = { { 6, "_7" }, { 7, "_8" } },
		[5] = { { 4, "_1" }, { 9, "_3" } },
		[6] = { { 2, "_1" }, { 11, "_6" } },
	}
}

COMPONENT.Patterns = {
	["auto_fedsig_jetsolaris"] = {
		["circle_2"] = { 1, 2, 3, 4, 5, 6 },
		["circle_pinwheel"] = { { 1, 4 }, { 2, 5 }, { 3, 6 } }
	}
}

COMPONENT.TrafficDisconnect = { 

}

COMPONENT.Modes = {
	Primary = {
			M1 = {
				["auto_fedsig_jetsolaris"] = "circle_pinwheel"
			},
			M2 = {

			},
			M3 = {

			},
			ALERT = {

			}
		},
	Auxiliary = {
			C = {

			},
			L = {

			},
			R = {

			},
			D = {

			}
		},
	Illumination = {
		T = {
		},
		F = {
		},
		L = {
		},
		R = {
		}
	}
}

EMVU:AddAutoComponent( COMPONENT, name )