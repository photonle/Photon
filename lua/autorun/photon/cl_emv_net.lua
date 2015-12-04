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

function EMVU.Net:SirenSet( arg )
	net.Start( "emvu_sirenset" )
		net.WriteInt( arg, 8 )
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
	PrintTable( received )
end
net.Receive( "photon_availableskins", function() EMVU.Net.ReceiveAvailableSkins() end)

function EMVU.Net.ApplyAutoSkin( ent, skin )
	net.Start( "photon_setautoskin" )
		net.WriteEntity( ent )
		net.WriteString( skin )
	net.SendToServer()
end