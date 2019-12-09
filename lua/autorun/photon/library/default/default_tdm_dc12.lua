AddCSLuaFile()

local name = "Dodge Charger SRT8 2012 Police"

local A = "AMBER"
local R = "RED"
local DR = "D_RED"
local B = "BLUE"
local W = "WHITE"
local CW = "C_WHITE"
local SW = "S_WHITE"

local EMV = {}

EMV.Siren = 7

EMV.Color = nil
EMV.Skin = 0

EMV.BodyGroups = {
	{ 0, 0 }, -- Dodge
	{ 1, 0 }, -- Charger
	{ 2, 0 }, -- 2012
	{ 3, 0 }, --
	{ 4, 0 }, --
	{ 5, 0 }, --
	{ 6, 0 }, --
	{ 7, 2 }, -- push bar
	{ 8, 1 }, -- grille leds
	{ 9, 1 }, -- front bumper leds
	{ 10, 3 }, -- front interior lightbar
	{ 11, 4 }, -- lightbar
	{ 12, 2 }, -- rear interior lightbar
	{ 13, 1 }, -- rear passenger leds
	{ 14, 1 }, -- antennas
	{ 15, 2 }, -- spotlights
	{ 16, 0 }, -- wing
	{ 17, 0 }, -- wheel
	{ 18, 0 }, -- cage
}

EMV.Props = {

}

EMV.Meta = {

}

