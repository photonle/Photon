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
		if istable(data.Lamps) then EMVU.Lamps[name] = data.Lamps end
		if istable(data.Props) then EMVU.Props[name] = data.Props end
	else
		error("data must be table with valid Meta, Positions, Patterns and Sequences")
	end
end

hook.Add("Initialize", "EMVU.LoadVehicles", function()
	EMVU:LoadVehicles()
end)