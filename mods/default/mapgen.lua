--
-- Aliases for map generator outputs
--

minetest.register_alias("mapgen_stone", "default:stone")
minetest.register_alias("mapgen_dirt", "default:dirt")
minetest.register_alias("mapgen_dirt_with_grass", "default:dirt_with_grass")
minetest.register_alias("mapgen_sand", "default:sand")
minetest.register_alias("mapgen_water_source", "default:water_source")
minetest.register_alias("mapgen_river_water_source", "default:river_water_source")
minetest.register_alias("mapgen_lava_source", "default:lava_source")
minetest.register_alias("mapgen_gravel", "default:gravel")
minetest.register_alias("mapgen_desert_stone", "default:desert_stone")
minetest.register_alias("mapgen_desert_sand", "default:desert_sand")
minetest.register_alias("mapgen_dirt_with_snow", "default:dirt_with_snow")
minetest.register_alias("mapgen_snowblock", "default:snowblock")
minetest.register_alias("mapgen_snow", "default:snow")
minetest.register_alias("mapgen_ice", "default:ice")
minetest.register_alias("mapgen_sandstone", "default:sandstone")

-- Flora

minetest.register_alias("mapgen_tree", "default:tree")
minetest.register_alias("mapgen_leaves", "default:leaves")
minetest.register_alias("mapgen_apple", "default:apple")
minetest.register_alias("mapgen_jungletree", "default:jungletree")
minetest.register_alias("mapgen_jungleleaves", "default:jungleleaves")
minetest.register_alias("mapgen_junglegrass", "default:junglegrass")
minetest.register_alias("mapgen_pine_tree", "default:pine_tree")
minetest.register_alias("mapgen_pine_needles", "default:pine_needles")

-- Dungeons

minetest.register_alias("mapgen_cobble", "default:cobble")
minetest.register_alias("mapgen_stair_cobble", "stairs:stair_cobble")
minetest.register_alias("mapgen_mossycobble", "default:mossycobble")
minetest.register_alias("mapgen_sandstonebrick", "default:sandstonebrick")
minetest.register_alias("mapgen_stair_sandstonebrick", "stairs:stair_sandstonebrick")
--default_voxelmanipulator = minetest.get_voxel_manip()

--
-- Register ores
--

-- All mapgens except singlenode
-- Blob ore first to avoid other ores inside blobs
--local no_light_x_65_65_1 = {}
--for i = 0,(65*65) do
--table.insert(no_light_x_65_65_1,255)
--end
local built_in_lua_random = math.random
local built_in_lua_floor = math.floor
local built_in_lua_pairs = pairs
local built_in_lua_tostring = tostring
local mob_on_gen_spawn_grounds = {["default:dunlanddirt"] = true,["default:ironhillsdirt"] = true,["default:shiredirt"] = true,["default:gondordirt"] = true,["default:ithiliendirt"] = true,["default:fangorndirt"] = true,["default:loriendirt"] = true,["default:brownlandsdirt"] = true,["default:angmarsnow"] = true,["default:mordordust_mapgen"] = true}
local default_register_epic_weapons = {}
if minetest.set_mapgen_params then
minetest.set_mapgen_params({name = "v7"})
end
function tablecopy(t)
local ta = {}
for i,e in built_in_lua_pairs(t) do
ta[i] = e
end
return ta
end
function default_do_not_punch_this_stuff(ent)
	if ent then
		local name = ent.name
		if (name ~= "__builtin:item") and (name ~= "__builtin:falling_node")and (name ~= "gauges:hp_bar")and (name ~= "signs:text")and (name ~= "itemframes:item") and (name ~= "dmobs:butterfly")and(not ent.lotharrow) then
			return true
		end
	else
		return true
	end
end
local function two_value_bool_noise(x,y,c)
	local x = math.floor(x+0.5)
	local y = math.floor(y+0.5)
	return ((((x*y)%(x+y))*x)+y)%c == 0
end
local volcano_size = 10000
local function ulmosine(x,z)
	local x = (x*2*math.pi)+0.25
	local z = (z*2*math.pi)+0.25
	return (math.sin(x)+math.sin(z)+math.sin(x)*math.sin(z)-1)/2
end
local function ulmovulcano(sqrd)
	local sqr = (sqrd/1.1892295)-1
	return (((sqr+1)/((sqr*sqr*1.20710677879)+1))-0.5)*2
end
local function star(x,y)
	if x==0 and y==0 then
	return 0
	else
	return math.sin(math.atan(x/y)*80)
	end
end
local function add_ulmovulcano(x,z,v)
	local sqrd = (x*x+z*z)/volcano_size
	local interpolator = 1/(sqrd/16+1)
	return (ulmovulcano(sqrd)*90+star(x,z)*10)*interpolator+v*(1-interpolator)
end
local function ulmomap(minp,maxp)
	local map = {}
	local magmaradsquare = 1.6*volcano_size
	local scale = ((maxp.y-minp.y)+1)
	local add = scale/2+minp.y
	for x = minp.x,maxp.x do
		map[x] = {}
		for z = minp.z,maxp.z do
			map[x][z] = add_ulmovulcano(x,z,((ulmosine(x/100,z/100)+(healthbar_ulmo_noise:get2d({x=x,y=0,z=z})+healthbar_ulmo_noise:get2d({x=z,y=0,z=x}))/8)/2)*scale)+add
		end
	end
	return map,magmaradsquare
end
local function underworldmap(minp,maxp)
	local map = {}
	local lavamap = {}
	local magmaradsquare = 1.6*volcano_size
	local scale = ((maxp.y-minp.y)+1)
	local add = scale/2+minp.y
	for x = minp.x,maxp.x do
		map[x] = {}
		lavamap[x] = {}
		for z = minp.z,maxp.z do
----(healthbar_ulmo_noise:get2d({x=x,y=z,z=0}))
			map[x][z] = healthbar_ulmo_noise:get2d({x=x,y=z})*6-9050
			if map[x][z] <= -9000 and map[x][z] >= -9004 then
				map[x][z] = -9008
				lavamap[x][z] = true
			end
			if map[x][z] <= -9000-26 and map[x][z] >= -9004-26 then
				map[x][z] = -9008-26
				lavamap[x][z] = true
			end
			if map[x][z] <= -9000-26*2 and map[x][z] >= -9004-26*2 then
				map[x][z] = -9008-26*2
				lavamap[x][z] = true
			end
			if map[x][z] <= -9000-26*3 and map[x][z] >= -9004-26*3 then
				map[x][z] = -9008-26*3
				lavamap[x][z] = true
			end
			if map[x][z] <= -9000-26*4 and map[x][z] >= -9004-26*4 then
				map[x][z] = -9008-26*4
				lavamap[x][z] = true
			end
		end
	end
	return map,magmaradsquare,lavamap
end
local flowers_flowerpower_names_list = {"flowers:rose","flowers:tulip","flowers:dandelion_yellow","flowers:geranium","flowers:viola","flowers:dandelion_white"}
--local function add_some_simple_flowerpower(pos)
--minetest.set_node(pos,{name = flowers_flowerpower_names_list[built_in_lua_random(1,6)]})
--end
fish_spawn_constant = 0.001
fish_overspawn_constant = 6
function get_node_in_cube(pos,sidelen,nodename)
	local p1 = vector.subtract(pos,sidelen)
	local p2 = vector.add(pos,sidelen)
	local returni = false
	local vm = VoxelManip()
	local minp, maxp = vm:read_from_map(p1, p2)
	--local a = VoxelArea:new({MinEdge = minp, MaxEdge = maxp})
	local data = vm:get_data()
	local c_air = minetest.get_content_id(nodename)
	for _,d in built_in_lua_pairs(data) do
		if d == c_air then
			returni = true
		end
	end
	return returni
end
function fastapproxisflatenoughforcircle(p,r,hmin)
local ret = true
for x = -1,1 do
for z = -1,1 do
if minetest.get_node(vector.subtract(vector.add(p,vector.multiply(vector.normalize({x=x,y=0,z=z}),r)),{x=0,y=hmin,z=0})).name == "air" then
ret  = false
end
end
end
return ret
end
function add_standard_mob_drop(self)
	local pos = self.object:getpos()
