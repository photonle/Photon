
function Photon:SetupCar( ent, index )
	// whether car headlights are on or off
	function ent:CAR_Headlights( val )
		if not IsValid( self ) then return false end
		if (val!=nil) then self:SetDTBool( CAR_HEADLIGHTS, val ) end
		return self:GetDTBool(CAR_HEADLIGHTS)

	end

	// if car is braking
	function ent:CAR_Braking( val )
		if not IsValid( self ) then return false end
		if (val!=nil) then self:SetDTBool( CAR_BRAKING, val ) end
		return self:GetDTBool( CAR_BRAKING )

	end

	// car reversing
	function ent:CAR_Reversing( val )
		if not IsValid( self ) then return false end
		if (val!=nil) then self:SetDTBool( CAR_REVERSING, val ) end
		return self:GetDTBool( CAR_REVERSING )

	end

	function ent:CAR_Running( val )
		if not IsValid( self ) then return false end
		if (val!=nil) then self:SetDTBool( CAR_RUNNING, val ) end
		return self:GetDTBool( CAR_RUNNING )

	end

	function ent:CAR_Signal( val )
		if not IsValid( self ) then return 0 end
		if (val!=nil) then self:SetDTInt( CAR_BLINKER, val ) end
		return self:GetDTInt( CAR_BLINKER )

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
		local speed = self:GetPhysicsObject():GetVelocity():Length()
		if not self.LastSpeed then self.LastSpeed = speed return false end
		if (self.LastSpeed - speed) >= 0 and ( self:GetDriver():KeyDown( IN_BACK ) and not self:IsReversing() ) or ( self:GetDriver():KeyDown( IN_BACK) and self:Photon_AdjustedSpeed() < 2 ) or self:GetDriver():KeyDown( IN_JUMP ) then 
			return true
		end
		return false
	end

	function ent:IsReversing()
		if not IsValid( self ) then return false end
		if self:GetDriver() and self:GetDriver():IsValid() and self:GetDriver():IsPlayer() then
			local ply = self:GetDriver()
			local velocity = self:GetPhysicsObject():GetVelocity()
			velocity:Normalize()
			local direction = self:GetForward()
			local sum = Vector()
			sum.x = velocity.x * direction.x
			sum.y = velocity.y * direction.y
			if not (sum.x >= 0 and sum.y >= 0) then 
				if (ply:KeyDown( IN_BACK ) and (ent:Photon_AdjustedSpeed() > 10)) and not ply:KeyDown( IN_JUMP ) then return true end
			end
		end
		return false
	end

	function ent:StayOn( val )
		if val != nil then self:SetNWBool( "PhotonStayOn", val ) end
		return self:GetNWBool( "PhotonStayOn", false )
	end

	ent:CAR_Headlights( false )
	ent:CAR_Braking( false )
	ent:CAR_Running( false )
	ent:CAR_Reversing( false )
	ent:CAR_StopSignals()

	ent:SetNWString( "PhotonVehicle", index )

end