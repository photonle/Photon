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

local name = "FPIU16 Foglights"

local COMPONENT = {}

COMPONENT.Skin = 0
COMPONENT.Bodygroups = {}
COMPONENT.NotLegacy = true
COMPONENT.ColorInput = 1
COMPONENT.UsePhases = true
COMPONENT.Category = "Hidden"
COMPONENT.DefaultColors = {
	[1] = "RED",
	[2] = "BLUE",
}

COMPONENT.Meta = {
	fog_lamp = {
		AngleOffset = -90,
		W = 22,
		H = 17,
		Sprite = "sprites/emv/fpiu_foglamp",
		Scale = 2,
		WMult = .6
	},
}

COMPONENT.Positions = {

	[1] = { Vector( -37.96, 98.48, 30.03 ), Angle( 1, 47, 0 ), "fog_lamp" },
	[2] = { Vector( 37.96, 98.48, 30.03 ), Angle( 180-1, -47, 180 ), "fog_lamp" },

}

COMPONENT.Sections = {
	["auto_fpiu16_foglamp"] = {
		[1] = { { 1, "_1" }, { 2, "_2" } },
		[2] = { { 1, "_1" } },
		[3] = { { 2, "_2" } },
	},
}

COMPONENT.Patterns = {
	["auto_fpiu16_foglamp"] = {
		["code1"] = { 1 },
		["code2"] = { 2, 0, 2, 0, 2, 2, 2, 2, 0, 3, 0, 3, 0, 3, 3, 3, 3, 0 },
		["code3"] = { 
			2, 0, 2, 0, 3, 0, 3, 0,
			2, 0, 2, 0, 3, 0, 3, 0,
			2, 0, 2, 0, 3, 0, 3, 0,
			2, 0, 2, 0, 3, 0, 3, 0,
			2, 0, 2, 0, 3, 0, 3, 0,
			2, 0, 2, 0, 3, 0, 3, 0,
			2, 0, 2, 0, 3, 0, 3, 0,
			2, 2, 2, 2, 3, 3, 3, 3,
			2, 2, 2, 2, 3, 3, 3, 3,
			2, 2, 2, 3, 3, 3,
			2, 2, 2, 3, 3, 3,
			2, 2, 2, 3, 3, 3,
			2, 2, 3, 3,
			2, 2, 3, 3,
			2, 2, 3, 3,
			2, 3, 2, 3,
			2, 3, 2, 3,
			2, 3, 2, 3,
			2, 3, 2, 3, 0
		},
	}
}

COMPONENT.Modes = {
	Primary = {
		M1 = { ["auto_fpiu16_foglamp"] = "code1", },
		M2 = { ["auto_fpiu16_foglamp"] = "code2", },
		M3 = { ["auto_fpiu16_foglamp"] = "code3", }
	},
	Auxiliary = {},
	Illumination = {}
}

EMVU:AddAutoComponent( COMPONENT, name )

name = "FPIU16 Front Hideaway"
COMPONENT = {}

COMPONENT.Skin = 0
COMPONENT.Bodygroups = {}
COMPONENT.NotLegacy = true
COMPONENT.ColorInput = 1
COMPONENT.UsePhases = true
COMPONENT.Category = "Hidden"
COMPONENT.DefaultColors = {
	[1] = "RED",
	[2] = "BLUE",
}

COMPONENT.Meta = {
	front_hideaway = {
		AngleOffset = -90,
		W = 17,
		H = 15,
		Sprite = "sprites/emv/fpiu_hideaway",
		Scale = 1.5,
		WMult = 1.25
	},
}

COMPONENT.Positions = {

	[1] = { Vector( -25.89, 107.04, 41.23 ), Angle( 1, 30, 0 ), "front_hideaway" },
	[2] = { Vector( 25.89, 107.04, 41.23 ), Angle( 180-1, -30, 180 ), "front_hideaway" },

}

COMPONENT.Sections = {
	["auto_fpiu16_fronthideaways"] = {
		[1] = { { 1, "_1" }, { 2, "_2" } },
		[2] = { { 1, "_1" } },
		[3] = { { 2, "_2" } },
	},
}

COMPONENT.Patterns = {
	["auto_fpiu16_fronthideaways"] = {
		["code2"] = { 3, 3, 3, 0, 2, 2, 2, 0 },
		["code3"] = { 3, 0, 3, 0, 0, 2, 0, 2, 0, 0 },
	}
}

COMPONENT.Modes = {
	Primary = {
		M1 = {},
		M2 = { ["auto_fpiu16_fronthideaways"] = "code2", },
		M3 = { ["auto_fpiu16_fronthideaways"] = "code3", }
	},
	Auxiliary = {},
	Illumination = {}
}

EMVU:AddAutoComponent( COMPONENT, name )

name = "FPIU16 Turn Signal Hideaways"
COMPONENT = {}

COMPONENT.Skin = 0
COMPONENT.Bodygroups = {}
COMPONENT.NotLegacy = true
COMPONENT.ColorInput = 1
COMPONENT.UsePhases = true
COMPONENT.Category = "Hidden"
COMPONENT.DefaultColors = {
	[1] = "WHITE",
	[2] = "WHITE",
}

