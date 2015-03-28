AddCSLuaFile()

local name = "Holden HSV W427 Police"

local A = "AMBER"
local R = "RED"
local DR = "D_RED"
local B = "BLUE"
local W = "WHITE"
local CW = "C_WHITE"
local SW = "S_WHITE"

local EMV = {}

EMV.Siren = 11

EMV.Color = nil
EMV.Skin = 0

EMV.BodyGroups = {}

EMV.Props = {}

EMV.Meta = {
	halogen_main = {
		AngleOffset = "R",
		Scale = 3,
		W = 10,
		H = 8,
		Sprite = "sprites/emv/emv_lightglow",
		Speed = 10,
		VisRadius = 1
	},
	halogen_alt = {
		AngleOffset = "R",
		Scale = 3,
		W = 10,
		H = 8,
		Sprite = "sprites/emv/emv_lightglow",
		Speed = -10.5,
		VisRadius = 1
	},
	halogen_offset = {
		AngleOffset = "R",
		Scale = 3,
		W = 10,
		H = 8,
		Sprite = "sprites/emv/emv_lightglow",
		Speed = -11,
		VisRadius = 1
	},
	grille_light = {
		AngleOffset = -90,
		Sprite = "sprites/emv/tdm_grille",
		W = 4.3,
		H = 3.6
	},
	headlight = {
		AngleOffset = -90,
		W = 6,
		H = 6,
		Sprite = "sprites/emv/light_circle",
		Scale = 2,
		VisRadius = 5
	},
	head_running = {
		AngleOffset = -90,
		W = 4.4,
		H = 4.4,
		Sprite = "sprites/emv/light_circle",
		Scale = 1.5,
		VisRadius = 5
	},
	reverse = {
		AngleOffset = 90,
		Sprite = "sprites/emv/light_circle",
		W = 5,
		H = 5,
		VisRadius = 10
	},
	tail_brake = {
		AngleOffset = 90,
		Sprite = "sprites/emv/light_circle",
		W = 5,
		H = 5,
		VisRadius = 10,
		Scale = 2
	},
}

EMV.Positions = {

	[1] = { Vector( -10.45, -13.06, 79.4 ), Angle( 0, 0, 0 ), "halogen_main" },
	[2] = { Vector( 10.45, -13.06, 79.4 ), Angle( 0, 0, 0 ), "halogen_alt" },

	[3] = { Vector( -15.85, -13.06, 79.4 ), Angle( 0, 0, 0 ), "halogen_main" },
	[4] = { Vector( 15.85, -13.06, 79.4 ), Angle( 0, 0, 0 ), "halogen_alt" },

	[5] = { Vector( -21.25, -13.06, 79.4 ), Angle( 0, 0, 0 ), "halogen_main" },
	[6] = { Vector( 21.25, -13.06, 79.4 ), Angle( 0, 0, 0 ), "halogen_alt" },

	[7] = { Vector( -26.45, -13.06, 79.4 ), Angle( 0, 0, 0 ), "halogen_main" },
	[8] = { Vector( 26.45, -13.06, 79.4 ), Angle( 0, 0, 0 ), "halogen_alt" },

	[9] = { Vector( -6.25, 124.7, 27.9 ), Angle( 0, 0, 0 ), "grille_light" },
	[10] = { Vector( 6.25, 124.7, 27.9 ), Angle( 0, 0, 0 ), "grille_light" },

	[11] = { Vector( -25.9, 109.8, 33.7 ), Angle( -5.47, 14.52, 20.2 ), "headlight" },
	[12] = { Vector( 25.9, 109.8, 33.7 ), Angle( 5.47, -14.52, 20.2 ), "headlight" },

	[13] = { Vector( -32.7, 106.56, 34.03 ), Angle( 0, 9.3, 0 ), "head_running" },
	[14] = { Vector( 32.7, 106.56, 34.03 ), Angle( 0, -9.3, 0 ), "head_running" },

	[15] = { Vector( -31.31, -108.6, 43.03 ), Angle( 0, -16.3, 0 ), "reverse" },
	[16] = { Vector( 31.31, -108.6, 43.03 ), Angle( 0, 16.3, 0 ), "reverse" },

	[17] = { Vector( -35.49, -104.59, 42.87 ), Angle( 0, -26.5, 0 ), "tail_brake" },
	[18] = { Vector( 35.49, -104.59, 42.87 ), Angle( 0, 26.5, 0 ), "tail_brake" },

}


EMV.Sections = {
	["lightbar"] = {
		{ { 1, R }, { 2, B }, { 3, R }, { 4, B }, { 5, R }, { 6, B }, { 7, R }, { 8, B } },
		{ { 3, R }, { 4, B }, { 5, R }, { 6, B }, },
		{ { 1, R }, { 2, B }, { 7, R }, { 8, B } },
	},
	["grille_lights"] = {
		{ { 9, R }, { 10, B } }, 
		{ { 10, B } }, 
		{ { 9, R } }, 
	},
	["headlights"] = {
		{ { 11, SW, { 16, .5, 10 } }, { 12, SW, { 12, .5, 0 } } }, 
	},
	["head_running"] = {
		{ { 13, CW } },
		{ { 14, CW } },
	},
	["rear_combo"] = {
		{ { 15, SW }, { 16, SW } },
		{ { 17, DR }, { 18, DR } },
	}
}

EMV.Patterns = {
	["lightbar"] = {
		["default"] = {
			1
		},
		["priority"] = {
			1
		},
		["warn"] = {
			2, 2, 2, 2, 2, 2, 2, 2, 2,
			3, 3, 3, 3, 3, 3, 3, 3, 3,
		}
	},
	["grille_lights"] = {
		["default"] = {
			1
		},
		["alt"] = {
			2, 2, 2, 3, 3, 3
		},
		["priority"] = {
			2, 0, 2, 0, 2, 0,
			3, 0, 3, 0, 3, 0,
			2, 0, 2, 0, 2, 0,
			3, 0, 3, 0, 3, 0,
			2, 0, 2, 0, 2, 0,
			3, 0, 3, 0, 3, 0,
			3, 3, 2, 2,
			3, 3, 2, 2,
			3, 3, 2, 2,
			3, 3, 2, 2,
			3, 3, 2, 2,
			3, 3, 2, 2,
		}
	},
	["headlights"] = {
		["wig-wag"] = {
			1
		},
	},
	["head_running"] = {
		["flash"] = {
			1, 0, 1, 0,
			2, 0, 2, 0,
			1, 0, 1, 0,
			2, 0, 2, 0,
			1, 0, 1, 0,
			2, 0, 2, 0,
			1, 1, 2, 2,
			1, 1, 2, 2,
			1, 1, 2, 2,
			1, 1, 2, 2,
		}
	},
	["rear_combo"] = {
		["priority"] = {
			1, 1, 1, 2, 2, 2
		}
	}
}


EMV.Sequences = {
	Sequences = {
		{
			Name = "WARN",
			Components = {
				["lightbar"] = "warn",
				["grille_lights"] = "alt",
			}
		},
		{
			Name = "PRIORITY",
			Components = {
				["headlights"] = "wig-wag",
				["head_running"] = "flash",
				["grille_lights"] = "priority",
				["lightbar"] = "default",
				["rear_combo"] = "priority"
			},
			Disconnect = { 1, 2, 3, 4, 7, 8, 9, 10 }
		}
	}
}

Photon.EMVLibrary[name] = EMV