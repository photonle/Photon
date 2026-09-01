AddCSLuaFile()

if not EMVU.Auto then EMVU.Auto = {} end
if not EMVU.AutoStaging then EMVU.AutoStaging = {} end
if not EMVU.AutoIndex then EMVU.AutoIndex = {} end


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

	if not component.Base then
		EMVU.Auto[name] = component
	elseif EMVU.Auto[component.Base] then
		EMVU.Auto[name] = table.Inherit(component, EMVU.Auto[component.Base])
	else
		EMVU.AutoStaging[name] = component
	end
end

--- Checks an auto component table for the fields whose absence would error at runtime.
-- EMVU:CalculateAuto iterates Meta, Sections, Patterns, Positions and Modes.Primary
-- unguarded, so a nil in any of them is a guaranteed error when a vehicle using the
-- component spawns. Empty tables are safe there and are left to the component author:
-- this checks that a component won't break, not that it does anything useful.
-- Components loaded via Base inheritance are exempt, since they may legitimately rely
-- on their base for every field checked here.
-- @tparam table component The component table to check.
-- @treturn bool Whether the component is valid.
-- @treturn string|nil A description of the first missing/invalid field, if any.
EMVU.ValidateAutoComponent = function(component)
	if not istable(component) then return false, "component must be a table" end
	if not isstring(component.Name) or component.Name == "" then return false, "missing required field 'Name'" end

	if component.Model ~= nil and (not isstring(component.Model) or component.Model == "") then return false, "optional field 'Model' must be a non-empty string" end
	if component.Category ~= nil and (not isstring(component.Category) or component.Category == "") then return false, "optional field 'Category' must be a non-empty string" end
	if component.Skin ~= nil and not isnumber(component.Skin) then return false, "optional field 'Skin' must be a number" end

	if component.Base then return true end

	if not istable(component.Meta) then return false, "missing required field 'Meta'" end
	if not istable(component.Sections) then return false, "missing required field 'Sections'" end
	if not istable(component.Patterns) then return false, "missing required field 'Patterns'" end
	if not istable(component.Positions) then return false, "missing required field 'Positions'" end
	if not istable(component.Modes) then return false, "missing required field 'Modes'" end
	if not istable(component.Modes.Primary) then return false, "missing required field 'Modes.Primary'" end

	return true
end

--- Includes a single auto component file, isolating compile-time and runtime
-- errors so one broken component doesn't abort the rest of EMV init.
-- @tparam string component The file name, relative to autorun/photon/library/auto/.
EMVU.IncludeAutoComponent = function(component)
	local path = "autorun/photon/library/auto/" .. component
	AddCSLuaFile(path)

	local func = CompileFile(path)
	if not func then
		return PhotonError(
			"Component file '" .. component .. "' failed to compile and has been skipped.\n",
			"If you are the author, check your file for syntax errors (see the compile error above)."
		)
	end

	-- Component files conventionally open with a bare AddCSLuaFile(). That form infers
	-- its own path from the calling file, which only resolves under include() - run via
	-- CompileFile it fails, erroring the chunk on line 1 and skipping the whole file.
	-- We've already sent the file above, so point the no-argument form at the known path.
	-- Writes still fall through to _G so the chunk behaves as it would under include().
	setfenv(func, setmetatable({
		AddCSLuaFile = function(target) return AddCSLuaFile(target or path) end
	}, { __index = _G, __newindex = _G }))

	local ok, err = pcall(func)
	if not ok then
		PhotonError(
			"Component file '" .. component .. "' failed to load and has been skipped.\n",
			"If you are the author, check your file for errors.\n",
			tostring(err)
		)
	end
end

local autoFiles = file.Find( "autorun/photon/library/auto/*.lua", "LUA" )
for _,_file in pairs( autoFiles ) do
	EMVU.IncludeAutoComponent( _file )
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
		local valid, invalidReason = EMVU.ValidateAutoComponent(component)
		if not errored and not valid then
			errored = true
			EMVU.Auto[name] = nil
			EMVU.AutoStaging[name] = true
			PhotonError(
				("Component %s has an invalid format and has been skipped.\n"):format(name),
				invalidReason .. ". Source: " .. tostring(component.Source)
			)
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
