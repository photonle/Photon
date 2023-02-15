--[[-- Photon Init
@copyright Photon Team
@release v74 Hot Sulphur Springs
@author Photon Team
--]]--

exlib = exlib or {}

if SERVER then
    function exlib.LoadLibrary()
        local fol = "exlib/"
        local files, folders = file.Find(fol .. "*", "LUA")
        
        for _, f in pairs(files) do
            include(fol .. f)
        end
        PrintTable(folders)

        for _,folder in SortedPairs(folders, true) do
            print(fol, "folder")
            for _, File in SortedPairs(file.Find(fol .. folder .."/sh_*.lua", "LUA"), true) do
                AddCSLuaFile(fol..folder .. "/" ..File)
                include(fol.. folder .. "/" ..File)
            end
            for _, File in SortedPairs(file.Find(fol .. folder .."/sv_*.lua", "LUA"), true) do
                include(fol.. folder .. "/" ..File)
            end
            for _, File in SortedPairs(file.Find(fol .. folder .."/cl_*.lua", "LUA"), true) do
                AddCSLuaFile(fol.. folder .. "/" ..File)
            end
        end
        
    end

    exlib.LoadLibrary()
end

if CLIENT then
    function exlib.LoadLibrary()
        local root = "exlib/"
        local _, folders = file.Find(root .. "*", "LUA")
        for _,folder in SortedPairs(folders, true) do
            for _, File in SortedPairs(file.Find(root .. folder .."/sh_*.lua", "LUA"), true) do
                include(root.. folder .. "/" ..File)
            end
            for _, File in SortedPairs(file.Find(root .. folder .."/cl_*.lua", "LUA"), true) do
                include(root.. folder .. "/" ..File)
            end
        end
    end
    
    exlib.LoadLibrary()
end

if SERVER then
	AddCSLuaFile( "photon/sh_emv_init.lua" )
	AddCSLuaFile( "photon/sh_photon_init.lua" )
end

include( "photon/sh_photon_init.lua" )
include( "photon/sh_emv_init.lua" )