AddCSLuaFile()

-- This file contains all the sirens used.
-- Tables are numbered to avoid vehicles using the wrong siren set from being rearranged.

EMVU.Sirens = {
	
	[1] = {
		Name = "WHELEN ALPHA", -- (Name that's displayed on HUD) this a typical Whelen siren, extremely common on vehicles within the last 20 years
		Category = "Whelen",
		Set = { -- 
			{Name = "WAIL", Sound = "emv/sirens/whelen std/emv_wail.wav"},
			{Name = "YELP", Sound = "emv/sirens/whelen std/emv_yelp.wav"},
			{Name = "PIER", Sound = "emv/sirens/whelen std/emv_phaser.wav"},
			{Name = "HI-LO", Sound = "emv/sirens/whelen std/emv_hilo.wav"},
		},
		--Manual = "emv/sirens/whelen std/emv_manual.wav" -- Expirimental manual tone, idea is to have wail sine wave hold at its peak
	},
	[2] = {
		Name = "TOUCHMASTER DELTA", -- Touchmaster siren
		Category = "Federal Signal",
		Set = {
			{Name = "WAIL", Sound = "emv/sirens/federal sig tm/emv_wail.wav"},
			{Name = "YELP", Sound = "emv/sirens/federal sig tm/emv_yelp.wav"},
			{Name = "SCAN", Sound = "emv/sirens/federal sig tm/emv_scan.wav"},
		},
		Horn = "emv/sirens/federal sig tm/emv_horn.wav",
		Manual = "emv/sirens/federal sig tm/emv_manual.wav"
	},
	[3] = {
		Name = "SMARTSIREN", -- SmartSiren is used notably by the NYPD and LAPD
		Category = "Federal Signal",
		Set = {
			{Name = "WAIL", Sound = "emv/sirens/federal sig ss/emv_wail.wav"},
			{Name = "YELP", Sound = "emv/sirens/federal sig ss/emv_yelp.wav"},
			{Name = "PRIORITY", Sound = "emv/sirens/federal sig ss/emv_priority.wav"},
			{Name = "HI-LO", Sound = "emv/sirens/federal sig ss/emv_hilo.wav"},
		},
		Horn = "emv/sirens/federal sig ss/emv_horn.wav",
		Manual = "emv/sirens/federal sig ss/emv_manual.wav"
	},
	[4] = {
		Name = "SMARTSIREN RMBLR", -- Same as SmartSiren but uses low frequency rumbler. More common in NYC.
		Category = "Federal Signal",
		Set = {
			{Name = "WAIL", Sound = "emv/sirens/federal sig rumbler/emv_wail.wav"},
			{Name = "YELP", Sound = "emv/sirens/federal sig rumbler/emv_yelp.wav"},
			{Name = "PRIORITY", Sound = "emv/sirens/federal sig rumbler/emv_priority.wav"},
			{Name = "HI-LO", Sound = "emv/sirens/federal sig rumbler/emv_hilo.wav"},
		},
		Horn = "emv/sirens/federal sig rumbler/emv_horn.wav",
		Manual = "emv/sirens/federal sig ss rumbler/emv_manual.wav"
	},
	[5] = {
		Name = "WHELEN CENCOM", -- UK often seems to use a square-wave speaker of some sort, giving almost a mechanical sound
		Category = "Woodway/Whelen (UK)",
		Set = {
			{Name = "WAIL", Sound = "emv/sirens/whelen std (uk)/emv_wail.wav"},
			{Name = "YELP", Sound = "emv/sirens/whelen std (uk)/emv_yelp.wav"},
			{Name = "PIER", Sound = "emv/sirens/whelen std (uk)/emv_phaser.wav"},
			{Name = "HI-LO", Sound = "emv/sirens/whelen std (uk)/emv_hilo.wav"},
		}
	},
	[6] = {
		Name = "DANMARK", -- This is specifically based off Denmark sirens, but is common in the Scandanavian region
		Category = "Whelen",
		Set = {
			{Name = "WAIL", Sound = "emv/sirens/whelen std/emv_wail.wav"},
			{Name = "YELP", Sound = "emv/sirens/danish/emv_yelp.wav"},
			{Name = "PIER", Sound = "emv/sirens/danish/emv_phaser.wav"},
			{Name = "HI-LO", Sound = "emv/sirens/danish/emv_hilo.wav"},
		}
	},
	[7] = {
		Name = "WHELEN CENCOM", -- the CenCom is the newer Whelen siren variant, is very common on newer vehicles
		Category = "Whelen",
		Set = {
			{Name = "WAIL", Sound = "emv/sirens/whelen cencom/emv_wail.wav"},
			{Name = "YELP", Sound = "emv/sirens/whelen cencom/emv_yelp.wav"},
			{Name = "PIER", Sound = "emv/sirens/whelen cencom/emv_phaser.wav"},
		}
	},
	[8] = {
		Name = "FS EQ2B",
		Category = "Federal Signal",
		Set = {
			{Name = "WAIL", Sound = "emv/sirens/federal signal eq2b/emv_wail.wav"},
			{Name = "YELP", Sound = "emv/sirens/federal signal eq2b/emv_yelp.wav"},
		},
		Horn = "emv/sirens/federal signal eq2b/emv_horn.wav"
	},
	[9] = {
		Name = "FS OMEGA 90",
		Category = "Federal Signal",
		Set = {
			{Name = "WAIL", Sound = "emv/sirens/federal sig omega 90/emv_wail.wav"},
			{Name = "YELP", Sound = "emv/sirens/federal sig omega 90/emv_yelp.wav"},
		},
		Manual = "emv/sirens/federal sig omega 90/emv_manual.wav",
		Horn = "emv/sirens/federal sig omega 90/emv_horn.wav"
	},
	[10] = {
		Name = "FS 80K",
		Category = "Federal Signal",
		Set = {
			{Name = "WAIL", Sound = "emv/sirens/federal sig 80k/emv_wail.wav"},
			{Name = "YELP", Sound = "emv/sirens/federal sig 80k/emv_yelp.wav"},
		},
		Manual = "emv/sirens/federal sig 80k/emv_manual.wav",
		Horn = "emv/sirens/federal sig 80k/emv_horn.wav"
	},
	[11] = {
		Name = "FS 650",
		Category = "Federal Signal",
		Set = {
			{Name = "WAIL", Sound = "emv/sirens/federal sig 650/emv_wail.wav"},
			{Name = "YELP", Sound = "emv/sirens/federal sig 650/emv_yelp.wav"},
		},
		Manual = "emv/sirens/federal sig 650/emv_manual.wav",
		Horn = "emv/sirens/federal sig 650/emv_horn.wav"
	},
	[12] = {
		Name = "FS MS4000",
		Category = "Federal Signal",
		Set = {
			{Name = "WAIL", Sound = "emv/sirens/federal sig ms4000/emv_wail.wav"},
			{Name = "YELP", Sound = "emv/sirens/federal sig ms4000/emv_yelp.wav"},
			{Name = "PRIORITY", Sound = "emv/sirens/federal sig ms4000/emv_phaser.wav"},
		},
		Manual = "emv/sirens/federal sig ms4000/emv_manual.wav",
		Horn = "emv/sirens/federal sig ms4000/emv_horn.wav"
	},
	[13] = {
		Name = "POLICE NATIONALE",
		Category = "Français",
		Set = {
			{Name = "FRANÇAISE", Sound = "emv/sirens/french/fr_pn.wav"},
		},
	},
	[14] = {
		Name = "VSAV/AR",
		Category = "Français",
		Set = {
			{Name = "FRANÇAISE", Sound = "emv/sirens/french/fr_vsav-ar.wav"},
		},
	},
	[15] = {
		Name = "GENDARMERIE",
		Category = "Français",
		Set = {
			{Name = "FRANÇAISE", Sound = "emv/sirens/french/fr_gendarmerie.wav"},
		},
	},
	[16] = {
		Name = "SAMU",
		Category = "Français",
		Set = {
			{Name = "FRANÇAISE", Sound = "emv/sirens/french/fr_samu.wav"},
		},
	},
	[17] = {
		Name = "CCFM",
		Category = "Français",
		Set = {
			{Name = "FRANÇAISE", Sound = "emv/sirens/french/fr_ccfm.wav"},
		},
	},
	[18] = {
		Name = "POLIZEI",
		Category = "Deutsche",
		Set = {
			{Name = "SIRENE", Sound = "emv/sirens/german/de_polizei_sirene.wav"},
			{Name = "LAND SIRENE", Sound = "emv/sirens/german/de_polizei_land.wav"},
			{Name = "STADT SIRENE", Sound = "emv/sirens/german/de_polizei_stadt.wav"},
		},
	},
	[19] = {
		Name = "NOTARZT",
		Category = "Deutsche",
		Set = {
			{Name = "KOMPRESSOR", Sound = "emv/sirens/german/de_notarzt_kompressor.wav"},
			{Name = "LAND SIRENE", Sound = "emv/sirens/german/de_notarzt_land.wav"},
			{Name = "STADT SIRENE", Sound = "emv/sirens/german/de_notarzt_stadt.wav"},
		}
	},
	[20] = {
		Name = "FEUERWEHR",
		Category = "Deutsche",
		Set = {
			{Name = "SIRENE", Sound = "emv/sirens/german/de_feuerwehr_sirene.wav"},
		}
	},
	[21] = { -- provided by Super Mighty
		Name = "GTA V",
		Category = "Other", 
		Set = {
			{Name = "WAIL", Sound = "emv/sirens/gta/emv_wail.wav"},
			{Name = "YELP", Sound = "emv/sirens/gta/emv_yelp.wav"},
			{Name = "PIER", Sound = "emv/sirens/gta/emv_pier.wav"},
		}
	},
	[22] = { -- provided by Super Mighty
		Name = "INTIMIDATOR",
		Category = "D&R",
		Set = { -- 
			{Name = "WAIL", Sound = "emv/sirens/canada/emv_wail.wav"},
			{Name = "YELP", Sound = "emv/sirens/canada/emv_yelp.wav"},
			{Name = "HYPER-YELP", Sound = "emv/sirens/canada/emv_phaser.wav"},
			{Name = "HI-LO", Sound = "emv/sirens/canada/emv_hilo.wav"},
		},
		Horn = "emv/sirens/canada/emv_bullhorn.wav",
	},
	[23] = {
		Name = "MASTERCOM B", -- Code 3
		Category = "Code 3",
		Set = {
			{Name = "WAIL", Sound = "emv/sirens/code3 mastercomb/emv_wail.wav"},
			{Name = "YELP", Sound = "emv/sirens/code3 mastercomb/emv_yelp.wav"},
			{Name = "HYPER-YELP", Sound = "emv/sirens/code3 mastercomb/emv_hyperyelp.wav"},
			{Name = "HI-LO", Sound = "emv/sirens/code3 mastercomb/emv_hilo.wav"},
		},
		Horn = "emv/sirens/code3 mastercomb/emv_horn.wav",
	},
	[24] = {
		Name = "Z3", -- Code 3
		Category = "Code 3",
		Set = {
			{Name = "WAIL", Sound = "emv/sirens/code3 z3/emv_wail.wav"},
			{Name = "YELP", Sound = "emv/sirens/code3 z3/emv_yelp.wav"},
			{Name = "HYPER-YELP", Sound = "emv/sirens/code3 z3/emv_hyperyelp.wav"},
			{Name = "HI-LO", Sound = "emv/sirens/code3 z3/emv_hilo.wav"},
		},
		Horn = "emv/sirens/code3 z3/emv_horn.wav",
	},
}

EMVU.Horns = {
	"emv/horns/emv_standard.wav" -- loud ass airhorn, slightly experimental
}