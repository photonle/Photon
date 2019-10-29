f not EMVU then return end

local siren = {
	Name = "RDS 17",
	Category = "D&R",
	Set = {
		{
			Name = "INTER-CLEAR",
			Sound = "sound/emv/sirens/canada/D&R_RDS_17_Inter-Clear.wav ",
			Icon = "inter-clear"
		},
		{
			Name = "WAIL",
			Sound = "sound/emv/sirens/canada/D&R RDS 17 Wail.wav ",
		},
		{
			Name = "YELP",
			Sound = "sound/emv/sirens/canada/D&R RDS 17 Yelp.wav",
			Icon = "yelp"
		},
                {
			Name = "STINGER",
			Sound = "sound/emv/sirens/canada/D&R RDS 17 Stinger.wav",
			Icon = "stinger"
		},
	},
	Horn = "sound/emv/sirens/canada/D&R RDS 17 Airhorn.wav" -- uses the same bullhorn
}
EMVU.AddCustomSiren("ancf_d&r_rds_17", siren) 