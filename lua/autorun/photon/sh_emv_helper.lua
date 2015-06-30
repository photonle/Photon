AddCSLuaFile()
if EMVU then EMVU.Helper = {} end

function EMVU.Helper:GetVectors( name )
	return EMVU.Positions[name]
end

function EMVU.Helper:GetSequence( name, option, vehicle )
	
	local resultTable = {}
	
	if IsValid( vehicle ) and istable( EMVU.Sequences[name]["Sequences"][option]["BG_Components"] ) then
		local bodygroups = vehicle:GetBodyGroups() -- BodyGroups of vehicle
		local bgtable = EMVU.Sequences[name]["Sequences"][option]["BG_Components"] -- BodyGroups defined in vehicle specification file
		for id,data in pairs( bodygroups ) do -- for index,value in each vehicle bodygroup
			local indexId = id - 1
			if bgtable[ data["name"] ] then  -- if this index is defined in the vehicle specifications
				local selected = vehicle:GetBodygroup( indexId )
				if bgtable[ data["name"] ][ tostring( selected ) ] then
					for component,option in pairs( bgtable[ data["name"] ][ tostring( selected ) ] ) do
						resultTable[ component ] = option
					end
				end
			end
		end
	end
	
	for component, option in pairs( EMVU.Sequences[name]["Sequences"][option]["Components"] ) do
		resultTable[ component ] = option
	end
	
	return resultTable
end

function EMVU.Helper:GetIllumSequence( name, option, vehicle )
	
	local resultTable = {}
	
	if IsValid( vehicle ) and istable( EMVU.Sequences[name]["Illumination"][option]["BG_Components"] ) then
		local bodygroups = vehicle:GetBodyGroups() -- BodyGroups of vehicle
		local bgtable = EMVU.Sequences[name]["Illumination"][option]["BG_Components"] -- BodyGroups defined in vehicle specification file
		for id,data in pairs( bodygroups ) do -- for index,value in each vehicle bodygroup
			local indexId = id - 1
			if bgtable[ data["name"] ] then  -- if this index is defined in the vehicle specifications
				local selected = vehicle:GetBodygroup( indexId )
				if bgtable[ data["name"] ][ tostring( selected ) ] then
					for component,option in pairs( bgtable[ data["name"] ][ tostring( selected ) ] ) do
						resultTable[ component ] = option
					end
				end
			end
		end
	end
	
	for component, option in pairs( EMVU.Sequences[name]["Illumination"][option]["Components"] ) do
		resultTable[ component ] = option
	end
	
	return resultTable

end

function EMVU.Helper:GetSequenceName( name, option )
	return EMVU.Sequences[name]["Sequences"][option]["Name"]
end

function EMVU.Helper:GetModeDisconnect( name, option )
	if EMVU.Sequences[name]["Sequences"][option]["Disconnect"] then return EMVU.Sequences[name]["Sequences"][option]["Disconnect"] end
	return false
end

function EMVU.Helper:GetPattern( name, option, frame )
	local pattern = EMVU.Helper:GetSequence( name, option )[frame]
	return EMVU.Patterns[name][pattern]
end

function EMVU.Helper:GetPatterns( name )
	return EMVU.Patterns[name]
end

function EMVU.Helper:GetMeta( name )
	return EMVU.LightMeta[name]
end

function EMVU.Helper:GetFrame( name, component, index, frame )
	return EMVU.Patterns[name][component][index][frame]
end

function EMVU.Helper:GetLightSection( name, component, frame )
	return EMVU.Sections[name][component][frame]
end

function EMVU.Helper:RotatingLight( speed, offset )
	return math.Round( CurTime() * 100 ) * speed + offset
end

function EMVU.Helper:RadiusLight( speed, radius )
	return math.sin( CurTime() * speed ) * radius
end

function EMVU.Helper:PulsingLight( speed, min, offset )
	return math.Clamp( ( (math.sin( (CurTime() + offset) * speed ) * .5 ) + .5), min, 1 )
end

function EMVU.Helper:GetProps( name )
	return EMVU.Props[name]
end

function EMVU.Helper:GetIlluminationName( name, option )
	return EMVU.Sequences[name].Illumination[option].Name
end

function EMVU.Helper:GetIlluminationLights( name, option )
	return EMVU.Sequences[name].Illumination[option].Lights
end

function EMVU.Helper:GetLampMeta( name, index )
	return EMVU.Lamps[name][index]
end

function EMVU.Helper:HasLamps( name )
	if istable( EMVU.Sequences[name].Illumination ) and istable( EMVU.Sequences[name].Illumination[1] ) then return true end
	return false
end

function EMVU.Helper:HasTrafficAdvisor( name )
	if istable( EMVU.Sequences[name].Traffic ) and istable( EMVU.Sequences[name].Traffic[1] ) then return true end
end

function EMVU.Helper:GetTASequence( name, option, vehicle )
	
	local resultTable = {}
	
	if IsValid( vehicle ) and istable( EMVU.Sequences[name]["Traffic"][option]["BG_Components"] ) then
		local bodygroups = vehicle:GetBodyGroups() -- BodyGroups of vehicle
		local bgtable = EMVU.Sequences[name]["Traffic"][option]["BG_Components"] -- BodyGroups defined in vehicle specification file
		for id,data in pairs( bodygroups ) do -- for index,value in each vehicle bodygroup
			local indexId = id - 1
			if bgtable[ data["name"] ] then  -- if this index is defined in the vehicle specifications
				local selected = vehicle:GetBodygroup( indexId )
				if bgtable[ data["name"] ][ tostring( selected ) ] then
					for component,option in pairs( bgtable[ data["name"] ][ tostring( selected ) ] ) do
						resultTable[ component ] = option
					end
				end
			end
		end
	end
	
	for component, option in pairs( EMVU.Sequences[name]["Traffic"][option]["Components"] ) do
		resultTable[ component ] = option
	end
	
	return resultTable
end

function EMVU.Helper:GetTrafficAdvisorName( name, option )
	return EMVU.Sequences[name]["Traffic"][option].Name
end