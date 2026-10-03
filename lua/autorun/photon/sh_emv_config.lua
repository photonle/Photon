AddCSLuaFile()

-- Banned Unit IDs.
PHOTON_BANNED_UNIT_IDS = {
	["fag"] = true,
	["f4g"] = true,
	["nig"] = true,
	["n1g"] = true
}

_PHOTON_UPDATE = "76.6.0" -- x-release-please-version
PHOTON_UPDATE = string.match( _PHOTON_UPDATE, "^(%d+%.%d+)" ) or _PHOTON_UPDATE
PHOTON_SERIES = "Johnstown"

-- Blinker State
CAR_TURNING_LEFT	 = 1
CAR_TURNING_RIGHT	 = 2
CAR_HAZARD			 = 3

CAR_BLINKER_NONE = 0
CAR_BLINKER_LEFT = CAR_TURNING_LEFT
CAR_BLINKER_RIGHT = CAR_TURNING_RIGHT
CAR_BLINKER_HAZARD = CAR_HAZARD



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
