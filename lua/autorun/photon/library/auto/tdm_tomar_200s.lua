AddCSLuaFile()

local A = "AMBER"
local R = "RED"
local DR = "D_RED"
local B = "BLUE"
local W = "WHITE"
local CW = "C_WHITE"
local SW = "S_WHITE"
local G = "GREEN"

local name = "Tomar 200S Rear"

local COMPONENT = {}

COMPONENT.Model = "models/tdmcars/emergency/equipment/tomar_200s.mdl"
COMPONENT.Skin = 0
COMPONENT.Bodygroups = {}
COMPONENT.NotLegacy = true
COMPONENT.Category = "Auxiliary"
COMPONENT.DefaultColors = {
	[1] = "RED",
	[2] = "BLUE",
	[3] = "AMBER"
}

COMPONENT.Meta = {
	tomar_src = {
		AngleOffset = 0,
		W = 8.1,
		H = 7,
		Sprite = "sprites/emv/emv_whelen_src",
		Scale = 1,
		WMult = 1.5,
		NoLegacy = true,
		DirAxis = "Up",
		DirOffset = -90
	}
}

COMPONENT.Positions = {
	[1] = { Vector( 1.48, -3.56, 1.13 ), Angle( 0, 90, 0 ), "tomar_src" },
	[2] = { Vector( 1.48, 3.56, 1.13 ), Angle( 0, 90, 0 ), "tomar_src" },

	[3] = { Vector( 1.48, -10.64, 1.13 ), Angle( 0, 90, 0 ), "tomar_src" },
	[4] = { Vector( 1.48, 10.64, 1.13 ), Angle( 0, 90, 0 ), "tomar_src" },

	[5] = { Vector( 1.48, -17.72, 1.13 ), Angle( 0, 90, 0 ), "tomar_src" },
	[6] = { Vector( 1.48, 17.72, 1.13 ), Angle( 0, 90, 0 ), "tomar_src" },

	[7] = { Vector( 1.48, -24.8, 1.13 ), Angle( 0, 90, 0 ), "tomar_src" },
	[8] = { Vector( 1.48, 24.8, 1.13 ), Angle( 0, 90, 0 ), "tomar_src" },
}

COMPONENT.Sections = {
	["auto_tomar_200s_rear"] = {
		[1] = { { 1, "_1" }, { 2, "_2" }, { 3, "_1" }, { 4, "_2" }, { 5, "_1" }, { 6, "_2" }, { 7, "_1" }, { 8, "_2" } }
	}
}

COMPONENT.Patterns = {
	["auto_tomar_200s_rear"] = {
		["code1"] = { 1 },
	}
}

COMPONENT.TrafficDisconnect = { 

}

COMPONENT.Modes = {
	Primary = {
		M1 = {
			["auto_tomar_200s_rear"] = "code1"
		},
		M2 = {
			["auto_tomar_200s_rear"] = "code1"
		},
		M3 = {
			["auto_tomar_200s_rear"] = "code1"
		}
	},
	Auxiliary = {
		L = {
			["auto_tomar_200s_rear"] = "left"
		},
		R = {
			["auto_tomar_200s_rear"] = "right"
		},
		D = {
			["auto_tomar_200s_rear"] = "diverge"
		}
	}
}

EMVU:AddAutoComponent( COMPONENT, name )