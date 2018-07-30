-- Minetest mod: creepers
-- (c) Kai Gerd Müller
-- See README.txt for licensing and other information.
local function is_not_epic_weapon(itmstck)
return (string.sub(itmstck:get_name(), 1, 13) ~= "default:epic_")
end
local function lawname_init(self,s)
if s == "orc" then
self.lawname = "orcishlaw"
else
self.lawname = "hudwelshlaw"
end
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
local standardguardslist = {["default:mese"]="mese",["default:steelblock"]="steel",["default:copperblock"]="copper",["default:goldblock"]="gold",["default:bronzeblock"]="bronze",["default:diamondblock"]="diamond",["default:obsidian"]="obsidian"}
local function jump_needet(size,pos)
pos.y = (pos.y+size)-1
local n =  minetest.get_node(pos).name
pos.y = pos.y-size+1
return  minetest.registered_nodes[n].walkable or(n == "default:water_source" )or( n == "default:water_flowing")
end
local function flight_h_under_v(pos,v)
local oldy = pos.y
pos.y = pos.y-v
local n
for i = 0,v do
	n = minetest.get_node(pos).name
	if minetest.registered_nodes[n].walkable or default_is_swimmable(n) then
		pos.y = oldy
		return true
	end
	pos.y = pos.y+1
end
pos.y = oldy
return false
end
local function standard_calc_flight_h_adjust(pos)
	if flight_h_under_v(pos,16) then
		if flight_h_under_v(pos,12) then
			return 1
		else
			return 0
		end
	else
		return -1
	end
end
local function may_stomp(self,pos,low,height)
local oldys = pos.y
local bl = true
pos.y = pos.y+low+1.26
for i = 0,height do
	pos.y = pos.y+1
	bl = bl and not minetest.registered_nodes[minetest.get_node(pos).name].walkable
end
--[[for _,e in pairs(self.mob_engine.collisionnodes) do
bl = bl and not minetest.registered_nodes[minetest.get_node(vector.add(pos,e)).name].walkable
end]]
if bl then
	pos.y = oldys+1.26
	self.object:setpos(pos)
end
end
local function animate(self, t,a)
	if self.mob_engine.punch_anim_time and ( self.mob_engine.punch_anim_time > 0)then if (self.canimation ~= -1) then
		self.object:set_animation({
			x = a.punch_start,
			y = a.punch_end},
			a.speed_run, 0)
		self.canimation = -1 end
	elseif t == 1 and self.canimation ~= 1 then
		self.object:set_animation({
			x = a.walk_start,
			y = a.walk_end},
			a.speed_normal, 0)
		self.canimation = 1
	elseif t == 2 and self.canimation ~= 2 then
		self.object:set_animation({x = a.walk_start,y = a.walk_end},a.speed_normal, 0)
		self.canimation = 2
	--walkmine
	elseif t == 4 and self.canimation ~= 4 then
		self.object:set_animation({x = a.walk_start,y = a.walk_end},a.speed_run, 0)
		self.canimation = 4
	--walkmine
	elseif t == 3 and self.canimation ~= 3 then
		self.object:set_animation({x = a.run_start or a.punch_start,y = a.run_end or a.punch_end},a.speed_normal, 0)
		self.canimation = 3
	--walk
	end
