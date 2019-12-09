AddCSLuaFile()

if Photon then Photon.Client_Settings = {} end

Photon.DefaultKeys = {
	Primary_Toggle = KEY_F, -- To pay respects.
	Primary_Alt = KEY_LALT,
	Siren_Toggle = KEY_R,
	Siren_Alt = MOUSE_RIGHT,
	Auxiliary = KEY_B,
	Blackout = KEY_H,
	Horn = KEY_G,
	Manual = KEY_T,
	Illum = KEY_X,
	Radar = KEY_O,
	Siren1 = KEY_1,
	Siren2 = KEY_2,
	Siren3 = KEY_3,
	Siren4 = KEY_4,
	Alt_Reverse = KEY_BACKSLASH
}

concommand.Add("photon_keys_reset", function()
	for name, key in pairs(Photon.DefaultKeys) do
		RunConsoleCommand("photon_key_" .. name:lower(), key)
	end
end)

for name, key in pairs(Photon.DefaultKeys) do
	CreateClientConVar("photon_key_" .. name:lower(), key, true)
end

CreateClientConVar("photon_emerg_unit", "", true)
CreateClientConVar("photon_emerg_enabled", "1", true)
CreateClientConVar("photon_stand_enabled", "1", true)
CreateClientConVar("photon_hud_opacity", "1", true)
CreateClientConVar("photon_lens_effects", "1", true)
CreateClientConVar("photon_bloom_modifier", 1, true)
CreateClientConVar("photon_dynamic_lights", "0", true)

CreateClientConVar("photon_christmas_mode", "0", true)
CreateClientConVar("photon_christmas_mode_auto", "1", true)

CreateClientConVar("photon_comp_editor_scale", "1", true)
CreateClientConVar("photon_express_edit", 0, false)

cvars.AddChangeCallback("photon_express_edit", function(name, old, new) PHOTON_EXPRESS = new end)