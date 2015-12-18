AddCSLuaFile()

local A = "AMBER"
local R = "RED"
local DR = "D_RED"
local B = "BLUE"
local W = "WHITE"
local CW = "C_WHITE"
local SW = "S_WHITE"
local G = "GREEN"

local name = "Whelen Justice"

local COMPONENT = {}

COMPONENT.Model = "models/schmal/whelen_justice/justice_lightbar.mdl"
COMPONENT.Skin = 0
COMPONENT.Lightbar = true
COMPONENT.Bodygroups = {}
COMPONENT.Category = "Lightbar"
COMPONENT.DefaultColors = {
	[1] = "RED",
	[2] = "BLUE"
}

COMPONENT.Meta = {
	justice_forward = {
		AngleOffset = -90,
		W = 4.2,
		H = 4.2,
		Sprite = "sprites/emv/justice_1x3",
		Scale = 1.25,
		WMult = 1.5,
	},
	justice_rear = {
		AngleOffset = 90,
		W = 4.2,
		H = 4.2,
		Sprite = "sprites/emv/justice_1x3",
		Scale = 1.5,
		WMult = 1.5,
	},
	justice_illum = {
		AngleOffset = -90,
		W = 3,
		H = 3,
		Sprite = "sprites/emv/emv_whelen_tri",
		Scale = 2,
		WMult = 1,
	},
	justice_corner_forward = {
		AngleOffset = -90,
		W = 10,
		H = 10,
		Sprite = "sprites/emv/emv_whelen_corner",
		Scale = 1.25,
		WMult = 2,
	},
	justice_corner_rear = {
		AngleOffset = 90,
		W = 10,
		H = 10,
		Sprite = "sprites/emv/emv_whelen_corner",
		Scale = 1.5,
		WMult = 2,
	},
}

COMPONENT.Positions = {

	[1] = { Vector( 0, 5.68, -0.69 ), Angle( 0, 0, 0 ), "justice_forward" },

	[2] = { Vector( -6.48, 5.68, -0.69 ), Angle( 0, 0, 0 ), "justice_forward" },
	[3] = { Vector( 6.48, 5.68, -0.69 ), Angle( 0, 0, 0 ), "justice_forward" },

	[4] = { Vector( -11.66, 5.68, -0.69 ), Angle( 0, 0, 0 ), "justice_forward" },
	[5] = { Vector( 11.66, 5.68, -0.69 ), Angle( 0, 0, 0 ), "justice_forward" },

	[6] = { Vector( -16.77, 5.68, -0.69 ), Angle( 0, 0, 0 ), "justice_forward" },
	[7] = { Vector( 16.77, 5.68, -0.69 ), Angle( 0, 0, 0 ), "justice_forward" },

	[8] = { Vector( -24.74, 3.17, -0.57 ), Angle( 0, 36, 0 ), "justice_corner_forward", 1 },
	[9] = { Vector( 24.74, 3.17, -0.57 ), Angle( 0, -36, 0 ), "justice_corner_forward", 2 },

	[10] = { Vector( -24.74, -3.91, -0.49 ), Angle( 0, -36, 0 ), "justice_corner_rear", 3 },
	[11] = { Vector( 24.74, -3.91, -0.49 ), Angle( 0, 36, 0 ), "justice_corner_rear", 4 },

	[12] = { Vector( -18.82, -6.38, -0.56 ), Angle( 0, 0, 0 ), "justice_rear" },
	[13] = { Vector( 18.82, -6.38, -0.56 ), Angle( 0, 0, 0 ), "justice_rear" },

	[14] = { Vector( -12.61, -6.38, -0.56 ), Angle( 0, 0, 0 ), "justice_rear" },
	[15] = { Vector( 12.61, -6.38, -0.56 ), Angle( 0, 0, 0 ), "justice_rear" },

	[16] = { Vector( -6.47, -6.38, -0.56 ), Angle( 0, 0, 0 ), "justice_rear" },
	[17] = { Vector( 6.47, -6.38, -0.56 ), Angle( 0, 0, 0 ), "justice_rear" },

	[18] = { Vector( 0, -6.38, -0.56 ), Angle( 0, 0, 0 ), "justice_rear" },

	[19] = { Vector( -20.72, 5.58, -0.64 ), Angle( 0, 0, 0 ), "justice_illum" },
	[20] = { Vector( 20.72, 5.58, -0.64 ), Angle( 0, 0, 0 ), "justice_illum" },

	[21] = { Vector( -27.72, -0.34, -0.59 ), Angle( 0, 90, 0 ), "justice_illum" },
	[22] = { Vector( 27.72, -0.34, -0.59 ), Angle( 0, -90, 0 ), "justice_illum" },

}

