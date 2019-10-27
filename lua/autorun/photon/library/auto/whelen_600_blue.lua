AddCSLuaFile()
 
local A = "AMBER"
local R = "RED"
local DR = "D_RED"
local B = "BLUE"
local W = "WHITE"
local CW = "C_WHITE"
local SW = "S_WHITE"
local G = "GREEN"
 
local name = "Whelen 600 Blue"
 
local COMPONENT = {}
 
COMPONENT.Model = "models/noble/whelen_600/whelen_600.mdl"
COMPONENT.Skin = 2
COMPONENT.Bodygroups = {}
COMPONENT.NotLegacy = true
COMPONENT.ColorInput = 1
COMPONENT.UsePhases = true 
COMPONENT.DefaultColors = {
    [1] = "BLUE"
}
 
COMPONENT.Meta = {

    whelen600_light = {
        AngleOffset = 0,
        W = 9.1,
        H = 9.1,
        Sprite = "sprites/emv/emv_whelen_600",
        Scale = 2,
        NoLegacy = true,
        DirAxis = "Up",
        DirOffset = 90,
        WMult = 1.5
    },

    

}
 
COMPONENT.Positions = {
    [1] = { Vector( 1.3, -.1, 3.15 ), Angle( 0, -90, 0 ), "whelen600_light" },

}
 
COMPONENT.Sections = {
    ["light_main"] = {
        [1] = { 
            { 1, "_1"}
        }
    }
}
 
COMPONENT.Patterns = {
    ["light_main"] = {
        ["code1"] = { 1, 1, 1, 0, 0, 0 },
        ["code2"] = { 1, 1, 0, 0 },
        ["code3"] = { 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0 },

        ["code1A"] = { 0, 0, 0, 1, 1, 1 },
        ["code2A"] = { 0, 0, 1, 1 },
        ["code3A"] = { 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0 },

        ["code1FDNY"] = { 1, 1, 0, 0 },
        ["code2FDNY"] = { 1, 0, 0 },
        ["code3FDNY"] = { 1, 0, 0 },

        ["code1FDNY2"] = { 0, 1, 1, 0 },
        ["code2FDNY2"] = { 0, 1, 0 },
        ["code3FDNY2"] = { 0, 1, 0 },

        ["code1FDNY3"] = { 0, 0, 1, 1 },
        ["code2FDNY3"] = { 0, 1, 0 },
        ["code3FDNY3"] = { 0, 1, 0 }
    },
}
 
COMPONENT.TrafficDisconnect = {}
 
COMPONENT.Modes = {
    Primary = {
        M1 = {
            ["light_main"] = "code1",
        },
        M2 = {
            ["light_main"] = "code2",
        },
        M3 = {
            ["light_main"] = "code3",
        }
    },
    Auxiliary = {
        L = {

        },
        R = {

        },
        D = {

        }
    }
}
 
EMVU:AddAutoComponent( COMPONENT, name )