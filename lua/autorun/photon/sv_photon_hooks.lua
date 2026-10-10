
local function ScanRunningVehicle( v )
	local driver = Photon.GetVehicleDriver(v)
	if IsValid( driver ) and driver:IsPlayer() and v:Photon() then
		if v:IsBraking() then v:CAR_Braking(true) else v:CAR_Braking(false) end
		if v:IsReversing() then v:CAR_Reversing(true) else v:CAR_Reversing(false) end
	end
end

local function ScanGlideVehicleLights( v )
	if not Photon.IsGlideVehicle(v) then return end
	-- ELS-only packs (no Photon = "PHOTON_INHERIT") never get SetupCar / Photon(),
	-- but still need native headlight sync and ELS flash.
	if not v:Photon() and not (v.HasPhotonELS and v:HasPhotonELS()) then return end
	local driver = Photon.GetVehicleDriver(v)
	if not IsValid(driver) or not driver:IsPlayer() then return end
	-- Sync first so Blackout tracks Glide (including auto-headlights) before ELS flash.
	Photon.SyncPhotonBlackoutFromGlide(v)
	Photon.ApplyGlideELSHeadlights(v)
end

function Photon:RunningScan()
	for k,v in pairs( self:AllVehicles() ) do
		if IsValid( v ) then Photon.RunQuarantined( v, ScanRunningVehicle ) end
	end
end
function Photon:GlideLightScan()
	for _, v in pairs( self:AllVehicles() ) do
		if IsValid( v ) then Photon.RunQuarantined( v, ScanGlideVehicleLights ) end
	end
end

-- Glide passengers sit in seats parented to the chassis, so they resolve to it
-- too. Only the driver's seat getting in or out should change its state.
local function IsGlidePassengerSeat(seat, vehicle)
	return vehicle ~= seat and seat.GlideSeatIndex ~= 1
end

hook.Add("PlayerEnteredVehicle", "Photon.EnterVeh.SGM", function(ply, seat)
	local v = Photon.GetVehicleEntity(seat)
	if IsGlidePassengerSeat(seat, v) then return end
	if IsValid(v) then
		if v:Photon() and isfunction(v.CAR_Running) and isfunction(v.CAR_IsBlackedOut) then
			v:CAR_Running(not v:CAR_IsBlackedOut())
		end
		if v:HasPhotonELS() then
			v:ELS_ParkMode(false)
		end
	end
end)

hook.Add("PlayerLeaveVehicle", "Photon.LeaveVeh.SGM", function(ply, seat)
  local v = Photon.GetVehicleEntity(seat)
  if IsGlidePassengerSeat(seat, v) then return end
  if IsValid(v) then
    if v:Photon() then
      if isfunction(v.CAR_Running) then v:CAR_Running(false) end
      if isfunction(v.CAR_Braking) then v:CAR_Braking(false) end
      if isfunction(v.CAR_Reversing) then v:CAR_Reversing(false) end
    end

    if v:HasPhotonELS() then
      if v:ELS_Siren() and not v:GetPhotonLEStayOn() then
        v:ELS_SirenOff()
      end
	  v:ELS_ParkMode(true)
      v:ELS_Horn(false)
      v:ELS_ManualSiren(false)
    end
  end
end)

hook.Add("KeyPress", "Photon.KeyPress.SGM", function(ply, key)
	local v = Photon.GetPlayerVehicle(ply)
	if IsValid(v) and v:Photon() then
		if v:IsBraking() then v:CAR_Braking(true) else v:CAR_Braking(false) end
		if v:IsReversing() then v:CAR_Reversing(true) else v:CAR_Reversing(false) end
	end
end)

hook.Add("KeyRelease", "Photon.KeyRelease.SGM", function(ply, key)
	local v = Photon.GetPlayerVehicle(ply)
	if IsValid(v) and v:Photon() then
		if v:IsBraking() then v:CAR_Braking(true) else v:CAR_Braking(false) end
		if v:IsReversing() then v:CAR_Reversing(true) else v:CAR_Reversing(false) end
	end
end)

timer.Create("Photon.RunScan", 0.5, 0, function()
	Photon:RunningScan()
end)

-- Faster than RunningScan so ELS headlight flash is visible (~2.5 Hz).
timer.Create("Photon.GlideLightScan", 0.1, 0, function()
	Photon:GlideLightScan()
end)

local function ContinueVehicleSiren( car )
	if car:HasPhotonELS() and car:ELS_Siren() then car:ELS_SirenContinue() end
end
timer.Create("Photon.SirenRunScan", 0.2, 0, function()
	for _,car in pairs( Photon:AllVehicles() ) do
		if IsValid( car ) then Photon.RunQuarantined( car, ContinueVehicleSiren ) end
	end
end)

function Photon:VehicleRemoved( ent )
	if IsValid( ent ) and Photon.IsPhotonChassis(ent) and ent:HasPhotonELS() then
		if ent.ELS.Manual then ent.ELS.Manual:Stop() end
		ent:ELS_SirenOff()
		ent:ELS_Horn( false )
		ent:ELS_ManualSiren( false )
	end
end
hook.Add("EntityRemoved", "Photon.VehicleRemoved", function(e)
	Photon:VehicleRemoved( e )
end)

hook.Add( "PlayerInitialSpawn", "Photon.InitialNotify", function( ply )
	ply:ChatPrint( string.format( "Photon Lighting Engine (%s #%s) is active. Type !photon or press C and click Photon for help and information.", tostring( PHOTON_SERIES), tostring(PHOTON_UPDATE) ) )
	-- Photon.Net.SendAvailableLiveries( ply )
end)

-- dev functions --

