AddCSLuaFile()

if Photon then Photon.Client_Settings = {} end

Photon.DefaultKeys = {
	Primary_Toggle = KEY_F,
	Primary_Alt = KEY_LALT,
	Siren_Toggle = KEY_R,
	Siren_Alt = MOUSE_RIGHT,
	Aux = KEY_B,
	Blackout = KEY_H,
	Horn = KEY_G,
	Manual = KEY_T,
	Illum = KEY_X,
	Radar = KEY_O,
}

concommand.Add( "photon_keys_reset", function() 
	RunConsoleCommand( "photon_key_primary_toggle", Photon.DefaultKeys.Primary_Toggle )
	RunConsoleCommand( "photon_key_primary_alt", Photon.DefaultKeys.Primary_Alt )
	RunConsoleCommand( "photon_key_siren_toggle", Photon.DefaultKeys.Siren_Toggle )
	RunConsoleCommand( "photon_key_siren_alt", Photon.DefaultKeys.Siren_Alt )
	RunConsoleCommand( "photon_key_auxiliary", Photon.DefaultKeys.Aux )
	RunConsoleCommand( "photon_key_blackout", Photon.DefaultKeys.Blackout )
	RunConsoleCommand( "photon_key_horn", Photon.DefaultKeys.Horn )
	RunConsoleCommand( "photon_key_manual", Photon.DefaultKeys.Manual )
	RunConsoleCommand( "photon_key_illum", Photon.DefaultKeys.Illum )
	RunConsoleCommand( "photon_key_radar", Photon.DefaultKeys.Radar )
end )

CreateClientConVar( "photon_key_primary_toggle", Photon.DefaultKeys.Primary_Toggle, true )
CreateClientConVar( "photon_key_primary_alt", Photon.DefaultKeys.Primary_Alt, true )
CreateClientConVar( "photon_key_siren_toggle", Photon.DefaultKeys.Siren_Toggle, true )
CreateClientConVar( "photon_key_siren_alt", Photon.DefaultKeys.Siren_Alt, true )
CreateClientConVar( "photon_key_auxiliary", Photon.DefaultKeys.Aux, true )
CreateClientConVar( "photon_key_blackout", Photon.DefaultKeys.Blackout, true )
CreateClientConVar( "photon_key_horn", Photon.DefaultKeys.Horn, true )
CreateClientConVar( "photon_key_manual", Photon.DefaultKeys.Manual, true )
CreateClientConVar( "photon_key_illum", Photon.DefaultKeys.Illum, true )
CreateClientConVar( "photon_key_radar", Photon.DefaultKeys.Radar, true )

CreateClientConVar( "photon_emerg_unit", "", true )
CreateClientConVar( "photon_emerg_enabled", "1", true )
CreateClientConVar( "photon_stand_enabled", "1", true )
CreateClientConVar( "photon_hud_opacity", "1", true )
CreateClientConVar( "photon_lens_effects", "1", true )
CreateClientConVar( "photon_bloom_modifier", 1, true )
CreateClientConVar( "photon_dynamic_lights", "0", true )

CreateClientConVar( "photon_christmas_mode", "0", true )
CreateClientConVar( "photon_christmas_mode_auto", "1", true )

CreateClientConVar( "photon_comp_editor_scale", "1", true )
CreateClientConVar( "photon_express_edit", 0, false)
// CreateClientConVar( "photon_debug", "0", false )

cvars.AddChangeCallback("photon_express_edit",function (name, old, val) PHOTON_EXPRESS = val end)