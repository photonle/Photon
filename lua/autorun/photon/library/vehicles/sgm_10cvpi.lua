AddCSLuaFile()

local A = "AMBER"
local DA = "D_AMBER"
local R = "RED"
local DR = "D_RED"
local B = "BLUE"
local W = "WHITE"
local SW = "S_WHITE"

local PI = {}

PI.Meta = {
	tail_light = {
		AngleOffset = -90,
		W = 12,
		H = 12,
		Sprite = "sprites/emv/blank",
		Scale = 1,
		WMult = 0,
	},
	tail_light_l = {
		AngleOffset = -90,
		W = 12,
		H = 12,
		Sprite = "sprites/emv/blank",
		Scale = 1,
		WMult = 0,
	},
	headlight = {
		AngleOffset = 90,
		W = 10,
		H = 10,
		Sprite = "sprites/emv/sgm_headlight",
		Scale = 1,
		WMult = 1,
	},
	headlight2 = {
		AngleOffset = -90,
		W = 10,
		H = 10,
		Sprite = "sprites/emv/sgm_headlight",
		Scale = 1,
		WMult = 0.9,
	},
    marker_turn_driver = {
        AngleOffset = 90,
        W = 7,
        H = 7,
        Sprite = "sprites/emv/sgm_turn",
        Scale = 1.8,
        WMult = 0.5,
    },
    marker_turn_passenger = {
        AngleOffset = -90,
        W = 7,
        H = 7,
        Sprite = "sprites/emv/sgm_turn",
        Scale = 1.8,
        WMult = 0.5,
	},
    marker_outer = {
        AngleOffset = -90,
        W = 2.3,
        H = 2.3,
        Sprite = "sprites/emv/sgm_marker",
        Scale = 0.6,
        WMult = 1,
	},
	turn = {
		AngleOffset = -90,
		W = 12,
		H = 12,
		Sprite = "sprites/emv/blank",
		Scale = 1,
		WMult = 0,
	},
}

PI.StateMaterials = {
	["right_brake"] = {
		Index = 12,
		States = {
			["running"] = "sentry/cvpi_fh3/taillight_on"
		}
	},
	["left_brake"] = {
		Index = 11,
		States = {
			["running"] = "sentry/cvpi_fh3/taillight_on" 
		}
	},
	["reverse"] = {
		Index = 15,
		States = {
			["running"] = "sentry/cvpi_fh3/taillight_on" 
		}
	},
	["reverse1"] = {
		Index = 16,
		States = {
			["running"] = "sentry/cvpi_fh3/taillight_on"
		}
	},
	["gauges"] = {
		Index = 10,
		States = {
			["running"] = "sentry/cvpi_fh3/gauges_lite" 
		}
	},
	["symbols"] = {
		Index = 17,
		States = {
			["running"] = "sentry/cvpi_fh3/symbols_on" 
		}
	},
	["left_turn"] = {
		Index = 13,
		States = {
			["running"] = "sentry/cvpi_fh3/taillight_on"
		}
	},
	["right_turn"] = {
		Index = 14,
		States = {
			["running"] = "sentry/cvpi_fh3/taillight_on"
		}
	},
}

PI.Positions = {

	-- TOP --
	[1] = { Vector( -33, -123, 39 ), Angle( 0, -200, 0 ), "tail_light_l" },	
	[2] = { Vector( 33, -123, 39 ), Angle( 0, 200, 0 ), "tail_light" },
	[3] = { Vector( -28.249, 106.045, 29.906 ), Angle( 0, 190, -21), "headlight" },
	[4] = { Vector( 28.249, 106.045, 29.906 ), Angle( 0, -10, 21 ), "headlight2" },
	[5] = { Vector( -22.205, 107.95, 29.82 ), Angle( 0, 190, -21 ), "marker_turn_driver" },
	[6] = { Vector( 22.205, 107.95, 29.82 ), Angle( 0, -10, 21 ), "marker_turn_passenger" },
	[7] = { Vector( -34.41, 102.25, 29.62 ), Angle( 0, 58.2, 0 ), "marker_outer" },
	[8] = { Vector( 34.41, 102.25, 29.62 ), Angle( 0, -58.2, 0 ), "marker_outer" },
	[9] = { Vector( -10.5, -127, 36 ), Angle( 0, -200, 0 ), "reverse" },
	[10] = { Vector( 10.5, -127, 36 ), Angle( 0, 200, 0 ), "reverse" },
	[11] = { Vector( -32, -123, 34.3 ), Angle( 0, -200, 0 ), "turn" },
	[12] = { Vector( 32, -123, 34.3 ), Angle( 0, 200, 0 ), "turn" },	
}

PI.States = {}

PI.States.Headlights = {}
PI.States.Brakes = {
	{ 1, DR, 1 }, { 2, DR, 1 },
}
PI.States.Blink_Left = {
	{ 5, A, 0.9}, { 11, DR, 0.7},
	{ "_left_turn", "running" }, -- 
}
PI.States.Blink_Right = {
	{ 6, A, 0.9}, { 12, DR, 0.7},
	{ "_right_turn", "running" },
}
PI.States.Reverse = {
	{ "_reverse", "running" }, 
	{ "_reverse1", "running" }, 
}
PI.States.Running = {
	{ 1, R, 0.4 }, { 2, R, 0.4 },  
	{ 3, SW,},{ 4, SW,}, 
	{ 5, A, 0.2},{ 6, A, 0.2}, 
	{ 7, A},{ 8, A}, 
	{ "_left_brake", "running" }, 
	{ "_right_brake", "running" },
	{ "_gauges", "running"},
	{ "_symbols", "running"},
}

Photon.VehicleLibrary["sgm_10cvpi"] = PI