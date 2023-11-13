--[[-- EMVU Key Listener.
@copyright Photon Team
@release v74 Hot Sulphur Springs
@author Photon Team
@module EMVU
--]]--
AddCSLuaFile()

local cv_key_alt_reverse = GetConVar("photon_key_alt_reverse")
local key_backtick = cv_key_alt_reverse and cv_key_alt_reverse:GetInt() or 0
local cv_key_illum = GetConVar("photon_key_illum")
local key_illum = cv_key_illum and cv_key_illum:GetInt() or 0
local cv_key_primary_alt = GetConVar("photon_key_primary_alt")
local key_primary_alt = cv_key_primary_alt and cv_key_primary_alt:GetInt() or 0
local cv_key_siren4 = GetConVar("photon_key_siren4")
local key_siren4 = cv_key_siren4 and cv_key_siren4:GetInt() or 0
local cv_key_signal_left = GetConVar("photon_key_signal_left")
local key_signal_left = cv_key_signal_left and cv_key_signal_left:GetInt() or 0
local cv_key_siren1 = GetConVar("photon_key_siren1")
local key_siren1 = cv_key_siren1 and cv_key_siren1:GetInt() or 0
local cv_key_siren2 = GetConVar("photon_key_siren2")
local key_siren2 = cv_key_siren2 and cv_key_siren2:GetInt() or 0
local cv_key_primary_toggle = GetConVar("photon_key_primary_toggle")
local key_primary_toggle = cv_key_primary_toggle and cv_key_primary_toggle:GetInt() or 0
local cv_key_signal_activate = GetConVar("photon_key_signal_activate")
local key_signal_activate = cv_key_signal_activate and cv_key_signal_activate:GetInt() or 0
local cv_key_blackout = GetConVar("photon_key_blackout")
local key_blackout = cv_key_blackout and cv_key_blackout:GetInt() or 0
local cv_key_siren_alt = GetConVar("photon_key_siren_alt")
local key_siren_alt = cv_key_siren_alt and cv_key_siren_alt:GetInt() or 0
local cv_key_horn = GetConVar("photon_key_horn")
local key_horn = cv_key_horn and cv_key_horn:GetInt() or 0
local cv_key_siren_toggle = GetConVar("photon_key_siren_toggle")
local key_siren_toggle = cv_key_siren_toggle and cv_key_siren_toggle:GetInt() or 0
local cv_emerg_enabled = GetConVar("photon_emerg_enabled")
local should_render = cv_emerg_enabled and cv_emerg_enabled:GetBool() or false
local cv_key_manual = GetConVar("photon_key_manual")
local key_manual = cv_key_manual and cv_key_manual:GetInt() or 0
local cv_key_radar = GetConVar("photon_key_radar")
local key_radar = cv_key_radar and cv_key_radar:GetInt() or 0
local cv_key_signal_hazard = GetConVar("photon_key_signal_hazard")
local key_signal_hazard = cv_key_signal_hazard and cv_key_signal_hazard:GetInt() or 0
local cv_key_signal_deactivate = GetConVar("photon_key_signal_deactivate")
local key_signal_deactivate = cv_key_signal_deactivate and cv_key_signal_deactivate:GetInt() or 0
local cv_key_signal_right = GetConVar("photon_key_signal_right")
local key_signal_right = cv_key_signal_right and cv_key_signal_right:GetInt() or 0
local cv_key_siren3 = GetConVar("photon_key_siren3")
local key_siren3 = cv_key_siren3 and cv_key_siren3:GetInt() or 0
local cv_key_auxiliary = GetConVar("photon_key_auxiliary")
local key_auxiliary = cv_key_auxiliary and cv_key_auxiliary:GetInt() or 0

