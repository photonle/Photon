AddCSLuaFile()

local col_White = Color( 255, 255, 255 )
local col_Orange = Color( 255, 155, 66 )
local col_GrayLight = Color( 255, 255, 255, 24 )
local col_GrayDark = Color( 0, 0, 0, 84 )
local col_Red = Color( 246, 58, 43 )
local col_Green = Color( 153, 226, 75 )

surface.CreateFont( "Photon_Title", {
	font = "Roboto",
	size = 15,
	weight = 900,
} )

surface.CreateFont( "Photon_WarningMode", {
	font = "Roboto",
	size = 17,
	weight = 1000,
} )

surface.CreateFont( "Photon_ButtonText", {
	font = "Roboto",
	size = 10,
	weight = 1000,
} )

local width = 200
local height = 304

local scrW = ScrW()
local scrH = ScrH()

local bgPosX = scrW - width
local bgPosY = scrH - height

local bgColor = Color( 16, 16, 16, 204 )
local bgPaddingLeft = bgPosX + 14

local icon_button = Material( "photon/ui/panel_button.png", "unlitgeneric" )
local icon_button_active = Material( "photon/ui/panel_button_active.png", "unlitgeneric")
local icon_button_down = Material( "photon/ui/panel_button_down.png", "unlitgeneric")

local icon_index = {
	["siren_wail"] = Material( "photon/ui/panel_icon_wail.png", "unlitgeneric" ),
	["siren_yelp"] = Material( "photon/ui/panel_icon_yelp.png", "unlitgeneric" ),
	["siren_phaser"] = Material( "photon/ui/panel_icon_phaser.png", "unlitgeneric" ),
	["siren_hilo"] = Material( "photon/ui/panel_icon_hilo.png", "unlitgeneric" ),

	["func_horn"] = Material( "photon/ui/panel_icon_horn.png", "unlitgeneric" ),
	["func_manual"] = Material( "photon/ui/panel_icon_manual.png", "unlitgeneric" ),
	["func_blackout"] = Material( "photon/ui/panel_icon_blackout.png", "unlitgeneric" ),

	["illum_takedown"] = Material( "photon/ui/panel_icon_takedown.png", "unlitgeneric" ),
	["illum_left"] = Material( "photon/ui/panel_icon_alley_left.png", "unlitgeneric" ),
	["illum_right"] = Material( "photon/ui/panel_icon_alley_right.png", "unlitgeneric" ),
	["illum_lamp"] = Material( "photon/ui/panel_icon_lamp.png", "unlitgeneric" ),
}

local storedData = {}

local function drawBackground()
	draw.RoundedBoxEx( 2, bgPosX, bgPosY, width, height, bgColor, true )
end

local function drawTitle( text, yOffset )
	draw.DrawText( text, "Photon_Title", bgPaddingLeft, yOffset, col_Orange, TEXT_ALIGN_LEFT)
	draw.RoundedBox( 0, bgPosX + 124, yOffset + 6, 100, 1, col_GrayLight )
	draw.RoundedBox( 0, bgPosX + 124, yOffset + 9, 100, 1, col_GrayLight )
end

local function drawTitle2( text, x, y )
	draw.DrawText( text, "Photon_Title", x, y, col_White, TEXT_ALIGN_LEFT)
end

local function drawButton( text, icon, state, x, y )
	surface.SetDrawColor( 255, 255, 255 )
	if state == 1 then surface.SetMaterial( icon_button ) elseif state == 3 then surface.SetMaterial( icon_button_active ) elseif state == 2 then surface.SetMaterial( icon_button_down ) end
	surface.DrawTexturedRect( x - 32, y - 32, 64, 64 )
	local ledColor = col_GrayLight
	if state == 3 then ledColor = col_Red elseif state == 2 then ledColor = col_Green end
	draw.RoundedBox( 2, x - 2, y - 27, 4, 4, ledColor )
	local modeColor = col_GrayLight
	if state == 3 then modeColor = col_Green elseif state == 2 then modeColor = col_Red end
	if text then
		draw.DrawText( text, "Photon_ButtonText", x, y + 3, modeColor, TEXT_ALIGN_CENTER )
	end
	if state == 1 then surface.SetDrawColor( col_GrayLight ) elseif state == 3 then surface.SetDrawColor( col_Green ) elseif state == 2 then surface.SetDrawColor( col_Red ) end
	if icon and icon_index[icon] then
		surface.SetMaterial( icon_index[icon] )
		surface.DrawTexturedRect( x - 16, y - 16, 32, 32 )
	end
