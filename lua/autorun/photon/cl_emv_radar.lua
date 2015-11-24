AddCSLuaFile()

EMVU.VehicleRadar = {}

local sPos, ePos

EMVU.VehicleRadar.AcquireTarget = function( rear )
	local curVehicle = LocalPlayer():GetVehicle()
	if not IsValid( curVehicle ) or not curVehicle:IsEMV() then return false end
	local normDirection = curVehicle:GetForward()
	if rear then normDirection:Rotate( Angle( 0, -90, 0 ) ) else normDirection:Rotate( Angle( 0, 90, 0 ) ) end
	
	print(tostring(normDirection))
	//debugoverlay.Line( curVehicle:GetPos(), curVehicle:GetPos() * ( normDirection * 10), 5, Color(0,255,0), true )
	local startPos = curVehicle:GetPos()
	startPos.z = startPos.z + 60
	local catchEnts = ents.FindInCone( startPos, normDirection, 2048, 0 )
	local foundTarget, targSpeed
	for _, ent in pairs( catchEnts ) do
		if IsValid( ent ) and ent:IsVehicle() and ent != curVehicle then
			debugoverlay.Line( ent:GetPos(), curVehicle:GetPos(), 5, Color(255,0,0), true )
			local thisSpeed = ent:Photon_AdjustedSpeed()
			if not IsValid( foundTarget ) then 
				foundTarget = ent
				targSpeed = thisSpeed
			else
				if thisSpeed < targSpeed then
					foundTarget = ent
					targSpeed = thisSpeed
				end
			end
		end
	end
	if foundTarget and IsValid( foundTarget ) then return foundTarget, targSpeed, curVehicle end
	return false, false
end

EMVU.VehicleRadar.LockTarget = function( ent )
	EMVU.VehicleRadar.TargetEnt = ent
end

EMVU.VehicleRadar.AutoTarget = function()
	local target, speed, originCar = EMVU.VehicleRadar.AcquireTarget()
	if target then EMVU.VehicleRadar.LockTarget( target ) end
	if IsValid( originCar ) then EMVU.VehicleRadar.OriginCar = originCar end
	return target, speed
end

EMVU.VehicleRadar.GetTargetSpeed = function()
	if not EMVU.VehicleRadar.SoundHandle then
		sound.PlayFile( "sound/emv/radar_flat.wav", "3d", EMVU.VehicleRadar.SoundCBack )
	end
	if IsValid( EMVU.VehicleRadar.TargetEnt ) then return EMVU.VehicleRadar.TargetEnt:Photon_AdjustedSpeed() end
	return 0
end

EMVU.VehicleRadar.SoundCBack = function( snd )
	if IsValid( snd ) then
		//snd:Pause()
		print("working")
		EMVU.VehicleRadar.SoundHandle = snd
	end
end

concommand.Add( "photon_radartarg", function() 
	
	photonTargTest()
end )

function photonTargTest()
	local target, speed = EMVU.VehicleRadar.AutoTarget()
	if target and speed then print( "Target acquired, speed: " .. tostring( speed ) ) end
end
//photonTargTest()

hook.Add( "Tick", "Photon.TargetSpeed", function()
	//render.DrawLine()
	-- if EMVU.VehicleRadar.GetTargetSpeed() > 1 then
	-- 	LocalPlayer():ChatPrint( "Target vehicle speed: " .. EMVU.VehicleRadar.GetTargetSpeed() )
	-- 	if IsValid( EMVU.VehicleRadar.SoundHandle ) then
	-- 		EMVU.VehicleRadar.SoundHandle:Play()
	-- 		if IsValid( EMVU.VehicleRadar.OriginCar ) then EMVU.VehicleRadar.SoundHandle:SetPos( EMVU.VehicleRadar.OriginCar:GetPos() ) end
	-- 		local result = ( math.Round(EMVU.VehicleRadar.GetTargetSpeed() / 10) / 10 ) + .5
	-- 		if result > 0 then EMVU.VehicleRadar.SoundHandle:SetPlaybackRate( result ) end
	-- 	end
	-- else
	-- 	if IsValid( EMVU.VehicleRadar.SoundHandle ) then
	-- 		EMVU.VehicleRadar.SoundHandle:Pause()
	-- 	end
	-- end
end )
