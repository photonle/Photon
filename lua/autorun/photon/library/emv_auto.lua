AddCSLuaFile()

if not EMVU.Auto then EMVU.Auto = {} end
if not EMVU.AutoStaging then EMVU.AutoStaging = {} end
if not EMVU.AutoIndex then EMVU.AutoIndex = {} end

local notifiedLegacyPositioning = false

function EMVU:AddAutoComponent(component, name, base)
	component.Name = name
	component.Base = component.Base or base or nil

	if component.BodyGroups then
		component.BodyGroups = EMVU.Helper.ResolveTable(component.BodyGroups)
	end

	local src = debug.getinfo(2, "S")
	component.Source = src.short_src

	if component.Deprecated then
		PhotonWarning(Format("Component %s is deprecated and may be removed in a future version.", name))
		if isstring(component.Deprecated) then
			PhotonWarning(component.Deprecated)
		end
	end

	if component.IsSGM then
		for _, position in pairs(component.Positions) do
			if position[2] then
				position[2].y = position[2].y - 90
			end
		end
	end

	if istable(component.Positions) and component.LegacyPositioning == nil then
		for _, dt in ipairs(component.Positions) do
			if istable(dt) and isvector(dt[1]) then
				local _, ang = self.Helper.ResolvePositionMatrix(component, dt[1], dt[2], Vector(0, 0, 0), Angle(0, 0, 0), 1)
				ang:SnapTo("r", 0.01)
				ang:SnapTo("p", 0.01)
				ang:SnapTo("y", 0.01)
				local _, ang2 = self.Helper.ResolvePositionLegacy(component, dt[1], dt[2], Vector(0, 0, 0), Angle(0, 0, 0), 1)
				ang2:SnapTo("r", 0.01)
				ang2:SnapTo("p", 0.01)
				ang2:SnapTo("y", 0.01)

				local meta = component.Meta[dt[3]]
				if meta then
					if not meta.NotLegacy then
						if meta.AngleOffset and isnumber(meta.AngleOffset) then
							ang2.y = ang2.y + meta.AngleOffset
						end
					elseif meta.DirAxis and meta.DirAxis == "Up" then
						ang2.y = ang2.y + meta.DirOffset
					end
				end

				if
					math.abs((ang[1] + 360) % 360) ~= math.abs((ang2[1] + 360) % 360) or
					math.abs((ang[2] + 360) % 360) ~= math.abs((ang2[2] + 360) % 360) or
					math.abs((ang[3] + 360) % 360) ~= math.abs((ang2[3] + 360) % 360) then
						Photon.Logging.Warning("An angle is resolved differently using the matrix and legacy postioning resolver in '", component.Name, "', falling back to legacy.")
						if not notifiedLegacyPositioning then
							Photon.Logging.Warning("Set COMPONENT.LegacyPositioning to false suppress this check.")
							notifiedLegacyPositioning = true
						end

						component.LegacyPositioning = true
						break
				end
			end
		end
		if not component.LegacyPositioning then
			Photon.Logging.Debug(component.Name, " works as expected.")
		end
	end

	if not component.Base then
		EMVU.Auto[name] = component
	elseif EMVU.Auto[component.Base] then
		EMVU.Auto[name] = table.Inherit(component, EMVU.Auto[component.Base])
	else
		EMVU.AutoStaging[name] = component
	end
end

local autoFiles = file.Find( "autorun/photon/library/auto/*", "LUA" )
for _,_file in pairs( autoFiles ) do
	include( "auto/" .. _file )
end
local changed, unchanged
while changed ~= 0 do
	changed, unchanged = 0, 0
	for name, component in pairs(EMVU.AutoStaging) do
		if EMVU.Auto[component.Base] then
			EMVU.Auto[name] = table.Inherit(component, EMVU.Auto[component.Base])
			EMVU.AutoStaging[name] = nil
			changed = changed + 1
		else
			unchanged = unchanged + 1
		end
	end
end
if unchanged ~= 0 then
	PhotonWarning("Attempted to load inherited components, but the base component wasn't loaded!")
	for name, data in pairs(EMVU.AutoStaging) do
		local base, _ = unpack(data)
		PhotonWarning(("\t%s attempted to load from %s, but %s wasn't found."):format(name, base, base))
	end
end

EMVU.AutoStaging = {}
local deprecated = {}
changed = nil
while changed ~= 0 do
	changed = 0
	for name, component in SortedPairsByMemberValue(EMVU.Auto, "Name") do
		local errored = false
		if not errored and not component.Modes then
			errored = true
			EMVU.Auto[name] = nil
			EMVU.AutoStaging[name] = true
			PhotonError(("Component %s is missing its Modes field."):format(name))
		end

		if not errored and component.BaseClass and EMVU.AutoStaging[component.BaseClass.Name] then
			errored = true
			EMVU.Auto[name] = nil
			EMVU.AutoStaging[name] = true
			PhotonError(("Component %s's BaseClass %s failed to load."):format(name, component.BaseClass.Name))
		end

		if not errored and component.BaseClass and component.Deprecated and not deprecated[name] then
			local root = component
			while root.BaseClass and root.BaseClass.Deprecated and root.Deprecated == root.BaseClass.Deprecated do
				root = root.BaseClass
			end
			PhotonWarning(("Component %s is based on a deprecated component (%s)"):format(name, root.Name))
			deprecated[name] = true
		end

		if errored then
			changed = changed + 1
		end
	end
end
EMVU.AutoStaging = nil

local wsidCache = {}
for _, addon in ipairs(engine.GetAddons()) do
	local files = file.Find("lua/autorun/photon/library/auto/*", addon.title)
	for _, path in ipairs(files) do
		path = string.format("lua/autorun/photon/library/auto/%s", path)
		if not wsidCache[path] then
			wsidCache[path] = {}
		end

		table.insert(wsidCache[path], addon)
	end
end

local pathCache = {}
for id, component in pairs(EMVU.Auto) do
	component.Found = false

	if not component.Found and component.Source:sub(0, 7) == "addons/" then
		component.Source = component.Source:sub(8)
		local st = component.Source:find("/")
		local addon = component.Source:sub(0, st - 1)
		component.Source = "Legacy Addon: " .. addon
		component.Found = true

		local path = "addons/" .. addon .. "/addon.json"
		local addonData
		if pathCache[path] then
			addonData = pathCache[path]
		elseif file.Exists(path, "GAME") then
			addonData = util.JSONToTable(file.Read(path, "GAME"))
			pathCache[path] = addonData
		end

		if addonData and addonData.title then
			component.Source = component.Source .. " (" .. addonData.title .. ")"
		end
	end

	if not component.Found and wsidCache[component.Source] then
		local addons = wsidCache[component.Source]
		local addon = addons[#addons]
		component.Source = "Workshop Addon: " .. addon.wsid .. " (" .. addon.title .. ")"
		component.Found = true
	end

	if not component.Found then
		component.Source = "Unknown"
	end
	component.Found = nil
end

function EMVU:PrecacheAutoModels()
	for id, component in pairs( EMVU.Auto ) do
		local mdl = component.Model
		if mdl and mdl ~= "" and not util.IsValidModel(mdl) then
			-- IsValidModel precaches on server, we don't need to worry about manually precaching.
			local required = component.Required
			if required then
				PhotonWarning(Format("%s is missing, you require https://steamcommunity.com/workshop/filedetails/?id=%s!", mdl, required))
			else
				PhotonWarning(Format("%s is missing!", mdl))
			end
		end
	end
end
hook.Add("Initialize", "Photon.PrecacheAutoModels", function()
	EMVU:PrecacheAutoModels()
end)