--	core.add_item(pos, "farming:meat " .. built_in_lua_tostring(built_in_lua_random(1,2)))
	local obj = minetest.add_item(pos, "farming:meat " .. built_in_lua_tostring(built_in_lua_random(1,2)))
	obj:setvelocity({x=built_in_lua_random(-1,1), y=5, z=built_in_lua_random(-1,1)})
	if self.drops and default_standard_mob_drop_list[self.drops[1]] then
	--db("HHHHHHHHHHHHHHHHHHHHHHHHHHHHHH")
	for _,i in built_in_lua_pairs(default_standard_mob_drop_list[self.drops[1]]) do
		--db("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
		if built_in_lua_random(1,i.occurance) == 1 then
			--core.add_item(vector.add(pos,{x=built_in_lua_random(-1,1)/2,y=built_in_lua_random(-1,1)/2,z=built_in_lua_random(-1,1)/2}), i.name .. " " .. built_in_lua_tostring(built_in_lua_random(i.min,i.max)))
			local obj = minetest.add_item(pos, i.name .. " " .. built_in_lua_tostring(built_in_lua_random(i.min,i.max)))
			obj:setvelocity({x=built_in_lua_random(-1,1), y=5, z=built_in_lua_random(-1,1)})	
		
		end 
	end 
	end
end

local mob_on_gen_spawn_data = {}
local mob_on_gen_spawn_data_gravel = {}
default_mob_spawn_jobs = {}
local function add_spawn_job(pos,entity)
local tstamp = math.floor((minetest.get_gametime()+3)/10)
if not default_mob_spawn_jobs[tstamp] then
default_mob_spawn_jobs[tstamp] = {}
end
table.insert(default_mob_spawn_jobs[tstamp],{pos = pos,entity = entity})
end

local function fix_mod_name_prefix(s)
local ret = false
_,i = string.find(s,":")
if i then
ret = minetest.get_current_modname() .. string.sub(s,i)
else
ret = minetest.get_current_modname() .. ":" .. s
end
return ret
end
local function extract_mob_on_gen_spawn_grounds(t)
local nt = {}
for _,i in pairs(t) do
if mob_on_gen_spawn_grounds[i] then
table.insert(nt,i)
end
end
return nt
end
local function spawn_mobs_using_mob_on_gen_spawn_data(nodename,pos)
if mob_on_gen_spawn_data[nodename] then
for _,mob_data in pairs(mob_on_gen_spawn_data[nodename]) do
if math.random(1,mob_data.chanche) == 1 and hmap then
minetest.add_entity(pos,mob_data.name)
end
end
end
end
spawn_gravel_index = 0
local function register_spawn_gravel()
spawn_gravel_index = spawn_gravel_index+1
local sgn = minetest.get_current_modname() .. ":gravel"..tostring(spawn_gravel_index)
minetest.register_node(sgn, {
	description = "Gravel",
	tiles = {"default_gravel.png"},
	groups = {crumbly = 2, falling_node = 1,spawn_gravel = 1},
	sounds = default.node_sound_gravel_defaults(),
	drop = {
		max_items = 1,
		items = {
			{items = {'default:flint'}, rarity = 16},
			{items = {'default:gravel'}}
		}
	}
})
return sgn
end
--default_register_sbm({
function default_register_sbm(def)
minetest.register_abm({
	nodenames = def.nodenames,
	neighbors = def.neighbors or {"air"},
	label = def.label or "spawn",
	catch_up = true,
	interval = def.interval or 10,
	chance = math.max(1,math.floor((def.chance or 6000)/6)),
	action = function(p,fc1,fc2,aocw)
		if  aocw < 4  then
			def.action(p,fc1,fc2,aocw)
		end
	end,
})
end
local default_get_next_hobbitcrop_cid_index = 1
minetest.after(0,function()
default_get_next_hobbitcrop_cid_index = math.random(1,#farming_hobbitcrops)
end)
local function default_get_next_hobbitcrop()
	default_get_next_hobbitcrop_cid_index = default_get_next_hobbitcrop_cid_index+1
	if default_get_next_hobbitcrop_cid_index > #farming_hobbitcrops then
		default_get_next_hobbitcrop_cid_index = 1
	end
	return farming_hobbitcrops[default_get_next_hobbitcrop_cid_index]
end
function regular_humanoid_spawn_registry(name,spawnnodes,chanche)
name = fix_mod_name_prefix(name)
minetest.register_abm({
	nodenames = spawnnodes,
	neighbors = {"air"},
	label = "spawn",
	catch_up = true,
	interval = 10,
	chance = chanche,
	action = function(p,fc1,fc2,aocw)
		p.y = p.y+1
		local p2 = p
		p2.y = p2.y+1
		if minetest.get_node(p).name == "air"and aocw < 4 and minetest.get_node(p2).name == "air" then
			minetest.add_entity(p,name)
--			self = self:get_luaentity()
--			set_weapon(self,ItemStack("default:mithrilmace"),1,"elf.png","3d_shield_elven.png")
		end
	end,
})
--[[local sgn = register_spawn_gravel()
local desc = {name = name,chanche =math.floor(math.max(chanche/1000,1))}
mob_on_gen_spawn_data_gravel[sgn] = desc
for _,i in pairs(extract_mob_on_gen_spawn_grounds(spawnnodes)) do
local cidi = minetest.get_content_id(i)
if not mob_on_gen_spawn_data[i] then
mob_on_gen_spawn_data[cidi] = {}
end
mob_on_gen_spawn_data[cidi][sgn] = desc

end]]
end
local function on_gen_spawn_gravel_adding(cid,pos)
if math.random(1,30) == 1 then
for i,e in pairs(mob_on_gen_spawn_data[cid] or {}) do
if math.random(1,e.chanche) == 1 then
pos.y = pos.y +1
--minetest.set_node(pos,{name = i})
--minetest.chat_send_all("SPAWN")
add_spawn_job(pos,e.name)
end
end
end
end
--[[if not pcall(function()
minetest.register_lbm({
	name = ":on_gen_spawn",
	nodenames = {"group:spawn_gravel"},
	--intervall = 10,
	--chanche = 1,
	--catch_up = false,
	label = "spawn",
	action = function(pos,node)
		minetest.set_node(pos,{name = "default:gravel"})
		pos.y =pos.y +2
		p2 = pos
		p2.y = p2.y+1
		if minetest.get_node(pos).name == "air" and minetest.get_node(p2).name == "air" then
		minetest.add_entity(pos,mob_on_gen_spawn_data_gravel[node.name].name)
		end
	end
})end) then
minetest.register_abm({
	nodenames = {"group:spawn_gravel"},
	intervall = 10,
	chanche = 1,
	catch_up = false,
	label = "spawn",
	action = function(pos,node)
		minetest.set_node(pos,{name = "default:gravel"})
		pos.y =pos.y +2
		p2 = pos
		p2.y = p2.y+1
		if minetest.get_node(pos).name == "air" and minetest.get_node(p2).name == "air" then
		minetest.add_entity(pos,mob_on_gen_spawn_data_gravel[node.name].name)
		end
	end
})
end]]
minetest.register_node("default:mordordust", {
	description = "Mordor Stone",
	tiles = {"mordordust.png"},
	groups = {cracky = 3,stone = 1},
	sounds = default.node_sound_stone_defaults,
	footstep = {name = "default_stone_footstep", gain = 0.25},
})
minetest.register_node("default:mapgen_air_substitute", {
	drawtype = "airlike",
	--drawtype = "allfaces",
	--tiles = {"doors_blank.png"},
	--tiles = {"doortgblank.png"},
	pointable = false,
--sunlight_propagates = false,
	buildable_to = true,
	walkable = false,
	drop = ""
})
core.is_protected = function(pos,name)
	if pos.y < -5695 and pos.y > -6056 and not is_melkor_killer(name) then
		return true
	end
	local eo = minetest.get_meta(pos):get_string("default_protection") or ""
	if string.find(eo,"\n") then
		if string.find(eo,name) then
			return false
		else
			return true
		end
	else
		return false
	end
end
local function discard_player_protection(pos,name)
	if minetest.is_protected(pos,name) then
		local eom = minetest.get_meta(pos)
		local eo = eom:get_string("default_protection")
		eom:set_string("default_protection", eo .. "\n" .. name)
	end
end
minetest.register_on_protection_violation(function(pos, name)
minetest.chat_send_all("%§$")
minetest.rollback_revert_actions_by("Player:<"..name..">", 1)
end)
local old_item_place = minetest.item_place
local old_node_dig = minetest.node_dig
core.item_place = function(itemstack, placer, pointed_thing)
	local pos = pointed_thing.above
	local player_name = ""
	if placer then
		player_name = placer:get_player_name() or ""
	end
	if not minetest.is_protected(pos,player_name) then
		return old_item_place(itemstack, placer, pointed_thing)
	else
	if placer:is_player() then
							local key =placer:get_player_name()
							healthbar_damn_values[key] = (healthbar_damn_values[key] or 0)+10
							update_damn_data_file(key,healthbar_damn_values[key])
	minetest.add_particlespawner({
		amount = 32,
		time = 0.5,
		minpos = vector.subtract(pos, {x=0.5,y=0.5,z=0.5}),
		maxpos = vector.add(pos, {x=0.5,y=0.5,z=0.5}),
		minvel = {x = -1, y = -1, z = -1},
		maxvel = {x = 1, y = 1, z = 1},
		minacc = vector.new(),
		maxacc = vector.new(),
		minexptime = 1,
		maxexptime = 2.5,
		minsize = 1,
		maxsize = 3,
		texture = "default_coal_block.png",
	})
	end
	end
	return itemstack
end
core.node_dig = function(pos,node,placer)
	--local pos = pointed_thing.under or placer:getpos()
	local player_name = ""
	if placer then
		player_name = placer:get_player_name() or ""
	end
	if (node and (node.name == "default:bloodore")) or (not minetest.is_protected(pos,player_name)) then
		return old_node_dig(pos,node,placer)
	else
	if placer:is_player() then
							local key =placer:get_player_name()
							healthbar_damn_values[key] = (healthbar_damn_values[key] or 0)+10
							update_damn_data_file(key,healthbar_damn_values[key])
	minetest.add_particlespawner({
		amount = 32,
		time = 0.5,
		minpos = vector.subtract(pos, {x=0.5,y=0.5,z=0.5}),
		maxpos = vector.add(pos, {x=0.5,y=0.5,z=0.5}),
		minvel = {x = -1, y = -1, z = -1},
		maxvel = {x = 1, y = 1, z = 1},
		minacc = vector.new(),
		maxacc = vector.new(),
		minexptime = 1,
		maxexptime = 2.5,
		minsize = 1,
		maxsize = 3,
		texture = "default_coal_block.png",
	})
	end
	end
end
local function protect_with_except(pos,names)
	minetest.get_meta(pos):set_string("default_protection","\n" .. table.concat(names,"\n"))
end
protection_protect_with_except = protect_with_except
local function protect(pos)
	minetest.get_meta(pos):set_string("default_protection","\n")
end
minetest.register_node("default:mordordust_mapgen", {
	description = "Mordor Stone",
	tiles = {"mordordust.png"},
	groups = {cracky = 3,stone = 1},
	sounds = default.node_sound_stone_defaults,
	drop = "default:mordordust",
	footstep = {name = "default_stone_footstep", gain = 0.25},
})
function register_standard_stone_min(name)
minetest.register_node("default:" .. name .. "stone", {
	description = name,
	tiles = {name .. ".png"},
	groups = {cracky = 3, stone = 1},
	legacy_mineral = true,
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("default:" .. name .. "stonebrick", {
	description = name,
	tiles = {name .. ".png^brick_overlay2.png"},
	groups = {cracky = 2, stone = 1},
	legacy_mineral = true,
	sounds = default.node_sound_stone_defaults(),
})
minetest.after(0,function(name)
--[[doors.register_trapdoor("default:trapdoor_" .. name .. "wood", {
	description = name .. "wood trapdoor",
	inventory_image = "trapdoor_blackwhite.png^" .. name .. "_tree_overlay.png",
	wield_image = "trapdoor_blackwhite.png^" .. name .. "_tree_overlay.png",
	tile_front = "trapdoor_blackwhite.png^" .. name .. "_tree_overlay.png",
	tile_side = "doors_trapdoor_side.png",
	groups = {snappy=1, choppy=2, oddly_breakable_by_hand=2, flammable=2, door=1},
})]]
stairs.register_stair_and_slab(name .. "stone", "default:" .. name .."stone",
		 {cracky = 3, stone = 1},
		{name .. ".png"},
		name .. "stone stair",
		name .. "stone slab",
		default.node_sound_stone_defaults())
stairs.register_stair_and_slab(name .. "stonebrick", "default:" .. name .."stonebrick",
		 {cracky = 2, stone = 1},
		{name .. ".png^brick_overlay2.png"},
		name .. "stonebrick stair",
		name .. "stonebrick slab",
		default.node_sound_stone_defaults())
end,name)
end
register_standard_stone_min("marble")
register_falling_trap("default:marblestone")
register_falling_trap("default:marblestonebrick")
minetest.register_node("default:ironhillstone", {
	description = "Stone",
	tiles = {"default_stone.png"},
	groups = {cracky = 3, stone = 1},
	drop = 'default:cobble',
	legacy_mineral = true,
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("default:bluemountainstone", {
	description = "Stone",
	tiles = {"default_stone.png"},
	groups = {cracky = 3, stone = 1},
	drop = 'default:cobble',
	legacy_mineral = true,
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("default:trollstone", {
	description = "Stone",
	tiles = {"default_stone.png"},
	groups = {cracky = 3, stone = 1},
	drop = 'default:cobble',
	legacy_mineral = true,
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("default:coolinglava", {
	description = "nearly cold lava",
	tiles = {"glowingmordorstone.png"},
	groups = {cracky = 3},
	light_source = 7,
	sounds = default.node_sound_dirt_defaults,
	footstep = {name = "default_stone_footstep", gain = 0.25},
})
minetest.register_node("default:angmarsnow", {
	description = "Snow Block",
	tiles = {"default_snow.png"},
	groups = {crumbly = 3, puts_out_fire = 1, falling_node = 1},
	drop = "default:snowblock",
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_snow_footstep", gain = 0.15},
		dug = {name = "default_snow_footstep", gain = 0.2},
		dig = {name = "default_snow_footstep", gain = 0.2}
	}),
})
minetest.register_abm({
	label = "default snowblock adapt",
	nodenames = {"default:snowblock"},
	neighbors = {"default:angmarsnow"},
	interval = 10,
	catch_up = false,
	chance = 6,
	action = function(pos)
		minetest.set_node(pos,{name = "default:angmarsnow"})
	end
})
minetest.register_abm({
	label = "lava kill",
	nodenames = {"default:lava_source","default:lava_flowing"},
	interval = 10,
	catch_up = false,
	chance = 6,
	action = function(pos)
		local burnin = false
		for _,i in built_in_lua_pairs(minetest.get_objects_inside_radius(pos,0.9)) do
			local luaent  = i:get_luaentity()
			if luaent and luaent.name == "__builtin:item" then
				if not string.find(luaent.itemstring or "","default:the_one_ring") then
					i:remove()
					burnin = true
				end
			else
			if not((luaent and luaent.lava_resistant)or (i:get_hp() > 200)) then
			i:set_hp(0)
			burnin = true
			end
			end
		end
		pos.y = pos.y + 1
		if burnin and minetest.get_node(pos).name == "air" then
			minetest.set_node(pos,{name= "fire:basic_flame"})
		end
	end
})
minetest.register_abm({
	label = "lava kill",
	nodenames = {"default:magma_source","default:magma_flowing"},
	interval = 3,
	catch_up = false,
	chance = 1,
	action = function(pos)
		local burnin = false
		for _,i in built_in_lua_pairs(minetest.get_objects_inside_radius(pos,0.9)) do
			local luaent  = i:get_luaentity()
			if luaent and luaent.name == "__builtin:item" then
				if string.find(luaent.itemstring or "","default:the_one_ring") then
					for i = 1,36 do
						pos.y = pos.y+1
						minetest.set_node(pos,{name = "default:magma_source"})
					end
					set_ring_destroyed(last_one_who_dropped_saurons_ring_name)
					minetest.chat_send_all(last_one_who_dropped_saurons_ring_name.." destroyed the one ring! he can now enchant magical wooden poles!")
					healthbar_sauron_exists = false
					healthbar_write_sauron_exists()
				end
				i:remove()
			else
			if not((luaent and luaent.lava_resistant)or(i:get_hp() > 200)) then
				i:set_hp(0)
				burnin = true
			else
				if i:get_hp(0) < 200 then
					i:set_hp(0)
					burnin = true
				else
					i:set_hp(i:get_hp()-200)
				end
			end
			end
		end
		pos.y = pos.y + 1
		if burnin and minetest.get_node(pos).name == "air" then
			minetest.set_node(pos,{name= "fire:basic_flame"})
		end
	end
})
minetest.register_abm({
        label = "default remove mapgen air substitute",
	nodenames = {"default:mapgen_air_substitute"},
	interval = 60,
	chance = 1,
	catch_up = false,
	action = function(pos)
		minetest.set_node(pos,{name = "air"})
	end
})
--[[minetest.register_abm({
	nodenames = {"air"},
	neighbors = {"default:mapgen_air_substitute"},
	interval = 0.1,
	chance = 1,
	action = function(pos)
		if pos.y == 9 then--if minetest.get_node(vector.subtract(pos,{x=0,y=1,z=0})).name ~= "air" and minetest.get_node(vector.subtract(pos,{x=0,y=1,z=0})).name ~= "default:mapgen_air_substitute"  then
			minetest.set_node(pos,{name = "default:mapgen_air_substitute"})
		end
	end
})]]
--                               0         1       2     3   4   5     6       7         8
--                               5         4       3     2   1   2     3       4         5
local randint_extreme_core_X8 = {0,0,0,0,0,1,1,1,1,2,2,2,3,3,4,5,5,6,6,6,7,7,7,7,8,8,8,8,8}
local default_randint_extreme = false
local function randint_extreme_func(minpy,maxpy)
	local heigth_d2 = (maxpy-minpy)/2
	local multiplier = heigth_d2/4
	return function()
		return (randint_extreme_core_X8[built_in_lua_random(1,29)]*multiplier)-heigth_d2
	end
end
local keynodetable = function(minp,maxp,wl,xsize,zsize)
	default_randint_extreme = randint_extreme_func(minp.y,maxp.y)
	local newkeynodetable = function(minp,maxp,wl)
	local xsize = xsize or maxp.x-minp.x
	local zsize = zsize or maxp.z-minp.z
	local prehmap = {}
	for x = 0,built_in_lua_floor(xsize/wl) do
--		x = x*wl
		prehmap[x] = {}
		for z = 0,built_in_lua_floor(zsize/wl) do
--			z = z*wl
			prehmap[x][z] = default_randint_extreme(minp,maxp)
		end
	end
	return prehmap
	end
	keynodetable = newkeynodetable
	return newkeynodetable(minp,maxp,wl)
end
local function influence(knpx,knpz,x,z,wl)
	local xd = ((knpx*wl)-x)
	local zd = ((knpz*wl)-z)
	return math.max(1-((1/wl)*math.sqrt((xd*xd)+(zd*zd))),0)
end
local function shardmap(minp,maxp,wl)
	local xsize = maxp.x-minp.x
	local zsize = maxp.z-minp.z
	local presharpmap = keynodetable(minp,maxp,wl)
	local ret = {}
	local mx = minp.x
	local mz = minp.z
	local dschnitt = (minp.y+maxp.y)/2
	for x = 0,xsize do
		ret[x+mx] = {}
		for z=0,zsize do
			local fx = math.floor(x/wl)
			local cx = math.ceil(x/wl)
			local fz = math.floor(z/wl)
			local cz = math.ceil(z/wl)
			local w1 = influence(fx,fz,x,z,wl)
			local w2 = influence(fx,cz,x,z,wl)
			local w3 = influence(cx,fz,x,z,wl)
			local w4 = influence(cx,cz,x,z,wl)
			ret[x+mx][z+mz] = (((((presharpmap[fx] or {})[fz] or 0)*w1)+
				    (((presharpmap[fx] or {})[cz] or 0)*w2)+
				    (((presharpmap[cx] or {})[fz] or 0)*w3)+
				    (((presharpmap[cx] or {})[cz] or 0)*w4))/(w1+w2+w3+w4))+dschnitt
		end
	end
	return ret
end
function register_sapling_growth_abm(saplingname,homedirt,treeschem,x_diff,z_diff)
minetest.register_abm({
	label = "default sapling growth",
	nodenames = {"default:"..saplingname.."sapling"},
	interval = 60,
	chance = 1,
	action = function(pos)
		pos.y = pos.y -1
		local node = minetest.get_node(pos).name
		local soil = minetest.registered_nodes[node].groups.soil
		homegame = 0
		for _,i in built_in_lua_pairs(homedirt) do
			if node == i then
				homegame = homegame + 15
				if get_node_in_cube(pos,1,"default:water_source") then
					homegame = homegame + 15
				end
			end
		end
		if soil and homegame == 0 then
			homegame = homegame+(soil*5)
		end
		pos.y = pos.y +1
		if built_in_lua_random(1,50-(minetest.get_node_light(pos)+homegame)) == 1 then
			minetest.remove_node(pos)
			pos = vector.add(pos,{x=x_diff,y=0,z=z_diff})
			place_schematic_central(treeschem .. ".mts",1,pos,true)
		end
	end
})
end
function register_biome_dirt(name)
minetest.register_node("default:" .. name .. "dirt", {
	description = name,
	tiles = {name .. "_dirt_top.png", "default_dirt.png",
		{name = name .. "_dirt_top.png^default_dirt_side.png",
			tileable_vertical = false}},
	groups = {dirt = 1,crumbly = 3, soil = 1, falling_node = 1},
	drop = 'default:dirt',
	sounds = default.node_sound_dirt_defaults,
	footstep = {name = "default_grass_footstep", gain = 0.25},
	soil = {
		base = "default:dirt",
		dry = "farming:soil",
		wet = "farming:soil_wet"
	}
	})
minetest.register_abm({
	label = "default dirt adapt to biome",
	nodenames = {"default:dirt"},
	neighbors = {"default:" .. name .. "dirt"},
	interval = 10,
	chance = 6,
	catch_up = false,
	action = function(pos)
		pos.y = pos.y+1
		local ntable = minetest.registered_nodes[minetest.get_node(pos).name]
		if ntable and ntable.sunlight_propagates and not ntable.walkable then
		pos.y = pos.y-1
		minetest.set_node(pos,{name="default:" .. name .. "dirt"})
		end
	end
})
minetest.register_abm({
	label = "default biome dirt grass decay",
	nodenames = {"default:" .. name .. "dirt"},
	
	interval = 30,--10,
	chance = 2,--6,
	catch_up = false,
	action = function(pos)
		pos.y = pos.y+1
		local n = minetest.get_node(pos).name
		local ntable = minetest.registered_nodes[n]
		--if minetest.get_node(pos).name ~= "air" then
		if ntable and (not(ntable.sunlight_propagates and not ntable.walkable)) and (not (n == "ignore")) then
		pos.y = pos.y-1
		minetest.set_node(pos,{name="default:dirt"})
		end
		--end
	end
})
end
function register_standard_biome(name,he,h,stone,ymin,watertop,dwatertop)
register_biome_dirt(name)
	minetest.register_biome({
		name = name,
		node_top ="default:" .. name .. "dirt",
		depth_top = 1,
		node_filler = "default:gravel",
		depth_filler = 1,
		node_stone = stone or "default:stone",
		node_water_top = watertop or "default:water_source",
		depth_water_top = dwatertop or 10,
		node_water = "default:water_source",
		node_river_water = "default:river_water_source",
		y_min = ymin or 0,
		y_max = 31000,
		heat_point = he,
		humidity_point = h,
	})
	minetest.register_biome({
		name = name .. "ocean",
		node_top = "default:sand",
		depth_top = 1,
		node_filler = "default:gravel",
		depth_filler = 1,
		node_stone = stone or "default:stone",
		node_water_top = watertop or "default:water_source",
		depth_water_top = dwatertop or 10,
		node_water = "default:water_source",
		node_river_water = "default:river_water_source",
		y_min = -125,
		y_max = -1,
		heat_point = he,
		humidity_point = h,
	})
end
function register_standard_biome_extended(name,dirtname,depth,he,h,water_top,dept_water_top)
	minetest.register_biome({
		name = name,
		node_top = dirtname,
		depth_top = depth,
		node_filler = "default:gravel",
		depth_filler = depth,
		node_stone = "default:stone",
		node_water_top = water_top or "default:water_source",
		depth_water_top = dept_water_top or 10,
		node_water = "default:water_source",
		node_river_water = "default:river_water_source",
		y_min = 0,
		y_max = 31000,
		heat_point = he,
		humidity_point = h,
	})
	minetest.register_biome({
		name = name .. "ocean",
		node_top = "default:sand",
		depth_top = 1,
		node_filler = "default:gravel",
		depth_filler = 1,
		node_stone = stone or "default:stone",
		node_water_top = water_top or "default:water_source",
		depth_water_top = dept_water_top or 10,
		node_water = "default:water_source",
		node_river_water = "default:river_water_source",
		y_min = -125,
		y_max = -1,
		heat_point = he,
		humidity_point = h,
	})
end
local function register_flower_spawn_abm(dirt,name,chanche,tname)
minetest.register_abm({
	label = "default flower spawn",
	nodenames = dirt,
	intervall = 5,
	chance = chanche*10,
	catch_up = false,
	action = function(pos)
		pos.y = pos.y+1
	if --[[not get_node_in_cube(pos,distance,"default:" .. name .. "flower") and]] minetest.get_node(pos).name == "air"then

		minetest.set_node(pos,{name = tname or "default:" .. name .. "flower"})
	end
end})
minetest.register_abm({
        label = "default flower delete",
	nodenames = {tname or "default:" .. name .. "flower"},
	interval = 5,
	chance = 10,
	catch_up = false,
	action = function(pos)
		minetest.set_node(pos, {name = "air"})
	end,
})
end
function register_flower(name,chanche,distance,dirt)
minetest.register_node("default:" .. name .. "flower", {
	description = name,
	drawtype = "plantlike",
	visual_scale = 1.3,
	sunlight_propagates = true,
	tiles = {name .. ".png"},
	paramtype = "light",
	walkable = false,
	is_ground_content = false,
	waving = 1,
	buildable_to = true,
	groups = {snappy = 3,flammable = 3, flora = 1, attached_node = 1, grass = 1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {type = "fixed",fixed = {-0.15, -0.5, -0.15, 0.15, 0.3, 0.15}},
})register_flower_spawn_abm(dirt,name,chanche,false)
--minetest.register_on_generated(--[[function(p1,p2)minetest.after(0.2,]]function(p1,p2)
--[[	local vm = VoxelManip()
	local minp, maxp = vm:read_from_map(p1, p2)
	local a = VoxelArea:new({MinEdge = minp, MaxEdge = maxp})
	local data = vm:get_data()
	local c_air = minetest.get_content_id(dirt)
	for i,d in built_in_lua_pairs(data) do
		local p = a:position(i)
		p.y= p.y+1
		if p.y >= 1.5 and d == c_air and built_in_lua_random(1,chanche) == 1 then
			--if minetest.get_node(p).name == "air" then
				minetest.set_node(p,{name = "default:" .. name .. "flower"})
			--end
		end
	end]]
--[[end,p1,p2)]]--end)
--for _,i in built_in_lua_pairs(dirt) do
--end
end
for _,i in built_in_lua_pairs(flowers_flowerpower_names_list) do
register_flower_spawn_abm({"default:dunlanddirt","default:ironhillsdirt","default:shiredirt","default:gondordirt","default:ithiliendirt","default:fangorndirt","default:loriendirt"},false,300,i)
end
function register_plant(name)
minetest.register_node("default:" .. name .. "plant", {
	description = name,
	drawtype = "plantlike",
	visual_scale = 1.3,
	sunlight_propagates = true,
	tiles = {name .. ".png"},
	paramtype = "light",
	walkable = false,
	is_ground_content = false,
	waving = 1,
	buildable_to = true,
	groups = {snappy = 3, flora = 1, attached_node = 1, grass = 1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {type = "fixed",fixed = {-0.15, -0.5, -0.15, 0.15, 0.3, 0.15}},
})
end
function register_crop(name,add,lawname,drops)
minetest.register_node("default:" .. name .. "plant", {
	description = name,
	drawtype = "plantlike",
	visual_scale = 1.3,
	sunlight_propagates = true,
	tiles = {name .. ".png"},
	paramtype = "light",
	walkable = false,
	is_ground_content = false,
	waving = 1,
	buildable_to = true,
	drop = {items = {{items = drops, rarity = 1}}},
	groups = {snappy = 3, flora = 1, attached_node = 1, grass = 1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {type = "fixed",fixed = {-0.15, -0.5, -0.15, 0.15, 0.3, 0.15}},
	can_dig = function(pos, player)
		add_to_law_status(player:get_player_name(),lawname or "hudwelshlaw",1)
		return true
	end
})
end
function register_grass(name,chanche,distance,dirt,chancheoverload)
minetest.register_node("default:" .. name .. "grass", {
	description = name,
	drawtype = "plantlike",
	visual_scale = 1.2,
	sunlight_propagates = true,
	tiles = {name .. ".png"},
	paramtype = "light",
	walkable = false,
	is_ground_content = false,
	waving = 1,
	buildable_to = true,
	groups = {snappy = 3,flammable =3, flora = 1, attached_node = 1, grass = 1},
	sounds = default.node_sound_leaves_defaults(),	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
	},})

--minetest.register_abm({
--	nodenames = dirt,
--	intervall = 1,--60,
	--chanche = chanche,--chanche*(chancheoverload or --[[7]]32),
--	chanche = 1,
--	catch_up = false,
--	action = function(pos)
--	pos.y = pos.y+1
--	if minetest.get_node(--[[vector.add(]]pos--[[,{x=0,y=1,z=0})]]).name == "air"then
--		minetest.set_node(pos,{name = "default:" .. name .. "grass"})
--	end
--end})
--minetest.register_abm({
--	nodenames = {"default:" .. name .. "grass"},
--	intervall = 5,--60,
--	catch_up = false,
--	chanche =  1,
--	action = function(pos)
	--	db({built_in_lua_tostring(var_test_deleted_gerasssgrass)})
	--var_test_deleted_gerasssgrass = var_test_deleted_gerasssgrass+1
		--minetest.remove_node(pos)
--		minetest.set_node(pos,{name = "default:stone"})
--end})
minetest.register_abm({
        label = "default grass delete",
	nodenames = {"default:" .. name .. "grass"},
	interval = 5,
	chance = 10,
	catch_up = false,
	action = function(pos)
		minetest.set_node(pos, {name = "air"})
	end,
})
minetest.register_abm({
        label = "default grass spawn",
	nodenames = dirt,
	interval = 5,
	chance = 100,
	catch_up = false,
	action = function(pos)
			pos.y = pos.y+1
	if minetest.get_node(--[[vector.add(]]pos--[[,{x=0,y=1,z=0})]]).name == "air"then
		minetest.set_node(pos,{name = "default:" .. name .. "grass"})
	end
	end,
})
end

register_flower("elanor",100,6,{"default:loriendirt"})
register_flower("niphredil",100,6,{"default:loriendirt"})
register_flower("lissuin",100,6,{"default:loriendirt"})
--register_flower("wheat",100,6,{"default:rohandirt"})
register_flower("mallos",100,6,{"default:gondordirt","default:ithiliendirt"})
register_flower("alfirin",100,6,{"default:gondordirt","default:ithiliendirt"})
register_flower("athelas",100,6,{"default:gondordirt","default:ithiliendirt"})
register_flower("seregon",100,6,{"default:ironhillsdirt"})
register_crop("pipeweed",nil,nil,{"farming:pipeweed"})
register_crop("wheat",nil,nil,{"farming:wheat"})
register_crop("barley",nil,nil,{"farming:barley"})
register_crop("corn",nil,nil,{"farming:corn"})
register_crop("cotton",nil,nil,{"farming:string"})
--register_flower("simbelmyne",100,6,"default:rohandirt")
minetest.register_node("default:simbelmyneflower", {
	description = name,
	drawtype = "plantlike",
	visual_scale = 1.3,
	sunlight_propagates = true,
	tiles = {"simbelmyne.png"},
	paramtype = "light",
	walkable = false,
	is_ground_content = false,
	waving = 1,
	buildable_to = true,
	groups = {snappy = 3, flora = 1, attached_node = 1, grass = 1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {type = "fixed",fixed = {-0.15, -0.5, -0.15, 0.15, 0.3, 0.15}},
})
minetest.register_node("default:mud", {
	description = "Mud",
	drawtype = "liquid",
	tiles = {"mud.png","mud.png","mud.png"},
	special_tiles = {"mud.png","mud.png","mud.png"},
	alpha = 250,
	paramtype = "light",
	walkable = false,
	pointable = true,
	diggable = true,
	buildable_to = true,
	is_ground_content = false,
	drowning = 1,
	liquidtype = "source",
	liquid_range = 1,
	liquid_alternative_flowing = "default:mud_flowing",
	liquid_alternative_source = "default:mud",
	liquid_viscosity = 20,
	liquid_renewable = false,
	post_effect_color = {a = 200, r = 30, g = 60, b = 0},
	groups = {crumbly = 1,water = 3, liquid = 3, puts_out_fire = 1},
})
minetest.register_node("default:mud_flowing", {
	description = "Flowing Mud",
	drawtype = "flowingliquid",
	tiles = {"mud.png","mud.png","mud.png"},
	special_tiles = {"mud.png","mud.png","mud.png"},
	alpha = 250,
	paramtype = "light",
	paramtype2 = "flowingliquid",
	walkable = false,
	pointable = true,
	diggable = true,
	buildable_to = true,
	is_ground_content = false,
	liquid_renewable = false,
	drop = "",
	drowning = 1,
	selection_box = {type = "fixed",fixed = {-0.5, -0.5, -0.5, 0.5, -0.25, 0.5}},
	liquidtype = "flowing",
	liquid_alternative_flowing = "default:mud_flowing",
	liquid_alternative_source = "default:mud",
	liquid_viscosity = 20,
	post_effect_color = {a = 200, r = 30, g = 60, b = 0},
	groups = {crumbly = 1,water = 3, liquid = 3, puts_out_fire = 1,
		not_in_creative_inventory = 1},
})
register_grass("bluemountainsgrass",--[[10]]7,2,"default:bluemountainsdirt")
register_grass("loriengrass",--[[10]]7,2,"default:loriendirt")
register_grass("valinorgrass",--[[10]]7,2,"default:valinordirt")
register_grass("ironhillsgrass",--[[10]]7,2,"default:ironhillsdirt")
register_grass("brownshrub",--[[10]]7,2,"default:brownlandsdirt")
register_grass("trollshawsshrub",--[[10]]7,2,"default:trollshawsdirt")
register_grass("grass",--[[10]]7,2,"default:gondordirt")
register_grass("ithiliengrass",--[[10]]7,2,"default:ithiliendirt")
register_grass("junglegrass",--[[10]]7,2,"default:mirkwooddirt")
register_grass("drygrass",--[[10]]7,2,"default:rohandirt")
register_grass("dunlandgrass",--[[10]]7,2,"default:dunlanddirt")
register_grass("fangorngrass",--[[10]]7,2,"default:fangorndirt")
by_register_tree_components_registered_wood_types = {}
function register_tree_components(name)
table.insert(by_register_tree_components_registered_wood_types,name)
minetest.register_node("default:" .. name .. "leaves", {
	description = name .. "leaves",
	drawtype = "allfaces_optional",
	waving = 1,
	visual_scale = 1.3,
	tiles = {name .. "_leaves.png"},
	--special_tiles = {name .. "_leaves_simple.png"},
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy = 3, --[[leafdecay = 3,]] flammable = 3, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{
				-- player will get sapling with 1/20 chance
				items = {"default:" .. name .. "sapling"},
				rarity = 20,
			},
			{
				-- player will get leaves only if he get no saplings,
				-- this is because max_items is 1
				items = {"default:" .. name .. "leaves"},
			}
		}
	},
	sounds = default.node_sound_leaves_defaults(),
	after_place_node = default.after_place_leaves,
})
minetest.register_node("default:" .. name .."wood", {
	description = name .. " planks",
	tiles = {"woodplanks.png^" .. name .. "_tree_overlay.png"},
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1},
	sounds = default.node_sound_wood_defaults(),
})
default.register_fence("default:fence_" .. name .."wood", {
	description = name .. "wood fence",
	texture = "default_fence_blackwhite.png^"--[["woodplanks.png^"]] ..  name .. "_tree_overlay.png",
	material = "default:" .. name .."wood",
	groups = {choppy = 2--[[, oddly_breakable_by_hand = 2,]], flammable = 2},
	sounds = default.node_sound_wood_defaults()
})
minetest.register_craft({
	output = "doors:trapdoor_" .. name .. "wood 2",
	recipe = {
		{"default:" .. name .."wood", "default:" .. name .."wood", "default:" .. name .."wood"},
		{"default:" .. name .."wood", "default:" .. name .."wood", "default:" .. name .."wood"},
		{'', '', ''},
	}
})
minetest.after(0,function(name)
--[[doors.register_trapdoor("default:trapdoor_" .. name .. "wood", {
	description = name .. "wood trapdoor",
	inventory_image = "trapdoor_blackwhite.png^" .. name .. "_tree_overlay.png",
	wield_image = "trapdoor_blackwhite.png^" .. name .. "_tree_overlay.png",
	tile_front = "trapdoor_blackwhite.png^" .. name .. "_tree_overlay.png",
	tile_side = "doors_trapdoor_side.png",
	groups = {snappy=1, choppy=2, oddly_breakable_by_hand=2, flammable=2, door=1},
})]]
doors.register_fencegate("default:gate_" .. name .. "wood", {
	description = name .. "wood fence gate",
	texture = "woodplanks.png^" .. name .. "_tree_overlay.png",
	material = "default:" .. name .."wood",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2}
})
stairs.register_stair_and_slab(name .. "wood", "default:" .. name .."wood",
		{snappy = 2, choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
		{"woodplanks.png^" .. name .. "_tree_overlay.png"},
		name .. "wood stair",
		name .. "wood slab",
		default.node_sound_wood_defaults())
doors.register("door_" .. name .. "wood", {
		tiles = {{ name = "doors_door_blackwhite.png^" .. name .. "_tree_overlay.png", backface_culling = true }},
		description = name .. "wood door",
		inventory_image = "doors_item_blackwhite.png^" .. name .. "_tree_overlay.png",
		groups = { snappy = 1, choppy = 2, --[[oddly_breakable_by_hand = 2,]] flammable = 2 },
		recipe = {
			{"default:" .. name .."wood", "default:" .. name .."wood"},
			{"default:" .. name .."wood", "default:" .. name .."wood"},
			{"default:" .. name .."wood", "default:" .. name .."wood"},
		}
})
end,name)
minetest.register_craft({
	output = "default:" .. name .."wood 4",
	recipe = {
		{"default:" .. name .. "tree"},
	}
})
minetest.register_craft({
	output = "default:stick 4",
	recipe = {
		{"default:" .. name .."wood"},
	}
})
minetest.register_node("default:" .. name .. "sapling", {
	description = name .. "sapling",
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles = {name .. "_sapling.png"},
	inventory_image = name .. "_sapling.png",
	wield_image = name .. "_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	waving = 1,
	buildable_to = true,
	groups = {snappy = 3, flora = 1, attached_node = 1, grass = 1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
	},
})
minetest.register_node("default:" .. name .. "tree", {
	description = name .. "tree",
	tiles = {name .. "_tree_top.png", name .. "_tree_top.png",
		name .. "_tree.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = default.node_sound_wood_defaults(),
	on_place = minetest.rotate_node
})
end
function default_write_back_boss_kill_flags()
	local input = io.open(health_data_file_name .. "cpttljmm.txt", "w")
	if input then
 	input:write(minetest.write_json(sauron_killed_bosses))
	io.close(input)
	end
end
function default_read_boss_kill_flags()
	local input = io.open(health_data_file_name .. "cpttljmm.txt", "r")
	if input then
 	local data = input:read("*all")
	sauron_killed_bosses = minetest.parse_json(data)
	io.close(input)
	end
end
function default_add_boss_kill_flag(self,ent)
if ent:is_player() and self.object:get_hp() <=0 then
local player_name = ent:get_player_name()
if not sauron_killed_bosses[player_name] then
sauron_killed_bosses[player_name] = {}
end
sauron_killed_bosses[player_name][self.object:get_luaentity().name] = true
default_write_back_boss_kill_flags()
--bones_netherport(ent)
end
lawbreak_on_punch(self,ent)
end
local cavespawn_default = function(pos,fc1,fc2,aocw)
		if aocw < 5 then
		pos.y = pos.y+1
		if minetest.get_node(pos).name == "air" then
		if minetest.get_node_light(pos,0.5) < 5 then
			local rand = built_in_lua_random(1,5)
			if rand == 1 then
				pos.y = pos.y +1
				minetest.add_entity(pos,"orcs:standardorc")
			elseif rand == 2 then
				pos.y = pos.y +1
				minetest.add_entity(pos,"archers:orccharacter")
			elseif rand == 3 then
				pos.y = pos.y + 2
				if minetest.get_node(pos).name == "air" then
					minetest.add_entity(pos,"bats:bat")
				end
			elseif rand == 4 then
				pos.y = pos.y + 2
				if minetest.get_node(pos).name == "air" then
					if math.random(1,9) == 1 then
						minetest.add_entity(pos,"spiders:shelob")
					else
						pos.y = pos.y-1
						minetest.add_entity(pos,"orcs:standardorc")
					end
				end
			else
				pos.y = pos.y +2
				if math.random(1,2) == 1 then
					minetest.add_entity(pos,"trolls:uruguay")
				else
					pos.y = pos.y-1
					minetest.add_entity(pos,"orcs:standardorc")
				end
			end
		elseif built_in_lua_random(1,3) == 1 and pos.y < 0 then
				pos.y = pos.y +1
			minetest.add_entity(pos,"hudwel:standarddwarf")
		end
		end
		end
		
	end
minetest.register_abm({
        label = "spawn",
	nodenames = {"default:stone","default:ironhillstone","default:mossycobble","default:stone_with_iron"},
	neighbors = {"air"},
	interval = 10,
	chance = 1000,
	catch_up = false,
	action = cavespawn_default
})
minetest.register_abm({
        label = "spawn",
	nodenames = {"default:sand"},
	neighbors = {"air"},
	interval = 10,
	chance = 1000,
	catch_up = false,
	action =function(pos,fc1,fc2,aocw) if pos.y < 0 then cavespawn_default(pos,fc1,fc2,aocw) end end
})

--
-- Register biomes
--

-- All mapgens except mgv6 and singlenode

function default.register_biomes()
	minetest.clear_registered_biomes()
	minetest.register_biome({
		name = "desert",
		node_top ="default:desert_sand",
		depth_top = 3,
		node_filler =  "default:desert_stone",
		depth_filler = 3,
		node_stone = "default:stone",
		node_water_top = "default:desert_sand",
		depth_water_top = 3,
		node_water = "default:stone",
		node_river_water = "default:desert_sand",
		y_min = -50,
		y_max = 31000,
		heat_point = 80,
		humidity_point = 0,
	})
	minetest.register_biome({
		name = "mordor",
		node_top ="default:mordordust_mapgen",
		depth_top = 2,
		node_filler =  "default:mordordust",
		depth_filler = 3,
		node_stone = "default:stone",
		node_water_top = "default:mordordust_mapgen",
		depth_water_top = 2,
		node_water = "default:stone",
		node_river_water = "default:mordordust",
		y_min = -50,
		y_max = 31000,
		heat_point = 90,
		humidity_point = 10,
	})
	minetest.register_biome({
		name = "mountains",
		node_top = "default:mountainsnow",
		depth_top = 1,
		node_filler = "golems:bedrock",
		depth_filler = 10,
		node_stone = "default:stone",
		node_water_top = "default:water_source",
		depth_water_top = 3,
		node_water = "default:water_source",
		node_river_water = "default:water_source",
		y_min = 2,
		y_max = 31000,
		heat_point = 10,
		humidity_point = 30,
	})
register_standard_biome("lorien",50,50)--    50 50 #
register_standard_biome("rohan",80,10)--     80 10 #
register_standard_biome("mirkwood",80,100)-- 80 100#
register_standard_biome("valinor",90,90)-- 80 100#
register_standard_biome("dunland",30,20)--   30 20 #
register_standard_biome("gondor",40,30)--    40 30 #
register_standard_biome("shire",60,60)--     60 60 #
register_standard_biome("ithilien",30,40)--  30 40 #
register_standard_biome("brownlands",20,80)--20 80 #
register_standard_biome("trollshaws",30,80)--20 80 #
register_standard_biome("fangorn",70,90)--   70 90 #
--register_standard_biome_extended("mordor","default:mordordust_mapgen",2,90,10)--         90 10 #
register_standard_biome_extended("angmar","default:angmarsnow",1,10,20,"default:ice",3)--10 30 #
register_standard_biome("ironhills",20,50,"default:ironhillstone",0)
register_standard_biome("bluemountains",10,50,"default:bluemountainstone",0,"default:ice",3)--              20 50 #
end
register_tree_components("mallorn")
register_tree_components("jungletree")
register_tree_components("culumalda")
register_tree_components("lebethron")
register_tree_components("mirk")
register_tree_components("whitetree")
register_tree_components("fir")

--
-- Register decorations
--

-- Mgv6

function default.register_mgv6_decorations()
end
-- All mapgens except mgv6 and singlenode
local function add_dwarfern_mine_skelleton(pos,treasurechanche)
	local justair  = 0
	local justignore = 0
	local juststone = 0
	local n = 0
--	local p1 = vector.subtract(pos,sidelen)
	local p2 = vector.add(pos,4)
	local vm = VoxelManip()
	local minp, maxp = vm:read_from_map(pos,p2)--p1, p2)
	local a = VoxelArea:new({MinEdge = minp, MaxEdge = maxp})
	local data = vm:get_data()
	local c_air = minetest.get_content_id("air")
	local c_ignore = minetest.get_content_id("ignore")
	local c_stone = minetest.get_content_id("default:ironhillstone")
	local c_iron = minetest.get_content_id("default:stone_with_iron")
	local c_dirt = minetest.get_content_id("default:ironhillsdirt")
	--for _,d in built_in_lua_pairs(data) do
	for x = 1,2 do
		for y = 0,3 do
			for z = 1,2 do
				local nopos = vector.add(pos,{x=x,y=y,z=z})
				local i = data[a:index(nopos.x,nopos.y,nopos.z)]
				if i == c_air then
					justair = justair+1
				elseif i == c_ignore then
					justignore = justignore+1
				elseif i == c_stone or i == c_iron or i == c_dirt then
					juststone = juststone+1
				end
				n = n+1
			end
		end
	end
	--end
	if justair+justignore == n then
		justair = false
	elseif justair+ justignore == 0 then
		if treasurechanche and built_in_lua_random(1,treasurechanche) == 1 then
			justair = "dwarfernminetreasure.mts"
		else
			justair = "mineskelleton.mts"
		end
	elseif juststone > 0 then 
		justair = "emptymineskelleton.mts"
	else
		justair = false
	end
	if justignore > 0 and pos.y < 0 then
		if treasurechanche and built_in_lua_random(1,treasurechanche) == 1 then
			justair = "dwarfernminetreasure.mts"
		else
			justair = "mineskelleton.mts"
		end
	end
	if justair then
		minetest.place_schematic(pos,minetest.get_modpath("default") .. "/schematics/" .. 	justair,"0",nil,true)
	end
end
--local function add_moria_mine_skelleton(pos)
--[[	local justair  = 0
	local justignore = 0
	local juststone = 0
	local n = 0
--	local p1 = vector.subtract(pos,sidelen)
	local p2 = vector.add(pos,{x=65,y=20,z=65})
	local vm = VoxelManip()
	local minp, maxp = vm:read_from_map(pos,p2)--p1, p2)
	local a = VoxelArea:new({MinEdge = minp, MaxEdge = maxp})
	local data = vm:get_data()
	local c_air = minetest.get_content_id("air")
	local c_ignore = minetest.get_content_id("ignore")
	local c_stone = minetest.get_content_id("default:ironhillstone")
	local c_iron = minetest.get_content_id("default:stone_with_iron")
	local c_dirt = minetest.get_content_id("default:ironhillsdirt")
	--for _,d in built_in_lua_pairs(data) do
	for x = 1,9--1,12 do--5,60 do
		for y = 0,7 do--0,19 do
			for z = 1,9 do--5,60 do
				local nopos = vector.add(pos,{x=x*18,y=y*10,z=z*18})--5})--{x=x,y=y,z=z})
				local i = data[a:index(nopos.x,nopos.y,nopos.z)]
				if i == c_air then
					justair = justair+1
				elseif i == c_ignore then
					justignore = justignore+1
				elseif i == c_stone or i == c_iron or i == c_dirt then
					juststone = juststone+1
				end
				n = n+1
			end
		end
	end
	--end
	if justair+justignore == n then
		justair = false
	elseif justair+ justignore <= n/10 then
		--if justignore > 0 then
			--pos.y = pos.y -1
			justair = --[["moria.mts"]]--"moriafinal.mts"--]]final.mts"--"moriareloaded.mts"--"moria.mts"
		--else
		--	justair = "moria.mts"
		--end
--[[	elseif juststone > 0 then 
		justair = false--"emptymoria.mts"
	else
		justair = false
	end
	if justignore > 0 then--and pos.y < 0 then
		--if justignore > 0 then
			--pos.y = pos.y -1
			justair = --[["moria.mts"]]--"moriafinal.mts"--final.mts"--"moriareloaded.mts"--"moria.mts"
		--else
		--	justair = "moria.mts"
		--end
--	end
--	if justair then
--		minetest.place_schematic(pos,minetest.get_modpath("default") .. "/schematics/moriav2","0",nil,true)
	--[[	minetest.after(3,function(vm,pos)
			local p1 = vector.subtract(pos,{x=0,y=1,z=0})
			local p2 = vector.add(pos,{x=65,y=-1,z=65})
			vm:read_from_map(p1,p2)
			vm:set_lighting(no_light_x_65_65_1,p1,p2)
			vm:write_to_map()
			--vm:set_lighting({day = 0,night = 0},p1, p2)--vm:calc_lighting()
			vm:update_map()end,vm,pos)]]
--	end
--end
local function fix_lighting(p1,p2,del)
	minetest.after(del,function(p1,p2)
	local vm = VoxelManip()
	vm:read_from_map(p1,p2)--p1, p2)
	--for _,d in built_in_lua_pairs(data) do
	vm:calc_calc_lighting()
	vm:update_map()
	end,p1,p2)
end
local function get_random_direction_for_dwarfern_mine()
	local vec = vector.new()
	local dir = {"x","z"}
	vec[dir[built_in_lua_random(1,2)]] = (built_in_lua_random(0,1)*6)-3
	return vec
end
local function get_random_direction_for_moria_mine()
	local vec = vector.new()
	local dir = {"x","z"}
	vec[dir[built_in_lua_random(1,2)]] = (built_in_lua_random(0,1)*360)-180
	return vec
end
local function rotate_vec_right_angle(vec)
	return{x = vec.z,z = vec.x,y = vec.y}
end
function add_dwarfern_mine_arms(pos,dir,armlenght,treasurechanche)
	local mdir = vector.multiply(dir,-1)
	local mpos = pos
	for i = 1,armlenght do
		pos = vector.add(pos,dir)
		mpos = vector.add(mpos,mdir)
		add_dwarfern_mine_skelleton(pos,treasurechanche)
		add_dwarfern_mine_skelleton(mpos,treasurechanche)
	end
end
function add_moria_mine_arms(pos,dir,armlenght)
	local mdir = vector.multiply(dir,-1)
	local mpos = pos
	for i = 1,armlenght do
		pos = vector.add(pos,dir)
		mpos = vector.add(mpos,mdir)
		minetest.place_schematic(pos,minetest.get_modpath("default") .. "/schematics/moriav2.mts")--,"0",nil,true)
		minetest.place_schematic(mpos,minetest.get_modpath("default") .. "/schematics/moriav2.mts")--,"0",nil,true)
	end
end
function add_dwarfern_mine(startpos,steps,armchanche,armlenght,treasurechanche,delay)
	minetest.after(delay,function(startpos,steps,armchanche,armlenght,treasurechanche)
	local add = get_random_direction_for_dwarfern_mine()
	while steps > 0 do
		startpos = vector.add(startpos,add)
		if armchanche and built_in_lua_random(1,armchanche) == 1 then
			add_dwarfern_mine_arms(startpos,rotate_vec_right_angle(add),armlenght,treasurechanche)
			steps = steps-(2*armlenght)
		end
		steps = steps-1
		add_dwarfern_mine_skelleton(startpos,treasurechanche)
	end end,startpos,steps,armchanche,armlenght,treasurechanche)
end
function add_moria_mine(startpos,steps--[[,armchanche,armlenght]],delay)
	minetest.after(delay,function(startpos,steps,armchanche,armlenght,treasurechanche)
	local add = get_random_direction_for_moria_mine()
	--while steps > 0 do
	for i = 1,steps do
		startpos = vector.add(startpos,add)
		--[[if armchanche and built_in_lua_random(1,armchanche) == 1 then
			add_moria_mine_arms(startpos,rotate_vec_right_angle(add),armlenght)
			steps = steps-(2*armlenght)
		end]]
		--add_moria_mine_skelleton(startpos)
		minetest.place_schematic(startpos,minetest.get_modpath("default") .. "/schematics/moriav2.mts")--,"0",nil,true)
	end end,startpos,steps,armchanche,armlenght)
end
--minetest.after(10,function()
--add_dwarfern_mine({x = -2,y = -10,z = -2},10,10,5,10)end)
--[[local function register_grass_decoration(offset, scale, length)
	minetest.register_decoration({
		deco_type = "simple",
		place_on = {"default:dirt_with_grass", "default:sand"},
		sidelen = 16,
		noise_params = {
			offset = offset,
			scale = scale,
			spread = {x = 200, y = 200, z = 200},
			seed = 329,
			octaves = 3,
			persist = 0.6
		},
		biomes = {"stone_grassland", "sandstone_grassland",
			"deciduous_forest", "coniferous_forest",
			"stone_grassland_dunes", "sandstone_grassland_dunes",
			"coniferous_forest_dunes"},
		y_min = 1,
		y_max = 31000,
		decoration = "default:grass_"..length,
	})
end]]
function place_schematic_central(schematic,sidelen,pos,one_direction,force)
	sidelen  = (sidelen-1)/2
	if one_direction then
		minetest.place_schematic(vector.subtract(pos,{x =sidelen ,y=0,z=sidelen}),minetest.get_modpath("default") .. "/schematics/" .. schematic,"0",nil,(force == "FORCE"))
	else
		minetest.place_schematic(vector.subtract(pos,{x =sidelen ,y=0,z=sidelen}),minetest.get_modpath("default") .. "/schematics/" .. schematic,"random",nil,(force == "FORCE"))
	end
end
local function gondor_city_place(p,centre,minp)
	local rp = vector.subtract(p,centre)
			local x = math.floor(rp.x%16)
			local z = math.floor(rp.z%16)
			if (p.x == minp.x) then
				x = 4
				p.x = p.x-4
				if (x>13) or (x<2) or (z>13) or (z<2) then
					p.x = p.x+4
				end
			end
			if (p.z == minp.z) then
				z = 2
				p.z = p.z-6
				if (x>13) or (x<2) or (z>13) or (z<2) then
					p.x = p.x+6
				end
			end
			if (x>13) or (x<2) or (z>13) or (z<2) then
				minetest.set_node(p,{name = "default:gravel"})
			elseif (x==4) and (z==2) and fastapproxisflatenoughforcircle(vector.add(p,{x=6,y=0,z=6}),6,3) then
				local rs =math.random(1,16)
				if rs < 5 then
					minetest.after(0.1,function()
					minetest.place_schematic(vector.subtract(p,{x=0,y=9,z=0}),minetest.get_modpath("default") .. "/schematics/gondorpub.mts")end)
				elseif rs > 12 then
					p.x = p.x-2
					p.z = p.z+2
					minetest.after(0.1,function()
					minetest.place_schematic(vector.subtract(p,{x=0,y=9,z=0}),minetest.get_modpath("default") .. "/schematics/gondorpub.mts","90")end)
				elseif rs < 12 then
					p.x = p.x-1
					p.z = p.z+1
					minetest.after(0.1,function()
					minetest.place_schematic(vector.subtract(p,{x=0,y=9,z=0}),minetest.get_modpath("default") .. "/schematics/cityhouse.mts")end)
				else
					p.x = p.x-1
					p.z = p.z+1
					minetest.after(0.1,function()
					minetest.place_schematic(vector.subtract(p,{x=0,y=9,z=0}),minetest.get_modpath("default") .. "/schematics/gondorfort.mts")end)
				end
--elseif (x==2) and (z==4) and ((sd%2 == 1) or true) then
--minetest.after(0.1,function()
--minetest.place_schematic(vector.subtract(p,{x=0,y=9,z=0}),minetest.get_modpath("default") .. "/schematics/gondorpub.mts","90")end)

			end
end
local function ithilien_city_place(p,centre,minp)
	local rp = vector.subtract(p,centre)
			local x = math.floor(rp.x%16)
			local z = math.floor(rp.z%16)
			if (p.x == minp.x) then
				x = 4
				p.x = p.x-4
				if (x>13) or (x<2) or (z>13) or (z<2) then
					p.x = p.x+4
				end
			end
			if (p.z == minp.z) then
				z = 2
				p.z = p.z-6
				if (x>13) or (x<2) or (z>13) or (z<2) then
					p.x = p.x+6
				end
			end
			if (x>13) or (x<2) or (z>13) or (z<2) then
				minetest.set_node(p,{name = "default:gravel"})
			elseif (x==4) and (z==2) and fastapproxisflatenoughforcircle(vector.add(p,{x=6,y=0,z=6}),6,3) then
				local rs =math.random(1,15)
				if rs < 5 then
					minetest.after(0.1,function()
					minetest.place_schematic(vector.subtract(p,{x=0,y=9,z=0}),minetest.get_modpath("default") .. "/schematics/ithilienpub.mts")end)
				elseif rs > 11 then
					p.x = p.x-2
					p.z = p.z+2
					minetest.after(0.1,function()
					minetest.place_schematic(vector.subtract(p,{x=0,y=9,z=0}),minetest.get_modpath("default") .. "/schematics/ithilienpub.mts","90")end)
				else
					p.x = p.x-1
					p.z = p.z+1
					minetest.after(0.1,function()
					minetest.place_schematic(vector.subtract(p,{x=0,y=9,z=0}),minetest.get_modpath("default") .. "/schematics/cityhouse.mts")end)
				end
--elseif (x==2) and (z==4) and ((sd%2 == 1) or true) then
--minetest.after(0.1,function()
--minetest.place_schematic(vector.subtract(p,{x=0,y=9,z=0}),minetest.get_modpath("default") .. "/schematics/gondorpub.mts","90")end)

			end
end
local function rohan_city_place(p,centre,minp)
	local rp = vector.subtract(p,centre)
			local x = math.floor(rp.x%16)
			local z = math.floor(rp.z%16)
			if (p.x == minp.x) then
				x = 4
				p.x = p.x-4
				if (x>13) or (x<2) or (z>13) or (z<2) then
					p.x = p.x+4
				end
			end
			if (p.z == minp.z) then
				z = 2
				p.z = p.z-6
				if (x>13) or (x<2) or (z>13) or (z<2) then
					p.x = p.x+6
				end
			end
			if (x>13) or (x<2) or (z>13) or (z<2) then
				minetest.set_node(p,{name = "default:gravel"})
			elseif (x==4) and (z==2) and fastapproxisflatenoughforcircle(vector.add(p,{x=6,y=0,z=6}),6,3) then
				local rs =math.random(1,15)
				if rs < 5 then
					minetest.after(0.1,function()
					minetest.place_schematic(vector.subtract(p,{x=0,y=9,z=0}),minetest.get_modpath("default") .. "/schematics/rohanpub.mts")end)
				elseif rs > 11 then
					p.x = p.x-2
					p.z = p.z+2
					minetest.after(0.1,function()
					minetest.place_schematic(vector.subtract(p,{x=0,y=9,z=0}),minetest.get_modpath("default") .. "/schematics/rohanpub.mts","90")end)
				else
					p.x = p.x-1
					p.z = p.z+1
					minetest.after(0.1,function()
					minetest.place_schematic(vector.subtract(p,{x=0,y=9,z=0}),minetest.get_modpath("default") .. "/schematics/cityhouse.mts")end)
				end
--elseif (x==2) and (z==4) and ((sd%2 == 1) or true) then
--minetest.after(0.1,function()
--minetest.place_schematic(vector.subtract(p,{x=0,y=9,z=0}),minetest.get_modpath("default") .. "/schematics/gondorpub.mts","90")end)

			end
end
local function shire_city_place(p,centre,minp)
	local rp = vector.subtract(p,centre)
			local x = math.floor(rp.x%16)
			local z = math.floor(rp.z%16)
			if (p.x == minp.x) then
				x = 4
				p.x = p.x-4
				if (x>13) or (x<2) or (z>13) or (z<2) then
					p.x = p.x+4
				end
			end
			if (p.z == minp.z) then
				z = 2
				p.z = p.z-6
				if (x>13) or (x<2) or (z>13) or (z<2) then
					p.x = p.x+6
				end
			end
			if (x>13) or (x<2) or (z>13) or (z<2) then
				minetest.set_node(p,{name = "default:gravel"})
			elseif (x==3) and (z==3) and fastapproxisflatenoughforcircle(vector.add(p,{x=6,y=0,z=6}),6,3) then
					minetest.after(0.1,function()
					minetest.place_schematic(vector.subtract(p,{x=0,y=9,z=0}),minetest.get_modpath("default") .. "/schematics/hobbithole2.mts")end)
--elseif (x==2) and (z==4) and ((sd%2 == 1) or true) then
--minetest.after(0.1,function()
--minetest.place_schematic(vector.subtract(p,{x=0,y=9,z=0}),minetest.get_modpath("default") .. "/schematics/gondorpub.mts","90")end)

			end
end
--MALLORN
local function vector_min(a,b)
return {x = math.min(a.x,b.x),y = math.min(a.y,b.y),z = math.min(a.z,b.z)}
end
--minetest.chat_send_all(minetest.get_mapgen_setting("seed") or "NOO")
local testparam = {
   offset = 0,
   scale = 1,
   spread = {x=2048, y=2048, z=2048},
   seed = 43,
   octaves = 6,
   persist = 0.6
}
minetest.register_on_generated(--[[function(p1,p2)minetest.after(0.2,]]function(p1,p2)
	if p1.y < -3000 and p2.y > -3000 then
	local c_air = minetest.get_content_id("air")
	local c_lava = minetest.get_content_id("default:lava_source")
	local c_nrack = minetest.get_content_id("default:netherrack")
	local c_nteleport = minetest.get_content_id("default:teleportnetherrack")
	local vm,minp,maxp = --[[minetest.get_mapgen_object("voxelmanip")]]minetest.get_mapgen_object("voxelmanip")--VoxelManip()
--	vm:calc_lighting()--p1,p2)
	--vm:update_map()
	vm:set_lighting({day = 0,night = 0})
	--local minp, maxp = vm:read_from_map(p1, p2)
	--local minp,maxp = p1,p2
	local shardtest = shardmap(minp,maxp,8)
	local a = VoxelArea:new({MinEdge = minp, MaxEdge = maxp})
	local data = vm:get_data()
	local lavalevel = 16+minp.y
	local volcanofreq = 10
	local teleportfreq = 18
	local maxy = maxp.y
	for i,d in built_in_lua_pairs(data) do
		local p = a:position(i)
		if p.y > shardtest[p.x][p.z] then
			if p.y > lavalevel then
				data[i] = c_air
			else
				data[i] = c_lava
			end
		else
			if p.y < maxy then
				data[i] = c_nrack
			else
				volcanofreq = volcanofreq-1
				teleportfreq = teleportfreq-1
				if volcanofreq == 0 then
					data[i] = c_lava
					volcanofreq = 10
				elseif teleportfreq == 0 then
					data[i] = c_nteleport
					teleportfreq = 18
				else
					data[i] = c_nrack
				end
			end
		end
	end
	vm:set_data(data)
	vm:update_liquids()
	vm:write_to_map()
	elseif (p1.y-(p2.y+1-p1.y) < -3000 and p2.y-(p2.y+1-p1.y) > -3000) or (p1.y-3*(1+p2.y-p1.y) < -6000 and p2.y-3*(1+p2.y-p1.y) > -6000) then
	local floorlift = math.floor((p2.y+1-p1.y)/2)
	local c_air = minetest.get_content_id("air")
	local c_nrack = minetest.get_content_id("default:netherrack")
	local c_lava = minetest.get_content_id("default:lava_source")
	local vm,minp,maxp = --[[minetest.get_mapgen_object("voxelmanip")]]minetest.get_mapgen_object("voxelmanip")--VoxelManip()
	--minetest.chat_send_all("MAX" .. tostring(p1.y-(1+p2.y-p1.y)))
	local a = VoxelArea:new({MinEdge = minp, MaxEdge = maxp})
	minp.y = minp.y+floorlift
	local shardtest = shardmap(minp,maxp,8)
	minp.y = minp.y-floorlift
--	vm:calc_lighting()--p1,p2)
	--vm:update_map()
	local data = vm:get_data()
	local lavalevel = 16+minp.y
	local volcanofreq = 10
	local teleportfreq = 18
	local maxy = maxp.y
	for i,d in built_in_lua_pairs(data) do
		local p = a:position(i)
		if (p.y > shardtest[p.x][p.z]) and (d ~= c_nrack) and (d ~= c_lava) then
			data[i] = c_nrack
		else
			data[i] = c_air
		end
	end
	vm:set_data(data)
	vm:update_liquids()
	vm:write_to_map()
	elseif p1.y < -6000 and p2.y > -6000 then
	local c_air = minetest.get_content_id("air")
	local c_lava = minetest.get_content_id("default:lava_source")
	local c_magma = minetest.get_content_id("default:magma_source")
	local c_nrack = minetest.get_content_id("default:netherrack")
	local c_dragoneore = minetest.get_content_id("default:bloodore")
	--local vm = --[[minetest.get_mapgen_object("voxelmanip")]]VoxelManip()
--	vm:calc_lighting()--p1,p2)
	local vm,minp,maxp = --[[minetest.get_mapgen_object("voxelmanip")]]minetest.get_mapgen_object("voxelmanip")--VoxelManip()
	local a = VoxelArea:new({MinEdge = minp, MaxEdge = maxp})
--	vm:calc_lighting()--p1,p2)
	local ulmotests,magmaradiussquare = ulmomap(minp,maxp)
	local data = vm:get_data()
	local island_chanche = 401
	local lavalevel = 48+minp.y
	local magmalevel = lavalevel - 32
	local maxy = maxp.y
	for i,d in built_in_lua_pairs(data) do
		local p = a:position(i)
		if p.y > ulmotests[p.x][p.z] then
			if p.y > lavalevel then
				data[i] = c_air
			elseif magmaradiussquare < (p.x*p.x+p.z*p.z) then
				if two_value_bool_noise(p.x/2,p.z/2,island_chanche) and p.y+1> lavalevel then
					data[i] = c_dragoneore
				else
					data[i] = c_lava
				end
			elseif p.y < magmalevel then
				data[i] = c_magma
			else
				data[i] = c_air
			end
		else
			data[i] = c_nrack
		end
	end
	vm:set_data(data)
	vm:update_liquids()
	vm:write_to_map()
	elseif p1.y-(1+p2.y-p1.y) < -6000 and p2.y-(1+p2.y-p1.y) > -6000 then
	local c_air = minetest.get_content_id("air")
	local c_lava = minetest.get_content_id("default:lava_source")
	local c_nrack = minetest.get_content_id("default:netherrack")
	local c_nteleport = minetest.get_content_id("default:teleportnetherrack")
--	vm:calc_lighting()--p1,p2)
	--vm:update_map()
	local layersize = p2.y-p1.y+1
	local vm,minp,maxp = --[[minetest.get_mapgen_object("voxelmanip")]]minetest.get_mapgen_object("voxelmanip")--VoxelManip()
	--minetest.chat_send_all(maxp.y)
	minp.y = minp.y-layersize
	maxp.y = maxp.y-layersize
	local ulmotests = ulmomap(minp,maxp)
	minp.y = minp.y+layersize
	maxp.y = maxp.y+layersize
local a = VoxelArea:new({MinEdge = minp, MaxEdge = maxp})
	local data = vm:get_data()
	local lavalevel = 32+minp.y
	local volcanofreq = 1600
	local teleportfreq = 180
	local maxy = maxp.y
	--minetest.chat_send_all(tostring(p1.y))
	for i,d in built_in_lua_pairs(data) do
		local p = a:position(i)
		if p.y > ulmotests[p.x][p.z] then
			data[i] = c_air
		else
			volcanofreq = volcanofreq-1
			teleportfreq = teleportfreq-1
			if volcanofreq == 0 then
				data[i] = c_lava
				volcanofreq = 1600
			elseif teleportfreq == 0 then
				data[i] = c_nteleport
				teleportfreq = 180
			else
				data[i] = c_nrack
			end
		end
	end
	vm:set_data(data)
	vm:update_liquids()
	vm:write_to_map()
	elseif p1.y-2*(1+p2.y-p1.y) < -6000 and p2.y-2*(1+p2.y-p1.y) > -6000 then
	local c_air = minetest.get_content_id("air")
	local c_lava = minetest.get_content_id("default:lava_source")
	local c_nrack = minetest.get_content_id("default:netherrack")
	local c_nteleport = minetest.get_content_id("default:teleportnetherrack")
--	vm:calc_lighting()--p1,p2)
	--vm:update_map()
	local layersize = 2*(p2.y-p1.y+1)
	local vm,minp,maxp = --[[minetest.get_mapgen_object("voxelmanip")]]minetest.get_mapgen_object("voxelmanip")--VoxelManip()
	--minetest.chat_send_all(maxp.y)
	minp.y = minp.y-layersize
	maxp.y = maxp.y-layersize
	local ulmotests = ulmomap(minp,maxp)
	minp.y = minp.y+layersize
	maxp.y = maxp.y+layersize
