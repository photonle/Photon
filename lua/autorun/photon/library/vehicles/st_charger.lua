AddCSLuaFile()

local A = "AMBER"
local R = "RED"
local DR = "D_RED"
local DGR = DR
local B = "BLUE"
local W = "WHITE"
local CW = "C_WHITE"
local SW = "S_WHITE"

local PI = {}

PI.Meta = {
	headlight = {
		AngleOffset = -90,
		W = 4,
		H = 4,
		Sprite = "sprites/emv/light_circle",
		Scale = 2,
	},
	front_signal = {
		AngleOffset = -90,
		W = 9,
		H = 8,
		Sprite = "sprites/emv/st_charger_front",
		Scale = 2,
		VisRadius = 2,
		WMult = 1.75
	},
	rear_inner = {
		AngleOffset = 90,
		W =  8,
		H = 8,
		Sprite = "sprites/emv/st_charger_rear_inner",
		Scale = 1.2,
		WMult = 2,
		VisRadius = 5,
	},
	rear_outer_a = {
		AngleOffset = 90,
		W =  7,
		H = 5,
		Sprite = "sprites/emv/st_charger_rear_outer_a",
		Scale = 1.75,
		WMult = 2,
		VisRadius = 5,
		SourceOnly = false,
	},
	rear_outer_b = {
		AngleOffset = 90,
		W =  4.3,
		H = 2.4,
		Sprite = "sprites/emv/square",
		Scale = 1,
		WMult = 2,
		VisRadius = 5,
		SourceOnly = false,
	},
	rear_outer_c = {
		AngleOffset = 90,
		W =  1.7,
		H = 1,
		Sprite = "sprites/emv/square",
		Scale = 1,
		WMult = 2,
		VisRadius = 5,
		SourceOnly = false,
	},
	turn_inner = {
		AngleOffset = 90,
		W =  4,
		H = 1.2,
		Sprite = "sprites/emv/square",
		Scale = .8,
		WMult = 2,
		VisRadius = 5,
	},
	turn_outer_a = {
		AngleOffset = 90,
		W =  4,
		H = 1.2,
		Sprite = "sprites/emv/square",
		WMult = 2,
		Scale = .8,
		VisRadius = 5,
	},
	tail_glow = {
		AngleOffset = 90,
		W =  1,
		H = 1,
		Sprite = "sprites/emv/blank",
		Scale = 1.5,
		WMult = 1,
		VisRadius = 8,
		Cheap = true,
	}
}

