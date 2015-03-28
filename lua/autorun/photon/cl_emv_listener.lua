AddCSLuaFile()

function EMVU:Listener( ply, bind, press )
	if not ply:InVehicle() or not ply:GetVehicle():Photon() then return end
	local emv = ply:GetVehicle()
	if not IsValid( emv ) then return false end
	if string.find(bind, "+attack") and not string.find(bind, "+attack2") then
		if LocalPlayer():KeyDown( IN_MOVELEFT ) then
			Photon:CarSignal( "left" )
		elseif LocalPlayer():KeyDown( IN_MOVERIGHT ) then
			Photon:CarSignal( "right" )
		elseif LocalPlayer():KeyDown( IN_BACK ) then
			Photon:CarSignal( "hazard" )
		else
			Photon:CarSignal( "none" )
		end
	elseif LocalPlayer():KeyDown( IN_ATTACK ) then
		if string.find(bind, "+moveleft" ) then
			Photon:CarSignal( "left" )
		elseif string.find(bind, "+moveright") then
			Photon:CarSignal( "right" )
		elseif string.find(bind, "+back") then
			Photon:CarSignal( "hazard" )
		elseif string.find(bind, "+forward") then
			Photon:CarSignal( "none" )
		end
	end

end
hook.Add("PlayerBindPress", "EMVU.Listener", function( pl, b, p )
	EMVU:Listener( pl, b, p )
end)

hook.Add( "Think", "Photon.ButtonPress", function()

	if not LocalPlayer():InVehicle() or not IsValid( LocalPlayer():GetVehicle() ) or not LocalPlayer():GetVehicle():IsEMV() then return end
	local emv = LocalPlayer():GetVehicle()
	if input.IsKeyTrapping() then return end
	if vgui.CursorVisible() then return end
	
	if not X_DOWN then
		if input.IsKeyDown( KEY_X ) then
			if emv:Illumination() then surface.PlaySound( EMVU.Sounds.Up ) else surface.PlaySound( EMVU.Sounds.Down ) end
			X_DOWN = true
			X_PRESS = CurTime()
		end
	elseif X_DOWN and not input.IsKeyDown ( KEY_X ) then
		local cmd = "on"
		if emv:Illumination() and X_PRESS + .25 > CurTime() then 
			cmd = "off"
		elseif emv:Illumination() then
			cmd = "tog"
		end
		if cmd == "on" or cmd == "tog" then surface.PlaySound( EMVU.Sounds.Up ) else surface.PlaySound( EMVU.Sounds.Down ) end
		EMVU.Net:Illuminate( cmd )
		X_DOWN = false
	end

	if emv:HasTrafficAdvisor() then 
		if not PHOTON_B_DOWN then
			if input.IsKeyDown( KEY_B ) then
				if emv:TrafficAdvisor() then surface.PlaySound( EMVU.Sounds.Up ) else surface.PlaySound( EMVU.Sounds.Down ) end
				PHOTON_B_DOWN = true
				PHOTON_B_PRESS = CurTime()
			end
		elseif PHOTON_B_DOWN and not input.IsKeyDown ( KEY_B ) then
			local cmd = "on"
			if emv:TrafficAdvisor() and PHOTON_B_PRESS + .25 > CurTime() then 
				cmd = "off"
			elseif emv:TrafficAdvisor() then
				cmd = "tog"
			end
			if cmd == "on" or cmd == "tog" then surface.PlaySound( EMVU.Sounds.Up ) else surface.PlaySound( EMVU.Sounds.Down ) end
			EMVU.Net:Traffic( cmd )
			PHOTON_B_DOWN = false
		end
	end

	if not LIGHTON_DOWN and input.IsKeyDown( KEY_F ) then
		if emv:Lights() then 
			surface.PlaySound( EMVU.Sounds.Up )
		else
			surface.PlaySound( EMVU.Sounds.Down )
		end
		LIGHTON_DOWN = true
	elseif LIGHTON_DOWN and not input.IsKeyDown( KEY_F ) then
		if emv:Lights() then
			surface.PlaySound( EMVU.Sounds.Down )
			EMVU.Net:Lights( "off" )
		else
			surface.PlaySound( EMVU.Sounds.Up )
			EMVU.Net:Lights( "on" )
		end
		LIGHTON_DOWN = false
	end

	if not SIRENON_DOWN and input.IsKeyDown( KEY_R ) then
		SIRENON_DOWN = true
		if emv:Siren() then
			EMVU.Net:Siren( "off" )
		else
			EMVU.Net:Siren( "on" )
		end
	elseif SIRENON_DOWN and not input.IsKeyDown( KEY_R ) then
		SIRENON_DOWN = false
	end

	if not LIGHTTOG_DOWN and input.IsKeyDown( KEY_LALT ) then
		if emv:Lights() then
			surface.PlaySound( EMVU.Sounds.Up )
		else
			surface.PlaySound( EMVU.Sounds.Down )
		end
		EMVU.Net:Lights("tog")
		LIGHTTOG_DOWN = true
	elseif LIGHTTOG_DOWN and not input.IsKeyDown( KEY_LALT ) then
		LIGHTTOG_DOWN = false
	end

	if not SIRENTOGGLE_DOWN and input.IsMouseDown( MOUSE_RIGHT ) then
		if emv:Lights() then
			surface.PlaySound( EMVU.Sounds.Up )
		else
			surface.PlaySound( EMVU.Sounds.Down )
		end
		EMVU.Net:Siren("tog")
		SIRENTOGGLE_DOWN = true
	elseif SIRENTOGGLE_DOWN and not input.IsMouseDown( MOUSE_RIGHT ) then
		SIRENTOGGLE_DOWN = false
	end

	if not BLKOUTON_DOWN and input.IsKeyDown( KEY_H ) then
		if emv:IsRunning() then 
			surface.PlaySound( EMVU.Sounds.Down )
		else
			surface.PlaySound( EMVU.Sounds.Up )
		end
		BLKOUTON_DOWN = true
	elseif BLKOUTON_DOWN and not input.IsKeyDown( KEY_H ) then
		if emv:IsRunning() then
			surface.PlaySound( EMVU.Sounds.Up )
			EMVU.Net:Blackout( true )
		else
			surface.PlaySound( EMVU.Sounds.Down )
			EMVU.Net:Blackout( false )
		end
		BLKOUTON_DOWN = false
	end

	if not HORNTOG_DOWN and input.IsKeyDown( KEY_G ) then
		EMVU.Net:Horn( true )
		HORNTOG_DOWN = true
	elseif HORNTOG_DOWN and not input.IsKeyDown( KEY_G ) then
		EMVU.Net:Horn( false )
		HORNTOG_DOWN = false
	end

	if not MANUALTOG_DOWN and input.IsKeyDown( KEY_T ) then
		EMVU.Net:Manual( true )
		MANUALTOG_DOWN = true
	elseif MANUALTOG_DOWN and not input.IsKeyDown( KEY_T ) then
		EMVU.Net:Manual( false )
		MANUALTOG_DOWN = false
	end

end)