end
local function get_nearest_enemy(self,pos,radius,boo,add,damage)
	if not damage then
		return false
	end
	pos.y = pos.y+add+1
	local radius = math.max(radius,3)
	local min_dist = radius+1
	local target = false
	local type = self.mob_engine.type
	for _,entity in ipairs(minetest.get_objects_inside_radius(pos,radius)) do
			local name = entity:get_player_name()
			luaent = entity:get_luaentity()
			if((type == "orc") and entity:is_player() and(
		(not orcishplayers[name])
		 or (orcishlaw[name]  and orcishlaw[name] > 0  )
		)) or ((type == "hudwel") and entity:is_player() and(
		(not hudwelshplayers[name])
		 or (hudwelshlaw[name]  and hudwelshlaw[name] > 0  )
		)) or(luaent and not (luaent[type])) and default_do_not_punch_this_stuff(luaent) then
			local p = vector.add(entity:getpos(),{x=0,y=1,z=0})
			local dist = vector.distance(pos,p)
			if (minetest.line_of_sight(pos,p) or (boo and minetest.line_of_sight(vector.add(pos,{x=0,y=10,z=0}),vector.add(p,{x=0,y=10,z=0})))) and dist < min_dist then
				min_dist = dist
				target = entity
			end
			end
	end
	pos.y = pos.y-add
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
end--[[
	type = "monster",--DONE
	reach = 3,--D
	damage = 2,--D
	attack_type = "dogfight",--D
	hp_min = 62,--D
	hp_max = 72,--D
	armor = 100,
	collisionbox = {-0.4, 0, -0.4, 0.4, 2.5, 0.4},--D
	visual = "mesh",--D
	mesh = "golem.b3d",--
	textures = {
		{"dmobs_golem.png"},--
	},
	blood_texture = "default_stone.png",--
	visual_size = {x=1, y=1},--
	makes_footstep_sound = true,--
	walk_velocity = 1,--
	run_velocity = 2.5,--
	jump = true,--
	drops = {
		{name = "dmobs:golemstone", chance = 30, min = 1, max = 1},
	},
	water_damage = 0,
	lava_damage = 2,
	light_damage = 1,
	fall_damage = 0,
	fear_height = 10,
	view_range = 14,
	animation = {
		speed_normal = 10,
		speed_run = 14,
		walk_start = 46,
		walk_end = 66,
		stand_start = 1,
		stand_end = 20,
		run_start = 46,
		run_end = 66,
		punch_start = 20,
		punch_end = 45,
	},]]
mobs = {}
mobs.spawn_constant = 3
local failed_mobs = {}
local function get_mob_nodes_index_list(collisionbox)
local l = {}
for x = math.ceil(collisionbox[1]+0.5),math.floor(collisionbox[4]-0.5) do
for y = math.ceil(collisionbox[2]+0.5),math.floor(collisionbox[5]-0.5) do
for z = math.ceil(collisionbox[3]+0.5),math.floor(collisionbox[6]-0.5) do
table.insert(l,{x=x,y=y,z=z})
end
end
end
return l
end
local dir_to_vec_walk = {{x=0,y=0,z=1},{x=0,y=0,z=-1},
{x=1,y=0,z=0},vector.normalize({x=1,y=0,z=1}),vector.normalize({x=1,y=0,z=-1}),
{x=-1,y=0,z=0},vector.normalize({x=-1,y=0,z=1}),vector.normalize({x=-1,y=0,z=-1})}
local function standard_walk_around(speed,dtime)
	if math.random(math.ceil(10/dtime)) == 1 then
		return vector.multiply(dir_to_vec_walk[math.random(1,8)],speed)
	end
end
local function standard_walk_around_flying(speed,dtime,y)
	if math.random(math.ceil(10/dtime)) == 1 then
		local v = dir_to_vec_walk[math.random(1,8)]
		if y ~= 0 then
				v.y = y
			speed = speed*0.70710678118
		end
		return vector.multiply(v,speed)
	end