end

local function drawWarnMode( text, x, y, isOn )
	local textColor = col_GrayLight
	if isOn then textColor = col_White end
	if not text or text == "[NONE]" then textColor = col_GrayLight end
	draw.DrawText( text, "Photon_WarningMode", x, y, textColor, TEXT_ALIGN_LEFT )
end

local function drawWarningLights( x, y, priName, priMode, priMax, priOn, auxName, auxAni )
	local yOrigin = y
	local xOrigin = x

	drawTitle( "WARNING LIGHTS", y )
	y = y + 22
	drawTitle2( "PRIMARY", x, y )
	
	y = y + 18
	local maxPrimaryWidth = 72
	local primaryHeight = 4
	local margin = 2
	local nodeSize = math.Round( ( maxPrimaryWidth - (margin * priMax) ) / priMax )
	local xDrawRef = x
	for i=1,priMax do
		local drawColor = col_GrayDark
		if i == priMode and priOn then
			if i == priMax then drawColor = col_Red
			elseif i == 1 then drawColor = col_Green
			else drawColor = col_Orange end
		end
		draw.RoundedBox( 2, xDrawRef, y, nodeSize, primaryHeight, drawColor )
		xDrawRef = xDrawRef + nodeSize + margin
	end

	y = y + 6
	drawWarnMode( priName, x, y, priOn )

	y = yOrigin + 22
	x = xOrigin + 100
	drawTitle2( "AUXILIARY", x, y )

	y = y + 18
	margin = 5
	xDrawRef = x
	local drawRadius = 4
	for i=1,8 do
		draw.RoundedBox( 2, xDrawRef, y, drawRadius, drawRadius, col_GrayDark )
		xDrawRef = xDrawRef + drawRadius + margin
	end
	y = y + 6
	drawWarnMode( auxName or "NONE", x, y, (auxAni == 0 or false) )

end

local function drawButtonRow( title, btnData, x, y )
	drawTitle( title, y )
	y = y + 48
	x = x + 16
	local margin = 14
	local width = 32
	local drawX = x
	for i=1,#btnData do
		local button = btnData[i]
		drawButton( button[1], button[2], button[3], drawX, y )
		drawX = drawX + width + margin
	end
end

local function drawSirenSection( sirens, x, y )
	drawButtonRow( "SIREN", sirens, x, y )
end

local function drawIllumSection( illum, x, y )
	drawButtonRow( "ILLUMINATION", illum, x, y )
end

local function drawFuncSection( funcdata, x, y )
	drawButtonRow( "FUNCTIONS", funcdata, x, y )
end

local sirens = {
	[1] = { "WAIL", "siren_wail", 3 },
	[2] = { "YELP", "siren_yelp", 1 },
	[3] = { "PIER", "siren_phaser", 1 },
	[4] = { "HILO", "siren_hilo", 1 },
}

local illum = {
	[1] = { "LEFT", "illum_left", 1 },
	[2] = { "TKDN", "illum_takedown", 1 },
	[3] = { "RGHT", "illum_right", 3 },
	[4] = { "LAMP", "illum_lamp", 1 },
}

local funcdata = {
	[1] = { "HORN", "func_horn", 1 },
	[2] = { "MAN", "func_manual", 1 },
	[3] = { nil, "func_blackout", 3 },
}

local function NewPhotonHUD()
	drawBackground()
	drawWarningLights( bgPaddingLeft, bgPosY + 10, "CODE 1", 4, 4, true, false, false )
	local yDist = 74
	local yRef = bgPosY + 80
	drawSirenSection( sirens, bgPaddingLeft, yRef )
	yRef = yRef + yDist
	drawIllumSection( illum, bgPaddingLeft, yRef )
	yRef = yRef + yDist
	drawFuncSection( funcdata, bgPaddingLeft, yRef )
end
hook.Add( "HUDPaint", "Photon.NewHudePaint", function()
	NewPhotonHUD()
end)
