AddCSLuaFile()

local A = "AMBER"
local W = "WHITE"

local name = "Feniex Avatar"

local COMPONENT = {}

COMPONENT.Model = "models/tdmcars/emergency/equipment/lightbar_low_led.mdl"
COMPONENT.Lightbar = true
-- COMPONENT.NotLegacy = true
COMPONENT.Skin = 0
COMPONENT.Category = "Lightbar"
COMPONENT.Bodygroups = {}
COMPONENT.DefaultColors = {
	[1] = "RED",
	[2] = "BLUE"
}

COMPONENT.Meta = {
	avatar_front = {
		AngleOffset = -90,
		W = 6.75,
		H = 6.75,
		Sprite = "sprites/emv/feniex_avatar",
		Scale = .5,
		WMult = 1,
		EmitArray = {
			Vector( 2.2, 0, 0 ),
			Vector( .72, 0, 0 ),
			Vector( -.72, 0, 0 ),
			Vector( -2.15, 0, 0 )
		}
	},
	avatar_rear = {
		AngleOffset = 90,
		W = 6.75,
		H = 6.75,
		Sprite = "sprites/emv/feniex_avatar",
		Scale = .5,
		WMult = 1,
		EmitArray = {
			Vector( 2.2, 0, 0 ),
			Vector( .72, 0, 0 ),
			Vector( -.72, 0, 0 ),
			Vector( -2.15, 0, 0 )
		}
	},
}

COMPONENT.Positions = {

	[1] = { Vector( -3.58, 8.63, 4.07 ), Angle( 0, 0, 0 ), "avatar_front" },
	[2] = { Vector( 3.58, 8.63, 4.07 ), Angle( 0, 0, 0 ), "avatar_front" },

	[3] = { Vector( -10.76, 8.63, 4.07 ), Angle( 0, 0, 0 ), "avatar_front" },
	[4] = { Vector( 10.76, 8.63, 4.07 ), Angle( 0, 0, 0 ), "avatar_front" },

	[5] = { Vector( -17.92, 8.63, 4.07 ), Angle( 0, 0, 0 ), "avatar_front" },
	[6] = { Vector( 17.92, 8.63, 4.07 ), Angle( 0, 0, 0 ), "avatar_front" },

	[7] = { Vector( -25.25, 8.63, 4.07 ), Angle( 0, 0, 0 ), "avatar_front" },
	[8] = { Vector( 25.25, 8.63, 4.07 ), Angle( 0, 0, 0 ), "avatar_front" },

	[9] = { Vector( -31.48, 5.96, 4.07 ), Angle( 0, 45, 0 ), "avatar_front" },
	[10] = { Vector( 31.48, 5.96, 4.07 ), Angle( 0, -45, 0 ), "avatar_front" },

	[11] = { Vector( -34.01, -0.04, 4.07 ), Angle( 0, 90, 0 ), "avatar_front" },
	[12] = { Vector( 34.01, -0.04, 4.07 ), Angle( 0, -90, 0 ), "avatar_front" },

	[13] = { Vector( -31.48, -5.96, 4.07 ), Angle( 0, -45, 0 ), "avatar_rear" },
	[14] = { Vector( 31.48, -5.96, 4.07 ), Angle( 0, 45, 0 ), "avatar_rear" },

	[15] = { Vector( -25.25, -8.63, 4.07 ), Angle( 0, 0, 0 ), "avatar_rear" },
	[16] = { Vector( 25.25, -8.63, 4.07 ), Angle( 0, 0, 0 ), "avatar_rear" },

	[17] = { Vector( -17.92, -8.63, 4.07 ), Angle( 0, 0, 0 ), "avatar_rear" },
	[18] = { Vector( 17.92, -8.63, 4.07 ), Angle( 0, 0, 0 ), "avatar_rear" },

	[19] = { Vector( -10.76, -8.63, 4.07 ), Angle( 0, 0, 0 ), "avatar_rear" },
	[20] = { Vector( 10.76, -8.63, 4.07 ), Angle( 0, 0, 0 ), "avatar_rear" },

	[21] = { Vector( -3.58, -8.63, 4.07 ), Angle( 0, 0, 0 ), "avatar_rear" },
	[22] = { Vector( 3.58, -8.63, 4.07 ), Angle( 0, 0, 0 ), "avatar_rear" },

}

