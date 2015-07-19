AddCSLuaFile()

local PhotonColors = nil
if EMVU and EMVU.Colors then PhotonColors = EMVU.Colors end
hook.Add( "Initialize", "Photon.LocalColorSet", function() PhotonColors = EMVU.Colors; end )

function Photon:SetupCar( ent, index )

	ent.VehicleName = index

	function ent:HeadlightsOn()
		if not IsValid( self ) then return false end
		return self:GetDTBool( CAR_HEADLIGHTS )
	end

	function ent:IsBraking()
		if not IsValid( self ) then return false end
		return self:GetDTBool( CAR_BRAKING )
	end

	function ent:IsReversing()
		if not IsValid( self ) then return false end
		return self:GetDTBool( CAR_REVERSING )
	end

	function ent:IsRunning()
		if not IsValid( self ) then return false end
		return self:GetDTBool( CAR_RUNNING )
	end

	function ent:BlinkState()
		if not IsValid( self ) then return 0 end
		return self:GetDTInt( CAR_BLINKER )
	end

	function ent:TurningLeft()
		if not IsValid( self ) then return false end
		return self:BlinkState() == CAR_TURNING_LEFT
	end

	function ent:TurningRight()
		if not IsValid( self ) then return false end
		return self:BlinkState() == CAR_TURNING_RIGHT
	end

	function ent:Hazards()
		if not IsValid( self ) then return false end
		return self:BlinkState() == CAR_HAZARD
	end

	function ent:SetupCarVisHandles()
		if not IsValid( self ) or not self.GetLightingPositions then return false end
		//if not self.GetLightingPositions() or not self:GetLightingPositions() then return end
		for k,v in pairs( self:GetLightingPositions() ) do
			self.Lighting.Handles[k] = util.GetPixelVisibleHandle()
		end
	end

	function ent:GetLightingPositions()
		if not IsValid( self ) then return false end
		return Photon.Vehicles.Positions[self.VehicleName]
	end

	function ent:GetLightingMeta()
		if not IsValid( self ) then return false end
		return Photon.Vehicles.Meta[self.VehicleName]
	end

	function ent:DisconnectLight( index )

		if not IsValid( self ) then return false end
		//local disconnectTable = { true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true }
		if not table.HasValue( self.Lighting.Disconnected, index ) then
			table.insert( self.Lighting.Disconnected, index )
		end
	end

	function ent:GetLightingConfig()
		if not IsValid( self ) then return false end
		if Photon.Vehicles.Config[self.VehicleName] then
			return Photon.Vehicles.Config[self.VehicleName]
		end
		return false
	end

	function ent:GetBlinkRate()
		if not IsValid( self ) then return PHO_DEFAULT_BLINK end
		if self:GetLightingConfig() and isnumber(self:GetLightingConfig().BlinkRate) then 
			return self:GetLightingConfig().BlinkRate 
		else 
			return PHO_DEFAULT_BLINK 
		end 
	end

	function ent:BlinkOn()
		if not IsValid( self ) then return false end
		if not self.Lighting.LastBlink then self.Lighting.LastBlink = CurTime() end
		local driving = (LocalPlayer():GetVehicle() == self)
		local result = nil
		if (self.Lighting.LastBlink + self:GetBlinkRate()) <= CurTime() and CurTime() <= (self.Lighting.LastBlink + (self:GetBlinkRate() * 2)) then
			result = false
			if not self.Lighting.WasOff and driving then surface.PlaySound( EMVU.Sounds.Tick ) end 
			self.Lighting.WasOff = true
		elseif CurTime() > (self.Lighting.LastBlink + (self:GetBlinkRate() * 2)) then
			result = false
			self.Lighting.WasOff = true
			self.Lighting.LastBlink = CurTime()
		else
			if self.Lighting.WasOff and driving then surface.PlaySound( EMVU.Sounds.Tock ) end 
			result = true
			self.Lighting.WasOff = false
		end
		return result
	end

	function ent:ReconnectLights()
		if not IsValid( self ) then return false end
		self.Lighting.Disconnected = {}
	end

	function ent:LightDisconnected( index )
		if not IsValid( self ) then return false end
		if table.HasValue( self.Lighting.Disconnected, index ) then return true end
		return false
	end

	function ent:SetStateMaterial( index, value )
		//print(tostring(index))
		//PrintTable( Photon.Vehicles.StateMaterials[ self.VehicleName ] )
		local stateData = Photon.Vehicles.StateMaterials[ self.VehicleName ][ index ]
		local matNumber = stateData.Index
		local matValue = stateData.States[ value ]
		self:SetSubMaterial( matNumber, matValue )
		self.PhotonMaterials[ index ] = value
	end

	function ent:ResetStateMaterials()
		for k,v in pairs( self.PhotonMaterials ) do
			self:SetStateMaterial( k, 0 )
			self.PhotonMaterials[k] = nil
		end
	end

	function ent:RenderLights( headlights, running, reversing, braking, left, right, hazards, pdebug )
		if not IsValid( self ) then return false end
		self:ResetStateMaterials()
		if not self.LastPhotonRenderCache or self.LastPhotonRenderCache + .05 < CurTime() then self.PhotonRenderCache = nil end

		local RenderTable = { true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true }

		if istable( self.PhotonRenderCache ) then

			RenderTable = self.PhotonRenderCache

		else
			if headlights then
				if Photon.Vehicles.States.Headlights[self.VehicleName] or pdebug then
					for _,l in pairs(Photon.Vehicles.States.Headlights[self.VehicleName]) do
						RenderTable[l[1]] = l
					end
				end
			end

			if running or pdebug then
				if Photon.Vehicles.States.Running[self.VehicleName] then
					for _,l in pairs(Photon.Vehicles.States.Running[self.VehicleName]) do
						RenderTable[l[1]] = l
					end
				end
			end

			if reversing or pdebug then
				if Photon.Vehicles.States.Reverse[self.VehicleName] then
					for _,l in pairs(Photon.Vehicles.States.Reverse[self.VehicleName]) do
						RenderTable[l[1]] = l
					end
				end
			end

			if braking or pdebug then -- Braking is added later because it will override values of all other lights
				if Photon.Vehicles.States.Brakes[self.VehicleName] then
					for _,l in pairs(Photon.Vehicles.States.Brakes[self.VehicleName]) do
						RenderTable[l[1]] = l
					end
				end
			end

			if (left and running or hazards) and self:BlinkOn() or pdebug then
				if Photon.Vehicles.States.Blink_Left[self.VehicleName] then
					for _,l in pairs(Photon.Vehicles.States.Blink_Left[self.VehicleName]) do
						RenderTable[l[1]] = l
					end
				end
			end

			if (right and running or hazards) and self:BlinkOn() or pdebug then
				if Photon.Vehicles.States.Blink_Right[self.VehicleName] then
					for _,l in pairs(Photon.Vehicles.States.Blink_Right[self.VehicleName]) do
						RenderTable[l[1]] = l
					end
				end
			end

			self.PhotonRenderCache = RenderTable
			self.LastPhotonRenderCache = CurTime()

		end

		local handles = self.Lighting.Handles
		local meta = self:GetLightingMeta()
		local positions = self:GetLightingPositions()

		local setupVis = self.SetupVisHandles
		local lightDisconnect = self.LightDisconnected
		local drawLight = Photon.PrepareVehicleLight

		local light = false
		
		for i,light in pairs( RenderTable ) do
			if light != true then
				if string.StartWith(tostring(i), "_") then
					self:SetStateMaterial( string.sub( tostring(i), 2 ), light[2] )
				else
					if not handles[light[1]] then setupVis( self ) return end -- for debugging mostly
					local pos = positions[light[1]]
					if pos and handles[i] and not lightDisconnect( self, light[1] ) then
						drawLight(
							Photon,
							self,
							PhotonColors[light[2]], -- color
							pos[1], -- positions
							pos[2], -- angle
							meta[pos[3]], -- meta data
							handles[light[1]], -- handle
							i, -- dynamic light number
							light[3] -- brightness
						)
					end
				end
			end
		end
	end

	ent.Lighting = {}
	ent.Lighting.Clock = CurTime()
	ent.Lighting.Handles = {}
	ent.Lighting.Disconnected = {}
	ent.Lighting.LastBlink = CurTime()
	ent.Lighting.Blink = false

	ent.PhotonMaterials = {}

	ent:SetupCarVisHandles()

	ent.DrawLight = Photon.DrawLight

end