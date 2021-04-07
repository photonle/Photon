---Made by: anemolis72
if not EMVU then return end

EMVU.AddCustomSiren("chp_bike", {
	Name = "Cal. Highway Patrol Bike Siren",
	Category = "Other",
	Set = {
			{ Name = "WAIL", Sound = "emv/sirens/chp bike/emv_wail.wav", Icon = "wail" },
			{ Name = "YELP", Sound = "emv/sirens/chp bike/emv_yelp.wav", Icon = "yelp" },
	},
	Horn = "emv/sirens/chp bike/emv_horn.wav",
	Volume = 100
})