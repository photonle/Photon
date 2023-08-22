--- Photon Logging Module
-- @module Photon.Logging

Photon = Photon or {}

Photon.Logging = {}

--- Various Logging Level Enumerations
Photon.Logging.Levels = {
	NONE = 100,
	FATAL = 50,
	ERROR = 40,
	WARNING = 30,
	INFO = 20,
	DEBUG = 10,
	ANY = 0
}
Photon.Logging.Levels.DEFAULT = Photon.Logging.Levels.WARNING
Photon.Logging.Levels._MAX = Photon.Logging.Levels.NONE
Photon.Logging.Levels._MIN = Photon.Logging.Levels.ANY

--- Colours used in the logging library.
Photon.Logging.Colours = {
	[Photon.Logging.Levels.NONE] = Color(20, 20, 20),
	[Photon.Logging.Levels.FATAL] = Color(255, 0, 0),
	[Photon.Logging.Levels.ERROR] = Color(255, 60, 60),
	[Photon.Logging.Levels.WARNING] = Color(255, 200, 0),
	[Photon.Logging.Levels.INFO] = Color(20, 140, 255),
	[Photon.Logging.Levels.DEBUG] = Color(160, 160, 160),

	Brand = Color(230, 92, 78),
	Client = Color(222, 169, 9),
	Server = Color(3, 169, 224),
	Text = Color(200, 200, 200),
	Disabled = Color(20, 20, 20),
}

--- Parse a string logging level (such as that from cvars.String) into a level.
-- If it fails to parse, the default is used instead.
-- @string level Input Level
-- @rnumber Logging Level
function Photon.Logging.Parse(level)
	if tonumber(level) ~= nil then
		level = tonumber(level)
	end

	if isnumber(level) then
		return math.Clamp(level, Photon.Logging.Levels.ANY, Photon.Logging.Levels.FATAL)
	end

	if Photon.Logging.Levels[level] then
		return Photon.Logging.Levels[level]
	end

	return Photon.Logging.Levels.DEFAULT
end

local level_cvar = CreateConVar(
	"photon_logging_level",
	Photon.Logging.Levels.DEFAULT,
	FCVAR_ARCHIVE + FCVAR_ARCHIVE_XBOX + FCVAR_UNLOGGED,
	"Set the logging level for Photon (number[0 <= X <= 50]|string<FATAL, ERROR, WARNING, INFO, DEBUG, ANY>)",
	Photon.Logging.Levels._MIN,
	Photon.Logging.Levels._MAX
)

Photon.Logging.Level = Photon.Logging.Parse(level_cvar:GetString())
cvars.RemoveChangeCallback("photon_logging_level", "Photon.Logging")
cvars.AddChangeCallback(level_cvar:GetName(), function(_, _, val)
	Photon.Logging.Level = Photon.Logging.Parse(val)
end, "Photon.Logging")





local function flatten(...)
	local out = {}
	local n = select('#', ...)
	for i = 1, n do
		local v = (select(i, ...))
		if istable(v) and not IsColor(v) then
			table.Add(out, flatten(unpack(v)))
		elseif isfunction(v) then
			table.Add(out, flatten(v()))
		else
			table.insert(out, v)
		end
	end

	return out
end


--- Print a message with colour to console.
-- @internal
-- @see MsgC
function Photon.Logging._print(...)
	MsgC(unpack(flatten(...)))
	print()
end

--- A table storing often used logging "phrases".
Photon.Logging.Phrases = {
	Photon = {Photon.Logging.Colours.Brand, "Photon"},
	PhotonPride = {
		Color(228, 3, 3), "P",
		Color(255, 140, 0), "h",
		Color(255, 237, 0), "o",
		Color(0, 128, 38), "t",
		Color(36, 64, 142), "o",
		Color(115, 41, 130), "n",
	},
	PhotonTrans = {
		Color(91, 206, 250), "P",
		Color(245, 169, 184), "h",
		Color(255, 255, 255), "ot",
		Color(245, 169, 184), "o",
		Color(91, 206, 250), "n",
	},
	PhotonChristmas = {
		Color(0, 120, 0), "Ph",
		Color(200, 0, 0), "ot",
		Color(0, 120, 0), "on",
	}
}

