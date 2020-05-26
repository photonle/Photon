AddCSLuaFile()

if not Photon.Editor then Photon.Editor = {} end

Photon.Editor.SetTarget = function( name )
	Photon.Editor.TargetName = name
	Photon.Editor.SetTargetTable( name )
end

Photon.Editor.GetTarget = function()
	return Photon.Editor.TargetName
end

Photon.Editor.SetComponentTarget = function( component )
	Photon.Editor.ComponentTarget = component
end

Photon.Editor.GetComponentTable = function()
	return Photon.Editor.TargetTable.Auto[Photon.Editor.GetComponentTarget()]
end

Photon.Editor.GetComponentTarget = function()
	return Photon.Editor.ComponentTarget
end

Photon.Editor.SetTargetTable = function( name )
	local vehicleTable = list.Get( "Vehicles" )[ name ]
	if not vehicleTable then return false end
	Photon.Editor.TargetTable = vehicleTable.EMV
end

Photon.Editor.Update = function()
	if not Photon.Editor.TargetName then return end
	EMVU:OverwriteIndex( Photon.Editor.GetTarget(), Photon.Editor.TargetTable )
end


concommand.Add( "photon_emv_editor_target", function( ply, cmd, args )
	photon_emv_editor_target = args[1]
	Photon.Editor.SetTarget( photon_emv_editor_target )
	if PHOTON_EDITOR_MENU_REF then Photon.Editor.CreateMenu( PHOTON_EDITOR_MENU_REF ) end
end )

concommand.Add( "photon_emv_editor_target_component", function( ply, cmd, args )
	photon_emv_editor_target_component = tonumber(args[1])
	Photon.Editor.SetComponentTarget( tonumber( args[1] ) )
	if PHOTON_EDITOR_MENU_REF then Photon.Editor.CreateMenu( PHOTON_EDITOR_MENU_REF ) end
end )

concommand.Add( "photon_emv_editor_update", function()
	Photon.Editor.Update()
end )

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
		list.Set( "PhotonEMVTargetComponents", string.format( "%s. %s", i, light.ID ), { ["photon_emv_editor_target_component"] = i } )
	end
end

local function buildComponentPreview( panel )
	panel.Preview = vgui.Create( "PhotonComponentPreview" )
	panel.Preview:Dock( TOP )
	panel.Preview:SetComponent( false )
	panel:AddItem( panel.Preview )
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
		local newLine = componentList:AddLine( tonumber(i), tostring(component.ID) )
		newLine.Component = component.ID
		function newLine:OnCursorEntered()
			//if panel.Preview then panel.Preview:SetComponent( self.Component ) end
		end
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
	autoList:AddColumn( "Component Name" )
	local categoryColumn = autoList:AddColumn( "Type" )
	categoryColumn:SetFixedWidth( 70 )

	for name,component in pairs( autoLibrary ) do
		local newLine = autoList:AddLine( name, component.Category or "Unknown" )
		newLine.NameIndex = name
		function newLine:OnCursorEntered()
			if panel.Preview then panel.Preview:SetComponent( self.NameIndex ) end
		end
	end

	function autoList:OnRowSelected( id, row )
		RunConsoleCommand( "photon_emv_editor_create", row.NameIndex )
	end

	autoList:SortByColumn( 1 )
	buildComponentPreview( panel )
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
					Photon.Editor.GetComponentTable()["Color" .. tostring(i)] = data
					Photon.Editor.Update()


				end
			end
		end
		colorProperties:SetSize( 1, 70 )
		panel:AddItem( colorProperties )
	end
end

