playernutritions = {}
playerhealthhuds = {}
playerpoison = {}
playerpoisonhuds = {}
local armor_register = {}
local mining_players_with_black_skies = {}
local normal_armor_of_player = {}
local last_armor_values_of_player = {}
local healthbar_chat_command_removal = true
health_data_file_name = minetest.get_worldpath() .. "/players/"
maxnutritions= {999,999,999,999,999}
minetest.register_on_mapgen_init(function()
minetest.set_mapgen_params({mgname = "v7"})
end)
core.get_node_group = minetest.get_item_group
function get_player_healthvals(name)
	local input = io.open(minetest.get_worldpath() .. "/players/" .. name .. "healthvals.txt", "r")
	if input then
		local data = input:read("*all")
		if data then
			db({data})
			local table = {}
			local index = 1
			for i in string.gmatch(data, '([^#]+)') do
				db({i})
				table[index] = tonumber(i)
				index = index+1
			end
			if table[1] then
				return table
			end
		end
        	io.close(input)
	else
	end
end
local function clean_spawn_job_list(tstamp)
local updated = {}
local tstamp = tstamp or math.floor(minetest.get_gametime()/10)
for i,_ in pairs(default_mob_spawn_jobs) do
if not (i < tstamp) then
updated[i] = default_mob_spawn_jobs[i]
else
end
end
default_mob_spawn_jobs = updated
end
if healthbar_chat_command_removal then
minetest.after(0,function()
minetest.chatcommands["grant"] = nil
minetest.chatcommands["teleport"] = nil
end)
end
--[[healthbar_heat_noise = PerlinNoise({
	offset = -1.5,
	scale = 3,--50
	spread = {x = 500, y = 500, z = 500},
	seed = 5349+minetest.get_mapgen_params().seed,
	octaves = 3,
	persist = 0.5,
	lacunarity = 2.0
	--flags = ""
})
healthbar_humidity_noise = PerlinNoise({
	offset = -1.5,
	scale = 3,--50
	spread = {x = 500, y = 500, z = 500},--1000
	seed = 842+minetest.get_mapgen_params().seed,
	octaves = 3,
	persist = 0.5,
	lacunarity = 2.0
	--flags = ""
})]]
local healthbar_noisegen_attempt_counter = 0
local function noisegen()
healthbar_noisegen_attempt_counter = healthbar_noisegen_attempt_counter+1
healthbar_heat_noise = minetest.get_perlin({
	offset = 50,
	scale = 50,
	spread = {x = 1000, y = 1000, z = 1000},
	seed = 5349,
	octaves = 3,--3,
	persist = 0.5,
	lacunarity = 2.0,
	--flags = ""
})
healthbar_height_noise = minetest.get_perlin({
    offset      = 4,
    scale       = 5,
    spread      = {x=600, y=600, z=600},
    seed        = 5934,
    octaves     = 5,
    persistence = 0.6,
    lacunarity  = 2.0,
    flags       = "eased"
 })
healthbar_ulmo_noise = minetest.get_perlin({
    offset      = 4,
    scale       = 5,
    spread      = {x=100, y=100, z=100},
    seed        = 1232,
    octaves     = 8,
    persistence = 0.6,
    lacunarity  = 2.0,
    flags       = "eased"
})
healthbar_humidity_noise = minetest.get_perlin({
	offset = 50,
	scale = 50,
	spread = {x = 1000, y = 1000, z = 1000},
	seed = 842,
	octaves = 3,--3,
	persist = 0.5,
	lacunarity = 2.0,
	--flags = ""
})
if healthbar_noisegen_attempt_counter < 18 and (not (healthbar_humidity_noise and healthbar_heat_noise and healthbar_ulmo_noise and healthbar_height_noise)) then
--error("NOISEGEN GOT RETRIED")
minetest.after(0.05,noisegen)
elseif (not (healthbar_humidity_noise and healthbar_heat_noise and healthbar_ulmo_noise and healthbar_height_noise)) then
error("[ERROR] FATAL ERROR: MAP PRECALC NOISEGEN OR ULMO NOISEGEN FAILED, THIS SHOULD NEVER HAPPEN, TRY AGAIN AND PLEASE CONTACT KGM (LOTH creator)")
end
end
local healthbar_biome_map_points = {}
local healthbar_biome_points = {}
minetest.after(0,noisegen)
minetest.after(0.5,function()
for i,e in pairs(minetest.registered_biomes) do
if not string.find(e.name,"ocean") then
healthbar_biome_points[e.name] = {he = e.heat_point,hu = e.humidity_point}
end
end
for i,e in pairs(minetest.registered_biomes) do
if not string.find(e.name,"ocean") then
if e.name ~= "mountains" then
healthbar_biome_map_points[minetest.registered_nodes[e.node_top].tiles[1]] = {he = e.heat_point,hu = e.humidity_point}
else
healthbar_biome_map_points["default_stone.png"] = {he = e.heat_point,hu = e.humidity_point}
end
end
end
end)
minetest.register_on_mapgen_init(function()
for i,e in pairs(minetest.registered_biomes) do
if not string.find(e.name,"ocean") then
healthbar_biome_points[e.name] = {he = e.heat_point,hu = e.humidity_point}
end
end
for i,e in pairs(minetest.registered_biomes) do
if not string.find(e.name,"ocean") then
if e.name ~= "mountains" then
healthbar_biome_map_points[minetest.registered_nodes[e.node_top].tiles[1]] = {he = e.heat_point,hu = e.humidity_point}
else
healthbar_biome_map_points["default_stone.png"] = {he = e.heat_point,hu = e.humidity_point}
end
end
end
end)
local function get_biome_by_heat_and_humidity(he,hu)
local biome = "ERROR"
local min_dist = 1000000
for i,e in pairs(healthbar_biome_points) do
	local dist = math.sqrt(((e.he-he)*(e.he-he))+((e.hu-hu)*(e.hu-hu)))
	if (dist <= min_dist) then
		min_dist = dist
		biome = i
	end
