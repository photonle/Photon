-- ProtectedCall only exists inside Garry's Mod, and the function file
-- captures it at include time.
TRIAL
	:Name("Photon: Quarantined Dispatch")
	:Description(
		"The call patterns available to Photon.RunQuarantined, which wraps per-entity scan and render callbacks so one vehicle with "
		.. "broken data cannot kill a shared timer or repeat an error every frame: calling directly, pcall, xpcall with a "
		.. "stack-reporting handler, and Garry's Mod's ProtectedCall."
	)
	:Order(201)
	:If(ProtectedCall ~= nil)
