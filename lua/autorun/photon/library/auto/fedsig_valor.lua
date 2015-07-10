AddCSLuaFile()

local A = "AMBER"
local R = "RED"
local DR = "D_RED"
local B = "BLUE"
local W = "WHITE"
local CW = "C_WHITE"
local SW = "S_WHITE"
local G = "GREEN"

local name = "Federal Signal Valor"

local COMPONENT = {}

COMPONENT.Model = "models/schmal/fedsig_valor/valor_lightbar.mdl"
COMPONENT.Skin = 0
COMPONENT.Bodygroups = {}

COMPONENT.Meta = {
	valor_forward_inner = {
		AngleOffset = -90,
		W = 7.5,
		H = 6,
		Sprite = "sprites/emv/fs_valor",
		Scale = 1,
		WMult = 1.5,
	},
	valor_forward = {
		AngleOffset = -90,
		W = 5.9,
		H = 6,
		Sprite = "sprites/emv/fs_valor",
		Scale = 1,
		WMult = 1.5,
	},
	valor_forward_ang = {
		AngleOffset = -90,
		W = 6.3,
		H = 6,
		Sprite = "sprites/emv/fs_valor",
		Scale = 1,
		WMult = 1.5,
	},
	valor_side = {
		AngleOffset = -90,
		W = 7.2,
		H = 6,
		Sprite = "sprites/emv/fs_valor",
		Scale = 1,
		WMult = 1.2,
	},
	valor_backward = {
		AngleOffset = 90,
		W = 5.8,
		H = 6,
		Sprite = "sprites/emv/fs_valor",
		Scale = 1,
		WMult = 1.7,
	},
	valor_backward_inner = {
		AngleOffset = 90,
		W = 6.8,
		H = 6,
		Sprite = "sprites/emv/fs_valor",
		Scale = 1,
		WMult = 1.7,
	},
}

COMPONENT.Positions = {

	[1] = { Vector( 2.82, 13.78, 0.23 ), Angle( 0, -38.79, 0 ), "valor_forward_inner" },
	[2] = { Vector( -2.82, 13.78, 0.23 ), Angle( 0, 38.79, 0 ), "valor_forward_inner" },
	
	[3] = { Vector( 7.94, 9.63, 0.23 ), Angle( 0, -38.79, 0 ), "valor_forward" },
	[4] = { Vector( -7.94, 9.63, 0.23 ), Angle( 0, 38.79, 0 ), "valor_forward" },
	
	[5] = { Vector( 12.47, 6, 0.23 ), Angle( 0, -38.79, 0 ), "valor_forward" },
	[6] = { Vector( -12.47, 6, 0.23 ), Angle( 0, 38.79, 0 ), "valor_forward" },
	
	[7] = { Vector( 16.95, 2.37, 0.23 ), Angle( 0, -38.79, 0 ), "valor_forward" },
	[8] = { Vector( -16.95, 2.37, 0.23 ), Angle( 0, 38.79, 0 ), "valor_forward" },
	
	[9] = { Vector( 22.12, 0.64, 0.23 ), Angle( 0, 0, 0 ), "valor_forward" },
	[10] = { Vector( -22.12, 0.64, 0.23 ), Angle( 0, 0, 0 ), "valor_forward" },
	
	[11] = { Vector( 27.39, -1.52, 0.23 ), Angle( 0, -44, 0 ), "valor_forward_ang" },
	[12] = { Vector( -27.39, -1.52, 0.23 ), Angle( 0, 44, 0 ), "valor_forward_ang" },
	
	[13] = { Vector( 30.26, -7.2, 0.23 ), Angle( 0, -79.7, 0 ), "valor_side" },
	[14] = { Vector( -30.26, -7.2, 0.23 ), Angle( 0, 79.7, 0 ), "valor_side" },
	
	[15] = { Vector( 27.14, -13.01, 0.23 ), Angle( 0, 0, 0 ), "valor_backward" },
	[16] = { Vector( -27.14, -13.01, 0.23 ), Angle( 0, 0, 0 ), "valor_backward" },

	[17] = { Vector( 21.32, -13.01, 0.23 ), Angle( 0, 0, 0 ), "valor_backward" },
	[18] = { Vector( -21.32, -13.01, 0.23 ), Angle( 0, 0, 0 ), "valor_backward" },
	
	[19] = { Vector( 15.54, -13.01, 0.23 ), Angle( 0, 0, 0 ), "valor_backward" },
	[20] = { Vector( -15.54, -13.01, 0.23 ), Angle( 0, 0, 0 ), "valor_backward" },
	
	[21] = { Vector( 9.73, -13.01, 0.23 ), Angle( 0, 0, 0 ), "valor_backward" },
	[22] = { Vector( -9.73, -13.01, 0.23 ), Angle( 0, 0, 0 ), "valor_backward" },
	
	[23] = { Vector( 3.41, -13.01, 0.23 ), Angle( 0, 0, 0 ), "valor_backward_inner" },
	[24] = { Vector( -3.41, -13.01, 0.23 ), Angle( 0, 0, 0 ), "valor_backward_inner" },

}

COMPONENT.Sections = {
	["auto_fedsig_valor"] = {
		{
			{ 1, B }, { 2, R }, 
			{ 3, B }, { 4, R }, 
			{ 5, B }, { 6, R }, 
			{ 7, B }, { 8, R },
			{ 9, B }, { 10,R }, 
			{ 11, B }, { 12,R }, 
			{ 13, B }, { 14,R }, 
			{ 15, B }, { 16,R },
			{ 17, B }, { 18,R }, 
			{ 19, B }, { 20,R }, 
			{ 21, B }, { 22,R }, 
			{ 23, B }, { 24,R }, 
		}
	}
}

COMPONENT.Patterns = {
	["auto_fedsig_valor"] = {
		["all"] = { 1 }
	}
}

EMVU:AddAutoComponent( COMPONENT, name )