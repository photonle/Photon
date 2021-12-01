AddCSLuaFile()

local B = "BLUE"
local name = "Dome Light Blue"

local COMPONENT = {}
COMPONENT.Base = "Dome Light Amber"
COMPONENT.Skin = 2
COMPONENT.Sections = {
	["auto_light_dome"] = {
		[1] = { { 1, B } },
		[2] = { { 2, B } },
	},
}

EMVU:AddAutoComponent(COMPONENT, name)