COMPONENT.Sections = {
	["auto_whelen_justice"] = {
		{
			{ 1, W }, { 2, "_1" },
			{ 3, "_2" }, { 4, "_1" },
			{ 5, "_2" }, { 6, "_1" },
			{ 7, "_2" }, { 8, "_1" },
			{ 9, "_2" }, { 10, "_1" },
			{ 11, "_2" }, { 12, A },
			{ 13, A }, { 14, A },
			{ 15, A }, { 16, A },
			{ 17, A }, { 18, A },
			{ 19, W }, { 20, W },
			{ 21, W }, { 22, W },
		},
		[2] = {
			{ 2, "_1" }, { 4, "_1" }, { 6, "_1" }, { 8, "_1" }, { 10, "_1" }, { 12, "_1" }, { 14, "_1" }, { 16, "_1" }
		},
		[3] = {
			{ 3, "_2" }, { 5, "_2" }, { 7, "_2" }, { 9, "_2" }, { 11, "_2" }, { 13, "_2" }, { 15, "_2" }, { 17, "_2" }
		},
		[4] = {
			{ 2, "_1" }, { 16, "_1" }
		},
		[5] = {
			{ 7, "_2" }, { 13, "_2" }, { 4, "_1" }, { 14, "_1" }
		},
		[6] = {
			{ 5, "_2" }, { 15, "_2" }, { 6, "_1" }, { 12, "_1" }
		},
		[7] = {
			{ 3, "_2" }, { 17, "_2" }, { 8, "_1" },
		},
		[8] = {
			{ 7, "_2" }, { 13, "_2" }, { 5, "_2" }, { 15, "_2" },
		},
		[9] = {
			{ 5, "_2" }, { 15, "_2" }, { 3, "_2" }, { 17, "_2" }
		},
		[10] = {
			{ 3, "_2" }, { 17, "_2" }, { 2, "_1" }, { 16, "_1" }
		},
		[11] = {
			{ 2, "_1" }, { 16, "_1" }, { 4, "_1" }, { 14, "_1" },
		},
		[12] = {
			{ 6, "_1" }, { 12, "_1" }, { 4, "_1" }, { 14, "_1" }
			},
		[13] = {
			{ 7, "_2" }, { 13, "_2" }, { 3, "_2" }, { 17, "_2" }, { 4, "_1" }, { 14, "_1" }
		},
		[14] = {
			{ 6, "_1" }, { 12, "_1" }, { 2, "_1" }, { 16, "_1" }, { 5, "_2" }, { 15, "_2" }
		}
	},
	["auto_whelen_justice_corner"] = {
		[1] = {
			{ 9, "_2" }, { 11, "_2" }
		},
		[2] = {
			{ 8, "_1" }, { 10, "_1" }
		},
		[3] = {
			{ 8, "_1" }, { 10, "_1" }, { 9, "_2" }, { 11, "_2" }
		}
	},
	["auto_whelen_justice_middle"] = {
		[1] = { { 1, "_1" }, { 18, A } },
		[2] = { { 1, "_2" }, { 18, A } },
		[3] = { { 1, W }, { 18, A } },
	},
	["auto_whelen_justice_illum"] = {
		[1] = { { 19, W }, { 21, W } },
		[2] = { { 20, W }, { 22, W } },
		[3] = { { 19, W }, { 20, W } },
		[4] = { { 21, W }, { 22, W } },
	},
	["auto_whelen_justice_traffic"] = {
		[1] = { { 12, A } },
		[2] = { { 12, A }, { 14, A } },
		[3] = { { 12, A }, { 14, A }, { 16, A } },
		[4] = { { 12, A }, { 14, A }, { 16, A }, { 18, A } },
		[5] = { { 12, A }, { 14, A }, { 16, A }, { 18, A }, { 17, A }, },
		[6] = { { 12, A }, { 14, A }, { 16, A }, { 18, A }, { 17, A }, { 15, A }, },
		[7] = { { 12, A }, { 14, A }, { 16, A }, { 18, A }, { 17, A }, { 15, A }, { 13, A }, },
		[8] = { { 13, A }, },
		[9] = { { 15, A }, { 13, A }, },
		[10] = { { 17, A }, { 15, A }, { 13, A }, },
		[11] = { { 18, A }, { 17, A }, { 15, A }, { 13, A }, },
		[12] = { { 16, A }, { 18, A }, { 17, A }, { 15, A }, { 13, A }, },
		[13] = { { 14, A }, { 16, A }, { 18, A }, { 17, A }, { 15, A }, { 13, A }, },
		[14] = { { 18, A } },
		[15] = { { 16, A }, { 18, A }, { 17, A } },
		[16] = { { 14, A }, { 16, A }, { 18, A }, { 17, A }, { 15, A } },

	}
}

