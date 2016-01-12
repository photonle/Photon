AddCSLuaFile()

local A = "AMBER"
local R = "RED"
local DR = "D_RED"
local B = "BLUE"
local W = "WHITE"
local CW = "C_WHITE"
local SW = "S_WHITE"
local G = "GREEN"
local RB = "BLUE/RED"

local name = "Federal Signal Vision SLR II"

local COMPONENT = {}

COMPONENT.Model = "models/schmal/vision_lightbar_ii.mdl"
COMPONENT.Skin = 0
COMPONENT.Lightbar = true
COMPONENT.NotLegacy = true
COMPONENT.Bodygroups = {}
COMPONENT.Category = "Lightbar"
COMPONENT.RotationEnabled = true

COMPONENT.Meta = {
	visionslr_a = {
		AngleOffset = 91,
		-- Speed = 10,
		W = 1.35,
		H = 2.65,
		Sprite = "sprites/emv/square_src",
		Scale = 1.5,
		WMult = 1.33,
	},
	visionslr_lower = {
		AngleOffset = 91,
		-- Speed = 10,
		W = 1.3,
		H = 6,
		Sprite = "sprites/emv/center_gradient",
		Scale = 1.5,
		WMult = 1.33,
	},
	visionslr_b = {
		AngleOffset = "R",
		W = 8,
		H = 4,
		Speed = 8,
		Sprite = "sprites/emv/visionslr",
		Scale = 1.5,
		WMult = 1.33,
	},
	visionslr_rear = {
		AngleOffset = 90,
		W = 6.2,
		H = 6,
		Sprite = "sprites/emv/visionslr_rear", 
		Scale = 1,
		WMult = 2,
	},
	visionslr_side = {
		AngleOffset = -90,
		W = 7,
		H = 6.4,
		Sprite = "sprites/emv/visionslr_side",
		Scale = 1,
		WMult = 2.25,
	},
	visionslr_illum = {
		AngleOffset = -90,
		W = 8,
		H = 4,
		Sprite = "sprites/emv/visionslr",
		Scale = 2,
		WMult = 1.5,
	},
	visionslr_illumr = {
		AngleOffset = 90,
		W = 8,
		H = 4,
		Sprite = "sprites/emv/visionslr",
		Scale = 2,
		WMult = 1.5,
	},
}

COMPONENT.Bones = {
	["FRONT"] = {
		Bone = 6,
		AxisP = "p", -- pitch of bone affects pitch of rendered light
		AxisY = "r", -- yaw of bone affects roll of rendered light
		AxisR = "y" -- roll of bone affects ya of rendered light
	},
	["L2A"] = {
		Bone = 2,
		AxisP = "p", -- pitch of bone affects pitch of rendered light
		AxisY = "r", -- yaw of bone affects roll of rendered light
		AxisR = "y" -- roll of bone affects ya of rendered light
	},
	["L2B"] = {
		Bone = 14,
		AxisP = "p", -- pitch of bone affects pitch of rendered light
		AxisY = "r", -- yaw of bone affects roll of rendered light
		AxisR = "y" -- roll of bone affects ya of rendered light
	},
	["L3A"] = {
		Bone = 8,
		AxisP = "p", -- pitch of bone affects pitch of rendered light
		AxisY = "r", -- yaw of bone affects roll of rendered light
		AxisR = "y" -- roll of bone affects ya of rendered light
	},
	["L3B"] = {
		Bone = 4,
		AxisP = "p", -- pitch of bone affects pitch of rendered light
		AxisY = "r", -- yaw of bone affects roll of rendered light
		AxisR = "y" -- roll of bone affects ya of rendered light
	},
	["L4A"] = {
		Bone = 12,
		AxisP = "p", -- pitch of bone affects pitch of rendered light
		AxisY = "r", -- yaw of bone affects roll of rendered light
		AxisR = "y" -- roll of bone affects ya of rendered light
	},
	["L4B"] = {
		Bone = 10,
		AxisP = "p", -- pitch of bone affects pitch of rendered light
		AxisY = "r", -- yaw of bone affects roll of rendered light
		AxisR = "y" -- roll of bone affects ya of rendered light
	}
}

