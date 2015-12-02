AddCSLuaFile()

function EMVU:PlayerSpawnedVehicle( ply, ent ) -- deprecated function, only gives legacy support
	if IsValid( ent ) and ent:IsVehicle() then EMVU:SpawnedVehicle( ent ) end
end

function EMVU:SpawnedVehicle( ent )
	if not IsValid( ent ) then print( "[Photon] Tried to setup an invalid entity: " .. tostring(ent) ) end
	local name = ent.VehicleTable.Name
	ent.Name = name
	local raw = list.Get("Vehicles")[name]
	local car = false

	for _,scar in pairs(list.Get("Vehicles")) do
		if scar.Name == name then
			car = scar
			break
		end
	end

	if not car then return end
	if not raw or not istable( raw.EMV ) then raw = car end

	if istable( car.EMV ) then
		EMVU:MakeEMV( ent, raw.EMV )
	end
end

function EMVU.FetchExpressVehicles()
	local results = {}
	local files = file.Find( "photon/express/*", "DATA" )
	for _,_file in pairs( files ) do
		local fileContents = file.Read( "photon/express/" .. _file )
		local resultVehicle = Photon.XML.ParseVehicleFromXML( fileContents )
		results[#results+1] = { resultVehicle.VehicleDefinition.Name, _file }
	end
	return results
end

function EMVU:ProcessExpressVehicles()
	local autoFiles = file.Find( "photon/express/*", "DATA" )
	for _,_file in pairs( autoFiles ) do
		local fileContents = file.Read( "photon/express/" .. _file )
		local resultVehicle = Photon.XML.ParseVehicleFromXML( fileContents )
		-- PrintTable( resultVehicle )
		local v = resultVehicle.VehicleDefinition
		list.Set( "Vehicles", v.Name, {
			Name = v.Name,
			Class = "prop_vehicle_jeep",
			Category = v.Category,
			Author = v.Author,
			Model = v.Model,
			KeyValues = { ["vehiclescript"] = v.KeyValues.vehiclescript },
			IsEMV = true,
			EMV = resultVehicle,
			HasPhoton = true,
			Photon = "PHOTON_INHERIT"
		} )
	end
end

function EMVU:LoadVehicles()
	local cars = list.Get("Vehicles")
	for k,v in pairs(cars) do
		if v.IsEMV then
			EMVU:PreloadVehicle( v )
		elseif EMVU:CheckForELS( v.Model ) then
			v.IsEMV = true
			v.EMV = EMVU:CheckForELS( v.Model )
			list.Set( "Vehicles", k, v )
			EMVU:PreloadVehicle( v )
		end
	end
end

function EMVU:CheckForELS( model )
	if Photon.EMVIndex[model] then return Photon.EMVLibrary[Photon.EMVIndex[model]] else return false end
end

function EMVU:PreloadVehicle( car )

	if istable( car.EMV.Sequences ) then EMVU.LoadModeData( car.Name, car.EMV.Sequences ) end 

	EMVU.Index[ #EMVU.Index + 1 ] = car.Name

	if istable( car.EMV.Positions ) then
		EMVU.Positions[ car.Name ] = car.EMV.Positions
	elseif isstring(car.EMV.Positions) then
		EMVU.Positions[ car.Name ] = EMVU.Positions[car.EMV.Positions]
	else
		EMVU.Positions[ car.Name ] = {}
	end

	if istable( car.EMV.Meta ) then
		EMVU.LightMeta[ car.Name ] = car.EMV.Meta
	elseif isstring(car.EMV.Meta) then
		EMVU.LightMeta[ car.Name ] = EMVU.LightMeta[car.EMV.Meta]
	else
		EMVU.LightMeta[ car.Name ] = {}
	end

	if istable( car.EMV.Patterns ) then
		EMVU.Patterns[ car.Name ] = car.EMV.Patterns
	elseif isstring(car.EMV.Patterns) then
		EMVU.Patterns[ car.Name ] = EMVU.Patterns[car.EMV.Patterns]
	else
		EMVU.Patterns[ car.Name ] = {}
	end

	if istable( car.EMV.Sections ) then
		EMVU.Sections[ car.Name ] = car.EMV.Sections
	elseif isstring(car.EMV.Sections) then
		EMVU.Sections[ car.Name ] = EMVU.Sections[car.EMV.Sections]
	else
		EMVU.Sections[ car.Name ] = {}
	end

	if car.EMV.Props and istable( car.EMV.Props ) then
		EMVU.Props[ car.Name ] = car.EMV.Props
		for _,prop in pairs( car.EMV.Props ) do
			util.PrecacheModel( prop.Model )
		end
	elseif isstring(car.EMV.Props) then
		EMVU.Props[ car.Name ] = EMVU.Props[car.EMV.Props]
	else
		EMVU.Props[ car.Name ] = {}
	end

	if car.EMV.Lamps and istable( car.EMV.Lamps ) then
		EMVU.Lamps[ car.Name ] = car.EMV.Lamps
	elseif isstring(car.EMV.Lamps) then
		EMVU.Lamps[ car.Name ] = EMVU.Lamps[car.EMV.Lamps]
	end

	if car.EMV.Liveries and istable( car.EMV.Liveries ) then
		EMVU.Liveries[ car.Name ] = car.EMV.Liveries
	elseif isstring( car.EMV.Liveries ) then
		EMVU.Liveries[ car.Name ] = EMVU.Liveries[ car.EMV.Liveries ]
	end

	if car.EMV.Presets and istable( car.EMV.Presets ) then
		EMVU.PresetIndex[ car.Name ] = car.EMV.Presets
	else
		EMVU.LoadPresetDefault( car.Name, car.EMV )
	end

	if car.EMV.Auto and istable( car.EMV.Auto ) then
		EMVU.AutoIndex[ car.Name ] = car.EMV.Auto
		EMVU:CalculateAuto( car.Name, car.EMV.Auto )
	end

	if car.EMV.SubMaterials and istable( car.EMV.SubMaterials ) then
		EMVU.SubMaterials[ car.Name ] = car.EMV.SubMaterials
	end

	if car.EMV.Selections and istable( car.EMV.Selections ) then
		EMVU.Selections[ car.Name ] = car.EMV.Selections
	end

end

local function safeTableEmpty( tab )
	if istable( tab ) then
		table.Empty( tab )
	end
end

-- function EMVU:OverwriteIndex( name, data )
-- 	if data then
-- 		safeTableEmpty( EMVU.LightMeta[name] ); EMVU.LightMeta[name] = data.Meta or {}
-- 		safeTableEmpty( EMVU.Positions[name]); EMVU.Positions[name] = data.Positions or {}
-- 		safeTableEmpty( EMVU.Patterns[name] ); EMVU.Patterns[name] = data.Patterns or {}
-- 		if istable( data.Sequences ) then EMVU.LoadModeData( name, data.Sequences ) end 
-- 		safeTableEmpty( EMVU.Sections[name] ); EMVU.Sections[name] = data.Sections or {}
-- 		if istable( data.Lamps ) then safeTableEmpty( EMVU.Lamps[ name ] ); EMVU.Lamps[ name ] = data.Lamps end
-- 		if istable( data.Props ) then safeTableEmpty( EMVU.Props[ name ] ); EMVU.Props[ name ] = data.Props end
-- 		if istable( data.Presets ) then safeTableEmpty( EMVU.PresetIndex[ name ] ); EMVU.PresetIndex[ name ] = data.Presets else EMVU.LoadPresetDefault( name, data ) end
-- 		if istable( data.Liveries ) then safeTableEmpty( EMVU.Liveries[ name ] ); EMVU.Liveries[ name ] = data.Liveries end
-- 		if istable( data.SubMaterials ) then safeTableEmpty( EMVU.SubMaterials[ name ] ); EMVU.SubMaterials[ name ] = data.SubMaterials end
-- 		if istable( data.Auto ) then
-- 			if istable( EMVU.AutoIndex ) then safeTableEmpty( EMVU.AutoIndex[ name ] ) end
-- 			EMVU.AutoIndex[ name ] = data.Auto
-- 			EMVU:CalculateAuto( name, data.Auto ) 
-- 		end
-- 	else
-- 		print("[Photon] Data must be table with valid Meta, Positions, Patterns and Sequences. Overwrite failed.")
-- 	end
-- end

-- function EMVU:OverwriteIndex( name, data )
-- 	if data then
-- 		EMVU.LightMeta[name] = data.Meta or {}
-- 		EMVU.Positions[name] = data.Positions or {}
-- 		EMVU.Patterns[name] = data.Patterns or {}
-- 		if istable( data.Sequences ) then EMVU.LoadModeData( name, data.Sequences ) end 
-- 		EMVU.Sections[name] = data.Sections or {}
-- 		if istable( data.Lamps ) then EMVU.Lamps[ name ] = data.Lamps end
-- 		if istable( data.Props ) then EMVU.Props[ name ] = data.Props end
-- 		if istable( data.Presets ) then EMVU.PresetIndex[ name ] = data.Presets else EMVU.LoadPresetDefault( name, data ) end
-- 		if istable( data.Liveries ) then EMVU.Liveries[ name ] = data.Liveries end
-- 		if istable( data.SubMaterials ) then EMVU.SubMaterials[ name ] = data.SubMaterials end
-- 		if istable( data.Auto ) then 
-- 			EMVU.AutoIndex[ name ] = data.Auto
-- 			EMVU:CalculateAuto( name, data.Auto ) 
-- 		end
-- 	else
-- 		print("[Photon] Data must be table with valid Meta, Positions, Patterns and Sequences. Overwrite failed.")
-- 	end
-- end

function EMVU:OverwriteIndex( name, data )
	-- print("overwriting: " .. tostring( name ) )
	if data then
		EMVU.LightMeta[name] = data.Meta or {}
		safeTableEmpty( EMVU.Positions[ name ] ); EMVU.Positions[name] = data.Positions or {}
		EMVU.Patterns[name] = data.Patterns or {}
		if istable( data.Sequences ) then EMVU.LoadModeData( name, data.Sequences ) end 
		EMVU.Sections[name] = data.Sections or {}
		if istable( data.Lamps ) then EMVU.Lamps[ name ] = data.Lamps end
		if istable( data.Props ) then EMVU.Props[ name ] = data.Props end
		if istable( data.Presets ) then EMVU.PresetIndex[ name ] = data.Presets else EMVU.LoadPresetDefault( name, data ) end
		if istable( data.Selections ) then EMVU.Selections [ name ] = data.Selections end
		if istable( data.Liveries ) then EMVU.Liveries[ name ] = data.Liveries end
		if istable( data.SubMaterials ) then EMVU.SubMaterials[ name ] = data.SubMaterials end
		if istable( data.Auto ) then 
			EMVU.AutoIndex[ name ] = data.Auto
			EMVU:CalculateAuto( name, data.Auto ) 
		end
	else
		print("[Photon] Data must be table with valid Meta, Positions, Patterns and Sequences. Overwrite failed.")
	end
end

function EMVU.LoadPresetDefault( name, data )
	if istable( data.Auto ) and not istable( data.Presets ) and not istable( data.Selections ) then
		data.Presets = {}
		data.Presets[1] = {}
		data.Presets[1].Name = "Default"
		data.Presets[1].Bodygroups = {}
		data.Presets[1].Props = {}
		data.Presets[1].Auto = {}
		for index,_ in pairs( data.Auto ) do
			data.Presets[1].Auto[ #data.Presets[1].Auto + 1 ] = index
		end
		EMVU.PresetIndex[ name ] = data.Presets
	end
end

function EMVU.LoadModeData( name, data )

	local lastSequence = data.Sequences[ #data.Sequences ] or {}

	if not data["Alert"] then

		data.Alert = {
			Components = {},
			BG_Components = {},
			Preset_Components = {}
		}

		if lastSequence.Components then data.Alert.Components = lastSequence.Components end
		if lastSequence.BG_Components then data.Alert.BG_Components = lastSequence.BG_Components end

	end

	EMVU.Sequences[ name ] = data

end

function EMVU:CalculateAuto( name, data )
	if not istable( data ) then return end

		//PrintTable( EMVU.PresetIndex[ name ]  )
	for i=1,#data do -- for each component in the vehicle's auto
		// print( "Auto ID: " .. tostring( data[ i ].ID ) )
		local component = EMVU.Auto[ data[ i ].ID ]
		local autoData = data[i]
		local autoPos = autoData.Pos
		local autoAng = autoData.Ang 
		local autoScale = autoData.Scale or 1
		local adjustAng = Angle()

		if not autoData.AutoPatterns or autoData.AutoPatterns != false then autoData.AutoPatterns = true end

		if not component then print( "[Photon] Auto component: " .. tostring( data[i].ID ) .. " was not found in the library. Requested in: " .. tostring( name ) .. ".") continue end

		if not component.NotLegacy then
			adjustAng.p = autoAng.r
			adjustAng.y = autoAng.y - 90
			adjustAng.r = autoAng.p * -1
		else
			adjustAng.p = autoAng.p
			adjustAng.y = autoAng.y
			adjustAng.r = autoAng.r
		end


		-- This section is to correctly add tables into each light mode. The rendering function will find all currently active Selection>Option sets and respective components that should be active
		local usedPresets = {}
		local usesPresets = false
		if istable( EMVU.PresetIndex[ name ] ) then
			for presetIndex,presetData in pairs( EMVU.PresetIndex[ name ] ) do
				for _,_autoIndex in pairs( presetData.Auto ) do
					if _autoIndex == i then usesPresets = true; usedPresets[ #usedPresets + 1 ] = presetIndex end
				end
			end
		end
		local usesSelections = false
		local activeSelections = {} -- table with a reference to each selection path (Lightbars.Option1)
		if istable( EMVU.Selections[ name ] ) then
			for _i,selection in pairs( EMVU.Selections[ name ] ) do -- for each category/index in the collections table
				if istable( selection.Options ) then
					for __i, option in pairs( selection.Options ) do -- for each choice within the category/index
						if istable( option.Auto ) then
							for ___i, autoIndex in pairs( option.Auto ) do -- for each auto component reference
								if autoIndex == i then -- if this current auto component index is matched in the option
									usesSelections = true
									activeSelections[_i] = activeSelections[_i] or {}
									activeSelections[_i][__i] = activeSelections[_i][__i] or {}
									activeSelections[_i][__i][ #activeSelections[_i][__i] + 1 ] = i -- Category > Option > Component
								end
							end
						end
					end
				end
			end
		end
		//PrintTable( activeSelections )
		for id,metadata in pairs( component.Meta ) do -- add meta template data
			local useId = tostring( tostring( id ) .. "_" .. tostring( i ) )
			EMVU.LightMeta[ name ][ useId ]  = {}
			for prop,val in pairs( metadata ) do
				local resultVal = val
				if prop == "W" then resultVal = val * autoScale end
				if prop == "H" then resultVal = val * autoScale end
				EMVU.LightMeta[ name ][ useId ][ prop ] = resultVal
			end
		end

		if istable( component.Modes ) and autoData.AutoPatterns != false then

			for modeIndex, modeData in pairs( component.Modes.Primary ) do
				for _,sequence in pairs( EMVU.Sequences[ name ].Sequences ) do
					if sequence.Stage and sequence.Stage == modeIndex then

						if usesPresets then

							if not istable( sequence.Preset_Components ) then sequence.Preset_Components = {} end
							for __,presetIndex in pairs( usedPresets ) do
								if not sequence.Preset_Components[presetIndex] then sequence.Preset_Components[presetIndex] = {} end
								for componentIndex, patternIndex in pairs( modeData ) do
									local patternPhase = autoData.Phase or ""
									sequence.Preset_Components[presetIndex][ componentIndex .. "_" .. i ] = tostring( patternIndex .. patternPhase )
								end
							end

						end

						if usesSelections then

							if not istable( sequence.Selection_Components ) then sequence.Selection_Components = {} end
							for _i, selection in pairs( activeSelections ) do
								sequence.Selection_Components[_i] = sequence.Selection_Components[_i] or {}
								for __i, option in pairs( selection ) do
									sequence.Selection_Components[_i][__i] = sequence.Selection_Components[_i][__i] or {}
									for componentIndex, patternIndex in pairs( modeData ) do
										local patternPhase = autoData.Phase or ""
										sequence.Selection_Components[_i][__i][ componentIndex .. "_" .. i ] = tostring( patternIndex .. patternPhase )
									end
								end
							end
							//PrintTable( sequence )
						end

					end
				end
			end

			if istable( component.Modes.Primary.ALERT ) or ( component.Modes.Primary.M3 ) then
				local targetCopy = component.Modes.Primary.ALERT or component.Modes.Primary.M3
				local sequence = EMVU.Sequences[name].Alert
				// PrintTable( sequence )

				if usesPresets then

					for __,presetIndex in pairs( usedPresets ) do
						if not sequence.Preset_Components[presetIndex] then sequence.Preset_Components[presetIndex] = {} end
						for componentIndex, patternIndex in pairs( targetCopy ) do
							local patternPhase = autoData.Phase or ""
							sequence.Preset_Components[presetIndex][ componentIndex .. "_" .. i ] = tostring( patternIndex .. patternPhase )
						end
					end

				end
				
				if usesSelections then
					
					if not istable( sequence.Selection_Components ) then sequence.Selection_Components = {} end
					for _i, selection in pairs( activeSelections ) do 
						sequence.Selection_Components[_i] = sequence.Selection_Components[_i] or {}
						for __i, option in pairs( selection ) do
							sequence.Selection_Components[_i][__i] = sequence.Selection_Components[_i][__i] or {}
							for componentIndex, patternIndex in pairs( targetCopy ) do
								local patternPhase = autoData.Phase or ""
								sequence.Selection_Components[_i][__i][ componentIndex .. "_" .. i ] = tostring( patternIndex .. patternPhase )
							end
						end
					end
					
				end

			end

		end

		if istable( component.Modes ) and autoData.AutoPatterns != false and EMVU.Sequences[ name ].Traffic then
			
			for modeIndex, modeData in pairs( component.Modes.Auxiliary ) do
				for _,sequence in pairs( EMVU.Sequences[ name ].Traffic ) do
					if sequence.Stage and sequence.Stage == modeIndex then

						if usesPresets then
							if not istable( sequence.Preset_Components ) then sequence.Preset_Components = {} end
							for __,presetIndex in pairs( usedPresets ) do
								if not sequence.Preset_Components[presetIndex] then sequence.Preset_Components[presetIndex] = {} end
								for componentIndex, patternIndex in pairs( modeData ) do
									sequence.Preset_Components[presetIndex][ componentIndex .. "_" .. i ] = patternIndex
								end
							end
						end
						
						if usesSelections then
							
							if not istable( sequence.Selection_Components ) then sequence.Selection_Components = {} end
							for _i, selection in pairs( activeSelections ) do 
								sequence.Selection_Components[_i] = sequence.Selection_Components[_i] or {}
								for __i, option in pairs( selection ) do
									sequence.Selection_Components[_i][__i] = sequence.Selection_Components[_i][__i] or {}
									for componentIndex, patternIndex in pairs( modeData ) do
										local patternPhase = autoData.Phase or ""
										sequence.Selection_Components[_i][__i][ componentIndex .. "_" .. i ] = patternIndex
									end
								end
							end

						end

					end
				end
			end

		end

		//PrintTable( EMVU.Sequences[ name ].Traffic )

		local offset = #EMVU.Positions[ name ] -- count of current meta values

		for id,section in pairs( component.Sections ) do -- for each section ["lightbar"] = { { 1, B } } *SECTION
			id = tostring( id .. "_" .. i )
			EMVU.Sections[ name ][ id ] = {}
			for index=1,#section do -- { { 1, B } } *FRAME
				EMVU.Sections[ name ][ id ][ index ] = {}
				local values = section[ index ]
				for light, lightData in pairs( values ) do -- { 1, B } *LIGHT
					if not istable( lightData ) then print( "[Photon] Auto-component failed to initialize because of an invalid variable type: " .. tostring( lightData ) .. ". Make sure the Sections table has correctly nested tables." ) return end
					local lightColor = lightData[2]
					if istable(component.DefaultColors) and (#component.DefaultColors > 0) then 
						if string.StartWith( lightColor, "_" ) then
							local colorIndex = string.sub( lightColor, 2 )
							if autoData["Color" .. tostring( colorIndex )] then
								lightColor = autoData["Color" .. tostring( colorIndex )]
							else
								lightColor = component.DefaultColors[tonumber(colorIndex)] or "WHITE"
							end
						end
					end
					local additionalParams = lightData[3]
					EMVU.Sections[ name ][ id ][ index ][ light ] = { lightData[1] + offset, lightColor, additionalParams }
				end
			end
		end

		for id,pattern in pairs( component.Patterns ) do -- add pattern data
			EMVU.Patterns[ name ][ tostring( id .. "_" .. i )] = pattern
		end

		for id=1,#component.Positions do
			local posData = component.Positions[ id ]
			local newPos = Vector()
			newPos:Set( posData[1] )
			newPos:Rotate( adjustAng )
			// print(tostring(adjustAng))
			newPos:Mul( autoScale )
			newPos:Add( autoPos )
			local newAng = Angle()
			if not component.NotLegacy then
				newAng.y = newAng.y + 90
				newAng:Set( posData[2] )
				newAng:RotateAroundAxis( autoAng:Right(), -1*autoAng.p )
				newAng:RotateAroundAxis( autoAng:Up(), -1*autoAng.r )
			else
				newAng:Set( posData[2] )
				if component.ForwardTranslation then
					newAng.p = newAng.p + (autoAng.r *-1)
					newAng.y = newAng.y + autoAng.y
					newAng.r = newAng.r + autoAng.p
				else
					newAng.p = newAng.p + autoAng.p
					newAng.y = newAng.y + autoAng.y
					newAng.r = newAng.r + autoAng.r
				end
			end
			EMVU.Positions[ name ][ offset + id ] = {
				newPos, newAng, tostring( posData[3] .. "_" .. i )
			}

		end

		if istable( EMVU.Sequences[ name ]["Traffic"] ) and istable( component.TrafficDisconnect ) then
			for _,sequence in pairs( EMVU.Sequences[ name ]["Traffic"] ) do

				if usesPresets then
					if istable( sequence.Preset_Components )  then
						for __,preset in pairs( sequence.Preset_Components ) do
							for componentName, ___ in pairs( preset ) do
								local moddedComponentName = tostring( componentName )
								if autoData.AutoPatterns then
									local stPos, edPos = string.find( componentName, "_", -4 )
									moddedComponentName = string.sub( componentName, 1, edPos - 1 )
								end
								if istable( component.TrafficDisconnect[ moddedComponentName ] ) then
									local disconnectIndexes = component.TrafficDisconnect[ moddedComponentName ]
									if not istable( sequence.EL_Disconnect ) then sequence.EL_Disconnect = {} end
									for ____, lightIndex in pairs( disconnectIndexes ) do
										sequence.EL_Disconnect[ #sequence.EL_Disconnect + 1 ] = lightIndex + offset
									end
								end
							end
						end
					end
				end

				if usesSelections then
					if not istable( sequence.Selection_Components ) then sequence.Selection_Components = {} end
					for _i,selectionCategory in pairs( sequence.Selection_Components ) do
						for __i,selection in pairs( selectionCategory ) do
							for componentName, ___ in pairs( selection ) do
								local moddedComponentName = tostring( componentName )
								if autoData.AutoPatterns then
									local stPos, edPos = string.find( componentName, "_", -4 )
									moddedComponentName = string.sub( componentName, 1, edPos - 1 )
								end
								if istable( component.TrafficDisconnect[ moddedComponentName ] ) then
									local disconnectIndexes = component.TrafficDisconnect[ moddedComponentName ]
									if not istable( sequence.EL_Disconnect ) then sequence.EL_Disconnect = {} end
									for ____, lightIndex in pairs( disconnectIndexes ) do
										sequence.EL_Disconnect[ #sequence.EL_Disconnect + 1 ] = lightIndex + offset
									end
								end
							end
						end
					end
				end

			end
		end

		if istable( component.Modes ) and autoData.AutoPatterns != false and EMVU.Sequences[ name ].Illumination and component.Modes.Illumination then
			
			for modeIndex, modeData in pairs( component.Modes.Illumination ) do
				for _,sequence in pairs( EMVU.Sequences[ name ].Illumination ) do
					if sequence.Stage and sequence.Stage == modeIndex then

						if usesPresets then
							if not istable( sequence.Preset_Components ) then sequence.Preset_Components = {} end
							for __,presetIndex in pairs( usedPresets ) do
								if not sequence.Preset_Components[presetIndex] then sequence.Preset_Components[presetIndex] = {} end
								for _, lightInfo in pairs( modeData ) do
									sequence.Preset_Components[presetIndex][ #sequence.Preset_Components[presetIndex] + 1 ] = {
										lightInfo[1] + offset, lightInfo[2]
									}
								end
							end
						end
						
						if usesSelections then
							if not istable( sequence.Selection_Components ) then sequence.Selection_Components = {} end
							for _i, selection in pairs( activeSelections ) do 
								sequence.Selection_Components[_i] = sequence.Selection_Components[_i] or {}
								for __i, option in pairs( selection ) do
									sequence.Selection_Components[_i][__i] = sequence.Selection_Components[_i][__i] or {}
									for _, lightInfo in pairs( modeData ) do
										sequence.Selection_Components[_i][__i][ #sequence.Selection_Components[_i][__i] + 1 ] = {
											lightInfo[1] + offset, lightInfo[2]
										}
									end
								end
							end
						end

					end
				end
			end
		end

	end


end

hook.Add("InitPostEntity", "EMVU.LoadVehicles", function()
	EMVU:ProcessExpressVehicles()
	EMVU:LoadVehicles()
end) 