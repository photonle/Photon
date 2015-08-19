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

function EMVU.Net:Livery( category, index )
	net.Start( "emvu_livery" )
		net.WriteString( category )
		net.WriteString( index )
		net.WriteString( unitid_pref:GetString() or "" )
	net.SendToServer()
end

function EMVU.Net:ReceiveLiveryUpdate( id, unit, ent )
	Photon.AutoLivery.Apply( id, unit, ent )
end
net.Receive( "photon_liveryupdate", function() 
	EMVU.Net:ReceiveLiveryUpdate( net.ReadString(), net.ReadString(), net.ReadEntity() )
end)