end
return biome
end
local function get_biome_texture_by_heat_and_humidity(he,hu)
local biome = "ERROR"
local min_dist = 1000000
for i,e in pairs(healthbar_biome_map_points) do
	local dist = math.sqrt(((e.he-he)*(e.he-he))+((e.hu-hu)*(e.hu-hu)))
	if (dist <= min_dist) then
		min_dist = dist
		biome = i
	end
end
return biome
end
local function get_biome_at_pos(pos)
local pos = {x = math.floor(pos.x+0.5),y= math.floor(pos.z+0.5)}
local heat = healthbar_heat_noise:get2d(pos)
local humidity = healthbar_humidity_noise:get2d(pos)
return get_biome_by_heat_and_humidity(heat,humidity)
end
local function get_ground_level_at_pos(pos)
return healthbar_height_noise:get2d({x = math.floor(pos.x+0.5),y= math.floor(pos.z+0.5)})
end
local function get_biome_texture_at_pos(pos)
local pos = {x = math.floor(pos.x+0.5),y= math.floor(pos.z+0.5)}
local heat = healthbar_heat_noise:get2d(pos)
local humidity = healthbar_humidity_noise:get2d(pos)
return get_biome_texture_by_heat_and_humidity(heat,humidity)
end
local function get_map_texture_string(x,y,resolution,texture_size,xy_multiplier,maptable,offset)
--local offset = math.floor((31000/resolution)+0.5)
--local x = x*xy_multiplier
--local y = y*xy_multiplier
local actualmappos = {x = x*resolution,z = y*resolution}
local tex = get_biome_texture_at_pos(actualmappos)
local texture_size_x = texture_size
if x == offset then
texture_size_x = tostring(xy_multiplier)
end
local texture_size_y = texture_size
if y == offset then
texture_size_y = tostring(xy_multiplier)
end
if (get_ground_level_at_pos(actualmappos) >= 0) or (tex == "default_desert_sand.png") or (tex == "mordordust.png") then
table.insert(maptable,"image["..tostring(x*xy_multiplier)..","..tostring(y*xy_multiplier)..";"..texture_size_x..","..texture_size_y..";"..tex.."]")
else
table.insert(maptable,"image["..tostring(x*xy_multiplier)..","..tostring(y*xy_multiplier)..";"..texture_size_x..","..texture_size_y..";map_river_water.png]")
end
end
local healthbar_pos_to_mappos_scale = 1
--local healthbar_pos_to_mappos_offset = 1
local function get_player_look_dir_2d(player)
	local vec2d = player:get_look_dir()
	vec2d.y = 0
	local length = vector.length(vec2d)
	if length < 0.01 then
		--minetest.chat_send_all("NOOOOOOOOOOOOOOOOOOO")
		return {x = 1,y = 0,z = 0}
	else
		return vector.divide(vec2d,length)
	end
end
local function add_player_look_dir_point(x,y,n,d)
	return "image["..tostring(x+(d.x*n)-0.05)..","..tostring(y+(d.z*n)-0.05)..";0.1,0.1;player_look_dir_point.png]"
end
local function add_player_look_dir_points(x,y,n,player)
	local d = get_player_look_dir_2d(player)
	local r = ""
	for i=1,n do
		r = r..add_player_look_dir_point(x,y,i/2,d)
	end
	return r
end
function player_point_addition(player,size)
	local pos = vector.multiply(player:getpos(),healthbar_pos_to_mappos_scale)
	return "image["..tostring(pos.x-(size/2))..","..tostring(pos.z-(size/2))..";"..tostring(size*1.3)..","..tostring(size*1.3)..";player_pos_marking.png]"..add_player_look_dir_points(pos.x,pos.z,3,player)
