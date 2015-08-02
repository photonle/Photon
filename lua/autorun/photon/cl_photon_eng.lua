AddCSLuaFile()

local lpos = Vector()

local clamp = math.Clamp
local pow = math.pow
local round = math.Round
local useEyePos = Vector( 0, 0, 0 )
local useEyeAng = Angle( 0, 0, 0 )

local getLightColor = render.GetLightColor
local utilPixVis = util.PixelVisible
local rotatingLight = true
local pulsingLight = true
local emvHelp = true

hook.Add( "Initialize", "Photon.AddHelperLocalVars", function()
	rotatingLight = EMVU.Helper.RotatingLight
	pulsingLight = EMVU.Helper.PulsingLight
	emvHelp = EMVU.Helper
end)

local isnumber = isnumber
local istable = istable
local pairs = pairs
local ColorAlpha = ColorAlpha
local Lerp = Lerp

local function getViewFlare( dot, brght )
	local dif = dot - .99
	if dif < 0 then return 0 end
	local calc = (dif * 1000) * clamp( brght, 0, 1 )
	return pow( calc, 1.4 ) * .1
end

local setMaterial = render.SetMaterial
local drawSprite = render.DrawSprite

local mat1 = Material("sprites/emv/flare_secondary")
local mat2 = Material("sprites/emv/emv_smoothglow")
local mat3 = Material("sprites/emv/light_initial")
local mat4 = Material("sprites/emv/flare_primary")

local up1 = Vector()

local photonRenderTable = {}

function Photon:AddLightToQueue( lightInfo )
	photonRenderTable[ #photonRenderTable + 1 ] = lightInfo
end

function Photon:ClearLightQueue()
	table.Empty( photonRenderTable )
end

function Photon:PrepareVehicleLight( parent, incolors, ilpos, lang, meta, pixvis, lnum, brght, multicolor )
	if not incolors or not ilpos or not lang or not meta then return end

	local resultTable = { true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true }

	local colors = incolors
	local offset = meta.AngleOffset

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

	local worldPos = Vector()
	local viewDot = 0
	local visible = 0
	local viewPercent = 0

	if meta.AngleOffset and meta.AngleOffset == "RR" then
		local lposMod = EMVU.Helper:RadiusLight( 1, 4 )
		lpos[1] = lpos[1] + lposMod
		lpos[2] = lpos[2] + lposMod
	end
		
	worldPos = parent:LocalToWorld(lpos)

	visible = utilPixVis( worldPos, visRadius, pixvis )
	if( visible and visible > 0) then


	if EMV_DEBUG then visible = 1 end
	if EMV_DEBUG then viewDot = 1 end
	if not visible or visible <= 0 then return end

	
	if not meta.Scale then meta.Scale = 1 end
	if not meta.WMult then meta.WMult = 1 end

	local ca = parent:GetAngles()
	
	ca:RotateAroundAxis(parent:GetUp(), (lang.y + offset))
	local lightNormal = ca:Forward()
	lightNormal:Normalize()

	local ViewNormal = Vector()
	ViewNormal:Set(worldPos)
	ViewNormal:Sub( useEyePos )
	ViewNormal:Normalize()
	viewDot = ViewNormal:Dot( lightNormal )

	if ( viewDot and viewDot >= 0 ) then

		viewPercent = viewDot
		local viewMod = viewDot * 10
		viewDot = pow( viewMod, 1.25 ) * .1

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
			local srcMod = viewDot * .5
			srcColor = ColorAlpha( UC.src, UC.src.a * rawBrightness )
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
		resultTable[11] = meta.Scale * viewDot
		resultTable[12] = meta.Scale * viewFlare
		resultTable[13] = meta.Scale * meta.WMult*viewDot
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


		self:AddLightToQueue( resultTable )
	end
	end
end


local startCam = cam.Start3D2D
local setRenderLighting = render.SetLightingMode
local drawQuad = render.DrawQuad
local endCam = cam.End3D2D

function Photon:QuickDrawNoTable( srcOnly, drawSrc, camPos, camAng, srcSprite, srcT, srcR, srcB, srcL, worldPos, bloomScale, flareScale, widthScale, colSrc, colMed, colAmb, colBlm, colGlw, colRaw, colFlr, lightMod, cheap, viewFlare, debug_mode )
	if drawSrc then
		startCam( camPos, camAng, 1 )
			setRenderLighting( 2 )
			setMaterial( srcSprite )
			drawQuad( srcT, srcR, srcB, srcL, colSrc )
			setRenderLighting( 0 )
		endCam()
	end

	if debug_mode == true then return end
	if not srcOnly then
		setMaterial( mat1 )
		drawSprite( worldPos, (48 * bloomScale), (32 * bloomScale), colGlw )

		setMaterial( mat2 )
		drawSprite( worldPos, (256 * bloomScale), (256 * bloomScale), colAmb )

		setMaterial( mat2 )
		drawSprite( worldPos, (64 * bloomScale), 48 * bloomScale, colBlm )

		setMaterial( mat3 )
		drawSprite( worldPos, 12 * widthScale, 12 * bloomScale, colMed )

		if viewFlare and colFlr and lightMod > .83 and not cheap then

			setMaterial( mat1 )
			drawSprite( worldPos, ( 96 * flareScale), ( 2 * flareScale ), colFlr )

			setMaterial( mat2 )
			drawSprite( worldPos, ( 1024 * flareScale), ( 1024 * flareScale ), colAmb )

			setMaterial( mat4 )
			drawSprite( worldPos, ( 64 * flareScale), ( 64 * flareScale ), colRaw )

		end 
	end

end

local quickDrawNoTable = Photon.QuickDrawNoTable
local cam3d = cam.Start3D
local endCam3d = cam.End3D2D
function Photon:RenderQueue()

	local count = #photonRenderTable
	if ( count > 0 ) then
		local debug_mode = PHOTON_DEBUG
		cam3d( EyePos(), EyeAngles() )
			for i=1, count do
				if photonRenderTable[i] != nil then
					local data = photonRenderTable[i]
					quickDrawNoTable( self, data[1], data[2], data[3], data[4], data[5], data[6], data[7], data[8], data[9], data[10], data[11], data[12], data[13], data[14], data[15], data[16],
											data[17], data[18], data[19], data[20], data[21], data[22], data[23], debug_mode )
				end
			end
		endCam3d()
	end

end
hook.Add( "PreDrawEffects", "Photon.RenderQueue", function() 
	Photon:RenderQueue()
end )

function Photon:CalculatePixVis( lpos, handle, a_radius )
	if not self or not self:IsValid() or not self:IsVehicle() then return 0 end

	local pos = self:LocalToWorld( lpos )
	local radius = 1
	if a_radius then radius = a_radius end

	return util.PixelVisible( pos, radius, handle )
end

local EyePos = EyePos
local EyeAngles = EyeAngles
hook.Add( "PostDrawTranslucentRenderables", "Photon.UpdateLocalEyeInfo", function()
	useEyePos = EyePos()
	useEyeAng = EyeAngles()
end)