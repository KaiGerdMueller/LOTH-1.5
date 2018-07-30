-- mods/default/nodes.lua


--[[ Node name convention:

Although many node names are in combined-word form, the required form for new
node names is words separated by underscores. If both forms are used in written
language (for example pinewood and pine wood) the underscore form should be used.

--]]


--[[ Index:

Stone
-----
(1. Material 2. Cobble variant 3. Brick variant 4. Modified forms)

default:stone
default:cobble
default:stonebrick
default:mossycobble

default:desert_stone
default:desert_cobble
default:desert_stonebrick

default:sandstone
default:sandstonebrick

default:obsidian
default:obsidianbrick

Soft / Non-Stone
----------------
(1. Material 2. Modified forms)

default:dirt
default:dirt_with_grass
default:dirt_with_grass_footsteps
default:dirt_with_dry_grass
default:dirt_with_snow

default:sand
default:desert_sand

default:gravel

default:clay

default:snow
default:snowblock

default:ice

Trees
-----
(1. Trunk 2. Fabricated trunk 3. Leaves 4. Sapling 5. Fruits)

default:tree
default:wood
default:leaves
default:sapling
default:apple

default:jungletree
default:junglewood
default:jungleleaves
default:junglesapling

default:pine_tree
default:pine_wood
default:pine_needles
default:pine_sapling

default:acacia_tree
default:acacia_wood
default:acacia_leaves
default:acacia_sapling

default:aspen_tree
default:aspen_wood
default:aspen_leaves
default:aspen_sapling

Ores
----
(1. In stone 2. Blocks)

default:stone_with_coal
default:coalblock

default:stone_with_iron
default:steelblock

default:stone_with_copper
default:copperblock
default:bronzeblock

default:stone_with_gold
default:goldblock

default:stone_with_mese
default:mese

default:stone_with_diamond
default:diamondblock

Plantlife (non-cubic)
---------------------

default:cactus
default:papyrus
default:dry_shrub
default:junglegrass

default:grass_1
default:grass_2
default:grass_3
default:grass_4
default:grass_5

default:dry_grass_1
default:dry_grass_2
default:dry_grass_3
default:dry_grass_4
default:dry_grass_5

Liquids
-------
(1. Source 2. Flowing)

default:water_source
default:water_flowing

default:river_water_source
default:river_water_flowing

default:lava_source
default:lava_flowing

Tools / "Advanced" crafting / Non-"natural"
-------------------------------------------

default:torch

default:chest
default:chest_locked

default:bookshelf

default:sign_wall_wood
default:sign_wall_steel

default:ladder_wood
default:ladder_steel

default:fence_wood
default:fence_acacia_wood
default:fence_junglewood
default:fence_pine_wood
default:fence_aspen_wood

default:glass
default:obsidian_glass

default:rail

default:brick

default:meselamp

Misc
----

default:cloud
default:nyancat
default:nyancat_rainbow

--]]

--
-- Stone
--
give_initial_stuff = {
}
function register_falling_trap(name)
	local d = minetest.registered_nodes[name]
	local def = {}
	for i,e in pairs(d) do
		def[i] = e
	end
	local groups = def.groups or {}
	groups.falling_trap = 1
	def.groups = groups
	def.name = name .. "_falling_trap"
	minetest.register_node(name .. "_falling_trap", def)
minetest.register_craft({
	output = name .. "_falling_trap 3",
	recipe = {
		{name,name,name},
		{'group:stick','group:stick','group:stick'},
	}
})
end
minetest.register_craftitem("default:map",{
		description = "World Map",
		inventory_image = "map_texture.png",
		groups = {book = 1},
		wield_scale = {x=1,y=1,z=0.01},
		on_use = function(_,user)
			minetest.show_formspec(user:get_player_name(), "healthbar_map",default_map_formspec..player_point_addition(user,0.5))
			minetest.after(0,function()
			for i=1,6 do
				--minetest.chat_send_all(" ")
			end
			end)
		end,
		stack_max=1
})
default_standard_mob_drop_list = {}
minetest.register_node("default:stone", {
	description = "Stone",
	tiles = {"default_stone.png"},
	groups = {cracky = 3, stone = 1},
	drop = 'default:cobble',
	legacy_mineral = true,
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:cobble", {
	description = "Cobblestone",
	tiles = {"default_cobble.png"},
	is_ground_content = false,
	groups = {cracky = 3, stone = 2},
	sounds = default.node_sound_stone_defaults(),
})
register_falling_trap("default:cobble")
minetest.register_node("default:stonebrick", {
	description = "Stone Brick",
	tiles = {"default_stone_brick.png"},
	is_ground_content = false,
	groups = {cracky = 2, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})
register_falling_trap("default:stonebrick")
minetest.register_node("default:mossycobble", {
	description = "Mossy Cobblestone",
	tiles = {"default_mossycobble.png"},
	is_ground_content = false,
	groups = {cracky = 3, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})
register_falling_trap("default:mossycobble")

minetest.register_node("default:desert_stone", {
	description = "Desert Stone",
	tiles = {"default_desert_stone.png"},
	groups = {cracky = 3, stone = 1},
	drop = 'default:desert_cobble',
	legacy_mineral = true,
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("default:netherrack", {
	description = "underworld stone",
	tiles = {"nethrack.png"},
	groups = {cracky = 1,level = 3},
	light_source = 5,
	sounds = default.node_sound_stone_defaults,
	footstep = {name = "default_stone_footstep", gain = 0.25},
})
minetest.register_node("default:underworldrack", {
	description = "underworld stone",
	tiles = {"underworld_rack.png"},
	groups = {cracky = 1,level = 4},
	light_source = 6,
	sounds = default.node_sound_stone_defaults,
	footstep = {name = "default_stone_footstep", gain = 0.25},
})
minetest.register_node("default:bloodore", {
	description = "netherrack with evil life within",
	tiles = {"nethrack_bloodore.png"},
	drop = {max_items = 1,items = {
			{
					items = {"default:balrogegg"},
					rarity = 3
			},
			{
					items = {"default:dragonegg"},
					rarity = 3
			},
			{
					items = {"default:netherrack"},
---					rarity = 1
			}
			}
},
	groups = {cracky = 1,level = 3},
	light_source = 8,
	sounds = default.node_sound_stone_defaults,
	footstep = {name = "default_stone_footstep", gain = 0.25},
})
register_falling_trap("default:netherrack")
minetest.register_node("default:teleportnetherrack", {
	description = "underworld stone",
	tiles = {"nethrack.png^default_mithril_metal_overlay.png"},
	groups = {cracky = 1,level = 3},
	light_source = 15,
	sounds = default.node_sound_stone_defaults,
	footstep = {name = "default_stone_footstep", gain = 0.25},
	on_punch = function(_,notneccesary, player)
	local pos =player:getpos()
	if pos.y < -2800 then
player:setpos({x=pos.x,y=0,z=pos.z})
		minetest.after(3,bones_spawn_over,player)end end
})
minetest.register_node("default:desert_cobble", {
	description = "Desert Cobblestone",
	tiles = {"default_desert_cobble.png"},
	is_ground_content = false,
	groups = {cracky = 3, stone = 2},
	sounds = default.node_sound_stone_defaults(),
})
register_falling_trap("default:desert_cobble")
minetest.register_node("default:desert_stonebrick", {
	description = "Desert Stone Brick",
	tiles = {"default_desert_stone_brick.png"},
	is_ground_content = false,
	groups = {cracky = 2, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})
register_falling_trap("default:desert_stonebrick")

minetest.register_node("default:sandstone", {
	description = "Sandstone",
	tiles = {"default_sandstone.png"},
	groups = {crumbly = 1, cracky = 3},
	sounds = default.node_sound_stone_defaults(),
})
register_falling_trap("default:sandstone")
minetest.register_node("default:sandstonebrick", {
	description = "Sandstone Brick",
	tiles = {"default_sandstone_brick.png"},
	is_ground_content = false,
	groups = {cracky = 2},
	sounds = default.node_sound_stone_defaults(),
})
register_falling_trap("default:sandstonebrick")

minetest.register_node("default:obsidian", {
	description = "Obsidian",
	tiles = {"default_obsidian.png"},
	sounds = default.node_sound_stone_defaults(),
	groups = {cracky = 1, level = 2},
})
register_falling_trap("default:obsidian")
minetest.register_abm({
	nodenames = {"group:falling_trap"},
	interval = 1,
	chance = 1,
	action = function(pos)
		pos.y = pos.y+1
		local r = false
		for _,e in pairs(minetest.get_objects_inside_radius(pos,1)) do
			if e:is_player() then
				r = true
			end
		end
		if r then
		pos.y = pos.y - 1
		minetest.set_node(pos,{name = "air"})
		end
	end
})
local function register_trap_abm(old_one,armor,new_one,reflexspeed,time)
minetest.register_abm({
	nodenames = {old_one},
	interval = reflexspeed,
	chance = 1,
	action = function(pos)
		local fed = false
		pos.y = pos.y + 0.6
		for _,e in pairs(minetest.get_objects_inside_radius(pos,1.8)) do
			if e:getpos().y > pos.y-1.2 then
				local ag =e:get_armor_groups()
				local hp = e:get_hp()
				local item = (e:get_luaentity() or {}).name == "__builtin:item"
				if item or ((not ag.immortal) and ((ag.fleshy or 100) > armor) and (hp < 201)) then
					if e:is_player() then
					e:set_hp(0)
					else
					e:remove()
					end
					fed = true
				end
			end
		end
		pos.y  = pos.y -0.6
		if fed then
			minetest.set_node(pos,{name = new_one})
		end
	end
})
minetest.register_abm({
	nodenames = {new_one},
	interval = time,
	chance = 1,
	action = function(pos)
		minetest.set_node(pos,{name = old_one})
	end
})
end
minetest.register_node("default:cavetrap_closed", {
	description = "cavetrap",
	drawtype = "mesh",
	mesh = "cavetrap_closed.obj",
	visual_size = 10,
	paramtype = "light",
	light_source = 1,
	tiles = {"nethrack.png"},
		node_box = {
		type = "fixed",
		fixed = {-0.8, -0.5, -0.8,0.8, 1.4, 0.8}
	},
		selection_box = {
		type = "fixed",
		fixed = {-0.7, -0.1, -0.7,0.7, 1.4, 0.7}
	},
	drop = {
		max_items = 1,
		items = {
			{
				-- player will get sapling with 1/20 chance
				items = {'default:cavetrap_open'},
				rarity = 3,
			}
		}
	},
	sounds = default.node_sound_stone_defaults(),
	groups = {cracky = 1, level = 2},
})
minetest.register_node("default:tombstone", {
	drawtype = "mesh",
	mesh = "cross.obj",
	visual_size = {x=0.5,y=0.5,z=0.5},
	paramtype = "light",
	tiles = {"default_stone.png"},
		node_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.1,0.3, 0.5, 0.1}
	},
		selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.1,0.3, 0.5, 0.1}
	},
	description = "tombstone",
	tiles = {"default_stone_brick.png"},
	is_ground_content = false,
	groups = {cracky = 2, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("default:jungletrap_closed", {
	description = "jungletrap",
	drawtype = "mesh",
	mesh = "cavetrap_closed.obj",
	visual_size = 10,
	paramtype = "light",
	tiles = {"default_grass.png"},
		node_box = {
		type = "fixed",
		fixed = {-0.8, -0.5, -0.8,0.8, 1.4, 0.8}
	},
		selection_box = {
		type = "fixed",
		fixed = {-0.7, -0.1, -0.7,0.7, 1.4, 0.7}
	},
	drop = {
		max_items = 1,
		items = {
			{
				-- player will get sapling with 1/20 chance
				items = {'default:jungletrap_open'},
				rarity = 3,
			}
		}
	},
	sounds = default.node_sound_stone_defaults(),
	groups = {choppy = 1, level = 2},
})
minetest.register_node("default:deserttrap_closed", {
	description = "deserttrap",
	drawtype = "mesh",
	mesh = "cavetrap_closed.obj",
	visual_size = 10,
	paramtype = "light",
	tiles = {"default_desert_sand.png"},
		node_box = {
		type = "fixed",
		fixed = {-0.8, -0.5, -0.8,0.8, 1.4, 0.8}
	},
		selection_box = {
		type = "fixed",
		fixed = {-0.7, -0.1, -0.7,0.7, 1.4, 0.7}
	},
	drop = {
		max_items = 1,
		items = {
			{
				-- player will get sapling with 1/20 chance
				items = {'default:deserttrap_open'},
				rarity = 3,
			}
		}
	},
	sounds = default.node_sound_stone_defaults(),
	groups = {cracky = 1, level = 2},
})
register_trap_abm("default:cavetrap_open",11,"default:cavetrap_closed",1,24)
register_trap_abm("default:jungletrap_open",21,"default:jungletrap_closed",1,12)
register_trap_abm("default:deserttrap_open",16,"default:deserttrap_closed",1,18)
minetest.register_node("default:dragonegg", {
	description = "dragon egg",
	drawtype = "mesh",
	--	node_box = {
	--	type = "fixed",
	--	fixed = {-1.5, -0.5, -1.5,1.5, 0, 1.5}
	--},
		selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3,0.3, 0.5, 0.3}
	},
	mesh = "dragonegg.obj",
	visual_size = 1,
	paramtype = "light",
	light_source = 5,
	tiles = {"nethrack.png"},
	sounds = default.node_sound_stone_defaults(),
	groups = {cracky = 1, level = 2},
	after_place_node = function(pos, placer)
		minetest.get_meta(pos):set_string("owner_name",placer:get_player_name())
	end
})
minetest.register_node("default:balrogegg", {
	description = "balrog egg",
	drawtype = "mesh",
	--	node_box = {
	--	type = "fixed",
	--	fixed = {-1.5, -0.5, -1.5,1.5, 0, 1.5}
	--},
		selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3,0.3, 0.5, 0.3}
	},
	mesh = "dragonegg.obj",
	visual_size = 1,
	paramtype = "light",
	light_source = 5,
	tiles = {"glowingmordorstone.png"},
	sounds = default.node_sound_stone_defaults(),
	groups = {cracky = 1, level = 2},
	after_place_node = function(pos, placer)
		minetest.get_meta(pos):set_string("owner_name",placer:get_player_name())
	end
})
minetest.register_abm({
	nodenames = {"default:dragonegg"},
	neighbors = {"group:igniter"},
	interval = 2,
	chance = 3,
	action = function(pos)
		local r = math.random(1,20)
		pos.y = pos.y + r
		local n = minetest.get_node(pos).name
		if n == "air" or n == "ignore" then
			local e = minetest.add_entity(pos,"dragons:bat")
			pos.y = pos.y-r
			e:get_luaentity().owner = minetest.get_meta(pos):get_string("owner_name")
			minetest.remove_node(pos)
		end
	end
})
minetest.register_abm({
	nodenames = {"default:balrogegg"},
	neighbors = {"group:igniter"},
	interval = 2,
	chance = 3,
	action = function(pos)
		pos.y = pos.y + 5
		local n = minetest.get_node(pos).name
		if n == "air" or n == "ignore" then
			local e = minetest.add_entity(pos,"balrog:balrog")
			pos.y = pos.y-5
			e:get_luaentity().owner = minetest.get_meta(pos):get_string("owner_name")
			minetest.remove_node(pos)
		end
	end
})
minetest.register_node("default:cavetrap_open", {
	description = "cavetrap",
	drawtype = "mesh",
	--	node_box = {
	--	type = "fixed",
	--	fixed = {-1.5, -0.5, -1.5,1.5, 0, 1.5}
	--},
		selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3,0.3, 0.5, 0.3}
	},
	mesh = "cavetrap_open.obj",
	visual_size = 10,
	drop = {
		max_items = 1,
		items = {
			{
				-- player will get sapling with 1/20 chance
				items = {'default:cavetrap_open'},
				rarity = 3,
			}
		}
	},
	paramtype = "light",
	light_source = 1,
	tiles = {"nethrack.png"},
	sounds = default.node_sound_stone_defaults(),
	groups = {cracky = 1, level = 2},
})
minetest.register_node("default:obsidianbrick", {
	description = "Obsidian Brick",
	tiles = {"default_obsidian_brick.png"},
	is_ground_content = false,
	sounds = default.node_sound_stone_defaults(),
	groups = {cracky = 1, level = 2},
})
minetest.register_node("default:jungletrap_open", {
	description = "jungletrap",
	drawtype = "mesh",
	--	node_box = {
	--	type = "fixed",
	--	fixed = {-1.5, -0.5, -1.5,1.5, 0, 1.5}
	--},
		selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3,0.3, 0.5, 0.3}
	},
	drop = {
		max_items = 1,
		items = {
			{
				-- player will get sapling with 1/20 chance
				items = {'default:jungletrap_open'},
				rarity = 3,
			}
		}
	},
	mesh = "cavetrap_open.obj",
	visual_size = 10,
	paramtype = "light",
	tiles = {"default_grass.png"},
	sounds = default.node_sound_stone_defaults(),
	groups = {choppy = 1, level = 2},
})
minetest.register_node("default:deserttrap_open", {
	description = "deserttrap",
	drawtype = "mesh",
	--	node_box = {
	--	type = "fixed",
	--	fixed = {-1.5, -0.5, -1.5,1.5, 0, 1.5}
	--},
		selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3,0.3, 0.5, 0.3}
	},
	drop = {
		max_items = 1,
		items = {
			{
				-- player will get sapling with 1/20 chance
				items = {'default:deserttrap_open'},
				rarity = 3,
			}
		}
	},
	mesh = "cavetrap_open.obj",
	visual_size = 10,
	paramtype = "light",
	tiles = {"default_desert_sand.png"},
	sounds = default.node_sound_stone_defaults(),
	groups = {cracky = 1, level = 2},
})
minetest.register_node("default:obsidianbrick", {
	description = "Obsidian Brick",
	tiles = {"default_obsidian_brick.png"},
	is_ground_content = false,
	sounds = default.node_sound_stone_defaults(),
	groups = {cracky = 1, level = 2},
})
--
-- Soft / Non-Stone
--

