AddCSLuaFile()

local name = "Ford Taurus 2013"

local W = "WHITE"

local EMV = {}

EMV.Siren = 46

-- EMV.Skin = "fpiu16_liveries/Blank"

EMV.Color = Color(255, 255, 255)

EMV.BodyGroups = {
	{ 10, 5 }
}

EMV.Props = {
	[1] = {
		Model = "models/schmal/whelen_cencom_panel.mdl",
		Scale = 1,
		Pos = Vector(.35, 30.7, 37.5),
		Ang = Angle( 0, 180, 85),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[2] = {
		Model = "models/schmal/motorola_car_radio.mdl",
		Scale = 1,
		Pos = Vector(.35, 21.5, 36.4),
		Ang = Angle( 0, 180, 0),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[3] = {
		Model = "models/schmal/motorola_car_radio.mdl",
		Scale = 1,
		Skin = 1,
		Pos = Vector(.35, 26, 36.8),
		Ang = Angle( 0, 180, -5),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[4] = {
		Model = "models/schmal/laptop_stand.mdl",
		Scale = .5,
		Pos = Vector(10, 33, 32),
		Ang = Angle( 0, 150, 0),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[5] = {
		Model = "models/tdmcars/emergency/equipment/laptop.mdl",
		Scale = 1,
		Pos = Vector(5, 24, 43),
		Ang = Angle( 0, 130, 0)
	},
	[6] = {
		Model = "models/schmal/stalker_dual_main.mdl",
		Scale = .25,
		Pos = Vector(.9, 51, 54.4),
		Ang = Angle( 0, 0, 0),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[7] = {
		Model = "models/schmal/watchguard_screen.mdl",
		Scale = .75,
		Pos = Vector(5, 22, 74),
		Ang = Angle( 0, -100, 0),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[8] = {
		Model = "models/schmal/watchguard_camera.mdl",
		Scale = .75,
		Pos = Vector(.35, 40, 65),
		Ang = Angle( 0, -90, 0),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[9] = {
		Model = "models/schmal/whelen_spotlight.mdl",
		Scale = .9,
		Pos = Vector(-37, 40, 60),
		Ang = Angle( 15, 120, -10),
		RenderGroup = RENDERGROUP_BOTH,
		RenderMode = RENDERGROUP_TRANSLUCENT
	},
	[10] = {
		Model = "models/schmal/antennas/antenna_6.mdl",
		Scale = 2,
		Pos = Vector(0, -25, 87.2),
		Ang = Angle( 0, 0, 1),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[11] = {
		Model = "models/schmal/antennas/antenna_4.mdl",
		Scale = 2,
		Pos = Vector(6, -29, 87),
		Ang = Angle( 0, 0, 1),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[12] = {
		Model = "models/schmal/antennas/antenna_2.mdl",
		Scale = 2,
		Pos = Vector(0, -33, 76),
		Ang = Angle( 0, 0, 1),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[13] = {
		Model = "models/tdmcars/emergency/equipment/pushbar.mdl",
		Scale = 1.4,
		Pos = Vector( 0, 128, 14 ),
		Ang = Angle( 0, -90, 0),
		RenderGroup = RENDERGROUP_TRANSLUCENT,
		RenderMode = RENDERMODE_TRANSALPHA
	},
	[14] = {
		Model = "models/schmal/antennas/antenna_5.mdl",
		Scale = Vector(1,1,2.5),
		Pos = Vector( -22, -102, 72 ),
		Ang = Angle( 1, -90, 0),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[15] = {
		Model = "models/schmal/antennas/antenna_5.mdl",
		Scale = Vector(1,1,2.5),
		Pos = Vector( 22, -102, 72 ),
		Ang = Angle( 1, -90, 0),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[16] = {
		Model = "models/schmal/alpr_camera_minimal.mdl",
		Scale = .66,
		Pos = Vector( -31, -100, 61 ),
		Ang = Angle( 10, 210, 0),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[17] = {
		Model = "models/schmal/alpr_camera_minimal.mdl",
		Scale = .66,
		Pos = Vector( 31, -100, 61 ),
		Ang = Angle( 10, -30, 0),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[18] = {
		Model = "models/schmal/fpiu_wrap.mdl",
		Scale = 1,
		Pos = Vector( 32, 115, 30 ),
		Ang = Angle( 5, 90, 0),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[19] = {
		Model = "models/schmal/fpiu_wrap.mdl",
		Scale = 1,
		Pos = Vector( -32, 115, 30 ),
		Ang = Angle( 5, 90, 180),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[20] = {
		Model = "models/schmal/tahoe_airel.mdl",
		Scale = .95,
		Pos = Vector(.1, -39, 74.5),
		Ang = Angle( -4, 90, 0),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL,
		AirEL = true
	},
	[21] = {
		Model = "models/schmal/antennas/antenna_6.mdl",
		Scale = 2,
		Pos = Vector(0, -28, 88),
		Ang = Angle( 0, 0, 5),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[22] = {
		Model = "models/schmal/antennas/antenna_4.mdl",
		Scale = 2,
		Pos = Vector(6, -49.7, 86),
		Ang = Angle( 0, 0, 5),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[23] = {
		Model = "models/schmal/antennas/antenna_2.mdl",
		Scale = 2,
		Pos = Vector(-6, -49, 76),
		Ang = Angle( 0, 0, 5),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[24] = {
		Model = "models/schmal/alpr_camera_minimal.mdl",
		Scale = .66,
		Pos = Vector( 22, -28, 79 ),
		Ang = Angle( 10, 20, 6),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[25] = {
		Model = "models/schmal/alpr_camera_minimal.mdl",
		Scale = .66,
		Pos = Vector( -22, -28, 79 ),
		Ang = Angle( 10, 150, -6),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[26] = {
		Model = "models/schmal/alpr_camera_minimal.mdl",
		Scale = .66,
		Pos = Vector( 22, -48, 77.5 ),
		Ang = Angle( 10, 0, 6),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[27] = {
		Model = "models/schmal/alpr_camera_minimal.mdl",
		Scale = .66,
		Pos = Vector( -22, -48, 77.5 ),
		Ang = Angle( 10, 180, -6),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[28] = {
		Model = "models/tdmcars/emergency/equipment/pushrod.mdl",
		Scale = 1.1,
		Pos = Vector( 0, 106, 16 ),
		Ang = Angle( 0, -90, 0),
		Color = Color( 0, 0, 0 ),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
}

EMV.Meta = {
	spotlight = {
		AngleOffset = -90,
		W = 7,
		H = 7,
		Sprite = "sprites/emv/light_circle",
		Scale = 3,
	}
}

EMV.Positions = {
	[1] = { Vector( 39.64, 50.84, 63.49 ), Angle( 17.26, 0, 0 ), "spotlight" },
	[2] = { Vector( -39.64, 50.84, 63.49 ), Angle( 17.26, 0, 0 ), "spotlight" },
}

EMV.Sections = {

}

EMV.Patterns = { -- 0 = blank

}

EMV.Sequences = {
		Sequences = {
		{
			Name = "STAGE 1",
			Stage = "M1",
			Components = {},
			Disconnect = { 24, 25 }
		},
		{
			Name = "STAGE 2",
			Stage = "M2",
			Components = {},
			Disconnect = { 24, 25 }
		},
		{
			Name = "STAGE 3",
			Stage = "M3",
			Components = {},
			Disconnect = { 15, 16, 28, 29, 24, 25 }
		},
	},
	Traffic = {
		{ Name = "CRUISE", Stage = "C", Components = {}, Disconnect = {} },
		{ Name = "LEFT", Stage = "L", Components = {}, Disconnect = {} },
		{ Name = "DIVERGE", Stage = "D", Components = {}, Disconnect = {} },
		{ Name = "RIGHT", Stage = "R", Components = {}, Disconnect = {} }
	},
	Illumination = {
		{
			Name = "TKDN",
			Icon = "takedown",
			Stage = "T",
			Components = {},
			BG_Components = {
				["spotlights"] = {
					["0"] = {
						{ 1, W, 2 },
						{ 2, W, 2 }
					},
				},
			},
			Preset_Components = {},
			Lights = {
				{ Vector( 0, 25, 65 ), Angle( 20, 90, 0 ), "takedown" },
			},
			Disconnect = {}
		},
		{
			Name = "LEFT",
			Icon = "alley-left",
			Stage = "L",
			Components = {},
			BG_Components = {},
			Preset_Components = {},
			Lights = {
				{ Vector( -10, -10, 65 ), Angle( 20, 180, 0 ), "alley" },
			},
			Disconnect = {}
		},
		{
			Name = "RIGHT",
			Icon = "alley-right",
			Stage = "R",
			Components = {},
			BG_Components = {},
			Preset_Components = {},
			Lights = {
				{ Vector( 10, -10, 65 ), Angle( 20, 0, 0 ), "alley" },
			},
			Disconnect = {}
		},
		{
			Name = "FULL",
			Icon = "takedown",
			Stage = "F",
			Components = {},
			BG_Components = {
				["spotlights"] = {
					["0"] = {
						{ 1, W, 2 },
						{ 2, W, 2 }
					},
				},
			},
			Preset_Components = {},
			Lights = {
				{ Vector( 0, 25, 80 ), Angle( 10, 90, 0 ), "flood" },
			},
			Disconnect = {}
		},
	}
}

EMV.Lamps = {
	["alley"] = {
		Color = Color(215,225,255,255),
		Texture = "effects/flashlight001",
		Near = 110,
		FOV = 90,
		Distance = 500,
	},
	["takedown"] = {
		Color = Color(215,225,255,255),
		Texture = "effects/flashlight001",
		Near = 120,
		FOV = 135,
		Distance = 800,
	},
	["flood"] = {
		Color = Color(215,225,255,255),
		Texture = "effects/flashlight001",
		Near = 120,
		FOV = 135,
		Distance = 1400,
	},
}

EMV.Auto = {
	[1] = {
		ID = "Federal Signal Integrity",
		Scale = .92,
		Pos = Vector( 0, -8.9, 77.8 ),
		Ang = Angle( 1, 90, 0),
	},
	[2] = {
		ID = "Federal Signal Legend",
		Scale = .99,
		Pos = Vector( 0, -7.5, 78 ),
		Ang = Angle( 1, 90, 0),
	},
	[3] = {
		ID = "Federal Signal Valor",
		Scale = .86,
		Pos = Vector( 0, -2, 78.4 ),
		Ang = Angle( 2, 90, 0)
	},
	[4] = {
		ID = "Federal Signal Vision SLR",
		Scale = .88,
		Pos = Vector( 0, -9, 79.8 ),
		Ang = Angle( 1, 90, 0),
	},
	[5] = {
		ID = "Whelen Justice",
		Scale = 1.01,
		Pos = Vector( 0, -7.1, 79.6 ),
		Ang = Angle( 1, 90, 0),
	},
	[6] = {
		ID = "Whelen Legacy",
		Scale = .96,
		Pos = Vector( 0, -7, 77.8 ),
		Ang = Angle( 2, 90, 0),
	},
	[7] = {
		ID = "Whelen Liberty SX",
		Scale = .92,
		Pos = Vector( 0, -8, 77.8 ),
		Ang = Angle( 1, 90, 0),
	},
	[8] = {
		ID = "TDM Rear Interior Lightbar",
		Scale = .95,
		Pos = Vector( 0, -82, 60),
		Ang = Angle( 0, -90, 0 ),
	},
	[9] = {
		ID = "TDM Front Interior Lightbar",
		Scale = 1.12,
		Pos = Vector( 0, 28.1, 71.4),
		Ang = Angle( 0, 90, 0 ),
	},
	[10] = {
		ID = "Federal Signal Vision SLR R/B",
		Scale = .88,
		Pos = Vector( 0, -9, 80 ),
		Ang = Angle( 1, 90, 0),
	},
	[11] = {
		ID = "Federal Signal Vision SLR Clear",
		Scale = .88,
		Pos = Vector( 0, -9, 80 ),
		Ang = Angle( 1, 90, 0),
	},
	[12] = {
		ID = "TDM Pushbar LED",
		Scale = 1.1,
		Pos = Vector( 0, 125, 14.4 ),
		Ang = Angle( 0, -90, 0),
	},
	[13] = {
		ID = "Whelen 700 Trio",
		Scale = 1.1,
		Pos = Vector( -39, -80, 62.5),
		Ang = Angle( 0, 95, -90),
	},
	[14] = {
		ID = "Whelen 700 Trio",
		Scale = 1.1,
		Pos = Vector( 39, -80, 62.5),
		Ang = Angle( 0, 85, 90),
	},
	[15] = {
		ID = "Whelen Vertex",
		Scale = 1,
		Pos = Vector( -45.6, 97, 30),
		Ang = Angle( -70, -100, 80 ),
		AutoPatterns = true
	},
	[16] = {
		ID = "Whelen Vertex",
		Scale = 1,
		Pos = Vector( 45.6, 97, 30),
		Ang = Angle( -70, -80, -80 ),
		AutoPatterns = true
	},
	[17] = {
		ID = "Federal Signal Viper Dual",
		Scale = 1,
		Pos = Vector( 19, -65, 67.7),
		Ang = Angle( 2, -85, -2 ),
		Color1 = "BLUE",
		Color2 = "BLUE",
		Phase = "A"
	},
	[18] = {
		ID = "Federal Signal Viper Dual",
		Scale = 1,
		Pos = Vector( -19, -65, 67.7),
		Ang = Angle( 2, -105, 2 ),
		Color1 = "RED",
		Color2 = "RED",
		Phase = "B"
	},
	[19] = {
		ID = "Whelen Vertex",
		Scale = 1,
		Pos = Vector( -15, -119.4, 23),
		Ang = Angle( 0, -10, 90 ),
		Color1 = "RED",
		Phase = "A"
	},
	[20] = {
		ID = "Whelen Vertex",
		Scale = 1,
		Pos = Vector( 15, -119.4, 23),
		Ang = Angle( 0, 10, 90 ),
		Color1 = "BLUE",
		Phase = "B"
	},
	[21] = {
		ID = "Federal Signal Viper",
		Scale = 1,
		Pos = Vector( 25, 29.62, 65.6),
		Ang = Angle( 0, 85, 2 ),
		Color1 = "BLUE",
		Color2 = "WHITE",
		Phase = "A"
	},
	[22] = {
		ID = "Federal Signal Viper",
		Scale = 1,
		Pos = Vector( -25, 29.62, 65.6),
		Ang = Angle( 0, 95, -2 ),
		Color1 = "RED",
		Color2 = "WHITE",
		Phase = "B"
	},
	[23] = {
		ID = "Federal Signal Arjent",
		Scale = .85,
		Pos = Vector( 0, -7.5, 84.3 ),
		Ang = Angle( 2, 90, 0),
	},
	[24] = {
		ID = "TDM Rear Interior Lightbar",
		Scale = 1,
		Pos = Vector( 0, -82.8, 61.6),
		Ang = Angle( 0, -90, 0 ),
	},
	[25] = {
		ID = "Whelen Ultra Freedom",
		Scale = .96,
		Pos = Vector( 0, -7.4, 79.2 ),
		Ang = Angle( 2, 90, 0),
		AutoPatterns = true
	},
	[26] = {
		ID = "Whelen Legacy",
		Scale = .96,
		Pos = Vector( 0, -7, 77.8 ),
		Ang = Angle( 2, 90, 0),
		Color1 = "BLUE",
		Color2 = "BLUE"
	},
	[27] = {
		ID = "Whelen Legacy",
		Scale = .96,
		Pos = Vector( 0, -7, 77.8 ),
		Ang = Angle( 2, 90, 0),
		Color1 = "RED",
		Color2 = "RED"
	},
	[28] = {
		ID = "TDM Pushbar LED",
		Scale = 1.1,
		Pos = Vector( 0, 125, 14.4 ),
		Ang = Angle( 0, -90, 0),
		Color1 = "BLUE",
		Color2 = "BLUE"
	},
	[29] = {
		ID = "TDM Pushbar LED",
		Scale = 1.1,
		Pos = Vector( 0, 125, 14.4 ),
		Ang = Angle( 0, -90, 0),
		Color1 = "RED",
		Color2 = "RED"
	},
	[30] = {
		ID = "TDM Rear Interior Lightbar",
		Scale = 1,
		Pos = Vector( 0, -82.8, 61.6),
		Ang = Angle( 0, -90, 0 ),
		Color1 = "BLUE",
		Color2 = "BLUE"
	},
	[31] = {
		ID = "TDM Rear Interior Lightbar",
		Scale = 1,
		Pos = Vector( 0, -82.8, 61.6),
		Ang = Angle( 0, -90, 0 ),
		Color1 = "RED",
		Color2 = "RED"
	},
	[32] = {
		ID = "Whelen Liberty II",
		Scale = 1.04,
		Pos = Vector( 0, -7, 78.3 ),
		Ang = Angle( 1.7, 90, 0),
	},
	[33] = {
		ID = "Code 3 RX2700",
		Scale = .93,
		Pos = Vector( 0, -7.3, 78 ),
		Ang = Angle( 1.7, 90, 0),
	},
	[34] = {
		ID = "Whelen Ion Split",
		Scale = .9,
		Pos = Vector( 10, 116, 37 ),
		Ang = Angle( 0, -6, 10 ),
	},
	[35] = {
		ID = "Whelen Ion Split",
		Scale = .9,
		Pos = Vector( -10, 116, 37 ),
		Ang = Angle( 0, 6, 10 ),
	},
	[36] = {
		ID = "Whelen Ion",
		Scale = .9,
		Pos = Vector( 10, 116, 37 ),
		Ang = Angle( 0, -6, 10 ),
		Color1 = "BLUE",
		Phase = "A"
	},
	[37] = {
		ID = "Whelen Ion",
		Scale = .9,
		Pos = Vector( -10, 116, 37 ),
		Ang = Angle( 0, 6, 10 ),
		Color1 = "RED",
		Phase = "B"
	},
	[38] = {
		ID = "Whelen Ion",
		Scale = .8,
		Pos = Vector( 47, 39.3, 57 ),
		Ang = Angle( -3, -34, 0 ),
		Color1 = "BLUE",
		Phase = "A"
	},
	[39] = {
		ID = "Whelen Ion",
		Scale = .8,
		Pos = Vector( -47, 39.3, 57 ),
		Ang = Angle( 3, 34, 0 ),
		Color1 = "RED",
		Phase = "B"
	},
	[40] = {
		ID = "FPIU16 Foglights",
		Scale = 1,
		Pos = Vector( 0, 0, 0 ),
		Ang = Angle( 0, 0, 0 )
	},
	[41] = {
		ID = "FPIS13 Front Hideaways",
		Scale = 1,
		Pos = Vector( 0, 0, 0 ),
		Ang = Angle( 0, 0, 0 )
	},
	[42] = {
		ID = "FPIS13 Turn Signal Hideaways",
		Scale = 1,
		Pos = Vector( 0, 0, 0 ),
		Ang = Angle( 0, 0, 0 )
	},
	[43] = {
		ID = "FPIS13 Wig-Wag Headlights",
		Scale = 1,
		Pos = Vector( 0, 0, 0 ),
		Ang = Angle( 0, 0, 0 )
	},
	[44] = {
		ID = "Whelen Ion Trio",
		Scale = .75,
		Pos = Vector( -10.5, 125, 42.4 ),
		Ang = Angle( 0, 0, 0 ),
		Phase = "A"
	},
	[45] = {
		ID = "Whelen Ion Trio",
		Scale = .75,
		Pos = Vector( 10.5, 125, 42.4 ),
		Ang = Angle( 0, 0, 0 ),
		Phase = "B"
	},
	[46] = {
		ID = "FPIS13 Reverse",
		Scale = 1,
		Pos = Vector( 0, 0, 0 ),
		Ang = Angle( 0, 0, 0 )
	},
	[47] = {
		ID = "Whelen 700 Trio",
		Scale = 1,
		Pos = Vector( -37, -45, 58.5 ),
		Ang = Angle( 2, 90, -90 )
	},
	[48] = {
		ID = "Whelen 700 Trio",
		Scale = 1,
		Pos = Vector( 37, -45, 58.5 ),
		Ang = Angle( 2, 90, 90 )
	},
	[49] = {
		ID = "Tomar 200S Rear",
		Scale = .66,
		Pos = Vector( 0, -82.2, 62 ),
		Ang = Angle( 0, -90, 0 )
	},
	[50] = {
		ID = "Whelen Ion Trio",
		Scale = .8,
		Pos = Vector( 45, 56, 40.5 ),
		Ang = Angle( -2, -90, 0 )
	},
	[51] = {
		ID = "Whelen Ion Trio",
		Scale = .8,
		Pos = Vector( -45, 56, 40.5 ),
		Ang = Angle( -2, -90, -180 )
	},
	[52] = {
		ID = "Federal Signal Viper Dual",
		Scale = 1,
		Pos = Vector( 12, -83, 61.6 ),
		Ang = Angle( -5, -85, -0 ),
		Phase = "NYA",
		Color1 = "BLUE",
		Color2 = "RED",
		BodyGroups = {
			{ 1, 2 },
		}
	},
	[53] = {
		ID = "Federal Signal Viper Dual",
		Scale = 1,
		Pos = Vector( -12, -83, 61.6 ),
		Ang = Angle( -5, -95, -0 ),
		BodyGroups = {
			{ 1, 2 },
		},
		Phase = "NYB"
	},
	[54] = {
		ID = "Whelen Liberty II CHP",
		Scale = 1.04,
		Pos = Vector( 0, -7, 78.3 ),
		Ang = Angle( 1.7, 90, 0),
	},
	[55] = {
		ID = "Whelen Ion",
		Scale = .8,
		Pos = Vector( 47, 39.3, 57 ),
		Ang = Angle( -3, -34, 0 ),
		Color1 = "RED",
		Phase = "CHPB"
	},
	[56] = {
		ID = "Whelen Ion",
		Scale = .8,
		Pos = Vector( -47, 39.3, 57 ),
		Ang = Angle( 3, 34, 0 ),
		Color1 = "RED",
		Phase = "CHPA"
	},
	[57] = {
		ID = "Whelen Ion",
		Scale = .75,
		Pos = Vector( -10.5, 125, 42.4 ),
		Ang = Angle( 0, 0, 0 ),
		Color1 = "RED",
		Phase = "CHPA"
	},
	[58] = {
		ID = "Whelen Ion",
		Scale = .75,
		Pos = Vector( 10.5, 125, 42.4 ),
		Ang = Angle( 0, 0, 0 ),
		Color1 = "RED",
		Phase = "CHPB"
	},
	[59] = {
		ID = "FPIU16 Foglights",
		Scale = 1,
		Pos = Vector( 0, 0, 0 ),
		Ang = Angle( 0, 0, 0 ),
		Color1 = "WHITE",
		Color2 = "WHITE",
		Phase = "CHP"
	},
	[60] = {
		ID = "Small Front Interior Trio",
		Scale = 1,
		Pos = Vector( 0, 36, 64 ),
		Ang = Angle( 0, -90, 0 )
	},
	[61] = {
		ID = "FPIS13 PAR-46",
		Scale = 1,
		Pos = Vector(0, 0, 0),
		Ang = Angle(0, 0, 0),
	},
	[62] = {
		ID = "Whelen CenCom Panel",
		Scale = 1,
		Pos = Vector(0, 25, 37.8),
		Ang = Angle(0, 0, 0),
	},
	[63] = {
		ID = "Code 3 RX2700 Blue",
		Scale = .93,
		Pos = Vector( 0, -7.3, 78 ),
		Ang = Angle( 1.7, 90, 0),
	},
	[64] = {
		ID = "Code 3 RX2700 Red",
		Scale = .93,
		Pos = Vector( 0, -7.3, 78 ),
		Ang = Angle( 1.7, 90, 0),
	},
	[65] = {
		ID = "Code 3 RX2700 MC",
		Scale = .93,
		Pos = Vector( 0, -7.3, 78 ),
		Ang = Angle( 1.7, 90, 0),
	},
	[66] = {
		ID = "Whelen Vertex",
		Scale = 1.2,
		Pos = Vector(39.5, -107, 31),
		Ang = Angle(0, 70, 94)
	},
	[67] = {
		ID = "Whelen Vertex",
		Scale = 1.2,
		Pos = Vector(-39.5, -107, 31),
		Ang = Angle(0, -70, 94)
	},
	[68] = {
		ID = "Whelen Vertex",
		Scale = 1.2,
		Pos = Vector(-13, -124.6, 26),
		Ang = Angle(0, 0, 100),
		Phase = "A",
		Color1 = "BLUE"
	},
	[69] = {
		ID = "Whelen Vertex",
		Scale = 1.2,
		Pos = Vector(13, -124.6, 26),
		Ang = Angle(0, 0, 100),
		Phase = "B",
		Color1 = "RED"
	},
	[70] = {
		ID = "Whelen Vertex",
		Scale = 1.2,
		Pos = Vector(20.13, 127, 36),
		Ang = Angle(0, -90, -90)
	},
	[71] = {
		ID = "Whelen Vertex",
		Scale = 1.2,
		Pos = Vector(-20.13, 127, 36),
		Ang = Angle(0, 90, -90)
	},
	[72] = {
		ID = "Federal Signal Viper Dual",
		Scale = 1,
		Pos = Vector( 23, 28.6, 66),
		Ang = Angle( 0, 85, 2 ),
		Color1 = "BLUE",
		Color2 = "BLUE",
		Phase = "A"
	},
	[73] = {
		ID = "Federal Signal Viper Dual",
		Scale = 1,
		Pos = Vector( -23, 28.6, 66),
		Ang = Angle( 0, 95, -2 ),
		Color1 = "RED",
		Color2 = "RED",
		Phase = "B"
	},
	[74] = {
		ID = "Federal Signal Viper Dual",
		Scale = 1,
		Pos = Vector( 0, 52, 56),
		Ang = Angle( 0, 90, 0 ),
		Phase = "C",
		Color1 = "RED",
		Color2 = "BLUE"
	},
	[75] = {
		ID = "Whelen Ion Split",
		Scale = .75,
		Pos = Vector( -10.5, 125, 42.4 ),
		Ang = Angle( 0, 0, 0 ),
		Color1 = "RED",
		Color2 = "BLUE"
	},
	[76] = {
		ID = "Whelen Ion Split",
		Scale = .75,
		Pos = Vector( 10.5, 125, 42.4 ),
		Ang = Angle( 0, 0, 0 ),
		Color1 = "BLUE",
		Color2 = "RED"
	},
	[77] = {
		ID = "Whelen Ion Split",
		Scale = .75,
		Pos = Vector( -10.5, 125, 42.4 ),
		Ang = Angle( 0, 0, 0 ),
		Color1 = "RED",
		Color2 = "WHITE"
	},
	[78] = {
		ID = "Whelen Ion Split",
		Scale = .75,
		Pos = Vector( 10.5, 125, 42.4 ),
		Ang = Angle( 0, 0, 0 ),
		Color1 = "WHITE",
		Color2 = "RED"
	},
	[79] = {
		ID = "Whelen Ion Split",
		Scale = .75,
		Pos = Vector( -10.5, 125, 42.4 ),
		Ang = Angle( 0, 0, 0 ),
		Color1 = "BLUE",
		Color2 = "WHITE"
	},
	[80] = {
		ID = "Whelen Ion Split",
		Scale = .75,
		Pos = Vector( 10.5, 125, 42.4 ),
		Ang = Angle( 0, 0, 0 ),
		Color1 = "WHITE",
		Color2 = "BLUE"
	},
	[81] = {
		ID = "FPIU16 Foglights",
		Scale = 1,
		Pos = Vector( 0, 0, 0 ),
		Ang = Angle( 0, 0, 0 ),
		Color1 = "BLUE",
		Color2 = "BLUE"
	},
	[82] = {
		ID = "FPIU16 Foglights",
		Scale = 1,
		Pos = Vector( 0, 0, 0 ),
		Ang = Angle( 0, 0, 0 ),
		Color1 = "RED",
		Color2 = "RED"
	},
	[83] = {
		ID = "Whelen Ion",
		Scale = .9,
		Pos = Vector( 10, 116, 37 ),
		Ang = Angle( 0, -6, 10 ),
		Color1 = "BLUE",
		Phase = "A"
	},
	[84] = {
		ID = "Whelen Ion",
		Scale = .9,
		Pos = Vector( -10, 116, 37 ),
		Ang = Angle( 0, 6, 10 ),
		Color1 = "BLUE",
		Phase = "B"
	},
	[85] = {
		ID = "Whelen Ion",
		Scale = .9,
		Pos = Vector( 10, 116, 37 ),
		Ang = Angle( 0, -6, 10 ),
		Color1 = "RED",
		Phase = "A"
	},
	[86] = {
		ID = "Whelen Ion",
		Scale = .9,
		Pos = Vector( -10, 116, 37 ),
		Ang = Angle( 0, 6, 10 ),
		Color1 = "RED",
		Phase = "B"
	},
	[87] = {
		ID = "Whelen Ion",
		Scale = .9,
		Pos = Vector( 10, 116, 37 ),
		Ang = Angle( 0, -6, 10 ),
		Color1 = "RED",
		Phase = "NYPDA"
	},
	[88] = {
		ID = "Whelen Ion",
		Scale = .9,
		Pos = Vector( -10, 116, 37 ),
		Ang = Angle( 0, 6, 10 ),
		Color1 = "RED",
		Phase = "NYPDB"
	},
	[89] = {
		ID = "FPIS13 Front Hideaways",
		Scale = 1,
		Pos = Vector( 0, 0, 0 ),
		Ang = Angle( 0, 0, 0 ),
		Color1 = "BLUE",
		Color2 = "BLUE"
	},
	[90] = {
		ID = "FPIS13 Front Hideaways",
		Scale = 1,
		Pos = Vector( 0, 0, 0 ),
		Ang = Angle( 0, 0, 0 ),
		Color1 = "RED",
		Color2 = "RED"
	},
	[91] = {
		ID = "FPIS13 Front Hideaways",
		Scale = 1,
		Pos = Vector( 0, 0, 0 ),
		Ang = Angle( 0, 0, 0 ),
		Color1 = "WHITE",
		Color2 = "WHITE"
	},
	[92] = {
		ID = "FPIS13 Reverse",
		Scale = 1,
		Pos = Vector( 0, 0, 0 ),
		Ang = Angle( 0, 0, 0 ),
		Color1 = "BLUE",
		Color2 = "BLUE"
	},
	[93] = {
		ID = "FPIS13 Reverse",
		Scale = 1,
		Pos = Vector( 0, 0, 0 ),
		Ang = Angle( 0, 0, 0 ),
		Color1 = "RED",
		Color2 = "RED"
	},
	[94] = {
		ID = "FPIS13 Reverse",
		Scale = 1,
		Pos = Vector( 0, 0, 0 ),
		Ang = Angle( 0, 0, 0 ),
		Color1 = "WHITE",
		Color2 = "WHITE"
	},
	[95] = {
		ID = "TDM Front Interior Lightbar",
		Scale = 1.12,
		Pos = Vector( 0, 28.1, 71.4),
		Ang = Angle( 0, 90, 0 ),
		Color1 = "BLUE",
		Color2 = "BLUE"
	},
	[96] = {
		ID = "TDM Front Interior Lightbar",
		Scale = 1.12,
		Pos = Vector( 0, 28.1, 71.4),
		Ang = Angle( 0, 90, 0 ),
		Color1 = "RED",
		Color2 = "RED"
	},
	[97] = {
		ID = "Federal Signal Viper",
		Scale = 1,
		Pos = Vector( 25, 29.62, 65.6),
		Ang = Angle( 0, 85, 2 ),
		Color1 = "BLUE",
		Color2 = "WHITE",
		Phase = "A"
	},
	[98] = {
		ID = "Federal Signal Viper",
		Scale = 1,
		Pos = Vector( -25, 29.62, 65.6),
		Ang = Angle( 0, 95, -2 ),
		Color1 = "BLUE",
		Color2 = "WHITE",
		Phase = "B"
	},
	[99] = {
		ID = "Federal Signal Viper",
		Scale = 1,
		Pos = Vector( 25, 29.62, 65.6),
		Ang = Angle( 0, 85, 2 ),
		Color1 = "RED",
		Color2 = "WHITE",
		Phase = "A"
	},
	[100] = {
		ID = "Federal Signal Viper",
		Scale = 1,
		Pos = Vector( -25, 29.62, 65.6),
		Ang = Angle( 0, 95, -2 ),
		Color1 = "RED",
		Color2 = "WHITE",
		Phase = "B"
	},
	[101] = {
		ID = "Federal Signal Viper Dual",
		Scale = 1,
		Pos = Vector( 23, 28.6, 66),
		Ang = Angle( 0, 85, 2 ),
		Color1 = "BLUE",
		Color2 = "BLUE",
		Phase = "A"
	},
	[102] = {
		ID = "Federal Signal Viper Dual",
		Scale = 1,
		Pos = Vector( -23, 28.6, 66),
		Ang = Angle( 0, 95, -2 ),
		Color1 = "BLUE",
		Color2 = "BLUE",
		Phase = "B"
	},
	[103] = {
		ID = "Federal Signal Viper Dual",
		Scale = 1,
		Pos = Vector( 23, 28.6, 66),
		Ang = Angle( 0, 85, 2 ),
		Color1 = "RED",
		Color2 = "RED",
		Phase = "A"
	},
	[104] = {
		ID = "Federal Signal Viper Dual",
		Scale = 1,
		Pos = Vector( -23, 28.6, 66),
		Ang = Angle( 0, 95, -2 ),
		Color1 = "RED",
		Color2 = "RED",
		Phase = "B"
	},
	[105] = {
		ID = "Federal Signal Viper Dual",
		Scale = 1,
		Pos = Vector( 0, 52, 56),
		Ang = Angle( 0, 90, 0 ),
		Color1 = "BLUE",
		Color2 = "BLUE"
	},
	[106] = {
		ID = "Federal Signal Viper Dual",
		Scale = 1,
		Pos = Vector( 0, 52, 56),
		Ang = Angle( 0, 90, 0 ),
		Color1 = "RED",
		Color2 = "RED"
	},
	[107] = {
		ID = "Federal Signal Viper Dual",
		Scale = 1,
		Pos = Vector( 19, -65, 67.7),
		Ang = Angle( 2, -85, -2 ),
		Color1 = "BLUE",
		Color2 = "BLUE",
		Phase = "A"
	},
	[108] = {
		ID = "Federal Signal Viper Dual",
		Scale = 1,
		Pos = Vector( -19, -65, 67.7),
		Ang = Angle( 2, -105, 2 ),
		Color1 = "BLUE",
		Color2 = "BLUE",
		Phase = "B"
	},
	[109] = {
		ID = "Federal Signal Viper Dual",
		Scale = 1,
		Pos = Vector( 19, -65, 67.7),
		Ang = Angle( 2, -85, -2 ),
		Color1 = "RED",
		Color2 = "RED",
		Phase = "A"
	},
	[110] = {
		ID = "Federal Signal Viper Dual",
		Scale = 1,
		Pos = Vector( -19, -65, 67.7),
		Ang = Angle( 2, -105, 2 ),
		Color1 = "RED",
		Color2 = "RED",
		Phase = "B"
	},
	[111] = {
		ID = "Tomar 200S Rear",
		Scale = .66,
		Pos = Vector( 0, -82.2, 62 ),
		Ang = Angle( 0, -90, 0 ),
		Color1 = "BLUE",
		Color2 = "BLUE"
	},
	[112] = {
		ID = "Tomar 200S Rear",
		Scale = .66,
		Pos = Vector( 0, -82.2, 62 ),
		Ang = Angle( 0, -90, 0 ),
		Color1 = "RED",
		Color2 = "RED"
	},
	[113] = {
		ID = "Federal Signal Viper Dual",
		Scale = 1,
		Pos = Vector( 12, -82, 63.3 ),
		Ang = Angle( -5, -85, -180 ),
		Phase = "A",
		Color1 = "BLUE",
		Color2 = "AMBER"
	},
	[114] = {
		ID = "Federal Signal Viper Dual",
		Scale = 1,
		Pos = Vector( -12, -82, 63.3 ),
		Ang = Angle( -5, -95, -180 ),
		Phase = "B",
		Color1 = "AMBER",
		Color2 = "RED"
	},
	[115] = {
		ID = "Federal Signal Viper Dual",
		Scale = 1,
		Pos = Vector( 12, -82, 63.3 ),
		Ang = Angle( -5, -85, -180 ),
		Phase = "A",
		Color1 = "BLUE",
		Color2 = "AMBER"
	},
	[116] = {
		ID = "Federal Signal Viper Dual",
		Scale = 1,
		Pos = Vector( -12, -82, 63.3 ),
		Ang = Angle( -5, -95, -180 ),
		Phase = "B",
		Color1 = "AMBER",
		Color2 = "BLUE"
	},
	[117] = {
		ID = "Federal Signal Viper Dual",
		Scale = 1,
		Pos = Vector( 12, -82, 63.3 ),
		Ang = Angle( -5, -85, -180 ),
		Phase = "A",
		Color1 = "RED",
		Color2 = "AMBER"
	},
	[118] = {
		ID = "Federal Signal Viper Dual",
		Scale = 1,
		Pos = Vector( -12, -82, 63.3 ),
		Ang = Angle( -5, -95, -180 ),
		Phase = "B",
		Color1 = "AMBER",
		Color2 = "RED"
	},
	[119] = {
		ID = "Whelen 700 Trio",
		Scale = 1,
		Pos = Vector( -37, -45, 58.5 ),
		Ang = Angle( 2, 90, -90 ),
		Color1 = "BLUE",
		Color2 = "AMBER",
		Color3 = "WHITE"
	},
	[120] = {
		ID = "Whelen 700 Trio",
		Scale = 1,
		Pos = Vector( 37, -45, 58.5 ),
		Ang = Angle( 2, 90, 90 ),
		Color1 = "BLUE",
		Color2 = "AMBER",
		Color3 = "WHITE"
	},
	[121] = {
		ID = "Whelen 700 Trio",
		Scale = 1,
		Pos = Vector( -37, -45, 58.5 ),
		Ang = Angle( 2, 90, -90 ),
		Color1 = "RED",
		Color2 = "AMBER",
		Color3 = "WHITE"
	},
	[122] = {
		ID = "Whelen 700 Trio",
		Scale = 1,
		Pos = Vector( 37, -45, 58.5 ),
		Ang = Angle( 2, 90, 90 ),
		Color1 = "RED",
		Color2 = "AMBER",
		Color3 = "WHITE"
	},
	[123] = {
		ID = "Federal Signal Viper Dual",
		Scale = 1,
		Pos = Vector( 34, -81, 62 ),
		Ang = Angle( 0, 0, -180 ),
		Phase = "C",
		Color1 = "BLUE",
		Color2 = "BLUE"
	},
	[124] = {
		ID = "Federal Signal Viper Dual",
		Scale = 1,
		Pos = Vector( -34, -81, 62 ),
		Ang = Angle( 0, -180, -180 ),
		Phase = "C",
		Color1 = "BLUE",
		Color2 = "BLUE"
	},
	[125] = {
		ID = "Federal Signal Viper Dual",
		Scale = 1,
		Pos = Vector( 34, -81, 62 ),
		Ang = Angle( 0, 0, -180 ),
		Phase = "C",
		Color1 = "RED",
		Color2 = "RED"
	},
	[126] = {
		ID = "Federal Signal Viper Dual",
		Scale = 1,
		Pos = Vector( -34, -81, 62 ),
		Ang = Angle( 0, -180, -180 ),
		Phase = "C",
		Color1 = "RED",
		Color2 = "RED"
	},
	[127] = {
		ID = "Whelen Ion Trio",
		Scale = .8,
		Pos = Vector( 47, 39.3, 57 ),
		Ang = Angle( -3, -34, 0 ),
		Phase = "A"
	},
	[128] = {
		ID = "Whelen Ion Trio",
		Scale = .8,
		Pos = Vector( -47, 39.3, 57 ),
		Ang = Angle( 3, 34, 0 ),
		Phase = "B"
	},
	[129] = {
		ID = "Whelen Ion Split",
		Scale = .8,
		Pos = Vector( 47, 39.3, 57 ),
		Ang = Angle( -3, -34, 0 ),
		Color1 = "BLUE",
		Color2 = "WHITE"
	},
	[130] = {
		ID = "Whelen Ion Split",
		Scale = .8,
		Pos = Vector( -47, 39.3, 57 ),
		Ang = Angle( 3, 34, 0 ),
		Color1 = "WHITE",
		Color2 = "BLUE"
	},
	[131] = {
		ID = "Whelen Ion Split",
		Scale = .8,
		Pos = Vector( 47, 39.3, 57 ),
		Ang = Angle( -3, -34, 0 ),
		Color1 = "RED",
		Color2 = "WHITE"
	},
	[132] = {
		ID = "Whelen Ion Split",
		Scale = .8,
		Pos = Vector( -47, 39.3, 57 ),
		Ang = Angle( 3, 34, 0 ),
		Color1 = "WHITE",
		Color2 = "RED"
	},
	[133] = {
		ID = "Whelen Ion Split",
		Scale = .8,
		Pos = Vector( 47, 39.3, 57 ),
		Ang = Angle( -3, -34, 0 ),
		Color1 = "RED",
		Color2 = "BLUE"
	},
	[134] = {
		ID = "Whelen Ion Split",
		Scale = .8,
		Pos = Vector( -47, 39.3, 57 ),
		Ang = Angle( 3, 34, 0 ),
		Color1 = "BLUE",
		Color2 = "RED"
	},
	[135] = {
		ID = "Whelen Ion",
		Scale = .8,
		Pos = Vector( 47, 39.3, 57 ),
		Ang = Angle( -3, -34, 0 ),
		Phase = "A",
		Color1 = "RED"
	},
	[136] = {
		ID = "Whelen Ion",
		Scale = .8,
		Pos = Vector( -47, 39.3, 57 ),
		Ang = Angle( 3, 34, 0 ),
		Phase = "B",
		Color1 = "RED"
	},
	[137] = {
		ID = "Whelen Ion",
		Scale = .8,
		Pos = Vector( 47, 39.3, 57 ),
		Ang = Angle( -3, -34, 0 ),
		Phase = "A",
		Color1 = "BLUE"
	},
	[138] = {
		ID = "Whelen Ion",
		Scale = .8,
		Pos = Vector( -47, 39.3, 57 ),
		Ang = Angle( 3, 34, 0 ),
		Phase = "B",
		Color1 = "BLUE"
	},
	[139] = {
		ID = "Federal Signal Valor",
		Scale = .86,
		Pos = Vector( 0, -2, 78.4 ),
		Ang = Angle( 2, 90, 0),
		Phase = "A"
	},
	[140] = {
		ID = "Whelen Vertex",
		Scale = 1.2,
		Pos = Vector(-13, -124.6, 26),
		Ang = Angle(0, 0, 100),
		Phase = "A",
		Color1 = "BLUE",
		Color2 = "AMBER",
		Color3 = "WHITE"
	},
	[141] = {
		ID = "Whelen Vertex",
		Scale = 1.2,
		Pos = Vector(13, -124.6, 26),
		Ang = Angle(0, 0, 100),
		Phase = "B",
		Color1 = "BLUE",
		Color2 = "AMBER",
		Color3 = "WHITE"
	},
	[142] = {
		ID = "Whelen Vertex",
		Scale = 1.2,
		Pos = Vector(-13, -124.6, 26),
		Ang = Angle(0, 0, 100),
		Phase = "A",
		Color1 = "RED",
		Color2 = "AMBER",
		Color3 = "WHITE"
	},
	[143] = {
		ID = "Whelen Vertex",
		Scale = 1.2,
		Pos = Vector(13, -124.6, 26),
		Ang = Angle(0, 0, 100),
		Phase = "B",
		Color1 = "RED",
		Color2 = "AMBER",
		Color3 = "WHITE"
	},
	[144] = {
		ID = "Federal Signal Valor",
		Scale = .86,
		Pos = Vector( 0, -2, 78.4 ),
		Ang = Angle( 2, 90, 0),
		Phase = "CA"
	},
	[145] = {
		ID = "Federal Signal Valor",
		Scale = .86,
		Pos = Vector( 0, -2, 78.4 ),
		Ang = Angle( 2, 90, 0),
		Phase = "A",
		Color1 = "BLUE",
		Color2 = "WHITE"
	},
	[146] = {
		ID = "Federal Signal Valor",
		Scale = .86,
		Pos = Vector( 0, -2, 78.4 ),
		Ang = Angle( 2, 90, 0),
		Color1 = "BLUE",
		Color2 = "BLUE"
	},
	[147] = {
		ID = "Federal Signal Valor",
		Scale = .86,
		Pos = Vector( 0, -2, 78.4 ),
		Ang = Angle( 2, 90, 0),
		Phase = "A",
		Color1 = "RED",
		Color2 = "AMBER"
	},
	[148] = {
		ID = "Federal Signal Valor",
		Scale = .86,
		Pos = Vector( 0, -2, 78.4 ),
		Ang = Angle( 2, 90, 0),
		Color1 = "RED",
		Color2 = "RED"
	},
	[149] = {
		ID = "Federal Signal Valor",
		Scale = .86,
		Pos = Vector( 0, -2, 78.4 ),
		Ang = Angle( 2, 90, 0),
		Color1 = "RED",
		Color2 = "RED"
	},
	[150] = {
		ID = "Federal Signal Hotfoot",
		Scale = .8,
		Pos = Vector( -24.4, 4.9, 76.2 ),
		Ang = Angle( 0, 0, 0),
		Color1 = "RED",
		Phase = "CA"
	},
	[151] = {
		ID = "Federal Signal Hotfoot",
		Scale = .8,
		Pos = Vector( 24.4, 4.9, 76.2 ),
		Ang = Angle( 0, 0, 0),
		Color1 = "BLUE",
		Phase = "CA"
	},
	[152] = {
		ID = "Whelen Ion",
		Scale = .8,
		Pos = Vector( 47, 39.3, 57 ),
		Ang = Angle( -3, -34, 0 ),
		Color1 = "BLUE"
	},
	[153] = {
		ID = "Whelen Ion",
		Scale = .8,
		Pos = Vector( -47, 39.3, 57 ),
		Ang = Angle( 3, 34, 0 ),
		Color1 = "RED",
		Phase = "CA"
	},
	[154] = {
		ID = "Federal Signal Legend Blue",
		Scale = .99,
		Pos = Vector( 0, -7.5, 78 ),
		Ang = Angle( 1, 90, 0),
	},
	[155] = {
		ID = "Federal Signal Legend Red",
		Scale = .99,
		Pos = Vector( 0, -7.5, 78 ),
		Ang = Angle( 1, 90, 0),
	},
	[156] = {
		ID = "Whelen Justice",
		Scale = 1.01,
		Pos = Vector( 0, -7.1, 79.6 ),
		Ang = Angle( 1, 90, 0),
		Color1 = "BLUE",
		Color2 = "BLUE",
	},
	[157] = {
		ID = "Whelen Justice",
		Scale = 1.01,
		Pos = Vector( 0, -7.1, 79.6 ),
		Ang = Angle( 1, 90, 0),
		Color1 = "RED",
		Color2 = "RED",
	},
	[158] = {
		ID = "Federal Signal Integrity",
		Scale = .92,
		Pos = Vector( 0, -8.9, 77.8 ),
		Ang = Angle( 1, 90, 0),
		Color1 = "BLUE",
		Color2 = "BLUE"
	},
	[159] = {
		ID = "Federal Signal Integrity",
		Scale = .92,
		Pos = Vector( 0, -8.9, 77.8 ),
		Ang = Angle( 1, 90, 0),
		Color1 = "RED",
		Color2 = "RED"
	},
	[160] = {
		ID = "Whelen Ultra Freedom",
		Scale = .96,
		Pos = Vector( 0, -7.4, 79.2 ),
		Ang = Angle( 2, 90, 0),
		Color1 = "BLUE",
		Color2 = "BLUE"

	},
	[161] = {
		ID = "Whelen Ultra Freedom",
		Scale = .96,
		Pos = Vector( 0, -7.4, 79.2 ),
		Ang = Angle( 2, 90, 0),
		AutoPatterns = true,
		Color1 = "RED",
		Color2 = "RED"
	},
	[162] = {
		ID = "Whelen Liberty SX",
		Scale = .92,
		Pos = Vector( 0, -8, 77.8 ),
		Ang = Angle( 1, 90, 0),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL,
		Color1 = "BLUE",
		Color2 = "BLUE"
	},
	[163] = {
		ID = "Whelen Liberty SX",
		Scale = .92,
		Pos = Vector( 0, -8, 77.8 ),
		Ang = Angle( 1, 90, 0),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL,
		Color1 = "RED",
		Color2 = "RED"
	},

	[164] = {
		ID = "Skirt Lighting Strip",
		Scale = 1,
		Pos = Vector( -44, 30, 12 ),
		Ang = Angle( 0, 0, -1)
	},
	[165] = {
		ID = "Skirt Lighting Strip",
		Scale = 1,
		Pos = Vector( 44, 30, 12 ),
		Ang = Angle( 0, 180, 1)
	},
	[166] = {
		ID = "Skirt Lighting Strip",
		Scale = 1,
		Pos = Vector( -44, 11.5, 12.32 ),
		Ang = Angle( 0, 0, -1)
	},
	[167] = {
		ID = "Skirt Lighting Strip",
		Scale = 1,
		Pos = Vector( 44, 11.5, 12.32 ),
		Ang = Angle( 0, 180, 1)
	},
	[168] = {
		ID = "Skirt Lighting Strip",
		Scale = 1,
		Pos = Vector( -44, -7, 12.65 ),
		Ang = Angle( 0, 0, -1)
	},
	[169] = {
		ID = "Skirt Lighting Strip",
		Scale = 1,
		Pos = Vector( 44, -7, 12.65 ),
		Ang = Angle( 0, 180, 1)
	},
	[170] = {
		ID = "Skirt Lighting Strip",
		Scale = 1,
		Pos = Vector( -44, -25.5, 12.96 ),
		Ang = Angle( 0, 0, -1)
	},
	[171] = {
		ID = "Skirt Lighting Strip",
		Scale = 1,
		Pos = Vector( 44, -25.5, 12.96 ),
		Ang = Angle( 0, 180, 1)
	},

	[172] = {
		ID = "Federal Signal Arjent",
		Scale = .8,
		Pos = Vector( 0, -7, 77.8 ),
		Ang = Angle( 1, 90, 0),
	},
	[173] = {
		ID = "Whelen Ion",
		Scale = .8,
		Pos = Vector( 45, 56, 40.5 ),
		Ang = Angle( -2, -90, 0 ),
		Color1 = "BLUE"
	},
	[174] = {
		ID = "Whelen Ion",
		Scale = .8,
		Pos = Vector( -45, 56, 40.5 ),
		Ang = Angle( -2, -90, -180 ),
		Color1 = "BLUE"
	},
	[175] = {
		ID = "Whelen Ion",
		Scale = .8,
		Pos = Vector( 45, 56, 40.5 ),
		Ang = Angle( -2, -90, 0 ),
		Color1 = "RED"
	},
	[176] = {
		ID = "Whelen Ion",
		Scale = .8,
		Pos = Vector( -45, 56, 40.5 ),
		Ang = Angle( -2, -90, -180 ),
		Color1 = "RED"
	},
	[177] = {
		ID = "Small Front Interior Trio",
		Scale = .95,
		Pos = Vector( 18, 26.8, 68.5),
		Ang = Angle( 0, -96, -2 )
	},
	[178] = {
		ID = "Small Front Interior Trio",
		Scale = .95,
		Pos = Vector( -18, 26.8, 68.5),
		Ang = Angle( 0, -84, 2 ),
		Color1 = "BLUE",
		Color2 = "RED"
	},
	[179] = {
		ID = "Small Front Interior Trio",
		Scale = .95,
		Pos = Vector( 18, 26.8, 68.5),
		Ang = Angle( 0, -96, -2 ),
		Color1 = "BLUE",
		Color2 = "WHITE"
	},
	[180] = {
		ID = "Small Front Interior Trio",
		Scale = .95,
		Pos = Vector( -18, 26.8, 68.5),
		Ang = Angle( 0, -84, 2 ),
		Color1 = "WHITE",
		Color2 = "BLUE"
	},
	[181] = {
		ID = "Small Front Interior Trio",
		Scale = .95,
		Pos = Vector( 18, 26.8, 68.5),
		Ang = Angle( 0, -96, -2 ),
		Color1 = "RED",
		Color2 = "WHITE"
	},
	[182] = {
		ID = "Small Front Interior Trio",
		Scale = .95,
		Pos = Vector( -18, 26.8, 68.5),
		Ang = Angle( 0, -84, 2 ),
		Color1 = "WHITE",
		Color2 = "RED"
	},

	[183] = {
		ID = "Skirt Lighting Strip",
		Scale = 1,
		Pos = Vector( -44, 30, 12 ),
		Ang = Angle( 0, 0, -1),
		Color1 = "BLUE",
		Color2 = "WHITE"
	},
	[184] = {
		ID = "Skirt Lighting Strip",
		Scale = 1,
		Pos = Vector( 44, 30, 12 ),
		Ang = Angle( 0, 180, 1),
		Color1 = "BLUE",
		Color2 = "WHITE"
	},
	[185] = {
		ID = "Skirt Lighting Strip",
		Scale = 1,
		Pos = Vector( -44, 11.5, 12.32 ),
		Ang = Angle( 0, 0, -1),
		Color1 = "WHITE",
		Color2 = "BLUE"
	},
	[186] = {
		ID = "Skirt Lighting Strip",
		Scale = 1,
		Pos = Vector( 44, 11.5, 12.32 ),
		Ang = Angle( 0, 180, 1),
		Color1 = "WHITE",
		Color2 = "BLUE"
	},
	[187] = {
		ID = "Skirt Lighting Strip",
		Scale = 1,
		Pos = Vector( -44, -7, 12.65 ),
		Ang = Angle( 0, 0, -1),
		Color1 = "BLUE",
		Color2 = "WHITE"
	},
	[188] = {
		ID = "Skirt Lighting Strip",
		Scale = 1,
		Pos = Vector( 44, -7, 12.65 ),
		Ang = Angle( 0, 180, 1),
		Color1 = "BLUE",
		Color2 = "WHITE"
	},
	[189] = {
		ID = "Skirt Lighting Strip",
		Scale = 1,
		Pos = Vector( -44, -25.5, 12.96 ),
		Ang = Angle( 0, 0, -1),
		Color1 = "WHITE",
		Color2 = "BLUE"
	},
	[190] = {
		ID = "Skirt Lighting Strip",
		Scale = 1,
		Pos = Vector( 44, -25.5, 12.96 ),
		Ang = Angle( 0, 180, 1),
		Color1 = "WHITE",
		Color2 = "BLUE"
	},
	[191] = {
		ID = "Feniex Avatar",
		Scale = .89,
		Pos = Vector( 0, -7.8, 75.25 ),
		Ang = Angle( 1.5, 90, 0)
	},
	[192] = {
		ID = "Code 3 Solex",
		Scale = 1,
		Pos = Vector( 0, -7.6, 75.1 ),
		Ang = Angle( 0, 0, -1.5)
	},
}

EMV.Selections = { -- structured and flexible version of presets designed to mimic bodygroups
	{
		Name = "Lightbar",
		Options = {
			{ Category = "Whelen Legacy", Name = "Red/Blue", Auto = { 6 } },
			{ Category = "Whelen Legacy", Name = "Blue", Auto = { 26 } },
			{ Category = "Whelen Legacy", Name = "Red", Auto = { 27 } },
			{ Category = "Whelen Liberty II", Name = "Default", Auto = { 32 } },
			{ Category = "Whelen Liberty II", Name = "CHP", Auto = { 54 } },
			{ Category = "Whelen Liberty SX", Name = "Default", Auto = { 7 } },
			{ Category = "Whelen Liberty SX", Name = "Blue", Auto = { 162 } },
			{ Category = "Whelen Liberty SX", Name = "Red", Auto = { 163 } },
			{ Category = "Whelen Ultra Freedom", Name = "Red/Blue", Auto = { 25 } },
			{ Category = "Whelen Ultra Freedom", Name = "Blue", Auto = { 160 } },
			{ Category = "Whelen Ultra Freedom", Name = "Red", Auto = { 161 } },
			{ Category = "Whelen Justice", Name = "Red/Blue", Auto = { 5 } },
			{ Category = "Whelen Justice", Name = "Blue", Auto = { 156 } },
			{ Category = "Whelen Justice", Name = "Red", Auto = { 157 } },
			{ Category = "Code 3 RX2700", Name = "Red/Blue", Auto = { 33 } },
			{ Category = "Code 3 RX2700", Name = "Blue", Auto = { 63 } },
			{ Category = "Code 3 RX2700", Name = "Red", Auto = { 64 } },
			{ Category = "Code 3 RX2700", Name = "Multi-Color", Auto = { 65 } },
			{ Category = "Code 3 Solex", Name = "Multi-Color", Auto = { 192 } },
			{ Name = "Federal Signal Arjent", Auto = { 172 } },
			{ Category = "Federal Signal Vision SLR", Name = "Red/Blue", Auto = { 10 } },
			{ Category = "Federal Signal Vision SLR", Name = "Red/Blue Clear", Auto = { 11 } },
			{ Category = "Federal Signal Vision SLR", Name = "NYPD", Auto = { 4 } },
			{ Category = "Federal Signal Integrity", Name = "Red/Blue", Auto = { 1 } },
			{ Category = "Federal Signal Integrity", Name = "Blue", Auto = { 158 } },
			{ Category = "Federal Signal Integrity", Name = "Red", Auto = { 159 } },
			{ Category = "Federal Signal Legend", Name = "Red/Blue", Auto = { 2 } },
			{ Category = "Federal Signal Legend", Name = "Blue", Auto = { 154 } },
			{ Category = "Federal Signal Legend", Name = "Red", Auto = { 155 } },
			{ Category = "Federal Signal Valor", Name = "Default", Auto = { 3 } },
			{ Category = "Federal Signal Valor", Name = "Alternate 1", Auto = { 139 } },
			{ Category = "Federal Signal Valor", Name = "California", Auto = { 144, 150, 151 } },
			{ Category = "Federal Signal Valor", Name = "Blue/White", Auto = { 145 } },
			{ Category = "Federal Signal Valor", Name = "Blue", Auto = { 146 } },
			{ Category = "Federal Signal Valor", Name = "Red/Amber", Auto = { 147 } },
			{ Category = "Federal Signal Valor", Name = "Red", Auto = { 148 } },
			{ Category = "Feniex Avatar", Name = "Red/Blue", Auto = { 191 } },
			{ Name = "None" },
		}
	},
	{
		Name = "Forward Hideaways",
		Options = {
			{ Name = "Red/Blue", Auto = { 41 } },
			{ Name = "Blue", Auto = { 89 } },
			{ Name = "Red", Auto = { 90 } },
			{ Name = "White", Auto = { 91 } },
			{ Name = "None" },
		}
	},
	{
		Name = "Grille",
		Options = {
			{ Name = "None" },
			{ Name = "Whelen Ion R/B", Auto = { 36, 37 } },
			{ Name = "Whelen Ion R/B Split", Auto = { 34, 35 } },
			{ Name = "Whelen Ion Blue", Auto = { 83, 84 } },
			{ Name = "Whelen Ion Red", Auto = { 85, 86 } },
			{ Name = "NYPD Red", Auto = { 87, 88 } },
		}
	},
	{
		Name = "Headlight Wig-Wag",
		Options = {
			{ Name = "On", Auto = { 43 } },
			{ Name = "None" },
		}
	},
	{
		Name = "Pushbars",
		Options = {
			{ Category = "Setina Pushbar", Name = "R/B Trio", Props = { 13 }, Auto = { 44, 45, 70, 71 }, Bodygroups = { { 4, 0 } } },
			{ Category = "Setina Pushbar", Name = "R/B Split", Props = { 13 }, Auto = { 75, 76, 70, 71 }, Bodygroups = { { 4, 0 } } },
			{ Category = "Setina Pushbar", Name = "B/W Split", Props = { 13 }, Auto = { 79, 80, 70, 71 }, Bodygroups = { { 4, 0 } } },
			{ Category = "Setina Pushbar", Name = "R/W Split", Props = { 13 }, Auto = { 77, 78, 70, 71 }, Bodygroups = { { 4, 0 } } },
			{ Category = "Setina Pushbar", Name = "CHP - Red", Props = { 13 }, Auto = { 57, 58 }, Bodygroups = { { 4, 0 } } },
			{ Category = "Setina Pushbar", Name = "Plain", Props = { 13 }, Bodygroups = { { 4, 0 } } },
			{ Category = "LED Pushbar", Name = "Red/Blue", Auto = { 12 }, Bodygroups = { { 4, 0 } } },
			{ Category = "LED Pushbar", Name = "Blue", Auto = { 28 }, Bodygroups = { { 4, 0 } } },
			{ Category = "LED Pushbar", Name = "Red", Auto = { 29 }, Bodygroups = { { 4, 0 } } },
			{ Name = "NYPD Pushrod", Bodygroups = { { 4, 2 } } },
			{ Name = "None", Bodygroups = { { 4, 0 } } },
		}
	},
	{
		Name = "Pushbar Wraparound",
		Options = {
			{ Name = "None" },
			{ Name = "Enabled", Props = { 18, 19 }, Bodygroups = { { 4, 0 } } },
		}
	},
	{
		Name = "Turn Signal Hideaways",
		Options = {
			{ Name = "White", Auto = { 42 } },
			{ Name = "None" },
		}
	},
	{
		Name = "Rear Vertexes",
		Options = {
			{ Name = "White", Auto = { 66, 67 } },
			{ Name = "None" },
		}
	},
	{
		Name = "License Plate Vertexes",
		Options = {
			{ Name = "Red/Blue", Auto = { 68, 69 } },
			{ Name = "Blue", Auto = { 140, 141 } },
			{ Name = "Red", Auto = { 142, 143 } },
			{ Name = "None" },
		}
	},
	{
		Name = "Reverse Light Hideaways",
		Options = {
			{ Name = "Red/Blue", Auto = { 46 } },
			{ Name = "Blue", Auto = { 92 } },
			{ Name = "Red", Auto = { 93 } },
			{ Name = "White", Auto = { 94 } },
			{ Name = "None" },
		}
	},
	{
		Name = "Front Upper Deck",
		Options = {
			{ Name = "None" },
			-- { Category = "Inner Bar", Name = "Red/Blue", Auto = { 9 } },
			-- { Category = "Inner Bar", Name = "Blue", Auto = { 95 } },
			-- { Category = "Inner Bar", Name = "Red", Auto = { 96 } },
			-- { Category = "Inner Bar Small", Name = "Red/Blue", Auto = { 60 } },
			{ Category = "Inner Edge", Name = "Red/Blue", Auto = { 177, 178 } },
			{ Category = "Inner Edge", Name = "Blue/White", Auto = { 179, 180 } },
			{ Category = "Inner Edge", Name = "Red/White", Auto = { 181, 182 } },
			{ Category = "Single Vipers", Name = "Red/Blue", Auto = { 21, 22 } },
			{ Category = "Single Vipers", Name = "Blue", Auto = { 97, 98 } },
			{ Category = "Single Vipers", Name = "Red", Auto = { 99, 100 } },
			{ Category = "Dual Vipers", Name = "Red/Blue", Auto = { 72, 73 } },
			{ Category = "Dual Vipers", Name = "Blue", Auto = { 101, 102 } },
			{ Category = "Dual Vipers", Name = "Red", Auto = { 103, 104 } },
		}
	},
	{
		Name = "Front Lower Deck",
		Options = {
			{ Name = "None" },
			{ Category = "Viper Dual", Name = "Red/Blue", Auto = { 74 } },
			{ Category = "Viper Dual", Name = "Blue", Auto = { 105 } },
			{ Category = "Viper Dual", Name = "Red", Auto = { 106 } },
		}
	},
	{
		Name = "Forward Side",
		Options = {
			{ Name = "Red/Blue", Auto = { 50, 51 } },
			{ Name = "Blue", Auto = { 173, 174 } },
			{ Name = "Red", Auto = { 175, 176 } },
			{ Name = "None" },
		}
	},
	{
		Name = "Rear Side",
		Options = {
			{ Name = "R/B/W", Auto = { 47, 48 } },
			{ Name = "B/A/W", Auto = { 119, 120 } },
			{ Name = "R/A/W", Auto = { 121, 122 } },
			{ Name = "None" },
		}
	},
	{
		Name = "Skirt Lighting",
		Options = {
			{ Name = "None" },
			{ Name = "Red/Blue", Auto = { 164, 165, 166, 167, 168, 169, 170, 171 } },
			{ Name = "Blue/White", Auto = { 183, 184, 185, 186, 187, 188, 189, 190 } },
		}
	},
	{
		Name = "Rear Upper Deck",
		Options = {
			{ Name = "None" },
			{ Name = "Red/Blue", Auto = { 17, 18 } },
			{ Name = "Blue", Auto = { 107, 108 } },
			{ Name = "Red", Auto = { 109, 110 } },
		}
	},
	{
		Name = "Rear Lower Deck",
		Options = {
			{ Category = "Inner Bar", Name = "Red/Blue", Auto = { 24 } },
			{ Category = "Inner Bar", Name = "Blue", Auto = { 30 } },
			{ Category = "Inner Bar", Name = "Red", Auto = { 31 } },
			{ Category = "Tomar 200S", Name = "Red/Blue/Amber", Auto = { 49 } },
			{ Category = "Tomar 200S", Name = "Blue/Amber", Auto = { 111 } },
			{ Category = "Tomar 200S", Name = "Red/Amber", Auto = { 112 } },
			{ Category = "Viper Dual", Name = "Red/Blue/Amber", Auto = { 113, 114 } },
			{ Category = "Viper Dual", Name = "Blue/Amber", Auto = { 115, 116 } },
			{ Category = "Viper Dual", Name = "Red/Amber", Auto = { 117, 118 } },
			{ Category = "Viper Dual", Name = "NYPD R/B", Auto = { 52, 53 } },
			{ Name = "None" },
		}
	},
	{
		Name = "Mirror Lights",
		Options = {
			{ Category = "Whelen Ion", Name = "Red/Blue", Auto = { 38, 39 } },
			{ Category = "Whelen Ion", Name = "Blue", Auto = { 137, 138 } },
			{ Category = "Whelen Ion", Name = "Red", Auto = { 135, 136 } },
			{ Category = "Whelen Ion", Name = "CHP - Red", Auto = { 55, 56 } },
			{ Category = "Whelen Ion", Name = "CA - Red/Blue", Auto = { 152, 153 } },
			{ Category = "Whelen Ion Split", Name = "Red/Blue", Auto = { 133, 134 } },
			{ Category = "Whelen Ion Split", Name = "Blue", Auto = { 129, 130 } },
			{ Category = "Whelen Ion Split", Name = "Red", Auto = { 131, 132 } },
			{ Name = "Whelen Ion R/B Trio", Auto = { 128, 127 } },
			{ Name = "None" },
		}
	},
	{
		Name = "Roof",
		Options = {
			{ Name = "All", Category = "AirEL", Props = { 20, 21, 22, 23, 24, 25, 26, 27 } },
			{ Name = "Antennas", Category = "AirEL", Props = { 20, 21, 22, 23 } },
			{ Name = "ALPR", Category = "AirEL", Props = { 20, 24, 25, 26, 27 } },
			{ Name = "None", Category = "AirEL", Props = { 20 } },
			{ Name = "Antennas", Props = { 10, 11, 12 } },
			{ Name = "None" },
		}
	},
	{
		Name = "Interior Equipment",
		Options = {
			{ Name = "Full", Props = { }, Auto = { 62 }, Bodygroups = { { 14, 3 } } },
			-- { Name = "Full", Props = { 2, 3, 4, 5, 6, 7, 8 }, Auto = { 62 } },
			{ Name = "None" },
		}
	},
	{
		Name = "Spotlight",
		Options = {
			{ Name = "Default", Bodygroups = { { 19, 0 } } },
			{ Name = "Whelen PAR-46", Auto = { 61 }, Props = { 9 }, Bodygroups = { { 19, 1 } } },
			{ Name = "None", Bodygroups = { { 19, 1 } } },
		}
	},
	{
		Name = "Trunk Equipment",
		Options = {
			{ Name = "None" },
			{ Name = "ALPR", Props = { 16, 17 } },
			{ Name = "Antennas", Props = { 14, 15 } },
			{ Name = "All", Props = { 14, 15, 16, 17 } },
		}
	}

}

EMV.Configuration = "fpis13"
Photon.EMVLibrary[name] = EMV
if EMVU then EMVU:OverwriteIndex( name, EMV ) end
-- if PI then Photon:OverwriteIndex( name, PI ) end

list.Set( "PhotonConfigurationLibrary", "fpis13_76561198033238057_default_red/blue", [[{"Author":"Schmal","Name":"Default Red/Blue","VehicleName":"Ford Taurus 2013","Siren":46,"Category":"Default","Selections":{"Pushbar Wraparound":"None","Rear Side":"R/B/W","Front Upper Deck":"None","Lightbar":"Whelen Legacy=Red/Blue","Rear Upper Deck":"None","Grille":"None","License Plate Vertexes":"Red/Blue","Reverse Light Hideaways":"Red/Blue","Rear Lower Deck":"Inner Bar=Red/Blue","Turn Signal Hideaways":"White","Skirt Lighting":"None","Spotlight":"Default","Forward Hideaways":"Red/Blue","Trunk Equipment":"None","Headlight Wig-Wag":"On","Interior Equipment":"Full","Roof":"AirEL=All","Mirror Lights":"Whelen Ion=Red/Blue","Pushbars":"Setina Pushbar=R/B Trio","Forward Side":"Red/Blue","Rear Vertexes":"White","Front Lower Deck":"None"},"Bodygroups":{"4":"0","10":"5","5":"0","11":"0","12":"0","7":"0","18":"0","13":"0","14":"3","8":"0","1":"0","9":"0","6":"0","16":"0","15":"0","3":"1","17":"0","2":"0","19":"0","0":"0","20":"0"},"AuxSiren":0}]] )
list.Set( "PhotonConfigurationLibrary", "fpis13_76561198033238057_default_blue", [[{"Skin":2,"Siren":46,"Category":"Default","Name":"Default Blue","AuxSiren":0,"VehicleName":"Ford Taurus 2013","Color":{"r":255,"b":255,"a":255,"g":255},"Author":"Schmal","Bodygroups":{"4":"0","10":"5","5":"0","11":"0","12":"0","7":"0","18":"0","13":"0","14":"3","8":"0","1":"0","9":"0","6":"0","16":"0","15":"0","3":"1","17":"0","2":"0","19":"0","0":"0","20":"0"},"Selections":{"Pushbar Wraparound":"None","Rear Side":"B/A/W","Front Upper Deck":"None","Lightbar":"Whelen Legacy=Blue","Rear Upper Deck":"None","Grille":"None","License Plate Vertexes":"Blue","Reverse Light Hideaways":"Blue","Rear Lower Deck":"Inner Bar=Blue","Turn Signal Hideaways":"White","Skirt Lighting":"None","Spotlight":"Default","Forward Hideaways":"Blue","Trunk Equipment":"None","Headlight Wig-Wag":"On","Interior Equipment":"Full","Roof":"AirEL=All","Mirror Lights":"Whelen Ion=Blue","Pushbars":"Setina Pushbar=B/W Split","Forward Side":"Blue","Rear Vertexes":"White","Front Lower Deck":"None"}}]] )
list.Set( "PhotonConfigurationLibrary", "fpis13_76561198033238057_default_red", [[{"Skin":2,"Siren":46,"Category":"Default","Name":"Default Red","AuxSiren":0,"VehicleName":"Ford Taurus 2013","Color":{"r":255,"b":255,"a":255,"g":255},"Author":"Schmal","Bodygroups":{"4":"0","10":"5","5":"0","11":"0","12":"0","7":"0","18":"0","13":"0","14":"3","8":"0","1":"0","9":"0","6":"0","16":"0","15":"0","3":"1","17":"0","2":"0","19":"0","0":"0","20":"0"},"Selections":{"Pushbar Wraparound":"None","Rear Side":"R/A/W","Front Upper Deck":"None","Lightbar":"Whelen Legacy=Red","Rear Upper Deck":"None","Grille":"None","License Plate Vertexes":"Red","Reverse Light Hideaways":"Red","Rear Lower Deck":"Inner Bar=Red","Turn Signal Hideaways":"White","Skirt Lighting":"None","Spotlight":"Default","Forward Hideaways":"Red","Trunk Equipment":"None","Headlight Wig-Wag":"On","Interior Equipment":"Full","Roof":"AirEL=All","Mirror Lights":"Whelen Ion=Red","Pushbars":"Setina Pushbar=R/W Split","Forward Side":"Red","Rear Vertexes":"White","Front Lower Deck":"None"}}]] )
list.Set( "PhotonConfigurationLibrary", "fpis13_76561198033238057_nypd", [[{"Skin":1,"Siren":4,"Category":"Default","Name":"NYPD","AuxSiren":0,"VehicleName":"Ford Taurus 2013","Color":{"r":255,"b":255,"a":255,"g":255},"Author":"Schmal","Bodygroups":{"4":"2","10":"5","5":"0","11":"0","12":"0","7":"0","18":"0","13":"0","14":"3","8":"0","1":"0","9":"0","6":"0","16":"0","15":"0","3":"1","17":"0","2":"0","19":"1","0":"0","20":"0"},"Selections":{"Pushbar Wraparound":"None","Rear Side":"None","Front Upper Deck":"None","Lightbar":"Federal Signal Vision SLR=NYPD","Rear Upper Deck":"None","Grille":"NYPD Red","License Plate Vertexes":"None","Reverse Light Hideaways":"None","Rear Lower Deck":"Viper Dual=NYPD R/B","Turn Signal Hideaways":"White","Skirt Lighting":"None","Spotlight":"None","Forward Hideaways":"White","Trunk Equipment":"None","Headlight Wig-Wag":"On","Interior Equipment":"None","Roof":"None","Mirror Lights":"None","Pushbars":"NYPD Pushrod","Forward Side":"None","Rear Vertexes":"None","Front Lower Deck":"None"}}]] )
list.Set( "PhotonConfigurationLibrary", "fpis13_76561198033238057_lapd", [[{"Skin":4,"Siren":3,"Category":"Default","Name":"LAPD","AuxSiren":0,"VehicleName":"Ford Taurus 2013","Color":{"r":255,"b":255,"a":255,"g":255},"Author":"Schmal","Bodygroups":{"4":"0","10":"5","5":"0","11":"0","12":"0","7":"0","18":"0","13":"0","14":"3","8":"0","1":"0","9":"0","6":"0","16":"0","15":"0","3":"1","17":"0","2":"0","19":"1","0":"0","20":"0"},"Selections":{"Pushbar Wraparound":"None","Rear Side":"None","Front Upper Deck":"None","Lightbar":"Federal Signal Arjent","Rear Upper Deck":"None","Grille":"None","License Plate Vertexes":"None","Reverse Light Hideaways":"None","Rear Lower Deck":"None","Turn Signal Hideaways":"White","Skirt Lighting":"None","Spotlight":"None","Forward Hideaways":"None","Trunk Equipment":"None","Headlight Wig-Wag":"On","Interior Equipment":"None","Roof":"Antennas","Mirror Lights":"None","Pushbars":"None","Forward Side":"None","Rear Vertexes":"None","Front Lower Deck":"None"}}]] )
list.Set( "PhotonConfigurationLibrary", "fpis13_76561198033238057_clear_lighting", [[{"VehicleName":"Ford Taurus 2013","Author":"Schmal","Category":"Default","Bodygroups":{"4":"0","10":"5","5":"0","11":"0","12":"0","7":"0","18":"0","13":"0","14":"3","8":"0","1":"0","9":"0","6":"0","16":"0","15":"0","3":"1","17":"0","2":"0","19":"1","0":"0","20":"0"},"Name":"Clear Lighting","Selections":{"Pushbar Wraparound":"None","Rear Side":"None","Front Upper Deck":"None","Lightbar":"None","Rear Upper Deck":"None","Grille":"None","License Plate Vertexes":"None","Reverse Light Hideaways":"None","Rear Lower Deck":"None","Turn Signal Hideaways":"None","Skirt Lighting":"None","Spotlight":"None","Forward Hideaways":"None","Trunk Equipment":"None","Headlight Wig-Wag":"None","Interior Equipment":"None","Roof":"None","Mirror Lights":"None","Pushbars":"None","Forward Side":"None","Rear Vertexes":"None","Front Lower Deck":"None"}}]] )
