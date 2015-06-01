AddCSLuaFile()

function Photon:RecoverVehicleTable( ent )
	if not IsValid( ent ) then return false end
	local model = tostring(ent:GetModel())
	local PhotonIndex = Photon.DefaultMapping[model]
	if PhotonIndex then return list.Get("Vehicles")[PhotonIndex] end
	for key,car in pairs( list.Get("Vehicles") ) do
		if string.lower(car.Model) == string.lower(model) then
			return list.Get("Vehicles")[key]
		end
	end
	return false
end

function Photon:SpawnedVehicle( ent )
	if not IsValid( ent ) then return end
	if not istable( ent.VehicleTable ) then return end
	local name = ent.VehicleTable.Name
	ent.Name = name
	if ent.VehicleTable.Photon then
		Photon:SetupCar( ent, name )
	end
end

function Photon:EntityCreated( ent )
	if IsValid( ent ) and ent:IsVehicle() then
		local timerId = ent:EntIndex() .. "-PHOTON-" .. CurTime()
		timer.Create( timerId, .01, 200, function()
			if ent.VehicleTable and istable(ent.VehicleTable) then
				Photon:SpawnedVehicle( ent )
				EMVU:SpawnedVehicle( ent )
				timer.Destroy( timerId )
				timer.Stop( timerId )
			end
			if timer.RepsLeft( timerId ) == 0 and SERVER then
				local default = Photon:RecoverVehicleTable( ent )
				if default then 
					ent.VehicleTable = default
					Photon:SpawnedVehicle( ent )
					EMVU:SpawnedVehicle( ent )
					print("[Photon] No .VehicleTable present, assuming " .. tostring(ent:GetModel()) .. " is a(n) " .. tostring(default.Name) .. ".")
				end
			end
		end)
	end
end

hook.Add("OnEntityCreated", "Photon.EntityCreated", function(e)
	Photon:EntityCreated( e )
end)

function Photon:CheckForPhoton( model )
	if Photon.VehicleIndex[model] then return Photon.VehicleIndex[model] else return false end
end

function Photon:LoadVehicles()
	local cars = list.Get( "Vehicles" )
	local found = false
	for key,car in pairs(cars) do
		if car.HasPhoton and car.Photon then
			found = true
			Photon:PreloadVehicle( car )
		elseif Photon:CheckForPhoton( car.Model ) then
			found = true
			car.HasPhoton = true
			car.Photon = Photon:CheckForPhoton( car.Model )
			list.Set( "Vehicles", key, car )
			Photon:PreloadVehicle( list.Get( "Vehicles" )[key] )
		end
	end
	if not found then
		if CLIENT then
			chat.AddText( Color(255, 128, 0), "[Photon] Photon detected that you have no compatible vehicles installed. Check Workshop for addons with a [Photon] tag to get started.")
		else
			print("[Photon] No Photon vehicles were loaded. Did you forget to download some?")
		end
	end
end

hook.Add("Initialize", "Photon.LoadVehicles", function()
	timer.Simple(1, function() Photon:LoadVehicles() end)
end)

