AddCSLuaFile()

local name = "Chevrolet Tahoe Secret Service"

local A = "AMBER"
local R = "RED"
local DR = "D_RED"
local B = "BLUE"
local W = "WHITE"
local CW = "C_WHITE"
local SW = "S_WHITE"

local EMV = {}

EMV.Siren = 3

EMV.Color = Color( 16, 16, 16 )
EMV.Skin = 0

EMV.BodyGroups = {}

EMV.Props = {}

EMV.Meta = {
	r_3led = {
		AngleOffset = 90,
		W = 5.3,
		H = 5.3,
		Sprite = "sprites/emv/emv_whelen_mini_3",
		Scale = 1.2
	},
	f_3led = {
		AngleOffset = -90,
		W = 4.6,
		H = 5.3,
		Sprite = "sprites/emv/emv_whelen_mini_3",
		Scale = 1.2
	},
	bull_3led = {
		AngleOffset = -90,
		W = 4.6,
		H = 5.3,
		Sprite = "sprites/emv/emv_whelen_mini_3",
		Scale = 1.2
	},
	f_win = {
		AngleOffset = -90,
		W = 7.4,
		H = 7.4,
		Sprite = "sprites/emv/emv_whelen_src",
		Scale = 1.5
	},
	headlight = {
		AngleOffset = -90,
		W = 6,
		H = 6,
		Sprite = "sprites/emv/light_circle",
		Scale = 2.5,
		VisRadius = 0
	},
	reverse_lights = {
		AngleOffset = 90,
		W = 4,
		H = 4,
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
	 [1] = { Vector(-3.7,-2.9,89.2), Angle(0,0,0), "takedown" },
	 [2] = { Vector(3.8,-2.9,89.2), Angle(0,0,0), "takedown" },

	 [3] = { Vector(-10.4,-1.4,89.2), Angle(0,0,0), "f_rect" },
	 [4] = { Vector(10.4,-1.4,89.2), Angle(0,0,0), "f_rect" },

	 [5] = { Vector(-17.23,-1.4,89.2), Angle(0,0,0), "f_round" },
	 [6] = { Vector(17.23,-1.4,89.2), Angle(0,0,0), "f_round" },

	 [7] = { Vector(-24.4,-2,89.2), Angle(0,28.2,0), "f_ang" },
	 [8] = { Vector(24.4,-2,89.2), Angle(0,-28.2,0), "f_ang" },

	 [9] = { Vector(-27.9,-7.2,89.2), Angle(0,90,0), "side" },
	 [10] = { Vector(27.9,-7.2,89.2), Angle(0,-90,0), "side" },

	[11] = { Vector(-24.4,-12.4,89.2), Angle(0,-28.2,0), "r_ang" },
	[12] = { Vector(24.4,-12.4,89.2), Angle(0,28.2,0), "r_ang" },

	[13] = { Vector(-17.23,-13,89.2), Angle(0,0,0), "r_round" },
	[14] = { Vector(17.23,-13,89.2), Angle(0,0,0), "r_round" },

	[15] = { Vector(-10.4,-13,89.2), Angle(0,0,0), "r_rect" },
	[16] = { Vector(10.4,-13,89.2), Angle(0,0,0), "r_rect" },

	[17] = { Vector(-3.55,-13,89.2), Angle(0,0,0), "r_rect" },
	[18] = { Vector(3.55,-13,89.2), Angle(0,0,0), "r_rect" },

	-- REAR TOP LEDS --

	[19] = { Vector(-15.5,-102,82.15), Angle(0,-6,0), "r_3led" }, --  20
	[20] = { Vector(15.5,-102,82.15), Angle(0,6,0), "r_3led" }, --  19

	[21] = { Vector(-20.35,-101.4,82.15), Angle(0,-6,0), "r_3led" }, --  22
	[22] = { Vector(20.35,-101.4,82.15), Angle(0,6,0), "r_3led" }, --  21

	[23] = { Vector(-25.2,-100.82,82.15), Angle(0,-6,0), "r_3led" }, --  24
	[24] = { Vector(25.2,-100.82,82.15), Angle(0,6,0), "r_3led" }, --  23

	-- BOTTOM BUMPER LEDS (WAIT TIL WOLFIE FIXES)--

	[25] = { Vector(-35,-117,30), Angle(0,-16,0), "r_3led" }, --  26
	[26] = { Vector(35,-117,30), Angle(0,16,0), "r_3led" }, --  25

	-- GRILLE LIGHTS --

	[27] = { Vector(-19.73,111.5,39.35), Angle(0,-2,0), "f_3led" }, --  28
	[28] = { Vector(19.73,111.5,39.35), Angle(0,2,0), "f_3led" }, --  27

	[29] = { Vector(-21.5,110.2,47.4), Angle(0,0,0), "f_3led" }, --  30
	[30] = { Vector(21.5,110.2,47.4), Angle(0,0,0), "f_3led" }, --  29

	-- BULLBAR LEDS --

	[31] = { Vector(-23.5,121.8,31.15), Angle(90,90,0), "f_3led" }, --  32
	[32] = { Vector(23.4,121.8,31.15), Angle(90,-90,0), "f_3led" }, --  31

	-- FRONT WINDOW --

	[33] = { Vector(-26.9,28.8,75.55), Angle(0,0,0), "f_win" }, --  34
	[34] = { Vector(26.9,28.8,75.55), Angle(0,0,0), "f_win" }, --  33

	-- HEADLIGHTS --

	[35] = { Vector( -36.5, 100.5, 46 ), Angle( 0,0,0 ), "headlight" },
	[36] = { Vector( 36.5, 100.5, 46 ), Angle( 0,0,0 ), "headlight" },

	-- TAIL LIGHTS --

	[37] = { Vector( -40, -108, 45.7 ), Angle( 0,-37,0 ), "tail_light" },
	[38] = { Vector( 40, -108, 45.7 ), Angle( 0,37,0 ), "tail_light" },

	-- REVERSE LIGHTS --

	[39] = { Vector( -39.6, -108.2, 51 ), Angle( 0,-37,0 ), "reverse_lights" },
	[40] = { Vector( 39.6, -108.2, 51 ), Angle( 0,37,0 ), "reverse_lights" },

}

EMV.Sections = {
	["front_window"] = {
		{ { 34, R } },
		{ { 33, B } },
		{ { 33, B }, { 34, R } },
	},
	["rear"] = {
		{ { 23, R }, },
		{ { 21, R }, },
		{ { 19, R }, },
		{ { 20, B }, },
		{ { 22, B }, },
		{ { 24, B }, },
		{ { 19, R }, { 20, B }, },
		{ { 21, R }, { 22, B }, },
		{ { 23, R }, { 24, B }, },
		{ { 23, R }, { 20, B }, },
		{ { 19, R }, { 24, B }, },
	},
	["bullbar"] = {
		{ { 31, W } },
		{ { 32, W } },
		{ { 31, W }, { 32, W }, },
	},
	["grille"] = {
		{ { 27, R } },
		{ { 28, B } },
		{ { 29, R } },
		{ { 30, B } },
		{ { 28, B }, { 27, R } },
		{ { 30, B }, { 29, R } },
	},
	["takedown"] = {
		{ { 1, W } },
		{ { 2, W } },
		{ { 1, W }, { 2, W } },
	},
	["headlights"] = {
		{ { 35, SW, { 16, .25, 0 } }, { 36, SW, { 16, .25, 10 } }, }
	},
	["tail_lights"] = {
		{ { 37, R } },
		{ { 38, R } },
	},
	["reverse_lights"] = { -- HIDEAWAYS MOTHERFUCKER
		{ { 39, B } },
		{ { 40, B } },
	}
}

EMV.Patterns = {
	["front_window"] = {
		["alt"] = {
			1, 1, 0, 2, 2, 0
		},
		["code3"] = {
			1, 0, 1, 0, 2, 0, 2, 0
		}
	},
	["rear"] = {
		["left"] = {
			11, 11, 8, 8, 10, 10, 0, 10, 10, 0, 10, 10, 0, 10, 10, 0, 0, 0, 0, 0
		},
		["right"] = {
			10, 10, 8, 8, 11, 11, 0, 11, 11, 0, 11, 11, 0, 11, 11, 0, 0, 0, 0, 0
		},
		["diverge"] = {
			7, 7, 8, 8, 9, 9, 0, 9, 9, 0, 9, 9, 0, 9, 9, 0, 0, 0
		},
		["dir_alt"] = {
			7, 8, 9, 8,
			7, 8, 9, 8,
			7, 8, 9, 8,
			7, 8, 9, 8,
			7, 8, 9, 8,
			7, 8, 9, 8,
			7, 0, 7, 0,
			8, 0, 8, 0,
			9, 0, 9, 0,
			7, 0, 7, 0,
			8, 0, 8, 0,
			9, 0, 9, 0,
			7, 0, 7, 0,
			8, 0, 8, 0,
			9, 0, 9, 0,
		}
	},
	["bullbar"] = {
		["flash"] = {
			3, 0, 3, 0, 3, 0, 0, 0
		}
	},
	["grille"] = {
		["code1"] = {
			5, 5, 5, 6, 6, 6
		},
		["alt"] = {
			1, 5, 3, 0, 2, 6, 4, 0
		}
	},
	["takedown"] = {
		["steady"] = {
			3
		},
		["code3"] = {
			1, 1, 2, 2
		}
	},
	["headlights"] = {
		["wig-wag"] = {
			1
		}
	},
	["tail_lights"] = {
		["code3"] = {
			1, 0, 1, 0, 2, 0, 2, 0
		}
	},
	["reverse_lights"] = {
		["code3"] = {
			2, 0, 2, 0, 1, 0, 1, 0
		}
	}
}


EMV.Sequences = {
	Sequences = {
		{
			Name = "CODE 1",
			Components = {
				["grille"] = "code1",
			}
		},
		{
			Name = "CODE 2",
			Components = {
				["front_window"] = "alt",
				["rear"] = "dir_alt",
				--["bullbar"] = "flash",
				["grille"] = "code1",
			}
		},
		{
			Name = "CODE 3",
			Components = {
				["front_window"] = "code3",
				["rear"] = "dir_alt",
				["bullbar"] = "flash",
				["grille"] = "alt",
				["headlights"] = "wig-wag",
				["tail_lights"] = "code3",
				["reverse_lights"] = "code3",
			},
			Disconnect = {
				14, 15, 1, 2, 3, 4
			}
		},
	}
}


Photon.EMVLibrary[name] = EMV