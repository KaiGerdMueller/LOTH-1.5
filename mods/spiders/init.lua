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
minetest.register_entity("spiders:mover",{
	hp_max	= 1000000,
	physical= true,
	collisionbox= { -1/2, -1/2, -1/2, 1/2, 1/2, 1/2 },
	textures= {"doors_blank.png"},
	timer	= 0,
	physical_state	= true,
	on_activate = function(sf,sd)
		local sd = sd or false
		if sd and (string.sub(sd,1,7) == "player/") then
			sd = string.sub(sd,8)
			sd = minetest.parse_json(sd) or {}
			if sd.v then
				sf.att = minetest.get_player_by_name(sd.v)
			end
			sf.time = sd.t
			if sf.att then
				sf.att:set_attach(sf.object, "", {x = 0, y = 0, z = 0}, {x = 0, y = 0, z = 0})
			end
		end
		sf.object:set_armor_groups({immortal =1})
		sf.timer = 0
		sf.checkplayerattached = true
	end,
	get_staticdata = function(self)
		local ret = ""
		if self.att then
			ret = "player/" .. minetest.write_json({v = self.att:get_player_name(),t = self.time - self.timer})
		end
		return ret
	end,
	on_step = function( sf, dt )
		if sf.poison and (sf.timer >= 6) then
			sf.time=  sf.time-sf.timer
			sf.timer = 0
			sf.att:set_hp(sf.att:get_hp()-sf.poison)
		else
			sf.timer = sf.timer+dt
		end
		if (sf.timer >= (sf.time or 1)) or (sf.att and sf.att:get_hp()<= 0) or (sf.object:get_hp() <= 0) then
				if sf.att then
				sf.att:set_detach()
				end
			sf.object:remove()
		end
	end
})
function add_player_mover_for_time(player,t)
	local emp = minetest.add_entity( player:getpos(), 'spiders:mover' )
	player:set_attach(emp, "", {x = 0, y = 0, z = 0}, {x = 0, y = 0, z = 0})
	local enti = emp:get_luaentity()
	enti.time = t
	enti.att = player
	return emp
end
function player_setvelocity(player,v,t)
if not t then
t = 1
end
add_player_mover_for_time(player,t):setvelocity(v)
end
function player_poison_stun(player,t,damage)
if not t then
t = 1
end
local poison = add_player_mover_for_time(player,t)
poison:setvelocity({x=0,y=0,z=0})
poison:get_luaentity().poison = damage
end
local function get_nearest_enemy(self,pos,radius,fucking_punchtest)
	local min_dist = radius+1
	local target = false
	for _,entity in ipairs(minetest.get_objects_inside_radius(pos,radius)) do
		local luaent = entity:get_luaentity()
		if (luaent and (not luaent.spider) and (not luaent.orc) and (not (self.balrog and (luaent.balrog or luaent.friends_of_shelob)))) or entity:is_player() then
		local p = entity:getpos()
		local dist = vector.distance(pos,p)
		if --[[minetest.line_of_sight(vector.add(pos,{x=0,y=5,z=0}),vector.add(p,{x=0,y=5,z=0}), 2) == true and]] dist < min_dist and default_do_not_punch_this_stuff(luaent) then
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
local on_punch_funct = lawbreak_on_punch
if def.name == "shelob" then
on_punch_funct = default_add_boss_kill_flag
end
	local defbox = def.size/2
	minetest.register_entity("spiders:" .. def.name,{
		initial_properties = {
			name = def.name,
			hp_min = def.max_hp,
			hp_max = def.max_hp,
			visual_size = {x = def.size, y = def.size, z = def.size},
			visual = "mesh",
			mesh = "lothspiderxxl.b3d",
			textures = {def.skin,def.skin,def.skin,def.skin,def.skin},
			collisionbox = {-defbox/2, -0.01, -defbox/2, defbox/2, defbox*0.9, defbox/2},
			physical = true
		},
		-- ON ACTIVATE --
		on_punch = on_punch_funct,
		on_activate = function(self)
			if def.name == "shelob" then
				self.balrog = true
				self.friends_of_shelob = true
			end
			self.poison = new_poison_storage(math.random(33,666),math.random(33,9))
			self.lifetimer = 6000
			self.damagetimer = 0
			self.timer = 0
			self.stuntimer = 0
			self.jump = 0
			self.damage = def.damage
			self.orc = true
			self.spider = true
			self.lawname = "orcishlaw"
			self.walkaround = {target = {},speed = def.speed,chanche = 100,calc = calctarget}
			self.object:setacceleration({x=0,y=-50,z=0})
		self.object:set_animation({
			x = 0,
			y = 80},
			30, 0)
			self.canimation = 1
			self.poisontimer = 0
		end,
		-- ON PUNCH --
		-- ON STEP --
		--on_rightclick = add_chestpriv_on_pay,
		on_step = function(self, dtime)
			if self.stuntimer > 0 then
				self.stuntimer = self.stuntimer -dtime
			end
			self.lifetimer = self.lifetimer-dtime
			if self.lifetimer < 0 then
				self.object:remove()
			end
			self.poisontimer = self.poisontimer + dtime
			if self.poisontimer >= 1 then
			self.poisontimer = 0
			self.poison = self.poison.charge(self.poison)
			end
			local pos = self.object:getpos()
			if true then--self.owner_name then
			--self.owner = minetest.get_player_by_name(self.owner_name)
			self.animation_set = true
			self.gravity = {x=0,y=-50,z=0}
			self.targetvektor = nil
			if self.timer < 1 then
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
			if self.timer >= 1 then
				local target = get_nearest_enemy(self,pos,def.size*1.5,true)
				if target then
				target:punch(self.object, 1.0, {full_punch_interval=1.0,damage_groups = {fleshy=def.damage}})
				if math.random(1,60) == 1 then
					target:set_hp(0)
				end
				self.poison = self.poison.poison(self.poison,target)
				if self.stuntimer <= 0 and def.stun then
					self.stuntimer = def.stun+1
					player_poison_stun(target,def.stun,1)
				end
				if target:is_player() then
					add_to_law_status(target:get_player_name(),self.lawname,-def.damage)
				end
				
				self.timer = 0
				end
			end
			local target = get_nearest_enemy(self,pos,25)
			self.waydown = self.object:getvelocity().y
			if target then
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
			self.object:setyaw(math.atan2(self.targetvektor.z,self.targetvektor.x)+math.pi/2)
			else
				self.object:setvelocity({x=0,y=0,z=0})		
				self.nextanimation = 1
			end
			animate(self,self.nextanimation)
			else
--			local next_owner = get_nearest_player(self,pos,100)
--			if next_owner then
--				self.owner_name = next_owner
--			end
			end
			if self.object:get_hp() > 0 then return end
			self.object:remove()
		end
	})
if not def.shelob then
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
		p2.y = p2.y+1
		if minetest.get_node(p).name == "air" and minetest.get_node(p2).name == "air" then
			minetest.add_entity(p,"spiders:" .. def.name)
		end
	end,
})
end
end
register_guard({
	damage = 1,
	name = "lothspider",
	max_hp = 15,
	size = 2,
	skin = "spiderskin.png",
	speed = 5
},{"default:mirkwooddirt"},300)--1000)
register_guard({
	damage = 5,
	name = "shelob",
	max_hp = 2400,
	size = 6,
	shelob = true,
	skin = "spiderskin.png",
	speed = 5,
	stun = 24
},{},1)--1000)
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


