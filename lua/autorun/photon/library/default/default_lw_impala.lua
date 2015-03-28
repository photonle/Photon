AddCSLuaFile()

local name = "Chevrolet Impala LS Police Cruiser"

local A = "AMBER"
local R = "RED"
local B = "BLUE"
local W = "WHITE"
local CW = "C_WHITE"
local SW = "S_WHITE"

local EMV = {}

EMV.Siren = 7

EMV.Color = nil
EMV.Skin = 0

EMV.BodyGroups = {}

EMV.Props = {}


EMV.Positions = {

	[1] = { Vector(23.9, 22.6, 60.4), Angle(0,0,0), "f_win" }, -- 3
	[2] = { Vector(-23.9, 22.6, 60.4), Angle(0,0,0), "f_win" }, -- 4

	[3] = { Vector(20.9, -60.3, 63), Angle(0,0,0), "r_win" }, -- 5
	[4] = { Vector(-19.4, -60.3, 63), Angle(0,0,0), "r_win" }, -- 6

	[5] = { Vector(15.7, -60.3, 63), Angle(0,0,0), "r_win" }, -- 7
	[6] = { Vector(-14.2, -60.3, 63), Angle(0,0,0), "r_win" }, -- 8

	[7] = { Vector(-33.4,101,32.5), Angle(0,30,0), "head_low" }, --  9
	[8] = { Vector(33.4,101,32.5), Angle(0,-30,0), "head_low" }, --  10

	[9] = { Vector(-28,106,31.5), Angle(0,30,0), "head_high" }, --  11
	[10] = { Vector(28,106,31.5), Angle(0,-30,0), "head_high" }, --  12

	[11] = { Vector(-32,-114,40), Angle(0,-20,-15), "reverse" }, --  13
	[12] = { Vector(32,-114,40), Angle(0,20,-15), "reverse" }, --  14

	[13] = { Vector( -3.12, -7.81, 73.03 ), Angle( 0, 0, 0 ), "liberty_f_main" },
	[14] = { Vector( 3.12, -7.81, 73.03 ), Angle( 0, 0, 0 ), "liberty_f_main" },

	[15] = { Vector( -8.81, -7.81, 73.03 ), Angle( 0, 0, 0 ), "liberty_f_main" },
	[16] = { Vector( 8.81, -7.81, 73.03 ), Angle( 0, 0, 0 ), "liberty_f_main" },

	[17] = { Vector( -14.77, -7.87, 73.06 ), Angle( 0, 0, 0 ), "liberty_takedown" },
	[18] = { Vector( 14.77, -7.87, 73.06 ), Angle( 0, 0, 0 ), "liberty_takedown" },

	[19] = { Vector( -22.6, -10, 73.06 ), Angle( 0, 33.2, 0 ), "liberty_f_ang" },
	[20] = { Vector( 22.6, -10, 73.06 ), Angle( 0, -33.2, 0 ), "liberty_f_ang" },

	[21] = { Vector( -26.8, -14.24, 72.89 ), Angle( 0, 90, 0 ), "liberty_alley" },
	[22] = { Vector( 26.8, -14.24, 72.89 ), Angle( 0, -90, 0 ) , "liberty_alley" },

	[23] = { Vector( -22.6, -18.46, 73.06 ), Angle( 0, -33.2, 0 ), "liberty_r_ang" },
	[24] = { Vector( 22.6, -18.46, 73.06 ), Angle( 0, 33.2, 0 ), "liberty_r_ang" },

	[25] = { Vector( -14.44, -20.68, 73.03 ), Angle( 0, 0, 0 ), "liberty_r_main" },
	[26] = { Vector( 14.44, -20.68, 73.03 ), Angle( 0, 0, 0 ), "liberty_r_main" },

	[27] = { Vector( -8.81, -20.68, 73.03 ), Angle( 0, 0, 0 ), "liberty_r_main" },
	[28] = { Vector( 8.81, -20.68, 73.03 ), Angle( 0, 0, 0 ), "liberty_r_main" },

	[29] = { Vector( -3.12, -20.68, 73.03 ), Angle( 0, 0, 0 ), "liberty_r_main" },
	[30] = { Vector( 3.12, -20.68, 73.03 ), Angle( 0, 0, 0 ), "liberty_r_main" },

}

