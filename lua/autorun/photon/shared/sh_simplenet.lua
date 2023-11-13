--[[-- Regular Simplified Networking.
Easily optimise networking for setting local values on entities.
@copyright Photon Team
@release development
@author Photon Team
@module Photon.SNet
@alias NET
@todo Add Spawn-Sync for all Photon Variables.
--]]--

Photon = Photon or {}
Photon.SNet = Photon.SNet or {}
local NET = Photon.SNet
local ENT = FindMetaTable("Entity")

if SERVER then
	util.AddNetworkString("Photon_SimpleNet_Change")
end

NET.BOOL = 1
NET.INT = 2
NET.UINT = 3
NET.STR = 4

NET.FMap = NET.FMap or {}
NET.RMap = NET.RMap or {}
NET.Bits = math.ceil(math.log(#NET.FMap, 2))

NET.WriteFunctions = {
	[NET.BOOL] = net.WriteBool,
	[NET.INT] = net.WriteInt,
	[NET.UINT] = net.WriteUInt,
	[NET.STR] = net.WriteString
}

NET.ReadFunctions = {
	[NET.BOOL] = net.ReadBool,
	[NET.INT] = net.ReadInt,
	[NET.UINT] = net.ReadUInt,
	[NET.STR] = net.ReadString
}

function NET.Normalise(name)
	return "PhotonNet_" .. name
end

--- Add a network mapping, with a name and type.
-- Adds NET:Set<name> to set the value on an entity and Get<name>.
-- @str name Variable name to use.
-- @int The NET.<TYPE> enum to use.
-- @param[opt] extra Any extra data required for a type.
function NET:Map(name, netType, extra)
	if self.RMap[name] then
		self.FMap[self.RMap[name][1]] = {name, netType, extra}
		self.RMap[name][2] = netType
		self.RMap[name][3] = extra
	else
		self.RMap[name] = {table.insert(self.FMap, {name, netType, extra}), netType, extra}
		self.Bits = math.ceil(math.log(#self.FMap, 2))
	end

	if not self.WriteFunctions[netType] then
		PhotonWarning("Unregistered NetType called!", netType)
	end

	local iName = self.Normalise(name)
	if SERVER then
		self["Set" .. name] = function(env, ent, val)
			env:Set(ent, name, val)
		end
		ENT["Set" .. iName] = function(ent, val)
			self:Set(ent, name, val)
		end
	end

	self["Get" .. name] = function(env, ent, val, default)
		return env:Get(ent, name, val, default)
	end
	ENT["Get" .. iName] = function(ent, val, default)
		return self:Get(ent, name, val, default)
	end
end

if SERVER then
	--- Change a networked entity variable.
	-- @ent ent The entity to change the value on.
	-- @str name The name to change.
	-- @param val Value to set.
	-- @warns name must be pre-registed with NET:Map
	-- @internal
	-- @state server
	function NET:Set(ent, name, val)
		local varName = self.Normalise(name)

		local old = ent[varName]
		if val ~= old then
			ent[varName] = val

			local idx, netType, extra = unpack(self.RMap[name])
			if not idx then
				PhotonError(("Attempted to call SimpleNet:Change with an unregistered name: %s"):format(name))
				return
			end

			net.Start("Photon_SimpleNet_Change")
			net.WriteEntity(ent)
			net.WriteUInt(idx, self.Bits)
			self.WriteFunctions[netType](val, extra)
			net.Broadcast()
		end
	end
end

--- Get the latest cached version of a value on an entity.
-- @ent ent The entity to change the value on.
-- @str name The name to change.
function NET:Get(ent, name, default)
	local v = ent[self.Normalise(name)]
	if v == nil then
		return default
	end

	return v
end

if CLIENT then
	net.Receive("Photon_SimpleNet_Change", function()
		local ent = net.ReadEntity()
		local idx = net.ReadUInt(NET.Bits)
		local name, netType, extra = unpack(NET.FMap[idx])
		local normalName = NET.Normalise(name)
		local old = ent[normalName]
		ent[normalName] = NET.ReadFunctions[netType](extra)
		hook.Run("Photon.SimpleNet.ValueChanged", name, old, ent[normalName], ent)
	end)
end

local UInt, Bool, Str = NET.UINT, NET.BOOL, NET.STR

NET:Map("CurrentSignal", UInt, 2)
NET:Map("Blinker", UInt, 2)
NET:Map("Headlights", Bool)
NET:Map("Braking", Bool)
NET:Map("Reversing", Bool)
NET:Map("Running", Bool)
NET:Map("LEStayOn", Bool)
NET:Map("WheelIndex", UInt, 6) -- 64 wheels

NET:Map("Enabled", Bool)
NET:Map("LightOn", Bool)
NET:Map("LightOption", UInt, 4) -- 16 Lighting Options
NET:Map("SirenOn", Bool)
NET:Map("SirenSet", UInt, 10) -- 1024 Siren Sets
NET:Map("SirenOption", UInt, 4) -- 16 Siren Options
NET:Map("AuxSirenSet", UInt, 10)
NET:Map("TrafficOn", Bool)
NET:Map("TrafficOption", UInt, 4)
NET:Map("IlluminationOn", Bool)
NET:Map("IlluminationOption", UInt, 4)
NET:Map("Preset", UInt, 10)

NET:Map("VehicleIndex", Str)
NET:Map("UnitNumber", Str)
NET:Map("LiveryID", Str)
NET:Map("SelectionString", Str)
