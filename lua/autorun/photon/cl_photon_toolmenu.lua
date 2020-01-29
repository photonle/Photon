AddCSLuaFile()

local invis = Color(0, 0, 0, 0)

hook.Add("AddToolMenuCategories", "Photon.AddMenuCategory", function()
	spawnmenu.AddToolCategory("Utilities", "Photon", "Photon")
end)


local function logoHeader(panel, imgpath)
	if not imgpath then
		imgpath = "photon/ui/settings_logo.png"
	end

	panel:AddControl("Header", {
		Description = string.format("Photon Lighting Engine | %s | Update #%s", PHOTON_SERIES, PHOTON_UPDATE)
	})

	local parent = vgui.Create("DPanel")
	parent:SetSize(300, 256)
	parent:SetBackgroundColor(invis)

	local header = vgui.Create("DImage", parent)
	header:SetImage(imgpath)
	header:SetSize(256, 256)
	panel:AddPanel(parent)
	header:Center()
end

local function buildControlsMenu(panel)
	panel:ClearControls()

	logoHeader(panel)
	panel:AddControl("Header", {Description = "Adjust the keys for Photon controls"})
	panel:AddControl("Numpad", {Label = "Primary Lights On/Off", Command="photon_key_primary_toggle", Label2 = "Primary Lights Mode", Command2="photon_key_primary_alt"})
	panel:AddControl("Numpad", {Label = "Siren On/Off", Command="photon_key_siren_toggle", Label2 = "Siren Tone", Command2="photon_key_siren_alt"})
	panel:AddControl("Numpad", {Label = "Auxiliary Lights", Command="photon_key_auxiliary", Label2 = "Illumination", Command2="photon_key_illum"})
	panel:AddControl("Numpad", {Label = "Horn", Command="photon_key_horn", Label2 = "Siren Manual", Command2="photon_key_manual"})
	panel:AddControl("Numpad", {Label = "Blackout Mode", Command="photon_key_blackout", Label2 = "Radar", Command2="photon_key_radar"})
	panel:AddControl("Numpad", {Label = "Siren 1", Command="photon_key_siren1", Label2 = "Siren 2", Command2="photon_key_siren2"})
	panel:AddControl("Numpad", {Label = "Siren 3", Command="photon_key_siren3", Label2 = "Siren 4", Command2="photon_key_siren4"})
	panel:AddControl("Numpad", {Label = "Reverse Light/Siren/TA Mode (Hold)", Command="photon_key_alt_reverse"})
	panel:AddControl("Button", {Label = "Reset to Default", Command="photon_keys_reset"})
end

local function buildClientSettings(panel)
	panel:ClearControls()

	logoHeader(panel)
	if PHOTON_CHRISTMAS_PERMIT then
		panel:AddControl("Header", {Description = "Special"})
		panel:AddControl("CheckBox", {Label = "Holiday Mode", Command = "photon_christmas_mode_auto"})
	end

	panel:AddControl("Header", {Description = "General Settings"})
	panel:AddControl("CheckBox", {Label = "Enable Emergency Lighting", Command = "photon_emerg_enabled"})
	panel:AddControl("CheckBox", {Label = "Enable Standard Lighting", Command = "photon_stand_enabled"})
	panel:AddControl("CheckBox", {Label = "Enable Radar Sound", Command = "photon_radar_sound"})
	panel:AddControl("Header", {Description = "Performance & Appearance"})
	panel:AddControl("CheckBox", {Label = "Enable Lens Flare Effects", Command = "photon_lens_effects"})
	panel:AddControl("CheckBox", {Label = "Enable Dynamic Lighting", Command = "photon_dynamic_lights", Description = "Experimental feature. This WILL significantly decrease FPS."})
	panel:AddControl("Slider", {Label = "Light Bloom Modifier", Command = "photon_bloom_modifier", Type = "Float", Min = "0", Max = "2"})
	panel:AddControl("Header", {Description = "Change HUD settings"})
	panel:AddControl("Slider", {Label = "Opacity", Command = "photon_hud_opacity", Type = "Float", Min = "0", Max = "1"})

	panel:AddControl("Header", {Description = "Personal Options"})
	panel:AddControl("TextBox", {Label = "Unit ID", Command = "photon_emerg_unit", WaitForEnter = "1", Max = "3"})
end

local function buildServerSettings(panel)
	panel:ClearControls()
	logoHeader(panel)
	panel:AddControl("Header", {Description = "Adjust server Photon settings"})

	panel:AddControl("CheckBox", {Label = "Enable Changing Siren Model", Command = "photon_emv_changesirens"})
	panel:AddControl("CheckBox", {Label = "Enable Changing Lighting Presets", Command = "photon_emv_changepresets"})
	panel:AddControl("CheckBox", {Label = "Enable Siren Running Outside Of Vehicle", Command = "photon_emv_stayon"})
	-- panel:AddControl("CheckBox", {Label = "Enable Rendering Illumination Light", Command = "photon_emv_useillum"})
end

local function createSirenOptions()
	list.Set("PhotonSirenOptions", "None",  {photon_creator_siren = "0"})
	local sirenTable = EMVU.GetSirenTable()
	for _, siren in ipairs(sirenTable) do
		list.Set("PhotonSirenOptions", siren.Category .. " - " .. siren.Name, {photon_creator_siren = tostring(i)})
	end
end

local function createLightbarOptions()
	list.Set("PhotonLightbarOptions", "None", {photon_creator_lightbar = 0})
	local autoComponents = EMVU.Auto
	for key, data in pairs( autoComponents ) do
		if data.Lightbar then
			list.Set("PhotonLightbarOptions", key, {photon_creator_lightbar = key})
		end
	end
