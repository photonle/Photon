AddCSLuaFile()

surface.CreateFont( "EMV_Title", {
	font = "Arial Black",
	size = 16,
	weight = 900,
} )

surface.CreateFont( "EMV_Switch", {
	font = "Arial Black",
	size = 16,
	weight = 900,
} )

surface.CreateFont( "EMV_Detail", {
	font = "Arial",
	size = 14,
	weight = 300,
} )

surface.CreateFont( "EMV_SS", {
	font = "Arial",
	size = 11,
	weight = 300,
} )

surface.CreateFont( "EMV_TRI_OFF", {
	font = "Arial",
	size = 12,
	weight = 300
} )

surface.CreateFont( "EMV_TRI_ON", {
	font = "Arial",
	size = 12,
	weight = 300
} )

local arrow_right = Material( "photon/ui/arrow_right.png", "unlitgeneric" )
local arrow_left = Material( "photon/ui/arrow_left.png", "unlitgeneric" )
local hazard_icon = Material( "photon/ui/hazard.png", "unlitgeneric" )
local headlight_icon = Material( "photon/ui/headlights.png", "unlitgeneric" )

local bX = ScrW() - 160
local bY = ScrH() - 160

local function EMV_Hud()

	if not LocalPlayer():InVehicle() or not LocalPlayer():GetVehicle():HasELS() then return end
	local EMV = LocalPlayer():GetVehicle()
	local srSET = EMV:SirenSet()
	local elOPT = EMV:LightOption()
	if not elOPT then elOPT = 1 end
	if not EMV:ELS_GetSequenceName() then error("Could not get sequence name: " .. tostring( EMV:ELS_GetSequenceName() )) return end
	local lightName = EMV:ELS_GetSequenceName()
	if not lightName then lightName = "UNKNOWN" end
	local srOPT = EMV:SirenOption()
	if not srOPT then srOPT = 1 end
	local sirenName = ""
	if not EMV:NoSiren() then sirenName = EMVU.Sirens[srSET]["Set"][srOPT]["Name"] end
	if not sirenName then sirenName = "UNKNOWN" end

	local sirenSet = ""
	if not EMV:NoSiren() then sirenSet = EMVU.Sirens[srSET]["Name"] end
	if not sirenSet then sirenSet = "" end

	local illumOpt = ""
	if EMV:HasIllum() then illumOpt = tostring( EMVU.Helper:GetIlluminationName( EMV.VehicleName, EMV:IllumOption() ) ) end
	
	local trafficOpt = ""
	if EMV:HasTrafficAdvisor() then trafficOpt = tostring( EMVU.Helper:GetTrafficAdvisorName( EMV.VehicleName, EMV:TrafficAdvisorOption() )) end

	local heightMin = 160
	if EMV:HasIllum() then heightMin = heightMin + 40 end
	if EMV:HasTrafficAdvisor() then heightMin = heightMin + 40 end
	bY = ScrH() - heightMin

	if PHOTON_HUD_Y then bY = PHOTON_HUD_Y end 

	local rX = bX
	local rY = bY

	if not EMV:NoSiren() then
		local height = 124
		if EMV:HasIllum() then height = height + 40 end
		if EMV:HasTrafficAdvisor() then height = height + 40 end
		draw.RoundedBox(4, rX, rY, 164, height, Color(24,24,24,200))
	else
		draw.RoundedBox(4, rX, rY, 164, 48, Color(24,24,24,200))
		rY = rY - 47
	end

	if not EMV:NoSiren() then draw.DrawText( "SIREN", "EMV_Title", rX + 10, rY + 8, Color(255,255,255,255), TEXT_ALIGN_LEFT) end -- SIREN title

	draw.DrawText( "LIGHTS", "EMV_Title", rX + 10, rY + 55, Color(255,255,255,255), TEXT_ALIGN_LEFT) -- LIGHTS title

	if not EMV:NoSiren() then 
		draw.DrawText( sirenSet, "EMV_SS", rX + 10, rY + 23, Color(128,128,128), TEXT_ALIGN_LEFT) -- siren name
		draw.DrawText( sirenName, "EMV_Detail", rX + 12, rY + 33, Color(255,145,106), TEXT_ALIGN_LEFT)
	end -- siren name

	draw.DrawText( lightName, "EMV_Detail", rX + 12, rY + 70, Color(255,145,106), TEXT_ALIGN_LEFT) -- lights name

	local rYb = 0

	if EMV:HasTrafficAdvisor() then 
		draw.DrawText( trafficOpt, "EMV_Detail", rX + 12, rY + 112 + rYb, Color(255,145,106), TEXT_ALIGN_LEFT )
		draw.DrawText( "TRAFFIC", "EMV_Title", rX + 10, rY + 96 + rYb, Color(255,255,255,255), TEXT_ALIGN_LEFT)
		rYb = rYb + 40
	end

	if EMV:HasIllum() then 
		draw.DrawText( illumOpt, "EMV_Detail", rX + 12, rY + 112 + rYb, Color(255,145,106), TEXT_ALIGN_LEFT) -- illum name
		draw.DrawText( "ILLUM", "EMV_Title", rX + 10, rY + 96 + rYb, Color(255,255,255,255), TEXT_ALIGN_LEFT)
		rYb = rYb + 40
	end

	rX = rX + 100
	rY = rY + 18
	if not EMV:NoSiren() then 
		draw.RoundedBox(4, rX, rY, 52, 24, Color(24,24,24,255))
		if EMV:Siren() then
			draw.RoundedBox(2, rX + 4, rY + 4, 16, 16, Color(136,210,104,255))
			draw.DrawText("ON", "EMV_Switch", rX + 27, rY + 4, Color(255,255,255,255), TEXT_ALIGN_LEFT)
		else
			draw.RoundedBox(2, rX + 32, rY + 4, 16, 16, Color(255,255,255,50))
			draw.DrawText("OFF", "EMV_Switch", rX + 5, rY + 4, Color(255,255,255,255), TEXT_ALIGN_LEFT)
		end
	end

	rY = rY + 42
	draw.RoundedBox(4, rX, rY, 52, 24, Color(24,24,24,255))
	if EMV:Lights() then
		draw.RoundedBox(2, rX + 4, rY + 4, 16, 16, Color(136,210,104,255))
		draw.DrawText("ON", "EMV_Switch", rX + 27, rY + 4, Color(255,255,255,255), TEXT_ALIGN_LEFT)
	else
		draw.RoundedBox(2, rX + 32, rY + 4, 16, 16, Color(255,255,255,50))
		draw.DrawText("OFF", "EMV_Switch", rX + 5, rY + 4, Color(255,255,255,255), TEXT_ALIGN_LEFT)
	end

	if EMV:HasTrafficAdvisor() then

		rY = rY + 40
		draw.RoundedBox( 4, rX, rY, 52, 24, Color(24,24,24,255))
		if EMV:TrafficAdvisor() then
			draw.RoundedBox(2, rX + 4, rY + 4, 16, 16, Color(136,210,104,255))
			draw.DrawText("ON", "EMV_Switch", rX + 27, rY + 4, Color(255,255,255,255), TEXT_ALIGN_LEFT)
		else
			draw.RoundedBox(2, rX + 32, rY + 4, 16, 16, Color(255,255,255,50))
			draw.DrawText("OFF", "EMV_Switch", rX + 5, rY + 4, Color(255,255,255,255), TEXT_ALIGN_LEFT)
		end

	end

	if EMV:HasIllum() then

		rY = rY + 40
		draw.RoundedBox( 4, rX, rY, 52, 24, Color(24,24,24,255))
		if EMV:Illumination() then
			draw.RoundedBox(2, rX + 4, rY + 4, 16, 16, Color(136,210,104,255))
			draw.DrawText("ON", "EMV_Switch", rX + 27, rY + 4, Color(255,255,255,255), TEXT_ALIGN_LEFT)
		else
			draw.RoundedBox(2, rX + 32, rY + 4, 16, 16, Color(255,255,255,50))
			draw.DrawText("OFF", "EMV_Switch", rX + 5, rY + 4, Color(255,255,255,255), TEXT_ALIGN_LEFT)
		end

	end

	if not EMV:NoSiren() then 

	draw.RoundedBox( 0, bX, rY + 35, 160, 21, Color(24,24,24,255))

		if EMV.IsRunning and EMV:IsRunning() then
			draw.DrawText("BLKOUT", "EMV_TRI_OFF", bX + 12, rY + 40, Color(255,255,255,50), TEXT_ALIGN_LEFT)
		else
			draw.DrawText("BLKOUT", "EMV_TRI_ON", bX + 12, rY + 40, Color(136,210,104,255), TEXT_ALIGN_LEFT)
		end

		if EMV.ManualHorn and EMV:ManualHorn() then
			draw.DrawText("HORN", "EMV_TRI_OFF", bX + 71, rY + 40, Color(136,210,104,255), TEXT_ALIGN_LEFT)
		else
			draw.DrawText("HORN", "EMV_TRI_OFF", bX + 71, rY + 40, Color(255,255,255,50), TEXT_ALIGN_LEFT)
		end

		if EMV.ManualSiren and EMV:ManualSiren() then
			draw.DrawText("MAN", "EMV_TRI_OFF", bX + 126, rY + 40, Color(136,210,104,255), TEXT_ALIGN_LEFT)
		else
			draw.DrawText("MAN", "EMV_TRI_OFF", bX + 126, rY + 40, Color(255,255,255,50), TEXT_ALIGN_LEFT)
		end

	end

