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
	for k,v in pairs(ents.GetAll()) do
		if IsValid( v ) and v.IsEMV and v:IsEMV() and v.RenderEL then v:RenderEL() elseif v:IsEMV() then EMVU:MakeEMV(v, v:EMVName()) end
		if IsValid( v ) and v.IsEMV and v:IsEMV() and v.RenderIllum then v:RenderIllum() end
	end
	-- for _,ent in pairs( ents.GetAll() ) do
	-- 	if ent and ent:IsValid() and ent.IsEMV and ent:IsEMV() then
	-- 		--if ent.RenderEL then ent:RenderEL() end
	-- 		-- if ent.RenderIllum then ent:RenderIllum() end
	-- 	elseif ent:IsEMV() then
	-- 		--EMVU:MakeEMV( ent, ent:EMVName() )
	-- 	end
	-- end
end
hook.Add("PostDrawTranslucentRenderables", "EMVU.Scan", DrawEMVLights)

function EMVU:CalculateFrames()
	for _,ent in pairs(ents.GetAll()) do
		if IsValid( ent ) and ent.HasELS and ent:HasELS() and (ent:Lights() or ent:TrafficAdvisor()) then ent:CalculateELFrames() end
	end
end
hook.Add("Think", "EMVU.CalculateFrames", function()
	EMVU:CalculateFrames()
end)