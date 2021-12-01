AddCSLuaFile()

local name = "Dodge Charger R/T 2015 Pursuit"

local function MirrorVector( vec, method )
	local newVector = Vector()
	if method == nil then
		newVector:Set( vec )
		newVector.x = vec.x * -1
	end
	return newVector
end

local function MirrorAngle( ang, method )
	local newAng = Angle()
	if method == nil then
		newAng:Set( ang )
		newAng.p = ang.p * -1
		newAng.r = ang.r * -1
		local yAngDif = -90 - ang.y
		newAng.y = ang.y + ( yAngDif * 2 )
	end
	if method == "opp" then
		newAng:Set( ang )
		newAng.p = ang.p * -1
		newAng.y = ang.y * -1
		-- newAng.r = ang.r * -1
	end
	return newAng
end

local W = "WHITE"

local EMV = {}

EMV.Siren = 7

EMV.SubMaterials = {
	["26"] = "photon/override/blank",
	["23"] = "photon/override/blank"
}

EMV.Color = nil
EMV.Skin = 0

EMV.BodyGroups = {}

EMV.Props = {
	[1] = {
		Model = "models/schmal/alpr_camera_minimal.mdl",
		Scale = .66,
		Pos = Vector( 27, 2, 73.6 ),
		Ang = Angle( 10, 60, 2),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[2] = {
		Model = "models/schmal/alpr_camera_minimal.mdl",
		Scale = .66,
		Pos = Vector( -27, 2, 73.6 ),
		Ang = Angle( 10, 120, 2),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[3] = {
		Model = "models/schmal/alpr_camera_minimal.mdl",
		Scale = .66,
		Pos = Vector( 27, -29, 74 ),
		Ang = Angle( 10, 0, 6),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[4] = {
		Model = "models/schmal/alpr_camera_minimal.mdl",
		Scale = .66,
		Pos = Vector( -27, -29, 74 ),
		Ang = Angle( 10, 180, -6),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[5] = {
		Model = "models/schmal/lwdodch_airel.mdl",
		Scale = 1,
		Pos = Vector(0, -106.2, 55.1),
		Ang = Angle( 0, 0, 0),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL,
		AirEL = true
	},
	[6] = {
		Model = "models/schmal/lwdodch_tail.mdl",
		Scale = .995,
		Pos = Vector(0, -117.7, 46.9),
		Ang = Angle( 0, 0, 0),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[7] = {
		Model = "models/schmal/lwdodch_head_driver.mdl",
		Scale = 1,
		Pos = Vector(0, .1, 0),
		Ang = Angle( 0, 0, 0),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[8] = {
		Model = "models/schmal/lwdodch_head_driver_glw.mdl",
		Scale = .999,
		Pos = Vector(0, .11, 0),
		Ang = Angle( 0, 0, 0),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[9] = {
		Model = "models/schmal/antennas/antenna_6.mdl",
		Scale = 2,
		Pos = Vector(-5, -30, 84),
		Ang = Angle( 0, 0, 2),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[10] = {
		Model = "models/schmal/antennas/antenna_4.mdl",
		Scale = 2,
		Pos = Vector(-5, -42, 84),
		Ang = Angle( 0, 0, 2),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[11] = {
		Model = "models/schmal/antennas/antenna_6.mdl",
		Scale = 2,
		Pos = Vector(5, -30, 83),
		Ang = Angle( 0, 0, 2),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[12] = {
		Model = "models/schmal/antennas/antenna_4.mdl",
		Scale = 2,
		Pos = Vector(5, -42, 83),
		Ang = Angle( 0, 0, 2),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[13] = {
		Model = "models/tdmcars/emergency/equipment/dynamax_siren.mdl",
		Scale = 1.5,
		Pos = Vector(0, 128, 28.15),
		Ang = Angle( 0, -90, 0)
	},
	[14] = {
		Model = "models/schmal/alpr_camera_minimal.mdl",
		Scale = .66,
		Pos = Vector( 22, -2, 74.25 ),
		Ang = Angle( 10, 60, 3),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[15] = {
		Model = "models/schmal/alpr_camera_minimal.mdl",
		Scale = .66,
		Pos = Vector( -22, -2, 74.25 ),
		Ang = Angle( 10, 120, -3),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[16] = {
		Model = "models/schmal/fpiu_wrap.mdl",
		Scale = 1,
		Pos = Vector( 32, 115, 28 ),
		Ang = Angle( 4, 90, 0),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[17] = {
		Model = "models/schmal/fpiu_wrap.mdl",
		Scale = 1,
		Pos = Vector( -32, 115, 28 ),
		Ang = Angle( 4, 90, 180),
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	}
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

local posRef = {
	["Arjent"] = {
		Scale = .8,
		Pos = Vector( 0, -16, 75 ),
		Ang = Angle( .25, 90, 0 )
	},
	["Integrity"] = {
		Scale = .93,
		Pos = Vector( 0, -18.5, 75.6 ),
		Ang = Angle( .25, 90, 0 )
	},
	["LibertySX"] = {
		Scale = .91,
		Pos = Vector( 0, -16, 75.8 ),
		Ang = Angle( .25, 90, 0 )
	},
	["LibertySXAlt"] = {
		Scale = .82,
		Pos = Vector( 0, -16, 72 ),
		Ang = Angle( .25, 0, 0 )
	},
	["LibertyII"] = {
		Scale = 1.02,
		Pos = Vector( 0, -16, 76 ),
		Ang = Angle( .25, 90, 0 )
	},
	["Legacy"] = {
		Scale = .96,
		Pos = Vector( 0, -17, 75.5 ),
		Ang = Angle( .25, 90, 0 )
	},
	["Freedom"] = {
		Scale = .95,
		Pos = Vector( 0, -16, 76.2 ),
		Ang = Angle( 0, 0, -.25 )
	},
	["Justice"] = {
		Scale = 1,
		Pos = Vector( 0, -16, 77 ),
		Ang = Angle( .1, 90, 0 )
	},
	["RX2700"] = {
		Scale = .95,
		Pos = Vector( 0, -15, 76.4 ),
		Ang = Angle( 0, 90, 0 )
	},
	["Solex"] = {
		Scale = 1.01,
		Pos = Vector( 0, -15, 72.9 ),
		Ang = Angle( .25, 0, 0 )
	},
	["Vision"] = {
		Scale = .91,
		Pos = Vector( 0, -12, 77.3 ),
		Ang = Angle( .25, 90, 0 )
	},
	["Legend"] = {
		Scale = 1,
		Pos = Vector( 0, -15.5, 76.1 ),
		Ang = Angle( .5, 90, 0 )
	},
	["Valor"] = {
		Scale = .90,
		Pos = Vector( 0, -11, 76.2),
		Ang = Angle( .25, 90, 0 )
	},
	["Avatar"] = {
		Scale = .85,
		Pos = Vector( 0, -16, 73 ),
		Ang = Angle( .25, 90, 0 )
	},
	["FrontInterior"] = {
		Scale = 1,
		Pos = Vector( 0, 22.6, 66),
		Ang = Angle( 0, 90, 0 ),
	},
	["FrontInteriorB"] = {
		Scale = 1,
		Pos = Vector( 15, 21, 67),
		Ang = Angle( 0, -96, -2 ),
	},
	["MirrorIons"] = {
		Scale = .8,
		Pos = Vector( -47.6, 34.9, 55 ),
		Ang = Angle( 3, 24, 5 ),
	},
	["GrilleVertexOut"] = {
		Scale = .47,
		Pos = Vector( -16.8, 119.8, 36.8 ),
		Ang = Angle( 0, 13, 0 ),
	},
	["GrilleVertexIn"] = {
		Scale = .47,
		Pos =  Vector( -7.85, 120.8, 36.8 ),
		Ang = Angle( 0, 7, 0 ),
	},
	["Apollo"] = {
		Scale = 1.3,
		Pos =  Vector( 0, -82, 56.9 ),
		Ang = Angle( 0, -90, 0 ),
	},
	["ApolloUpper"] = {
		Scale = 1.4,
		Pos =  Vector( 0, -57, 66.2 ),
		Ang = Angle( 0, -90, 0 ),
	},
	["CHPIon"] = {
		Scale = 1,
		Pos =  Vector( -16, 128, 29.2 ),
		Ang = Angle( 0, -35, 0 ),
	},
	["RearLowerViper"] = {
		Scale = 1,
		Pos =  Vector( -14, -87, 57 ),
		Ang = Angle( 0, -100, 0 ),
		BodyGroups = {
			{ 1, 2 }
		}
	},
	["MidSide"] = {
		Scale = 1,
		Pos = Vector( -38, -54, 55.2 ),
		Ang = Angle( 4, 90, -90 )
	},
	["Bumper400"] = {
		Scale = 1,
		Pos =  Vector( -12, 129, 30.8 ),
		Ang = Angle( 0, 0, 0 ),
	},
	["RearVertexes"] = {
		Scale = 1.2,
		Pos = Vector(41.96, -112, 26),
		Ang = Angle(0, 70, 94)
	},
	["PlateVertexes"] = {
		Scale = 1.2,
		Pos = Vector(-20, -126.3, 31),
		Ang = Angle(0, -10, 90),
	},
	["BumperVertex"] = {
		Scale = 1.2,
		Pos = Vector(-21.3, 127.8, 32),
		Ang = Angle(0, -90, 90),
	},
}

local skirtOffsetY = -2
local skirtOffsetZ = -1

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
	[40] = {
		ID = "TDM Front Interior Lightbar",
		Scale = posRef.FrontInterior.Scale,
		Pos = posRef.FrontInterior.Pos,
		Ang = posRef.FrontInterior.Ang,
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL
	},
	[41] = {
		ID = "TDM Front Interior Lightbar",
		Scale = posRef.FrontInterior.Scale,
		Pos = posRef.FrontInterior.Pos,
		Ang = posRef.FrontInterior.Ang,
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL,
		Color1 = "BLUE",
		Color2 = "BLUE"
	},
	[42] = {
		ID = "TDM Front Interior Lightbar",
		Scale = posRef.FrontInterior.Scale,
		Pos = posRef.FrontInterior.Pos,
		Ang = posRef.FrontInterior.Ang,
		RenderGroup = RENDERGROUP_OPAQUE,
		RenderMode = RENDERMODE_NORMAL,
		Color1 = "RED",
		Color2 = "RED"
	},
	[43] = {
		ID = "Small Front Interior Trio",
		Scale = posRef.FrontInteriorB.Scale,
		Pos = posRef.FrontInteriorB.Pos,
		Ang = posRef.FrontInteriorB.Ang,
	},
	[44] = {
		ID = "Small Front Interior Trio",
		Scale = posRef.FrontInteriorB.Scale,
		Pos = MirrorVector( posRef.FrontInteriorB.Pos ),
		Ang = MirrorAngle( posRef.FrontInteriorB.Ang ),
		Color1 = "BLUE",
		Color2 = "RED"
	},
	[45] = {
		ID = "Small Front Interior Trio",
		Scale = posRef.FrontInteriorB.Scale,
		Pos = posRef.FrontInteriorB.Pos,
		Ang = posRef.FrontInteriorB.Ang,
		Color1 = "BLUE",
		Color2 = "WHITE"
	},
	[46] = {
		ID = "Small Front Interior Trio",
		Scale = posRef.FrontInteriorB.Scale,
		Pos = MirrorVector( posRef.FrontInteriorB.Pos ),
		Ang = MirrorAngle( posRef.FrontInteriorB.Ang ),
		Color1 = "WHITE",
		Color2 = "BLUE"
	},
	[47] = {
		ID = "Small Front Interior Trio",
		Scale = posRef.FrontInteriorB.Scale,
		Pos = posRef.FrontInteriorB.Pos,
		Ang = posRef.FrontInteriorB.Ang,
		Color1 = "RED",
		Color2 = "WHITE"
	},
	[48] = {
		ID = "Small Front Interior Trio",
		Scale = posRef.FrontInteriorB.Scale,
		Pos = MirrorVector( posRef.FrontInteriorB.Pos ),
		Ang = MirrorAngle( posRef.FrontInteriorB.Ang ),
		Color1 = "WHITE",
		Color2 = "RED"
	},
	[49] = {
		ID = "Whelen Ion",
		Scale = posRef.MirrorIons.Scale,
		Pos = posRef.MirrorIons.Pos,
		Ang = posRef.MirrorIons.Ang,
		Color1 = "RED",
		Phase = "A"
	},
	[50] = {
		ID = "Whelen Ion",
		Scale = posRef.MirrorIons.Scale,
		Pos = MirrorVector( posRef.MirrorIons.Pos ),
		Ang = MirrorAngle( posRef.MirrorIons.Ang, "opp" ),
		Color1 = "BLUE",
		Phase = "B"
	},
	[51] = {
		ID = "Whelen Ion",
		Scale = posRef.GrilleVertexOut.Scale,
		Pos = posRef.GrilleVertexOut.Pos,
		Ang = posRef.GrilleVertexOut.Ang,
		Color1 = "RED",
		Phase = "A"
	},
	[52] = {
		ID = "Whelen Ion",
		Scale = posRef.GrilleVertexOut.Scale,
		Pos = MirrorVector( posRef.GrilleVertexOut.Pos ),
		Ang = MirrorAngle( posRef.GrilleVertexOut.Ang, "opp" ),
		Color1 = "BLUE",
		Phase = "B"
	},
	[53] = {
		ID = "Whelen Ion",
		Scale = posRef.GrilleVertexIn.Scale,
		Pos = posRef.GrilleVertexIn.Pos,
		Ang = posRef.GrilleVertexIn.Ang,
		Color1 = "RED",
		Phase = "A"
	},
	[54] = {
		ID = "Whelen Ion",
		Scale = posRef.GrilleVertexIn.Scale,
		Pos = MirrorVector( posRef.GrilleVertexIn.Pos ),
		Ang = MirrorAngle( posRef.GrilleVertexIn.Ang, "opp" ),
		Color1 = "BLUE",
		Phase = "B"
	},
	[55] = {
		ID = "Feniex Apollo Interior",
		Scale = posRef.Apollo.Scale,
		Pos = posRef.Apollo.Pos,
		Ang = posRef.Apollo.Ang
	},
	[56] = {
		ID = "Whelen Ion",
		Scale = posRef.CHPIon.Scale,
		Pos = posRef.CHPIon.Pos,
		Ang = posRef.CHPIon.Ang,
		Color1 = "RED",
		Phase = "CHPA"
	},
	[57] = {
		ID = "Whelen Ion",
		Scale = posRef.CHPIon.Scale,
		Pos = MirrorVector( posRef.CHPIon.Pos ),
		Ang = MirrorAngle( posRef.CHPIon.Ang, "opp" ),
		Color1 = "RED",
		Phase = "CHPB"
	},
	[58] = {
		ID = "Whelen Liberty SX A",
		Scale = posRef.LibertySXAlt.Scale,
		Pos = posRef.LibertySXAlt.Pos,
		Ang = posRef.LibertySXAlt.Ang
	},
	[59] = {
		ID = "Feniex Apollo Interior",
		Scale = posRef.ApolloUpper.Scale,
		Pos = posRef.ApolloUpper.Pos,
		Ang = posRef.ApolloUpper.Ang
	},
	[60] = {
		ID = "Federal Signal Viper",
		Scale = posRef.RearLowerViper.Scale,
		Pos = posRef.RearLowerViper.Pos,
		Ang = posRef.RearLowerViper.Ang,
		BodyGroups = posRef.RearLowerViper.BodyGroups,
		Phase = "A",
		Color1 = "RED"
	},
	[61] = {
		ID = "Federal Signal Viper",
		Scale = posRef.RearLowerViper.Scale,
		Pos = MirrorVector( posRef.RearLowerViper.Pos ),
		Ang = MirrorAngle( posRef.RearLowerViper.Ang ),
		BodyGroups = posRef.RearLowerViper.BodyGroups,
		Phase = "B",
		Color1 = "BLUE"
	},
	[62] = {
		ID = "Whelen 700 Trio",
		Scale = posRef.MidSide.Scale,
		Pos = posRef.MidSide.Pos,
		Ang = posRef.MidSide.Ang,
	},
	[63] = {
		ID = "Whelen 700 Trio",
		Scale = posRef.MidSide.Scale,
		Pos = MirrorVector( posRef.MidSide.Pos ),
		Ang = MirrorAngle( posRef.MidSide.Ang, "opp" ),
	},
	[64] = {
		ID = "Whelen 400 Mounted",
		Scale = posRef.Bumper400.Scale,
		Pos = posRef.Bumper400.Pos,
		Ang = posRef.Bumper400.Ang,
	},
	[65] = {
		ID = "Whelen 400 Mounted",
		Scale = posRef.Bumper400.Scale,
		Pos = MirrorVector( posRef.Bumper400.Pos ),
		Ang = MirrorAngle( posRef.Bumper400.Ang, "opp" ),
	},
	[66] = {
		ID = "Whelen Vertex",
		Scale = posRef.RearVertexes.Scale,
		Pos = posRef.RearVertexes.Pos,
		Ang = posRef.RearVertexes.Ang,
	},
	[67] = {
		ID = "Whelen Vertex",
		Scale = posRef.RearVertexes.Scale,
		Pos = MirrorVector( posRef.RearVertexes.Pos ),
		Ang = MirrorAngle( posRef.RearVertexes.Ang, "opp" ),
	},
	[68] = {
		ID = "Whelen Vertex",
		Scale = posRef.PlateVertexes.Scale,
		Pos = posRef.PlateVertexes.Pos,
		Ang = posRef.PlateVertexes.Ang,
		Color1 = "RED",
		Phase = "A"
	},
	[69] = {
		ID = "Whelen Vertex",
		Scale = posRef.PlateVertexes.Scale,
		Pos = MirrorVector( posRef.PlateVertexes.Pos ),
		Ang = MirrorAngle( posRef.PlateVertexes.Ang, "opp" ),
		Color1 = "BLUE",
		Phase = "B"
	},
	[70] = {
		ID = "Whelen Vertex",
		Scale = posRef.BumperVertex.Scale,
		Pos = posRef.BumperVertex.Pos,
		Ang = posRef.BumperVertex.Ang,
	},
	[71] = {
		ID = "Whelen Vertex",
		Scale = posRef.BumperVertex.Scale,
		Pos = MirrorVector( posRef.BumperVertex.Pos ),
		Ang = MirrorAngle( posRef.BumperVertex.Ang, "opp" )
	},
	[72] = {
		ID = "Skirt Lighting Strip",
		Scale = 1,
		Pos = Vector( -43, 30 + skirtOffsetY, 10 + skirtOffsetZ ),
		Ang = Angle( 0, 0, -1)
	},
	[73] = {
		ID = "Skirt Lighting Strip",
		Scale = 1,
		Pos = Vector( 43, 30 + skirtOffsetY, 10 + skirtOffsetZ ),
		Ang = Angle( 0, 180, 1)
	},
	[74] = {
		ID = "Skirt Lighting Strip",
		Scale = 1,
		Pos = Vector( -43, 11.5 + skirtOffsetY, 10.32 + skirtOffsetZ ),
		Ang = Angle( 0, 0, -1)
	},
	[75] = {
		ID = "Skirt Lighting Strip",
		Scale = 1,
		Pos = Vector( 43, 11.5 + skirtOffsetY, 10.32 + skirtOffsetZ ),
		Ang = Angle( 0, 180, 1)
	},
	[76] = {
		ID = "Skirt Lighting Strip",
		Scale = 1,
		Pos = Vector( -43, -7 + skirtOffsetY, 10.65 + skirtOffsetZ ),
		Ang = Angle( 0, 0, -1)
	},
	[77] = {
		ID = "Skirt Lighting Strip",
		Scale = 1,
		Pos = Vector( 43, -7 + skirtOffsetY, 10.65 + skirtOffsetZ ),
		Ang = Angle( 0, 180, 1)
	},
	[78] = {
		ID = "Skirt Lighting Strip",
		Scale = 1,
		Pos = Vector( -43, -25.5 + skirtOffsetY, 10.96 + skirtOffsetZ ),
		Ang = Angle( 0, 0, -1)
	},
	[79] = {
		ID = "Skirt Lighting Strip",
		Scale = 1,
		Pos = Vector( 43, -25.5 + skirtOffsetY, 10.96 + skirtOffsetZ ),
		Ang = Angle( 0, 180, 1)
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
			{ Category = "Whelen Liberty SX Alt. 1", Name = "Red/Blue", Auto = { 58 } },
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
			{ Name = "Red/Blue", Auto = { 51, 52, 53, 54 } },
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
		Name = "Pushbar Layout",
		Options = {
			{ Category = "Whelen 400s", Name = "R/B/W", Auto = { 64, 65, 71, 70 } },
			{ Name = "None" },
			{ Name = "CHP", Props = { 13 }, Auto = { 56, 57 } },
		}
	},
	{
		Name = "Pushbar Wraparound",
		Options = {
			{ Name = "None" },
			{ Name = "On", Props = { 16, 17 } },
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
			{ Name = "White", Auto = { 66, 67 } },
			{ Name = "None" },
		}
	},
	{
		Name = "License Plate Vertexes",
		Options = {
			{ Name = "Red/Blue", Auto = { 68, 69 } },
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
			{ Category = "Lightbar", Name = "Red/Blue", Auto = { 40 } },
			{ Category = "Lightbar", Name = "Blue", Auto = { 41 } },
			{ Category = "Lightbar", Name = "Red", Auto = { 42 } },
			{ Category = "Trio Heads", Name = "Red/Blue", Auto = { 43, 44 } },
			{ Category = "Trio Heads", Name = "Blue/White", Auto = { 45, 46 } },
			{ Category = "Trio Heads", Name = "Red/White", Auto = { 47, 48 } },
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
			{ Category = "Whelen 700", Name = "R/B/W", Auto = { 62, 63 } },
			{ Name = "None" },
		}
	},
	{
		Name = "Skirt Lighting",
		Options = {
			{ Category = "Whelen Tracer", Name = "R/B/W", Auto = { 72, 73, 74, 75, 76, 77, 78, 79 } },
			{ Name = "None" },
		}
	},
	{
		Name = "Rear Upper Deck",
		Options = {
			{ Category = "Feniex Apollo", Name = "Red/Blue", Auto = { 59 } },
			{ Name = "None" },
		}
	},
	{
		Name = "Rear Lower Deck",
		Options = {
			{ Category = "Feniex Apollo", Name = "Red/Blue", Auto = { 55 } },
			{ Category = "Federal Signal Viper", Name = "Red/Blue", Auto = { 60, 61 } },
			{ Name = "None" },
		}
	},
	{
		Name = "Mirror Lights",
		Options = {
			{ Category = "Whelen Ion", Name = "Red/Blue", Auto = { }, Props = { } },
			{ Name = "None" },
		}
	},
	{
		Name = "ALPR Cameras",
		Options = {
			{ Category = "Roof", Name = "Default", Props = { 14, 15, 3, 4 } },
			{ Category = "Roof", Name = "Extended", Props = { 1, 2, 3, 4 } }
		}
	},
	{
		Name = "Roof",
		Options = {
			{ Name = "Extra Antennas", Props = { 9, 10, 11, 12 } },
			{ Name = "None" },
		}
	},
	{
		Name = "Trunk AirEL",
		Options = {
			{ Name = "On", Props = { 5, 6, 7, 8 } },
		}
	},
	{
		Name = "Trunk Equipment",
		Options = {
			{ Name = "None" },
		}
	}

}

EMV.AutoInsert = {
	{
		Component = "Federal Signal Viper Dual",
		Parent = "Rear Upper Deck",
		Category = "Federal Signal Viper Dual",
		Mirror = true,
		-- TransformType = "opp",
		Scale = 1,
		Position =  Vector( -17, -64, 65 ),
		Angle = Angle( 0, -95, 0 ),
		Variants = {
			{ Name = "Red/Blue No Phase",  Colors = { { "RED", "RED" }, { "BLUE", "BLUE" } } },
			{ Name = "Red/Blue", Phases = { "A", "B" }, Colors = { { "RED", "RED" }, { "BLUE", "BLUE" } } }
		}
	},
	{
		Component = "Federal Signal Viper Dual",
		Parent = "Rear Lower Deck",
		Category = "Federal Signal Viper Dual",
		Scale = 1,
		Position =  Vector( -14, -87, 60 ),
		Angle = Angle( 0, -100, 0 ),
		Variants = {
			{ Name = "Red/Blue", Phases = { "A", "B" }, Colors = { { "RED", "RED" }, { "BLUE", "BLUE" } } }
		}
	},
	{
		Component = "Whelen LINZ6",
		Parent = "Pushbar Layout",
		Category = "Whelen LINZ6",
		Mirror = true,
		TransformType = "opp",
		BodyGroups = {
			{ 1, 1 }
		},
		Position = Vector( 14, 127.5, 30 ),
		Angle = Angle( 0, 24, 0 ),
		Variants = {
			{ Name = "CHP", Phases = { "", "" }, Colors = { { "RED", "RED" }, { "RED", "RED" } } },
			{ Name = "Red/Blue", Phases = { "A", "B" }, Colors = { { "RED", "BLUE" }, { "BLUE", "RED" } } },
		}
	},
	{

		Component = "Whelen Ion V",
		Parent = "Pushbar Layout",
		Category = "Whelen LINZ6",
		Mirror = true,
		TransformType = "opp",
		Position = Vector( 22.5, 128, 30 ),
		Angle = Angle( 0, -90, 0 ),
		Variants = {
			{ Name = "CHP", Phases = { "", "" }, Colors = { { "RED", "RED" }, { "RED", "RED" } } },
			{ Name = "Red/Blue", Phases = { "A", "B" }, Colors = { { "RED", "BLUE" }, { "BLUE", "RED" } } },
		}
	},
	{
		Component = "SoundOff Intersector",
		Parent = "Mirror Intersectors",
		Category = "Intersector",
		Mirror = true,
		TransformType = "opp",
		Position = Vector( 44.6, 33, 49.8 ),
		Angle = Angle( 0, -45, 0 ),
		Variants = {
			{ Name = "R/B/W", Phases = { "A", "B" } },
		}
	},
	{
		Component = "Whelen LINZ6",
		Parent = "Side Lighting",
		Category = "Whelen LINZ6",
		Mirror = true,
		TransformType = "opp",
		BodyGroups = {
			{ 1, 2 }
		},
		Position = Vector( 38.1, -24, 54 ),
		Angle = Angle( -4, -90, 0 ),
		Variants = {
			{ Name = "R/B/W", Phase = "split" },
		}
	}
}
EMV.Configuration = true

Photon.EMVLibrary[name] = EMV
if EMVU then EMVU:OverwriteIndex( name, EMV ) end