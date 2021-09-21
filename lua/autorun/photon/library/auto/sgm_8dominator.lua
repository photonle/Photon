AddCSLuaFile()

local name = "Whelen Dominator 8"

local W = "S_WHITE"
local COMPONENT = {}

COMPONENT.Model = "models/sentry/props/dominator8_photon.mdl"
COMPONENT.Lightbar = true
COMPONENT.Skin = 0
COMPONENT.Category = "Lightbar" 
COMPONENT.Bodygroups = {}
COMPONENT.DefaultColors = {
    [1] = "AMBER",
}

COMPONENT.Meta = {
	dominator = {
		AngleOffset = 90,
		W = 3.2,
		H = 3.2,
		Sprite = "sentry/props/dominator_photon/tir3_sprite",
		WMult = .5,
		Scale = .36,
		EmitArray = {
			Vector( -1, 0, 0 ),
			Vector( 0, 0, 0 ),
			Vector( 1, 0, 0 ),
		}
	},
}

COMPONENT.Positions = {

	[1] = { Vector( -0.2, -14.75, 0.01 ), Angle( 0, 0, 0 ), "dominator" },
	[2] = { Vector( -0.2, 14.75, 0.01 ), Angle( 0, 0, 0 ), "dominator" },
	[3] = { Vector( -0.2, -10.52, 0.01 ), Angle( 0, 0, 0 ), "dominator" },
	[4] = { Vector( -0.2, 10.52, 0.01 ), Angle( 0, 0, 0 ), "dominator" },
	[5] = { Vector( -0.2, -6.33, 0.01 ), Angle( 0, 0, 0 ), "dominator" },
	[6] = { Vector( -0.2, 6.33, 0.01 ), Angle( 0, 0, 0 ), "dominator" },
	[7] = { Vector( -0.2, -2.14, 0.01 ), Angle( 0, 0, 0 ), "dominator" },
	[8] = { Vector( -0.2, 2.14, 0.01 ), Angle( 0, 0, 0 ), "dominator" },
	--Vector( -14.75, 0.2, 0.01 ), Angle( 0, 0, 0 )
}

COMPONENT.Sections = {
	["auto_dom"] = {
        [1] = { { 1, "_1" },{ 2, "_1" },{ 3, "_1" },{ 4, "_1" },{ 5, "_1" },{ 6, "_1" },{ 7, "_1" },{ 8, "_1" }, },
		[2] = { { 1, "_1"},{ 2, "_1"},{ 3, "_1"},{ 4, "_1"}, },
		[3] = { { 5, "_1"},{ 6, "_1"},{ 7, "_1"},{ 8, "_1"}, },
		[4] = { { 3, "_1" } },
		[5] = { { 6, "_1" } },
		[6] = { { 7, "_1" } },
		[7] = { { 7, "_1" }, { 2, "_1" } },
		[8] = { { 5, "_1" } },
		[9] = { { 4, "_1" } },
		[10] = { { 1, "_1" } },
		[11] = { { 8, "_1" } },
		[12] = { { 2, "_1" }, { 5, "_1" } },
		[13] = { { 1, "_1" }, { 2, "_1" } },
		[14] = { { 1, "_1" }, { 8, "_1" } },
		[15] = { { 3, "_1" }, { 6, "_1" } },	
		[16] = { { 7, "_1" }, { 6, "_1" } },
		[17] = { { 7, "_1" }, { 2, "_1" } },
		[18] = { { 4, "_1" }, { 5, "_1" } },
		[19] = { { 1, "_1" }, { 8, "_1" } },
		[20] = { { 3, "_1" }, { 6, "_1" } },
		[21] = { { 6, "_1" }, { 7, "_1" } },
		[22] = { { 2, "_1" }, { 5, "_1" } },
		[23] = { { 1, "_1" }, { 4, "_1" } },
		[24] = { { 3, "_1" }, { 8, "_1" } },
		[25] = { { 7, "_1" }, { 2, "_1" } },
		[26] = { { 5, "_1" }, { 2, "_1" } },
		[27] = { { 1, "_1" }, { 8, "_1" } },
		[28] = { { 2, "_1" }, { 6, "_1" } },
		[29] = { { 2, "_1" }, { 5, "_1" } },
		[30] = { { 4, "_1" }, { 5, "_1" } },
		[31] = { { 3, "_1" }, { 8, "_1" } },
		[32] = { { 7, "_1" }, { 2, "_1" } },
		[33] = { { 4, "_1" }, { 5, "_1" } },
		[34] = { { 3, "_1" }, { 8, "_1" } },
		[35] = { { 2, "_1" }, { 6, "_1" } },
		[36] = { { 2, "_1" }, { 5, "_1" } },
		[37] = { { 1, "_1" }, { 8, "_1" } },
		[38] = { { 3, "_1" }, { 6, "_1" } },
		[39] = { { 2, "_1" }, { 7, "_1" } },
		[40] = { { 1, "_1" }, { 4, "_1" } },
		[41] = { { 3, "_1" }, { 6, "_1" } },
		[42] = { { 1, "_1" },{ 3, "_1" },{ 5, "_1" }, { 7, "_1" }, },
		[43] = { { 2, "_1" },{ 4, "_1" },{ 6, "_1" }, { 8, "_1" }, },
		[44] = { { 1, "_1" },{ 5, "_1" },{ 8, "_1" }, { 4, "_1" }, },
		[45] = { { 3, "_1" },{ 2, "_1" },{ 6, "_1" }, { 7, "_1" }, },
		[46] = { { 2, "_1" } },
		[47] = { { 2, "_1" }, { 4, "_1" } },
		[48] = { { 4, "_1" }, { 6, "_1" } },
		[49] = { { 6, "_1" }, { 8, "_1" } },
		[50] = { { 8, "_1" }, { 7, "_1" } },
		[51] = { { 7, "_1" }, { 5, "_1" } },
		[52] = { { 5, "_1" }, { 3, "_1" } },
		[53] = { { 3, "_1" }, { 1, "_1" } },
		[54] = { { 2, "_1" }, { 1, "_1" } },
		[55] = { { 2, "_1" }, { 4, "_1" }, { 1, "_1" } },
		[56] = { { 4, "_1" }, { 6, "_1" }, { 1, "_1" } },
		[57] = { { 6, "_1" }, { 8, "_1" }, { 1, "_1" } },
		[58] = { { 8, "_1" }, { 7, "_1" }, { 1, "_1" } },
		[59] = { { 7, "_1" }, { 5, "_1" }, { 1, "_1" } },
		[60] = { { 5, "_1" }, { 3, "_1" }, { 1, "_1" } },
		[61] = { { 3, "_1" }, { 1, "_1" }, },
		[62] = { { 1, "_1" }, },
		[63] = { { 8, "_1" },{ 7, "_1" }, },
		[64] = { { 5, "_1" },{ 6, "_1" }, { 4, "_1" },{ 3, "_1" }, },
		[65] = { { 1, "_1" },{ 2, "_1" }, },
		[66] = { { 8, "_1" },{ 7, "_1" }, { 1, "_1" },{ 2, "_1" }, },
		[67] = { { 5, "_1" },{ 6, "_1" }, { 4, "_1" },{ 3, "_1" }, { 1, "_1" },{ 2, "_1" }, },
		[68] = { { 1, "_1" } },
		[69] = { { 1, "_1" }, { 3, "_1" } },
		[70] = { { 3, "_1" }, { 5, "_1" } }, 
		[71] = { { 5, "_1" }, { 7, "_1" } },
		[72] = { { 7, "_1" }, { 8, "_1" } },
		[73] = { { 8, "_1" }, { 6, "_1" } },
		[74] = { { 6, "_1" }, { 4, "_1" } },
		[75] = { { 4, "_1" }, { 2, "_1" } },
		[76] = { { 1, "_1" }, { 2, "_1" } },	
		[77] = { { 1, "_1" }, { 2, "_1" } },--
		[78] = { { 1, "_1" }, { 3, "_1" }, { 2, "_1" } },
		[79] = { { 3, "_1" }, { 5, "_1" }, { 2, "_1" } }, 
		[80] = { { 5, "_1" }, { 7, "_1" }, { 2, "_1" } },
		[81] = { { 7, "_1" }, { 8, "_1" }, { 2, "_1" } },
		[82] = { { 8, "_1" }, { 6, "_1" }, { 2, "_1" } },
		[83] = { { 6, "_1" }, { 4, "_1" }, { 2, "_1" } },
		[84] = { { 4, "_1" }, { 2, "_1" } },
		[85] = { { 2, "_1" } },
    },
}