local a = VoxelArea:new({MinEdge = minp, MaxEdge = maxp})
	local data = vm:get_data()
	local lavalevel = 32+minp.y
	local volcanofreq = 800
	local teleportfreq = 180
	local maxy = maxp.y
	--minetest.chat_send_all(tostring(p1.y))
	for i,d in built_in_lua_pairs(data) do
		local p = a:position(i)
		if p.y > ulmotests[p.x][p.z] then
			data[i] = c_air
		else
			volcanofreq = volcanofreq-1
			teleportfreq = teleportfreq-1
			if volcanofreq == 0 then
				data[i] = c_lava
				volcanofreq = 800
			elseif teleportfreq == 0 then
				data[i] = c_nteleport
				teleportfreq = 180
			else
				data[i] = c_nrack
			end
		end
	end
	vm:set_data(data)
	vm:update_liquids()
	vm:write_to_map()
	elseif p1.y < -9000 and p2.y > -9000 then
	local c_air = minetest.get_content_id("air")
	local c_lava = minetest.get_content_id("default:nice_souls_source")
	local c_lift = minetest.get_content_id("default:nice_souls_steam")
	local c_nrack = minetest.get_content_id("default:underworldrack")
	local c_nteleport = minetest.get_content_id("default:teleportnetherrack")
