--[[-- Automatic Liveries
@copyright Photon Team
@release v73 Grand Lake
@author Photon Team
@module EMVU.AutoLivery
--]]--
AddCSLuaFile()

Photon.AutoLivery = {}

--- Translation table for models to material names for unit generation.
Photon.AutoLivery.TranslationTable = {
	["models/lonewolfie/chev_tahoe.mdl"] = "lwt",
	["models/sentry/taurussho.mdl"] = "sgmt"
}

--- Function to download a material.
-- @string car Vehicle Material key for the generator.
-- @string id Livery ID.
-- @string val Unit ID.
-- @ent ent Callback entity.
-- @tparam function cback Callback function.
-- @tparam function failedcback Error callback.
Photon.AutoLivery.DownloadMaterial = function(car, id, val, ent, cback, failedcback)
	if not file.Exists("photon", "DATA") then
		file.CreateDir("photon")
	end

	if not file.Exists("photon/liveries", "DATA") then
		file.CreateDir("photon/liveries")
	end

	ent.PhotonLiveryDownloadInProgress = true
	local fetchUrl = string.format("https://photon.lighting/generator/unit_number.php?car=%s&num=%s&id=%s", tostring(car), tostring(val), tostring(id))

	http.Fetch(fetchUrl, function(body, len, headers, code)
		file.Write("photon/liveries/" .. Photon.AutoLivery.FormatName(car, id, val), body)

		if isfunction(cback) then
			cback(car, id, val, ent, true)
		end
	end, function(error)
		print("[Photon] Failed to fetch custom livery, reverting to fallback. Error: " .. tostring(error))

		if isfunction(cback) then
			cback(car, id, val, ent, false)
		end
	end)
end

--- Format a livery name for caching.
-- @string car Vehicle ID
-- @string id Livery ID
-- @string val Unit ID
-- @treturn string Formatted name.
Photon.AutoLivery.FormatName = function(car, id, val) return string.format("photon_liv_%s_%s_%s.txt", car, id, val) end

--- Load and fetch a material onto a given vehicle.
-- @string car Vehicle ID
-- @string id Livery ID.
-- @string val Unit ID.
-- @ent ent Callback entity.
Photon.AutoLivery.LoadMaterial = function(car, id, val, ent)
	local checkFile = "photon/liveries/" .. Photon.AutoLivery.FormatName(car, id, val)

	if file.Exists(checkFile, "DATA") then
		Photon.AutoLivery.ApplyTexture(Photon.AutoLivery.LoadLivery(car, id, val), ent, car, val, id)
	else
		Photon.AutoLivery.DownloadMaterial(car, id, val, ent, Photon.AutoLivery.LoadCallback)
	end
end

--- Callback after a livery has been downloaded.
-- @string car Vehicle ID
-- @string id Livery ID.
-- @string val Unit ID.
-- @ent ent Callback entity.
-- @bool success If the download was successful.
Photon.AutoLivery.LoadCallback = function(car, id, val, ent, success)
	ent.PhotonLiveryDownloadInProgress = false

	if success then
		Photon.AutoLivery.ApplyTexture(Photon.AutoLivery.LoadLivery(car, id, val), ent, car, val, id)
	else
		Photon.AutoLivery.ApplyFallback(ent, id)
	end
end

--- Broken.
-- @string name Vehicle name.
-- @string id Livery ID.
Photon.AutoLivery.FindFallback = function(name, id)
	if not EMVU.Liveries[tostring(ent.VehicleName)] then return "" end
	local liveryTable = EMVU.Liveries[name]

	for category, subtable in pairs(liveryTable) do
		for displayName, liveryData in pairs(subtable) do
			if liveryData[2] == id then return liveryData[1] end
		end
	end

	return ""
end