COMPONENT.Patterns = {
	["auto_dom"] = {
		["code1"] = { 2, 2, 2, 2, 3, 3, 3, 3, },
		["code2"] = { 42, 42, 43, 43, 42, 42, 43, 43, 42, 42, 43, 43, 42, 42, 43, 43, 42, 42, 43, 43, 2, 2, 3, 3, 2, 2, 3, 3, 2, 2, 3, 3, 2, 2, 3, 3, 2, 2, 3, 3, 44, 44, 45, 45, 44, 44, 45, 45, 44, 44, 45, 45, 44, 44, 45, 45, 44, 44, 45, 45, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, },
		["sgm"] = { 4, 0, 5, 0, 6, 0, 7, 0, 8, 0, 9, 0, 10, 0, 11, 0, 12, 0, 13, 0, 14, 0, 15, 0, 16, 0, 17, 0, 18, 0, 19, 0, 20, 0, 21, 0, 22, 0, 23, 0, 24, 0, 25, 0, 26, 0, 27, 0, 28, 0, 29, 0, 30, 0, 31, 0, 32, 0, 33, 0, 34, 0, 35, 0, 36, 0, 37, 0, 38, 0, 39, 0, 40, 0, 41, 0, 1, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0, 0, 2, 0, 2, 2, 0, 0, 3, 0, 3, 3, 0, 0, 2, 0, 2, 2, 0, 0, },
		["alert"] = { 1,2,3,2,3,2,3,1,1,1,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,}, 
		["left"] = { 46, 46, 47, 47, 48, 48, 49, 49, 50, 50, 51, 51, 52, 52, 53, 53, 54, 54, 55, 55, 56, 56, 57, 57, 58, 58, 59, 59, 60, 60, 61, 61, 62, 62 },
		["diverge"] = { 63, 63, 63, 64, 64, 64, 65, 65, 65, 66, 66, 66, 67, 67, 67, 65, 65, 65, 0, 0, 0,},
		["right"] = { 68, 68, 69, 69, 70, 70, 71, 71, 72, 72, 73, 73, 74, 74, 75, 75, 76 ,76, 78, 78, 79, 79, 80, 80, 81, 81, 82, 82, 83, 83, 84, 84, 85, 85, 86, 86 },
    },
}


COMPONENT.Modes = {
	Primary = {
		M1 = { ["auto_dom"] = "code1", },
		M2 = { ["auto_dom"] = "code2", },
		M3 = { ["auto_dom"] = "sgm", },
		ALERT = { ["auto_dom"] = "alert", },
	},
	Auxiliary = {
		L = { ["auto_dom"] = "left", },
		D = { ["auto_dom"] = "diverge" },
		R = { ["auto_dom"] = "right" },
	},
	Illumination = {}
}

EMVU:AddAutoComponent( COMPONENT, name )

