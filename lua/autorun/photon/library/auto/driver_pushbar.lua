AddCSLuaFile()

local R = "RED"
local B = "BLUE"
local name = "Driver SF Pushbar"

local COMPONENT = {}
COMPONENT.Model = "models/lonewolfie/bullbar.mdl"
COMPONENT.Category = "Exterior"
COMPONENT.Skin = 0
COMPONENT.Lightbar = false
COMPONENT.Bodygroups = {}
COMPONENT.ColorInput = 0

COMPONENT.Meta = {
    main = {
        AngleOffset = -90,
        W = 6,
        H = 10,
        Sprite = "sprites/emv/fs_valor",
        Scale = 1,
        WMult = 1
    }
}

COMPONENT.Positions = {
    {Vector(9, 12.68, 22.46), Angle(0, 0, 0), "main"},
    {Vector(-12, 12.68, 22.46), Angle(0, 0, 0), "main"}
}

COMPONENT.Sections = {
    auto_main = {
		{
			{1, R}, {2, B}
		},
		{
			{1, R}
		},
		{
			{2, B}
		}
	}
}

COMPONENT.Patterns = {
    auto_main = {
        code1 = {2, 2, 2, 2, 3, 3, 3, 3},
        code2 = {2, 2, 0, 0, 2, 2, 0, 3, 3, 0, 0, 3, 3, 0},
        code3 = {2, 2, 0, 3, 3, 0},
        alert = {2, 3}
    }
}

COMPONENT.Modes = {
    Primary = {
        M1 = {
            auto_main = "code1"
        },
        M2 = {
            auto_main = "code2"
        },
        M3 = {
            auto_main = "code3"
        },
        ALERT = {
            auto_main = "alert"
        }
    },
    Auxiliary = {},
    Illumination = {}
}

EMVU:AddAutoComponent(COMPONENT, name)