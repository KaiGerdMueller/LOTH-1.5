-- Global farming namespace
farming = {}
farming.path = minetest.get_modpath("farming")
farming_food_constant = 10
-- Load files
dofile(farming.path .. "/api.lua")
dofile(farming.path .. "/nodes.lua")
dofile(farming.path .. "/hoes.lua")
local function register_food(name,imagename,vitality,second_ffoood,flag_png)
local ii = ""
if flag_png then
ii = imagename
else
ii = imagename .. ".png"
end
minetest.register_craftitem(name, {
	description =  (name:split(":")[2]),
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
--	harvest_mass = 74.8,(t/ha)
-- WHEAT
farming.register_plant("farming:wheat", {
	description = "Wheat seed",
	no_hobbit_crops = true,
	inventory_image = "farming_wheat_seed.png",
	steps = 50,
	growtime = 175,
	harvest_mass = 74.8,--(dt/ha)####################
	minlight = 13,
	maxlight = default.LIGHT_MAX,
	fertility = {"grassland"}
},true)
farming.register_plant("farming:barley", {
	no_hobbit_crops = true,
	description = "Barley seed",
	inventory_image = "farming_barley_seed.png",
	steps = 50,
	growtime = 100,
	harvest_mass = 74.7,--(dt/ha)####################
	minlight = 13,
	maxlight = default.LIGHT_MAX,
	fertility = {"grassland"}
},true)
farming.register_plant("farming:carrot", {
	description = "Carrot seed",
	inventory_image = "farming_carrot_seed.png",
	steps = 50,
	growtime = 70,
	cookit = true,
	harvest_mass = 611.9,--(dt/ha)####################
	minlight = 13,
	maxlight = default.LIGHT_MAX,
	fertility = {"grassland"}
},true,180,{2,0,1,37,0})--########################################
farming.register_plant("farming:arugula", {
	description = "Arugula seed",
	inventory_image = "farming_arugula_seed.png",
	harvest_image = "zarugula0_",
	steps = 100,
	cookit = true,
	harvest_mass = 90,--(dt/ha)####################ESTIMATED
	growtime = 42,
	minlight = 0,
	maxlight = default.LIGHT_MAX,
	fertility = {"grassland"}
},false,180,{1,1,5,12,0},true)--###################################
farming.register_plant("farming:corn", {
	description = "Corn seed",
	no_hobbit_crops = true,
	inventory_image = "farming_corn_seed.png",
	steps = 50,
	cookit = true,
	harvest_mass = 436,--(dt/ha)####################
	growtime = 110,
	minlight = 13,
	maxlight = default.LIGHT_MAX,
	fertility = {"grassland"},
	notfood = true
},false,180,{18,7,18,9,0},true)--##################################
farming.register_plant("farming:radish", {
	description = "radish seed",
	inventory_image = "farming_radish_seed.png",
	harvest_image = "radish_harvest",
	steps = 50,
	cookit = true,
	growtime = 30,
	harvest_mass = 348.4,--(dt/ha)####################
	minlight = 13,
	maxlight = default.LIGHT_MAX,
	fertility = {"grassland"}
},false,180,{1,0,1,4,0},true)--####################################
farming.register_plant("farming:kale", {
	description = "kale seed",
	inventory_image = "farming_kale_seed.png",
	harvest_image = "zkale0_",
	steps = 50,
	cookit = true,
	harvest_mass = 146.2,--(dt/ha)####################
	growtime = 90,
	minlight = 13,
	maxlight = default.LIGHT_MAX,
	fertility = {"grassland"}
},false,180,{2,1,8,46,0},true)--###################################
farming.register_plant("farming:kohlrabi", {
	description = "kohlrabi seed",
	inventory_image = "farming_kohlrabi_seed.png",
	harvest_image = "kohlrabi_harvest",
	steps = 50,
	cookit = true,
	growtime = 84,
	harvest_mass = 335.3,--(dt/ha)####################
	minlight = 13,
	maxlight = default.LIGHT_MAX,
	fertility = {"grassland"}
},false,180,{1,0,3,13,0},true)--###################################
farming.register_plant("farming:tomato", {
	description = "tomato seed",
	inventory_image = "farming_tomato_seed.png",
	harvest_image = "tomato_harvest",
	steps = 50,
	cookit = true,
	harvest_mass =  2846.4,--(dt/ha)####################
	growtime = 150,
	minlight = 13,
	maxlight = default.LIGHT_MAX,
	fertility = {"grassland"}
},false,180,{1,0,1,5,0},true)--####################################
farming.register_plant("farming:berry_bush", {
	description = "berry bush seed",
	inventory_image = "farming_berry_seed.png",
	harvest_image = "berry_bush_harvest",
	harvest_mass =  53,--(dt/ha)####################
	steps = 50,
	harvest_desc = "berries",
	growtime = 240,
	minlight = 13,
	maxlight = default.LIGHT_MAX,
	fertility = {"grassland"}
},false,180,{3,1,2,6,0},true)--####################################
farming.register_plant("farming:onion", {
	description = "onion seed",
	inventory_image = "farming_onion_seed.png",
	harvest_image = "onion_harvest",
	steps = 50,
	cookit = true,
	harvest_mass =  431.1,--(dt/ha)####################
	growtime = 150,
	minlight = 13,
	maxlight = default.LIGHT_MAX,
	fertility = {"grassland"}
},false,180,{2,0,2,3,0},true)--####################################
farming.register_plant("farming:turnips", {
	description = "turnips seed",
	inventory_image = "farming_turnips_seed.png",
	harvest_image = "turnips_harvest",
	steps = 50,
	cookit = true,
	growtime = 5,
	harvest_mass= 500,--(dt/ha)####################
	minlight = 13,
	maxlight = default.LIGHT_MAX,
	fertility = {"grassland"}
},false,180,{1,0,1,5,0},true)--#####################################
farming.register_plant("farming:ruhbarb", {
	description = "ruhbarb seed",
	inventory_image = "farming_ruhbarb_seed.png",
	harvest_image = "ruhbarb_harvest",
	steps = 50,
	cookit = true,
	growtime = 150,
	harvest_mass = 324.5,--(dt/ha)####################
	minlight = 13,
	maxlight = default.LIGHT_MAX,
	fertility = {"grassland"}
},false,180,{1,0,1,3,0},true)--####################################
farming.register_plant("farming:potato", {
	description = "potato seed",
	inventory_image = "farming_potato_seed.png",
	harvest_image = "potato_harvest",
	steps = 50,
	cookit = true,
	notfood = true,
	growtime = 90,
	harvest_mass= 398.4,--(dt/ha)####################
	minlight = 13,
	maxlight = default.LIGHT_MAX,
	fertility = {"grassland"}
},false,180,{4,0,4,7,0},true)--####################################
farming.register_plant("farming:spinach", {
	description = "spinach seed",
	inventory_image = "farming_spinach_seed.png",
	harvest_image = "zspinach0_",
	steps = 10,
	cookit = true,
	harvest_mass = 177.7,--(dt/ha)####################
	growtime = 56,
	minlight = 13,
	maxlight = default.LIGHT_MAX,
	fertility = {"grassland"}
},false,180,{1,0,5,30,0},true)--###################################
farming.register_plant("farming:pipeweed", {
	description = "pipeweed seed",
	no_hobbit_crops = true,
	inventory_image = "farming_pipeweed_seed.png",
	harvest_image = "zpipeweed0_",
	steps = 50,
	cookit = true,
	growtime = 147,
	minlight = 13,
	harvest_mass = 25,--(dt/ha)####################
	maxlight = default.LIGHT_MAX,
	fertility = {"grassland"}
},false,180,nil,true)
farming.register_plant("farming:watercress", {
	description = "watercress seed",
	inventory_image = "farming_watercress_seed.png",
	harvest_image = "zwatercress0_",
	steps = 50,
	cookit = true,
	growtime = 14,
	harvest_mass = 45,--(dt/ha)####################
	minlight = 13,
	maxlight = default.LIGHT_MAX,
	fertility = {"grassland"}
},false,180,{1,0,4,17,0},true)--###################################
farming.register_mushroom("farming:mushroom_brown", {
	description = "brown mushroom spores",
	harvest_image = "farming_mushroom_brown_seed.png",
	steps = 10,
	growtime = 36,
	cookit = true,
	harvest_mass = 1400,--(dt/ha)####################
	minlight = 0,
	maxlight = 2,
	fertility = {"grassland"}
},true,{1,0,6,2,0})--##############################################
farming.register_plant("farming:cabbage", {
	description = "cabbage seed",
	inventory_image = "farming_cabbage_seed.png",
	steps = 50,
	cookit = true,
	growtime = 180,
	top_tiles = "cabbage_top.png",
	harvest_mass = 	429.0,--(dt/ha)####################
	side_tiles = "cabbage.png",
	side_tiles_wopng = "cabbage",
	top_tiles_wopng = "cabbage_top",
	minlight = 13,
	maxlight = default.LIGHT_MAX,
	fertility = {"grassland"}
},false,180,{1,0,2,8,0},false,true)--##############################
minetest.register_craftitem("farming:flour", {
	description = "Flour",
	inventory_image = "farming_flour.png",
})
farming.register_plant("farming:melon", {
	description = "melon seed",
	inventory_image = "farming_melon_seed.png",
	steps = 50,
	growtime = 120,
	top_tiles = "melon_top.png",
	side_tiles = "melon.png",
	side_tiles_wopng = "melon",
	harvest_mass = 664.321,--(dt/ha)####################
	top_tiles_wopng = "melon_top",
	minlight = 13,
	maxlight = default.LIGHT_MAX,
	fertility = {"grassland"}
},false,180,{2,0,1,3,0},false,true)--##############################
farming.register_plant("farming:pumpkin", {
	description = "pumpkin seed",
	inventory_image = "farming_pumpkin_seed.png",
	steps = 50,
	growtime = 120,
	cookit = true,
	notfood = true,
	top_tiles = "pumpkin_top.png",
	side_tiles = "pumpkin.png",
	harvest_mass = 284.7,--(dt/ha)####################
	side_tiles_wopng = "pumpkin",
	top_tiles_wopng = "pumpkin_top",
	minlight = 13,
	maxlight = default.LIGHT_MAX,
	fertility = {"grassland"}
},false,180,{1,0,2,20,0},false,true)--#############################
--[[minetest.register_craftitem("farming:bread", {
	description = "Bread",
	inventory_image = "farming_bread.png",
	on_use = minetest.item_eat(5),
})]]
register_food("farming:bread","bread",{14*farming_food_constant,0,0,0,0})
--ENERGY FAT PROTEIN OTHER WATER
--kale {2,1,8,46,0} 60d 2kg/acre
--rhubarb {1,0,1,3,0}
--cabbage {1,0,2,8,0}
--radish {1,0,1,4,0}
--tomato {1,0,1,5,0}
--melon {2,0,1,3,0} 22 kg/acre
--kohlrabi {1,0,3,13,0}
--turnips {1,0,1,5,0}
--watercress {1,0,4,17,0}
--potato {4,0,4,7,0}
--spinach {1,0,5,30,0}
--pumpkin {1,0,2,20,0}
--corn {18,7,18,9,0} 5kg/ac
--berries #rasp {3,1,2,6,0}
--onion {2,0,2,3,0}
--arugula {1,1,5,12,0}
--carrot {2,0,1,37,0}
register_food("farming:meat","meat",{13*farming_food_constant,29*farming_food_constant,50*farming_food_constant,9*farming_food_constant,0},{nutrition = {-20*farming_food_constant,-20*farming_food_constant,-20*farming_food_constant,-20*farming_food_constant,-20*farming_food_constant},chanche = 6})
register_food("farming:jelly","jelly",{2*farming_food_constant,0,20*farming_food_constant,15*farming_food_constant,0},{nutrition = {-100*farming_food_constant,-100*farming_food_constant,-100*farming_food_constant,-100*farming_food_constant,-100*farming_food_constant},chanche = 3})
register_food("farming:meat_cooked","cookedmeat3",{12*farming_food_constant,25*farming_food_constant,32*farming_food_constant,2*farming_food_constant,0})
register_food("farming:jelly_cooked","jelly_cooked",{1*farming_food_constant,0,15*farming_food_constant,10*farming_food_constant,0})
--register_food("farming:meat","meat",{10,10,10,,0})
minetest.register_craft({
	type = "shapeless",
	output = "farming:flour",
	recipe = {"farming:wheat", "farming:wheat", "farming:wheat", "farming:wheat"}
})

minetest.register_craft({
	type = "cooking",
	cooktime = 15,
	output = "farming:bread",
	recipe = "farming:flour"
})
minetest.register_craft({
	type = "cooking",
	cooktime = 15,
	output = "farming:jelly",
	recipe = "farming:jelly_cooked"
})
-- Cotton
farming.register_plant("farming:cotton", {
	no_hobbit_crops = true,
	description = "Cotton seed",
	inventory_image = "farming_cotton_seed.png",
	steps = 8,
	growtime = 120,
	minlight = 13,
	maxlight = default.LIGHT_MAX,
	fertility = {"grassland", "desert"}
})
minetest.register_alias("farming:string", "farming:cotton")

minetest.register_craft({
	output = "wool:white",
	recipe = {
		{"farming:cotton", "farming:cotton"},
		{"farming:cotton", "farming:cotton"},
	}
})

-- Straw
minetest.register_craft({
	output = "farming:straw 3",
	recipe = {
		{"farming:wheat", "farming:wheat", "farming:wheat"},
		{"farming:wheat", "farming:wheat", "farming:wheat"},
		{"farming:wheat", "farming:wheat", "farming:wheat"},
	}
})

minetest.register_craft({
	output = "farming:wheat 3",
	recipe = {
		{"farming:straw"},
	}
})
local pipeweedstack = ItemStack("farming:cooked_pipeweed")
minetest.register_tool("farming:pipe", {
	description = "pipe",
	inventory_image = "hobbitpipe.png",
	range = 0,
	on_use = function(itemstack, user, pointed_thing)
			if (not user:get_inventory():remove_item("main",pipeweedstack):is_empty()) then
			itemstack:add_wear(wear)
			pos = user:getpos()
			pos.y = pos.y +1.5
			user:set_hp(user:get_hp()-1)
				minetest.add_particlespawner({
		amount = 64,
		time = 0.5,
		minpos = pos,
		maxpos = pos,
		minvel = vector.multiply(user:get_look_dir(),2),
		maxvel = vector.multiply(user:get_look_dir(),2),
		minacc = vector.new(),
		maxacc = vector.new(),
		minexptime = 1,
		maxexptime = 2.5,
		minsize = 0.1,
		maxsize = 0.9,
		texture = "tnt_smoke.png",
	})
			return itemstack
			end
	end
})
