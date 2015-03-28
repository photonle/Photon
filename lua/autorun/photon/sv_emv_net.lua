util.AddNetworkString( "emvu_add" )
util.AddNetworkString( "emvu_siren" )
util.AddNetworkString( "emvu_el" )
util.AddNetworkString( "emvu_load" )
util.AddNetworkString( "emvu_sirenset" )
util.AddNetworkString( "emvu_illum" )
util.AddNetworkString( "emvu_blackout" )
util.AddNetworkString( "emvu_horn" )
util.AddNetworkString( "emvu_manual" )
util.AddNetworkString( "emvu_traffic" )
util.AddNetworkString( "photon_signal" )
util.AddNetworkString( "photon_menu" )

EMVU.Net = {}

function EMVU.Net:Lights( ply, args )
	if not ply:InVehicle() then return end
	local emv = ply:GetVehicle()
	if not emv:IsEMV() then return end
	if args == "on" then
		emv:ELS_LightsOn()
	elseif args == "off" then
		emv:ELS_LightsOff()
	elseif args == "tog" then
		emv:ELS_LightsToggle()
	end
end
net.Receive("emvu_el", function(len, ply)
	EMVU.Net:Lights( ply, net.ReadString() )
end)

function EMVU.Net:Siren( ply, args )
	local emv = ply:GetVehicle()
	if not emv:IsEMV() then return end
	if args == "on" then
		emv:ELS_SirenOn()
	elseif args == "off" then
		emv:ELS_SirenOff()
	elseif args == "tog" then
		emv:ELS_SirenToggle()
	elseif args == "hon" then
		emv:ELS_HornOn()
	elseif args == "hoff" then
		emv:ELS_HornOff()
	end
end
net.Receive("emvu_siren", function( len, ply )
	EMVU.Net:Siren( ply, net.ReadString() )
end)

function EMVU.Net:Illumination( ply, args )
	local emv = ply:GetVehicle()
	if not emv:IsEMV() then return end
	if args=="on" then
		emv:ELS_IllumOn()
	elseif args == "off" then
		emv:ELS_IllumOff()
	elseif args == "tog" then
		emv:ELS_IllumToggle()
	end
end
net.Receive("emvu_illum", function( len, ply ) 
	EMVU.Net:Illumination( ply, net.ReadString() )
end)

function EMVU.Net:Traffic( ply, args )
	local emv = ply:GetVehicle()
	if not emv:IsEMV() then return end
	if args == "on" then
		emv:ELS_TrafficOn()
	elseif args == "off" then
		emv:ELS_TrafficOff()
	elseif args == "tog" then
		emv:ELS_TrafficToggle()
	end
end
net.Receive( "emvu_traffic", function (len, ply )
	EMVU.Net:Traffic( ply, net.ReadString() )
end)

function EMVU.Net:SirenSet( ply )
	if not ply:InVehicle() or not ply:GetVehicle():IsEMV() then return end
	local emv = ply:GetVehicle()
	local recv = net.ReadInt(8)
	if recv != 0 then emv:ELS_SetSirenSet(recv) return end
	emv:ELS_SirenSetToggle()
end
net.Receive("emvu_sirenset", function( len, ply )
	EMVU.Net:SirenSet( ply )
end)

function EMVU.Net:Blackout( ply, arg )
	if not ply:InVehicle() or not ply:GetVehicle():IsEMV() then return end
	local emv = ply:GetVehicle()
	emv:ELS_Blackout( arg )
end
net.Receive( "emvu_blackout", function( len, ply ) 
	EMVU.Net:Blackout( ply, tobool( net.ReadBit() ) )
end)

function EMVU.Net:Horn( ply, arg )
	if not ply:InVehicle() or not ply:GetVehicle():IsEMV() then return end
	local emv = ply:GetVehicle()
	emv:ELS_Horn( arg )
end
net.Receive( "emvu_horn", function( len, ply ) 
	EMVU.Net:Horn( ply, tobool( net.ReadBit() ))
end)

function EMVU.Net:Manual( ply, arg )
	if not ply:InVehicle() or not ply:GetVehicle():IsEMV() then return end
	local emv = ply:GetVehicle()
	emv:ELS_ManualSiren( arg )
end
net.Receive( "emvu_manual", function( len, ply ) 
	EMVU.Net:Manual( ply, tobool( net.ReadBit() ))
end)

function Photon.Net:Signal( ply )
	if not ply:InVehicle() or not ply:GetVehicle():Photon() then return end
	local car = ply:GetVehicle()
	local signal = net.ReadInt(3)
	if not signal == CAR_TURNING_LEFT or not signal == CAR_TURNING_RIGHT or not signal == CAR_HAZARD then return false end
	if signal == car:CAR_Signal() then car:CAR_StopSignals() return end
	car:CAR_Signal( signal )
end
net.Receive("photon_signal", function( l,p )
	Photon.Net:Signal( p )
end)

function Photon.Net:OpenMenu( ply )
	if not IsValid( ply ) then return end
	net.Start( "photon_menu" )
	net.Send( ply )
end

local function PhotonMenuCheck( ply, txt )
	if txt=="!photon" then Photon.Net:OpenMenu( ply ); return "" end
end
hook.Add( "PlayerSay", "Photon.MenuCheck", PhotonMenuCheck )

concommand.Add( "photon_stick", function( ply, cmd, args )
	if not IsValid( ply ) or not ply:IsAdmin() then return end
	local car = ply:GetVehicle()
	if not IsValid( car ) or not car:Photon() then return end
	car:StayOn( !car:StayOn() )
end )