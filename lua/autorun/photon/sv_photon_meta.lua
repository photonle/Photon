util.AddNetworkString("PhotonLE.Photon.SetupCar")

function Photon:SetupCar(ent, index)
	ent:SetPhotonNet_Headlights(false)
	ent:SetPhotonNet_Braking(false)
	ent:SetPhotonNet_Running(false)
	ent:SetPhotonNet_Reversing(false)
	ent:Photon_SignalStop()

	if ent:Photon_WheelEnabled() then
		ent:Photon_SetWheelIndex(1)
	end

	ent:SetNW2String("PhotonLE.CAR_PHOTON_NAME", index)
	ent:SetNW2Bool("PhotonLE.CAR_HAS_PHOTON", true)
end
