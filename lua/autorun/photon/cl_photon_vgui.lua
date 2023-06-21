
-- LIGHT COMPONENT PREVIEW --

local PANEL = {}

function PANEL:Init()

	self.Parent = vgui.Create( "DPanel", self )
	self.Parent:Dock( FILL )

	self.ModelViewer = vgui.Create( "DModelPanel", self.Parent )
	self.ModelViewer:SetSize( 96, 64 )
	self.ModelViewer:SetPos( 0, 0 )
	self.ModelViewer:SetCamPos( Vector( 50, 50, 10 ) )
	self.ModelViewer:SetLookAt( Vector( 0, 0, 0 ) )

	self.ComponentTitle = vgui.Create( "DLabel", self.Parent )
	self.ComponentTitle:SetPos( 96, 10 )
	self.ComponentTitle:SetSize( 200, 16 )
	self.ComponentTitle:SetDark( 1 )

	self.ComponentCategory = vgui.Create( "DLabel", self.Parent )
	self.ComponentCategory:SetPos( 96, 24 )
	self.ComponentCategory:SetSize( 200, 16 )
	self.ComponentCategory:SetTextColor( Color( 156, 156, 156 ) )

	self.ComponentInfo = vgui.Create( "DLabel", self.Parent )
	self.ComponentInfo:SetPos( 96, 40 )
	self.ComponentInfo:SetSize( 200, 16 )
	self.ComponentInfo:SetTextColor( Color( 27, 131, 204 ) )

	self:SetHeight( 64 )

end

function PANEL:SetComponent( componentId )
	if componentId == false then
		self.ModelViewer:SetModel( "" )
		self.ComponentTitle:SetText( "" )
		self.ComponentCategory:SetText( "" )
		self.ComponentInfo:SetText( "" )
	elseif componentId then

		local component = EMVU.Auto[ componentId ]
		if not component then
			Photon.Logging.Error("Could not find Component ID: ", componentId)
			return
		end

		self.ModelViewer:SetModel( component.Model or "" )
		if self.ModelViewer:GetEntity() then
			self.ModelViewer:GetEntity():SetSkin( 0 )
			if component.Skin then self.ModelViewer:GetEntity():SetSkin( component.Skin ) end
		end
		self.ComponentTitle:SetText( componentId )
		self.ComponentCategory:SetText( component.Category or "Unknown Type" )

		local infoText = ""
		if component.DefaultColors then infoText = infoText .. tostring( #component.DefaultColors ) .. " COL | " end
		if component.UsePhases then infoText = infoText .. "A/B | " end
		if istable( component.Modes) and istable( component.Modes.Auxiliary ) then infoText = infoText .. "AUX | " end
		if string.len( infoText ) > 3 then infoText = string.sub( infoText, 1, string.len( infoText ) - 3 ) end

		self.ComponentInfo:SetText( infoText )

	end

end

vgui.Register( "PhotonComponentPreview", PANEL, "DPanel" )