function Photon:PreloadVehicle( car )
	if isstring( car.Photon ) and istable( Photon.VehicleLibrary[car.Photon] ) then
		car.Photon = Photon.VehicleLibrary[car.Photon]
	elseif car.Photon and isstring( car.Photon ) then
		if not Photon.VehicleLibrary[car.Photon] then print( "[Photon] Failed to load " .. car.Photon .. " because the Photon parameter was not valid." ) end
	else
		--if SERVER then print( "[Photon]: " .. tostring(car) .. " has an invalid declaration for Photon. Car lighting will not render.") end
	end

	if car.Photon.Positions and istable( car.Photon.Positions ) then
		Photon.Vehicles.Positions[ car.Name ] = car.Photon.Positions
	elseif car.Photon.Positions and isstring( car.Photon.Positions ) then
		Photon.Vehicles.Positions[ car.Name ] = Photon.Vehicles.Positions[ car.Photon.Positions ]
	else
		Photon.Vehicles.Positions[ car.Name ] = {}
	end

	if car.Photon.Meta and istable( car.Photon.Meta ) then
		Photon.Vehicles.Meta[ car.Name ] = car.Photon.Meta
	elseif car.Photon.Meta and isstring( car.Photon.Meta ) then
		Photon.Vehicles.Meta[ car.Name ] = Photon.Vehicles.Meta[ car.Photon.Meta ]
	else
		Photon.Vehicles.Meta[ car.Name ] = {}
	end

	if car.Photon.States.Headlights and istable( car.Photon.States.Headlights ) then
		Photon.Vehicles.States.Headlights[ car.Name ] = car.Photon.States.Headlights
	elseif car.Photon.States.Headlights and isstring( car.Photon.States.Headlights ) then
		Photon.Vehicles.States.Headlights[ car.Name ] = Photon.Vehicles.States.Headlights[ car.Photon.States.Headlights ]
	else 
		Photon.Vehicles.States.Headlights[ car.Name ] = {}
	end

	if car.Photon.States.Brakes and istable( car.Photon.States.Brakes ) then
		Photon.Vehicles.States.Brakes[ car.Name ] = car.Photon.States.Brakes
	elseif car.Photon.States.Brakes and isstring( car.Photon.States.Brakes ) then
		Photon.Vehicles.States.Brakes[ car.Name ] = Photon.Vehicles.States.Brakes[ car.Photon.States.Brakes ]
	else
		Photon.Vehicles.States.Brakes[ car.Name ] = {}
	end

	if car.Photon.States.Blink_Left and istable( car.Photon.States.Blink_Left ) then
		Photon.Vehicles.States.Blink_Left[ car.Name ] = car.Photon.States.Blink_Left
	elseif car.Photon.States.Blink_Left and isstring( car.Photon.States.Blink_Left ) then
		Photon.Vehicles.States.Blink_Left[ car.Name ] = Photon.Vehicles.States.Blink_Left[ car.Photon.States.Blink_Left ]
	else
		Photon.Vehicles.States.Blink_Left[ car.Name ] = {}
	end

	if car.Photon.States.Blink_Right and istable( car.Photon.States.Blink_Right ) then
		Photon.Vehicles.States.Blink_Right[ car.Name ] = car.Photon.States.Blink_Right
	elseif car.Photon.States.Blink_Right and isstring( car.Photon.States.Blink_Right ) then
		Photon.Vehicles.States.Blink_Right[ car.Name ] = Photon.Vehicles.States.Blink_Right[ car.Photon.States.Blink_Right ]
	else
		Photon.Vehicles.States.Blink_Right[ car.Name ] = {}
	end

	if car.Photon.States.Reverse and istable( car.Photon.States.Reverse ) then
		Photon.Vehicles.States.Reverse[ car.Name ] = car.Photon.States.Reverse
	elseif car.Photon.States.Reverse and isstring( car.Photon.States.Reverse ) then
		Photon.Vehicles.States.Reverse[ car.Name ] = Photon.Vehicles.States.Reverse[ car.Photon.States.Reverse ]
	else
		Photon.Vehicles.States.Reverse[ car.Name ] = {}
	end

	if car.Photon.States.Running and istable( car.Photon.States.Running ) then
		Photon.Vehicles.States.Running[ car.Name ] = car.Photon.States.Running
	elseif car.Photon.States.Running and isstring( car.Photon.States.Running ) then
		Photon.Vehicles.States.Running[ car.Name ] = Photon.Vehicles.States.Running[ car.Photon.States.Running ]
	else
		Photon.Vehicles.States.Running[ car.Name ] = {}
	end

	if car.Photon.Config and istable( car.Photon.Config ) then
		Photon.Vehicles.Config[ car.Name ] = car.Photon.Config
	elseif car.Photon.Config and isstring( car.Photon.Config ) then
		Photon.Vehicles.Config[ car.Name ] = Photon.Vehicles.Config[ car.Photon.Config ]
	else
		Photon.Vehicles.Config[ car.Name ] = {}
	end

end

function Photon:OverwriteIndex( name, data )
	if not data then return end
	if data.Positions != nil then Photon.Vehicles.Positions[name] = data.Positions end
	if data.Meta != nil then Photon.Vehicles.Meta[name] = data.Meta end
	if data.States.Headlights != nil then Photon.Vehicles.States.Headlights[name] = data.States.Headlights end
	if data.States.Brakes != nil then Photon.Vehicles.States.Brakes[name] = data.States.Brakes end
	if data.States.Blink_Left != nil then Photon.Vehicles.States.Blink_Left[name] = data.States.Blink_Left end
	if data.States.Blink_Right != nil then Photon.Vehicles.States.Blink_Right[name] = data.States.Blink_Right end
	if data.States.Reverse != nil then Photon.Vehicles.States.Reverse[name] = data.States.Reverse end
	if data.States.Running != nil then Photon.Vehicles.States.Running[name] = data.States.Running end
	if data.Config != nil then Photon.Vehicles.Config[name] = data.Config end
end