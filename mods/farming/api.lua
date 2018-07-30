-- Wear out hoes, place soil
-- TODO Ignore group:flower
local alias_frequency
local function cabbage_defbox(size)
return {type = "fixed",fixed = {-0.5*size,-0.5,-0.5*size,0.5*size,size-0.5,0.5*size}}
end
local function register_food(name,imagename,vitality,second_ffoood,flag_png)
local ii = ""
if flag_png then
ii = imagename
else
ii = imagename .. ".png"
end
local function steal_punishment(a,b, player)
		add_to_law_status(player:get_player_name(),"hudwelshlaw",1)
		return true
end
minetest.register_craftitem(name, {
	description = name:split(":")[2],
	inventory_image = ii,
	on_use = function(itemstack, dropper)
		name = dropper:get_player_name()
		local vitality = vitality
		if second_ffoood and math.random(1,second_ffoood.chanche)then
			vitality = second_ffoood.nutrition
		end
		local table = playernutritions[name]
		for ind,ele in pairs(table) do
			if vitality[ind] then
				table[ind] = math.max(ele + vitality[ind],0)
			end
		end
		update_health_data_file(name,table)
		itemstack:take_item()
		return itemstack
	end,
})
end
farming_hobbitcrops  = {"default:cornplant",
			"default:cottonplant",
			"default:pipeweedplant"
--			,"default:barleyplant",
--			"default:wheatplant"
}
farming.hoe_on_use = function(itemstack, user, pointed_thing, uses)
	local pt = pointed_thing
	-- check if pointing at a node
	if not pt then
		return
	end
	if pt.type ~= "node" then
		return
	end
	
	local under = minetest.get_node(pt.under)
	local p = {x=pt.under.x, y=pt.under.y+1, z=pt.under.z}
	local above = minetest.get_node(p)
	
	-- return if any of the nodes is not registered
	if (not minetest.registered_nodes[under.name]) or (not minetest.registered_nodes[above.name]) then
		return
	end
	
	-- check if the node above the pointed thing is air
	if above.name ~= "air" then
		return
	end
	
	-- check if pointing at soil
	if minetest.get_item_group(under.name, "soil") ~= 1 then
		return
	end
	
	-- check if (wet) soil defined
	local regN = minetest.registered_nodes
	if regN[under.name].soil == nil or regN[under.name].soil.wet == nil or regN[under.name].soil.dry == nil then
		return
	end
	
	if minetest.is_protected(pt.under, user:get_player_name()) then
		minetest.record_protection_violation(pt.under, user:get_player_name())
		return
	end
	if minetest.is_protected(pt.above, user:get_player_name()) then
		minetest.record_protection_violation(pt.above, user:get_player_name())
		return
	end

	
	-- turn the node into soil, wear out item and play sound
	minetest.set_node(pt.under, {name = regN[under.name].soil.dry})
	minetest.sound_play("default_dig_crumbly", {
		pos = pt.under,
		gain = 0.5,
	})
	
	if not minetest.setting_getbool("creative_mode") then
		itemstack:add_wear(65535/(uses-1))
	end
	return itemstack
end

