AddCSLuaFile()

if not EMVU.Auto then EMVU.Auto = {} end
if not EMVU.AutoStaging then EMVU.AutoStaging = {} end
if not EMVU.AutoIndex then EMVU.AutoIndex = {} end


function EMVU:AddAutoComponent(component, name, base)
	component.Name = name
	component.Base = component.Base or base or nil

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
local lastFound = -1
local found = 0
local iter = 0
while found ~= lastFound do
	iter = iter + 1
	lastFound = found
	found = 0

	print(("iteration %s"):format(iter))
	for name, component in pairs(EMVU.AutoStaging) do
		found = found + 1

		print(("\t%s => %s"):format(component.Base, name))
		if EMVU.Auto[component.Base] then
			EMVU.Auto[name] = table.Inherit(component, EMVU.Auto[component.Base])
			EMVU.AutoStaging[name] = nil
		end
	end
end
if found ~= 0 then
	PhotonWarning("Attempted to load inherited components, but the base component wasn't loaded!")
	for name, data in pairs(EMVU.AutoStaging) do
		local base, _ = unpack(data)
		PhotonWarning(("\t%s attempted to load from %s, but %s wasn't found."):format(name, base, base))
	end
end


function EMVU:PrecacheAutoModels()
	for id,prop in pairs( EMVU.Auto ) do
		if not prop.Model then continue end
		util.PrecacheModel( prop.Model )
	end
end
hook.Add( "Initialize", "Photon.PrecacheAutoModels", function()
	EMVU:PrecacheAutoModels()
end)