end

local function buildCreatorMenu(panel)
	createSirenOptions()
	createLightbarOptions()

	panel:ClearControls()
	logoHeader(panel, "photon/ui/settings_creator.png")

	panel:AddControl("Header", {Description = "This is the Photon Creator menu. Here you can pre-customize a vehicle's settings and copy them when creating your own Photon car."})
	panel:AddControl("Header", {Description = "Basic Parameters:"})
	panel:AddControl("TextBox", {Label = "Vehicle Name", Command = "photon_creator_name", WaitForEnter = "0"})
	panel:AddControl("TextBox", {Label = "Spawn Category", Command = "photon_creator_category", WaitForEnter = "0"})
	panel:AddControl("ListBox", {Label = "Siren Model", Options = list.Get("PhotonSirenOptions"), Height = 80})
	panel:AddControl("ListBox", {Label = "Starter Lightbar", Options = list.Get("PhotonLightbarOptions"), Height = 80})
	panel:AddControl("Header", {Description = "Configure skins, bodygroups and colors on a vehicle. Sit in the vehicle and press the button below to copy the initial data to the clipboard."})
	panel:AddControl("Button", {Text = "Copy Configuration", Command = "photon_creator_copyconfig"})
end

local function buildExpressManager(panel)
	local expressPanel = vgui.Create("DPanel")
	expressPanel:Dock(FILL)
	expressPanel:SetHeight(600)
	expressPanel:SetBackgroundColor(invis)

	local defaultPanel, vehicleList, importButton, vehicleInfo

	local function drawVehicleInfo(infoPnl, clear, info)
		if clear and IsValid(vehicleInfo) then
			vehicleInfo:Remove()
			vehicleInfo = nil
		end

		vehicleInfo = vgui.Create("DPanel", infoPnl)
		vehicleInfo:Dock(TOP)
		vehicleInfo:DockMargin(0, 0, 0, 12)
		vehicleInfo:SetBackgroundColor(invis)

		local titleLabel = vgui.Create("DLabel", vehicleInfo)
		titleLabel:SetDark(1)
		titleLabel:SetText(info)
		titleLabel:Dock(TOP)
	end

	local function drawVehicleList(listPnl)
		importButton = vgui.Create("DButton", listPnl)
		importButton:Dock(TOP)

		importButton:SetText("Import Vehicle Code")
		importButton:DockMargin(140, 0, 0, 12)

		vehicleList = vgui.Create("DListView", listPnl)
		vehicleList:SetMultiSelect(false)
		vehicleList:Dock(TOP)
		vehicleList:SetHeight(140)
		vehicleList:AddColumn("Vehicle Name")

		function vehicleList:OnRowSelected(id, row)
			drawVehicleInfo(listPnl, true, row.File)
		end

		local vehicles = EMVU.FetchExpressVehicles()
		for _, vehicle in pairs(vehicles) do
			local newLine = vehicleList:AddLine(vehicle[1])
			newLine.File = vehicle[2]

			function newLine:OnCursorEntered()
				print(tostring(newLine.File))
			end
		end
	end

	local function createDefault()
		defaultPanel = vgui.Create("DPanel", expressPanel)
		defaultPanel:Dock(TOP)
		defaultPanel:SetHeight(400)
		defaultPanel:SetBackgroundColor(invis)
		drawVehicleList(defaultPanel)
	end

	-- local function clearPanels()
	-- 	if IsValid(defaultPanel) then
	-- 		defaultPanel:Remove()
	-- 		defaultPanel = nil
	-- 	end

	-- 	if IsValid(vehicleList) then
	-- 		vehicleList:Remove()
	-- 		vehicleList = nil
	-- 	end
	-- end

	createDefault()
	panel:AddItem(expressPanel)
end

hook.Add("PopulateToolMenu", "Photon.AddSettingsMenu", function()
	spawnmenu.AddToolMenuOption("Utilities", "Photon", "photon_settings_controls", "Controls", "", "", buildControlsMenu)
	spawnmenu.AddToolMenuOption("Utilities", "Photon", "photon_settings_client", "Client", "", "", buildClientSettings)
	spawnmenu.AddToolMenuOption("Utilities", "Photon", "photon_settings_server", "Settings", "", "", buildServerSettings)
	spawnmenu.AddToolMenuOption("Utilities", "Photon", "photon_settings_config_creator", "Configurations", "", "", Photon.Editor.CreateConfiguration)

	if game.SinglePlayer() then
		spawnmenu.AddToolMenuOption("Utilities", "Photon", "photon_settings_creator", "Express Creator", "", "", buildCreatorMenu)
		--spawnmenu.AddToolMenuOption("Utilities", "Photon", "photon_settings_express", "Express Vehicles", "", "", buildExpressManager)
		spawnmenu.AddToolMenuOption("Utilities", "Photon", "photon_settings_editor", "Express Editor", "", "", Photon.Editor.CreateMenu)
	end
end)

-- PrintTable( list.Get( "ThrusterSounds" ) )

-- cvars.RemoveChangeCallback("photon_christmas_mode_auto","photon.christmas.hook")
-- cvars.AddChangeCallback("photon_christmas_mode_auto",function(name, old, new)
-- 	if tonumber( new ) == 1 then
-- 		if PHOTON_CHRISTMAS_PERMIT then
-- 			RunConsoleCommand( "photon_christmas_mode", "1" )
-- 		end
-- 	else
-- 		RunConsoleCommand( "photon_christmas_mode", "0" )
-- 		chat.AddText( Color( 255, 255, 128), "Photon Holiday Mode has been disabled." )
-- 	end

-- end,"photon.christmas.hook")
