
-- Minetest mod: creepers
-- (c) Kai Gerd Müller
-- See README.txt for licensing and other information.
local parse_json = minetest.parse_json
core.parse_json = function(s)
if s ~= "" then
return parse_json(s)
else
return false
end
end
default_human_orc_mob_weapon_table = {}
local function set_weapon(self,item,mob_level,mobtex,shieldtex)
	local item = item or ItemStack("default:sword_steel")
	local def = item:get_definition()
	self.damage = def.tool_capabilities.damage_groups.fleshy*mob_level
	self.cooldown = def.tool_capabilities.full_punch_interval/mob_level
	self.object:set_properties({textures = {shieldtex,def.inventory_image,mobtex}})
end
default_human_orc_mob_weapon_table["ELF"] = {}
default_human_orc_mob_weapon_table["ELF"].KEYLIST = {"MITHRILSWORD"}
for e,i in pairs({"warhammer","mace","halberd","battleaxe","spear"}) do
	local index2 = "MITHRIL" .. string.upper(i)
	default_human_orc_mob_weapon_table["ELF"][index2] = ItemStack("default:".."mithril"..i)
	table.insert(default_human_orc_mob_weapon_table["ELF"].KEYLIST,index2)
end
default_human_orc_mob_weapon_table["ELF"]["MITHRILSWORD"] = ItemStack("default:sword_mithril")
default_human_orc_mob_weapon_table["DWARF"] = {}
default_human_orc_mob_weapon_table["DWARF"].KEYLIST = {"GALVORNSWORD"}
for e,i in pairs({"warhammer","mace","halberd","battleaxe","spear"}) do
	local index2 = "GALVORN" .. string.upper(i)
	default_human_orc_mob_weapon_table["DWARF"][index2] = ItemStack("default:".."galvorn"..i)
	table.insert(default_human_orc_mob_weapon_table["DWARF"].KEYLIST,index2)
end
default_human_orc_mob_weapon_table["DWARF"]["GAlVORNSWORD"] = ItemStack("default:sword_galvorn")
default_human_orc_mob_weapon_table["ORC"] = {}
default_human_orc_mob_weapon_table["ORC"].KEYLIST = {"STEELSWORD"}
for e,i in pairs({"warhammer","mace","halberd","battleaxe","spear"}) do
	local index2 = "STEEL" .. string.upper(i)
	default_human_orc_mob_weapon_table["ORC"][index2] = ItemStack("default:".."steel"..i)
	table.insert(default_human_orc_mob_weapon_table["ORC"].KEYLIST,index2)
end
default_human_orc_mob_weapon_table["ORC"]["STEELSWORD"] = ItemStack("default:sword_steel")
default_human_orc_mob_weapon_table["HUMAN"] = {}
default_human_orc_mob_weapon_table["HUMAN"].KEYLIST = {"STEELSWORD","BRONZESWORD"}
for e,i in pairs({"warhammer","mace","halberd","battleaxe","spear"}) do
	local index2 = "STEEL" .. string.upper(i)
	default_human_orc_mob_weapon_table["HUMAN"][index2] = ItemStack("default:".."steel"..i)
	table.insert(default_human_orc_mob_weapon_table["HUMAN"].KEYLIST,index2)
	local index2 = "BRONZE" .. string.upper(i)
	default_human_orc_mob_weapon_table["HUMAN"][index2] = ItemStack("default:".."bronze"..i)
	table.insert(default_human_orc_mob_weapon_table["HUMAN"].KEYLIST,index2)
