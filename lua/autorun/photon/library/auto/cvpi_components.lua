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

local height = 76.4

local alphaOffset = 10
local betaOffset = -10
local gammaOffset = 5

---------------- BEGIN COMPONENT ------------------

local name = "CVPI Grille LEDs"

local COMPONENT = {}

COMPONENT.NotLegacy = true
COMPONENT.ColorInput = 1
COMPONENT.UsePhases = true
COMPONENT.Category = "Hidden"
COMPONENT.DefaultColors = {
	[1] = "RED",
	[2] = "BLUE",
}

COMPONENT.Meta = {
	grille_leds = {
		AngleOffset = -90,
		W = 5.7,
		H = 5.4,
		Sprite = "sprites/emv/tdm_grille_leds",
		Scale = 1,
		WMult = 1,
	},
}

COMPONENT.Positions = {

	[1] = { Vector( 10.16, 118.2, 35.17 ), Angle( 0, 0, 15.2 ), "grille_leds" },
	[2] = { Vector( -10.16, 118.2, 35.17 ), Angle( 0, 0, 15.2 ), "grille_leds" },

}

COMPONENT.Sections = {
	["grille_leds"] = {
		{ { 1, "_2" }, { 2, "_1" } },
		{ { 1, "_2" } },
		{ { 2, "_1" } }
	},
}

COMPONENT.Patterns = {
	["grille_leds"] = {
		["flash"] = { 1, 0, 1, 0, 0, 0, },
		["code2"] = { 2, 2, 2, 0, 0, 3, 3, 3, 0, 0 },
		["code3"] = { 2, 0, 2, 0, 3, 0, 3, 0 }
	},
}

COMPONENT.Modes = {
	Primary = {
		M1 = {  },
		M2 = { ["grille_leds"] = "code2" },
		M3 = { ["grille_leds"] = "code3" },
		-- ALERT = { ["auto_fpiu16_foglamp"] = "alert", }
	},
	Auxiliary = {},
	Illumination = {}
}

EMVU:AddAutoComponent( COMPONENT, name )

-------------------- END COMPONENT ----------------------

---------------- BEGIN COMPONENT ------------------

local name = "CVPI Pushbar LEDs"

local COMPONENT = {}

COMPONENT.NotLegacy = true
COMPONENT.ColorInput = 1
COMPONENT.UsePhases = true
COMPONENT.Category = "Hidden"
COMPONENT.DefaultColors = {
	[1] = "RED",
	[2] = "BLUE",
}

COMPONENT.Meta = {
	pushbar_leds = {
		AngleOffset = -90,
		W = 6,
		H = 6.3,
		Sprite = "sprites/emv/led_1x4",
		Scale = 1,
		WMult = 1,
	},
}

COMPONENT.Positions = {

	[1] = { Vector( 9.24, 128.7, 31.13 ), Angle( 0, 0, 0 ), "pushbar_leds" },
	[2] = { Vector( -9.24, 128.7, 31.13 ), Angle( 0, 0, 0 ), "pushbar_leds" },

	[3] = { Vector( 2.97, 128.7, 31.13 ), Angle( 0, 0, 0 ), "pushbar_leds" },
	[4] = { Vector( -2.97, 128.7, 31.13 ), Angle( 0, 0, 0 ), "pushbar_leds" },

}

COMPONENT.Sections = {
	["pushbar_leds"] = {
		{ { 1, "_2" }, { 2, "_1" }, { 3, "_2" }, { 4, "_1" } },
		{ { 2, "_1" }, { 4, "_1" } },
		{ { 1, "_2" }, { 3, "_2" } },
		{ { 1, "_2" }, { 2, "_1" } },
		{ { 3, "_2" }, { 4, "_1" } },
	},
}

COMPONENT.Patterns = {
	["pushbar_leds"] = {
		["flash"] = { 1, 0, 1, 0, 0, 0, 0, 0 },
		["code2"] = { 4, 4, 4, 0, 5, 5, 5, 0, 1, 1, 1, 0 },
		["code3"] = {
			2, 0, 2, 0, 2, 0, 3, 0, 3, 0, 3, 0,
			2, 0, 2, 0, 2, 0, 3, 0, 3, 0, 3, 0,
			2, 0, 2, 0, 2, 0, 3, 0, 3, 0, 3, 0,
			4, 0, 4, 0, 4, 0, 5, 0, 5, 0, 5, 0,
			4, 0, 4, 0, 4, 0, 5, 0, 5, 0, 5, 0,
			4, 0, 4, 0, 4, 0, 5, 0, 5, 0, 5, 0,
		},
	},
}

