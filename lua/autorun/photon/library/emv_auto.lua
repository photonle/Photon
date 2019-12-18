AddCSLuaFile()

if not EMVU.Auto then EMVU.Auto = {} end
if not EMVU.AutoIndex then EMVU.AutoIndex = {} end


function EMVU:AddAutoComponent(component, name)
	if not component.Modes then
		ErrorNoHalt(Format("[PHOTON] Component %s is missing its Modes field.\n", name))
		return
	end

	if component.Deprecated then
		PhotonWarning(Format("[PHOTON] Component %s is deprecated and may be removed in a future version.\n", name))
		if isstring(component.Deprecated) then
			PhotonWarning(component.Deprecated)
		end
	end

	EMVU.Auto[name] = component
end

local autoFiles = file.Find( "autorun/photon/library/auto/*", "LUA" )
for _,_file in pairs( autoFiles ) do
	include( "auto/" .. _file )
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