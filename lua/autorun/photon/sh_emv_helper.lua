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
local insert = table.insert

local printedErrors = {}

--- Pack sequence document, or nil when the vehicle has no EMV sequences yet.
--- @param name any
--- @return table|nil
local function sequenceData(name)
	return istable(EMVU.Sequences) and EMVU.Sequences[name] or nil
end

--- Resolve a table, which is in either Map<idx, value>, (idx, value)[] or a mix, to be output in (idx, value)[] format, allowing for ipairs.
-- @tab tab Input table.
-- @rtab
function EMVU.Helper.ResolveTable(tab)
	if not istable(tab) then
		PhotonWarning("Non table passed to ResolveTable")
		PhotonWarning(debug.traceback())
		return tab
	end

	local out = {}
	for idx, value in pairs(tab) do
		if istable(value) then
			insert(out, value)
		else
			insert(out, {idx, value})
		end
	end

	return out
end

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
		for i = 1, #selComp do
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

function EMVU.Helper.GetParkSequence( name, vehicle, resultTable )
	if IsValid( vehicle ) and istable( EMVU.Sequences[name]["Park"]["BG_Components"] ) then
		local bodygroups = vehicle:GetBodyGroups() -- BodyGroups of vehicle
		local bgtable = EMVU.Sequences[name]["Park"]["BG_Components"] -- BodyGroups defined in vehicle specification file
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

	if IsValid( vehicle ) and istable( EMVU.Sequences[name]["Park"]["Preset_Components"] ) then
		local preset = vehicle:Photon_ELPresetOption()
		local ptable = EMVU.Sequences[name]["Park"]["Preset_Components"][preset]
		if istable( ptable ) then
			for id,data in pairs( ptable ) do
				resultTable[ id ] = data
			end
		end
	end

	if IsValid( vehicle ) and istable( EMVU.Sequences[name]["Park"]["Selection_Components"]) then
		local selComp = EMVU.Sequences[name]["Park"]["Selection_Components"]
		for i = 1, #selComp do
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
	if IsValid( vehicle ) and istable( EMVU.Sequences[name]["Park"]["Components"]) then
		for component, option in pairs( EMVU.Sequences[name]["Park"]["Components"] ) do
			resultTable[ component ] = option
		end
	end

	return resultTable
end

function EMVU.Helper.GetBrakeSequence( name, vehicle, resultTable )
	if IsValid( vehicle ) and istable( EMVU.Sequences[name]["Braking"]["BG_Components"] ) then
		local bodygroups = vehicle:GetBodyGroups() -- BodyGroups of vehicle
		local bgtable = EMVU.Sequences[name]["Braking"]["BG_Components"] -- BodyGroups defined in vehicle specification file
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

	if IsValid( vehicle ) and istable( EMVU.Sequences[name]["Braking"]["Preset_Components"] ) then
		local preset = vehicle:Photon_ELPresetOption()
		local ptable = EMVU.Sequences[name]["Braking"]["Preset_Components"][preset]
		if istable( ptable ) then
			for id,data in pairs( ptable ) do
				resultTable[ id ] = data
			end
		end
	end

	if IsValid( vehicle ) and istable( EMVU.Sequences[name]["Braking"]["Selection_Components"]) then
		local selComp = EMVU.Sequences[name]["Braking"]["Selection_Components"]
		for i = 1, #selComp do
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
	if IsValid( vehicle ) and istable( EMVU.Sequences[name]["Braking"]["Components"]) then
		for component, option in pairs( EMVU.Sequences[name]["Braking"]["Components"] ) do
			resultTable[ component ] = option
		end
	end

	return resultTable
end

function EMVU.Helper.GetReverseSequence( name, vehicle, resultTable )
	if IsValid( vehicle ) and istable( EMVU.Sequences[name]["Reverse"]["BG_Components"] ) then
		local bodygroups = vehicle:GetBodyGroups() -- BodyGroups of vehicle
		local bgtable = EMVU.Sequences[name]["Reverse"]["BG_Components"] -- BodyGroups defined in vehicle specification file
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

	if IsValid( vehicle ) and istable( EMVU.Sequences[name]["Reverse"]["Preset_Components"] ) then
		local preset = vehicle:Photon_ELPresetOption()
		local ptable = EMVU.Sequences[name]["Reverse"]["Preset_Components"][preset]
		if istable( ptable ) then
			for id,data in pairs( ptable ) do
				resultTable[ id ] = data
			end
		end
	end

	if IsValid( vehicle ) and istable( EMVU.Sequences[name]["Reverse"]["Selection_Components"]) then
		local selComp = EMVU.Sequences[name]["Reverse"]["Selection_Components"]
		for i = 1, #selComp do
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
	if IsValid( vehicle ) and istable( EMVU.Sequences[name]["Reverse"]["Components"]) then
		for component, option in pairs( EMVU.Sequences[name]["Reverse"]["Components"] ) do
			resultTable[ component ] = option
		end
	end

	return resultTable
