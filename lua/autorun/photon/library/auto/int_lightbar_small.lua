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

local name = "Small Rear Interior Lightbar"

local COMPONENT = {}

COMPONENT.Model = "models/noble/police/int_lightbar_big.mdl"
COMPONENT.Required = "489864412"
COMPONENT.Skin = 0
COMPONENT.Bodygroups = {}
COMPONENT.NotLegacy = true
COMPONENT.ColorInput = 3
COMPONENT.Category = "Interior"
COMPONENT.DefaultColors = {
    [1] = "BLUE",
    [2] = "RED",
    [3] = "AMBER"
}

COMPONENT.Meta = {
    auto_int_lb = {
        W = 4.1,
        H = 3.1,
        Sprite = "sprites/emv/tdm_charger_rear_int",
        Scale = 1,
        WMult = 1.5,
        NoLegacy = true,
        DirAxis = "Up",
        DirOffset = -90
    },
}

COMPONENT.Positions = {

    [1] = { Vector( -1.8, -6.8, 0.82 ), Angle( 0, 90, 0 ), "auto_int_lb" },
    [2] = { Vector( -1.8, 6.8, 0.82 ), Angle( 0, 90, 0 ), "auto_int_lb" },

    [3] = { Vector( -1.8, -10.8, 0.82 ), Angle( 0, 90, 0 ), "auto_int_lb" },
    [4] = { Vector( -1.8, 10.8, 0.82 ), Angle( 0, 90, 0 ), "auto_int_lb" },

    [5] = { Vector( -1.8, -14.8, 0.82 ), Angle( 0, 90, 0 ), "auto_int_lb" },
    [6] = { Vector( -1.8, 14.8, 0.82 ), Angle( 0, 90, 0 ), "auto_int_lb" },

    [7] = { Vector( -1.8, -18.8, 0.82 ), Angle( 0, 90, 0 ), "auto_int_lb" },
    [8] = { Vector( -1.8, 18.8, 0.82 ), Angle( 0, 90, 0 ), "auto_int_lb" },

    [9] = { Vector( -1.8, -22.8, 0.82 ), Angle( 0, 90, 0 ), "auto_int_lb" },
    [10] = { Vector( -1.8, 22.8, 0.82 ), Angle( 0, 90, 0 ), "auto_int_lb" },

}

COMPONENT.Sections = {

    ["carbide_aux"] = {
        [1] = {
            { 9, "_1", .66 }, { 5, "_1", .66 }, { 8, "_1", .66 },
            { 7, "_1", .66 }, { 6, "_1", .66 }, { 10, "_1", .66 },
        },
    },

    ["auto_boston"] = {
        [1] = {
            { 9, "_1" }, { 5, "_1" }, { 8, "_1" },
        },
        [2] = {
            { 7, "_1" }, { 6, "_1" }, { 10, "_1" },
        },

        [3] = {
            { 9, "_1" }, { 5, "_1" }, { 8, "_3" },
        },
        [4] = {
            { 7, "_2" }, { 6, "_1" }, { 10, "_1" },
        },


        [5] = {
            { 9, "_2" }, { 5, "_2" }, { 8, "_2" },
        },
        [6] = {
            { 9, "_2" }, { 5, "_2" }, { 8, "_1" },
        },
        [7] = {
            { 7, "_2" }, { 6, "_1" }, { 10, "_1" },
        },
    },
}

COMPONENT.Patterns = {

    ["auto_boston"] = {
        ["code1"] = { 5, 5, 0, 5, 5, 5, 5, 0, 2, 2, 0, 2, 2, 2, 2, 0 },
        ["code2"] = { 5, 0, 5, 5, 5, 0, 2, 0, 2, 2, 2, 0 },
        ["code3"] = { 6, 0, 6, 6, 6, 0, 7, 0, 7, 7, 7, 0 },

        ["code1A"] = { 1, 1, 0, 1, 1, 1, 1, 0, 2, 2, 0, 2, 2, 2, 2, 0 },
        ["code2A"] = { 1, 0, 1, 1, 1, 0, 2, 0, 2, 2, 2, 0 },
        ["code3A"] = { 3, 0, 3, 3, 3, 0, 4, 0, 4, 4, 4, 0 },
    },

    ["carbide_aux"] = {
        ["parkkill"] = { 1 }
    },

}

COMPONENT.TrafficDisconnect = { 
    ["carbide_aux"] = {
        5, 6, 7, 8, 9, 10 
    }
}

COMPONENT.Modes = {
    Primary = {
        M1 = { 
            ["auto_boston"] = "code1",
        },
        M2 = { 
            ["auto_boston"] = "code2",
        },
        M3 = { 
            ["auto_boston"] = "code3",
        },
    },
    Auxiliary = {
        PK = {
            ["carbide_aux"] = "parkkill",
        },
        C = {

        },
        L = { 

        },
        R = { 

        },
        D = {

        },
    },
    Illumination = {}
}

EMVU:AddAutoComponent( COMPONENT, name )