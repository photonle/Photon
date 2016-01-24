AddCSLuaFile()

EMVU.Net = {}

function EMVU.Net:Siren( arg )
	net.Start( "emvu_siren" )
		net.WriteString( arg )
	net.SendToServer()
end

function EMVU.Net:Lights( arg )
	net.Start( "emvu_el" )
		net.WriteString( arg )
	net.SendToServer()
end

function EMVU.Net:SirenSet( arg, ent, aux )
	if aux == nil then aux = false end
	if not ent then ent = LocalPlayer():GetVehicle() end
	if not IsValid( ent ) then return end
	net.Start( "emvu_sirenset" )
		net.WriteEntity( ent )
		net.WriteInt( arg, 8 )
		net.WriteBool( aux )
	net.SendToServer()
end

function Photon.Net:Signal( arg )
	net.Start( "photon_signal" )
		net.WriteInt( arg, 3 )
	net.SendToServer()
end

function EMVU.Net:Illuminate( arg )
	net.Start( "emvu_illum" )
		net.WriteString( arg )
	net.SendToServer()
end

function EMVU.Net:Traffic( arg )
	net.Start( "emvu_traffic" )
		net.WriteString( arg )
	net.SendToServer()
end

function EMVU.Net:Blackout( arg )
	net.Start( "emvu_blackout" )
		net.WriteBit( arg )
	net.SendToServer()
end

function EMVU.Net:Horn( arg )
	net.Start( "emvu_horn" )
		net.WriteBit( arg )
	net.SendToServer()
end

function EMVU.Net:Manual( arg )
	net.Start( "emvu_manual" )
		net.WriteBit( arg )
	net.SendToServer()
end

function EMVU.Net:Preset( arg )
	net.Start( "emvu_preset" )
		net.WriteInt( arg, 8 )
	net.SendToServer()
end

local unitid_pref = GetConVar( "photon_emerg_unit" )

local function GenerateDefaultUnitID()
	return string.sub( tostring( LocalPlayer():SteamID64() ), 14 ) or "000" -- will use the last three digits of Steam64
end

function EMVU.Net:Livery( category, index )
	net.Start( "emvu_livery" )
		net.WriteString( category )
		net.WriteString( index )
		net.WriteString( unitid_pref:GetString() or GenerateDefaultUnitID() )
	net.SendToServer()
end

function EMVU.Net:ReceiveLiveryUpdate( id, unit, ent )
	Photon.AutoLivery.Apply( id, unit, ent )
end
net.Receive( "photon_liveryupdate", function() 
	EMVU.Net:ReceiveLiveryUpdate( net.ReadString(), net.ReadString(), net.ReadEntity() )
end)

function EMVU.Net:Color( ent, col )
	net.Start( "emvu_color" )
		net.WriteEntity( ent )
		net.WriteColor( col )
	net.SendToServer()
end

function EMVU.Net:ReceiveUnitNumberRequest()
	net.Start( "photon_myunitnumber" )
		net.WriteString( unitid_pref:GetString() or GenerateDefaultUnitID() )
	net.SendToServer()
end
net.Receive( "photon_myunitnumber", function() EMVU.Net:ReceiveUnitNumberRequest() end)

function EMVU.Net.Selection( ent, category, option )
	net.Start( "emvu_selection" )
		net.WriteEntity( ent )
		net.WriteInt( category, 8 )
		net.WriteInt( option, 8)
	net.SendToServer()
end

function EMVU.Net.RequestAllSkins()
	net.Start( "photon_availableskins" )
	net.SendToServer()
end

function EMVU.Net.ReceiveAvailableSkins()
	local received = net.ReadTable()
	Photon.AutoSkins.Available = received
end
net.Receive( "photon_availableskins", function() EMVU.Net.ReceiveAvailableSkins() end)

function EMVU.Net.ApplyAutoSkin( ent, skin )
	local cnt = 0
	skin = tostring( skin )
	for i in string.gfind( skin, "/" ) do
		cnt = cnt + 1
	end
	if cnt < 2 then
		skin = string.Replace( skin, "/", "///" )
	end
	net.Start( "photon_setautoskin" )
		net.WriteEntity( ent )
		net.WriteString( skin )
	net.SendToServer()
end

function EMVU.Net.ApplyLicenseMaterial( ent, mat )
	local cnt = 0
	for i in string.gfind( mat, "/" ) do
		cnt = cnt + 1
	end
	if cnt < 2 then
		mat = string.Replace( mat, "/", "///" )
	end
	net.Start( "photon_license_mat" )
		net.WriteEntity( ent )
		net.WriteString( mat )
	net.SendToServer()
end

