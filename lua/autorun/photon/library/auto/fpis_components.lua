AddCSLuaFile()

local W = "WHITE"
local SW = "S_WHITE"

local name = "FPIS13 Reverse"

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
	tail_light_src = {
		AngleOffset = 90,
		W = 8.6,
		H = 8.6,
		Sprite = "sprites/emv/tdm_fpis_reverse",
		WMult = 1.5,
		Scale = 2
	},
}

COMPONENT.Positions = {

	[1] = { Vector( -27.78, -112.7, 52.59 ), Angle( 0, -29, -16 ), "tail_light_src" }, -- 1
	[2] = { Vector( 27.78, -112.7, 52.59 ), Angle( 0, 29, 180-16 ), "tail_light_src" }, -- 2

}

COMPONENT.Sections = {
	["auto_fpis13_reverse"] = {
		[1] = { { 1, "_1" }, { 2, "_2" } },
		[2] = { { 1, "_1" } },
		[3] = { { 2, "_2" } },
	},
}

COMPONENT.Patterns = {
	["auto_fpis13_reverse"] = {
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
		["alert"] = { 2, 3 }
	}
}

COMPONENT.Modes = {
	Primary = {
		M1 = { ["auto_fpis13_reverse"] = "code2", },
		M2 = { ["auto_fpis13_reverse"] = "code2", },
		M3 = { ["auto_fpis13_reverse"] = "code3", },
		ALERT = { ["auto_fpis13_reverse"] = "alert", }
	},
	Auxiliary = {},
	Illumination = {}
}

EMVU:AddAutoComponent( COMPONENT, name )

---------------------------------------------------------------------

name = "FPIS13 Wig-Wag Headlights"
COMPONENT = {}

COMPONENT.Skin = 0
COMPONENT.Bodygroups = {}
COMPONENT.NotLegacy = true
COMPONENT.UsePhases = true
COMPONENT.Category = "Hidden"

COMPONENT.Meta = {
	headlight = {
		AngleOffset = -90,
		W = 4,
		H = 4,
		Sprite = "sprites/emv/light_circle",
		Scale = 2,
		VisRadius = 0
	},
}

COMPONENT.Positions = {
	[1] = { Vector( -33.3, 107.4, 38.5 ), Angle( 0, 0, 0 ), "headlight" }, -- 15
	[2] = { Vector( 33.3, 107.4, 38.5 ), Angle( 0, 0, 0 ), "headlight" }, -- 16
}

COMPONENT.Sections = {
	["auto_fpis13_headlights"] = {
		[1] = { { 1, SW, { 16, .25, 10 } }, { 2, SW, { 16, .25, 0 } }, }
	},
}

COMPONENT.Patterns = {
	["auto_fpis13_headlights"] = {
		["code3"] = { 1 },
	}
}

COMPONENT.Modes = {
	Primary = {
		M1 = {},
		M2 = {},
		M3 = { ["auto_fpis13_headlights"] = "code3", }
	},
	Auxiliary = {},
	Illumination = {}
}

EMVU:AddAutoComponent( COMPONENT, name )

-----------------------------------------------------------------------------------

name = "FPIS13 Turn Signal Hideaways"
COMPONENT = {}

COMPONENT.Skin = 0
COMPONENT.Bodygroups = {}
COMPONENT.NotLegacy = true
COMPONENT.UsePhases = true
COMPONENT.Category = "Hidden"

COMPONENT.Meta = {
	tail_light_src = {
		AngleOffset = 90,
		W = 8.6,
		H = 8.6,
		Sprite = "sprites/emv/tdm_fpis_reverse",
		WMult = 1.5,
		Scale = 2
	},
	front_signal = {
		AngleOffset = -90,
		W = 6,
		H = 6,
		Sprite = "sprites/emv/tdm_fpis_forward_out",
		Scale = 3
	},
}

COMPONENT.Positions = {
	[1] = { Vector( -37.84, 102.9, 39 ), Angle( 0, 60, 0 ), "front_signal" },
	[2] = { Vector( 37.84, 102.9, 39 ), Angle( 0, -60, 180 ), "front_signal" },
	[3] = { Vector( -25.92, -115.48, 48.51 ), Angle( 0, -22, -16 ), "tail_light_src" },
	[4] = { Vector( 25.92, -115.48, 48.51 ), Angle( 0, 22, 180-16 ), "tail_light_src" },
}

COMPONENT.Sections = {
	["auto_fpis16_signalhideaways"] = {
		[1] = { { 3, W } },
		[2] = { { 4, W } },
		[3] = { { 3, W }, { 1, W } },
		[4] = { { 4, W }, { 2, W } }
	},
}

COMPONENT.Patterns = {
	["auto_fpis16_signalhideaways"] = {
		["code1"] = { 1, 1, 1, 0, 2, 2, 2 },
		["code2"] = { 1, 0, 1, 0, 2, 0, 2, 0 },
		["code3"] = { 3, 0, 3, 0, 4, 0, 4, 0 },
	}
}

