AddCSLuaFile()

local name = "Motorola 09 Controller"

local W = "S_WHITE"
local COMPONENT = {}

COMPONENT.Model = "models/sentry/props/motorola09.mdl"
COMPONENT.Lightbar = true
COMPONENT.Skin = 0
COMPONENT.Category = "Lightbar" 
COMPONENT.RotationEnabled = true
COMPONENT.Bodygroups = {}
COMPONENT.DefaultColors = {
	[1] = "RED",
}

local sin, cos = math.sin, math.cos
local rad = math.rad

COMPONENT.Meta = {
	skybolt = {
		AngleOffset = 90,
		W = 8.5,
		H = 8.5,
		Sprite = "sprites/emv/circular_src",
		WMult = 1.5,
		Scale = 1.5,
		-- EmitArray = {
		-- 	Vector( -1, 0, 0 ),
		-- 	Vector( 1, 0, 0 ),
		-- }
	},
	skybolt_rotator = {
		AngleOffset = 0,
		W = 9.5,
		H = 9.5,
		Sprite = "sprites/emv/circular_src",
		WMult = 1.0,
		Scale = 1.5,
		--EmitArray = {
		--}
	},
}

COMPONENT.Bones = {
	["LEFT"] = {
		Bone = 1,
		AxisP = "p", -- pitch of bone affects pitch of rendered light
		AxisY = "y", -- yaw of bone affects roll of rendered light
		AxisR = "r" -- roll of bone affects yaw of rendered light
	},
}

COMPONENT.BoneOperations = {
	[1] = {
		Default = { "S", 0, 50 },
		Illumination = {},
		Primary = {
			M1 = { "S", 33, 50 }, -- static at 0 degrees
			M2 = { "S", 66, 50 }, -- static at 0 degrees
			M3 = { "S", 99, 50 }, -- static at 0 degrees
		},
	},
}

COMPONENT.Positions = {
	--front outer 2

	--rotators
	-- RE = Rotating Element
	-- FRONT = Bone information
	-- Vector = Relative position to bone
	-- Angle = Relative angle (offset?) to bone
	-- [1] = { { "RE", "LEFT", Vector( 0, 0.5, 0 ), Angle( 0, 0, -90 ) }, nil, "skybolt_rotator" },
}

COMPONENT.Sections = {
	-- ["auto_skybolt"] = {
	-- 	[1] = {
	-- 		{ 1, "_1" },
	-- 	},
	-- },
}

COMPONENT.Patterns = {
	-- ["auto_skybolt"] = {
	-- 	["code1"] = {
	-- 		{1},
	-- 	},
	-- },
}


COMPONENT.Modes = {
	Primary = {
		-- M1 = { ["auto_skybolt"] = "code1", },
		-- M2 = { ["auto_skybolt"] = "code1", },
		-- M3 = { ["auto_skybolt"] = "code1", },
		-- ALERT = { ["auto_skybolt"] = "code1", },
	},
	Auxiliary = {},
	Illumination = {}
}

EMVU:AddAutoComponent( COMPONENT, name )