--	vm:calc_lighting()--p1,p2)
	--vm:update_map()
	local layersize = p2.y-p1.y+1
	local vm,minp,maxp = --[[minetest.get_mapgen_object("voxelmanip")]]minetest.get_mapgen_object("voxelmanip")--VoxelManip()
	--minetest.chat_send_all(maxp.y)
	local ulmotests,_,lavamap = underworldmap(minp,maxp)
	local minpx = minp.x
	minp.x= minp.z
	minp.z = minpx
	minpx = maxp.x
	maxp.x= maxp.z
	maxp.z = minpx
	local ulmotests2,_,lavamap2 = underworldmap(minp,maxp)
	minpx = minp.x
	minp.x= minp.z
	minp.z = minpx
	minpx = maxp.x
	maxp.x= maxp.z
	maxp.z = minpx
local a = VoxelArea:new({MinEdge = minp, MaxEdge = maxp})
	local data = vm:get_data()
	local lavalevel = 32+minp.y
	local volcanofreq = 16000
	local teleportfreq = 180
	local maxy = maxp.y
	--minetest.chat_send_all(tostring(p1.y))
	for i,d in built_in_lua_pairs(data) do
		local p = a:position(i)
		if p.y > ulmotests[p.x][p.z]-25 then
if lavamap2[p.z][p.x] then
			data[i] = c_lift

		elseif (p.y > ulmotests2[p.z][p.x]-25+125 or p.y < ulmotests2[p.z][p.x]-25+75) and (p.y > ulmotests2[p.z][p.x]-25+200 or p.y < ulmotests2[p.z][p.x]-25+175) then
			data[i] = c_air
		else
			volcanofreq = volcanofreq-1
			teleportfreq = teleportfreq-1
			if volcanofreq == 0 then
				volcanofreq = 16000
			elseif teleportfreq == 0 then
				teleportfreq = 180
			end
			data[i] = c_nrack
		end
		else
			if lavamap[p.x][p.z] and p.y == ulmotests[p.x][p.z]-25 then
				data[i] = c_lava
			else
			volcanofreq = volcanofreq-1
			teleportfreq = teleportfreq-1
			if volcanofreq == 0 then
				data[i] = c_lava
				volcanofreq = 16000
			elseif teleportfreq == 0 then
				data[i] = c_nteleport
				teleportfreq = 180
			else
				data[i] = c_nrack
			end
			end
		end
	end
	vm:set_data(data)
	vm:update_liquids()
	vm:write_to_map()
	elseif p1.y-(1+p2.y-p1.y) < -9000 and p2.y-(1+p2.y-p1.y) > -9000 then
	local c_air = minetest.get_content_id("air")
	local c_lava = minetest.get_content_id("default:nice_souls_source")
	local c_lift = minetest.get_content_id("default:nice_souls_steam")
	local c_nrack = minetest.get_content_id("default:underworldrack")
	local c_nteleport = minetest.get_content_id("default:teleportnetherrack")
