if not EMVU then return end

local siren = {
	Name = "Woodway Whelen Cencom",
	Category = "Woodway Eng.",
	Set = {
		{
			Name = "WAIL",
			Sound = "emv/sirens/woodway whelen cencom/wail.wav",
			Icon = "wail"
		},
		{
			Name = "YELP",
			Sound = "emv/sirens/woodway whelen cencom/yelp.wav",
			Icon = "yelp"
		},
		{
			Name = "PHASER",
			Sound = "emv/sirens/woodway whelen cencom/priority.wav",
			Icon = "phaser"
		},
	},
	Horn = "emv/sirens/premier hazard 7004/bullhorn.wav" -- uses the same bullhorn
}
EMVU.AddCustomSiren("sm_woodway_whelen_cencom", siren)