-- Register new hoes
farming.register_hoe = function(name, def)
	-- Check for : prefix (register new hoes in your mod's namespace)
	if name:sub(1,1) ~= ":" then
		name = ":" .. name
	end
	-- Check def table
	if def.description == nil then
		def.description = "Hoe"
	end
	if def.inventory_image == nil then
		def.inventory_image = "unknown_item.png"
	end
	if def.recipe == nil then
		def.recipe = {
			{"air","air",""},
			{"","group:stick",""},
			{"","group:stick",""}
		}
	end
	if def.max_uses == nil then
		def.max_uses = 30
	end
	-- Register the tool
	minetest.register_tool(name, {
		description = def.description,
		inventory_image = def.inventory_image,
		on_use = function(itemstack, user, pointed_thing)
			return farming.hoe_on_use(itemstack, user, pointed_thing, def.max_uses)
		end
	})
	-- Register its recipe
	if def.material == nil then
		minetest.register_craft({
			output = name:sub(2),
			recipe = def.recipe
		})
	else
		minetest.register_craft({
			output = name:sub(2),
			recipe = {
				{def.material, def.material, ""},
				{"", "group:stick", ""},
				{"", "group:stick", ""}
			}
		})
		-- Reverse Recipe
		minetest.register_craft({
			output = name:sub(2),
			recipe = {
				{"", def.material, def.material},
				{"", "group:stick", ""},
				{"", "group:stick", ""}
			}
		})
	end
end

-- Seed placement
farming.place_seed = function(itemstack, placer, pointed_thing, plantname)
	local pt = pointed_thing
	-- check if pointing at a node
	if not pt then
		return
	end
	if pt.type ~= "node" then
		return
	end
	
	local under = minetest.get_node(pt.under)
	local above = minetest.get_node(pt.above)
	
	if minetest.is_protected(pt.under, placer:get_player_name()) then
		minetest.record_protection_violation(pt.under, placer:get_player_name())
		return
	end
	if minetest.is_protected(pt.above, placer:get_player_name()) then
		minetest.record_protection_violation(pt.above, placer:get_player_name())
		return
	end

	
	-- return if any of the nodes is not registered
	if not minetest.registered_nodes[under.name] then
		return
	end
	if not minetest.registered_nodes[above.name] then
		return
	end
	
	-- check if pointing at the top of the node
	if pt.above.y ~= pt.under.y+1 then
		return
	end
	
	-- check if you can replace the node above the pointed node
	if not minetest.registered_nodes[above.name].buildable_to then
		return
	end
	
	-- check if pointing at soil
	if minetest.get_item_group(under.name, "soil") < 2 then
		return
	end
	
	-- add the node and remove 1 item from the itemstack
	minetest.add_node(pt.above, {name = plantname, param2 = 1})
	if not minetest.setting_getbool("creative_mode") then
		itemstack:take_item()
	end
	return itemstack
end

-- Register plants
local function farming_cookfood(t)
return {[1] = t[1]*3,[2] = t[2],[3] = t[3]*2,[4] = t[4],[5] = t[5]}
end
farming.register_plant = function(name, def,generatetextures,startgreenvalue,food,generatedtextures,cabbage)
	if def.growtime then
		def.growtime = def.growtime/10
	end
	if food then
		def.harvest_mass = (def.harvest_mass or 10)/10
		for i,e in pairs(food) do
			food[i] = e*farming_food_constant*def.harvest_mass
		end
	end
	if generatedtextures or cabbage then
		def.steps = 10
	end
	local mname = name:split(":")[1]
	local pname = name:split(":")[2]

	-- Check def table
	if not def.description then
		def.description = "Seed"
	end
	if not def.inventory_image then
		def.inventory_image = "unknown_item.png"
	end
	if not def.steps then
		return nil
	end
	if not def.minlight then
		def.minlight = 1
	end
	if not def.maxlight then
		def.maxlight = 14
	end
	if not def.fertility then
		def.fertility = {}
	end

	-- Register seed
	local g = {seed = 1, snappy = 3, attached_node = 1}
	for k, v in pairs(def.fertility) do
		g[v] = 1
	end
	minetest.register_node(":" .. mname .. ":seed_" .. pname, {
		description = def.description,
		tiles = {def.inventory_image},
		inventory_image = def.inventory_image,
		wield_image = def.inventory_image,
		drawtype = "signlike",
		groups = g,
		paramtype = "light",
		paramtype2 = "wallmounted",
		walkable = false,
		sunlight_propagates = true,
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
		},
		fertility = def.fertility,
		sounds = default.node_sound_dirt_defaults({
			dug = {name = "default_grass_footstep", gain = 0.2},
			place = {name = "default_place_node", gain = 0.25},
		}),

		on_place = function(itemstack, placer, pointed_thing)
			return farming.place_seed(itemstack, placer, pointed_thing, mname .. ":seed_" .. pname)
		end,
	})
	default_make_seeds_aviable_in_hobbit_chests(mname .. ":seed_" .. pname)
	-- Register harvest
	if food and (not def.notfood) then
	if cabbage then
	register_food(mname .. ":" .. pname,"[inventorycube{" .. def.top_tiles .. "{" .. def.side_tiles .. "{" .. def.side_tiles_wopng,food)
	else
	register_food(mname .. ":" .. pname,def.harvest_image or (mname .. "_" .. pname .. "harvest"),food,nil,nil,def.harvest_desc)
	end
	else
	if cabbage then
	minetest.register_craftitem(":" .. mname .. ":" .. pname, {
		description = pname:gsub("^%l", string.upper),
		inventory_image = "[inventorycube{" .. def.top_tiles .. "{" .. def.side_tiles .. "{" .. def.side_tiles,
	})
	else
	minetest.register_craftitem(":" .. mname .. ":" .. pname, {
		description = pname:gsub("^%l", string.upper),
		inventory_image = (def.harvest_image or (mname .. "_" .. pname .. "harvest")) .. ".png",
	})
	end
	end
	if def.cookit then
		minetest.register_craft({
			type = "cooking",
			output = mname .. ":cooked_" .. pname,
			recipe = mname .. ":" .. pname,
		})
		local coverlay = "^[colorize:black:150"
		if food then
			local cookit = farming_cookfood(food)
			if cabbage then
				register_food(mname .. ":cooked_" .. pname,"([inventorycube{" .. def.top_tiles .. "{" .. def.side_tiles .. "{" .. def.side_tiles_wopng  ..".png)" .. coverlay .. "^cutoffmarginmask.png^[makealpha:255,0,255",cookit,nil,true)

			else
				register_food(mname .. ":cooked_" .. pname,(def.harvest_image or (mname .. "_" .. pname .. "harvest")) .. ".png" .. coverlay,cookit,nil,true)
			end
		else
			if cabbage then
				minetest.register_craftitem(":" .. mname .. ":cooked_" .. pname, {
				description = pname:gsub("^%l", string.upper),
				inventory_image = "([inventorycube{" .. def.top_tiles .. "{" .. def.side_tiles .. "{" .. def.side_tiles_wopng  ..".png)" .. coverlay})
			else
				minetest.register_craftitem(":" .. mname .. ":cooked_" .. pname, {
				description = pname:gsub("^%l", string.upper),
				inventory_image = (def.harvest_image or (mname .. "_" .. pname .. "harvest")) .. ".png" .. coverlay})
			end
		end
	end

	-- Register growing steps
	for i=1,def.steps do
		local drop = {
			items = {
				{items = {mname .. ":" .. pname}, rarity = 9 - i},
				{items = {mname .. ":" .. pname}, rarity= 18 - i * 2},
				{items = {mname .. ":seed_" .. pname}, rarity = 9 - i},
				{items = {mname .. ":seed_" .. pname}, rarity = 18 - i * 2},
			}
		}
		local nodegroups = {snappy = 3, flammable = 2, plant = 1, not_in_creative_inventory = 1, attached_node = 1}
		nodegroups[pname] = i
		if generatetextures then
		minetest.register_node(mname .. ":" .. pname .. "_" .. i, {
			drawtype = "plantlike",
			waving = 1,
			--visual_size = {x = 1.2,y = 0.2--[[1.2*(i/def.steps)]],z = 1.2},
			tiles = {"transparent100.png^[lowpart:" .. tostring(math.floor(100*i/def.steps)) .. ":" .. mname .. "_" .. pname .. "crop.png^[colorize:green:0"..tostring(math.floor((startgreenvalue or 120)*(1-(i/def.steps))))},
			paramtype = "light",
			walkable = false,
			buildable_to = true,
			drop = drop,
			selection_box = {
				type = "fixed",
				fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
			},
			groups = nodegroups,
			sounds = default.node_sound_leaves_defaults(),
		})
		elseif generatedtextures then
		minetest.register_node(mname .. ":" .. pname .. "_" .. i, {
			drawtype = "plantlike",
			waving = 1,
			--visual_size = {x = 1.2,y = 0.2--[[1.2*(i/def.steps)]],z = 1.2},
			tiles = {"z" .. pname .. tostring(100-(i*10)) .. "_.png^[colorize:green:0"..tostring(math.floor((startgreenvalue or 120)*(1-(i/def.steps))))},
			paramtype = "light",
			walkable = false,
			buildable_to = true,
			drop = drop,
			selection_box = {
				type = "fixed",
				fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
			},
			groups = nodegroups,
			sounds = default.node_sound_leaves_defaults(),
		})
		elseif cabbage then
		local green = "^[colorize:green:0"..tostring(math.floor((startgreenvalue or 120)*(1-(i/def.steps))))
		local nodebox = cabbage_defbox(((i/def.steps)*0.8)+0.1)
		local cabbage_num = tostring(math.floor(100-((i*9)+10)))
		--local cabbage_num = tostring(100-i)
		minetest.register_node(mname .. ":" .. pname .. "_" .. i, {
			drawtype = "nodebox",
			--waving = 1,
			node_box = nodebox,
			tiles = {"z" .. def.top_tiles_wopng .. cabbage_num .. "_.png","z" .. def.top_tiles_wopng .. cabbage_num .. "_.png","z" .. def.side_tiles_wopng .. cabbage_num .. "_.png"},
			paramtype = "light",
			--walkable = false,
			--buildable_to = true,
			drop = drop,
			selection_box = nodebox,
			groups = nodegroups,
			sounds = default.node_sound_leaves_defaults(),
		})
		else
		minetest.register_node(mname .. ":" .. pname .. "_" .. i, {
			drawtype = "plantlike",
			waving = 1,
			--visual_size = 1.2,
			tiles = {mname .. "_" .. pname .. "_" .. i .. ".png"},
			paramtype = "light",
			walkable = false,
			buildable_to = true,
			drop = drop,
			selection_box = {
				type = "fixed",
				fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
			},
			groups = nodegroups,
			sounds = default.node_sound_leaves_defaults(),
		})
		end
	end