end
dofile(minetest.get_modpath("libs").."/mobs_extended.lua")
mobs.hp_multiplier = 3
function mobs:register_mob(name,def)
	def.reach = def.reach or 2
	if def.fly then
		mobs:register_flying_mob(name,def)
		return
	end
	local actually_dogshoting = def.attack_type == "dogshoot"
	def.attack_type = "dogfight"
	if def.visual ~= "mesh" then
		failed_mobs[name] = true
		return
	end
	if def.type == "animal" then
		def.type = "npc"
	end
	if def.type == "monster" then
		def.type = "orc"
	elseif def.type == "npc" then
		def.type = "hudwel"
	end
	local heigth = 1+def.collisionbox[2]
	local mob_actually_really_floats = def.floats ~= 0
	local theight = def.collisionbox[5]-def.collisionbox[2]
	local defcollboxlower = def.collisionbox[2]
	if string.find(name,"nssm:") then
		def.rotate = (def.rotate or 270)+180
	end
	local yaw_offset = ((def.rotate or 0)*math.pi/180)
	local punch_time = ((def.animation.punch_end or 0)-(def.animation.punch_start or 0))/(def.animation.speed_run or 10)
	local dmg_is_there = def.damage
	local add_to_pos = defcollboxlower+(theight/2)
	local animations = def.animation
	local morva_special = def.duplication_counterstrike or false
	minetest.register_entity(":" .. name,{
		initial_properties = {
			name = name,
			hp_min = (def.hp_min or def.hp_max)*mobs.hp_multiplier,
			hp_max = def.hp_max*mobs.hp_multiplier,
			visual_size = {x = def.visual_size.x, y = def.visual_size.y, z = def.visual_size.x},
			visual = "mesh",
			mesh = def.mesh,
			textures = def.textures[1],
			collisionbox = def.collisionbox,
			physical = true
		},
		-- ON ACTIVATE --
		on_punch = function(self,puncher,time_from_last,tool_capabilities)
			local new_hp = self.object:get_hp()
			if (new_hp >  0) then
			if morva_special then
				local tool_capabilities = (((tool_capabilities or {})["damage_groups"] or {})["fleshy"] or 0)
				local duplicate_count_max = morva_special*tool_capabilities
				if duplicate_count_max > 5 then
				duplicate_count_max = 5
				puncher:punch(self.object, 1.0, {full_punch_interval=1.0,damage_groups = {fleshy=math.ceil((duplicate_count_max-5)*6)}})
				end
				duplicate_count_max = math.floor(duplicate_count_max)
				for i = 1,math.random(math.min(1,duplicate_count_max),duplicate_count_max) do
					local dir = math.random()*2*3.14159
					local e = minetest.add_entity(vector.add(self.object:getpos(),{x=math.sin(dir),y=0,z=math.cos(dir)}),name)
					if e then
					e:set_hp(new_hp)
					e:get_luaentity().unique_soul_data = nil
					end
				end
			end
			if puncher:is_player() then
puncher:set_wielded_item(add_wear_to_weapon(puncher:get_wielded_item()))
add_to_law_status(puncher:get_player_name(),self.lawname,20)
end
			return
			end
			mobs:drop(vector.add(self.object:getpos(),{x=0,y=1,z=0}),def.drops)
if puncher:is_player() then
puncher:set_wielded_item(add_wear_to_weapon(puncher:get_wielded_item()))
add_to_law_status(puncher:get_player_name(),self.lawname,720)
increase_player_bad_souls_harvested(morva_special,puncher:get_player_name())
end
			self.object:remove()
		end,
		on_activate = function(self,sdata)
			lawname_init(self,def.type)
			if morva_special then
				self.unique_soul_data = true
			end
			if sdata ~= "#" then
				self.object:set_armor_groups({fleshy = math.min(def.armor,100)})
			end
			self.timer = 0
			self.jump = 0
			self[def.type] = true
			self.mob_engine = {["type"] = def.type,["punch_anim_time"] = 0}--,["collisionnodes"] = get_mob_nodes_index_list(def.collisionbox)}
			self.object:setacceleration({x=0,y=-50,z=0})
		self.object:set_animation({
			x = animations.stand_start,
			y = animations.stand_end},
			animations.speed_normal, 0)
			self.canimation = 1
			self.gravity = {x=0,y=-50,z=0}
			local pos = self.object:getpos()
			local actualNode = minetest.get_node(vector.add(pos,{x=0,y=heigth,z=0})).name
			if actualNode == "default:water_source" then
				self.gravity = {x=0,y=0,z=0}
			end
			self.shoot_timer = (def.shoot_interval or 1)
			self.object:setacceleration(self.gravity)
		end,
		-- ON PUNCH --
		-- ON STEP --
		get_staticdata = function(self, dtime)
			return "#"
		end,
		on_step = function(self, dtime)
			if morva_special then
				self.last_hp = self.object:get_hp()
			end
			if def.do_custom then
				def.do_custom(self,dtime)
			end
			self.mob_engine.punch_anim_time = math.max(0,(self.mob_engine.punch_anim_time or 0)-dtime)
			self.gset = false
			local waydown = self.object:getvelocity().y
			local pos = self.object:getpos()
			self.animation_set = true
			self.gravity = {x=0,y=-50,z=0}
			self.targetvektor = nil
			if self.timer < 1 then
			self.timer = self.timer+dtime
			end
			local punching = false
			local target = false
			if self.timer >= 1 then
			target = get_nearest_enemy(self,pos,def.reach or (def.collisionbox[2]*3),false,add_to_pos,def.damage)
			if target then 
				self.mob_engine.punch_anim_time = punch_time
				if def.damage then
				pcall(function()
				target:punch(self.object, 1.0, {full_punch_interval=1.0,damage_groups = {fleshy=def.damage}})
				if target:is_player() then
					add_to_law_status(target:get_player_name(),self.lawname,-def.damage)
				end
				self.timer = 0
				end)
				end
			end
							
end
			if dmg_is_there then
			local target = get_nearest_enemy(self,pos,def.view_range,true,add_to_pos,def.damage)
			if target then
			if actually_dogshoting then
				self.shoot_timer = (self.shoot_timer or 0)-dtime
				if self.shoot_timer <=0 then
					self.shoot_timer = def.shoot_interval
					mobs:throw_arrow(pos,vector.subtract(target:getpos(),pos),def.arrow)
				end
			end
			target = target:getpos()
			self.nextanimation = 4
			self.targetvektor = vector.multiply(vector.normalize({x=target.x-pos.x,y=0,z=target.z-pos.z}),def.run_velocity)
			end
			end
			local velocity = self.object:getvelocity()
			self.jump = (self.jump +1)%10
			--if self.targetvektor then
			local actualNode = minetest.get_node(pos).name
			if actualNode == "default:lava_source" then
				self.object:remove()
			end
			actualNode = minetest.get_node(vector.add(pos,{x=0,y=heigth,z=0})).name
			if actualNode == "default:lava_source" then
				self.object:remove()
			end
			if mob_actually_really_floats and default_is_swimmable(actualNode) then
				self.gravity = {x=0,y=0,z=0}
			end
			if not self.targetvektor then
			self.targetvektor = standard_walk_around(def.walk_velocity,dtime)
			self.mob_engine.old_targetvektor =self.targetvektor
			self.nextanimation = 2
			if self.jump == 0 and jump_needet(defcollboxlower,self.object:getpos()) and vector.length(self.object:getvelocity()) < def.walk_velocity*0.4 then
				self.targetvektor = self.targetvektor or self.mob_engine.old_targetvektor or vector.multiply(dir_to_vec_walk[math.random(1,8)],def.walk_velocity)
				may_stomp(self,pos,defcollboxlower,theight)			
			end
			else
self.targetvektor.y = waydown
			if self.jump == 0 and jump_needet(defcollboxlower,self.object:getpos()) and vector.length(self.object:getvelocity()) < def.run_velocity*0.4 then
				may_stomp(self,pos,defcollboxlower,theight)			
			end
			end
			if self.targetvektor then
			self.object:setacceleration(self.gravity)
			self.object:setvelocity(self.targetvektor)
			self.object:setyaw(math.atan2(self.targetvektor.z,self.targetvektor.x)-math.pi/2+yaw_offset)
			else
			if  mob_actually_really_floats and default_is_swimmable(minetest.get_node(vector.add(pos,{x=0,y=1+heigth,z=0})).name) then
				self.targetvektor = self.object:getvelocity()
				self.targetvektor.y = self.targetvektor.y+1
				self.object:setacceleration({x=0,y=0,z=0 })
				self.object:setvelocity(self.targetvektor)
			end
			end
			--[[else
				--self.object:setvelocity({x=0,y=waydown,z=0})		
				self.nextanimation = 1
			end]]
			animate(self,self.nextanimation,def.animation)
			if self.object:get_hp() > 0 then return end
			local pos = self.object:getpos()
			for _,e in pairs(def.drops or {}) do
			if math.random(1,e.chanche or 1) == 1 then
			local e = minetest.add_item(pos, e.name .. tostring(math.random(e.min or 1,e.max or 1)))
			if e then
			e:setvelocity({x=math.random(-1,1),y=math.random(-1,2),z=math.random(-1,1)})			
			end
			end
			end
			self.object:remove()
mobs:drop(vector.add(self.object:getpos(),{x=0,y=1,z=0}),def.drops)
		end
	})