--- Apply a fallback livery to a vehicle.
-- @ent ent Entity to apply to.
-- @string id Livery ID.
Photon.AutoLivery.ApplyFallback = function(ent, id)
	if tostring(ent.VehicleName) ~= "nil" then
		local fallbackMaterial = Photon.AutoLivery.FindFallback(ent.VehicleName, id)

		if fallbackMaterial ~= "" then
			local applyIndex = ent:Photon_GetAutoSkinIndex()

			if applyIndex then
				ent:SetSubMaterial(applyIndex, fallbackMaterial)
			end
		end
	end
end

--- Apply an autolivery to a vehicle.
-- @tparam IMaterial mat Material to apply.
-- @ent ent Vehicle to apply to.
-- @string car Vehicle ID.
-- @string val Livery ID.
-- @string id Unit ID.
Photon.AutoLivery.ApplyTexture = function(mat, ent, car, val, id)
	local veh = ent
	if not IsValid(ent) then return end

	local matParams = {
		["$basetexture"] = mat:GetString("$basetexture") .. ".png",
		["$bumpmap"] = "models/LoneWolfiesCars/shared/skin_nm",
		["$nodecal"] = 1,
		["$phong"] = 1,
		["$phongexponent"] = 5,
		["$phongboost"] = 1,
		["$nocull"] = 1,
		["$phongfresnelranges"] = "[1 1 1]",
		["$envmap"] = "env_cubemap",
		["$normalmapalphaenvmapmask"] = 1,
		["$envmaptint"] = "[0.1 0.1 0.1]",
		["$colorfix"] = "{255 255 255}"
	}

	local newLivery = CreateMaterial(string.format("photon_livery_%s_%s_%s", car, val, id), "VertexlitGeneric", matParams)
	local applyIndex = ent:Photon_GetAutoSkinIndex()
	veh:SetSubMaterial(applyIndex, "!" .. tostring(newLivery:GetName()))

	veh.Photon_LiveryData = {
		UnitID = veh:Photon_GetUnitNumber(),
		LiveryID = veh:Photon_GetLiveryID()
	}

	for _, prop in ipairs(EMVU.Helper.GetSubProps(veh)) do
		prop:SetSubMaterial(applyIndex, "!" .. tostring(newLivery:GetName()))
	end
end

--- Load a livery from file.
-- @string car Vehicle ID.
-- @string id Livery ID.
-- @string val Unit ID.
Photon.AutoLivery.LoadLivery = function(car, id, val)
	local baseMaterial = Material(string.format("../data/photon/liveries/photon_liv_%s_%s_%s.txt\n.png", car, id, val), "nocull smooth")
	return baseMaterial
end

--- Apply an auto livery to a vehicle.
-- @string id Livery ID.
-- @string val Unit ID.
-- @ent ent Vehicle to apply to.
Photon.AutoLivery.Apply = function(id, val, ent)
	if not IsValid(ent) or not ent:IsVehicle() then return end
	local carMdl = ent:GetModel()
	local car = Photon.AutoLivery.TranslationTable[tostring(carMdl)]

	if not car then
		print(string.format("[Photon] %s is not a supported livery model.", carMdl))
		return false
	end

	Photon.AutoLivery.LoadMaterial(car, id, val, ent)
end

--- Scan for AutoLivery changes.
Photon.AutoLivery.Scan = function()
	for _, car in pairs(EMVU:AllVehicles()) do
		if not IsValid(car) then continue end
		if car:Photon_GetLiveryID() == "" then continue end
		if car.PhotonLiveryDownloadInProgress == true then continue end
		if istable(car.Photon_LiveryData) and tostring(car.Photon_LiveryData.UnitID) == car:Photon_GetUnitNumber() and tostring(car.Photon_LiveryData.LiveryID) == car:Photon_GetLiveryID() then continue end

		Photon.AutoLivery.Apply(car:Photon_GetLiveryID(), car:Photon_GetUnitNumber(), car)
	end
end

timer.Create("Photon.AutoLiveryScan", 10, 0, function()
	Photon.AutoLivery.Scan()
end)