AddCSLuaFile()

PHOTON_REG_ENABLED = true

function DrawCarLights()
	local photonDebug = PHOTON_DEBUG
	for _,ent in pairs(ents.GetAll()) do
		if IsValid( ent ) then
			if ent:Photon() and ent.RenderLights then
				if PHOTON_REG_ENABLED then ent:RenderLights( 
					ent:HeadlightsOn(), 
					ent:IsRunning(), 
					ent:IsReversing(), 
					ent:IsBraking(), 
					ent:TurningLeft(), 
					ent:TurningRight(), 
					ent:Hazards(), 
					photonDebug
					) end

				if ent:IsEMV() then ent:ScanEMVProps() end
			elseif ent:Photon() and not ent.RenderLights then
				Photon:SetupCar( ent, ent:Photon() )
			end
		end
	end
end
hook.Add("PostDrawTranslucentRenderables", "Photon.Scan", DrawCarLights)

function Photon:AdjustFrameTime()
	if FrameTime() >= EMV_FRAME_DUR or FrameTime() < EMV_FRAME_DUR and FrameTime() > EMV_FRAME_CONST then 
		EMV_FRAME_DUR = FrameTime()
	elseif FrameTime() < EMV_FRAME_CONST then
		EMV_FRAME_DUR = EMV_FRAME_CONST
	end
end
hook.Add("PreRender", "Photon.AdjustFrameTime", function()
	Photon:AdjustFrameTime()
end)

local function TurnScan()
	local ply = LocalPlayer()
	if not ply or not ply:IsValid() or not ply:InVehicle() or not ply:GetVehicle() then return end
	local car = ply:GetVehicle()
	if not IsValid( car ) then return end
	if not car:Photon() then return end
	if ply:KeyDown( IN_MOVERIGHT ) and car:TurningRight() then 
		car.Lighting.GoingForward = false
		return
	end
	if not ply:KeyDown( IN_FORWARD ) then
		car.Lighting.GoingForward = false
		return
	end
	if car:TurningLeft() and ply:KeyDown( IN_MOVELEFT ) then
		car.Lighting.GoingForward = false
		return
	end
	
	if car.Lighting.GoingForward and (car:Photon_AdjustedSpeed() > 25) then
		if CurTime() >= car.Lighting.ForwardDuration then
			Photon:CarSignal( "none" )
		end
	else
		car.Lighting.ForwardDuration = CurTime() + 1
		car.Lighting.GoingForward = true
	end

end

hook.Add("Tick", "Photon.TurnScan", function() TurnScan() end)

local function SettingsScan()
	--if istable(VC_Settings_Data) and VC_Settings_Data.VC_Enabled then PHOTON_REG_ENABLED = false return end
	PHOTON_REG_ENABLED = true
end
hook.Add("Tick", "Photon.SettingsScan", function() SettingsScan() end)

local function RemoveCarProps( ent )
	if IsValid( ent ) and ent:IsVehicle() and ent:HasELS() and ent.EMVProps then
		for _,prop in pairs( ent.EMVProps ) do
			prop:Remove()
		end
	end
end
hook.Add("EntityRemoved", "Photon.RemoveCarProps", RemoveCarProps)