end
local function get_map_string(resolution,map_size)
local offset = math.floor((31000/resolution)+0.5)
local xy_multiplier = tostring(map_size*resolution/62000)
healthbar_pos_to_mappos_scale = xy_multiplier/resolution
local texture_size = xy_multiplier*1.85
--healthbar_pos_to_mappos_offset = -1.3*xy_multiplier/2
local water_bg_pos = tostring(-(1+(map_size/2)))
local r = "size[0,0;]image["..water_bg_pos..","..water_bg_pos..";"..tostring(map_size+5.5)..","..tostring(map_size+4)..";crafting_book_side.png]"
local t = {}
for x = -offset,offset do
for y = -offset,offset do
get_map_texture_string(x,y,resolution,texture_size,xy_multiplier,t,offset)
end
end
return r..table.concat(t)
end
default_map_formspec = ""
minetest.after(1,function()
if not (healthbar_humidity_noise and healthbar_heat_noise) then
noisegen()
end
default_map_formspec = get_map_string(150,12)
end)
--function healthbar_play_attack_sound(attacked)
--[[minetest.sound_play("tnt_explode.ogg", {
	pos = attacked:getpos(),
	max_hear_distance = 100,
	gain = 10.0,]]
--})
--end
local function maintain_spawn_job_list()
local timestamp = math.floor(minetest.get_gametime()/10)
for _,e in pairs(default_mob_spawn_jobs[timestamp] or {}) do
minetest.add_entity(e.pos,e.entity)
end
if timestamp%6 == 0 then
clean_spawn_job_list(timestamp)
end
end
function update_health_data_file(name,healthvals)
	local input = io.open(health_data_file_name .. name .. "healthvals.txt", "w")
	if input then
 	input:write(table.concat(healthvals, "#"))
	io.close(input)
	end
end
function update_nazgul_data_file()
	local input = io.open(health_data_file_name .. "nzgl.txt", "w")
	if input then
 	input:write(tostring(actual_nazgul_emission))
	io.close(input)
	end
end
function update_sauron_number_data_file()
	local input = io.open(health_data_file_name .. "sron.txt", "w")
	if input then
 	input:write(tostring(actual_sauron_emission))
	io.close(input)
	end
end
function update_poison_hud(name)
	local player = minetest.get_player_by_name(name)
	if playerpoisonhuds[name] then
		player:hud_remove(playerpoisonhuds[name])
	end
	playerpoisonhuds[name] = player:hud_add({
    hud_elem_type = "statbar",
    position = {x=0,y=1},
    size = "",
    text = "poison.png",
    number = math.min(math.ceil(playerpoison[name]/49.5),40),
    alignment = {x=0,y=1},
    offset = {x=0, y=-64},
})
end
function update_poison_data_file(name,healthvals)
	local input = io.open(health_data_file_name .. name .. "poison.txt", "w")
	if input then
 	input:write(tostring(healthvals))
	io.close(input)
	end
end
function nutrition_reduce(player,table)
	local name = player:get_player_name()
	if playernutritions[name] then
		local newnutritions = {}
		for ind,ele in pairs(playernutritions[name]) do
			newnutritions[ind] = math.max(0,ele - table)
		end
		playernutritions[name] = newnutritions
		update_health_data_file(name,newnutritions)
		return true
	end
end
function on_tick_update_poison_data_file(name)
	local player = minetest.get_player_by_name(name)
	playerpoison[name] = math.max(playerpoison[name] - 10,0)
	if playerpoison[name] > 0 then
	playerpoison[name] = math.min(playerpoison[name],999)
	nutrition_reduce(player,math.ceil(playerpoison[name]/2))
	player:set_hp(player:get_hp()-2)
	end
	update_poison_data_file(name,playerpoison[name])
	update_poison_hud(name)
end
function refresh_poison_state(name)
	playerpoison[name] = 0
	update_poison_data_file(name,0)
	update_poison_hud(name)
end
function add_health_table_to_player_health_data(player,table)
	local name = player:get_player_name()
	if playernutritions[name] then
		local newnutritions = {}
		for ind,ele in pairs(playernutritions[name]) do
			newnutritions[ind] = math.max(0,ele + table[ind])
		end
		playernutritions[name] = newnutritions
		update_health_data_file(name,newnutritions)
	end
end
function poisoning_standard(player,table)
	local name = player:get_player_name()
	if playerpoison[name] then
		playerpoison[name] = math.max(playerpoison[name]-table,0)
		update_poison_data_file(name,playerpoison[name])
		return true
	end
end
local function register_creator_cmd()
minetest.register_chatcommand("creator", {
	params = "",
	description = "find out about creator",
	func = function(name, param)
		minetest.chat_send_all("This Subgame was created by Kai Gerd Müller using the default Minetest Subgame minetest_game as base")
	end,
})
end
register_creator_cmd()
minetest.after(1,register_creator_cmd)
minetest.after(3,register_creator_cmd)
minetest.after(10,register_creator_cmd)
function new_poison_storage(max_ammount,charge_ammount,starting_ammount)
	return {
		ammount = starting_ammount or max_ammount,
		charge = function(self)
			self.ammount = math.min(self.ammount + charge_ammount,max_ammount)
			return self
		end,
		poison = function(self,player)
			if not poisoning_standard(player,self.ammount) then
				player:set_hp(player:get_hp()-math.ceil(self.ammount/10))
			end
			self.ammount = 0
			return self
		end
		}
