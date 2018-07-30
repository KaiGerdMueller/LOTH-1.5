-- Minetest mod: creepers
-- (c) Kai Gerd Müller
-- See README.txt for licensing and other information.
local standardguardslist = {["default:mese"]="mese",["default:steelblock"]="steel",["default:copperblock"]="copper",["default:goldblock"]="gold",["default:bronzeblock"]="bronze",["default:diamondblock"]="diamond",["default:obsidian"]="obsidian"}
local function animate(self, t)
	if t == 1 and self.canimation ~= 1 then
		self.object:set_animation({
			x = 0,
			y = 80},
			3--[[30]], 0)
		self.canimation = 1
	elseif t == 2 and self.canimation ~= 2 then
		self.object:set_animation({x = 200,y = 220},3--[[30]], 0)
		self.canimation = 2
	--walkmine
	elseif t == 3 and self.canimation ~= 3 then
		self.object:set_animation({x = 168,y = 188},3--[[30]], 0)
		self.canimation = 3
	--walk
	end
end
local function get_nearest_enemy(self,pos,radius)
	local min_dist = radius+1
	local target = false
	for _,entity in ipairs(minetest.get_objects_inside_radius(pos,25)) do
		local luaent = entity:get_luaentity()
		local name = entity:get_player_name()
		if (luaent and (not luaent.balrog)) or (entity:is_player() and (not( entity:get_player_name() == self.owner)))  then
		local p = entity:getpos()
		local dist = vector.distance(pos,p)
				if default_do_not_punch_this_stuff(luaent) and dist < min_dist then
			min_dist = dist
			target = entity
		end
		end
	end