COMPONENT.Modes = {
	Primary = {
		M1 = {  },
		M2 = { ["pushbar_leds"] = "code2" },
		M3 = { ["pushbar_leds"] = "code3" },
		-- ALERT = { ["auto_fpiu16_foglamp"] = "alert", }
	},
	Auxiliary = {},
	Illumination = {}
}

EMVU:AddAutoComponent( COMPONENT, name )

-------------------- END COMPONENT ----------------------

---------------- BEGIN COMPONENT ------------------

local name = "CVPI Front Viper"

local COMPONENT = {}

COMPONENT.NotLegacy = true
COMPONENT.ColorInput = 1
COMPONENT.UsePhases = true
COMPONENT.Category = "Hidden"
COMPONENT.DefaultColors = {
	[1] = "RED",
	[2] = "BLUE",
}

COMPONENT.Meta = {
	front_viper = {
		AngleOffset = -90,
		W = 4,
		H = 4,
		Sprite = "sprites/emv/tdm_viper",
		Scale = 1,
		WMult = 1,
	},
}

COMPONENT.Positions = {

	[1] = { Vector( 2.05, 16.68, 65.43 ), Angle( 0, 0, 0 ), "front_viper" },
	[2] = { Vector( -2.05, 16.68, 65.43 ), Angle( 0, 0, 0 ), "front_viper" },

}

COMPONENT.Sections = {
	["front_viper"] = {
		{ { 1, "_1" }, { 2, "_2" } },
		{ { 1, "_1" } },
		{ { 2, "_2" } }
	},
}

COMPONENT.Patterns = {
	["front_viper"] = {
		["flash"] = { 1, 1, 0, 0 },
		["code2"] = { 
			2, 0, 2, 0, 2, 0,
			3, 0, 3, 0, 3, 0
		},
		["code3"] = {
			2, 0, 2, 0,
			3, 0, 3, 0
		}
	},
}

COMPONENT.Modes = {
	Primary = {
		M1 = { },
		M2 = { ["front_viper"] = "code2" },
		M3 = { ["front_viper"] = "code3" },
		-- ALERT = { ["auto_fpiu16_foglamp"] = "alert", }
	},
	Auxiliary = {},
	Illumination = {}
}

EMVU:AddAutoComponent( COMPONENT, name )

-------------------- END COMPONENT ----------------------

---------------- BEGIN COMPONENT ------------------

local name = "CVPI Front Interior LEDs"

local COMPONENT = {}

COMPONENT.NotLegacy = true
COMPONENT.ColorInput = 1
COMPONENT.UsePhases = true
COMPONENT.Category = "Hidden"
COMPONENT.DefaultColors = {
	[1] = "RED",
	[2] = "BLUE",
}

COMPONENT.Meta = {
	font_interior_leds = {
		AngleOffset = -90,
		W = 3.5,
		H = 2.5,
		Sprite = "sprites/emv/led_1x4",
		Scale = 1,
		WMult = 1,
	},
}

COMPONENT.Positions = {

	[1] = { Vector( 11.32, 13.68, 65.57 ), Angle( 0, 0, 0 ), "font_interior_leds" },
	[2] = { Vector( -11.32, 13.68, 65.57 ), Angle( 0, 0, 0 ), "font_interior_leds" },

	[3] = { Vector( 15.01, 13.68, 65.57 ), Angle( 0, 0, 0 ), "font_interior_leds" },
	[4] = { Vector( -15.01, 13.68, 65.57 ), Angle( 0, 0, 0 ), "font_interior_leds" },

	[5] = { Vector( 18.69, 13.68, 65.57 ), Angle( 0, 0, 0 ), "font_interior_leds" },
	[6] = { Vector( -18.69, 13.68, 65.57 ), Angle( 0, 0, 0 ), "font_interior_leds" },

	[7] = { Vector( 22.4, 13.68, 65.57 ), Angle( 0, 0, 0 ), "font_interior_leds" },
	[8] = { Vector( -22.4, 13.68, 65.57 ), Angle( 0, 0, 0 ), "font_interior_leds" },

	[9] = { Vector( 26.07, 13.68, 65.57 ), Angle( 0, 0, 0 ), "font_interior_leds" },
	[10] = { Vector( -26.07, 13.68, 65.57 ), Angle( 0, 0, 0 ), "font_interior_leds" },

}

