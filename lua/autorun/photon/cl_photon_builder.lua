AddCSLuaFile()

PHOTON_DEBUG = PHOTON_DEBUG or nil
PHOTON_DEBUG_TARGET = PHOTON_DEBUG_TARGET or nil
PHOTON_DEBUG_LIGHT = PHOTON_DEBUG_LIGHT or nil
PHOTON_DEBUG_INDEX = PHOTON_DEBUG_INDEX or 1
PHOTON_DEBUG_MODE = PHOTON_DEBUG_MODE or "UNKNOWN"
PHOTON_DEBUG_NAME = PHOTON_DEBUG_NAME or "UNKNOWN"
PHOTON_DEBUG_VECTOR = PHOTON_DEBUG_VECTOR or false

local GRACE_PRESS = .4
local SLIDE_TIMER = .1
local SLIDE_INDEX = 0

function PhotonAdjustPosition( vector )
	if not PHOTON_DEBUG_LIGHT then return end
	PHOTON_DEBUG_LIGHT[1] = WorldToLocal( PHOTON_DEBUG_LIGHT[1], PHOTON_DEBUG_LIGHT[2], vector, Angle(0,0,0) )
	-- PHOTON_DEBUG_LIGHT[1] = PHOTON_DEBUG_LIGHT[1] + vector
	-- PHOTON_DEBUG_LIGHT[1].x = math.Round( PHOTON_DEBUG_LIGHT[1].x, 2 )
	-- PHOTON_DEBUG_LIGHT[1].y = math.Round( PHOTON_DEBUG_LIGHT[1].y, 2 )
	-- PHOTON_DEBUG_LIGHT[1].z = math.Round( PHOTON_DEBUG_LIGHT[1].z, 2 )
	-- print( "Vector( " .. math.Round( PHOTON_DEBUG_LIGHT[1].x, 2 ) .. ", " .. math.Round( PHOTON_DEBUG_LIGHT[1].y, 2 ) .. ", " .. math.Round( PHOTON_DEBUG_LIGHT[1].z, 2 ) .. " )" )
end

function PhotonAdjustAngle( angle )
	if not PHOTON_DEBUG_LIGHT then return end
	local pos, ang = WorldToLocal( PHOTON_DEBUG_LIGHT[1], PHOTON_DEBUG_LIGHT[2], Vector(0,0,0), angle )
	PHOTON_DEBUG_LIGHT[2] = ang
	-- PHOTON_DEBUG_LIGHT[2] = PHOTON_DEBUG_LIGHT[2] + angle
	-- local ang = PHOTON_DEBUG_LIGHT[2]
	-- PHOTON_DEBUG_LIGHT[2].p = math.Round( PHOTON_DEBUG_LIGHT[2].p, 2 )
	-- PHOTON_DEBUG_LIGHT[2].y = math.Round( PHOTON_DEBUG_LIGHT[2].y, 2 )
	-- PHOTON_DEBUG_LIGHT[2].r = math.Round( PHOTON_DEBUG_LIGHT[2].r, 2 )
	-- print( "Angle( " .. pos.p .. ", " .. pos.y .. ", " .. pos.r .. " )" )
end

function SetDebugTarget( index, cat )
	if PHOTON_DEBUG_NAME == "UNKNOWN" then
		local car = PHOTON_DEBUG_TARGET
		if not IsValid( car ) or not car:Photon() then return end
		PHOTON_DEBUG_NAME = car.VehicleName
	end
	
	PHOTON_DEBUG_INDEX = index
	if cat == "ELS" then
		PHOTON_DEBUG_MODE = "ELS"
		PHOTON_DEBUG_LIGHT = EMVU.Positions[ PHOTON_DEBUG_NAME ][ index ]
	elseif cat == "REG" then
		PHOTON_DEBUG_MODE = "REG"
		PHOTON_DEBUG_LIGHT = Photon.Vehicles.Positions[ PHOTON_DEBUG_NAME ][ index ]
	end