COMPONENT.BoneOperations = {
	[2] = { -- L2A
		Primary = {
			M1 = { "S", 0 }, -- static at 0 degrees
			M2 = { "R", 0, 5 }, -- static at 0 degrees
			M3 = { "R", 0 }, -- static at 0 degrees
		}
	},
	[4] = { -- L3B
		Primary = {
			M1 = { "S", 0 }, -- static at 0 degrees
			M2 = { "R", 0, 5 }, -- static at 0 degrees
			M3 = { "R", 0 }, -- static at 0 degrees
		}
	},
	[6] = { -- FRONT
		Primary = {
			M1 = { "S", 0 }, -- static at 0 degrees
			M2 = { "R", 0, 10 },
			M3 = { "R", 0, 20 }
		}
	},
	[8] = { -- L3A
		Primary = {
			M1 = { "S", 0 }, -- static at 0 degrees
			M2 = { "R", 0, 5 }, -- static at 0 degrees
			M3 = { "R", 0 }, -- static at 0 degrees
		}
	},
	[10] = { -- L4B
		Primary = {
			M1 = { "S", 180 }, -- static at 0 degrees
			M2 = { "R", 180, 10 }, -- static at 0 degrees
			M3 = { "R", 180, 15 }, -- static at 0 degrees
		}
	},
	[12] = { -- L4A
		Primary = {
			M1 = { "S", -180, 5 }, -- static at 0 degrees
			M2 = { "S", -180, 5 }, -- static at 0 degrees
			M3 = { "S", -180, 5 } -- static at 0 degrees
		}
	},
	[14] = { -- L2B
		Primary = {
			M1 = { "S", 0, 5 }, -- static at 0 degrees
			M2 = { "R", 0, 5 }, -- static at 0 degrees
			M3 = { "S", 0, 5 } -- static at 0 degrees
		}
	},

}

COMPONENT.Positions = {
	-- RE = Rotating Element
	-- FRONT = Bone information
	-- Vector = Relative position to bone
	-- Angle = Relative angle (offset?) to bone
	[1] = { { "RE", "FRONT", Vector( 2.6, -1.3, 0 ), Angle( 0, 0, 0 ) }, nil, "visionslr_a" },

	[2] = { { "RE", "L2A", Vector( 2.6, -1.3, 0 ), Angle( 0, 0, 0 ) }, nil, "visionslr_a" },
	[3] = { { "RE", "L2B", Vector( 2.6, -1.3, 0 ), Angle( 0, 0, 0 ) }, nil, "visionslr_a" },

	[4] = { { "RE", "L3A", Vector( 2.6, -1.3, 0 ), Angle( 0, 0, 0 ) }, nil, "visionslr_a" },
	[5] = { { "RE", "L3B", Vector( 2.6, -1.3, 0 ), Angle( 0, 0, 0 ) }, nil, "visionslr_a" },

	[6] = { { "RE", "L4A", Vector( 2.6, -1.3, 0 ), Angle( 0, 0, 0 ) }, nil, "visionslr_a" },
	[7] = { { "RE", "L4B", Vector( 2.6, -1.3, 0 ), Angle( 0, 0, 0 ) }, nil, "visionslr_a" },

	[8] = { { "RE", "FRONT", Vector( 1.3, -1.6, 0 ), Angle( 0, 0, 0 ) }, nil, "visionslr_lower" },

	[9] = { { "RE", "L2A", Vector( 1.3, -1.6, 0 ), Angle( 0, 0, 0 ) }, nil, "visionslr_lower" },
	[10] = { { "RE", "L2B", Vector( 1.3, -1.6, 0 ), Angle( 0, 0, 0 ) }, nil, "visionslr_lower" },

	[11] = { { "RE", "L3A", Vector( 1.3, -1.6, 0 ), Angle( 0, 0, 0 ) }, nil, "visionslr_lower" },
	[12] = { { "RE", "L3B", Vector( 1.3, -1.6, 0 ), Angle( 0, 0, 0 ) }, nil, "visionslr_lower" },

	[13] = { { "RE", "L4A", Vector( 1.3, -1.6, 0 ), Angle( 0, 0, 0 ) }, nil, "visionslr_lower" },
	[14] = { { "RE", "L4B", Vector( 1.3, -1.6, 0 ), Angle( 0, 0, 0 ) }, nil, "visionslr_lower" },

	[15] = { Vector( -15.48, -13.16, 0.03 ), Angle( 0, 0, 0 ), "visionslr_rear" },
	[16] = { Vector( 15.48, -13.16, 0.03 ), Angle( 0, 0, 0 ), "visionslr_rear" },

	[17] = { Vector( -9.35, -13.16, 0.03 ), Angle( 0, 0, 0 ), "visionslr_rear" },
	[18] = { Vector( 9.35, -13.16, 0.03 ), Angle( 0, 0, 0 ), "visionslr_rear" },

	[19] = { Vector( -3.18, -13.16, 0.03 ), Angle( 0, 0, 0 ), "visionslr_rear" },
	[20] = { Vector( 3.18, -13.16, 0.03 ), Angle( 0, 0, 0 ), "visionslr_rear" },

	[21] = { Vector( -30.28, -8.11, 0.13 ), Angle( 0, 90, 11.7 ), "visionslr_side" },
	[22] = { Vector( 30.28, -8.11, 0.13 ), Angle( 0, -90, 11.7 ), "visionslr_side" },

}