local function buildComponentAxisAdjust( id, label, parent, inc, init, typ )
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
	xScratchPanel:SetZoom( 125 )
	local xNumWang = vgui.Create( "DNumberWang", xPanel )
	xNumWang:SetPos( 38, 7 )
	xNumWang:SetSize( 47, 17 )
	xNumWang:SetDecimals( 2 )
	xNumWang:SetMin( -500 )
	xNumWang:SetMax( 500 )
	local function adjustNumber( val )
		Photon.Editor.GetComponentTable()[typ][id] = val
		Photon.Editor.Update()
	end
	function xScratchPanel:OnValueChanged( val )
		xNumWang:SetValue( val )
		adjustNumber( val )
	end
	function xNumWang:OnValueChanged( val )
		xScratchPanel:SetValue( val )
		adjustNumber( val )
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
	buildComponentAxisAdjust( "x", "X", posPanel, 0, autoIndex.Pos.x, "Pos" )
	buildComponentAxisAdjust( "y", "Y", posPanel, 1, autoIndex.Pos.y, "Pos" )
	buildComponentAxisAdjust( "z", "Z", posPanel, 2, autoIndex.Pos.z, "Pos" )
	panel:AddItem( posPanel )

	panel:AddControl( "Header", { Description = "Angle: " } )
	local angPanel = vgui.Create( "DPanel" )
	angPanel:SetBackgroundColor( Color( 0, 0, 0, 32 ) )
	angPanel:Dock( FILL )
	angPanel:SetSize( 1, 30 )
	buildComponentAxisAdjust( "p", "P", angPanel, 0, autoIndex.Ang.p, "Ang" )
	buildComponentAxisAdjust( "y", "Y", angPanel, 1, autoIndex.Ang.y, "Ang" )
	buildComponentAxisAdjust( "r", "R", angPanel, 2, autoIndex.Ang.r, "Ang" )
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
	RunConsoleCommand( "photon_comp_editor_scale", tonumber( autoIndex.Scale ) or 1 )
	panel:AddControl( "Slider", { Label = "Scale", Command = "photon_comp_editor_scale", Type = "Float", Min = 0, Max = 5 } )
end

cvars.RemoveChangeCallback("photon_comp_editor_scale","photon_target_edit_scale")
cvars.AddChangeCallback("photon_comp_editor_scale",function(name, old, new)
	Photon.Editor.GetComponentTable()["Scale"] = tonumber( new )
	Photon.Editor.Update()
end,"photon_target_edit_scale")

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
		function noButton:DoClick() buildComponentRemove( panel, false ); if PHOTON_EDITOR_MENU_REF then Photon.Editor.CreateMenu( PHOTON_EDITOR_MENU_REF ) end end
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


Photon.Editor.CreateMenu = function( panel )
	panel:ClearControls()
	PHOTON_EDITOR_MENU_REF = panel
	createPhotonTargetList()
	if photon_emv_editor_target then
		panel:AddControl( "Header", { Description = "Selected: " .. tostring( photon_emv_editor_target ) } )
		panel:AddControl( "Button", { Text = "Change Target Vehicle", Command = "photon_emv_editor_target;photon_emv_editor_target_component" } )
		RunConsoleCommand( "photon_express_edit", 1 )
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
		RunConsoleCommand( "photon_express_edit", 0 )
	end
end

local photon_cfgbld_name = ""
local photon_cfgbld_cat = false
local photon_cfgbld_bge = true
local photon_cfgbld_liv = true
local photon_cfgbld_srn = true

CreateClientConVar("photon_cfgbld_name", "", false, false, "Photon Configuration Name")
CreateClientConVar("photon_cfgbld_cat", "", false, false, "Photon Configuration Category")
CreateClientConVar("photon_cfgbld_bge", "", false, false, "Photon Configuration Bodygroups & Equipment")
CreateClientConVar("photon_cfgbld_liv", "", false, false, "Photon Configuration Livery")
CreateClientConVar("photon_cfgbld_srn", "", false, false, "Photon Configuration Siren")

