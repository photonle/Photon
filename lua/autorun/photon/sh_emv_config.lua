AddCSLuaFile()

-- Banned Unit IDs.
PHOTON_BANNED_UNIT_IDS = {
	["fag"] = true,
	["f4g"] = true,
	["nig"] = true,
	["n1g"] = true
}

PHOTON_UPDATE = 72.3
PHOTON_SERIES = "Fair Oaks | November Garry's Mod Update Hotfix"

--[[
	DATATABLE CONFIGURATIONS
	If you're a developer or server owner, change these as needed to avoid datatable conflicts.
]]--

-- Booleans
local BOOL_CONST_OFFSET = 10

EMV_LIGHTS_ON        = BOOL_CONST_OFFSET + 0
EMV_SIREN_ON         = BOOL_CONST_OFFSET + 1
CAR_BRAKING			 = BOOL_CONST_OFFSET + 2
CAR_REVERSING		 = BOOL_CONST_OFFSET + 3
CAR_HEADLIGHTS		 = BOOL_CONST_OFFSET + 4
CAR_RUNNING			 = BOOL_CONST_OFFSET + 5
CAR_USE_EL			 = BOOL_CONST_OFFSET + 6
EMV_HORN			 = BOOL_CONST_OFFSET + 7
CAR_MANUAL			 = BOOL_CONST_OFFSET + 8
EMV_ILLUM_ON		 = BOOL_CONST_OFFSET + 9
EMV_TRF_ON			 = BOOL_CONST_OFFSET + 10
CAR_HAS_PHOTON		 = BOOL_CONST_OFFSET + 11

-- Integers
local INT_CONST_OFFSET = 20

EMV_LIGHT_OPTION     = INT_CONST_OFFSET + 0
EMV_SIREN_OPTION     = INT_CONST_OFFSET + 1
EMV_SIREN_SET        = INT_CONST_OFFSET + 2
CAR_BLINKER			 = INT_CONST_OFFSET + 3
EMV_ILLUM_OPTION	 = INT_CONST_OFFSET + 4
EMV_TRF_OPTION		 = INT_CONST_OFFSET + 5
EMV_PRE_OPTION		 = INT_CONST_OFFSET + 6
EMV_SIREN_SECONDARY	 = INT_CONST_OFFSET + 7
CAR_WHEEL_OPTION	 = INT_CONST_OFFSET + 8

-- Strings
EMV_INDEX            = 3

-- Blinker State
CAR_TURNING_LEFT	 = 1
CAR_TURNING_RIGHT	 = 2
CAR_HAZARD			 = 3


-- Speeds
-- This is the frame speed, it will affect how fast the lights appear to flash.
-- At .05 seconds, anything below 20 FPS will likely have stutters where frames are skipped.
-- If you encounter this problem, increase this number and then buy a new fucking computer. Jesus Christ.
EMV_FRAME_DUR		 = .05
EMV_FRAME_CONST		 = .05

-- Globals
EMV_PIXVIS_MULTIPLIER = 1
PHO_DEFAULT_BLINK	 = .4
PHOTON_TRF_LEFT 						= 1
PHOTON_TRF_DIVERGE 						= 2
PHOTON_TRF_RIGHT						= 3
PHOTON_TRF_WARN							= 4

-- Livery changing cooldown.
PHOTON_LIVERY_COOLDOWN = 3

-- If photon christmas mode is allowed.
PHOTON_CHRISTMAS_PERMIT = false

if CLIENT then
	hook.Add( "InitPostEntity", "Photon.ChristmasCheck", function()
		RunConsoleCommand("photon_christmas_mode", 0)
		RunConsoleCommand("photon_christmas_mode_auto", 0)
	end)
end
