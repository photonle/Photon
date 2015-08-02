AddCSLuaFile()

if ( SERVER ) then return end



hook.Add( "PopulateMenuBar", "PhotonOptions_MenuBar", function( menubar ) 

	local m = menubar:AddOrGetMenu( "Photon" )

	m:AddCVar( "Toggle Debug Mode", "photon_debug" )

	local dTarget = m:AddSubMenu( "Set Debug Target" )

	dTarget:SetDeleteSelf( false )

	dTarget:AddCVar( "Regular Lighting", "photon_debugtarget", "REG" )
	dTarget:AddCVar( "Emergency Lighting", "photon_debugtarget", "ELS" )

end )