util.AddNetworkString("Photon.ELS_PlaySiren")
util.AddNetworkString("Photon.ELS_StopSiren")
util.AddNetworkString("Photon.ELS_PlaySiren2")
util.AddNetworkString("Photon.ELS_StopSiren2")
util.AddNetworkString("Photon.ELS_PlayManual")
util.AddNetworkString("Photon.ELS_StopManual")
util.AddNetworkString("Photon.ELS_PlayHorn")
util.AddNetworkString("Photon.ELS_StopHorn")

function EMVU:MakeEMV( ent, emv )

	-- Avoid any uncaught errors if a bad entity is passed in
	if not ent or not IsValid( ent ) or not ent:IsVehicle() then
		error("[Photon] Error while creating ent from " .. tostring(ent) .. ". Aborting...")
		return
	end

	ent.ELS = {} -- Emergency Lights and Sirens

	---------- DATATABLE FUNCTIONS -----------
	--
	-- Optional parameters to set value, otherwise
	-- it will return the value.
	--


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

	function ent:ELS_IllumToggleBack()
		if not IsValid( self ) then return end
		local usesLamps = EMVU.Helper:HasLamps( self.Name )
		if not usesLamps then return false end

		local cur = self:ELS_IlluminateOption()
		if cur == 1 then
			self:ELS_IlluminateOption(#EMVU.Sequences[self.Name].Illumination)
		else
			self:ELS_IlluminateOption(cur - 1)
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

	function ent:ELS_TrafficToggleBack()
		if not IsValid( self ) then return end

		local cur = self:ELS_TrafficOption()
		if cur == 1 then
			self:ELS_TrafficOption(#EMVU.Sequences[self.Name].Traffic)
		else
			self:ELS_TrafficOption(cur - 1)
		end
	end

	-- Turn the lights on
	function ent:ELS_LightsOn()
		if not IsValid( self ) then return end
		self:ELS_Lights( true )
		--self:ELS_TakeDownCheck()
		self:ELS_Blackout( false )

	end

	-- Turn the lights off
	function ent:ELS_LightsOff()
		if not IsValid( self ) then return end
		self:ELS_SirenOff()
		self:ELS_Lights( false )
		--self:ELS_TakeDownCheck()

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

	function ent:ELS_LightsToggleBack()
		if not IsValid( self ) then return end

		local cur = self:ELS_LightOption()
		if cur == 1 then
			self:ELS_LightOption(#EMVU.Sequences[self.Name].Sequences)
		else
			self:ELS_LightOption(cur - 1)
		end
	end

	function ent:ELS_SirenPlay(sound)
		net.Start("Photon.ELS_PlaySiren")
			net.WriteEntity(self)
			net.WriteString(sound)
			if EMVU.GetSirenTable()[self:ELS_SirenSet()].Volume then
				net.WriteFloat(EMVU.GetSirenTable()[self:ELS_SirenSet()].Volume )
			else
				net.WriteFloat(75)
			end
		net.Broadcast()
		self:SetNW2String("PhotonLE.Siren_Sound", sound)
		if EMVU.GetSirenTable()[self:ELS_SirenSet()].Volume then
			self:SetNW2Float("PhotonLE.Siren_Volume", EMVU.GetSirenTable()[self:ELS_SirenSet()].Volume )
		else
			self:SetNW2Float("PhotonLE.Siren_Volume", 75 )
		end
	end

	function ent:ELS_SirenStop()
		net.Start("Photon.ELS_StopSiren")
			net.WriteEntity(self)
		net.Broadcast()
		self:SetNW2String("PhotonLE.Siren_Sound", nil)
	end

	function ent:ELS_Siren2Play(sound)
		net.Start("Photon.ELS_PlaySiren2")
			net.WriteEntity(self)
			net.WriteString(sound)
			if EMVU.GetSirenTable()[self:ELS_SirenSet()].Volume then
				net.WriteFloat(EMVU.GetSirenTable()[self:ELS_SirenSet()].Volume )
			else
				net.WriteFloat(75)
			end
		net.Broadcast()
		self:SetNW2String("PhotonLE.Siren2_Sound", sound)
		if EMVU.GetSirenTable()[self:ELS_SirenSet()].Volume then
			self:SetNW2Float("PhotonLE.Siren_Volume", EMVU.GetSirenTable()[self:ELS_SirenSet()].Volume )
		else
			self:SetNW2Float("PhotonLE.Siren_Volume", 75 )
		end
	end

	function ent:ELS_Siren2Stop()
		net.Start("Photon.ELS_StopSiren2")
			net.WriteEntity(self)
		net.Broadcast()
		self:SetNW2String("PhotonLE.Siren2_Sound", nil)
	end

	function ent:ELS_ManualPlay(sound)
		net.Start("Photon.ELS_PlayManual")
			net.WriteEntity(self)
			net.WriteString(sound)
			if EMVU.GetSirenTable()[self:ELS_SirenSet()].Volume then
				net.WriteFloat(EMVU.GetSirenTable()[self:ELS_SirenSet()].Volume )
			else
				net.WriteFloat(75)
			end
		net.Broadcast()
		self:SetNW2String("PhotonLE.Manual_Sound", sound)
		if EMVU.GetSirenTable()[self:ELS_SirenSet()].Volume then
			self:SetNW2Float("PhotonLE.Siren_Volume", EMVU.GetSirenTable()[self:ELS_SirenSet()].Volume )
		else
			self:SetNW2Float("PhotonLE.Siren_Volume", 75 )
		end
	end

	function ent:ELS_ManualStop()
		net.Start("Photon.ELS_StopManual")
			net.WriteEntity(self)
		net.Broadcast()
		self:SetNW2String("PhotonLE.Manual_Sound", nil)
	end

	function ent:ELS_PlayHorn(sound)
		net.Start("Photon.ELS_PlayHorn")
			net.WriteEntity(self)
			net.WriteString(sound)
			if EMVU.GetSirenTable()[self:ELS_SirenSet()].Volume then
				net.WriteFloat(EMVU.GetSirenTable()[self:ELS_SirenSet()].Volume )
			else
				net.WriteFloat(75)
			end
		net.Broadcast()
		self:SetNW2String("PhotonLE.Horn_Sound", sound)
		if EMVU.GetSirenTable()[self:ELS_SirenSet()].Volume then
			self:SetNW2Float("PhotonLE.Siren_Volume", EMVU.GetSirenTable()[self:ELS_SirenSet()].Volume )
		else
			self:SetNW2Float("PhotonLE.Siren_Volume", 75 )
		end
	end

	function ent:ELS_StopHorn()
		net.Start("Photon.ELS_StopHorn")
			net.WriteEntity(self)
		net.Broadcast()
		self:SetNW2String("PhotonLE.Horn_Sound", nil)
	end

	-- Turn the siren off
	function ent:ELS_SirenOff( toneChange )
		if not IsValid( self ) then return end
		--if not self.ELS.Siren then return end
		--if not self.Siren then return end
		self.ELS.SirenContinue = nil
		--self.ELS.Siren:Stop()
		self:ELS_SirenStop()
		if self:ELS_HasAuxSiren() and not toneChange then
			self:ELS_Siren2Stop()
			self.ELS.CurrentSecondarySiren = ""
		end
		self:ELS_Siren(false)
		self.ELS.SirenPaused = false
	end

	-- Turn the siren on
	function ent:ELS_SirenOn()
		if not IsValid( self ) then return end
		if self:ELS_NoSiren() then return end
		if self:ELS_Siren() then self:ELS_SirenOff() end
		if not self:ELS_Lights() then self:ELS_LightOption( #EMVU.Sequences[self.Name].Sequences ) end
		self:ELS_LightsOn()

		local recipientFilter = RecipientFilter()
		recipientFilter:AddAllPlayers()
		--self.ELS.Siren = CreateSound( self, EMVU.GetSirenTable()[self:ELS_SirenSet()].Set[self:ELS_SirenOption()].Sound, recipientFilter )
		self:ELS_SirenPlay(EMVU.GetSirenTable()[self:ELS_SirenSet()].Set[self:ELS_SirenOption()].Sound)
		-- self.ELS.Siren:SetDSP( 119 )
		if self:ELS_HasAuxSiren() then
			local secondIndex = 1
			local secondarySiren = self:ELS_AuxSirenSet()
			if self.ELS.LastSecondSiren ~= secondIndex then
				self:ELS_Siren2Stop()
				-- print("siren2 off")
					if not self.ELS.LastSecondSiren then
						self.ELS.LastSecondSiren = secondIndex
					end
				end
			if self:ELS_SirenOption() > 2 then secondIndex = 2 end
			local newSound = EMVU.GetSirenTable()[secondarySiren].Set[1].Sound
			if EMVU.GetSirenTable()[secondarySiren].Set[secondIndex] then newSound = EMVU.GetSirenTable()[secondarySiren].Set[secondIndex].Sound end
			if ( self.ELS.CurrentSecondarySiren ) and self.ELS.CurrentSecondarySiren ~= newSound then
				--self.ELS.Siren2:Stop()
				self:ELS_Siren2Stop()
				--self.ELS.Siren2 = CreateSound( self, newSound, recipientFilter )
				-- print("( self.ELS.CurrentSecondarySiren ) and self.ELS.CurrentSecondarySiren ~= newSound"..newSound)
				self:ELS_Siren2Play(newSound)
				self.ELS.CurrentSecondarySiren = newSound
			elseif self.ELS.CurrentSecondarySiren ~= newSound  then
				self:ELS_Siren2Play(newSound)
				-- print("self.ELS.CurrentSecondarySiren ~= newSound"..newSound)
				self.ELS.CurrentSecondarySiren = newSound
			end
			-- if self.ELS.Siren2 then self.ELS.Siren2:Stop() end
			--self:ELS_Siren2Stop()
		end

		self:ELS_Siren( true )
	end

	function ent:ELS_SirenPause()
		if self:ELS_Siren() then
			self.ELS.SirenPaused = true
			--self.ELS.Siren:Stop()
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
		--if not self.ELS.Siren then return end
		if self.ELS.SirenPaused and not force then return end
		if ( self.ELS.SirenContinue and self.ELS.SirenContinue + 2 > CurTime() ) and not force then return end
		-- print("continue")
		--self.ELS.Siren:PlayEx( 0, 100 )
		-- if self:ELS_HasAuxSiren() then
		-- 	print("continue aux")
		-- end
		--self.ELS.Siren:ChangeVolume( 2, 0 )
		--if self:ELS_HasAuxSiren() and self.ELS.Siren2 then self.ELS.Siren2:ChangeVolume( 2, 0 ) end
		self.ELS.SirenContinue = CurTime()
	end

	function ent:ELS_SirenToggle( requestIndex )
		if not IsValid( self ) then return end
		if self:ELS_NoSiren() then return end
		if requestIndex and not isnumber( requestIndex ) then requestIndex = 1 end
		if requestIndex and requestIndex < 1 then requestIndex = 1 end
		if not requestIndex then
			if self:ELS_SirenOption() >= #EMVU.GetSirenTable()[self:ELS_SirenSet()].Set then
				self:ELS_SirenOption( 1 )
			else
				self:ELS_SirenOption( self:ELS_SirenOption() + 1 )
			end
		else
			if requestIndex > #EMVU.GetSirenTable()[self:ELS_SirenSet()].Set then
				self:ELS_SirenOption( 1 )
			else
				self:ELS_SirenOption( requestIndex )
			end
		end
		if self:ELS_Siren() then
			self:ELS_SirenOff( true )
			self:ELS_SirenOn()
		end
	end

	function ent:ELS_SirenToggleBack()
		if not IsValid( self ) then return end
		if self:ELS_NoSiren() then return end

		local cur = self:ELS_SirenOption()
		if cur == 1 then
			self:ELS_SirenOption(#EMVU.GetSirenTable()[self:ELS_SirenSet()].Set)
		else
			self:ELS_SirenOption(cur - 1)
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

		if self:ELS_SirenSet() >= #EMVU.GetSirenTable() then
			self:ELS_SirenSet( 1 )
		else
			self:ELS_SirenSet( self:ELS_SirenSet() + 1 )
		end

		if wasOn then self:ELS_SirenOn() end

	end

	function ent:ELS_SetAuxSirenSet( num )
		if not IsValid( self ) then return end
		if num < 0 or num > #EMVU.GetSirenTable() then return false end

		self:ELS_SirenOff()
		self:ELS_AuxSirenSet( num )
	end

	function ent:ELS_SetSirenSet( num )
		if not IsValid( self ) then return end
		if num < 0 or num > #EMVU.GetSirenTable() then return false end

		self:ELS_SirenOff()
		self:ELS_SirenSet( num )

	end

	function ent:ELS_ManualSiren( state )
		if not IsValid( self ) then return end
		if self:ELS_NoSiren() then return end
		if state then
			--if self:ELS_SirenOption() == 1 and self:ELS_Siren() then return end
			self:SetNW2Bool( "PhotonLE.CAR_MANUAL", true )
			if ( not self:Photon_HasManualWind() ) or self:ELS_Siren() then
				local manSiren = EMVU.GetSirenTable()[self:ELS_SirenSet()].Set[1].Sound
				if EMVU.GetSirenTable()[self:ELS_SirenSet()].Manual then manSiren = EMVU.GetSirenTable()[self:ELS_SirenSet()].Manual end
				if self:ELS_Siren() then
					local manualToneIndex = self:ELS_SirenOption() + 1
					local manualTone = EMVU.Horns[1]
					if manualToneIndex <= #EMVU.GetSirenTable()[ self:ELS_SirenSet() ].Set
						and EMVU.GetSirenTable()[ self:ELS_SirenSet() ].Set[ manualToneIndex ].Name ~= "HILO"
					 then
						manualTone = EMVU.GetSirenTable()[ self:ELS_SirenSet() ].Set[ manualToneIndex ].Sound
					elseif EMVU.GetSirenTable()[self:ELS_SirenSet()].Horn then
						manualTone = EMVU.GetSirenTable()[self:ELS_SirenSet()].Horn
					end
					self:ELS_SirenPause()
					manSiren = manualTone
				end
				--self.ELS.Manual = CreateSound( self, manSiren )
				self:ELS_ManualPlay(manSiren)
				-- if EMVU.GetSirenTable()[self:ELS_SirenSet()].Volume then
				-- 	self.ELS.Manual:SetSoundLevel( EMVU.GetSirenTable()[self:ELS_SirenSet()].Volume )
				-- else
				-- 	self.ELS.Manual:SetSoundLevel( 75 )
				-- end

				--self.ELS.Manual:PlayEx( 0, 100 )
				--self.ELS.Manual:ChangeVolume( 1, 0 )
			end
		else
			if ( not self:Photon_HasManualWind() ) or self:ELS_Siren() then
				local windDown = EMVU.GetSirenTable()[self:ELS_SirenSet()].ManualWind
				if windDown then
					if self.ELS.Manual then self.ELS.Manual:FadeOut( 1 ) end
				else
					--if self.ELS.Manual then self.ELS.Manual:Stop() end
					self:ELS_ManualStop()
					if self:ELS_Siren() then
						self:ELS_SirenResume()
					end
				end
			end
			self:SetNW2Bool( "PhotonLE.CAR_MANUAL", false )
		end
	end

	function ent:ELS_Horn( state )
		if not IsValid( self ) then return end
		if self:ELS_NoSiren() then return end
		if state then
			self:SetNW2Bool( "PhotonLE.EMV_HORN", true )
			local horn = EMVU.Horns[1]
			if EMVU.GetSirenTable()[self:ELS_SirenSet()].Horn then horn = EMVU.GetSirenTable()[self:ELS_SirenSet()].Horn end
			--self.ELS.Horn = CreateSound( self, horn )
			-- print(horn)
			self:ELS_PlayHorn(horn)
			-- if EMVU.GetSirenTable()[self:ELS_SirenSet()].Volume then
			-- 	self.ELS.Horn:SetSoundLevel( EMVU.GetSirenTable()[self:ELS_SirenSet()].Volume )
			-- else
			-- 	self.ELS.Horn:SetSoundLevel( 75 )
			-- end

			--self.ELS.Horn:PlayEx( 0, 100 )
			--self.ELS.Horn:ChangeVolume( 1, 0 )
		else
			self:SetNW2Bool( "PhotonLE.EMV_HORN", false )
			self:ELS_StopHorn()
			--if self.ELS.Horn then self.ELS.Horn:Stop() end
		end
	end

	function ent:ELS_ParkMode(state)
		if not IsValid(self) then return end
		self:SetNW2Bool("PhotonLE.PARK_MODE", state)
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
				if string.EndsWith( thisMat, "/skin" ) or string.EndsWith( thisMat, "/skin0" ) or string.EndsWith( thisMat, "/carpaint" ) then
					submaterialIndex = i - 1
					break
				end
			end
		end
		if submaterialIndex == false then return end
		if index then self:SetSkin(index) else self:SetSkin(0) end

		mat = tostring(mat)
		self:SetSubMaterial(submaterialIndex, mat)

		for _, prop in ipairs(EMVU.Helper.GetSubProps(self)) do
			local propsubmaterialIndex = false
			local propmaterials = prop:GetMaterials()
			for i=1,#propmaterials do
				local propthisMat = tostring( propmaterials[i] )
				if string.EndsWith( propthisMat, "/skin" ) or string.EndsWith( propthisMat, "/skin0" ) or string.EndsWith( propthisMat, "/carpaint" ) then
					propsubmaterialIndex = i - 1
					break
				end
			end
			if propsubmaterialIndex ~= false then prop:SetSubMaterial(propsubmaterialIndex, mat) end
		end
	end

	function ent:ApplyPhotonSkin( skin, index, mat )
		if isnumber( skin ) then
			self:SetSkin( skin )
		elseif isstring( skin ) and index ~= nil and mat ~= nil then
			self:ApplySmartSkin( skin, index, mat )
		elseif isstring( skin ) then
			self:ApplySmartSkin( skin )
		end
	end

	function ent:Photon_ApplyLivery( category, index, unit )
		if not IsValid( self ) then return end
		-- print( "instructed to apply: " .. index .. " from " .. category .. " with unit #" .. tostring( unit ) )
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
			-- self:ApplyPhotonSkin( liveryData[1] )
			-- self:Photon_SetLiveryId( liveryData[2] )
		end
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

	function ent:Photon_ResetSelections()
		if istable( EMVU.Selections[ self.Name ] ) then
			for i=1,#EMVU.Selections[ self.Name ] do
				self:Photon_SetSelection( i, 1 )
			end
		end
	end

	function ent:Photon_HasManualWind()
		local set = self:ELS_SirenSet()
		return istable( EMVU.GetSirenTable()[set].Gain )
	end

	function ent:Photon_SetAutoSkin( skin )
		local mdl = self:GetModel()
		local mdlId = Photon.AutoSkins.TranslationTable[ mdl ]
		--print(tostring(mdlId))
		if not mdlId then
			local toNum = tonumber( skin )
			if isnumber( toNum ) then self:SetSkin( toNum); return true else return false end
		end
		-- if not Photon.AutoSkins.IsSkinAvailable( mdlId, skin ) then return false end
		--print("instructed to apply" .. tostring( skin ))
		self:ApplySmartSkin( skin )
	end

	function ent:Photon_SetLicenseMaterial( mat )
		if self:Photon_LicensePlate() == false then return end
		self:SetSubMaterial( self:Photon_LicensePlate(), mat )
	end

	ent.IsEMV = true
	ent:SetPhotonNet_VehicleIndex(ent.Name)

	------ APPLY EMV PARAMETERS ------

	if emv.Skin then ent:ApplyPhotonSkin( emv.Skin, emv.SkinIndex, emv.SkinMaterialIndex ) end

	if emv.Color then ent:SetColor( emv.Color ) end

	if emv.BodyGroups then

		for _,group in pairs( emv.BodyGroups) do
			ent:SetBodygroup( group[1], group[2] )
		end

	end

	if emv.Siren then
		local set = EMVU.GetSirenIndex(emv.Siren)
		if not set then
			ErrorNoHalt(Format("EMV.Siren = '%s' cannot be found during registration, defaulting to #1.\n", emv.Siren))
			ent:ELS_SetSirenSet(1)
		else
			ent:ELS_SetSirenSet(set)
		end
	else
		ent:ELS_SetSirenSet( 1 )
	end

	if emv.AuxiliarySiren then
		local set = EMVU.GetSirenIndex(emv.AuxiliarySiren)
		if not set then
			ErrorNoHalt(Format("EMV.AuxiliarySiren = '%s' cannot be found during registration, defaulting to none.\n", emv.Siren))
			ent:ELS_AuxSirenSet(0)
		else
			ent:ELS_AuxSirenSet(set)
		end
	else
		ent:ELS_AuxSirenSet(0)
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
	ent:ELS_ManualSiren( false )
	ent:Photon_ApplySubMaterials()
	ent:Photon_ResetSelections()
end