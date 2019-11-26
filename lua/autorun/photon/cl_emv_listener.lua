--[[-- EMVU Key Listener.
@copyright Photon Team
@release v73 Grand Lake
@author Photon Team
@module EMVU
--]]--
AddCSLuaFile()

local key_primary_toggle = GetConVar("photon_key_primary_toggle")
local key_primary_alt = GetConVar("photon_key_primary_alt")
local key_siren_toggle = GetConVar("photon_key_siren_toggle")
local key_siren_alt = GetConVar("photon_key_siren_alt")
local key_auxiliary = GetConVar("photon_key_auxiliary")
local key_blackout = GetConVar("photon_key_blackout")
local key_horn = GetConVar("photon_key_horn")
local key_manual = GetConVar("photon_key_manual")
local key_illum = GetConVar("photon_key_illum")
local key_radar = GetConVar("photon_key_radar")
local key_siren1 = GetConVar("photon_key_siren1")
local key_siren2 = GetConVar("photon_key_siren2")
local key_siren3 = GetConVar("photon_key_siren3")
local key_siren4 = GetConVar("photon_key_siren4")
local should_render =  GetConVar("photon_emerg_enabled")

hook.Add("InitPostEntity", "Photon.SetupLocalKeyBinds", function()
	key_primary_toggle = GetConVar("photon_key_primary_toggle")
	key_primary_alt = GetConVar("photon_key_primary_alt")
	key_siren_toggle = GetConVar("photon_key_siren_toggle")
	key_siren_alt = GetConVar("photon_key_siren_alt")
	key_auxiliary = GetConVar("photon_key_auxiliary")
	key_blackout = GetConVar("photon_key_blackout")
	key_horn = GetConVar("photon_key_horn")
	key_manual = GetConVar("photon_key_manual")
	key_illum = GetConVar("photon_key_illum")
	key_radar = GetConVar("photon_key_radar")
	should_render = GetConVar("photon_emerg_enabled")
end)

--- Hook function called on key press.
-- @ply ply Player pushing the key.
-- @string bind The bind being pressed.
-- @bool press If the key is going up or down.
function EMVU:Listener(ply, bind, press)
	if not should_render:GetBool() then return end
	if not ply:InVehicle() or not ply:GetVehicle():Photon() then return end

	local emv = ply:GetVehicle()
	if not IsValid(emv) then return false end

	if string.find(bind, "+attack") and not string.find(bind, "+attack2") then
		if ply:KeyDown(IN_MOVELEFT) then
			Photon:CarSignal("left")
		elseif ply:KeyDown(IN_MOVERIGHT) then
			Photon:CarSignal("right")
		elseif ply:KeyDown(IN_BACK) then
			Photon:CarSignal("hazard")
		else
			Photon:CarSignal("none")
		end
	elseif ply:KeyDown(IN_ATTACK) then
		if string.find(bind, "+moveleft") then
			Photon:CarSignal("left")
		elseif string.find(bind, "+moveright") then
			Photon:CarSignal("right")
		elseif string.find(bind, "+back") then
			Photon:CarSignal("hazard")
		elseif string.find(bind, "+forward") then
			Photon:CarSignal("none")
		end
	end
end

hook.Add("PlayerBindPress", "EMVU.Listener", function(pl, b, p)
	EMVU:Listener(pl, b, p)
end)

local inputKeyDown = input.IsKeyDown
local inputMouseDown = input.IsMouseDown

--- Check if a key / mouse button has been pressed.
-- @number key KEY_ or MOUSE_ enums.
-- @treturn bool Key press status.
local function keyDown(key)
	if key > 0 and key < 107 then
		return inputKeyDown(key)
	end

	if key > 107 and key < 114 then
		return inputMouseDown(key)
	end

	return false
end

