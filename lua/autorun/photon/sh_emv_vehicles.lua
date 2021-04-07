AddCSLuaFile()

PHOTON_HASHCOMPONENTS = true

local tostring = tostring
local IsValid = IsValid
local istable = istable
local pairs = pairs
local isnumber = isnumber
local tonumber = tonumber

local function MirrorVector( vec, method )
	local newVector = Vector()
	if method == nil then
		newVector:Set( vec )
		newVector.x = vec.x * -1
	end
	return newVector
end

local function MirrorAngle( ang, method )
	local newAng = Angle()
	if method == nil then
		newAng:Set( ang )
		newAng.p = ang.p * -1
		newAng.r = ang.r * -1
		local yAngDif = -90 - ang.y
		newAng.y = ang.y + ( yAngDif * 2 )
	end
	if method == "opp" then
		newAng:Set( ang )
		newAng.p = ang.p * -1
		newAng.y = ang.y * -1
		-- newAng.r = ang.r * -1
	end
	return newAng
end

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

EMVU.Configurations.Library = {}

EMVU.Configurations.LoadConfigurations = function()
	local files = file.Find( "photon/equip_configs/*", "DATA" )
	for _,_file in pairs( files ) do
		local fileContents = file.Read( "photon/equip_configs/" .. _file )
		local resultVehicle = util.JSONToTable( fileContents )
		local fileNameData = string.Split( _file, "_" )
		local vehicleId = fileNameData[1]
		resultVehicle.VehicleTypeID = vehicleId
		resultVehicle.StoreType = "LOCAL FILE"
		resultVehicle.FileName = "photon/equip_configs/" .. _file
		resultVehicle.Date = os.date( "%Y-%m-%d", file.Time( "photon/equip_configs/" .. _file, "DATA" ) )
		EMVU.Configurations.AddConfiguration( resultVehicle )
	end
	local luaTables = list.Get( "PhotonConfigurationLibrary" )
	for key,_data in pairs( luaTables ) do
		local resultVehicle = util.JSONToTable( _data )
		local fileNameData = string.Split( key, "_" )
		local vehicleId = fileNameData[1]
		resultVehicle.VehicleTypeID = vehicleId
		resultVehicle.StoreType = "LUA"
		EMVU.Configurations.AddConfiguration( resultVehicle )
	end
end

