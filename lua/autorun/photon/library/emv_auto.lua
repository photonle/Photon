AddCSLuaFile()

if not EMVU.Auto then EMVU.Auto = {} end
if not EMVU.AutoStaging then EMVU.AutoStaging = {} end
if not EMVU.AutoIndex then EMVU.AutoIndex = {} end


function EMVU:AddAutoComponent(component, name, base)
	component.Name = name
	component.Base = component.Base or base or nil

	local src = debug.getinfo(2, "S")
	component.Source = src.short_src

	if component.Deprecated then
		PhotonWarning(Format("Component %s is deprecated and may be removed in a future version.", name))
		if isstring(component.Deprecated) then
			PhotonWarning(component.Deprecated)
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
