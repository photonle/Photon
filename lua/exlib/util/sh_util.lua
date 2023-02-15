exutil = exutil or {}

exutil._modelMeshes = exutil._modelMeshes or {}
exutil._modelMeshMap = exutil._modelMeshMap or {}
local function cacheModelMeshMap(mdl, meshes)
	local materialTrack = {}
	exutil._modelMeshMap[mdl] = {}
	for k,v in pairs(meshes or util.GetModelMeshes(mdl)) do
		local material = string.GetFileFromFilename(v.material)
		if not materialTrack[material] then materialTrack[material] = 0 end
		materialTrack[material] =  materialTrack[material] + 1
		exutil._modelMeshMap[mdl][material .. "[" .. materialTrack[material] .. "]"] = k
	end
end
function exutil.GetModelMesh(mdl, search, resultIndex)
	resultIndex = resultIndex or 1
	local meshes
	if (isstring(search)) then
		local prev = search
		if (exutil._modelMeshMap[mdl] == nil) then 
			meshes = util.GetModelMeshes(mdl)
			cacheModelMeshMap(mdl, meshes)
		end
		search = exutil._modelMeshMap[mdl][search .. "[" .. resultIndex .. "]"]
		if not search then
			error("[EX] No mesh with material '" .. tostring(prev) .."' was found on model '" .. tostring(mdl) .. "'")
		end
	end
	if (isnumber(search)) then
		exutil._modelMeshes[mdl] = exutil._modelMeshes[mdl]  or {}
		if not exutil._modelMeshes[mdl][search] then
			meshes = meshes or util.GetModelMeshes(mdl)
			exutil._modelMeshes[mdl][search] = Mesh()
			exutil._modelMeshes[mdl][search]:BuildFromTriangles(meshes[search].triangles)
		end
	end
	return exutil._modelMeshes[mdl][search]
end

-- Credit to Kefta's pull request
function exutil.InheritTable( t, base )
	for k, v in pairs( base ) do 
		if ( t[ k ] == nil ) then
			t[ k ] = v
		elseif ( istable( t[ k ] ) and istable( v ) ) then
			exutil.InheritTable( t[ k ], v )
		end
	end
	t["BaseClass"] = base
	return t
end

function exutil.ReadOnlyTable(src)
	return setmetatable({}, {
		__index = src,
		__newindex = function(table, key, value)
					   error("Attempt to modify a read-only table.")
					 end,
		__metatable = false
	})
end

--- Identical to timer.Create but can override existing timers. In typical
--- Garry's Mod fashion, random shit won't work unless it's delayed by a tick.
function timer.ex_Create(identifier, delay, repititions, func)
	timer.Remove(identifier)
	timer.Simple(0.01, function()
		timer.Create(identifier, delay, repititions, func)
	end)
end

-- exmeta.LoadFile(META_TEST_FILE)
-- PrintTable(FindMetaTable("EXCarTest"))
print("util working")