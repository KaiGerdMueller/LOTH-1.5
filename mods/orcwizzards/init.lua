-- Minetest mod: creepers
-- (c) Kai Gerd Müller
-- See README.txt for licensing and other information.
local mob_schems = {}
minetest.after(0,function()
	mob_schems = hudwel_mob_weapon_table
end)
local function set_weapon(self,item,mob_level,mobtex,shieldtex)
	--local def = item:get_definition()
	self.damage = 2
	self.cooldown = 1
	self.object:set_properties({textures = {"doors_blank.png","magicdamnwand.png","bad_mage.png"}})
end
local function set_mob_weapon_acc_race(self,sdata,selfish)
if sdata and sdata.weapon then
set_weapon(self,nil,selfish.main_image,selfish.shield_image or "doors_blank.png")
else
self.wielded_weapon_index = "STEELSWORD"
set_weapon(self,nil,selfish.mob_level,selfish.main_image,selfish.shield_image or "doors_blank.png")
end
end
hudwel_mob_weapon_table = mob_schems
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
		local name = entity:get_player_name()
		if (luaent and (not luaent.orc)) or (entity:is_player() and(
		(not orcishplayers[name])
		 or (orcishlaw[name]  and orcishlaw[name] > 0  )
		)) then
		local p = entity:getpos()
		local dist = vector.distance(pos,p)
				if default_do_not_punch_this_stuff(luaent) and dist < min_dist then
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
local function register_guard(def,spawnnodes,spawnchanche)
	if def.drops and (not default_standard_mob_drop_list[def.drops[1]]) and def.drops[2] then
	default_standard_mob_drop_list[def.drops[1]] = def.drops[2]
	end
	--local defbox = def.size/2
	minetest.register_entity("orcwizzards:" .. def.name,{
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
		on_punch = lawbreak_on_punch,
		on_activate = function(self,sdata)
			self.it_is_a_riding_creature = true
			local sdata,first_sp = self_first_spawn(sdata)
			if def.drops then
				self.drops = def.drops
			end
			if sdata and sdata ~= "" then
			sdata = minetest.parse_json(sdata) or {}
			else
			sdata = {}
			end
			local deftextures = def.textures or {}
			set_mob_weapon_acc_race(self,sdata,{main_image = deftextures[1] or def.name .. ".png",
		shield_image = def.shield or "3d_shield_" .. def.name .. ".png",
		fighter_group = string.upper(def.drops[1]),
		mob_level = def.damage/6})
			self.lifetimer = sdata.lifetimer or 6000
			if first_sp then
			self.object:set_armor_groups({fleshy = def.armor or 100,level = 1})
			end
			self.on_gold_pay = def.on_gold_pay
			self.damage = def.damage
			self.lawname = "orcishlaw"
			self.damagetimer = 0
			self.timer = 0
			self.jump = 0
			self.orc = true
			self.walkaround = {target = {},speed = def.speed,chanche = 100,calc = calctarget}
			self.object:setacceleration({x=0,y=-50,z=0})
		self.object:set_animation({
			x = 0,
			y = 80},
			30, 0)
			self.canimation = 1
			--set_weapon(self,ItemStack("default:mithrilmace"),1,"elf.png","3d_shield_elven.png")
		end,
		-- ON PUNCH --
		-- ON STEP --
		get_staticdata = function(self)
			return add_first_spawn_flag(minetest.write_json({weapon = self.wielded_weapon_index,lifetimer = self.lifetimer}))end,
		on_rightclick = add_chestpriv_on_pay,
		on_step = function(self, dtime)
			self.lifetimer = self.lifetimer-dtime
			if self.lifetimer < 0 then
				self.object:remove()
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
			elseif minetest.get_node(vector.subtract(pos,{x=0,y=0.5,z=0})).name == "default:lava_source" or minetest.get_node(vector.subtract(pos,{x=0,y=0.5,z=0})).name == "default:lava_flowing" then
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
				local target = get_nearest_enemy(self,pos,def.size*3,true)
				if target then
				target:punch(self.object, 1.0,  {full_punch_interval=1.0,damage_groups = {fleshy=self.damage}})
					if target:is_player() then
					add_to_law_status(target:get_player_name(),self.lawname,-self.damage)
					end
				end
				self.timer = 0
			end
			local target = get_nearest_enemy(self,pos,25)
			self.waydown = self.object:getvelocity().y
			if target then
				if math.random(math.ceil(3/dtime)) == 1 then
				minetest.add_entity(pos,"lotharrows:bad_mageball")
				end
			target = target:getpos()
			self.targetvektor = vector.multiply(vector.normalize({x=target.x-pos.x,y=self.waydown,z=target.z-pos.z}),def.speed)
			local oldtx = target.x
			target.x = target.z
			target.z = oldtx
			end
			if not self.targetvektor then
					self.walkaround = self.walkaround.calc(self.walkaround)
					self.targetvektor = self.walkaround.target
					self.targetvektor.y =self.waydown
					self.nextanimation = 3
					self.animation_set = false
			end
			local velocity = self.object:getvelocity()
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
			if self.jump == 0 and vector.distance(vector.new(),velocity)<def.speed/10 and velocity.y == 0 and default_nodes_under_jumpable(def,pos) then
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
regular_humanoid_spawn_registry("orcwizzards:" .. def.name,spawnnodes,spawnchanche)
end

--[[minetest.register_abm({
	nodenames = {"default:stone_with_iron"},
	neighbors = {"air"},
	label = "spawn",
	catch_up = false,
	interval = 10,
	chance = 12000,
	action = function(p)
		p.y = p.y+1
		local p2 = p
		p2.y = p2.y+1
		if minetest.get_node(p).name == "air" and minetest.get_node(p2).name == "air" then
			minetest.add_entity(p,"orcwizzards:standarddwarf")
		end
	end,
})]]
local noshield = "doors_blank.png"
shield = noshield,
register_guard({
	damage = 5,
	name = "bad_mage",
	drops = {"orc"},
	max_hp = 900,
	size = 1,
	armor = 30,
	speed = 3
},
{"default:mordordust_mapgen","default:mordordust","default:angmarsnow"},8000)
--[[register_guard({
	damage = 12,
	name = "elf",
	drops = {"elf"},
	max_hp = 90,
	armor = 15,
	size = 1,
	speed = 4
},{"default:loriendirt"},1000)
register_guard({
	damage = 11,
	name = "standardelf",
shield = noshield,
	textures = {"elfcharacter.png"},
	mesh = "character.b3d",
	drops = {"elf"},
	max_hp = 85,
	size = 1,
	speed = 4
},{"default:mirkwooddirt","default:loriendirt"},10000)
register_guard({
	damage = 9,
	name = "human",
	drops = {"human"},
	max_hp = 60,
	armor = 20,
	size = 1,
	speed = 3
},{"default:gondordirt","default:ithiliendirt"},1000)
register_guard({
	damage = 8,
	name = "standardhuman",
	drops = {"human"},
shield = noshield,
	textures = {"humancharacter.png"},
	mesh = "character.b3d",
	max_hp = 55,
	size = 1,
	speed = 3
},{"default:gondordirt","default:ithiliendirt","default:rohandirt"},1000)
register_guard({
	damage = 6,
	name = "dwarf",
	on_gold_pay = dwarf_gold_pay,
	drops = {"dwarf"},
	armor = 10,
	max_hp = 120,
	size = 0.75,
	speed = 2
},{"default:ironhillsdirt"},1000)
register_guard({
	damage = 5,
	name = "standarddwarf",
	drops = {"dwarf"},
shield = noshield,
	textures = {"dwarfcharacter.png"},
	mesh = "character.b3d",
	max_hp = 115,
	size = 0.75,
	speed = 2
},{"default:ironhillsdirt"},1000)]]
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


