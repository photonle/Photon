AddCSLuaFile()

hook.Add( "AddToolMenuCategories", "Photon.AddMenuCategory", function()
	spawnmenu.AddToolCategory( "Utilities", "Photon", "Photon" )
end)

local function logoHeader( panel, imgpath )
	if not imgpath then imgpath = "photon/ui/settings_logo.png" end
	panel:AddControl( "Header", { Description = ( string.format( "Photon Lighting Engine | %s | Update #%s", tostring( PHOTON_SERIES ), tostring( PHOTON_UPDATE ) ) ) } )
	local parent = vgui.Create( "DPanel" )
	parent:SetSize( 300, 256 )
	parent:SetBackgroundColor( Color( 0, 0, 0, 0 ) )
	local header = vgui.Create( "DImage", parent )
	header:SetImage( imgpath )
	header:SetSize( 256, 256 )
	panel:AddPanel( parent )
	header:Center()
end

local function buildControlsMenu( panel )
	panel:ClearControls()
	logoHeader( panel )
	panel:AddControl( "Header", { Description = "Adjust the keys for Photon controls" } )

	panel:AddControl( "Numpad", { Label = "Primary Lights On/Off", Command="photon_key_primary_toggle", Label2 = "Primary Lights Mode", Command2="photon_key_primary_alt" } )
	panel:AddControl( "Numpad", { Label = "Siren On/Off", Command="photon_key_siren_toggle", Label2 = "Siren Tone", Command2="photon_key_siren_alt" } )
	panel:AddControl( "Numpad", { Label = "Auxiliary Lights", Command="photon_key_auxiliary", Label2 = "Illumination", Command2="photon_key_illum" } )
	panel:AddControl( "Numpad", { Label = "Horn", Command="photon_key_horn", Label2 = "Siren Manual", Command2="photon_key_manual" } )
	panel:AddControl( "Numpad", { Label = "Blackout Mode", Command="photon_key_blackout" } )
end

local function buildClientSettings( panel )
	panel:ClearControls()
	logoHeader( panel )
	panel:AddControl( "Header", { Description = "Adjust your local Photon settings" } )

	panel:AddControl( "CheckBox", { Label = "Enable Emergency Lighting", Command = "photon_emerg_enabled" } )
	panel:AddControl( "CheckBox", { Label = "Enable Standard Lighting", Command = "photon_stand_enabled" } )
	panel:AddControl( "CheckBox", { Label = "Enable Lens Flare Effects", Command = "photon_lens_effects" } )
	panel:AddControl( "Header", { Description = "Change HUD settings" } )
	panel:AddControl( "Slider", { Label = "Opacity", Command = "photon_hud_opacity", Type = "Float", Min = "0", Max = "1" } )

	panel:AddControl( "Header", { Description = "Personal Options" } )
	panel:AddControl( "TextBox", { Label = "Unit ID", Command = "photon_emerg_unit", WaitForEnter = "1", Max = "3" })
end

local function buildServerSettings( panel )
	panel:ClearControls()
	logoHeader( panel )
	panel:AddControl( "Header", { Description = "Adjust server Photon settings" } )

	panel:AddControl( "CheckBox", { Label = "Enable Changing Siren Model", Command = "photon_emv_changesirens" } )
	panel:AddControl( "CheckBox", { Label = "Enable Changing Lighting Presets", Command = "photon_emv_changepresets" } )
	// panel:AddControl( "CheckBox", { Label = "Enable Rendering Illumination Light", Command = "photon_emv_useillum" } )
end

local function createSirenOptions()
	list.Set( "PhotonSirenOptions", "None",  { ["photon_creator_siren"] = "0" } )
	local sirenTable = EMVU.Sirens
	for i=1,#EMVU.Sirens do
		local siren = EMVU.Sirens[i]
		list.Set( "PhotonSirenOptions", siren.Category .. " - " .. siren.Name, { ["photon_creator_siren"] = tostring( i ) } )
	end
end

local function createLightbarOptions()
	list.Set( "PhotonLightbarOptions", "None", { ["photon_creator_lightbar"] = 0 } )
	local autoComponents = EMVU.Auto
	for key, data in pairs( autoComponents ) do
		if data.Lightbar then
			list.Set( "PhotonLightbarOptions", key, { ["photon_creator_lightbar"] = key } )
		end
	end
end

