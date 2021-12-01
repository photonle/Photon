AddCSLuaFile()

local A = "AMBER"
local R = "RED"
local B = "BLUE"
local W = "WHITE"
local WA = "AMBER/WHITE"

local name = "Federal Signal Vision SLR R/B"

local COMPONENT = {}

COMPONENT.Model = "models/schmal/vision_lightbar_ii.mdl"
COMPONENT.Skin = 2
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
		Default = { "S", 0, 25 },
		Primary = {
			M1 = { "S", 0, 25 }, -- static at 0 degrees
			M2 = { "A", { 90, 270 }, 50 }, -- static at 0 degrees
			M3 = { "RN", 0, 90 }, -- static at 0 degrees
		},
	},
	[4] = { -- L3B
		Default = { "S", 0, 25 },
		Illumination = {
			T = { "S", 0, 25 },
			F = { "S", 0, 25 },
		},
		Primary = {
			M1 = { "S", 180, 25 }, -- static at 0 degrees
			M2 = { "R", 0, 85 }, -- static at 0 degrees
			M3 = { "R", 0, 74 }, -- static at 0 degrees
		}
	},
	[6] = { -- FRONT
		Default = { "S", 0, 25 },
		Illumination = {
			F = { "S", 0, 25 },
		},
		Primary = {
			M1 = { "S", 0, 25 }, -- static at 0 degrees
			M2 = { "RN", 0, 70 },
			M3 = { "A", { 90, 270 }, 40 },
		}
	},
	[8] = { -- L3A
		Default = { "S", 0, 25 },
		Illumination = {
			T = { "S", 0, 25 },
			F = { "S", 0, 25 },
		},
		Primary = {
			M1 = { "S", 180, 25 }, -- static at 0 degrees
			M2 = { "R", 0, 85 }, -- static at 0 degrees
			M3 = { "R", 0, 76 }, -- static at 0 degrees
		}
	},
	[10] = { -- L4B
		Default = { "S", 0, 25 },
		Primary = {
			M1 = { "S", 0, 25 }, -- static at 0 degrees
			M2 = { "RN", 0, 75 }, -- static at 0 degrees
			M3 = { "RN", 0, 84 }, -- static at 0 degrees
		}
	},
	[12] = { -- L4A
		Default = { "S", 0, 25 },
		Primary = {
			M1 = { "S", 0, 25 }, -- static at 0 degrees
			M2 = { "RN", 0, 75 }, -- static at 0 degrees
			M3 = { "RN", 0, 86 }, -- static at 0 degrees
		}
	},
	[14] = { -- L2B
		Default = { "S", 0, 25 },
		Primary = {
			M1 = { "S", 0, 25 }, -- static at 0 degrees
			M2 = { "A", { 90, 270 }, 50 }, -- static at 0 degrees
			M3 = { "RN", 0, 90 }, -- static at 0 degrees
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

	[15] = { Vector( -13.02, 15.48, 0.04 ), Angle( 0, -90, 0 ), "visionslr_rear" },
	[16] = { Vector( -13.02, -15.48, 0.04 ), Angle( 0, -90, 0 ), "visionslr_rear" },

	[17] = { Vector( -13.02, 9.3, 0.04 ), Angle( 0, -90, 0 ), "visionslr_rear" },
	[18] = { Vector( -13.02, -9.3, 0.04 ), Angle( 0, -90, 0 ), "visionslr_rear" },

	[19] = { Vector( -13.02, 3.12, 0.04 ), Angle( 0, -90, 0 ), "visionslr_rear" },
	[20] = { Vector( -13.02, -3.12, 0.04 ), Angle( 0, -90, 0 ), "visionslr_rear" },

	[21] = { Vector( -8.16, 30.13, 0.13 ), Angle( 0, 0, 12 ), "visionslr_side" },
	[22] = { Vector( -8.16, -30.15, 0.13 ), Angle( 0, 180, 12 ), "visionslr_side" },

}

COMPONENT.Sections = {
	["auto_fedsig_visionslr"] = {
		[1] = { { 1, WA }, { 2, R }, { 3, B }, { 4, WA }, { 5, WA }, { 6, B }, { 7, R },
			{ 8, WA }, { 9, R }, { 10, B }, { 11, WA }, { 12, WA }, { 13, B }, { 14, R },
		},
		[2] = {
			{ 5, WA }, { 12, WA }, { 6, B }, { 13, B }
		},
		[3] = {
			{ 4, WA }, { 11, WA }, { 7, R }, { 14, R }
		}
	},
	["auto_fedsig_visionslr_traffic"] = {
		{ { 15, A }, { 16, A }, { 17, A }, { 18, A } },
		{ { 19, A }, { 20, A } },
		{ { 16, A }, { 18, A }, { 20, A } },
		{ { 15, A }, { 17, A }, { 19, A } },
		{ { 15, A } },
		{ { 15, A }, { 17, A } },
		{ { 15, A }, { 17, A }, { 19, A } },
		{ { 15, A }, { 17, A }, { 19, A }, { 20, A } },
		{ { 15, A }, { 17, A }, { 19, A }, { 20, A }, { 18, A } },
		{ { 15, A }, { 17, A }, { 19, A }, { 20, A }, { 18, A }, { 16, A } },
		{ { 16, A } },
		{ { 18, A }, { 16, A } },
		{ { 20, A }, { 18, A }, { 16, A } },
		{ { 19, A }, { 20, A }, { 18, A }, { 16, A } },
		{ { 17, A }, { 19, A }, { 20, A }, { 18, A }, { 16, A } },
		[16] = { { 19, A }, { 20, A }, },
		[17] = { { 17, A }, { 19, A }, { 20, A }, { 18, A }, },
		[18] = { { 15, A }, { 17, A }, { 19, A }, { 20, A }, { 18, A }, { 16, A }, { 21, W }, { 22, W } },
	},
}

COMPONENT.Patterns = {
	["auto_fedsig_visionslr"] = {
		["all"] = { 1 },
		["debug"] = { 1 },
		["code1"] = { 2, 2, 2, 2, 2, 3, 3, 3, 3, 3 },
		["code2"] = { 4 },
		["code3"] = { 2 },
		["cruise"] = { 7 },
	},
	["auto_fedsig_visionslr_traffic"] = {
		["off"] = { 0 },
		["warn"] = { 1, 1, 1, 1, 0, 2, 2, 2, 2, 0 },
		["debug"] = { 18 },
		["code1"] = { 3, 3, 3, 3, 3, 4, 4, 4, 4, 4 },
		["right"] = { 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 10, 10, 0, 0 },
		["left"] = { 11, 11, 12, 12, 13, 13, 14, 14, 15, 15, 10, 10, 10, 10, 0, 0 },
		["diverge"] = { 16, 16, 16, 17, 17, 17, 10, 10, 10, 10, 0, 0 }
	}
}

COMPONENT.TrafficDisconnect = {

}

COMPONENT.Modes = {
	Primary = {
			M1 = {
				["auto_fedsig_visionslr"] = "code1",
				["auto_fedsig_visionslr_traffic"] = "off"
			},
			M2 = {
				["auto_fedsig_visionslr"] = "all",
				["auto_fedsig_visionslr_traffic"] = "warn",
			},
			M3 = {
				["auto_fedsig_visionslr"] = "all",
				["auto_fedsig_visionslr_traffic"] = "warn",
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
			{ 21, W }
		},
		R = {
			{ 22, W }
		},
		T = {
			{ 4, W }, { 5, W }, { 11, W }, { 12, W }
		},
		F = {
			{ 4, W }, { 5, W }, { 11, W }, { 12, W }, { 1, W }, { 8, W }
		}
	}
}

EMVU:AddAutoComponent( COMPONENT, name )