hook.Add("InitPostEntity", "Photon.SetupLocalKeyBinds", function()
	cv_key_alt_reverse = GetConVar("photon_key_alt_reverse")
	key_backtick = cv_key_alt_reverse:GetInt()
	cv_key_illum = GetConVar("photon_key_illum")
	key_illum = cv_key_illum:GetInt()
	cv_key_primary_alt = GetConVar("photon_key_primary_alt")
	key_primary_alt = cv_key_primary_alt:GetInt()
	cv_key_siren4 = GetConVar("photon_key_siren4")
	key_siren4 = cv_key_siren4:GetInt()
	cv_key_signal_left = GetConVar("photon_key_signal_left")
	key_signal_left = cv_key_signal_left:GetInt()
	cv_key_siren1 = GetConVar("photon_key_siren1")
	key_siren1 = cv_key_siren1:GetInt()
	cv_key_siren2 = GetConVar("photon_key_siren2")
	key_siren2 = cv_key_siren2:GetInt()
	cv_key_primary_toggle = GetConVar("photon_key_primary_toggle")
	key_primary_toggle = cv_key_primary_toggle:GetInt()
	cv_key_signal_activate = GetConVar("photon_key_signal_activate")
	key_signal_activate = cv_key_signal_activate:GetInt()
	cv_key_blackout = GetConVar("photon_key_blackout")
	key_blackout = cv_key_blackout:GetInt()
	cv_key_siren_alt = GetConVar("photon_key_siren_alt")
	key_siren_alt = cv_key_siren_alt:GetInt()
	cv_key_horn = GetConVar("photon_key_horn")
	key_horn = cv_key_horn:GetInt()
	cv_key_siren_toggle = GetConVar("photon_key_siren_toggle")
	key_siren_toggle = cv_key_siren_toggle:GetInt()
	cv_emerg_enabled = GetConVar("photon_emerg_enabled")
	should_render = cv_emerg_enabled:GetBool()
	cv_key_manual = GetConVar("photon_key_manual")
	key_manual = cv_key_manual:GetInt()
	cv_key_radar = GetConVar("photon_key_radar")
	key_radar = cv_key_radar:GetInt()
	cv_key_signal_hazard = GetConVar("photon_key_signal_hazard")
	key_signal_hazard = cv_key_signal_hazard:GetInt()
	cv_key_signal_deactivate = GetConVar("photon_key_signal_deactivate")
	key_signal_deactivate = cv_key_signal_deactivate:GetInt()
	cv_key_signal_right = GetConVar("photon_key_signal_right")
	key_signal_right = cv_key_signal_right:GetInt()
	cv_key_siren3 = GetConVar("photon_key_siren3")
	key_siren3 = cv_key_siren3:GetInt()
	cv_key_auxiliary = GetConVar("photon_key_auxiliary")
	key_auxiliary = cv_key_auxiliary:GetInt()
end)

cvars.AddChangeCallback("photon_key_alt_reverse", function() key_backtick = cv_key_alt_reverse:GetInt() end)
cvars.AddChangeCallback("photon_key_illum", function() key_illum = cv_key_illum:GetInt() end)
cvars.AddChangeCallback("photon_key_primary_alt", function() key_primary_alt = cv_key_primary_alt:GetInt() end)
cvars.AddChangeCallback("photon_key_siren4", function() key_siren4 = cv_key_siren4:GetInt() end)
cvars.AddChangeCallback("photon_key_signal_left", function() key_signal_left = cv_key_signal_left:GetInt() end)
cvars.AddChangeCallback("photon_key_siren1", function() key_siren1 = cv_key_siren1:GetInt() end)
cvars.AddChangeCallback("photon_key_siren2", function() key_siren2 = cv_key_siren2:GetInt() end)
cvars.AddChangeCallback("photon_key_primary_toggle", function() key_primary_toggle = cv_key_primary_toggle:GetInt() end)
cvars.AddChangeCallback("photon_key_signal_activate", function() key_signal_activate = cv_key_signal_activate:GetInt() end)
cvars.AddChangeCallback("photon_key_blackout", function() key_blackout = cv_key_blackout:GetInt() end)
cvars.AddChangeCallback("photon_key_siren_alt", function() key_siren_alt = cv_key_siren_alt:GetInt() end)
cvars.AddChangeCallback("photon_key_horn", function() key_horn = cv_key_horn:GetInt() end)
cvars.AddChangeCallback("photon_key_siren_toggle", function() key_siren_toggle = cv_key_siren_toggle:GetInt() end)
cvars.AddChangeCallback("photon_emerg_enabled", function() should_render = cv_emerg_enabled:GetBool() end)
cvars.AddChangeCallback("photon_key_manual", function() key_manual = cv_key_manual:GetInt() end)
cvars.AddChangeCallback("photon_key_radar", function() key_radar = cv_key_radar:GetInt() end)
cvars.AddChangeCallback("photon_key_signal_hazard", function() key_signal_hazard = cv_key_signal_hazard:GetInt() end)
cvars.AddChangeCallback("photon_key_signal_deactivate", function() key_signal_deactivate = cv_key_signal_deactivate:GetInt() end)
cvars.AddChangeCallback("photon_key_signal_right", function() key_signal_right = cv_key_signal_right:GetInt() end)
cvars.AddChangeCallback("photon_key_siren3", function() key_siren3 = cv_key_siren3:GetInt() end)
cvars.AddChangeCallback("photon_key_auxiliary", function() key_auxiliary = cv_key_auxiliary:GetInt() end)