end
function mobs:register_egg()
end
minetest.register_chatcommand("spawn", {
	params = "",
	description = "Test 1: Modify player's inventory view",
	func = function(name, param)minetest.add_entity(minetest.get_player_by_name(name):getpos(),param)end,
})
function mobs:spawn_specific(name, nodes, neighbors
, min_light, max_light,
 interval,
   chance, active_object_count, min_height, max_height, day_toggle, on_spawn)
	local min_height = min_height or -31000
	local  max_height =   max_height  or 31000
	if (min_height and max_height) and min_height > max_height then
		local old_max = max_height
		max_height = min_height
		min_height = old_max
	end
	if (min_light and max_light) and min_light > max_light then
		local old_max = max_light
		max_light = min_light
		min_light = old_max
	end
	if (not minetest.registered_entities[name]) and (not minetest.registered_entities[":"..name]) then
		return
	end
		--if name == "dmobs:treeman" then
		--end
	local add_pos = 1
	minetest.register_abm({
	label = "spawn",
	catch_up = false,
		nodenames = nodes,
		neighbors = neighbors,
		interval = interval,
		chance = math.ceil(chance*0.2),
		action = function(pos,_,__,aoc)
			--if minetest.get_node(pos).name ~= "default:stone" then
			--minetest.chat_send_all("am i, a dangerous "..name.." supposed to spawn on "..minetest.get_node(pos).name.."???")
			--end
			pos.y = pos.y+add_pos
			
			local light = minetest.get_node_light(pos) or 7
			if (pos.y <(max_height or 3100000)+1)
 and (pos.y >(min_height or -3100000)-1)
 and (light >= (min_light or 0))and( light <= (max_light or 15))and
 (aoc  < 4) and not minetest.registered_nodes[minetest.get_node(pos).name].walkable then
				local e = minetest.add_entity(pos, name)
				if on_spawn then
					on_spawn(e,pos)
				end
			--[[else 
			minetest.chat_send_all("NOPE :(")
			if not (pos.y <max_height+1 or 3100000) then
			minetest.chat_send_all("TOO high")
			end
			if not(light > (min_light or 0))then
			minetest.chat_send_all("TOO much darkness")
			end
			if not( light < (max_light or 15)) then
			minetest.chat_send_all("TOO much light")
			end
			if not  (aoc  < 4) then
			minetest.chat_send_all("TOO much activity")
			end]]
			--if minetest.registered_nodes[minetest.get_node(pos).name].walkable then
			--minetest.chat_send_all("TOO solid pos")
			--end
			end
		end
	})
