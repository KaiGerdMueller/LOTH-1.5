playerarmors =  {orc = 0,dunlending = 0,elf = 0,dwarf = 0,hobbit = 0,human = 0,wizzard = 0}
orcishplayers = {}
dunlendingshplayers = {}
orcishlaw = {}
dunlendingshlaw = {}
hudwelshplayers = {}
hudwelshlaw = {}
hudwelshchestpriv = {}
orcishchestpriv = {}
dunlendingshchestpriv = {}
player_base_textures = {}
player_fine_group = {}
healthbar_damn_values = {}
local bad_souls_harvested = {}
local players_who_can_change_race = {}
local group_num_to_group_name = {"orc","dunlending","elf","dwarf","hobbit","human","wizzard"}
local player_group_textures = {"orccharacter2.png","dunlendingcharacter.png","elfcharacter.png","dwarfcharacter.png","hobbitcharacter.png","humancharacter.png","wizardcharacter1.png"}
local player_group_sizes = {[1] = {x = 1.1,y=1.1},[3] = {x=1.2,y=1.2},[4] = {x=1,y=0.75},[5] = {x=0.75,y=0.75}}
local rac_agility = {orc = 1.2
,dunlending = 1.8,elf = 2,dwarf = 1,hobbit = 1,human = 1.6,wizzard = 1.4}
local function give_initial_stuff(player,group)
	minetest.log("action",
			"Giving initial stuff to player " .. player:get_player_name())
	local inv = player:get_inventory()
	inv:add_item("main", "healthbar:crafting_book")
	if group == "wizzard" then
	inv:add_item("main", "default:magic_light_wand")
	end
	for i = 1,10 do
	for _, stack in ipairs(default_standard_mob_drop_list[group]) do
		if math.random(1,math.max(math.floor(stack.occurance/1),1)) == 1 then
			inv:add_item("main", stack.name .. " " .. tostring(math.random(stack.min,stack.max)))
		end
	end
	end
end
function update_group_data_file(name,healthvals)
	local input = io.open(health_data_file_name .. name .. "group.txt", "w")
	if input then
 	input:write(tostring(healthvals))
	io.close(input)
	end
end
function set_rune_riddle_solved(name)
	local input = io.open(health_data_file_name .. name .. "rune_riddle_solved.txt", "w")
	if input then
 	input:write(tostring(minetest.get_password_hash(name,health_data_file_name .. name .. "rune_riddle_solved.txt")))
	io.close(input)
	end
end
function set_melkor_spawned()
	local input = io.open(health_data_file_name .. "melkor_is_there.txt", "w")
	if input then
 	input:write("MELKOR")
	io.close(input)
	end
end
function set_melkor_killer(name)
	local input = io.open(health_data_file_name .. "ndmlpsljmmds.txt", "w")
	if input then
 	input:write(name)
	io.close(input)
	end
end
function is_melkor_killer(name)
	local input = io.open(health_data_file_name .. "ndmlpsljmmds.txr", "r")
 	if input then
	if input:read("*all") == name then
		io.close(input)
		return true
	end
	io.close(input)
	end
	return false
end
function get_melkor_spawned()
	local input = io.open(health_data_file_name .. "melkor_is_there.txr", "r")
 	if input then
	if input:read("*all") == "MELKOR" then
		io.close(input)
		return true
	end
	io.close(input)
	end
	return false
end
function set_ring_destroyed(name)
	minetest.chat_send_all(name.." destroyed saurons ring!!! he can now make wooden staves magical by using them!")
	local input = io.open(health_data_file_name .. name .. "ring_destroyed.txt", "w")
	if input then
 	input:write(tostring(minetest.get_password_hash(name,health_data_file_name .. name .. "ring_destroyed.txt")))
	io.close(input)
	end
