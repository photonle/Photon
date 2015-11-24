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
			local isSelected = ( tostring( k ) == tostring( ent:Photon_SirenSet() ) )
			local category = v.Category or "Other"
			local option = categories[ category ]:AddOption( v.Name, function() EMVU.Net:SirenSet( k ) end )
			if isSelected then
				option:SetChecked( true )
			end
		end

	end

})

properties.Add( "photon_liveries", {
	MenuLabel = "Vehicle Livery",
	Order = 3,
	MenuIcon = "photon/ui/menu-livery.png",

	Filter = function( self, ent, ply )
		if not IsValid( ent ) then return false end
		if not ent:Photon() then return false end
		if not ent:IsEMV() then return false end
		if not ent.VehicleName then return false end
		if not ply:InVehicle() then return false end
		if not ply:GetVehicle() == ent then return false end
		local liveries = EMVU.Liveries[ ent.VehicleName ]
		if not liveries then return false end
		return true
	end,

	MenuOpen = function( self, option, ent )
		local liveries = EMVU.Liveries[ ent.VehicleName ]
		local submenu = option:AddSubMenu()

		for key,data in SortedPairs( liveries ) do
			local category = submenu
			if (#liveries > 1) then category = submenu:AddSubMenu( key ) end
			for name,mat in SortedPairs( data ) do
				category:AddOption( name, function() EMVU.Net:Livery( key, name ) end )
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
		if not ent:Photon_PresetEnabled() then return false end
		if not ply:InVehicle() then return false end
		if not ply:GetVehicle() == ent then return false end
		local options = EMVU.PresetIndex[ ent.VehicleName ]
		if not options or not istable( options ) or #options <= 1 then return false end
		return true
	end,

	MenuOpen = function( self, option, ent )
		local options = EMVU.PresetIndex[ ent.VehicleName ]
		local submenu = option:AddSubMenu()
		for k,v in ipairs( options ) do
			local isSelected = ( tostring( k ) == tostring( ent:Photon_ELPresetOption() ) )
			local option = submenu:AddOption( v.Name, function() EMVU.Net:Preset( k ) end )
			if isSelected then
				option:SetChecked( true )
			end
		end
	end

})

properties.Add( "photon_selection", {
	MenuLabel = "Equipment",
	Order = 1,
	MenuIcon = "photon/ui/menu-lights.png",

	Filter = function( self, ent, ply )
		if not IsValid( ent ) then return false end
		if not ent:Photon() then return false end
		if not ent:IsEMV() then return false end
		if not ent:Photon_SelectionEnabled() then return false end
		return true
	end,

	MenuOpen = function( self, option, ent )
		local options = EMVU.Selections[ ent.VehicleName ]
		local submenu = option:AddSubMenu()
		for catIndex,cat in ipairs( options ) do
			if #cat.Options == 2 and ( cat.Options[1].Name == "None" or cat.Options[2].Name == "None" ) then
				local selected = ent:Photon_SelectionOption( catIndex )
				local isActive = ( cat.Options[selected].Name != "None" )
				local addedOption
				if selected == 1 then
					addedOption = submenu:AddOption( cat.Name, function() EMVU.Net.Selection( ent, catIndex, 2 ) end )
				else
					addedOption = submenu:AddOption( cat.Name, function() EMVU.Net.Selection( ent, catIndex, 1 ) end )
				end
				addedOption:SetChecked( isActive )
			else
				local category = submenu:AddSubMenu( cat.Name )
				local subCategories = {}
				for index,option in pairs( cat.Options ) do
					local opt
					if option.Category then
						if not subCategories[ option.Category ] then subCategories[ option.Category ] = category:AddSubMenu( option.Category ) end
						opt = subCategories[ option.Category ]:AddOption( option.Name, function () EMVU.Net.Selection( ent, catIndex, index ) end )
					else
						opt = category:AddOption( option.Name, function () EMVU.Net.Selection( ent, catIndex, index ) end )
					end
					if ent:Photon_SelectionOption( catIndex ) == index then
						opt:SetChecked( true )
					end
				end
			end
			-- local isSelected = ( tostring( k ) == tostring( ent:Photon_ELPresetOption() ) )
			-- local option = submenu:AddOption( v.Name, function() EMVU.Net:Preset( k ) end )
			-- if isSelected then
			-- 	option:SetChecked( true )
			-- end
		end
	end

})