return target
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
	if def.drops and (not default_standard_mob_drop_list[def.drops[1]])and def.drops[2] then
	default_standard_mob_drop_list[def.drops[1]] = def.drops[2]
	end
	local defbox = def.size/3
	minetest.register_entity("balrog:" .. def.name,{
		initial_properties = {
			name = def.name,
			hp_min = def.max_hp,
			hp_max = def.max_hp,
			visual_size = {x = def.size, y = def.size, z = def.size},
			visual = "mesh",
			mesh = "balrog6.b3d",
			textures = {"balrog.png"},
			collisionbox = {-defbox, -def.size, -defbox, defbox, def.size, defbox},
			physical = true
		},
		-- ON ACTIVATE --
		on_punch = function(self,ent) 
			if ent and ent:get_player_name() == self.owner and self.object:get_hp() < def.max_hp/2 then
				self.owner = "meaner.txt"
				self.g_mode = nil
			end
			default_add_boss_kill_flag(self,ent)
			end,
		on_activate = function(self,static)
			local static,very_first = self_first_spawn(static)
			self.tnt_blast_resistant = true
			self.arrow_resistant = true
			if very_first then
			self.object:set_armor_groups({fleshy = 8,level = 1})
			end
			if def.drops then
				self.drops = def.drops
			end
			self.timer = 0
			self.lava_resistant = true
			local split_index = string.find(static,"#")
			if split_index then
			local split_index2 = string.find(static,"\n")
			if split_index2 then
				static = string.sub(static,1,split_index2-1)
				self.g_mode = true
			end
			self.regentimer = tonumber(string.sub(static,1,split_index-1))
			self.owner = string.sub(static,split_index+1)
			else
			static = "1800#singleplayer.txt"
			local split_index = string.find(static,"#")
			self.regentimer = tonumber(string.sub(static,1,split_index-1))
			self.owner = string.sub(static,split_index+1)
			end
			self.damage = def.damage
			self.jump = 0
			self.balrog = true
			self.lawname = "orcishlaw"
			self.walkaround = {target = {},speed = def.speed,chanche = 100,calc = calctarget}
			self.object:setacceleration({x=0,y=-50,z=0})
		self.object:set_animation({
			x = 0,
			y = 80},
			30, 0)
			self.canimation = 1
		end,
		get_staticdata = function(self)
		if self.g_mode then
			return add_first_spawn_flag(tostring(self.regentimer or 1800) .. "#" .. (self.owner or "dfd.txt") .. "\n")
		end
		return add_first_spawn_flag(tostring(self.regentimer or 1800) .. "#" .. (self.owner or "dfd.txt"))
		end,
		on_rightclick = function(self,click)
			if click and click:get_player_name() == self.owner then
				self.g_mode = not self.g_mode
			end
		-- ON PUNCH --
		end,
		-- ON PUNCH --
		-- ON STEP --
		--on_rightclick = add_chestpriv_on_pay,
		on_step = function(self, dtime)
			local pos = self.object:getpos()
			--if self.owner_name then
			--self.owner = minetest.get_player_by_name(self.owner_name)
			self.animation_set = true
			self.gravity = {x=0,y=-50,z=0}
			self.targetvektor = nil
			if self.timer < 1 then
			self.timer = self.timer+dtime
			end
			self.regentimer = self.regentimer - dtime
			if self.regentimer < 0 then
			self.regentimer = 1800
			self.object:set_hp(def.max_hp)
			end
			--db({minetest.get_node(vector.subtract(pos,{x=0,y=1,z=0})).name})
			local punching = false
			local target = get_nearest_enemy(self,pos,def.size*2)
			if target and self.timer >= 1 then
				target:punch(self.object, 1.0, {full_punch_interval=1.0,damage_groups = {fleshy=def.damage}})
				tnt.boom(vector.divide(vector.add(pos,target:getpos()),2), {radius = 5,damage_radius = 3,hellish_explosion = true})
				if math.random(1,60) == 1 then
					target:set_hp(0)
				end
--				if target:is_player() then					
--				end
				self.timer = 0
			end
			self.waydown = self.object:getvelocity().y
			local target = get_nearest_enemy(self,pos,20)
			if target then
			target = target:getpos()
			self.targetvektor = vector.multiply(vector.normalize({x=target.x-pos.x,y=self.waydown,z=target.z-pos.z}),def.speed)
			end
			if not self.targetvektor then
					if self.g_mode then
					self.targetvektor = vector.new()
					else
					self.walkaround = self.walkaround.calc(self.walkaround)
					self.targetvektor = self.walkaround.target
					self.targetvektor.y =self.waydown
					self.nextanimation = 3
					self.animation_set = false
					end
			end
			local velocity = self.object:getvelocity()
			self.jump = (self.jump +1)%10
			if self.jump == 0 then
		pos.y = pos.y - def.size
		local n = minetest.get_node(pos).name
		if (not default_is_swimmable(n)) and not ((((pos.x*pos.x)+(pos.z*pos.z)) < 62500) and pos.y < -5695 and pos.y > -6056)  then
		minetest.set_node(pos,{name = "default:lava_source"})
		end
		pos.y = pos.y +def.size
		for i = 1,6 do
		local newflamepos = vector.add(pos,{x=math.random(2,-2),y=math.random(2,-2),z=math.random(2,-2)})
		if minetest.get_node(newflamepos).name ~= "default:magma_source" then
		minetest.set_node(newflamepos,{name = "fire:basic_flame"})
		end
		end
	minetest.add_particlespawner({
		amount = 128,
		time = 0.5,
		minpos = vector.subtract(pos, {x=defbox,y=def.size,z=defbox}),
		maxpos = vector.add(pos, {x=defbox,y=def.size,z=defbox}),
		minvel = {x = -1, y = -1, z = -1},
		maxvel = {x = 1, y = 1, z = 1},
		minacc = vector.new(),
		maxacc = vector.new(),
		minexptime = 1,
		maxexptime = 2.5,
		minsize = 1,
		maxsize = 5,
		texture = "default_lava.png",
	})
end
			if self.targetvektor then
			if self.animation_set then
				self.nextanimation = 2
			end
			pos.y = pos.y -(def.size-1)
			local n = minetest.get_node(pos).name
			if default_is_swimmable(n) then
				self.gravity = {x=0,y=0,z=0}
			end
			pos.y = pos.y +(def.size-1)
			local n = minetest.get_node(pos).name
			if default_is_swimmable(n) then
				self.targetvektor.y = 1
			end
			if self.jump == 0 and vector.distance(vector.new(),velocity)<def.speed/10 and velocity.y == 0 --[[minetest.registered_nodes[minetest.get_node(vector.add(pos,{x=0,y=-(def.size-1),z=0})).name].walkable]] then
				stomp(self,2)		
			end
			self.object:setacceleration(self.gravity)
			self.object:setvelocity(self.targetvektor)
			if self.targetvektor.z ~= 0 or self.targetvektor.x ~= 0 then
			self.object:setyaw(math.atan2(self.targetvektor.z,self.targetvektor.x)-math.pi/2)
			end
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
default_register_sbm({
	label = "spawn",
	catch_up = false,
	nodenames = spawnnodes,
	neighbors = {"air"},
	interval = 10,
	chance = spawnchanche*6,
	action = function(p)
		p.y = p.y+1
		local p2 = p
		p2.y = p2.y+5
		if minetest.get_node(p).name == "air" and minetest.get_node(p2).name == "air" then
			minetest.add_entity(p,"balrog:" .. def.name)
--			db({"SCCESSS"})
		end
	end,
})
end
register_guard({
	damage = 160,
	name = "balrog",
	drops = {"orc"},
	max_hp = 18000,
	size = 5,
	speed = 3
},{"default:lava_source","default:netherrack"},36000)
--[[register_guard({
	damage = 2,
	name = "standardorc",
	drops = {"orc"},
	mesh = "character.b3d",
	textures = {"orccharacter2.png"},
	max_hp = 20,
	size = 0.9,
	speed = 3
},{"default:fangorndirt","default:brownlandsdirt","default:mordordust","default:angmarsnow"},1000)]]
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