EMV.Positions = {

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
			BG_Components = {},
			Preset_Components = {},
			BG_Components = {
				["spotlights"] = {
					["0"] = {
						{ 1, W, 2 },
						{ 2, W, 2 }
					},
				},
			},
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

local posRef = {
	["Arjent"] = {
		Scale = .8,
		Pos = Vector( 0, -19, 76.25 ),
		Ang = Angle( .25, 90, 0 )
	},
	["Integrity"] = {
		Scale = .93,
		Pos = Vector( 0, -21, 76.25 ),
		Ang = Angle( .25, 90, 0 )
	},
	["LibertySX"] = {
		Scale = .91,
		Pos = Vector( 0, -19.3, 76.25 ),
		Ang = Angle( .25, 90, 0 )
	},
	["LibertyII"] = {
		Scale = 1.02,
		Pos = Vector( 0, -19, 77 ),
		Ang = Angle( .25, 90, 0 )
	},
	["Legacy"] = {
		Scale = .96,
		Pos = Vector( 0, -19.5, 76.45 ),
		Ang = Angle( .25, 90, 0 )
	},
	["Freedom"] = {
		Scale = .95,
		Pos = Vector( 0, -20, 77.2 ),
		Ang = Angle( 0, 0, -.25 )
	},
	["Justice"] = {
		Scale = 1,
		Pos = Vector( 0, -19, 78 ),
		Ang = Angle( .1, 90, 0 )
	},
	["RX2700"] = {
		Scale = .95,
		Pos = Vector( 0, -19.5, 76.4 ),
		Ang = Angle( 0, 90, 0 )
	},
	["Solex"] = {
		Scale = 1,
		Pos = Vector( 0, -19, 73.9 ),
		Ang = Angle( .25, 0, 0 )
	},
	["Vision"] = {
		Scale = .91,
		Pos = Vector( 0, -21, 78.2 ),
		Ang = Angle( .25, 90, 0 )
	},
	["Legend"] = {
		Scale = 1,
		Pos = Vector( 0, -19, 76.5 ),
		Ang = Angle( .25, 90, 0 )
	},
	["Valor"] = {
		Scale = .90,
		Pos = Vector( 0, -16, 77.3 ),
		Ang = Angle( .25, 90, 0 )
	},
	["Avatar"] = {
		Scale = .85,
		Pos = Vector( 0, -20, 74 ),
		Ang = Angle( .25, 90, 0 )
	},
}

EMV.Auto = {
	[1] = {
		ID = "Federal Signal Integrity",
		Scale = posRef.Integrity.Scale,
		Pos = posRef.Integrity.Pos,
		Ang = posRef.Integrity.Ang,
	},
	[2] = {
		ID = "Federal Signal Integrity",
		Scale = posRef.Integrity.Scale,
		Pos = posRef.Integrity.Pos,
		Ang = posRef.Integrity.Ang,
		Color1 = "BLUE",
		Color2 = "BLUE"
	},
	[3] = {
		ID = "Federal Signal Integrity",
		Scale = posRef.Integrity.Scale,
		Pos = posRef.Integrity.Pos,
		Ang = posRef.Integrity.Ang,
		Color1 = "RED",
		Color2 = "RED"
	},
	[4] = {
		ID = "Whelen Liberty SX",
		Scale = posRef.LibertySX.Scale,
		Pos = posRef.LibertySX.Pos,
		Ang = posRef.LibertySX.Ang
	},
	[5] = {
		ID = "Whelen Liberty SX",
		Scale = posRef.LibertySX.Scale,
		Pos = posRef.LibertySX.Pos,
		Ang = posRef.LibertySX.Ang,
		Color1 = "BLUE",
		Color2 = "BLUE"
	},
	[6] = {
		ID = "Whelen Liberty SX",
		Scale = posRef.LibertySX.Scale,
		Pos = posRef.LibertySX.Pos,
		Ang = posRef.LibertySX.Ang,
		Color1 = "RED",
		Color2 = "RED"
	},
	[7] = {
		ID = "Whelen Legacy",
		Scale = posRef.Legacy.Scale,
		Pos = posRef.Legacy.Pos,
		Ang = posRef.Legacy.Ang
	},
	[8] = {
		ID = "Whelen Legacy",
		Scale = posRef.Legacy.Scale,
		Pos = posRef.Legacy.Pos,
		Ang = posRef.Legacy.Ang,
		Color1 = "BLUE",
		Color2 = "BLUE"
	},
	[9] = {
		ID = "Whelen Legacy",
		Scale = posRef.Legacy.Scale,
		Pos = posRef.Legacy.Pos,
		Ang = posRef.Legacy.Ang,
		Color1 = "RED",
		Color2 = "RED"
	},
	[10] = {
		ID = "Whelen Liberty II",
		Scale = posRef.LibertyII.Scale,
		Pos = posRef.LibertyII.Pos,
		Ang = posRef.LibertyII.Ang
	},
	[11] = {
		ID = "Whelen Liberty II",
		Scale = posRef.LibertyII.Scale,
		Pos = posRef.LibertyII.Pos,
		Ang = posRef.LibertyII.Ang,
		Color1 = "BLUE",
		Color2 = "BLUE"
	},
	[12] = {
		ID = "Whelen Liberty II",
		Scale = posRef.LibertyII.Scale,
		Pos = posRef.LibertyII.Pos,
		Ang = posRef.LibertyII.Ang,
		Color1 = "RED",
		Color2 = "RED"
	},
	[13] = {
		ID = "Whelen Justice",
		Scale = posRef.Justice.Scale,
		Pos = posRef.Justice.Pos,
		Ang = posRef.Justice.Ang,
		Color1 = "RED",
		Color2 = "BLUE"
	},
	[14] = {
		ID = "Whelen Justice",
		Scale = posRef.Justice.Scale,
		Pos = posRef.Justice.Pos,
		Ang = posRef.Justice.Ang,
		Color1 = "BLUE",
		Color2 = "BLUE"
	},
	[15] = {
		ID = "Whelen Justice",
		Scale = posRef.Justice.Scale,
		Pos = posRef.Justice.Pos,
		Ang = posRef.Justice.Ang,
		Color1 = "RED",
		Color2 = "RED"
	},
	[16] = {
		ID = "Code 3 RX2700",
		Scale = posRef.RX2700.Scale,
		Pos = posRef.RX2700.Pos,
		Ang = posRef.RX2700.Ang
	},
	[17] = {
		ID = "Code 3 RX2700 Blue",
		Scale = posRef.RX2700.Scale,
		Pos = posRef.RX2700.Pos,
		Ang = posRef.RX2700.Ang
	},
	[18] = {
		ID = "Code 3 RX2700 Red",
		Scale = posRef.RX2700.Scale,
		Pos = posRef.RX2700.Pos,
		Ang = posRef.RX2700.Ang
	},
	[19] = {
		ID = "Code 3 RX2700 MC",
		Scale = posRef.RX2700.Scale,
		Pos = posRef.RX2700.Pos,
		Ang = posRef.RX2700.Ang
	},
	[20] = {
		ID = "Federal Signal Legend",
		Scale = posRef.Legend.Scale,
		Pos = posRef.Legend.Pos,
		Ang = posRef.Legend.Ang
	},
	[21] = {
		ID = "Federal Signal Legend Blue",
		Scale = posRef.Legend.Scale,
		Pos = posRef.Legend.Pos,
		Ang = posRef.Legend.Ang
	},
	[22] = {
		ID = "Federal Signal Legend Red",
		Scale = posRef.Legend.Scale,
		Pos = posRef.Legend.Pos,
		Ang = posRef.Legend.Ang
	},
	[23] = {
		ID = "Federal Signal Valor",
		Scale = posRef.Valor.Scale,
		Pos = posRef.Valor.Pos,
		Ang = posRef.Valor.Ang
	},
	[24] = {
		ID = "Federal Signal Valor",
		Scale = posRef.Valor.Scale,
		Pos = posRef.Valor.Pos,
		Ang = posRef.Valor.Ang,
		Phase = "A"
	},
	[25] = {
		ID = "Federal Signal Valor",
		Scale = posRef.Valor.Scale,
		Pos = posRef.Valor.Pos,
		Ang = posRef.Valor.Ang,
		Phase = "A",
		Color1 = "BLUE",
		Color2 = "WHITE"
	},
	[26] = {
		ID = "Federal Signal Valor",
		Scale = posRef.Valor.Scale,
		Pos = posRef.Valor.Pos,
		Ang = posRef.Valor.Ang,
		Phase = "A",
		Color1 = "RED",
		Color2 = "WHITE"
	},
	[27] = {
		ID = "Federal Signal Valor",
		Scale = posRef.Valor.Scale,
		Pos = posRef.Valor.Pos,
		Ang = posRef.Valor.Ang,
		Color1 = "BLUE",
		Color2 = "BLUE"
	},
	[28] = {
		ID = "Federal Signal Valor",
		Scale = posRef.Valor.Scale,
		Pos = posRef.Valor.Pos,
		Ang = posRef.Valor.Ang,
		Color1 = "RED",
		Color2 = "RED"
	},
	[29] = {
		ID = "Federal Signal Arjent",
		Scale = posRef.Arjent.Scale,
		Pos = posRef.Arjent.Pos,
		Ang = posRef.Arjent.Ang
	},
	[30] = {
		ID = "Federal Signal Vision SLR",
		Scale = posRef.Vision.Scale,
		Pos = posRef.Vision.Pos,
		Ang = posRef.Vision.Ang
	},
	[31] = {
		ID = "Federal Signal Vision SLR R/B",
		Scale = posRef.Vision.Scale,
		Pos = posRef.Vision.Pos,
		Ang = posRef.Vision.Ang
	},
	[32] = {
		ID = "Federal Signal Vision SLR Clear",
		Scale = posRef.Vision.Scale,
		Pos = posRef.Vision.Pos,
		Ang = posRef.Vision.Ang
	},
	[33] = {
		ID = "Code 3 Solex",
		Scale = posRef.Solex.Scale,
		Pos = posRef.Solex.Pos,
		Ang = posRef.Solex.Ang
	},
	[34] = {
		ID = "Feniex Avatar",
		Scale = posRef.Avatar.Scale,
		Pos = posRef.Avatar.Pos,
		Ang = posRef.Avatar.Ang
	},
	[35] = {
		ID = "Feniex Avatar",
		Scale = posRef.Avatar.Scale,
		Pos = posRef.Avatar.Pos,
		Ang = posRef.Avatar.Ang,
		Color1 = "BLUE",
		Color2 = "BLUE"
	},
	[36] = {
		ID = "Feniex Avatar",
		Scale = posRef.Avatar.Scale,
		Pos = posRef.Avatar.Pos,
		Ang = posRef.Avatar.Ang,
		Color1 = "RED",
		Color2 = "RED"
	},
	[37] = {
		ID = "Whelen Ultra Freedom Alternate",
		Scale = posRef.Freedom.Scale,
		Pos = posRef.Freedom.Pos,
		Ang = posRef.Freedom.Ang
	},
	[38] = {
		ID = "Code 3 Solex",
		Scale = posRef.Solex.Scale,
		Pos = posRef.Solex.Pos,
		Ang = posRef.Solex.Ang,
		Color1 = "BLUE",
		Color2 = "BLUE"
	},
	[39] = {
		ID = "Code 3 Solex",
		Scale = posRef.Solex.Scale,
		Pos = posRef.Solex.Pos,
		Ang = posRef.Solex.Ang,
		Color1 = "RED",
		Color2 = "RED"
	},
}



EMV.Selections = { -- structured and flexible version of presets designed to mimic bodygroups
	{
		Name = "Lightbar",
		Options = {
			{ Category = "Whelen Ultra Freedom", Name = "Red/Blue/Amber", Auto = { 37 } },
			{ Category = "Whelen Legacy", Name = "Red/Blue", Auto = { 7 } },
			{ Category = "Whelen Legacy", Name = "Blue", Auto = { 8 } },
			{ Category = "Whelen Legacy", Name = "Red", Auto = { 9 } },
			{ Category = "Whelen Liberty II", Name = "Red/Blue", Auto = { 10 } },
			{ Category = "Whelen Liberty II", Name = "Blue", Auto = { 11 } },
			{ Category = "Whelen Liberty II", Name = "Red", Auto = { 12 } },
			{ Category = "Whelen Liberty SX", Name = "Red/Blue", Auto = { 4 } },
			{ Category = "Whelen Liberty SX", Name = "Blue", Auto = { 5 } },
			{ Category = "Whelen Liberty SX", Name = "Red", Auto = { 6 } },
			{ Category = "Whelen Justice", Name = "Red/Blue", Auto = { 13 } },
			{ Category = "Whelen Justice", Name = "Blue", Auto = { 14 } },
			{ Category = "Whelen Justice", Name = "Red", Auto = { 15 } },
			{ Category = "Federal Signal Arjent", Name = "Red/Blue", Auto = { 29 } },
			{ Category = "Federal Signal Integrity", Name = "Red/Blue", Auto = { 1 } },
			{ Category = "Federal Signal Integrity", Name = "Blue", Auto = { 2 } },
			{ Category = "Federal Signal Integrity", Name = "Red", Auto = { 3 } },
			{ Category = "Federal Signal Legend", Name = "Red/Blue", Auto = { 20 } },
			{ Category = "Federal Signal Legend", Name = "Blue", Auto = { 21 } },
			{ Category = "Federal Signal Legend", Name = "Red", Auto = { 22 } },
			{ Category = "Federal Signal Valor", Name = "Default", Auto = { 23 } },
			{ Category = "Federal Signal Valor", Name = "Alternate", Auto = { 24 } },
			{ Category = "Federal Signal Valor", Name = "Blue/White", Auto = { 25 } },
			{ Category = "Federal Signal Valor", Name = "Red/White", Auto = { 26 } },
			{ Category = "Federal Signal Valor", Name = "Blue/Blue", Auto = { 27 } },
			{ Category = "Federal Signal Valor", Name = "Red/Red", Auto = { 28 } },
			{ Category = "Federal Signal Vision SLR", Name = "Red/Blue", Auto = { 31 } },
			{ Category = "Federal Signal Vision SLR", Name = "Red/Blue Clear", Auto = { 31 } },
			{ Category = "Federal Signal Vision SLR", Name = "NYPD", Auto = { 30 } },
			{ Category = "Feniex Avatar", Name = "Red/Blue", Auto = { 34 } },
			{ Category = "Feniex Avatar", Name = "Blue", Auto = { 35 } },
			{ Category = "Feniex Avatar", Name = "Red", Auto = { 36 } },
			{ Category = "Code 3 RX2700", Name = "Red/Blue", Auto = { 16 } },
			{ Category = "Code 3 RX2700", Name = "Multi-Color", Auto = { 19 } },
			{ Category = "Code 3 RX2700", Name = "Blue", Auto = { 17 } },
			{ Category = "Code 3 RX2700", Name = "Red", Auto = { 18 } },
			{ Category = "Code 3 Solex", Name = "Red/Blue", Auto = { 33 } },
			{ Category = "Code 3 Solex", Name = "Blue", Auto = { 38 } },
			{ Category = "Code 3 Solex", Name = "Red", Auto = { 39 } },
			{ Name = "None" },
		}
	},
	{
		Name = "Forward Hideaways",
		Options = {
			{ Name = "None" },
		}
	},
	{
		Name = "Grille",
		Options = {
			{ Name = "None" },
		}
	},
	{
		Name = "Headlight Wig-Wag",
		Options = {
			{ Name = "None" },
		}
	},
	{
		Name = "Pushbars",
		Options = {
			{ Name = "None" },
		}
	},
	{
		Name = "Pushbar Wraparound",
		Options = {
			{ Name = "None" },
		}
	},
	{
		Name = "Turn Signal Hideaways",
		Options = {
			{ Name = "None" },
		}
	},
	{
		Name = "Rear Vertexes",
		Options = {
			{ Name = "None" },
		}
	},
	{
		Name = "License Plate Vertexes",
		Options = {
			{ Name = "None" },
		}
	},
	{
		Name = "Reverse Light Hideaways",
		Options = {
			{ Name = "None" },
		}
	},
	{
		Name = "Front Upper Deck",
		Options = {
			{ Name = "None" },
		}
	},
	{
		Name = "Front Lower Deck",
		Options = {
			{ Name = "None" },
		}
	},
	{
		Name = "Forward Side",
		Options = {
			{ Name = "None" },
		}
	},
	{
		Name = "Rear Side",
		Options = {
			{ Name = "None" },
		}
	},
	{
		Name = "Skirt Lighting",
		Options = {
			{ Name = "None" },
		}
	},
	{
		Name = "Rear Upper Deck",
		Options = {
			{ Name = "None" },
		}
	},
	{
		Name = "Rear Lower Deck",
		Options = {
			{ Name = "None" },
		}
	},
	{
		Name = "Mirror Lights",
		Options = {
			{ Name = "None" },
		}
	},
	{
		Name = "Roof",
		Options = {
			{ Name = "None" },
		}
	},
	{
		Name = "Interior Equipment",
		Options = {
			{ Name = "None" },
		}
	},
	{
		Name = "Spotlight",
		Options = {
			{ Name = "None" },
		}
	},
	{
		Name = "Trunk Equipment",
		Options = {
			{ Name = "None" },
		}
	}

}

EMV.Configuration = true
Photon.EMVLibrary[name] = EMV
if EMVU then EMVU:OverwriteIndex( name, EMV ) end