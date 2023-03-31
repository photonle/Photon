AddCSLuaFile()

EMVU.Net = {}

--- Write a siren change to the server.
-- @integer arg Change mode.
function EMVU.Net:Siren(arg)
	net.Start("emvu_siren")
		net.WriteUInt(arg, 5)
	net.SendToServer()
end

--- Write a els change to the server.
-- @integer arg Change mode.
function EMVU.Net:Lights(arg)
	net.Start("emvu_el")
		net.WriteUInt(arg, 2)
	net.SendToServer()
end

--- Write a siren set change to the server.
-- @integer arg Change mode.
-- @ent[opt=LocalPlayer():GetVehicle()] ent Entity to change siren on.
-- @bool[opt=false] If the aux siren should be set.
function EMVU.Net:SirenSet(arg, ent, aux)
	if aux == nil then
		aux = false
	end

	if not ent then
		ent = LocalPlayer():GetVehicle()
	end
	if not IsValid(ent) then return end

	net.Start("emvu_sirenset")
		net.WriteEntity(ent)
		net.WriteUInt(arg, 9)
		net.WriteBool(aux)
	net.SendToServer()
end

--- Write a turn signal change to the server.
-- @string arg Change mode.
function Photon.Net:Signal(arg)
	net.Start("photon_signal")
		net.WriteInt(arg, 3)
	net.SendToServer()
end

--- Write an illumination change to the server.
-- @integer arg Mode Change.

function EMVU.Net:Illumination(arg)
	net.Start("emvu_illum")
		net.WriteUInt(arg, 2)
	net.SendToServer()
end

--- Write an illumination change to the server.
-- @string arg Change mode.
-- @deprecated
-- @see EMVU.Net:Illumination
function EMVU.Net:Illuminate(arg)
	self:Illumination(arg)
end

--- Write a TA change to the server.
-- @string arg Change mode.
function EMVU.Net:Traffic(arg)
	net.Start("emvu_traffic")
		net.WriteString(arg)
	net.SendToServer()
end

--- Write a blackout change to the server.
-- @string arg Change mode.
function EMVU.Net:Blackout(arg)
	net.Start("emvu_blackout")
		net.WriteBit(arg)
	net.SendToServer()
end

--- Write a horn change to the server.
-- @string arg Change mode.
function EMVU.Net:Horn(arg)
	net.Start("emvu_horn")
		net.WriteBit(arg)
	net.SendToServer()
end

--- Write a manual siren change to the server.
-- @string arg Change mode.
function EMVU.Net:Manual(arg)
	net.Start("emvu_manual")
		net.WriteBit(arg)
	net.SendToServer()
end

--- Write a preset change to the server.
-- @string arg Change mode.
-- @ent ent Entity the preset is changing on.
function EMVU.Net:Preset(arg, ent)
	net.Start("emvu_preset")
		net.WriteEntity(ent)
		net.WriteInt(arg, 8)
	net.SendToServer()
end

--- Write a wheel change to the server.
-- @string arg Change mode.
function EMVU.Net:WheelOption(arg, ent)
	net.Start("photon_wheel")
		net.WriteEntity(ent)
		net.WriteInt(arg, 8)
	net.SendToServer()
end

local unitid_pref = GetConVar("photon_emerg_unit")
local function GenerateDefaultUnitID()
	return string.sub(tostring(LocalPlayer():SteamID64()), -3) or "000" -- will use the last three digits of Steam64
end

--- Write a livery change to the server.
-- @string category Livery catgegory.
-- @string index Livery ID.
function EMVU.Net:Livery(category, index)
	net.Start("emvu_livery")
		net.WriteString(category)
		net.WriteString(index)
		net.WriteString(unitid_pref:GetString() or GenerateDefaultUnitID())
	net.SendToServer()
end

--- Receive a livery update from the server.
-- @string id Livery ID
-- @string unit Unit ID.
-- @ent ent Entity being applyed to.
function EMVU.Net:ReceiveLiveryUpdate(id, unit, ent)
	Photon.AutoLivery.Apply(id, unit, ent)
end
net.Receive("photon_liveryupdate", function()
	EMVU.Net:ReceiveLiveryUpdate(net.ReadString(), net.ReadString(), net.ReadEntity())
end)

--- Write a color change to the server.
-- @ent ent Entity to recolor.
-- @string col New color.
function EMVU.Net:Color(ent, col)
	net.Start("emvu_color")
		net.WriteEntity(ent)
		net.WriteColor(col)
	net.SendToServer()
end

--- Receive unit ID request from the server.
function EMVU.Net:ReceiveUnitNumberRequest()
	net.Start("photon_myunitnumber")
		net.WriteString(unitid_pref:GetString() or GenerateDefaultUnitID())
	net.SendToServer()
end
net.Receive("photon_myunitnumber", function() EMVU.Net:ReceiveUnitNumberRequest() end)

--- Write a selection change to the server.
-- @ent ent Entity to change selections on.
-- @int category Selection category.
-- @int option Selected option.
function EMVU.Net.Selection(ent, category, option)
	net.Start("emvu_selection")
		net.WriteEntity(ent)
		net.WriteInt(category, 8)
		net.WriteInt(option, 8)
	net.SendToServer()
end

--- Send a request for skins to the server.
function EMVU.Net.RequestAllSkins()
	net.Start("photon_availableskins")
	net.SendToServer()
end

--- Receive a list of autoskins from the server.
function EMVU.Net.ReceiveAvailableSkins()
	local received = net.ReadTable()
	Photon.AutoSkins.Available = received
end
net.Receive("photon_availableskins", function() EMVU.Net.ReceiveAvailableSkins() end)

--- Send an autoskin change to the server.
-- @ent ent Entity to change skin on.
-- @string skin Skin name.
function EMVU.Net.ApplyAutoSkin(ent, skin)
	skin = tostring(skin)

	local cnt = 0
	for i in string.gmatch(skin, "/") do
		cnt = cnt + 1
	end

	if cnt < 2 then
		skin = string.Replace(skin, "/", "///")
	end

	net.Start("photon_setautoskin")
		net.WriteEntity(ent)
		net.WriteString(skin)
	net.SendToServer()
end

--- Write a license plate change to the server.
-- @ent ent Entity to change license plate on.
-- @string mat License plate material
function EMVU.Net.ApplyLicenseMaterial(ent, mat)
	local cnt = 0
	for i in string.gmatch( mat, "/" ) do
		cnt = cnt + 1
	end

	if cnt < 2 then
		mat = string.Replace( mat, "/", "///" )
	end

	net.Start("photon_license_mat")
		net.WriteEntity(ent)
		net.WriteString(mat)
	net.SendToServer()
end

concommand.Add("photon_debug_getbones", function()
	local ent = ply:GetEyeTrace().Entity
	if not IsValid(ent) then return end

	print(tostring(ent:GetBoneCount()))
end)