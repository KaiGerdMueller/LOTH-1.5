local farming_food_constant = 100
local whinebarrelnutritions = {math.floor(360/farming_food_constant),0,0,math.floor(3403/farming_food_constant),500}
local beerbarrelnutritions = {math.floor(182/farming_food_constant),0,math.floor(10000/farming_food_constant),0,500}
minetest.register_node("brewing:barrel", {
	description = "empty barrel",
	tiles = {"barrel_top_closed.png", "barrel_top_closed.png", "barrel_side.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = default.node_sound_wood_defaults(),

	on_place = minetest.rotate_node
})
minetest.register_craft({
	output = 'brewing:barrel',
	recipe = {
		{'default:wood', 'default:steel_ingot', 'default:wood'},
		{'default:wood', '', 'default:wood'},
		{'default:wood', 'default:steel_ingot', 'default:wood'},
	}
})
local function register_alcohol(name,nutrition,time,crafting_mat)
minetest.register_craft({
	type = "shapeless",
	output = "brewing:" .. name .. "barrel",
	recipe = {crafting_mat,crafting_mat,crafting_mat,crafting_mat,crafting_mat,crafting_mat, "brewing:barrel"},
})
minetest.register_node("brewing:" .. name .. "barrel", {
	description = name .. " barrel",
	tiles = {name .. "_barrel_top_closed.png", name .. "_barrel_top_closed.png", "barrel_side.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = default.node_sound_wood_defaults(),
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		minetest.get_node_timer(pos):start(time)
	end,
	on_timer = function(pos, elapsed)
		minetest.set_node(pos,{name = "brewing:old_" .. name .. "barrel"})
	end
})
minetest.register_node("brewing:old_" .. name .. "barrel", {
	description = "ripe " .. name .. " barrel",
	tiles = {name .. "_barrel_top_closed.png", name .. "_barrel_top_closed.png", "barrel_side.png"},
	paramtype2 = "facedir",
	stack_max = 1,
	is_ground_content = false,
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = default.node_sound_wood_defaults(),
	on_place = minetest.rotate_node,
	on_use = function(itemstack, dropper)
		name = dropper:get_player_name()
		local table = playernutritions[name]
		for ind,ele in pairs(table) do
			if nutrition[ind] then
				table[ind] = math.max(ele + nutrition[ind],0)
			end
		end
		update_health_data_file(name,table)
		return ItemStack("brewing:barrel")
	end,
})
end
register_alcohol("beer",beerbarrelnutritions,1500,"farming:barley")
register_alcohol("whine",whinebarrelnutritions,1500,"farming:berry_bush")