PI.Positions = {

	[1] = { Vector( 36.7, 108.38, 35.58 ), Angle( 0, 0, 0 ), "headlight" },
	[2] = { Vector( -36.7, 108.38, 35.58 ), Angle( 0, 0, 0 ), "headlight" },

	[3] = { Vector( 30.5, 114.08, 34.38 ), Angle( 180 - 5.27, -29.78, 180 - 3.97), "front_signal" },
	[4] = { Vector( -30.5, 114.08, 34.38 ), Angle( 5.27, 29.78, 3.97 ), "front_signal" },

	[5] = { Vector( 24.9, -116.72, 46.7 ), Angle( 0, 13.8, 0 ), "rear_inner" },
	[6] = { Vector( -24.9, -116.72, 46.7 ), Angle( 180, -13.8, 180 ), "rear_inner" },

	[7] = { Vector( 31.02, -114.83, 46.4 ), Angle( 0, 21.2, 0 ), "rear_outer_a" },
	[8] = { Vector( -31.02, -114.83, 46.4 ), Angle( 180, -21.2, 180 ), "rear_outer_a" },

	[9] = { Vector( 35.02, -112.77, 46.2 ), Angle( 0, 32.4, 0 ), "rear_outer_b" },
	[10] = { Vector( -35.02, -112.77, 46.2 ), Angle( 0, -32.4, 0 ), "rear_outer_b" },

	[11] = { Vector( 37.52, -111.17, 45.8 ), Angle( 0, 33.6, 0 ), "rear_outer_c" },
	[12] = { Vector( -37.52, -111.17, 45.8 ), Angle( 0, -33.6, 0 ), "rear_outer_c" },

	[13] = { Vector( 26.09, -116.55, 44.6 ), Angle( 0, 11.8, 0 ), "turn_inner" },
	[14] = { Vector( -26.09, -116.55, 44.6 ), Angle( 0, -11.8, 0 ), "turn_inner" },

	[15] = { Vector( 30.39, -115.22, 44.6 ), Angle( 0, 20.6, 0 ), "turn_outer_a" },
	[16] = { Vector( -30.39, -115.22, 44.6 ), Angle( 0, -20.6, 0 ), "turn_outer_a" },

	[17] = { Vector( 33.96, -113.47, 44.6 ), Angle( 0, 31.7, 0 ), "turn_outer_a" },
	[18] = { Vector( -33.96, -113.47, 44.6 ), Angle( 0, -31.7, 0 ), "turn_outer_a" },

	[19] = { Vector( 37.26, -111.24, 44.6 ), Angle( 0, 36, 0 ), "turn_outer_a" },
	[20] = { Vector( -37.26, -111.24, 44.6 ), Angle( 0, -36, 0 ), "turn_outer_a" },

	----------------------------------------------------------------------------------------
	-- FULL CREDIT TO SHADOWZACK FOR GETTING THESE REAR POSITIONS, BECAUSE GOD DAMN THAT IS HARD
	----------------------------------------------------------------------------------------

	[21] = { Vector( -30.5, -115.7, 48.4 ), Angle(-0,-20,22 ), "tail_glow" },
	[22] = { Vector( -32.5, -115.1, 48.2 ), Angle(-0,-20,22 ), "tail_glow" },
	[23] = { Vector( -34.5, -114, 47.8 ), Angle(-0,-25,22 ), "tail_glow" },
	[24] = { Vector( -36.5, -112.7, 47.3 ), Angle(-0,-25,22 ), "tail_glow" },
	[25] = { Vector( -38.5, -111.4, 46.8 ), Angle(-0,-25,20 ), "tail_glow" },
	[26] = { Vector( -39.7, -110.2, 45.8 ), Angle(-0,-15,12 ), "tail_glow" },
	[27] = { Vector( -40.1, -109.8, 44.3 ), Angle(-0,-12,8 ), "tail_glow" },
	[28] = { Vector( -39.4, -110.8, 43.2 ), Angle(-0,-12,-20 ), "tail_glow" },
	[29] = { Vector( -38, -111.8, 42.9 ), Angle(-0,-15,-20 ), "tail_glow" },
	[30] = { Vector( -36, -113.2, 42.8 ), Angle(-0,-20,-20 ), "tail_glow" },
	[31] = { Vector( -34, -114.35, 42.7 ), Angle(-0,-20,-20 ), "tail_glow" },
	[32] = { Vector( -34, -114.35, 42.7 ), Angle(-0,-20,-20 ), "tail_glow" },
	[33] = { Vector( -32, -115.4, 42.7 ), Angle(-0,-20,-20 ), "tail_glow" },
	[34] = { Vector( -30.2, -116.1, 42.7 ), Angle(-0,-20,-22 ), "tail_glow" },
	[35] = { Vector( -28.5, -116.7, 42.7 ), Angle(-0,-20,-22 ), "tail_glow" },

	[36] = { Vector( 30.5, -115.8, 48.5 ), Angle(-0,20,22 ), "tail_glow" },
	[37] = { Vector( 32.5, -115.1, 48.2 ), Angle(-0,20,22 ), "tail_glow" },
	[38] = { Vector( 34.5, -114, 47.8 ), Angle(-0,25,22 ), "tail_glow" },
	[39] = { Vector( 36.5, -112.7, 47.3 ), Angle(-0,25,22 ), "tail_glow" },
	[40] = { Vector( 38.5, -111.4, 46.8 ), Angle(-0,25,20 ), "tail_glow" },
	[41] = { Vector( 39.7, -110.2, 45.8 ), Angle(-0,15,12 ), "tail_glow" },
	[42] = { Vector( 40.1, -109.8, 44.3 ), Angle(-0,12,8 ), "tail_glow" },
	[43] = { Vector( 39.4, -110.8, 43.2 ), Angle(-0,12,-20 ), "tail_glow" },
	[44] = { Vector( 38, -111.9, 42.9 ), Angle(-0,15,-20 ), "tail_glow" },
	[45] = { Vector( 36, -113.3, 42.8 ), Angle(-0,20,-20 ), "tail_glow" },
	[46] = { Vector( 34, -114.4, 42.7 ), Angle(-0,20,-20 ), "tail_glow" },
	[47] = { Vector( 34, -114.4, 42.7 ), Angle(-0,20,-20 ), "tail_glow" },
	[48] = { Vector( 32, -115.4, 42.7 ), Angle(-0,20,-20 ), "tail_glow" },
	[49] = { Vector( 30.2, -116.1, 42.7 ), Angle(-0,20,-22 ), "tail_glow" },
	[50] = { Vector( 28.5, -116.7, 42.7 ), Angle(-0,20,-22 ), "tail_glow" },
 
	[51] = { Vector( -26.5, -117.1, 42.7 ), Angle(-0,-20,-27 ), "tail_glow" },
	[52] = { Vector( -24.5, -117.6, 43.3 ), Angle(-0,-20,-27 ), "tail_glow" },
	[53] = { Vector( -22.5, -118, 44.4 ), Angle(-0,-20,-27 ), "tail_glow" },
	[54] = { Vector( -20.5, -118.35, 45.5 ), Angle(-0,-20,-27 ), "tail_glow" },
	[55] = { Vector( -18.5, -118.5, 46.3 ), Angle(-0,-15,-33 ), "tail_glow" },
	[56] = { Vector( -16.5, -118.9, 46.7 ), Angle(-0,-15,-33 ), "tail_glow" },
	[57] = { Vector( -14.5, -119.1, 46.7 ), Angle(-0,-0,-35 ), "tail_glow" },
	[58] = { Vector( -12.5, -119.2, 46.8 ), Angle(-0,-0,-35 ), "tail_glow" },
	[59] = { Vector( -10.5, -119.4, 46.82 ), Angle(-0,-0,-35 ), "tail_glow" },
	[60] = { Vector( -8.5, -119.5, 46.84 ), Angle(-0,-0,-35 ), "tail_glow" },
	[61] = { Vector( -6.5, -119.7, 46.86 ), Angle(-0,-0,-35 ), "tail_glow" },
	[62] = { Vector( -4.5, -119.9, 46.88 ), Angle(-0,-0,-35 ), "tail_glow" },
	[63] = { Vector( -2.3, -120, 46.9 ), Angle(-0,-0,-35 ), "tail_glow" },
	[64] = { Vector( -0, -120.1, 47 ), Angle(-0,-0,-35 ), "tail_glow" },

	[65] = { Vector( 2.3, -120, 46.9 ), Angle(-0,-0,-35 ), "tail_glow" },
	[66] = { Vector( 4.5, -119.9, 46.88 ), Angle(-0,-0,-35 ), "tail_glow" },
	[67] = { Vector( 6.5, -119.7, 46.86 ), Angle(-0,-0,-35 ), "tail_glow" },
	[68] = { Vector( 8.5, -119.5, 46.84 ), Angle(-0,-0,-35 ), "tail_glow" },
	[69] = { Vector( 10.5, -119.4, 46.82 ), Angle(-0,-0,-35 ), "tail_glow" },
	[70] = { Vector( 12.5, -119.2, 46.8 ), Angle(-0,-0,-35 ), "tail_glow" },
	[71] = { Vector( 14.5, -119.1, 46.7 ), Angle(-0,-0,-35 ), "tail_glow" },
	[72] = { Vector( 16.5, -118.9, 46.7 ), Angle(-0,15,-33 ), "tail_glow" },
	[73] = { Vector( 18.5, -118.5, 46.3 ), Angle(-0,15,-33 ), "tail_glow" },
	[74] = { Vector( 20.5, -118.35, 45.5 ), Angle(-0,20,-27 ), "tail_glow" },
	[75] = { Vector( 22.5, -118, 44.4 ), Angle(-0,20,-27 ), "tail_glow" },
	[76] = { Vector( 24.5, -117.6, 43.3 ), Angle(-0,20,-27 ), "tail_glow" },
	[77] = { Vector( 26.5, -117.1, 42.7 ), Angle(-0,20,-27 ), "tail_glow" },

	[78] = { Vector( -28.4, -116.2, 48.8 ), Angle(-0,-15,30 ), "tail_glow" },
	[79] = { Vector( -26.4, -116.6, 49 ), Angle(-0,-10,30 ), "tail_glow" },
	[80] = { Vector( -24.4, -117.2, 49.2 ), Angle(-0,-10,30 ), "tail_glow" },
	[81] = { Vector( -22.4, -117.5, 49.35 ), Angle(-0,-5,30 ), "tail_glow" },
	[82] = { Vector( -20.4, -117.9, 49.5 ), Angle(-0,-5,32 ), "tail_glow" },
	[83] = { Vector( -18.4, -118.1, 49.6 ), Angle(-0,-5,32 ), "tail_glow" },
	[84] = { Vector( -16.4, -118.4, 49.7 ), Angle(-0,-5,32 ), "tail_glow" },
	[85] = { Vector( -14.4, -118.7, 49.8 ), Angle(-0,-5,32 ), "tail_glow" },
	[86] = { Vector( -12.4, -118.9, 49.88 ), Angle(-0,-0,32 ), "tail_glow" },
	[87] = { Vector( -10.4, -119.1, 49.95 ), Angle(-0,-0,32 ), "tail_glow" },
	[88] = { Vector( -8.4, -119.2, 50 ), Angle(-0,-0,34 ), "tail_glow" },
	[89] = { Vector( -6.4, -119.3, 50.05 ), Angle(-0,-0,34 ), "tail_glow" },
	[90] = { Vector( -4.4, -119.4, 50.1 ), Angle(-0,-0,34 ), "tail_glow" },
	[91] = { Vector( -2.3, -119.4, 50.1 ), Angle(-0,-0,34 ), "tail_glow" },
	[92] = { Vector( -0, -119.4, 50.1 ), Angle(-0,-0,34 ), "tail_glow" },
 
	[93] = { Vector( 2.3, -119.4, 50.1 ), Angle(-0,-0,34 ), "tail_glow" },
	[94] = { Vector( 4.4, -119.4, 50.1 ), Angle(-0,-0,34 ), "tail_glow" },
	[95] = { Vector( 6.4, -119.3, 50.05 ), Angle(-0,-0,34 ), "tail_glow" },
	[96] = { Vector( 8.4, -119.2, 50 ), Angle(-0,-0,34 ), "tail_glow" },
	[97] = { Vector( 10.4, -119.1, 49.95 ), Angle(-0,-0,32 ), "tail_glow" },
	[98] = { Vector( 12.4, -118.9, 49.88 ), Angle(-0,-0,32 ), "tail_glow" },
	[99] = { Vector( 14.4, -118.7, 49.8 ), Angle(-0,5,32 ), "tail_glow" },
	[100] = { Vector( 16.4, -118.4, 49.7 ), Angle(-0,5,32 ), "tail_glow" },
	[101] = { Vector( 18.4, -118.1, 49.6 ), Angle(-0,5,32 ), "tail_glow" },
	[102] = { Vector( 20.4, -117.9, 49.5 ), Angle(-0,5,32 ), "tail_glow" },
	[103] = { Vector( 22.4, -117.5, 49.35 ), Angle(-0,5,30 ), "tail_glow" },
	[104] = { Vector( 24.4, -117.2, 49.2 ), Angle(-0,10,30 ), "tail_glow" }, 
	[105] = { Vector( 26.4, -116.6, 49 ), Angle(-0,10,30 ), "tail_glow" },
	[106] = { Vector( 28.4, -116.2, 48.8 ), Angle(-0,15,30), "tail_glow" },

}

