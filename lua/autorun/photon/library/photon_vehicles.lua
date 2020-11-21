AddCSLuaFile()

Photon.VehicleLibrary = {}
Photon.EMVLibrary = {}

-- These were converted to be read-only after addons were breaking compatibility with the Ford Police Interceptor Utility

local PhotonVehicleIndex = {
	["models/lonewolfie/chev_impala_09_police.mdl"] = "lw_impala",
	["models/lonewolfie/chev_impala_09_taxi.mdl"] = "lw_impala",
	["models/lonewolfie/chev_impala_09.mdl"] = "lw_impala",
	["models/lonewolfie/chev_tahoe.mdl"] = "lw_tahoe",
	["models/lonewolfie/chev_tahoe_police.mdl"] = "lw_tahoe",
	["models/lonewolfie/chev_suburban.mdl"] = "lw_suburban",
	["models/lonewolfie/chev_suburban_pol.mdl"] = "lw_suburban",
	["models/lonewolfie/chev_suburban_pol_und.mdl"] = "lw_suburban",
	["models/sentry/explorer.mdl"] = "sgm_explorer",
	["models/sentry/20explorer.mdl"] = "sgm_fpiu20",
	["models/sentry/taurussho.mdl"] = "sgm_taurus",
	["models/sentry/07crownvic_uc.mdl"] = "sgm_cvpi",
	["models/sentry/07crownvic_cvpi.mdl"] = "sgm_cvpi",
	["models/sentry/07crownvic.mdl"] = "sgm_cvpi",
	["models/smcars/2017_ford_explorer_utility_steelies.mdl"] = "sm_fpiu17",
	["models/tdmcars/hsvw427_pol.mdl"] = "tdm_hsv",
	["models/tdmcars/hsvw427.mdl"] = "tdm_hsv",
	["models/sentry/15hellcat_cop.mdl"] = "st_charger",
	["models/sentry/15hellcat.mdl"] = "st_charger",
	["models/tdmcars/emergency/for_crownvic.mdl"] = "tdm_cvpi",
	["models/tdmcars/emergency/dod_charger12.mdl"] = "tdm_dc12",
	["models/schmal/fpiu/ford_utility.mdl"] = "2016 Ford Police Interceptor Utility",
	["models/schmal/chev_tahoe16.mdl"] = "2016 Chevrolet Tahoe PPV",
	["models/tdmcars/emergency/for_taurus_13.mdl"] = "fortauruspoltdm",
	["models/lonewolfie/dodge_charger_2015_police.mdl"] = "dodge_charger_2015_police_lw",
	["models/sentry/cvpi_fh3.mdl"] = "sgm_10cvpi"
	-- ["models/talonvehicles/tal_chev_suburban_2015.mdl"] = "talon_suburban"
}

local function tableFunc( tabl, key )
	if not key then return tabl end
	if key then return tabl[key] end
end

function Photon.GetVehicleIndex( key )
	return tableFunc( PhotonVehicleIndex, key )
end

local PhotonEMVIndex = {
	["models/lonewolfie/chev_impala_09_police.mdl"] = "Chevrolet Impala LS Police Cruiser",
	["models/lonewolfie/chev_tahoe_police.mdl"] = "Chevrolet Tahoe Secret Service",
	["models/lonewolfie/chev_suburban_pol_und.mdl"] = "Chevrolet Suburban Police Cruiser Undercover",
	["models/tdmcars/hsvw427_pol.mdl"] = "Holden HSV W427 Police",
	["models/tdmcars/emergency/for_crownvic.mdl"] = "Ford Crown Victoria",
	["models/tdmcars/emergency/dod_charger12.mdl"] = "Dodge Charger SRT8 2012 Police",
	["models/schmal/fpiu/ford_utility.mdl"] = "2016 Ford Police Interceptor Utility",
	["models/schmal/chev_tahoe16.mdl"] = "2016 Chevrolet Tahoe PPV",
	["models/tdmcars/emergency/for_taurus_13.mdl"] = "Ford Taurus 2013",
	["models/lonewolfie/dodge_charger_2015_police.mdl"] = "Dodge Charger R/T 2015 Pursuit",
	-- ["models/talonvehicles/tal_chev_suburban_2015.mdl"] = "2015 Chevrolet Suburban"
}