local inputKeyDown = input.IsKeyDown
local inputMouseDown = input.IsMouseDown

--- Check if a key / mouse button has been pressed.
-- @number key KEY_ or MOUSE_ enums.
-- @treturn bool Key press status.
local function keyDown(key)
	if key > 0 and key < 107 then
		return inputKeyDown(key)
	end

	if key >= 107 and key < 114 then
		return inputMouseDown(key)
	end

	return false
end

--- Hook function called on key press.
-- @ply ply Player pushing the key.
-- @string bind The bind being pressed.
-- @bool press If the key is going up or down.
function EMVU:Listener(ply, bind, press)
	if not should_render then return end
	if not ply:InVehicle() or not ply:GetVehicle():Photon() then return end

	local emv = ply:GetVehicle()
	if not IsValid(emv) then return false end

	if keyDown(key_signal_activate) and not keyDown(key_signal_deactivate) then
		if keyDown(key_signal_left) then
			Photon:CarSignal("left")
		elseif keyDown(key_signal_right) then
			Photon:CarSignal("right")
		elseif keyDown(key_signal_hazard) then
			Photon:CarSignal("hazard")
		else
			Photon:CarSignal("none")
		end
	end
end

hook.Add("PlayerBindPress", "EMVU.Listener", function(pl, b, p)
	EMVU:Listener(pl, b, p)
end)