PI.States = {}
 
PI.States.Headlights = {}
PI.States.Brakes = {
	{ 7, R }, { 8, R },
	{ 9, R }, { 10, R },
	{ 11, R }, { 12, R },
	{ 21, DGR, .2 },
	{ 22, DGR, .2}, { 23, DGR, .2}, { 24, DGR, .2}, { 25, DGR, .2}, { 26, DGR, .2},
	{ 27, DGR, .2}, { 28, DGR, .2}, { 29, DGR, .2}, { 30, DGR, .2}, { 31, DGR, .2},
	{ 32, DGR, 00 }, { 33, DGR, .2}, { 34, DGR, .2}, { 35, DGR, .2}, { 36, DGR, .2},
	{ 37, DGR, .2}, { 38, DGR, .2}, { 39, DGR, .2}, { 40, DGR, .2}, { 41, DGR, .2},	
	{ 42, DGR, .2}, { 43, DGR, .2}, { 44, DGR, .2}, { 45, DGR, .2},	{ 46, DGR, .2},	
	{ 47, DGR, 00 }, { 48, DGR, .2}, { 49, DGR, .2}, { 50, DGR, .2}, { 51, DGR, .2}, 
	{ 52, DGR, .2}, { 53, DGR, .2}, { 54, DGR, .2}, { 55, DGR, .2}, { 56, DGR, .2}, 
	{ 57, DGR, .2}, { 58, DGR, .2}, { 59, DGR, .2}, { 60, DGR, .2}, { 61, DGR, .2}, 
	{ 62, DGR, .2}, { 63, DGR, .2}, { 64, DGR, .2}, { 65, DGR, .2}, { 66, DGR, .2},
	{ 67, DGR, .2}, { 68, DGR, .2}, { 69, DGR, .2}, { 70, DGR, .2}, { 71, DGR, .2}, 
	{ 72, DGR, .2}, { 73, DGR, .2}, { 74, DGR, .2}, { 75, DGR, .2}, { 76, DGR, .2}, 
	{ 77, DGR, .2}, { 78, DGR, .2}, { 79, DGR, .2}, { 80, DGR, .2}, { 81, DGR, .2}, 
	{ 82, DGR, .2}, { 83, DGR, .2}, { 84, DGR, .2}, { 85, DGR, .2}, { 86, DGR, .2}, 
	{ 87, DGR, .2}, { 88, DGR, .2}, { 89, DGR, .2}, { 90, DGR, .2}, { 91, DGR, .2}, 
	{ 92, DGR, .2}, { 93, DGR, .2}, { 94, DGR, .2}, { 95, DGR, .2}, { 96, DGR, .2}, 
	{ 97, DGR, .2}, { 98, DGR, .2}, { 99, DGR, .2}, { 100, DGR, .2}, { 101, DGR, .2}, 
	{ 102, DGR, .2}, { 103, DGR, .2}, { 104, DGR, .2}, { 105, DGR, .2}, { 106, DGR, .2},
}