end
local function arrow_shall_be_removed(self,pos)
	if not self.last_simulated_pos then
		self.last_simulated_pos = pos
	end
	if minetest.line_of_sight(pos,self.last_simulated_pos) then
		self.last_simulated_pos = pos
		return false
	else
		pos = self.last_simulated_pos
		self.object:setpos(pos)
		return true
	end
end
local mobs_arrow_arr = {}
function mobs:throw_arrow(pos,dir,name)
	local length = vector.length(dir)
	if mobs_arrow_arr[name] and length ~= 0 then
		local e = minetest.add_entity(vector.add(pos,vector.divide(dir,length)),name)
		e:setvelocity(vector.multiply(dir,mobs_arrow_arr[name]/length))
	end
end
function mobs:register_arrow(n,d)
	mobs_arrow_arr[n] = d.velocity
	minetest.register_entity(":"..n,{
		initial_properties = {
			--name = "arrow",
			hp_min = 1000000,
			hp_max = 1000000,
			visual_size = d.visual_size,
			visual = "sprite",--"wielditem",
	--textures = {"lotharrows:boltmodel"},
			textures = d.textures,
			collisionbox = {0, 0, 0,0, 0, 0},
			physical = false
		},
		-- ON ACTIVATE --
		--on_activate = function(self)
			--[[self.]]lastpos ={x=0,y=0,z=0},--self.object:getpos(),
			--[[self.]]orc = true,
			--[[self.]]hudwel = true,
			--[[self.]]dunlending = true,
				   balrog = true,
			--[[self.]]arrow_resistant  = true,
				lotharrow = true,
			--[[self.]]shooter = nil,--self.object,
		--end,
		on_activate = function(self)
			self.last_simulated_pos = self.object:getpos()
			self.time = 10
			self.timer = 0
		end,
		-- ON PUNCH --
		-- ON STEP --
		on_step = function(self,dtime)
		if self.object then

	if self.lotharrow then
	local pos = self.object:getpos()
	local remove_this = arrow_shall_be_removed(self,pos)
	local target = false
	local remove = 0
	for _,entity in ipairs(minetest.get_objects_inside_radius(pos,1)) do
		local luaent  = entity:get_luaentity()
		if ((not luaent) or (not luaent.arrow_resistant))  and ((not luaent) or (not luaent.lotharrow)) then
			if entity:is_player() then
			if d.hit_player then
		pcall(d.hit_player,self,entity)
			end
			else
			if d.hit_mob then
			pcall(d.hit_mob,self,entity)
			end
			end
			remove  = remove-1
		elseif ((not luaent) or (not luaent.lotharrow)) then
			if entity:is_player() then
			if d.hit_player then
		pcall(d.hit_player,self,entity)
			end
			else
			if d.hit_mob then
			pcall(d.hit_mob,self,entity)
			end
			end
			remove  = remove-1
		end
	end
	local n = minetest.get_node(pos).name
	if remove_this or (remove < 0) or (n ~= "air" and n ~= "nssm:phoenix_fire" and n ~= "ignore")then
		if ((n ~= "air" and n ~= "ignore") or remove_this) and d.hit_node then
		d.hit_node(self,pos,minetest.get_node(pos))
		end
--		db({"REM",tostring(remove)},"VeryImportantMessage")
		self.object:remove()
	end
	else
		self.object:remove()
	end
	end
			self.time = self.time-dtime
			if self.time < 0 then
				self.object:remove()
			end
	if d.on_step then d.on_step(self,dtime)
	end
	end
	})