EMV.Sections = {
	["front"] = {
		{ {1, B} },
		{ {2, R} },
		{ {1, B}, {2, R} }
	},
	["rear"] = {
		{ {3, R}, {4, R} },
		{ {5, B}, {6, B} },
		{ {5, B}, {6, B}, {3, B}, {4, B} },
	},
	["low beams"] = {
		{ {7, CW, 1} },
		{ {8, CW, 1} },
	},
	["high beams"] = {
		{ {9, SW, .5}, {10, SW, 1} },
		{ {10, SW, .5}, {9, SW, 1} },
		{ {9, SW, 1}, {10, SW, 1} },
	},
	["rearhide"] = {
		{ {11, CW, 1} },
		{ {12, CW, 1} },
		{ {11, CW, 1}, {12, CW, 1} }
	},
	["lightbar"] = {
		{ { 13, R }, { 15, R }, { 19, R }, { 23, R }, { 25, R }, },
		{ { 14, B }, { 16, B }, { 20, B }, { 24, B }, { 26, B }, },
		{ { 19, R }, { 23, R } },
		{ { 27, A }, { 29, A } },
		{ { 20, B }, { 24, B } },
		{ { 28, A }, { 30, A } },
		{ { 14, B }, { 16, B }, { 19, R }, { 23, R }, { 26, B }, },
		{ { 13, R }, { 15, R }, { 20, B }, { 24, B }, { 25, R }, },
	},
	["lightbar_rear"] = {
		{ { 29, A }, { 30, A } },
		{ { 27, A }, { 28, A } },
	}
}

EMV.Patterns = { -- 0 = blank
	["front"] = {
		["alt"] = {
			1, 1, 1, 1, 2, 2, 2, 2
		},
		["flash"] = {
			1, 0, 1, 0, 1, 0, 2, 0, 2, 0, 2, 0,
		}
	},
	["rear"] = {
		["alt_slow"] = {
			1, 1, 1, 1, 1, 2, 2, 2, 2, 2
		},
		["alt_med"] = {
			1, 1, 1, 2, 2, 2
		},
		["flash"] = {
			1, 0, 1, 0, 1, 0, 2, 0, 2, 0, 2, 0
		}
	},
	["low beams"] = {
		["flash"] = {
			1, 0, 1, 0, 2, 0, 2, 0
		}
	},
	["high beams"] = {
		["wigwag"] = {
			1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2
		},
		["steady"] = {
			3
		}
	},
	["rearhide"] = {
		["flash"] = {
			1, 0, 1, 0, 2, 0, 2, 0
		},
		["steady"] = {
			3
		}
	},
	["lightbar"] = {
		["alt"] = {
			1, 1, 1, 2, 2, 2
		},
		["code1"] = {
			3, 3, 3, 4, 4, 3, 3, 3, 4, 4, 
			5, 5, 5, 6, 6, 5, 5, 5, 6, 6
		},
		["priority"] = {
			1, 0, 1, 0,
			2, 0, 2, 0,
			1, 0, 1, 0,
			2, 0, 2, 0,
			1, 0, 1, 0,
			2, 0, 2, 0,
			1, 0, 1, 0,
			2, 0, 2, 0,
			7, 7, 8, 8,
			7, 7, 8, 8,
			7, 7, 8, 8,
			7, 7, 8, 8,
			7, 7, 8, 8,
		}
	},
	["lightbar_rear"] = {
		["med"] = {
			1, 1, 2, 2
		},
		["rapid"] = {
			1, 0, 1, 0, 1,
			2, 0, 2, 0, 2
		},
	}
}