local function SirenSuggestions( cmd, args )

	args = string.Trim( args )
	args = string.lower( args )

	local result = {}

	local i = 1
	for k,v in pairs( EMVU.Sirens ) do

		table.insert( result, "emv_siren " .. k .. " \"" .. v.Name .. "\"")

	end

	return result

end

concommand.Add("emv_siren", function(ply, cmd, args)
	if not args[1] then return end
	if not ply:InVehicle() or not ply:GetVehicle():IsEMV() then return end
	local set = 0
	local max = #EMVU.Sirens
	local val = tonumber(args[1])
	if val and isnumber(val) and val <= max then set = val end
	EMVU.Net:SirenSet( set )
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
		if not car:TurningLeft() then surface.PlaySound( EMVU.Sounds.SignalOn ) else surface.PlaySound( EMVU.Sounds.SignalOff ) end
		return
	end
	if arg == "right" then 
		Photon.Net:Signal( CAR_TURNING_RIGHT )
		if not car:TurningRight() then surface.PlaySound( EMVU.Sounds.SignalOn ) else surface.PlaySound( EMVU.Sounds.SignalOff ) end
		return
	end
	if arg == "hazard" then Photon.Net:Signal( CAR_HAZARD ) return end
	if arg == "none" and (car:BlinkState() != 0) then Photon.Net:Signal( 0 ); surface.PlaySound( EMVU.Sounds.SignalOff ) return end
end