end

function EMVU.Helper:GetSequence( name, option, vehicle )
	local data = sequenceData(name)
	if not istable(data) or not istable(data.Sequences) or not istable(data.Sequences[option]) then
		return {}
	end

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
	local data = sequenceData(name)
	if not istable(data) or not istable(data.Traffic) or not istable(data.Traffic[option]) then return end
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
	if not istable(EMVU.Sequences[name]) then return {} end
	if not istable(EMVU.Sequences[name].Illumination) then return {} end
	if not istable(EMVU.Sequences[name].Illumination[option]) then return {} end
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
		resultTable[ #resultTable + 1 ] = option
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

function EMVU.Helper.FetchUsedLights(vehicle)
	if not IsValid(vehicle) then return end

	local name = vehicle.VehicleName
	local primaryOption = vehicle:Photon_LightOption()
	local auxOption = vehicle:Photon_TrafficAdvisorOption()
	local illumOption = vehicle:Photon_IllumOption()

	local resultTable = {}
	local primaryLights = EMVU.Helper:GetSequence(name, primaryOption, vehicle) or {}
	local auxiliaryLights = EMVU.Helper:GetTASequence(name, auxOption, vehicle) or {}
	local illumLights = EMVU.Helper:GetIllumSequence(name, illumOption, vehicle)

	for component, _ in pairs(primaryLights) do
		for key, _ in pairs(EMVU.Helper.GetUsedLightsFromComponent(name, component)) do
			resultTable[tostring(key)] = true
		end
	end

	for component, _ in pairs(auxiliaryLights) do
		for key, _ in pairs(EMVU.Helper.GetUsedLightsFromComponent(name, component)) do
			resultTable[tostring(key)] = true
		end
	end

	if istable(illumLights) then
		for _, lightInfo in pairs(illumLights) do
			resultTable[tostring(lightInfo[1])] = true
		end
	end

	return resultTable
end

function EMVU.Helper:GetSequenceName( name, option )
	local data = sequenceData(name)
	local stage = istable(data) and istable(data.Sequences) and data.Sequences[option]
	if istable(stage) then return stage.Name end
end

function EMVU.Helper:GetModeDisconnect( name, option )
	local data = sequenceData(name)
	local stage = istable(data) and istable(data.Sequences) and data.Sequences[option]
	if istable(stage) and stage.Disconnect then return stage.Disconnect end
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

				if autoData and propData then
					propData.Pos = preset.Pos
					propData.Ang = preset.Ang
					propData.Scale = preset.Scale
					propData.RenderGroup = preset.RenderGroup
					propData.RenderMode = preset.RenderMode
					propData.Skin = preset.Skin or propData.Skin
					propData.BodyGroups = preset.BodyGroups or propData.BodyGroups
					propData.SubMaterials = preset.SubMaterials or propData.SubMaterials
					propData.AutoIndex = id
					propData.ComponentName = preset[ "ID" ]
					if autoData.RotationEnabled then
						propData.PhotonRotationEnabled = true
						propData.PhotonBoneAnimationData = autoData.BoneOperations
					end
					results[ #results + 1 ] = propData
				end
			end
		end
		if istable( presetData.Props ) then
			for _,prop in pairs( presetData.Props ) do
				results[ #results + 1 ] = prop
			end
		end
	end
	if ent:Photon_SelectionEnabled() and istable( EMVU.Selections[ name ] ) then
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
						propData.RenderGroup = component.RenderGroup
						propData.RenderMode = component.RenderMode
						propData.Skin = component.Skin or propData.Skin
						propData.BodyGroups = component.BodyGroups or propData.BodyGroups
						propData.SubMaterials = component.SubMaterials or propData.SubMaterials
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
	return results
end

function EMVU.Helper:GetAutoModel( id )
	local modelData = EMVU.Auto[ id ]
	if not modelData then return {} end
	return {
		Model = modelData.Model,
		Skin = modelData.Skin or 0,
		BodyGroups = modelData.Bodygroups or {},
		SubMaterials = modelData.SubMaterials or {}
	}
end

--- Build the vehicle-local Euler for an auto-component light.
--- Kept in authored Euler space so sprite facing (which reads `.y` and then
--- subtracts 90 from `.r`) stays aligned with the component model.
--- `Matrix:GetAngles()` can re-express the same rotation with a flipped yaw,
--- which turns that `.y` read into a backwards-facing sprite.
--- @param component table
--- @param localAng Angle Light angle in component space.
--- @param autoAng Angle Component angle on the vehicle.
--- @return Angle
function EMVU.Helper.ComposeAutoLightAngle(component, localAng, autoAng)
	local p, y, r = localAng.p, localAng.y, localAng.r
	if component.ForwardTranslation then
		p, y, r = -localAng.r, localAng.y, localAng.p
	end

	local yawAdjust = 0
	if not component.NotLegacy then
		yawAdjust = -90
	end

	return Angle(p + autoAng.p, y + autoAng.y + yawAdjust, r + autoAng.r)
end

--- Apply a uniform or per-axis scale to a model without stacking transforms.
--- Spawn uses `EnableMatrix("RenderMultiply")`; a lua refresh used to call
--- `SetModelScale` on top of that leftover matrix, so saving a vehicle file
--- (even without touching Scale) compounded the size until the vehicle was
--- respawned.
--- @param ent Entity
--- @param scale Vector|number|nil
function EMVU.Helper.ApplyModelScale(ent, scale)
	if not IsValid(ent) then return end

	if CLIENT then
		ent:DisableMatrix("RenderMultiply")
	end
	ent:SetModelScale(1, 0)

	if isvector(scale) then
		if scale.x == 1 and scale.y == 1 and scale.z == 1 then return end
		if CLIENT then
			local mat = Matrix()
			mat:Scale(scale)
			ent:EnableMatrix("RenderMultiply", mat)
		else
			ent:SetModelScale(scale.x, 0)
		end
		return
	end

	if isnumber(scale) and scale ~= 1 then
		if CLIENT then
			local mat = Matrix()
			mat:Scale(Vector(scale, scale, scale))
			ent:EnableMatrix("RenderMultiply", mat)
		else
			ent:SetModelScale(scale, 0)
		end
	end
end

function EMVU.Helper:BodygroupPreset( ent, index )
	local presetData = EMVU.Helper:GetPresetData( ent.Name, index )
	return presetData.Bodygroups or {}
end

function EMVU.Helper:GetPresetData( name, index )
	local presets = EMVU.PresetIndex[ name ]
	if not presets then return {} end
	return presets[ index ] or {}
end

function EMVU.Helper:GetIlluminationName( name, option )
	return EMVU.Sequences[name].Illumination[option].Name
end

function EMVU.Helper:GetIlluminationLights( name, option )
	local data = sequenceData(name)
	local stageData = istable(data) and istable(data.Illumination) and data.Illumination[option]
	if not istable(stageData) then return {} end
	return stageData.Lights or {}
end

function EMVU.Helper:GetLampMeta( name, index )
	return EMVU.Lamps[name][index]
end

function EMVU.Helper:HasLamps( name )
	local data = sequenceData(name)
	if istable(data) and istable(data.Illumination) and istable(data.Illumination[1]) then return true end
	return false
end

function EMVU.Helper:HasTrafficAdvisor( name )
	local data = sequenceData(name)
	if istable(data) and istable(data.Traffic) and istable(data.Traffic[1]) then return true end
end

function EMVU.Helper:GetTrafficAdvisorName( name, option )
	local data = sequenceData(name)
	local stage = istable(data) and istable(data.Traffic) and data.Traffic[option]
	if istable(stage) then return stage.Name end
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
	if not boneWorldPos then return Vector(), Angle(), 0 end
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

--- Fetch the sub props used in multi-prop vehicles.
-- @ent car Vehicle to fetch sub props for.
-- @treturn table Array of subprops.
function EMVU.Helper.GetSubProps(car)
	local out = {}
	for _, prop in ipairs(car:GetChildren()) do
		if prop:GetClass() == "prop_dynamic_ornament" then
			table.insert(out, prop)
		end
	end
	return out
end

-- Returns whether or not the "Alert Mode" should automatically
-- adjust light patterns.
function EMVU.Helper.GetAlertModeEnabled( name )
	-- TODO: Remove below line before publishing update
	if not istable(EMVU.Attributes[ name ]) then print("[Photon] ERROR: No Attributes table found for: " .. tostring(name) .. ". Please notify @schmal if you see this.") end
	if (istable(EMVU.Attributes[ name ]) and (EMVU.Attributes[ name ].DisableAlertPatterns)) then return false end
	return true
end