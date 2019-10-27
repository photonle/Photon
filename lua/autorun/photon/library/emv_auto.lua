AddCSLuaFile()

if not EMVU.Auto then EMVU.Auto = {} end
if not EMVU.AutoIndex then EMVU.AutoIndex = {} end


function EMVU:AddAutoComponent( component, name )
	-- temporary debug
	-- local info = debug.getinfo(2, 'S')
	-- if not info.short_src:StartWith("addons/photon/lua/autorun/photon/library/") then
	-- 	ErrorNoHalt("Loading component from " .. info.source)
	-- 	print()
	-- 	return
	-- end

	if not component.Modes then
		ErrorNoHalt(Format("Component %s is missing its Modes field.\n", name))
		return
	end

	EMVU.Auto[ name ] = component
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