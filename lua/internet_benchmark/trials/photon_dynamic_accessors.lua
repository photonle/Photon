local dir = Vector(1, 0, 0)

local ent = {}
function ent:GetForward()
	return dir
end

local meta = {DirAxis = "Forward"}
local axisMethod = "Get" .. meta.DirAxis
local getForward = ent.GetForward

local out

local function a()
	out = ent["Get" .. meta.DirAxis](ent)
end

local function b()
	out = ent[axisMethod](ent)
end

local function c()
	out = getForward(ent)
end

local function d()
	out = ent:GetForward()
end

TRIAL
	:Name("Photon: Dynamic Method Lookup")
	:Description(
		"Photon aims directional lights with parent[\"Get\" .. meta.DirAxis](parent), rebuilding the method name by string "
		.. "concatenation on every call. This compares that against precomputing the name once, caching the method itself, "
		.. "and a plain method call."
	)
	:Order(202)
	:Function(a)
	:Label("concat lookup")
	:Describe("What Photon currently does - a string concatenation, a table lookup, and a call, every single time.")
	:Function(b)
	:Label("precomputed key")
	:Describe("The method name built once outside the hot path, leaving just the lookup and the call.")
	:Function(c)
	:Label("cached method")
	:Describe("The function itself captured as an upvalue, skipping the table lookup entirely.")
	:Function(d)
	:Label("direct method call")
	:Describe("The baseline when the axis is known at write time and no dynamic dispatch is needed at all.")
	:ManualPredefine(1, 10)
	:Exclude("dir")
	:Exclude("ent")
	:Exclude("meta")
	:Exclude("axisMethod")
	:Exclude("getForward")
	:Exclude("out")