end
function get_rune_riddle_solved(name)
	local input = io.open(health_data_file_name .. name .. "rune_riddle_solved.txt", "r")
 	if input then
	if input:read("*all") == tostring(minetest.get_password_hash(name,health_data_file_name .. name .. "rune_riddle_solved.txt")) then
		io.close(input)
		return true
	end
	io.close(input)
	end
	return false
end
function get_ring_destroyed(name)
	local input = io.open(health_data_file_name .. name .. "ring_destroyed.txt", "r")
 	if input then
	if input:read("*all") == tostring(minetest.get_password_hash(name,health_data_file_name .. name .. "ring_destroyed.txt")) then
		io.close(input)
		return true
	end
	io.close(input)
	end
	return false
end
function set_player_bad_souls_harvested(name)
	local input = io.open(health_data_file_name .. name .."badsoulsharvested.txt", "w")
	if input then
 	input:write(tostring(bad_souls_harvested[name]))
	io.close(input)
	end
end
function increase_player_bad_souls_harvested(doit,name,ammo)
	if doit then
		bad_souls_harvested[name] = get_player_bad_souls_harvested(name)+ammo
		set_player_bad_souls_harvested(name)
	end
end
function decimate_player_bad_souls_harvested(name)
	local bad_souls = get_player_bad_souls_harvested(name)
	if bad_souls > 0 then
	bad_souls_harvested[name] = math.floor(get_player_bad_souls_harvested(name)/10)
	set_player_bad_souls_harvested(name)
	end
end
function update_damn_data_file(name,healthvals)
	local input = io.open(health_data_file_name .. name .. "doomed.txt", "w")
	if input then
 	input:write(tostring(healthvals))
	io.close(input)
	end
end
function update_law_data_file(name,lawname,lawnum)
	local input = io.open(health_data_file_name .. name .. lawname .. "law.txt", "w")
	if input then
 	input:write(tostring(lawnum))
	io.close(input)
	end
end
function update_chestpriv_data_file(name,lawname,lawnum)
	local input = io.open(health_data_file_name .. name .. lawname .. "chestpriv.txt", "w")
	if input then
 	input:write(tostring(lawnum))
	io.close(input)
	end
end
function add_to_law_status(name,lawname,add,ngtv)
	local law = false
	if ngtv then
	if lawname == "orcishlaw" then
		orcishlaw[name] = orcishlaw[name]+add
		law = orcishlaw[name]
	elseif lawname == "dunlendingshlaw" then
		dunlendingshlaw[name] = dunlendingshlaw[name]+add
		law = dunlendingshlaw[name]
	elseif lawname == "hudwelshlaw" then
		hudwelshlaw[name] = hudwelshlaw[name]+add
		law = hudwelshlaw[name]
	end
	else
	if lawname == "orcishlaw" then
		orcishlaw[name] = math.max(orcishlaw[name]+add,0)
		law = orcishlaw[name]
	elseif lawname == "dunlendingshlaw" then
		dunlendingshlaw[name] = math.max(dunlendingshlaw[name]+add,0)
		law = dunlendingshlaw[name]
	elseif lawname == "hudwelshlaw" then
		hudwelshlaw[name] = math.max(hudwelshlaw[name]+add,0)
		law = hudwelshlaw[name]
	end
	end
	if law then
		update_law_data_file(name,lawname,law)
	end
end
local function convert_law_to_chestpriv(law)
if law == "dunlendingshlaw" then
law = "dunlendingshchestpriv"
elseif law == "orcishlaw" then
law = "orcishchestpriv"
else
law = "hudwelshchestpriv"
end
return law
end
function add_to_chestpriv_status(name,lawname,add)
	local law = false
	if lawname == "orcishchestpriv" then
		orcishchestpriv[name] = orcishchestpriv[name]+add
		law = orcishchestpriv[name]
	elseif lawname == "dunlendingshchestpriv" then
		dunlendingshchestpriv[name] = dunlendingshchestpriv[name]+add
		law = dunlendingshchestpriv[name]
	elseif lawname == "hudwelshchestpriv" then
		hudwelshchestpriv[name] = hudwelshchestpriv[name]+add
		law = hudwelshchestpriv[name]
	end
	if law then
		update_chestpriv_data_file(name,lawname,law)
	end
