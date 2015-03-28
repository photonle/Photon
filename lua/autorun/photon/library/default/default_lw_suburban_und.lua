AddCSLuaFile()

local name = "Chevrolet Suburban Police Cruiser Undercover"

local A = "AMBER"
local R = "RED"
local DR = "D_RED"
local B = "BLUE"
local W = "WHITE"
local CW = "C_WHITE"
local SW = "S_WHITE"

local EMV = {}

EMV.Siren = 7

EMV.Color = Color( 16, 16, 16 )
EMV.Skin = 0

EMV.BodyGroups = {}

EMV.Props = {}

EMV.Meta = {
	f_round = {
		AngleOffset = -90,
		W = 8.1,
		H = 7.5,
		Sprite = "sprites/emv/emv_whelen_src",
		Scale = 1.4
	},
	r_3led = {
		AngleOffset = 90,
		W = 6,
		H = 6,
		Sprite = "sprites/emv/emv_whelen_mini_3",
		Scale = 1.2
	},
	f_3led = {
		AngleOffset = -90,
		W = 5.9,
		H = 5.8,
		Sprite = "sprites/emv/emv_whelen_mini_3",
		Scale = 1.2
	},
	skirt = {
		AngleOffset = -90,
		W = 5.9,
		H = 5.8,
		Sprite = "sprites/emv/emv_whelen_mini_3",
		Scale = 1.2
	},
	grille = {
		AngleOffset = -90,
		W = 5.98,
		H = 5.8,
		Sprite = "sprites/emv/emv_whelen_mini_3",
		Scale = 1.2,
		VisRadius = 20
	},
	headlight = {
		AngleOffset = -90,
		W = 7,
		H = 7,
		Sprite = "sprites/emv/light_circle",
		Scale = 3,
		VisRadius = 0
	},
	reverse_lights = {
		AngleOffset = 90,
		W = 4,
		H = 3,
		Sprite = "sprites/emv/square_src",
		Scale = 1
	},
	tail_light = {
		AngleOffset = 90,
		W = 5,
		H = 5.7,
		Sprite = "sprites/emv/square_src",
		Scale = 1.8
	},
}

EMV.Positions = {


	[1] = { Vector(-18.8, 40.2, 83), Angle(0,0,0), "f_3led" },
	[2] = { Vector( 18.8, 40.2, 83), Angle(0,0,0), "f_3led" },

	[3] = { Vector(-12.9, 40.2, 83), Angle(0,0,0), "f_3led" },
	[4] = { Vector( 12.9, 40.2, 83), Angle(0,0,0), "f_3led" },

	[5] = { Vector(-17.62, 133.3, 50.8), Angle(0,8,0), "grille" },
	[6] = { Vector( 17.62, 133.3, 50.8), Angle(0,-8,0), "grille" },

	[7] = { Vector(-9.7, 134.29, 50.8), Angle(0,7,0), "grille" },
	[8] = { Vector( 9.7, 134.29, 50.8), Angle(0,-7,0), "grille" },

	[9] = { Vector( -40, -124.8, 53.1 ), Angle( 0,-21,-2 ), "reverse_lights" },
	[10] = { Vector( 40, -124.8, 53.1 ), Angle( 0,21, -2 ), "reverse_lights" },

	[11] = { Vector( -37.8, 124.8, 48.15 ), Angle( 0,0,0 ), "headlight" },
	[12] = { Vector( 37.8, 124.8, 48.15 ), Angle( 0,0,0 ), "headlight" },

}


EMV.Sections = {
	["grille"] = {
		{
			{ 5, R }, { 6, B }, { 7, R }, { 8, B }, 
		},
		{ { 6, B } },
		{ { 8, B } },
		{ { 7, R } },
		{ { 5, R } },
		{
			{ 5, R }, { 6, B }, 
		},
		{
			{ 7, R }, { 8, B }, 
		},
	},
	["dash"] = {
		{ { 1, R }, { 2, B }, { 3, B }, { 4, B }, },
		{ { 1, R }, { 2, B }, },
		{ { 3, R }, { 4, B }, },
	},
	["reverse"] = {
		{ { 9, R } },
		{ { 10, B } },
		{ { 9, R }, { 10, B } }
	},
	["headlights"] = {
		{ { 11, SW, {16, 0, 0} }, { 12, SW, {16, 0, 10} }, },
	}
}

EMV.Patterns = {
	["grille"] = {
		["all"] = {
			1
		},
		["code1"] = {
			2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5, 0, 5, 5, 5, 4, 4, 4, 3, 3, 3, 2, 2, 2, 0
		},
		["code2"] = {
			6, 6, 6, 0, 6, 6, 6, 0, 7, 7, 7, 0, 7, 7, 7, 0
		},
		["code3"] = {
			2, 3, 4, 5, 0, 5, 4, 3, 2, 1, 0, 1, 0, 1, 0, 6, 6, 0, 7, 7, 0, 6, 6, 0, 7, 7, 0, 6, 6, 0, 7, 7, 0
		}
	},
	["dash"] = {
		["all"] = {
			1
		},
		["code3"] = {
			2, 3, 1, 3, 2, 1
		}
	},
	["reverse"] = {
		["code3"] = {
			1, 0, 1, 0, 2, 0, 2, 0
		},
		["code1"] = {
			1, 1, 0, 2, 2, 0
		},
		["cruise"] = {
			3
		}
	},
	["headlights"] = {
		["wigwag"] = {
			1
		}
	}
}


EMV.Sequences = {
	Sequences = {
		{
			Name = "CODE 1",
			Components = {
				["reverse"] = "code1",
			}
		},
		{
			Name = "CODE 2",
			Components = {
				["grille"] = "code2",
				["reverse"] = "code1",
			}
		},
		{
			Name = "CODE 3",
			Components = {
				["grille"] = "code3",
				["dash"] = "code3",
				["reverse"] = "code3",
				["headlights"] = "wigwag"
			},
			Disconnect = {
				14, 15
			}
		}
	}
}

Photon.EMVLibrary[name] = EMV