hook.Add("Think", "Photon.ButtonPress", function()
	if not should_render:GetBool() then return end
	if not LocalPlayer():InVehicle() or not IsValid( LocalPlayer():GetVehicle() ) or not LocalPlayer():GetVehicle():IsEMV() then return end

	local emv = LocalPlayer():GetVehicle()
	if input.IsKeyTrapping() then return end
	if vgui.CursorVisible() then return end

	local SHIFTING = keyDown(KEY_LALT)

	if not X_DOWN then
		if keyDown(key_illum:GetInt()) then
			EMVU.Sounds:Panel(emv:Photon_Illumination())
			X_DOWN = true
			X_PRESS = CurTime()
		end
	elseif X_DOWN and not keyDown(key_illum:GetInt()) then
		local cmd = "on"
		if emv:Photon_Illumination() and X_PRESS + .25 > CurTime() then
			cmd = "off"
		elseif emv:Photon_Illumination() then
			cmd = "tog"
		end

		EMVU.Sounds:Panel(cmd ~= "off")
		EMVU.Net:Illuminate(cmd)
		X_DOWN = false
	end

	if emv.Photon_HasTrafficAdvisor and emv:Photon_HasTrafficAdvisor() then
		if not PHOTON_B_DOWN then
			if keyDown( key_auxiliary:GetInt() ) then
				EMVU.Sounds:Panel(emv:Photon_TrafficAdvisor())
				PHOTON_B_DOWN = true
				PHOTON_B_PRESS = CurTime()
			end
		elseif PHOTON_B_DOWN and not keyDown(key_auxiliary:GetInt()) then
			local cmd = "on"
			if emv:Photon_TrafficAdvisor() and PHOTON_B_PRESS + .25 > CurTime() then
				cmd = "off"
			elseif emv:Photon_TrafficAdvisor() then
				cmd = "tog"
			end
			EMVU.Sounds:Panel(cmd ~= "off")
			EMVU.Net:Traffic(cmd)
			PHOTON_B_DOWN = false
		end
	end

	if not LIGHTON_DOWN and keyDown(key_primary_toggle:GetInt()) then
		EMVU.Sounds:Panel(emv:Photon_Lights())
		LIGHTON_DOWN = true
	elseif LIGHTON_DOWN and not keyDown(key_primary_toggle:GetInt()) then
		EMVU.Sounds:Panel(not emv:Photon_Lights())
		EMVU.Net:Lights(emv:Photon_Lights() and "off" or "on")
		LIGHTON_DOWN = false
	end

	if not SIRENON_DOWN and keyDown(key_siren_toggle:GetInt()) then
		SIRENON_DOWN = true
		EMVU.Net:Siren(emv:Photon_Siren() and "off" or "on")
	elseif SIRENON_DOWN and not keyDown(key_siren_toggle:GetInt()) then
		SIRENON_DOWN = false
	end

	if not LIGHTTOG_DOWN and keyDown(key_primary_alt:GetInt()) then
		EMVU.Sounds:Panel(emv:Photon_Lights())
		EMVU.Net:Lights(SHIFTING and "togback" or "tog")
		LIGHTTOG_DOWN = true
	elseif LIGHTTOG_DOWN and not keyDown(key_primary_alt:GetInt()) then
		LIGHTTOG_DOWN = false
	end

	if not SIRENTOGGLE_DOWN and keyDown(key_siren_alt:GetInt()) then
		EMVU.Sounds:Panel(emv:Photon_Lights())
		EMVU.Net:Siren(SHIFTING and "togback" or "tog")
		SIRENTOGGLE_DOWN = true
	elseif SIRENTOGGLE_DOWN and not keyDown(key_siren_alt:GetInt()) then
		SIRENTOGGLE_DOWN = false
	end

	if not SIRENTOGGLE1_DOWN and keyDown(key_siren1:GetInt()) then
		EMVU.Sounds:Panel(emv:Photon_Lights())
		EMVU.Net:Siren("1")
		SIRENTOGGLE1_DOWN = true
	elseif SIRENTOGGLE1_DOWN and not keyDown(key_siren1:GetInt()) then
		SIRENTOGGLE1_DOWN = false
	end

	if not SIRENTOGGLE2_DOWN and keyDown(key_siren2:GetInt()) then
		EMVU.Sounds:Panel(emv:Photon_Lights())
		EMVU.Net:Siren("2")
		SIRENTOGGLE2_DOWN = true
	elseif SIRENTOGGLE2_DOWN and not keyDown(key_siren2:GetInt()) then
		SIRENTOGGLE2_DOWN = false
	end

	if not SIRENTOGGLE3_DOWN and keyDown(key_siren3:GetInt()) then
		EMVU.Sounds:Panel(emv:Photon_Lights())
		EMVU.Net:Siren("3")
		SIRENTOGGLE3_DOWN = true
	elseif SIRENTOGGLE3_DOWN and not keyDown(key_siren3:GetInt()) then
		SIRENTOGGLE3_DOWN = false
	end

	if not SIRENTOGGLE4_DOWN and keyDown(key_siren4:GetInt()) then
		EMVU.Sounds:Panel(emv:Photon_Lights())
		EMVU.Net:Siren("4")
		SIRENTOGGLE4_DOWN = true
	elseif SIRENTOGGLE4_DOWN and not keyDown(key_siren4:GetInt()) then
		SIRENTOGGLE4_DOWN = false
	end

	if not BLKOUTON_DOWN and keyDown(key_blackout:GetInt()) then
		EMVU.Sounds:Panel(not emv:Photon_IsRunning())
		BLKOUTON_DOWN = true
	elseif BLKOUTON_DOWN and not keyDown( key_blackout:GetInt() ) then
		EMVU.Sounds:Panel(emv:Photon_IsRunning())
		EMVU.Net:Blackout(emv:Photon_IsRunning())
		BLKOUTON_DOWN = false
	end

	if not HORNTOG_DOWN and keyDown(key_horn:GetInt()) then
		EMVU.Net:Horn(true)
		HORNTOG_DOWN = true
	elseif HORNTOG_DOWN and not keyDown(key_horn:GetInt()) then
		EMVU.Net:Horn(false)
		HORNTOG_DOWN = false
	end

	if not MANUALTOG_DOWN and keyDown(key_manual:GetInt()) then
		EMVU.Net:Manual(true)
		MANUALTOG_DOWN = true
	elseif MANUALTOG_DOWN and not keyDown(key_manual:GetInt()) then
		EMVU.Net:Manual(false)
		MANUALTOG_DOWN = false
	end

	if not PHOTONRADARTOG_DOWN and keyDown(key_radar:GetInt()) then
		EMVU.Sounds:Panel(emv:Photon_RadarActive())
		PHOTONRADARTOG_DOWN = true
	elseif PHOTONRADARTOG_DOWN and not keyDown( key_radar:GetInt() ) then
		EMVU.Sounds:Panel(not emv:Photon_RadarActive())
		emv:Photon_RadarActive(not emv:Photon_RadarActive())
		PHOTONRADARTOG_DOWN = false
	end
end)

