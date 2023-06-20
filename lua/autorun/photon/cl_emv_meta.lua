AddCSLuaFile()

EMVU.DebugInfo = {}
EMVU.DebugInfo.Last = CurTime()
EMVU.Calculations = 0

local EMVColors = nil
if EMVU.Colors then EMVColors = EMVU.Colors end

local EMVHelper = nil
if EMVU.Helper then EMVHelper = EMVU.Helper end

hook.Add("InitPostEntity", "PhotonEMV.LocalColorSet", function()
	EMVColors = EMVU.Colors
	EMVHelper = EMVU.Helper
end)

local IsValid = IsValid
local tostring = tostring
local istable = istable
local math = math
local isstring = isstring
local system = system
local pairs = pairs

local christmasMode = GetConVar( "photon_christmas_mode" )

hook.Add( "InitPostEntity", "Photon.CLEMVMETASettings", function()
	christmasMode = GetConVar("photon_christmas_mode")
end)

local printedErrors = {}

function EMVU:MakeEMV( emv, name )

	if not emv or not emv:IsValid() or not emv:IsVehicle() then return false end

	if name == "1" then return end


	function emv:Photon_ManualSiren()
		if not IsValid( self ) then return false end
		return self:GetNW2Bool( "PhotonLE.CAR_MANUAL" )
	end

	function emv:Photon_AlertMode()
		return ( self:Photon_ManualSiren() and self:Photon_Siren() )
	end

	function emv:Photon_ParkMode()
		if not IsValid(self) then return false end
		return self:GetNW2Bool("PhotonLE.PARK_MODE")
	end

	function emv:Photon_ManualHorn()
		if not IsValid( self ) then return false end
		return self:GetNW2Bool( "PhotonLE.EMV_HORN" )
	end

	function emv:Photon_NoSiren()
		if not IsValid( self ) then return true end
		return self:Photon_SirenSet() == 0
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
		local result = EMVHelper:GetIllumSequence( self.VehicleName, self:Photon_IllumOption(), self )
		return result
	end

	function emv:Photon_HasIllum()
		if not IsValid( self ) then return 1 end
		if self.ELSIllum == nil then self.ELSIllum = EMVHelper:HasLamps( self.VehicleName ) end
		return self.ELSIllum
	end


	function emv:Photon_AuxLights()
		return self:Photon_TrafficAdvisor()
	end

	function emv:Photon_HasTrafficAdvisor()
		if self.ELSTraffic == nil then self.ELSTraffic = EMVHelper:HasTrafficAdvisor( self.VehicleName ) end
		return self.ELSTraffic
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
		if self:Photon_AlertMode() and EMVHelper.GetAlertModeEnabled(self.VehicleName) then
			result = EMVHelper.GetAlertSequence( self.VehicleName, self )
		else
			local option = self:Photon_LightOption()
			if not option then option = 1 end
			result = EMVHelper:GetSequence( self.VehicleName, option, self )
		end
		if self.Photon_IsBraking and self:Photon_IsBraking() then result = EMVHelper.GetBrakeSequence( self.VehicleName, self, result ) end
		if self.Photon_IsReversing and self:Photon_IsReversing() then result = EMVHelper.GetReverseSequence( self.VehicleName, self, result ) end
		if self.Photon_ParkMode and self:Photon_ParkMode() then result = EMVHelper.GetParkSequence(self.VehicleName, self, result) end
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
		if not self.EL.Frames[k][a] then
			local comp = tostring( component )
			if not printedErrors[comp] then
				local errorOutput = print("[Photon] Unregistered pattern: " .. tostring( index ) .. " under component: " .. component .. " defined in vehicle: " .. tostring( self.VehicleName ) )
				printedErrors[comp] = true
			end
			return
		end

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

	function emv:AlertPhotonMissingRequirements( modelName )
		if self.PhotonAlertedMissingRequirements then return end
		if not LocalPlayer():IsAdmin() then return end
		chat.AddText( Color( 255, 128, 0 ), "[Photon] You may be missing one or more required addons for the \"" .. tostring(self.VehicleName) .. "\" (" .. tostring( modelName ) .. ") and some models will not be loaded.\n", Color(255,255,255), "Please check the Workshop page for this vehicle to see the requirements." )
		self.PhotonAlertedMissingRequirements = true
	end

	function emv:Photon_UpdateFrameLightPositions()
		local lights = self:Photon_GetELUsedLights()
		local posData = EMVU.Positions[ self.VehicleName ]
		local resultTable = {}
		for key,_ in pairs( lights ) do
			if PHOTON_DEBUG and not istable( posData[tonumber(key)] ) then continue end
			local pData = posData[tonumber(key)]
			if not istable( pData ) then error("[Photon] Unable to find light index (#" .. tostring( key ) .. "). Check EMV.Sections and ensure the the defined light number exists as [" .. tostring( key ) .. "] in the EMV.Positions table.") return end
			if pData[1][1] == "RE" then
				local npos, nang = EMVU.Helper.GetPositionFromRE( self, self:Photon_GetPropByAutoIndex( pData[1][5] ), pData[1], true )
				-- local newPos = self:LocalToWorld( npos )
				-- newPos.x = math.Round( newPos.x )
				-- newPos.y = math.Round( newPos.y )
				-- newPos.z = math.Round( newPos.z )
				-- print( string.format( "[%s] %s", key, tostring( newPos ) ) )
				resultTable[key] = npos
			elseif isvector( pData[1] ) then
				resultTable[key] = self:LocalToWorld( posData[tonumber(key)][1] )
			end
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
			if self:Photon_Lights() and disconnect then
				for k,v in pairs(disconnect) do
					if self.Photon_DisconnectLight then
						self:Photon_DisconnectLight( v )
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

	function emv:Photon_RenderLightTable( RenderTable, type )
		if not IsValid( self ) then return false end
		if not self.PhotonELFramePositions then return false end
		local positions = self:Photon_GetELPositions()
		local meta = self:Photon_GetELMeta()
		local gpos = self.PhotonELFramePositions
		local pixviscache = self.EL.PixVisCache

		local b = true
		local pos = true

		local illumBlock = ( type == "ILLUM" )
		if illumBlock and istable( self.PhotonIllumBlockedLights ) then table.Empty( self.PhotonIllumBlockedLights ) elseif illumBlock then self.PhotonIllumBlockedLights = {} end
		local blockTable = self.PhotonIllumBlockedLights
		local colorRecycle = { true, true }
		for a=1,#RenderTable do
			b = RenderTable[a]
			if (b==true) then continue end
			pos = positions[b[1]]
			if istable(blockTable) then
				if illumBlock then blockTable[tostring(b[1])] = true elseif blockTable[tostring(b[1])] then continue end
			end
			if positions[b[1]] then
				local colString = b[2]
				if not colString then print("[Photon] No color specified for position: " .. tostring(b[1]) .. ". Falling back to WHITE"); colString = "WHITE" end

				local col = false
				local multiColor = false

				if string.find(colString, "/") then
					local cols = string.Explode("/", colString)
					colorRecycle = { EMVColors[cols[1]], EMVColors[cols[2]] }
					col = colorRecycle
					multiColor = true

				else
					col = EMVColors[colString]
				end
				if not col then print("[Photon] Invalid color specified: " .. colString .. ". Falling back to WHITE"); col = EMVColors["WHITE"] end

				if christmasMode:GetBool() then
					if colString == "BLUE" then col = EMVColors["GREEN"]
					elseif colString == "AMBER" then col = EMVColors["WHITE"] end
				end
				// print(pixviscache[tostring(b[1])])
				local showDynamic = pos[4] or false
				local calcPos, calcAng, lrang, contingentTransform
				if pos[1][1] == "RE" then
					calcPos, calcAng, lrang, contingentTransform = EMVU.Helper.GetPositionFromRE( self, self:Photon_GetPropByAutoIndex( pos[1][5] ), pos[1] )
					-- calcAng.p = -90 -- hacky ass fix because I didn't want to actually figure out why it's so fucked up (TODO)
					-- calcAng.r = 0
					-- print(lrang)
					local minAng = 90
					local maxAng = 270
					if meta.reColorAngles then minAng = meta.reColorAngles[1]; maxAng = meta.reColorAngles[2]; end
					if multiColor then
						if lrang > minAng and lrang < maxAng then
							col = colorRecycle[1]
						else
							col = colorRecycle[2]
						end
						multiColor = false
					end

				end
				Photon:PrepareVehicleLight(
						self, -- parent
						col, -- color of the light (colors)
						calcPos or pos[1], -- local pos if needed
						gpos[b[1]] or gpos[tostring(b[1])], -- position (GLOBAL POS)
						calcAng or pos[2], -- angle (lang)
						meta[pos[3]], -- meta data (meta)
						pixviscache[tostring(b[1])], -- pixvis handle (pixvis)
						a, -- int for dynamic light (lnum)
						b[3], -- brightness
						multiColor,
						0,
						showDynamic,
						contingentTransform
					)
			else
				print("[Photon] No position found for: " .. tostring(b[1]))
			end
		end
	end

	function emv:Photon_RenderIllum()
		if not IsValid( self ) then return false end
		if not self:Photon_Illumination() and istable( self.PhotonIllumBlockedLights ) then table.Empty( self.PhotonIllumBlockedLights ) return end
		local handles = self.EL.VisHandles
		local positions = self:Photon_GetELPositions()
		local meta = self:Photon_GetELMeta()
		local RenderTable = self:Photon_IllumLights()
		--PrintTable( RenderTable )
		if RenderTable then self:Photon_RenderLightTable( RenderTable, "ILLUM" ) end
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
		if not self:Photon_Lights() and not self:Photon_TrafficAdvisor() and not self:Photon_Illumination() then return end
		local increment = self:Photon_ELShiftFrames()
		local sequence = self:Photon_GetELSequence()
		local RenderTable = {}

		if increment or not self.EL.RenderCache then

			self:Photon_CalculateUsedLights()

			local skipComponents = {}
			local skipELIndexes = {}

			if self:Photon_HasTrafficAdvisor() and self:Photon_TrafficAdvisor() then
				local taSequence = self:Photon_GetTASequence()

				for index, light in pairs( taSequence ) do
					skipComponents[index] = true
					local frame = self:Photon_GetFrame( index, light, increment )
					if frame then
						if istable(frame) then
							for _, idx in ipairs(frame) do
								table.Add(RenderTable, self:Photon_GetLightSection(index, idx))
							end
						else
							table.Add( RenderTable, self:Photon_GetLightSection( index, frame ) )
						end
					end
				end

				local disconnectTable = EMVU.Helper:GetTrafficELDisconnect( self.VehicleName, self:Photon_TrafficAdvisorOption() )
				if istable( disconnectTable ) then
					for i=1, #disconnectTable do
						skipELIndexes[ disconnectTable[ i ] ] = true
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
		local emv = self
		local emvProps = EMVHelper:GetProps( self.VehicleName, self )
		if emvProps then

		emv.EMVProps = {}

		for _,p in pairs( emvProps ) do

			if p == true then continue end
			if not p.Model then continue end
			local rendergroup = p.RenderGroup or RENDERGROUP_OPAQUE
			local rendermode = p.RenderMode or RENDERMODE_TRANSALPHA
			util.PrecacheModel( p.Model )
			if not util.IsModelLoaded( p.Model ) then self:AlertPhotonMissingRequirements( p.Model ) end
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
			if p.AirEL then prop.AirEL = true end

			prop.AutoIndex = p.AutoIndex or false
			prop.ComponentName = p.ComponentName or false
			prop.PhotonRotationEnabled = p.PhotonRotationEnabled or false
			prop.PhotonBoneAnimationData = p.PhotonBoneAnimationData or false
			prop.PhotonLocalAngs = p.Ang
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
			if p.SubMaterials then
				for index, value in pairs( p.SubMaterials ) do
					if isnumber( tonumber( index ) ) then
						prop:SetSubMaterial( tonumber( index ), value )
					end
				end
			end

			if p.HideBone then
				emv:ManipulateBoneScale(emv:LookupBone(p.HideBone), Vector(0, 0, 0))
			end

			if p.OffsetBone then
				if p.OffsetBoneAng then
					emv:ManipulateBoneAngles(emv:LookupBone(p.OffsetBone), p.OffsetBoneAng)
				end
				if p.OffsetBonePos then
					emv:ManipulateBonePosition(emv:LookupBone(p.OffsetBone), p.OffsetBonePos)
				end
			end

			if p.AttachmentMerge then
				prop:SetParent(nil)
				prop:SetParent(emv, emv:LookupAttachment(p.AttachmentMerge))
			end

			table.insert(photonLightModels, prop)
			table.insert( emv.EMVProps, prop )

		end

	end

	end

	function emv:Photon_GetPropByAutoIndex( id )
		if istable( self.EMVProps ) then
			for _,prop in pairs( self.EMVProps ) do
				if tostring( prop.AutoIndex ) == tostring( id ) then return prop end
			end
		end
		return false
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

		if self.LastSelectionString != self:Photon_SelectionString() then
			self:Photon_RemoveEMVProps( true )
			self.LastSelectionString = self:Photon_SelectionString()
			return
		end

		if ( self.LastEMVPropScan and self.LastEMVPropScan + .5 > CurTime() and not PHOTON_DEBUG and not PHOTON_EXPRESS ) then return end

		if not self.EMVProps then return end
		local emvProps = EMVHelper:GetProps( self.VehicleName, self )

		if emvProps and istable( emvProps) then
			for index,prop in ipairs( self.EMVProps ) do
				if not IsValid( prop ) then
					self:Photon_RemoveEMVProps( true )
					break
				end
				--[[
				recoded to only reparent when necessary, fixes detachment when vehicle leaves PVS - sgm
				--]]
				if !IsValid(prop:GetParent()) then
					prop:SetParent( self )
					prop:SetPos( self:LocalToWorld( emvProps[index].Pos ) )
					prop:SetAngles( self:LocalToWorldAngles( emvProps[index].Ang ) )

					if emvProps[index].AttachmentMerge then
						prop:SetParent(nil)
						prop:SetParent(self, self:LookupAttachment(emvProps[index].AttachmentMerge))
					end

				end

				if PHOTON_DEBUG or PHOTON_EXPRESS then
					if isvector( emvProps[index].Scale ) then
						local mat = Matrix()
						mat:Scale( emvProps[index].Scale )
						prop:EnableMatrix( "RenderMultiply", mat )
					elseif isnumber( emvProps[index].Scale ) then
						prop:SetModelScale( emvProps[index].Scale, 0 )
					end
				end
				if prop.AirEL then self.AirELEntity = prop end
				if not IsValid( self.AirELEntity ) then self.AirELEntity = nil end
			end
		else
			self:Photon_RemoveEMVProps( true )
		end
		self.LastEMVPropScan = CurTime()

	end

	-- For updating the props after saving the file
	function emv:Photon_UpdateEMVProps()
		local emvProps = EMVHelper:GetProps( self.VehicleName, self )
		if not emvProps or not istable( emvProps) then return end

		for index,prop in ipairs( self.EMVProps ) do
			if not IsValid( prop ) then
				self:Photon_RemoveEMVProps( true )
				break
			end

			prop:SetParent( self )
			prop:SetPos( self:LocalToWorld( emvProps[index].Pos ) )
			prop:SetAngles( self:LocalToWorldAngles( emvProps[index].Ang ) )

			if emvProps[index].AttachmentMerge then
				prop:SetParent(nil)
				prop:SetParent(self, self:LookupAttachment(emvProps[index].AttachmentMerge))
			end

			if isvector( emvProps[index].Scale ) then
				local mat = Matrix()
				mat:Scale( emvProps[index].Scale )
				prop:EnableMatrix( "RenderMultiply", mat )
			elseif isnumber( emvProps[index].Scale ) then
				prop:SetModelScale( emvProps[index].Scale, 0 )
			end
			if prop.AirEL then self.AirELEntity = prop end
			if not IsValid( self.AirELEntity ) then self.AirELEntity = nil end
		end
	end

	function emv:Photon_GetRadarCone( rear, force )
		local normDirection = self:GetForward()
		if rear then normDirection:Rotate( Angle( 0, -90, 0 ) ) else normDirection:Rotate( Angle( 0, 90, 0 ) ) end
		local startPos = self:GetPos()
		startPos.z = startPos.z + 60
		if not self.PhotonRadarTargetCache or ( self.PhotonRadarTargetCacheTime and self.PhotonRadarTargetCacheTime + 1 < CurTime() ) or ( rear != self.PhotonRadarTargetLastRear ) or force then
			local validEnts = {}
			for _, ent in pairs( ents.FindInCone( startPos, normDirection, 2048, 0 ) ) do
				if IsValid( ent ) and
					ent:IsVehicle() and
					ent != self and
					-- self:IsLineOfSightClear( ent:GetPos() ) and
					ent:Photon_GetSpeed() > .5 then
					validEnts[ #validEnts + 1 ] = ent
				end
			end
			self.PhotonRadarTargetLastRear = (rear or false)
			self.PhotonRadarTargetCache = validEnts
			self.PhotonRadarTargetCacheTime = CurTime()
		end
		return self.PhotonRadarTargetCache
	end

	function emv:Photon_UpdateRadarTargets( rear )
		local entList = self:Photon_GetRadarCone( rear )
		local fastest, nearest, fastSpeed, nearDist
		for _, ent in pairs( entList ) do
			if IsValid( ent ) then
				local thisSpeed = ent:Photon_GetSpeed()
				local thisDist = self:GetPos():Distance( ent:GetPos() )
				if (fastest and fastSpeed) then
					if (thisSpeed > fastSpeed) then fastest = ent; fastSpeed = thisSpeed end
				else
					fastest = ent; fastSpeed = thisSpeed
				end
				if (nearest and nearDist) then
					if ( nearDist > thisDist ) then nearest = ent; nearDist = thisDist end
				else
					nearest = ent; nearDist = thisDist
				end
			end
		end
		self.PhotonRadarTargetFastest = fastest
		self.PhotonRadarTargetNearest = nearest
		return fastest, nearest
	end

	function emv:Photon_RadarTargetSpeeds( rear )
		if not IsValid( self.PhotonRadarTargetFastest ) or not IsValid( self.PhotonRadarTargetNearest ) then self:Photon_UpdateRadarTargets() end
		local fastest, nearest = self:Photon_UpdateRadarTargets( rear )
		if not IsValid( nearest ) or not IsValid( fastest ) then return 0, 0 end
		if fastest == nearest then return 0, math.Round( nearest:Photon_AdjustedSpeed() ) end
		return math.Round( fastest:Photon_AdjustedSpeed() ), math.Round( nearest:Photon_AdjustedSpeed() )
	end

	function emv:Photon_RadarSoundInitialize()
		if self.PhotonRadarSoundLoading then return end
		self.PhotonRadarSoundLoading = true
		sound.PlayFile( "sound/emv/radar_flat.wav", "3d", function( snd )
			self:Photon_RadarSoundCallback( snd )
		end)
	end

	function emv:Photon_RadarSoundCallback( snd )
		if IsValid( snd ) then
			snd:Pause()
			self.PhotonRadarSoundHandle = snd
			self.PhotonRadarSoundLoading = false
		end
	end

	function emv:Photon_RadarTick()
		if not IsValid( LocalPlayer():GetVehicle() ) or not self == LocalPlayer():GetVehicle() then return end
		local rear = false
		local fastest, nearest = self:Photon_RadarTargetSpeeds( rear )
		PHOTON_RADAR_DISP_FAST = fastest or 0
		PHOTON_RADAR_DISP_NEAR = nearest or 0
		if not GetConVar("photon_radar_sound"):GetBool() then return end
		local soundSpeed = nearest
		if fastest > nearest then soundSpeed = fastest end
		local handle = self.PhotonRadarSoundHandle
		if not handle then self:Photon_RadarSoundInitialize(); return end
		handle:SetPos( self:GetPos() )
		if soundSpeed > 1 then
			local result = ( math.Round( soundSpeed / 10) / 10 ) + .5
			handle:Play()
			if result > 0 then handle:SetPlaybackRate( result ) else handle:Pause() end
		else
			handle:Pause()
		end
	end

	function emv:Photon_RadarActive( arg )
		if EMVU.DisabledRadars[self:EMVName()] then return false end
		local prev = self.PhotonRadarActive or false
		if arg != nil then self.PhotonRadarActive = arg end
		if arg == false and IsValid( self.PhotonRadarSoundHandle ) then self.PhotonRadarSoundHandle:Pause() end
		return self.PhotonRadarActive
	end

	function emv:Photon_ManualWindUpdate()
		if not self:Photon_HasManualWind() or self.PhotonManualSirenProcessing then return false end
		local isWindingUp = self:Photon_ManualSiren()
		local info = EMVU.GetSirenTable()[self:Photon_SirenSet()].Gain
		if not self.Photon_ManualSirenTable then self.Photon_ManualSirenTable = {} end
		local sirenState = self.Photon_ManualSirenTable

		if not sirenState.SoundHandle or not IsValid( sirenState.SoundHandle ) then
			self.PhotonManualSirenProcessing = true
			local emv = self
			sound.PlayFile( info.Sound, "3d", function( snd, errorNo, errorName )
				if IsValid( emv ) and IsValid( snd ) then
					snd:Pause()
					emv:Photon_ManualWindCallback( snd )
					EMVU.ManualSirenTable[tostring(snd)] = { snd, self }
				end
			end)
			return
		end

		local currentRate = sirenState.SoundHandle:GetPlaybackRate()
		local minRate = info.MinRate or decreaseRate
		local maxRate = info.MaxRate or 1.25
		if isWindingUp and not self:Photon_Siren() then
			sirenState.ShouldPlay = true
			local increaseRate = info.UpRate or .01
			if currentRate < maxRate then
				-- sirenState.SoundHandle:SetPlaybackRate( Lerp( currentRate/maxRate, minRate, maxRate ) )
				sirenState.SoundHandle:SetPlaybackRate( currentRate + increaseRate )
			end
			sirenState.SoundHandle:EnableLooping( true )
			sirenState.SoundHandle:Play()
		else
			local decreaseRate = info.DownRate or .006

			if currentRate > minRate and sirenState.ShouldPlay and not self:Photon_Siren() then
				local newRate = currentRate - decreaseRate
				if newRate < .005 then newRate = .005 end
				sirenState.SoundHandle:SetPlaybackRate( newRate )
				sirenState.SoundHandle:Play()
			else
				sirenState.SoundHandle:Pause()
				sirenState.SoundHandle:SetPlaybackRate( minRate )
				sirenState.ShouldPlay = false
			end
		end
		local forwardDir = self:GetForward()
		forwardDir:Rotate( Angle( 0, 90, 0 ) )
		sirenState.SoundHandle:SetPos( self:GetPos(), forwardDir )
		if system.HasFocus() then sirenState.SoundHandle:SetVolume( 1 ) else sirenState.SoundHandle:SetVolume( 0 ) end
	end

	function emv:Photon_ManualWindFocus()
		if not self.Photon_ManualSirenTable then return end
		if not IsValid( self.Photon_ManualSirenTable.SoundHandle ) then return end
		if system.HasFocus() then self.Photon_ManualSirenTable.SoundHandle:SetVolume( 1 ) else self.Photon_ManualSirenTable.SoundHandle:SetVolume( 0 ) end
	end

	function emv:Photon_ManualWindCallback( snd )
		if not IsValid( snd ) then return end
		if not self.Photon_ManualSirenTable then self.Photon_ManualSirenTable = {} end
		snd:EnableLooping( false )
		snd:Pause()
		snd:SetPlaybackRate( .005 )
		snd:Set3DFadeDistance( 500, 1000 )
		snd:Set3DCone( 90, 180, .88 )
		snd:SetVolume( 1 )
		self.Photon_ManualSirenTable.SoundHandle = snd
		self.Photon_ManualSirenTable.ShouldPlay = false
		self.PhotonManualSirenProcessing = false
	end

	function emv:Photon_HasManualWind()
		local set = self:Photon_SirenSet()
		if set == 0 then return false end
		return istable( EMVU.GetSirenTable()[set].Gain )
	end

	function emv:Photon_ApplyEquipmentPreset( presetData )
		for index, value in pairs( presetData ) do
			EMVU.Net.Selection( self, index, value )
		end
	end

	function emv:Photon_ApplyEquipmentConfiguration( index )
		local data
		if isnumber( index ) then
			local shortId = EMVU.Configurations.Supported[ self:EMVName() ]
			if EMVU.Configurations.Library[ shortId ] and EMVU.Configurations.Library[shortId][ index ]then data = EMVU.Configurations.Library[ shortId ][ index ] end
		end
		if data.Skin then EMVU.Net.ApplyAutoSkin( self, data.Skin ) end
		if data.Siren then
			local convertedSiren = tonumber( data.Siren )
			if isnumber( convertedSiren ) then EMVU.Net:SirenSet( convertedSiren, self, false ) end
		end
		if data.AuxSiren then
			local convertedSiren = tonumber( data.AuxSiren )
			if isnumber( convertedSiren ) then EMVU.Net:SirenSet( convertedSiren, self, true ) end
		end
		if istable( data.Selections ) then
			local convertedTable = self:Photon_ImportSelectionData( data.Selections )
			self:Photon_ApplyEquipmentPreset( convertedTable )
		end
		if istable( data.Color ) then
			local c = data.Color
			EMVU.Net:Color( self, Color( c.r or 255, c.g or 255, c.b or 255 ) )
		end
	end

	function emv:Photon_GetAvailableConfigurations()
		if not self:Photon_SupportsConfigurations() then return {} end
		local shortId = EMVU.Configurations.Supported[ self:EMVName() ]
		return EMVU.Configurations.Library[ shortId ]
	end

	emv.LastPresetOption = 0
	emv:Photon_SetupEMVProps()
	emv.PhotonFinishedInit = true
end

local nextDoppler = 0
local thirdPersonVolume = 0.6
local interiorVolume = 0.2
local fadeDist = 4500
local updateRate = 0.1
local sirenTypes = {
	"EMVU_Siren",
	"EMVU_Siren2",
	"EMVU_ManualSiren",
	"EMVU_Horn"
}

hook.Add( "PreDrawTranslucentRenderables", "Photon.ELS_SirenDoppler_FixEyePos", function()
	EyePos()
end )

hook.Add("Think", "Photon.ELS_SirenDoppler", function()
	if nextDoppler < CurTime() then
	local ply = LocalPlayer()
	local pos = EyePos()
	local viewEnt = GetViewEntity() or LocalPlayer()
	local camVel = viewEnt:GetVelocity() or 0

	local plyVeh = false
	if viewEnt == ply then
		plyVeh = ply:GetVehicle()
	end
		for _,v in ipairs(EMVU:AllVehicles()) do
			for idx, sirenType in ipairs(sirenTypes) do
				local currentSiren = v[sirenType]
				if currentSiren then
					local driver = v:GetDriver()
					local spos = v:GetPos()
					local doppler = ((pos:Distance(spos+camVel)-pos:Distance(spos+v:GetVelocity()))/200)
					if IsValid(plyVeh) then
						if plyVeh:GetParent() == v then
							doppler = 0
						end
					end
					updateRate = FrameTime()

					if (IsValid(driver) and driver ~= viewEnt) or !IsValid(driver) then
						local distBehind = v:WorldToLocal(viewEnt:GetPos())[2]

						if IsValid(plyVeh) then
							if plyVeh:GetParent() == v then
								if currentSiren:GetVolume() ~= thirdPersonVolume and plyVeh:GetThirdPersonMode() then
									currentSiren:ChangeVolume(thirdPersonVolume, updateRate)
								elseif currentSiren:GetVolume() ~= interiorVolume and !plyVeh:GetThirdPersonMode() then
									currentSiren:ChangeVolume(interiorVolume, updateRate)
								end
							end
						else
							if currentSiren:GetVolume() ~= 1 and distBehind > 0 then
								currentSiren:ChangeVolume(1, updateRate)
							elseif distBehind < 0 then
								currentSiren:ChangeVolume(math.Clamp(1 + (distBehind/fadeDist), 0.05, 1), updateRate)
							end
						end

						if math.abs(doppler) > 1 then
								currentSiren:ChangePitch(math.Clamp(100 + doppler, 50, 150), updateRate)
							elseif currentSiren:GetPitch() ~= 100 then
								currentSiren:ChangePitch(100, updateRate)
						end
					else
						if currentSiren:GetPitch() ~= 100 then
							currentSiren:ChangePitch(100)
						end
						if currentSiren:GetVolume() ~= thirdPersonVolume and v:GetThirdPersonMode() then
							currentSiren:ChangeVolume(thirdPersonVolume, updateRate)
						elseif currentSiren:GetVolume() ~= interiorVolume and !v:GetThirdPersonMode() then
							currentSiren:ChangeVolume(interiorVolume, updateRate)
						end
					end
				end
			end
		end
		nextDoppler = CurTime() + updateRate
	end
end)

net.Receive("Photon.ELS_PlaySiren", function()
	local ent = net.ReadEntity()
	if IsValid(ent) and !IsValid(ent.EMVU_Siren) then
		local sound = net.ReadString()
		local volume = net.ReadFloat()
		ent.EMVU_Siren = CreateSound(ent, sound)
		ent.EMVU_Siren:SetSoundLevel( volume * 1.8 )
		if ent:GetThirdPersonMode() then
			ent.EMVU_Siren:PlayEx(thirdPersonVolume, 100)
		elseif !ent:GetThirdPersonMode() then
			ent.EMVU_Siren:PlayEx(interiorVolume, 100)
		else
			ent.EMVU_Siren:PlayEx(1, 100)
		end
		--ent.EMVU_Siren:ChangeVolume(0)
		--ent.EMVU_Siren:SetDSP(1)
		ent:CallOnRemove("StopSiren", function(ent)
			if ent.EMVU_Siren then
				ent.EMVU_Siren:Stop()
			end
		end)
	--ent.ELS.Siren = siren
	end
end)

net.Receive("Photon.ELS_StopSiren", function()
	local ent = net.ReadEntity()
	if IsValid(ent) then
		if ent.EMVU_Siren then
			ent.EMVU_Siren:Stop()
			ent.EMVU_Siren = nil
		end
	end
end)

net.Receive("Photon.ELS_PlaySiren2", function()
	local ent = net.ReadEntity()
	if IsValid(ent) and !IsValid(ent.EMVU_Siren2) then
		local sound = net.ReadString()
		local volume = net.ReadFloat()
		ent.EMVU_Siren2 = CreateSound(ent, sound)
		ent.EMVU_Siren2:SetSoundLevel( volume * 1.25 )
		if ent:GetThirdPersonMode() then
			ent.EMVU_Siren2:PlayEx(thirdPersonVolume, 100)
		elseif !ent:GetThirdPersonMode() then
			ent.EMVU_Siren2:PlayEx(interiorVolume, 100)
		else
			ent.EMVU_Siren2:PlayEx(1, 100)
		end
		--ent.EMVU_Siren:ChangeVolume(0)
		--ent.EMVU_Siren:SetDSP(129)
		ent:CallOnRemove("StopSiren2", function(ent)
			if ent.EMVU_Siren2 then
				ent.EMVU_Siren2:Stop()
			end
		end)
	end
	--ent.ELS.Siren = siren
end)

net.Receive("Photon.ELS_StopSiren2", function()
	local ent = net.ReadEntity()
	if IsValid(ent) then
		if ent.EMVU_Siren2 then
			ent.EMVU_Siren2:Stop()
			ent.EMVU_Siren2 = nil
		end
	end
end)

net.Receive("Photon.ELS_PlayManual", function()
	local ent = net.ReadEntity()
	if IsValid(ent) and !IsValid(ent.EMVU_ManualSiren) then
		local sound = net.ReadString()
		local volume = net.ReadFloat()
		ent.EMVU_ManualSiren = CreateSound(ent, sound)
		ent.EMVU_ManualSiren:SetSoundLevel( volume * 1.25 )
		if ent:GetThirdPersonMode() then
			ent.EMVU_ManualSiren:PlayEx(thirdPersonVolume, 100)
		elseif !ent:GetThirdPersonMode() then
			ent.EMVU_ManualSiren:PlayEx(interiorVolume, 100)
		else
			ent.EMVU_ManualSiren:PlayEx(1, 100)
		end

		if ent.EMVU_Siren then
			ent.EMVU_Siren:Stop()
		end

		ent:CallOnRemove("StopManualSiren", function(ent)
			if ent.EMVU_ManualSiren then
				ent.EMVU_ManualSiren:Stop()
			end
		end)
	--ent.ELS.Siren = siren
	end
end)

net.Receive("Photon.ELS_StopManual", function()
	local ent = net.ReadEntity()
	if IsValid(ent) then
		if ent.EMVU_Siren then
			if ent:GetThirdPersonMode() then
				ent.EMVU_Siren:PlayEx(thirdPersonVolume, 100)
			elseif !ent:GetThirdPersonMode() then
				ent.EMVU_Siren:PlayEx(interiorVolume, 100)
			else
				ent.EMVU_Siren:PlayEx(1, 100)
			end
		end

		if ent.EMVU_ManualSiren then
			ent.EMVU_ManualSiren:Stop()
			ent.EMVU_ManualSiren = nil
		end
	end
end)

net.Receive("Photon.ELS_PlayHorn", function()
	local ent = net.ReadEntity()
	if IsValid(ent) and !IsValid(ent.EMVU_Horn) then
		local sound = net.ReadString()
		local volume = net.ReadFloat()
		ent.EMVU_Horn = CreateSound(ent, sound)
		ent.EMVU_Horn:SetSoundLevel( volume * 1.25 )
		if ent:GetThirdPersonMode() then
			ent.EMVU_Horn:PlayEx(thirdPersonVolume, 100)
		elseif !ent:GetThirdPersonMode() then
			ent.EMVU_Horn:PlayEx(interiorVolume, 100)
		else
			ent.EMVU_Horn:PlayEx(1, 100)
		end
		ent:CallOnRemove("StopHorn", function(ent)
			if ent.EMVU_Horn then
				ent.EMVU_Horn:Stop()
			end
		end)
		--ent.ELS.Siren = siren
	end
end)

net.Receive("Photon.ELS_StopHorn", function()
	local ent = net.ReadEntity()
	if IsValid(ent) then
		if ent.EMVU_Horn then
			ent.EMVU_Horn:Stop()
			ent.EMVU_Horn = nil
		end
	end
end)

hook.Add("NotifyShouldTransmit", "Photon.ShouldTransmitSirens", function(ent, shouldtransmit)

	if ent:GetNW2String("PhotonLE.Siren_Sound") ~= "" and !IsValid(ent.EMVU_Siren) then
		local sound = ent:GetNW2String("PhotonLE.Siren_Sound")
		local volume = ent:GetNW2Float("PhotonLE.Siren_Volume")
		ent.EMVU_Siren = CreateSound(ent, sound)
		ent.EMVU_Siren:SetSoundLevel( volume * 0.05 )
		ent.EMVU_Siren:PlayEx(1, 100)
		ent:CallOnRemove("StopSiren", function(ent)
			if ent.EMVU_Siren then
				ent.EMVU_Siren:Stop()
			end
		end)
	end

	if ent:GetNW2String("PhotonLE.Siren2_Sound") ~= "" and !IsValid(ent.EMVU_Siren2) then
		local sound = ent:GetNW2String("PhotonLE.Siren2_Sound")
		local volume = ent:GetNW2Float("PhotonLE.Siren_Volume")
		ent.EMVU_Siren2 = CreateSound(ent, sound)
		ent.EMVU_Siren2:SetSoundLevel( volume * 0.05 )
		ent.EMVU_Siren2:PlayEx(1, 100)
		ent:CallOnRemove("StopSiren2", function(ent)
			if ent.EMVU_Siren2 then
				ent.EMVU_Siren2:Stop()
			end
		end)
	end

	if ent:GetNW2String("PhotonLE.Manual_Sound") ~= "" and !IsValid(ent.EMVU_ManualSiren) then
		local sound = ent:GetNW2String("PhotonLE.Manual_Sound")
		local volume = ent:GetNW2Float("PhotonLE.Siren_Volume")
		ent.EMVU_ManualSiren = CreateSound(ent, sound)
		ent.EMVU_ManualSiren:SetSoundLevel( volume * 0.05 )
		ent.EMVU_ManualSiren:PlayEx(1, 100)
		ent:CallOnRemove("StopManualSiren", function(ent)
			if ent.EMVU_ManualSiren then
				ent.EMVU_ManualSiren:Stop()
			end
		end)
	end

	if ent:GetNW2String("PhotonLE.Horn_Sound") ~= "" and !IsValid(ent.EMVU_Horn) then
		local sound = ent:GetNW2String("PhotonLE.Horn_Sound")
		local volume = ent:GetNW2Float("PhotonLE.Siren_Volume")
		ent.EMVU_Horn = CreateSound(ent, sound)
		ent.EMVU_Horn:SetSoundLevel( volume * 0.05 )
		ent.EMVU_Horn:PlayEx(1, 100)
		ent:CallOnRemove("StopHorn", function(ent)
			if ent.EMVU_Horn then
				ent.EMVU_Horn:Stop()
			end
		end)
	end
end)

photonLightModels = {}