--- Create a "Photon" or "[Photon]" table.
-- @bool wrapped Should the Photon be wrapped in [].
-- @string event It's a secret tool that'll help us later.
-- @rtab
function Photon.Logging:Photon(wrapped, event)
	if not event then
		event = ""

		local dt = os.date("%d-%m")
		if dt == "31-03" then
			event = "Trans"
		elseif dt == "25-12" then
			event = "Christmas"
		elseif os.date("%m") == "06" then
			event = "Pride"
		end
	end

	local photon = self.Phrases["Photon" .. event] or self.Phrases.Photon
	if wrapped then
		return {self.Colours.Text, "[", photon, self.Colours.Text, "]"}
	end

	return {photon, self.Colours.Text}
end

--- Build the message functions for a given level.
-- Creates the global function Photon<LEVEL>, ie PhotonWarning
-- Also adds the function to Photon.Logging.<LEVEL>, ie Photon.Logging.Warning
-- @tparam string level Message level.
function Photon.Logging:Build(level)
	local levelValue = isnumber(level) and level or self.Levels[level:upper()]

	if self[level] then
		self[level] = nil
	end

	local args = {}
	table.insert(args, Photon.Functional.partial(self.Photon, self, true))
	table.insert(args, self.Colours.Text)
	table.insert(args, "[")

	if SERVER then
		table.insert(args, self.Colours.Server)
		table.insert(args, "sv")
		table.insert(args, self.Colours.Text)
		table.insert(args, "][")
	end
	if CLIENT then
		table.insert(args, self.Colours.Client)
		table.insert(args, "cl")
		table.insert(args, self.Colours.Text)
		table.insert(args, "][")
	end

	if self.Colours[levelValue] then
		table.insert(args, self.Colours[levelValue])
		table.insert(args, level)
		table.insert(args, self.Colours.Text)
		table.insert(args, "] ")
	else
		table.insert(args, level .. "] ")
	end

	local _prt = self._print
	local function prt(...)
		if self.Level > levelValue then
			return
		end

		_prt(...)
	end

	self[level] = Photon.Functional.partial(
		prt,
		unpack(args)
	)
	self["Force" .. level] = Photon.Functional.partial(
		prt,
		unpack(args)
	)

	_G["Photon" .. level] = self[level]
end

-- @function Photon.Logging:Fatal(...)
-- Emit a Fatal Level Log.
Photon.Logging:Build("Fatal")

-- @function Photon.Logging:Error(...)
-- Emit a Error Level Log.
Photon.Logging:Build("Error")

-- @function Photon.Logging:Warning(...)
-- Emit a Warning Level Log.
Photon.Logging:Build("Warning")

-- @function Photon.Logging:Info(...)
-- Emit a Info Level Log.
Photon.Logging:Build("Info")

-- @function Photon.Logging:Debug(...)
-- Emit a Debug Level Log.
Photon.Logging:Build("Debug")

concommand.Add("photon_logging_level_report", function()
	local last = math.huge
	local cur = Photon.Logging.Level

	local l = Photon.Logging
	local c = l.Colours
	local t = c.Text

	MsgC(unpack(flatten(l:Photon(), " Logging Configuration Report\n")))
	MsgC(t, "Photon Logging is configurable, to be as chatty or quiet as required.\n")
	MsgC(t, "For this, we have various logging levels, representing how dire a log represents.\n")
	MsgC(t, "The `photon_logging_level` ConVar is used to control which of these output.\n")
	MsgC(t, "Any logs at the given level or above will be shown.\n")
	MsgC(t, "Any logs below will be hidden.\n\n")

	for name, level in SortedPairsByValue(l.Levels, true) do
		if name == "DEFAULT" or name:StartWith("_") then
			continue
		end

		if cur < last and cur > level then
			MsgC(t, "--> Current Logging Level (" .. cur .. ")\n")
		end

		local args = {}
		local color = level < cur and c.Disabled or c[level] or nil
		if color then
			table.insert(args, color)
		end
		table.insert(args, name)
		table.insert(args, "\n")
		MsgC(t, cur == level and "--> " or "    ", unpack(args))

		last = level
	end

	MsgC("\n", t, "Below here, we'll print one of each log, in decending order of severity.\n\n")
	l.Fatal("Example Fatal Log")
	l.Error("Example Error Log")
	l.Warning("Example Warning Log")
	l.Info("Example Informational Log")
	l.Debug("Example Debug Log")
end, nil, "Report on which logging levels will be reported by Photon.")
