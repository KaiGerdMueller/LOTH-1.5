
-- Minetest mod: creepers
-- (c) Kai Gerd Müller
-- See README.txt for licensing and other information.
local function set_weapon(self,item,mob_level,mobtex,shieldtex)
	local item = item or ItemStack("default:sword_steel")
	local def = item:get_definition()
	self.damage = def.tool_capabilities.damage_groups.fleshy*mob_level
	self.cooldown = def.tool_capabilities.full_punch_interval/mob_level
	self.object:set_properties({textures = {shieldtex,def.inventory_image,mobtex}})
end
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
		if (luaent and (not luaent.orc)) or (entity:is_player() and(
		(not orcishplayers[name])
		 or (orcishlaw[name]  and orcishlaw[name] > 0  )
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
local function become_nearest_general(self,pos)
	local min_dist = 31
	local target = false
	if self.general then
	for _,entity in ipairs(minetest.get_objects_inside_radius(pos,30)) do
		local luaent = entity:get_luaentity()
		if luaent and luaent.orcish_soldier and (not luaent.owner) and not luaent.general then
			luaent.owner = self.object
		end
	end
	end
end
local function go_to_group(self,speed,pos)
	local c = 0
	local total = 0
	local tpos
	local d = false
	local target = false
	local targetvektor = {x=0,y=0,z=0}
	for _,entity in ipairs(minetest.get_objects_inside_radius(pos,30)) do
		local luaent = entity:get_luaentity()
		if luaent and luaent.orcish_soldier then
			tpos = entity:getpos()
			d = vector.distance(pos,tpos)
			if d ~= 0 then
			total = total+1
			targetvektor = vector.add(targetvektor,tpos)
			if d < 3 then
				c = c+1
				if c > 4 then
					return false
				end
			end
			end
		end
	end
	if total > 0 then
	tpos = vector.subtract(vector.divide(targetvektor,total),pos)
	tpos.y = 0
	tpos = vector.multiply(vector.normalize(tpos),speed)
	return tpos
	else
	return false
	end
end
local dir_to_vec_walk = {{x=0,y=0,z=1},{x=0,y=0,z=-1},
{x=1,y=0,z=0},vector.normalize({x=1,y=0,z=1}),vector.normalize({x=1,y=0,z=-1}),
{x=-1,y=0,z=0},vector.normalize({x=-1,y=0,z=1}),vector.normalize({x=-1,y=0,z=-1})}
local function standard_walk_around(speed,dtime)
	if math.random(math.ceil(3/dtime)) == 1 then
		return vector.multiply(dir_to_vec_walk[math.random(1,8)],speed)
	end
end
local function force_standard_walk(speed)
	return vector.multiply(dir_to_vec_walk[math.random(1,8)],speed)
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
local function jump_needet(size,pos)
pos.y = (pos.y-(size+0.5))
local returning = minetest.registered_nodes[minetest.get_node(pos).name].walkable
local returningz = false
for x =-1,1 do
for y =-1,1 do
if not returningz then
returningz =  minetest.registered_nodes[minetest.get_node(vector.add(pos,{x=x,y=0.6,z=y})).name].walkable
else
break
end
end
end
return true
--return (returningz and returning)
end
local function entity_block(size,pos)
pos.y = (pos.y-(size+0.5))
local returning = minetest.registered_nodes[minetest.get_node(pos).name].walkable
local returningz = false
pos.y = pos.y+1
for x =-1,1 do
for y =-1,1 do
if not returningz then
returningz =  minetest.registered_nodes[minetest.get_node(vector.add(pos,{x=x,y=1,z=y})).name].walkable
else
break
end
end
end
return not (returningz and returning)
end
local function register_guard(def,spawnnodes,spawnchanche)
	if def.drops and (not default_standard_mob_drop_list[def.drops[1]]) and def.drops[2] then
	default_standard_mob_drop_list[def.drops[1]] = def.drops[2]
	end
	--def.speed = 0.01
	--local defbox = def.size/2
	minetest.register_entity("orcarmys:" .. def.name,{
		initial_properties = {
			name = def.name,
			hp_min = def.max_hp,
			hp_max = def.max_hp,
			visual_size = {x = 1, y = def.size, z = 1},
			visual = "mesh",
			mesh = --[[def.mesh or]] "final_player_character.b3d",--"character20.b3d",
			textures = def.textures or {def.name .. "shield.png^swordf.png",def.name .. ".png"},
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
			local deftextures = def.textures or {}
			set_mob_weapon_acc_race(self,sdata,{main_image = deftextures[1] or def.name .. ".png",
		shield_image = def.shield or "3d_shield_" .. def.name .. ".png",
		fighter_group = "ORC",
		mob_level = def.damage/6})
			self.lifetimer = sdata.lifetimer or 6000
			if type(self.lifetimer) ~= "number" then
				self.lifetimer = 6000
			end
			if first_spawn_at_all then
			self.object:set_armor_groups({fleshy = def.armor or 100,level = 1})
			end
			self.general = def.general
			self.orcish_soldier = true
			become_nearest_general(self,self.object:getpos())
			self.regentimer = sdata.regentimer or 1800
			self.on_gold_pay = def.on_gold_pay
			self.damage = def.damage
			self.lawname = "orcishlaw"
			self.on_diamond_pay = def.on_diamond_pay
			self.valar = def.name == "valar"
			self.damagetimer = 0
			self.timer = 0
			self.arrow_resistant = def.arrow_resistant
			self.jump = 0
			self.orc = true
			self.walkaround = {target = {},speed = def.speed,chanche = 100,calc = calctarget}
			self.object:setacceleration({x=0,y=-50,z=0})
		self.object:set_animation({
			x = 0,
			y = 80},
			30, 0)
			self.canimation = 1
			self.recruiting = 0
			--set_weapon(self,ItemStack("default:mithrilmace"),1,"elf.png","3d_shield_elven.png")
		end,
		-- ON PUNCH --
		-- ON STEP --
		get_staticdata = function(self)
			
			return add_first_spawn_flag(minetest.write_json({weapon = self.wielded_weapon_index,lifetimer = self.lifetimer,regentimer = self.regentimer}))end,
		on_rightclick = add_chestpriv_on_pay,
		on_step = function(self, dtime)
			self.timer = self.timer or (self.cooldown or 1)
			self.recruiting = (self.recruiting or 0)+dtime
			if self.recruiting > 3 then
			become_nearest_general(self,self.object:getpos())
			self.recruiting = 0
			end
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
			if not self.damagetimer then
				self.damagetimer = 0
				minetest.chat_send_all("FATA")
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
				if ((def.name == "thorin") or (def.name == "legolas") or (def.name == "valar"))and(math.random(1,60) == 1) and( not( target:get_luaentity() and (target:get_luaentity().name == "sauron:sauron"))) then
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
					--[[if self.owner then
							local togo = vector.subtract(self.owner:getpos(),pos)
							self.owner_distance = vector.length(togo)
							if self.owner_distance > 8 then
							self.targetvektor = vector.multiply(vector.normalize({x = togo.x,y = 0,z = togo.z}),def.speed)
							self.nextanimation = 3
							else
							self.nextanimation = 1
							self.targetvektor = vector.new()
							end
					else]]
						--self.walkaround = self.walkaround.calc(self.walkaround)
						self.nextanimation = 3
						local gtg = go_to_group(self,def.speed,pos)
						self.targetvektor = gtg or standard_walk_around(def.speed,dtime) or self.old_targetvektor or force_standard_walk(def.speed)
					--end
					if self.targetvektor then
					self.old_targetvektor = self.targetvektor
					self.targetvektor.y =self.waydown
					--elseif vector.length(self.object:getvelocity()) < def.speed then
					--self.old_targetvektor = 
					--self.targetvektor = self.old_targetvektor
					end
					if  vector.length(velocity) < def.speed  and entity_block(1,pos) then
					self.old_targetvektor = vector.multiply(self.old_targetvektor or force_standard_walk(def.speed),-1)
					self.targetvektor = self.old_targetvektor
					--self.targetvektor = self.old_targetvektor
					end




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
			local booljn = jump_needet(def.size,pos)
			if (self.jump == 0) and (vector.length(self.targetvektor) ~= 0) and boolstuck --[[and default_nodes_under_jumpable(def,pos) and]] and booljn then
				stomp(self,def.size)
			end
			self.object:setacceleration(self.gravity)
			self.object:setvelocity(self.targetvektor)
			self.object:setyaw(math.atan2(self.targetvektor.z,self.targetvektor.x)-math.pi/2)
			--else
				--self.object:setvelocity({x=0,y=0,z=0})		
				--self.nextanimation = 1
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
if def.general then
--regular_humanoid_spawn_registry("archers:" .. def.name,spawnnodes,spawnchanche)
end
end
local function may_spawn_on_floor(pos,x,z,name)
local pos = vector.add(pos,{x=x,y=-10,z=z})
local v = 0
for i=1,20 do
	pos.y = pos.y+1
	if minetest.get_node(pos).name == "air" then
		v = v+1
		if v == 2 then
			minetest.add_entity(pos,name)
			return true
		end
	else
		v=0
	end
end
return false
end
local function spawn_uruk_hai_army(pos,name_1,name_2,sidelen)
	name_1 = "orcarmys:"..name_1
	name_2 = "orcarmys:"..name_2
	if minetest.get_node(pos).name == "air" and minetest.get_node(vector.add(pos,{x=0,y=1,z=0})).name == "air" then
		--minetest.add_entity(pos,name_1)
	local x0 = math.floor(-0.5*sidelen)
	local z0 = math.floor(-0.5*sidelen)
	--[[local r = math.random(1,4)
	if r == 1 then
		x0 = 1
	elseif r == 2 then
		x0 = -sidelen-1
	elseif r == 3 then
		z0 = 1
	else
		z0 = -sidelen-1
	end]]
	for x= x0,x0+sidelen do
	for z = z0,z0+sidelen do
	may_spawn_on_floor(pos,x,z,name_2)
	end
	end
	end
end
local noshield = "doors_blank.png"
register_guard({
	damage = 5,
	name = "lottmobs_uruk_hai",
	max_hp = 30,
	general = true,
	size = 1,
	armor = 30,
	speed = 3
},{"default:mordordust_mapgen","default:mordordust","default:angmarsnow"},800)
register_guard({
	damage = 5,
	name = "lottmobs_uruk_hai_general",
	max_hp = 30,
	general = true,
	size = 1,
	armor = 30,
	speed = 3
},{"default:mordordust_mapgen","default:mordordust","default:angmarsnow"},16000)
default_register_sbm({
	nodenames = "default:mordordust_mapgen",
	chance = 200000,
	action = function(pos)
		pos.y = pos.y+1
		spawn_uruk_hai_army(pos,"lottmobs_uruk_hai_general","lottmobs_uruk_hai",12)
	end}
)
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