EMV.Sequences = {
		Sequences = {
		{
			Name = "CODE 1",
			Components = {
				["rear"] = "alt_slow",
				["lightbar"] = "code1"
			},
			Disconnect = {}
		},
		{
			Name = "CODE 2",
			Components = {
				["front"] = "alt",
				["rear"] = "alt_med",
				["lightbar"] = "alt",
				["lightbar_rear"] = "med"
			},
			Disconnect = {}
		},
		{
			Name = "CODE 3",
			Components = {
				["front"] = "flash",
				["rear"] = "flash",
				["low beams"] = "flash",
				["high beams"] = "wigwag",
				["rearhide"] = "flash",
				["lightbar_rear"] = "rapid",
				["lightbar"] = "priority"
			},
			Disconnect = { 10, 11 }
		},
	},
	Illumination = {
		{
			Name = "TAKEDOWN",
			Components = {
				{ 17, W, 1.5 }, { 18, W, 1.5 }
			},
			Lights = {
				{ Vector( -14.77, -5, 75 ), Angle( 10, 90, 0 ), "takedowns" },
				{ Vector( 14.77, -5, 75 ), Angle( 10, 90, 0 ), "takedowns" },
			},
			Disconnect = { }
		},
		{
			Name = "ALLEY",
			Components = {
				{ 21, W, 1.5 }, { 22, W, 1.5 }
			},
			Lights = {
				{ Vector( -27, -14.24, 72.89 ), Angle(20,0,0), "alley" },
				{ Vector( 27, -14.24, 72.89 ), Angle(20,180,0), "alley" },

			},
			Disconnect = { }
		},
	}
}

EMV.Meta = {
	f_win = {
		AngleOffset = -90,
		W = 5.7,
		H = 5.8,
		Sprite = "sprites/emv/emv_whelen_src",
		Scale = .8,
		WMult = 2.3
	},
	r_win = {
		AngleOffset = 90,
		W = 5.7,
		H = 5.8,
		Sprite = "sprites/emv/emv_whelen_src",
		WMult = 2.3,
		Scale = .8
	},
	f_grille = {
		AngleOffset = -90,
		W = 4.5,
		H = 4.5,
		Sprite = "sprites/emv/emv_whelen_mini_3"
	},
	r_trf_advisor = {
		AngleOffset = 90,
		W = 5,
		H = 7,
		Sprite = "sprites/emv/led_lightbar"
	},
	head_low = {
		AngleOffset = -90,
		W = 12,
		H = 10,
		Sprite = "sprites/emv/circular_src",
		Scale = 1,
		VisRadius = 16,
	},
	head_high = {
		AngleOffset = -90,
		W = 10,
		H = 10,
		Sprite = "sprites/emv/circular_src",
		Scale = 2,
		VisRadius = 16,
	},
	reverse = {
		AngleOffset = 90,
		W = 12,
		H = 12,
		Sprite = "sprites/emv/impala_reverse",
		Scale = .6,
		WMult = 1.2
	},
	liberty_f_main = {
		AngleOffset = -90,
		W = 6.9,
		H = 6.9,
		Sprite = "sprites/emv/emv_whelen_src",
		WMult = 2,
		Scale = 1.4
	},
	liberty_takedown = {
		AngleOffset = -90,
		W = 6,
		H = 6,
		Sprite = "sprites/emv/emv_whelen_6x2",
		WMult = 3,
		Scale = 1.2
	},
	liberty_alley = {
		AngleOffset = -90,
		W = 3,
		H = 3,
		Sprite = "sprites/emv/emv_whelen_tri",
		WMult = 1,
		Scale = 1.2
	},
	liberty_f_ang = {
		AngleOffset = -90,
		W = 13.6,
		H = 12.8,
		Sprite = "sprites/emv/emv_whelen_corner",
		WMult = 3,
		Scale = 1.6,
		VisRadius = 0
	},
	liberty_r_ang = {
		AngleOffset = 90,
		W = 13.6,
		H = 12.8,
		Sprite = "sprites/emv/emv_whelen_corner",
		WMult = 3,
		Scale = 1.6
	},
	liberty_r_main = {
		AngleOffset = 90,
		W = 6.9,
		H = 6.9,
		Sprite = "sprites/emv/emv_whelen_src",
		WMult = 2,
		Scale = 1.4
	},
}

EMV.Lamps = {
	["takedowns"] = {
		Color = Color(128,128,164,255),
		Texture = "effects/flashlight001",
		Near = 16,
		FOV = 70,
		Distance = 700,
	},
	["alley"] = {
		Color = Color(48,48,64,255),
		Texture = "effects/flashlight001",
		Near = 100,
		FOV = 60,
		Distance = 500,
	}
}

Photon.EMVLibrary[name] = EMV