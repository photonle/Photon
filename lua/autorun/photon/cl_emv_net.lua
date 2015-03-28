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