end
--on_rightclick = add_chestpriv_on_pay
function add_chestpriv_on_pay(self, clicker)
local stack = clicker:get_wielded_item()
local stackname = stack:get_name()
if stackname == "default:gold_ingot" then
	add_to_chestpriv_status(clicker:get_player_name(),convert_law_to_chestpriv(self.lawname),10*stack:get_count())
	clicker:set_wielded_item(ItemStack("default:key"))
elseif self.on_gold_pay and (stackname == "default:goldblock") then
	if not self.on_gold_pay(self,clicker,stack:get_count()) then
		clicker:set_wielded_item(ItemStack(""))
	end
elseif stackname == "default:diamond" then
	add_to_chestpriv_status(clicker:get_player_name(),convert_law_to_chestpriv(self.lawname),60*stack:get_count())
	clicker:set_wielded_item(ItemStack("default:key"))
elseif self.on_diamond_pay and (stackname == "default:diamondblock") then
	if not self.on_diamond_pay(self,clicker,stack:get_count()) then
		clicker:set_wielded_item(ItemStack(""))
	end
end
end
function get_default_properties_of_player(name,prop)
local group = get_player_group(name,true)
if prop == "textures" then
return player_group_textures[group]
else
return false
end
end

local function is_not_epic_weapon(itmstck)
return (string.sub(itmstck:get_name(), 1, 13) ~= "default:epic_")
end

local function add_wear_to_weapon(itmstck)
local d = itmstck:get_tool_capabilities()
if d then
local gc = d.groupcaps
if gc then
local uses = (gc.oddly_breakable_by_hand or {}).uses or (gc.crumbly or {}).uses or (gc.cracky or {}).uses or (gc.choppy or {}).uses or (gc.snappy or {}).uses or 10
if uses and uses ~= 0 and is_not_epic_weapon(itmstck) then
local uses = uses*math.max(1,(gc.maxlevel or 1))*30
itmstck:add_wear(math.floor(65535/uses))
end
end
end
return itmstck
end
function lawbreak_on_punch(self,puncher)
--healthbar_play_attack_sound(self.object)
if puncher:is_player() then
puncher:set_wielded_item(add_wear_to_weapon(puncher:get_wielded_item()))
add_to_law_status(puncher:get_player_name(),self.lawname,20)
end
if self.object:get_hp() <= 0 then
if puncher:is_player() then
add_to_law_status(puncher:get_player_name(),self.lawname,700)
end
add_standard_mob_drop(self)
if self.on_mob_die then
self.on_mob_die(self.object:getpos())
end
self.object:remove()
end
end
local function groupitzeradv()
local percent = math.random()*80
if percent > 70 then--elven
percent = 3
elseif percent > 55 then--dwarf
percent = 4
elseif percent > 25 then--hobbit
percent = 5
elseif percent > 5 then--human
percent = 6
else--wizzard
percent = 7
end
return percent
end
local function get_overgroup(gval)
	if gval > 2 then
	gval = 1
	elseif gval == 1 then
	gval = 2
	else
	gval = 3
	end
	return gval