COMPONENT.Sections = {
	["front_interior"] = {
		{ { 1, "_2" }, { 2, "_1" }, { 3, "_2" }, { 4, "_1" }, { 5, "_2" }, { 6, "_1" }, { 7, "_2" }, { 8, "_1" }, { 9, "_2" }, { 10, "_1" } },

		{ { 1, "_2" }, { 3, "_2" }, { 5, "_2" }, { 7, "_2" }, { 9, "_2" } },
		{ { 2, "_1" }, { 4, "_1" }, { 6, "_1" }, { 8, "_1" }, { 10, "_1" } },

		{ { 1, "_2" }, { 2, "_1" }, { 9, "_2" }, { 10, "_1" } },
		{ { 3, "_2" }, { 4, "_1" }, { 5, "_2" }, { 6, "_1" }, { 7, "_2" }, { 8, "_1" } },

		{ { 1, "_2" }, { 5, "_2" }, { 9, "_2" }, { 4, "_1" }, { 8, "_1" } },
		{ { 2, "_1" }, { 6, "_1" }, { 10, "_1" }, { 3, "_2" }, { 7, "_2" } }
	},
}

COMPONENT.Patterns = {
	["front_interior"] = {
		["flash"] = { 1, 1, 1, 0, 0, 0 },
		["code2"] = {
			2, 2, 2, 0, 3, 3, 3, 0
		},
		["code3"] = {
			2, 0, 2, 0, 2, 0,
			3, 0, 3, 0, 3, 0,
			2, 0, 2, 0, 2, 0,
			3, 0, 3, 0, 3, 0,
			2, 0, 2, 0, 2, 0,
			3, 0, 3, 0, 3, 0,

			4, 0, 4, 0, 4, 0,
			5, 0, 5, 0, 5, 0,
			4, 0, 4, 0, 4, 0,
			5, 0, 5, 0, 5, 0,
			4, 0, 4, 0, 4, 0,
			5, 0, 5, 0, 5, 0,

			6, 0, 6, 0, 6, 0,
			7, 0, 7, 0, 7, 0,
			6, 0, 6, 0, 6, 0,
			7, 0, 7, 0, 7, 0,
			6, 0, 6, 0, 6, 0,
			7, 0, 7, 0, 7, 0,

			1, 0, 1, 0, 1, 0,
			0, 0, 0, 0, 0, 0,
			1, 0, 1, 0, 1, 0,
			0, 0, 0, 0, 0, 0,
			1, 0, 1, 0, 1, 0,
			0, 0, 0, 0, 0, 0,
		}
	},
}

COMPONENT.Modes = {
	Primary = {
		M1 = { },
		M2 = { ["front_interior"] = "code2" },
		M3 = { ["front_interior"] = "code3" },
		-- ALERT = { ["auto_fpiu16_foglamp"] = "alert", }
	},
	Auxiliary = {},
	Illumination = {}
}

EMVU:AddAutoComponent( COMPONENT, name )

-------------------- END COMPONENT ----------------------

---------------- BEGIN COMPONENT ------------------

local name = "CVPI Mirror LEDs"

local COMPONENT = {}

COMPONENT.NotLegacy = true
COMPONENT.ColorInput = 1
COMPONENT.UsePhases = true
COMPONENT.Category = "Hidden"
COMPONENT.DefaultColors = {
	[1] = "RED",
	[2] = "BLUE",
}

COMPONENT.Meta = {
	mirror_leds = {
		AngleOffset = -90,
		W = 6.4,
		H = 5,
		Sprite = "sprites/emv/emv_whelen_src",
		Scale = 1,
		WMult = 1,
	},
}

COMPONENT.Positions = {

	[1] = { Vector( 47.97, 30.5, 51.77 ), Angle( 1.18 - 180, -28.66, 180 - 6.3 ), "mirror_leds" },
	[2] = { Vector( -47.97, 30.5, 51.77 ), Angle( 1.18, 28.66, 6.3 ), "mirror_leds" },

}

COMPONENT.Sections = {
	["mirror_leds"] = {
		{ { 1, "_2" }, { 2, "_1" } },
		{ { 1, "_2" } },
		{ { 2, "_1" } },
	},
}

COMPONENT.Patterns = {
	["mirror_leds"] = {
		["code1"] = { 1 },
		["code2"] = { 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0 },
		["code3"] = { 2, 0, 2, 0, 2, 0, 0, 0, 3, 0, 3, 0, 3, 0, 0, 0 }
	},
}

COMPONENT.Modes = {
	Primary = {
		M1 = { ["mirror_leds"] = "code1" },
		M2 = { ["mirror_leds"] = "code2" },
		M3 = { ["mirror_leds"] = "code3" },
		-- ALERT = { ["auto_fpiu16_foglamp"] = "alert", }
	},
	Auxiliary = {},
	Illumination = {}
}

EMVU:AddAutoComponent( COMPONENT, name )

-------------------- END COMPONENT ----------------------

