if not EMVU then return end

local siren = {
	Name = "Sverige (SE) New",
	Category = "European",
	Set = {
		{
			Name = "HI-LO",
			Sound = "emv/sirens/standby sweden/emv_hilo.wav",
			Icon = "hilo"
		},
		{
			Name = "YELP",
			Sound = "emv/sirens/standby sweden/emv_yelp.wav",
			Icon = "yelp"
		},
	},
}
EMVU.AddCustomSiren("standby_sweden", siren)
