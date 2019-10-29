f not EMVU then return end

local siren = {
	Name = "RDS 17",
	Category = "D&R",
	Set = {
		{
			Name = "INTER-CLEAR",
			Sound = "emv/sirens/canada/D&R_RDS_17_Inter-Clear.wav ",
			Icon = "inter-clear"
		},
		{
			Name = "WAIL",
			Sound = "emv/sirens/canada/D&R RDS 17 Wail.wav ",
			Icon = "wail"
		},
		{
			Name = "YELP",
			Sound = "emv/sirens/canada/D&R RDS 17 Yelp.wav",
			Icon = "yelp"
		},
                {
			Name = "STINGER",
			Sound = "emv/sirens/canada/D&R RDS 17 Stinger.wav",
			Icon = "stinger"
		},
	},
	Horn = "emv/sirens/canada/D&R RDS 17 Airhorn.wav" -- uses the same bullhorn
}
EMVU.AddCustomSiren("ancf_d&r_rds_17", siren) 
