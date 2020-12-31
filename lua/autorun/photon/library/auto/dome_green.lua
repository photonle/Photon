AddCSLuaFile()

local G = "GREEN"
local name = "Dome Light Green"

local COMPONENT = {}
COMPONENT.Base = "Dome Light Amber"
COMPONENT.Skin = 3
COMPONENT.Sections = {
	["auto_light_dome"] = {
		[1] = { { 1, G } },
		[2] = { { 2, G } },
	},
}

EMVU:AddAutoComponent(COMPONENT, name)
