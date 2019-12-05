tparam_alias("ply", "Player")
tparam_alias("vec", "Vector")
tparam_alias("ent", "Entity")
tparam_alias("color", "Color")
tparam_alias("veh", "Vehicle")
tparam_alias("ang", "Angle")

local luaWikiUrl = "http://lua-users.org/wiki/%s"
local luaWikiName = "Lua Users Wiki: %s"
custom_see_handler("^lua%-wiki%((%w+)%)$", function(page)
	return luaWikiName:format(page), luaWikiUrl:format(page)
end)