end
//hook.Add("HUDPaint", "EMV_Draw_HUD", EMV_Hud)

function PhotonHUD()
	if not LocalPlayer():InVehicle() or not LocalPlayer():GetVehicle():Photon() then return end
	local car = LocalPlayer():GetVehicle()

	rX = bX
	if PHOTON_HUD_Y then bY = PHOTON_HUD_Y end 
	if not car:HasELS() then 
		if PHOTON_HUD_Y then bY = PHOTON_HUD_Y else bY = ScrH() - 48 end 
	end
	rY = bY - 48

	draw.RoundedBox( 4, rX, rY, 164, 32, Color(24, 24, 24, 200) )

	if (car:TurningLeft() or car:Hazards()) and car:BlinkOn() then
		surface.SetDrawColor( 136, 210, 104 )
	else
		surface.SetDrawColor( 255, 255, 255, 40 )
	end
	surface.SetMaterial( arrow_left )
	surface.DrawTexturedRect( rX, rY, 32, 32 )

	if (car:TurningRight() or car:Hazards()) and car:BlinkOn()  then
		surface.SetDrawColor( 136, 210, 104 )
	else
		surface.SetDrawColor( 255, 255, 255, 40 )
	end
	surface.SetMaterial( arrow_right )
	surface.DrawTexturedRect( rX + 160 - 32, rY, 32, 32 )

	if car:HeadlightsOn() then
		surface.SetDrawColor( 149, 206, 255 )
	else
		surface.SetDrawColor( 255, 255, 255, 40 )
	end
	surface.SetMaterial( headlight_icon )
	surface.DrawTexturedRect( rX + 38, rY - 1, 32, 32 )

	if car:Hazards() and not car:BlinkOn() then
		surface.SetDrawColor( 255, 145, 106 )
	else
		surface.SetDrawColor( 255, 255, 255, 40 )
	end
	surface.SetMaterial( hazard_icon )
	surface.DrawTexturedRect( rX + 86, rY, 32, 32 )
end
//hook.Add("HUDPaint", "PHOTON_Draw_HUD", PhotonHUD)