AddCSLuaFile()

local name = "Federal Signal MicroPulse"

local COMPONENT = {}

COMPONENT.Model = "models/noble/photon/fedsig_micropulse.mdl"
COMPONENT.Skin = 0
COMPONENT.Bodygroups = {}
COMPONENT.NotLegacy = true
COMPONENT.ColorInput = 2
COMPONENT.UsePhases = true
COMPONENT.Category = "Exterior"
COMPONENT.DefaultColors = {
    [1] = "BLUE",
    [2] = "RED"
}

COMPONENT.Meta = {
    auto_pulse_left = {
        AngleOffset = 0,
        W = 5.4,
        H = 5.0,
        WMult = 1.5,
        Sprite = "sprites/emv/fs_micropulse_left",
        Scale = .66,
        NoLegacy = true,
        DirAxis = "Up",
        DirOffset = 90
    },
    auto_pulse_right = {
        AngleOffset = 0,
        W = 5.4,
        H = 5.0,
        WMult = 1.5,
        Sprite = "sprites/emv/fs_micropulse_right",
        Scale = .66,
        NoLegacy = true,
        DirAxis = "Up",
        DirOffset = 90
    },
}

COMPONENT.Positions = {

    -- L/R, F/B, U,D
    [1] = { Vector( .13, .26, -.86 ), Angle( 0, 0, 0 ), "auto_pulse_left" },
    [2] = { Vector( -2.555, .26, -.86 ), Angle( 0, 0, 0 ), "auto_pulse_right" },

}

COMPONENT.Sections = {
    ["auto_pulse"] = {
        [1] = { { 1, "_1", .88 }, { 2, "_1", .88 }, },

        [2] = { { 1, "_1", .88 } },
        [3] = { { 2, "_2", .88 } },

        [4] = { { 2, "_2", .88 } },
        [5] = { { 1, "_1", .88 } },
    },
}

COMPONENT.Patterns = {
    ["auto_pulse"] = {
        ["code1"] = { 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0 },
        ["code1A"] = { 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0 },
        ["code1B"] = { 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1 },
        ["code2"] = { 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0 },
        ["code2A"] = { 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0 },
        ["code2B"] = { 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1 },
        ["code3"] = { 1, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0 },
        ["code3A"] = { 1, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0 },
        ["code3B"] = { 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 1 },

        ["code1A2"] = { 1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
        ["code2A2"] = { 1, 0, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0 },
        ["code3A2"] = { 1, 0, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0 },

        ["code1B2"] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1 },
        ["code2B2"] = { 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 1, 1, },
        ["code3B2"] = { 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 1, 1, },

        ["code1S1"] = { 1 },
        ["code2S1"] = { 3, 0, 2, 0, 2, 2, 2, 0, 3, 0, 3, 3, },
        ["code3S1"] = { 3, 0, 2, 0, 2, 2, 2, 0, 3, 0, 3, 3, },

        ["code1S2"] = { 1 },
        ["code2S2"] = { 5, 0, 4, 0, 4, 4, 4, 0, 5, 0, 5, 5 },
        ["code3S2"] = { 5, 0, 4, 0, 4, 4, 4, 0, 5, 0, 5, 5 },

        ["parkkill"] = { 1 }
    }
}

COMPONENT.TrafficDisconnect = {
    ["auto_pulse"] = {
        1, 2, 3
    }
}

COMPONENT.Modes = {
    Primary = {
        M1 = { ["auto_pulse"] = "code1" },
        M2 = { ["auto_pulse"] = "code2" },
        M3 = { ["auto_pulse"] = "code3" },
        PARK = {
            ["auto_pulse"] = "parkkill",
        }
    },
    Auxiliary = {
        L = {

        },
        R = {

        },
        D = {

        },
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