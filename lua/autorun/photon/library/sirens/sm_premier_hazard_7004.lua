if not EMVU then return end

local siren = {
	Name = "7004",
	Category = "Premier Hazard",
	Set = {
		{
			Name = "WAIL",
			Sound = "emv/sirens/premier hazard 7004/wail.wav",
			Icon = "wail"
		},
		{
			Name = "YELP",
			Sound = "emv/sirens/premier hazard 7004/yelp.wav",
			Icon = "yelp"
		},
		{
			Name = "PHASER",
			Sound = "emv/sirens/premier hazard 7004/priority.wav",
			Icon = "phaser"
		},
		{
			Name = "HI-LO",
			Sound = "emv/sirens/premier hazard 7004/hilo.wav",
			Icon = "hilo"
		},
	},
	Horn = "emv/sirens/premier hazard 7004/bullhorn.wav"
}
EMVU.AddCustomSiren("sm_premier_hazard_7004", siren)