COMPONENT.Sections = {
	["auto_feniex_avatar"] = {
		[1] = {
			{ 1, W }, { 2, W }, { 3, "_1" }, { 4, "_2" }, { 5, "_2" }, { 6, "_1" }, { 7, "_1" }, { 8, "_2" }, { 9, "_1" }, { 10, "_2" },
			{ 11, W }, { 12, W },
			{ 13, "_1" }, { 14, "_2" }, { 15, "_1" }, { 16, "_2" }, { 17, A }, { 18, A }, { 19, A }, { 20, A }, { 21, A }, { 22, A },
		}
	},
	["auto_feniex_avatar_a"] = {
		[1] = { { 3, "_1" }, { 4, "_2" } }
	},
	["auto_feniex_avatar_corner"] = {
		[1] = { { 9, "_1" }, { 13, "_2" } },
		[2] = { { 10, "_2" }, { 14, "_1" } },
	},
	["auto_feniex_avatar_traffic"] = {
		[1] = { { 17, A }, { 19, A }, { 21, A } },
		[2] = { { 18, A }, { 20, A }, { 22, A } },
		[3] = { { 17, A }, { 21, A } },
		[4] = { { 19, A }, { 22, A } },
		[5] = { { 21, A }, { 20, A } },
		[6] = { { 22, A }, { 18, A } },
		[7] = { { 17, A }, { 19, A }, { 20, A }, { 18, A } },
		[8] = { { 21, A }, { 22, A } },
	},
	["auto_feniex_avatar_c"] = {
		[1] = { { 15, "_1" } },
		[2] = { { 16, "_2" } },
	},
	["auto_feniex_avatar_front"] = {
		[1] = { { 7, "_1" }, { 4, "_2" } },
		[2] = { { 5, "_2" }, { 6, "_1" } },
		[3] = { { 3, "_1" }, { 8, "_2" } },
	},
	["auto_feniex_avatar_illum"] = {
		[1] = { { 1, W }, { 11, W } },
		[2] = { { 2, W }, { 12, W } },
	}
}

COMPONENT.Patterns = {
	["auto_feniex_avatar"] = {
		["all"] = { 1 }
	},
	["auto_feniex_avatar_a"] = {
		["steady"] = { 1 }
	},
	["auto_feniex_avatar_corner"] = {
		["code_1"] = { 1, 1, 1, 2, 2, 2 },
		["code_2"] = { 1, 0, 1, 0, 1, 1, 1, 1, 0, 2, 0, 2, 0, 2, 2, 2, 2, 0 },
	},
	["auto_feniex_avatar_traffic"] = {
		["code_1"] = { 1, 1, 1, 0, 2, 2, 2, 0 },
		["code_2"] = { 3, 3, 4, 4, 5, 5, 6, 6, 5, 5, 4, 4 },
		["code_3"] = { 7, 7, 0, 8, 8, 0 }
	},
	["auto_feniex_avatar_c"] = {
		["code_1"] = { 1, 0, 1, 0, 1, 1, 1, 0, 2, 0, 2, 0, 2, 2, 2, 0 },
		["code_3"] = { 1, 0, 1, 0, 2, 0, 2, 0 }
	},
	["auto_feniex_avatar_front"] = {
		["code_3"] = {
			1, 1, 1, 2, 2, 2, 3, 3, 3, 2, 2, 2,
			1, 1, 1, 2, 2, 2, 3, 3, 3, 2, 2, 2,
			1, 1, 2, 2, 3, 3, 2, 2,
			1, 1, 2, 2, 3, 3, 2, 2,
			1, 1, 2, 2, 3, 3, 2, 2,
			1, 2, 3, 2,
			1, 2, 3, 2,
			1, 2, 3, 2,
			1, 2, 3, 2,
			1, 1, 2, 2, 3, 3, 2, 2,
			1, 1, 2, 2, 3, 3, 2, 2,
			1, 1, 2, 2, 3, 3, 2, 2,
		},
	},
	["auto_feniex_avatar_illum"] = {
		["code_3"] = { 1, 1, 1, 2, 2, 2 }
	}
}

COMPONENT.TrafficDisconnect = {

}

COMPONENT.Modes = {
	Primary = {
			M1 = {
				-- ["auto_feniex_avatar"] = "all",
				["auto_feniex_avatar_corner"] = "code_1",
				["auto_feniex_avatar_a"] = "steady",
				["auto_feniex_avatar_traffic"] = "code_1",
				["auto_feniex_avatar_c"] = "code_1"
			},
			M2 = {
				["auto_feniex_avatar_corner"] = "code_2",
			},
			M3 = {
				["auto_feniex_avatar_corner"] = "code_2",
				["auto_feniex_avatar_front"] = "code_3",
				["auto_feniex_avatar_traffic"] = "code_3",
				["auto_feniex_avatar_c"] = "code_3",
				["auto_feniex_avatar_illum"] = "code_3"
			}
		},
	Auxiliary = {
			C = {

			},
			L = {

			},
			R = {

			},
			D = {

			}
		},
	Illumination = {
		L = {

		},
		R = {

		},
		F = {

		},
		T = {

		}
	}
}

EMVU:AddAutoComponent( COMPONENT, name )