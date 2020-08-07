AddCSLuaFile()

local name = "Schmal 2016 Ford Police Interceptor Utility"

local A = "AMBER"
local R = "RED"
local DR = "D_RED"
local B = "BLUE"
local W = "WHITE"
local CW = "C_WHITE"
local SW = "S_WHITE"
local G = "GREEN"

local EMV = {}

EMV.Siren = 46

-- EMV.Skin = "fpiu16_liveries/Blank"

EMV.Color = Color(255, 255, 255)

EMV.BodyGroups = {}

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
		Pos = Vector(-39, 43, 62),
		Ang = Angle( 15, 120, -10),
		RenderGroup = RENDERGROUP_BOTH,
		RenderMode = RENDERGROUP_TRANSLUCENT
	},
	[10] = {
		Model = "models/schmal/antennas/antenna_6.mdl",
		Scale = 2,
		Pos = Vector(0, -55, 90.8),
		Ang = Angle( 0, 0, 1),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[11] = {
		Model = "models/schmal/antennas/antenna_4.mdl",
		Scale = 2,
		Pos = Vector(8, -58, 90.6),
		Ang = Angle( 0, 0, 1),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[12] = {
		Model = "models/schmal/antennas/antenna_2.mdl",
		Scale = 2,
		Pos = Vector(0, -63, 81),
		Ang = Angle( 0, 0, 1),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[13] = {
		Model = "models/tdmcars/emergency/equipment/pushbar.mdl",
		Scale = Vector( 1.4, 1.4, 1.6 ),
		Pos = Vector( 0, 119.5, 16 ),
		Ang = Angle( 0, -90, 0),
		RenderGroup = RENDERGROUP_TRANSLUCENT,
		RenderMode = RENDERMODE_TRANSALPHA
	},
	[14] = {
		Model = "models/schmal/alpr_camera_minimal.mdl",
		Scale = .66,
		Pos = Vector( -27, 10, 80.5 ),
		Ang = Angle( 10, 130, 0),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[15] = {
		Model = "models/schmal/alpr_camera_minimal.mdl",
		Scale = .66,
		Pos = Vector( 27, 10, 80.5 ),
		Ang = Angle( 10, 50, 0),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[16] = {
		Model = "models/schmal/alpr_camera_minimal.mdl",
		Scale = .66,
		Pos = Vector( -27, -21, 82 ),
		Ang = Angle( 10, 180, 0),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[17] = {
		Model = "models/schmal/alpr_camera_minimal.mdl",
		Scale = .66,
		Pos = Vector( 27, -21, 82 ),
		Ang = Angle( 10, 0, 0),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[18] = {
		Model = "models/schmal/fpiu_wrap.mdl",
		Scale = 1,
		Pos = Vector(32, 105, 32.6),
		Ang = Angle( 0, 90, 0),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[19] = {
		Model = "models/schmal/fpiu_wrap.mdl",
		Scale = 1,
		Pos = Vector(-32, 105, 32.6),
		Ang = Angle( 0, 90, 180),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[20] = {
		Model = "models/schmal/fpiu_airel.mdl",
		Scale = 1,
		Pos = Vector(0, -64, 80.8),
		Ang = Angle( 0, 90, 0),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL,
		AirEL = true
	},
	[21] = {
		Model = "models/schmal/antennas/antenna_6.mdl",
		Scale = 2,
		Pos = Vector(0, -50, 92),
		Ang = Angle( 0, 0, 1),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[22] = {
		Model = "models/schmal/antennas/antenna_4.mdl",
		Scale = 2,
		Pos = Vector(6, -77, 90.6),
		Ang = Angle( 0, 0, 1),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[23] = {
		Model = "models/schmal/antennas/antenna_2.mdl",
		Scale = 2,
		Pos = Vector(-6, -77, 81),
		Ang = Angle( 0, 0, 1),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[24] = {
		Model = "models/schmal/alpr_camera_minimal.mdl",
		Scale = .66,
		Pos = Vector( 24, -50, 83.5 ),
		Ang = Angle( 10, 50, 0),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[25] = {
		Model = "models/schmal/alpr_camera_minimal.mdl",
		Scale = .66,
		Pos = Vector( -24, -50, 83.5 ),
		Ang = Angle( 10, 130, 0),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[26] = {
		Model = "models/schmal/alpr_camera_minimal.mdl",
		Scale = .66,
		Pos = Vector( 24, -76, 82.9 ),
		Ang = Angle( 10, 0, 3),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[27] = {
		Model = "models/schmal/alpr_camera_minimal.mdl",
		Scale = .66,
		Pos = Vector( -24, -76, 82.9 ),
		Ang = Angle( 10, 180, -3),
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
	headlight = {
		AngleOffset = -90,
		W = 4,
		H = 4,
		Sprite = "sprites/emv/light_circle",
		Scale = 3,
		VisRadius = 0
	},
	reverse_lights = {
		AngleOffset = 90,
		W = 7,
		H = 6.2,
		Sprite = "sprites/emv/taurus_reverse",
		Scale = 1,
		WMult = 1
	},
}

EMV.Positions = {


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
			Disconnect = {}
		},
		{
			Name = "STAGE 2",
			Stage = "M2",
			Components = {},
			Disconnect = {}
		},
		{
			Name = "STAGE 3",
			Stage = "M3",
			Components = {},
			Disconnect = {}
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
			BG_Components = {},
			Preset_Components = {},
			Lights = {
				{ Vector( 0, 25, 70 ), Angle( 20, 90, 0 ), "takedown" },
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
				{ Vector( -10, -10, 70 ), Angle( 20, 180, 0 ), "alley" },
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
				{ Vector( 10, -10, 70 ), Angle( 20, 0, 0 ), "alley" },
			},
			Disconnect = {}
		},
		{
			Name = "FULL",
			Icon = "takedown",
			Stage = "F",
			Components = {},
			BG_Components = {},
			Preset_Components = {},
			Lights = {
				{ Vector( 0, 25, 90 ), Angle( 10, 90, 0 ), "flood" },
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
		Near = 110,
		FOV = 135,
		Distance = 800,
	},
	["flood"] = {
		Color = Color(215,225,255,255),
		Texture = "effects/flashlight001",
		Near = 110,
		FOV = 135,
		Distance = 1400,
	},
}

EMV.Auto = {
	[1] = {
		ID = "Federal Signal Integrity",
		Scale = 1,
		Pos = Vector( 0, -10.4, 82 ),
		Ang = Angle( 1, 90, 0),
	},
	[2] = {
		ID = "Federal Signal Legend",
		Scale = 1.05,
		Pos = Vector( 0, -8.5, 83 ),
		Ang = Angle( 1, 90, 0),
	},
	[3] = {
		ID = "Federal Signal Valor",
		Scale = .93,
		Pos = Vector( 0, -4, 83.6 ),
		Ang = Angle( 1.7, 90, 0)
	},
	[4] = {
		ID = "Federal Signal Vision SLR",
		Scale = .90,
		Pos = Vector( 0, -10.5, 84.4 ),
		Ang = Angle( 1, 90, 0),
	},
	[5] = {
		ID = "Whelen Justice",
		Scale = 1.06,
		Pos = Vector( 0, -7.1, 84 ),
		Ang = Angle( 1, 90, 0),
	},
	[6] = {
		ID = "Whelen Legacy",
		Scale = 1.04,
		Pos = Vector( 0, -8.6, 82.4 ),
		Ang = Angle( 1.7, 90, 0),
	},
	[7] = {
		ID = "Whelen Liberty SX",
		Scale = .98,
		Pos = Vector( 0, -8, 83 ),
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
		Scale = .90,
		Pos = Vector( 0, -10.5, 84.4 ),
		Ang = Angle( 1, 90, 0),
	},
	[11] = {
		ID = "Federal Signal Vision SLR Clear",
		Scale = .90,
		Pos = Vector( 0, -10.5, 84.4 ),
		Ang = Angle( 1, 90, 0),
	},
	[12] = {
		ID = "TDM Pushbar LED",
		Scale = 1.15,
		Pos = Vector( 0, 116, 17 ),
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
		Pos = Vector( 22, -92, 72.5),
		Ang = Angle( 0, -80, 0 ),
		Color1 = "BLUE",
		Color2 = "BLUE",
		Phase = "A"
	},
	[18] = {
		ID = "Federal Signal Viper Dual",
		Scale = 1,
		Pos = Vector( -22, -92, 72.5),
		Ang = Angle( 0, -100, 0 ),
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
		Pos = Vector( 26, 29.62, 69),
		Ang = Angle( 0, 85, 2 ),
		Color1 = "BLUE",
		Color2 = "WHITE",
		Phase = "A"
	},
	[22] = {
		ID = "Federal Signal Viper",
		Scale = 1,
		Pos = Vector( -26, 29.6, 69),
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
		Scale = .9,
		Pos = Vector( 0, -94, 72.9),
		Ang = Angle( 0, -90, 0 ),
	},
	[25] = {
		ID = "Whelen Ultra Freedom",
		Scale = 1,
		Pos = Vector( 0, -8.1, 84 ),
		Ang = Angle( 1, 90, 0),
		AutoPatterns = true
	},
	[26] = {
		ID = "Whelen Legacy",
		Scale = 1.04,
		Pos = Vector( 0, -8.6, 82.4 ),
		Ang = Angle( 1.7, 90, 0),
		Color1 = "BLUE",
		Color2 = "BLUE"
	},
	[27] = {
		ID = "Whelen Legacy",
		Scale = 1.04,
		Pos = Vector( 0, -8.6, 82.4 ),
		Ang = Angle( 1.7, 90, 0),
		Color1 = "RED",
		Color2 = "RED"
	},
	[28] = {
		ID = "TDM Pushbar LED",
		Scale = 1.15,
		Pos = Vector( 0, 118, 17 ),
		Ang = Angle( 0, -90, 0),
		Color1 = "BLUE",
		Color2 = "BLUE"
	},
	[29] = {
		ID = "TDM Pushbar LED",
		Scale = 1.15,
		Pos = Vector( 0, 118, 17 ),
		Ang = Angle( 0, -90, 0),
		Color1 = "RED",
		Color2 = "RED"
	},
	[30] = {
		ID = "TDM Rear Interior Lightbar",
		Scale = .9,
		Pos = Vector( 0, -94, 72.6),
		Ang = Angle( 0, -90, 0 ),
		Color1 = "BLUE",
		Color2 = "BLUE"
	},
	[31] = {
		ID = "TDM Rear Interior Lightbar",
		Scale = .9,
		Pos = Vector( 0, -94, 72.6),
		Ang = Angle( 0, -90, 0 ),
		Color1 = "RED",
		Color2 = "RED"
	},
	[32] = {
		ID = "Whelen Liberty II",
		Scale = 1.1,
		Pos = Vector( 0, -8.6, 83 ),
		Ang = Angle( 1.7, 90, 0),
	},
	[33] = {
		ID = "Code 3 RX2700",
		Scale = .96,
		Pos = Vector( 0, -8.6, 83 ),
		Ang = Angle( 1.7, 90, 0),
	},
	[34] = {
		ID = "Whelen Ion Split",
		Scale = .66,
		Pos = Vector( 7.8, 107.8, 44.4 ),
		Ang = Angle( 0, -6, 10 ),
	},
	[35] = {
		ID = "Whelen Ion Split",
		Scale = .66,
		Pos = Vector( -7.8, 107.8, 44.4 ),
		Ang = Angle( 0, 6, 10 ),
	},
	[36] = {
		ID = "Whelen Ion",
		Scale = .66,
		Pos = Vector( 7.8, 107.8, 44.4 ),
		Ang = Angle( 0, -6, 10 ),
		Color1 = "BLUE",
		Phase = "A"
	},
	[37] = {
		ID = "Whelen Ion",
		Scale = .66,
		Pos = Vector( -7.8, 107.8, 44.4 ),
		Ang = Angle( 0, 6, 10 ),
		Color1 = "RED",
		Phase = "B"
	},
	[38] = {
		ID = "Whelen Ion",
		Scale = .8,
		Pos = Vector( 49.6, 37.8, 59.4 ),
		Ang = Angle( 0, -25, 2 ),
		Color1 = "BLUE",
		Phase = "A"
	},
	[39] = {
		ID = "Whelen Ion",
		Scale = .8,
		Pos = Vector( -49.6, 37.8, 59.4 ),
		Ang = Angle( 0, 25, 2 ),
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
		ID = "FPIU16 Front Hideaway",
		Scale = 1,
		Pos = Vector( 0, 0, 0 ),
		Ang = Angle( 0, 0, 0 )
	},
	[42] = {
		ID = "FPIU16 Turn Signal Hideaways",
		Scale = 1,
		Pos = Vector( 0, 0, 0 ),
		Ang = Angle( 0, 0, 0 )
	},
	[43] = {
		ID = "FPIU16 Wig-Wag Headlights",
		Scale = 1,
		Pos = Vector( 0, 0, 0 ),
		Ang = Angle( 0, 0, 0 )
	},
	[44] = {
		ID = "Whelen Ion Trio",
		Scale = .75,
		Pos = Vector( -10.5, 116.6, 48.2 ),
		Ang = Angle( 0, 0, 0 ),
		Phase = "A"
	},
	[45] = {
		ID = "Whelen Ion Trio",
		Scale = .75,
		Pos = Vector( 10.5, 116.6, 48.2 ),
		Ang = Angle( 0, 0, 0 ),
		Phase = "B"
	},
	[46] = {
		ID = "FPIU16 Reverse Hideaways",
		Scale = 1,
		Pos = Vector( 0, 0, 0 ),
		Ang = Angle( 0, 0, 0 )
	},
	[47] = {
		ID = "Whelen 700 Trio",
		Scale = 1,
		Pos = Vector( -38.6, -45, 60 ),
		Ang = Angle( 2, 90, -90 )
	},
	[48] = {
		ID = "Whelen 700 Trio",
		Scale = 1,
		Pos = Vector( 38.6, -45, 60 ),
		Ang = Angle( 2, 90, 90 )
	},
	[49] = {
		ID = "Tomar 200S Rear",
		Scale = .66,
		Pos = Vector( 0, -94, 72.5 ),
		Ang = Angle( 0, -90, 0 )
	},
	[50] = {
		ID = "Federal Signal Viper Dual",
		Scale = 1,
		Pos = Vector( 34, -81, 62 ),
		Ang = Angle( 0, 0, -180 ),
		Phase = "C"
	},
	[51] = {
		ID = "Federal Signal Viper Dual",
		Scale = 1,
		Pos = Vector( -34, -81, 62 ),
		Ang = Angle( 0, -180, -180 ),
		Phase = "C"
	},
	[52] = {
		ID = "Federal Signal Viper Dual",
		Scale = 1,
		Pos = Vector( 12, -101, 63.5 ),
		Ang = Angle( 0, -90, -180 ),
		Phase = "NYA",
		Color1 = "BLUE",
		Color2 = "RED"
	},
	[53] = {
		ID = "Federal Signal Viper Dual",
		Scale = 1,
		Pos = Vector( -12, -101, 63.5 ),
		Ang = Angle( 0, -90, -180 ),
		Phase = "NYB"
	},
	[54] = {
		ID = "Whelen Liberty II CHP",
		Scale = 1.1,
		Pos = Vector( 0, -8.6, 83 ),
		Ang = Angle( 1.7, 90, 0)
	},
	[55] = {
		ID = "Whelen Ion",
		Scale = .8,
		Pos = Vector( 49.6, 37.8, 59.4 ),
		Ang = Angle( 0, -25, 2 ),
		Color1 = "RED",
		Phase = "CHPB"
	},
	[56] = {
		ID = "Whelen Ion",
		Scale = .8,
		Pos = Vector( -49.6, 37.8, 59.4 ),
		Ang = Angle( 0, 25, 2 ),
		Color1 = "RED",
		Phase = "CHPA"
	},
	[57] = {
		ID = "Whelen Ion",
		Scale = .75,
		Pos = Vector( -10.5, 116.6, 48.2 ),
		Ang = Angle( 0, 0, 0 ),
		Color1 = "RED",
		Phase = "CHPA"
	},
	[58] = {
		ID = "Whelen Ion",
		Scale = .66,
		Pos = Vector( 10.5, 116.6, 48.2 ),
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
		Pos = Vector( 0, 29.2, 72.3 ),
		Ang = Angle( 0, -90, 0 )
	},
	[61] = {
		ID = "FPIU16 PAR-46",
		Scale = 1,
		Pos = Vector(0, 0, 0),
		Ang = Angle(0, 0, 0),
	},
	[62] = {
		ID = "Whelen CenCom Panel",
		Scale = 1,
		Pos = Vector(.35, 30.98, 37.5),
		Ang = Angle(0, 0, 5),
	},
	[63] = {
		ID = "Code 3 RX2700 Blue",
		Scale = .96,
		Pos = Vector( 0, -8.6, 83 ),
		Ang = Angle( 1.7, 90, 0),
	},
	[64] = {
		ID = "Code 3 RX2700 Red",
		Scale = .96,
		Pos = Vector( 0, -8.6, 83 ),
		Ang = Angle( 1.7, 90, 0),
	},
	[65] = {
		ID = "Code 3 RX2700 MC",
		Scale = .96,
		Pos = Vector( 0, -8.6, 83 ),
		Ang = Angle( 1.7, 90, 0),
	},
	[66] = {
		ID = "Whelen Vertex",
		Scale = 1,
		Pos = Vector(35.68, -107, 25.89),
		Ang = Angle(0, 48.51, 96.37)
	},
	[67] = {
		ID = "Whelen Vertex",
		Scale = 1,
		Pos = Vector(-35.68, -107, 25.89),
		Ang = Angle(0, -48.51, 96.37)
	},
	[68] = {
		ID = "Whelen 700 Trio",
		Scale = .7,
		Pos = Vector(-23, -109.6, 51),
		Ang = Angle(0, -15, 90),
		Phase = "A",
		Color2 = "BLUE",
		Color3 = "WHITE"
	},
	[69] = {
		ID = "Whelen 700 Trio",
		Scale = .7,
		Pos = Vector(23, -109.6, 51),
		Ang = Angle(0, 15, 90),
		Phase = "B",
		Color2 = "BLUE",
		Color3 = "WHITE"
	},
	[70] = {
		ID = "Whelen Vertex",
		Scale = 1,
		Pos = Vector(20.13, 118.46, 41.38),
		Ang = Angle(0, -90, -90)
	},
	[71] = {
		ID = "Whelen Vertex",
		Scale = 1,
		Pos = Vector(-20.13, 118.46, 41.38),
		Ang = Angle(0, 90, -90)
	},
	[72] = {
		ID = "Federal Signal Viper Dual",
		Scale = 1,
		Pos = Vector( 26, 28.6, 70),
		Ang = Angle( 0, 85, 2 ),
		Color1 = "BLUE",
		Color2 = "BLUE",
		Phase = "A"
	},
	[73] = {
		ID = "Federal Signal Viper Dual",
		Scale = 1,
		Pos = Vector( -26, 28.6, 70),
		Ang = Angle( 0, 95, -2 ),
		Color1 = "RED",
		Color2 = "RED",
		Phase = "B"
	},
	[74] = {
		ID = "Federal Signal Viper Dual",
		Scale = 1,
		Pos = Vector( 0, 52, 58),
		Ang = Angle( 0, 90, 0 ),
		Phase = "C",
		Color1 = "RED",
		Color2 = "BLUE"
	},
	[75] = {
		ID = "Whelen Ion Split",
		Scale = .75,
		Pos = Vector( -10.5, 116.6, 48.2 ),
		Ang = Angle( 0, 0, 0 ),
		Color1 = "RED",
		Color2 = "BLUE"
	},
	[76] = {
		ID = "Whelen Ion Split",
		Scale = .75,
		Pos = Vector( 10.5, 116.6, 48.2 ),
		Ang = Angle( 0, 0, 0 ),
		Color1 = "BLUE",
		Color2 = "RED"
	},
	[77] = {
		ID = "Whelen Ion Split",
		Scale = .75,
		Pos = Vector( -10.5, 116.6, 48.2 ),
		Ang = Angle( 0, 0, 0 ),
		Color1 = "RED",
		Color2 = "WHITE"
	},
	[78] = {
		ID = "Whelen Ion Split",
		Scale = .75,
		Pos = Vector( 10.5, 116.6, 48.2 ),
		Ang = Angle( 0, 0, 0 ),
		Color1 = "WHITE",
		Color2 = "RED"
	},
	[79] = {
		ID = "Whelen Ion Split",
		Scale = .75,
		Pos = Vector( -10.5, 116.6, 48.2 ),
		Ang = Angle( 0, 0, 0 ),
		Color1 = "BLUE",
		Color2 = "WHITE"
	},
	[80] = {
		ID = "Whelen Ion Split",
		Scale = .75,
		Pos = Vector( 10.5, 116.6, 48.2 ),
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
		Scale = .66,
		Pos = Vector( 7.8, 107.8, 44.4 ),
		Ang = Angle( 0, -6, 10 ),
		Color1 = "BLUE",
		Phase = "A"
	},
	[84] = {
		ID = "Whelen Ion",
		Scale = .66,
		Pos = Vector( -7.8, 107.8, 44.4 ),
		Ang = Angle( 0, 6, 10 ),
		Color1 = "BLUE",
		Phase = "B"
	},
	[85] = {
		ID = "Whelen Ion",
		Scale = .66,
		Pos = Vector( 7.8, 107.8, 44.4 ),
		Ang = Angle( 0, -6, 10 ),
		Color1 = "RED",
		Phase = "A"
	},
	[86] = {
		ID = "Whelen Ion",
		Scale = .66,
		Pos = Vector( -7.8, 107.8, 44.4 ),
		Ang = Angle( 0, 6, 10 ),
		Color1 = "RED",
		Phase = "B"
	},
	[87] = {
		ID = "Whelen Ion",
		Scale = .66,
		Pos = Vector( 7.8, 107.8, 44.4 ),
		Ang = Angle( 0, -6, 10 ),
		Color1 = "RED",
		Phase = "NYPDA"
	},
	[88] = {
		ID = "Whelen Ion",
		Scale = .66,
		Pos = Vector( -7.8, 107.8, 44.4 ),
		Ang = Angle( 0, 6, 10 ),
		Color1 = "RED",
		Phase = "NYPDB"
	},
	[89] = {
		ID = "FPIU16 Front Hideaway",
		Scale = 1,
		Pos = Vector( 0, 0, 0 ),
		Ang = Angle( 0, 0, 0 ),
		Color1 = "BLUE",
		Color2 = "BLUE"
	},
	[90] = {
		ID = "FPIU16 Front Hideaway",
		Scale = 1,
		Pos = Vector( 0, 0, 0 ),
		Ang = Angle( 0, 0, 0 ),
		Color1 = "RED",
		Color2 = "RED"
	},
	[91] = {
		ID = "FPIU16 Front Hideaway",
		Scale = 1,
		Pos = Vector( 0, 0, 0 ),
		Ang = Angle( 0, 0, 0 ),
		Color1 = "WHITE",
		Color2 = "WHITE"
	},
	[92] = {
		ID = "FPIU16 Reverse Hideaways",
		Scale = 1,
		Pos = Vector( 0, 0, 0 ),
		Ang = Angle( 0, 0, 0 ),
		Color1 = "BLUE",
		Color2 = "BLUE"
	},
	[93] = {
		ID = "FPIU16 Reverse Hideaways",
		Scale = 1,
		Pos = Vector( 0, 0, 0 ),
		Ang = Angle( 0, 0, 0 ),
		Color1 = "RED",
		Color2 = "RED"
	},
	[94] = {
		ID = "FPIU16 Reverse Hideaways",
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
		Pos = Vector( 26, 29.62, 69),
		Ang = Angle( 0, 85, 2 ),
		Color1 = "BLUE",
		Color2 = "WHITE",
		Phase = "A"
	},
	[98] = {
		ID = "Federal Signal Viper",
		Scale = 1,
		Pos = Vector( -26, 29.6, 69),
		Ang = Angle( 0, 95, -2 ),
		Color1 = "BLUE",
		Color2 = "WHITE",
		Phase = "B"
	},
	[99] = {
		ID = "Federal Signal Viper",
		Scale = 1,
		Pos = Vector( 26, 29.62, 69),
		Ang = Angle( 0, 85, 2 ),
		Color1 = "RED",
		Color2 = "WHITE",
		Phase = "A"
	},
	[100] = {
		ID = "Federal Signal Viper",
		Scale = 1,
		Pos = Vector( -26, 29.6, 69),
		Ang = Angle( 0, 95, -2 ),
		Color1 = "RED",
		Color2 = "WHITE",
		Phase = "B"
	},
	[101] = {
		ID = "Federal Signal Viper Dual",
		Scale = 1,
		Pos = Vector( 26, 28.6, 70),
		Ang = Angle( 0, 85, 2 ),
		Color1 = "BLUE",
		Color2 = "BLUE",
		Phase = "A"
	},
	[102] = {
		ID = "Federal Signal Viper Dual",
		Scale = 1,
		Pos = Vector( -26, 28.6, 70),
		Ang = Angle( 0, 95, -2 ),
		Color1 = "BLUE",
		Color2 = "BLUE",
		Phase = "B"
	},
	[103] = {
		ID = "Federal Signal Viper Dual",
		Scale = 1,
		Pos = Vector( 26, 28.6, 70),
		Ang = Angle( 0, 85, 2 ),
		Color1 = "RED",
		Color2 = "RED",
		Phase = "A"
	},
	[104] = {
		ID = "Federal Signal Viper Dual",
		Scale = 1,
		Pos = Vector( -26, 28.6, 70),
		Ang = Angle( 0, 95, -2 ),
		Color1 = "RED",
		Color2 = "RED",
		Phase = "B"
	},
	[105] = {
		ID = "Federal Signal Viper Dual",
		Scale = 1,
		Pos = Vector( 0, 52, 58),
		Ang = Angle( 0, 90, 0 ),
		Color1 = "BLUE",
		Color2 = "BLUE"
	},
	[106] = {
		ID = "Federal Signal Viper Dual",
		Scale = 1,
		Pos = Vector( 0, 52, 58),
		Ang = Angle( 0, 90, 0 ),
		Color1 = "RED",
		Color2 = "RED"
	},
	[107] = {
		ID = "Federal Signal Viper Dual",
		Scale = 1,
		Pos = Vector( 22, -92, 72.5),
		Ang = Angle( 0, -80, 0 ),
		Color1 = "BLUE",
		Color2 = "BLUE",
		Phase = "A"
	},
	[108] = {
		ID = "Federal Signal Viper Dual",
		Scale = 1,
		Pos = Vector( -22, -92, 72.5),
		Ang = Angle( 0, -100, 0 ),
		Color1 = "BLUE",
		Color2 = "BLUE",
		Phase = "B"
	},
	[109] = {
		ID = "Federal Signal Viper Dual",
		Scale = 1,
		Pos = Vector( 22, -92, 72.5),
		Ang = Angle( 0, -80, 0 ),
		Color1 = "RED",
		Color2 = "RED",
		Phase = "A"
	},
	[110] = {
		ID = "Federal Signal Viper Dual",
		Scale = 1,
		Pos = Vector( -22, -92, 72.5),
		Ang = Angle( 0, -100, 0 ),
		Color1 = "RED",
		Color2 = "RED",
		Phase = "B"
	},
	[111] = {
		ID = "Tomar 200S Rear",
		Scale = .66,
		Pos = Vector( 0, -94, 72.5 ),
		Ang = Angle( 0, -90, 0 ),
		Color1 = "BLUE",
		Color2 = "BLUE"
	},
	[112] = {
		ID = "Tomar 200S Rear",
		Scale = .66,
		Pos = Vector( 0, -94, 72.5 ),
		Ang = Angle( 0, -90, 0 ),
		Color1 = "RED",
		Color2 = "RED"
	},
	[113] = {
		ID = "Federal Signal Viper Dual",
		Scale = 1,
		Pos = Vector( 12, -101, 63.5 ),
		Ang = Angle( 0, -90, -180 ),
		Phase = "A",
		Color1 = "BLUE",
		Color2 = "AMBER"
	},
	[114] = {
		ID = "Federal Signal Viper Dual",
		Scale = 1,
		Pos = Vector( -12, -101, 63.5 ),
		Ang = Angle( 0, -90, -180 ),
		Phase = "B",
		Color1 = "AMBER",
		Color2 = "RED"
	},
	[115] = {
		ID = "Federal Signal Viper Dual",
		Scale = 1,
		Pos = Vector( 12, -101, 63.5 ),
		Ang = Angle( 0, -90, -180 ),
		Phase = "A",
		Color1 = "BLUE",
		Color2 = "AMBER"
	},
	[116] = {
		ID = "Federal Signal Viper Dual",
		Scale = 1,
		Pos = Vector( -12, -101, 63.5 ),
		Ang = Angle( 0, -90, -180 ),
		Phase = "B",
		Color1 = "AMBER",
		Color2 = "BLUE"
	},
	[117] = {
		ID = "Federal Signal Viper Dual",
		Scale = 1,
		Pos = Vector( 12, -101, 63.5 ),
		Ang = Angle( 0, -90, -180 ),
		Phase = "A",
		Color1 = "RED",
		Color2 = "AMBER"
	},
	[118] = {
		ID = "Federal Signal Viper Dual",
		Scale = 1,
		Pos = Vector( -12, -101, 63.5 ),
		Ang = Angle( 0, -90, -180 ),
		Phase = "B",
		Color1 = "AMBER",
		Color2 = "RED"
	},
	[119] = {
		ID = "Whelen 700 Trio",
		Scale = 1,
		Pos = Vector( -38.6, -45, 60 ),
		Ang = Angle( 2, 90, -90 ),
		Color1 = "BLUE",
		Color2 = "AMBER",
		Color3 = "WHITE"
	},
	[120] = {
		ID = "Whelen 700 Trio",
		Scale = 1,
		Pos = Vector( 38.6, -45, 60 ),
		Ang = Angle( 2, 90, 90 ),
		Color1 = "BLUE",
		Color2 = "AMBER",
		Color3 = "WHITE"
	},
	[121] = {
		ID = "Whelen 700 Trio",
		Scale = 1,
		Pos = Vector( -38.6, -45, 60 ),
		Ang = Angle( 2, 90, -90 ),
		Color1 = "RED",
		Color2 = "AMBER",
		Color3 = "WHITE"
	},
	[122] = {
		ID = "Whelen 700 Trio",
		Scale = 1,
		Pos = Vector( 38.6, -45, 60 ),
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
		Pos = Vector( 49.6, 37.8, 59.4 ),
		Ang = Angle( 0, -25, 2 ),
		Phase = "A"
	},
	[128] = {
		ID = "Whelen Ion Trio",
		Scale = .8,
		Pos = Vector( -49.6, 37.8, 59.4 ),
		Ang = Angle( 0, 25, 2 ),
		Phase = "B"
	},
	[129] = {
		ID = "Whelen Ion Split",
		Scale = .8,
		Pos = Vector( 49.6, 37.8, 59.4 ),
		Ang = Angle( 0, -25, 2 ),
		Color1 = "BLUE",
		Color2 = "WHITE"
	},
	[130] = {
		ID = "Whelen Ion Split",
		Scale = .8,
		Pos = Vector( -49.6, 37.8, 59.4 ),
		Ang = Angle( 0, 25, 2 ),
		Color1 = "WHITE",
		Color2 = "BLUE"
	},
	[131] = {
		ID = "Whelen Ion Split",
		Scale = .8,
		Pos = Vector( 49.6, 37.8, 59.4 ),
		Ang = Angle( 0, -25, 2 ),
		Color1 = "RED",
		Color2 = "WHITE"
	},
	[132] = {
		ID = "Whelen Ion Split",
		Scale = .8,
		Pos = Vector( -49.6, 37.8, 59.4 ),
		Ang = Angle( 0, 25, 2 ),
		Color1 = "WHITE",
		Color2 = "RED"
	},
	[133] = {
		ID = "Whelen Ion Split",
		Scale = .8,
		Pos = Vector( 49.6, 37.8, 59.4 ),
		Ang = Angle( 0, -25, 2 ),
		Color1 = "RED",
		Color2 = "BLUE"
	},
	[134] = {
		ID = "Whelen Ion Split",
		Scale = .8,
		Pos = Vector( -49.6, 37.8, 59.4 ),
		Ang = Angle( 0, 25, 2 ),
		Color1 = "BLUE",
		Color2 = "RED"
	},
	[135] = {
		ID = "Whelen Ion",
		Scale = .8,
		Pos = Vector( 49.6, 37.8, 59.4 ),
		Ang = Angle( 0, -25, 2 ),
		Phase = "A",
		Color1 = "RED"
	},
	[136] = {
		ID = "Whelen Ion",
		Scale = .8,
		Pos = Vector( -49.6, 37.8, 59.4 ),
		Ang = Angle( 0, 25, 2 ),
		Phase = "B",
		Color1 = "RED"
	},
	[137] = {
		ID = "Whelen Ion",
		Scale = .8,
		Pos = Vector( 49.6, 37.8, 59.4 ),
		Ang = Angle( 0, -25, 2 ),
		Phase = "A",
		Color1 = "BLUE"
	},
	[138] = {
		ID = "Whelen Ion",
		Scale = .8,
		Pos = Vector( -49.6, 37.8, 59.4 ),
		Ang = Angle( 0, 25, 2 ),
		Phase = "B",
		Color1 = "BLUE"
	},
	[139] = {
		ID = "Federal Signal Valor",
		Scale = .93,
		Pos = Vector( 0, -4, 83.6 ),
		Ang = Angle( 1.7, 90, 0),
		Phase = "A"
	},
	[140] = {
		ID = "Whelen 700 Trio",
		Scale = .7,
		Pos = Vector(-23, -109.6, 51),
		Ang = Angle(0, -15, 90),
		Phase = "A",
		Color1 = "BLUE",
		Color2 = "AMBER",
		Color3 = "WHITE"
	},
	[141] = {
		ID = "Whelen 700 Trio",
		Scale = .7,
		Pos = Vector(23, -109.6, 51),
		Ang = Angle(0, 15, 90),
		Phase = "B",
		Color1 = "BLUE",
		Color2 = "AMBER",
		Color3 = "WHITE"
	},
	[142] = {
		ID = "Whelen 700 Trio",
		Scale = .7,
		Pos = Vector(-23, -109.6, 51),
		Ang = Angle(0, -15, 90),
		Phase = "A",
		Color1 = "RED",
		Color2 = "AMBER",
		Color3 = "WHITE"
	},
	[143] = {
		ID = "Whelen 700 Trio",
		Scale = .7,
		Pos = Vector(23, -109.6, 51),
		Ang = Angle(0, 15, 90),
		Phase = "B",
		Color1 = "RED",
		Color2 = "AMBER",
		Color3 = "WHITE"
	},
	[144] = {
		ID = "Federal Signal Valor",
		Scale = .93,
		Pos = Vector( 0, -4, 83.6 ),
		Ang = Angle( 1.7, 90, 0),
		Phase = "CA"
	},
	[145] = {
		ID = "Federal Signal Valor",
		Scale = .93,
		Pos = Vector( 0, -4, 83.6 ),
		Ang = Angle( 1.7, 90, 0),
		Phase = "A",
		Color1 = "BLUE",
		Color2 = "WHITE"
	},
	[146] = {
		ID = "Federal Signal Valor",
		Scale = .93,
		Pos = Vector( 0, -4, 83.6 ),
		Ang = Angle( 1.7, 90, 0),
		Color1 = "BLUE",
		Color2 = "BLUE"
	},
	[147] = {
		ID = "Federal Signal Valor",
		Scale = .93,
		Pos = Vector( 0, -4, 83.6 ),
		Ang = Angle( 1.7, 90, 0),
		Phase = "A",
		Color1 = "RED",
		Color2 = "AMBER"
	},
	[148] = {
		ID = "Federal Signal Valor",
		Scale = .93,
		Pos = Vector( 0, -4, 83.6 ),
		Ang = Angle( 1.7, 90, 0),
		Color1 = "RED",
		Color2 = "RED"
	},
	[149] = {
		ID = "Federal Signal Valor",
		Scale = .93,
		Pos = Vector( 0, -4, 83.6 ),
		Ang = Angle( 1.7, 90, 0),
		Color1 = "RED",
		Color2 = "RED"
	},
	[150] = {
		ID = "Federal Signal Hotfoot",
		Scale = 1,
		Pos = Vector( -25, 3.6, 81.2 ),
		Ang = Angle( 0, 0, 0),
		Color1 = "RED",
		Phase = "CA"
	},
	[151] = {
		ID = "Federal Signal Hotfoot",
		Scale = 1,
		Pos = Vector( 25, 3.6, 81.2 ),
		Ang = Angle( 0, 0, 0),
		Color1 = "BLUE",
		Phase = "CA"
	},
	[152] = {
		ID = "Whelen Ion",
		Scale = .8,
		Pos = Vector( 49.6, 37.8, 59.4 ),
		Ang = Angle( 0, -25, 2 ),
		Color1 = "BLUE"
	},
	[153] = {
		ID = "Whelen Ion",
		Scale = .8,
		Pos = Vector( -49.6, 37.8, 59.4 ),
		Ang = Angle( 0, 25, 2 ),
		Color1 = "RED",
		Phase = "CA"
	},
	[154] = {
		ID = "Federal Signal Legend Blue",
		Scale = 1.05,
		Pos = Vector( 0, -8.5, 83 ),
		Ang = Angle( 1, 90, 0),
	},
	[155] = {
		ID = "Federal Signal Legend Red",
		Scale = 1.05,
		Pos = Vector( 0, -8.5, 83 ),
		Ang = Angle( 1, 90, 0),
	},
	[156] = {
		ID = "Whelen Justice",
		Scale = 1.06,
		Pos = Vector( 0, -7.1, 84 ),
		Ang = Angle( 1, 90, 0),
		Color1 = "BLUE",
		Color2 = "BLUE",
	},
	[157] = {
		ID = "Whelen Justice",
		Scale = 1.06,
		Pos = Vector( 0, -7.1, 84 ),
		Ang = Angle( 1, 90, 0),
		Color1 = "RED",
		Color2 = "RED",
	},
	[158] = {
		ID = "Federal Signal Integrity",
		Scale = 1,
		Pos = Vector( 0, -10.4, 82 ),
		Ang = Angle( 1, 90, 0),
		Color1 = "BLUE",
		Color2 = "BLUE"
	},
	[159] = {
		ID = "Federal Signal Integrity",
		Scale = 1,
		Pos = Vector( 0, -10.4, 82 ),
		Ang = Angle( 1, 90, 0),
		Color1 = "RED",
		Color2 = "RED"
	},
	[160] = {
		ID = "Whelen Ultra Freedom",
		Scale = 1,
		Pos = Vector( 0, -8.1, 84 ),
		Ang = Angle( 1, 90, 0),
		Color1 = "BLUE",
		Color2 = "BLUE"

	},
	[161] = {
		ID = "Whelen Ultra Freedom",
		Scale = 1,
		Pos = Vector( 0, -8.1, 84 ),
		Ang = Angle( 1, 90, 0),
		AutoPatterns = true,
		Color1 = "RED",
		Color2 = "RED"
	},
	[162] = {
		ID = "Whelen Liberty SX",
		Scale = .98,
		Pos = Vector( 0, -8, 83 ),
		Ang = Angle( 1, 90, 0),
		Color1 = "BLUE",
		Color2 = "BLUE"
	},
	[163] = {
		ID = "Whelen Liberty SX",
		Scale = .98,
		Pos = Vector( 0, -8, 83 ),
		Ang = Angle( 1, 90, 0),
		Color1 = "RED",
		Color2 = "RED"
	}
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
			{ Name = "None" },
		}
	},
	{
		Name = "Bumper Layout",
		Options = {
			{ Category = "Fog Lights", Name = "Red/Blue", Auto = { 40 }, Bodygroups = { { 7, 1 } } },
			{ Category = "Fog Lights", Name = "Blue", Auto = { 81 }, Bodygroups = { { 7, 1 } } },
			{ Category = "Fog Lights", Name = "Red", Auto = { 82 }, Bodygroups = { { 7, 1 } } },
			{ Category = "Fog Lights", Name = "CHP - White", Auto = { 59 }, Bodygroups = { { 7, 1 } } },
			{ Name = "None", Bodygroups = { { 7, 0 } } },
			{ Name = "Pushbar Wraparound", Props = { 18, 19 }, Bodygroups = { { 7, 0 } } },
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
			{ Category = "Setina Pushbar", Name = "R/B Trio", Props = { 13 }, Auto = { 44, 45, 70, 71 } },
			{ Category = "Setina Pushbar", Name = "R/B Split", Props = { 13 }, Auto = { 75, 76, 70, 71 } },
			{ Category = "Setina Pushbar", Name = "B/W Split", Props = { 13 }, Auto = { 79, 80, 70, 71 } },
			{ Category = "Setina Pushbar", Name = "R/W Split", Props = { 13 }, Auto = { 77, 78, 70, 71 } },
			{ Category = "Setina Pushbar", Name = "CHP - Red", Props = { 13 }, Auto = { 57, 58 } },
			{ Category = "Setina Pushbar", Name = "Plain", Props = { 13 } },
			{ Category = "LED Pushbar", Name = "Red/Blue", Auto = { 12 } },
			{ Category = "LED Pushbar", Name = "Blue", Auto = { 28 } },
			{ Category = "LED Pushbar", Name = "Red", Auto = { 29 } },
			{ Name = "NYPD Pushrod", Props = { 28 } },
			{ Name = "None" },
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
		Name = "Rear Trunk Lights",
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
			{ Category = "Inner Bar", Name = "Red/Blue", Auto = { 9 } },
			{ Category = "Inner Bar", Name = "Blue", Auto = { 95 } },
			{ Category = "Inner Bar", Name = "Red", Auto = { 96 } },
			{ Category = "Inner Bar Small", Name = "Red/Blue", Auto = { 60 } },
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
		Name = "Mid-Level Side",
		Options = {
			{ Category = "Whelen 700", Name = "R/B/W", Auto = { 47, 48 } },
			{ Category = "Whelen 700", Name = "B/A/W", Auto = { 119, 120 } },
			{ Category = "Whelen 700", Name = "R/A/W", Auto = { 121, 122 } },
			{ Category = "Viper Dual", Name = "Red/Blue", Auto = { 50, 51 } },
			{ Category = "Viper Dual", Name = "Blue", Auto = { 123, 124 } },
			{ Category = "Viper Dual", Name = "Red", Auto = { 125, 126 } },
			{ Name = "None" },
		}
	},
	{
		Name = "Rear Upper Deck",
		Options = {
			{ Category = "Inner Bar", Name = "Red/Blue", Auto = { 24 } },
			{ Category = "Inner Bar", Name = "Blue", Auto = { 30 } },
			{ Category = "Inner Bar", Name = "Red", Auto = { 31 } },
			{ Category = "Dual Vipers", Name = "Red/Blue", Auto = { 17, 18 } },
			{ Category = "Dual Vipers", Name = "Blue", Auto = { 107, 108 } },
			{ Category = "Dual Vipers", Name = "Red", Auto = { 109, 110 } },
			{ Category = "Tomar 200S", Name = "Red/Blue/Amber", Auto = { 49 } },
			{ Category = "Tomar 200S", Name = "Blue/Amber", Auto = { 111 } },
			{ Category = "Tomar 200S", Name = "Red/Amber", Auto = { 112 } },
			{ Name = "None" },
		}
	},
	{
		Name = "Rear Lower Deck",
		Options = {
			{ Name = "None" },
			{ Name = "Red/Blue/Amber", Auto = { 113, 114 } },
			{ Name = "Blue/Amber", Auto = { 115, 116 } },
			{ Name = "Red/Amber", Auto = { 117, 118 } },
			{ Name = "NYPD R/B", Auto = { 52, 53 } },
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
			{ Name = "Full", Props = { 2, 3, 4, 5, 6, 7, 8 }, Auto = { 62 } },
			{ Name = "None" },
		}
	},
	{
		Name = "Spotlight",
		Options = {
			{ Name = "Full", Auto = { 61 }, Props = { 9 } },
			{ Name = "None" },
		}
	},
	{
		Name = "Forward ALPR",
		Options = {
			{ Name = "None" },
			{ Name = "All", Props = { 14, 15, 16, 17 } },
			{ Name = "Front", Props = { 14, 15 } },
			{ Name = "Reverse", Props = { 16, 17 } },
		}
	}

}

EMV.Configuration = "fpiu16"

Photon.EMVLibrary[name] = EMV
-- if EMVU then EMVU:OverwriteIndex( name, EMV ) end
-- if PI then Photon:OverwriteIndex( name, PI ) end