end



hook.Add( "Think", "Photon.Debug.ButtonPress", function()

	if not PHOTON_DEBUG then return end
	if not PHOTON_DEBUG_NAME or PHOTON_DEBUG_NAME == "UNKNOWN" then return end

	local SHIFT = input.IsKeyDown( KEY_LSHIFT )
	local CTRL = input.IsKeyDown( KEY_LALT )
	local ALT = input.IsKeyDown( KEY_LCONTROL )

	local VEC_MODE = !PHOTON_DEBUG_VECTOR

	if input.IsKeyDown( KEY_UP ) then
		if P_UP == 0 or ( P_UP + GRACE_PRESS < CurTime() and SLIDE_INDEX + SLIDE_TIMER < CurTime() ) then
			if P_UP == 0 then P_UP = CurTime() end
			if VEC_MODE then
				if CTRL then -- use z
					if SHIFT then
						PhotonAdjustPosition( Vector( 0, 0, 1 ) )
					elseif ALT then
						PhotonAdjustPosition( Vector( 0, 0, .01 ) )
					else
						PhotonAdjustPosition( Vector( 0, 0, .1 ) )
					end
				else
					if SHIFT then -- use y
						PhotonAdjustPosition( Vector( 0, 1, 0 ) )
					elseif ALT then
						PhotonAdjustPosition( Vector( 0, .01, 0 ) )
					else
						PhotonAdjustPosition( Vector( 0, .1, 0 ) )
					end
				end
			else
				if CTRL then -- use z
					if SHIFT then
						PhotonAdjustAngle( Angle( 0, 0, 1 ) )
					elseif ALT then
						PhotonAdjustAngle( Angle( 0, 0, .01 ) )
					else
						PhotonAdjustAngle( Angle( 0, 0, .1 ) )
					end
				else
					if SHIFT then -- use y
						PhotonAdjustAngle( Angle( 0, 1, 0 ) )
					elseif ALT then
						PhotonAdjustAngle( Angle( 0, .01, 0 ) )
					else
						PhotonAdjustAngle( Angle( 0, .1, 0 ) )
					end
				end
			end
			SLIDE_INDEX = CurTime()
		end
	else
		if isnumber(P_UP) and P_UP > 0 then SLIDE_INDEX = 0 end
		P_UP = 0
	end

	if input.IsKeyDown( KEY_DOWN ) then
		if P_DOWN == 0 or P_DOWN + GRACE_PRESS < CurTime() and SLIDE_INDEX + SLIDE_TIMER < CurTime() then
			if P_DOWN == 0 then P_DOWN = CurTime() end
			if VEC_MODE then
				if CTRL then -- use z
					if SHIFT then
						PhotonAdjustPosition( Vector( 0, 0, -1 ) )
					elseif ALT then
						PhotonAdjustPosition( Vector( 0, 0, -.01 ) )
					else
						PhotonAdjustPosition( Vector( 0, 0, -.1 ) )
					end
				else
					if SHIFT then -- use y
						PhotonAdjustPosition( Vector( 0, -1, 0 ) )
					elseif ALT then
						PhotonAdjustPosition( Vector( 0, -.01, 0 ) )
					else
						PhotonAdjustPosition( Vector( 0, -.1, 0 ) )
					end
				end
			else
				if CTRL then -- use z
					if SHIFT then
						PhotonAdjustAngle( Angle( 0, 0, -1 ) )
					elseif ALT then
						PhotonAdjustAngle( Angle( 0, 0, -.01 ) )
					else
						PhotonAdjustAngle( Angle( 0, 0, -.1 ) )
					end
				else
					if SHIFT then -- use y
						PhotonAdjustAngle( Angle( 0, -1, 0 ) )
					elseif ALT then
						PhotonAdjustAngle( Angle( 0, -.01, 0 ) )
					else
						PhotonAdjustAngle( Angle( 0, -.1, 0 ) )
					end
				end
			end
			SLIDE_INDEX = CurTime()
		end
	else
		if isnumber(P_DOWN) and P_DOWN > 0 then SLIDE_INDEX = 0 end
		P_DOWN = 0
	end

	if input.IsKeyDown( KEY_LEFT ) then
		if P_LEFT == 0 or P_LEFT + GRACE_PRESS < CurTime() and SLIDE_INDEX + SLIDE_TIMER < CurTime() then
			if P_LEFT == 0 then P_LEFT = CurTime() end
			if VEC_MODE then
				if SHIFT then -- x
					PhotonAdjustPosition( Vector( -1, 0, 0 ) )
				elseif ALT then
					PhotonAdjustPosition( Vector( -.01, 0, 0 ) )
				else
					PhotonAdjustPosition( Vector( -.1, 0, 0 ) )
				end
			else
				if SHIFT then
					PhotonAdjustAngle( Angle( 1, 0, 0 ) )
				elseif ALT then
					PhotonAdjustAngle( Angle( .01, 0, 0 ) )
				else
					PhotonAdjustAngle( Angle( .1, 0, 0 ) )
				end
			end
			SLIDE_INDEX = CurTime()
		end
	else
		if isnumber(P_LEFT) and P_LEFT > 0 then SLIDE_INDEX = 0 end
		P_LEFT = 0
	end

	if input.IsKeyDown( KEY_RIGHT ) then
		if P_RIGHT == 0 or P_RIGHT + GRACE_PRESS < CurTime() and SLIDE_INDEX + SLIDE_TIMER < CurTime() then
			if P_RIGHT == 0 then P_RIGHT = CurTime() end
			if VEC_MODE then
				if SHIFT then -- x
					PhotonAdjustPosition( Vector( 1, 0, 0 ) )
				elseif ALT then
					PhotonAdjustPosition( Vector( .01, 0, 0 ) )
				else
					PhotonAdjustPosition( Vector( .1, 0, 0 ) )
				end
			else
				if SHIFT then
					PhotonAdjustAngle( Angle( -1, 0, 0 ) )
				elseif ALT then
					PhotonAdjustAngle( Angle( -.01, 0, 0 ) )
				else
					PhotonAdjustAngle( Angle( -.1, 0, 0 ) )
				end
			end
			SLIDE_INDEX = CurTime()
		end
	else
		if isnumber(P_RIGHT) and P_RIGHT > 0 then SLIDE_INDEX = 0 end
		P_RIGHT = 0
	end

	if input.IsKeyDown( KEY_PAD_MINUS ) and not P_KPMINUS then
		if !( not PHOTON_DEBUG_NAME or PHOTON_DEBUG_NAME == "UNKNOWN" ) then
			surface.PlaySound( EMVU.Sounds.Up )
			if PHOTON_DEBUG_MODE == "ELS" then
				local max = #EMVU.Positions[ PHOTON_DEBUG_NAME ]
				if PHOTON_DEBUG_INDEX <= 1 then 
					SetDebugTarget( max, "ELS" )
				else
					SetDebugTarget( PHOTON_DEBUG_INDEX - 1, "ELS" )
				end
			elseif PHOTON_DEBUG_MODE == "REG" then
				local max = #Photon.Vehicles.Positions[ PHOTON_DEBUG_NAME ]
				if PHOTON_DEBUG_INDEX <= 1 then 
					SetDebugTarget( max, "REG" )
				else
					SetDebugTarget( PHOTON_DEBUG_INDEX - 1, "REG" )
				end
			end
		end
		P_KPMINUS = true
	elseif not input.IsKeyDown( KEY_PAD_MINUS ) then
		P_KPMINUS = false
	end

	if input.IsKeyDown( KEY_PAD_PLUS ) and not P_KPPLUS then
		if !( not PHOTON_DEBUG_NAME or PHOTON_DEBUG_NAME == "UNKNOWN" ) then
			surface.PlaySound( EMVU.Sounds.Up )
			if PHOTON_DEBUG_MODE == "ELS" then
				local max = #EMVU.Positions[ PHOTON_DEBUG_NAME ]
				if PHOTON_DEBUG_INDEX >= max then 
					SetDebugTarget( 1, "ELS" )
				else
					SetDebugTarget( PHOTON_DEBUG_INDEX + 1, "ELS" )
				end
			elseif PHOTON_DEBUG_MODE == "REG" then
				local max = #Photon.Vehicles.Positions[ PHOTON_DEBUG_NAME ]
				if PHOTON_DEBUG_INDEX >= max then 
					SetDebugTarget( 1, "REG" )
				else
					SetDebugTarget( PHOTON_DEBUG_INDEX + 1, "REG" )
				end
			end
		end
		P_KPPLUS = true
	elseif not input.IsKeyDown( KEY_PAD_PLUS ) then
		P_KPPLUS = false
	end

	if input.IsKeyDown( KEY_PAD_MULTIPLY ) and not P_KPENTER then
		if !( not PHOTON_DEBUG_NAME or PHOTON_DEBUG_NAME == "UNKNOWN" ) then
			surface.PlaySound( EMVU.Sounds.Down )
			local lightVector = "Vector( " .. math.Round( PHOTON_DEBUG_LIGHT[1].x, 2 ) .. ", " .. math.Round( PHOTON_DEBUG_LIGHT[1].y, 2 ) .. ", " .. math.Round( PHOTON_DEBUG_LIGHT[1].z, 2 ) .. " )"
			local lightAngle = "Angle( " .. math.Round( PHOTON_DEBUG_LIGHT[2].p, 2 ) .. ", " .. math.Round( PHOTON_DEBUG_LIGHT[2].y, 2 ) .. ", " .. math.Round( PHOTON_DEBUG_LIGHT[2].r, 2 ) .. " )"
			local result = lightVector .. ", " .. lightAngle
			SetClipboardText( result )
			LocalPlayer():ChatPrint( "Copied to clipboard." )
		end
		P_KPENTER = true
	elseif not input.IsKeyDown( KEY_PAD_MULTIPLY ) then
		P_KPENTER = false
	end

	if input.IsKeyDown( KEY_PAD_DIVIDE ) and not P_KP_DIVIDE then
		if !( not PHOTON_DEBUG_NAME or PHOTON_DEBUG_NAME == "UNKNOWN" ) then
			surface.PlaySound( EMVU.Sounds.Up )
			PHOTON_DEBUG_VECTOR = !PHOTON_DEBUG_VECTOR
		end
		P_KP_DIVIDE = true
	elseif not input.IsKeyDown( KEY_PAD_DIVIDE ) then
		P_KP_DIVIDE = false
	end

end)

