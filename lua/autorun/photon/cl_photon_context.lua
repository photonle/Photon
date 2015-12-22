AddCSLuaFile()

local function null() end

properties.Add( "photon_siren", {
	MenuLabel = "Siren Model",
	Order = 2,
	MenuIcon = "photon/ui/menu-siren.png",

	Filter = function( self, ent, ply )
		if not IsValid( ent ) then return false end
		if not ent:IsVehicle() then return false end
		if not ent:Photon() then return false end
		if not ent:IsEMV() then return false end
		return true
	end,

	MenuOpen = function( self, option, ent )
		
		local options = EMVU.Sirens
		local submenu = option:AddSubMenu()

		local showSecondary = true

		local primarySubmenu = submenu:AddSubMenu( "Primary", null )
		local secondarySubmenu
		if showSecondary then secondarySubmenu = submenu:AddSubMenu( "Secondary", null ) end

		local categories = {}
		categories["Other"] = true
		for k,v in pairs( options ) do
			if v.Category then
				categories[ v.Category ] = true
			end
		end

		for k,v in SortedPairs( categories ) do
			if showSecondary then
				categories[k] = { primarySubmenu:AddSubMenu( k, null ), secondarySubmenu:AddSubMenu( k, null ) }
			else
				categories[k] = { primarySubmenu:AddSubMenu( k, null ) }
			end
		end

		for k,v in ipairs( options ) do
			local isSelected = ( tostring( k ) == tostring( ent:Photon_SirenSet() ) )
			local category = v.Category or "Other"
			local option = categories[ category ][1]:AddOption( v.Name, function() EMVU.Net:SirenSet( k, ent, false ) end )
			if isSelected then
				option:SetChecked( true )
			end
			if showSecondary and not isSelected then
				local secondarySelected = ( tostring( k ) == tostring( ent:Photon_AuxSirenSet() ) )
				option = categories[ category ][2]:AddOption( v.Name, function() EMVU.Net:SirenSet( k, ent, true ) end )
				if secondarySelected then
					option:SetChecked( true )
				end
			end
		end

		secondarySubmenu:AddOption( "None", function() EMVU.Net:SirenSet( 0, ent, true ) end )

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
			if (#liveries > 1) then category = submenu:AddSubMenu( key, null ) end
			for name,mat in SortedPairs( data ) do
				category:AddOption( name, function() EMVU.Net:Livery( key, name ) end )
			end
		end

	end
})

properties.Add( "photon_autoskin", {
	MenuLabel = "Vehicle Liveries",
	Order = 3,
	MenuIcon = "photon/ui/menu-livery.png",

	Filter = function( self, ent, ply )
		if not IsValid( ent ) then return false end
		if not ent:Photon() then return false end
		if not ent:IsEMV() then return false end
		if not ent.VehicleName then return false end
		local mdl = ent:GetModel()
		local mdlId = Photon.AutoSkins.TranslationTable[ mdl ]
		if not mdlId then return false end
		if not istable( Photon.AutoSkins.Available[ mdlId ] ) then return false end
		return true
	end,

	MenuOpen = function( self, option, ent )
		local mdl = ent:GetModel()
		local mdlId = Photon.AutoSkins.TranslationTable[ mdl ]
		local skinTable = Photon.AutoSkins.Available[ mdlId ]

		local submenu = option:AddSubMenu()

		for category,subSkins in pairs( skinTable ) do
			if category != "/" then
				local categoryMenu = submenu:AddSubMenu( category, null )
				for _,skinInfo in pairs( subSkins ) do
					categoryMenu:AddOption( skinInfo.Name, function() EMVU.Net.ApplyAutoSkin( ent, skinInfo.Texture ) end )
				end
			end
		end

		if istable( skinTable["/"] ) then
			for _,skinInfo in pairs( skinTable["/"] ) do
				submenu:AddOption( skinInfo.Name, function() EMVU.Net.ApplyAutoSkin( ent, skinInfo.Texture ) end )
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
				local category = submenu:AddSubMenu( cat.Name, null )
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

properties.Add( "photon_configuration", {
	MenuLabel = "Configurations",
	Order = 4,
	MenuIcon = "photon/ui/menu-presets.png",

	Filter = function( self, ent, ply )
		if not IsValid( ent ) then return false end
		if not ent:Photon() then return false end
		if not ent:IsEMV() then return false end
		if not ent:Photon_SelectionEnabled() then return false end
		if not ent:Photon_SupportsConfigurations() then return false end
		if not ent:Photon_GetAvailableConfigurations() then return false end
		return true
	end,

	MenuOpen = function( self, option, ent )
		local options = ent:Photon_GetAvailableConfigurations() or {}
		local submenu  = option:AddSubMenu()
		local categories = {}
		for index, data in pairs( options ) do
			local sub = submenu
			if data.Category and ( not tobool( data.Category ) ==  false ) then
				local newCat = categories[ tostring( data.Category ) ]
				if not newCat then 
					categories[ tostring( data.Category ) ] = submenu:AddSubMenu( tostring( data.Category ), null )
					newCat = categories[ tostring( data.Category ) ]
				end
				sub = newCat
			end
			sub:AddOption( data.Name, function() ent:Photon_ApplyEquipmentConfiguration( index ) end )
		end
	end

})