end
function mobs:register_spawn(name, nodes, max_light, min_light, chance,
   active_object_count, max_height, day_toggle,flags)
	local flags = flags or {}
	if not minetest.registered_entities[name] and string.sub(name,1,5) == "dmobs" then
		return
	end
		--if name == "dmobs:treeman" then
		--end
	local add_pos = 1
	if flags.air then
		add_pos = math.random(2,14)
	end
	minetest.register_abm({
	label = "spawn",
	catch_up = false,
		nodenames = nodes,
		neighbors = "air",
		interval = 30,
		chance = math.ceil(chance*0.2),
		action = function(pos,_,__,aoc)
			--if minetest.get_node(pos).name ~= "default:stone" then
			--minetest.chat_send_all("am i, a dangerous "..name.." supposed to spawn on "..minetest.get_node(pos).name.."???")
			--end
			pos.y = pos.y+add_pos
			local light = minetest.get_node_light(pos) or 7
			if (pos.y <max_height+1 or 3100000)
 and (light >= (min_light or 0))and( light <= (max_light or 15))and
 (aoc  < 4) and not minetest.registered_nodes[minetest.get_node(pos).name].walkable then
				minetest.add_entity(pos, name)
			--[[else 
			minetest.chat_send_all("NOPE :(")
			if not (pos.y <max_height+1 or 3100000) then
			minetest.chat_send_all("TOO high")
			end
			if not(light > (min_light or 0))then
			minetest.chat_send_all("TOO much darkness")
			end
			if not( light < (max_light or 15)) then
			minetest.chat_send_all("TOO much light")
			end
			if not  (aoc  < 4) then
			minetest.chat_send_all("TOO much activity")
			end]]
			--if minetest.registered_nodes[minetest.get_node(pos).name].walkable then
			--minetest.chat_send_all("TOO solid pos")
			--end
			end
		end
	})
end
local function mob_drop_item(pos,def)
	if math.random(1,def.chanche or 1) == 1 then
	minetest.add_item(vector.add(pos,{x=math.random()-0.5,y=math.random()-0.5,z=math.random()-0.5}),def.name.." "..math.random(def.min or 1,def.max or def.min or 1))
	end
end
function mobs:drop(pos,t)
	for i,e in pairs(t) do
		mob_drop_item(pos,e)
	end
end