function Photon.Editor.CreateConfiguration(panel)
	-- Clear the panel.
	panel:ClearControls()

	-- Add the header.
	panel:Help("This is the Photon Configurations menu. Configurations are an easy way to save equipment, siren and livery configurations. Local configurations will only appear to you, while copying the Lua snippet allows server administrators and addon authors to include their own.")

	-- Text Configs.
	panel:TextEntry("Name", "photon_cfgbld_name")
	panel:TextEntry("Category", "photon_cfgbld_cat")

	-- Selections
	panel:CheckBox("Bodygroups & Equipment", "photon_cfgbld_bge")
	panel:CheckBox("Livery & Color", "photon_cfgbld_liv")
	panel:CheckBox("Siren Models", "photon_cfgbld_srn")

	-- Output Stage
	panel:Button("Save as Local Configuration", "photon_cfgbld_savelocal")
	panel:Button("Copy Lua for Export", "photon_cfgbld_getlua")


	-- Config Manager
	panel:Help("Select row to DELETE local configuration:")

	local configList = vgui.Create("DListView")
	configList:SetSize(30, 120)
	configList:SetMultiSelect(false)
	configList:AddColumn("Car"):SetFixedWidth(50)
	configList:AddColumn("Date"):SetFixedWidth(70)
	configList:AddColumn("Name")

	function panel:MetaReset()
		configList:ClearSelection()
		configList:Clear()

		local configs = EMVU.Configurations.Library
		for _, car in pairs(configs) do
			for key, data in pairs(car) do
				if data.StoreType ~= "LOCAL FILE" then continue end

				local line = configList:AddLine(data.VehicleTypeID, data.Date, data.Name)
				line.File = data.FileName
			end
		end
	end
	panel:MetaReset()

	function configList:OnRowSelected(id, row)
		if row.File then
			EMVU.Configurations.DeleteConfiguration(row.File)
		end
		panel:MetaReset()
	end

	configList:SortByColumn(3)
	panel:AddItem(configList)

	hook.Add("Photon.NewConfig", "PhotonEditorReset", function()
		panel:MetaReset()
	end)
end

concommand.Add("photon_cfgbld_savelocal", function()
	local ply = LocalPlayer()
	if not IsValid(ply) then return end

	local ent = ply:GetVehicle()
	if not IsValid(ent) then
		chat.AddText(Color(255, 128, 64), "[Photon] You must be driving the vehicle you wish to save the configuration from." )
		return
	end

	local bge = GetConVar("photon_cfgbld_bge"):GetBool()
	local liv = GetConVar("photon_cfgbld_liv"):GetBool()
	local srn = GetConVar("photon_cfgbld_srn"):GetBool()
	local resultData = ent:Photon_ExportConfiguration(bge, liv, liv, srn, bge)
	if not resultData then
		chat.AddText(Color(255, 128, 64), "[Photon] This vehicle is not compatible with Photon Configurations." )
		return
	end

	local name = GetConVar("photon_cfgbld_name"):GetString()
	local cat = GetConVar("photon_cfgbld_cat"):GetString()
	local result = EMVU.Configurations.SaveConfiguration(name, cat, LocalPlayer():Name(), resultData)
	if not result then
		chat.AddText(Color(255, 128, 64), "[Photon] An error occurred while saving vehicle configuration.")
		return
	end

	chat.AddText(Color(128, 255, 64), string.format(
		"[Photon] %s has been saved, this configuration can now be selected from the Photon context menu.",
		name
	))
	hook.Run("Photon.NewConfig", name, cat, resultData)
end)

local luaConfigInstructions = [[
1. Paste copied text into a text editor (Notepad++ or better recommended).
2. Save file under lua/autorun of your addon or server, name is irrelevant.
3. Config data will automatically load onto server players or addon users. Game restart may be initially required.
]]

concommand.Add( "photon_cfgbld_getlua", function()
	local ply = LocalPlayer()
	local ent = ply:GetVehicle()
	if not IsValid( ent ) then chat.AddText( Color(255, 128, 64), "[Photon] You must be driving the vehicle you wish to save the configuration from." ) return end
	local resultData = ent:Photon_ExportConfiguration( photon_cfgbld_bge, photon_cfgbld_liv, photon_cfgbld_liv, photon_cfgbld_srn, photon_cfgbld_bge )
	if not resultData then chat.AddText( Color(255, 128, 64), "[Photon] This vehicle is not compatible with Photon Configurations." ) return end
	local result = EMVU.Configurations.ConfigurationLua( photon_cfgbld_name, photon_cfgbld_cat, LocalPlayer():Name(), resultData )
	if result then
		SetClipboardText( result )
		chat.AddText( Color(128, 255, 64), string.format( "[Photon] %s has been exported to your clipboard.", tostring( photon_cfgbld_name )  ) )
		chat.AddText( Color(255, 255, 255), luaConfigInstructions )
		return
	else
		chat.AddText( Color(255, 128, 64), "[Photon] An error occurred while saving vehicle configuration." )
		return
	end
end )
