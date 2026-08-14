local base = Color(255, 128, 0, 255)
local scratch = Color(255, 128, 0, 255)

local colorAlpha = ColorAlpha
local newColor = Color

local out

local function a()
	out = colorAlpha(base, 128)
end

local function b()
	out = newColor(base.r, base.g, base.b, 128)
end

local function c()
	scratch.r = base.r
	scratch.g = base.g
	scratch.b = base.b
	scratch.a = 128
	out = scratch
end

local function d()
	base.a = 128
	out = base
end

TRIAL
	:Name("Photon: Colour Alpha Derivation")
	:Description(
		"Photon derives a per-frame source colour from each light's base colour with ColorAlpha, allocating a new Color for "
		.. "every visible light, every frame. This compares that against constructing the Color by hand, writing into a reused "
		.. "scratch Color, and mutating the base colour's alpha in place."
	)
	:Order(203)
	:Function(a)
	:Label("ColorAlpha")
	:Describe("What Photon currently does - a helper call that allocates a fresh Color each time.")
	:Function(b)
	:Label("Color()")
	:Describe("The same allocation without the helper, reading the components out directly.")
	:Function(c)
	:Label("reused scratch")
	:Describe("No allocation - but every consumer shares the same object, so it only works while nothing holds onto the previous value. Photon's render queue does, which is why it can't do this today.")
	:Function(d)
	:Label("mutate in place")
	:Describe("The cheapest option and the most dangerous: the base colour is shared state, and anything else reading it now sees the modified alpha.")
	:Before(function()
		base.a = 255
	end)
	:Exclude("out")
