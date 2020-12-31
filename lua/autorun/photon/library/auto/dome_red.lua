AddCSLuaFile()

local R = "RED"
local name = "Dome Light Red"

local COMPONENT = {}
COMPONENT.Base = "Dome Light Amber"
COMPONENT.Skin = 1
COMPONENT.Sections = {
	["auto_light_dome"] = {
		[1] = { { 1, R } },
		[2] = { { 2, R } },
	},
}

EMVU:AddAutoComponent(COMPONENT, name)