hook.Add("Think", "Photon.ButtonPress", function()
	if not should_render then return end
	if not LocalPlayer():InVehicle() or not IsValid( LocalPlayer():GetVehicle() ) or not LocalPlayer():GetVehicle():IsEMV() then return end

	local emv = LocalPlayer():GetVehicle()

	if not emv.Photon_Illumination or not emv.Photon_Lights or not emv.Photon_Siren then return end

	if input.IsKeyTrapping() then return end
	if vgui.CursorVisible() then return end

	local SHIFTING = keyDown(key_backtick)

	if not X_DOWN then
		if keyDown(key_illum) then
			EMVU.Sounds:Panel(emv:Photon_Illumination())
			X_DOWN = true
			X_PRESS = CurTime()
		end
	elseif X_DOWN and not keyDown(key_illum) then
		local cmd = EMVU_NET_ILLUM_ON
		if emv:Photon_Illumination() and X_PRESS + .25 > CurTime() then
			cmd = EMVU_NET_ILLUM_OFF
		elseif emv:Photon_Illumination() then
			cmd = SHIFTING and EMVU_NET_ILLUM_REVERSE or EMVU_NET_ILLUM_FORWARD
		end

		EMVU.Sounds:Panel(cmd ~= "off")
		EMVU.Net:Illuminate(cmd)
		X_DOWN = false
	end

	if emv.Photon_HasTrafficAdvisor and emv:Photon_HasTrafficAdvisor() then
		if not PHOTON_B_DOWN then
			if keyDown( key_auxiliary ) then
				EMVU.Sounds:Panel(emv:Photon_TrafficAdvisor())
				PHOTON_B_DOWN = true
				PHOTON_B_PRESS = CurTime()
			end
		elseif PHOTON_B_DOWN and not keyDown(key_auxiliary) then
			local cmd = "on"
			if emv:Photon_TrafficAdvisor() and PHOTON_B_PRESS + .25 > CurTime() then
				cmd = "off"
			elseif emv:Photon_TrafficAdvisor() then
				cmd = SHIFTING and "togback" or "tog"
			end
			EMVU.Sounds:Panel(cmd ~= "off")
			EMVU.Net:Traffic(cmd)
			PHOTON_B_DOWN = false
		end
	end

	if not LIGHTON_DOWN and keyDown(key_primary_toggle) then
		EMVU.Sounds:Panel(emv:Photon_Lights())
		LIGHTON_DOWN = true
	elseif LIGHTON_DOWN and not keyDown(key_primary_toggle) then
		EMVU.Sounds:Panel(not emv:Photon_Lights())
		EMVU.Net:Lights(emv:Photon_Lights() and EMVU_NET_ELS_OFF or EMVU_NET_ELS_ON)
		LIGHTON_DOWN = false
	end

	if not SIRENON_DOWN and keyDown(key_siren_toggle) then
		SIRENON_DOWN = true
		EMVU.Net:Siren(emv:Photon_Siren() and EMVU_NET_SIREN_OFF or EMVU_NET_SIREN_ON)
	elseif SIRENON_DOWN and not keyDown(key_siren_toggle) then
		SIRENON_DOWN = false
	end

	if not LIGHTTOG_DOWN and keyDown(key_primary_alt) then
		EMVU.Sounds:Panel(emv:Photon_Lights())
		EMVU.Net:Lights(SHIFTING and EMVU_NET_ELS_REVERSE or EMVU_NET_ELS_FORWARD)
		LIGHTTOG_DOWN = true
	elseif LIGHTTOG_DOWN and not keyDown(key_primary_alt) then
		LIGHTTOG_DOWN = false
	end

	if not SIRENTOGGLE_DOWN and keyDown(key_siren_alt) then
		EMVU.Sounds:Panel(emv:Photon_Lights())
		EMVU.Net:Siren(SHIFTING and EMVU_NET_SIREN_REVERSE or EMVU_NET_SIREN_FORWARD)
		SIRENTOGGLE_DOWN = true
	elseif SIRENTOGGLE_DOWN and not keyDown(key_siren_alt) then
		SIRENTOGGLE_DOWN = false
	end

	if not SIRENTOGGLE1_DOWN and keyDown(key_siren1) then
		EMVU.Sounds:Panel(emv:Photon_Lights())
		EMVU.Net:Siren(EMVU_NET_SIREN_SET_1)
		SIRENTOGGLE1_DOWN = true
	elseif SIRENTOGGLE1_DOWN and not keyDown(key_siren1) then
		SIRENTOGGLE1_DOWN = false
	end

	if not SIRENTOGGLE2_DOWN and keyDown(key_siren2) then
		EMVU.Sounds:Panel(emv:Photon_Lights())
		EMVU.Net:Siren(EMVU_NET_SIREN_SET_2)
		SIRENTOGGLE2_DOWN = true
	elseif SIRENTOGGLE2_DOWN and not keyDown(key_siren2) then
		SIRENTOGGLE2_DOWN = false
	end

	if not SIRENTOGGLE3_DOWN and keyDown(key_siren3) then
		EMVU.Sounds:Panel(emv:Photon_Lights())
		EMVU.Net:Siren(EMVU_NET_SIREN_SET_3)
		SIRENTOGGLE3_DOWN = true
	elseif SIRENTOGGLE3_DOWN and not keyDown(key_siren3) then
		SIRENTOGGLE3_DOWN = false
	end

	if not SIRENTOGGLE4_DOWN and keyDown(key_siren4) then
		EMVU.Sounds:Panel(emv:Photon_Lights())
		EMVU.Net:Siren(EMVU_NET_SIREN_SET_4)
		SIRENTOGGLE4_DOWN = true
	elseif SIRENTOGGLE4_DOWN and not keyDown(key_siren4) then
		SIRENTOGGLE4_DOWN = false
	end

	if not BLKOUTON_DOWN and keyDown(key_blackout) then
		EMVU.Sounds:Panel(not emv:Photon_IsRunning())
		BLKOUTON_DOWN = true
	elseif BLKOUTON_DOWN and not keyDown( key_blackout ) then
		EMVU.Sounds:Panel(emv:Photon_IsRunning())
		EMVU.Net:Blackout(emv:Photon_IsRunning())
		BLKOUTON_DOWN = false
	end

	if not HORNTOG_DOWN and keyDown(key_horn) then
		EMVU.Net:Horn(true)
		HORNTOG_DOWN = true
	elseif HORNTOG_DOWN and not keyDown(key_horn) then
		EMVU.Net:Horn(false)
		HORNTOG_DOWN = false
	end

	if not MANUALTOG_DOWN and keyDown(key_manual) then
		EMVU.Net:Manual(true)
		MANUALTOG_DOWN = true
	elseif MANUALTOG_DOWN and not keyDown(key_manual) then
		EMVU.Net:Manual(false)
		MANUALTOG_DOWN = false
	end

	if not PHOTONRADARTOG_DOWN and keyDown(key_radar) then
		EMVU.Sounds:Panel(emv:Photon_RadarActive())
		PHOTONRADARTOG_DOWN = true
	elseif PHOTONRADARTOG_DOWN and not keyDown( key_radar ) then
		EMVU.Sounds:Panel(not emv:Photon_RadarActive())
		emv:Photon_RadarActive(not emv:Photon_RadarActive())
		PHOTONRADARTOG_DOWN = false
	end
end)