local function SirenSuggestions(cmd, args)
	args = args:Trim():lower()

	local filtered
	if args == "" then
		filtered = EMVU.GetSirenTable()
	else
		filtered = {}
		for k, v in pairs(EMVU.GetSirenTable()) do
			if v.Name:lower():StartWith(args) then
				filtered[k] = v
			end
		end
	end

	local result = {}
	for k, v in SortedPairs(filtered) do
		table.insert(result, Format("%s %s", cmd, v.Name))
	end

	return result
end

concommand.Add("emv_siren", function(ply, cmd, args)
	if args[1] == nil then return end
	if not ply:InVehicle() or not ply:GetVehicle():IsEMV() then return end

	local id = tonumber(args[1])
	if id == nil then
		-- We're dealing with a name or a named ID.
		local name = table.concat(args, " "):Trim()

		-- Check for IDs first.
		for idx, data in ipairs(EMVU.GetSirenTable()) do
			if data.ID == args[1] then
				id = idx
				break
			end
		end

		-- We've already checked against IDs.
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
	if id > max then
		id = 0
	end

	EMVU.Net:SirenSet(id)
end, SirenSuggestions, "[Photon] Overrides the default siren on an Emergency Vehicle.")

concommand.Add("car_signal", function(ply, cmd, args)
	if not ply:InVehicle() or not ply:GetVehicle():Photon() or not args[1] then return end
	Photon:CarSignal( args[1] )
end)

concommand.Add( "emv_illum", function( ply, cmd, args )
	if not args[1] then return end
	if not ply:InVehicle() or not ply:GetVehicle():IsEMV() then return end
	EMVU.Net:Illuminate( args[1] )
end)

function Photon:CarSignal( arg )
	if not LocalPlayer():InVehicle() or not LocalPlayer():GetVehicle():Photon() or not arg then return end
	local car = LocalPlayer():GetVehicle()
	if arg == "left" then
		Photon.Net:Signal( CAR_TURNING_LEFT )
		if not car:Photon_TurningLeft() then surface.PlaySound( EMVU.Sounds.SignalOn ) else surface.PlaySound( EMVU.Sounds.SignalOff ) end
		return
	end
	if arg == "right" then
		Photon.Net:Signal( CAR_TURNING_RIGHT )
		if not car:Photon_TurningRight() then surface.PlaySound( EMVU.Sounds.SignalOn ) else surface.PlaySound( EMVU.Sounds.SignalOff ) end
		return
	end
	if arg == "hazard" then Photon.Net:Signal( CAR_HAZARD ) return end
	if arg == "none" and (car:Photon_BlinkState() != 0) then Photon.Net:Signal( 0 ); surface.PlaySound( EMVU.Sounds.SignalOff ) return end
end