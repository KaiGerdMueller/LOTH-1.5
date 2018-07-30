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
function default_nodes_under_jumpable(def,pos)
local p = vector.add(pos,{x=0,y=-(def.size+0.5),z=0})
local n = minetest.get_node(p).name
if minetest.registered_nodes[n].walkable then
	return true
else
	if default_is_swimmable(n) then
		p.y = p.y-1
		if minetest.registered_nodes[minetest.get_node(p).name].walkable then
			return true
		else
			return false
		end
	else
		return false
	end
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
actual_nazgul_emission = 0
local function read_nazgul_file()
local inputfile = io.open(health_data_file_name .. "nzgl.txt", "r")
if inputfile then
	local data = inputfile:read("*n")
        io.close(inputfile)
	if data then
		actual_nazgul_emission = data
	end
end
end
minetest.after(0,read_nazgul_file)
local function register_guard(def,spawnnodes,spawnchanche)
	if def.drops and (not default_standard_mob_drop_list[def.drops[1]])and def.drops[2] then
	default_standard_mob_drop_list[def.drops[1]] = def.drops[2]
	end
	local defbox = 0.4
	minetest.register_entity("nazgul:" .. def.name,{
		initial_properties = {
			name = def.name,
			hp_min = def.max_hp,
			hp_max = def.max_hp,
			visual_size = {x = def.size, y = def.size, z = def.size},
			visual = "mesh",
			mesh = def.mesh or "character20.b3d",
			textures = {"morgul_blade.png",def.specialtex or "lottmobs_nazgul.png"},
			collisionbox = {-defbox, -def.size, -defbox, defbox, def.size, defbox},
			physical = true
		},
		-- ON ACTIVATE --
		on_punch = function(self,ent)
			if self.object:get_hp() <=0 and def.name == "witchy" then
				actual_nazgul_emission = actual_nazgul_emission-1
				update_nazgul_data_file()
				self.object:remove()
			end
			default_add_boss_kill_flag(self,ent)
		end,
		on_activate = function(self,static)
			self.it_is_a_riding_creature = true
			if def.drops then
				self.drops = def.drops
			end
			self.on_mob_die = function()
				actual_nazgul_emission = actual_nazgul_emission-1
				update_nazgul_data_file()
			end
			if (static == "") and not def.weak then
			self.object:set_armor_groups({fleshy = 8,level = 1})
			end
			self.lifetimer = 300
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
			local split_index = string.find(static,"#")
			self.regentimer = 1800
			if split_index then
			self.regentimer = tonumber(string.sub(static,1,split_index-1))
			self.actual_nazgul_emission = tonumber(string.sub(static,split_index+1))
			elseif def.name == "witchy" then
				self.actual_nazgul_emission = actual_nazgul_emission
				actual_nazgul_emission = actual_nazgul_emission+1
				update_nazgul_data_file()
			else
				self.actual_nazgul_emission = 0
			end
		end,
		get_staticdata = function(self)
		return tostring(self.regentimer) .. "#" .. tostring(self.actual_nazgul_emission)
		end,
		-- ON PUNCH --
		-- ON STEP --
		on_step = function(self, dtime)
			if def.name == "witchy" then
			self.regentimer = self.regentimer-dtime
			if self.regentimer < 0 then
			self.regentimer = 1800
			self.object:set_hp(def.max_hp)
			end
			end
			self.lifetimer = self.lifetimer-dtime
			if self.lifetimer < 0 and def.weak then
				self.object:remove()
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
			--db({minetest.get_node(vector.subtract(pos,{x=0,y=1,z=0})).name})
			local punching = false
			if self.timer >= 1 then
				local target = get_nearest_enemy(self,pos,def.size*3,true)
				if target and target:get_hp() > 0 then

				if math.random(1,60) == 1 then
				target:set_hp(0)
				minetest.add_entity(target:getpos(),"nazgul:ghost")
				else
				target:punch(self.object, 1.0, {full_punch_interval=1.0,damage_groups = {fleshy=def.damage}})
				end
				if target:is_player() then
					add_to_law_status(target:get_player_name(),self.lawname,-def.damage)
poisoning_standard(target,99)
				end
				end
				self.timer = 0
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
			if self.jump == 0 and (def.name == "witchy") and (self.actual_nazgul_emission+11 <actual_nazgul_emission) then
				actual_nazgul_emission = actual_nazgul_emission-1
				update_nazgul_data_file()
				if minetest.get_node(pos).name == air then
				minetest.set_node(pos,{name="fire:basic_flame"})
				end
				self.object:remove()
			end
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
			if def.name == "witchy" then
				actual_nazgul_emission = actual_nazgul_emission-1
				update_nazgul_data_file()
				--self.object:remove()
			end
			self.object:remove()
		end
	})
if not def.dontspawn then
regular_humanoid_spawn_registry("archers:" .. def.name,spawnnodes,spawnchanche)
end
end
register_guard({
	damage = 60,
	name = "witchy",
	drops = {"orc"},
	max_hp = 6000,
	size = 1,
	speed = 4
},{"default:mordordust_mapgen","default:mordordust","default:angmarsnow","default:netherrack"},10000)
register_guard({
	damage = 60,
	name = "ghost",
	drops = {"orc"},
	specialtex = "morgulghost1.png",
	max_hp = 30,
	size = 1,
	weak = true,
	dontspawn = true,
	speed = 4
},{},10000)
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


