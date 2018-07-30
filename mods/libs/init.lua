--[[local entity_methods
for n,e in pairs(minetest.registered_entities) do
local t = {}
local new
for i,elm in pairs(e) do
	if entity_methods[i] then
		new = entity_methods[i]
		t[i] = new(elm)
	else
		t[i] = elm
	end
end]]
--end
dofile(minetest.get_modpath("libs").."/mobs.lua")
dofile(minetest.get_modpath("libs").."/core.lua")