EMVU.Configurations.AddConfiguration = function( data )
	local vehicleId = data.VehicleTypeID
	if not vehicleId then return false end
	if not istable(EMVU.Configurations.Library[ vehicleId ]) then EMVU.Configurations.Library[ vehicleId ] = {} end
	local parentTable = EMVU.Configurations.Library[ vehicleId ]
	parentTable[ #parentTable + 1 ] = data
	return true
end

EMVU.Configurations.ResetConfigurations = function()
	table.Empty( EMVU.Configurations.Library )
	EMVU.Configurations.LoadConfigurations()
end

EMVU.Configurations.DeleteConfiguration = function( cfgFile )
	file.Delete( cfgFile )
	EMVU.Configurations.ResetConfigurations()
end

function EMVU:LoadVehicles()
	local cars = list.GetForEdit("Vehicles")
	for k,v in pairs(cars) do
		if v.IsEMV then
			if istable( v.EMV ) then EMVU:PreloadVehicle( v ) end
		elseif EMVU:CheckForELS( v.Model ) then
			v.IsEMV = true
			v.EMV = EMVU:CheckForELS( v.Model )
			list.Set( "Vehicles", k, v )
			EMVU:PreloadVehicle( v )
		end
	end
end

function EMVU:CheckForELS( model )
	if Photon.GetEMVIndex( model ) then return Photon.EMVLibrary[ Photon.GetEMVIndex(model) ] else return false end
end

function EMVU:PreloadVehicle( car )
	if EMVU.Positions[ car.Name ] then return end
	if car.Name then EMVU:OverwriteIndex( tostring( car.Name ), car.EMV or {} ) return end
	if istable( car.EMV.Sequences ) then EMVU.LoadModeData( car.Name, car.EMV.Sequences ) end

	EMVU.Index[ #EMVU.Index + 1 ] = car.Name

	if CLIENT then
		if istable( car.EMV.Positions ) then
			EMVU.Positions[ car.Name ] = car.EMV.Positions
		elseif isstring(car.EMV.Positions) then
			EMVU.Positions[ car.Name ] = EMVU.Positions[car.EMV.Positions]
		else
			EMVU.Positions[ car.Name ] = {}
		end
	end

	if CLIENT then
		if istable( car.EMV.Meta ) then
			EMVU.LightMeta[ car.Name ] = car.EMV.Meta
		elseif isstring(car.EMV.Meta) then
			EMVU.LightMeta[ car.Name ] = EMVU.LightMeta[car.EMV.Meta]
		else
			EMVU.LightMeta[ car.Name ] = {}
		end
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

function EMVU:OverwriteIndex(name, data)
	if not data then
		print("[Photon] Data must be table with valid Meta, Positions, Patterns and Sequences. Overwrite failed.")
		return
	end

	EMVU.LightMeta[name] = data.Meta or {}
	if CLIENT then
		safeTableEmpty(EMVU.Positions[name])
		EMVU.Positions[name] = data.Positions or {}
	end

	EMVU.Patterns[name] = data.Patterns or {}
	if istable(data.Sequences) then
		EMVU.LoadModeData(name, data.Sequences)
	end

	EMVU.Sections[name] = data.Sections or {}

	if istable(data.Lamps) then
		EMVU.Lamps[name] = data.Lamps
	end

	if istable(data.Props) then
		EMVU.Props[name] = data.Props
		for _, prop in pairs(data.Props) do
			util.PrecacheModel(prop.Model)
		end
	end

	if istable(data.Presets) then
		EMVU.PresetIndex[name] = data.Presets
	else
		EMVU.LoadPresetDefault(name, data)
	end

	if istable(data.Selections) then
		EMVU.Selections[name] = data.Selections
	end

	if istable(data.Liveries) then
		EMVU.Liveries[name] = data.Liveries
	end

	if istable(data.SubMaterials) then
		EMVU.SubMaterials[name] = data.SubMaterials
	end

	if istable(data.AutoInsert) then
		EMVU.AutoInsert[name] = data.AutoInsert
	end

	if istable(data.Auto) then
		EMVU.AutoIndex[name] = data.Auto
		EMVU:CalculateAuto(name, data.Auto, data.AutoInsert)
	end

	if data.Configuration then
		self:AddSupportedConfiguration(name, data.Configuration)
	end

	if data.RadarDisabled then
		EMVU.DisabledRadars[name] = true
	else
		EMVU.DisabledRadars[name] = nil
	end

	-- Updating prop positions
	if not CLIENT then return end

	for _, ent in ipairs(Photon:AllVehicles()) do
		if ent.VehicleName ~= name then continue end
		ent:Photon_UpdateEMVProps()
	end
end

--- Mark a vehicle as supporting configs.
-- @string name Name of the vehicle to add.
-- @tparam string|bool Either the name of the config, or true to automatically generate a name.
function EMVU:AddSupportedConfiguration(name, config)
	if isstring(config) then
		self.Configurations.Supported[name] = config
	elseif isbool(config) then
		local words = {}
		for word in name:gmatch("(%w+)") do
			if tonumber(word) ~= nil then
				table.insert(words, word:sub(-2))
			else
				table.insert(words, word:sub(0, 1):lower())
			end
		end
		self.Configurations.Supported[name] = table.concat(words, "")
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

	if istable(data["Traffic"]) and #data["Traffic"] == 0 then data["Traffic"] = nil end

	if not data["Alert"] then

		data.Alert = {
			Components = {},
			BG_Components = {},
			Preset_Components = {}
		}

		if lastSequence.Components then data.Alert.Components = lastSequence.Components end
		if lastSequence.BG_Components then data.Alert.BG_Components = lastSequence.BG_Components end

	end

	if not data["Braking"] then
		data.Braking = {
			Preset_Components = {}
		}
	end

	if not data["Reverse"] then
		data.Reverse = {
			Preset_Components = {}
		}
	end

	if not data["Park"] then
		data.Park = {
			Preset_Components = {}
		}
	end

	EMVU.Sequences[ name ] = data
end

local function hashPosition( firstPos, lastPos, autoPos, autoAng )
	if not istable( firstPos ) and istable( lastPos ) then return "" end
	local result = ""
	for _,dat in pairs( firstPos, lastPos ) do
		result = result .. tostring( dat )
	end
	result = result .. tostring( autoPos ) .. tostring( autoAng )
	return result
end

function EMVU:CalculateAuto( name, data, autoInsert )

	if not istable( data ) then return end

	if istable( autoInsert ) then
		for _, segment in pairs( autoInsert ) do
			if istable( segment.Variants ) then
				for __, variant in pairs( segment.Variants ) do
					local thisIndex = #data + 1

					local newComponent = {}
					newComponent.ID = segment.Component
					newComponent.BodyGroups = segment.BodyGroups
					newComponent.ColorMap = segment.ColorMap
					newComponent.RenderGroup = segment.RenderGroup or RENDERGROUP_OPAQUE
					newComponent.RenderMode = segment.RenderMode or RENDERMODE_NORMAL
					newComponent.Pos = segment.Position
					newComponent.Ang = segment.Angle
					newComponent.Scale = segment.Scale

					if istable( variant.Phases ) then
						newComponent.Phase = variant.Phases[1]
					else
						newComponent.Phase = variant.Phase
					end

					if istable( variant.Colors ) and istable( variant.Colors[1] ) then
						for colorCount, col in pairs( variant.Colors[1] ) do
							newComponent[ "Color" .. tostring( colorCount ) ] = col
						end
					elseif istable( variant.Colors ) then
						for colorCount, col in pairs( variant.Colors ) do
							newComponent[ "Color" .. tostring( colorCount ) ] = col
						end
					end

					local selectionTable = EMVU.Selections[ name ]

					local parentTable
					for ___, selection in pairs( selectionTable ) do
						if selection.Name == segment.Parent then parentTable = selection; break; end
					end
					if not parentTable then
						selectionTable[ #selectionTable + 1 ]  = {
							Name = segment.Parent,
							Options = {}
						}
						parentTable = selectionTable[ #selectionTable ]
					end

					local optionsTable = parentTable.Options
					local optionTable
					for ___, option in pairs( optionsTable ) do
						if option.Category == segment.Category and option.Name == variant.Name then optionTable = option; break; end
					end
					if not optionTable then
						optionsTable[ #optionsTable + 1 ] = {
							Category = segment.Category,
							Name = variant.Name,
							Props = segment.Props,
							Auto = {}
						}
						optionTable = optionsTable[ #optionsTable ]
					end

					local optionAutoTable = optionTable.Auto
					optionAutoTable[ #optionAutoTable + 1 ] = thisIndex

					data[ thisIndex ] = newComponent

					if segment.Mirror then
						thisIndex = thisIndex + 1
						local mirroredComponent = table.Copy( newComponent )
						mirroredComponent.Pos = MirrorVector( mirroredComponent.Pos )
						mirroredComponent.Ang = MirrorAngle( mirroredComponent.Ang, segment.TransformType )

						if istable( variant.Phases ) then
							mirroredComponent.Phase = variant.Phases[2]
						else
							mirroredComponent.Phase = variant.Phase
						end

						if istable( variant.Colors ) and istable( variant.Colors[2] ) then
							for colorCount, col in pairs( variant.Colors[2] ) do
								mirroredComponent[ "Color" .. tostring( colorCount ) ] = col
							end
						end

						optionAutoTable[ #optionAutoTable + 1 ] = thisIndex
						data[ thisIndex ] = mirroredComponent
					end

				end
			end
		end
	end
	if SERVER then return end

	local positionTable = {}
	for i=1,#data do -- for each component in the vehicle's auto
		local component = EMVU.Auto[ data[ i ].ID ]
		local autoData = data[i]
		local autoPos = autoData.Pos
		local autoAng = autoData.Ang
		local autoScale = autoData.Scale or 1
		local adjustAng = Angle()

		if not autoData.AutoPatterns or autoData.AutoPatterns != false then autoData.AutoPatterns = true end

		if not component then print( "[Photon] Auto component: " .. tostring( data[i].ID ) .. " was not found in the library. Requested in: " .. tostring( name ) .. ".") continue end
		if component.Deprecated then
			PhotonWarning("Auto component: " .. tostring(data[i].ID) .. " is deprecated and may be removed in a future version.")
			if isstring(component.Deprecated) then
				PhotonWarning(component.Deprecated)
			end
			PhotonWarning("The component was requested in: " .. tostring(name) .. ".")
		end

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
		for id,metadata in pairs( component.Meta ) do -- add meta template data
			local useId = tostring( tostring( id ) .. "_" .. tostring( i ) )
			EMVU.LightMeta[ name ][ useId ]  = {}
			for prop,val in pairs( metadata ) do
				local resultVal = val
				if prop == "W" then resultVal = val * autoScale end
				if prop == "H" then resultVal = val * autoScale end
				if prop == "EmitArray" and istable( val ) then
					local newArray = {}
					for arrayIdx,pos in pairs(val) do
						newArray[arrayIdx] = Vector()
						newArray[arrayIdx]:Set(pos)
						newArray[arrayIdx]:Mul(autoScale)
					end
					resultVal = newArray
				end
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
						end

					end
				end
			end

			if istable( component.Modes.Primary.BRAKE ) then
				local targetCopy = component.Modes.Primary.BRAKE
				local sequence = EMVU.Sequences[ name ].Braking
				if usesPresets then
					for __,presetIndex in pairs( usedPresets ) do
						if not sequence.Preset_Components[presetIndex] then sequence.Preset_Components[presetIndex] = {} end
						for componentIndex, patternIndex in pairs( targetCopy ) do
							local patternPhase = autoData.Phase or ""
							if component.Patterns[componentIndex][patternIndex .. patternPhase] then
								sequence.Preset_Components[presetIndex][componentIndex .. "_" .. i] = tostring(patternIndex .. patternPhase)
							end
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
								if component.Patterns[componentIndex][patternIndex .. patternPhase] then
									sequence.Selection_Components[_i][__i][componentIndex .. "_" .. i] = tostring(patternIndex .. patternPhase)
								end
							end
						end
					end
				end
			end

			if istable( component.Modes.Primary.REVERSE ) then
				local targetCopy = component.Modes.Primary.REVERSE
				local sequence = EMVU.Sequences[ name ].Reverse
				if usesPresets then
					for __,presetIndex in pairs( usedPresets ) do
						if not sequence.Preset_Components[presetIndex] then sequence.Preset_Components[presetIndex] = {} end
						for componentIndex, patternIndex in pairs( targetCopy ) do
							local patternPhase = autoData.Phase or ""
							if component.Patterns[componentIndex][patternIndex .. patternPhase] then
								sequence.Preset_Components[presetIndex][componentIndex .. "_" .. i] = tostring(patternIndex .. patternPhase)
							end
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
								if component.Patterns[componentIndex][patternIndex .. patternPhase] then
									sequence.Selection_Components[_i][__i][componentIndex .. "_" .. i] = tostring(patternIndex .. patternPhase)
								end
							end
						end
					end
				end
			end

			if istable( component.Modes.Primary.PARK ) then
				local targetCopy = component.Modes.Primary.PARK
				local sequence = EMVU.Sequences[ name ].Park
				if usesPresets then
					for __,presetIndex in pairs( usedPresets ) do
						if not sequence.Preset_Components[presetIndex] then sequence.Preset_Components[presetIndex] = {} end
						for componentIndex, patternIndex in pairs( targetCopy ) do
							local patternPhase = autoData.Phase or ""
							if component.Patterns[componentIndex][patternIndex .. patternPhase] then
								sequence.Preset_Components[presetIndex][componentIndex .. "_" .. i] = tostring(patternIndex .. patternPhase)
							end
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
								if component.Patterns[componentIndex][patternIndex .. patternPhase] then
									sequence.Selection_Components[_i][__i][componentIndex .. "_" .. i] = tostring(patternIndex .. patternPhase)
								end
							end
						end
					end
				end
			end

			if istable( component.Modes.Primary.ALERT ) or ( component.Modes.Primary.M3 ) then
				local targetCopy = component.Modes.Primary.ALERT or component.Modes.Primary.M3
				local sequence = EMVU.Sequences[name].Alert

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

		-- COMPONENT POSITION REUSE
		-- added to recyle position data and avoid excessive RAM usage
		local offset

		if PHOTON_HASHCOMPONENTS and not component.RotationEnabled then
			local firstPosData = component.Positions[ 1 ]
			local lastPosData = component.Positions[ #component.Positions ]
			local componentHash = hashPosition( firstPosData, lastPosData, autoPos, autoAng ) -- hash first and last values to determine if the offset can be recycled
			if not positionTable[ componentHash ] or not isnumber( positionTable[ componentHash ] ) then
				offset = #EMVU.Positions[ name ]
				positionTable[ componentHash ] = offset
			else
				offset = positionTable[ componentHash ]
			end
		else
			offset = #EMVU.Positions[ name ]
		end


		for id=1,#component.Positions do
			local posData = component.Positions[ id ]
			if isvector( posData[1] ) then
				local newPos = Vector()
				newPos:Set( posData[1] )
				newPos:Rotate( adjustAng )
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
					newPos, newAng, tostring( posData[3] .. "_" .. i ), posData[4] or false
				}
			else
				local posCopy = table.Copy( posData )
				local insertPos = table.Copy( posData[1] )
				insertPos[5] = tostring( i )
				local origVector = posData[1][3]
				insertPos[3] = Vector()
				insertPos[3]:Set( origVector )
				insertPos[3]:Mul( autoScale )
				EMVU.Positions[ name ][ offset + id ] = {
					insertPos, posCopy[2], tostring( posCopy[3] .. "_" .. i ), posCopy[4] or false
				}
			end
		end

		for id,section in pairs( component.Sections ) do -- for each section ["lightbar"] = { { 1, B } } *SECTION
			id = tostring( id .. "_" .. i )
			EMVU.Sections[ name ][ id ] = {}
			for index = 1, #section do -- { { 1, B } } *FRAME
				EMVU.Sections[ name ][ id ][ index ] = {}
				local values = section[ index ]
				for light, lightData in pairs( values ) do -- { 1, B } *LIGHT
					if not istable( lightData ) then print( "[Photon] Auto-component failed to initialize because of an invalid variable type: " .. tostring( lightData ) .. ". Make sure the Sections table has correctly nested tables." ) return end
					local lightColor = lightData[2]
					if istable(component.DefaultColors) and (#component.DefaultColors > 0) and string.StartWith( lightColor, "_" ) then
						local colorIndex = string.sub( lightColor, 2 )
						if autoData["Color" .. tostring( colorIndex )] then
							lightColor = autoData["Color" .. tostring( colorIndex )]
						else
							lightColor = component.DefaultColors[tonumber(colorIndex)] or "WHITE"
						end
					end
					local additionalParams = lightData[3]
					EMVU.Sections[ name ][ id ][ index ][ light ] = { lightData[1] + offset, lightColor, additionalParams }
				end
			end
		end

		if istable(component.Modes.Illumination) then
			for mode, modeData in pairs(component.Modes.Illumination) do
				for light, lightData in ipairs(modeData) do
					if istable(lightData) and lightData[2] then
						local color = lightData[2]
						if color:StartWith("_") then
							local idx = tonumber(color:sub(2))
							lightData[2] = autoData["Color" .. idx] or
								(component.DefaultColors and component.DefaultColors[light]) or
								"WHITE"
						end
					end

					component.Modes.Illumination[mode][light] = lightData
				end
			end
		end

		for id,pattern in pairs( component.Patterns ) do -- add pattern data
			EMVU.Patterns[ name ][ tostring( id .. "_" .. i )] = pattern
		end

		if istable( EMVU.Sequences[ name ]["Traffic"] ) and istable( component.TrafficDisconnect ) then
			for _,sequence in pairs( EMVU.Sequences[ name ]["Traffic"] ) do

				if usesPresets and istable( sequence.Preset_Components ) then
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
										-- if istable( lightInfo ) then PrintTable( lightInfo ) end
										if lightInfo[1] and isnumber( tonumber( lightInfo[1] ) ) then
											sequence.Selection_Components[_i][__i][ #sequence.Selection_Components[_i][__i] + 1 ] = {
												tonumber( lightInfo[1] ) + offset, lightInfo[2]
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

	table.Empty( positionTable )
end

hook.Add("InitPostEntity", "EMVU.LoadVehicles", function()
	EMVU:ProcessExpressVehicles()
	EMVU:LoadVehicles()
	EMVU.Configurations.LoadConfigurations()
end)