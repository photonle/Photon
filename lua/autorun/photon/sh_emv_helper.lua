AddCSLuaFile()
if EMVU then EMVU.Helper = {} end

function EMVU.Helper:GetVectors( name )
	return EMVU.Positions[name]
end

local IsValid = IsValid
local istable = istable
local pairs = pairs
local tostring = tostring
local math = math

local printedErrors = {}

function EMVU.Helper.GetAlertSequence( name, vehicle )
	local resultTable = {}

	if IsValid( vehicle ) and istable( EMVU.Sequences[name]["Alert"]["BG_Components"] ) then
		local bodygroups = vehicle:GetBodyGroups() -- BodyGroups of vehicle
		local bgtable = EMVU.Sequences[name]["Alert"]["BG_Components"] -- BodyGroups defined in vehicle specification file
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

	if IsValid( vehicle ) and istable( EMVU.Sequences[name]["Alert"]["Preset_Components"] ) then
		local preset = vehicle:Photon_ELPresetOption()
		local ptable = EMVU.Sequences[name]["Alert"]["Preset_Components"][preset]
		if istable( ptable ) then
			for id,data in pairs( ptable ) do
				resultTable[ id ] = data
			end
		end
	end

	if IsValid( vehicle ) and istable( EMVU.Sequences[name]["Alert"]["Selection_Components"]) then
		local selComp = EMVU.Sequences[name]["Alert"]["Selection_Components"]
		for i=1,#selComp do
			-- PrintTable(selComp)
			local currentOption = vehicle:Photon_SelectionOption( i )
			if istable( selComp[i] ) then
				local ptable = selComp[i][currentOption]
				if istable( ptable ) then
				for id,data in pairs( ptable ) do
					resultTable[ id ] = data
				end
			end
		end
		end
	end

	for component, option in pairs( EMVU.Sequences[name]["Alert"]["Components"] ) do
		resultTable[ component ] = option
	end

	return resultTable
end

function EMVU.Helper.GetBrakeSequence( name, vehicle, resultTable )
	if IsValid( vehicle ) and istable( EMVU.Sequences[name]["Braking"]["Selection_Components"]) then
		local selComp = EMVU.Sequences[name]["Braking"]["Selection_Components"]
		for i,optionInfo in pairs( selComp ) do
			local currentOption = vehicle:Photon_SelectionOption( i )
			if istable( selComp[i] ) then
				local ptable = selComp[i][currentOption]
				if istable( ptable ) then
					for id,data in pairs( ptable ) do
						if vehicle.EL.Frames[id] and vehicle.EL.Frames[id][data] then
							resultTable[ id ] = data
						end
					end
				end
			end
		end
	end
	return resultTable
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

	if IsValid( vehicle ) and istable( EMVU.Sequences[name]["Sequences"][option]["Preset_Components"] ) then
		local preset = vehicle:Photon_ELPresetOption()
		local ptable = EMVU.Sequences[name]["Sequences"][option]["Preset_Components"][preset]
		if istable( ptable ) then
			for id,data in pairs( ptable ) do
				resultTable[ id ] = data
			end
		end
	end

	if IsValid( vehicle ) and istable( EMVU.Sequences[name]["Sequences"][option]["Selection_Components"]) then
		local selComp = EMVU.Sequences[name]["Sequences"][option]["Selection_Components"]
		for i,options in pairs( selComp ) do
			local currentOption = vehicle:Photon_SelectionOption( i )
			if istable( options ) and istable( options[currentOption] ) then
				for id,data in pairs( options[currentOption] ) do
					resultTable[ id ] = data
				end
			end
		end
	end

	for component, option in pairs( EMVU.Sequences[name]["Sequences"][option]["Components"] ) do
		resultTable[ component ] = option
	end

	return resultTable
end

function EMVU.Helper:GetTASequence( name, option, vehicle )

	if not istable( EMVU.Sequences[ name ].Traffic ) then return end
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

	if IsValid( vehicle ) and istable( EMVU.Sequences[name]["Traffic"][option]["Preset_Components"] ) then
		local preset = vehicle:Photon_ELPresetOption()
		local ptable = EMVU.Sequences[name]["Traffic"][option]["Preset_Components"][preset]
		if istable( ptable ) then
			for id,data in pairs( ptable ) do
				resultTable[ id ] = data
			end
		end
	end

	if IsValid( vehicle ) and istable( EMVU.Sequences[name]["Traffic"][option]["Selection_Components"]) then
		local selComp = EMVU.Sequences[name]["Traffic"][option]["Selection_Components"]
		for i,options in pairs( selComp ) do
			local currentOption = vehicle:Photon_SelectionOption( i )
			if istable( options[currentOption] ) then
				for id,data in pairs( options[currentOption] ) do
					resultTable[ id ] = data
				end
			end
		end
		-- for i=1,#selComp do
		-- 	local currentOption = vehicle:Photon_SelectionOption( i )
		-- 	for id,data in pairs( selComp[i][currentOption] ) do
		-- 		resultTable[ id ] = data
		-- 	end
		-- end
	end

	for component, option in pairs( EMVU.Sequences[name]["Traffic"][option]["Components"] ) do
		resultTable[ component ] = option
	end

	return resultTable
