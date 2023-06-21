--[[-- Functional Programming / Currying Library.
@copyright Photon Team
@release v74 Hot Sulphur Springs
@author Joshua Piper
@module Photon.Functional
--]]--

Photon.Functional = {}

local select = select
local unpack = unpack

--- Builds a partial function, with stored arguments.
-- @usage local positiveOnly = partial(max, 0)
-- @usage print(positiveOnly(-1)) -- Returns 0.
-- @usage print(positiveOnly(2)) -- Returns 2.
-- @tparam function func Input function to curry.
-- @param ... Arguments to store.
function Photon.Functional.partial(func, ...)
	local args = {...}
	local st = #args

	return function(...)
		local m = select("#", ...)
		for i = 1, m do
			args[st + i] = select(i, ...)
		end

		func(unpack(args, 1, st + m))
	end
end

--- Returns parameters without any changes.
-- @param ... Input paramters.
local function null(...) return ... end

--- Returns a function where the first two inputs are flipped.
-- @tparam function func Input function.
-- @treturn function Flipped function.
-- @usage local flippedPrint = flip(print)
-- @usage flippedPrint("hello", "world") -- Outputs: "world hello"
function Photon.Functional.flip(func)
	return function(a, b, ...)
		func(b, a, ...)
	end
end

--- Reverses a set of input arguments.
-- @tparam ... vararg Input argument.
-- @treturn vararg Flipped outputs.
-- @see lua-wiki(CurriedLua)
function Photon.Functional.reverse(...)
	local function reverse_h(acc, v, ...)
		if select('#', ...) == 0 then
			return v, acc()
		else
			return reverse_h(function() return v, acc() end, ...)
		end
	end

	return reverse_h(function() return end, ...)
end

--- Build a function o from f/g so that f(g(x)) == o(x)
-- @tparam vararg ... Input functions.
-- @treturn function Composed function.
function Photon.Functional.compose(...)
	local m = select("#", ...)
	if m == 0 then return null end

	local funcs = {...}
	if m == 1 then return funcs[1] end

	return function(...)
		local values = {...}

		-- Go through the functions backwards.
		for i = m, 1, -1 do
			values = {funcs[i](unpack(values))}
		end

		return unpack(values)
	end
end