minetest.register_node("default:dirt", {
	description = "Dirt",
	tiles = {"default_dirt.png"},
	groups = {crumbly = 3, soil = 1, falling_node = 1},
	sounds = default.node_sound_dirt_defaults(),
})
register_falling_trap("default:obsidianbrick")
minetest.register_node("default:dirt_with_grass", {
	description = "Dirt with Grass",
	tiles = {"default_grass.png", "default_dirt.png",
		{name = "default_dirt.png^default_grass_side.png",
			tileable_vertical = false}},
	groups = {crumbly = 3, soil = 1, falling_node = 1},
	drop = 'default:dirt',
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_grass_footstep", gain = 0.25},
	}),
})

minetest.register_node("default:dirt_with_grass_footsteps", {
	description = "Dirt with Grass and Footsteps",
	tiles = {"default_grass.png^default_footprint.png", "default_dirt.png",
		{name = "default_dirt.png^default_grass_side.png",
			tileable_vertical = false}},
	groups = {crumbly = 3, soil = 1, not_in_creative_inventory = 1, falling_node = 1},
	drop = 'default:dirt',
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_grass_footstep", gain = 0.25},
	}),
})

minetest.register_node("default:dirt_with_dry_grass", {
	description = "Dirt with Dry Grass",
	tiles = {"default_dry_grass.png",
		"default_dirt.png",
		{name = "default_dirt.png^default_dry_grass_side.png",
			tileable_vertical = false}},
	groups = {crumbly = 3, soil = 1, falling_node = 1},
	drop = 'default:dirt',
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_grass_footstep", gain = 0.4},
	}),
})

minetest.register_node("default:dirt_with_snow", {
	description = "Dirt with Snow",
	tiles = {"default_snow.png", "default_dirt.png",
		{name = "default_dirt.png^default_snow_side.png",
			tileable_vertical = false}},
	groups = {crumbly = 3, soil = 1, falling_node = 1},
	drop = 'default:dirt',
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_snow_footstep", gain = 0.15},
	}),
})

minetest.register_node("default:sand", {
	description = "Sand",
	tiles = {"default_sand.png"},
	groups = {crumbly = 3, falling_node = 1, sand = 1},
	sounds = default.node_sound_sand_defaults(),
})

minetest.register_node("default:desert_sand", {
	description = "Desert Sand",
	tiles = {"default_desert_sand.png"},
	groups = {crumbly = 3, falling_node = 1, sand = 1},
	sounds = default.node_sound_sand_defaults(),
})


minetest.register_node("default:gravel", {
	description = "Gravel",
	tiles = {"default_gravel.png"},
	groups = {crumbly = 2, falling_node = 1},
	sounds = default.node_sound_gravel_defaults(),
	drop = {
		max_items = 1,
		items = {
			{items = {'default:flint'}, rarity = 16},
			{items = {'default:gravel'}}
		}
	}
})

minetest.register_node("default:clay", {
	description = "Clay",
	tiles = {"default_clay.png"},
	groups = {crumbly = 3},
	drop = 'default:clay_lump 4',
	sounds = default.node_sound_dirt_defaults(),
})


minetest.register_node("default:snow", {
	description = "Snow",
	tiles = {"default_snow.png"},
	inventory_image = "default_snowball.png",
	wield_image = "default_snowball.png",
	paramtype = "light",
	buildable_to = true,
	floodable = true,
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.25, 0.5},
		},
	},
	groups = {crumbly = 3, falling_node = 1, puts_out_fire = 1},
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_snow_footstep", gain = 0.15},
		dug = {name = "default_snow_footstep", gain = 0.2},
		dig = {name = "default_snow_footstep", gain = 0.2}
	}),

	on_construct = function(pos)
		pos.y = pos.y - 1
		local nd = minetest.registered_nodes[minetest.get_node(pos).name]
		if nd.groups and nd.groups.dirt then
			minetest.set_node(pos, {name = "default:dirt_with_snow"})
		end
	end,
})
minetest.register_node("default:mountainsnow", {
	description = "Snow",
	tiles = {"default_snow.png"},
	inventory_image = "default_snowball.png",
	wield_image = "default_snowball.png",
	drop = "default:snow",
	paramtype = "light",
	buildable_to = true,
	floodable = true,
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.25, 0.5},
		},
	},
	groups = {crumbly = 3, falling_node = 1, puts_out_fire = 1},
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_snow_footstep", gain = 0.15},
		dug = {name = "default_snow_footstep", gain = 0.2},
		dig = {name = "default_snow_footstep", gain = 0.2}
	}),

	on_construct = function(pos)
		pos.y = pos.y - 1
		local nd = minetest.registered_nodes[minetest.get_node(pos).name]
		if nd.groups and nd.groups.dirt then
			minetest.set_node(pos, {name = "default:dirt_with_snow"})
		end
	end,
})
minetest.register_node("default:snowblock", {
	description = "Snow Block",
	tiles = {"default_snow.png"},
	groups = {crumbly = 3, puts_out_fire = 1, falling_node = 1},
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_snow_footstep", gain = 0.15},
		dug = {name = "default_snow_footstep", gain = 0.2},
		dig = {name = "default_snow_footstep", gain = 0.2}
	}),
})

minetest.register_node("default:ice", {
	description = "Ice",
	alpha = 160,
	tiles = {"default_ice.png"},
	is_ground_content = false,
	drawtype = "glasslike",
	--drawtype = "liquid",
	use_texture_alpha = true,
	paramtype = "light",
	sunlight_propagates = true,
	groups = {cracky = 3},--, puts_out_fire = 1},
	sounds = default.node_sound_glass_defaults(),
})

--
-- Trees
--

