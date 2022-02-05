
function Photon:SetupCar( ent, index )
	ent:SetPhotonNet_Headlights( false )
	ent:SetPhotonNet_Braking( false )
	ent:SetPhotonNet_Running( false )
	ent:SetPhotonNet_Reversing( false )
	ent:Photon_SignalStop()

	if ent:Photon_WheelEnabled() then
		ent:Photon_SetWheelIndex( 1 )
	end

	-- ent:SetNWString( "PhotonVehicle", index )
	ent:SetNW2Bool( "PhotonLE.CAR_HAS_PHOTON", true )
end
