AddCSLuaFile()

-- this is where the magic happens

local lpos = Vector()


local clamp = math.Clamp
local pow = math.pow
local round = math.Round

local getLightColor = render.GetLightColor

local function getViewFlare( dot, brght )
	local dif = dot - .99
	if dif < 0 then return 0 end
	local calc = (dif * 1000) * clamp( brght, 0, 1 )
	return pow( calc, 1.4 ) * .1
end

local setMaterial = render.SetMaterial
local drawSprite = render.DrawSprite

local mat1 = Material("sprites/light_ignorez")
local mat2 = Material("sprites/emv/emv_smoothglow")
local mat3 = Material("sprites/emv/emv_lightglow")
local mat4 = Material("sprites/emv/flare_primary")

local up1 = Vector()


local function CacheLight( self, index, wpos, viewDot )
	self.PhotonLightCache[index] = {
		WorldPos = wpos,
		ViewDot = viewDot,
		LastCache = CurTime()
	}
end

local function GetLightCache( self, index )
	if true then return false end
	if self.PhotonLightCache[index] then 
		if self.PhotonLightCache[index].LastCache + .033 > CurTime() then
			return self.PhotonLightCache[index]
		end
	end
	return false
end

function Photon:DrawLight( incolors, ilpos, lang, meta, pixvis, lnum, brght, multicolor )
	// if true then return end
	if not incolors or not ilpos or not lang or not meta then return end
	local colors = incolors
	local offset = meta.AngleOffset

	lpos:Set( ilpos )
	
	local rotating = false
		
	if offset == "R" or offset == "RR" then -- R indicates a rotating light
		local speed = 2
		if meta.Speed then speed = meta.Speed end
		offset = EMVU.Helper:RotatingLight(speed, 10)
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
	
	if not self.PhotonLightCache then self.PhotonLightCache = {} end

	

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
			lpos.x = lpos.x + lposMod
			lpos.y = lpos.y + lposMod
			
		end
		
	worldPos = self:LocalToWorld(lpos)
	visible = util.PixelVisible( worldPos, visRadius * EMV_PIXVIS_MULTIPLIER, pixvis ) -- this line needs to be run asap to prevent needless calculations below
	//visible = 1
	if EMV_DEBUG then visible = 1 end
	if EMV_DEBUG then viewDot = 1 end
	if not visible or visible <= 0 then return end

	--if EMV_DEBUG or PHOTON_DEBUG then colors.src = Color(255,0,255,255) end -- EMV_DEBUG global is useful for light placement, but is rather buggy to toggle
	if not meta.Scale then meta.Scale = 1 end
	if not meta.WMult then meta.WMult = 1 end

	local ca = self:GetAngles()
	
	ca:RotateAroundAxis(self:GetUp(), (lang.y + offset))
	local lightNormal = ca:Forward()
	lightNormal:Normalize()
	local ViewNormal = worldPos - EyePos()
	local Distance = ViewNormal:Length()
	ViewNormal:Normalize()
	viewDot = ViewNormal:Dot(lightNormal)
	viewPercent = viewDot
	local viewMod = viewDot * 10

	viewDot = math.pow( viewMod, 1.25 ) * .1

	if( visible and visible > 0) and ( viewDot and viewDot >= 0) then

		local curLight = getLightColor( worldPos )
		local lightMod = clamp(1 - round(((( curLight.x * curLight.y * curLight.z ) * .3) * 10) * 2, 5), .66, 1)

		local srcOnly = false
		local srcSkip = false

		if (meta.Sprite and meta.Sprite == "sprites/emv/blank") or meta.Cheap then srcSkip = true end

		local UC = { true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true }

		local brightness = 1
		local rawBrightness = 1
		local pulseOverride = false
		
		if brght and istable(brght) then -- a table in place of the brightness index indicates pulsing light info, which will take over the brightess variable
			brightness = EMVU.Helper:PulsingLight( brght[1], brght[2], brght[3] )
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
		local ua = self:LocalToWorldAngles( al )

		for k,v in pairs( colors ) do -- modifies the alpha of the colors based on the brightness
			UC[k] = v
		end

		local srcColor = Color(255,255,255,255)

		if not srcSkip then
			srcColor.r = UC.src.r
			srcColor.g = UC.src.g
			srcColor.b = UC.src.b
			srcColor.a = UC.src.a * rawBrightness
			if pulseOverride then srcColor.a = ( srcColor.a * brightness ) end
			if istable(UC["dim"]) then
				srcColor.r = Lerp( viewDot, UC.dim.r, UC.src.r )
				srcColor.g = Lerp( viewDot, UC.dim.g, UC.src.g )
				srcColor.b = Lerp( viewDot, UC.dim.b, UC.src.b )
				--srcColor.a = Lerp( viewDot, UC.dim.a, UC.src.a )
			end
		end

		if PHOTON_DEBUG and !PHOTON_DEBUG_EXCLUSIVE then srcColor = Color( 255, 255, 0, 255 ) elseif PHOTON_DEBUG and PHOTON_DEBUG_EXCLUSIVE then srcColor = Color( 0, 0, 0, 0 ) end
		if PHOTON_DEBUG and PHOTON_DEBUG_LIGHT and lpos == PHOTON_DEBUG_LIGHT[1] then srcColor = Color( 0, 255, 255 ) end
		render.SuppressEngineLighting(true)
		cam.Start3D(EyePos(), EyeAngles())

			if not srcSkip then
				cam.Start3D2D(up1, ua, 1)

					render.SetLightingMode( 2 )
					render.SetMaterial(Material(meta.Sprite))
					render.DrawQuad(
						Vector(meta.W/2,meta.H/2,0),
						Vector(-meta.W/2,meta.H/2,0),
						Vector(-meta.W/2,-meta.H/2,0),
						Vector(meta.W/2,-meta.H/2,0),
						srcColor
					)
					render.SetLightingMode( 0 )

					if false then
						local w = 48 * meta.Scale * viewDot
						local h = 32 * meta.Scale * viewDot
						render.SetMaterial( mat1 )
						render.DrawQuad(
							Vector( w*.5, h*.5, 0 ),
							Vector( -w*.5, h*.5, 0 ),
							Vector( -w*.5, -h*.5, 0 ),
							Vector( w*.5, -h*.5, 0 ),
							UC.glw
						)

						w = 256 * meta.Scale * viewDot
						h = 256 * meta.Scale * viewDot
						render.SetMaterial( mat2 )
						render.DrawQuad(
							Vector( w*.5, h*.5, 0 ),
							Vector( -w*.5, h*.5, 0 ),
							Vector( -w*.5, -h*.5, 0 ),
							Vector( w*.5, -h*.5, 0 ),
							UC.amb
						)

						w = 64 * meta.Scale * viewDot
						h = 48 * meta.Scale * viewDot
						render.SetMaterial( mat2 )
						render.DrawQuad(
							Vector( w*.5, h*.5, 0 ),
							Vector( -w*.5, h*.5, 0 ),
							Vector( -w*.5, -h*.5, 0 ),
							Vector( w*.5, -h*.5, 0 ),
							UC.blm
						)

						w = 12 * meta.Scale * viewDot
						h = 12 * meta.Scale * viewDot
						render.SetMaterial( mat3 )
						render.DrawQuad(
							Vector( w*.5, h*.5, 0 ),
							Vector( -w*.5, h*.5, 0 ),
							Vector( -w*.5, -h*.5, 0 ),
							Vector( w*.5, -h*.5, 0 ),
							UC.med
						)
					end


				cam.End3D2D()
			end

			if not PHOTON_DEBUG then -- having these render while trying to place lights is a pain in the ass

			if not srcOnly then

				setMaterial( mat1 )
				drawSprite( worldPos, (48*meta.Scale*viewDot), (32*meta.Scale*viewDot), UC.glw )

				setMaterial( mat2 )
				drawSprite( worldPos, (256*meta.Scale*viewDot), (256*meta.Scale*viewDot), UC.amb )

				setMaterial( mat2 )
				drawSprite( worldPos, (64*meta.Scale*viewDot), 48*meta.Scale*viewDot, UC.blm )

				setMaterial( mat3 )
		 		drawSprite( worldPos, 12*meta.Scale*meta.WMult*viewDot, 12*meta.Scale*viewDot, UC.med )

		 		if viewFlare and UC["flr"] and lightMod > .83 and not cheapLight then
		 			setMaterial( mat1 )
					drawSprite( worldPos, ( 96 * meta.Scale * viewFlare), ( 2 * meta.Scale * viewFlare ), UC.flr )

					setMaterial( mat2 )
					drawSprite( worldPos, ( 1024 * meta.Scale * viewFlare), ( 1024 * meta.Scale * viewFlare ), UC.amb )

					setMaterial( mat4 )
					drawSprite( worldPos, ( 64 * meta.Scale * viewFlare), ( 64 * meta.Scale * viewFlare ), UC.raw )

					-- render.SetMaterial( Material("sprites/emv/glare_overlay") )
					-- render.DrawScreenQuad()
					-- draw.TexturedQuad( {
					-- 	texture = surface.GetTextureID( "sprites/emv/glare_overlay" ),
					-- 	color = Color(255,0,0,255),
					-- 	x = 0,
					-- 	y = 0,
					-- 	w = ScrW(),
					-- 	h = ScrH()
					-- } )

		 		end
		 		
		 	end

		 	end

		cam.End3D()
		render.SuppressEngineLighting(false)

	end

	-- This is a shitty experiment with dynamic light placement.
	-- It's highly inefficient, but use at your own risk.
	-- Keep in mind dyanamic lights murder your FPS, so that's why I do not use them.

	-- local col = colors.blm
	-- local dlight = DynamicLight( lnum )

 --    if ( dlight ) then
 --    	if col.r == 255 and col.g == 255 and col.b == 255 then return end
 --        --dlight.Dir = self:GetAngles():Right()
 --        -- dlight.OuterAngle = Vector(.5,0,0)
 --        -- dlight.InnerAngle = Vector(.5,0,0)

 --        local ap = Vector()
	-- 	ap:Set(lpos)
	-- 	--ap.z = ap.z - (meta.H/2) + .1

	-- 	local al = Angle()
	-- 	al:Set(lang)
	-- 	al.r = al.r + 90
	-- 	if rotating then al.y = offset - 90 end
	-- 	local up1 = self:LocalToWorld(ap)
	-- 	local ua = self:LocalToWorldAngles(al)
	-- 	ua.y = ua.y - 90
 --        local dpos = Vector()
 --        dpos:Set(pos)
 --        dpos = dpos + ua:Forward() * 50
 --        dpos.z = dpos.z
 --        dlight.Pos = dpos
 --        dlight.r = col.r
 --        dlight.g = col.g
 --        dlight.b = col.b
 --        dlight.Brightness = 2
 --        dlight.Decay = 0
 --        dlight.Size = (200*meta.Scale)
 --        dlight.DieTime = CurTime() + .06
 --        dlight.NoModel = true -- unless you want to turn the car into a pink-ass piece of shit, I suggest you leave this
 --    end

end

function Photon:CalculatePixVis( lpos, handle, a_radius )
	if not self or not self:IsValid() or not self:IsVehicle() then return 0 end

	local pos = self:LocalToWorld( lpos )
	local radius = 1
	if a_radius then radius = a_radius end

	return util.PixelVisible( pos, radius, handle )
	//return 1
end