minetest.register_node("default:tree", {
	description = "Tree",
	tiles = {"default_tree_top.png", "default_tree_top.png", "default_tree.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = default.node_sound_wood_defaults(),

	on_place = minetest.rotate_node
})

minetest.register_node("default:wood", {
	description = "Wooden Planks",
	tiles = {"default_wood.png"},
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("default:treesapling", {
	description = "Sapling",
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles = {"default_sapling.png"},
	inventory_image = "default_sapling.png",
	wield_image = "default_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
	},
	groups = {snappy = 2, dig_immediate = 3, flammable = 2,
		attached_node = 1, sapling = 1},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_node("default:leaves", {
	description = "Leaves",
	drawtype = "allfaces_optional",
	waving = 1,
	visual_scale = 1.3,
	tiles = {"default_leaves.png"},
	special_tiles = {"default_leaves_simple.png"},
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 3, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{
				-- player will get sapling with 1/20 chance
				items = {'default:treesapling'},
				rarity = 20,
			},
			{
				-- player will get leaves only if he get no saplings,
				-- this is because max_items is 1
				items = {'default:leaves'},
			}
		}
	},
	sounds = default.node_sound_leaves_defaults(),

	after_place_node = default.after_place_leaves,
})

minetest.register_node("default:apple", {
	description = "Apple",
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles = {"default_apple.png"},
	inventory_image = "default_apple.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	is_ground_content = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.2, -0.5, -0.2, 0.2, 0, 0.2}
	},
	groups = {fleshy = 3, dig_immediate = 3, flammable = 2,
		leafdecay = 3, leafdecay_drop = 1},
	on_use = minetest.item_eat(2),
	sounds = default.node_sound_leaves_defaults(),

	after_place_node = function(pos, placer, itemstack)
		if placer:is_player() then
			minetest.set_node(pos, {name = "default:apple", param2 = 1})
		end
	end,
})


minetest.register_node("default:jungletree", {
	description = "Jungle Tree",
	tiles = {"default_jungletree_top.png", "default_jungletree_top.png",
		"default_jungletree.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = default.node_sound_wood_defaults(),

	on_place = minetest.rotate_node
})
minetest.register_node("default:wizzard_air_light", {
	drawtype = "airlike",
	tiles = {},
	light_source = 15,
	groups = {not_in_creative_inventory = 1},
	drop = '',
	walkable = false,
	groups = {},
	buildable_to = true,
	pointable = false,
	on_blast = function() end,
	on_timer = function(pos)minetest.remove_node(pos)end
})
minetest.register_entity("default:greymagic",{
			hp_min = 20,
			hp_max = 20,
			visual_size = {x = 3, y = 3,z = 3},
			visual = "mesh",--"wielditem",
			mesh = "crystal.obj",
	--textures = {"lotharrows:boltmodel"},
			textures = {"fogtex.png"},
			collisionbox = {0, 0, 0,0, 0, 0},
			physical = false,
	on_activate = function(sf,sd)
		sf.time = 6
		local sd = sd or false
		if sd and (string.sub(sd,1,7) == "player/") then
			sd = string.sub(sd,8)
			sd = minetest.parse_json(sd) or {}
			sf.time = sd.t
		end
		sf.object:set_armor_groups({immortal =1})
		sf.timer = 0
		sf.checkplayerattached = true
	end,
	get_staticdata = function(self)
		local ret = ""
		if self.att then
			ret = "player/" .. minetest.write_json({t = self.time - self.timer})
		end
		return ret
	end,
	on_step = function( sf, dt )
	local pos = sf.object:getpos()
minetest.add_particlespawner({
	amount = 3,
	time = 3,
	minpos = pos,
	maxpos = pos,
	minvel = {x=-0.5, y=-0.5, z=-0.5},
	maxvel = {x=0.5, y=0.5, z=0.5},
	minacc = {x=0, y=0, z=0},
	maxacc = {x=0, y=0, z=0},
	minexptime = 1,
	maxexptime = 1,
	minsize = 1,
	maxsize = 1,
	collisiondetection = true,
	vertical = false,
	texture = "greymagic.png",
})
			if minetest.get_node(pos).name == "air" then
			minetest.set_node(pos,{name="default:wizzard_air_light"})
			minetest.get_node_timer(pos):start(3)
			end
		sf.timer = sf.timer + dt
		if (sf.timer >= (sf.time or 1)) then
			sf.object:remove()
		end
	end
})
local function blueball_exists(pos,radius)
	for _,entity in ipairs(minetest.get_objects_inside_radius(pos,radius)) do
		local luaent = entity:get_luaentity()
		if luaent and luaent.magic_blueball then
			return true
		end
	end
end
local function spawn_over(player)
	local pos = player:getpos()
	local oldy = pos.y
	local walkable = true
	local enough = 0
	while walkable and (enough < 129) do
		enough = enough+1
		node0 = minetest.get_node(pos)
		pos.y = pos.y+1
		node1 = minetest.get_node(pos)
		pos.y = pos.y-1
		if (minetest.registered_nodes[node1.name].walkable) or (minetest.registered_nodes[node0.name].walkable) then
			pos.y = pos.y+1
		else
			walkable = false
		end
	end
	if walkable then
		pos.y = pos.y - 128
	end
	player:setpos(pos)
	--minetest.after(1,player.setpos(pos))
end
minetest.register_tool("default:magic_light_wand", {
	description = "Magic Wand",
	inventory_image = "magiclightwand.png",
	wield_scale = {x=2,y=2,z=0.25},
	range = 0,
	on_place = function(itemstack, user, pointed_thing)
			local pos = user:getpos()
			pos.y = pos.y+1
			if minetest.get_node(pos).name == "air" then
			minetest.set_node(pos,{name="default:wizzard_air_light"})
			minetest.get_node_timer(pos):start(60)
			end
	end,
	on_use = function(itemstack, user, pointed_thing)
			local pos = user:getpos()
			pos.y = pos.y+1
			local ball = false
			local user_player_name = user:get_player_name()
			if (user:get_hp() <= 5) or (not hudwelshplayers[user_player_name]) or (hudwelshlaw[user_player_name] and (hudwelshlaw[user_player_name] > 0)) then
			ball = minetest.add_entity(pos,"default:greymagic")
			ball:setvelocity(vector.multiply(user:get_look_dir(),8))
			elseif not blueball_exists(pos,12) then
			for _,obj in ipairs(minetest.get_objects_inside_radius(vector.add(user:getpos(),vector.multiply(user:get_look_dir(),5.1)),5)) do
			local obj_pos = obj:getpos()
			local obj_vel = obj:getvelocity()
			if obj_vel == nil then
				obj_vel = {x = 0,y = 0,z = 0}
			end
			local vel = vector.add(obj_vel,{x=math.random(-10,10),y=500,z=math.random(-10,10)})
			if obj:is_player() == true then
				obj:setpos(vector.add(obj:getpos(),{x=math.random(-10,10),y=20,z=math.random(-10,10)}))
				spawn_over(obj)
			else
				obj:setvelocity(vel)
			end
			end
			ball = minetest.add_entity(pos,"lotharrows:mageball")
			end
			if ball then
			if player_fine_group[user_player_name] and (player_fine_group[user_player_name] == 7) then
				user:set_hp(math.max(user:get_hp()-1,0))
			else
				user:set_hp(math.max(user:get_hp()-2,0))
			end
			local luaent = ball:get_luaentity()
			luaent.shooter = user
			luaent.owner = user:get_player_name()
			luaent.damage = ((orcishlaw[user_player_name] or 0)/(3000000*((player_deaths[user_player_name] or 0)+1))) + 10
			end
			if minetest.get_node(pos).name == "air" then
			minetest.set_node(pos,{name="default:wizzard_air_light"})
			minetest.get_node_timer(pos):start(60)
			end
	end
})
minetest.register_tool("default:magic_lightning_wand", {
	description = "Magic Wand",
	inventory_image = "magiclightningwand.png",
	wield_scale = {x=2,y=2,z=0.25},
	range = 0,
	on_place = function(itemstack, user, pointed_thing)
			local pos = user:getpos()
			pos.y = pos.y+1
			if minetest.get_node(pos).name == "air" then
			minetest.set_node(pos,{name="default:wizzard_air_light"})
			minetest.get_node_timer(pos):start(60)
			end
	end,
	on_use = function(itemstack, user, pointed_thing)
			local user_actual_hp = user:get_hp()
			local user_player_name = user:get_player_name()
			if user_actual_hp > 5 and ((user_actual_hp > 10) or (player_fine_group[user_player_name] and (player_fine_group[user_player_name] == 7))) then
			local pos = user:getpos()
			pos.y = pos.y+1
			local ball = false
			if --[[not ((user:get_hp() <= 5) or (not hudwelshplayers[user_player_name]) or (hudwelshlaw[user_player_name] and (hudwelshlaw[user_player_name] > 0)))]] true then
			for _,obj in ipairs(minetest.get_objects_inside_radius(vector.add(user:getpos(),vector.multiply(user:get_look_dir(),5.1)),5)) do
			local obj_pos = obj:getpos()
			local obj_vel = obj:getvelocity()
			if obj_vel == nil then
				obj_vel = {x = 0,y = 0,z = 0}
			end
			local vel = vector.add(obj_vel,{x=math.random(-10,10),y=500,z=math.random(-10,10)})
			if obj:is_player() == true then
				obj:setpos(vector.add(obj:getpos(),{x=math.random(-10,10),y=20,z=math.random(-10,10)}))
				spawn_over(obj)
			else
				obj:setvelocity(vel)
			end
			end
			ball = true
			magic_wand_lightning_ray(pos,user:get_look_dir(),3,100,user,100,math.ceil(user:get_hp()/4))
			end
			if ball then
			if player_fine_group[user_player_name] and (player_fine_group[user_player_name] == 7) then
				user:set_hp(math.max(user:get_hp()-5,0))
			else
				user:set_hp(math.max(user:get_hp()-10,0))
			end
			end
			end
			pos = user:getpos()
			if minetest.get_node(pos).name == "air" then
			minetest.set_node(pos,{name="default:wizzard_air_light"})
			minetest.get_node_timer(pos):start(60)
			end
	end
})
minetest.register_tool("default:magic_doomed_wand", {
	description = "Magic Wand",
	inventory_image = "magicdamnwand.png",
	wield_scale = {x=2,y=2,z=0.25},
	range = 0,
	on_place = function(itemstack, user, pointed_thing)
			local pos = user:getpos()
			pos.y = pos.y+1
			if minetest.get_node(pos).name == "air" then
			minetest.set_node(pos,{name="fire:basic_flame"})
			minetest.get_node_timer(pos):start(60)
			end
	end,
	on_use = function(itemstack, user, pointed_thing)
			local pos = user:getpos()
			pos.y = pos.y+1
			local ball = false
			local user_player_name = user:get_player_name()
			if (not orcishplayers[user_player_name]) or (orcishlaw[user_player_name] and (orcishlaw[user_player_name] > 0)) then
			ball = minetest.add_entity(pos,"default:greymagic")
			user:set_hp(math.max(user:get_hp()-2,0))
			healthbar_damn_values[user_player_name] = healthbar_damn_values[user_player_name]+10
			update_damn_data_file(user_player_name,healthbar_damn_values[user_player_name])
			ball:setvelocity(vector.multiply(user:get_look_dir(),8))
			elseif not blueball_exists(pos,12) then
			ball = minetest.add_entity(pos,"lotharrows:bad_mageball")
			end
			if ball then
				healthbar_damn_values[user_player_name] = healthbar_damn_values[user_player_name]+25
				update_damn_data_file(user_player_name,healthbar_damn_values[user_player_name])
			local luaent = ball:get_luaentity()
			luaent.shooter = user
			luaent.damage = ((orcishlaw[user_player_name] or 0)/(3000000*((player_deaths[user_player_name] or 0)+1))) + 10
			end
			if minetest.get_node(pos).name == "air" then
			minetest.set_node(pos,{name="fire:basic_flame"})
			minetest.get_node_timer(pos):start(60)
			end
	end
})
minetest.register_tool("default:netherkey", {
	description = "netherporter",
	inventory_image = "netherkey.png",
	range = 0,
	on_use = function(itemstack, user)
		bones_netherport(user)
	end
})
minetest.register_craft({
	output = "default:netherkey",
	recipe = {
		{"","","default:diamond"},
		{"","default:diamond",""},
		{"default:diamond","",""},
	}
})
minetest.register_tool("default:ulmokey", {
	description = "ulmoporter",
	inventory_image = "ulmokey1.png",
	range = 0,
	on_use = function(itemstack, user)
		bones_ulmoport(user)
	end
})
minetest.register_craft({
	output = "default:ulmokey",
	recipe = {
		{"default:diamondblock","default:magic_doomed_wand","default:diamondblock"},
		{"default:netherrack","default:netherkey","default:netherrack"},
		{"default:mithrilblock","default:magic_light_wand","default:mithrilblock"},
	}
})
minetest.register_node("default:junglewood", {
	description = "Junglewood Planks",
	tiles = {"default_junglewood.png"},
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("default:jungleleaves", {
	description = "Jungle Leaves",
	drawtype = "allfaces_optional",
	waving = 1,
	visual_scale = 1.3,
	tiles = {"default_jungleleaves.png"},
	special_tiles = {"default_jungleleaves_simple.png"},
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 3, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {'default:junglesapling'}, rarity = 20},
			{items = {'default:jungleleaves'}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),

	after_place_node = default.after_place_leaves,
})

minetest.register_node("default:junglesapling", {
	description = "Jungle Sapling",
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles = {"default_junglesapling.png"},
	inventory_image = "default_junglesapling.png",
	wield_image = "default_junglesapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
	},
	groups = {snappy = 2, dig_immediate = 3, flammable = 2,
		attached_node = 1, sapling = 1},
	sounds = default.node_sound_leaves_defaults(),
})


minetest.register_node("default:pine_tree", {
	description = "Pine Tree",
	tiles = {"default_pine_tree_top.png", "default_pine_tree_top.png",
		"default_pine_tree.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = default.node_sound_wood_defaults(),

	on_place = minetest.rotate_node
})

minetest.register_node("default:pine_wood", {
	description = "Pine Wood Planks",
	tiles = {"default_pine_wood.png"},
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("default:pine_needles",{
	description = "Pine Needles",
	drawtype = "allfaces_optional",
	visual_scale = 1.3,
	tiles = {"default_pine_needles.png"},
	waving = 1,
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 3, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:pinesapling"}, rarity = 20},
			{items = {"default:pine_needles"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),

	after_place_node = default.after_place_leaves,
})
--[[minetest.register_node("default:pinesapling", {
	description = "Pine Sapling",
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles = {"pine_sapling.png"},
	inventory_image = "pine_sapling.png",
	wield_image = "pine_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
	},
	groups = {snappy = 2, dig_immediate = 3, flammable = 2,
		attached_node = 1, sapling = 1},
	sounds = default.node_sound_leaves_defaults(),
})]]
minetest.register_node("default:pinesapling", {
	description = "Pine Sapling",
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles = {"pine_sapling.png"},
	inventory_image = "pine_sapling.png",
	wield_image = "pine_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
	},
	groups = {snappy = 2, dig_immediate = 3, flammable = 2,
		attached_node = 1, sapling = 1},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_node("default:acacia_tree", {
	description = "Acacia Tree",
	tiles = {"default_acacia_tree_top.png", "default_acacia_tree_top.png",
		"default_acacia_tree.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = default.node_sound_wood_defaults(),

	on_place = minetest.rotate_node
})

minetest.register_node("default:acacia_wood", {
	description = "Acacia Wood Planks",
	tiles = {"default_acacia_wood.png"},
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("default:acacia_leaves", {
	description = "Acacia Leaves",
	drawtype = "allfaces_optional",
	visual_scale = 1.3,
	tiles = {"default_acacia_leaves.png"},
	waving = 1,
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 3, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:acacia_sapling"}, rarity = 20},
			{items = {"default:acacia_leaves"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),

	after_place_node = default.after_place_leaves,
})

minetest.register_node("default:acacia_sapling", {
	description = "Acacia Tree Sapling",
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles = {"default_acacia_sapling.png"},
	inventory_image = "default_acacia_sapling.png",
	wield_image = "default_acacia_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
	},
	groups = {snappy = 2, dig_immediate = 3, flammable = 2,
		attached_node = 1, sapling = 1},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_node("default:aspen_tree", {
	description = "Aspen Tree",
	tiles = {"default_aspen_tree_top.png", "default_aspen_tree_top.png",
		"default_aspen_tree.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = default.node_sound_wood_defaults(),

	on_place = minetest.rotate_node
})

minetest.register_node("default:aspen_wood", {
	description = "Aspen Wood Planks",
	tiles = {"default_aspen_wood.png"},
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("default:aspen_leaves", {
	description = "Aspen Leaves",
	drawtype = "allfaces_optional",
	visual_scale = 1.3,
	tiles = {"default_aspen_leaves.png"},
	waving = 1,
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 3, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:aspensapling"}, rarity = 20},
			{items = {"default:aspen_leaves"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),

	after_place_node = default.after_place_leaves,
})

minetest.register_node("default:aspensapling", {
	description = "Aspen Tree Sapling",
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles = {"aspen_sapling.png"},
	inventory_image = "aspen_sapling.png",
	wield_image = "aspen_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
	},
	groups = {snappy = 2, dig_immediate = 3, flammable = 2,
		attached_node = 1, sapling = 1},
	sounds = default.node_sound_leaves_defaults(),
})
--
-- Ores
--

minetest.register_node("default:stone_with_coal", {
	description = "Coal Ore",
	tiles = {"default_stone.png^default_mineral_coal.png"},
	groups = {cracky = 3},
	drop = 'default:coal_lump',
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:coalblock", {
	description = "Coal Block",
	tiles = {"default_coal_block.png"},
	is_ground_content = false,
	groups = {cracky = 3},
	sounds = default.node_sound_stone_defaults(),
})


minetest.register_node("default:stone_with_iron", {
	description = "Iron Ore",
	tiles = {"default_stone.png^default_mineral_iron.png"},
	groups = {cracky = 2},
	drop = 'default:iron_lump',
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:steelblock", {
	description = "Steel Block",
	tiles = {"default_steel_block.png"},
	is_ground_content = false,
	groups = {cracky = 1, level = 2},
	sounds = default.node_sound_stone_defaults(),
})


minetest.register_node("default:stone_with_copper", {
	description = "Copper Ore",
	tiles = {"default_stone.png^default_mineral_copper.png"},
	groups = {cracky = 2},
	drop = 'default:copper_lump',
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:copperblock", {
	description = "Copper Block",
	tiles = {"default_copper_block.png"},
	is_ground_content = false,
	groups = {cracky = 1, level = 2},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:bronzeblock", {
	description = "Bronze Block",
	tiles = {"default_bronze_block.png"},
	is_ground_content = false,
	groups = {cracky = 1, level = 2},
	sounds = default.node_sound_stone_defaults(),
})




minetest.register_node("default:stone_with_gold", {
	description = "Gold Ore",
	tiles = {"default_stone.png^default_mineral_gold.png"},
	groups = {cracky = 2},
	drop = "default:gold_lump",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:goldblock", {
	description = "Gold Block",
	tiles = {"default_gold_block.png"},
	is_ground_content = false,
	groups = {cracky = 1},
	sounds = default.node_sound_stone_defaults(),
})


minetest.register_node("default:stone_with_diamond", {
	description = "Diamond Ore",
	tiles = {"default_stone.png^default_mineral_diamond.png"},
	groups = {cracky = 1},
	drop = "default:diamond",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:diamondblock", {
	description = "Diamond Block",
	tiles = {"default_diamond_block.png"},
	is_ground_content = false,
	groups = {cracky = 1, level = 3},
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("default:diamond_magic_wall", {
	description = "Diamond Wall",
	tiles = {"magic_wall.png"},
	is_ground_content = false,
	groups = {cracky = 1, level = 3},
	sounds = default.node_sound_stone_defaults(),
	on_blast = function(pos,hellish)
		if hellish == "dark" then
			minetest.remove_node(pos)
		end
	end,
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		if placer and placer:get_player_name() then
			protection_protect_with_except(pos,{placer:get_player_name()})
		end
	end
})
--
-- Plantlife (non-cubic)
--

minetest.register_node("default:cactus", {
	description = "Cactus",
	tiles = {"default_cactus_top.png", "default_cactus_top.png",
		"default_cactus_side.png"},
	paramtype2 = "facedir",
	groups = {snappy = 1, choppy = 3},
	sounds = default.node_sound_wood_defaults(),
	on_place = minetest.rotate_node,
})

minetest.register_node("default:papyrus", {
	description = "Papyrus",
	drawtype = "plantlike",
	tiles = {"default_papyrus.png"},
	inventory_image = "default_papyrus.png",
	wield_image = "default_papyrus.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.5, 0.3}
	},
	groups = {snappy = 3, flammable = 3},
	sounds = default.node_sound_leaves_defaults(),

	after_dig_node = function(pos, node, metadata, digger)
		default.dig_up(pos, node, digger)
	end,
})

minetest.register_node("default:dry_shrub", {
	description = "Dry Shrub",
	drawtype = "plantlike",
	waving = 1,
	visual_scale = 1.0,
	tiles = {"default_dry_shrub.png"},
	inventory_image = "default_dry_shrub.png",
	wield_image = "default_dry_shrub.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, flammable = 3, attached_node = 1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
	},
})
minetest.register_node("default:junglegrass", {
	description = "Jungle Grass",
	drawtype = "plantlike",
	waving = 1,
	visual_scale = 1.3,
	tiles = {"default_junglegrass.png"},
	inventory_image = "default_junglegrass.png",
	wield_image = "default_junglegrass.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, flora = 1,flammable = 3, attached_node = 1, grass = 1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
	},
})


minetest.register_node("default:grass_1", {
	description = "Grass",
	drawtype = "plantlike",
	waving = 1,
	tiles = {"default_grass_1.png"},
	-- Use texture of a taller grass stage in inventory
	inventory_image = "default_grass_3.png",
	wield_image = "default_grass_3.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, flora = 1, attached_node = 1,flammable = 3, grass = 1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
	},

	on_place = function(itemstack, placer, pointed_thing)
		-- place a random grass node
		local stack = ItemStack("default:grass_" .. math.random(1,5))
		local ret = minetest.item_place(stack, placer, pointed_thing)
		return ItemStack("default:grass_1 " ..
			itemstack:get_count() - (1 - ret:get_count()))
	end,
})

for i = 2, 5 do
	minetest.register_node("default:grass_" .. i, {
		description = "Grass",
		drawtype = "plantlike",
		waving = 1,
		tiles = {"default_grass_" .. i .. ".png"},
		inventory_image = "default_grass_" .. i .. ".png",
		wield_image = "default_grass_" .. i .. ".png",
		paramtype = "light",
		sunlight_propagates = true,
		walkable = false,
		buildable_to = true,
		drop = "default:grass_1",
		groups = {snappy = 3, flora = 1, attached_node = 1,
			not_in_creative_inventory = 1,flammable = 3, grass = 1},
		sounds = default.node_sound_leaves_defaults(),
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
		},
	})
end


minetest.register_node("default:dry_grass_1", {
	description = "Dry Grass",
	drawtype = "plantlike",
	waving = 1,
	tiles = {"default_dry_grass_1.png"},
	inventory_image = "default_dry_grass_3.png",
	wield_image = "default_dry_grass_3.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, flammable = 2, flora = 1,
		attached_node = 1, dry_grass = 1,flammable = 3},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
	},

	on_place = function(itemstack, placer, pointed_thing)
		-- place a random dry grass node
		local stack = ItemStack("default:dry_grass_" .. math.random(1, 5))
		local ret = minetest.item_place(stack, placer, pointed_thing)
		return ItemStack("default:dry_grass_1 " ..
			itemstack:get_count() - (1 - ret:get_count()))
	end,
})

for i = 2, 5 do
	minetest.register_node("default:dry_grass_" .. i, {
		description = "Dry Grass",
		drawtype = "plantlike",
		waving = 1,
		tiles = {"default_dry_grass_" .. i .. ".png"},
		inventory_image = "default_dry_grass_" .. i .. ".png",
		wield_image = "default_dry_grass_" .. i .. ".png",
		paramtype = "light",
		sunlight_propagates = true,
		walkable = false,
		buildable_to = true,
		groups = {snappy = 3, flammable = 2, flora = 1, attached_node = 1,
			not_in_creative_inventory=1, dry_grass = 1,flammable = 3},
		drop = "default:dry_grass_1",
		sounds = default.node_sound_leaves_defaults(),
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
		},
	})
end

--
-- Liquids
--

minetest.register_node("default:water_source", {
	description = "Water Source",
	drawtype = "liquid",
	tiles = {
		{
			name = "default_water_source_animated.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
	},
	special_tiles = {
		-- New-style water source material (mostly unused)
		{
			name = "default_water_source_animated.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
			backface_culling = false,
		},
	},
	alpha = 160,
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "source",
	liquid_alternative_flowing = "default:water_flowing",
	liquid_alternative_source = "default:water_source",
	liquid_viscosity = 1,
	post_effect_color = {a = 103, r = 30, g = 60, b = 90},
	groups = {water = 3, liquid = 3, puts_out_fire = 1},
})

minetest.register_node("default:water_flowing", {
	description = "Flowing Water",
	drawtype = "flowingliquid",
	tiles = {"default_water.png"},
	special_tiles = {
		{
			name = "default_water_flowing_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.8,
			},
		},
		{
			name = "default_water_flowing_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.8,
			},
		},
	},
	alpha = 160,
	paramtype = "light",
	paramtype2 = "flowingliquid",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "flowing",
	liquid_alternative_flowing = "default:water_flowing",
	liquid_alternative_source = "default:water_source",
	liquid_viscosity = 1,
	post_effect_color = {a = 103, r = 30, g = 60, b = 90},
	groups = {water = 3, liquid = 3, puts_out_fire = 1,
		not_in_creative_inventory = 1},
})


minetest.register_node("default:river_water_source", {
	description = "River Water Source",
	drawtype = "liquid",
	tiles = {
		{
			name = "default_river_water_source_animated.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
	},
	special_tiles = {
		{
			name = "default_river_water_source_animated.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
			backface_culling = false,
		},
	},
	alpha = 160,
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "source",
	liquid_alternative_flowing = "default:river_water_flowing",
	liquid_alternative_source = "default:river_water_source",
	liquid_viscosity = 1,
	liquid_renewable = false,
	liquid_range = 2,
	post_effect_color = {a = 103, r = 30, g = 76, b = 90},
	groups = {water = 3, liquid = 3, puts_out_fire = 1},
})

minetest.register_node("default:river_water_flowing", {
	description = "Flowing River Water",
	drawtype = "flowingliquid",
	tiles = {"default_river_water.png"},
	special_tiles = {
		{
			name = "default_river_water_flowing_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.8,
			},
		},
		{
			name = "default_river_water_flowing_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.8,
			},
		},
	},
	alpha = 160,
	paramtype = "light",
	paramtype2 = "flowingliquid",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "flowing",
	liquid_alternative_flowing = "default:river_water_flowing",
	liquid_alternative_source = "default:river_water_source",
	liquid_viscosity = 1,
	liquid_renewable = false,
	liquid_range = 2,
	post_effect_color = {a = 103, r = 30, g = 76, b = 90},
	groups = {water = 3, liquid = 3, puts_out_fire = 1,
		not_in_creative_inventory = 1},
})


minetest.register_node("default:lava_source", {
	description = "Lava Source",
	drawtype = "liquid",
	tiles = {
		{
			name = "default_lava_source_animated.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.0,
			},
		},
	},
	special_tiles = {
		-- New-style lava source material (mostly unused)
		{
			name = "default_lava_source_animated.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.0,
			},
			backface_culling = false,
		},
	},
	paramtype = "light",
	light_source = default.LIGHT_MAX - 1,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "source",
	liquid_alternative_flowing = "default:lava_flowing",
	liquid_alternative_source = "default:lava_source",
	liquid_viscosity = 7,
	liquid_renewable = false,
	damage_per_second = 4 * 2,
	post_effect_color = {a = 191, r = 255, g = 64, b = 0},
	groups = {lava = 3, liquid = 2, hot = 3, igniter = 1},
})

minetest.register_node("default:lava_flowing", {
	description = "Flowing Lava",
	drawtype = "flowingliquid",
	tiles = {"default_lava.png"},
	special_tiles = {
		{
			name = "default_lava_flowing_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.3,
			},
		},
		{
			name = "default_lava_flowing_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.3,
			},
		},
	},
	paramtype = "light",
	paramtype2 = "flowingliquid",
	light_source = default.LIGHT_MAX - 1,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "flowing",
	liquid_alternative_flowing = "default:lava_flowing",
	liquid_alternative_source = "default:lava_source",
	liquid_viscosity = 7,
	liquid_renewable = false,
	damage_per_second = 4 * 2,
	damage_per_second = 10 * 2,
	post_effect_color = {a = 191, r = 255, g = 64, b = 0},
	groups = {lava = 4, liquid = 2, hot = 4, igniter = 10,
		not_in_creative_inventory = 1},
})
minetest.register_node("default:nice_souls_source", {
	description = "Soul Source",
	drawtype = "liquid",
	tiles = {
		{
			name = "good_souls_animated.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.0,
			},
		},
	},
	special_tiles = {
		-- New-style lava source material (mostly unused)
		{
			name = "good_souls_animated.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.0,
			},
			backface_culling = false,
		},
	},
	paramtype = "light",
	light_source = default.LIGHT_MAX,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = false,
	is_ground_content = false,
	drop = "",
	drowning = 0,
	liquidtype = "source",
	liquid_alternative_flowing = "default:nice_souls_flowing",
	liquid_alternative_source = "default:nice_souls_source",
	liquid_viscosity = 2,
	liquid_renewable = false,
	damage_per_second = -2,
	post_effect_color = {a = 191, r = 0, g = 0, b = 255},
	groups = { liquid = 2},
})

