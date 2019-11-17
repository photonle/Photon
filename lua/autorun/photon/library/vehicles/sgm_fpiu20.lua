AddCSLuaFile()

local A = "AMBER"
local DA = "D_AMBER"
local R = "RED"
local DR = "D_RED"
local B = "BLUE"
local W = "WHITE"
local SW = "S_WHITE"
local CW = "C_WHITE"

local PI = {}

PI.StateMaterials = {
    ["main-r"] = {
        Index = 22,
        States = {
            ["running-r"] = "photon/override/20explorer_brake"
        }
    },

    ["main-l"] = {
        Index = 23,
        States = {
            ["running-l"] = "photon/override/20explorer_brake"
        }
    }
}

PI.Meta = {

	headlight = {
		AngleOffset = -90,
		W = 8.2,
		H = 8,
		Sprite = "sprites/emv/fpiu20_headlight",
		Scale = 2.25,
		WMult = 1
	},

	turn_signal = {
		AngleOffset = -90,
		W = 10.5,
		H = 8,
		Sprite = "sprites/emv/fpiu20_turnsignal",
		Scale = 1,
		WMult = 2
	},

	rear_turn = {
		AngleOffset = 90,
		W = 8.0,
		H = 8.3,
		Sprite = "sprites/emv/fpiu20_rearturn",
		Scale = 1,
		WMult = 1
	},

	reverse = {
		AngleOffset = 90,
		W = 8.0,
		H = 8.3,
		Sprite = "sprites/emv/fpiu20_reverse",
		Scale = 1,
		WMult = 1
	},

	brake_light = {
		AngleOffset = 90,
		W = 24.0,
		H = 19.0,
		Sprite = "sprites/emv/fpiu20_brakelight",
		Scale = 1.5,
		WMult = 1
	},

	tail_light = {
		AngleOffset = 90,
		W = 11.2,
		H = 10.0,
		Sprite = "sprites/emv/fpiu20_taillight",
		Scale = 0,
		WMult = 0,
		SourceOnly = true,
	},

	tail_glow = {
		AngleOffset = 90,
		W = 0,
		H = 0,
		Sprite = "sprites/emv/blank",
		Scale = 1.0,
		WMult = 2.0,
		EmitArray = {
			Vector(-6, 0, 0),
			Vector(0, 0, 0),
			Vector(6, 0, 0)
		}
	},

	running_light = {
		AngleOffset = -90,
		W = 18,
		H = 17,
		Sprite = "sprites/emv/fpiu20_running",
		Scale = 1,
		WMult = 1.5
	},

}

PI.Positions = {
	[1] = { Vector( 29.1, 110.6, 47.7 ), Angle( 0, 0, 0 ), "headlight" },
	[2] = { Vector( -29.1, 110.6, 47.7 ), Angle( 0, 0, 0 ), "headlight" },

	[3] = { Vector( 36.9, 105.7, 48.4 ), Angle( 0, 0, 0 ), "headlight" },
	[4] = { Vector( -36.9, 105.7, 48.4 ), Angle( 0, 0, 0 ), "headlight" },

	[5] = { Vector( -26.8, 114.5, 50.4 ), Angle( 0.73, 21.39, -1.86 ), "turn_signal" },
	[6] = { Vector( 26.8, 114.5, 50.4 ), Angle( 180-0.73, -21.39, 180+1.86 ), "turn_signal" },

	[7] = { Vector( -35.47, -109.75, 54.01 ), Angle( 180, -26.1, 180 ), "rear_turn" },
	[8] = { Vector( 35.47, -109.75, 54.01 ), Angle( 0, 26.1, 0 ), "rear_turn" },

	[9] = { Vector( -35.3, -109.47, 48.81 ), Angle( 180, -26.1, 180-5 ), "reverse" },
	[10] = { Vector( 35.3, -109.47, 48.81 ), Angle( 0, 26.1, 5 ), "reverse" },

	[11] = { Vector( 39.4, -108.57, 54.01 ), Angle( 0, 26.1, 0.5 ), "brake_light" },
	[12] = { Vector( -39.4, -108.57, 54.01 ), Angle( 180, -26.1, 180-0.5 ), "brake_light" },

	[13] = { Vector( -5.04, -101.37, 79.25 ), Angle( 0, 0, 0 ), "tail_light" },
	[14] = { Vector( 5.04, -101.37, 79.25 ), Angle( 0, 0, 0 ), "tail_light" },
	[15] = { Vector( 0, -101.37, 79.25 ), Angle( 0, 0, 0 ), "tail_glow" },

	[16] = { Vector( -43.19, 99.51, 49.01 ), Angle( 3.92, 78.49, 23.86 ), "running_light" },
	[17] = { Vector( 43.19, 99.51, 49.01 ), Angle( 180-3.92, -78.49, 180-23.86 ), "running_light" },

}

PI.States = {}

PI.States.Headlights = {}
PI.States.Brakes = {
	{ 11, DR, 1 }, { 12, DR, 1 }, { 13, R, 1 }, { 14, R, 1 }, { 15, R, 1 },
}
PI.States.Blink_Left = {
	{ 5, A, 1 }, { 7, A, 1 },
}
PI.States.Blink_Right = {
	{ 6, A, 1 }, { 8, A, 1 },
}
PI.States.Reverse = {
	{ 9, W, 1 }, { 10, W, 1 },
}
PI.States.Running = {
	{ 3, W, .5 }, { 4, W, .5 }, 
	{ 16, A, .5 }, { 17, A, .5 },
	{ 11, DR, .5 }, { 12, DR, .5 },
	{ "_main-l", "running-l" }, { "_main-r", "running-r" }
}



Photon.VehicleLibrary["sgm_fpiu20"] = PI