local function SirenSuggestions(cmd, args)
	arg = args:Trim():lower()
	if arg == "" then
		arg = false
	end

	local result = {}

	for i, siren in ipairs(EMVU.GetSirenTable()) do
		if arg then
			local cat = siren.Category:lower()
			local name = siren.Name:lower()

			if tostring(i) == arg then
				table.insert(result, string.format("%s %s \"%s\"", cmd, i, siren.Name))
			elseif name:StartWith(arg) then
				table.insert(result, string.format("%s %s \"%s\"", cmd, i, siren.Name))
			elseif cat:StartWith(arg) then
				table.insert(result, string.format("%s %s \"%s\"", cmd, i, siren.Name))
			elseif arg:StartWith(cat) then
				local test = arg:sub(#cat + 1):Trim()
				if name:StartWith(test) then
					table.insert(result, string.format("%s %s \"%s\"", cmd, i, siren.Name))
				end
			end
		else
			table.insert(result, string.format("%s %s \"%s\"", cmd, i, siren.Name))
		end
	end

	return result
end

concommand.Add("emv_siren", function(ply, cmd, args)
	if args[1] == nil then return end
	if not ply:InVehicle() or not ply:GetVehicle():IsEMV() then return end

	local id = tonumber(args[1])
	if id == nil then
		-- We're dealing with a name or a named ID.
		-- Check for IDs first.
		for idx, data in ipairs(EMVU.GetSirenTable()) do
			if data.ID == args[1] then
				id = idx
				break
			end
		end

		-- We've already checked against IDs.
		local name = table.concat(args, " "):Trim()
		for idx, data in ipairs(EMVU.GetSirenTable()) do
			if data.Name == name then
				id = idx
				break
			end
		end
	end

	if id == nil or not isnumber(id) then
		Error("[Photon] emv_siren was sent a bad name, ID or named index.\n")
		return
	end

	local max = #EMVU.GetSirenTable()
	local val = tonumber(args[1])
	if val and isnumber(val) and val <= max then set = val end
	EMVU.Net:SirenSet( set )
end, SirenSuggestions, "[Photon] Overrides the default siren on an Emergency Vehicle.")

concommand.Add("emv_illum", function(ply, cmd, args)
	if not args[1] then return end
	if not ply:InVehicle() or not ply:GetVehicle():IsEMV() then return end
	EMVU.Net:Illuminate(args[1])
end)

concommand.Add("car_signal", function(ply, cmd, args)
	if not ply:InVehicle() or not ply:GetVehicle():Photon() or not args[1] then return end
	Photon:CarSignal(args[1])
end)

--- Set the LocalPlayer's vehicle's turn signal state.
-- @string arg New state.
function Photon:CarSignal(arg)
	local lPly = LocalPlayer()
	if not IsValid(lPly) then return end
	if not lPly:InVehicle() then return end

	local car = LocalPlayer():GetVehicle()
	if not car:Photon() then return end

	if not arg then return end
	if not Photon.Vehicles.States.Blink_Left[car.VehicleName] or not Photon.Vehicles.States.Blink_Right[car.VehicleName] then return end
	if #Photon.Vehicles.States.Blink_Left[car.VehicleName] == 0 and #Photon.Vehicles.States.Blink_Right[car.VehicleName] == 0 then return end

	if arg == "left" then
		Photon.Net:Signal(CAR_BLINKER_LEFT)
		EMVU.Sounds:Signal(not car:Photon_TurningLeft())
		return
	end

	if arg == "right" then
		Photon.Net:Signal(CAR_BLINKER_RIGHT)
		EMVU.Sounds:Signal(not car:Photon_TurningRight())
		return
	end

	if arg == "hazard" then
		Photon.Net:Signal(CAR_BLINKER_HAZARD)
		return
	end

	if arg == "none" and (car:Photon_BlinkState() ~= CAR_BLINKER_NONE) then
		Photon.Net:Signal(CAR_BLINKER_NONE)
		EMVU.Sounds:Signal(false) -- Always turn off.
		return
	end
end