minetest.register_node("default:nice_souls_flowing", {
	description = "Flowing Souls",
	drawtype = "flowingliquid",
	tiles = {"default_lava.png"},
	special_tiles = {
		{
			name = "good_souls_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.3,
			},
		},
		{
			name = "good_souls_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.3,
			},
		},
	},
	paramtype = "light",
	paramtype2 = "flowingliquid",
	light_source = default.LIGHT_MAX,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 0,
	liquidtype = "flowing",
	liquid_alternative_flowing = "default:nice_souls_flowing",
	liquid_alternative_source = "default:nice_souls_source",
	liquid_viscosity = 2,
	liquid_renewable = false,
	damage_per_second = -2,
	post_effect_color = {a = 191, r = 0, g = 0, b = 255},
	groups = { liquid = 2,not_in_creative_inventory = 1},
})
minetest.register_node("default:nice_souls_steam", {
	drawtype = "airlike",
	tiles = {},
	light_source = 15,
	groups = {not_in_creative_inventory = 1},
	drop = '',
	walkable = false,
	groups = {},
	buildable_to = false,
	pointable = false,
	climbable = true,
	on_blast = function() end,
	on_timer = function(pos)minetest.remove_node(pos)end
})
minetest.register_node("default:magma_source", {
	description = "Magma Source",
	drawtype = "liquid",
	tiles = {
		{
			name = "magmasource.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.0,
			},
		},
	},
	special_tiles = {
		-- New-style lava source material (mostly unused)
		{
			name = "magmasource.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.0,
			},
			backface_culling = false,
		},
	},
	on_blast = function() end,
	paramtype = "light",
	light_source = default.LIGHT_MAX,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "source",
	liquid_alternative_flowing = "default:magma_flowing",
	liquid_alternative_source = "default:magma_source",
	liquid_viscosity = 7,
	liquid_renewable = true,
	damage_per_second = 10 * 2,
	post_effect_color = {a = 191, r = 255, g = 255, b = 0},
	groups = {lava = 4, liquid = 2, hot = 4, igniter = 10},
})

