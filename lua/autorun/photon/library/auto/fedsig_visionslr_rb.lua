-- AddCSLuaFile()

-- local A = "AMBER"
-- local R = "RED"
-- local DR = "D_RED"
-- local B = "BLUE"
-- local W = "WHITE"
-- local CW = "C_WHITE"
-- local SW = "S_WHITE"
-- local G = "GREEN"
-- local RB = "BLUE/RED"

-- local name = "Federal Signal Vision SLR R/B"

-- local COMPONENT = {}

-- COMPONENT.Model = "models/schmal/fedsig_visionslr/vision_lightbar.mdl"
-- COMPONENT.Skin = 2
-- COMPONENT.Lightbar = true
-- COMPONENT.Bodygroups = {}
-- COMPONENT.Category = "Lightbar"

-- COMPONENT.Meta = {
-- 	visionslr_a = {
-- 		AngleOffset = "R",
-- 		Speed = 10,
-- 		W = 8,
-- 		H = 4,
-- 		Sprite = "sprites/emv/visionslr",
-- 		Scale = 2.5,
-- 		WMult = 1.33,
-- 	},
-- 	visionslr_b = {
-- 		AngleOffset = "R",
-- 		W = 8,
-- 		H = 4,
-- 		Speed = 8,
-- 		Sprite = "sprites/emv/visionslr",
-- 		Scale = 1.75,
-- 		WMult = 1.33,
-- 	},
-- 	visionslr_rear = {
-- 		AngleOffset = 90,
-- 		W = 6.2,
-- 		H = 6,
-- 		Sprite = "sprites/emv/visionslr_rear",
-- 		Scale = 1,
-- 		WMult = 2,
-- 	},
-- 	visionslr_side = {
-- 		AngleOffset = -90,
-- 		W = 7,
-- 		H = 6.4,
-- 		Sprite = "sprites/emv/visionslr_side",
-- 		Scale = 1,
-- 		WMult = 2.25,
-- 	},
-- 	visionslr_illum = {
-- 		AngleOffset = -90,
-- 		W = 8,
-- 		H = 4,
-- 		Sprite = "sprites/emv/visionslr",
-- 		Scale = 2,
-- 		WMult = 1.5,
-- 	},
-- }

-- COMPONENT.Positions = {

-- 	[1] = { Vector( 0, 16.78, 2.05 ), Angle( 0, 0, 0 ), "visionslr_b" },

-- 	[2] = { Vector( -8.02, 10.28, 2.05 ), Angle( 0, -90, 0 ), "visionslr_a" },
-- 	[3] = { Vector( 8.02, 10.28, 2.05 ), Angle( 0, 90, 0 ), "visionslr_a" },

-- 	[4] = { Vector( -16.03, 2.6, 2.05 ), Angle( 0, 180, 0 ), "visionslr_b" },
-- 	[5] = { Vector( 16.03, 2.6, 2.05 ), Angle( 0, 180, 0 ), "visionslr_b" },

-- 	[6] = { Vector( -24.13, -5.03, 2.05 ), Angle( 0, 90, 0 ), "visionslr_a" },
-- 	[7] = { Vector( 24.13, -5.03, 2.05 ), Angle( 0, -90, 0 ), "visionslr_a" },

-- 	[8] = { Vector( -15.48, -13.16, 0.03 ), Angle( 0, 0, 0 ), "visionslr_rear" },
-- 	[9] = { Vector( 15.48, -13.16, 0.03 ), Angle( 0, 0, 0 ), "visionslr_rear" },

-- 	[10] = { Vector( -9.35, -13.16, 0.03 ), Angle( 0, 0, 0 ), "visionslr_rear" },
-- 	[11] = { Vector( 9.35, -13.16, 0.03 ), Angle( 0, 0, 0 ), "visionslr_rear" },

-- 	[12] = { Vector( -3.18, -13.16, 0.03 ), Angle( 0, 0, 0 ), "visionslr_rear" },
-- 	[13] = { Vector( 3.18, -13.16, 0.03 ), Angle( 0, 0, 0 ), "visionslr_rear" },

-- 	[14] = { Vector( -30.28, -8.11, 0.13 ), Angle( 0, 90, 11.7 ), "visionslr_side" },
-- 	[15] = { Vector( 30.28, -8.11, 0.13 ), Angle( 0, -90, 11.7 ), "visionslr_side" },

-- 	[16] = { Vector( -8.02, 10.28, 2.05 ), Angle( 0, 0, 0 ), "visionslr_illum" },
-- 	[17] = { Vector( 8.02, 10.28, 2.05 ), Angle( 0, 0, 0 ), "visionslr_illum" },

-- }