PI.States.Blink_Left = {
	{ 14, R }, { 16, R }, { 18, R }, { 20, R },

	{ 21, DGR, .25 },
	{ 22, DGR, .25 }, { 23, DGR, .25 }, { 24, DGR, .25 }, { 25, DGR, .25 }, { 26, DGR, .25 },
	{ 27, DGR, .25 }, { 28, DGR, .25 }, { 29, DGR, .25 }, { 30, DGR, .25 }, { 31, DGR, .25 },
	{ 32, DGR, 00 }, { 33, DGR, .25 }, { 34, DGR, .25 }, { 35, DGR, .25 },

	{ 4, A, 2 }
}

PI.States.Blink_Right = {
	{ 13, R }, { 15, R }, { 17, R }, { 19, R },

	{ 36, DGR, .25 },
	{ 37, DGR, .25 }, { 38, DGR, .25 }, { 39, DGR, .25 }, { 40, DGR, .25 }, { 41, DGR, .25 },	
	{ 42, DGR, .25 }, { 43, DGR, .25 }, { 44, DGR, .25 }, { 45, DGR, .25 },	{ 46, DGR, .25 },	
	{ 47, DGR, 00 }, { 48, DGR, .25 }, { 49, DGR, .25 }, { 50, DGR, .25 },

	{ 3, A, 2 }
}