--	vm:calc_lighting()--p1,p2)
	--vm:update_map()
	local layersize = p2.y-p1.y+1
	local vm,minp,maxp = --[[minetest.get_mapgen_object("voxelmanip")]]minetest.get_mapgen_object("voxelmanip")--VoxelManip()
	--minetest.chat_send_all(maxp.y)
	minp.y = minp.y-layersize+25
	maxp.y = maxp.y-layersize+25
	local ulmotests,_,lavamap = underworldmap(minp,maxp)
	local minpx = minp.x
	minp.x= minp.z
	minp.z = minpx
	minpx = maxp.x
	maxp.x= maxp.z
	maxp.z = minpx
	local ulmotests2,_,lavamap2 = underworldmap(minp,maxp)
	minpx = minp.x
	minp.x= minp.z
	minp.z = minpx
	minpx = maxp.x
	maxp.x= maxp.z
	maxp.z = minpx
	minp.y = minp.y+layersize-25
	maxp.y = maxp.y+layersize-25
local a = VoxelArea:new({MinEdge = minp, MaxEdge = maxp})
	local data = vm:get_data()
	local lavalevel = 32+minp.y
	local volcanofreq = 1600
	local teleportfreq = 180
	local maxy = maxp.y
	--minetest.chat_send_all(tostring(p1.y))
	for i,d in built_in_lua_pairs(data) do
		local p = a:position(i)
		if p.y > ulmotests[p.x][p.z]-25 then
		if lavamap2[p.z][p.x] then
			data[i] = c_lift
		elseif (p.y > ulmotests2[p.z][p.x]-25+125 or p.y < ulmotests2[p.z][p.x]-25+75) and (p.y > ulmotests2[p.z][p.x]-25+200 or p.y < ulmotests2[p.z][p.x]-25+175)  then
			data[i] = c_air
		else
			volcanofreq = volcanofreq-1
			teleportfreq = teleportfreq-1
			if volcanofreq == 0 then
				volcanofreq = 16000
			elseif teleportfreq == 0 then
				teleportfreq = 180
			end
			data[i] = c_nrack
		end
		else
			if lavamap[p.x][p.z] and p.y == ulmotests[p.x][p.z]-25 then
				data[i] = c_lava
			else
			volcanofreq = volcanofreq-1
			teleportfreq = teleportfreq-1
			if volcanofreq == 0 then
				data[i] = c_lava
				volcanofreq = 1600
			elseif teleportfreq == 0 then
				data[i] = c_nteleport
				teleportfreq = 180
			else
				data[i] = c_nrack
			end
			end
		end
	end
	vm:set_data(data)
	vm:update_liquids()
	vm:write_to_map()
	elseif p1.y-2*(1+p2.y-p1.y) < -9000 and p2.y-2*(1+p2.y-p1.y) > -9000 then
	local c_air = minetest.get_content_id("air")
	local c_lava = minetest.get_content_id("default:nice_souls_source")
	local c_lift = minetest.get_content_id("default:nice_souls_steam")
	local c_nrack = minetest.get_content_id("default:underworldrack")
	local c_nteleport = minetest.get_content_id("default:teleportnetherrack")
