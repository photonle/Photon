AddCSLuaFile()

local lpos = Vector()

local clamp = math.Clamp
local pow = math.pow
local round = math.Round
local useEyePos = Vector( 0, 0, 0 )
local useEyeAng = Angle( 0, 0, 0 )
local istable = istable
local isnumber = isnumber
local pairs = pairs
local ColorAlpha = ColorAlpha
local Lerp = Lerp
local tostring = tostring
local Material = Material
local Vector = Vector

local bloom_multi = GetConVar( "photon_bloom_modifier" )
local dynlights_enabled = GetConVar( "photon_dynamic_lights" )

local getLightColor = render.GetLightColor
local utilPixVis = util.PixelVisible
local rotatingLight, pulsingLight, emvHelp

if EMVU and istable( EMVU.Helper ) then
	rotatingLight = EMVU.Helper.RotatingLight
	pulsingLight = EMVU.Helper.PulsingLight
	emvHelp = EMVU.Helper
end

hook.Add( "InitPostEntity", "Photon.AddHelperLocalVars", function()
	rotatingLight = EMVU.Helper.RotatingLight
	pulsingLight = EMVU.Helper.PulsingLight
	emvHelp = EMVU.Helper
end)



local function getViewFlare( dot, brght )
	local dif = dot - .85
	if dif < 0 then return 0 end
	local calc = (dif * 1000) * clamp( brght, 0, 1 )
	return pow( calc, 1.01 ) * .025
end

local setMaterial = render.SetMaterial
local drawSprite = render.DrawSprite

local mat1 = Material("sprites/emv/flare_secondary")
local mat2 = Material("sprites/emv/emv_smoothglow")
local mat3 = Material("sprites/emv/light_initial")
local mat4 = Material("sprites/emv/flare_primary")
local mat5 = Material("sprites/emv/effect_artifact1")
local mat6 = Material("sprites/emv/effect_artifact2")
local mat7 = Material("sprites/emv/dirty_lens_1")
local mat8 = Material("sprites/emv/dirty_lens_2")

local up1 = Vector()

local photonRenderTable = {}
local photonDynamicLights = {}