PI.States.Reverse = {
	{ 5, W }, { 6, W },
}

PI.States.Running = {
	{ 1, CW }, { 2, CW },
	{ 3, A }, { 4, A },
	
	{ 21, DGR, .07 },
	{ 22, DGR, .07}, { 23, DGR, .07}, { 24, DGR, .07}, { 25, DGR, .07}, { 26, DGR, .07},
	{ 27, DGR, .07}, { 28, DGR, .07}, { 29, DGR, .07}, { 30, DGR, .07}, { 31, DGR, .07},
	{ 32, DGR, 00 }, { 33, DGR, .07}, { 34, DGR, .07}, { 35, DGR, .07}, { 36, DGR, .07},
	{ 37, DGR, .07}, { 38, DGR, .07}, { 39, DGR, .07}, { 40, DGR, .07}, { 41, DGR, .07},	
	{ 42, DGR, .07}, { 43, DGR, .07}, { 44, DGR, .07}, { 45, DGR, .07},	{ 46, DGR, .07},	
	{ 47, DGR, 00 }, { 48, DGR, .07}, { 49, DGR, .07}, { 50, DGR, .07}, { 51, DGR, .07}, 
	{ 52, DGR, .07}, { 53, DGR, .07}, { 54, DGR, .07}, { 55, DGR, .07}, { 56, DGR, .07}, 
	{ 57, DGR, .07}, { 58, DGR, .07}, { 59, DGR, .07}, { 60, DGR, .07}, { 61, DGR, .07}, 
	{ 62, DGR, .07}, { 63, DGR, .07}, { 64, DGR, .07}, { 65, DGR, .07}, { 66, DGR, .07},
	{ 67, DGR, .07}, { 68, DGR, .07}, { 69, DGR, .07}, { 70, DGR, .07}, { 71, DGR, .07}, 
	{ 72, DGR, .07}, { 73, DGR, .07}, { 74, DGR, .07}, { 75, DGR, .07}, { 76, DGR, .07}, 
	{ 77, DGR, .07}, { 78, DGR, .07}, { 79, DGR, .07}, { 80, DGR, .07}, { 81, DGR, .07}, 
	{ 82, DGR, .07}, { 83, DGR, .07}, { 84, DGR, .07}, { 85, DGR, .07}, { 86, DGR, .07}, 
	{ 87, DGR, .07}, { 88, DGR, .07}, { 89, DGR, .07}, { 90, DGR, .07}, { 91, DGR, .07}, 
	{ 92, DGR, .07}, { 93, DGR, .07}, { 94, DGR, .07}, { 95, DGR, .07}, { 96, DGR, .07}, 
	{ 97, DGR, .07}, { 98, DGR, .07}, { 99, DGR, .07}, { 100, DGR, .07}, { 101, DGR, .07}, 
	{ 102, DGR, .07}, { 103, DGR, .07}, { 104, DGR, .07}, { 105, DGR, .07}, { 106, DGR, .07},
}

Photon.VehicleLibrary["st_charger"] = PI