Photon.BoneRotation = function()
	-- if true then return end
	for _,ent in pairs( ents.GetAll() ) do
		if ent.PhotonRotationEnabled then
			local emv = ent:GetParent()
			if emv:Photon_Lights() then
				local stageId = emv:Photon_LightOptionID()
				local componentBoneData = ent.PhotonBoneAnimationData
				for boneIndex, boneData in pairs( componentBoneData ) do
					local currentAnimation = boneData.Primary[ stageId ]
					local animAction = currentAnimation[1] or "RP"
					local animAngle = currentAnimation[2] or 0
					local animSpeed = currentAnimation[3] or 25
					local currentAngles = ent:GetManipulateBoneAngles( boneIndex )
					local currentAngle = currentAngles[3]
					local difAng = ( FrameTime() * animSpeed ) * 10
					local addAng = (currentAngles.r + difAng) % 360
					local subAng = (currentAngles.r - difAng) % 360
					-- print(difAng)
					if animAction == "S" then
						if animAngle < 0 then animAngle = 360 + animAngle end
						local lt = animAngle > currentAngle
						local eq = animAngle == currentAngle
						if not eq then
							if lt then
								if difAng + currentAngle > animAngle then addAng = animAngle end
								ent:ManipulateBoneAngles( boneIndex, Angle( currentAngles.p, currentAngles.y, addAng ) )
							else
								if currentAngle - difAng < animAngle then subAng = animAngle end
								ent:ManipulateBoneAngles( boneIndex, Angle( currentAngles.p, currentAngles.y, subAng ) )
							end
						end
					elseif (animAction == "A" or animAction == "AN") and istable( animAngle ) then
						if not ent.PhotonBonesAlt then ent.PhotonBonesAlt = {} end
						if not ent.PhotonBonesAlt[ boneIndex ] then ent.PhotonBonesAlt[ boneIndex ] = 1 end
						local currentDir = ent.PhotonBonesAlt[ boneIndex ] or 1
						local gotoAngle = animAngle[ currentDir ]
						local ang1 = animAngle[1]
						local ang2 = animAngle[2]
						local lt = gotoAngle > currentAngle
						local eq = gotoAngle == currentAngle
						local difAng = ( FrameTime() * animSpeed ) * 10
						local addAng = (currentAngles.r + difAng) % 360
						local subAng = (currentAngles.r - difAng) % 360
						if not eq then
							if animAction == "A" then
								if currentDir == 2 then -- even
									if subAng > ang1 and subAng < ang2 then subAng = gotoAngle end
									ent:ManipulateBoneAngles( boneIndex, Angle( currentAngles.p, currentAngles.y, subAng ) )
								else -- odd
									if addAng > ang1 and addAng < ang2 then addAng = gotoAngle end
									ent:ManipulateBoneAngles( boneIndex, Angle( currentAngles.p, currentAngles.y, addAng ) )
								end
							else
								if currentDir == 2 then -- even
									if subAng < ang1 and subAng > ang2 then subAng = gotoAngle end
									ent:ManipulateBoneAngles( boneIndex, Angle( currentAngles.p, currentAngles.y, subAng ) )
								else -- odd
									if addAng < ang1 and addAng > ang2 then addAng = gotoAngle end
									ent:ManipulateBoneAngles( boneIndex, Angle( currentAngles.p, currentAngles.y, addAng ) )
								end
							end
							
						else
							local max = #animAngle
							if max > currentDir then ent.PhotonBonesAlt[ boneIndex ] = currentDir + 1
							else  ent.PhotonBonesAlt[ boneIndex ] = 1 end
						end
					elseif animAction == "RP" or animAction == "R" then
						ent:ManipulateBoneAngles( boneIndex, Angle( currentAngles.p, currentAngles.y, addAng ) )
					elseif animAction == "RN" then
						ent:ManipulateBoneAngles( boneIndex, Angle( currentAngles.p, currentAngles.y, subAng ) )
					end
				end
			end
		end
		-- if ent:GetModel() == "models/schmal/vision_lightbar_ii.mdl" then
		-- 	if ent:GetParent():Photon_Lights() then
		-- 	local ang = ent:GetManipulateBoneAngles(14)
		-- 	ent:ManipulateBoneAngles( 14, Angle( ang.p, ang.y, ang.r + 24 ) )
		-- 	ang = ent:GetManipulateBoneAngles(12)
		-- 	ent:ManipulateBoneAngles( 12, Angle( ang.p, ang.y, ang.r - 16 ) )
		-- 	ang = ent:GetManipulateBoneAngles(10)
		-- 	ent:ManipulateBoneAngles( 10, Angle( ang.p, ang.y, ang.r - 16 ) )
		-- 	ang = ent:GetManipulateBoneAngles(8)
		-- 	ent:ManipulateBoneAngles( 8, Angle( ang.p, ang.y, ang.r + 24 ) )
		-- 	ang = ent:GetManipulateBoneAngles(6)
		-- 	ent:ManipulateBoneAngles( 6, Angle( ang.p, ang.y, ang.r + 24 ) )
		-- 	ang = ent:GetManipulateBoneAngles(4)
		-- 	ent:ManipulateBoneAngles( 4, Angle( ang.p, ang.y, ang.r - 16 ) )
		-- 	ang = ent:GetManipulateBoneAngles(2)
		-- 	ent:ManipulateBoneAngles( 2, Angle( ang.p, ang.y, ang.r - 16 ) )
		-- 	end
		-- end
	end
end

hook.Add( "PreRender", "Photon.RotationAnimation", function() 
	Photon.BoneRotation()
end )