--#################################################################################################
	if not def.no_hobbit_crops then
		local i = def.steps
		table.insert(farming_hobbitcrops,mname .. ":" .. pname .. "hobbitcrop")
		local drop = {
			items = {
				{items = {mname .. ":" .. pname}, rarity = 9 - i},
				{items = {mname .. ":" .. pname}, rarity= 18 - i * 2},
				{items = {mname .. ":seed_" .. pname}, rarity = 9 - i},
				{items = {mname .. ":seed_" .. pname}, rarity = 18 - i * 2},
			}
		}
		local nodegroups = {snappy = 3, flammable = 2, plant = 1, not_in_creative_inventory = 1, attached_node = 1}
		nodegroups[pname] = i
		if generatetextures then
		minetest.register_node(mname .. ":" .. pname .. "hobbitcrop", {
			drawtype = "plantlike",
			waving = 1,
			--visual_size = {x = 1.2,y = 0.2--[[1.2*(i/def.steps)]],z = 1.2},
			tiles = {"transparent100.png^[lowpart:" .. tostring(math.floor(100*i/def.steps)) .. ":" .. mname .. "_" .. pname .. "crop.png^[colorize:green:0"..tostring(math.floor((startgreenvalue or 120)*(1-(i/def.steps))))},
			paramtype = "light",
			walkable = false,
			sunlight_propagates = true,
			buildable_to = true,
			drop = drop,
			selection_box = {
				type = "fixed",
				fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
			},
			groups = nodegroups,
			sounds = default.node_sound_leaves_defaults(),
	can_dig = function(pos, player)
		add_to_law_status(player:get_player_name(),lawname or "hudwelshlaw",1)
		return true
	end
		})
		elseif generatedtextures then
		minetest.register_node(mname .. ":" .. pname .. "hobbitcrop", {
			drawtype = "plantlike",
			waving = 1,
			--visual_size = {x = 1.2,y = 0.2--[[1.2*(i/def.steps)]],z = 1.2},
			tiles = {"z" .. pname .. tostring(100-(i*10)) .. "_.png^[colorize:green:0"..tostring(math.floor((startgreenvalue or 120)*(1-(i/def.steps))))},
			paramtype = "light",
			walkable = false,
			buildable_to = true,
			sunlight_propagates = true,
			drop = drop,
			selection_box = {
				type = "fixed",
				fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
			},
			groups = nodegroups,
			sounds = default.node_sound_leaves_defaults(),
	can_dig = function(pos, player)
		add_to_law_status(player:get_player_name(),lawname or "hudwelshlaw",1)
		return true
	end
		})
		elseif cabbage then
		local green = "^[colorize:green:0"..tostring(math.floor((startgreenvalue or 120)*(1-(i/def.steps))))
		local nodebox = cabbage_defbox(((i/def.steps)*0.8)+0.1)
		local cabbage_num = tostring(math.floor(100-((i*9)+10)))
		--local cabbage_num = tostring(100-i)
		minetest.register_node(mname .. ":" .. pname .. "hobbitcrop", {
			drawtype = "nodebox",
			--waving = 1,
			node_box = nodebox,
			tiles = {"z" .. def.top_tiles_wopng .. cabbage_num .. "_.png","z" .. def.top_tiles_wopng .. cabbage_num .. "_.png","z" .. def.side_tiles_wopng .. cabbage_num .. "_.png"},
			sunlight_propagates = true,
			paramtype = "light",
			--walkable = false,
			--buildable_to = true,
			drop = drop,
			selection_box = nodebox,
			groups = nodegroups,
			sounds = default.node_sound_leaves_defaults(),
	can_dig = function(pos, player)
		add_to_law_status(player:get_player_name(),lawname or "hudwelshlaw",1)
		return true
	end
		})
		else
		minetest.register_node(mname .. ":" .. pname .. "hobbitcrop", {
			drawtype = "plantlike",
			waving = 1,
			--visual_size = 1.2,
			tiles = {mname .. "_" .. pname .. "_" .. i .. ".png"},
			paramtype = "light",
			walkable = false,
			buildable_to = true,
			sunlight_propagates = true,
			drop = drop,
			selection_box = {
				type = "fixed",
				fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
			},
			groups = nodegroups,
			sounds = default.node_sound_leaves_defaults(),
	can_dig = function(pos, player)
		add_to_law_status(player:get_player_name(),lawname or "hudwelshlaw",1)
		return true
	end
		})
		end
	end