--	vm:calc_lighting()--p1,p2)
	--vm:update_map()
	local layersize = 2*(p2.y-p1.y+1)
	local vm,minp,maxp = --[[minetest.get_mapgen_object("voxelmanip")]]minetest.get_mapgen_object("voxelmanip")--VoxelManip()
	--minetest.chat_send_all(maxp.y)
	local ulmotests,_,lavamap = underworldmap(minp,maxp)
	local minpx = minp.x
	minp.x= minp.z
	minp.z = minpx
	minpx = maxp.x
	maxp.x= maxp.z
	maxp.z = minpx
	local ulmotests2,_,lavamap2 = underworldmap(minp,maxp)
	minpx = minp.x
	minp.x= minp.z
	minp.z = minpx
	minpx = maxp.x
	maxp.x= maxp.z
	maxp.z = minpx
local a = VoxelArea:new({MinEdge = minp, MaxEdge = maxp})
	local data = vm:get_data()
	local lavalevel = 32+minp.y
	local volcanofreq = 800
	local teleportfreq = 180
	local maxy = maxp.y
	--minetest.chat_send_all(tostring(p1.y))
	for i,d in built_in_lua_pairs(data) do
		local p = a:position(i)
		if p.y > ulmotests[p.x][p.z]-25 then
if  lavamap2[p.z][p.x] then
			data[i] = c_lift

		elseif (p.y > ulmotests2[p.z][p.x]-25+125 or p.y < ulmotests2[p.z][p.x]-25+75) and (p.y > ulmotests2[p.z][p.x]-25+200 or p.y < ulmotests2[p.z][p.x]-25+175)  then
			data[i] = c_air
		else
			volcanofreq = volcanofreq-1
			teleportfreq = teleportfreq-1
			if volcanofreq == 0 then
				volcanofreq = 16000
			elseif teleportfreq == 0 then
				teleportfreq = 180
			end
			data[i] = c_nrack
		end
		else
			if lavamap[p.x][p.z] and p.y == ulmotests[p.x][p.z]-25 then
				data[i] = c_lava
			else
			volcanofreq = volcanofreq-1
			teleportfreq = teleportfreq-1
			if volcanofreq == 0 then
				data[i] = c_lava
				volcanofreq = 1600
			elseif teleportfreq == 0 then
				data[i] = c_nteleport
				teleportfreq = 180
			else
				data[i] = c_nrack
			end
			end
		end
	end
	vm:set_data(data)
	vm:update_liquids()
	vm:write_to_map()
	elseif p1.y < -500 and p2.y > -500 then
	local c_air = minetest.get_content_id("air")
	local c_lava = minetest.get_content_id("default:lava_source")
	local c_cobble = minetest.get_content_id("default:cobble")
	local c_stonebrick = minetest.get_content_id("default:stonebrick")
	local vm = --[[minetest.get_mapgen_object("voxelmanip")]]VoxelManip()
--	vm:calc_lighting()--p1,p2)
	--vm:update_map()
	vm:set_lighting({day = 0,night = 0})
	local minp, maxp = vm:read_from_map(p1, p2)
	local a = VoxelArea:new({MinEdge = minp, MaxEdge = maxp})
	local data = vm:get_data()
	local lavalevel = 6+minp.y
	for i,d in built_in_lua_pairs(data) do
		local p = a:position(i)
		local x = p.x%20
		local y = p.y%10
		local z = p.z%20
		if p.y <= lavalevel then
		data[i] = c_lava
		elseif (((x > 17) or (x < 2)) and ((z > 17) or (z < 2)))then
		data[i] = c_cobble
		elseif (y == 0) and ((x > 16) or (x < 3) or (z > 16) or (z < 3))then
		data[i] = c_stonebrick
		else
		data[i] = c_air
		end
	end
	vm:set_data(data)
	vm:update_liquids()
	vm:write_to_map()
	else
	local pipeweedshirefield = (built_in_lua_random(1,3) == 1)
	--local cornshirefield = (built_in_lua_random(1,5) == 1) and not pipeweedshirefield
	local hobbitcrop = default_get_next_hobbitcrop()
	local wheatrohanfield = (built_in_lua_random(1,25) == 1)
	local barleyrohanfield = (built_in_lua_random(1,25) == 1) and not wheatrohanfield
	local cottonrohanfield = (built_in_lua_random(1,25) == 1) and (not barleyrohanfield) and not wheatrohanfield
	local vm = --[[minetest.get_mapgen_object("voxelmanip")]]VoxelManip()
