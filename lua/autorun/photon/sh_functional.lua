--[[-- Functional Programming / Currying Library.
@copyright Photon Team
@release v73 Grand Lake
@author Joshua Piper
@module functional
--]]--

local select = select
local unpack = unpack

module("functional")

--- Builds a partial function, with stored arguments.
-- @usage local positiveOnly = compose(max, 0)
-- @usage print(positiveOnly(-1)) -- Returns 0.
-- @usage print(positiveOnly(2)) -- Returns 2.
-- @tparam function func Input function to curry.
-- @tparam vararg ... Arguments to store.
function compose(func, ...)
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