function Photon.GetEMVIndex( key )
	return tableFunc( PhotonEMVIndex, key )
end

local PhotonDefaultMapping = {
	["models/lonewolfie/chev_impala_09_police.mdl"] = "chev_impala_09_police",
	["models/lonewolfie/chev_impala_09_taxi.mdl"] = "chev_impala_09_taxi",
	["models/lonewolfie/chev_impala_09.mdl"] = "chev_impala_09",
	["models/lonewolfie/chev_tahoe.mdl"] = "chev_tahoe_lw",
	["models/lonewolfie/chev_tahoe_police.mdl"] = "chev_tahoe_police_lw",
	["models/lonewolfie/chev_suburban.mdl"] = "chev_suburban",
	["models/lonewolfie/chev_suburban_pol.mdl"] = "chev_suburban_pol",
	["models/lonewolfie/chev_suburban_pol_und.mdl"] = "chev_suburban_pol_und",
	["models/sentry/explorer.mdl"] = "explorer",
	["models/sentry/taurussho.mdl"] = "taurussho",
	["models/sentry/07crownvic_uc.mdl"] = "07sgmcrownvicuc",
	["models/sentry/07crownvic_cvpi.mdl"] = "07sgmcrownviccvpi",
	["models/sentry/07crownvic.mdl"] = "07sgmcrownvic",
	["models/tdmcars/hsvw427_pol.mdl"] = "hsvw427poltdm",
	["models/tdmcars/hsvw427.mdl"] = "hsvw427tdm",
	["models/sentry/15hellcat_cop.mdl"] = "15hellcat_cop_sgm",
	["models/sentry/15hellcat.mdl"] = "15hellcat_sgm",
	["models/tdmcars/emergency/for_crownvic.mdl"] = "forcrownvicpoltdm",
	["models/tdmcars/emergency/dod_charger12.mdl"] = "charger12poltdm",
	["models/schmal/fpiu/ford_utility.mdl"] = "2016 Ford Police Interceptor Utility",
	["models/schmal/chev_tahoe16.mdl"] = "2016 Chevrolet Tahoe PPV",
	["models/tdmcars/emergency/for_taurus_13.mdl"] = "fortauruspoltdm",
	["models/lonewolfie/dodge_charger_2015_police.mdl"] = "dodge_charger_2015_police_lw",
	-- ["models/talonvehicles/tal_chev_suburban_2015.mdl"] = "talsuburban2015"
}

function Photon.GetDefaultMapping( key )
	return tableFunc( PhotonDefaultMapping, key )
end

local indexed_vehicles = {
	"lw_impala",
	"lw_tahoe",
	"lw_suburban",
	"sgm_explorer",
	"sgm_fpiu20",
	"sgm_taurus",
	"sgm_cvpi",
	"sm_fpiu17",
	"tdm_citroenc1",
	"tdm_hsv",
	"st_charger",
	"tdm_cvpi",
	"tdm_dc12",
	"schmal_fpiu16",
	"schmal_tahoe",
	"tdm_fpis",
	"sgm_10cvpi",
	-- "talon_suburban",
}

local indexed_emvs = {
	"default_lw_impala",
	"default_lw_tahoe",
	"default_lw_suburban_und",
	"default_tdm_hsv",
	"default_tdm_cvpi",
	"default_tdm_dc12",
	"default_schmal_fpiu16",
	"default_schmal_tahoe16",
	"default_tdm_fpis",
	"default_lw_charger"
	-- "default_talon_suburban"
}

for _,car in pairs( indexed_vehicles ) do
	include( "vehicles/" .. car .. ".lua" )
end

for _,car in pairs( indexed_emvs ) do
	include( "default/" .. car .. ".lua" )
end