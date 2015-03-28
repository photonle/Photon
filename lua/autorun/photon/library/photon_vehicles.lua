AddCSLuaFile()

Photon.VehicleLibrary = {}
Photon.EMVLibrary = {}

Photon.VehicleIndex = {
	["models/LoneWolfie/chev_impala_09_police.mdl"] = "lw_impala",
	["models/LoneWolfie/chev_impala_09_taxi.mdl"] = "lw_impala",
	["models/LoneWolfie/chev_impala_09.mdl"] = "lw_impala",
	["models/LoneWolfie/chev_tahoe.mdl"] = "lw_tahoe",
	["models/LoneWolfie/chev_tahoe_police.mdl"] = "lw_tahoe",
	["models/LoneWolfie/chev_suburban.mdl"] = "lw_suburban",
	["models/LoneWolfie/chev_suburban_pol.mdl"] = "lw_suburban",
	["models/LoneWolfie/chev_suburban_pol_und.mdl"] = "lw_suburban",
	["models/sentry/explorer.mdl"] = "sgm_explorer",
	["models/sentry/taurussho.mdl"] = "sgm_taurus",
	["models/sentry/07crownvic_uc.mdl"] = "sgm_cvpi",
	["models/sentry/07crownvic_cvpi.mdl"] = "sgm_cvpi",
	["models/sentry/07crownvic.mdl"] = "sgm_cvpi",
	["models/tdmcars/hsvw427_pol.mdl"] = "tdm_hsv",
	["models/tdmcars/hsvw427.mdl"] = "tdm_hsv",
	["models/sentry/15hellcat_cop.mdl"] = "st_charger",
	["models/sentry/15hellcat.mdl"] = "st_charger",
}

Photon.EMVIndex = {
	["models/LoneWolfie/chev_impala_09_police.mdl"] = "Chevrolet Impala LS Police Cruiser",
	["models/LoneWolfie/chev_tahoe_police.mdl"] = "Chevrolet Tahoe Secret Service",
	["models/LoneWolfie/chev_suburban_pol_und.mdl"] = "Chevrolet Suburban Police Cruiser Undercover",
	["models/tdmcars/hsvw427_pol.mdl"] = "Holden HSV W427 Police",
}

Photon.DefaultMapping = {
	["models/LoneWolfie/chev_impala_09_police.mdl"] = "chev_impala_09_police",
	["models/LoneWolfie/chev_impala_09_taxi.mdl"] = "chev_impala_09_taxi",
	["models/LoneWolfie/chev_impala_09.mdl"] = "chev_impala_09",
	["models/LoneWolfie/chev_tahoe.mdl"] = "chev_tahoe_lw",
	["models/LoneWolfie/chev_tahoe_police.mdl"] = "chev_tahoe_police_lw",
	["models/LoneWolfie/chev_suburban.mdl"] = "chev_suburban",
	["models/LoneWolfie/chev_suburban_pol.mdl"] = "chev_suburban_pol",
	["models/LoneWolfie/chev_suburban_pol_und.mdl"] = "chev_suburban_pol_und",
	["models/sentry/explorer.mdl"] = "explorer",
	["models/sentry/taurussho.mdl"] = "taurussho",
	["models/sentry/07crownvic_uc.mdl"] = "07sgmcrownvicuc",
	["models/sentry/07crownvic_cvpi.mdl"] = "07sgmcrownviccvpi",
	["models/sentry/07crownvic.mdl"] = "07sgmcrownvic",
	["models/tdmcars/hsvw427_pol.mdl"] = "hsvw427poltdm",
	["models/tdmcars/hsvw427.mdl"] = "hsvw427tdm",
	["models/sentry/15hellcat_cop.mdl"] = "15hellcat_cop_sgm",
	["models/sentry/15hellcat.mdl"] = "15hellcat_sgm",
}

local indexed_vehicles = {
	"lw_impala",
	"lw_tahoe",
	"lw_suburban",
	"sgm_explorer",
	"sgm_taurus",
	"sgm_cvpi",
	"tdm_citroenc1",
	"tdm_hsv",
	"st_charger",
}

local indexed_emvs = {
	"default_lw_impala",
	"default_lw_tahoe",
	"default_lw_suburban_und",
	"default_tdm_hsv",
}

for _,car in pairs( indexed_vehicles ) do
	include( "vehicles/" .. car .. ".lua" )
end

for _,car in pairs( indexed_emvs ) do
	include( "default/" .. car .. ".lua" )
end