AddCSLuaFile()

-- This file contains all the sirens used.
-- Tables are numbered to avoid vehicles using the wrong siren set from being rearranged.

--[[ Siren Example Table
{
	Name = "Example Siren", -- The name that shows on the HUD.
	Category = "Examples", -- The category the siren shows up under.
	Set = { -- The actual sirens.
		{
			Name = "WAIL", -- Short name to display on HUD.
			Sound = "emv/sirens/example/example.wav", -- Sound path.
			Icon = "wail" -- Icon to show on the HUD. One of wail, yelp, phaser, hilo.
		}
	},
	Horn = "emv/sirens/example/horn.wav" -- Path to the horn.
}
]]--

local sirenTable = {
	[1] = {
		Name = "Alpha", -- (Name that's displayed on HUD) this a typical Whelen siren, extremely common on vehicles within the last 20 years
		Category = "Whelen",
		Set = { --
			{Name = "WAIL", Sound = "emv/sirens/whelen std/emv_wail.wav", Icon="wail"},
			{Name = "YELP", Sound = "emv/sirens/whelen std/emv_yelp.wav", Icon="yelp"},
			{Name = "PIER", Sound = "emv/sirens/whelen std/emv_phaser.wav", Icon="phaser"},
			{Name = "HILO", Sound = "emv/sirens/whelen std/emv_hilo.wav", Icon="hilo"},
		},
		--Manual = "emv/sirens/whelen std/emv_manual.wav" -- Expirimental manual tone, idea is to have wail sine wave hold at its peak
	},
	[2] = {
		Name = "Touchmaster Delta", -- Touchmaster siren
		Category = "Federal Signal",
		Set = {
			{Name = "WAIL", Sound = "emv/sirens/federal sig tm/emv_wail.wav", Icon="wail"},
			{Name = "YELP", Sound = "emv/sirens/federal sig tm/emv_yelp.wav", Icon="yelp"},
			{Name = "PHSR", Sound = "emv/sirens/federal sig tm/pemv_tmjingle.wav", Icon = "phaser"}, -- edit by pringle
			{Name = "SCAN", Sound = "emv/sirens/federal sig tm/emv_scan.wav", Icon="phaser"},
		},
		Horn = "emv/sirens/federal sig tm/emv_horn.wav",
		Manual = "emv/sirens/federal sig tm/emv_manual.wav"
	},
	[3] = {
		Name = "SmartSiren", -- SmartSiren is used notably by the NYPD and LAPD
		Category = "Federal Signal",
		Set = {
			{Name = "WAIL", Sound = "emv/sirens/federal sig ss/emv_wail.wav", Icon="wail"},
			{Name = "YELP", Sound = "emv/sirens/federal sig ss/emv_yelp.wav", Icon="yelp"},
			{Name = "PRTY", Sound = "emv/sirens/federal sig ss/emv_priority.wav", Icon="phaser"},
			{Name = "HILO", Sound = "emv/sirens/federal sig ss/emv_hilo.wav", Icon="hilo"},
		},
		Horn = "emv/sirens/federal sig ss/emv_horn.wav",
		Manual = "emv/sirens/federal sig ss/emv_manual.wav"
	},
	[4] = {
		Name = "SmartSiren Rumbler", -- Same as SmartSiren but uses low frequency rumbler. More common in NYC.
		Category = "Federal Signal",
		Set = {
			{Name = "WAIL", Sound = "emv/sirens/federal sig rumbler/emv_wail.wav", Icon="wail"},
			{Name = "YELP", Sound = "emv/sirens/federal sig rumbler/emv_yelp.wav", Icon="yelp"},
			{Name = "PRTY", Sound = "emv/sirens/federal sig rumbler/emv_priority.wav", Icon="phaser"},
			{Name = "HILO", Sound = "emv/sirens/federal sig rumbler/emv_hilo.wav", Icon="hilo"},
		},
		Horn = "emv/sirens/federal sig rumbler/emv_horn.wav",
		Manual = "emv/sirens/federal sig rumbler/emv_manual.wav"
	},
	[5] = {
		Name = "Whelen CenCom", -- UK often seems to use a square-wave speaker of some sort, giving almost a mechanical sound
		Category = "Woodway Eng.",
		Set = {
			{Name = "WAIL", Sound = "emv/sirens/whelen std (uk)/emv_wail.wav", Icon="wail"},
			{Name = "YELP", Sound = "emv/sirens/whelen std (uk)/emv_yelp.wav", Icon="yelp"},
			{Name = "PIER", Sound = "emv/sirens/whelen std (uk)/emv_phaser.wav", Icon="phaser"},
			{Name = "HILO", Sound = "emv/sirens/whelen std (uk)/emv_hilo.wav", Icon="hilo"},
		}
	},
	[6] = {
		Name = "Danmark (DK)",
		Category = "European",
		Set = {
			{Name = "WAIL", Sound = "emv/sirens/whelen std/emv_wail.wav", Icon="wail"},
			{Name = "YELP", Sound = "emv/sirens/danish/emv_yelp.wav", Icon="yelp"},
			{Name = "PIER", Sound = "emv/sirens/danish/emv_phaser.wav", Icon="phaser"},
			{Name = "HILO", Sound = "emv/sirens/danish/emv_hilo.wav", Icon="hilo"},
		}
	},
	[7] = {
		Name = "CenCom", -- the CenCom is the newer Whelen siren variant, is very common on newer vehicles
		Category = "Whelen",
		Set = {
			{Name = "WAIL", Sound = "emv/sirens/whelen cencom/emv_wail.wav", Icon="wail"},
			{Name = "YELP", Sound = "emv/sirens/whelen cencom/emv_yelp.wav", Icon="yelp"},
			{Name = "PIER", Sound = "emv/sirens/whelen cencom/emv_phaser.wav", Icon="phaser"},
		}
	},
	[8] = {
		Name = "EQ2B",
		Category = "Federal Signal",
		Set = {
			{Name = "WAIL", Sound = "emv/sirens/federal signal eq2b/emv_wail.wav", Icon="wail"},
			{Name = "YELP", Sound = "emv/sirens/federal signal eq2b/emv_yelp.wav", Icon="yelp"},
			{Name = "MAN", Sound = "emv/sirens/federal signal eq2b/emv_manual.wav", Icon="manual"},
		},
		Manual = "emv/sirens/federal signal eq2b/emv_manual.wav",
		Horn = "emv/sirens/federal signal eq2b/emv_horn.wav"
	},
	[9] = {
		Name = "OMEGA 90",
		Category = "Federal Signal",
		Set = {
			{Name = "WAIL", Sound = "emv/sirens/federal sig omega 90/emv_wail.wav", Icon="wail"},
			{Name = "YELP", Sound = "emv/sirens/federal sig omega 90/emv_yelp.wav", Icon="yelp"},
			{Name = "HILO", Sound = "emv/sirens/federal sig omega 90/emv_hilo.wav", Icon="hilo"},
			{Name = "SWEP", Sound = "emv/sirens/federal sig omega 90/emv_sweep.wav", Icon="phaser"},
		},
		Horn = "emv/sirens/federal sig omega 90/emv_horn.wav"
	},
	[10] = {
		Name = "80K",
		Category = "Federal Signal",
		Set = {
			{Name = "WAIL", Sound = "emv/sirens/federal sig 80k/emv_wail.wav", Icon="wail"},
			{Name = "YELP", Sound = "emv/sirens/federal sig 80k/emv_yelp.wav", Icon="yelp"},
			{Name = "PRTY", Sound = "emv/sirens/federal sig 80k/emv_phaser.wav", Icon="phaser"},
			{Name = "HILO", Sound = "emv/sirens/federal sig 80k/emv_hilo.wav", Icon="hilo"},
		},
		Manual = "emv/sirens/federal sig 80k/emv_manual.wav",
		Horn = "emv/sirens/federal sig 80k/emv_horn.wav"
	},
	[11] = {
		Name = "650 Series",
		Category = "Federal Signal",
		Set = {
			{Name = "WAIL", Sound = "emv/sirens/federal sig 650/emv_wail.wav", Icon="wail"},
			{Name = "YELP", Sound = "emv/sirens/federal sig 650/emv_yelp.wav", Icon="yelp"},
		},
		Manual = "emv/sirens/federal sig 650/emv_manual.wav",
		Horn = "emv/sirens/federal sig 650/emv_horn.wav"
	},
	[12] = {
		Name = "MS4000",
		Category = "Federal Signal",
		Set = {
			{Name = "WAIL", Sound = "emv/sirens/federal sig ms4000/emv_wail.wav", Icon="wail"},
			{Name = "YELP", Sound = "emv/sirens/federal sig ms4000/emv_yelp.wav", Icon="yelp"},
			{Name = "PRTY", Sound = "emv/sirens/federal sig ms4000/emv_phaser.wav", Icon="phaser"},
		},
		Manual = "emv/sirens/federal sig ms4000/emv_manual.wav",
		Horn = "emv/sirens/federal sig ms4000/emv_horn.wav"
	},
	[13] = {
		Name = "Police Nationale",
		Category = "Français (FR)",
		Set = {
			{Name = "HILO", Sound = "emv/sirens/french/fr_pn.wav", Icon="hilo"},
		},
	},
	[14] = {
		Name = "VSAV/AR",
		Category = "Français (FR)",
		Set = {
			{Name = "HILO", Sound = "emv/sirens/french/fr_vsav-ar.wav", Icon="hilo"},
		},
	},
	[15] = {
		Name = "Gendarmerie",
		Category = "Français (FR)",
		Set = {
			{Name = "HILO", Sound = "emv/sirens/french/fr_gendarmerie.wav", Icon="hilo"},
		},
	},
	[16] = {
		Name = "SAMU",
		Category = "Français (FR)",
		Set = {
			{Name = "HILO", Sound = "emv/sirens/french/fr_samu.wav", Icon="hilo"},
		},
	},
	[17] = {
		Name = "CCFM",
		Category = "Français (FR)",
		Set = {
			{Name = "HILO", Sound = "emv/sirens/french/fr_ccfm.wav", Icon="hilo"},
		},
	},
	[18] = {
		Name = "Polizei",
		Category = "Deutsche (DE)",
		Set = {
			{Name = "SRNE", Sound = "emv/sirens/german/de_polizei_sirene.wav", Icon="hilo"},
			{Name = "LAND", Sound = "emv/sirens/german/de_polizei_land.wav", Icon="hilo"},
			{Name = "STADT", Sound = "emv/sirens/german/de_polizei_stadt.wav", Icon="hilo"},
		},
	},
	[19] = {
		Name = "Notarzt",
		Category = "Deutsche (DE)",
		Set = {
			{Name = "KOMP", Sound = "emv/sirens/german/de_notarzt_kompressor.wav", Icon="hilo"},
			{Name = "LAND", Sound = "emv/sirens/german/de_notarzt_land.wav", Icon="hilo"},
			{Name = "STADT", Sound = "emv/sirens/german/de_notarzt_stadt.wav", Icon="hilo"},
		}
	},
	[20] = {
		Name = "Feuerwehr",
		Category = "Deutsche (DE)",
		Set = {
			{Name = "SRNE", Sound = "emv/sirens/german/de_feuerwehr_sirene.wav", Icon="hilo"},
		}
	},
	[21] = { -- provided by Super Mighty
		Name = "GTA V",
		Category = "Other",
		Set = {
			{Name = "WAIL", Sound = "emv/sirens/gta/emv_wail.wav", Icon="wail"},
			{Name = "YELP", Sound = "emv/sirens/gta/emv_yelp.wav", Icon="yelp"},
			{Name = "PIER", Sound = "emv/sirens/gta/emv_pier.wav", Icon="phaser"},
		}
	},
	[22] = { -- provided by Super Mighty
		Name = "Intimidator",
		Category = "D&R",
		Set = {
			{Name = "WAIL", Sound = "emv/sirens/d&r/intimidator/emv_wail.wav", Icon="wail"},
			{Name = "YELP", Sound = "emv/sirens/d&r/intimidator/emv_yelp.wav", Icon="yelp"},
			{Name = "HPYP", Sound = "emv/sirens/d&r/intimidator/emv_phaser.wav", Icon="phaser"},
			{Name = "HILO", Sound = "emv/sirens/d&r/intimidator/emv_hilo.wav", Icon="hilo"},
		},
		Horn = "emv/sirens/d&r/intimidator/emv_bullhorn.wav",
	},
	[23] = {
		Name = "Mastercom B", -- Code 3
		Category = "Code 3",
		Set = {
			{Name = "WAIL", Sound = "emv/sirens/code3 mastercomb/emv_wail.wav", Icon="wail"},
			{Name = "YELP", Sound = "emv/sirens/code3 mastercomb/emv_yelp.wav", Icon="yelp"},
			{Name = "HPYP", Sound = "emv/sirens/code3 mastercomb/emv_hyperyelp.wav", Icon="phaser"},
			{Name = "HILO", Sound = "emv/sirens/code3 mastercomb/emv_hilo.wav", Icon="hilo"},
		},
		Horn = "emv/sirens/code3 mastercomb/emv_horn.wav",
	},
	[24] = {
		Name = "Z3", -- Code 3
		Category = "Code 3",
		Set = {
			{Name = "WAIL", Sound = "emv/sirens/code3 z3/emv_wail.wav", Icon="wail"},
			{Name = "YELP", Sound = "emv/sirens/code3 z3/emv_yelp.wav", Icon="yelp"},
			{Name = "HPYP", Sound = "emv/sirens/code3 z3/emv_hyperyelp.wav", Icon="phaser"},
			{Name = "HILO", Sound = "emv/sirens/code3 z3/emv_hilo.wav", Icon="hilo"},
		},
		Horn = "emv/sirens/code3 z3/emv_horn.wav",
	},
	[25] = {
		Name = "Cal. Highway Patrol", -- THANK YOU POLECAT
		Category = "Other",
		Set = {
			{Name = "WAIL", Sound = "emv/sirens/chp/emv_wail.wav", Icon="wail"},
			{Name = "YELP", Sound = "emv/sirens/chp/emv_yelp.wav", Icon="yelp"},
		},
		Horn = "emv/sirens/chp/emv_horn.wav",
	},
	[26] = {
		Name = "SQ Zone",
		Category = "Other",
		Set = {
			{Name = "WAIL", Sound = "emv/sirens/sq zone/emv_wail.wav", Icon="wail"},
			{Name = "YELP", Sound = "emv/sirens/sq zone/emv_yelp.wav", Icon="yelp"},
		},
	},
	[27] = {
		Name = "PA300",
		Category = "Federal Signal",
		Set = {
			{Name = "WAIL", Sound = "emv/sirens/federal signal pa 300/emv_wail.wav", Icon="wail"},
			{Name = "YELP", Sound = "emv/sirens/federal signal pa 300/emv_yelp.wav", Icon="yelp"},
			{Name = "HILO", Sound = "emv/sirens/federal signal pa 300/emv_hilo.wav", Icon="hilo"},
		},
		Horn = "emv/sirens/federal signal pa 300/emv_horn.wav",
		Manual = "emv/sirens/federal signal pa 300/emv_manual.wav",
	},
	[28] = {
		Name = "H2 Covert",
		Category = "Code 3",
		Set = {
			{Name = "WAIL", Sound = "emv/sirens/code 3 h2/emv_wail.wav", Icon="wail"},
			{Name = "YELP", Sound = "emv/sirens/code 3 h2/emv_yelp.wav", Icon="yelp"},
			{Name = "HPYP", Sound = "emv/sirens/code 3 h2/emv_hyperyelp.wav", Icon="phaser"},
			-- {Name = "HPYP", Sound = "emv/sirens/code 3 h2/emv_whoop.wav", Icon="hilo"},
		},
		Horn = "emv/sirens/code 3 h2/emv_horn.wav"
	},
	[29] = {
		Name = "Norge (NO)",
		Category = "European",
		Set = {
			{Name = "WAIL", Sound = "emv/sirens/code3 norway/emv_wail.wav", Icon="wail"},
			{Name = "YELP", Sound = "emv/sirens/code3 norway/emv_yelp.wav", Icon="yelp"},
		},
	},
	[30] = {
		Name = "Rettung", -- ambulance
		Category = "Österreich (AT)",
		Set = {
			{Name = "HILO", Sound = "emv/sirens/code3 austria/hilo_ambulance.wav", Icon="hilo"},
		},
	},
	[31] = {
		Name = "DIN", -- no idea what the fuck this is
		Category = "Österreich (AT)",
		Set = {
			{Name = "HILO", Sound = "emv/sirens/code3 austria/hilo_din.wav", Icon="hilo"},
		},
	},
	[32] = {
		Name = "Feuerwehr", -- fire
		Category = "Österreich (AT)",
		Set = {
			{Name = "HILO", Sound = "emv/sirens/code3 austria/hilo_fire.wav", Icon="hilo"},
		},
	},
	[33] = {
		Name = "Polizei", -- police
		Category = "Österreich (AT)",
		Set = {
			{Name = "HILO", Sound = "emv/sirens/code3 austria/hilo_police.wav", Icon="hilo"},
		},
	},
	[34] = {
		Name = "Sverige (SE)",
		Category = "European",
		Set = {
			{Name = "HILO", Sound = "emv/sirens/code3 sweden/emv_hilo.wav", Icon="hilo"},
			{Name = "YELP", Sound = "emv/sirens/code3 sweden/emv_yelp.wav", Icon="yelp"},
		},
	},
	[35] = {
		Name = "Xcel",
		Category = "Code 3",
		Set = {
			{Name = "WAIL", Sound = "emv/sirens/code3 excel/emv_wail.wav", Icon="wail"},
			{Name = "YELP", Sound = "emv/sirens/code3 excel/emv_yelp.wav", Icon="yelp"},
			{Name = "HPYP", Sound = "emv/sirens/code3 excel/emv_hyperyelp.wav", Icon="phaser"},
		},
		Horn = "emv/sirens/code3 excel/emv_horn.wav",
	},
	[36] = {
		Name = "Banshee",
		Category = "Code 3",
		Set = {
			{Name = "WAIL", Sound = "emv/sirens/code3 banshee/emv_wail.wav", Icon="wail"},
			{Name = "YELP", Sound = "emv/sirens/code3 banshee/emv_yelp.wav", Icon="yelp"},
			{Name = "HPYP", Sound = "emv/sirens/code3 banshee/emv_hyperyelp.wav", Icon="phaser"},
			{Name = "CMND", Sound = "emv/sirens/code3 banshee/emv_command.wav", Icon="yelp"},
		},
		Horn = "emv/sirens/code3 excel/emv_horn.wav",
	},
	[37] = {
		Name = "Motorcycle 3955",
		Category = "Code 3",
		Set = {
			{Name = "WAIL", Sound = "emv/sirens/code3 3955/emv_wail.wav", Icon="wail"},
			{Name = "YELP", Sound = "emv/sirens/code3 3955/emv_yelp.wav", Icon="yelp"},
		},
		Horn = "emv/sirens/code3 excel/emv_horn.wav",
	},
	[38] = {
		Name = "RLS",
		Category = "Code 3",
		Set = {
			{Name = "WAIL", Sound = "emv/sirens/code3 rls/emv_wail.wav", Icon="wail"},
			{Name = "YELP", Sound = "emv/sirens/code3 rls/emv_yelp.wav", Icon="yelp"},
			{Name = "HPYP", Sound = "emv/sirens/code3 rls/emv_hyperyelp.wav", Icon="phaser"},
			{Name = "HILO", Sound = "emv/sirens/code3 rls/emv_hilo.wav", Icon="hilo"},
		},
		Horn = "emv/sirens/code3 rls/emv_horn.wav",
	},
	[39] = {
		Name = "Sprinter",
		Category = "Code 3",
		Set = {
			{Name = "WAIL", Sound = "emv/sirens/code3 sprinter/emv_wail.wav", Icon="wail"},
			{Name = "YELP", Sound = "emv/sirens/code3 sprinter/emv_yelp.wav", Icon="yelp"},
			{Name = "HILO", Sound = "emv/sirens/code3 sprinter/emv_hilo.wav", Icon="hilo"},
		},
		Horn = "emv/sirens/code3 rls/emv_horn.wav",
	},
	[40] = {
		Name = "Schweizerische (CH)",
		Category = "European",
		Set = {
			{Name = "HILO", Sound = "emv/sirens/code3 swiss/emv_hilo.wav", Icon="hilo"},
		},
	},
	[41] = {
		Name = "Suomi (FI)",
		Category = "European",
		Set = {
			{Name = "HILO", Sound = "emv/sirens/code3 finnish/emv_hilo.wav", Icon="hilo"},
			{Name = "YELP", Sound = "emv/sirens/code3 sweden/emv_yelp.wav", Icon="yelp"}
		},
	},
	[42] = {
		Name = "PA500",
		Category = "Federal Signal",
		Set = {
			{Name = "WAIL", Sound = "emv/sirens/federal signal pa 500/emv_wail.wav", Icon="wail"},
			{Name = "YELP", Sound = "emv/sirens/federal signal pa 500/emv_yelp.wav", Icon="yelp"},
			{Name = "HILO", Sound = "emv/sirens/federal signal pa 500/emv_hilo.wav", Icon="hilo"},
		},
		Horn = "emv/sirens/federal signal pa 300/emv_horn.wav",
	},
	[43] = {
		Name = "Storm",
		Category = "Feniex",
		Set = {
			{Name = "WAIL", Sound = "emv/sirens/feniex storm/emv_wail.wav", Icon="wail"},
			{Name = "YELP", Sound = "emv/sirens/feniex storm/emv_yelp.wav", Icon="yelp"},
			{Name = "PHSR", Sound = "emv/sirens/feniex storm/emv_phaser.wav", Icon="phaser"},
		},
		Horn = "emv/sirens/feniex storm/emv_horn.wav",
	},
	[44] = {
		Name = "PA640",
		Category = "Federal Signal",
		Set = {
			{Name = "WAIL", Sound = "emv/sirens/federal signal pa 640/emv_wail.wav", Icon="wail"},
			{Name = "YELP", Sound = "emv/sirens/federal signal pa 640/emv_yelp.wav", Icon="yelp"},
			{Name = "PRTY", Sound = "emv/sirens/federal signal pa 640/emv_priority.wav", Icon="phaser"},
		},
		Horn = "emv/sirens/federal signal pa 640/emv_horn.wav",
		Manual = "emv/sirens/federal signal pa 640/emv_manual.wav",
	},
	[45] = {
		Name = "nFORCE 400",
		Category = "SoundOff Signal",
		Set = {
			{Name = "WAIL", Sound = "emv/sirens/soundoff nforce 400/emv_wail.wav", Icon="wail"},
			{Name = "YELP", Sound = "emv/sirens/soundoff nforce 400/emv_yelp.wav", Icon="yelp"},
			{Name = "PHSR", Sound = "emv/sirens/soundoff nforce 400/emv_pier.wav", Icon="phaser"},
		}
	},
	[46] = {
		Name = "Gamma",
		Category = "Whelen",
		-- Gain = {
		-- 	Sound = "sound/emv/sirens/whelen gamma/emv_wind3.wav",
		-- 	-- UpRate = .017,
		-- 	-- DownRate = .005,
		-- 	UpRate = .034,
		-- 	DownRate = .01,
		-- 	MaxRate = 1,
		-- 	MinRate = .3
		-- },
		Set = {
			{Name = "WAIL", Sound = "emv/sirens/whelen gamma/emv_wail.wav", Icon="wail"},
			{Name = "YELP", Sound = "emv/sirens/whelen gamma/emv_yelp.wav", Icon="yelp"},
			{Name = "PIER", Sound = "emv/sirens/whelen gamma/emv_pier.wav", Icon="phaser"},
		},
	},
	[47] = {
		Name = "Holiday",
		Category = "Other",
		Set = {
			{Name = "JNGL", Sound = "emv/sirens/holiday/jingle.wav", Icon="xmas"},
			{Name = "CAROL", Sound = "emv/sirens/holiday/carol.wav", Icon="xmas"},
			{Name = "NOEL", Sound = "emv/sirens/holiday/noel.wav", Icon="xmas"},
		}
	},
	-- [48] = {
	-- 	Name = "295 (Alternate)",
	-- 	Category = "Whelen",
	-- 	Set = {
	-- 		{Name = "WAIL", Sound = "emv/sirens/whelen 295/wail_alternate.wav", Icon="wail"},
	-- 		{Name = "WARB", Sound = "emv/sirens/whelen 295/warble.wav", Icon="wail"},
	-- 		-- {Name = "YELP", Sound = "emv/sirens/whelen gamma/emv_yelp.wav", Icon="yelp"},
	-- 		-- {Name = "PIER", Sound = "emv/sirens/whelen gamma/emv_pier.wav", Icon="phaser"},
	-- 	},
	-- },
	[48] = {
		Name = "Street Thunder 800",
		Category = "Galls",
		Set = {
			{Name = "WAIL", Sound = "emv/sirens/galls street thunder 800/emv_wail.wav", Icon="wail"},
			{Name = "YELP", Sound = "emv/sirens/galls street thunder 800/emv_yelp.wav", Icon="yelp"},
			{Name = "THNDR", Sound = "emv/sirens/galls street thunder 800/emv_thunder.wav", Icon="phaser"},
			{Name = "HILO", Sound = "emv/sirens/galls street thunder 800/emv_hilo.wav", Icon = "hilo"},
		},
		Horn = "emv/sirens/galls street thunder 800/emv_horn.wav",
	},
	[49] = {
		Name = "Whelen Cencom Sapphire", -- The unmodified with the high pitch version that's used by various forces in the UK.
		Category = "Woodway Eng.",
		Set = {
			{Name = "WAIL", Sound = "emv/sirens/whelen cencom sapphire/emv_wail.wav", Icon="wail"},
			{Name = "YELP", Sound = "emv/sirens/whelen cencom sapphire/emv_yelp.wav", Icon="yelp"},
			{Name = "PHSR", Sound = "emv/sirens/whelen cencom sapphire/emv_phaser.wav", Icon="phaser"},
			{Name = "HILO", Sound = "emv/sirens/whelen cencom sapphire/emv_hilo.wav", Icon = "hilo"},
		},
		Horn = "emv/sirens/whelen cencom sapphire/emv_horn.wav",
	},
	[50] = {
		Name = "295HFSA6",
		Category = "Whelen",
		Set = {
			{Name = "WAIL", Sound = "emv/sirens/whelen 295hsfa6/emv_wail.wav", Icon="wail"},
			{Name = "YELP", Sound = "emv/sirens/whelen 295hsfa6/emv_yelp.wav", Icon="yelp"},
			{Name = "PHSR", Sound = "emv/sirens/whelen 295hsfa6/emv_phaser.wav", Icon="phaser"},
			{Name = "HILO", Sound = "emv/sirens/whelen 295hsfa6/emv_hilo.wav", Icon = "hilo"},
		},
		Horn = "emv/sirens/whelen 295hsfa6/emv_horn.wav",
	},
	[51] = {
		Name = "CO19 STIRLING", -- Old styled siren typically used by the Met's armed responce team in the late 2000's
		Category = "Woodway Eng.",
		Set = { --
			{Name = "WAIL", Sound = "emv/sirens/co19/emv_wail.wav"},
			{Name = "YELP", Sound = "emv/sirens/co19/emv_yelp.wav"},
			{Name = "HYPER-YELP", Sound = "emv/sirens/co19/emv_phaser.wav"},
			{Name = "HI-LO", Sound = "emv/sirens/co19/emv_hilo.wav"},
		},
		Horn = "emv/sirens/co19/emv_horn.wav",
	},
	[52] = {
		Name = "West Midlands", -- The siren typically found within  the West Midlands in the UK.
		Category = "Woodway Eng.",
		Set = {
			{Name = "WAIL", Sound = "emv/sirens/west mids/emv_wail.wav", Icon="wail"},
			{Name = "YELP", Sound = "emv/sirens/west mids/emv_yelp.wav", Icon="yelp"},
			{Name = "PHSR", Sound = "emv/sirens/west mids/emv_phaser.wav", Icon="phaser"},
			{Name = "HILO", Sound = "emv/sirens/west mids/emv_hilo.wav", Icon = "hilo"},
		},
		Horn = "emv/sirens/whelen cencom sapphire/emv_horn.wav",
	},
	[53] = {
		Name = "Q2B",
		Category = "Federal Signal",
		Set = {
			{Name = "WAIL", Sound = "emv/sirens/federal signal q2b/emv_wail.wav", Icon="wail"},
			{Name = "YELP", Sound = "emv/sirens/federal signal q2b/emv_yelp.wav", Icon="yelp"},
			{Name = "MAN", Sound = "emv/sirens/federal signal eq2b/emv_manual.wav", Icon="manual"},
		},
		Manual = "emv/sirens/federal signal eq2b/emv_manual.wav",
		Horn = "emv/sirens/federal signal eq2b/emv_horn.wav"
	},
	[54] = {
		Name = "Scan Superior",
		Category = "Other",
		Set = {
			{Name = "WAIL", Sound = "emv/sirens/scan superior/emv_wail.wav", Icon="wail"},
			{Name = "YELP", Sound = "emv/sirens/scan superior/emv_yelp.wav", Icon="yelp"},
			{Name = "PRTY", Sound = "emv/sirens/scan superior/emv_phaser.wav", Icon="phaser"},
			{Name = "HILO", Sound = "emv/sirens/scan superior/emv_hilo.wav", Icon="hilo"},
		},
		Horn = "emv/sirens/scan superior/emv_horn.wav"
	},
	[55] = {
		Name = "ST300 Command Center",
		Category = "Galls",
		Set = {
			{Name = "WAIL", Sound = "emv/sirens/galls st300 command center/emv_wail.wav", Icon="wail"},
			{Name = "YELP", Sound = "emv/sirens/galls st300 command center/emv_yelp.wav", Icon="yelp"},
			{Name = "PHASER", Sound = "emv/sirens/galls st300 command center/emv_phaser.wav", Icon="phaser"},
			{Name = "HILO", Sound = "emv/sirens/galls st300 command center/emv_hilo.wav", Icon = "hilo"},
		},
		Horn = "emv/sirens/galls st300 command center/emv_horn.wav",
	},
}

EMVU.Horns = {
	"emv/horns/emv_standard.wav" -- loud ass airhorn, slightly experimental
}

EMVU.GetSiren = function(index)
	if not index then Error("[Photon] EMVU.GetSiren( index ) requires a string or number index. Got nil or false.") return end
	local st = EMVU.GetSirenTable()

	if isnumber(index) and st[index] then return table.Copy(st[index]) end

	for key, sirenInfo in pairs(st) do
		if sirenInfo.ID == index then
			return sirenInfo
		end
	end
	print( "[Photon] Failed to find siren with index (" .. tostring( index ) .. "), falling back.")
	return sirenTable[1]
end

EMVU.GetSirenIndex = function(index)
	if not index then Error("[Photon] EMVU.GetSirenIndex( index ) requires a string or number index. Got nil or false.") return end
	local st = EMVU.GetSirenTable()

	if isnumber(index) and st[index] then return index end

	for key, sirenInfo in pairs(st) do
		if sirenInfo.ID == index then
			return key
		end
	end

	print( "[Photon] Failed to find siren with index (" .. tostring( index ) .. "), falling back.")
	return 0
end

EMVU.GetSirenTable = function()
	return sirenTable
end

EMVU.AddCustomSiren = function(index, siren)
	if tonumber(index) ~= nil then return Error("[Photon] Custom sirens need a non-number identifier. See: https://github.com/photonle/Photon/wiki/Custom-Sirens\n") end

	siren.ID = index
	table.insert(sirenTable, siren)
end

local function searchSirenAddon(siren, addon)
	if not addon.downloaded then return end
	if not addon.mounted then return end

	local files = file.Find("sound/" .. siren.Horn, addon.title)
	if files[1] then
		PhotonWarning(
			"The addon", addon.title, "(", addon.wsid, ") appears to be trying to load old photon sirens.\n",
			"The method being used is no longer supported. https://github.com/photonle/Photon/wiki/Custom-Sirens"
		)
		return true
	end
end
EMVU.Sirens = {}
timer.Simple(35, function()
	if #EMVU.Sirens > 0 then
		PhotonWarning("One or more addons are using a deprecated method to add custom sirens. See: https://github.com/photonle/Photon/wiki/Custom-Sirens")

		for _, siren in ipairs(EMVU.Sirens) do
			local found = false

			local search = "sound/"
			if siren.Horn then
				search = search .. siren.Horn
			else
				search = search .. siren.Set[1].Sound
			end

			local files = file.Find("sound/" .. siren.Horn, "GAME")
			if not files[1] then
				PhotonWarning("Sound file not found for", siren.Category, ":", siren.Name)
				found = true
			end

			if not found then
				local addons = engine.GetAddons()
				for _, addon in ipairs(addons) do
					if searchSirenAddon(siren, addon) then
						found = true
						break
					end
				end
			end

			if not found then
				PhotonWarning(
					"A folder addon appears to be trying to load old photon sirens.\n",
					"Because it's in a folder, we can't find it.\n",
					"If it's your addon, please read https://github.com/photonle/Photon/wiki/Custom-Sirens"
				)
			end
		end
	end
end)

--[[ New Siren Example
EMVU.AddCustomSiren("internets special siren number UNO", {
	Name = "Example Siren", -- The name that shows on the HUD.
	Category = "Examples", -- The category the siren shows up under.
	Set = {
		{Name = "WAIL", Sound = "emv/sirens/example/example.wav", Icon = "wail"}
	},
	Horn = "emv/sirens/example/horn.wav"
})
]]--

EMVU.IncludeSiren = function(siren)
	AddCSLuaFile("autorun/photon/library/sirens/" .. siren)
	include("autorun/photon/library/sirens/" .. siren)
end

local sirens = file.Find("autorun/photon/library/sirens/*.lua", "LUA")
for _, siren in pairs(sirens) do
	EMVU.IncludeSiren(siren)
end