---------------- BEGIN COMPONENT ------------------

local name = "CVPI Rear Tomar 200"

local COMPONENT = {}

COMPONENT.NotLegacy = true
COMPONENT.ColorInput = 1
COMPONENT.UsePhases = true
COMPONENT.Category = "Hidden"
COMPONENT.DefaultColors = {
	[1] = "RED",
	[2] = "BLUE",
}

COMPONENT.Meta = {
	rear_200 = {
		AngleOffset = 90,
		W = 6.4,
		H = 5.2,
		Sprite = "sprites/emv/emv_whelen_src",
		Scale = 1,
		WMult = 1.5,
	},
}

COMPONENT.Positions = {

	[1] = { Vector( 19.87, -75.72, 56.07 ), Angle( 0, 0, 0 ), "rear_200" },
	[2] = { Vector( -19.87, -75.72, 56.07 ), Angle( 0, 0, 0 ), "rear_200" },

	[3] = { Vector( 14.19, -75.72, 56.07 ), Angle( 0, 0, 0 ), "rear_200" },
	[4] = { Vector( -14.19, -75.72, 56.07 ), Angle( 0, 0, 0 ), "rear_200" },

	[5] = { Vector( 8.54, -75.72, 56.07 ), Angle( 0, 0, 0 ), "rear_200" },
	[6] = { Vector( -8.54, -75.72, 56.07 ), Angle( 0, 0, 0 ), "rear_200" },

	[7] = { Vector( 2.84, -75.72, 56.07 ), Angle( 0, 0, 0 ), "rear_200" },
	[8] = { Vector( -2.84, -75.72, 56.07 ), Angle( 0, 0, 0 ), "rear_200" },

}

COMPONENT.Sections = {
	["rear_200"] = {
		{ { 1,"_1"}, { 2, "_2" }, { 3,"_1"}, { 4, "_2" }, { 5,"_1"}, { 6, "_2" }, {7,"_1"}, { 8, "_2"} },

		{ { 1,"_1"}, { 3,"_1"}, { 5,"_1"}, { 7,"_1"} },
		{ { 2, "_2" }, { 4, "_2" }, { 6, "_2" }, { 8, "_2" } },

		{ { 1,"_1"}, { 3,"_1"}, { 2, "_2" }, { 4, "_2" } },
		{ { 5,"_1"}, { 7,"_1"}, { 6, "_2" }, { 8, "_2" } },

		{ { 1,"_1"}, { 7,"_1"}, { 4, "_2" }, { 6, "_2" } },
		{ { 2, "_2" }, { 8, "_2" }, { 5,"_1"}, { 3,"_1"} },

		{ { 1,"_1"}, { 3,"_1"} },
		{ { 2, "_2" }, { 4, "_2" } }
	},
}

COMPONENT.Patterns = {
	["rear_200"] = {
		["flash"] = { 1, 1, 1, 1, 0, 0, 0, 0 },
		["code1"] = { 8, 8, 8, 0, 9, 9, 9, 0 },
		["code2"] = { 2, 2, 2, 0, 3, 3, 3, 0 },
		["code3"] = {
			2, 0, 2, 0, 2, 0,
			3, 0, 3, 0, 3, 0,
			2, 0, 2, 0, 2, 0,
			3, 0, 3, 0, 3, 0,
			2, 0, 2, 0, 2, 0,
			3, 0, 3, 0, 3, 0,

			4, 0, 4, 0, 4, 0,
			5, 0, 5, 0, 5, 0,
			4, 0, 4, 0, 4, 0,
			5, 0, 5, 0, 5, 0,
			4, 0, 4, 0, 4, 0,
			5, 0, 5, 0, 5, 0,

			6, 0, 6, 0, 6, 0,
			7, 0, 7, 0, 7, 0,
			6, 0, 6, 0, 6, 0,
			7, 0, 7, 0, 7, 0,
			6, 0, 6, 0, 6, 0,
			7, 0, 7, 0, 7, 0,
		}
	},
}

COMPONENT.Modes = {
	Primary = {
		M1 = { ["rear_200"] = "code1" },
		M2 = { ["rear_200"] = "code2" },
		M3 = { ["rear_200"] = "code3" },
		-- ALERT = { ["auto_fpiu16_foglamp"] = "alert", }
	},
	Auxiliary = {},
	Illumination = {}
}

EMVU:AddAutoComponent( COMPONENT, name )

-------------------- END COMPONENT ----------------------

---------------- BEGIN COMPONENT ------------------

local name = "CVPI Rear Vipers"

local COMPONENT = {}