COMPONENT.Modes = {
	Primary = {
		M1 = { ["auto_fpis16_signalhideaways"] = "code1", },
		M2 = { ["auto_fpis16_signalhideaways"] = "code2", },
		M3 = { ["auto_fpis16_signalhideaways"] = "code3", }
	},
	Auxiliary = {},
	Illumination = {}
}

EMVU:AddAutoComponent( COMPONENT, name )

----------------------------------------------------------------------------------------

name = "FPIS13 Front Hideaways"
COMPONENT = {}

COMPONENT.Skin = 0
COMPONENT.Bodygroups = {}
COMPONENT.NotLegacy = true
COMPONENT.UsePhases = true
COMPONENT.ColorInput = 1
COMPONENT.Category = "Hidden"
COMPONENT.DefaultColors = {
	[1] = "RED",
	[2] = "BLUE",
}

COMPONENT.Meta = {
	front_marker = {
		AngleOffset = -90,
		W = 4,
		H = 4,
		Sprite = "sprites/emv/tdm_fpis_forward_1",
		Scale = 1,
	},

	front_2 = {
		AngleOffset = -90,
		W = 4,
		H = 4,
		Sprite = "sprites/emv/tdm_fpis_forward_2",
		Scale = 1,
	},

	front_3 = {
		AngleOffset = -90,
		W = 9,
		H = 9,
		Sprite = "sprites/emv/tdm_fpis_forward_3",
		Scale = 1,
	},
}

COMPONENT.Positions = {

	[1] = { Vector( -30.26, 111.97, 36.12 ), Angle( 0, 27, 0 ), "front_marker" },
	[2] = { Vector( 30.26, 111.97, 36.12 ), Angle( 0, -27, 180 ), "front_marker" },

	[3] = { Vector( -28.15, 111.57, 39.32 ), Angle( 0, 35, 0 ), "front_3" },
	[4] = { Vector( 28.15, 111.57, 39.32 ), Angle( 180, -35, 180 ), "front_3" },

	[5] = { Vector( -28.97, 112.2, 37.62 ), Angle( 0, 35, 0 ), "front_2" },
	[6] = { Vector( 28.97, 112.2, 37.62 ), Angle( 180, -35, 180 ), "front_2" },
}

COMPONENT.Sections = {
	["auto_fpis16_signalhideaways"] = {
		[1] = { { 1, "_1" }, { 3, "_1" }, { 5, "_1"} },
		[2] = { { 2, "_2" }, { 4, "_2" }, { 6, "_2"} },
	},
}

COMPONENT.Patterns = {
	["auto_fpis16_signalhideaways"] = {
		["alt"] = { 1, 1, 1, 1, 0, 2, 2, 2, 2 }
	}
}

COMPONENT.Modes = {
	Primary = {
		M1 = { ["auto_fpis16_signalhideaways"] = "alt", },
		M2 = { ["auto_fpis16_signalhideaways"] = "alt", },
		M3 = { ["auto_fpis16_signalhideaways"] = "alt", }
	},
	Auxiliary = {},
	Illumination = {}
}

EMVU:AddAutoComponent( COMPONENT, name )

-----------------------------------------------------------------------------------

name = "FPIS13 PAR-46"
COMPONENT = {}

COMPONENT.Skin = 0
COMPONENT.Bodygroups = {}
COMPONENT.NotLegacy = true
COMPONENT.UsePhases = true
COMPONENT.Category = "Hidden"

COMPONENT.Meta = {
	auto_whelen_spotlight = {
		AngleOffset = -90,
		W = 11,
		H = 11,
		WMult = .9,
		Sprite = "sprites/emv/whelen_spotlight",
		Scale = 2,
		-- NoLegacy = true,
		-- DirAxis = "Up",
		-- DirOffset = 90
	}
}

COMPONENT.Positions = {

	[1] = { Vector( -40, 48.1, 61.8 ), Angle( 7.96, -6, 0 ), "auto_whelen_spotlight" },

}

COMPONENT.Sections = {
	["auto_whelen_spotlight"] = {
		[1] = { { 1, "_1" } }
	},
}

COMPONENT.Patterns = {
	["auto_whelen_spotlight"] = {
		["c1"] = { 1 },
		["off"] = { 0 },
	}
}

COMPONENT.Modes = {
	Primary = {
		M1 = { ["auto_whelen_spotlight"] = "off" },
		M2 = { ["auto_whelen_spotlight"] = "off" },
		M3 = { ["auto_whelen_spotlight"] = "off" }
	},
	Auxiliary = {},
	Illumination = {
		F = {
			{ 1, W }
		},
		T = {
			{ 1, W }
		},
	}
}

EMVU:AddAutoComponent( COMPONENT, name )