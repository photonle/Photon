AddCSLuaFile()

hook.Add( "AddToolMenuCategories", "Photon.AddMenuCategory", function()
	spawnmenu.AddToolCategory( "Utilities", "Photon", "Photon" )
end)

local function logoHeader( panel )
	panel:AddControl( "Header", { Description = ( string.format( "Photon Lighting Engine | %s | Update #%s", tostring( PHOTON_SERIES ), tostring( PHOTON_UPDATE ) ) ) } )
	local parent = vgui.Create( "DPanel" )
	parent:SetSize( 300, 256 )
	parent:SetBackgroundColor( Color( 0, 0, 0, 0 ) )
	local header = vgui.Create( "DImage", parent )
	header:SetImage( "photon/ui/settings_logo.png" )
	header:SetSize( 256, 256 )
	panel:AddPanel( parent )
	header:Center()
end

local function buildControlsMenu( panel )
	panel:ClearControls()
	logoHeader( panel )
	panel:AddControl( "Header", { Description = "Adjust the keys for Photon controls" } )

	panel:AddControl( "Numpad", { Label = "Primary Lights On/Off", Command="photon_key_primary_toggle", Label2 = "Primary Lights Mode", Command2="photon_key_primary_alt" } )
	panel:AddControl( "Numpad", { Label = "Siren On/Off", Command="photon_key_siren_toggle", Label2 = "Siren Tone", Command2="photon_key_siren_alt" } )
	panel:AddControl( "Numpad", { Label = "Auxiliary Lights", Command="photon_key_auxiliary", Label2 = "Illumination", Command2="photon_key_illum" } )
	panel:AddControl( "Numpad", { Label = "Horn", Command="photon_key_horn", Label2 = "Siren Manual", Command2="photon_key_manual" } )
	panel:AddControl( "Numpad", { Label = "Blackout Mode", Command="photon_key_blackout" } )
end

local function buildClientSettings( panel )
	panel:ClearControls()
	logoHeader( panel )
	panel:AddControl( "Header", { Description = "Adjust your local Photon settings" } )

	panel:AddControl( "CheckBox", { Label = "Enable Emergency Lighting", Command = "photon_emerg_enabled" } )
	panel:AddControl( "CheckBox", { Label = "Enable Standard Lighting", Command = "photon_stand_enabled" } )
	panel:AddControl( "CheckBox", { Label = "Enable Lens Flare Effects", Command = "photon_lens_effects" } )
	panel:AddControl( "Header", { Description = "Change HUD settings" } )
	panel:AddControl( "Slider", { Label = "Opacity", Command = "photon_hud_opacity", Type = "Float", Min = "0", Max = "1" } )

	panel:AddControl( "Header", { Description = "Personal Options" } )
	panel:AddControl( "TextBox", { Label = "Unit ID", Command = "photon_emerg_unit", WaitForEnter = "1", MaxLength = "3" })
end

local function buildServerSettings( panel )
	panel:ClearControls()
	logoHeader( panel )
	panel:AddControl( "Header", { Description = "Adjust server Photon settings" } )

	panel:AddControl( "CheckBox", { Label = "Enable Changing Siren Model", Command = "photon_emv_changesirens" } )
	panel:AddControl( "CheckBox", { Label = "Enable Changing Lighting Presets", Command = "photon_emv_changepresets" } )
	// panel:AddControl( "CheckBox", { Label = "Enable Rendering Illumination Light", Command = "photon_emv_useillum" } )
end

hook.Add( "PopulateToolMenu", "Photon.AddSettingsMenu", function() 
	spawnmenu.AddToolMenuOption( "Utilities", "Photon", "photon_settings_controls", "Controls", "", "", buildControlsMenu )
	spawnmenu.AddToolMenuOption( "Utilities", "Photon", "photon_settings_client", "Client", "", "", buildClientSettings )
	spawnmenu.AddToolMenuOption( "Utilities", "Photon", "photon_settings_server", "Settings", "", "", buildServerSettings )
end )