-- COMPONENT.Sections = {
-- 	["auto_fedsig_visionslr_rb"] = {
-- 		{},
-- 		{
-- 			{ 1, W },
-- 			{ 2, B }, { 3, R },
-- 			{ 4, W }, { 5, W },
-- 			{ 6, R }, { 7, B },
-- 		},
-- 		{
-- 			{ 6, R }, { 7, B },
-- 		},
-- 		{
-- 			{ 2, B }, { 3, R },
-- 			{ 6, R }, { 7, B },
-- 		}
-- 	},
-- 	["auto_fedsig_visionslr_rb_traffic"] = {
-- 		{ { 8, A }, { 9, A }, { 10, A }, { 11, A } },
-- 		{ { 12, A }, { 13, A } },
-- 		{ { 9, A }, { 11, A }, { 13, A } },
-- 		{ { 8, A }, { 10, A }, { 12, A } },
-- 		{ { 8, A } },
-- 		{ { 8, A }, { 10, A } },
-- 		{ { 8, A }, { 10, A }, { 12, A } },
-- 		{ { 8, A }, { 10, A }, { 12, A }, { 13, A } },
-- 		{ { 8, A }, { 10, A }, { 12, A }, { 13, A }, { 11, A } },
-- 		{ { 8, A }, { 10, A }, { 12, A }, { 13, A }, { 11, A }, { 9, A } },
-- 		{ { 9, A } },
-- 		{ { 11, A }, { 9, A } },
-- 		{ { 13, A }, { 11, A }, { 9, A } },
-- 		{ { 12, A }, { 13, A }, { 11, A }, { 9, A } },
-- 		{ { 10, A }, { 12, A }, { 13, A }, { 11, A }, { 9, A } },
-- 		[16] = { { 12, A }, { 13, A }, },
-- 		[17] = { { 10, A }, { 12, A }, { 13, A }, { 11, A }, },
-- 	},
-- }

-- COMPONENT.Patterns = {
-- 	["auto_fedsig_visionslr_rb"] = {
-- 		["all"] = { 1 },
-- 		["code1"] = { 3 },
-- 		["code2"] = { 4 },
-- 		["code3"] = { 2 }
-- 	},
-- 	["auto_fedsig_visionslr_rb_traffic"] = {
-- 		["warn"] = { 1, 1, 1, 1, 0, 2, 2, 2, 2, 0 },
-- 		["code1"] = { 3, 3, 3, 3, 3, 4, 4, 4, 4, 4 },
-- 		["right"] = { 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 10, 10, 0, 0 },
-- 		["left"] = { 11, 11, 12, 12, 13, 13, 14, 14, 15, 15, 10, 10, 10, 10, 0, 0 },
-- 		["diverge"] = { 16, 16, 16, 17, 17, 17, 10, 10, 10, 10, 0, 0 }
-- 	}
-- }

-- COMPONENT.Modes = {
-- 	Primary = {
-- 			M1 = {
-- 				["auto_fedsig_visionslr_rb"] = "code1",
-- 				["auto_fedsig_visionslr_rb_traffic"] = "code1",
-- 			},
-- 			M2 = {
-- 				["auto_fedsig_visionslr_rb"] = "code2",
-- 				["auto_fedsig_visionslr_rb_traffic"] = "warn",
-- 			},
-- 			M3 = {
-- 				["auto_fedsig_visionslr_rb"] = "code3",
-- 				["auto_fedsig_visionslr_rb_traffic"] = "warn",
-- 			}
-- 		},
-- 	Auxiliary = {
-- 			L = {
-- 				["auto_fedsig_visionslr_rb_traffic"] = "left"
-- 			},
-- 			R = {
-- 				["auto_fedsig_visionslr_rb_traffic"] = "right"
-- 			},
-- 			D = {
-- 				["auto_fedsig_visionslr_rb_traffic"] = "diverge"
-- 			}
-- 		},
-- 	Illumination = {
-- 		L = {
-- 			{ 14, W }
-- 		},
-- 		R = {
-- 			{ 15, W }
-- 		},
-- 		T = {
-- 			{ 16, W }, { 17, W }
-- 		},
-- 		F = {
-- 			{ 16, W }, { 17, W }
-- 		}
-- 	}
-- }

-- EMVU:AddAutoComponent( COMPONENT, name )