end
default_human_orc_mob_weapon_table["HUMAN"]["STEELSWORD"] = ItemStack("default:sword_steel")
default_human_orc_mob_weapon_table["HUMAN"]["BRONZESWORD"] = ItemStack("default:sword_bronze")
local function set_mob_weapon_acc_race(self,sdata,selfish)
if sdata and sdata.weapon then
set_weapon(self,default_human_orc_mob_weapon_table[selfish.fighter_group][sdata.weapon],selfish.mob_level,selfish.main_image,selfish.shield_image or "doors_blank.png")
self.wielded_weapon_index = sdata.weapon
else
local keylist = default_human_orc_mob_weapon_table[selfish.fighter_group].KEYLIST
self.wielded_weapon_index = keylist[math.random(#keylist)]
set_weapon(self,default_human_orc_mob_weapon_table[selfish.fighter_group][self.wielded_weapon_index],selfish.mob_level,selfish.main_image,selfish.shield_image or "doors_blank.png")
end
end
--default_human_orc_mob_weapon_table = default_human_orc_mob_weapon_table
--[[selfish  = {main_image = ".png",
		shield_image = ".png",
		fighter_group = "",
		mob_level = ,}]]
local standardguardslist = {["default:mese"]="mese",["default:steelblock"]="steel",["default:copperblock"]="copper",["default:goldblock"]="gold",["default:bronzeblock"]="bronze",["default:diamondblock"]="diamond",["default:obsidian"]="obsidian"}
local function animate(self, t)
	if t == 1 and self.canimation ~= 1 then
		self.object:set_animation({
			x = 0,
			y = 80},
			30, 0)
		self.canimation = 1
	elseif t == 2 and self.canimation ~= 2 then
		self.object:set_animation({x = 200,y = 220},30, 0)
		self.canimation = 2
	--walkmine
	elseif t == 3 and self.canimation ~= 3 then
		self.object:set_animation({x = 168,y = 188},30, 0)
		self.canimation = 3
	--walk
	end
end
local function get_nearest_enemy(self,pos,radius,fucking_punchtest)
	local min_dist = radius+1
	local target = false
	for _,entity in ipairs(minetest.get_objects_inside_radius(pos,radius)) do
		local luaent = entity:get_luaentity()
--		db(hudwelshlaw)
		local name = entity:get_player_name()
		if (luaent and (not luaent.hudwel)) or (entity:is_player() and(
		(not hudwelshplayers[name])
		 or (hudwelshlaw[name]  and hudwelshlaw[name] > 0  )
		)) then
		local p = entity:getpos()
		local dist = vector.distance(pos,p)
				if default_do_not_punch_this_stuff(luaent) and (self.valar or minetest.line_of_sight(vector.add(pos,{x=0,y=5,z=0}),vector.add(p,{x=0,y=5,z=0}), 2,entity) == true or minetest.line_of_sight(pos,p, 2,entity) == true --[[or minetest.line_of_sight(vector.add(pos,{x=0,y=1,z=0}),vector.add(p,{x=0,y=1,z=0}), 2) == true]]) and dist < min_dist then
			min_dist = dist
				target = entity
		end
		end
	end
if target and ((not fucking_punchtest) or minetest.line_of_sight(target:getpos(),pos,2)) then
return target
else
return false
end
end
local function get_nearest_player(self,pos,radius)
	local min_dist = radius+1
	local target = false
	for _,entity in ipairs(minetest.get_objects_inside_radius(pos,25)) do
		if entity:is_player() then
			local p = entity:getpos()
			local dist = vector.distance(pos,p)
			if dist < min_dist then
				min_dist = dist
					target = entity
			end
		end
	end
if target then
return target:get_player_name()
else
return target
end
end
local calctarget  = function(table)
	if math.random(1,table.chanche) == 1 or not (table.target.x and table.target.y and table.target.z) then
		table.target = vector.multiply(vector.normalize({x= math.random(1,2)-1.5,y = 0,z= math.random(1,2)-1.5}),table.speed)
	end
	return table
end
local function set_boss_elf_textures_according_to_attack(self,ranged_attack)
	if ranged_attack and (not self.ranged_attack) then
		self.object:set_properties({textures = {"3d_shield_mithril.png","default_elven_boss_bow.png","elfcharacter.png^mob_armor_mithril.png"}})
	self.ranged_attack = ranged_attack
	elseif (not ranged_attack) and self.ranged_attack then
		self.object:set_properties({textures = {"3d_shield_mithril.png","default_tool_mithrilsword.png","elfcharacter.png^mob_armor_mithril.png"}})
	self.ranged_attack = ranged_attack
	elseif (not ranged_attack) and (self.ranged_attack == nil) then
		self.object:set_properties({textures = {"3d_shield_mithril.png","default_tool_mithrilsword.png","elfcharacter.png^mob_armor_mithril.png"}})
	self.ranged_attack = ranged_attack
	end
end
local function set_valar_textures(self)
self.object:set_properties({textures = {"3d_shield_valar.png","default_tool_valinorsword.png","valar.png"}})
end
local function boss_elf_attack(self,target)
if vector.distance(target:getpos(),self.object:getpos()) > 3 then
local admg = 12
if math.random(1,30) == 1 then
admg = admg*100
end
local selfpos = self.object:getpos()
hudwel_elven_boss_arch({
p1 = {x=selfpos.x,y = selfpos.y,z = selfpos.z},
p2 = target:getpos(),
archer = self.object,
targetv = target:getvelocity(),
damage = admg,
--penetration = def.penetration,
maxvel = 450})
set_boss_elf_textures_according_to_attack(self,true)
else
local admg = self.damage
if math.random(1,30) == 1 then
admg = admg*100
end
target:punch(self.object, 1.0,  {full_punch_interval=1.0,damage_groups = {fleshy=admg}})
set_boss_elf_textures_according_to_attack(self,false)
				if target:is_player() then
					add_to_law_status(target:get_player_name(),self.lawname,-self.damage)
				end
end
end
local function jump_needet(size,pos)
pos.y = (pos.y-(size+0.5))
local returning = minetest.registered_nodes[minetest.get_node(pos).name].walkable
local returningz = false
for x =-1,1 do
for y =-1,1 do
if not returningz then
returningz =  minetest.registered_nodes[minetest.get_node(vector.add(pos,{x=x,y=1,z=y})).name].walkable
else
break
end
end
end
return (returningz and returning)
end
local function register_guard(def,spawnnodes,spawnchanche)
	if def.drops and (not default_standard_mob_drop_list[def.drops[1]]) and def.drops[2] then
	default_standard_mob_drop_list[def.drops[1]] = def.drops[2]
	end
	--def.speed = 0.01
	--local defbox = def.size/2
	minetest.register_entity("hudwel:" .. def.name,{
		initial_properties = {
			name = def.name,
			hp_min = def.max_hp,
			hp_max = def.max_hp,
			visual_size = {x = 1, y = def.size, z = 1},
			visual = "mesh",
			mesh = --[[def.mesh or]] "final_player_character.b3d",--"character20.b3d",
			textures = {"doors_blank.png","doors_blank.png","doors_blank.png"},--def.textures or {def.name .. "shield.png^swordf.png","doors_blank.png"},
			collisionbox = {-0.4, -def.size, -0.4, 0.4, def.size, 0.4},
			physical = true
		},
		-- ON ACTIVATE --
		on_punch = function(self,puncher,t,tool_capabilities)
			if def.name == "thorin" and t and tool_capabilities and puncher and math.random(1,3) == 1 then
					puncher:punch(self.object,t,tool_capabilities)
			end
			lawbreak_on_punch(self,puncher)
		end,
		on_activate = function(self,sdata)
			self.it_is_a_riding_creature = true
			local sdata,first_spawn_at_all = self_first_spawn(sdata)
			if def.drops then
				self.drops = def.drops
			end
			local sdata = (sdata or false)
			if sdata and sdata ~= "" then
			sdata = minetest.parse_json(sdata) or {}
			else
			sdata = {}
			end
			self.texture_index = sdata.tex_index or math.random(0,def.max_texture_index or 0)
			if def.name == "legolas" then
				sdata.weapon = "MITHRILSWORD"
			end
			if def.name == "valar" then
				sdata.weapon = "MITHRILSWORD"
			end
			local deftextures = def.textures or {}
			set_mob_weapon_acc_race(self,sdata,{main_image = deftextures[1] or "lottmobs_"..def.texture_name .. self.texture_index..".png",
		shield_image = def.shield or "3d_shield_" .. def.name .. ".png",
		fighter_group = string.upper(def.drops[1]),
		mob_level = def.damage/6})

			if def.name == "legolas" then
				set_boss_elf_textures_according_to_attack(self,false)
			end
			self.lifetimer = sdata.lifetimer or 6000
			if type(self.lifetimer) ~= "number" then
				self.lifetimer = 6000
			end
			if first_spawn_at_all then
			self.object:set_armor_groups({fleshy = def.armor or 100,level = 1})
			end
			self.worktimer = sdata.worktimer or 0

			if sdata.owner_name then
				self.owner_name = sdata.owner_name
				self.owner = minetest.get_player_by_name(sdata.owner_name)
			end
			self.regentimer = sdata.regentimer or 1800
			self.on_gold_pay = def.on_gold_pay
			self.damage = def.damage
			self.lawname = "hudwelshlaw"
			self.on_diamond_pay = def.on_diamond_pay
			self.valar = def.name == "valar"
			self.damagetimer = 0
			self.timer = 0
			self.arrow_resistant = def.arrow_resistant
			self.jump = 0
			self.hudwel = true
			self.walkaround = {target = {},speed = def.speed,chanche = 100,calc = calctarget}
			self.object:setacceleration({x=0,y=-50,z=0})
		self.object:set_animation({
			x = 0,
			y = 80},
			30, 0)
			self.canimation = 1
			if def.name == "valar" then
				set_valar_textures(self)
			end
			--set_weapon(self,ItemStack("default:mithrilmace"),1,"elf.png","3d_shield_elven.png")
		end,
		-- ON PUNCH --
		-- ON STEP --
		get_staticdata = function(self)
			
			return add_first_spawn_flag(minetest.write_json({weapon = self.wielded_weapon_index,tex_index = self.texture_index,lifetimer = self.lifetimer,worktimer = self.worktimer,owner_name = self.owner_name,regentimer = self.regentimer}))end,
		on_rightclick = add_chestpriv_on_pay,
		on_step = function(self, dtime)
			self.timer = self.timer or (self.cooldown or 1)
			if (def.name == "legolas") or (def.name == "thorin") or (def.name == "valar") then
			self.regentimer = self.regentimer-dtime
			if self.regentimer < 0 then
			self.regentimer = 1800
			self.object:set_hp(def.max_hp)
			end
			end
			self.lifetimer = (self.lifetimer or 6000)-dtime
			if (self.lifetimer < 0) then
				if(def.name ~= "legolas") and (def.name ~= "thorin") and (def.name ~= "valar") then
					self.object:remove()
				else
					self.lifetimer = 6000
				end
			end
			local pos = self.object:getpos()
			--if self.owner_name then
			--self.owner = minetest.get_player_by_name(self.owner_name)
			self.animation_set = true
			self.gravity = {x=0,y=-50,z=0}
			self.targetvektor = nil
			if self.timer < (self.cooldown or 1) then
			self.timer = self.timer+dtime
			end
			if self.damagetimer < 1 then
				self.damagetimer = self.damagetimer+dtime
			elseif ((minetest.get_node(vector.subtract(pos,{x=0,y=0.5,z=0})).name == "default:lava_source") or (minetest.get_node(vector.subtract(pos,{x=0,y=0.5,z=0})).name == "default:lava_flowing")) and (def.name ~= "legolas") and (def.name ~= "thorin") and (def.name ~= "valar") then
				db({"AAARRRGGGHHH!!!"})
				--self.object:set_hp(self.object:get_hp()-minetest.registered_nodes[minetest.get_node(pos).name].damage_per_second)
				self.object:remove()
				self.damagetimer = 0
			else
				self.damagetimer = 0
			end	
			--db({minetest.get_node(vector.subtract(pos,{x=0,y=1,z=0})).name})
			local punching = false
			if self.timer >= (self.cooldown or 1) then
				if def.name ~= "legolas" then
				local target = get_nearest_enemy(self,pos,def.size*3,true)
				if target then
				target:punch(self.object, 1.0,  {full_punch_interval=1.0,damage_groups = {fleshy=self.damage}})
				if ((def.name == "thorin") or (def.name == "legolas") or (def.name == "valar"))and(math.random(1,60) == 1) and( not( target:get_luaentity() and ((target:get_luaentity().name == "sauron:sauron") or (target:get_luaentity().name == "melkor:melkor")))) then
					target:set_hp(0)
				end
				if target:is_player() then
					add_to_law_status(target:get_player_name(),self.lawname,-self.damage)
					if (def.name == "thorin")and (math.random(1,6) == 1) then
					local inv = target:get_inventory()
					inv:set_stack("main", math.random(33,38), ItemStack(""))
					end
				elseif (def.name == "thorin")and (math.random(1,6) == 1) then
					local g = target:get_armor_groups()
					for i,e in pairs(g) do
						g[i] = math.min(e*1.25,100)
					end
					target:set_armor_groups(g)
				end	
				self.timer = 0
				end
				else
				local target = get_nearest_enemy(self,pos,120,true)
				if target then
				boss_elf_attack(self,target)
				self.timer = 0
				end
				end
			end
			local target = get_nearest_enemy(self,pos,25)
			
			local velocity = self.object:getvelocity()
			self.waydown = velocity.y
			if target then
			if (def.name == "valar") and (math.random(1,60) == 1) and ((self.timer >= (self.cooldown or 1))or (self.timer == 0)) then
				minetest.add_entity(pos,"lotharrows:mageball")
			end
			target = target:getpos()
			self.targetvektor = vector.multiply(vector.normalize({x=target.x-pos.x,y=self.waydown,z=target.z-pos.z}),def.speed)
			end
			if not self.targetvektor then
					if self.owner then
						if self.worktimer > 0 then
							self.worktimer = self.worktimer -dtime
							local togo = vector.subtract(self.owner:getpos(),pos)
							self.owner_distance = vector.length(togo)
							if self.owner_distance > 8 then
							self.targetvektor = vector.multiply(vector.normalize({x = togo.x,y = 0,z = togo.z}),def.speed)
							self.nextanimation = 3
							else
							self.nextanimation = 1
							self.targetvektor = vector.new()
							end
						else
							self.owner = nil
							self.walkaround = self.walkaround.calc(self.walkaround)
							self.nextanimation = 3
							self.targetvektor = self.walkaround.target
						end
					else
						self.walkaround = self.walkaround.calc(self.walkaround)
						self.nextanimation = 3
						self.targetvektor = self.walkaround.target
					end
					self.targetvektor.y =self.waydown
					self.animation_set = false
			end
			self.jump = (self.jump +1)%10
			if self.targetvektor then
			if self.animation_set then
				self.nextanimation = 2
			end
			if default_is_swimmable(minetest.get_node(pos).name) then
				self.gravity = {x=0,y=0,z=0}
			end
			pos.y = pos.y+0.5
			if default_is_swimmable(minetest.get_node(pos).name) then
				self.targetvektor.y = 1
			end
			pos.y = pos.y-0.5
			local boolstuck = vector.distance(vector.new(),velocity)<def.speed/10
			local booljn = (not self.owner) or jump_needet(def.size,pos)
			if (self.jump == 0) and (vector.length(self.targetvektor) ~= 0) and boolstuck and default_nodes_under_jumpable(def,pos) and booljn then
				stomp(self,def.size)
			end
			self.object:setacceleration(self.gravity)
			self.object:setvelocity(self.targetvektor)
			self.object:setyaw(math.atan2(self.targetvektor.z,self.targetvektor.x)-math.pi/2)
			else
				self.object:setvelocity({x=0,y=0,z=0})		
				self.nextanimation = 1
			end
			animate(self,self.nextanimation)
			--else
			--local next_owner = get_nearest_player(self,pos,100)
			--if next_owner then
			--	self.owner_name = next_owner
			--end
			--end
			if self.object:get_hp() > 0 then return end
			add_standard_mob_drop(self)
			self.object:remove()
		end
	})
regular_humanoid_spawn_registry("archers:" .. def.name,spawnnodes,spawnchanche)
end
local function dwarf_gold_pay(obj,player,count)
local working = minetest.add_entity(obj:getpos(),"guards:dwarf")
working:setyaw(obj:getyaw())
local luaent = working:get_luaentity()
luaent.worktimer = 5600*count
luaent.owner_name = player:get_player_name()
obj:remove()
end
local function standard_on_diamond_pay(self,clicker,number)
	local name = clicker:get_player_name()
	if (not self.owner) and hudwelshplayers[name] and ((not hudwelshlaw[name])  or (hudwelshlaw[name] <= 0)  ) then
		self.owner = clicker
		self.owner_name = clicker:get_player_name()
		self.worktimer = 5600*number
	else
		return true
	end
end
local function valar_on_diamond_pay(self,clicker,number)
	local name = clicker:get_player_name()
	if (not self.owner) and hudwelshplayers[name] and ((not hudwelshlaw[name])  or (hudwelshlaw[name] <= 0)  ) then
		self.owner = clicker
		self.owner_name = clicker:get_player_name()
		self.worktimer = 2800*number
	else
		return true
	end
end
default_register_sbm({
	nodenames = {"default:stone_with_iron"},
	neighbors = {"air"},
	label = "spawn",
	catch_up = false,
	interval = 10,
	chance = 800,
	action = function(p)
		p.y = p.y+1
		local p2 = p
		p2.y = p2.y+1
		if minetest.get_node(p).name == "air" and minetest.get_node(p2).name == "air" then
			minetest.add_entity(p,"hudwel:standarddwarf")
		end
	end,
})
local noshield = "doors_blank.png"
register_guard({
	damage = 12,
	name = "elf",
	drops = {"elf"},
	textures = {"elf.png"},
	on_gold_pay = standard_on_diamond_pay,
	max_hp = 90,
	armor = 15,
	size = 1,
	speed = 5
},{"default:loriendirt"},800)
register_guard({
	damage = 11,
	name = "standardelf",
shield = noshield,
	max_texture_index = 5,
	texture_name = "elf_",
	--textures = {"elfcharacter.png"},
	on_gold_pay = standard_on_diamond_pay,
	mesh = "character.b3d",
	drops = {"elf"},
	max_hp = 85,
	size = 1,
	speed = 5
},{"default:mirkwooddirt","default:loriendirt"},500)
register_guard({
	damage = 24,
	name = "legolas",
	drops = {"elf"},
	max_hp = 6000,
	textures = {"legolas.png"},
	on_diamond_pay = standard_on_diamond_pay,
	arrow_resistant = true,
	armor = 8,
	size = 1,
	speed = 6
},{"default:loriendirt"},3600)
register_guard({
	damage = 60,
	name = "valar",
	drops = {"elf"},
	max_hp = 9000,
	textures = {"valar.png"},
	on_diamond_pay = valar_on_diamond_pay,
	arrow_resistant = true,
	armor = 2,
	size = 1,
	speed = 6
},{"default:valinordirt"},3600)
register_guard({
	damage = 9,
	name = "human",
	drops = {"human"},
	max_texture_index = 1,
	texture_name = "human_armored_",
	on_gold_pay = standard_on_diamond_pay,
	max_hp = 60,
	armor = 20,
	size = 1,
	speed = 4
},{"default:gondordirt","default:ithiliendirt"},800)
register_guard({
	damage = 8,
	name = "standardhuman",
	max_texture_index = 10,
	texture_name = "human_",
	drops = {"human"},
shield = noshield,
	on_gold_pay = standard_on_diamond_pay,
	--textures = {"humancharacter.png"},
	mesh = "character.b3d",
	max_hp = 55,
	size = 1,
	speed = 4
},{"default:gondordirt","default:ithiliendirt","default:rohandirt"},500)
register_guard({
	damage = 6,
	name = "dwarf",
	textures = {"dwarf.png"},
	on_gold_pay = standard_on_diamond_pay,
	drops = {"dwarf"},
	armor = 10,
	max_hp = 120,
	size = 0.75,
	speed = 3
},{"default:ironhillsdirt","default:bluemountainsdirt"},800)
register_guard({
	damage = 18,
	name = "thorin",
	textures = {"thorin.png"},
	arrow_resistant = true,
	on_diamond_pay = standard_on_diamond_pay,
	drops = {"dwarf"},
	armor = 3,
	max_hp = 6000,
	size = 0.75,
	speed = 3
},{"default:bluemountainsdirt"},3600)
register_guard({
	damage = 5,
	name = "standarddwarf",
	max_texture_index = 5,
	texture_name = "dwarf_",
	drops = {"dwarf"},
shield = noshield,
	on_gold_pay = standard_on_diamond_pay,
	--textures = {"dwarfcharacter.png"},
	mesh = "character.b3d",
	max_hp = 115,
	size = 0.75,
	speed = 3
},{"default:ironhillsdirt","default:bluemountainsdirt"},500)
--[[register_guard({
	damage = 10,
	name = "copper",
	max_hp = 40,
	size = 1,
	speed = 3
},{"default:mordordust","default:angmarsnow"},10000)
register_guard({
	damage = 11,
	name = "bronze",
	max_hp = 50,
	size = 1,
	speed = 3
},{"default:mordordust","default:angmarsnow"},10000)
register_guard({
	damage = 12,
	name = "gold",
	max_hp = 60,
	size = 1,
	speed = 3
},{"default:mordordust","default:angmarsnow"},10000)
register_guard({
	damage = 13,
	name = "mese",
	max_hp = 70,
	size = 1,
	speed = 3
},{"default:mordordust","default:angmarsnow"},10000)

register_guard({
	damage = 14,
	name = "diamond",
	max_hp = 80,
	size = 1,
	speed = 3
},{"default:mordordust","default:angmarsnow"},10000)
register_guard({
	damage = 15,
	name = "obsidian",
	max_hp = 90,
	size = 1,
	speed = 3
},{"default:mordordust","default:angmarsnow"},10000)]]


