-- Minetest mod: creepers
-- (c) Kai Gerd Müller
-- See README.txt for licensing and other information.

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
		if (luaent and (not luaent.orc) and (not luaent.balrog)) or (entity:is_player() and(
		(not orcishplayers[name])
		 or (orcishlaw[name]  and orcishlaw[name] > 0  )
		)) then
		local p = entity:getpos()
		local dist = vector.distance(pos,p)
				if default_do_not_punch_this_stuff(luaent) and (minetest.line_of_sight(vector.add(pos,{x=0,y=5,z=0}),vector.add(p,{x=0,y=5,z=0}), 2) == true or minetest.line_of_sight(pos,p, 2) == true --[[or minetest.line_of_sight(vector.add(pos,{x=0,y=1,z=0}),vector.add(p,{x=0,y=1,z=0}), 2) == true]]) and dist < min_dist then
			min_dist = dist
			min_player = player
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
	for _,entity in ipairs(minetest.get_objects_inside_radius(pos,radius)) do
		if entity:is_player() then
			local p = entity:getpos()
			local dist = vector.distance(pos,p)
			if dist < min_dist then
				min_dist = dist
				min_player = player
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
function need_to_spawn_guard(self,pos)
local t = {}
local c = 1
self.necrotable = self.necrotable or {}
for _,i in pairs(self.necrotable) do
if i and i:get_hp() >0 then
table.insert(t,i)
c = c+1
end
end
self.necrotable = t
if c < 11 then
table.insert(self.necrotable,minetest.add_entity(pos,"nazgul:ghost"))
end
end
function default_is_swimmable(nname)
	return nname == "default:water_source" or nname == "default:lava_source" or nname == "default:magma_source" or nname == "default:mud_source" or nname == "default:lava_flowing" or nname == "default:magma_flowing" or nname == "default:water_flowing" or nname == "default:mud_flowing" or nname == "default:river_water_flowing" or nname == "default:river_water_source"
end

local function register_guard(def,spawnnodes,spawnchanche)
	if def.drops and (not default_standard_mob_drop_list[def.drops[1]])and def.drops[2] then
	default_standard_mob_drop_list[def.drops[1]] = def.drops[2]
	end
	local defbox = 0.4
	minetest.register_entity("necromancer:" .. def.name,{
		initial_properties = {
			name = def.name,
			hp_min = def.max_hp,
			hp_max = def.max_hp,
			visual_size = {x = def.size, y = def.size, z = def.size},
			visual = "mesh",
			mesh = "character.b3d",
			textures = {"blackcolor.png"},
			collisionbox = {-defbox, -def.size, -defbox, defbox, def.size, defbox},
			physical = true
		},
		-- ON ACTIVATE --
		on_punch = default_add_boss_kill_flag,
		on_activate = function(self,sdata)
			self.it_is_a_riding_creature = true
			local sdata,first_spawning = self_first_spawn(sdata)
			if def.drops then
				self.drops = def.drops
			end
			if first_spawning then
				self.object:set_armor_groups({fleshy = 8,level = 1})
			end
			self.damage = def.damage
			self.timer = 0
			self.jump = 0
			self.orc = true
			self.balrog = true
			self.lawname = "orcishlaw"
			self.walkaround = {target = {},speed = def.speed,chanche = 100,calc = calctarget}
			self.object:setacceleration({x=0,y=-50,z=0})
		self.object:set_animation({
			x = 0,
			y = 80},
			30, 0)
			self.canimation = 1
			self.regentimer = tonumber(static) or 1800
		end,
		get_staticdata = function(self)
		return add_first_spawn_flag(tostring(self.regentimer))
		end,
		-- ON PUNCH --
		-- ON STEP --
		on_step = function(self, dtime)
			self.regentimer = self.regentimer-dtime
			if self.regentimer < 0 then
			self.regentimer = 1800
			self.object:set_hp(def.max_hp)
			end
			local pos = self.object:getpos()
			minetest.add_particlespawner({
			amount = 5,
			time = 0.5,
			minpos = vector.subtract(pos,{x=0.5,y=0.5,z=0.5}),
			maxpos = vector.add(pos,{x=0.5,y=0.5,z=0.5}),
			minvel = {x=-1,y=-1,z=-1},
			maxvel = {x=1,y=1,z=1},
			minacc = {x=0, y=0, z=0},
			maxacc = {x=0, y=0, z=0},
			minexptime = 1,
			maxexptime = 2,
			minsize = 1,
			maxsize = 3,
			collisiondetection = false,
			texture = "blackcolor.png",
	})
			--if self.owner_name then
			--self.owner = minetest.get_player_by_name(self.owner_name)
			self.animation_set = true
			self.gravity = {x=0,y=-50,z=0}
			self.targetvektor = nil
			if self.timer < 1 then
			self.timer = self.timer+dtime
			end
			--db({minetest.get_node(vector.subtract(pos,{x=0,y=1,z=0})).name})
			local punching = false
			if self.timer >= 1 then
				local target = get_nearest_enemy(self,pos,def.size*3,true)
				if target and target:get_hp() > 0 then
				target:punch(self.object, 1.0, {full_punch_interval=1.0,damage_groups = {fleshy=def.damage}})
				if target:is_player() then
					add_to_law_status(target:get_player_name(),self.lawname,-def.damage)
poisoning_standard(target,9)
				end
				end
				self.timer = 0
			end
			local target = get_nearest_enemy(self,pos,25)
			self.waydown = self.object:getvelocity().y
			if target then
			if self.timer == 0 then
				need_to_spawn_guard(self,pos)
			end
			target = target:getpos()
			self.targetvektor = vector.multiply(vector.normalize({x=target.x-pos.x,y=self.waydown,z=target.z-pos.z}),def.speed)
			end
			if not self.targetvektor then
					self.walkaround = self.walkaround.calc(self.walkaround)
					self.targetvektor = self.walkaround.target
					self.targetvektor.y = self.waydown
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
				stomp(self,1)	
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
register_guard({
	damage = 6,
	name = "witchy",
	drops = {"orc"},
	max_hp = 6000,
	size = 1,
	speed = 2
},{"default:mordordust_mapgen","default:mordordust","default:angmarsnow","default:netherrack"},12000)
--[[register_guard({
	damage = 2,
	name = "standardorc",
	drops = {"orc"},
	mesh = "character.b3d",
	textures = {"orccharacter2.png"},
	max_hp = 20,
	size = 0.9,
	speed = 3
},{"default:fangorndirt","default:brownlandsdirt","default:mordordust_mapgen","default:angmarsnow"},1000)
]]--[[register_guard({
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


