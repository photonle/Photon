	EMVU.AddCustomSiren("TMD2", {
	Name = "Touchmaster Delta 2", -- The name that shows on the HUD.
	Category = "Other", -- The category the siren shows up under.
	Set = {
			{Name = "WAIL", Sound = "emv/sirens/p_fs_touchmaster_delta/pemv_tmwail.wav", Icon="wail"},
			{Name = "YELP", Sound = "emv/sirens/p_fs_touchmaster_delta/pemv_tmyelp.wav", Icon="yelp"},
			{Name = "PHSR", Sound = "emv/sirens/p_fs_touchmaster_delta/pemv_tmjingle.wav", Icon="phaser"},
	},
	Horn = "emv/sirens/p_fs_touchmaster_delta/pemv_tmhorn.wav",
	Manual = "emv/sirens/p_fs_touchmaster_delta/pemv_tmmanual.wav",
})