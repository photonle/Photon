local eyePos = Vector(90, -1408, 64)
local lightPos = Vector(128, -1200, 96)

local scratch = Vector()
local newVector = Vector

local out

local function a()
	local normal = lightPos - eyePos
	normal:Normalize()
	out = normal
end

local function b()
	out = (lightPos - eyePos):GetNormalized()
end

local function c()
	local normal = newVector(lightPos)
	normal:Sub(eyePos)
	normal:Normalize()
	out = normal
end

local function d()
	scratch:Set(lightPos)
	scratch:Sub(eyePos)
	scratch:Normalize()
	out = scratch
end

TRIAL
	:Name("Photon: View Normal Vectors")
	:Description(
		"Photon computes a view normal (light position minus eye position, normalised) for every visible light, every frame. "
		.. "This compares the allocating forms - the subtraction operator and GetNormalized - against copy-then-mutate and "
		.. "against reusing one scratch vector, which is what the engine does."
	)
	:Order(204)
	:Function(a)
	:Label("operator + Normalize")
	:Describe("The subtraction operator allocates one new Vector, normalised in place afterwards.")
	:Function(b)
	:Label("GetNormalized")
	:Describe("Two allocations per call: one from the subtraction, one from GetNormalized.")
	:Function(c)
	:Label("copy + in-place ops")
	:Describe("One explicit copy, then mutating operations on it - the same allocation count as the operator form, spelled out.")
	:Function(d)
	:Label("reused scratch")
	:Describe("What Photon's engine does - a module-local scratch vector mutated in place, allocating nothing per call.")
	:ManualPredefine(1, 4)
	:Exclude("eyePos")
	:Exclude("lightPos")
	:Exclude("scratch")
	:Exclude("out")
