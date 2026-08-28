--- Regular Simplified Networking.
--- Easily optimise networking for setting local values on entities.
---
--- Registering a variable with `Photon.SNet:Map` generates a matching setter and
--- getter on both this table and the `Entity` metatable, and networks every
--- change to it automatically. The generated entity methods are listed on the
--- Entity page.
--- @copyright Photon Team
--- @release development
--- @author Photon Team
--- @namespace Photon.SNet
--- @state shared

Photon = Photon or {}

-- Declared local-first, then published, rather than the other way round: LuaLS
-- only attributes `function NET:X()` to a table it can name when the local *is*
-- the definition, so `Photon.SNet = Photon.SNet or {} ; local NET = Photon.SNet`
-- leaves every method on this table invisible to the docs build and to editors.
-- Same two references to the same table either way. Kept a blank line clear of
-- the annotation below so it stays an aside rather than becoming its blurb.

--- @class Photon.SNet
local NET = Photon.SNet or {}
Photon.SNet = NET

local ENT = FindMetaTable("Entity")

if SERVER then
	util.AddNetworkString("Photon_SimpleNet_Change")
	util.AddNetworkString("Photon_SimpleNet_RequestSync")
	util.AddNetworkString("Photon_SimpleNet_Resync")
end

--- The wire types a variable can be registered as, passed to `Photon.SNet:Map`.
--- Each one picks the `net` library reader/writer pair the value is sent with.
--- @section Network Types
--- @alias PhotonNetType
---| `Photon.SNet.BOOL`
---| `Photon.SNet.INT`
---| `Photon.SNet.UINT`
---| `Photon.SNet.STR`

--- A boolean, sent as one bit. Takes no extra data.
--- @state shared
NET.BOOL = 1
--- A signed integer. The extra data is its bit width.
--- @state shared
NET.INT = 2
--- An unsigned integer. The extra data is its bit width.
--- @state shared
NET.UINT = 3
--- A string, sent null-terminated. Takes no extra data.
--- @state shared
NET.STR = 4
NET.FLOAT = 5

--- Bit width needed to index a table of `count` entries, one-based.
--- @param count integer Number of registered entries.
--- @return integer bits Bit width.
--- @internal
--- @state shared
--- @section Registration
local function IndexBits(count)
	return math.max(1, math.ceil(math.log(count + 1, 2)))
end

--- Registered variables by index, as `{name, netType, extra}`. This is the
--- order indices are sent in, so an entry's position is part of the wire
--- format for as long as both realms are running the same build.
--- @type table<integer, table>
--- @internal
--- @state shared
NET.FMap = NET.FMap or {}

--- Registered variables by name, as `{index, netType, extra}` — the reverse of
--- `Photon.SNet.FMap`.
--- @type table<string, table>
--- @internal
--- @state shared
NET.RMap = NET.RMap or {}