minetest.register_node("default:magma_flowing", {
	description = "Flowing Magma",
	drawtype = "flowingliquid",
	tiles = {"magma.png"},
	special_tiles = {
		{
			name = "magmasource.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.0,
			},
		},
		{
			name = "magmasource.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.0,
			},
		},
	},
	paramtype = "light",
	paramtype2 = "flowingliquid",
	light_source = default.LIGHT_MAX,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "flowing",
	liquid_alternative_flowing = "default:magma_flowing",
	liquid_alternative_source = "default:magma_source",
	liquid_viscosity = 7,
	liquid_renewable = true,
	damage_per_second = 4 * 2,
	post_effect_color = {a = 191, r = 255, g = 255, b = 0},
	groups = {lava = 3, liquid = 2, hot = 3, igniter = 1,
		not_in_creative_inventory = 1},
})
--
-- Tools / "Advanced" crafting / Non-"natural"
--

minetest.register_node("default:torch", {
	description = "Torch",
	drawtype = "torchlike",
	tiles = {
		{
			name = "default_torch_on_floor_animated.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.0
			},
		},
		{
			name="default_torch_on_ceiling_animated.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.0
			},
		},
		{
			name="default_torch_animated.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.0
			},
		},
	},
	inventory_image = "default_torch_on_floor.png",
	wield_image = "default_torch_on_floor.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	is_ground_content = false,
	walkable = false,
	light_source = default.LIGHT_MAX - 1,
	selection_box = {
		type = "wallmounted",
		wall_top = {-0.1, 0.5 - 0.6, -0.1, 0.1, 0.5, 0.1},
		wall_bottom = {-0.1, -0.5, -0.1, 0.1, -0.5 + 0.6, 0.1},
		wall_side = {-0.5, -0.3, -0.1, -0.5 + 0.3, 0.3, 0.1},
	},
	groups = {choppy = 2, dig_immediate = 3, flammable = 1, attached_node = 1},
	legacy_wallmounted = true,
	sounds = default.node_sound_defaults(),
})
function register_torch(name,burning)
minetest.register_node("default:" .. name .. "_torch", {
	description = name .. " torch",
	drawtype = "torchlike",
	tiles = {
		{
			name = "torch_on_floor_background.png^".. name .. "_torch_on_floor_overlay.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.0
			},
		},
		{
			name="torch_on_ceiling_background.png^".. name .. "_torch_on_ceiling_overlay.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.0
			},
		},
		{
			name="torch_background.png^".. name .. "_torch_overlay.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.0
			},
		},
	},
	inventory_image = name .. "_torch.png",
	wield_image = name .. "_torch.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	is_ground_content = false,
	walkable = false,
	light_source = default.LIGHT_MAX - 1,
	selection_box = {
		type = "wallmounted",
		wall_top = {-0.1, 0.5 - 0.6, -0.1, 0.1, 0.5, 0.1},
		wall_bottom = {-0.1, -0.5, -0.1, 0.1, -0.5 + 0.6, 0.1},
		wall_side = {-0.5, -0.3, -0.1, -0.5 + 0.3, 0.3, 0.1},
	},
	groups = {choppy = 2, dig_immediate = 3, flammable = 1, attached_node = 1},
	legacy_wallmounted = true,
	sounds = default.node_sound_defaults(),
})
minetest.register_craft({
	output = "default:" .. name .. "_torch 4",
	recipe = {
		{burning},
		{'group:stick'},
	}
})
end
register_torch("elven","default:mallornwood")
local chest_formspec =
	"size[8,9]" ..
	default.gui_bg ..
	default.gui_bg_img ..
	default.gui_slots ..
	"list[current_name;main;0,0.3;8,4;]" ..
	"list[current_player;main;0,4.85;8,1;]" ..
	"list[current_player;main;0,6.08;8,3;8]" ..
	"listring[current_name;main]" ..
	"listring[current_player;main]" ..
	default.get_hotbar_bg(0,4.85)

local function get_locked_chest_formspec(pos)
	local spos = pos.x .. "," .. pos.y .. "," .. pos.z
	local formspec =
		"size[8,9]" ..
		default.gui_bg ..
		default.gui_bg_img ..
		default.gui_slots ..
		"list[nodemeta:" .. spos .. ";main;0,0.3;8,4;]" ..
		"list[current_player;main;0,4.85;8,1;]" ..
		"list[current_player;main;0,6.08;8,3;8]" ..
		"listring[nodemeta:" .. spos .. ";main]" ..
		"listring[current_player;main]" ..
		default.get_hotbar_bg(0,4.85)
 return formspec
end

local function has_locked_chest_privilege(meta, player)
	local name = ""
	if player then
--		if minetest.check_player_privs(player, "protection_bypass") then
--			return true
--		end
		name = player:get_player_name()
	end
	if name ~= meta:get_string("owner") then
		return false
	end
	return true
end

--[[minetest.register_node("default:chest", {
	description = "Chest",
	tiles = {"default_chest_top.png", "default_chest_top.png", "default_chest_side.png",
		"default_chest_side.png", "default_chest_side.png", "default_chest_front.png"},
	paramtype2 = "facedir",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
	legacy_facedir_simple = true,
	is_ground_content = false,
	sounds = default.node_sound_wood_defaults(),

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", chest_formspec)
		meta:set_string("infotext", "Chest")
		local inv = meta:get_inventory()
		inv:set_size("main", 8*4)
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end,
	on_metadata_inventory_move = function(pos, from_list, from_index,
			to_list, to_index, count, player)
		minetest.log("action", player:get_player_name() ..
			" moves stuff in chest at " .. minetest.pos_to_string(pos))
	end,
    on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name() ..
			" moves " .. stack:get_name() ..
			" to chest at " .. minetest.pos_to_string(pos))
	end,
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name() ..
			" takes " .. stack:get_name() ..
			" from chest at " .. minetest.pos_to_string(pos))
	end,
	on_blast = function(pos)
		local drops = {}
		default.get_inventory_drops(pos, "main", drops)
		drops[#drops+1] = "default:chest"
		minetest.remove_node(pos)
		return drops
	end,
})]]

--[[minetest.register_node("default:chest_locked", {
	description = "Locked Chest",
	tiles = {"default_chest_top.png", "default_chest_top.png", "default_chest_side.png",
		"default_chest_side.png", "default_chest_side.png", "default_chest_lock.png"},
	paramtype2 = "facedir",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
	legacy_facedir_simple = true,
	is_ground_content = false,
	sounds = default.node_sound_wood_defaults(),

	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		meta:set_string("owner", placer:get_player_name() or "")
		meta:set_string("infotext", "Locked Chest (owned by " ..
				meta:get_string("owner") .. ")")
	end,
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", "Locked Chest")
		meta:set_string("owner", "")
		local inv = meta:get_inventory()
		inv:set_size("main", 8 * 4)
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main") and has_locked_chest_privilege(meta, player)
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index,
			to_list, to_index, count, player)
		local meta = minetest.get_meta(pos)
		if not has_locked_chest_privilege(meta, player) then
			return 0
		end
		return count
	end,
    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		if not has_locked_chest_privilege(meta, player) then
			return 0
		end
		return stack:get_count()
	end,
    allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		if not has_locked_chest_privilege(meta, player) then
			return 0
		end
		return stack:get_count()
	end,
    on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name() ..
			" moves " .. stack:get_name() ..
			" to locked chest at " .. minetest.pos_to_string(pos))
	end,
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name() ..
			" takes " .. stack:get_name()  ..
			" from locked chest at " .. minetest.pos_to_string(pos))
	end,
	on_rightclick = function(pos, node, clicker)
		local meta = minetest.get_meta(pos)
		if has_locked_chest_privilege(meta, clicker) then
			minetest.show_formspec(
				clicker:get_player_name(),
				"default:chest_locked",
				get_locked_chest_formspec(pos)
			)
		end
	end
})]]
local function item_drop(itemstack, dropper, pos)
	if dropper and dropper:is_player() then
		local v = dropper:get_look_dir()
		local p = {x=pos.x, y=pos.y+1.2, z=pos.z}
		p.x = p.x+(math.random(1,3)*0.2)
		p.z = p.z+(math.random(1,3)*0.2)
		local obj = minetest.add_item(p, itemstack)
		if obj then
			v.x = v.x*4
			v.y = v.y*4 + 2
			v.z = v.z*4
			obj:setvelocity(v)
		end
	else
		minetest.add_item(pos, itemstack)
	end
	return itemstack
