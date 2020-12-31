AddCSLuaFile()

local A = "AMBER"
local name = "Dome Light Amber"

local COMPONENT = {}

COMPONENT.Skin = 0
COMPONENT.Sections = {
	["auto_light_dome"] = {
		[1] = { { 1, A } },
		[2] = { { 2, A } },
	},
}

EMVU:AddAutoComponent( COMPONENT, name, "Dome Light Blue" )