function PhotonDebugTarget( ply, args )

	if not args[1] then args[1] = "ELS"; print( "[Photon] Defaulting to ELS mode." ) return end
	local ent = ply:GetVehicle() or ply:GetEyeTrace().Entity
	if not IsValid( ent ) then return end
	PHOTON_DEBUG_TARGET = ent
	local lightTarget = 1

	print(tostring(ent))

	if not args[2] then
		if args[1] == "ELS" then
			local index = #EMVU.Positions[ ent.VehicleName ]
			SetDebugTarget( index, "ELS" )
		elseif args[1] == "REG" then
			local index = #Photon.Vehicles.Positions[ ent.VehicleName ]
			SetDebugTarget( index, "REG" )
		else
			print( "Argument ")
		end
	else
		SetDebugTarget( args[1], args[2] )
	end

end

concommand.Add( "photon_debugtarget", function( ply, cmd, args ) 
	PhotonDebugTarget( ply, args )
end)

concommand.Add( "photon_debug", function( ply, cmd, args )
	if not ply:IsAdmin() then return end
	PHOTON_DEBUG = !PHOTON_DEBUG
	if PHOTON_DEBUG then
		ply:ChatPrint( "[Photon] Debug mode enabled." )
	else
		ply:ChatPrint( "[Photon] Debug mode disabled.")
	end
end)