COMPONENT.Meta = {
	turn_signal = {
		AngleOffset = -90,
		W = 10,
		H = 12,
		Sprite = "sprites/emv/fpiu_turnsignal",
		Scale = 1,
		WMult = 2
	},
	rear_turn = {
		AngleOffset = 90,
		W = 14,
		H = 14,
		Sprite = "sprites/emv/fpiu_rearturn",
		Scale = 1.25,
		WMult = 1
	},
}

COMPONENT.Positions = {

	[1] = { Vector( -35.02, -103.73, 47.67 ), Angle( -5.19, -30.14, -6.99 ), "rear_turn" },
	[2] = { Vector( 35.02, -103.73, 47.67 ), Angle( 180+5.19, 30.14, 180+6.99 ), "rear_turn" },

	[3] = { Vector( -37.39, 97.14, 41.43 ), Angle( 1, 58.9, 14 ), "turn_signal" },
	[4] = { Vector( 37.39, 97.14, 41.43 ), Angle( 180-1, -58.9, 180-14 ), "turn_signal" },

}

COMPONENT.Sections = {
	["auto_fpiu16_signalhideaways"] = {
		[1] = { { 1, "_1" }, { 2, "_2" },  { 3, "_1" }, { 4, "_2" },  },
	},
}

COMPONENT.Patterns = {
	["auto_fpiu16_signalhideaways"] = {
		["code2"] = { 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0 },
	}
}

COMPONENT.Modes = {
	Primary = {
		M1 = {},
		M2 = { ["auto_fpiu16_signalhideaways"] = "code2", },
		M3 = { ["auto_fpiu16_signalhideaways"] = "code2", }
	},
	Auxiliary = {},
	Illumination = {}
}

EMVU:AddAutoComponent( COMPONENT, name )

name = "FPIU16 Wig-Wag Headlights"
COMPONENT = {}

COMPONENT.Skin = 0
COMPONENT.Bodygroups = {}
COMPONENT.NotLegacy = true
COMPONENT.UsePhases = true
COMPONENT.Category = "Hidden"

COMPONENT.Meta = {
	headlight = {
		AngleOffset = -90,
		W = 10,
		H = 10,
		Sprite = "sprites/emv/fpiu_headlight",
		Scale = 2.5,
		WMult = 1
	},
}

COMPONENT.Positions = {
	[1] = { Vector( -28, 103.33, 44.13 ), Angle( 0, 31, 17 ), "headlight" },
	[2] = { Vector( 28, 103.33, 44.13 ), Angle( 180, (-31), 180-17 ), "headlight" },
}

COMPONENT.Sections = {
	["auto_fpiu16_headlights"] = {
		[1] = { { 1, SW, { 16, .25, 10 } }, { 2, SW, { 16, .25, 0 } }, }
	},
}

COMPONENT.Patterns = {
	["auto_fpiu16_headlights"] = {
		["code3"] = { 1 },
	}
}

COMPONENT.Modes = {
	Primary = {
		M1 = {},
		M2 = {},
		M3 = { ["auto_fpiu16_headlights"] = "code3", }
	},
	Auxiliary = {},
	Illumination = {}
}

EMVU:AddAutoComponent( COMPONENT, name )

name = "FPIU16 Reverse Hideaways"
COMPONENT = {}

COMPONENT.Skin = 0
COMPONENT.Bodygroups = {}
COMPONENT.NotLegacy = true
COMPONENT.UsePhases = true
COMPONENT.Category = "Hidden"
COMPONENT.DefaultColors = {
	[1] = "RED",
	[2] = "BLUE",
}

COMPONENT.Meta = {
	reverse = {
		AngleOffset = 90,
		W = 8,
		H = 8,
		Sprite = "sprites/emv/fpiu_reverse",
		Scale = 1,
		WMult = 1.25
	},
}

COMPONENT.Positions = {
	[1] = { Vector( -32.32, -104.33, 53.92 ), Angle( 0, -30.14, 0 ), "reverse" },
	[2] =  {Vector( 32.32, -104.33, 53.92 ), Angle( 180, 30.14, 180), "reverse" },
}

COMPONENT.Sections = {
	["auto_fpiu16_reverse"] = {
		[1] = { { 1, "_1" }, { 2, "_2" } },
		[2] = { { 1, "_1" } },
		[3] = { { 2, "_2" } },
	},
}

COMPONENT.Patterns = {
	["auto_fpiu16_reverse"] = {
		["code1"] = { 1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0 },
		["code2"] = { 2, 2, 2, 2, 2, 0, 3, 3, 3, 3, 3 },
		["code3"] = { 2, 2, 0, 2, 2, 0, 3, 3, 0, 3, 3, 0 },
	}
}

COMPONENT.Modes = {
	Primary = {
		M1 = { ["auto_fpiu16_reverse"] = "code2" },
		M2 = { ["auto_fpiu16_reverse"] = "code2" },
		M3 = { ["auto_fpiu16_reverse"] = "code3" }
	},
	Auxiliary = {},
	Illumination = {}
}

EMVU:AddAutoComponent( COMPONENT, name )