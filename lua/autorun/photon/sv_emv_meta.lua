
function EMVU:MakeEMV( ent, emv )

	// Avoid any uncaught errors if a bad entity is passed in
	if not ent or not IsValid( ent ) or not ent:IsVehicle() then
		error("[EMV Upgrade] Error while creating ent from " .. tostring(ent) .. ". Aborting...")
		return
	end

	ent.ELS = {} // Emergency Lights and Sirens

	//-------- DATATABLE FUNCTIONS ---------//
	//
	// Optional parameters to set value, otherwise
	// it will return the value.
	//

	// whether or not the car truly uses emergency lights
	function ent:ELS_Enabled( val )
		if not IsValid( self ) then return end
		if (val!=nil) then self:SetDTBool(CAR_USE_EL, val) end
		return self:GetDTBool(CAR_USE_EL)

	end

	// Lights on/off
	function ent:ELS_Lights( val )
		if not IsValid( self ) then return end
		if (val!=nil) then self:SetDTBool(EMV_LIGHTS_ON, val) end
		return self:GetDTBool(EMV_LIGHTS_ON)

	end

	// Light pattern/option
	function ent:ELS_LightOption( val )
		if not IsValid( self ) then return end
		if (val!=nil) then self:SetDTInt(EMV_LIGHT_OPTION, val) end
		return self:GetDTInt(EMV_LIGHT_OPTION)

	end

	// Siren on/off
	function ent:ELS_Siren( val )
		if not IsValid( self ) then return end
		if (val!=nil) then self:SetDTBool(EMV_SIREN_ON, val) end
		return self:GetDTBool(EMV_SIREN_ON)
	end

	// Siren tone
	function ent:ELS_SirenOption( val )
		if not IsValid( self ) then return end
		if (val!=nil) then self:SetDTInt(EMV_SIREN_OPTION, val) end
		return self:GetDTInt(EMV_SIREN_OPTION)
	end

	// Siren set
	function ent:ELS_SirenSet( val )
		if not IsValid( self ) then return end
		if (val!=nil) then 
			self:ELS_SirenOption( 1 )
			self:SetDTInt(EMV_SIREN_SET, val) 
		end
		return self:GetDTInt(EMV_SIREN_SET)
	end

	// Traffic on/off
	function ent:ELS_Traffic( val )
		if not IsValid( self ) then return end
		if (val!=nil) then self:SetDTBool( EMV_TRF_ON, val ) end
		return self:GetDTBool( EMV_TRF_ON )
	end

	// Traffic direction
	function ent:ELS_TrafficOption( val )
		if not IsValid( self ) then return end
		if (val!=nil) then self:SetDTInt (EMV_TRF_OPTION, val ) end
		return self:GetDTInt( EMV_TRF_OPTION )
	end

	// Takedowns/alley lights on/off
	function ent:ELS_Illuminate( val )
		if not IsValid( self ) then return end
		if (val!=nil) then self:SetDTBool( EMV_ILLUM_ON, val ) end
		return self:GetDTBool( EMV_ILLUM_ON )
	end

	// Takedowns/alley lights option
	function ent:ELS_IlluminateOption( val )
		if not IsValid( self ) then return end
		if (val!=nil) then self:SetDTInt( EMV_ILLUM_OPTION, val ) end
		return self:GetDTInt( EMV_ILLUM_OPTION )
	end

	function ent:ELS_PresetOption( val )
		if not IsValid( self ) then return 0 end
		if not EMVU.PresetIndex[ self.Name ] then print( "[Photon] No presets found for " .. tostring( self.Name ) .. ". Please check for errors above." ) return end
		if (val!=nil) then 
			val = math.Clamp( val, 0, #EMVU.PresetIndex[ self.Name ] )
			self:SetDTInt( EMV_PRE_OPTION, val )
			local bgData = EMVU.Helper:BodygroupPreset( self, val )
			for _,bg in pairs( bgData ) do
				self:SetBodygroup( bg[1], bg[2] )
			end
		end
		return self:GetDTInt( EMV_PRE_OPTION )
	end

	function ent:ELS_IllumOn()
		if not IsValid( self ) then return end
		local usesLamps = EMVU.Helper:HasLamps( self.Name )
		if not usesLamps then return false end
		self:ELS_Illuminate( true )
		if not self.ELS_Lamps then self.ELS_Lamps = {} end

		local lampMode = self:ELS_IlluminateOption()
		local lamps = EMVU.Helper:GetIlluminationLights( self.Name, lampMode )
		for k,l in pairs( lamps ) do

			local pos = l[1]
			local ang = l[2]
			local lampMeta = EMVU.Helper:GetLampMeta( self.Name, l[3] )

			local lamp = ents.Create( "env_projectedtexture" )
			lamp:SetParent( self )
			lamp:SetLocalPos( pos )
			lamp:SetLocalAngles( ang )

			lamp:SetKeyValue( "enableshadows", 1 )
			lamp:SetKeyValue( "farz", lampMeta.Distance )
			lamp:SetKeyValue( "nearz", lampMeta.Near )
			lamp:SetKeyValue( "lightfov", lampMeta.FOV )
			lamp:SetKeyValue( "lightcolor", Format("%i %i %i 255", lampMeta.Color.r, lampMeta.Color.g, lampMeta.Color.b ) )

			lamp:Spawn()
			lamp:Input( "SpotlightTexture", NULL, NULL, lampMeta.Texture )

			table.insert( self.ELS_Lamps, lamp )

		end

	end

	function ent:ELS_IllumOff()
		if not IsValid( self ) then return end
		self:ELS_Illuminate( false )
		if not self.ELS_Lamps then return end
		for _,lamp in pairs( self.ELS_Lamps ) do
			SafeRemoveEntity( lamp )
		end

	end

	function ent:ELS_IllumToggle()
		if not IsValid( self ) then return end
		local usesLamps = EMVU.Helper:HasLamps( self.Name )
		if not usesLamps then return false end
		local maxOptions = #EMVU.Sequences[self.Name].Illumination
		if self:ELS_IlluminateOption() >= maxOptions then
			self:ELS_IlluminateOption( 1 )
		else
			self:ELS_IlluminateOption( self:ELS_IlluminateOption() + 1 )
		end
		if self:ELS_Illuminate() then self:ELS_IllumOff(); self:ELS_IllumOn() end
	end

	function ent:ELS_TrafficOn()
		if not IsValid( self ) then return end
		self:ELS_Traffic( true )
	end

	function ent:ELS_TrafficOff()
		if not IsValid( self ) then return end
		self:ELS_Traffic( false )
	end

	function ent:ELS_TrafficToggle()
		if not IsValid( self ) then return end
		local maxSequences = #EMVU.Sequences[self.Name].Traffic
		if self:ELS_TrafficOption() >= maxSequences then
			self:ELS_TrafficOption( 1 )
		else
			self:ELS_TrafficOption( self:ELS_TrafficOption() + 1 )
		end
	end

	// Turn the lights on
	function ent:ELS_LightsOn()
		if not IsValid( self ) then return end
		self:ELS_Lights( true )
		--self:ELS_TakeDownCheck()
		self:ELS_Blackout( false )

	end

	// Turn the lights off
	function ent:ELS_LightsOff()
		if not IsValid( self ) then return end
		self:ELS_SirenOff()
		self:ELS_Lights( false )
		//self:ELS_TakeDownCheck()

	end

	function ent:ELS_LightsToggle()
		if not IsValid( self ) then return end
		local maxSequences = #EMVU.Sequences[self.Name].Sequences
		if self:ELS_LightOption() >= maxSequences then
			self:ELS_LightOption(1)
		else
			self:ELS_LightOption(self:ELS_LightOption() + 1)
		end
	end

	// Turn the siren off
	function ent:ELS_SirenOff( toneChange )
		if not IsValid( self ) then return end
		if not self.ELS.Siren then return end
		self.ELS.SirenContinue = nil
		self.ELS.Siren:Stop()
		if not toneChange then self.ELS.Siren2:Stop() end
		self:ELS_Siren(false)
		self.ELS.SirenPaused = false
	end

	// Turn the siren on
	function ent:ELS_SirenOn()
		if not IsValid( self ) then return end
		if self:ELS_NoSiren() then return end
		if self:ELS_Siren() then self:ELS_SirenOff() end
		if not self:ELS_Lights() then self:ELS_LightOption( #EMVU.Sequences[self.Name].Sequences ) end
		self:ELS_LightsOn()
		self.ELS.Siren = CreateSound( self, EMVU.Sirens[self:ELS_SirenSet()].Set[self:ELS_SirenOption()].Sound )
		self.ELS.Siren:SetSoundLevel( 75 )
		
		local secondIndex = 1
		if self.ELS.LastSecondSiren != secondIndex and self.ELS.LastSecondSiren then self.ELS.Siren2:Stop(); self.ELS.LastSecondSiren = secondIndex end
		if self:ELS_SirenOption() > 2 then secondIndex = 2 end
		self.ELS.Siren2 = CreateSound( self, EMVU.Sirens[3].Set[secondIndex].Sound )
		self.ELS.Siren2:SetSoundLevel( 75 )
		self:ELS_Siren( true )
	end

	function ent:ELS_SirenPause()
		if self:ELS_Siren() then
			self.ELS.SirenPaused = true
			self.ELS.Siren:Stop()
		end
	end

	function ent:ELS_SirenResume()
		if self:ELS_Siren() then
			self:ELS_SirenContinue( true )
			self.ELS.SirenPaused = false
		end
	end

	function ent:ELS_SirenContinue( force )
		if not IsValid( self ) then return end
		if not self:ELS_Siren() then return end
		if not self.ELS.Siren then return end
		if self.ELS.SirenPaused and not force then return end
		if ( self.ELS.SirenContinue and self.ELS.SirenContinue + 2 > CurTime() ) and not force then return end
		self.ELS.Siren:PlayEx( 0, 100 )
		self.ELS.Siren2:PlayEx( 0, 100 )
		self.ELS.Siren:ChangeVolume( 2, 0 )
		self.ELS.Siren2:ChangeVolume( 2, 0 )
		self.ELS.SirenContinue = CurTime()
	end

	function ent:ELS_SirenToggle()
		if not IsValid( self ) then return end
		if self:ELS_NoSiren() then return end
		if self:ELS_SirenOption() >= #EMVU.Sirens[self:ELS_SirenSet()].Set then
			self:ELS_SirenOption( 1 )
		else
			self:ELS_SirenOption( self:ELS_SirenOption() + 1 )
		end

		if self:ELS_Siren() then
			self:ELS_SirenOff( true )
			self:ELS_SirenOn()
		end

	end

	function ent:ELS_SirenSetToggle()
		if not IsValid( self ) then return end
		if self:ELS_NoSiren() then return end
		local wasOn = self:ELS_Siren()

		if wasOn then self:ELS_SirenOff() end

		if self:ELS_SirenSet() >= #EMVU.Sirens then
			self:ELS_SirenSet( 1 )
		else
			self:ELS_SirenSet( self:ELS_SirenSet() + 1 )
		end

		if wasOn then self:ELS_SirenOn() end

	end

	function ent:ELS_SetSirenSet( num )
		if not IsValid( self ) then return end
		if num <= 0 or num > #EMVU.Sirens then return false end

		self:ELS_SirenOff()
		self:ELS_SirenSet( num )

	end

	function ent:ELS_ManualSiren( state, gain )
		if not IsValid( self ) then return end
		if self:ELS_NoSiren() then return end

		if state then
			//if self:ELS_SirenOption() == 1 and self:ELS_Siren() then return end
			self:SetDTBool( CAR_MANUAL, true )
			if not self:Photon_HasManualWind() then
				local manSiren = EMVU.Sirens[self:ELS_SirenSet()].Set[1].Sound
				if EMVU.Sirens[self:ELS_SirenSet()].Manual then manSiren = EMVU.Sirens[self:ELS_SirenSet()].Manual end
				if self:ELS_Siren() then
					local manualToneIndex = self:ELS_SirenOption() + 1
					local manualTone = EMVU.Horns[1]
					if manualToneIndex <= #EMVU.Sirens[ self:ELS_SirenSet() ].Set 
						and EMVU.Sirens[ self:ELS_SirenSet() ].Set[ manualToneIndex ].Name != "HILO"
					 then
						manualTone = EMVU.Sirens[ self:ELS_SirenSet() ].Set[ manualToneIndex ].Sound
					elseif EMVU.Sirens[self:ELS_SirenSet()].Horn then
						manualTone = EMVU.Sirens[self:ELS_SirenSet()].Horn
					end
					self:ELS_SirenPause()
					manSiren = manualTone
				end
				self.ELS.Manual = CreateSound( self, manSiren )
				self.ELS.Manual:SetSoundLevel( 75 )
				self.ELS.Manual:PlayEx( 0, 100 )
				self.ELS.Manual:ChangeVolume( 1, 0 )
			end
		else
			if not self:Photon_HasManualWind() then
				local windDown = EMVU.Sirens[self:ELS_SirenSet()].ManualWind
				if windDown then
					if self.ELS.Manual then self.ELS.Manual:FadeOut( 1 ) end
				else
					if self.ELS.Manual then self.ELS.Manual:Stop() end
					if self:ELS_Siren() then
						self:ELS_SirenResume()
					end
				end
			end
			self:SetDTBool( CAR_MANUAL, false )
 		end
	end

	function ent:ELS_Horn( state )
		if not IsValid( self ) then return end
		if self:ELS_NoSiren() then return end
		if state then
			self:SetDTBool( EMV_HORN, true )
			local horn = EMVU.Horns[1]
			if EMVU.Sirens[self:ELS_SirenSet()].Horn then horn = EMVU.Sirens[self:ELS_SirenSet()].Horn end
			self.ELS.Horn = CreateSound( self, horn )
			self.ELS.Horn:SetSoundLevel( 75 )
			self.ELS.Horn:PlayEx( 0, 100 )
			self.ELS.Horn:ChangeVolume( 1, 0 )
		else
			self:SetDTBool( EMV_HORN, false )
			if self.ELS.Horn then self.ELS.Horn:Stop() end
		end
	end

	function ent:ELS_Blackout( state )
		if not IsValid( self ) then return end
		if self:ELS_NoSiren() then return end
		if state then
			self.ELS.Blackout = true
		elseif state == false then
			self.ELS.Blackout = false
		end
		return self.ELS.Blackout
	end

	function ent:ELS_BlackoutToggle()
		if not IsValid( self ) then return end
		local state = true
		if self:ELS_Blackout() then state = false end
		self:ELS_Blackout( state )
	end

	function ent:ELS_NoSiren()
		if not IsValid( self ) then return end
		return self:ELS_SirenSet() == 0
	end

	function ent:ApplySmartSkin( mat, index, skin )
		if not IsValid( self ) then return end
		local submaterialIndex = false
		if skin then 
			submaterialIndex = skin
		else
			local materials = self:GetMaterials()
			for i=1,#materials do
				local thisMat = tostring( materials[i] )
				if string.EndsWith( thisMat, "/skin" ) or string.EndsWith( thisMat, "/skin0" ) then
					submaterialIndex = i - 1
					break
				end
			end
		end
		if submaterialIndex == false then return end
		if index then self:SetSkin( index ) else self:SetSkin( 0 ) end
		self:SetSubMaterial( submaterialIndex, tostring( mat ) )
	end

	function ent:ApplyPhotonSkin( skin, index, mat )
		if isnumber( skin ) then
			self:SetSkin( skin )
		elseif isstring( skin ) and index != nil and mat != nil then
			self:ApplySmartSkin( skin, index, mat )
		elseif isstring( skin ) then
			self:ApplySmartSkin( skin )
		end
	end

	function ent:Photon_ApplyLivery( category, index, unit )
		if not IsValid( self ) then return end
		// print( "instructed to apply: " .. index .. " from " .. category .. " with unit #" .. tostring( unit ) )
		local available = EMVU.Liveries[ self.Name ]
		if not available[category] or not available[category][index] then return end
		local liveryData = available[category][index]
		if istable( liveryData ) then
			if liveryData[1] and liveryData[2] then
				local liveryId = liveryData[2]
				local cleanUnit = self:Photon_SetUnitNumber( unit )
				self:Photon_SetLiveryId( liveryId )
				Photon.Net:NotifyLiveryUpdate( liveryId, cleanUnit, self )
			end
		elseif isstring( liveryData ) then
			self:ApplyPhotonSkin( liveryData )
			// self:ApplyPhotonSkin( liveryData[1] )
			// self:Photon_SetLiveryId( liveryData[2] )
		end
	end

	function ent:Photon_SetLiveryId( val )
		local curdata = string.Explode( "ö", self:GetDTString( EMV_INDEX ), false )
		curdata[4] = val
		self:SetDTString( EMV_INDEX, ( table.concat( curdata, "ö" ) )
 )	end

	function ent:Photon_SetUnitNumber( val )
		val = string.upper( tostring( val ) )
		if string.len( val ) > 3 then val = string.sub( val, 1, 3 ) end
		if not string.match( val, "%w" ) then val = "" end
		if PHOTON_BANNED_UNIT_IDS[ string.lower( val ) ] then val = "" end
		local curdata = string.Explode( "ö", self:GetDTString( EMV_INDEX ), false )
		curdata[3] = val
		self:SetDTString( EMV_INDEX, table.concat( curdata, "ö" ) )
		return val
	end

	function ent:Photon_ApplySubMaterials()
		if istable( EMVU.SubMaterials[ self.Name ] ) then
			local submaterials = EMVU.SubMaterials[ self.Name ]
			for index, value in pairs( submaterials ) do
				if isnumber( tonumber( index ) ) then
					self:SetSubMaterial( tonumber( index ), value )
				end
			end
		end
	end

	function ent:Photon_SetSelection( index, value )
			-- print(string.format( "index: %s value: %s", index, value ))
		if istable( EMVU.Selections[ self.Name ][ index ] ) then
			local selectionTable = self:Photon_SelectionTable()
			selectionTable[index] = value
			-- PrintTable( selectionTable )
			local photonUtilString = self:Photon_GetUtilStringTable()
			photonUtilString[5] = table.concat( selectionTable, "." )
			//PrintTable( photonUtilString )
			self:Photon_SetUtilString( table.concat( photonUtilString, "ö" ) )
		end
	end

	function ent:Photon_ResetSelections()
		if istable( EMVU.Selections[ self.Name ] ) then
			for i=1,#EMVU.Selections[ self.Name ] do
				self:Photon_SetSelection( i, 1 )
			end
		end
	end

	function ent:Photon_SetUtilString( str )
		self:SetDTString( EMV_INDEX, str )
	end

	function ent:Photon_HasManualWind()
		local set = self:ELS_SirenSet()
		return istable( EMVU.Sirens[set].Gain )
	end

	ent.IsEMV = true
	ent:SetDTString( EMV_INDEX, "ö" .. tostring( ent.Name ) .. "ööö." ) // Al

	//---- APPLY EMV PARAMETERS ----//

	if emv.Skin then ent:ApplyPhotonSkin( emv.Skin, emv.SkinIndex, emv.SkinMaterialIndex ) end

	if emv.Color then ent:SetColor( emv.Color ) end

	if emv.BodyGroups then

		for _,group in pairs( emv.BodyGroups) do
			ent:SetBodygroup( group[1], group[2] )
		end

	end

	if emv.Siren then
		ent:ELS_SetSirenSet( emv.Siren )
	else
		ent:ELS_SetSirenSet( 1 )
	end

	if istable( emv.Auto ) and emv.Auto[1] and istable( emv.Presets ) then
		ent:ELS_PresetOption( 1 )
	end

	ent:ELS_SirenOption( 1 )
	ent:ELS_LightOption( 1 )
	ent:ELS_IlluminateOption ( 1 )
	ent:ELS_TrafficOption( 1 )
	ent:ELS_SirenOff()
	ent:ELS_LightsOff()
	ent:ELS_Enabled( true )
	ent:Photon_ApplySubMaterials()
	ent:Photon_ResetSelections()
end

-- concommand.Add("makecaronme", function(ply)
-- 	local ent = ents.Create("prop_vehicle_jeep")
-- 	ent:SetModel( "models/LoneWolfie/chev_impala_09_police.mdl" )
-- 	ent:SetKeyValue( "vehiclescript", "scripts/vehicles/LWCars/chev_impala_09.txt" )
-- 	ent:SetPos( ply:GetPos() )
-- 	ent:SetAngles( ply:GetAngles() )
-- 	ent:Spawn()
-- 	ent:Activate()
-- end)