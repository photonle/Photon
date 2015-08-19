AddCSLuaFile()

local A = "AMBER"
local R = "RED"
local DR = "D_RED"
local B = "BLUE"
local W = "WHITE"
local CW = "C_WHITE"
local SW = "S_WHITE"
local G = "GREEN"

local name = "Federal Signal Arjent"

local COMPONENT = {}

COMPONENT.Model = "models/schmal/fedsig_arjent/arjent_lightbar.mdl"
COMPONENT.Skin = 0
COMPONENT.Bodygroups = {}

COMPONENT.Meta = {
	arjent_forward = {
		AngleOffset = -90,
		W = 6.75,
		H = 6.75,
		Sprite = "sprites/emv/arjent_main",
		Scale = 1.25,
		WMult = 1.5,
	},
	arjent_takedown = {
		AngleOffset = -90,
		W = 7.5,
		H = 7.1,
		Sprite = "sprites/emv/arjent_takedown",
		Scale = 2,
		WMult = 1.5,
	},
	arjent_alley = {
		AngleOffset = -90,
		W = 2.25,
		H = 2.25,
		Sprite = "sprites/emv/light_circle",
		Scale = 2,
		WMult = .9,
	},
	arjent_rear = {
		AngleOffset = 90,
		W = 6.75,
		H = 6.75,
		Sprite = "sprites/emv/arjent_main",
		Scale = 1.25,
		WMult = 1.5,
	},
}

COMPONENT.Positions = {

	[1] = { Vector( -10.4, 8.85, 2.17 ), Angle( 0, 0, 0 ), "arjent_forward" },
	[2] = { Vector( 10.4, 8.85, 2.17 ), Angle( 0, 0, 0 ), "arjent_forward" },

	[3] = { Vector( -16.79, 8.85, 2.17 ), Angle( 0, 0, 0 ), "arjent_forward" },
	[4] = { Vector( 16.79, 8.85, 2.17 ), Angle( 0, 0, 0 ), "arjent_forward" },

	[5] = { Vector( -23.85, 7.61, 2.17 ), Angle( 0, 20, 0 ), "arjent_forward" },
	[6] = { Vector( 23.85, 7.61, 2.17 ), Angle( 0, -20, 0 ), "arjent_forward" },

	[7] = { Vector( -30.17, 3.9, 2.17 ), Angle( 0, 45, 0 ), "arjent_forward" },
	[8] = { Vector( 30.17, 3.9, 2.17 ), Angle( 0, -45, 0 ), "arjent_forward" },

	[9] = { Vector( -30.17, -4.19, 2.17 ), Angle( 0, -45, 0 ), "arjent_rear" },
	[10] = { Vector( 30.17, -4.19, 2.17 ), Angle( 0, 45, 0 ), "arjent_rear" },

	[11] = { Vector( -23.85, -7.92, 2.17 ), Angle( 0, -20, 0 ), "arjent_rear" },
	[12] = { Vector( 23.85, -7.92, 2.17 ), Angle( 0, 20, 0 ), "arjent_rear" },

	[13] = { Vector( -16.79, -9.17, 2.17 ), Angle( 0, 0, 0 ), "arjent_rear" },
	[14] = { Vector( 16.79, -9.17, 2.17 ), Angle( 0, 0, 0 ), "arjent_rear" },

	[15] = { Vector( -10.43, -9.17, 2.17 ), Angle( 0, 0, 0 ), "arjent_rear" },
	[16] = { Vector( 10.43, -9.17, 2.17 ), Angle( 0, 0, 0 ), "arjent_rear" },

	[17] = { Vector( -3.43, -9.17, 2.17 ), Angle( 0, 0, 0 ), "arjent_rear" },
	[18] = { Vector( 3.43, -9.17, 2.17 ), Angle( 0, 0, 0 ), "arjent_rear" },

	[19] = { Vector( -3.51, 8.85, 2.05 ), Angle( 0, 0, 0 ), "arjent_takedown" },
	[20] = { Vector( 3.51, 8.85, 2.05 ), Angle( 0, 0, 0 ), "arjent_takedown" },

	[21] = { Vector( -33.15, 0.18, 2.14 ), Angle( 0, 72.9, 0 ), "arjent_alley" },
	[22] = { Vector( 33.15, 0.18, 2.14 ), Angle( 0, -72.9, 0 ), "arjent_alley" },

}

COMPONENT.Sections = {
	["auto_fedsig_arjent"] = {
		{
			{ 1, R }, { 2, B }, { 3, R }, { 4, B }, { 5, R }, { 6, B }, { 7, R }, { 8, B },
			{ 9, R }, { 10, B }, { 11, R }, { 12, B }, { 13, A }, { 14, A }, { 15, A }, { 16, A }, { 17, A }, { 18, A },
			{ 19, SW }, { 20, SW }, { 21, SW }, { 22, SW }, 
		},
	},
	["auto_fedsig_arjent_steady"] = {
		[1] = {
			{ 3, R }, { 4, B }
		}
	},
	["auto_fedsig_arjent_rear"] = {
		[1] = { { 15, A } },
		[2] = { { 16, A } }
	}
}

COMPONENT.Patterns = {
	["auto_fedsig_arjent"] = {
		["all"] = { 1 },
	},
	["auto_fedsig_arjent_steady"] = {
		["on"] = { 1 },
	},
	["auto_fedsig_arjent_rear"] = {
		["code1"] = { 1, 1, 1, 1, 0, 2, 2, 2, 2, 0 }
	}
}

COMPONENT.TrafficDisconnect = { 
	["auto_fedsig_arjent_signalmaster"] = {
		
	}
}

COMPONENT.Modes = {
	Primary = {
		M1 = {
			["auto_fedsig_arjent_steady"] = "on",
			["auto_fedsig_arjent_rear"] = "code1"
		},
		M2 = {
			["auto_fedsig_arjent"] = "all",
		},
		M3 = {
			["auto_fedsig_arjent"] = "all",
		}
	},
	Auxiliary = {
		L = {},
		R = {},
		D = {}
	},
	Illumination = {
		 T = {
		 	{ 1, W }, { 2, W }
		 }
	}
}

EMVU:AddAutoComponent( COMPONENT, name )