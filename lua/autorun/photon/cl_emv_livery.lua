AddCSLuaFile()

Photon.AutoLivery = {}

Photon.AutoLivery.TranslationTable = {
	["models/lonewolfie/chev_tahoe.mdl"] = "lwt",
	["models/sentry/taurussho.mdl"] = "sgmt"
}

Photon.AutoLivery.DownloadMaterial = function( car, id, val, ent, cback )
	if not file.Exists( "photon", "DATA" ) then file.CreateDir( "photon" ) end
	if not file.Exists( "photon/liveries", "DATA" ) then file.CreateDir( "photon/liveries" ) end
	print(tostring(string.format( "https://photon.lighting/generator/unit_number.php?car=%s&num=%s&id=%s", tostring( car ), tostring( val ), tostring( id ))))
	http.Fetch( string.format( "https://photon.lighting/generator/unit_number.php?car=%s&num=%s&id=%s", tostring( car ), tostring( val ), tostring( id ) ),
		function( body, len, headers, code )
			file.Write( "photon/liveries/" .. Photon.AutoLivery.FormatName( car, id, val ), body )
			if isfunction( cback ) then
				cback( car, id, val, ent )
			end
			print( "SUCCESS BABY" )
		end,
		function( error )
			print( "OH FUCK IT FAILED " .. tostring(error) )
		end
	);
end

Photon.AutoLivery.FormatName = function( car, id, val )
	return string.format( "photon_liv_%s_%s_%s.txt", car, id, val )
end

Photon.AutoLivery.LoadMaterial = function( car, id, val, ent )
	local checkFile = "photon/liveries/" .. Photon.AutoLivery.FormatName( car, id, val )
	if file.Exists( checkFile, "DATA" ) then
		Photon.AutoLivery.ApplyTexture( Photon.AutoLivery.LoadLivery( car, id, val ), ent )
	else
		Photon.AutoLivery.DownloadMaterial( car, id, val, ent, 
			function( car, id, val, ent )
				local loadedmaterial = Photon.AutoLivery.LoadLivery( car, id, val )
				Photon.AutoLivery.ApplyTexture( loadedmaterial, ent )
			end)
	end
end

Photon.AutoLivery.ApplyFallback = function()

end

Photon.AutoLivery.ApplyTexture = function( mat, ent )
	local veh = LocalPlayer():GetVehicle()
	if not IsValid( ent ) then return end
	print("APPLYING")
	print(tostring( mat:GetString( "$basetexture" )))
	local matParams = {
		["$basetexture"] = mat:GetString( "$basetexture" ) .. ".png",
		["$bumpmap"] =  "models/LoneWolfiesCars/shared/skin_nm",
		["$nodecal"] = 1,
		["$phong"] = 1,
		["$phongexponent"] = 5,
		["$phongboost"] = 1,
		["$nocull"] 		= 1,
		["$phongfresnelranges"] = "[1 1 1]",
		["$envmap"] = "env_cubemap",
		["$normalmapalphaenvmapmask"] = 1,
		["$envmaptint"] =  "[0.1 0.1 0.1]",
		["$colorfix"] = "{255 255 255}",
	}
	local newLivery = CreateMaterial( "photon_livery" .. string.Replace( tostring( CurTime() ), ".", "") , "VertexlitGeneric", matParams )
	local applyIndex = ent:Photon_GetAutoSkinIndex()
	veh:SetSubMaterial( applyIndex, "!" .. tostring( newLivery:GetName() ) )
end

Photon.AutoLivery.LoadLivery = function( car, id, val )
	local baseMaterial = Material( string.format( "../data/photon/liveries/photon_liv_%s_%s_%s.txt\n.png", car, id, val ), "nocull smooth" )
	return baseMaterial
end

Photon.AutoLivery.Apply = function( id, val, ent )
	if not IsValid( ent ) or not ent:IsVehicle() then return end
	local carMdl = ent:GetModel()
	local car = Photon.AutoLivery.TranslationTable[ tostring( carMdl ) ]
	if not car then print( string.format( "[Photon] %s is not a supported livery model.", carMdl )); return false end
	Photon.AutoLivery.LoadMaterial( car, id, val, ent )
end
