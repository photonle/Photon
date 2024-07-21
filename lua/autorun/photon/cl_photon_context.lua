AddCSLuaFile()

local function null() end

properties.Add("photon_siren", {
    MenuLabel = "Siren Model",
    Order = 2,
    MenuIcon = "photon/ui/menu-siren.png",
    Filter = function(self, ent, ply)
        if not IsValid(ent) then
            return false
        end

        if not ent:IsVehicle() then
            return false
        end

        if not ent:Photon() then
            return false
        end

        if not ent:IsEMV() then
            return false
        end

        return true
    end,
    MenuOpen = function(self, option, ent)
        local sirens = EMVU.GetSirenTable()
        local submenu = option:AddSubMenu()
        local primarySubmenu = submenu:AddSubMenu("Primary", null)
        local secondarySubmenu = submenu:AddSubMenu("Secondary", null)
        local categories = {}
        categories["Other"] = true

        for _, siren in pairs(sirens) do
            if siren.Category then
                categories[siren.Category] = true
            end
        end

        for category, siren in SortedPairs(categories) do
            categories[category] = {primarySubmenu:AddSubMenu(category, null), secondarySubmenu:AddSubMenu(category, null)}
        end

        for idx, siren in ipairs(sirens) do
            local key = tostring(idx)
            local category = siren.Category or "Other"
            local selected = tostring(ent:Photon_SirenSet()) == key

            categories[category][1]:AddOption(siren.Name, function()
                EMVU.Net:SirenSet(idx, ent, false)
            end):SetChecked(selected)

            if not selected then
                categories[category][2]:AddOption(siren.Name, function()
                    EMVU.Net:SirenSet(idx, ent, true)
                end):SetChecked(tostring(ent:Photon_AuxSirenSet()) == key)
            end
        end

        primarySubmenu:AddOption("None", function()
            EMVU.Net:SirenSet(0, ent, false)
        end):SetChecked(ent:Photon_SirenSet() == 0)

        secondarySubmenu:AddOption("None", function()
            EMVU.Net:SirenSet(0, ent, true)
        end):SetChecked(ent:Photon_AuxSirenSet() == 0)
    end,
    Action = null
})

properties.Add("photon_liveries", {
    MenuLabel = "Vehicle Livery",
    Order = 3,
    MenuIcon = "photon/ui/menu-livery.png",
    Filter = function(self, ent, ply)
        if not IsValid(ent) then
            return false
        end

        if not ent:Photon() then
            return false
        end

        if not ent:IsEMV() then
            return false
        end

        if not ent.VehicleName then
            return false
        end

        if not ply:InVehicle() then
            return false
        end

        if ply:GetVehicle() ~= ent then
            return false
        end

        local liveries = EMVU.Liveries[ent.VehicleName]

        if not liveries then
            return false
        end

        return true
    end,
    MenuOpen = function(self, option, ent)
        local liveries = EMVU.Liveries[ent.VehicleName]
        local lCount = table.Count(liveries)
        local submenu = option:AddSubMenu()

        for key, data in SortedPairs(liveries) do
            local category = lCount > 1 and table.Count(data) > 1 and submenu:AddSubMenu(key) or submenu

            for name, _ in SortedPairs(data) do
                category:AddOption(name, function()
                    EMVU.Net:Livery(key, name)
                end)
            end
        end
    end,
    Action = null
})

