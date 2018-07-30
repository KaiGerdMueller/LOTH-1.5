-- Minetest mod: creepers
-- (c) Kai Gerd Müller
-- See README.txt for licensing and other information.
local standardguardslist = {["default:mese"]="mese",["default:steelblock"]="steel",["default:copperblock"]="copper",["default:goldblock"]="gold",["default:bronzeblock"]="bronze",["default:diamondblock"]="diamond",["default:obsidian"]="obsidian"}
local function animate(self, t)
	if t == 1 and self.canimation ~= 1 then
		self.object:set_animation({
			x = 0,
			y = 250},
			10, 0)
		self.canimation = 1
	elseif t == 2 and self.canimation ~= 2 then
		self.object:set_animation({x = 0,y = 250},250, 0)
		self.canimation = 2
	--walkmine
	elseif t == 3 and self.canimation ~= 3 then
		self.object:set_animation({x = 0,y = 250},500, 0)
		self.canimation = 3
	--walk
	end
end
local function catch_wargrider(self)
local pos = self.object:getpos()
local min_dist = 4
local target = false
for _,i in pairs(minetest.get_objects_inside_radius(self.object:getpos(),3)) do
		local lentity = i:get_luaentity()
		if lentity and lentity.orc and (not lentity.warg) and lentity.it_is_a_riding_creature then
			local p = i:getpos()
			local dist = vector.distance(pos,p)
			if dist < min_dist then
				min_dist = dist
				target = i
			end
		end
end
if target then
self.catched_rider = true
target:set_attach(self.object, "", {x = 0, y = 10, z = 0}, {x = 0, y = 180, z = 0})
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
								if default_do_not_punch_this_stuff(luaent) and (minetest.line_of_sight(vector.add(pos,{x=0,y=5,z=0}),vector.add(p,{x=0,y=5,z=0}), 2,entity) == true or minetest.line_of_sight(pos,p, 2,entity) == true --[[or minetest.line_of_sight(vector.add(pos,{x=0,y=1,z=0}),vector.add(p,{x=0,y=1,z=0}), 2) == true]]) and dist < min_dist then
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
local function set_horse_attach(h,clicker)
	local self = h:get_luaentity()
				self.owner = clicker
				self.owner_name = clicker:get_player_name()
				clicker:set_attach(self.object, "", {x = 0, y = 10, z = 0}, {x = 0, y = 180, z = 0})
end
local function set_horse(self,c)
	local name = c:get_player_name()
	if orcishplayers[name] then
	local horse = minetest.add_entity(self.object:getpos(),"horses:warg")
	horse:setyaw(self.object:getyaw())
	self.object:remove()
	set_horse_attach(horse,c)
	end
end
local function register_guard(def,spawnnodes,spawnchanche)
	if def.drops and (not default_standard_mob_drop_list[def.drops[1]])and def.drops[2] then
	default_standard_mob_drop_list[def.drops[1]] = def.drops[2]
	end
	minetest.register_entity("wargs:" .. def.name,{
		initial_properties = {
			name = def.name,
			hp_min = def.max_hp,
			hp_max = def.max_hp,
			visual_size = {x = 1, y = 1, z = 1},
			visual = "mesh",
			mesh = "LOTHWARG1.b3d",
			textures = {"wargtex2.png"},
			collisionbox = {-0.8, -1.2, -0.8, 0.8, 0.6, 0.8},
			physical = true
		},
		-- ON ACTIVATE --
		on_punch = function(self) if self.object:get_hp() <= 0 then minetest.add_item(self.object:getpos(),"farming:meat " .. def.meat) self.object:remove()end end,--lawbreak_on_punch,
		on_activate = function(self)
			if def.drops then
				self.drops = def.drops
			end
			self.lifetimer = 600
			self.warg = true
			self.damagetimer = 0
			self.timer = 0
			self.jump = 0
			self.orc = true
			--self.lawname = "orcishlaw"
			self.walkaround = {target = {},speed = def.speed,chanche = 100,calc = calctarget}
			self.object:setacceleration({x=0,y=-50,z=0})
		self.object:set_animation({
			x = 0,
			y = 80},
			30, 0)
			self.canimation = 1
		end,
		-- ON PUNCH --
		-- ON STEP --
		on_rightclick = set_horse,
		on_step = function(self, dtime)
			self.lifetimer = self.lifetimer-dtime
			if self.lifetimer < 0 then
				self.object:remove()
			end
			if not self.catched_rider then
			catch_wargrider(self)
			end
			local pos = self.object:getpos()
			--if self.owner_name then
			--self.owner = minetest.get_player_by_name(self.owner_name)
			self.animation_set = true
			self.gravity = {x=0,y=-50,z=0}
			self.targetvektor = nil
			if self.timer < 1 then
			self.timer = self.timer+dtime
			end
			local posvar = self.object:getpos()
			local abov = minetest.get_node(posvar).name
			if abov == "default:lava_source" or abov == "default:lava_flowing" then
				self.object:remove()
			else
			posvar.y = posvar.y+0.5
			abov = minetest.get_node(posvar).name
			if default_is_swimmable(abov) then
				minetest.add_item(vector.add(pos,{x=0,y=1,z=0}),"farming:meat 2")
				self.object:remove()
			end
			end
			--db({minetest.get_node(vector.subtract(pos,{x=0,y=1,z=0})).name})
			local punching = false
			if self.timer >= 1 then
				local target = get_nearest_enemy(self,pos,3.6)
				if target then
				target:punch(self.object, 1.0, {full_punch_interval=1.0,damage_groups = {fleshy=def.damage}})
				if target:is_player() then
					add_to_law_status(target:get_player_name(),self.lawname,-def.damage)
				end
				self.timer = 0
				end
			end
			local target = get_nearest_enemy(self,pos,25)
			local waydown = self.object:getvelocity().y
			if target then
			target = target:getpos()
			self.targetvektor = vector.multiply(vector.normalize({x=target.x-pos.x,y=waydown,z=target.z-pos.z}),def.speed)
			end
			if not self.targetvektor then
					self.walkaround = self.walkaround.calc(self.walkaround)
					self.targetvektor = self.walkaround.target
					self.targetvektor.y = waydown
					self.nextanimation = 3
					self.animation_set = false
			end
			local velocity = self.object:getvelocity()
			self.jump = (self.jump +1)%10
			if self.targetvektor then
			if self.animation_set then
				self.nextanimation = 2
			end
			--if  minetest.get_node(vector.add(pos,{x=0,y=1,z=0})).name == "default:water_source" then
			--	self.targetvektor.y = 1
			--end
			if self.jump == 0 and vector.distance(vector.new(),velocity)<def.speed/3 and velocity.y == 0 and minetest.registered_nodes[minetest.get_node(vector.add(pos,{x=0,y=-1.7,z=0})).name].walkable then
				stomp(self,1)		
			end
			self.object:setacceleration(self.gravity)
			self.object:setvelocity(self.targetvektor)
			self.object:setyaw(math.atan2(self.targetvektor.z,self.targetvektor.x)+math.pi/2)
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
			--add_standard_mob_drop(self)
			minetest.add_item(self.object:getpos(),"farming:meat " .. def.meat)
			self.object:remove()
		end
	})
regular_humanoid_spawn_registry("archers:" .. def.name,spawnnodes,spawnchanche)
end

register_guard({
	damage = 3,
	name = "warg",
	drops = {"orc"},
	max_hp = 80,
	size = 1,
	meat = "2",
	speed = 8
},{"default:mordordust","default:angmarsnow","default:fangorndirt"},1000)
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