--	vm:calc_lighting()--p1,p2)
	--vm:update_map()
	if p1.y+p2.y < -100 then
		vm:set_lighting({day = 0,night = 0})
	end
	local gondorcity = (math.random(1,8) == 1)
	local minpcomp = vector_min(p1,p2)
	local centre = vector.multiply(vector.add(p1,p2),0.5)
	local minp, maxp = vm:read_from_map(p1, p2)
	local a = VoxelArea:new({MinEdge = minp, MaxEdge = maxp})
	local data = vm:get_data()
	local c_air = minetest.get_content_id("air")
	local c_stone = minetest.get_content_id("default:stone")
	local c_water = minetest.get_content_id("default:water_source")
	local c_mirkwood = minetest.get_content_id("default:mirkwooddirt")
	local c_lorien = minetest.get_content_id("default:loriendirt")
	local c_desert = minetest.get_content_id("default:desert_sand")
	local c_dunland = minetest.get_content_id("default:dunlanddirt")
	local c_gondor = minetest.get_content_id("default:gondordirt")
	local c_ithilien = minetest.get_content_id("default:ithiliendirt")
	local c_shire = minetest.get_content_id("default:shiredirt")
	local c_brownlands = minetest.get_content_id("default:brownlandsdirt")
	local c_trollshaws = minetest.get_content_id("default:trollshawsdirt")
	local c_rohan = minetest.get_content_id("default:rohandirt")
	local c_fangorn = minetest.get_content_id("default:fangorndirt")
	local c_mordor = minetest.get_content_id("default:mordordust_mapgen")
	local c_mordor2 = minetest.get_content_id("default:mordordust")
	local c_angmar = minetest.get_content_id("default:angmarsnow")
	local c_bluemountains = minetest.get_content_id("default:bluemountainsdirt")
	local c_ironhills = minetest.get_content_id("default:ironhillsdirt")
	local c_bluemountainstone = minetest.get_content_id("default:bluemountainstone")
	local c_ironhillstone = minetest.get_content_id("default:ironhillstone")
	local c_mapgen_air_substitute = minetest.get_content_id("default:mapgen_air_substitute")
	local c_sand = minetest.get_content_id("default:sand")
	local c_snow = minetest.get_content_id("default:mountainsnow")
	local c_pine_needles = minetest.get_content_id("default:pine_needles")
	local c_valinor = minetest.get_content_id("default:valinordirt")
	for i,d in built_in_lua_pairs(data) do
		local p = a:position(i)
		if p.y >= 0 then
			if (d ~= c_air) and (d ~= c_stone) and (d ~= c_water) then
				--on_gen_spawn_gravel_adding(d,p)
				if d == c_mirkwood then
					if built_in_lua_random(1,25) == 1 then-- and not get_node_in_cube(p,--[[3]]10,"default:")then
						place_schematic_central("mirk3.mts",9,p)
					elseif built_in_lua_random(1,3000) == 1--[[ and ]]--[[not get_node_in_cube(p,5,"default:mirktree")]]  and fastapproxisflatenoughforcircle(p,5,2) then
					minetest.after(0.1,function(p)
						place_schematic_central(--[["mirkcutter.mts"]]--[["smallmirkcutter.mts"]]"finalmirkcutter.mts",7,vector.add(p,{x=0,y=2,z=0}),nil,"FORCE")
						place_schematic_central("mirkhouse.mts",9,p)
					end,p)
				elseif p.y < 0.5 then
					if built_in_lua_random(1,3) == 1 then
						minetest.set_node(p,{name = "default:clay"})
					else
						minetest.set_node(p,{name = "default:sand"})
					end
					if built_in_lua_random(1,2) == 1 then
						for i=2,4 do
							minetest.set_node({x=p.x,y=p.y+i,z=p.z},{name = "default:papyrus"})
						end
					end
				end
				elseif d == c_desert then
					if built_in_lua_random(1,10000) == 1 and data[a:indexp(vector.add(p,{x=0,y=1,z=0}))] == c_air then
						minetest.place_schematic(vector.subtract(p,{x=2,y=0,z=0}),minetest.get_modpath("default") .. "/schematics/large_cactus.mts")
					elseif built_in_lua_random(1,10000) == 1 and data[a:indexp(vector.add(p,{x=0,y=1,z=0}))] == c_air then
						minetest.place_schematic(vector.subtract(p,{x=0,y=0,z=2}),minetest.get_modpath("default") .. "/schematics/large_cactus.mts","90")
					elseif built_in_lua_random(1,30000) == 1 and data[a:indexp(vector.add(p,{x=0,y=1,z=0}))] == c_air then
						minetest.place_schematic(vector.subtract(p,{x=3,y=0,z=3}),minetest.get_modpath("default") .. "/schematics/acacia_tree.mts")
					elseif built_in_lua_random(1,5000) == 1 then
						p.y = p.y+1
						if minetest.get_node(p).name == "air" then
						minetest.set_node(p,{name = "default:deserttrap_open"})
						end
					end
				elseif d == c_snow then
					--[[if p.y > 40 and data[a:indexp(vector.add(p,{x=0,y=1,z=0}))] == c_air then
						minetest.set_node(p,{name = "default:snow"})
					elseif built_in_lua_random(1,10) == 1 and data[a:indexp(vector.add(p,{x=0,y=1,z=0}))] == c_air then
						if math.random(1,2) == 1 then
							minetest.remove_node(p)
						else
							p.y = p.y+1
							minetest.set_node(p,{name="golems:bedrock"})
						end
					]]
					p.y = p.y-1
					if data[a:indexp(p)] ~= c_pine_needles then
					if  built_in_lua_random(1,10000) == 1 then
							p.y = p.y+1
							--[[minetest.after(0.1,function()]]minetest.after(0.1,function()
							for i=1,3 do
								p.y = p.y+1
								minetest.set_node(p,{name = "default:pinetree"})
							end

			--place_schematic_central("foggypine.mts",5,p,true,true)
			minetest.place_schematic(vector.subtract(p,{x=2,y=0,z=2}), minetest.get_modpath("default").."/schematics/foggypine.mts", "0", nil,true)

end)--end)
					else
							p.y = p.y+1
							for i=1,5 do
								p.y = p.y+1
								local d = data[a:index(p.x,p.y,p.z)]
								if ((not d) or (d== c_air)) then
									minetest.set_node(p,{name = "golems:fog"})
								end
							end
							--
					end
					elseif p.y < 0.5 then
					if built_in_lua_random(1,3) == 1 then
						minetest.set_node(p,{name = "default:clay"})
					else
						minetest.set_node(p,{name = "default:sand"})
					end
				end
				elseif d == c_lorien then 
					if built_in_lua_random(1,10) == 1 and not get_node_in_cube(p,3,"default:mallorntree")then
					place_schematic_central("mallorn2.mts",20,vector.subtract(p,{x=0,y=2,z=0}))
					elseif built_in_lua_random(1,100) == 1 and not get_node_in_cube(p,3,"default:mallorntree") and fastapproxisflatenoughforcircle(p,5,2) then
					place_schematic_central("mallornhouse.mts",20,vector.subtract(p,{x=0,y=--[[2]]0,z=0}))
				elseif p.y < 0.5 then
					if built_in_lua_random(1,3) == 1 then
						minetest.set_node(p,{name = "default:clay"})
					else
						minetest.set_node(p,{name = "default:sand"})
					end
					if built_in_lua_random(1,2) == 1 then
						for i=2,4 do
							minetest.set_node({x=p.x,y=p.y+i,z=p.z},{name = "default:papyrus"})
						end
					end
				end
				elseif d == c_valinor then 
					if built_in_lua_random(1,400) == 1 then-- and not get_node_in_cube(p,--[[3]]10,"default:")then
						place_schematic_central("mirk3.mts",9,p)
					elseif built_in_lua_random(1,400) == 1 then
					place_schematic_central("bigjtreewithvines.mts",8,p)
					elseif built_in_lua_random(1,20) == 1 and not get_node_in_cube(p,3,"default:mallorntree")then
					place_schematic_central("mallorn2.mts",20,vector.subtract(p,{x=0,y=2,z=0}))
				elseif p.y < 0.5 then
					if built_in_lua_random(1,3) == 1 then
						minetest.set_node(p,{name = "default:clay"})
					else
						minetest.set_node(p,{name = "default:sand"})
					end
					if built_in_lua_random(1,2) == 1 then
						for i=2,4 do
							minetest.set_node({x=p.x,y=p.y+i,z=p.z},{name = "default:papyrus"})
						end
					end
				end
				elseif d == c_fangorn then
					if built_in_lua_random(1,75) == 1 then
					place_schematic_central("bigjtreewithvines.mts",8,p)
				elseif p.y < 0.5 then
					if built_in_lua_random(1,3) == 1 then
						minetest.set_node(p,{name = "default:clay"})
					else
						minetest.set_node(p,{name = "default:sand"})
					end
					if built_in_lua_random(1,2) == 1 then
						for i=2,4 do
							minetest.set_node({x=p.x,y=p.y+i,z=p.z},{name = "default:papyrus"})
						end
					end
				end
				elseif p.y < 0.5 and (d == c_dunland or d == c_gondor or d == c_ithilien or d == c_shire or d == c_brownlands or d==c_trollshaws or d == c_valinor or d == c_rohan or d == c_ironhills or d == c_angmar or d == c_bluemountains) then
					if built_in_lua_random(1,3) == 1 then
						minetest.set_node(p,{name = "default:clay"})
					else
						minetest.set_node(p,{name = "default:sand"})
					end
					if (d ~= c_angmar) and (d ~= c_bluemountains) and (d ~= c_brownlands) and (d ~= c_trollshaws) and (d ~= c_ironhills) and (built_in_lua_random(1,2) == 1) then
						for i=2,4 do
							minetest.set_node({x=p.x,y=p.y+i,z=p.z},{name = "default:papyrus"})
						end
					end
				end
				if p.y >= 0.5 then
					if d == c_rohan then
						if gondorcity then
							rohan_city_place(p,centre,minpcomp)
						elseif wheatrohanfield then--built_in_lua_random(1,100) == 1 then
							p.y = p.y + 1
							minetest.set_node(p,{name = "default:wheatplant"})
						elseif barleyrohanfield then--built_in_lua_random(1,100) == 1 then
							p.y = p.y + 1
							minetest.set_node(p,{name = "default:barleyplant"})
						elseif built_in_lua_random(1,12000) == 1--[[ and ]]--[[not get_node_in_cube(p,5,"default:mirktree")]]  and fastapproxisflatenoughforcircle(p,6,2) then
							minetest.after(0.1,function(p)
								place_schematic_central(--[["mirkcutter.mts"]]--[["smallmirkcutter.mts"]]"rohanpub.mts",12,vector.subtract(p,{x=0,y=9,z=0}),nil,"FORCE")
							end,p)
						elseif built_in_lua_random(1,10000) == 1 then
							place_schematic_central("tree.mts",5,p)
						elseif built_in_lua_random(1,10000) == 1 then
							place_schematic_central("rohangruft.mts",4,vector.subtract(p,{x=0,y=1,z=0}))
						elseif built_in_lua_random(1,10) == 1 then
							p.y = p.y + 1
							minetest.set_node(p,{name = "default:drygrassgrass"})
						end
					elseif d == c_shire then
						if gondorcity then
							shire_city_place(p,centre,minpcomp)
						elseif pipeweedshirefield then
							p.y = p.y + 1
							minetest.set_node(p,{name = hobbitcrop})
						elseif built_in_lua_random(1,10000) == 1--[[ and ]]--[[not get_node_in_cube(p,5,"default:mirktree")]]  and fastapproxisflatenoughforcircle(p,5,2) then
							minetest.after(0.1,function(p)
								place_schematic_central(--[["mirkcutter.mts"]]--[["smallmirkcutter.mts"]]--[["hobbithole.mts"]]"hobbithole2.mts",11,vector.subtract(p,{x=0,y=9,z=0}),nil,"FORCE")
							end,p)
						elseif built_in_lua_random(1,100) == 1 then
							place_schematic_central("tree.mts",5,p)
						end
					elseif d == c_gondor then
						if gondorcity then
							gondor_city_place(p,centre,minpcomp)
						elseif built_in_lua_random(1,10000) == 1 then
							place_schematic_central("whitetree2.mts",4,p)
						elseif built_in_lua_random(1,10000) == 1--[[ and ]]--[[not get_node_in_cube(p,5,"default:mirktree")]]  and fastapproxisflatenoughforcircle(p,5,2) then
							minetest.after(0.1,function(p)
								place_schematic_central(--[["mirkcutter.mts"]]--[["smallmirkcutter.mts"]]"firetower.mts",6,vector.subtract(p,{x=0,y=4,z=0}),nil,"FORCE")
							end,p)
						elseif built_in_lua_random(1,20000) == 1--[[ and ]]--[[not get_node_in_cube(p,5,"default:mirktree")]]  and fastapproxisflatenoughforcircle(p,5,2) then
							minetest.after(0.1,function(p)
								place_schematic_central(--[["mirkcutter.mts"]]--[["smallmirkcutter.mts"]]"gondorfort.mts",10,vector.subtract(p,{x=0,y=9,z=0}),nil,"FORCE")
							end,p)
						elseif built_in_lua_random(1,6000) == 1--[[(3000!) and ]]--[[not get_node_in_cube(p,5,"default:mirktree")]]  and fastapproxisflatenoughforcircle(p,6,2) then
							minetest.after(0.1,function(p)
								place_schematic_central(--[["mirkcutter.mts"]]--[["smallmirkcutter.mts"]]"gondorpub.mts",12,vector.subtract(p,{x=0,y=9,z=0}),nil,"FORCE")
							end,p)
						elseif built_in_lua_random(1,1000) == 1 then
							place_schematic_central("lebethron2.mts",4,p)
						elseif built_in_lua_random(1,100) == 1 then
							place_schematic_central("tree.mts",5,p)
						elseif built_in_lua_random(1,100)== 1 then
							p.y = p.y + 1
							minetest.set_node(p,{name = "default:mallosflower"})
						elseif built_in_lua_random(1,100)== 1 then
							p.y = p.y + 1
							minetest.set_node(p,{name = "default:alfirinflower"})
						elseif built_in_lua_random(1,100)== 1 then
							p.y = p.y + 1
							minetest.set_node(p,{name = "default:athelasflower"})
						elseif built_in_lua_random(1,50)== 1 then
							p.y = p.y + 1
							minetest.set_node(p,{name = flowers_flowerpower_names_list[built_in_lua_random(1,6)]})
						elseif built_in_lua_random(1,10) == 1 then
							p.y = p.y + 1
							minetest.set_node(p,{name = "default:grassgrass"})
						end
					elseif d == c_dunland then
						if cottonrohanfield then--built_in_lua_random(1,100) == 1 then
							p.y = p.y + 1
							minetest.set_node(p,{name = "default:cottonplant"})
						elseif built_in_lua_random(1,200) == 1 then
							place_schematic_central("tree.mts",5,p)
						elseif built_in_lua_random(1,100)== 1 then
							p.y = p.y + 1
							minetest.set_node(p,{name = flowers_flowerpower_names_list[built_in_lua_random(1,6)]})
						elseif built_in_lua_random(1,10) == 1 then
							p.y = p.y + 1
							minetest.set_node(p,{name = "default:dunlandgrassgrass"})
						end
					elseif d == c_trollshaws then
						if built_in_lua_random(1,800) == 1 then
							place_schematic_central("fangornaspen.mts",4,p)
						elseif built_in_lua_random(1,200) == 1 then
							place_schematic_central("tree.mts",5,p)
						elseif built_in_lua_random(1,150) == 1 then
							p.y = p.y+1
							place_schematic_central("ironhillpine.mts",5,p)
						elseif built_in_lua_random(1,10) == 1 then
							p.y = p.y + 1
							minetest.set_node(p,{name = "default:trollshawsshrubgrass"})
						end
					elseif d == c_dunland then
						if cottonrohanfield then--built_in_lua_random(1,100) == 1 then
							p.y = p.y + 1
							minetest.set_node(p,{name = "default:cottonplant"})
						elseif built_in_lua_random(1,200) == 1 then
							place_schematic_central("tree.mts",5,p)
						elseif built_in_lua_random(1,100)== 1 then
							p.y = p.y + 1
							minetest.set_node(p,{name = flowers_flowerpower_names_list[built_in_lua_random(1,6)]})
						elseif built_in_lua_random(1,10) == 1 then
							p.y = p.y + 1
							minetest.set_node(p,{name = "default:dunlandgrassgrass"})
						end
					elseif d == c_lorien then
						if built_in_lua_random(1,100) == 1 and fastapproxisflatenoughforcircle(p,3,2) then
							p.y = p.y + 1
							minetest.set_node(p,{name = "default:niphredilflower"})
						elseif built_in_lua_random(1,100) == 1 then
							p.y = p.y + 1
							minetest.set_node(p,{name = "default:elanorflower"})
						elseif built_in_lua_random(1,100) == 1 then
							p.y = p.y + 1
							minetest.set_node(p,{name = "default:lissuinflower"})
						elseif built_in_lua_random(1,100)== 1 then
							p.y = p.y + 1
							minetest.set_node(p,{name = flowers_flowerpower_names_list[built_in_lua_random(1,6)]})
						elseif built_in_lua_random(1,10) == 1 then
							p.y = p.y + 1
							minetest.set_node(p,{name = "default:loriengrassgrass"})
						end
					elseif d == c_valinor then
						if built_in_lua_random(1,1000) == 1 then
							p.y = p.y+1
							place_schematic_central("ironhillpine.mts",5,p)
						elseif built_in_lua_random(1,1000) == 1 then
							place_schematic_central("lebethron2.mts",4,p)
						elseif built_in_lua_random(1,1000) == 1 then
							place_schematic_central("culumalda.mts",4,p)
						elseif built_in_lua_random(1,1000) == 1 then
							p.y = p.y+1
							place_schematic_central("fir.mts",5,p)
						elseif built_in_lua_random(1,1000) == 1 then
							place_schematic_central("fangornaspen.mts",4,p)
						elseif built_in_lua_random(1,100) == 1 and fastapproxisflatenoughforcircle(p,3,2) then
							p.y = p.y + 1
							minetest.set_node(p,{name = "default:niphredilflower"})
						elseif built_in_lua_random(1,100) == 1 then
							p.y = p.y + 1
							minetest.set_node(p,{name = "default:elanorflower"})
						elseif built_in_lua_random(1,100) == 1 then
							p.y = p.y + 1
							minetest.set_node(p,{name = "default:lissuinflower"})
						elseif built_in_lua_random(1,100)== 1 then
							p.y = p.y + 1
							minetest.set_node(p,{name = flowers_flowerpower_names_list[built_in_lua_random(1,6)]})
						elseif built_in_lua_random(1,10) == 1 then
							p.y = p.y + 1
							minetest.set_node(p,{name = "default:valinorgrassgrass"})
						elseif built_in_lua_random(1,12000) == 1--[[ and ]]--[[not get_node_in_cube(p,5,"default:mirktree")]]  and fastapproxisflatenoughforcircle(p,10,2) then
							minetest.after(0.1,function(p)
								place_schematic_central(--[["mirkcutter.mts"]]--[["smallmirkcutter.mts"]]"valarhouse.mts",20,vector.subtract(p,{x=0,y=9,z=0}),nil,"FORCE")
							end,p)
						end
					elseif d == c_mirkwood then
						if built_in_lua_random(1,500) == 1 then
							p.y = p.y+1
							minetest.set_node(p,{name = "default:jungletrap_open"})
						elseif built_in_lua_random(1,10) == 1 then
						p.y = p.y + 1
						minetest.set_node(p,{name = "default:junglegrassgrass"})
						end
					elseif d == c_angmar then
						if  built_in_lua_random(1,100) == 1 then
							p.y = p.y+1
							place_schematic_central("snowypine.mts",5,p)
						elseif built_in_lua_random(1,10000) == 1 and fastapproxisflatenoughforcircle(p,10,2) and not fastapproxisflatenoughforcircle(vector.add(p,{x=0,y=6,z=0}),10,2)then		minetest.after(3,function(p)
							place_schematic_central("angmarfort.mts",20,vector.subtract(p,{x=0,y=6,z=0}),nil,"FORCE")end,p)
						end
					elseif d == c_ironhills then
						if built_in_lua_random(1,100) == 1 then
							p.y = p.y+1
							place_schematic_central("ironhillpine.mts",5,p)
						elseif built_in_lua_random(1,100) == 1 then
							p.y = p.y + 1
							minetest.set_node(p,{name = "default:seregonflower"})
						elseif built_in_lua_random(1,100)== 1 then
							p.y = p.y + 1
							minetest.set_node(p,{name = flowers_flowerpower_names_list[built_in_lua_random(1,6)]})
						elseif built_in_lua_random(1,10) == 1 then
							p.y = p.y + 1
							minetest.set_node(p,{name = "default:ironhillsgrassgrass"})
						end
					elseif d == c_bluemountains then
						if built_in_lua_random(1,100) == 1 then
							p.y = p.y+1
							place_schematic_central("fir.mts",5,p)
						elseif built_in_lua_random(1,10) == 1 then
							p.y = p.y + 1
							minetest.set_node(p,{name = "default:bluemountainsgrassgrass"})
						end
					elseif d == c_ironhillstone then
						if built_in_lua_random(1,27000) == 1 then
							add_dwarfern_mine(p,100,10,5,50,1)
						end
					elseif d == c_brownlands then
						if built_in_lua_random(1,2000) == 1 and fastapproxisflatenoughforcircle(p,15,1)then
							place_schematic_central("mudpool.mts",30,vector.subtract(p,{x=0,y=1,z=0}))
						elseif built_in_lua_random(1,10000) == 1 then
							place_schematic_central("rock1.mts",3,p)
						elseif built_in_lua_random(1,4000) == 1 then
							place_schematic_central("scorchedtree.mts",3,p)
						elseif built_in_lua_random(1,10) == 1 then
							p.y = p.y + 1
							minetest.set_node(p,{name = "default:brownshrubgrass"})
						end
					elseif d == c_ithilien then
						if gondorcity then
							ithilien_city_place(p,centre,minpcomp)
						elseif built_in_lua_random(1,10000) == 1 then
							place_schematic_central("whitetree2.mts",4,p)
						elseif built_in_lua_random(1,6000) == 1--[[(3000!) and ]]--[[not get_node_in_cube(p,5,"default:mirktree")]]  and fastapproxisflatenoughforcircle(p,6,2) then
							minetest.after(0.1,function(p)
								place_schematic_central(--[["mirkcutter.mts"]]--[["smallmirkcutter.mts"]]"ithilienpub.mts",12,vector.subtract(p,{x=0,y=9,z=0}),nil,"FORCE")
							end,p)
						elseif built_in_lua_random(1,1000) == 1 then
							place_schematic_central("lebethron.mts",4,p)
						elseif built_in_lua_random(1,200) == 1 then
							place_schematic_central("culumalda.mts",4,p)
						elseif built_in_lua_random(1,100) == 1 then
							place_schematic_central("tree.mts",5,p)
						elseif built_in_lua_random(1,100)== 1 then
							p.y = p.y + 1
							minetest.set_node(p,{name = "default:mallosflower"})
						elseif built_in_lua_random(1,100)== 1 then
							p.y = p.y + 1
							minetest.set_node(p,{name = "default:alfirinflower"})
						elseif built_in_lua_random(1,100)== 1 then
							p.y = p.y + 1
							minetest.set_node(p,{name = "default:athelasflower"})
						elseif built_in_lua_random(1,100)== 1 then
							p.y = p.y + 1
							minetest.set_node(p,{name = flowers_flowerpower_names_list[built_in_lua_random(1,6)]})
						elseif built_in_lua_random(1,10) == 1 then
							p.y = p.y + 1
							minetest.set_node(p,{name = "default:ithiliengrassgrass"})
						end
					elseif d == c_fangorn then
						if built_in_lua_random(1,150) == 1 then
							place_schematic_central("fangornaspen.mts",4,p)
						elseif built_in_lua_random(1,150) == 1 then
							place_schematic_central("fangorntree.mts",4,vector.add(p,{x=0,y=1,z=0}))
						elseif built_in_lua_random(1,75) == 1 then
							place_schematic_central("mediumjtreewithvines.mts",8,vector.add(p,{x=0,y=1,z=0}))
						elseif built_in_lua_random(1,100)== 1 then
							p.y = p.y + 1
							minetest.set_node(p,{name = flowers_flowerpower_names_list[built_in_lua_random(1,6)]})
						elseif built_in_lua_random(1,500) == 1 then
							p.y = p.y+1
							minetest.set_node(p,{name = "default:jungletrap_open"})
						elseif built_in_lua_random(1,10) == 1 then
							p.y = p.y + 1
							minetest.set_node(p,{name = "default:fangorngrassgrass"})
						end
					elseif d == c_mordor then
						if built_in_lua_random(1,10000) == 1 and fastapproxisflatenoughforcircle(p,15,2)then
							place_schematic_central("giantlavalake1raw.mts",30,vector.subtract(p,{x=0,y=1,z=0}))
						elseif built_in_lua_random(1,10000) == 1 and fastapproxisflatenoughforcircle(p,15,2)then
							place_schematic_central("giantlavalake2raw.mts",30,vector.subtract(p,{x=0,y=1,z=0}))
						elseif built_in_lua_random(1,10000) == 1 and fastapproxisflatenoughforcircle(p,10,2) and not fastapproxisflatenoughforcircle(vector.add(p,{x=0,y=6,z=0}),10,2)then		minetest.after(3,function(p)
							place_schematic_central("mordortower2.mts",20,vector.subtract(p,{x=0,y=6,z=0}),nil,"FORCE")end,p)
						elseif built_in_lua_random(1,1000) == 1 and fastapproxisflatenoughforcircle(p,15,2)then
							place_schematic_central("lavapool1.mts",10,vector.subtract(p,{x=0,y=1,z=0}))
						elseif built_in_lua_random(1,1000) == 1 and fastapproxisflatenoughforcircle(p,15,2)then
							place_schematic_central("lavapool2.mts",10,vector.subtract(p,{x=0,y=1,z=0}))
						elseif built_in_lua_random(1,100) == 1 then
							place_schematic_central("smalllavapool1.mts",3,vector.subtract(p,{x=0,y=1,z=0}))
						elseif built_in_lua_random(1,100) == 1 then
							place_schematic_central("smalllavapool2.mts",3,vector.subtract(p,{x=0,y=1,z=0}))
						end
					end
				end
			end
		else
--			if p.y < -256 and d == c_stone then
--				spawn_epic_weapon(p,0.00001)
			if d~= c_stone then
			if (d == c_mordor) or (d == c_mordor2) then
				p.y = p.y-1
				local node = minetest.get_node(p).name
				if (math.random(1,60) ~= 1) and (node ~= "default:mordordust") and (node ~= "default:mordordust") then
					p.y = p.y+1
					minetest.set_node(p,{name = "air"})
				elseif (node ~= "default:mordordust") and (node ~= "default:mordordust_mapgen") then
					p.y = p.y+1
					minetest.set_node(p,{name = "default:cavetrap_open"})
				end
			elseif (d == c_air) and (data[a:index(p.x,p.y-1,p.z)] ~= c_air) and (math.random(1,100) == 1) then
				minetest.set_node(p,{name = "default:cavetrap_open"})
				
			elseif d == c_sand then
				p.y  = p.y +1
				if (p.y < -30) or (minetest.get_node(p).name == "air")then
					--p.y = p.y -1
					if math.random(1,100) ==1 then
						minetest.set_node(p,{name = "default:cavetrap_open"})
					end
				--else
					--p.y = p.y -1
					
				end
				p.y =p.y -1
			elseif d == c_ironhillstone then
				if p.y > -256 and built_in_lua_random(1,500000) == 1 then
					add_dwarfern_mine(p,200,10,5,25,0)--1)
				elseif p.y <= -256 then
					if built_in_lua_random(1,500000) == 1 then
						add_dwarfern_mine(p,500,10,5,25,0)--1)
					--elseif built_in_lua_random(1,500000) == 1 then
					--	db({"MORIA!!!!!!!!!!!!!!!!!!!!!"})
					--	p = vector.subtract(p,{x=90,y=35,z=90})
					--	add_moria_mine(p,--[[50 10]]10,10,5,0.1)--1)
					end
				end
			--elseif d == c_mapgen_air_substitute then
			--	minetest.remove_node(p)
				--p.y = p.y-1
				--minetest.set_node(p,{name = minetest.get_node(p).name})
			elseif d == c_bluemountainstone then
				if p.y > -256 and built_in_lua_random(1,500000) == 1 then
					add_dwarfern_mine(p,200,10,5,25,0)--1)
				elseif p.y <= -256 then
					if built_in_lua_random(1,500000) == 1 then
						add_dwarfern_mine(p,500,10,5,25,0)--1)
					--elseif built_in_lua_random(1,500000) == 1 then
					--	db({"MORIA!!!!!!!!!!!!!!!!!!!!!"})
					--	p = vector.subtract(p,{x=90,y=35,z=90})
					--	add_moria_mine(p,--[[50 10]]10,10,5,0.1)--1)
					end
				end
			--elseif d == c_mapgen_air_substitute then
			--	minetest.remove_node(p)
				--p.y = p.y-1
				--minetest.set_node(p,{name = minetest.get_node(p).name})
			end
			end
		end
	end
	end
