AddCSLuaFile()

// HERP DERP //
PHOTON_BANNED_UNIT_IDS = {
	["fag"] = true,
	["f4g"] = true,
	["nig"] = true,
	["n1g"] = true
}

//         DATATABLE CONFIGURATIONS    //

-- If you're a developer or server owner, change these as needed to avoid datatable conflicts

local BOOL_CONST_OFFSET = 19

PHOTON_UPDATE = 71
PHOTON_SERIES = "Estes Park"

// booleans //
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

// integers //

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

// strings //
EMV_INDEX            = 3

// Blinker states
CAR_TURNING_LEFT	 = 1
CAR_TURNING_RIGHT	 = 2
CAR_HAZARD			 = 3


//			SPEED 					///
EMV_FRAME_DUR		 = .05
EMV_FRAME_CONST		 = .05

//			GLOBALS					///	

EMV_PIXVIS_MULTIPLIER = 1
PHO_DEFAULT_BLINK	 = .4
PHOTON_TRF_LEFT 						= 1
PHOTON_TRF_DIVERGE 						= 2
PHOTON_TRF_RIGHT						= 3
PHOTON_TRF_WARN							= 4

-- This is the frame speed, it will affect how fast the lights appear to flash.
-- At .05 seconds, anything below 20 FPS will likely have stutters where frames are skipped.
-- If you encounter this problem, increase this number and then buy a new fucking computer. Jesus Christ.

// SECONDS A PLAYER MUST WAIT FOR UNTIL THEY CAN CHANGE LIVERY AGAIN //
PHOTON_LIVERY_COOLDOWN = 3 

PHOTON_CHRISTMAS_PERMIT = false

if CLIENT then
	-- hook.Add( "InitPostEntity", "Photon.ChristmasCheck", function()
	-- 	local curDate = os.date("*t")
	-- 	local modeEnabled = GetConVar( "photon_christmas_mode" )
	-- 	local autoEnabled = GetConVar( "photon_christmas_mode_auto" )
	-- 	if curDate.month == 12 and ( curDate.day == 25 or curDate.day == 24 ) then
	-- 		PHOTON_CHRISTMAS_PERMIT = true
	-- 		if autoEnabled:GetBool() then
	-- 			RunConsoleCommand( "photon_christmas_mode", 1 )
	-- 			chat.AddText( Color( 205, 31, 31 ), "Merry Christmas ", Color( 255, 255, 255 ), "and ", Color( 65, 136, 13 ), "Happy Holidays ", Color( 255, 255, 255 ), " from Photon! \n", Color( 200, 200, 200 ), "(You can disable this in the Photon settings menu or by typing \"stop\" into chat)."  )
	-- 		end
	-- 	end
	-- end)
	-- hook.Add( "OnPlayerChat", "Photon.ChatXmasHook", function( ply, txt )
	-- 	if string.lower( txt ) == "stop" and ply == LocalPlayer() then
	-- 		local modeEnabled = GetConVar( "photon_christmas_mode" )
	-- 		if modeEnabled:GetBool() then
	-- 			RunConsoleCommand( "photon_christmas_mode_auto", 0 )
	-- 		end
	-- 	end
	-- end)
	hook.Add( "InitPostEntity", "Photon.ChristmasCheck", function()

		RunConsoleCommand( "photon_christmas_mode", 0 )
		RunConsoleCommand( "photon_christmas_mode_auto", 0 )
				
	end)
end