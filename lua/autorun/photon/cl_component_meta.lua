if exmeta.DebugReloadFile("autorun/photon/cl_component_meta.lua") then return end
NAME = "photon_component_base"
BASE = "Entity"

function META:Initialize() end

function META:CheckPhoton()
    print("Metatable functioning.")
end