COMPONENT.Patterns = {
	["auto_whelen_justice_traffic"] = {
		["left"] = { 8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13, 7, 7, 7, 7, 0, 0 },
		["right"] = { 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 7, 7, 0, 0 },
		["diverge"] = { 14, 14, 15, 15, 16, 16, 7, 7, 7, 7, 0, 0 }
	},
	["auto_whelen_justice"] = {
		["all"] = { 1, 0, 1, 0, 1, 0 },
		["code1"] = { 2, 2, 2, 2, 0, 3, 3, 3, 3, 0 },
		["code2"] = { 4, 5, 6, 7, 6, 5 },
		["code3"] = { 
			8, 9, 10, 11, 12, 11, 10, 9,
			8, 9, 10, 11, 12, 11, 10, 9,
			8, 9, 10, 11, 12, 11, 10, 9,
			8, 9, 10, 11, 12, 11, 10, 9,
			8, 9, 10, 11, 12, 11, 10, 9,
			13, 14, 13, 14, 13, 14, 13, 14,
			13, 14, 13, 14, 13, 14, 13, 14,
			13, 14, 13, 14, 13, 14, 13, 14,
			13, 14, 13, 14, 13, 14, 13, 14,
		},
		["alert"] = { 2, 3 }
	},
	["auto_whelen_justice_corner"] = {
		["code2"] = { 1, 0, 1, 0, 1, 0, 2, 0, 2, 0, 2, 0 },
		["code3"] = { 1, 2 },
		["cruise"] = { 3 }
	},
	["auto_whelen_justice_middle"] = {
		["code2"] = { 1, 0, 2, 0 },
		["code3"] = { 1, 0, 2, 0, 3, 0 },
	},
	["auto_whelen_justice_illum"] = {
		["code3"] = { 1, 0, 1, 0, 2, 0, 2, 0 }
	}
}

COMPONENT.TrafficDisconnect = { 
	["auto_whelen_justice_traffic"] = {
		12, 13, 14, 15, 16, 17, 18
	}
}

COMPONENT.Modes = {
	Primary = {
			M1 = {
				["auto_whelen_justice"] = "code1"
			},
			M2 = {
				["auto_whelen_justice"] = "code2",
				["auto_whelen_justice_corner"] = "code2",
				["auto_whelen_justice_middle"] = "code2"
			},
			M3 = {
				["auto_whelen_justice"] = "code3",
				["auto_whelen_justice_corner"] = "code3",
				["auto_whelen_justice_middle"] = "code3",
				["auto_whelen_justice_illum"] = "code3"
			},
			ALERT = {
				["auto_whelen_justice"] = "alert"
			}
		},
	Auxiliary = {
			C = {
				["auto_whelen_justice_corner"] = "cruise",
			},
			L = {
				["auto_whelen_justice_traffic"] = "left"
			},
			R = {
				["auto_whelen_justice_traffic"] = "right"
			},
			D = {
				["auto_whelen_justice_traffic"] = "diverge"
			}
		},
	Illumination = {
		L = {
			{ 21, W }
		},
		R = {
			{ 22, W }
		},
		F = {
			{ 19, W }, { 20, W }
		},
		T = {
			{ 19, W }, { 20, W }
		}
	}
}

EMVU:AddAutoComponent( COMPONENT, name )