end
function get_player_group(name,eth,del)
	if player_fine_group[name] then
		if eth then
			return player_fine_group[name]
		else
			return get_overgroup(player_fine_group[name])
		end
	else
	local input = io.open(minetest.get_worldpath() .. "/players/" .. name .. "group.txt", "r")
	if input then
		local data = input:read("*n")
        	io.close(input)
		player_fine_group[name] = data
		local group_name = group_num_to_group_name[data]
		local agility = rac_agility[group_name] or 1
		local player  = minetest.get_player_by_name(name)
		if eth and del then
		--give_initial_stuff(player,group_name)
		player:set_physics_override({
speed = agility,
jump = agility,
gravity = 1,
sneak = true,
sneak_glitch = false})
		end
		if eth then
			return data
		else
			return get_overgroup(data)
		end
	else
		local healthvals = groupitzeradv()
		minetest.chat_send_player(name, "hello "..name..", you joined this world and spawned as a "..group_num_to_group_name[healthvals]..", but if you wish to, you can change your race to any evil race during the next three minutes. just type /change_race_to_evil_race <evil_race> into the chat, and you will be a creature of that evil race. possible evil races are orc and dunlending. but anyway, it's quite impossible to win the game as orc or dunlending. (since you cannot build up an army)")
		players_who_can_change_race[name] = true
		minetest.after(180,function()players_who_can_change_race[name] = nil end)
		player_fine_group[name] = healthvals
		if not del then
		update_group_data_file(name,healthvals)
		else
		minetest.after(0,function()update_group_data_file(name,player_fine_group[name])end)
		minetest.after(del,function()update_group_data_file(name,player_fine_group[name])end)
		minetest.after(del*3,function()update_group_data_file(name,player_fine_group[name])end)
		minetest.after(del*10,function()update_group_data_file(name,player_fine_group[name])end)
		end
		local group_name = group_num_to_group_name[healthvals]
		local agility = rac_agility[group_name] or 1
		local player  = minetest.get_player_by_name(name)
		if eth and del then
		give_initial_stuff(player,group_name)
		player:set_physics_override({
speed = agility,
jump = agility,
gravity = 1,
sneak = true,
sneak_glitch = false})
			return healthvals
		else
			return get_overgroup(healthvals)
		end
	end
	end
end
minetest.register_chatcommand("change_race_to_evil_race", {
	params = "<text>",
	description = "change race to evil race",
	func = function( name , text)
		if players_who_can_change_race[name] then
			if (text == "orc") or (text == "dunlending") then
				players_who_can_change_race[name] = nil
				local healthvals = ({["orc"]=1,["dunlending"]=2})[text]
				minetest.chat_send_all(healthvals)
				update_group_data_file(name,healthvals)
				local player = minetest.get_player_by_name(name)
				default.player_set_model(player, "final_player_character.b3d",player_group_sizes[healthvals] or {x=1,y=1})
local group = player_fine_group[name]
player_fine_group[name] = healthvals
if group == 1 then--allied
orcishplayers[name] = true
elseif group == 2 then--orc
dunlendingshplayers[name] = true
else--dunlending
hudwelshplayers[name] = true
end --end,name)
if healthvals == 1 then--allied
orcishplayers[name] = true
elseif healthvals == 2 then--orc
dunlendingshplayers[name] = true
else--dunlending
hudwelshplayers[name] = true
end --end,name)
		local group_name = group_num_to_group_name[healthvals]
				default.player_set_textures(player, {"doors_blank.png","doors_blank.png",player_group_textures[healthvals]})
						minetest.chat_send_all(player_group_textures[healthvals])
		local agility = rac_agility[group_name] or 1
		player:set_physics_override({
speed = agility,
jump = agility,
gravity = 1,
sneak = true,
sneak_glitch = false})
				return true,"race changed sucessfully. you are now "..(((text == "orc") and "an") or (("dunlending" ==  text) and "a")).." "..text.."!"
			else 
				return true,"couldn't change race. the evil race "..text.." does not exist at all!"
			end
		else
			return true,"couldn't change race. either the three min you had to choose an evil race are over or the server has restarted."
		end
	end,
})
function get_player_law(name,lawname)
	local input = io.open(health_data_file_name .. name .. lawname .. "law.txt", "r")
	if input then
		local data = input:read("*n")
        	io.close(input)
		return data
	end
end
function get_player_poison(name)
	local input = io.open(health_data_file_name .. name .. "poison.txt", "r")
	if input then
		local data = input:read("*n")
        	io.close(input)
		return data
	end