local function buildCreatorMenu( panel )
	createSirenOptions()
	createLightbarOptions()
	panel:ClearControls()
	logoHeader( panel, "photon/ui/settings_creator.png" )
	panel:AddControl( "Header", { Description = "This is the Photon Creator menu. Here you can pre-customize a vehicle's settings and copy them when creating your own Photon car." } )
	panel:AddControl( "Header", { Description = "Basic Parameters:" } )
	panel:AddControl( "TextBox", { Label = "Vehicle Name", Command = "photon_creator_name", WaitForEnter = "0" } )
	panel:AddControl( "TextBox", { Label = "Spawn Category", Command = "photon_creator_category", WaitForEnter = "0" } )
	panel:AddControl( "ListBox", { Label = "Siren Model", Options = list.Get( "PhotonSirenOptions" ), Height = 80 } )
	panel:AddControl( "ListBox", { Label = "Starter Lightbar", Options = list.Get( "PhotonLightbarOptions" ), Height = 80 } )
	panel:AddControl( "Header", { Description = "Configure skins, bodygroups and colors on a vehicle. Sit in the vehicle and press the button below to copy the initial data to the clipboard." } )
	panel:AddControl( "Button", { Text = "Copy Configuration", Command = "photon_creator_copyconfig" } )
end

local function createPhotonTargetList()
	local photonEmvs = EMVU.AutoIndex
	for key,_ in pairs( photonEmvs ) do
		list.Set( "PhotonEMVTargets", key, { ["photon_emv_editor_target"] = key } )
	end
end

local function createPhotonTargetLights( index )
	local autoComponents = EMVU.AutoIndex[index]
	table.Empty( list.GetForEdit( "PhotonEMVTargetComponents" ) )
	
	for i=1,#autoComponents do
		local light = autoComponents[i]
		-- list.Set( "PhotonEMVTargetComponents", i, tostring(i) .. ". " .. light.ID )
		list.Set( "PhotonEMVTargetComponents", string.format( "%s. %s", i, light.ID ), { ["photon_emv_editor_target_component"] = i } )
	end
end

local function buildComponentList( panel )
	panel:AddControl( "Header", { Description = "Modify existing component: " } )

	local autoComponents = EMVU.AutoIndex[ tostring( photon_emv_editor_target ) ]
	local componentList = vgui.Create( "DListView" )
	componentList:SetMultiSelect( false )
	componentList:SetSize( 30, 80 )
	local idColumn = componentList:AddColumn( "ID" )
	idColumn:SetFixedWidth( 40 )
	local nameColumn = componentList:AddColumn( "Component Name" )
	for i=1,#autoComponents do
		local component = autoComponents[i]
		componentList:AddLine( tonumber(i), tostring(component.ID) )
	end

	function componentList:OnRowSelected( id )
		RunConsoleCommand("photon_emv_editor_target_component", tostring(id))
	end

	componentList:SortByColumn(1)

	panel:AddItem( componentList )

	panel:AddControl( "Header", { Description = "Add a new component: " } )

	local autoLibrary = EMVU.Auto
	local autoList = vgui.Create( "DListView" )
	autoList:SetMultiSelect( false )
	autoList:SetSize( 30, 120 )
	autoList:AddColumn( "New Component Name" )

	for name,_ in pairs( autoLibrary ) do
		autoList:AddLine( name ).NameIndex = name
	end	

	function autoList:OnRowSelected( id, row )
		RunConsoleCommand( "photon_emv_editor_create", row.NameIndex )
	end

	autoList:SortByColumn( 1 )
	panel:AddItem( autoList )
end

local function buildTargetVehicles( panel )
	local photonEmvs = EMVU.AutoIndex
	local emvList = vgui.Create( "DListView" )
	emvList:SetMultiSelect( false )
	emvList:SetSize( 30, 160 )
	emvList:AddColumn( "Vehicle Name" )

	function emvList:OnRowSelected( id, row )
		RunConsoleCommand( "photon_emv_editor_target", row.NameIndex )
	end

	for name,_ in pairs( photonEmvs ) do
		emvList:AddLine( name ).NameIndex = name
	end
	emvList:SortByColumn(1)

	panel:AddItem( emvList )
end

