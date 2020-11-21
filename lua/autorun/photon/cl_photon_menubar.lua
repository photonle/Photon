AddCSLuaFile()

if SERVER then return end

hook.Add("PopulateMenuBar", "PhotonOptions_MenuBar", function(menubar)
	local m = menubar:AddOrGetMenu("Photon")

	m:AddCVar("Express Editing Mode", "photon_express_edit", "1", "0")
	m:AddOption("Toggle Debug Mode", function() RunConsoleCommand("photon_debug") end)

	local dTarget = m:AddSubMenu("Set Debug Target")
	dTarget:SetDeleteSelf(false)

	dTarget:AddOption("Regular Lighting", function() RunConsoleCommand("photon_debugtarget", "REG") end)
	dTarget:AddOption("Emergency Lighting", function() RunConsoleCommand("photon_debugtarget", "ELS") end)
end )