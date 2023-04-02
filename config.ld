title = "Photon Documentation"
project = "Photon Lighting Engine"

format = "markdown"
no_space_before_args = true
merge = true

custom_tags = {
	{"state", title = "State", hidden = true},

	{"warns", title = "Warnings", format = function(...)
		return "<span class='tag-warning'>" .. markup(...) .. "</span>"
	end},
	{"bugs", title = "Known Issues", format = function(...)
		return "<span class='tag-bugs'>" .. markup(...) .. "</span>"
	end},
	{"deprecated", title = "Deprecated", format = function(str)
		if str == "" then
			return "<span class='tag-deprecated'>This function is deprecated and may be removed in a future version.</span>"
		else
			return "<span class='tag-deprecated'>This function is deprecated and may be removed in a future version.<br>" .. markup(str) .. "</span>"
		end
	end},
	{"internal", title = "Internal", format = function(str)
		if str == "" then
			return "<span class='tag-internal'>This function is internal. Whilst you can call it, you probably shouldn't.</span>"
		else
			return "<span class='tag-internal'>This function is internal. Whilst you can call it, you probably shouldn't.<br>" .. markup(str) .. "</span>"
		end
	end}
}

local function tagToState(tags)
	local states = {false, false, false} -- client, server, menu

	for _, state in ipairs(tags) do
		state = state:lower()
		if state == "client" then states[1] = true end
		if state == "server" then states[2] = true end
		if state == "menu" then states[3] = true end
		if state == "shared" then states[1], states[2] = true, true end
		if state == "global" then states[1], states[2], states[3] = true, true, true end
		if state == "clmenu" then states[1], states[3] = true, true end
	end

	return states
end

custom_display_name_handler = function(item, default)
	if item.type == "function" or item.type == "lfunction" or item.type == "hook" then
		local states = {false, false, false}

		local fileDesc = item.file.items[1]
		if item.tags.state then
			states = tagToState(item.tags.state)
		elseif fileDesc.tags.state then
			states = tagToState(fileDesc.tags.state)
		else
			local basename
			local fullpath = item.file.filename:sub(#item.file.base + 2)
			local st, ed = fullpath:find("[/\\][^/\\]+$")
			if (not st) or (not ed) then
				-- We already have the end path component
				basename = fullpath
			else
				basename = fullpath:sub(st + 1, ed)
			end

			local prefix = basename:match("^(%w+)_")
			if basename == "init.lua" or prefix == "sv" then
				states[2] = true
			elseif basename == "shared.lua" or prefix == "sh" then
				states[1] = true
				states[2] = true
			elseif prefix == "cl" then
				states[1] = true
			end
		end

		local outstate = {}
		if states[1] then outstate[#outstate + 1] = "state-client" end
		if states[2] then outstate[#outstate + 1] = "state-server" end
		if states[3] then outstate[#outstate + 1] = "state-menu" end

		if #outstate == 0 then
			return default(item)
		else
			local render = ""
			for _, state in ipairs(outstate) do
				render = render .. state .. " "
			end
			render = render:sub(0, -2)

			return "<span class='state " .. render .. "'>" .. default(item) .. "</span>"
		end
	end

	return default(item)
end

alias("fstring", {"field", modifiers = {type="string"}})
alias("fnumber", {"field", modifiers = {type="number"}})
alias("fint", {"field", modifiers = {type="int"}})
alias("fbool", {"field", modifiers = {type="bool"}})
alias("ffunc", {"field", modifiers = {type="function"}})
alias("ftab", {"field", modifiers = {type="table"}})

alias("rstring", {"return", modifiers = {type="string"}})
alias("rnumber", {"return", modifiers = {type="number"}})
alias("rint", {"return", modifiers = {type="int"}})
alias("rbool", {"return", modifiers = {type="bool"}})
alias("rfunc", {"return", modifiers = {type="function"}})
alias("rtab", {"return", modifiers = {type="table"}})
alias("rvec", {"return", modifiers = {type="Vector"}})
alias("rang", {"return", modifiers = {type="Angle"}})

tparam_alias("ply", "Player")
tparam_alias("vec", "Vector")
tparam_alias("ent", "Entity")
tparam_alias("color", "Color")
tparam_alias("veh", "Vehicle")
tparam_alias("ang", "Angle")
tparam_alias("vararg", "vararg")

local luaWikiUrl = "http://lua-users.org/wiki/%s"
local luaWikiName = "Lua Users Wiki: %s"
custom_see_handler("^lua%((%w+)%)$", function(page)
	return luaWikiName:format(page), luaWikiUrl:format(page)
end)

local gmodWikiUrl = "https://wiki.facepunch.com/gmod/%s"
local gmodWikiName = "GMod Wiki: %s"
custom_see_handler("^gmod%((.*)%)$", function(name)
	return gmodWikiName:format(name), gmodWikiUrl:format(name)
end)
