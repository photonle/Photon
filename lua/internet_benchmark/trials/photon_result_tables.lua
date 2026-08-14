local SLOTS = 31

local reused = {}

local out

local function a(times)
	local tab = {}
	for i = 1, SLOTS do
		tab[i] = times
	end
	out = tab
end

local function b(times)
	local tab = {
		true, true, true, true, true, true, true, true,
		true, true, true, true, true, true, true, true,
		true, true, true, true, true, true, true, true,
		true, true, true, true, true, true, true
	}
	for i = 1, SLOTS do
		tab[i] = times
	end
	out = tab
end

local function c(times)
	for i = 1, SLOTS do
		reused[i] = times
	end
	out = reused
end

TRIAL
	:Name("Photon: Per-Light Result Tables")
	:Description(
		"Photon:PrepareVehicleLight builds a 31-slot render table for every visible light, every frame, by allocating a literal "
		.. "prefilled with 31 trues and then overwriting the slots. This compares that against growing an empty table and against "
		.. "reusing one table across calls."
	)
	:Order(200)
	:Function(a)
	:Label("fresh {}")
	:Describe("A new empty table each call, grown one indexed write at a time - the array part reallocates as it grows.")
	:Function(b)
	:Label("prefilled literal")
	:Describe("What Photon currently does: a literal of 31 trues sizes the array part in one go, at the cost of writing every slot twice.")
	:Function(c)
	:Label("reused table")
	:Describe("One table shared across calls, so nothing is allocated at all - only safe when the consumer is done with the previous contents, which Photon's render queue is not.")
	:Before(function()
		reused = {}
	end)
	:ManualPredefine(1, 3)
	:Exclude("SLOTS")
	:Exclude("reused")
	:Exclude("out")
