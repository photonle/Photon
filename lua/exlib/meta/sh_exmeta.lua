exmeta = exmeta or {}

---Identical to exmeta.SetMetaTable but accepts a string for the base table's name.
---@param tbl any
---@param base string|table
function exmeta.Inherit(tbl, base)
	if isstring(base) then base = exmeta.FindMetaTable(base) end
	-- print("(((((((((((((((((((((((((((((((((((((((((((((")
	-- print(tostring(base))
	-- if (base.Lights) then

		-- PrintTable(base.Lights)
	-- end
	-- print("(((((((((((((((((((((((((((((((((((((((((((((")
	local r = exmeta.SetMetaTable(tbl, base)
	-- print("RESULT !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	-- PrintTable(r)
	-- PrintTable(r.Lights)
	return r
end

---@param obj table
---@param key string
---@param prototype table|string
---@param ref any
---(ref is the object that 'self' should point to)
function  exmeta.SetSubTable(obj, key, prototype, ref)
	ref = ref or obj
	prototype = prototype or obj[key]
	if (isstring(prototype)) then
		prototype = exmeta.FindMetaTable(prototype)
	end
	obj[key] = setmetatable({
		__self = ref,
		__prototype = prototype
		-- __prototype = setmetatable({}, {__index = prototype})
	}, {__index = function(t, k)
		if isfunction(t.__prototype[k]) then
			return function(self, ...)
				return t.__prototype[k](t.__self, unpack({...}))
			end
		end
		return t.__prototype[k]
	end})
	if istable(prototype.__subtables) then
		for k, t in pairs(prototype.__subtables) do
			exmeta.SetSubTable(obj[key], k, t, ref)
		end
	end
	if isfunction(prototype.__init) then
		prototype.__init(ref, key)
	end
end

-- function exmeta.FindMetaTable(name)
-- 	return exmeta.FindMetaTable(name)
-- 	-- local meta = FindMetaTable(name)
-- 	-- return setmetatable({}, { __index = function(t, k) 
-- 	-- 	if rawget(meta, k) ~= nil then return rawget(meta, k) end
-- 	-- 	return meta.__index(t, k)
-- 	-- end})
-- end

function exmeta.RegisterMetaTable(name, tbl, base)
	if isstring(base) then base = exmeta.FindMetaTable(base) end
	if base then
		debug.getregistry()[name] = exmeta.SetMetaTable(tbl, base)
	else
		debug.getregistry()[name] = tbl
	end
	-- debug.getregistry()[name] = setmetatable(tbl, {__index = base})
	return FindMetaTable(name)
end

function exmeta.FindMetaTable(name)
	if debug.getregistry()[name] == nil then debug.getregistry()[name] = {} end
	return FindMetaTable(name)
end

function exmeta.LoadFile(filename, tableName, prefix, overwrite)
	tableName = tableName or "META"
	print("[EXMeta] Loading file: " .. tostring(filename))
	_NAME, _BASE, _META = NAME, BASE, _G[tableName]
	NAME, BASE = nil
	_G[tableName] = {}
	exmeta._shouldReload = false
	include(filename)
	exmeta._shouldReload = true
	if NAME == nil then error("[EXMeta] NAME must be defined.") end
	exmeta.LoadTable(NAME, BASE, _G[tableName], prefix, overwrite)
	-- local data = table.Copy(_G[tableName])
	-- if (isstring(prefix)) then
	-- 	NAME = prefix .. "." .. NAME
	-- end
	-- local meta = FindMetaTable(NAME)
	-- print("NAME:", NAME)
	-- print("BASE:", BASE)
	-- if meta == nil or overwrite then
	-- 	meta = exmeta.RegisterMetaTable(NAME, {}, BASE)
	-- 	-- print("NO META FOUND")
	-- else 
	-- 	-- print("LOADED META TABLE:")
	-- 	-- PrintTable(meta)
	-- end
	-- table.Merge(debug.getregistry()[NAME], data)
	-- -- if not overwrite then
	-- -- 	table.Merge(debug.getregistry()[NAME], data)
	-- -- else
	-- -- 	debug.getregistry()[NAME] = data
	-- -- end
	-- if isstring(BASE) or istable(BASE) then 
	-- 	print("INHERITING FROM: '" .. tostring(BASE) .. "'")
	-- 	meta = exmeta.Inherit(meta, BASE)
	-- end
	-- meta.ClassName = NAME
	-- -- PrintTable(meta)
	-- hook.Run("EXMeta.FileLoaded", NAME, meta, BASE)
	NAME, BASE, _G[tableName] = _NAME, _BASE, _META
end

---@param name string
---@param base string | table
---@param data table
---@param prefix string
---@param overwrite boolean
function exmeta.LoadTable(name, base, data, prefix, overwrite)
	local data = table.Copy(data)
	if isstring(prefix) then
		name = prefix .. "." .. name
	end
	local meta = FindMetaTable(name)
	print("Name:", name)
	print("Base:", base)
	if (meta == nil) or (overwrite) then
		meta = exmeta.RegisterMetaTable(name, {}, base)
	end
	table.Merge(debug.getregistry()[name], data)
	if isstring(base) or istable(base) then
		print("INHERITING FROM: '" .. tostring(base) .. "'")
		meta = exmeta.Inherit(meta, base)
	end
	meta.ClassName = name
	hook.Run("EXMeta.TableLoaded", name, meta, base)
end

function exmeta.DebugReloadFile(filename, tableName, prefix, overwrite)
	if exmeta._shouldReload then
		exmeta.LoadFile(filename, tableName, prefix, overwrite)
		return true
	end
	return false
end

function exmeta.LoadFolder(path, fol, tableName, prefix)
	fol = isstring(fol) and fol .. "/" or "exmeta/"
	fol = path .. fol
	local files = file.Find(fol .. "sh_*.lua", "LUA")
	for _, f in pairs(files) do
		AddCSLuaFile(fol .. f)
		exmeta.LoadFile(fol .. f, tableName, prefix)
	end
	files = file.Find(fol .. "sv_*.lua", "LUA")
	if SERVER then	
		for _, f in pairs(files) do
			exmeta.LoadFile(fol .. f, tableName, prefix)
		end
	end
	files = file.Find(fol .. "cl_*.lua", "LUA")
	for _, f in pairs(files) do
		AddCSLuaFile(fol .. f)
		if CLIENT then exmeta.LoadFile(fol .. f, tableName, prefix) end
	end
end

function exmeta.LoadCSFolder(path, fol, tableName, prefix)
	fol = isstring(fol) and fol .. "/" or "exmeta/"
	fol = path .. fol
	local files = file.Find(fol .. "*.lua", "LUA")
	PrintTable(files)
	for _, f in pairs(files) do
		AddCSLuaFile(fol .. f)
		if CLIENT then exmeta.LoadFile(fol .. f, tableName, prefix) end
	end
end

---Applies default/fallback values to a table.
---@param obj any
---@param metaTable table|nil
---@return table
function exmeta.SetMetaTable(obj, metaTable)
	if (metaTable == nil) then metaTable = obj; obj = {} end
	if not debug.setmetatable(obj, {__index = metaTable}) then
		error("[EXMeta] Failed to set metatable of object [" .. tostring(obj) .. "]")
	end
	return obj
end

-- PrintTable(FindMetaTable("EXCar"))
-- PrintTable(FindMetaTable("EXCarTest"))