COMPONENT.Sections = {
	["auto_fedsig_visionslr"] = {
		{
			{ 1, R },
			{ 2, W }, { 3, W },
			{ 4, R }, { 5, R },
			{ 6, RB }, { 7, RB },

			{ 8, A }, { 9, A },
			{ 10, A }, { 11, A },
			{ 12, A }, { 13, A },

			{ 14, W }, { 15, W },
		},
		{
			{ 1, R },
			{ 2, W }, { 3, W },
			{ 4, R }, { 5, R },
			{ 6, RB }, { 7, RB },
		},
		{
			{ 6, RB }, { 7, RB },
		},
		{
			{ 1, R },
			{ 4, R }, { 5, R },
			{ 6, RB }, { 7, RB },
		},
		[5] = { { 19, R }, { 20, B } },
		[6] = { { 18, R }, { 21, B } },
		[7] = { { 18, R, .33 }, { 21, B, .33 }, { 19, R, .33 }, { 20, B, .33 } },
		[8] = { { 1, R }, { 2, W }, { 3, W }, { 4, R }, { 5, R }, { 6, R }, { 7, R }, 
			{ 8, R }, { 9, W }, { 10, W }, { 11, R }, { 12, R }, { 13, R }, { 14, R },  
		}
	},
	["auto_fedsig_visionslr_traffic"] = {
		{ { 8, A }, { 9, A }, { 10, A }, { 11, A } },
		{ { 12, A }, { 13, A } },
		{ { 9, A }, { 11, A }, { 13, A } },
		{ { 8, A }, { 10, A }, { 12, A } },
		{ { 8, A } },
		{ { 8, A }, { 10, A } },
		{ { 8, A }, { 10, A }, { 12, A } },
		{ { 8, A }, { 10, A }, { 12, A }, { 13, A } },
		{ { 8, A }, { 10, A }, { 12, A }, { 13, A }, { 11, A } },
		{ { 8, A }, { 10, A }, { 12, A }, { 13, A }, { 11, A }, { 9, A } },
		{ { 9, A } },
		{ { 11, A }, { 9, A } },
		{ { 13, A }, { 11, A }, { 9, A } },
		{ { 12, A }, { 13, A }, { 11, A }, { 9, A } },
		{ { 10, A }, { 12, A }, { 13, A }, { 11, A }, { 9, A } },
		[16] = { { 12, A }, { 13, A }, },
		[17] = { { 10, A }, { 12, A }, { 13, A }, { 11, A }, },
	},
}

COMPONENT.Patterns = {
	["auto_fedsig_visionslr"] = {
		["all"] = { 1 },
		["debug"] = { 8 },
		["code1"] = { 5, 5, 5, 5, 0, 6, 6, 6, 6, 0 },
		["code2"] = { 4 },
		["code3"] = { 2 },
		["cruise"] = { 7 },
	},
	["auto_fedsig_visionslr_traffic"] = {
		["warn"] = { 1, 1, 1, 1, 0, 2, 2, 2, 2, 0 },
		["code1"] = { 3, 3, 3, 3, 3, 4, 4, 4, 4, 4 },
		["right"] = { 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 10, 10, 0, 0 },
		["left"] = { 11, 11, 12, 12, 13, 13, 14, 14, 15, 15, 10, 10, 10, 10, 0, 0 },
		["diverge"] = { 16, 16, 16, 17, 17, 17, 10, 10, 10, 10, 0, 0 }
	}
}

COMPONENT.TrafficDisconnect = { 
	["auto_fedsig_visionslr"] = {
		4, 5, 6, 7, 18, 19, 20, 21
	}
}

COMPONENT.Modes = {
	Primary = {
			M1 = {
				["auto_fedsig_visionslr"] = "debug",
				-- ["auto_fedsig_visionslr_traffic"] = "code1",
			},
			M2 = {
				["auto_fedsig_visionslr"] = "debug",
			},
			M3 = {
				["auto_fedsig_visionslr"] = "debug",
			}
		},
	Auxiliary = {
			C = {
				["auto_fedsig_visionslr"] = "cruise"
			},
			L = {
				["auto_fedsig_visionslr_traffic"] = "left"
			},
			R = {
				["auto_fedsig_visionslr_traffic"] = "right"
			},
			D = {
				["auto_fedsig_visionslr_traffic"] = "diverge"
			}
		},
	Illumination = {
		L = {
			{ 14, W }
		},
		R = {
			{ 15, W }
		},
		T = {
			{ 16, W }, { 17, W }
		},
		F = {
			{ 16, W }, { 17, W }
		}
	}
}

EMVU:AddAutoComponent( COMPONENT, name )