local function buildComponentColorEdit( panel )
	local colors = EMVU.Colors
	local component = EMVU.Auto[EMVU.AutoIndex[photon_emv_editor_target][photon_emv_editor_target_component].ID]
	local autoIndex = EMVU.AutoIndex[photon_emv_editor_target][photon_emv_editor_target_component]
	if component.DefaultColors and istable(component.DefaultColors) then
		local colorProperties = vgui.Create( "DProperties" )
		for i=1,#component.DefaultColors do
			local colorChoice = colorProperties:CreateRow( "Color Configuration", "Color #" .. tostring(i) )
			colorChoice:Setup( "Combo", {} )
			for key,_ in pairs( colors ) do

				colorChoice:AddChoice( key, key, ((autoIndex["Color" .. tostring(i)] and autoIndex["Color" .. tostring(i)] == key) or (component.DefaultColors and component.DefaultColors[i] == key )) )
				function colorChoice:DataChanged( data )
					autoIndex["Color" .. tostring(i)] = data
					print( "Changed Color" .. tostring(i) .. " to " .. tostring(data) )
				end
			end
		end
		colorProperties:SetSize( 1, 70 )
		panel:AddItem( colorProperties )
	end
end

local function buildComponentAxisAdjust( id, label, parent, inc, init )
	local xPanel = vgui.Create( "DPanel", parent )
	xPanel:SetPos( inc*90, 0 )
	xPanel:SetSize( 90, 30 )
	xPanel:SetBackgroundColor( Color( 0, 0, 0, 0 ) )
	local xLabel = vgui.Create( "DLabel", xPanel )
	xLabel:SetText( label )
	xLabel:SetDark( 1 )
	xLabel:SetPos( 6, 6 )
	local xScratchPanel = vgui.Create( "DNumberScratch", xPanel )
	xScratchPanel:SetPos( 10, 0 )
	xScratchPanel:SetSize( 32, 32 )
	xScratchPanel:SetMin( -500 )
	xScratchPanel:SetMax( 500 )
	local xNumWang = vgui.Create( "DNumberWang", xPanel )
	xNumWang:SetPos( 38, 7 )
	xNumWang:SetSize( 47, 17 )
	xNumWang:SetDecimals( 2 )
	xNumWang:SetMin( -500 )
	xNumWang:SetMax( 500 )
	function xScratchPanel:OnValueChanged( val )
		xNumWang:SetValue( val )
	end
	function xNumWang:OnValueChanged( val )
		xScratchPanel:SetValue( val )
	end
	if init then xScratchPanel:SetValue( init ); xNumWang:SetValue( init ) end
end

local function buildComponentPositionEdit( panel )
	local autoIndex = EMVU.AutoIndex[photon_emv_editor_target][photon_emv_editor_target_component]
	panel:AddControl( "Header", { Description = "Position: " } )
	local posPanel = vgui.Create( "DPanel" )
	posPanel:SetBackgroundColor( Color( 0, 0, 0, 32 ) )
	posPanel:Dock( FILL )
	posPanel:SetSize( 1, 30 )
	buildComponentAxisAdjust( "p_x", "X", posPanel, 0, autoIndex.Pos.x )
	buildComponentAxisAdjust( "p_y", "Y", posPanel, 1, autoIndex.Pos.y )
	buildComponentAxisAdjust( "p_z", "Z", posPanel, 2, autoIndex.Pos.z )
	panel:AddItem( posPanel )

	panel:AddControl( "Header", { Description = "Angle: " } )
	local angPanel = vgui.Create( "DPanel" )
	angPanel:SetBackgroundColor( Color( 0, 0, 0, 32 ) )
	angPanel:Dock( FILL )
	angPanel:SetSize( 1, 30 )
	buildComponentAxisAdjust( "a_p", "P", angPanel, 0, autoIndex.Ang.p )
	buildComponentAxisAdjust( "a_y", "Y", angPanel, 1, autoIndex.Ang.y )
	buildComponentAxisAdjust( "a_r", "R", angPanel, 2, autoIndex.Ang.r )
	panel:AddItem( angPanel )
end

local function buildComponentPhaseEdit( panel )
	local component = EMVU.Auto[EMVU.AutoIndex[photon_emv_editor_target][photon_emv_editor_target_component].ID]
	local autoIndex = EMVU.AutoIndex[photon_emv_editor_target][photon_emv_editor_target_component]
	if component.UsePhases then
		local phaseCombo = vgui.Create( "DComboBox")
		phaseCombo:AddChoice( "No phase" )
		phaseCombo:AddChoice( "Phase A" )
		phaseCombo:AddChoice( "Phase B" )
		if autoIndex.Phase then phaseCombo:SetValue( "Phase " .. tostring( autoIndex.Phase ) ) else phaseCombo:SetValue( "No phase") end
		panel:AddItem( phaseCombo )
	end
