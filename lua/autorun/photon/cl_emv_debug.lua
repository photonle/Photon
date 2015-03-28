
concommand.Add("photon_pv_mult", function(ply, cmd, args)
	if args[1] and isnumber(args[1]) then EMV_PIXVIS_MULTIPLIER = args[1] end
end)