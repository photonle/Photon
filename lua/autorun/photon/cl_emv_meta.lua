AddCSLuaFile()

EMVU.DebugInfo = {}
EMVU.DebugInfo.Last = CurTime()
EMVU.Calculations = 0

local EMVColors = nil
if EMVU.Colors then EMVColors = EMVU.Colors end

local EMVHelper = nil
if EMVU.Helper then EMVHelper = EMVU.Helper end

hook.Add( "InitPostEntity", "PhotonEMV.LocalColorSet", function() 
	EMVColors = EMVU.Colors; 
	EMVHelper = EMVU.Helper;
end )

local IsValid = IsValid

function EMVU:MakeEMV( emv, name )

	if not emv or not emv:IsValid() or not emv:IsVehicle() then return false end

	if name == "1" then return end

	-- Datatable Functions --

	function emv:Photon_Lights()
		if not IsValid( self ) then return false end
		return self:GetDTBool( EMV_LIGHTS_ON )
	end

	function emv:Photon_LightOption()
		if not IsValid( self ) then return 1 end
		return self:GetDTInt( EMV_LIGHT_OPTION )
	end

	function emv:Photon_Siren()
		if not IsValid( self ) then return false end
		return self:GetDTBool( EMV_SIREN_ON )
	end

	function emv:Photon_SirenOption()
		if not IsValid( self ) then return 1 end
		return self:GetDTInt( EMV_SIREN_OPTION )
	end

	function emv:Photon_SirenSet()
		if not IsValid( self ) then return 1 end
		return self:GetDTInt( EMV_SIREN_SET )
	end

	function emv:Photon_ManualSiren()
		if not IsValid( self ) then return false end
		return self:GetDTBool( CAR_MANUAL )
	end

	function emv:Photon_AlertMode()
		return ( self:Photon_ManualSiren() and self:Photon_Siren() )
	end

	function emv:Photon_ManualHorn()
		if not IsValid( self ) then return false end
		return self:GetDTBool( EMV_HORN )
	end

	function emv:Photon_NoSiren()
		if not IsValid( self ) then return true end
		return self:Photon_SirenSet() == 0
	end

	function emv:Photon_Illumination()
		if not IsValid( self ) then return false end
		return self:GetDTBool( EMV_ILLUM_ON )
	end

	function emv:Photon_IllumOption()
		if not IsValid( self ) then return 1 end
		return self:GetDTInt( EMV_ILLUM_OPTION )
	end

	function emv:Photon_IllumLights()
		if not IsValid( self ) then return {} end
		// local renderIllum = EMVHelper:GetIllumSequence( self.VehicleName, self:Photon_IllumOption(), self )
		// local resultTable = {}
		// for key,value in pairs( renderIllum ) do
		// 	if isstring( key ) then
		// 		local subTable = EMVU.Patterns[ self.VehicleName ]
		// 	end
		// end
		return EMVHelper:GetIllumSequence( self.VehicleName, self:Photon_IllumOption(), self )
	end

	function emv:Photon_HasIllum()
		if not IsValid( self ) then return 1 end
		if self.ELSIllum == nil then self.ELSIllum = EMVHelper:HasLamps( self.VehicleName ) end
		return self.ELSIllum
	end

	function emv:Photon_TrafficAdvisor()
		if not IsValid( self ) then return false end
		return self:GetDTBool( EMV_TRF_ON )
	end

	function emv:Photon_TrafficAdvisorOption()
		if not IsValid( self ) then return 1 end
		return self:GetDTInt( EMV_TRF_OPTION )
	end

	function emv:Photon_HasTrafficAdvisor()
		if self.ELSTraffic == nil then self.ELSTraffic = EMVHelper:HasTrafficAdvisor( self.VehicleName ) end
		return self.ELSTraffic
	end

	function emv:Photon_ELPresetOption()
		if not IsValid( self ) then return 0 end
		return self:GetDTInt( EMV_PRE_OPTION )
	end

	function emv:Photon_PresetEnabled()
		if not IsValid( self ) then return false end
		return !( self:Photon_ELPresetOption() == 0 )
	end

	-- Helper Functions --

	function emv:Photon_GetELPositions()
		if not IsValid( self ) then return false end
		return EMVHelper:GetVectors( self.VehicleName )
	end

	function emv:Photon_GetELUsedLights()
		if not self.PhotonUsedEL then self:Photon_CalculateUsedLights() end
		return self.PhotonUsedEL
	end

	function emv:Photon_CalculateUsedLights()
		self.PhotonUsedEL = EMVHelper.FetchUsedLights( self )
		return self.PhotonUsedEL
	end

	function emv:Photon_GetELPattern( option, frame )
		if not IsValid( self ) then return false end
		return EMVHelper:GetPattern( self.VehicleName, option, frame )
	end

	function emv:Photon_GetELSequence()
		if not IsValid( self ) then return false end
		local result
		if self:Photon_AlertMode() then
			result = EMVHelper.GetAlertSequence( self.VehicleName, self )
		else
			local option = self:Photon_LightOption()
			if not option then option = 1 end
			result = EMVHelper:GetSequence( self.VehicleName, option, self )
		end
		return result
	end

	function emv:Photon_GetTASequence()
		if not IsValid( self ) then return false end
		local option = self:Photon_TrafficAdvisorOption()
		if not option then option = 1 end
		local result = EMVHelper:GetTASequence( self.VehicleName, option, self )
		return result
	end

	function emv:Photon_ELS_GetPatterns()
		if not IsValid( self ) then return false end
		return EMVHelper:GetPatterns( self.VehicleName )
	end

	function emv:Photon_ELS_GetSequenceName()
		if not IsValid( self ) then return false end
		local option = self:Photon_LightOption()
		if not option then option = 1 end
		local result =  EMVHelper:GetSequenceName( self.VehicleName, option )
		return result
	end

	function emv:Photon_GetELMeta()
		if not IsValid( self ) then return false end
		return EMVHelper:GetMeta( self.VehicleName )
	end

	function emv:Photon_SetupVisHandles()
		if not IsValid( self ) then return false end
		for k,v in pairs( self:Photon_GetELPositions() ) do
			self.EL.VisHandles[tostring(k)] = util.GetPixelVisibleHandle()
		end
	end

	function emv:Photon_SetupFrames()
		if not IsValid( self ) then return false end
		for k,v in pairs( self:Photon_ELS_GetPatterns() ) do

			self.EL.Frames[k] = {}

			for a,b in pairs(v) do
				
				self.EL.Frames[k][a] = { 1, #v[a] }

			end

		end
	end

	-- Calculates whether we should increment the frame/pattern --
	function emv:Photon_ShiftELFrames( frames )
		if not IsValid( self ) then return false end
		if ( ( CurTime() - self.EL.Last ) >= EMV_FRAME_DUR ) then
			self.EL.Sequence = self.EL.Sequence + 1
			if self.EL.Sequence > frames then self.EL.Sequence = 1 end
			self.EL.Last = CurTime()
		end
	end

	function emv:Photon_ELShiftFrames()
		if not IsValid( self ) then return false end
		if ( ( CurTime() - self.EL.Last ) >= EMV_FRAME_DUR ) then
			self.EL.Last = CurTime()
			return true
		else
			return false
		end
	end

	 -- Component = key (ie lightbar), index = value/pattern, inc = increment frame
	function emv:Photon_GetFrame( component, index, inc )

		if not IsValid( self ) then return false end

		local k = component
		local a = index

		if not self.EL.Frames[k] then print("[Photon] Unregistered component name: " .. tostring( component ) .. " defined in vehicle: " .. tostring( self.VehicleName ) ) return end
		if not self.EL.Frames[k][a] then print("[Photon] Unregistered pattern: " .. tostring( index ) .. " under component: " ..tostring( component ) .. " defined in vehicle: " .. tostring( self.VehicleName ) ) return end

		if inc then
			if self.EL.Frames[k][a][1] >= self.EL.Frames[k][a][2] then
				self.EL.Frames[k][a][1] = 1
			else
				self.EL.Frames[k][a][1] = self.EL.Frames[k][a][1] + 1
			end
		end

		local frame = self.EL.Frames[k][a][1]

		return EMVHelper:Photon_GetFrame( self.VehicleName, component, index, frame )

	end

	function emv:Photon_GetLightSection( component, frame, skip )
		return EMVHelper:Photon_GetLightSection( self.VehicleName, component, frame, skip )
	end

	function emv:Photon_GetELOverride()
		return EMVHelper:GetModeDisconnect( self.VehicleName, self:Photon_LightOption() )
	end

	function emv:AlertPhotonMissingRequirements()
		if self.PhotonAlertedMissingRequirements then return end
		if not LocalPlayer():IsAdmin() then return end
		chat.AddText( Color( 255, 128, 0 ), "[Photon] You may be missing one or more required addons for the \"" .. tostring(self.VehicleName) .. "\" and some models will not be loaded.\n", Color(255,255,255), "Please check the Workshop page for this vehicle to see the requirements." )
		self.PhotonAlertedMissingRequirements = true
	end

	function emv:Photon_UpdateFrameLightPositions()
		local lights = self:Photon_GetELUsedLights()
		local posData = EMVU.Positions[ self.VehicleName ]
		local resultTable = {}
		for key,_ in pairs( lights ) do
			resultTable[key] = self:LocalToWorld( posData[tonumber(key)][1] )
		end
		self.PhotonELFramePositions = resultTable
		return self.PhotonELFramePositions
	end

	-- Basic KV Shit --

	emv.EMV = true

	emv.VehicleName = name

	emv.EL = {}
	emv.EL.Sequence = 1
	emv.EL.Last = CurTime()
	emv.EL.VisHandles = {}
	emv.EL.Frames = {}
	emv.EL.RenderCache = {}
	emv.EL.PixVisCache = {}
	emv.EL.TrafficDisconnect = {}
	emv.EL.Horn = false
	emv.EL.Manual = false

	-- Initializer Functions --
	emv:Photon_SetupFrames()
	emv:Photon_SetupVisHandles()

	-- Rendering Functions --

	-- Render Emergency Lights --
	function emv:Photon_RenderEL()
		if not IsValid( self ) then return false end
		if not self:Photon_Lights() and not self:Photon_TrafficAdvisor() and not self:Photon_Illumination() then
			if self.Photon_ReconnectLights then 
				self:Photon_ReconnectLights()
			elseif not self.RenderELPrimaryError then
				--error("[Photon] Catastrophic error occurred on clientside vehicle setup (" .. tostring(self.VehicleName) .. ")." )
				self.RenderELPrimaryError = true
			end
			return 
		end


		local RenderTable = self.EL.RenderCache

		if not RenderTable then return end
		self:Photon_UpdateFrameLightPositions()
		self:Photon_RefreshELPixVis()

		if self.Photon_ReconnectLights then 
			self:Photon_ReconnectLights()
		end
		
		if self.Photon_DisconnectLight then
			local disconnect = self:Photon_GetELOverride()
			if self:Photon_Lights() then
				if disconnect then
					for k,v in pairs(disconnect) do
						if self.Photon_DisconnectLight then
							self:Photon_DisconnectLight( v )
						end
						
					end
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

		self:Photon_RenderLightTable( RenderTable )
	end

	function emv:Photon_RenderLightTable( RenderTable )
		if not IsValid( self ) then return false end
		if not self.PhotonELFramePositions then return false end

		local positions = self:Photon_GetELPositions()
		local meta = self:Photon_GetELMeta()
		local gpos = self.PhotonELFramePositions
		local pixviscache = self.EL.PixVisCache

		local b = true
		local pos = true
		// PrintTable( RenderTable )
		local colorRecycle = { true, true }

		for a=1,#RenderTable do
			b = RenderTable[a]
			if (b==true) then continue end
			pos = positions[b[1]]

			if positions[b[1]] then
				local colString = b[2]
				local col = false
				local multiColor = false

				if string.find(colString, "/") then
					local cols = string.Explode("/", colString)
					colorRecycle = { EMVColors[cols[1]], EMVColors[cols[2]] }
					col = colorRecycle
					multiColor = true
					
				else
					col = EMVColors[b[2]]
				end
				// print(pixviscache[tostring(b[1])])
				Photon:PrepareVehicleLight(
						self, -- parent
						col, -- color of the light (colors)
						pos[1], -- local pos if needed
						gpos[tostring(b[1])], -- position (GLOBAL POS)
						pos[2], -- angle (lang)
						meta[pos[3]], -- meta data (meta)
						pixviscache[tostring(b[1])], -- pixvis handle (pixvis)
						a, -- int for dynamic light (lnum)
						b[3], -- brightness
						multiColor
					)
			end
		end

	end

	function emv:Photon_RenderIllum()
		if not IsValid( self ) then return false end
		if not self:Photon_Illumination() then return end
		local handles = self.EL.VisHandles
		local positions = self:Photon_GetELPositions()
		local meta = self:Photon_GetELMeta()
		local RenderTable = self:Photon_IllumLights()
		if RenderTable then self:Photon_RenderLightTable( RenderTable ) end
	end

	function emv:Photon_RefreshELPixVis()
		if not IsValid( self ) then return false end
		local handles = self.EL.VisHandles
		local usedLights = self:Photon_GetELUsedLights()
		local usedPositions = self.PhotonELFramePositions
		for index,_ in pairs( usedLights ) do
			if not handles[tostring(index)] then self:Photon_SetupVisHandles() return end
			self.EL.PixVisCache[ tostring(index) ] = util.PixelVisible( usedPositions[tostring(index)], 1, handles[tostring(index)] )
		end
	end

	function emv:Photon_CalculateELFrames()
		if not IsValid( self ) then return false end
		if not self:Photon_Lights() and not self:Photon_TrafficAdvisor() then return end
		local increment = self:Photon_ELShiftFrames()
		local sequence = self:Photon_GetELSequence()
		local RenderTable = {}

		if increment or not self.EL.RenderCache then

			self:Photon_CalculateUsedLights()

			local skipComponents = {}
			local skipELIndexes = {}

			if self:Photon_HasTrafficAdvisor() then
				if self:Photon_TrafficAdvisor() then
					local taSequence = self:Photon_GetTASequence()

					for index, light in pairs( taSequence ) do
						skipComponents[index] = true
						local frame = self:Photon_GetFrame( index, light, increment )
						if frame then table.Add( RenderTable, self:Photon_GetLightSection( index, frame ) ) end
					end

					local disconnectTable = EMVU.Helper:GetTrafficELDisconnect( self.VehicleName, self:Photon_TrafficAdvisorOption() )
					if istable( disconnectTable ) then
						for i=1, #disconnectTable do
							skipELIndexes[ disconnectTable[ i ] ] = true
						end
					end

				end
			end

			if self:Photon_Lights() then 
				for k,v in pairs( sequence ) do
					local frame = self:Photon_GetFrame( k, v, increment )
					if frame and not skipComponents[k] then
						if istable(frame) then
							for _,index in pairs( frame ) do
								table.Add( RenderTable, self:Photon_GetLightSection( k, index, skipELIndexes ) )
							end
						else
							table.Add( RenderTable, self:Photon_GetLightSection( k, frame, skipELIndexes ) )
						end
						
						// local addTable = self:Photon_GetLightSection( k, frame )
						// if istable( addTable ) then
						// 	for a,b in pairs( addTable ) do
						// 		RenderTable[a] = b
						// 	end
						// end
					end
				end
			end

			self.EL.RenderCache = RenderTable
		end

	end

	-- really shitty way of legacy support
	emv.DrawEL = Photon.DrawLight
	emv.CalcPixVis = Photon.CalculatePixVis

	function emv:Photon_SetupEMVProps()
		if not IsValid( self ) then return false end

		local emvProps = EMVHelper:GetProps( self.VehicleName, self )
		if emvProps then

		emv.EMVProps = {}

		for _,p in pairs( emvProps ) do

			if p == true then continue end
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
			prop:SetRenderMode( rendermode )

			if p.Skin then prop:SetSkin(p.Skin) end
			if p.Material then prop:SetMaterial( p.Material ) end
			if p.Color then prop:SetColor( p.Color ) end

			prop:SetSolid( SOLID_NONE )
			prop:SetMoveType( MOVETYPE_NONE )
			prop:SetCollisionGroup( COLLISION_GROUP_IN_VEHICLE )
			prop:Activate()
			prop:Spawn()
			prop:DrawShadow( false )

			if p.BodyGroups then 
				for _,group in pairs( p.BodyGroups ) do
					prop:SetBodygroup( group[1], group[2] )
				end
			end

			table.insert( emv.EMVProps, prop )

		end

	end

	end

	function emv:Photon_RemoveEMVProps( readd )
		if not IsValid( self ) then return false end

		if self.EMVProps then
			for _,prop in pairs( self.EMVProps ) do
				if prop and IsValid(prop) then SafeRemoveEntity(prop) end
			end
		end

		if readd then
			self:Photon_SetupEMVProps()
		end

	end

	function emv:Photon_ScanEMVProps()
		if not IsValid( self ) then return end

		if self.LastPresetOption != self:Photon_ELPresetOption() then 
			self:Photon_RemoveEMVProps( true ) 
			self.LastPresetOption = self:Photon_ELPresetOption() 
			return
		end

		if ( self.LastEMVPropScan and self.LastEMVPropScan + .5 > CurTime() and not PHOTON_DEBUG ) then return end

		if not self.EMVProps then return end
		local emvProps = EMVHelper:GetProps( self.VehicleName, self )

		if emvProps then 
			for index,prop in ipairs( self.EMVProps ) do
				if not IsValid( prop ) then
					self:Photon_RemoveEMVProps( true )
					break
				end
				prop:SetParent( self )
				prop:SetPos( self:LocalToWorld( emvProps[index].Pos ) )
				prop:SetAngles( self:LocalToWorldAngles( emvProps[index].Ang ) )
				if PHOTON_DEBUG then 
					if isvector( emvProps[index].Scale ) then
						local mat = Matrix()
						mat:Scale( emvProps[index].Scale )
						prop:EnableMatrix( "RenderMultiply", mat )
					elseif isnumber( emvProps[index].Scale ) then
						prop:SetModelScale( emvProps[index].Scale, 0 )
					end
				end
			end
		end
		self.LastEMVPropScan = CurTime()

	end

	emv.LastPresetOption = 0
	emv:Photon_SetupEMVProps()

end
