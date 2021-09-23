AddCSLuaFile()

local name = "Whelen Dominator 4"

local W = "S_WHITE"
local COMPONENT = {}

COMPONENT.Model = "models/sentry/props/dominator4.mdl"
COMPONENT.Lightbar = true
COMPONENT.Skin = 0
COMPONENT.Category = "Lightbar" 
COMPONENT.Bodygroups = {}
COMPONENT.DefaultColors = {
    [1] = "RED",
	[2] = "BLUE",
}

COMPONENT.Meta = {
	dominator = {
		AngleOffset = 90,
		W = 3.2,
		H = 3.2,
		Sprite = "sentry/props/dominator/tir3_sprite",
		WMult = .5,
		Scale = .36,
		EmitArray = {
			Vector( -1, 0, 0 ),
			Vector( 0, 0, 0 ),
			Vector( 1, 0, 0 ),
		}
	},
}

COMPONENT.Positions = {

	[1] = { Vector( -0.2, -6.33, 0.01 ), Angle( 0, 0, 0 ), "dominator" },
	[2] = { Vector( -0.2, -2.14, 0.01 ), Angle( 0, 0, 0 ), "dominator" },
	[3] = { Vector( -0.2, 2.14, 0.01 ), Angle( 0, 0, 0 ), "dominator" },
	[4] = { Vector( -0.2, 6.33, 0.01 ), Angle( 0, 0, 0 ), "dominator" },
	--Vector( -14.75, 0.2, 0.01 ), Angle( 0, 0, 0 )
}

COMPONENT.Sections = {
	["auto_dom"] = {
        [1] = {
			{ 1, "_1" },{ 4, "_2" },
		},
		[2] = {
			{ 2, "_1" },{ 3, "_2" },
		},
		[3] = {
			{ 1, "_1" },{ 2, "_1" },
		},
		[4] = {
			{ 3, "_2" },{ 4, "_2" },
		},
		[5] = {
			{ 1, "_1" },{ 3, "_2" },
		},
		[6] = {
			{ 2, "_1" },{ 4, "_2" },
		},
		[7] = {
			{ 1, "_1" },{ 2, "_1" },{ 3, "_2" },{ 4, "_2" },
		},
    },
}

COMPONENT.Patterns = {
	["auto_dom"] = {
		["code1"] = { 1, 0, 1, 0, 1, 1, 2, 0, 2, 0, 2, 2, },
		["code2"] = { 3, 0, 3, 0, 3, 3, 4, 0, 4, 0, 4, 4, },
		["code3"] = { 5, 0, 5, 0, 5, 5, 6, 0, 6, 0, 6, 6, 5, 0, 5, 0, 5, 5, 6, 0, 6, 0, 6, 6, 5, 0, 5, 0, 5, 5, 6, 0, 6, 0, 6, 6, 5, 0, 5, 0, 5, 5, 6, 0, 6, 0, 6, 6, 5, 0, 5, 0, 5, 5, 6, 0, 6, 0, 6, 6, 5, 0, 5, 0, 5, 5, 6, 0, 6, 0, 6, 6, 5, 0, 5, 0, 5, 5, 6, 0, 6, 0, 6, 6, 7, 0, 7, 0, 7, 7, 0, 0, 0, 7, 0, 7, 0, 7, 7, 0, 0, 0, 7, 0, 7, 0, 7, 7, 0, 0, 0,},
		["alert"] = { 5, 0, 5, 0, 5, 5, 6, 0, 6, 0, 6, 6, 5, 0, 5, 0, 5, 5, 6, 0, 6, 0, 6, 6, 5, 0, 5, 0, 5, 5, 6, 0, 6, 0, 6, 6, 5, 0, 5, 0, 5, 5, 6, 0, 6, 0, 6, 6, 5, 0, 5, 0, 5, 5, 6, 0, 6, 0, 6, 6, 5, 0, 5, 0, 5, 5, 6, 0, 6, 0, 6, 6, 5, 0, 5, 0, 5, 5, 6, 0, 6, 0, 6, 6, 7, 0, 7, 0, 7, 7, 0, 0, 0, 7, 0, 7, 0, 7, 7, 0, 0, 0, 7, 0, 7, 0, 7, 7, 0, 0, 0,}, 
    },
}


COMPONENT.Modes = {
	Primary = {
		M1 = { ["auto_dom"] = "code1", },
		M2 = { ["auto_dom"] = "code2", },
		M3 = { ["auto_dom"] = "code3", },
		ALERT = { ["auto_dom"] = "alert", },
	},
	Auxiliary = {},
	Illumination = {}
}

EMVU:AddAutoComponent( COMPONENT, name )