--#################################################################################################
	-- Growing ABM
	minetest.register_abm({
		nodenames = {"group:" .. pname, "group:seed"},
		neighbors = {"group:soil"},
		interval = 9,
		chance = math.max(1,math.floor(20*((def.growtime or def.steps)/def.steps))),
		action = function(pos, node)
			local plant_height = minetest.get_item_group(node.name, pname)

			-- return if already full grown
			if plant_height == def.steps then
				return
			end

			local node_def = minetest.registered_items[node.name] or nil

			-- grow seed
			if minetest.get_item_group(node.name, "seed") and node_def.fertility then
				local can_grow = false
				local soil_node = minetest.get_node_or_nil({x = pos.x, y = pos.y - 1, z = pos.z})
				if not soil_node then
					return
				end
				for _, v in pairs(node_def.fertility) do
					if minetest.get_item_group(soil_node.name, v) ~= 0 then
						can_grow = true
					end
				end
				if can_grow then
					minetest.set_node(pos, {name = node.name:gsub("seed_", "") .. "_1"})
				end
				return
			end

			-- check if on wet soil
			pos.y = pos.y - 1
			local n = minetest.get_node(pos)
			if minetest.get_item_group(n.name, "soil") < 3 then
				return
			end
			pos.y = pos.y + 1

			-- check light
			local ll = minetest.get_node_light(pos)

			if not ll or ll < def.minlight or ll > def.maxlight then
				return
			end

			-- grow
			minetest.set_node(pos, {name = mname .. ":" .. pname .. "_" .. plant_height + 1})
		end
	})

	-- Return
	local r = {
		seed = mname .. ":seed_" .. pname,
		harvest = mname .. ":" .. pname
	}
	return r