end
function get_player_die(name)
	local input = io.open(health_data_file_name .. name .."diedata.txt", "r")
	if input then
		local data = input:read("*n")
        	io.close(input)
		return data
	end
end
function get_player_bad_souls_harvested(name)
	if bad_souls_harvested[name] then
		return bad_souls_harvested[name]
	end
	local input = io.open(health_data_file_name .. name .."badsoulsharvested.txt", "r")
	if input then
		local data = input:read("*n")
        	io.close(input)
		bad_souls_harvested[name] = data
		return data
	end
	return 0
end
function player_is_qualified_for_rune_riddle(name)
	return get_player_bad_souls_harvested(name)/get_player_die(name) > 3000
end
function get_player_damn(name)
	local input = io.open(health_data_file_name .. name .."doomed.txt", "r")
	if input then
		local data = input:read("*n")
        	io.close(input)
		return data
	end
end
function update_die_data_file(name,lawnum)
	local input = io.open(health_data_file_name .. name .. "diedata.txt", "w")
	if input then
 	input:write(tostring(lawnum))
	io.close(input)
	end
end
function get_player_chestpriv(name,lawname)
	local input = io.open(health_data_file_name .. name .. lawname .. "chestpriv.txt", "r")
	if input then
		local data = input:read("*n")
        	io.close(input)
		return data
	end
end
function get_chestpriv_by_string(s,name)
if s == "orcishchestpriv" then
s = orcishchestpriv[name]
elseif s == "dunlendingshchestpriv" then
s = dunlendingshchestpriv[name]
else
s = hudwelshchestpriv[name]
end
return s
end
minetest.register_on_joinplayer(function(player)
local name = player:get_player_name()
player_deaths[name] = get_player_die(name) or 0
dunlendingshlaw[name] = get_player_law(name,"dunlendingshlaw") or 0
hudwelshlaw[name] = (get_player_law(name,"hudwelshlaw") or 0)
orcishlaw[name] = get_player_law(name,"orcishlaw") or 0
dunlendingshchestpriv[name] = get_player_chestpriv(name,"dunlendingshchestpriv") or 0
hudwelshchestpriv[name] = (get_player_chestpriv(name,"hudwelshchestpriv") or 0)
orcishchestpriv[name] = get_player_chestpriv(name,"orcishchestpriv") or 0
healthbar_damn_values[name] = get_player_damn(name) or 0
--[[local group = get_player_group(name)
if group == 1 then--allied
hudwelshplayers[name] = true
elseif group == 2 then--orc
orcishplayers[name] = true
else--dunlending
dunlendingshplayers[name] = true
end]]
--local finegroup = get_player_group(name,true)
--default.player_set_textures(player, {player_group_textures[finegroup]})

--default.player_set_model(player, "character.b3d",player_group_sizes[finegroup] or {x=1,y=1})
--[[player:set_properties({
	visual = "mesh",
	textures = {--[[player_group_textures[finegroup]]--"elfchrarcter.png"},
	--[[visual_size = player_group_sizes[finegroup] or {x=10,y=10},
})]]
--dunlendingshplayers[name] = true
--minetest.after(3--[[10]],function(name)
local finegroup = get_player_group(name,true,1)
default.player_set_textures(player, {"doors_blank.png","doors_blank.png",player_group_textures[finegroup]})
if player_group_sizes[finegroup] and player_group_sizes[finegroup].y == 0.75 then
default.player_set_model(player, "final_player_character_small.b3d",player_group_sizes[finegroup])
else
default.player_set_model(player, "final_player_character.b3d",player_group_sizes[finegroup] or {x=1,y=1})
end
local group = get_overgroup(finegroup)--get_player_group(name)
if group == 1 then--allied
hudwelshplayers[name] = true
elseif group == 2 then--orc
orcishplayers[name] = true
else--dunlending
dunlendingshplayers[name] = true
end --end,name)
end)
