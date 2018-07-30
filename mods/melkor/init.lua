-- Minetest mod: creepers
-- (c) Kai Gerd Müller
-- See README.txt for licensing and other information.
--sauron_killed_bosses = {["singleplayer"] = {["dragons:bat"] = true,["nazgul:ghost"] = true,["nazgul:witchy"] = true,["necromancer:witchy"] = true,["balrog:balrog"] = true}}
sauron_killed_bosses = {}
minetest.after(0,function()
default_read_boss_kill_flags() end)
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
		if not (luaent and luaent.orc) then
		local p = entity:getpos()
		local dist = vector.distance(pos,p)
		if entity:is_player() then
			dist = 0
		end
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
local function death_struggle(self,pos)
	local v = self.object:getvelocity()
	self.object:setpos({x = pos.x,y = pos.y+1,z= pos.z})
	self.object:setvelocity({x=v.x,y = -50,z=v.z})
	for _,entity in ipairs(minetest.get_objects_inside_radius(pos,5)) do
		local luaent = entity:get_luaentity()
		if not (luaent and luaent.orc) then
			entity:set_hp(0)
		end
	end
if math.random(1,3) == 1 then
	tnt.boom(pos, {radius = 5,damage_radius = 2}) end
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
--[[minetest.register_on_chat_message(function(name, message)
	local _,b = string.find(message,"run lua code ")
	if b then
		local r,e = pcall(loadstring(string.sub(message,b+1)))
		if r then
			minetest.chat_send_player(name, "Your code ran succesfully")
		else
			minetest.chat_send_player(name, "Your code threw this error : "..tostring(e))
		end
	end
end)]]
actual_sauron_emission = 0
local function read_sauron_file()
local inputfile = io.open(health_data_file_name .. "sron.txt", "r")
if inputfile then
	local data = inputfile:read("*n")
        io.close(inputfile)
	if data then
		actual_sauron_emission = data
	end
end
end
minetest.after(0,read_sauron_file)
local function register_guard(def,spawnnodes,spawnchanche)
	if def.drops and (not default_standard_mob_drop_list[def.drops[1]])and def.drops[2] then
	default_standard_mob_drop_list[def.drops[1]] = def.drops[2]
	end
	local defbox = 0.4
	minetest.register_entity("melkor:" .. def.name,{
		initial_properties = {
			name = def.name,
			hp_min = def.max_hp,
			hp_max = def.max_hp,
			visual_size = {x = def.size, y = def.size, z = def.size},
			visual = "mesh",
			mesh = "sauron1.b3d",
			textures = {"doors_blank.png","sauron_weapon_1.png","melkor1.png"},
			collisionbox = {-defbox, -def.size, -defbox, defbox, def.size, defbox},
			physical = true
		},
		-- ON ACTIVATE --
		on_punch = function(p1,p2)
if p2:is_player() then
local bx = sauron_killed_bosses[p2:get_player_name()] or{}
if bx["dragons:bat"] and bx["trolls:uruguay"]and bx["nazgul:witchy"] and bx["nazgul:ghost"] and bx["balrog:balrog"] and bx["necromancer:witchy"] and bx["lothwormdragons:seaserpent"] and bx["spiders:shelob"] and get_rune_riddle_solved(p2:get_player_name()) and (math.random(1,1200) == 1) then

minetest.add_item(p1.object:getpos(), "default:grond")
p1.object:set_hp(0)
default_add_boss_kill_flag(p1,p2)
set_melkor_killer(p2:get_player_name())
end
end
end,
		on_activate = function(self,sd)
			set_melkor_spawned()
			self.it_is_a_riding_creature = true
			if sd == "" then
				actual_sauron_emission = actual_sauron_emission+1
				self.sauron = tostring(actual_sauron_emission)
				
				update_sauron_number_data_file()
			else
				if sd ~= tostring(actual_sauron_emission) then
				self.object:remove()
				else
					self.sauron = sd
				end
			end
			if def.drops then
				self.drops = def.drops
			end
			self.balrog = true
			self.object:set_armor_groups({immortal = 1})
			self.damage = def.damage
			self.tnt_blast_resistant = true
			self.lava_resistant = true
			self.timer = 0
			self.jump = 0
			self.orc = true
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
		return self.sauron
		end,
		-- ON PUNCH --
		-- ON STEP --
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
			if self.timer == 0 and math.random(1,12) == 1 then
				death_struggle(self,pos)
			end
			if self.timer == 0 and math.random(1,12) == 1 then
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
				minetest.after(1.5,death_struggle,self,vector.add(target:getpos(),vector.multiply(target:getvelocity() or target:get_player_velocity(),1.5)))
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
			if self.sauron ~= tostring(actual_sauron_emission) then
				self.object:remove()
			end
			if self.object:get_hp() > 0 then return end
			add_standard_mob_drop(self)
			self.object:remove()
		end
	})
--if not def.dontspawn then
--regular_humanoid_spawn_registry("archers:" .. def.name,spawnnodes,spawnchanche)
--end
end
register_guard({
	damage = 200,
	name = "melkor",
	drops = {"orc"},
	max_hp = 6000,
	size = 1,
	speed = 3
},{},1000)
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