end

function EMVU.Helper:GetIllumSequence( name, option, vehicle )
	-- if not istable( EMVU.Sequences[ name ] ) then
	-- 	local errorString = "[Photon] CRITICAL ERROR: " .. tostring( name ) .. " is not index in EMVU.Sequences. "
	-- 	if not printedErrors[ errorString ] then printedErrors[ errorString ] = true; print( errorString ) end
	-- 	return
	-- end
	EMVU.Sequences = EMVU.Sequences or {}
	if not name or not option or not vehicle then return {} end
	if not istable( EMVU.Sequences[ name ] ) or not istable( EMVU.Sequences[ name ].Illumination ) then return {} end
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

	if IsValid( vehicle ) and istable( EMVU.Sequences[name]["Illumination"][option]["Preset_Components"] ) then
		local preset = vehicle:Photon_ELPresetOption()
		local ptable = EMVU.Sequences[name]["Illumination"][option]["Preset_Components"][preset]
		if istable( ptable ) then
			for id,data in pairs( ptable ) do
				resultTable[ id ] = data
			end
		end
	end

	if IsValid( vehicle ) and istable( EMVU.Sequences[name]["Illumination"][option]["Selection_Components"]) then
		local selComp = EMVU.Sequences[name]["Illumination"][option]["Selection_Components"]
		for i,options in pairs( selComp ) do
			local currentOption = vehicle:Photon_SelectionOption( i )
			if istable( options[currentOption] ) then
				for id,data in pairs( options[currentOption] ) do
					resultTable[ #resultTable + 1 ] = data
				end
			end
		end
	end

	for component, option in pairs( EMVU.Sequences[name]["Illumination"][option]["Components"] ) do
		resultTable[ component ] = option
	end

	return resultTable

end

function EMVU.Helper.GetUsedLightsFromComponent( name, component )
	local resultTable = {}
	local componentTable = EMVU.Sections[ name ][ component ]
	if not componentTable then return {} end -- error is thrown elsewhere for this
	for _,frame in pairs( componentTable ) do
		for __,lightData in pairs( frame ) do
			resultTable[ tostring( lightData[1] ) ] = true
		end
	end
	return resultTable
end

function EMVU.Helper.FetchUsedLights( vehicle )
	if not IsValid( vehicle ) then return end
	local name = vehicle.VehicleName
	local primaryOption = vehicle:Photon_LightOption()
	local auxOption = vehicle:Photon_TrafficAdvisorOption()
	local illumOption = vehicle:Photon_IllumOption()
	-- print("illum option: ".. tostring(illumOption))
	local resultTable = {}
	local primaryLights = EMVU.Helper:GetSequence( name, primaryOption, vehicle ) or {}
	local auxiliaryLights = EMVU.Helper:GetTASequence( name, auxOption, vehicle ) or {}
	local illumLights = EMVU.Helper:GetIllumSequence( name, illumOption, vehicle )
	-- print("ILLUM LIGHTS RECEIVED: ")
	-- PrintTable( illumLights )
	for component,_ in pairs( primaryLights, auxiliaryLights ) do
		for key,_ in pairs( EMVU.Helper.GetUsedLightsFromComponent( name, component ) ) do
			resultTable[tostring(key)] = true
		end
	end
	if istable( illumLights ) then
		for _,lightInfo in pairs( illumLights ) do
			resultTable[tostring(lightInfo[1])] = true
		end
	end

	--PrintTable( resultTable )
	return resultTable
end

function EMVU.Helper:GetSequenceName( name, option )
	return EMVU.Sequences[name]["Sequences"][option]["Name"]
end

function EMVU.Helper:GetModeDisconnect( name, option )
	if EMVU.Sequences[name]["Sequences"][option]["Disconnect"] then return EMVU.Sequences[name]["Sequences"][option]["Disconnect"] end
	return false
end

function EMVU.Helper:GetTrafficOptions( name )
	return EMVU.Sequences[ name ][ "Traffic" ]
end

function EMVU.Helper:GetTrafficELDisconnect( name, option )
	if istable( EMVU.Sequences[ name ][ "Traffic" ][ option ]["EL_Disconnect"] ) then
		return EMVU.Sequences[ name ][ "Traffic" ][ option ]["EL_Disconnect"]
	else
		return {}
	end
end

function EMVU.Helper:GetPattern( name, option, frame )
	local pattern = EMVU.Helper:GetSequence( name, option )[frame]
	--PrintTable( EMVU.Patterns[name][pattern] )
	return EMVU.Patterns[name][pattern]
end

function EMVU.Helper:GetPatterns( name )
	return EMVU.Patterns[name]
end

function EMVU.Helper:GetMeta( name )
	return EMVU.LightMeta[name]
end

function EMVU.Helper:Photon_GetFrame( name, component, index, frame )
	if EMVU.Patterns[name] and EMVU.Patterns[name][component] and EMVU.Patterns[name][component][index] and EMVU.Patterns[name][component][index][frame] then
		return EMVU.Patterns[name][component][index][frame]
	else
		return {}
	end
end

function EMVU.Helper:Photon_GetLightSection( name, component, frame, skip )
	if istable( skip ) then
		local lights = EMVU.Sections[name][component][frame]
		local resultTable = {}
		if istable( lights ) then
			for _,light in pairs( lights ) do
				if not skip[ light[1] ] then
					resultTable[ #resultTable + 1 ] = light
				end
			end
			return resultTable
		else
			return EMVU.Sections[name][component][frame]
		end
	else
		return EMVU.Sections[name][component][frame]
	end
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

// function EMVU.Helper:GetProps( name )
// 	return EMVU.Props[name]
// end

function EMVU.Helper:GetProps( name, ent )
	local results = {} -- ALL ABOUT THAT PRECACHIN
	if istable( EMVU.Props[name] ) and not ent:Photon_SelectionEnabled() then
		for i=1,#EMVU.Props[name] do
			results[i] = EMVU.Props[name][i]
		end
	end
	if ent:Photon_PresetEnabled() then
		local presetData = EMVU.Helper:GetPresetData( name, ent:Photon_ELPresetOption() )
		if istable( presetData.Auto ) then
			for _,id in pairs( presetData.Auto ) do
				local preset = EMVU.AutoIndex[ name ][ id ]
				local autoData = EMVU.Auto[ preset[ "ID" ] ]
				local propData = EMVU.Helper:GetAutoModel( preset[ "ID" ] )
				propData.Pos = preset.Pos
				propData.Ang = preset.Ang
				propData.Scale = preset.Scale
				propData.RenderGroup = preset.RenderGroup
				propData.RenderMode = preset.RenderMode
				propData.AutoIndex = id
				propData.ComponentName = preset[ "ID" ]
				if autoData.RotationEnabled then
					propData.PhotonRotationEnabled = true
					propData.PhotonBoneAnimationData = autoData.BoneOperations
				end
				results[ #results + 1 ] = propData
			end
		end
		if istable( presetData.Props ) then
			for _,prop in pairs( presetData.Props ) do
				results[ #results + 1 ] = prop
			end
		end
	end
	if ent:Photon_SelectionEnabled() then
		if istable( EMVU.Selections[ name ] ) then
			for index,category in pairs( EMVU.Selections[ name ] ) do
				local selected = ent:Photon_SelectionOption( index )
				if istable( category.Options[selected] ) then
					if category.Options[selected].Auto then
						for _,id in pairs( category.Options[selected].Auto ) do
							local component = EMVU.AutoIndex[ name ][ id ]
							if not component then Error( "[Photon] No component (" .. tostring( id ) .. ") found under vehicle (" .. tostring( name ) .. ")" ) end
							local autoData = EMVU.Auto[ component[ "ID" ] ]
							local propData = EMVU.Helper:GetAutoModel( component[ "ID" ] )
							if not propData.Model then continue end
							propData.Pos = component.Pos
							propData.Ang = component.Ang
							propData.Scale = component.Scale
							propData.BodyGroups = component.BodyGroups or false
							propData.AutoIndex = id
							propData.ComponentName = component[ "ID" ]
							if autoData.RotationEnabled then
								propData.PhotonRotationEnabled = true
								propData.PhotonBoneAnimationData = autoData.BoneOperations
							end
							results[ #results + 1 ] = propData
						end
					end
					if category.Options[selected].Props then
						for _,id in pairs( category.Options[selected].Props ) do
							results[ #results + 1 ] = EMVU.Props[ name ][ id ]
						end
					end
				end
			end
		end
	end
	--PrintTable( results )
	return results
end

function EMVU.Helper:GetAutoModel( id )
	local modelData = EMVU.Auto[ id ]
	if not modelData then return {} end
	return {
		Model = modelData.Model,
		Skin = modelData.Skin or 0,
		BodyGroups = modelData.Bodygroups or {}
	}
end

function EMVU.Helper:BodygroupPreset( ent, index )
	local presetData = EMVU.Helper:GetPresetData( ent.Name, index )
	return presetData.Bodygroups or {}
end

function EMVU.Helper:GetPresetData( name, index )
	return EMVU.PresetIndex[ name ][ index ]
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

function EMVU.Helper:GetTrafficAdvisorName( name, option )
	return EMVU.Sequences[name]["Traffic"][option].Name
end

function EMVU.Helper.GetLocalToWorld( posData )
	if posData[1] == "RE" then
		return
	else

	end
end

-- name: Vehicle Name
-- car: vehicle entity
-- lbEntity: the lightbar entity with bones
-- posIndex: the position index of the vehicle to return pos and ang data for
-- [1] = "RE", [2] = "BONE_NAME", [3] = Vector relative pos to bone, [4] = Angle relative to bone

function EMVU.Helper.GetPositionFromRE( car, lbEntity, posInput, returnWorld )
	if not IsValid( lbEntity ) then return Vector(), Angle(), 0 end
	if not lbEntity.PhotonLocalAngs then lbEntity.PhotonLocalAngs = Vector() end
	local name = car:EMVName()
	local posData
	if not istable( posInput ) then posData = EMVU.Positions[ name ][ posIndex ] else posData = posInput end
	local posVector = posData[3]
	local posAngle = posData[4]
	-- print(tostring(lbEntity.ComponentName))
	-- print(tostring(posData[2]))
	local boneData = EMVU.Auto[ tostring(lbEntity.ComponentName) ].Bones[ posData[2] ]
	local boneIndex = boneData.Bone
	local boneWorldPos, boneWorldAng = lbEntity:GetBonePosition( boneIndex )
	-- local boneMatrix = lbEntity:GetBoneMatrix( )
	-- local bonePos = car:WorldToLocal( boneWorldPos )
	-- local boneAng = car:WorldToLocalAngles( boneWorldAng )
	local bonePos, boneAng
	if returnWorld then
		bonePos = boneWorldPos
		boneAng = boneWorldAng
	else
		bonePos = car:WorldToLocal( boneWorldPos )
		boneAng = car:WorldToLocalAngles( boneWorldAng )
	end

	local newPos = Vector()
	local newAng = Angle()
	-- print(tostring(lbEntity:GetAngles().p))
	local contingentTransform = ( math.abs(lbEntity.PhotonLocalAngs.p) > 0 )
	newPos:Set( posVector or Vector() )
	newAng:Set( boneAng or Angle() )
	-- if contingentTransform then
	-- 	local tempVector = Angle()
	-- 	tempVector:Set( newAng )
	-- 	newAng.p = tempVector.p + posAngle.p
	-- 	newAng.r = tempVector.y + posAngle.y
	-- 	newAng.y = (tempVector.r + posAngle.r) - 90
	-- else
	-- 	newAng.p = newAng.p + posAngle.p
	-- 	newAng.y = newAng.y + posAngle.y
	-- 	newAng.r = newAng.r + posAngle.r
	-- end
	newAng.p = newAng.p + posAngle.p
		newAng.y = newAng.y + posAngle.y
		newAng.r = newAng.r + posAngle.r
	newPos:Rotate( newAng )
	newPos:Add( bonePos )
	-- print( "Car: " .. tostring( car:GetAngles() ) )
	-- print( "World to local: " .. tostring(newAng))
	-- print( "Raw manipupated: " .. tostring(lbEntity:GetManipulateBoneAngles( boneIndex )))
	return newPos, newAng, lbEntity:GetManipulateBoneAngles( boneIndex ).r, contingentTransform
end

function EMVU.Helper.GetBonePositionFromRE( car, lbEntity, posInput )
	local name = car:EMVName()
	local posData
	if not istable( posInput ) then posData = EMVU.Positions[ name ][ posIndex ] else posData = posInput end
	local posVector = posData[3]
	local posAngle = posData[4]
	-- print(tostring(lbEntity.ComponentName))
	-- print(tostring(posData[2]))
	local boneData = EMVU.Auto[ tostring(lbEntity.ComponentName) ].Bones[ posData[2] ]
	local boneIndex = boneData.Bone
	local boneWorldPos, boneWorldAng = lbEntity:GetBonePosition( boneIndex )
	return boneWorldPos
end