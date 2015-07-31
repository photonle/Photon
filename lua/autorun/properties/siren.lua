AddCSLuaFile()

properties.Add( "photon_siren", {
	MenuLabel = "Siren Model",
	Order = 2,
	MenuIcon = "photon/ui/menu-siren.png",

	Filter = function( self, ent, ply )
		if not IsValid( ent ) then return false end
		if not ent:Photon() then return false end
		if not ent:IsEMV() then return false end
		if not ply:InVehicle() then return false end
		if not ply:GetVehicle() == ent then return false end
		return true
	end,

	MenuOpen = function( self, option, ent )
		
		local options = EMVU.Sirens
		local submenu = option:AddSubMenu()

		local categories = {}
		categories["Other"] = true
		for k,v in pairs( options ) do
			if v.Category then
				categories[ v.Category ] = true
			end
		end

		for k,v in SortedPairs( categories ) do
			categories[k] = submenu:AddSubMenu( k )
		end

		for k,v in ipairs( options ) do
			local isSelected = ( tostring( k ) == tostring( ent:SirenSet() ) )
			local category = v.Category or "Other"
			local option = categories[ category ]:AddOption( v.Name, function() EMVU.Net:SirenSet( k ) end )
			if isSelected then
				option:SetChecked( true )
			end
		end

	end

})

properties.Add( "photon_preset", {
	MenuLabel = "Emergency Lights",
	Order = 1,
	MenuIcon = "photon/ui/menu-lights.png",

	Filter = function( self, ent, ply )
		if not IsValid( ent ) then return false end
		if not ent:Photon() then return false end
		if not ent:IsEMV() then return false end
		if not ent:PresetEnabled() then return false end
		if not ply:InVehicle() then return false end
		if not ply:GetVehicle() == ent then return false end
		return true
	end,

	MenuOpen = function( self, option, ent )
		local options = EMVU.PresetIndex[ ent.VehicleName ]
		local submenu = option:AddSubMenu()
		for k,v in ipairs( options ) do
			local isSelected = ( tostring( k ) == tostring( ent:ELPresetOption() ) )
			local option = submenu:AddOption( v.Name, function() EMVU.Net:Preset( k ) end )
			if isSelected then
				option:SetChecked( true )
			end
		end
	end

})