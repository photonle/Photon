
function Photon:SetupCar( ent, index )
	function ent:Photon_WheelEnabled()
		return istable( Photon.Vehicles.WheelPositions[ self.VehicleName ] ) and istable( Photon.Vehicles.WheelOptions[ self.VehicleName ] )
	end

	function ent:Photon_PlayerSetWheelIndex( val )
		if not self:Photon_WheelEnabled() then return false end
		local max = #Photon.Vehicles.WheelOptions[ self.VehicleName ]
		if val > max then val = 1 end
		self:Photon_SetWheelIndex( val )
	end

	function ent:Photon_SetWheelIndex( val )
		if not IsValid( self ) then return 0 end
		if (val!=nil) then self:SetNW2Int( "PhotonLE.CAR_WHEEL_OPTION", val ) end
		return self:GetNW2Int( "PhotonLE.CAR_WHEEL_OPTION" )
	end

	ent:SetPhotonNet_Headlights( false )
	ent:SetPhotonNet_Braking( false )
	ent:SetPhotonNet_Running( false )
	ent:SetPhotonNet_Reversing( false )
	ent:Photon_SignalStop()

	if ent:Photon_WheelEnabled() then ent:Photon_SetWheelIndex( 1 ) end

	-- ent:SetNWString( "PhotonVehicle", index )
	ent:SetNW2Bool( "PhotonLE.CAR_HAS_PHOTON", true )

end