end
local function default_multiply_with_occurance_in_drop_table(tablefc,a)
local tabert = {}
local a = a or 10
for i,e in pairs(tablefc) do
tabert[i] = {occurance = math.floor(e.occurance*a),min = e.min,max = e.max,name = e.name}
end
return tabert
end
local function fill_chest(pos,cstuff)
	minetest.after(2, function()
		local n = minetest.get_node(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", default_chest_formspec)
		meta:set_string("infotext", "Chest")
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size("main", 8*4)
		ilist = {}
		for _,stuff in pairs(cstuff) do
			if math.random(1,stuff.occurance) == 1 then
				--local stack = {name=stuff.name, count = math.random(stuff.min,stuff.max)}		
				local stack = stuff.name
				local numbers=math.random(stuff.min,stuff.max)
				if numbers ~= 1 then
				stack = stack .. " " .. tostring(numbers) end
				inv:add_item("main", ItemStack(stack))--set_stack("main", math.random(1,32), stack)
			end
		end	
	end)
end
local function fill_hobbit_chest(pos)
	minetest.after(2, function()
		local n = minetest.get_node(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", default_chest_formspec)
		meta:set_string("infotext", "Chest")
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size("main", 8*4)
		ilist = {}
		for _,stuff in pairs(hobbit_chest_stuff_copy) do
			if math.random(1,stuff.occurance) == 1 then
				local stack = {name=stuff.name, count = math.random(stuff.min,stuff.max)}
				inv:set_stack("main", math.random(1,32), stack)
			end
		end	
	end)
end
local function replace_node_invoking_facedir(pos,name)
	local param2 = minetest.get_node(pos).param2
	minetest.set_node(pos,{name = name})
	local node = minetest.get_node(pos)
	node.param2 = param2
	minetest.swap_node(pos,node)
end
function register_treasurechest(name,chestpriv,law,adddata1,adddata2,adddata3,treasure,edges,overlayborder,nameadd)
local descadd = ""
if nameadd then
	descadd = nameadd .. " "
end
minetest.register_node("default:" .. name .. (nameadd or "") .. "chest_locked", {
	description = descadd .. name .. " chest locked",
	tiles = adddata1 or {    "blackwhite_chest_top.png^" .. name .. "_tree_overlay.png" .. (overlayborder or ""),
				 "blackwhite_chest_top.png^" .. name .. "_tree_overlay.png" .. (overlayborder or ""),
				 "blackwhite_chest_side.png^" .. name .. "_tree_overlay.png" .. (overlayborder or ""),
				 "blackwhite_chest_side.png^" .. name .. "_tree_overlay.png" .. (overlayborder or ""), 
				 "blackwhite_chest_side.png^" .. name .. "_tree_overlay.png" .. (overlayborder or ""),
				 "blackwhite_chest_lock.png^" .. name .. "_tree_overlay.png^lockchest.png" .. (overlayborder or "")},
	paramtype2 = "facedir",
	groups = {choppy = 2, oddly_breakable_by_hand = 2,flammable = 1},
	legacy_facedir_simple = true,
	is_ground_content = false,
	sounds = default.node_sound_wood_defaults(),

	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		meta:set_string("owner", placer:get_player_name() or "")
		meta:set_string("infotext", "Locked Chest (owned by " ..
				meta:get_string("owner") .. ")")
	end,
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
--		meta:set_string("infotext", "Locked Chest")
		meta:set_string("owner", "")
		local inv = meta:get_inventory()
		inv:set_size("main", 8 * 4)
	end,
	--after_dig_node = function(pos,node,meta,player)
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		local name = player:get_player_name()
		db({tostring(inv)})
		for i = 1,inv:get_size("main") do
			db({"WWWWWWWWWWWWWWWWWWWWW"})
			item_drop(inv:get_stack("main", i),nil,pos)
		end
		if not has_locked_chest_privilege(meta, player) then
		if (get_chestpriv_by_string(chestpriv,name) <= 0) then
			db({get_chestpriv_by_string(chestpriv,name)})
			add_to_law_status(name,law,100)
		elseif meta:get_string("owner") ~= "" then
			db({get_chestpriv_by_string(chestpriv,name)})
			add_to_law_status(name,law,100)
		elseif get_chestpriv_by_string(chestpriv,name) > 0 then
			add_to_chestpriv_status(name,chestpriv,-1)
		end
		end
		return true
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index,
			to_list, to_index, count, player)
		local meta = minetest.get_meta(pos)
		if not has_locked_chest_privilege(meta, player) then
			return 0
		end
		return count
	end,
    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		if not has_locked_chest_privilege(meta, player) then
			return 0
		end
		return stack:get_count()
	end,
    allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		if not has_locked_chest_privilege(meta, player) then
			return 0
		end
		return stack:get_count()
	end,
    on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name() ..
			" moves " .. stack:get_name() ..
			" to locked chest at " .. minetest.pos_to_string(pos))
	end,
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name() ..
			" takes " .. stack:get_name()  ..
			" from locked chest at " .. minetest.pos_to_string(pos))
	end,
	on_blast = function(pos)
		local drops = {}
		default.get_inventory_drops(pos, "main", drops)
		drops[#drops+1] = "default:chest"
		minetest.remove_node(pos)
		return drops
	end,
	on_rightclick = function(pos, node, clicker)
		local meta = minetest.get_meta(pos)
		local stack = clicker:get_wielded_item()
		local name = clicker:get_player_name()
		if stack:get_name() == "default:key" then
			if get_chestpriv_by_string(chestpriv,name) > 0 or has_locked_chest_privilege(meta, clicker) then
				if get_chestpriv_by_string(chestpriv,name) > 0 and not has_locked_chest_privilege(meta, clicker) then
					if meta:get_string("owner") ~= "" then
						db({get_chestpriv_by_string(chestpriv,player:get_player_name())})
						add_to_law_status(player:get_player_name(),law,48)
					else
						add_to_chestpriv_status(name,chestpriv,-1)
					end
				end
				meta:set_string("owner", name or "")
				minetest.show_formspec(
					name,
					"default:chest_locked",
					get_locked_chest_formspec(pos)
				)
			else
				add_to_law_status(name,law,48)
				meta:set_string("owner", name or "")
				minetest.show_formspec(
					name,
					"default:chest_locked",
					get_locked_chest_formspec(pos)
				)
			end
		end
	end
})
if treasure then
minetest.register_node("default:" .. name .. (nameadd or "") .. "chest_locked_spawner", {
	description = descadd .. name .. " chest locked",
	tiles = adddata1 or {    "blackwhite_chest_top.png^" .. name .. "_tree_overlay.png" .. (overlayborder or ""),
				 "blackwhite_chest_top.png^" .. name .. "_tree_overlay.png" .. (overlayborder or ""),
				 "blackwhite_chest_side.png^" .. name .. "_tree_overlay.png" .. (overlayborder or ""),
				 "blackwhite_chest_side.png^" .. name .. "_tree_overlay.png" .. (overlayborder or ""), 
				 "blackwhite_chest_side.png^" .. name .. "_tree_overlay.png" .. (overlayborder or ""),
				 "blackwhite_chest_lock.png^" .. name .. "_tree_overlay.png^lockchest.png" .. (overlayborder or "")},
	paramtype2 = "facedir",
	groups = {immortal = 1},
	legacy_facedir_simple = true,
	is_ground_content = false,
	sounds = default.node_sound_wood_defaults(),
	on_blast = function()return end,
})
if name == "shire" then
minetest.register_abm({
	nodenames = {"default:" .. name .. (nameadd or "") .. "chest_locked_spawner"},
	interval = 10,
	chance = 1,
	action = function(pos)
		replace_node_invoking_facedir(pos,"default:" .. name .. (nameadd or "") .. "chest_locked")
		fill_hobbit_chest(pos)
	end
})
else
minetest.register_abm({
	nodenames = {"default:" .. name .. (nameadd or "") .. "chest_locked_spawner"},
	interval = 10,
	chance = 1,
	action = function(pos)
		replace_node_invoking_facedir(pos,"default:" .. name .. (nameadd or "") .. "chest_locked")
		fill_chest(pos,treasure)
	end
})
end
end
minetest.register_node("default:" .. name .. (nameadd or "") .. "chest", {
	description = descadd .. name .. " chest",
	tiles = adddata3 or {    "blackwhite_chest_top.png^" .. name .. "_tree_overlay.png" .. (overlayborder or ""),
				 "blackwhite_chest_top.png^" .. name .. "_tree_overlay.png" .. (overlayborder or ""),
				 "blackwhite_chest_side.png^" .. name .. "_tree_overlay.png" .. (overlayborder or ""),
				 "blackwhite_chest_side.png^" .. name .. "_tree_overlay.png" .. (overlayborder or ""), 
				 "blackwhite_chest_side.png^" .. name .. "_tree_overlay.png" .. (overlayborder or ""),
				 "blackwhite_chest.png^" .. name .. "_tree_overlay.png^clipchest.png" .. (overlayborder or "")},
	paramtype2 = "facedir",
	groups = {choppy = 2, oddly_breakable_by_hand = 2,flammable = 1},
	legacy_facedir_simple = true,
	is_ground_content = false,
	sounds = default.node_sound_wood_defaults(),
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
--		meta:set_string("infotext", "Locked Chest")
		local inv = meta:get_inventory()
		inv:set_size("main", 8 * 4)
	end,
	--after_dig_node = function(pos,node,meta,player)
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		db({tostring(inv)})
		for i = 1,inv:get_size("main") do
			--db({"WWWWWWWWWWWWWWWWWWWWW"})
			item_drop(inv:get_stack("main", i),nil,pos)
		end
		return true
	end,
    on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name() ..
			" moves " .. stack:get_name() ..
			" to chest at " .. minetest.pos_to_string(pos))
	end,
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name() ..
			" takes " .. stack:get_name()  ..
			" from chest at " .. minetest.pos_to_string(pos))
	end,
	on_blast = function(pos)
		local drops = {}
		default.get_inventory_drops(pos, "main", drops)
		drops[#drops+1] = "default:chest"
		minetest.remove_node(pos)
		return drops
	end,
	on_rightclick = function(pos, node, clicker)
		local meta = minetest.get_meta(pos)
		local stack = clicker:get_wielded_item()
		local name = clicker:get_player_name()
		minetest.show_formspec(
			name,
			"default:chest_locked",
			get_locked_chest_formspec(pos)
		)
	end
})
minetest.register_craft({
	output = "default:" .. name .. (nameadd or "") .. "chest_locked",
	recipe = {
		{edges or adddata2 or'default:' .. name .. 'wood', adddata2 or 'default:' .. name .. 'wood', edges or adddata2 or 'default:' .. name .. 'wood'},
		{adddata2 or 'default:' .. name .. 'wood', 'default:steel_ingot', adddata2 or 'default:' .. name .. 'wood'},
		{edges or adddata2 or 'default:' .. name .. 'wood', adddata2 or 'default:' .. name .. 'wood',edges or adddata2 or 'default:' .. name .. 'wood'},
	}
})
minetest.register_craft({
	output = "default:" .. name .. (nameadd or "") .. "chest",
	recipe = {
		{edges or adddata2 or'default:' .. name .. 'wood', adddata2 or 'default:' .. name .. 'wood', edges or adddata2 or 'default:' .. name .. 'wood'},
		{adddata2 or 'default:' .. name .. 'wood', '', adddata2 or 'default:' .. name .. 'wood'},
		{edges or adddata2 or 'default:' .. name .. 'wood', adddata2 or 'default:' .. name .. 'wood',edges or adddata2 or 'default:' .. name .. 'wood'},
	}
})
end
local function add_chest_stuff(t1,t2)
for _,i in pairs(t2) do
table.insert(t1,i)
end
return t1
end
local function add_wood_stuff(table_,name,chestadd)
local add = {
{name="default:fence_" ..name .. "wood",occurance = 4,min = 1,max = 35},
{name="stairs:stair_" ..name .. "wood",occurance = 4,min = 1,max = 35},
{name="stairs:slab_" ..name .. "wood",occurance = 5,min = 1,max = 35},
{name="doors:door_" ..name .. "wood",occurance = 4,min = 1,max = 35},
{name="doors:trapdoor_" ..name .. "wood",occurance = 4,min = 1,max = 35},
{name="default:gate_" ..name .. "wood_closed",occurance = 5,min = 1,max = 35},
{name="default:" ..name .. (chestadd or "") .. "chest",occurance = 4,min = 1,max = 10},
{name="default:" ..name .. (chestadd or "") .. "chest_locked",occurance = 4,min = 1,max = 10},
{name="default:" ..name .. "wood",occurance = 1,min = 1,max = 99},
{name="default:" ..name .. "tree",occurance = 1,min = 1,max = 99},
{name="default:" ..name .. "leaves",occurance = 5,min = 1,max = 99},
{name="default:" ..name .. "sapling",occurance = 1,min = 1,max = 10}
}
return add_chest_stuff(table_,add)
end
local elven_chest_stuff ={
{name="default:sword_mithril",occurance = 1,min = 1,max = 1},
{name="default:sword_mithril",occurance = 1,min = 1,max = 1},
{name="default:shovel_mithril",occurance = 3,min = 1,max = 1},
{name="healthbar:crafting_book",occurance = 3,min = 1,max = 1},
{name="default:map",occurance = 3,min = 1,max = 1},
{name="default:pick_mithril",occurance = 1,min = 1,max = 1},
{name="default:axe_mithril",occurance = 2,min = 1,max = 1},
{name="default:mithrilblock",occurance = 2,min = 1,max = 3},
{name="default:mithril_ingot",occurance = 1,min = 1,max = 35},
{name="default:mithril_lump",occurance = 3,min = 1,max = 35}}
default_standard_mob_drop_list.elf = default_multiply_with_occurance_in_drop_table(elven_chest_stuff)

