local ent = {count = 0}

local function process(e)
	e.count = e.count + 1
end

local protectedCall = ProtectedCall
local errorNoHalt = ErrorNoHaltWithStack

local function a()
	process(ent)
end

local function b()
	pcall(process, ent)
end

local function c()
	xpcall(process, errorNoHalt, ent)
end

local function d()
	protectedCall(process, ent)
end

TRIAL
	:Function(a)
	:Label("direct call")
	:Describe("No isolation at all - the dispatch cost every other variant is paying on top of, and the pattern where one bad entity takes the whole loop down.")
	:Function(b)
	:Label("pcall")
	:Describe("Catches the error but discards the stack trace, leaving nothing to debug the broken vehicle with.")
	:Function(c)
	:Label("xpcall")
	:Describe("What Photon.RunQuarantined uses - the handler only runs when the call actually errors, so on the happy path this is paying for the extra argument, not the handler.")
	:Function(d)
	:Label("ProtectedCall")
	:Describe("Errors are reported through the engine's error handler, with the full stack trace intact, but the engine round-trip costs ~6x a plain Lua protected call.")
	:Before(function()
		ent.count = 0
	end)
	:ManualPredefine(1, 5)
	:Exclude("ent")
	:Exclude("process")
