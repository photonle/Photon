AddCSLuaFile()
local A = "AMBER"
local name = "LW Arrowboard"

local COMPONENT = {}
COMPONENT.Model = "models/lonewolfie/arrow_mount.mdl"
COMPONENT.Skin = 0
COMPONENT.Bodygroups = {}
COMPONENT.NotLegacy = true
COMPONENT.ColorInput = 0
COMPONENT.Category = "Exterior"
COMPONENT.DefaultColors = {}

COMPONENT.Meta = {
	main = {
		AngleOffset = 90,
		W = 6,
		H = 6,
		Sprite = "sprites/emv/circular_src",
		Scale = 1
	}
}

local zAng = Angle(0, -90, 0)
COMPONENT.Positions = {
	{Vector(22, -0.7, 40), zAng, "main"},
    {Vector(22, -9.2, 40), zAng, "main"},
    {Vector(22, -18, 40), zAng, "main"},
    {Vector(22, 15.2, 40), zAng, "main"},
    {Vector(22, 7.5, 40), zAng, "main"},
    {Vector(22, -26.8, 40), zAng, "main"},
    {Vector(22, 23.6, 40), zAng, "main"},
    {Vector(22, 14.5, 51.6), zAng, "main"},
    {Vector(22, 20, 45.6), zAng, "main"},
    {Vector(22, 21.2, 33.8), zAng, "main"},
    {Vector(22, 16.4, 29.2), zAng, "main"},
    {Vector(22, -16.8, 51.4), zAng, "main"},
    {Vector(22, -22.2, 46.1), zAng, "main"},
    {Vector(22, -22.5, 34.2), zAng, "main"},
	{Vector(22, -16.6, 29), zAng, "main"}
}

COMPONENT.Sections = {
	auto_internet_arrowboard = {
		{{1, A}, {2, A}, {3, A}, {4, A}, {5, A}, {6, A}, {7, A}, {8, A}, {9, A}, {10, A}, {11, A}, {12, A}, {13, A}, {14, A}, {15, A}},
		{{6, A}},
		{{6, A}, {3, A}},
		{{6, A}, {3, A}, {2, A}},
		{{6, A}, {3, A}, {2, A}, {1, A}},
		{{6, A}, {3, A}, {2, A}, {1, A}, {5, A}},
		{{6, A}, {3, A}, {2, A}, {1, A}, {5, A}, {4, A}, {8, A}, {11, A}},
		{{6, A}, {3, A}, {2, A}, {1, A}, {5, A}, {4, A}, {8, A}, {11, A}, {9, A}, {10, A}},
		{{6, A}, {3, A}, {2, A}, {1, A}, {5, A}, {4, A}, {8, A}, {11, A}, {9, A}, {10, A}, {7, A}},
		{{7, A}},
		{{7, A}, {4, A}},
		{{7, A}, {4, A}, {5, A}},
		{{7, A}, {4, A}, {5, A}, {1, A}},
		{{7, A}, {4, A}, {5, A}, {1, A}, {2, A}},
		{{7, A}, {4, A}, {5, A}, {1, A}, {2, A}, {3, A}, {12, A}, {15, A}},
		{{7, A}, {4, A}, {5, A}, {1, A}, {2, A}, {3, A}, {12, A}, {15, A}, {13, A}, {14, A}},
		{{7, A}, {4, A}, {5, A}, {1, A}, {2, A}, {3, A}, {12, A}, {15, A}, {13, A}, {14, A}, {6, A}},
		{{1, A}},
		{{1, A}, {2, A}, {5, A}},
		{{1, A}, {2, A}, {5, A}, {4, A}, {3, A}, {8, A}, {11, A}, {12, A}, {15, A}},
		{{1, A}, {2, A}, {5, A}, {4, A}, {3, A}, {8, A}, {11, A}, {12, A}, {15, A}, {9, A}, {10, A}, {13, A}, {14, A}}
	}
}

-- All 1:1
-- Left 2:9
-- Right 10:17
-- Diverge 18:21 + 1
COMPONENT.Patterns = {
	auto_internet_arrowboard = {
		code1 = {0},
		code2 = {0},
		code3 = {0},
		alert = {0},
		left = {2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 9, 9, 0, 0, 9, 9, 0, 0, 9, 9, 0, 0},
		right = {10, 10, 11, 11, 12, 12, 13, 13, 14, 14, 15, 15, 16, 16, 17, 17, 17, 17, 0, 0, 17, 17, 0, 0, 17, 17, 0, 0},
		diverge = {18, 18, 19, 19, 20, 20, 21, 21, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0}
	}
}

COMPONENT.Modes = {
	Primary = {
		M1 = {
			auto_internet_arrowboard = "code1"
		},
		M2 = {
			auto_internet_arrowboard = "code2"
		},
		M3 = {
			auto_internet_arrowboard = "code3"
		}
	},
	Auxiliary = {
		L = {
			auto_internet_arrowboard = "left"
		},
		R = {
			auto_internet_arrowboard = "right"
		},
		D = {
			auto_internet_arrowboard = "diverge"
		}
	},
	Illumination = {}
}

EMVU:AddAutoComponent(COMPONENT, name)