local mordor_chest_stuff ={
{name="default:sword_steel",occurance = 1,min = 1,max = 1},
{name="default:shovel_steel",occurance = 3,min = 1,max = 1},
{name="default:pick_steel",occurance = 1,min = 1,max = 1},
{name="default:axe_steel",occurance = 2,min = 1,max = 1},
{name="default:mordordust",occurance = 1,min = 1,max = 99},
{name="default:coalblock",occurance = 1,min = 1,max = 36},
{name="default:cobble",occurance = 1,min = 1,max = 99},
{name="default:mossycobble",occurance = 1,min = 1,max = 99},
{name="default:coolinglava",occurance = 1,min = 1,max = 99},
{name="bucket:bucket_lava",occurance = 1,min = 1,max = 10},
{name="bones:bones",occurance = 1,min = 1,max = 99},
{name="default:steel_ingot",occurance = 1,min = 1,max = 24}}
default_standard_mob_drop_list.orc = default_multiply_with_occurance_in_drop_table(mordor_chest_stuff)
default_standard_mob_drop_list.wizzard = default_multiply_with_occurance_in_drop_table({
{name="default:sword_mithril",occurance = 2,min = 1,max = 1},
{name="default:sword_mithril",occurance = 1,min = 1,max = 1},
{name="default:shovel_mithril",occurance = 3,min = 1,max = 1},
{name="default:pick_mithril",occurance = 1,min = 1,max = 1},
{name="default:axe_mithril",occurance = 2,min = 1,max = 1},
{name="default:mithrilblock",occurance = 2,min = 1,max = 3},
{name="default:mithril_ingot",occurance = 1,min = 1,max = 35},
{name="default:mithril_lump",occurance = 3,min = 1,max = 35}})
--table.insert(default_standard_mob_drop_list.wizzard,{name="default:magic_light_wand",occurance = 1,min = 1,max = 1})
local rohan_add_chest_stuff ={
{name="default:simbelmyneflower",occurance = 3,min = 1,max = 99},
{name="default:wheatplant",occurance = 1,min = 1,max = 99},
{name="default:barleyplant",occurance = 1,min = 1,max = 99},
}
local gondor_and_ithilien_add_chest_stuff ={
{name="default:mallosflower",occurance = 3,min = 1,max = 99},
{name="default:alfirinflower",occurance = 1,min = 1,max = 99},
{name="default:athelasflower",occurance = 1,min = 1,max = 99},
}
local lorien_add_chest_stuff ={
{name="default:lissulinflower",occurance = 3,min = 1,max = 99},
{name="default:niphredilflower",occurance = 3,min = 1,max = 99},
{name="default:elanorflower",occurance = 3,min = 1,max = 99},
--{name="default:loriengrassgrass",occurance = 3,min = 1,max = 99},
}
local human_chest_stuff ={
{name="default:sword_steel",occurance = 1,min = 1,max = 1},
{name="default:shovel_steel",occurance = 2,min = 1,max = 1},
{name="default:pick_steel",occurance = 1,min = 1,max = 1},
{name="default:axe_steel",occurance = 2,min = 1,max = 1},
{name="default:sword_steel",occurance = 1,min = 1,max = 1},
{name="default:shovel_steel",occurance = 2,min = 1,max = 1},
{name="default:pick_steel",occurance = 1,min = 1,max = 1},
{name="default:axe_steel",occurance = 2,min = 1,max = 1},
{name="default:sword_steel",occurance = 1,min = 1,max = 1},
{name="default:shovel_steel",occurance = 2,min = 1,max = 1},
{name="default:pick_steel",occurance = 1,min = 1,max = 1},
{name="default:axe_steel",occurance = 2,min = 1,max = 1},
{name="default:sword_steel",occurance = 1,min = 1,max = 1},
{name="default:shovel_steel",occurance = 2,min = 1,max = 1},
{name="default:pick_steel",occurance = 1,min = 1,max = 1},
{name="default:axe_steel",occurance = 2,min = 1,max = 1},
{name="default:coalblock",occurance = 1,min = 1,max = 36},
{name="default:cobble",occurance = 1,min = 1,max = 99},
{name="default:marblestone",occurance = 1,min = 1,max = 99},
{name="default:marblestonebrick",occurance = 1,min = 1,max = 99},
{name="stairs:stair_marblestonebrick",occurance = 1,min = 1,max = 99},
{name="stairs:stair_marblestone",occurance = 1,min = 1,max = 99},
{name="stairs:stair_cobble",occurance = 1,min = 1,max = 99},
{name="default:steel_ingot",occurance = 1,min = 1,max = 24}}
local hobbit_chest_stuff ={
{name="farming:hoe_steel",occurance = 1,min = 1,max = 1},
{name="farming:seed_mushroom_brown",occurance = 3,min = 1,max = 99},
{name="farming:hoe_bronze",occurance = 2,min = 1,max = 1},
--{name="default:hoe_mese",occurance = 4,min = 1,max = 1},
--{name="default:hoe_diamond",occurance = 8,min = 1,max = 1},
{name="default:shovel_steel",occurance = 1,min = 1,max = 1},
{name="default:axe_steel",occurance = 1,min = 1,max = 1},
{name="default:shovel_bronze",occurance = 1,min = 1,max = 1},
{name="default:axe_bronze",occurance = 1,min = 1,max = 1},
{name="farming:hoe_steel",occurance = 1,min = 1,max = 1},
{name="farming:hoe_bronze",occurance = 2,min = 1,max = 1},
--{name="default:hoe_mese",occurance = 4,min = 1,max = 1},
--{name="default:hoe_diamond",occurance = 8,min = 1,max = 1},
{name="default:shovel_steel",occurance = 1,min = 1,max = 1},
{name="default:axe_steel",occurance = 1,min = 1,max = 1},
{name="default:shovel_bronze",occurance = 1,min = 1,max = 1},
{name="default:axe_bronze",occurance = 1,min = 1,max = 1},
{name="farming:hoe_steel",occurance = 1,min = 1,max = 1},
{name="farming:hoe_bronze",occurance = 2,min = 1,max = 1},
--{name="default:hoe_mese",occurance = 4,min = 1,max = 1},
--{name="default:hoe_diamond",occurance = 8,min = 1,max = 1},
{name="default:shovel_steel",occurance = 1,min = 1,max = 1},
{name="default:axe_steel",occurance = 1,min = 1,max = 1},
{name="default:shovel_bronze",occurance = 1,min = 1,max = 1},
{name="default:axe_bronze",occurance = 1,min = 1,max = 1},
--{name="default:shovel_mese",occurance = 1,min = 1,max = 1},
--{name="default:axe_mese",occurance = 1,min = 1,max = 1},
--{name="default:shovel_diamond",occurance = 1,min = 1,max = 1},
--{name="default:axe_diamond",occurance = 1,min = 1,max = 1},
{name="default:coalblock",occurance = 1,min = 1,max = 36},
{name="default:cobble",occurance = 1,min = 1,max = 99},
{name="stairs:stair_cobble",occurance = 1,min = 1,max = 99},
--#addedlater{name="default:cottonplant",occurance = 1,min = 1,max = 99},
--#addedlater{name="default:cornplant",occurance = 1,min = 1,max = 99},
--#addedlater{name="default:pipeweedplant",occurance = 1,min = 1,max = 99},
{name="default:dirt",occurance = 1,min = 1,max = 99},
{name="default:wood",occurance = 1,min = 1,max = 99},
{name="default:tree",occurance = 1,min = 1,max = 99},
}
hobbit_chest_stuff_copy = {
{name="farming:hoe_steel",occurance = 1,min = 1,max = 1},
{name="farming:seed_mushroom_brown",occurance = 3,min = 1,max = 99},
{name="farming:hoe_bronze",occurance = 2,min = 1,max = 1},
--{name="default:hoe_mese",occurance = 4,min = 1,max = 1},
--{name="default:hoe_diamond",occurance = 8,min = 1,max = 1},
{name="default:shovel_steel",occurance = 1,min = 1,max = 1},
{name="default:axe_steel",occurance = 1,min = 1,max = 1},
{name="default:shovel_bronze",occurance = 1,min = 1,max = 1},
{name="default:axe_bronze",occurance = 1,min = 1,max = 1},
{name="farming:hoe_steel",occurance = 1,min = 1,max = 1},
{name="farming:hoe_bronze",occurance = 2,min = 1,max = 1},
--{name="default:hoe_mese",occurance = 4,min = 1,max = 1},
--{name="default:hoe_diamond",occurance = 8,min = 1,max = 1},
{name="default:shovel_steel",occurance = 1,min = 1,max = 1},
{name="default:axe_steel",occurance = 1,min = 1,max = 1},
{name="default:shovel_bronze",occurance = 1,min = 1,max = 1},
{name="default:axe_bronze",occurance = 1,min = 1,max = 1},
{name="farming:hoe_steel",occurance = 1,min = 1,max = 1},
{name="farming:hoe_bronze",occurance = 2,min = 1,max = 1},
--{name="default:hoe_mese",occurance = 4,min = 1,max = 1},
--{name="default:hoe_diamond",occurance = 8,min = 1,max = 1},
{name="default:shovel_steel",occurance = 1,min = 1,max = 1},
{name="default:axe_steel",occurance = 1,min = 1,max = 1},
{name="default:shovel_bronze",occurance = 1,min = 1,max = 1},
{name="default:axe_bronze",occurance = 1,min = 1,max = 1},
--{name="default:shovel_mese",occurance = 1,min = 1,max = 1},
--{name="default:axe_mese",occurance = 1,min = 1,max = 1},
--{name="default:shovel_diamond",occurance = 1,min = 1,max = 1},
--{name="default:axe_diamond",occurance = 1,min = 1,max = 1},
{name="default:coalblock",occurance = 1,min = 1,max = 36},
{name="default:cobble",occurance = 1,min = 1,max = 99},
{name="stairs:stair_cobble",occurance = 1,min = 1,max = 99},
--#addedlater{name="default:cottonplant",occurance = 1,min = 1,max = 99},
--#addedlater{name="default:cornplant",occurance = 1,min = 1,max = 99},
--#addedlater{name="default:pipeweedplant",occurance = 1,min = 1,max = 99},
{name="default:dirt",occurance = 1,min = 1,max = 99},
{name="default:wood",occurance = 1,min = 1,max = 99},
{name="default:tree",occurance = 1,min = 1,max = 99},
}
function default_make_stuff_aviable_in_hobbit_chests(name,min,max,occurance)
	table.insert(hobbit_chest_stuff_copy,{name = name,min = min,max = max,occurance = occurance})
end
function default_make_seeds_aviable_in_hobbit_chests(name)
default_make_stuff_aviable_in_hobbit_chests(name,1,99,6)
end
default_standard_mob_drop_list.ent = add_wood_stuff({},"jungletree")
default_standard_mob_drop_list.human = default_multiply_with_occurance_in_drop_table(human_chest_stuff)
default_standard_mob_drop_list["hobbit"] = default_multiply_with_occurance_in_drop_table(hobbit_chest_stuff)
local angmar_chest_stuff ={
{name="default:sword_steel",occurance = 1,min = 1,max = 1},
{name="default:shovel_steel",occurance = 3,min = 1,max = 1},
{name="default:pick_steel",occurance = 1,min = 1,max = 1},
{name="default:axe_steel",occurance = 2,min = 1,max = 1},
{name="default:coalblock",occurance = 1,min = 1,max = 36},
{name="default:cobble",occurance = 1,min = 1,max = 99},
{name="default:cobble",occurance = 1,min = 1,max = 99},
{name="default:angmarsnow",occurance = 1,min = 1,max = 99},
{name="default:ice",occurance = 1,min = 1,max = 99},
{name="default:pine_tree",occurance = 1,min = 1,max = 99},
{name="default:pine_wood",occurance = 1,min = 1,max = 99},
{name="default:pinesapling",occurance = 1,min = 1,max = 10},
{name="bones:bones",occurance = 1,min = 1,max = 99},
{name="default:steel_ingot",occurance = 1,min = 1,max = 24}}
local dwarvern_chest_stuff ={
{name="default:sword_galvorn",occurance = 1,min = 1,max = 1},
{name="default:shovel_galvorn",occurance = 3,min = 1,max = 1},
{name="default:pick_galvorn",occurance = 1,min = 1,max = 1},
{name="default:axe_galvorn",occurance = 2,min = 1,max = 1},
{name="default:galvornblock",occurance = 2,min = 1,max = 3},
{name="default:galvorn_ingot",occurance = 1,min = 1,max = 35},
{name="lotharrows:arrow_black",occurance = 4,min = 1,max = 99}}
default_standard_mob_drop_list.dwarf = default_multiply_with_occurance_in_drop_table(dwarvern_chest_stuff)
default_standard_mob_drop_list.dunlending ={
{name="default:sword_stone",occurance = 1,min = 1,max = 1},
{name="default:shovel_stone",occurance = 3,min = 1,max = 1},
{name="default:pick_stone",occurance = 1,min = 1,max = 1},
{name="default:axe_stone",occurance = 2,min = 1,max = 1}}
register_treasurechest("mallorn","hudwelshchestpriv","hudwelshlaw",nil,nil,nil,add_wood_stuff(elven_chest_stuff,"mallorn"))
register_treasurechest("jungletree","hudwelshchestpriv","hudwelshlaw",nil,nil,nil,add_wood_stuff({},"jungletree"))
register_treasurechest("mirk","hudwelshchestpriv","hudwelshlaw",nil,nil,nil,add_wood_stuff(elven_chest_stuff,"mirk"))
register_treasurechest("lebethron","hudwelshchestpriv","hudwelshlaw",nil,nil,nil,add_chest_stuff(add_wood_stuff(add_wood_stuff(add_wood_stuff(human_chest_stuff,"lebethron"),"culumalda"),"whitetree"),gondor_and_ithilien_add_chest_stuff))
--register_treasurechest("culumalda","hudwelshchestpriv","hudwelshlaw",nil,nil,nil,add_wood_stuff(human_chest_stuff,"culumalda"))
--register_treasurechest("culumalda","hudwelshchestpriv","hudwelshlaw")
register_treasurechest("culumalda","hudwelshchestpriv","hudwelshlaw",nil,nil,nil,add_chest_stuff(add_wood_stuff(human_chest_stuff,"lebethron"),gondor_and_ithilien_add_chest_stuff))
register_treasurechest("whitetree","hudwelshchestpriv","hudwelshlaw")
register_treasurechest("dunland","dunlendingshchestpriv","dunlendingshlaw",{"default_chest_top.png^dunland_chest_overlay.png",
 "default_chest_top.png^dunland_chest_overlay.png", "default_chest_side.png^dunland_chest_overlay.png","default_chest_side.png^dunland_chest_overlay.png", "default_chest_side.png^dunland_chest_overlay.png", "default_chest_lock.png^dunland_chest_overlay.png"},"default:wood",{"default_chest_top.png^dunland_chest_overlay.png","default_chest_top.png^dunland_chest_overlay.png","default_chest_side.png^dunland_chest_overlay.png","default_chest_side.png^dunland_chest_overlay.png", "default_chest_side.png^dunland_chest_overlay.png", "default_chest_front.png^dunland_chest_overlay.png"},nil,"default:tree")
