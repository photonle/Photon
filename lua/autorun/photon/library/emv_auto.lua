AddCSLuaFile()

if not EMVU.Auto then EMVU.Auto = {} end
if not EMVU.AutoIndex then EMVU.AutoIndex = {} end


function EMVU:AddAutoComponent( component, name )
	EMVU.Auto[ name ] = component
end

// include( "auto/fedsig_valor.lua" )
// include( "auto/fedsig_integrity.lua" )
// include( "auto/fedsig_integrity_amber.lua" )
// include( "auto/fedsig_integrity_senco.lua" )
// include( "auto/fedsig_legend.lua" )
// include( "auto/fedsig_visionslr.lua" )
// include( "auto/whelen_justice.lua" )
// include( "auto/whelen_legacy.lua" )
// include( "auto/whelen_liberty.lua" )

local autoFiles = file.Find( "autorun/photon/library/auto/*", "LUA" )
for _,_file in pairs( autoFiles ) do
	include( "auto/" .. _file )
end

function EMVU:PrecacheAutoModels()
	for id,prop in pairs( EMVU.Auto ) do
		util.PrecacheModel( prop.Model )
	end
end
hook.Add( "Initialize", "Photon.PrecacheAutoModels", function() 
	EMVU:PrecacheAutoModels()
end)