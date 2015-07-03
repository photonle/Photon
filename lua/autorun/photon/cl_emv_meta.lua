AddCSLuaFile()

EMVU.DebugInfo = {}
EMVU.DebugInfo.Last = CurTime()
EMVU.Calculations = 0

function EMVU:MakeEMV( emv, name )

	if not emv or not emv:IsValid() or not emv:IsVehicle() then return false end

	if name == "1" then return end

	-- Datatable Functions --

	function emv:Lights()
		if not IsValid( self ) then return false end
		return self:GetDTBool( EMV_LIGHTS_ON )
	end

	function emv:LightOption()
		if not IsValid( self ) then return 1 end
		return self:GetDTInt( EMV_LIGHT_OPTION )
	end

	function emv:Siren()
		if not IsValid( self ) then return false end
		return self:GetDTBool( EMV_SIREN_ON )
	end

	function emv:SirenOption()
		if not IsValid( self ) then return 1 end
		return self:GetDTInt( EMV_SIREN_OPTION )
	end

	function emv:SirenSet()
		if not IsValid( self ) then return 1 end
		return self:GetDTInt( EMV_SIREN_SET )
	end

	function emv:ManualSiren()
		if not IsValid( self ) then return false end
		return self:GetDTBool( CAR_MANUAL )
	end

	function emv:ManualHorn()
		if not IsValid( self ) then return false end
		return self:GetDTBool( EMV_HORN )
	end

	function emv:NoSiren()
		if not IsValid( self ) then return true end
		return self:SirenSet() == 0
	end

	function emv:Illumination()
		if not IsValid( self ) then return false end
		return self:GetDTBool( EMV_ILLUM_ON )
	end

	function emv:IllumOption()
		if not IsValid( self ) then return 1 end
		return self:GetDTInt( EMV_ILLUM_OPTION )
	end

	function emv:IllumLights()
		if not IsValid( self ) then return {} end
		return EMVU.Helper:GetIllumSequence( self.VehicleName, self:IllumOption(), self )
	end

	function emv:HasIllum()
		if not IsValid( self ) then return 1 end
		if self.ELSIllum == nil then self.ELSIllum = EMVU.Helper:HasLamps( self.VehicleName ) end
		return self.ELSIllum
	end

	function emv:TrafficAdvisor()
		if not IsValid( self ) then return false end
		return self:GetDTBool( EMV_TRF_ON )
	end

	function emv:TrafficAdvisorOption()
		if not IsValid( self ) then return 1 end
		return self:GetDTInt( EMV_TRF_OPTION )
	end

	function emv:HasTrafficAdvisor()
		if self.ELSTraffic == nil then self.ELSTraffic = EMVU.Helper:HasTrafficAdvisor( self.VehicleName ) end
		return self.ELSTraffic
	end

	-- Helper Functions --

	function emv:GetELPositions()
		if not IsValid( self ) then return false end
		return EMVU.Helper:GetVectors( self.VehicleName )
	end

	function emv:GetELPattern( option, frame )
		if not IsValid( self ) then return false end
		return EMVU.Helper:GetPattern( self.VehicleName, option, frame )
	end

	function emv:GetELSequence()
		if not IsValid( self ) then return false end
		local option = self:LightOption()
		if not option then option = 1 end
		local result = EMVU.Helper:GetSequence( self.VehicleName, option, self )
		return result
	end

	function emv:GetTASequence()
		if not IsValid( self ) then return false end
		local option = self:TrafficAdvisorOption()
		if not option then option = 1 end
		local result = EMVU.Helper:GetTASequence( self.VehicleName, option, self )
		return result
	end

	function emv:ELS_GetPatterns()
		if not IsValid( self ) then return false end
		return EMVU.Helper:GetPatterns( self.VehicleName )
	end

	function emv:ELS_GetSequenceName()
		if not IsValid( self ) then return false end
		local option = self:LightOption()
		if not option then option = 1 end
		local result =  EMVU.Helper:GetSequenceName( self.VehicleName, option )
		return result
	end

	function emv:GetELMeta()
		if not IsValid( self ) then return false end
		return EMVU.Helper:GetMeta( self.VehicleName )
	end

	function emv:SetupVisHandles()
		if not IsValid( self ) then return false end
		for k,v in pairs( self:GetELPositions() ) do
			self.EL.VisHandles[k] = util.GetPixelVisibleHandle()
		end
	end

	function emv:SetupFrames()
		if not IsValid( self ) then return false end
		local start = CurTime()
		for k,v in pairs( self:ELS_GetPatterns() ) do

			self.EL.Frames[k] = {}

			for a,b in pairs(v) do
				
				self.EL.Frames[k][a] = { 1, #v[a] }

			end

		end
		local endTime = CurTime()

		print( "Setup Frames Time: " .. tostring( endTime - start ) )
	end

	-- Calculates whether we should increment the frame/pattern --
	function emv:ShiftELFrames( frames )
		if not IsValid( self ) then return false end
		if ( ( CurTime() - self.EL.Last ) >= EMV_FRAME_DUR ) then
			self.EL.Sequence = self.EL.Sequence + 1
			if self.EL.Sequence > frames then self.EL.Sequence = 1 end
			self.EL.Last = CurTime()
		end
	end

	function emv:ELShiftFrames()
		if not IsValid( self ) then return false end
		if ( ( CurTime() - self.EL.Last ) >= EMV_FRAME_DUR ) then
			self.EL.Last = CurTime()
			return true
		else
			return false
		end
	end

	 -- Component = key (ie lightbar), index = value/pattern, inc = increment frame
	function emv:GetFrame( component, index, inc )

		if not IsValid( self ) then return false end

		local k = component
		local a = index

		if not self.EL.Frames[k] then print("[Photon] Invalid component name: " .. tostring( component ) ) return end

		if inc then
			if self.EL.Frames[k][a][1] >= self.EL.Frames[k][a][2] then
				self.EL.Frames[k][a][1] = 1
			else
				self.EL.Frames[k][a][1] = self.EL.Frames[k][a][1] + 1
			end
		end

		local frame = self.EL.Frames[k][a][1]

		return EMVU.Helper:GetFrame( self.VehicleName, component, index, frame )

	end

	function emv:GetLightSection( component, frame )
		return EMVU.Helper:GetLightSection( self.VehicleName, component, frame )
	end

	function emv:GetELOverride()
		return EMVU.Helper:GetModeDisconnect( self.VehicleName, self:LightOption() )
	end

	function emv:AlertPhotonMissingRequirements()
		if self.PhotonAlertedMissingRequirements then return end
		if not LocalPlayer():IsAdmin() then return end
		chat.AddText( Color( 255, 128, 0 ), "[Photon] You may be missing one or more required addons for the \"" .. tostring(self.VehicleName) .. "\" and some models will not be loaded.\n", Color(255,255,255), "Please check the Workshop page for this vehicle to see the requirements." )
		self.PhotonAlertedMissingRequirements = true
	end

	-- Basic KV Shit --

	emv.EMV = true
	emv.PixVis = util.GetPixelVisibleHandle()

	emv.VehicleName = name

	emv.EL = {}
	emv.EL.Sequence = 1
	emv.EL.Last = CurTime()
	emv.EL.VisHandles = {}
	emv.EL.Frames = {}
	emv.EL.RenderCache = {}
	emv.EL.PixVisCache = {}
	emv.EL.Horn = false
	emv.EL.Manual = false

	-- Initializer Functions --
	emv:SetupFrames()
	emv:SetupVisHandles()

	-- Rendering Functions --

	-- Render Emergency Lights --
	function emv:RenderEL()
		if not IsValid( self ) then return false end
		if not self:Lights() and not self:TrafficAdvisor() then
			if self.ReconnectLights then 
				self:ReconnectLights()
			elseif not self.RenderELPrimaryError then
				--error("[Photon] Catastrophic error occurred on clientside vehicle setup (" .. tostring(self.VehicleName) .. ")." )
				self.RenderELPrimaryError = true
			end
			return 
		end

		self:ProcessPixVis()
		local RenderTable = self.EL.RenderCache

		if not RenderTable then return end

		if self.ReconnectLights then 
			self:ReconnectLights()
		end
		
		local disconnect = self:GetELOverride()
		if self:Lights() then
			if disconnect then
				for k,v in pairs(disconnect) do
					self:DisconnectLight( v )
				end
			end
		end

		if PHOTON_DEBUG then
			RenderTable = {}
			local count = #EMVU.Positions[ self.VehicleName ]
			for i = 1, count, 1 do
				table.insert( RenderTable, { i, "BLUE" } )
			end
		end

		self:RenderLightTable( RenderTable )
		
	end

	function emv:RenderLightTable( RenderTable )
		if not IsValid( self ) then return false end

		local handles = self.EL.VisHandles
		local positions = self:GetELPositions()
		local meta = self:GetELMeta()

		local b = true
		local pos = true

		for a=1,#RenderTable do
			b = RenderTable[a]
			if not handles[b[1]] then self:SetupVisHandles() return end
			pos = positions[b[1]]
			if positions[b[1]] and handles[a] then
				self:DrawEL( 

						EMVU.Colors[b[2]], -- color of the light (colors)
						pos[1], -- position (lpos)
						pos[2], -- angle (lang)
						meta[pos[3]], -- meta data (meta)
						handles[b[1]], -- pixvis handle (pixvis)
						a, -- int for dynamic light (lnum)
						b[3] -- brightness
					)
			end
		end

	end

	function emv:RenderIllum()
		if not IsValid( self ) then return false end
		if not self:Illumination() then return end
		local handles = self.EL.VisHandles
		local positions = self:GetELPositions()
		local meta = self:GetELMeta()
		local RenderTable = self:IllumLights()
		if RenderTable then self:RenderLightTable( RenderTable ) end
	end

	function emv:ProcessPixVis()

		if not IsValid( self ) then return false end

		local handles = self.EL.VisHandles
		local ELPositions = self:GetELPositions()

		local pos = true
		local handle = true

		for i=1,#ELPositions do
			if not handles[i] then self:SetupVisHandles() return end
			local handle = handles[i]
			self:CalcPixVis(
				ELPositions[i][1],
				handle,
				4
			)
		end

	end

	function emv:CalculateELFrames()
		if not IsValid( self ) then return false end
		if not self:Lights() and not self:TrafficAdvisor() then return end
		local increment = self:ELShiftFrames()
		local sequence = self:GetELSequence()
		local RenderTable = {}

		if increment or not self.EL.RenderCache then

			local skipComponents = {}

			if self:HasTrafficAdvisor() then
				if self:TrafficAdvisor() then
					local taSequence = self:GetTASequence()

					for index, light in pairs( taSequence ) do
						skipComponents[index] = true
						local frame = self:GetFrame( index, light, increment )
						if frame then table.Add( RenderTable, self:GetLightSection( index, frame ) ) end
					end
				end
			end

			if self:Lights() then 
				for k,v in pairs( sequence ) do
					local frame = self:GetFrame( k, v, increment )
					if frame and not skipComponents[k] then table.Add( RenderTable, self:GetLightSection( k, frame ) ) end
				end
			end

			self.EL.RenderCache = RenderTable
		end

	end

	-- really shitty way of legacy support
	emv.DrawEL = Photon.DrawLight
	emv.CalcPixVis = Photon.CalculatePixVis

	function emv:SetupEMVProps()
		if not IsValid( self ) then return false end

		local emvProps = EMVU.Helper:GetProps( self.VehicleName )
		if emvProps then

		emv.EMVProps = {}

		for _,p in pairs( emvProps ) do

			local rendergroup = p.RenderGroup or RENDERGROUP_TRANSLUCENT
			local rendermode = p.RenderMode or RENDERMODE_TRANSALPHA
			util.PrecacheModel( p.Model )
			if not util.IsModelLoaded( p.Model ) then self:AlertPhotonMissingRequirements() continue end
			local prop = ClientsideModel( p.Model, rendergroup )
			if isvector( p.Scale ) then
				local mat = Matrix()
				mat:Scale( p.Scale )
				prop:EnableMatrix( "RenderMultiply", mat )
			elseif isnumber( p.Scale ) then
				prop:SetModelScale( p.Scale, 0 )
			end
			prop:SetParent( emv )
			prop:SetPos( emv:LocalToWorld( p.Pos ) )
			prop:SetAngles( emv:LocalToWorldAngles( p.Ang ) )
			prop:DrawShadow( false )
			prop:SetRenderMode( rendermode )

			if p.Skin then prop:SetSkin(p.Skin) end
			if p.Material then prop:SetMaterial( p.Material ) end
			if p.Color then prop:SetColor( p.Color ) end

			prop:SetSolid( SOLID_NONE )
			prop:SetMoveType( MOVETYPE_NONE )
			prop:SetCollisionGroup( COLLISION_GROUP_IN_VEHICLE )
			prop:Activate()
			prop:Spawn()

			if p.BodyGroups then 
				for _,group in pairs( p.BodyGroups ) do
					prop:SetBodygroup( group[1], group[2] )
				end
			end

			table.insert( emv.EMVProps, prop )

		end

	end

	end

	function emv:RemoveEMVProps( readd )
		if not IsValid( self ) then return false end

		if self.EMVProps then
			for _,prop in pairs( self.EMVProps ) do
				if prop and IsValid(prop) then SafeRemoveEntity(prop) end
			end
		end

		if readd then
			self:SetupEMVProps()
		end

	end

	function emv:ScanEMVProps()
		
		if not IsValid( self ) then return end

		if self.LastEMVPropScan and self.LastEMVPropScan + 2 > CurTime() and not PHOTON_DEBUG then return end

		if not self.EMVProps then return end
		local emvProps = EMVU.Helper:GetProps( self.VehicleName )

		if emvProps then 
			for index,prop in ipairs( self.EMVProps ) do
				if not IsValid( prop ) then
					self:RemoveEMVProps( true )
					break
				end
				prop:SetParent( self )
				prop:SetPos( self:LocalToWorld( emvProps[index].Pos ) )
				prop:SetAngles( self:LocalToWorldAngles( emvProps[index].Ang ) )
			end
		end

		self.LastEMVPropScan = CurTime()

	end

	emv:SetupEMVProps()

end