--- Bit width currently needed to send a variable index, kept in step with
--- `Photon.SNet.FMap` by `Photon.SNet:Map`.
--- @type integer
--- @internal
--- @state shared
NET.Bits = IndexBits(#NET.FMap)

--- The `net` writer used for each `PhotonNetType`.
--- @type table<integer, function>
--- @internal
--- @state shared
NET.WriteFunctions = {
	[NET.BOOL] = net.WriteBool,
	[NET.INT] = net.WriteInt,
	[NET.UINT] = net.WriteUInt,
	[NET.STR] = net.WriteString,
	[NET.FLOAT] = net.WriteFloat
}

--- The `net` reader used for each `PhotonNetType`.
--- @type table<integer, function>
--- @internal
--- @state shared
NET.ReadFunctions = {
	[NET.BOOL] = net.ReadBool,
	[NET.INT] = net.ReadInt,
	[NET.UINT] = net.ReadUInt,
	[NET.STR] = net.ReadString,
	[NET.FLOAT] = net.ReadFloat
}

--- The key a registered variable is cached under on an entity.
--- @param name string Registered variable name.
--- @return string key The prefixed field name, e.g. `PhotonNet_SirenOn`.
--- @state shared
function NET.Normalise(name)
	return "PhotonNet_" .. name
end

--- Register a variable to be networked, under a name and a wire type.
---
--- Generates four accessors for it: `Photon.SNet:Set<name>(ent, value)` and
--- `ent:SetPhotonNet_<name>(value)` on the server, and `Photon.SNet:Get<name>`
--- and `ent:GetPhotonNet_<name>` on both realms. Re-registering an existing
--- name updates its type in place and keeps its index, so the wire format does
--- not shift under a client that is already connected.
--- @param name string Variable name to use.
--- @param netType PhotonNetType The wire type to send the value as.
--- @param extra integer? Bit width, for `Photon.SNet.INT` and `Photon.SNet.UINT`; unused by the others.
--- @warning Both realms have to register the same names in the same order:
--- indices are what go over the wire, not names.
--- @state shared
--- @example Photon.SNet:Map("SirenOn", Photon.SNet.BOOL)
---  Photon.SNet:Map("SirenSet", Photon.SNet.UINT, 10)
function NET:Map(name, netType, extra)
	if self.RMap[name] then
		self.FMap[self.RMap[name][1]] = {name, netType, extra}
		self.RMap[name][2] = netType
		self.RMap[name][3] = extra
	else
		self.RMap[name] = {table.insert(self.FMap, {name, netType, extra}), netType, extra}
		self.Bits = IndexBits(#self.FMap)
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

	self["Get" .. name] = function(env, ent, default)
		return env:Get(ent, name, default)
	end
	ENT["Get" .. iName] = function(ent, default)
		return self:Get(ent, name, default)
	end
end

if SERVER then
	--- Send the current value of a networked variable to a recipient.
	--- @param ent Entity The entity the value belongs to.
	--- @param name string The registered name to send.
	--- @param val any Value to send.
	--- @param to Player|table|nil Player (or players) to send to; broadcasts to everyone if omitted.
	--- @internal
	--- @state server
	--- @section Sending
	function NET:SendChange(ent, name, val, to)
		local mapping = self.RMap[name]
		if not mapping then
			PhotonError(("Attempted to call SimpleNet:SendChange with an unregistered name: %s"):format(name))
			return
		end

		local idx, netType, extra = unpack(mapping)

		net.Start("Photon_SimpleNet_Change")
		net.WriteEntity(ent)
		net.WriteUInt(idx, self.Bits)
		self.WriteFunctions[netType](val, extra)
		if to then
			net.Send(to)
		else
			net.Broadcast()
		end
	end

	--- Change a networked entity variable, broadcasting it if it actually moved.
	---
	--- Runs the `Photon.SimpleNet.ValueChanged` hook with `(name, old, new, ent)`
	--- once the change has been sent, mirroring what the client does on receipt.
	--- A value that has not moved broadcasts nothing and runs nothing, so a
	--- listener sees a given change once per realm rather than once per write.
	--- @param ent Entity The entity to change the value on.
	--- @param name string The registered name to change.
	--- @param val any Value to set.
	--- @warns `name` must be pre-registered with `Photon.SNet:Map`.
	--- @internal
	--- @state server
	function NET:Set(ent, name, val)
		local varName = self.Normalise(name)

		local old = ent[varName]
		if val ~= old then
			ent[varName] = val
			self:SendChange(ent, name, val)
			hook.Run("Photon.SimpleNet.ValueChanged", name, old, val, ent)
		end
	end

	--- `photon_simplenet_resync_rate` — how many vehicles the resync queue is
	--- allowed to send to each player per frame. Lower it on a server whose
	--- outbound bandwidth is the bottleneck; a value below 1 is clamped to 1.
	--- @type ConVar
	--- @internal
	--- @state server
	local resyncRate = CreateConVar(
		"photon_simplenet_resync_rate", "32", FCVAR_ARCHIVE,
		"Maximum number of vehicles the SimpleNet resync queue sends to each player per frame"
	)

	--- Pending full-state sends, keyed by player, as
	--- `{list = {ent, ...}, set = {[ent] = true}, pos = <next index to send>}`.
	--- Drained a few entities per frame by the `Think` hook below.
	--- @type table<Player, table>
	--- @internal
	--- @state server
	--- @section Resync Queue
	NET.ResyncQueue = NET.ResyncQueue or {}

	-- Entries are deduped, so a legitimate queue never exceeds the number of
	-- vehicles on the map. The cap only bounds memory if a client spams
	-- requests faster than the queue drains.
	local MAX_QUEUED = 8192

	--- Collect every currently-set networked variable on an entity.
	--- @param ent Entity Entity to read the values from.
	--- @return table? fields Array of `{idx, netType, extra, val}`, or nil if nothing is set.
	--- @internal
	--- @state server
	function NET:CollectFields(ent)
		local fields
		for name, mapping in pairs(self.RMap) do
			local val = ent[self.Normalise(name)]
			if val ~= nil then
				fields = fields or {}
				local idx, netType, extra = unpack(mapping)
				fields[#fields + 1] = {idx, netType, extra, val}
			end
		end

		return fields
	end

	--- Queue vehicles to have their full networked state sent to a player.
	--- Values are only broadcast when they change, so a client that has just
	--- become aware of an entity has to pull the current state explicitly.
	--- @param ply Player Player to send the current state to.
	--- @param targets Entity[] Array of entities to queue.
	--- @internal
	--- @state server
	function NET:QueueResync(ply, targets)
		local queue = self.ResyncQueue[ply]
		if not queue then
			queue = {list = {}, set = {}, pos = 1}
			self.ResyncQueue[ply] = queue
		end

		for _, ent in ipairs(targets) do
			if #queue.list - queue.pos >= MAX_QUEUED then break end

			if IsValid(ent) and not queue.set[ent] then
				queue.set[ent] = true
				queue.list[#queue.list + 1] = ent
			end
		end
	end

	--- Drain up to `count` vehicles from a player's queue into one net message.
	--- Draining over several frames keeps any single message well under the
	--- 64KiB net limit, which a whole-map resync could otherwise exceed.
	--- @param ply Player Player to send to.
	--- @param count integer Maximum number of vehicles to process this frame.
	--- @internal
	--- @state server
	function NET:SendQueuedResync(ply, count)
		local queue = self.ResyncQueue[ply]
		if not queue then return end

		local groups, processed = {}, 0
		while processed < count and queue.pos <= #queue.list do
			local ent = queue.list[queue.pos]
			queue.pos = queue.pos + 1
			processed = processed + 1
			queue.set[ent] = nil

			if IsValid(ent) then
				local fields = self:CollectFields(ent)
				if fields then
					groups[#groups + 1] = {ent, fields}
				end
			end
		end

		if queue.pos > #queue.list then
			self.ResyncQueue[ply] = nil
		elseif queue.pos > MAX_QUEUED then
			-- Reclaim the drained prefix so a queue that never fully empties
			-- does not grow its backing array without bound.
			local remaining, n = {}, 0
			for i = queue.pos, #queue.list do
				n = n + 1
				remaining[n] = queue.list[i]
			end
			queue.list, queue.pos = remaining, 1
		end

		if #groups == 0 then return end

		net.Start("Photon_SimpleNet_Resync")
		net.WriteUInt(#groups, 16)
		for _, group in ipairs(groups) do
			local ent, fields = group[1], group[2]
			net.WriteEntity(ent)
			net.WriteUInt(#fields, self.Bits)
			for _, field in ipairs(fields) do
				local idx, netType, extra, val = field[1], field[2], field[3], field[4]
				net.WriteUInt(idx, self.Bits)
				self.WriteFunctions[netType](val, extra)
			end
		end
		net.Send(ply)
	end

	hook.Add("Think", "Photon.SimpleNet.ResyncQueue", function()
		if not next(NET.ResyncQueue) then return end

		local count = math.max(1, resyncRate:GetInt())
		for ply in pairs(NET.ResyncQueue) do
			if IsValid(ply) then
				NET:SendQueuedResync(ply, count)
			else
				NET.ResyncQueue[ply] = nil
			end
		end
	end)
end

--- Get the latest cached value of a networked variable on an entity.
--- Reads the client's local copy; it never asks the server for a fresh one.
--- @param ent Entity The entity to read the value from.
--- @param name string The registered name to read.
--- @param default any? Value to return when nothing has been networked yet.
--- @return any value The networked value, or `default`.
--- @state shared
--- @section Reading
function NET:Get(ent, name, default)
	local v = ent[self.Normalise(name)]
	if v == nil then
		return default
	end

	return v
end

if SERVER then
	net.Receive("Photon_SimpleNet_RequestSync", function(len, ply)
		local count = net.ReadUInt(14) -- 8192 edicts is the engine ceiling

		local targets = {}
		for _ = 1, count do
			local ent = net.ReadEntity()
			-- Deliberately not gated on IsEMV: the map also covers regular car
			-- variables (signals, headlights, brakes, engine), so an EMV-only
			-- gate would drop resyncs for every non-emergency Photon vehicle.
			if IsValid(ent) and ent:IsVehicle() then
				targets[#targets + 1] = ent
			end
		end

		if #targets > 0 then
			NET:QueueResync(ply, targets)
		end
	end)
end

if CLIENT then
	--- Apply a received value to an entity and notify listeners.
	--- Runs the `Photon.SimpleNet.ValueChanged` hook with
	--- `(name, old, new, ent)` after the value has been stored.
	--- @param ent Entity Entity to apply to.
	--- @param name string Registered variable name.
	--- @param val any Value that was read off the wire.
	--- @internal
	--- @state client
	--- @section Receiving
	local function ApplyValue(ent, name, val)
		local normalName = NET.Normalise(name)
		local old = ent[normalName]
		ent[normalName] = val
		hook.Run("Photon.SimpleNet.ValueChanged", name, old, val, ent)
	end

	net.Receive("Photon_SimpleNet_Change", function()
		local ent = net.ReadEntity()
		local idx = net.ReadUInt(NET.Bits)
		local mapping = NET.FMap[idx]
		if not mapping then return end

		local name, netType, extra = unpack(mapping)
		local val = NET.ReadFunctions[netType](extra)

		-- Changes are broadcast to everyone, so the entity may not exist for
		-- this client yet. NetworkEntityCreated pulls the state when it does.
		if not IsValid(ent) then return end

		ApplyValue(ent, name, val)
	end)

	net.Receive("Photon_SimpleNet_Resync", function()
		local entCount = net.ReadUInt(16)
		for _ = 1, entCount do
			local ent = net.ReadEntity()
			local fieldCount = net.ReadUInt(NET.Bits)
			for _ = 1, fieldCount do
				local idx = net.ReadUInt(NET.Bits)
				local mapping = NET.FMap[idx]
				-- An unknown index means the rest of the message cannot be
				-- realigned, so abandon it rather than reading garbage.
				if not mapping then return end

				local name, netType, extra = unpack(mapping)
				local val = NET.ReadFunctions[netType](extra)
				if IsValid(ent) then
					ApplyValue(ent, name, val)
				end
			end
		end
	end)

	local pending, flushQueued = {}, false

	--- Send one batched sync request for every vehicle queued this frame.
	--- @internal
	--- @state client
	local function FlushSyncRequests()
		flushQueued = false

		local targets, count = {}, 0
		for ent in pairs(pending) do
			if IsValid(ent) then
				count = count + 1
				targets[count] = ent
			end
		end
		table.Empty(pending)
		if count == 0 then return end

		net.Start("Photon_SimpleNet_RequestSync")
		net.WriteUInt(count, 14) -- 8192 edicts is the engine ceiling
		for i = 1, count do
			net.WriteEntity(targets[i])
		end
		net.SendToServer()
	end

	--- Queue a vehicle for a full state sync from the server.
	--- Requests are debounced into a single message because joining a server
	--- fires `NetworkEntityCreated` for every entity in the initial PVS at once.
	--- @param ent Entity Entity to request state for.
	--- @internal
	--- @state client
	local function RequestSync(ent)
		-- Gated on IsVehicle rather than IsEMV: IsEMV reads VehicleIndex, which
		-- is exactly the value an unsynced client is missing, so an EMV gate
		-- here can never recover a vehicle it has no state for.
		if not IsValid(ent) or not ent:IsVehicle() then return end

		pending[ent] = true
		if not flushQueued then
			flushQueued = true
			timer.Simple(0, FlushSyncRequests)
		end
	end

	hook.Add("NetworkEntityCreated", "Photon.SimpleNet.RequestSync", RequestSync)

	hook.Add("NotifyShouldTransmit", "EMVU.Net.NotifyShouldTransmit", function(ent, shouldTransmit)
		if shouldTransmit then RequestSync(ent) end
	end)
end

local UInt, Bool, Str, Float = NET.UINT, NET.BOOL, NET.STR, NET.FLOAT

NET:Map("HasPhoton", Bool)
NET:Map("CurrentSignal", UInt, 2)
NET:Map("Blinker", UInt, 2)
NET:Map("Headlights", Bool)
NET:Map("Braking", Bool)
NET:Map("Reversing", Bool)
NET:Map("Running", Bool)
NET:Map("LEStayOn", Bool)

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
NET:Map("Blackout", Bool)

NET:Map("SirenSound", Str)
NET:Map("SirenVolume", Float)
NET:Map("Siren2Sound", Str)
NET:Map("Siren2Volume", Float)
NET:Map("ManualSound", Str)
NET:Map("ManualVolume", Float)
NET:Map("HornSound", Str)
NET:Map("HornVolume", Float)

NET:Map("VehicleIndex", Str)
NET:Map("UnitNumber", Str)
NET:Map("LiveryID", Str)
NET:Map("SelectionString", Str)
