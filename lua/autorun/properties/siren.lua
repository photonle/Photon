AddCSLuaFile()

properties.Add( "photon_siren", {
	MenuLabel = "Siren Model",
	Order = 1,
	MenuIcon = "photon/ui/menu-siren.png",

	Filter = function( self, ent, ply )
		if not IsValid( ent ) then return false end
		if not ent:Photon() then return false end
		if not ent:IsEMV() then return false end
		if not ply:InVehicle() then return false end
		if not ply:GetVehicle() == ent then return false end
		return true
	end,

	MenuOpen = function( self, option, ent, tr )
		local options = EMVU.Sirens
		local submenu = option:AddSubMenu()
		for k,v in ipairs( options ) do
			local isSelected = ( tostring( k ) == tostring( ent:SirenSet() ) )
			local option = submenu:AddOption( v.Name, function() EMVU.Net:SirenSet( k ) end )
			if isSelected then
				option:SetChecked( true )
			end
		end

	end

} )