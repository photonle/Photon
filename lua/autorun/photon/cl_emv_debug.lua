
concommand.Add("photon_pv_mult", function(ply, cmd, args)
	if args[1] and isnumber(args[1]) then EMV_PIXVIS_MULTIPLIER = args[1] end
end)

concommand.Add( "photon_selectiondata", function( ply ) 
	local veh = ply:GetVehicle()
	if not IsValid( veh ) then return end
	-- PrintTable( veh:Photon_ExportSelections() )
	PrintTable( veh:Photon_ExportConfiguration( true, true, true, true, true ) )
end )