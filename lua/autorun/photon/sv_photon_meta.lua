
function Photon:SetupCar( ent, index )
	// whether car headlights are on or off
	function ent:CAR_Headlights( val )
		if not IsValid( self ) then return false end
		if (val!=nil) then self:SetNW2Bool( "PhotonLE.CAR_HEADLIGHTS", val ) end
		return self:GetNW2Bool("PhotonLE.CAR_HEADLIGHTS")

	end

	-- if car is braking
	function ent:CAR_Braking( val )
		if not IsValid( self ) then return false end
		if (val!=nil) then self:SetNW2Bool( "PhotonLE.CAR_BRAKING", val ) end
		return self:GetNW2Bool( "PhotonLE.CAR_BRAKING" )

	end

	-- car reversing
	function ent:CAR_Reversing( val )
		if not IsValid( self ) then return false end
		if (val!=nil) then self:SetNW2Bool( "PhotonLE.CAR_REVERSING", val ) end
		return self:GetNW2Bool( "PhotonLE.CAR_REVERSING" )

	end

	function ent:CAR_Running( val )
		if not IsValid( self ) then return false end
		if (val!=nil) then self:SetNW2Bool( "PhotonLE.CAR_RUNNING", val ) end
		return self:GetNW2Bool( "PhotonLE.CAR_RUNNING" )

	end

	function ent:CAR_Signal( val )
		if not IsValid( self ) then return 0 end
		if (val!=nil) then self:SetNW2Int( "PhotonLE.CAR_BLINKER", val ) end
		return self:GetNW2Int( "PhotonLE.CAR_BLINKER" )

	end

	function ent:CAR_TurnLeft( val )
		if not IsValid( self ) then return false end
		if (val!=nil) then self:CAR_Signal( CAR_TURNING_LEFT ) end
		return self:CAR_Signal() == CAR_TURNING_LEFT

	end

	function ent:CAR_TurnRight( val )
		if not IsValid( self ) then return false end
		if (val!=nil) then self:CAR_Signal( CAR_TURNING_RIGHT ) end
		return self:CAR_Signal() == CAR_TURNING_RIGHT

	end

	function ent:CAR_Hazards( val )
		if not IsValid( self ) then return false end
		if (val!=nil) then self:CAR_Signal( CAR_HAZARD ) end
		return self:CAR_Signal() == CAR_HAZARD

	end

	function ent:CAR_StopSignals()
		if not IsValid( self ) then return false end
		self:CAR_Signal( 0 )
	end

	function ent:IsBraking( )
		if not IsValid( self ) then return false end
		if self:IsReversing() then return false end
		--local speed = self:GetPhysicsObject():GetVelocity():Length()
		local vel = self:WorldToLocal(self:GetVelocity()+self:GetPos())
		if (self:GetDriver():KeyDown( IN_BACK ) and vel.y > 1) or (self:GetDriver():KeyDown( IN_FORWARD ) and vel.y < -1) or self:GetDriver():KeyDown( IN_JUMP ) then
			return true
		end
		return false
	end

	function ent:IsReversing()
		if not IsValid( self ) then return false end
		if self:GetDriver() and self:GetDriver():IsValid() and self:GetDriver():IsPlayer() then
			local ply = self:GetDriver()
			local vel = self:WorldToLocal(self:GetVelocity()+self:GetPos())
			if (vel.y < 1 and ply:KeyDown( IN_BACK )) then
				return true
			end
		end
		return false
	end

	function ent:GetPhotonLEStayOn()
		if GetConVar("photon_emv_stayon"):GetBool() then return true end
		return self:GetNW2Bool("PhotonLEStayOn", false)
	end
	function ent:SetPhotonLEStayOn(val)
		return self:SetNW2Bool("PhotonLEStayOn", val)
	end

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

	ent:CAR_Headlights( false )
	ent:CAR_Braking( false )
	ent:CAR_Running( false )
	ent:CAR_Reversing( false )
	ent:CAR_StopSignals()
	if ent:Photon_WheelEnabled() then ent:Photon_SetWheelIndex( 1 ) end

	-- ent:SetNWString( "PhotonVehicle", index )
	ent:SetNW2Bool( "PhotonLE.CAR_HAS_PHOTON", true )

end