end
local function mushroom_defbox(i)
	i = i/10
	return {-0.25*i,-0.5,-0.25*i,0.25*i,i-0.5,0.25*i}
end
farming.register_mushroom = function(name, def,food)
	local mname = name:split(":")[1]
	local pname = name:split(":")[2]

	-- Check def table
	if not def.description then
		def.description = "Seed"
	end
	if not def.inventory_image then
		def.inventory_image = "unknown_item.png"
	end
	if not def.steps then
		return nil
	end
	if not def.minlight then
		def.minlight = 0
	end
	if not def.maxlight then
		def.maxlight = 1
	end
	if not def.fertility then
		def.fertility = {}
	end

	-- Register seed
	local g = {seed = 1, snappy = 3, attached_node = 1}
	for k, v in pairs(def.fertility) do
		g[v] = 1
	end
	minetest.register_node(":" .. mname .. ":seed_" .. pname, {
		description = def.description,
		tiles = {def.harvest_image},
		inventory_image = def.harvest_image,
		wield_image = def.harvest_image,
		drawtype = "signlike",
		groups = g,
		paramtype = "light",
		paramtype2 = "wallmounted",
		walkable = false,
		sunlight_propagates = true,
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
		},
		fertility = def.fertility,
		sounds = default.node_sound_dirt_defaults({
			dug = {name = "default_grass_footstep", gain = 0.2},
			place = {name = "default_place_node", gain = 0.25},
		}),

		on_place = function(itemstack, placer, pointed_thing)
			return farming.place_seed(itemstack, placer, pointed_thing, mname .. ":seed_" .. pname)
		end,
	})

	-- Register harvest
	if food then
	register_food(mname .. ":" .. pname,mname .. "_" .. pname .. "harvest",food)
	else
	minetest.register_craftitem(":" .. mname .. ":" .. pname, {
		description = pname:gsub("^%l", string.upper),
		inventory_image = mname .. "_" .. pname .. "harvest.png",
	})end

	-- Register growing steps
	for i=1,10 do
		local drop = {
			items = {
				{items = {mname .. ":" .. pname}, rarity = 9 - i},
				{items = {mname .. ":" .. pname}, rarity= 18 - i * 2},
				{items = {mname .. ":seed_" .. pname}, rarity = 9 - i},
				{items = {mname .. ":seed_" .. pname}, rarity = 18 - i * 2},
			}
		}
		local nodegroups = {snappy = 3, flammable = 2, plant = 1,mushroom = 1, not_in_creative_inventory = 1, attached_node = 1}
		nodegroups[pname] = i
		minetest.register_node(mname .. ":" .. pname .. "_" .. i, {
			--drawtype = "plantlike",
			drawtype = "mesh",
			mesh = "mushroomg" .. tostring(i) .. ".obj",
			waving = 1,
			visual_scale = {x = 1,y = 1,z = 1},
			tiles = {mname .. "_" .. pname .. "crop1.png"},
			
			paramtype = "light",
			walkable = false,
			buildable_to = true,
			drop = drop,
			selection_box = {
				type = "fixed",
				fixed = mushroom_defbox(i),
			},
			groups = nodegroups,
			sounds = default.node_sound_leaves_defaults(),
		})
	end

	-- Growing ABM
	minetest.register_abm({
		nodenames = {"group:" .. pname, "group:seed"},
		neighbors = {"group:soil"},
		interval = 9,
		chance = math.max(1,math.floor(20*((def.growtime or def.steps)/def.steps))),
		action = function(pos, node)
			local plant_height = minetest.get_item_group(node.name, pname)

			-- return if already full grown
			if plant_height == 10 then
				return
			end

			local node_def = minetest.registered_items[node.name] or nil

			-- grow seed
			if minetest.get_item_group(node.name, "seed") and node_def.fertility then
				local can_grow = false
				local soil_node = minetest.get_node_or_nil({x = pos.x, y = pos.y - 1, z = pos.z})
				if not soil_node then
					return
				end
				for _, v in pairs(node_def.fertility) do
					if minetest.get_item_group(soil_node.name, v) ~= 0 then
						can_grow = true
					end
				end
				if can_grow then
					minetest.set_node(pos, {name = node.name:gsub("seed_", "") .. "_1"})
				end
				return
			end

			-- check if on wet soil
			pos.y = pos.y - 1
			local n = minetest.get_node(pos)
			if minetest.get_item_group(n.name, "soil") < 3 then
				return
			end
			pos.y = pos.y + 1

			-- check light
			local ll = minetest.get_node_light(pos)

			if not ll or ll < def.minlight or ll > def.maxlight then
				return
			end

			-- grow
			minetest.set_node(pos, {name = mname .. ":" .. pname .. "_" .. plant_height + 1})
		end
	})

	-- Return
	local r = {
		seed = mname .. ":seed_" .. pname,
		harvest = mname .. ":" .. pname
	}
	return r
end
