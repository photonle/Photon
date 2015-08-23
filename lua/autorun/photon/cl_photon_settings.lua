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
	Illum = KEY_X
}

CreateClientConVar( "photon_key_primary_toggle", Photon.DefaultKeys.Primary_Toggle, true )
CreateClientConVar( "photon_key_primary_alt", Photon.DefaultKeys.Primary_Alt, true )
CreateClientConVar( "photon_key_siren_toggle", Photon.DefaultKeys.Siren_Toggle, true )
CreateClientConVar( "photon_key_siren_alt", Photon.DefaultKeys.Siren_Alt, true )
CreateClientConVar( "photon_key_auxiliary", Photon.DefaultKeys.Aux, true )
CreateClientConVar( "photon_key_blackout", Photon.DefaultKeys.Blackout, true )
CreateClientConVar( "photon_key_horn", Photon.DefaultKeys.Horn, true )
CreateClientConVar( "photon_key_manual", Photon.DefaultKeys.Manual, true )
CreateClientConVar( "photon_key_illum", Photon.DefaultKeys.Illum, true )

CreateClientConVar( "photon_emerg_unit", "", true )
CreateClientConVar( "photon_emerg_enabled", "1", true )
CreateClientConVar( "photon_stand_enabled", "1", true )
CreateClientConVar( "photon_hud_opacity", "1", true )
CreateClientConVar( "photon_lens_effects", "1", true )
// CreateClientConVar( "photon_debug", "0", false )