end
function register_player_armor(metal,table,crafting_metal)
n = 0
for i,v in pairs({boots = 1.5,chestplate = 2.5,trousers = 1.5,helmet = 2,shield = 2.5}) do
n = n+1

minetest.register_tool("healthbar:armor_part_" .. metal .. i, {
	description = metal .. i,
	inventory_image = i .. "_blackwhite.png^default_" .. metal ..
			"_metal_overlay.png^" .. i .. "_alphamask.png^[makealpha:255,0,255"
})
local texture = false
local recipe = false
if i == "shield" then
	texture = "3d_shield_" .. metal .. ".png"
	recipe = {
		{crafting_metal, crafting_metal, crafting_metal},
		{crafting_metal, crafting_metal, crafting_metal},
		{'', crafting_metal, ''},
	}
elseif i == "boots" then
	recipe = {
		{crafting_metal, '', crafting_metal},
		{crafting_metal, '', crafting_metal},
	}
elseif i == "trousers" then
	recipe = {
		{crafting_metal, crafting_metal, crafting_metal},
		{crafting_metal, '', crafting_metal},
		{crafting_metal, '', crafting_metal},
	}
elseif i == "helmet" then
	recipe = {
		{crafting_metal, crafting_metal, crafting_metal},
		{crafting_metal, '', crafting_metal},
	}
elseif i == "chestplate"then
	recipe = {
		{crafting_metal, '', crafting_metal},
		{crafting_metal, crafting_metal,crafting_metal},
		{crafting_metal, crafting_metal,crafting_metal},
	}