properties.Add("photon_autoskin", {
    MenuLabel = "Vehicle Liveries",
    Order = 3,
    MenuIcon = "photon/ui/menu-livery.png",
    Filter = function(self, ent, ply)
        if not IsValid(ent) then
            return false
        end

        if not ent:Photon() then
            return false
        end

        if not ent:IsEMV() then
            return false
        end

        if not ent.VehicleName then
            return false
        end

        local mdl = ent:GetModel()
        local mdlId = Photon.AutoSkins.TranslationTable[mdl]

        if not mdlId then
            return false
        end

        if not istable(Photon.AutoSkins.Available[mdlId]) then
            return false
        end

        return true
    end,
    MenuOpen = function(self, option, ent)
        local mdl = ent:GetModel()
        local mdlId = Photon.AutoSkins.TranslationTable[mdl]
        local skinTable = Photon.AutoSkins.Available[mdlId]
        local submenu = option:AddSubMenu()

        for category, subSkins in pairs(skinTable) do
            if category ~= "/" then
                local categoryMenu = submenu:AddSubMenu(category, null)

                for _, skinInfo in pairs(subSkins) do
                    categoryMenu:AddOption(skinInfo.Name, function()
                        EMVU.Net.ApplyAutoSkin(ent, skinInfo.Texture)
                    end)
                end
            end
        end

        if istable(skinTable["/"]) then
            for _, skinInfo in pairs(skinTable["/"]) do
                submenu:AddOption(skinInfo.Name, function()
                    EMVU.Net.ApplyAutoSkin(ent, skinInfo.Texture)
                end)
            end
        end
    end,
    Action = null
})

properties.Add("photon_licenseplates", {
    MenuLabel = "License Plate",
    Order = 4,
    MenuIcon = "photon/ui/menu-license.png",
    Filter = function(self, ent, ply)
        if not IsValid(ent) then
            return false
        end

        if not ent:Photon() then
            return false
        end

        if not ent:IsEMV() then
            return false
        end

        if not ent:EMVName() then
            return false
        end

        if not ent:Photon_LicensePlate() then
            return false
        end

        return true
    end,
    MenuOpen = function(self, option, ent)
        local skinTable = Photon.LicensePlates.Available
        local submenu = option:AddSubMenu()

        for category, subSkins in pairs(skinTable) do
            if category ~= "/" then
                local categoryMenu = submenu:AddSubMenu(category, null)

                for _, skinInfo in pairs(subSkins) do
                    categoryMenu:AddOption(skinInfo.Name, function()
                        EMVU.Net.ApplyLicenseMaterial(ent, skinInfo.Texture)
                    end)
                end
            end
        end

        if istable(skinTable["/"]) then
            for _, skinInfo in pairs(skinTable["/"]) do
                submenu:AddOption(skinInfo.Name, function()
                    EMVU.Net.ApplyLicenseMaterial(ent, skinInfo.Texture)
                end)
            end
        end
    end,
    Action = null
})

properties.Add("photon_wheels", {
    MenuLabel = "Wheel Style",
    Order = 5,
    MenuIcon = "photon/ui/menu-wheel.png",
    Filter = function(self, ent, ply)
        if not IsValid(ent) then
            return false
        end

        if not ent:Photon() then
            return false
        end

        if not ent:Photon_WheelEnabled() then
            return false
        end

        return true
    end,
    MenuOpen = function(self, option, ent)
        local options = Photon.Vehicles.WheelOptions[ent.VehicleName]
        local submenu = option:AddSubMenu()
        local selected = tostring(ent:Photon_WheelOption())

        for index, data in pairs(options) do
            submenu:AddOption(data.Name, function()
                EMVU.Net:WheelOption(index, ent)
            end):SetChecked(tostring(index) == selected)
        end
    end,
    Action = null
})

properties.Add("photon_preset", {
    MenuLabel = "Emergency Lights",
    Order = 1,
    MenuIcon = "photon/ui/menu-lights.png",
    Filter = function(self, ent, ply)
        if not IsValid(ent) then
            return false
        end

        if not ent:Photon() then
            return false
        end

        if not ent:IsEMV() then
            return false
        end

        if not ent:Photon_PresetEnabled() then
            return false
        end

        local options = EMVU.PresetIndex[ent.VehicleName]

        if not options then
            return false
        end

        if not istable(options) then
            return false
        end

        if #options <= 1 then
            return false
        end

        return true
    end,
    MenuOpen = function(self, option, ent)
        local options = EMVU.PresetIndex[ent.VehicleName]
        local submenu = option:AddSubMenu()
        local selected = tostring(ent:Photon_ELPresetOption())

        for idx, data in ipairs(options) do
            submenu:AddOption(data.Name, function()
                EMVU.Net:Preset(idx, ent)
            end):SetChecked(tostring(idx) == selected)
        end
    end,
    Action = null
})

