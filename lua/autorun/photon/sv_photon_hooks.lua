
function Photon:RunningScan()
	for k,v in pairs( self:AllVehicles() ) do
		if IsValid( v ) and IsValid(v:GetDriver()) and v:GetDriver():IsPlayer() then
			if v:IsBraking() then v:CAR_Braking(true) else v:CAR_Braking(false) end
			if v:IsReversing() then v:CAR_Reversing(true) else v:CAR_Reversing(false) end
		end
	end
end

hook.Add("PlayerEnteredVehicle", "Photon.EnterVeh.SGM", function(ply, v)
	if IsValid(v) then
		local hasELS = v:HasPhotonELS()
		if hasELS and v.ELS.Blackout then
			v:CAR_Running(false)
		else
			v:CAR_Running(true)
		end
		if hasELS then v:ELS_ParkMode(false) end
	end
end)

hook.Add("PlayerLeaveVehicle", "Photon.LeaveVeh.SGM", function(ply, v)
	if IsValid(v) then
		local hasELS = v:HasPhotonELS()
		if hasELS then v:ELS_ParkMode(true) end
		v:CAR_Running(false)
		v:CAR_Braking(false)
		v:CAR_Reversing(false)
		if hasELS then
			if v:ELS_Siren() then v:ELS_SirenOff() end
			v:ELS_Horn(false)
			v:ELS_ManualSiren(false)
		end
	end
end)

hook.Add("KeyPress", "Photon.KeyPress.SGM", function(ply, key)
	local v = ply:GetVehicle()
	if IsValid(v) then
		if v:IsBraking() then v:CAR_Braking(true) else v:CAR_Braking(false) end
		if v:IsReversing() then v:CAR_Reversing(true) else v:CAR_Reversing(false) end
	end
end)

hook.Add("KeyRelease", "Photon.KeyRelease.SGM", function(ply, key)
	local v = ply:GetVehicle()
	if IsValid(v) then
		if v:IsBraking() then v:CAR_Braking(true) else v:CAR_Braking(false) end
		if v:IsReversing() then v:CAR_Reversing(true) else v:CAR_Reversing(false) end
	end
end)

timer.Create("Photon.RunScan", 0.5, 0, function()
	Photon:RunningScan()
end)
timer.Create("Photon.SirenRunScan", 0.2, 0, function()
	for _,car in pairs( Photon:AllVehicles() ) do
		if car:HasPhotonELS() and car:ELS_Siren() then car:ELS_SirenContinue() end
	end
end)

function Photon:VehicleRemoved( ent )
	if IsValid( ent ) and ent:IsVehicle() and ent:HasPhotonELS() then
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
	local veh = ply:GetVehicle()
	PrintTable( veh:GetMaterials() )
end)

hook.Add( "Photon.EntityChangedSkin", "Photon.LiverySkinCheck", function( ent, skin )
	if IsValid( ent ) and ent:IsEMV() and ent:Photon_GetLiveryID() != "" and skin > 0 then
		ent:Photon_SetLiveryId("")
	end
end )

hook.Add( "Photon.CanPlayerModify", "Photon.DefaultModifyCheck", function( ply, ent )
	if not IsValid( ent ) then return false end
	local isDriver = ( ply:GetVehicle() == ent )
	local isOwner = ( ent:GetOwner() == ply )
	local spawner = ent.PhotonVehicleSpawner
	local isSpawner = ( IsValid( spawner ) and ( spawner == ply ) )
	if isDriver or ply == isOwner or game.SinglePlayer() or isSpawner then
		return true
	else
		return false
	end
end )

local function PhotonUnitNumberScan()
	for _,ent in pairs( EMVU:AllVehicles() ) do
		if not IsValid( ent ) then continue end
		if not IsValid( ent:GetDriver() ) then continue end
		local ply = ent:GetDriver()
		if ( ent:Photon_GetLiveryID() == "" and ( (not ent.PhotonUnitIDRequestTime) or ( RealTime() < ent.PhotonUnitIDRequestTime + 10 ) ) ) then
			Photon.Net:RequestUnitNumber( ply )
			ent.PhotonUnitIDRequestTime = RealTime()
		end
	end
end
timer.Create( "Photon.UnitNumberScan", 2, 0, function()
	PhotonUnitNumberScan()
end )

hook.Add( "PlayerSpawnedVehicle", "Photon.PlayerVehicleSpawn", function( ply, ent )
	ent.PhotonVehicleSpawner = ply
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