COMPONENT.NotLegacy = true
COMPONENT.ColorInput = 1
COMPONENT.UsePhases = true
COMPONENT.Category = "Hidden"
COMPONENT.DefaultColors = {
	[1] = "RED",
	[2] = "BLUE",
}

COMPONENT.Meta = {
	rear_vipers = {
		AngleOffset = 90,
		W = 4,
		H = 4,
		Sprite = "sprites/emv/tdm_viper",
		Scale = 1,
		WMult = 1,
	},
}

COMPONENT.Positions = {

	[1] = { Vector( 26.53, -67.68, 61.47 ), Angle( 0, 15, 0 ), "rear_vipers" },
	[2] = { Vector( -26.53, -67.68, 61.47 ), Angle( 0, -15, 0 ), "rear_vipers" },

	[3] = { Vector( 22.63, -68.78, 61.47 ), Angle( 0, 15, 0 ), "rear_vipers" },
	[4] = { Vector( -22.63, -68.78, 61.47 ), Angle( 0, -15, 0 ), "rear_vipers" },

}

COMPONENT.Sections = {
	["rear_vipers"] = {
		{ { 1, "_1" }, { 2,"_2"}, { 3, "_1" }, { 4,"_2"} },

		{ { 1,"_2"}, { 3,"_2"} },
		{ { 2, "_1" }, { 4, "_1" } },

		{ { 1,"_2"}, { 2, "_1" } },
		{ { 3,"_2"}, { 4, "_1" } },
	},
}

COMPONENT.Patterns = {
	["rear_vipers"] = {
		["flash"] = { 1, 1, 0, 0 },
		["code1"] = { 2, 2, 2, 0, 3, 3, 3, 0 },
		["code2"] = { 2, 2, 0, 3, 3, 0 },
		["code3"] = { 
			2, 0, 2, 0, 2, 0,
			3, 0, 3, 0, 3, 0,
			2, 0, 2, 0, 2, 0,
			3, 0, 3, 0, 3, 0,
			2, 0, 2, 0, 2, 0,
			3, 0, 3, 0, 3, 0,

			4, 0, 4, 0, 4, 0,
			5, 0, 5, 0, 5, 0,
			4, 0, 4, 0, 4, 0,
			5, 0, 5, 0, 5, 0,
			4, 0, 4, 0, 4, 0,
			5, 0, 5, 0, 5, 0
		}
	},
}

COMPONENT.Modes = {
	Primary = {
		M1 = { ["rear_vipers"] = "code1" },
		M2 = { ["rear_vipers"] = "code2" },
		M3 = { ["rear_vipers"] = "code3" },
		-- ALERT = { ["auto_fpiu16_foglamp"] = "alert", }
	},
	Auxiliary = {},
	Illumination = {}
}

EMVU:AddAutoComponent( COMPONENT, name )

-------------------- END COMPONENT ----------------------

---------------- BEGIN COMPONENT ------------------

local name = "CVPI Rear Flourescent"

local COMPONENT = {}

COMPONENT.NotLegacy = true
COMPONENT.ColorInput = 1
COMPONENT.UsePhases = true
COMPONENT.Category = "Hidden"
COMPONENT.DefaultColors = {
	[1] = "RED",
	[2] = "BLUE",
}

COMPONENT.Meta = {
	rear_fluor = {
		AngleOffset = 90,
		W = 9.5,
		H = 9.6,
		Sprite = "sprites/emv/tdm_fluorescent",
		Scale = 2,
		WMult = 1.4,
	},
}

COMPONENT.Positions = {

	[33] = { Vector( 11.13, -80.48, 53.97 ), Angle( 0, 0, -14 ), "rear_fluor" },
	[34] = { Vector( -11.13, -80.48, 53.97 ), Angle( 0, 0, -14 ), "rear_fluor" },

}

COMPONENT.Sections = {
	["rear_fluor"] = {
		{ { 33, "_1" }, { 34, "_2" } },
		{ { 33, "_2", { 24, 0, 24 } }, { 34, "_1", { 24, 0, 0 } } }
	},
}

COMPONENT.Patterns = {
	["rear_fluor"] = {
		["flash"] = { 1, 1, 0, 0 },
		["alt"] = { 2 }
	},
}

COMPONENT.Modes = {
	Primary = {
		M1 = { ["rear_vipers"] = "alt" },
		M2 = { ["rear_vipers"] = "alt" },
		M3 = { ["rear_vipers"] = "alt" },
		-- ALERT = { ["auto_fpiu16_foglamp"] = "alert", }
	},
	Auxiliary = {},
	Illumination = {}
}

EMVU:AddAutoComponent( COMPONENT, name )

-------------------- END COMPONENT ----------------------
