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
	if istable( car.EMV.Sequences ) then
		EMVU.Sequences[ car.Name ] = car.EMV.Sequences
	elseif isstring(car.EMV.Sequences) then
		EMVU.Sequences[ car.Name ] = EMVU.Sequences[car.EMV.Sequences]
	end

	if istable( car.EMV.Positions ) then
		EMVU.Positions[ car.Name ] = car.EMV.Positions
	elseif isstring(car.EMV.Positions) then
		EMVU.Positions[ car.Name ] = EMVU.Positions[car.EMV.Positions]
	end

	if istable( car.EMV.Meta ) then
		EMVU.LightMeta[ car.Name ] = car.EMV.Meta
	elseif isstring(car.EMV.Meta) then
		EMVU.LightMeta[ car.Name ] = EMVU.LightMeta[car.EMV.Meta]
	end

	if istable( car.EMV.Patterns ) then
		EMVU.Patterns[ car.Name ] = car.EMV.Patterns
	elseif isstring(car.EMV.Patterns) then
		EMVU.Patterns[ car.Name ] = EMVU.Patterns[car.EMV.Patterns]
	end

	if istable( car.EMV.Sections ) then
		EMVU.Sections[ car.Name ] = car.EMV.Sections
	elseif isstring(car.EMV.Sections) then
		EMVU.Sections[ car.Name ] = EMVU.Sections[car.EMV.Sections]
	end

	if car.EMV.Props and istable( car.EMV.Props ) then
		EMVU.Props[ car.Name ] = car.EMV.Props
		for _,prop in pairs( car.EMV.Props ) do
			util.PrecacheModel( prop.Model )
		end
	elseif isstring(car.EMV.Props) then
		EMVU.Props[ car.Name ] = EMVU.Props[car.EMV.Props]
	end

	if car.EMV.Lamps and istable( car.EMV.Lamps ) then
		EMVU.Lamps[ car.Name ] = car.EMV.Lamps
	elseif isstring(car.EMV.Lamps) then
		EMVU.Lamps[ car.Name ] = EMVU.Lamps[car.EMV.Lamps]
	end

end

function EMVU:OverwriteIndex( name, data )
	if data and istable(data.Meta) and istable(data.Positions) and istable(data.Patterns) and istable(data.Sequences) and istable(data.Sections) then
		EMVU.LightMeta[name] = data.Meta
		EMVU.Positions[name] = data.Positions
		EMVU.Patterns[name] = data.Patterns
		EMVU.Sequences[name] = data.Sequences
		EMVU.Sections[name] = data.Sections
		if istable( data.Lamps ) then EMVU.Lamps[ name ] = data.Lamps end
		if istable( data.Props ) then EMVU.Props[ name ] = data.Props end
		if istable( data.Auto ) then 
			EMVU.AutoIndex[ name ] = data.Auto
			EMVU:CalculateAuto( name, data.Auto ) 
		end
		if istable( data.Presets ) then EMVU.PresetIndex[ name ] = data.Presets end
	else
		error("data must be table with valid Meta, Positions, Patterns and Sequences")
	end
end

function EMVU:CalculateAuto( name, data )
	if not istable( data ) then return end

	for i=1,#data do -- for each component in the vehicle's auto
		// print( "Auto ID: " .. tostring( data[ i ].ID ) )
		local component = EMVU.Auto[ data[ i ].ID ]
		local autoData = data[i]
		local autoPos = autoData.Pos
		local autoAng = autoData.Ang 
		local autoScale = autoData.Scale or 1
		local adjustAng = Angle()
		adjustAng.p = autoAng.r
		adjustAng.y = autoAng.y - 90
		adjustAng.r = autoAng.p * -1

		for id,metadata in pairs( component.Meta ) do -- add meta template data
			EMVU.LightMeta[ name ][ id ] = metadata
			for prop,val in pairs( metadata ) do
				local resultVal = val
				if prop == "W" then resultVal = val * autoScale end
				if prop == "H" then resultVal = val * autoScale end
				EMVU.LightMeta[ name ][ id ][ prop ] = resultVal
			end
		end

		local offset = #EMVU.Positions[ name ] -- count of current meta values

		for id,section in pairs( component.Sections ) do -- for each section ["lightbar"] = { { 1, B } } *SECTION
			EMVU.Sections[ name ][ id ] = {}
			for index=1,#section do -- { { 1, B } } *FRAME
				EMVU.Sections[ name ][ id ][ index ] = {}
				local values = section[ index ]
				for light, lightData in pairs( values ) do -- { 1, B } *LIGHT
					EMVU.Sections[ name ][ id ][ index ][ light ] = { lightData[1] + offset, lightData[2] }
				end
			end
		end

		for id,pattern in pairs( component.Patterns ) do -- add pattern data
			EMVU.Patterns[ name ][ id ] = pattern
		end

		for id=1,#component.Positions do
			local posData = component.Positions[ id ]
			local newPos = Vector()
			newPos:Set( posData[1] )
			newPos:Rotate( adjustAng )
			newPos:Mul( autoScale )
			newPos:Add( autoPos )
			local newAng = Angle()
			newAng.y = newAng.y + 90
			newAng:Set( posData[2] )
			newAng:RotateAroundAxis( autoAng:Right(), -1*autoAng.p )
			EMVU.Positions[ name ][ offset + id ] = {
				newPos, newAng, posData[3]
			}

		end

		if istable( EMVU.Sequences[ name ]["Traffic"] ) and istable( component.TrafficDisconnect ) then
			for _,sequence in pairs( EMVU.Sequences[ name ]["Traffic"] ) do
				if istable( sequence.Preset_Components )  then
					for __,preset in pairs( sequence.Preset_Components ) do
						for componentName, ___ in pairs( preset ) do
							if istable( component.TrafficDisconnect[ componentName ] ) then
								local disconnectIndexes = component.TrafficDisconnect[ componentName ]
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


end

hook.Add("Initialize", "EMVU.LoadVehicles", function()
	EMVU:LoadVehicles()
end)