properties.Add("photon_selection", {
    MenuLabel = "Equipment",
    Order = 1,
    MenuIcon = "photon/ui/menu-lights.png",
    Filter = function(self, ent, ply)
        if not IsValid(ent) then
            return false
        end

        if not ent:Photon() then
            return false
        end

        if not ent:IsEMV() then
            return false
        end

        if not ent:Photon_SelectionEnabled() then
            return false
        end

        return true
    end,
    MenuOpen = function(self, option, ent)
        local options = EMVU.Selections[ent.VehicleName]
        local submenu = option:AddSubMenu()

        for catIndex, cat in ipairs(options) do
            if not cat.Name then
                cat.Name = "Unspecified #" .. catIndex
                Photon.Logging.Warning("Selection with the index #" .. catIndex .. " has no name specified.")
            end

            if #cat.Options == 2 and (cat.Options[1].Name == "None" or cat.Options[2].Name == "None") then
                local selected = ent:Photon_SelectionOption(catIndex)
                local isActive = cat.Options[selected].Name ~= "None"
                local addedOption

                if selected == 1 then
                    addedOption = submenu:AddOption(cat.Name, function()
                        EMVU.Net.Selection(ent, catIndex, 2)
                    end)
                else
                    addedOption = submenu:AddOption(cat.Name, function()
                        EMVU.Net.Selection(ent, catIndex, 1)
                    end)
                end

                addedOption:SetChecked(isActive)
            else
                local category = submenu:AddSubMenu(cat.Name, null)
                local subCategories = {}

                for index, option in pairs(cat.Options) do
                    local opt

                    if not option.Name then
                        option.Name = "Unspecified #" .. index
                        Photon.Logging.Warning("Option in selection '" .. cat.Name .. "' with the index #" .. index .. " has no name specified.")
                    end

                    if option.Category then
                        if not subCategories[option.Category] then
                            subCategories[option.Category] = category:AddSubMenu(option.Category)
                        end

                        opt = subCategories[option.Category]:AddOption(option.Name, function()
                            EMVU.Net.Selection(ent, catIndex, index)
                        end)
                    else
                        opt = category:AddOption(option.Name, function()
                            EMVU.Net.Selection(ent, catIndex, index)
                        end)
                    end

                    if ent:Photon_SelectionOption(catIndex) == index then
                        opt:SetChecked(true)
                    end
                end
            end
        end
    end,
    Action = null
})

properties.Add("photon_configuration", {
    MenuLabel = "Configurations",
    Order = 5,
    MenuIcon = "photon/ui/menu-presets.png",
    Filter = function(self, ent, ply)
        if not IsValid(ent) then
            return false
        end

        if not ent:Photon() then
            return false
        end

        if not ent:IsEMV() then
            return false
        end

        if not ent:Photon_SelectionEnabled() then
            return false
        end

        if not ent:Photon_SupportsConfigurations() then
            return false
        end

        if not ent:Photon_GetAvailableConfigurations() then
            return false
        end

        return true
    end,
    MenuOpen = function(self, option, ent)
        local options = ent:Photon_GetAvailableConfigurations() or {}
        local submenu = option:AddSubMenu()
        local categories = {}

        for index, data in pairs(options) do
            local sub = submenu

            if data.Category and (not tobool(data.Category) == false) then
                local newCat = categories[tostring(data.Category)]

                if not newCat then
                    categories[tostring(data.Category)] = submenu:AddSubMenu(tostring(data.Category), null)
                    newCat = categories[tostring(data.Category)]
                end

                sub = newCat
            end

            sub:AddOption(data.Name, function()
                ent:Photon_ApplyEquipmentConfiguration(index)
            end)
        end
    end,
    Action = null
})