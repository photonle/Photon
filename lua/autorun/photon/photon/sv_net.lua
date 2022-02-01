--[[-- Regular Lighting Networking
@copyright Photon Team
@release development
@author Photon Team
@module Photon.Net
@alias ENT
--]]--

Photon = Photon or {}
Photon.Net = Photon.Net or {}

local NET = Photon.Net

local function send(to)
	if not to then
		net.Broadcast()
	else
		net.Send(to)
	end
end

util.AddNetworkString("Photon_SignalChanged")

function NET.SignalChanged(car, signal, to)
	net.Start("Photon_SignalChanged")
	net.WriteEntity(car)
	net.WriteUInt(signal, 2) -- 0 to 3
	send(to)
end
