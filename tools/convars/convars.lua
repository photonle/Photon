TYPE_INT = "Int"
TYPE_STRING = "String"
TYPE_BOOL = "Bool"

local defaults = {
	[TYPE_INT] = [[0]],
	[TYPE_STRING] = [[""]],
	[TYPE_BOOL] = [[false]]
}

local remap = {
	emerg_enabled =	"should_render",
	key_alt_reverse = "key_backtick"
}

local convars = {
	photon_key_primary_toggle = TYPE_INT,
	photon_key_primary_alt = TYPE_INT,
	photon_key_siren_toggle = TYPE_INT,
	photon_key_siren_alt = TYPE_INT,
	photon_key_auxiliary = TYPE_INT,
	photon_key_blackout = TYPE_INT,
	photon_key_horn = TYPE_INT,
	photon_key_manual = TYPE_INT,
	photon_key_illum = TYPE_INT,
	photon_key_radar = TYPE_INT,
	photon_key_siren1 = TYPE_INT,
	photon_key_siren2 = TYPE_INT,
	photon_key_siren3 = TYPE_INT,
	photon_key_siren4 = TYPE_INT,
	photon_key_alt_reverse = TYPE_INT,
	photon_key_signal_activate = TYPE_INT,
	photon_key_signal_deactivate = TYPE_INT,
	photon_key_signal_left = TYPE_INT,
	photon_key_signal_right = TYPE_INT,
	photon_key_signal_hazard = TYPE_INT,
	photon_emerg_enabled = TYPE_BOOL
}

local hook = [[hook.Add("InitPostEntity", "Photon.SetupLocalKeyBinds", function()
	%s
end)]]
local setup_cv = [[local %s = GetConVar("%s")]]
local setup_val = [[local %s = IsValid(%s) and %s:Get%s() or %s]]
local hook_cv = [[%s = GetConVar("%s")]]
local hook_val = [[%s = %s:Get%s()]]
local cvar = [[cvars.AddChangeCallback("%s", function() %s = %s:Get%s() end)]]

local header = {}
local hooks = {}
local callbacks = {}

local function normalize(name)
	return string.sub(name, 8)
end

local function convarVariable(name)
	return "cv_" .. normalize(name)
end

local function valueVariable(name)
	name = normalize(name)
	if remap[name] then
		name = remap[name]
	end
	return name
end

for cv, t in pairs(convars) do
	table.insert(header, string.format(setup_cv, convarVariable(cv), cv))
	table.insert(header, string.format(setup_val, valueVariable(cv), convarVariable(cv), convarVariable(cv), t, defaults[t]))
	table.insert(hooks, string.format(hook_cv, convarVariable(cv), cv))
	table.insert(hooks, string.format(hook_val, valueVariable(cv), convarVariable(cv), t))
	table.insert(callbacks, string.format(cvar, cv, valueVariable(cv), convarVariable(cv), t))
end

local out =
	table.concat(header, "\n") ..
	"\n\n" ..
	string.format(hook, table.concat(hooks, "\n\t")) ..
	"\n\n" ..
	table.concat(callbacks, "\n")
print(out)