surface.CreateFont( "PHOTON_Debug", {
	font = "Consolas",
	size = 16,
	weight = 900, 
	antialias = true
} )

hook.Add( "PostDrawHUD", "Photon.Debug.HUDPaint", function()
	if not PHOTON_DEBUG then return end
	draw.DrawText( "PHOTON DEBUG MODE ON", "PHOTON_Debug", ScrW() - 16, 17, Color( 0, 0, 0 ), TEXT_ALIGN_RIGHT )
	draw.DrawText( "PHOTON DEBUG MODE ON", "PHOTON_Debug", ScrW() - 16, 16, Color( 255, 200, 100 ), TEXT_ALIGN_RIGHT )

	if PHOTON_DEBUG_LIGHT then
		local lightVector = "Vector( " .. math.Round( PHOTON_DEBUG_LIGHT[1].x, 2 ) .. ", " .. math.Round( PHOTON_DEBUG_LIGHT[1].y, 2 ) .. ", " .. math.Round( PHOTON_DEBUG_LIGHT[1].z, 2 ) .. " )"
		local lightAngle = "Angle( " .. math.Round( PHOTON_DEBUG_LIGHT[2].p, 2 ) .. ", " .. math.Round( PHOTON_DEBUG_LIGHT[2].y, 2 ) .. ", " .. math.Round( PHOTON_DEBUG_LIGHT[2].r, 2 ) .. " )"
		local vehicleName = PHOTON_DEBUG_NAME or "UNKNOWN"
		local lightIndex = "INDEX [" .. PHOTON_DEBUG_MODE .. "]: " .. PHOTON_DEBUG_INDEX
		local angColor = Color( 255, 255, 255, 255 )
		local vecColor = Color( 255, 255, 255, 255 )
		if !PHOTON_DEBUG_VECTOR then
			angColor.a = 100
		else
			vecColor.a = 100
		end
		draw.DrawText( lightVector, "PHOTON_Debug", ScrW() - 16, 41, Color( 0, 0, 0 ), TEXT_ALIGN_RIGHT )
		draw.DrawText( lightVector, "PHOTON_Debug", ScrW() - 16, 40, vecColor, TEXT_ALIGN_RIGHT )
		draw.DrawText( lightAngle, "PHOTON_Debug", ScrW() - 16, 58, Color( 0, 0, 0 ), TEXT_ALIGN_RIGHT )
		draw.DrawText( lightAngle, "PHOTON_Debug", ScrW() - 16, 57, angColor, TEXT_ALIGN_RIGHT )
		draw.DrawText( vehicleName, "PHOTON_Debug", ScrW() - 16, 81, Color( 0, 0, 0 ), TEXT_ALIGN_RIGHT )
		draw.DrawText( vehicleName, "PHOTON_Debug", ScrW() - 16, 80, Color( 100, 200, 255 ), TEXT_ALIGN_RIGHT )
		draw.DrawText( lightIndex, "PHOTON_Debug", ScrW() - 16, 98, Color( 0, 0, 0 ), TEXT_ALIGN_RIGHT )
		draw.DrawText( lightIndex, "PHOTON_Debug", ScrW() - 16, 97, Color( 100, 200, 255 ), TEXT_ALIGN_RIGHT )
	end
end)

concommand.Add("photon_debug_bg", function( ply )
	if not ply:IsAdmin() then return end
	local vehicle = ply:GetVehicle()
	if not vehicle then return end
	PrintTable( vehicle:GetBodyGroups() )
end)