end

local function buildComponentScale( panel )
	local autoIndex = EMVU.AutoIndex[photon_emv_editor_target][photon_emv_editor_target_component]
	RunConsoleCommand( "photon_comp_editor_scale", autoIndex.Scale or 1 )
	panel:AddControl( "Slider", { Label = "Scale", Command = "photon_comp_editor_scale", Type = "Float", Min = 0, Max = 5 } )
end

local deleteButton, confirmPanel
local function buildComponentRemove( panel, confirm )
	if not confirm then
		if confirmPanel then confirmPanel:Remove() end
		deleteButton = vgui.Create( "DButton" )
		deleteButton:SetText( "Delete this component" )
		function deleteButton:DoClick()
			buildComponentRemove( panel, true )
		end
		panel:AddItem( deleteButton )
	else
		if deleteButton then deleteButton:Remove() end
		confirmPanel = vgui.Create( "DPanel" )
		confirmPanel:SetSize( 1, 60 )
		local confirmHeader = vgui.Create( "DLabel", confirmPanel )
		confirmHeader:SetText( "Are you sure you want to delete this component?")
		confirmHeader:SetPos( 10, 5 )
		confirmHeader:SetDark( 1 )
		confirmHeader:SetSize( 250, 12 )
		local noButton = vgui.Create( "DButton", confirmPanel )
		noButton:SetText( "No" )
		noButton:SetSize( 150, 25 )
		noButton:SetPos( 10, 25 )
		function noButton:DoClick() buildComponentRemove( panel, false ); if PHOTON_EDITOR_MENU_REF then Photon_EditorMenu( PHOTON_EDITOR_MENU_REF ) end end
		local yesButton = vgui.Create( "DButton", confirmPanel )
		yesButton:SetText( "Yes")
		yesButton:SetSize( 100, 25 )
		yesButton:SetPos( 170, 25 )
		function yesButton:DoClick() print("delete component") end
		panel:AddItem( confirmPanel )
	end
end

local function buildComponentEdit( panel )
	buildComponentRemove( panel, false )
	buildComponentColorEdit( panel )
	buildComponentPhaseEdit( panel )
	buildComponentPositionEdit( panel )
	buildComponentScale( panel )
end

function Photon_EditorMenu( panel )
	panel:ClearControls()
	PHOTON_EDITOR_MENU_REF = panel
	logoHeader( panel )
	createPhotonTargetList()
	if photon_emv_editor_target then
		panel:AddControl( "Header", { Description = "Selected: " .. tostring( photon_emv_editor_target ) } )
		panel:AddControl( "Button", { Text = "Change Target Vehicle", Command = "photon_emv_editor_target;photon_emv_editor_target_component" } )
		
		if photon_emv_editor_target_component then
			panel:AddControl( "Header", { Description = "Selected: #" .. tostring(photon_emv_editor_target_component) .. " | " .. tostring( EMVU.AutoIndex[photon_emv_editor_target][photon_emv_editor_target_component].ID ) } )
			panel:AddControl( "Button", { Text = "Change Component Selection", Command = "photon_emv_editor_target_component" } )

			buildComponentEdit( panel )
			
		else
			buildComponentList( panel )
		end
		
	else
		panel:AddControl( "Header", { Description = "Select a vehicle to modify: " } )
		buildTargetVehicles( panel )
	end
end

hook.Add( "PopulateToolMenu", "Photon.AddSettingsMenu", function() 
	spawnmenu.AddToolMenuOption( "Utilities", "Photon", "photon_settings_controls", "Controls", "", "", buildControlsMenu )
	spawnmenu.AddToolMenuOption( "Utilities", "Photon", "photon_settings_client", "Client", "", "", buildClientSettings )
	spawnmenu.AddToolMenuOption( "Utilities", "Photon", "photon_settings_server", "Settings", "", "", buildServerSettings )
	if game.SinglePlayer() then
		spawnmenu.AddToolMenuOption( "Utilities", "Photon", "photon_settings_creator", "Creator", "", "", buildCreatorMenu )
		spawnmenu.AddToolMenuOption( "Utilities", "Photon", "photon_settings_editor", "Component Editor", "", "", Photon_EditorMenu )
	end
end )

-- PrintTable( list.Get( "ThrusterSounds" ) )
