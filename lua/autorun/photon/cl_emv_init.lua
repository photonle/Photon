AddCSLuaFile()

if not CLIENT then return end

include( "cl_emv_meta.lua" )
include( "cl_emv_hud.lua" )
include( "cl_emv_listener.lua" )
include( "cl_emv_net.lua" )
include( "cl_frame_adjust.lua" )
include( "cl_photon_builder.lua" )
include( "cl_photon_menu.lua" )

function DrawEMVLights()
	Photon:ClearLightQueue()
	for k,v in pairs( EMVU:AllVehicles() ) do
		if IsValid( v ) and v.IsEMV and v:IsEMV() and v.RenderEL then v:RenderEL() elseif v:IsEMV() then EMVU:MakeEMV(v, v:EMVName()) end
		if IsValid( v ) and v.IsEMV and v:IsEMV() and v.RenderIllum then v:RenderIllum() end
	end	
end
// timer.Create("EMVU.Scan", .033, 0, DrawEMVLights)
hook.Add("PreRender", "EMVU.Scan", DrawEMVLights)

function EMVU:CalculateFrames()
	for _,ent in pairs( EMVU:AllVehicles() ) do
		if IsValid( ent ) and ent.HasELS and ent:HasELS() and (ent.Lights and ent:Lights() or ent.TrafficAdvisor and ent:TrafficAdvisor()) then ent:CalculateELFrames() end
	end
end
timer.Create("EMVU.CalculateFrames", .03, 0, function()
	EMVU:CalculateFrames()
end)
