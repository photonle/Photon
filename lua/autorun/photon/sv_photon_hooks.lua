
function Photon:RunningScan()
	for k,v in pairs( ents.GetAll() ) do
		if IsValid( v ) and v:Photon() and v:GetDriver():IsValid() and v:GetDriver():IsPlayer() then

			if v:HasELS() and v.ELS.Blackout then 
				v:CAR_Running( false )
			else
				v:CAR_Running( true )
			end

			if v:HasELS() and v:ELS_Siren() then v:ELS_SirenContinue() end

			if v:IsBraking() then v:CAR_Braking( true ) else v:CAR_Braking( false ) end
			if v:IsReversing() then v:CAR_Reversing( true ) else v:CAR_Reversing( false ) end

			v.LastSpeed = v:Photon_GetSpeed()

		elseif v:Photon() and not v:GetDriver():IsValid() and not v:GetDriver():IsPlayer() and not v:StayOn() then
			v:CAR_Running( false )
			v:CAR_Braking( false )
			v:CAR_Reversing( false )
			if v:HasELS() then
				if v:ELS_Siren() then v:ELS_SirenOff() end
				v:ELS_Horn( false )
				v:ELS_ManualSiren( false )
			end
		end
	end

end

hook.Add( "Think", "Photon.RunScan", function()
	Photon:RunningScan()
end)

function Photon:VehicleRemoved( ent )
	if IsValid( ent ) and ent:IsVehicle() and ent:HasELS() then
		ent:ELS_SirenOff()
		ent:ELS_Horn( false )
		ent:ELS_ManualSiren( false )
	end
end
hook.Add("EntityRemoved", "Photon.VehicleRemoved", function(e)
	Photon:VehicleRemoved( e )
end)

hook.Add( "PlayerInitialSpawn", "Photon.InitialNotify", function( ply )
	ply:ChatPrint( "Photon Lighting Engine [Beta] is active. Type !photon for help and information." )
end)