function Photon:AddLightToQueue( lightInfo )
	photonRenderTable[ #photonRenderTable + 1 ] = lightInfo
end

function Photon.AddDynamicLightToQueue( lightInfo )
	photonDynamicLights[ #photonDynamicLights + 1 ] = lightInfo
end

function Photon:ClearLightQueue()
	table.Empty( photonRenderTable )
	table.Empty( photonDynamicLights )
end

function Photon:PrepareVehicleLight( parent, incolors, ilpos, gpos, lang, meta, pixvis, lnum, brght, multicolor, type, emitDynamic, contingent )
	if not incolors or not ilpos or not lang or not meta or not gpos then return end
	local resultTable = { true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true }
	local legacy = true
	if meta.NoLegacy == true then legacy = false end
	local colors = incolors
	local offset = meta.AngleOffset

	local manualBloom = 1
	if bloom_multi and bloom_multi:GetFloat() then manualBloom = bloom_multi:GetFloat() end

	lpos:Set( ilpos )

	local rotating = false

	if offset == "R" or offset == "RR" then
		local speed = 2
		if meta.Speed then speed = meta.Speed end
		offset = rotatingLight(emvHelp, speed, 10)
		rotating = true
		local degrees = offset % 360
		if multicolor then
			if ( degrees > 0 and degrees < 180 ) then
				colors = incolors[2]
			else
				colors = incolors[1]
			end
		end
	end

	local visRadius = .1
	local cheapLight = false
	if meta.Cheap then cheapLight = true end

	if meta.VisRadius then visRadius = meta.VisRadius end

	local viewDot = 0
	-- local visible = 1
	local visible = 0
	local viewPercent = 0

	if meta.AngleOffset and meta.AngleOffset == "RR" then
		local lposMod = EMVU.Helper:RadiusLight( 1, 4 )
		lpos[1] = lpos[1] + lposMod
		lpos[2] = lpos[2] + lposMod
	end

	local worldPos = gpos
	// local worldPos = parent:LocalToWorld(lpos)

	// visible = 1
	//visible = utilPixVis( worldPos, visRadius, pixvis )
	visible = pixvis
	-- visible = 1
	if( visible and visible > 0) then


	if EMV_DEBUG then visible = 1 end
	if EMV_DEBUG then viewDot = 1 end

	if emitDynamic then
			local addDynamic = { true, true, true, true }
			local normalDir = parent:GetForward()
			if emitDynamic == 1 then normalDir:Rotate( Angle( 0, 135, 0 ) )
			elseif emitDynamic == 2 then normalDir:Rotate( Angle( 0, 45, 0 ) )
			elseif emitDynamic == 3 then normalDir:Rotate( Angle( 0, -135, 0 ) )
			elseif emitDynamic == 4 then normalDir:Rotate( Angle( 0, -45, 0 ) ) end
			addDynamic[1] = worldPos
			addDynamic[2] = normalDir
			addDynamic[3] = { colors.raw.r, colors.raw.g, colors.raw.b }
			addDynamic[4] = ( parent:EntIndex() * 400 ) + emitDynamic
			-- addDynamic[4] = (parent:EntIndex()*100) + ( lnum * 4 )
			Photon.AddDynamicLightToQueue( addDynamic )
		end

	if not visible or visible <= 0 then return end

	if not meta.Scale then meta.Scale = 1 end
	if not meta.WMult then meta.WMult = 1 end
	local ca = parent:GetAngles()
	local lightNormal = Angle()
	if legacy and not contingent then
		ca:RotateAroundAxis( parent:GetUp(), ( lang.y + offset ) )
	elseif contingent then
		ca:RotateAroundAxis( parent:GetUp(), ( lang.r + 180 ) )
	else
		if meta.DirAxis and not rotating then
			ca:RotateAroundAxis( parent["Get"..meta.DirAxis](parent), lang.r - meta.DirOffset )
			ca:RotateAroundAxis( parent:GetUp(), lang.y )
		elseif meta.DirAxis and rotating then
			ca:RotateAroundAxis( parent["Get"..meta.DirAxis](parent), lang.r - meta.DirOffset - offset )
			ca:RotateAroundAxis( parent:GetUp(), lang.y )
		end
	end
	lightNormal = ca:Forward()
	lightNormal:Normalize()

	local ViewNormal = Vector()
	ViewNormal:Set(worldPos)
	ViewNormal:Sub( useEyePos )
	ViewNormal:Normalize()
	viewDot = ViewNormal:Dot( lightNormal )

	if ( viewDot and viewDot >= 0 ) then

		viewPercent = viewDot
		local viewMod = viewDot * 10
		viewDot = ( pow( viewMod, 1.25 ) * .1 ) * manualBloom

		local curLight = getLightColor( worldPos )
		local lightMod = clamp(1 - round(((( curLight[1] * curLight[2] * curLight[3] ) * .3) * 10) * 2, 5), .66, 1)

		local srcOnly = false
		local srcSkip = false

		if (meta.Sprite and meta.Sprite == "sprites/emv/blank") or meta.Cheap then srcSkip = true end

		local UC = { true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true }

		local brightness = 1
		local rawBrightness = 1
		local pulseOverride = false

		if brght and istable(brght) then
			brightness = pulsingLight( emvHelp, brght[1], brght[2], brght[3] )
			pulseOverride = true
		elseif isnumber( brght ) then
			brightness = brght
			rawBrightness = brght
		end

		brightness = brightness * lightMod

		viewDot = viewDot * brightness
		local viewFlare = getViewFlare( viewPercent, brightness )
		local dist = worldPos:Distance( EyePos() )
		local distModifier = ( 1 - clamp( ( dist / 512 ), 0, 1) )
		viewFlare = viewFlare * distModifier

		if meta.SourceOnly == true then
			srcOnly = true
		end

		local al = Angle()
		al:Set(lang)
		al.r = al.r - 90
		if rotating then al.y = offset - 90 end

		up1:Set( worldPos )
		local ua = parent:LocalToWorldAngles( al )

		for k,v in pairs( colors ) do
			UC[k] = v
		end

		local srcColor = Color(255,255,255,255)

		if not srcSkip then
			local srcMod = ( viewDot * .5 ) * manualBloom
			//srcColor = ColorAlpha( UC.src, UC.src.a * rawBrightness )
			srcColor = ColorAlpha( UC.src, 255 )
			if pulseOverride then srcColor.a = ( srcColor.a * brightness ) end
			if istable(UC["dim"]) then
				srcColor.r = Lerp( srcMod, UC.dim.r, UC.src.r )
				srcColor.g = Lerp( srcMod, UC.dim.g, UC.src.g )
				srcColor.b = Lerp( srcMod, UC.dim.b, UC.src.b )
			end
		end

		if PHOTON_DEBUG and !PHOTON_DEBUG_EXCLUSIVE then srcColor = Color( 255, 255, 0, 255 ) elseif PHOTON_DEBUG and PHOTON_DEBUG_EXCLUSIVE then srcColor = Color( 0, 0, 0, 0 ) end
		if PHOTON_DEBUG and PHOTON_DEBUG_LIGHT and lpos == PHOTON_DEBUG_LIGHT[1] then srcColor = Color( 0, 255, 255 ) end

		resultTable[1] = srcOnly
		resultTable[2] = !srcSkip
		resultTable[3] = worldPos
		resultTable[4] = ua
		if not meta.SpriteMaterial then meta.SpriteMaterial = Material( meta.Sprite ) end
		resultTable[5] = meta.SpriteMaterial
		if not meta.SprT then meta.SprT = Vector( meta.W * .5, meta.H * .5, 0 ) end
		resultTable[6] = meta.SprT
		if not meta.SprR then meta.SprR = Vector( -meta.W * .5, meta.H * .5, 0 ) end
		resultTable[7] = meta.SprR
		if not meta.SprB then meta.SprB = Vector( -meta.W * .5, -meta.H * .5, 0 ) end
		resultTable[8] = meta.SprB
		if not meta.SprL then meta.SprL = Vector( meta.W * .5, -meta.H * .5, 0 ) end
		resultTable[9] = meta.SprL
		resultTable[10] = worldPos
		local fovModifier = math.Clamp( ( ( 1 - ( LocalPlayer():GetFOV() / 90 ) ) * 5 ) + 1, 1, 1000 )
		resultTable[11] = (meta.Scale * viewDot) * manualBloom
		resultTable[12] = ((meta.Scale * viewFlare) * fovModifier) * manualBloom
		resultTable[13] = (meta.Scale * meta.WMult*viewDot) * manualBloom
		resultTable[14] = srcColor

		resultTable[15] = UC.med
		resultTable[16] = UC.amb
		resultTable[17] = UC.blm
		resultTable[18] = UC.glw
		resultTable[19] = UC.raw
		resultTable[20] = UC.flr

		resultTable[21] = lightMod
		resultTable[22] = cheapLight
		resultTable[23] = viewFlare

		resultTable[24] = false

		resultTable[25] = meta.SubmatID
		resultTable[26] = meta.SubmatMaterial
		resultTable[27] = parent

		if istable( meta.EmitArray ) then
			local emitResults = {}
			for _key,_val in pairs( meta.EmitArray ) do
				if not isvector( _val ) then continue end
				emitResults[ #emitResults + 1 ] = Vector()
				local insertRef = emitResults[ #emitResults ]
				insertRef:Set( _val )
				insertRef:Rotate( ua )
				insertRef:Add( worldPos )
			end
			resultTable[24] = emitResults
		end

		self:AddLightToQueue( resultTable )

	end
	end
end


local startCam = cam.Start3D2D
local setRenderLighting = render.SetLightingMode
local drawQuad = render.DrawQuad
local endCam = cam.End3D2D

local bloomRef = 0
local bloomColor = nil

function Photon.QuickDrawNoTable( srcOnly, drawSrc, camPos, camAng, srcSprite, srcT, srcR, srcB, srcL, worldPos, bloomScale, flareScale, widthScale, colSrc, colMed, colAmb, colBlm, colGlw, colRaw, colFlr, lightMod, cheap, viewFlare, multiEmit, SubmatID, SubmatMaterial, SubmatParent, debug_mode )

	if drawSrc then
		startCam( camPos, camAng, 1 )
			setRenderLighting( 2 )
			setMaterial( srcSprite )
			drawQuad( srcT, srcR, srcB, srcL, colSrc )
			setRenderLighting( 0 )
		endCam()
	end
	if SubmatID then
		SubmatParent:SetSubMaterial(SubmatID, SubmatMaterial)
		timer.Simple( 0.2, function() 
			if IsValid(SubmatParent) then  SubmatParent:SetSubMaterial(SubmatID, nil) end
		end )
	end

	if debug_mode == true then return end
	if not srcOnly then
		if istable( multiEmit ) then
			for _,wPos in pairs( multiEmit ) do
				setMaterial( mat1 )
				drawSprite( wPos, (48 * bloomScale), (32 * bloomScale), colGlw )

				setMaterial( mat2 )
				drawSprite( wPos, (256 * bloomScale), (256 * bloomScale), colAmb )

				setMaterial( mat2 )
				drawSprite( wPos, (64 * bloomScale), 48 * bloomScale, colBlm )

				setMaterial( mat3 )
				drawSprite( wPos, 12 * widthScale, 12 * bloomScale, colMed )
			end
		elseif isvector( worldPos ) then
				setMaterial( mat1 )
				drawSprite( worldPos, (48 * bloomScale), (32 * bloomScale), colGlw )

				setMaterial( mat2 )
				drawSprite( worldPos, (256 * bloomScale), (256 * bloomScale), colAmb )

				setMaterial( mat2 )
				drawSprite( worldPos, (64 * bloomScale), 48 * bloomScale, colBlm )

				setMaterial( mat3 )
				drawSprite( worldPos, 12 * widthScale, 12 * bloomScale, colMed )
		end
	end
end

local drawW = ScrW() * .5
local drawH = ScrH() * .5
local refW = ScrW()
local refH = ScrH()

local setSurfaceMaterial = surface.SetMaterial
local setSurfaceColor = surface.SetDrawColor
local drawTexturedRect = surface.DrawTexturedRect

function Photon.DrawScreenEffects( srcOnly, drawSrc, camPos, camAng, srcSprite, srcT, srcR, srcB, srcL, worldPos, bloomScale, flareScale, widthScale, colSrc, colMed, colAmb, colBlm, colGlw, colRaw, colFlr, lightMod, cheap, viewFlare, multiEmit, SubmatID, SubmatMaterial, parent, debug_mode )
	if false then return end
	if viewFlare and colFlr and viewFlare > 0 and not cheap then
		local width = drawW
		local height = drawH
		local screenPos = worldPos:ToScreen()
		local percentVertical = 1 - math.abs((drawW - screenPos.x) / drawW)
		local percentHorizontal = 1 - math.abs((drawH - screenPos.y) / drawH)
		local averageCenterPercent = (percentVertical + percentHorizontal) * .5

		local artifact1x = screenPos.x + ( ( width - screenPos.x ) * .15 )
		local artifact1y = screenPos.y + ( ( height - screenPos.y ) * .15 )
		local artifact2x = screenPos.x + ( ( width - screenPos.x ) * .6 )
		local artifact2y = screenPos.y + ( ( height - screenPos.y ) * .6 )
		local artifact3x = screenPos.x
		local artifact3y = screenPos.y
		local artifact4x = screenPos.x + ( ( width - screenPos.x ) * .3 )
		local artifact4y = screenPos.y + ( ( height - screenPos.y ) * .3 )
		local artifact5x = screenPos.x + ( ( height - screenPos.y ) )
		local artifact5y = screenPos.y + ( ( height - screenPos.y ) )

		flareScale = flareScale * averageCenterPercent

		local alphaMod = ( ( flareScale ) * colAmb.a)

		local artificactColor1 = ColorAlpha( colAmb, alphaMod )
		setSurfaceMaterial( mat2 )
		setSurfaceColor( artificactColor1 )
		local size = 2048 * flareScale
		local halfSize = size * .5
		drawTexturedRect( screenPos.x - halfSize, screenPos.y - halfSize, size, size )

		-- setSurfaceColor( artificactColor1 )
		setSurfaceMaterial( mat5 )
		size = 16 * flareScale
		halfSize = size * .5
		drawTexturedRect( artifact2x - halfSize, artifact2y - halfSize, size, size )

		size = 128 * flareScale
		halfSize = size * .5
		drawTexturedRect( artifact4x - halfSize, artifact4y - halfSize, size, size )

		alphaMod = ( ( flareScale * .25 ) * colFlr.a )
		setSurfaceMaterial( mat6 )
		setSurfaceColor( ColorAlpha( colFlr, alphaMod ) )
		size = 48 * flareScale
		halfSize = size * .5
		drawTexturedRect( artifact1x - halfSize, artifact1y - halfSize, size, size )
		setSurfaceMaterial( mat1 )
		setSurfaceColor( colFlr )

		local flareMultiplier = 1
		local flareW = 256 * ( flareScale * flareMultiplier )
		local flareH = 4 * ( flareScale * flareMultiplier )
		if viewFlare > bloomRef then bloomRef = viewFlare; bloomColor = colAmb end
		drawTexturedRect( ( artifact3x - ( flareW * .5 ) ), ( artifact3y - ( flareH * .5 ) ), flareW, flareH )

		if true then
		local sizeX, sizeY

		setSurfaceMaterial( mat1 )
		setSurfaceColor( colGlw )
		sizeX = (48 * bloomScale) * flareScale
		sizeY = (32 * bloomScale) * flareScale
		drawTexturedRect( screenPos.x - (sizeX * .5), screenPos.y - (sizeY * .5), sizeX, sizeY )

		setSurfaceMaterial( mat2 )
		setSurfaceColor( colAmb )
		sizeX = (256 * bloomScale) * flareScale
		sizeY = (256 * bloomScale) * flareScale
		drawTexturedRect( screenPos.x - (sizeX * .5), screenPos.y - (sizeY * .5), sizeX, sizeY )

		setSurfaceMaterial( mat2 )
		setSurfaceColor( colBlm )
		sizeX = (64 * bloomScale) * flareScale
		sizeY = (48 * bloomScale) * flareScale
		drawTexturedRect( screenPos.x - (sizeX * .5), screenPos.y - (sizeY * .5), sizeX, sizeY )

		setSurfaceMaterial( mat3 )
		setSurfaceColor( colMed )
		sizeX = (12 * bloomScale) * flareScale
		sizeY = (12 * bloomScale) * flareScale
		drawTexturedRect( screenPos.x - (sizeX * .5), screenPos.y - (sizeY * .5), sizeX, sizeY )
		end
	end
end

function Photon.RenderDynamicLight( pos, dir, incol, index )
	local dlight = DynamicLight( index )
	if dlight then
		dlight.pos = pos
		dlight.r = incol[1]
		dlight.g = incol[2]
		dlight.b = incol[3]
		dlight.dir = dir
		dlight.innerangle = 5
		dlight.outerangle = 90
		dlight.brightness = 7
		dlight.Decay = 1000
		dlight.Size = 64
		dlight.DieTime = CurTime() + 1
	end
end

local quickDrawNoTable = Photon.QuickDrawNoTable
local photonScreenEffects = Photon.DrawScreenEffects
local cam3d = cam.Start3D
local cam2d = cam.Start2D
local endCam2d = cam.End2D
local endCam3d = cam.End3D
local draw_effects = GetConVar( "photon_lens_effects" )
hook.Add( "InitPostEntity", "Photon.DrawEffectsConvar", function()
	draw_effects = GetConVar( "photon_lens_effects" )
	bloom_multi = GetConVar( "photon_bloom_modifier" )
	dynlights_enabled = GetConVar( "photon_dynamic_lights" )
end)

function Photon:RenderQueue( effects )
	local eyePos = EyePos()
	local eyeAng = EyeAngles()
	local count = #photonRenderTable
	if not effects then cam3d( eyePos, eyeAng ) else cam2d( eyePos, eyeAng ) end
	if ( count > 0 ) then
		local debug_mode = PHOTON_DEBUG
		local renderFunction
		if effects then renderFunction = photonScreenEffects else renderFunction = quickDrawNoTable end
		for i=1, count do
			if photonRenderTable[i] != nil then
				local data = photonRenderTable[i]
				renderFunction( data[1], data[2], data[3], data[4], data[5], data[6], data[7], data[8], data[9], data[10], data[11], data[12], data[13], data[14], data[15], data[16],
								data[17], data[18], data[19], data[20], data[21], data[22], data[23], data[24], data[25], data[26], data[27], debug_mode )
			end
		end
	end
	if not effects then endCam3d() else endCam2d() end
	-- Photon:ClearLightQueue()
end
hook.Add( "PreDrawEffects", "Photon.RenderQueue", function()
	Photon:RenderQueue( false )
	if draw_effects and draw_effects:GetBool() then
		Photon:RenderQueue( true )
	end
end )
local overlayX = math.Round(( ScrW() - ScrH() ) / 2)

local isFuckingBloomMap = false
local fuckingBloomMaps = {
	["gm_driversheaven_tdm"] = true,
}
hook.Add( "InitPostEntity", "Photon.CheckForFuckingBloomMap", function()
	isFuckingBloomMap = fuckingBloomMaps[ tostring( game.GetMap() ) ]
end )
local mapBloomAdjust = 1
function Photon.DrawDirtyLensEffect()
	if isFuckingBloomMap then mapBloomAdjust = .15 end
	if not ( ( bloomRef > 0 ) and ( bloomColor != nil ) ) then return end
	-- setSurfaceColor( ColorAlpha( colAmb, alphaMod * 1.66 ) )
	local drawColor = Color( bloomColor.r, bloomColor.g, bloomColor.b, ( bloomColor.a ) * ( ( bloomRef * bloomRef * bloomRef ) * mapBloomAdjust ) )
	setSurfaceColor( drawColor )
	setSurfaceMaterial( mat7 )
	-- size = 512
	-- halfSize = size * .5
	drawTexturedRect( overlayX, 0, refH, refH )
	setSurfaceMaterial( mat8 )
	drawTexturedRect( 0, 0, refW, refH )
	bloomRef = 0; bloomColor = nil;

end
if not mat7:IsError() then
	hook.Add( "RenderScreenspaceEffects", "Photon.ScreenEffects", function()
		Photon.DrawDirtyLensEffect()
	end)
else
	timer.Simple( 1, function()
		LocalPlayer():ChatPrint("[Photon] It seems that some content of photon is missing. Try to redownload photon by deleting the gma file in your addons folder.")
	end)
end
function Photon.RenderDynamicLightQueue()
	local count = #photonDynamicLights
	if ( count > 0 ) then
		for i=1, count do
			if photonDynamicLights[i] != nil then
				local data = photonDynamicLights[i]
				Photon.RenderDynamicLight( data[1], data[2], data[3], data[4] )
			end
		end
	end
end
hook.Add( "Think", "Photon.RenderDynamicLightQueue", function() 
	if ( dynlights_enabled and dynlights_enabled.GetBool and dynlights_enabled:GetBool() ) then Photon.RenderDynamicLightQueue() end
end)

local IsValid = IsValid
function Photon:CalculatePixVis( pos, handle, a_radius )
	if not IsValid( self ) then return 0 end
	local radius = a_radius or 1
	return utilPixVis( pos, radius, handle )
end

local EyePos = EyePos
local EyeAngles = EyeAngles
hook.Add( "PostDrawTranslucentRenderables", "Photon.UpdateLocalEyeInfo", function()
	useEyePos:Set( EyePos() )
	useEyeAng:Set( EyeAngles() )
end)

-- concommand.Add( "photon_maxoverride", function( ply ) 
-- 	local ent = ply:GetEyeTrace().Entity
-- 	if not IsValid( ent ) then return end
-- 	ent.Photon_OldDrawModel = ent.Draw
-- 	print("affirm")
-- 	ent.Draw = false
-- 	-- ent.Draw = function( self )
-- 	-- 	print( "called" )
-- 	-- 	render.MaterialOverrideByIndex( 36, "sprites/emv/fs_valor" )
-- 	-- 	self.Photon_OldDrawModel( self )
-- 	-- end
-- end )

-- hook.Add( "PreDrawHalos", "Photon.PleaseFuckingWOrk", function() 
-- 	render.MaterialOverrideByIndex( 0, "sprites/emv/fs_valor" )
-- 	for k,v in pairs( ents.GetAll() ) do
-- 		if not IsValid( v ) then continue end
-- 		if v:GetModel() == "models/lonewolfie/dodge_charger_2015_police.mdl" then
-- 			-- render.MaterialOverrideByIndex( 0, "sprites/emv/fs_valor" )
-- 			-- v:Draw()
-- 			-- print("found")
-- 			-- render.MaterialOverrideByIndex( 36, "" )
-- 		end
-- 	end
-- end )

-- hook.Add( "PreDrawHalos", "Photon.HaloTest", function() 
-- 	local targs = {}
-- 	for k,ent in pairs( ents.GetAll() ) do
-- 		if not IsValid( ent ) then continue end
-- 		if ent:GetModel() == "models/schmal/lwdodch_tail.mdl" then 
-- 			targs[#targs+1] = ent
-- 		end
-- 	end
-- 	halo.Add( targs, Color( 255, 0, 0 ), 5, 5, 2, true, false )
-- 	local targs = {}
-- 	for k,ent in pairs( ents.GetAll() ) do
-- 		if not IsValid( ent ) then continue end
-- 		if ent:GetModel() == "models/schmal/tahoe_rear.mdl" then 
-- 			targs[#targs+1] = ent
-- 		end
-- 	end
-- 	halo.Add( targs, Color( 255, 0, 0 ), 8, 8, 4, true, false )
-- 	local targs = {}
-- 	for k,ent in pairs( ents.GetAll() ) do
-- 		if not IsValid( ent ) then continue end
-- 		if ent:GetModel() == "models/schmal/tdm_cvpi_tail.mdl" then 
-- 			targs[#targs+1] = ent
-- 		end
-- 	end
-- 	halo.Add( targs, Color( 255, 128, 0 ), 5, 5, 1, true, false )
-- 	halo.Add( targs, Color( 255, 0, 0 ), 15, 15, 7, true, false )
-- 	local targs = {}
-- 	for k,ent in pairs( ents.GetAll() ) do
-- 		if not IsValid( ent ) then continue end
-- 		if ent:GetModel() == "models/schmal/lwdodch_head_driver_glw.mdl" then 
-- 			targs[#targs+1] = ent
-- 		end
-- 	end
-- 	halo.Add( targs, Color( 0, 0, 255 ), 8, 8, 1, true, false )
-- 	halo.Add( targs, Color( 200, 220, 255 ), 4, 4, 2, true, false )
-- 	-- halo.Add( targs, Color( 200, 220, 255 ), 4, 4, 5, true, false )
-- end )

-- lua_run BroadcastLua("hook.remove('HudPaint','photonmodelglowtest')")
-- lua_run BroadcastLua("hook.remove('PreDrawHalos','Photon.HaloTest')")

-- hook.Add("HudPaint","photonmodelglowtest",function()
-- 	for k,ent in pairs( ents.GetAll() ) do
-- 		if not IsValid( ent ) then continue end
-- 		if ent:GetModel() == "models/schmal/lwdodch_head_driver_glw.mdl" then
-- 			ent:SetColor( Color( 255, 0, 0 ) )
-- 			ent:SetColor( Color( 255, 0, 0 ) )
-- 			ent:SetColor( Color( 255, 0, 0 ) )
-- 			ent:SetColor( Color( 255, 0, 0 ) )
-- 			ent:SetColor( Color( 255, 0, 0 ) )
-- 			ent:SetColor( Color( 255, 0, 0 ) )
-- 			print("hey")
-- 			ent:DrawModel()
-- 			ent:DrawModel()
-- 			ent:DrawModel()
-- 			ent:DrawModel()
-- 			ent:DrawModel()
-- 			ent:DrawModel()
-- 			ent:DrawModel()
-- 			ent:DrawModel()
-- 			ent:DrawModel()
-- 			ent:DrawModel()
-- 			ent:DrawModel()
-- 			ent:DrawModel()
-- 			ent:DrawModel()
-- 			ent:DrawModel()
-- 			ent:DrawModel()
-- 			ent:DrawModel()
-- 			ent:DrawModel()
-- 			ent:DrawModel()
-- 			ent:DrawModel()
-- 			ent:DrawModel()
-- 			ent:DrawModel()
-- 			ent:DrawModel()
-- 			ent:DrawModel()
-- 			ent:DrawModel()
-- 			ent:DrawModel()
-- 			ent:DrawModel()
-- 			ent:DrawModel()
-- 			ent:DrawModel()
-- 			ent:DrawModel()
-- 			-- ent:SetColor( Color( 255, 255, 255 ) )
-- 		end
-- 	end
-- end)