register_treasurechest("shire","hudwelshchestpriv","hudwelshlaw",{"default_chest_top.png^shire_chest_overlay.png",
 "default_chest_top.png^shire_chest_overlay.png", "default_chest_side.png^shire_chest_overlay.png","default_chest_side.png^shire_chest_overlay.png", "default_chest_side.png^shire_chest_overlay.png", "default_chest_lock.png^shire_chest_overlay.png"},"default:tree",{"default_chest_top.png^shire_chest_overlay.png","default_chest_top.png^shire_chest_overlay.png","default_chest_side.png^shire_chest_overlay.png","default_chest_side.png^shire_chest_overlay.png", "default_chest_side.png^shire_chest_overlay.png", "default_chest_front.png^shire_chest_overlay.png"},hobbit_chest_stuff,"default:wood")
register_treasurechest("aspen","hudwelshchestpriv","hudwelshlaw",nil,"default:aspen_wood")
register_treasurechest("rohan","hudwelshchestpriv","hudwelshlaw",{"default_chest_top.png", "default_chest_top.png", "default_chest_side.png","default_chest_side.png", "default_chest_side.png", "default_chest_lock.png"},"default:wood",{"default_chest_top.png","default_chest_top.png","default_chest_side.png","default_chest_side.png","default_chest_side.png","default_chest_front.png"},add_chest_stuff(human_chest_stuff,rohan_add_chest_stuff))
register_treasurechest("aspen","hudwelshchestpriv","hudwelshlaw",nil,"default:aspen_wood")
register_treasurechest("pine","orcishchestpriv","orcishlaw",nil,"default:pine_wood",nil,angmar_chest_stuff)
register_treasurechest("pine","hudwelshchestpriv","hudwelshlaw",nil,"default:pine_wood",nil,dwarvern_chest_stuff,"default:steel_ingot","^ironhill_chest_overlay.png","dwarfern")
register_treasurechest("pine","orcishchestpriv","orcishlaw",nil,"default:pine_wood",nil,mordor_chest_stuff,"default:mordordust","^mordor_chest_overlay.png","mordor")
local bookshelf_formspec =
	"size[8,7;]" ..
	default.gui_bg ..
	default.gui_bg_img ..
	default.gui_slots ..
	"list[context;books;0,0.3;8,2;]" ..
	"list[current_player;main;0,2.85;8,1;]" ..
	"list[current_player;main;0,4.08;8,3;8]" ..
	"listring[context;books]" ..
	"listring[current_player;main]" ..
	default.get_hotbar_bg(0,2.85)
minetest.register_node("default:bookshelf", {
	description = "Bookshelf",
	tiles = {"default_wood.png", "default_wood.png", "default_bookshelf.png"},
	is_ground_content = false,
	groups = {choppy = 3, oddly_breakable_by_hand = 2, flammable = 2},
	sounds = default.node_sound_wood_defaults(),

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", bookshelf_formspec)
		local inv = meta:get_inventory()
		inv:set_size("books", 8 * 2)
	end,
	can_dig = function(pos,player)
		local inv = minetest.get_meta(pos):get_inventory()
		return inv:is_empty("books")
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack)
		if minetest.get_item_group(stack:get_name(), "book") ~= 0 then
			return stack:get_count()
		end
		return 0
	end,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		minetest.log("action", player:get_player_name() ..
			" moves stuff in bookshelf at " .. minetest.pos_to_string(pos))
	end,
	on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name() ..
			" moves stuff to bookshelf at " .. minetest.pos_to_string(pos))
	end,
	on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name() ..
			" takes stuff from bookshelf at " .. minetest.pos_to_string(pos))
	end,
	on_blast = function(pos)
		local drops = {}
		default.get_inventory_drops(pos, "books", drops)
		drops[#drops+1] = "default:bookshelf"
		minetest.remove_node(pos)
		return drops
	end,
})

local function register_sign(material, desc, def)
	minetest.register_node("default:sign_wall_" .. material, {
		description = desc .. " Sign",
		drawtype = "nodebox",
		tiles = {"default_sign_wall_" .. material .. ".png"},
		inventory_image = "default_sign_" .. material .. ".png",
		wield_image = "default_sign_" .. material .. ".png",
		paramtype = "light",
		paramtype2 = "wallmounted",
		sunlight_propagates = true,
		is_ground_content = false,
		walkable = false,
		node_box = {
			type = "wallmounted",
			wall_top    = {-0.4375, 0.4375, -0.3125, 0.4375, 0.5, 0.3125},
			wall_bottom = {-0.4375, -0.5, -0.3125, 0.4375, -0.4375, 0.3125},
			wall_side   = {-0.5, -0.3125, -0.4375, -0.4375, 0.3125, 0.4375},
		},
		groups = def.groups,
		legacy_wallmounted = true,
		sounds = def.sounds,

		on_construct = function(pos)
			--local n = minetest.get_node(pos)
			local meta = minetest.get_meta(pos)
			meta:set_string("formspec", "field[text;;${text}]")
			meta:set_string("infotext", "\"\"")
		end,
		on_receive_fields = function(pos, formname, fields, sender)
			--print("Sign at "..minetest.pos_to_string(pos).." got "..dump(fields))
			local player_name = sender:get_player_name()
			if minetest.is_protected(pos, player_name) then
				minetest.record_protection_violation(pos, player_name)
				return
			end
			local meta = minetest.get_meta(pos)
			if not fields.text then return end
			minetest.log("action", (player_name or "") .. " wrote \"" ..
				fields.text .. "\" to sign at " .. minetest.pos_to_string(pos))
			meta:set_string("text", fields.text)
			meta:set_string("infotext", '"' .. fields.text .. '"')
		end,
	})
end

register_sign("wood", "Wooden", {
	sounds = default.node_sound_wood_defaults(),
	groups = {choppy = 2, attached_node = 1, flammable = 2, oddly_breakable_by_hand = 3}
})

register_sign("steel", "Steel", {
	sounds = default.node_sound_defaults(),
	groups = {cracky = 2, attached_node = 1}
})

minetest.register_node("default:ladder_wood", {
	description = "Wooden Ladder",
	drawtype = "signlike",
	tiles = {"default_ladder_wood.png"},
	inventory_image = "default_ladder_wood.png",
	wield_image = "default_ladder_wood.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	climbable = true,
	is_ground_content = false,
	selection_box = {
		type = "wallmounted",
		--wall_top = = <default>
		--wall_bottom = = <default>
		--wall_side = = <default>
	},
	groups = {choppy = 2, oddly_breakable_by_hand = 3, flammable = 2},
	legacy_wallmounted = true,
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("default:ladder_steel", {
	description = "Steel Ladder",
	drawtype = "signlike",
	tiles = {"default_ladder_steel.png"},
	inventory_image = "default_ladder_steel.png",
	wield_image = "default_ladder_steel.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	climbable = true,
	is_ground_content = false,
	selection_box = {
		type = "wallmounted",
		--wall_top = = <default>
		--wall_bottom = = <default>
		--wall_side = = <default>
	},
	groups = {cracky = 2},
	sounds = default.node_sound_stone_defaults(),
})

default.register_fence("default:fence_wood", {
	description = "Wooden Fence",
	texture = "default_fence_wood.png",
	material = "default:wood",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	sounds = default.node_sound_wood_defaults()
})

default.register_fence("default:fence_acacia_wood", {
	description = "Acacia Fence",
	texture = "default_fence_acacia_wood.png",
	material = "default:acacia_wood",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	sounds = default.node_sound_wood_defaults()
})

default.register_fence("default:fence_junglewood", {
	description = "Junglewood Fence",
	texture = "default_fence_junglewood.png",
	material = "default:junglewood",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	sounds = default.node_sound_wood_defaults()
})

default.register_fence("default:fence_pine_wood", {
	description = "Pine Fence",
	texture = "default_fence_pine_wood.png",
	material = "default:pine_wood",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	sounds = default.node_sound_wood_defaults()
})

default.register_fence("default:fence_aspen_wood", {
	description = "Aspen Fence",
	texture = "default_fence_aspen_wood.png",
	material = "default:aspen_wood",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	sounds = default.node_sound_wood_defaults()
})

minetest.register_node("default:glass", {
	description = "Glass",
	drawtype = "glasslike_framed_optional",
	tiles = {"default_glass.png", "default_glass_detail.png"},
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {cracky = 3, oddly_breakable_by_hand = 3},
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_node("default:obsidian_glass", {
	description = "Obsidian Glass",
	drawtype = "glasslike_framed_optional",
	tiles = {"default_obsidian_glass.png", "default_obsidian_glass_detail.png"},
	paramtype = "light",
	is_ground_content = false,
	sunlight_propagates = true,
	sounds = default.node_sound_glass_defaults(),
	groups = {cracky = 3},
})


minetest.register_node("default:rail", {
	description = "Rail",
	drawtype = "raillike",
	tiles = {"default_rail.png", "default_rail_curved.png",
		"default_rail_t_junction.png", "default_rail_crossing.png"},
	inventory_image = "default_rail.png",
	wield_image = "default_rail.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	is_ground_content = false,
	selection_box = {
		type = "fixed",
                -- but how to specify the dimensions for curved and sideways rails?
                fixed = {-1/2, -1/2, -1/2, 1/2, -1/2+1/16, 1/2},
	},
	groups = {bendy = 2, dig_immediate = 2, attached_node = 1,
		connect_to_raillike = minetest.raillike_group("rail")},
})


minetest.register_node("default:brick", {
	description = "Brick Block",
	tiles = {"default_brick.png"},
	is_ground_content = false,
	groups = {cracky = 3},
	sounds = default.node_sound_stone_defaults(),
})


minetest.register_node("default:mithrillamp", {
	description = "Mithril Lamp",
	drawtype = "glasslike",
	tiles = {--[["default_meselamp.png]]"white_background.png^lamp_mithril_overlay2.png"},
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {cracky = 3, oddly_breakable_by_hand = 3},
	sounds = default.node_sound_glass_defaults(),
	light_source = default.LIGHT_MAX,
})
--
-- Misc
--

minetest.register_node("default:cloud", {
	description = "Cloud",
	tiles = {"default_cloud.png"},
	is_ground_content = false,
	sounds = default.node_sound_defaults(),
	groups = {not_in_creative_inventory = 1},
})

minetest.register_node("default:nyancat", {
	description = "Nyan Cat",
	tiles = {"default_nc_side.png", "default_nc_side.png", "default_nc_side.png",
		"default_nc_side.png", "default_nc_back.png", "default_nc_front.png"},
	paramtype2 = "facedir",
	groups = {cracky = 2},
	is_ground_content = false,
	legacy_facedir_simple = true,
	sounds = default.node_sound_defaults(),
})

minetest.register_node("default:nyancat_rainbow", {
	description = "Nyan Cat Rainbow",
	tiles = {
		"default_nc_rb.png^[transformR90", "default_nc_rb.png^[transformR90",
		"default_nc_rb.png", "default_nc_rb.png"
	},
	paramtype2 = "facedir",
	groups = {cracky = 2},
	is_ground_content = false,
	sounds = default.node_sound_defaults(),
})
			ball = minetest.add_entity(pos,"default:greymagic")
