if not EMVU then return end

EMVU.AddCustomSiren("ancf_d&r_rds_17", {
	Name = "RDS 17",
	Category = "D&R",
	Set = {
		{
			Name = "INTER-CLEAR",
			Sound = "emv/sirens/d&r/rds-17/inter-clear.wav ",
			Icon = "wail"
		}, {
			Name = "WAIL",
			Sound = "emv/sirens/d&r/rds-17/wail.wav.wav ",
			Icon = "wail"
		}, {
			Name = "YELP",
			Sound = "emv/sirens/d&r/rds-17/yelp.wav",
			Icon = "yelp"
		}, {
			Name = "STINGER",
			Sound = "emv/sirens/d&r/rds-17/stinger.wav",
			Icon = "stinger"
		}
	},
	Horn = "emv/sirens/d&r/rds-17/airhorn.wav"
})