--[[end,p1,p2)]]end)
register_sapling_growth_abm("tree",{"default:dunlanddirt","default:rohandirt","default:gondordirt","default:ithiliendirt","default:shiredirt"},"tree",-2,-2)
register_sapling_growth_abm("tree",{"default:fangorndirt"},"fangorntree",-2,-2)
register_sapling_growth_abm("pine",{"default:ironhillsdirt"},"ironhillpine",-2,-2)
register_sapling_growth_abm("fir",{"default:bluemountainsdirt"},"fir",-2,-2)
register_sapling_growth_abm("pine",{"default:angmarsnow"},"snowypine",-2,-2)
register_sapling_growth_abm("jungletree",{"default:fangorndirt"},"mediumjtreewithvines",-3,-4)
register_sapling_growth_abm("aspen",{"default:fangorndirt"},"fangornaspen",-2,-2)
register_sapling_growth_abm("mallorn",{"default:loriendirt"},"mallorn2",-12,-12)
register_sapling_growth_abm("mirk",{"default:mirkwooddirt"},"mirk3",-5,-5)
register_sapling_growth_abm("whitetree",{"default:ithiliendirt","default:gondordirt"},"whitetree2",-2,-2)
register_sapling_growth_abm("culumalda",{"default:ithiliendirt"},"culumalda",-2,-2)
register_sapling_growth_abm("lebethron",{"default:ithiliendirt","default:gondordirt"},"lebethron",-2,-2)
minetest.register_node("default:airlight", {
	drawtype = "airlike",
	tiles = {},
	light_source = 14,
	groups = {not_in_creative_inventory = 1},
	drop = '',
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	pointable = false,
	on_blast = function() end,
})
minetest.register_node("default:vines", {
	description = "vines",
	drawtype = "plantlike",
	tiles = {"vine.png"},
	inventory_image = "vine.png",
	wield_image = "vine.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	climbable = true,
	is_ground_content = false,
	selection_box = {type = "fixed",fixed = {-0.15, -0.5, -0.15, 0.15, 0.5, 0.15}},
	groups = {choppy = 2, oddly_breakable_by_hand = 3, flammable = 3},
	sounds = default.node_sound_wood_defaults(),
})
minetest.register_abm({
        label = "default lorien lightbeetles spawn",
	nodenames = {"default:loriendirt"},
	interval = 60,
	chance = 5,
	catch_up = true,
	action = function(pos)
		pos.y = pos.y+built_in_lua_random(2,20)
		if minetest.get_node(pos).name == "air" then
minetest.set_node(pos,{name = "default:airlight"})
local i = built_in_lua_random(1,10)-6
if i <= 0 then
	i =1
end
minetest.add_particlespawner({
	amount = 30,
	time = 60,
	minpos = pos,
	maxpos = pos,
	minvel = {x=((built_in_lua_random(1,2)-1.5)*1), y=0, z=((built_in_lua_random(1,2)-1.5)*1)},
	maxvel = {x=((built_in_lua_random(1,2)-1.5)*1), y=0, z=((built_in_lua_random(1,2)-1.5)*1)},
	minacc = {x=0, y=0, z=0},
	maxacc = {x=0, y=0, z=0},
	minexptime = 1,
	maxexptime = 1,
	minsize = 1,
	maxsize = 1,
	collisiondetection = false,
	vertical = false,
	texture = "lightbeetle" .. built_in_lua_tostring(i) .. ".png",
})
end
end
})
minetest.register_abm({
        label = "default lorien lightbeetles delete",
	nodenames = {"default:airlight"},
	interval = 60,
	catch_up = false,
	chance = 1,
	action = function(pos)
if math.random(1,5) > 3 then
	minetest.set_node(pos,{name = "air"})
else
	local i = built_in_lua_random(1,10)-6
	if i <= 0 then
		i =1
	end
	minetest.add_particlespawner({
	amount = 30,
	time = 60,
	minpos = pos,
	maxpos = pos,
	minvel = {x=((built_in_lua_random(1,2)-1.5)*1), y=0, z=((built_in_lua_random(1,2)-1.5)*1)},
	maxvel = {x=((built_in_lua_random(1,2)-1.5)*1), y=0, z=((built_in_lua_random(1,2)-1.5)*1)},
	minacc = {x=0, y=0, z=0},
	maxacc = {x=0, y=0, z=0},
	minexptime = 1,
	maxexptime = 1,
	minsize = 1,
	maxsize = 1,
	collisiondetection = false,
	vertical = false,
	texture = "lightbeetle" .. built_in_lua_tostring(i) .. ".png",
	})
end
--[[minetest.add_particle({
	pos = pos,
	velocity = {x=((built_in_lua_random(1,2)-1.5)*1), y=0, z=((built_in_lua_random(1,2)-1.5)*1)},
	acceleration = {x=0, y=0, z=0},
	expirationtime = 60,
	size = 1,
	glow = 10,
light_source = 10,
	collisiondetection = true,
	vertical = false,
	texture = "lightbeetle1.png"
})]]
end
})
function add_schematics(nodename,chanche,schemname,sidelen)
minetest.register_on_generated(function(p1,p2)--[[minetest.after(1,function(p1,p2)]]
	local vm = VoxelManip()
	local minp, maxp = vm:read_from_map(p1, p2)
	local a = VoxelArea:new({MinEdge = minp, MaxEdge = maxp})
	local data = vm:get_data()
	local c_air = minetest.get_content_id(nodename)
	for i,d in built_in_lua_pairs(data) do
		if built_in_lua_random(1,chanche) == 1 and d == c_air then
			place_schematic_central(schemname,built_in_lua_floor(sidelen/2),a:position(i))
		end
	end
--[[end,p1,p2)]]end)
end
local default_epic_weapon_num = 0
function register_epic_weapon(wname,damage,reload,number,range,tex,dec)
default_epic_weapon_num = default_epic_weapon_num+1
minetest.register_tool("default:epic_" .. wname, {
	description = dec or wname,
	range = range,
	wield_scale = {x=2,y=2,z=0.5},
	inventory_image = "epic_" .. (tex or wname) .. ".png",
	tool_capabilities = {
		full_punch_interval = 0.7/reload,
		max_drop_level=1,
		groupcaps={
			snappy={times={[1]=1.90/damage, [2]=0.90/damage, [3]=0.30/damage}, uses=0, maxlevel=built_in_lua_floor(3*damage)},
		},
		damage_groups = {fleshy=built_in_lua_floor(8*damage)},
	}
})
table.insert(default_register_epic_weapons,{name = ItemStack("default:epic_" .. wname),number = number or 1})
end

register_epic_weapon("aeglos",7,1.2,1,7)
register_epic_weapon("anduril",12,3.6)
register_epic_weapon("anglachel",8,1.6)
register_epic_weapon("anguriel",8,1.6,1,nil,"anglachel")
register_epic_weapon("angrist",3,3)
register_epic_weapon("aranruth",4.2,1.8)
register_epic_weapon("damborleg",6,1.2)
register_epic_weapon("guthwine",4,2)
register_epic_weapon("orccrist",3,2.4,1)
register_epic_weapon("orccrist_glamdring_sibling",3,2.4,10,nil,"orccrist")
register_epic_weapon("glamdring",3,2.4,1,nil,"orccrist")
register_epic_weapon("stich",2.4,3,1)
register_epic_weapon("stich_sibling",2.4,3,10,nil,"stich")
register_epic_weapon("orccrist_alert",3,2.4,1,nil,"orccrist_blue_lit_alert","orccrist")
register_epic_weapon("orccrist_glamdring_sibling_alert",3,2.4,10,nil,"orccrist_blue_lit_alert","orccrist_glamdring_sibling")
register_epic_weapon("glamdring_alert",3,2.4,1,nil,"orccrist_blue_lit_alert","glamdring")
register_epic_weapon("stich_alert",2.4,3,1,nil,"stich_blue_lit_alert","stich")
register_epic_weapon("stich_sibling_alert",2.4,3,10,nil,"stich_blue_lit_alert","stich_sibling")
function spawn_epic_weapon(pos,chanche)
	pos.y = pos.y + 1
	if built_in_lua_random(10*(chanche or 1)) == 1 and pos.y < -10 then
		local epic_index = built_in_lua_random(1,default_epic_weapon_num)
		local epic_selected = default_register_epic_weapons[epic_index]
		if epic_selected.number > 0 and built_in_lua_random(1,10/epic_selected.number) == 1 then
			minetest.add_item(pos,epic_selected.name)
			default_register_epic_weapons[epic_index].number = epic_selected.number - 1
		end
	end
	pos.y = pos.y-1
end
--add_schematics("default:loriendirt",10,"mallorntree.mts",30)
local mg_params = minetest.get_mapgen_params()
function default.register_ores()

	-- Clay

	--minetest.register_ore({ 
	--	ore_type        = "blob",
	--	ore             = "default:clay",
	--	wherein         = {"default:sand"},
	--	clust_scarcity  = 16 * 16 * 16,
	--	clust_size      = 5,
	--	y_min           = -15,
	--	y_max           = 0,
	--	noise_threshold = 0.0,
	--	noise_params    = {
	--		offset = 0.5,
	--		scale = 0.2,
	--		spread = {x = 5, y = 5, z = 5},
	--		seed = -316,
	--		octaves = 1,
	--		persist = 0.0
	--	},
	--})

	-- Sand

	--minetest.register_ore({ 
	--	ore_type        = "blob",
	--	ore             = "default:sand",
	--	wherein        = {"default:stone","default:ironhillstone", "default:sandstone",
	--		"default:desert_stone"},
	--	clust_scarcity  = 16 * 16 * 16,
	--	clust_size      = 5,
	--	y_min           = -31,
	--	y_max           = 4,
	--	noise_threshold = 0.0,
	--	noise_params    = {
	--		offset = 0.5,
	--		scale = 0.2,
	--		spread = {x = 5, y = 5, z = 5},
	--		seed = 2316,
	--		octaves = 1,
	--		persist = 0.0
	--	},
	--})

	-- Dirt

	minetest.register_ore({
		ore_type        = "blob",
		ore             = "default:dirt",
		wherein        = {"default:stone","default:bluemountainstone","default:ironhillstone"},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 5,
		y_min           = -31,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.2,
			spread = {x = 5, y = 5, z = 5},
			seed = 17676,
			octaves = 1,
			persist = 0.0
		},
	})

	-- Gravel

	minetest.register_ore({
		ore_type        = "blob",
		ore             = "default:gravel",
		wherein        = {"default:stone","default:ironhillstone","default:bluemountainstone"},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 5,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.2,
			spread = {x = 5, y = 5, z = 5},
			seed = 766,
			octaves = 1,
			persist = 0.0
		},
	})

	-- Coal

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_coal",
		wherein        = {"default:stone","default:ironhillstone","default:bluemountainstone"},
		clust_scarcity = 8 * 8 * 8,
		clust_num_ores = 8,
		clust_size     = 3,
		y_min          = -31000,
		y_max          = 64,
	})
	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_coal",
		wherein        = {"default:stone","default:ironhillstone","default:bluemountainstone"},
		clust_scarcity = 24 * 24 * 24,
		clust_num_ores = 27,
		clust_size     = 6,
		y_min          = -31000,
		y_max          = 0,
	})

	-- Iron

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_iron",
		wherein        = {"default:stone","default:bluemountainstone"},
		clust_scarcity = 12 * 12 * 12,
		clust_num_ores = 3,
		clust_size     = 2,
		y_min          = -15,
		y_max          = 2,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_iron",
		wherein        = {"default:stone","default:bluemountainstone"},
		clust_scarcity = 9 * 9 * 9,
		clust_num_ores = 5,
		clust_size     = 3,
		y_min          = -63,
		y_max          = -16,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_iron",
		wherein        = {"default:stone","default:bluemountainstone"},
		clust_scarcity = 7 * 7 * 7,
		clust_num_ores = 5,
		clust_size     = 3,
		y_min          = -31000,
		y_max          = -64,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_iron",
		wherein        = {"default:stone","default:bluemountainstone"},
		clust_scarcity = 24 * 24 * 24,
		clust_num_ores = 27,
		clust_size     = 6,
		y_min          = -31000,
		y_max          = -64,
	})
	--Mese
	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_mithril",
		wherein        = {"default:stone","default:bluemountainstone"},
		clust_scarcity = 14 * 14 * 14,
		clust_num_ores = 5,
		clust_size     = 3,
		y_min          = -31000,
		y_max          = -256,
	})
	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_mithril",
		wherein        = "default:ironhillstone",
		clust_scarcity = 14 * 14 * 14,
		clust_num_ores = 3,
		clust_size     = 3,
		y_min          = -31000,
		y_max          = -256,
	})

	-- Gold

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_gold",
		wherein        = {"default:stone","default:bluemountainstone"},
		clust_scarcity = 15 * 15 * 15,
		clust_num_ores = 3,
		clust_size     = 2,
		y_min          = -255,
		y_max          = -64,
	})
	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_gold",
		wherein        = "default:ironhillstone",
		clust_scarcity = 16 * 16 * 16,
		clust_num_ores = 3,
		clust_size     = 2,
		y_min          = -31000,
		y_max          = -64,
	})
	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_gold",
		wherein        = {"default:stone","default:bluemountainstone"},
		clust_scarcity = 13 * 13 * 13,
		clust_num_ores = 5,
		clust_size     = 3,
		y_min          = -31000,
		y_max          = -256,
	})
	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_gold",
		wherein        = {"default:stone","default:bluemountainstone"},
		clust_scarcity = 13 * 13 * 13,
		clust_num_ores = 3,
		clust_size     = 3,
		y_min          = -31000,
		y_max          = -256,
	})

	-- Diamond

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_diamond",
		wherein        = {"default:stone","default:bluemountainstone"},
		clust_scarcity = 17 * 17 * 17,
		clust_num_ores = 4,
		clust_size     = 3,
		y_min          = -255,
		y_max          = -128,
	})
	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_diamond",
		wherein        = "default:ironhillstone",
		clust_scarcity = 18 * 18 * 18,
		clust_num_ores = 4,
		clust_size     = 3,
		y_min          = -31000,
		y_max          = -128,
	})
	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_diamond",
		wherein        = {"default:stone","default:bluemountainstone"},
		clust_scarcity = 15 * 15 * 15,
		clust_num_ores = 4,
		clust_size     = 3,
		y_min          = -31000,
		y_max          = -256,
	})
	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_diamond",
		wherein        = {"default:stone","default:bluemountainstone"},
		clust_scarcity = 15 * 15 * 15,
		clust_num_ores = 2,
		clust_size     = 3,
		y_min          = -31000,
		y_max          = -256,
	})

	-- Copper

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_copper",
		wherein        = {"default:stone","default:ironhillstone","default:bluemountainstone"},
		clust_scarcity = 12 * 12 * 12,
		clust_num_ores = 4,
		clust_size     = 3,
		y_min          = -63,
		y_max          = -16,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_copper",
		wherein        = {"default:stone","default:ironhillstone","default:bluemountainstone"},
		clust_scarcity = 9 * 9 * 9,
		clust_num_ores = 5,
		clust_size     = 3,
		y_min          = -31000,
		y_max          = -64,
	})
	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_iron",
		wherein        = "default:ironhillstone",
		clust_scarcity = 30,
		clust_num_ores = 27,
		clust_size     = 6,
		y_min          = -31000,
		y_max          = 31000,
	})
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "default:ice",
		wherein        = {"golems:bedrock"},
		clust_scarcity  = 4000,
		clust_size      = 10,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.2,
			spread = {x = 5, y = 5, z = 5},
			seed = 766,
			octaves = 1,
			persist = 0.0
		},
	})
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "default:bloodore",
		wherein        = {"golems:bedrock"},
		clust_scarcity  = 4000,
		clust_size      = 10,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.2,
			spread = {x = 5, y = 5, z = 5},
			seed = 766,
			octaves = 1,
			persist = 0.0
		},
	})
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "default:sandstone",
		wherein        = {"default:desert_stone"},
		clust_scarcity  = 2000,
		clust_size      = 10,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.2,
			spread = {x = 5, y = 5, z = 5},
			seed = 766,
			octaves = 1,
			persist = 0.0
		},
	})
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "default:snowblock",
		wherein        = {"golems:bedrock"},
		clust_scarcity  = 4000,
		clust_size      = 10,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.2,
			spread = {x = 5, y = 5, z = 5},
			seed = 766,
			octaves = 1,
			persist = 0.0
		},
	})
	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "golems:rock",
		wherein        = "golems:bedrock",
		clust_scarcity = 40,
		clust_num_ores = 27,
		clust_size     = 6,
		y_min          = -31000,
		y_max          = 39,
	})
end
if mg_params.mgname == "v6" then
	default.register_ores()
	default.register_biomes()
elseif mg_params.mgname ~= "singlenode" then
	default.register_biomes()
	default.register_ores()
end
minetest.after(10,function()db({"GC"})collectgarbage()end)