concommand.Add( "photon_mat", function( ply, cmd, args )
	local veh = Photon.GetPlayerVehicle(ply)
	if not IsValid(veh) then return end
	PrintTable( veh:GetMaterials() )
end)

hook.Add( "Photon.EntityChangedSkin", "Photon.LiverySkinCheck", function( ent, skin )
	if IsValid( ent ) and ent:IsEMV() and ent:Photon_GetLiveryID() != "" and skin > 0 then
		ent:Photon_SetLiveryId("")
	end
end )

hook.Add( "Photon.CanPlayerModify", "Photon.DefaultModifyCheck", function( ply, ent )
	if not IsValid( ent ) then return false end
	local isDriver = ( Photon.GetPlayerVehicle(ply) == ent )
	local isOwner = ( ent:GetOwner() == ply )
	local spawner = ent.PhotonVehicleSpawner
	local isSpawner = ( IsValid( spawner ) and ( spawner == ply ) )
	if isDriver or ply == isOwner or game.SinglePlayer() or isSpawner then
		return true
	else
		return false
	end
end )

local function ScanVehicleUnitNumber( ent )
	local ply = Photon.GetVehicleDriver(ent)
	if not IsValid( ply ) then return end
	if ( ent:Photon_GetLiveryID() == "" and ( (not ent.PhotonUnitIDRequestTime) or ( RealTime() < ent.PhotonUnitIDRequestTime + 10 ) ) ) then
		Photon.Net:RequestUnitNumber( ply )
		ent.PhotonUnitIDRequestTime = RealTime()
	end
end

local function PhotonUnitNumberScan()
	for _,ent in pairs( EMVU:AllVehicles() ) do
		if IsValid( ent ) then Photon.RunQuarantined( ent, ScanVehicleUnitNumber ) end
	end
end
timer.Create( "Photon.UnitNumberScan", 2, 0, function()
	PhotonUnitNumberScan()
end )

hook.Add( "PlayerSpawnedVehicle", "Photon.PlayerVehicleSpawn", function( ply, ent )
	ent.PhotonVehicleSpawner = ply
end)

hook.Add( "PlayerSpawnedSENT", "Photon.PlayerGlideSpawn", function( ply, ent )
	if Photon.IsGlideVehicle(ent) then
		ent.PhotonVehicleSpawner = ply
	end
end)

-- Photon.AutoSkins.FetchSkins = function( id )
-- 	local result = {}
-- 	local baseDir = "materials/" .. tostring(id) .. "_liveries/"
-- 	local files = file.Find( baseDir .. "*.vmt", "GAME" )
-- 	result["/"] = {}
-- 	for _,foundFile in pairs( files ) do
-- 		result["/"][ #result["/"] + 1 ] = foundFile
-- 	end
-- 	local _,dirs = file.Find( baseDir .. "*", "GAME" )
-- 	for _,foundDir in pairs( dirs ) do
-- 		if not result[foundDir] then result[foundDir] = {} end
-- 		local subFiles = file.Find( baseDir .. foundDir .. "/*.vmt", "GAME" )
-- 		for __,foundFile in pairs( subFiles ) do
-- 			result[foundDir][ #result[foundDir] + 1 ] = foundFile
-- 		end
-- 	end
-- 	return result, baseDir
-- end

-- Photon.AutoSkins.ParseSkins = function( id )
-- 	local fileTable, baseDir = Photon.AutoSkins.FetchSkins( id )
-- 	local result = {}
-- 	for key,subFiles in pairs( fileTable ) do
-- 		if key == "/" then
-- 			result["/"] = {}
-- 			local newKey = key
-- 			for _,mat in pairs( subFiles ) do
-- 				result[ newKey ][ #result[ newKey ] + 1 ] = {}
-- 				local matInfo = result[ newKey ][ #result[ newKey ] ]
-- 				matInfo.Name = string.Replace( string.Replace( mat, "_", " " ), ".vmt", "" )
-- 				matInfo.Texture = string.format( "%s%s/%s", string.Replace( baseDir, "materials/", "" ), key, string.StripExtension( mat ) )
-- 			end
-- 		else
-- 			local newKey = string.Replace( key, "_", " ")
-- 			result[ newKey ] = {}
-- 			for _,mat in pairs( subFiles ) do
-- 				result[ newKey ][ #result[ newKey ] + 1 ] = {}
-- 				local matInfo = result[ newKey ][ #result[ newKey ] ]
-- 				matInfo.Name = string.Replace( string.Replace( mat, "_", " " ), ".vmt", "" )
-- 				matInfo.Texture = string.format( "%s%s/%s", string.Replace( baseDir, "materials/", "" ), key, string.StripExtension( mat ) )
-- 			end
-- 		end
-- 	end
-- 	return result
-- end

-- Photon.AutoSkins.LoadAvailable = function()
-- 	if not istable( Photon.AutoSkins.TranslationTable ) then return end
-- 	for _,id in pairs( Photon.AutoSkins.TranslationTable ) do
-- 		local skinTable = Photon.AutoSkins.ParseSkins( id )
-- 		Photon.AutoSkins.Available[id] = skinTable
-- 	end
-- end

-- hook.Add( "InitPostEntity", "Photon.LoadAvailableMaterials", function() Photon.AutoSkins.LoadAvailable() end )

concommand.Add("photon_components", function(ply, str, args, argStr)
	local print = IsValid(ply) and function(...) ply:ChatPrint(...) end or print
	local access = game.SinglePlayer() or not IsValid(ply) or ply:IsAdmin()
	if not access then
		print("You must be in single-player or an admin to access this command.")
		return
	end

	for _, component in pairs(EMVU.Auto) do
		print(component.Name)
		if component.Source then
			print("\tSource: " .. component.Source)
		end
	end
end)