end
minetest.register_craft({
	output = "healthbar:armor_part_" .. metal .. i,
	recipe = recipe
})
armor_register["healthbar:armor_part_" .. metal .. i] = {shield = (i == "shield"),protected = n,max_protection =1/(v*table.max_protection),max_level = v*(table.max_level or 1),durability = table.durability,textures = texture or "^3d_" .. i .. "_" .. metal .. ".png"}--^3d_" .. i .. "_alphamask.png^[makealpha:255,0,255)"}
--[[(default_" .. metal ..
			"_metal_3d_overlay.png^]]
end
end
register_player_armor("steel",{max_protection = 1,max_level = 0,durability = 0.05},"default:steel_ingot")
register_player_armor("mithril",{max_protection = 1.5,max_level = 0,durability = 1},"default:mithril_ingot")
register_player_armor("bronze",{max_protection = 1.1,max_level = 0,durability = 0.1},"default:bronze_ingot")
register_player_armor("galvorn",{max_protection = 1.4,max_level = 0,durability = 0.8},"default:galvorn_ingot")
function register_food(name,imagename,vitality,second_ffoood,flag_png)
local ii = ""
if flag_png then
ii = imagename
else
ii = imagename .. ".png"
end
minetest.register_craftitem(name, {
	description = (name:split(":")[2]),
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
function register_medecine(name,imagename,vitality,flag_png)
local ii = ""
if flag_png then
ii = imagename
else
ii = imagename .. ".png"
end
minetest.register_craftitem(name, {
	description = (name:split(":")[2]),
	inventory_image = ii,
	on_use = function(itemstack, dropper)
		name = dropper:get_player_name()
		playerpoison[name] = playerpoison[name]-vitality
		update_poison_data_file(name,playerpoison[name])
		update_poison_hud(name)
		itemstack:take_item()
		return itemstack
	end,
})
end
register_medecine("healthbar:athelas_cooked","athelas_cooked",99)
minetest.register_craft({
	type = "cooking",
	output = "healthbar:athelas_cooked",
	recipe = "default:athelasflower",
	cooktime = 810
})
minetest.register_on_joinplayer(function(player)
local name = player:get_player_name()
playerpoison[name] = get_player_poison(name) or 0
update_poison_hud(name)
local table = get_player_healthvals(name) or "ERRNO"
if table == "ERRNO" then
	table = maxnutritions
	update_health_data_file(name,table)
end
playernutritions[name] = table
playerhealthhuds[name] = player:hud_add({
    hud_elem_type = "statbar",
    position = {x=0,y=1},
    size = "",
    text = "health.png",
    number = math.floor(2*math.min(table[1],table[2],table[3],table[4],table[5])/99--[[111]]),
    alignment = {x=0,y=1},
    offset = {x=0, y=-32},
})
end)
local timer = 0
local timer2 = 0
function db(message,category)
	if category == "Debug"then--"VeryImportantMessage" then
	if type(message) ~= string then
		message = table.concat(message,"+")--tostring(message)
	end
	--minetest.chat_send_all(message)
	end
end
local function add_wear_to_armor(player,d)
		db({"ADD_WEAR..."})
	local inv = player:get_inventory():get_list("main")
	for i = 33,38 do
		if inv[i] then
			local data = armor_register[inv[i]:get_name()]
			if data then
				db({"wear_added"})
				inv[i]:add_wear(math.floor((d/data.durability)+0.5))
			end
		else
			db({"CREATIVEINV?????????????!!!!!!!!!!!!!!!!!!!!!"},"VeryImportantMessage")
		end
	end
	player:get_inventory():set_list("main",inv)
end
local player_law_groups = {
[1] = "orcishlaw",
[2] = "dunlendingshlaw",
[3] = "hudwelshlaw",
[4] = "hudwelshlaw",
[5] = "hudwelshlaw",
[6] = "hudwelshlaw",
[7] = "hudwelshlaw"
}
local function is_not_gangsta(player)
	local f = player_fine_group[player] or 3
	if f == 1 then
		return ((not orcishlaw[player]) or (orcishlaw[player] <= 0))
	elseif f == 2 then
		return ((not dunlendingshlaw[player]) or (dunlendingshlaw[player] <= 0))
	elseif f > 2 then
		return ((not hudwelshlaw[player]) or (hudwelshlaw[player] <= 0))
	end
end
minetest.register_on_punchplayer(function(player, hitter)
	pcall(function()
--	healthbar_play_attack_sound(player)
	if hitter then
		local luaent = hitter:get_luaentity()
		if luaent and luaent.damage then
			add_wear_to_armor(player,luaent.damage)
		elseif hitter:is_player() then
			local victim_name =player:get_player_name()
			if is_not_gangsta(victim_name) then
				if player:get_hp() == 0 then
					add_to_law_status(hitter:get_player_name(),player_law_groups[player_fine_group[victim_name] or 3],1000000)
				else
					add_to_law_status(hitter:get_player_name(),player_law_groups[player_fine_group[victim_name] or 3],100)
				end
			end
			local def = hitter:get_wielded_item():get_definition()
			if def then
				local groups = def.damage_groups
				if groups then
					local fleshy = groups.fleshy or true
					if fleshy == true then
						fleshy = 1
						for _,i in pairs(groups) do
							fleshy = math.max(fleshy,i)
						end
					end
					add_wear_to_armor(player,fleshy)
				else
					add_wear_to_armor(player,1)	
				end
			else
				add_wear_to_armor(player,1)
			end
		else
			add_wear_to_armor(player,1)
		end
	else
		add_wear_to_armor(player,1)
	end
	end)
end)
--add_wear_to_armor(player,)
local orc_detecting_swords = {["default:epic_stich"] =ItemStack("default:epic_stich_alert"),["default:epic_orccrist"] =ItemStack("default:epic_orccrist_alert"),["default:epic_stich_sibling"] =ItemStack("default:epic_stich_sibling_alert"),["default:epic_glamdring"] =ItemStack("default:epic_glamdring_alert"),["default:epic_orccrist_glamdring_sibling"] =ItemStack("default:epic_orccrist_glamdring_sibling_alert")}
local orc_detected_swords = {["default:epic_stich_alert"] =ItemStack("default:epic_stich"),["default:epic_orccrist_alert"] =ItemStack("default:epic_orccrist"),["default:epic_stich_sibling_alert"] =ItemStack("default:epic_stich_sibling"),["default:epic_glamdring_alert"] =ItemStack("default:epic_glamdring"),["default:epic_orccrist_glamdring_sibling_alert"] =ItemStack("default:epic_orccrist_glamdring_sibling")}
local function orcs_near(pos,raaa)
	local r = false
	for _,e in pairs(minetest.get_objects_inside_radius(pos,raaa)) do
	local luaent = e:get_luaentity()
	if luaent then
	r = r or luaent.orc or luaent.balrog
	end
	end
	return r
end
--image[X,Y;W,H;texture_name]
local get_sample_item_of_group_mem = {}
local function get_sample_item_of_group(name)
	if get_sample_item_of_group_mem[name] then
		return get_sample_item_of_group_mem[name]
	else
	local d=minetest.registered_items[name] or minetest.registered_nodes[name]
	if d then
		get_sample_item_of_group_mem[name] = name
		return name
	elseif string.find(name,"group:") then
		local g=string.gsub(name, "group:", "")
		for i,e in pairs(minetest.registered_items) do
			local return_i = true
			for gr in string.gmatch(g, '([^, ]+)') do
				if (gr ~= "") and (minetest.get_item_group(i, gr) == 0) then
					--return i
					return_i = false
				end
			end
			if return_i then
				get_sample_item_of_group_mem[name] = i
				return i
				
			end
		end
		for i,e in pairs(minetest.registered_nodes) do
			local return_i = true
			for gr in string.gmatch(g, '([^, ]+)') do
				if (gr ~= "") and (minetest.get_node_group(i, gr) == 0) then
					--return i
					return_i = false
				end
			end
			if return_i then
				get_sample_item_of_group_mem[name] = i
				return i
			end
		end
		get_sample_item_of_group_mem[name] = "no item"
		return "no item"
	elseif minetest.registered_aliases[name] then
		get_sample_item_of_group_mem[name] = minetest.registered_aliases[name]
		return minetest.registered_aliases[name]
	end
	end
end
local function extract_item_texture_out_of_def(d)
	if d then
	if d.inventory_image or d.tiles then
			--db({"Tiles_fOUND"},"VeryImportantMessage")
		if (d.inventory_image ~= "") and (d.inventory_image ~= nil) then
			if type(d.inventory_image) == "table" then
				return d.inventory_image[1]
			else
				return d.inventory_image
			end
		elseif d.tiles and d.tiles[1] and (type(d.tiles[1]) ~= "table") then
			return d.tiles[1]
		end
	else
		return "no_item.png"
	end
	end
end
local function get_item_texture(name)
	local name = get_sample_item_of_group(name)
	local d=minetest.registered_items[name]
	local d2=minetest.registered_nodes[name]
	return extract_item_texture_out_of_def(d2 or d)

end
--[[	if d and (not d2) then
	if d.inventory_image then
		if type(d.inventory_image) == "table" then
			return d.inventory_image[1]
		else
			return d.inventory_image
		end
	elseif d.tiles then
		return d.tiles[1]
	end
	elseif d2 then
	if d2.tiles then
		if type(d2.tiles[1]) ~= "table" then
		if d2.paramtype ~= "light" then
			return minetest.inventorycube(d2.tiles[1],d2.tiles[1],d2.tiles[1])
		else
			return d2.tiles[1]
		end
		end
	end
	end]]
local function get_item_texture_using_def(name,d)
		return get_item_texture(name)
end
local function get_craft_list()
	local crafts = {}
	for i,e in pairs(minetest.registered_items) do
		local l=minetest.get_all_craft_recipes(i)
		local result_tex = get_item_texture_using_def(i,e)
		if l then
		for n,c in pairs(l) do
			local input_tex = {}
			for s,it in pairs(c.items) do
				input_tex[s] =  get_item_texture(it) or "no_item.png"
			end
			local rt = result_tex
			--if c.method == "fuel" then
			--	rt = "fire_basic_flame.png"
			--[[else]]if c.method == "cooking" then
			if rt == nil then
				rt = "fire_basic_flame.png"
			else
				table.insert(input_tex,"fire_basic_flame.png")
			end
			end
			table.insert(crafts,{result = rt,input = input_tex,width = c.width})
		end
		end
	end
	return crafts
end
local craftingbookscale = 4
local function img_form(img,x,y)
	return "image["..tostring(x/craftingbookscale)..","..tostring(y/craftingbookscale)..";"..tostring(1/craftingbookscale)..","..tostring(1/craftingbookscale)..";"..(img or "no_item.png").."]"
end
local function c_form(x,y)
	return "image["..tostring((x-0.1)/craftingbookscale)..","..tostring((y-0.1)/craftingbookscale)..";"..tostring(1.2/craftingbookscale)..","..tostring(1.2/craftingbookscale)..";gui_hotbar_selected.png]"
end
local function craft_form(c,x,y)
	local s = c_form(x,y+1)..img_form(c.result,x,y+1)
	local xo = false
	local yo = false
	local w = false
	if c.width == 0 then
		w = 3
	else
		w = c.width
	end
	for i,e in pairs(c.input) do
		xo = (i-1)%w
		yo = (i-xo)/w
		s=s..c_form(x+2+xo,y+yo)..(img_form(e,x+2+xo,y+yo) or "no_item.png")
	end
	return s
end
local function create_tab_header(n,a)
	local r =  "tabheader[0,-0.5;craftguide_tabs;"
	for i = 1,n-1 do
		r = r..tostring(i)..","
	end
	return r..tostring(n)..";" .. tostring(a) .. ";true;false]"
end
local function create_crafting_side(bg,list,w,h,n,tabs)
	local o = 1+(n*w*h)
	
	local s = "size[9,8;]image[-1,-1;"..tostring(13)..","..tostring(12)..";"..bg.."]"..tabs
	for x=0,w-1 do
		for y=0,h-1 do
			local c = list[o+x+(y*w)]
			if c then
				s=s..craft_form(c,x*6,y*4)
			end
		end
	end
	return s
end
local function alphabetic_string(i)
	local s=""
	local a=false
	while i ~= 0 do
		a=i%26
		i=(i-a)/26
		s=string.char(a+97)..s
	end
	return s
end
local crafting_formspecs = {}
local function create_crafting_books(bg,w,h)
	local list = get_craft_list()
	local max = math.ceil(table.getn(list)/(w*h))
	for i=0,max-1 do
		local tabs = create_tab_header(max,i+1)
		local formspec=create_crafting_side(bg,list,w,h,i,tabs)
		crafting_formspecs[i+1] = formspec
		--local n=":healthbar:book_nr_" .. alphabetic_string(i)
		--table.insert(healthbar_crafting_books,n)
	end
end
minetest.register_craftitem("healthbar:crafting_book",{
		description = "Crafting Book",
		inventory_image = "crafting_book.png",
		groups = {book = 1},
		on_use = function(_,user)
			minetest.show_formspec(user:get_player_name(), "crafting_book",crafting_formspecs[1])
		end,
		stack_max=1
})
minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname == "crafting_book" then
		if fields.craftguide_tabs then
			minetest.show_formspec(player:get_player_name(), "crafting_book", crafting_formspecs[tonumber(fields.craftguide_tabs)])
		end
	end
end)
minetest.after(0,function()create_crafting_books("crafting_book_side.png",3*math.floor(craftingbookscale/2),4*math.floor(craftingbookscale/2))end)
local function get_wield_item_texture(p)
	local i = p:get_wielded_item()
	local newitem = orc_detecting_swords[i:get_name()] or false
	local newitem2 = orc_detected_swords[i:get_name()] or false
	if newitem and orcs_near(vector.add(p:getpos(),{x=0,y=30,z=0}),60)then
	p:set_wielded_item(newitem)
	i = newitem
	elseif newitem2 and (not orcs_near(vector.add(p:getpos(),{x=0,y=30,z=0}),60))then
	p:set_wielded_item(newitem2)
	i = newitem2
	end
	if (not i:is_empty()) and  i:is_known() then
		local d = i:get_definition()
		--db({d.tiles[1]},"VeryImportantMessage")
		if d.inventory_image or d.tiles then
			--db({"Tiles_fOUND"},"VeryImportantMessage")
			db({tostring(d.inventory_image == "")},"VeryImportantMessage")
			if d.inventory_image ~= "" then
				return d.inventory_image
			else
				return d.tiles[1]
			end	
		else
			return "doors_blank.png"
		end
	else
		return "doors_blank.png"
	end
end
local timer3 = 0
local function armorcurve(a,s)
for i = 1,(s or 1) do
	a = (1 - (1 / ((a / 100) + 1)))* 200
end
return a
end
local function levelcurve(a,s)
for i = 1,(s or 1) do
	a = (1 - (1 / (a  + 1)))* 2
end
return a
end
local timer4 = 0
--local timer5 = 0
local function read_sauron_exists()
	local input = io.open(health_data_file_name .. "tbvspofyjtut.txt", "r")
	local data = 1
	if input then
 	data = input:read("*n")
	io.close(input)
	end
	return (data == 1)
end
function healthbar_write_sauron_exists()
	local input = io.open(health_data_file_name .. "tbvspofyjtut.txt", "w")
	if input then
	if healthbar_sauron_exists then
 	input:write("1")
	else
 	input:write("0")
	end
	io.close(input)
	end
end
healthbar_sauron_exists = read_sauron_exists()
local function read_the_ring_is_taken()
	local input = io.open(health_data_file_name .. "tbvspofyjtutsjoh.txt", "r")
	local data = 0
	if input then
 	data = input:read("*n")
	io.close(input)
	end
	return (data == 1)
end
function healthbar_write_the_ring_is_taken()
	local input = io.open(health_data_file_name .. "tbvspofyjtutsjoh.txt", "w")
	if input then
	if healthbar_the_ring_is_taken then
 	input:write("1")
	else
 	input:write("0")
	end
	io.close(input)
	end
end
healthbar_the_ring_is_taken = read_the_ring_is_taken()
local timer5 = 0
minetest.register_globalstep(function(dtime)
	timer = timer+dtime
	timer2 = timer2+dtime
	timer3 = timer3+dtime
	timer4 = timer4+dtime
	timer5 = timer5+dtime
	if timer3 >= 60 then
	timer3 = 0
	collectgarbage("collect")
	--collectgarbage("collect")
	end
	if timer5 >= 300 then
	timer5 = 0
	if math.random(1,12) == 1 then
	for name,bx in pairs(sauron_killed_bosses) do
		if bx["dragons:bat"] and bx["trolls:uruguay"]and bx["nazgul:witchy"] and bx["nazgul:ghost"] and bx["balrog:balrog"] and bx["necromancer:witchy"] and bx["lothwormdragons:seaserpent"] and bx["spiders:shelob"] and not healthbar_the_ring_is_taken then--healthbar_sauron_exists then
			local player = minetest.get_player_by_name(name)
			if player then
				
				minetest.add_entity(player:getpos(),"sauron:sauron")
				--healthbar_sauron_exists = false
				--healthbar_write_sauron_exists()
			end
		end
	end
	end
	--collectgarbage("collect")
	end
	if timer2 >= 3 then
	--pcall(function()
	--if minetest.get_player_by_name("singleplayer") then
	--local playerbiopos = minetest.get_player_by_name("singleplayer"):getpos()
	--minetest.chat_send_all(tostring(get_ground_level_at_pos(playerbiopos)))
	--end)
	--end
	timer2 = 0
	for _,player in ipairs(minetest.get_connected_players()) do
	local name = player:get_player_name()
	local inv = player:get_inventory():get_list("main")
	local armortable = {true,true,true,true,true}
	normal_armor_of_player[player:get_player_name()] = 100
	local armormultipier = normal_armor_of_player[player:get_player_name()]
	local level = 1
	local shieldtex = false
	local d3tex = ""--{}
	for i = 33,38 do
		db({type(inv[i])})
		local index = i-32
		local i = inv[i]
		if i then
		local data = armor_register[i:get_name()]
		if data and armortable[data.protected] then
			--db(data,"VeryImportantMessage")
			if data.shield then
				shieldtex = data.textures
			else
				d3tex = d3tex .. data.textures--"^culumalda_tree_top.png"--data.textures --or ""
			end
			armortable[data.protected] = false
			local quality = (2-(i:get_wear()/65535))
			armormultipier = armormultipier * (data.max_protection/quality)
			db({tostring(data.max_protection == nil)},"VeryImportantMessage")
			level = level * (data.max_level / quality)
			db({"YEY! FOUND ARMOR"})
		end
		else
			db("CREATIVEINV!!!!!!!!!")
		end
	end
	db({"AAAAA"},"VeryImportantMessage")
	db({"^(3d_" .. "helmet" .. "_blackwhite.png^default_" .. "steel" ..
			"_metal_overlay.png" .. "^3d_" .. "helmet" .. "_alphamask.png^[makealpha:255,126,126)"},"VeryImportantMessage")
	db({"BBBB"},"VeryImportantMessage")
	local armorvals = {fleshy =armorcurve(armormultipier,8),level = 1}
	db({armorvals.fleshy},"Debug")
	db({get_default_properties_of_player(name,"textures")},"VeryImportantMessage")
	if player:get_wielded_item():get_name() ~= "default:the_one_ring" then
	default.player_set_textures(player,{shieldtex or "doors_blank.png",get_wield_item_texture(player),(get_default_properties_of_player(name,"textures") or "") .. d3tex})
	else
	default.player_set_textures(player,{"doors_blank.png","doors_blank.png","doors_blank.png"})
	end
	if last_armor_values_of_player[name] ~= armorvals then
	last_armor_values_of_player[name] = armorvals
	player:set_armor_groups(armorvals)
	end
end
end
	if timer4 >= 9 then
	maintain_spawn_job_list()
	timer4 = 0
	end
	if timer >= 10 then
	timer = 0
	local sky_settings = false
	for _,player in ipairs(minetest.get_connected_players()) do
		local pos = player:getpos()
		local name = player:get_player_name()
		on_tick_update_poison_data_file(name)
		if healthbar_damn_values[name] > 998 then
			local playerhp = player:get_hp()
			local pos = player:getpos()
			if minetest.get_node(pos).name == "air" then
				minetest.set_node(pos,{name = "fire:basic_flame"})
			end
			player:set_hp(math.max(playerhp-4,0))
		end
		if pos.y > -30 and mining_players_with_black_skies[name] then
		mining_players_with_black_skies[name] = false
		db({"SKYCHANGE[NORMAL]"})
		player:set_sky(nil,"regular")
		elseif pos.y < -30 and mining_players_with_black_skies[name] ~= true then
		db({"SKYCHANGE[BLACK]"})
		mining_players_with_black_skies[name] = true
		player:set_sky("#000000", "plain")
		end
		local table = playernutritions[name] or "ERRNO"
		if table == "ERRNO" then
			db({"ERRNO"})
			table = maxnutritions
			update_health_data_file(name,table)
		end
		if playerhealthhuds[name] then
		player:hud_remove(playerhealthhuds[name])
		end
		db(table)
		local health = math.min(20,
math.floor(2*math.min(table[1],table[2],table[3],table[4],table[5])/99--[[111]]))
		playerhealthhuds[name] = player:hud_add({
    			hud_elem_type = "statbar",
    			position = {x=0,y=1},
    			size = "",
    			text = "health.png",
    			number = health,
    			alignment = {x=0,y=1},
    			offset = {x=0, y=-32},
		})
		local neardead = false
		if health <= 0 then
			neardead = true
			player:set_hp(player:get_hp()-1)
		end
		if not neardead then
		if player:get_hp() < 18 and player:get_hp() > 0 then
		player:set_hp(player:get_hp()+1)
		for i =1,5 do
			if table[i] > 999 then
				table[i] = 999
			end
			if table[i] > 0 then
				table[i] = table[i] -6
			end
		end
		end
		for i =1,5 do
			if table[i]-20 > 0 then
				table[i] = table[i] -6
			else
				table[i] = 0
			end
		end
		end
		playernutritions[name] = table
		update_health_data_file(name,table)
end
end
end)
healthbar_armor_register = armor_register

