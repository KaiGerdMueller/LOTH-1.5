-- Minetest mod: creepers
-- (c) Kai Gerd Müller
-- See README.txt for licensing and other information.
local standardguardslist = {["default:mese"]="mese",["default:steelblock"]="steel",["default:copperblock"]="copper",["default:goldblock"]="gold",["default:bronzeblock"]="bronze",["default:diamondblock"]="diamond",["default:obsidian"]="obsidian"}

--[[local function get_nearest_enemy(self,pos,radius,fucking_punchtest)
	local min_dist = radius+1
	local target = false
	for _,entity in ipairs(minetest.get_objects_inside_radius(pos,25)) do
		if entity:is_player() then
		local p = entity:getpos()
		local dist = vector.distance(pos,p)]]
--		if --[[default_do_not_punch_this_stuff(luaent) and]] (minetest.line_of_sight(vector.add(pos,{x=0,y=5,z=0}),vector.add(p,{x=0,y=5,z=0}), 2) == true or minetest.line_of_sight(pos,p, 2) == true --[[or minetest.line_of_sight(vector.add(pos,{x=0,y=1,z=0}),vector.add(p,{x=0,y=1,z=0}), 2) == true]]) and dist < min_dist then
--[[			min_dist = dist
			target = entity
		end
		end
	end
if target and ((not fucking_punchtest) or minetest.line_of_sight(target:getpos(),pos,2)) then
return target
else
return target
end
end]]
local function get_nearest_enemy(self,pos,radius,fucking_punchtest)
	local min_dist = radius+1
	local target = false
	for _,entity in ipairs(minetest.get_objects_inside_radius(pos,6)) do
		local luaent = entity:get_luaentity()
--		db(hudwelshlaw)
		local name = entity:get_player_name()
		if (luaent and (not luaent.hudwel)and (not luaent.dunlending)) or --[[(]]entity:is_player() then--and(
		--(not hudwelshplayers[name])
		-- or (hudwelshlaw[name]  and hudwelshlaw[name] > 0  )
		--)) then
		local p = entity:getpos()
		local dist = vector.distance(pos,p)
				if default_do_not_punch_this_stuff(luaent) and (minetest.line_of_sight(vector.add(pos,{x=0,y=5,z=0}),vector.add(p,{x=0,y=5,z=0}), 2) == true or minetest.line_of_sight(pos,p, 2) == true --[[or minetest.line_of_sight(vector.add(pos,{x=0,y=1,z=0}),vector.add(p,{x=0,y=1,z=0}), 2) == true]]) and dist < min_dist then
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
	for _,entity in ipairs(minetest.get_objects_inside_radius(pos,5)) do
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
	--if def.drops and (not default_standard_mob_drop_list[def.drops[1]]) and def.drops[2] then
	--default_standard_mob_drop_list[def.drops[1]] = def.drops[2]
	--end
	local defbox = def.size
	minetest.register_entity("rats:" .. def.name,{
		initial_properties = {
			name = def.name,
			hp_min = def.max_hp,
			hp_max = def.max_hp,
			visual_size = {x = def.size*50, y = def.size*50, z = def.size*50},
			visual = "mesh",
			mesh = "lothmouse.obj",--"lothpig.b3d",
			textures = {"lothmousetex.png"},
			collisionbox = {-defbox, -def.size, -defbox, defbox, def.size, defbox},
			physical = true
		},
		-- ON ACTIVATE --
		on_activate = function(self)
			if def.drops then
				self.drops = def.drops
			end
			self.lifetimer = 6000
			self.lawname = "hudwelshlaw"
			self.damagetimer = 0
			self.warhorse = true
			self.timer = 0
			self.damage = def.damage
			self.jump = 0
			self.hudwel = true
			self.dunlending = true
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
		--on_rightclick = add_chestpriv_on_pay,
		on_punch = function(self) if self.object:get_hp() <= 0 then minetest.add_item(self.object:getpos(),"farming:meat " .. def.meat) self.object:remove()end end,
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
			local target = get_nearest_enemy(self,pos,25)
			local waydown = self.object:getvelocity().y
			if target then
			target = target:getpos()
			self.targetvektor = vector.multiply(vector.normalize({x=target.x-pos.x,y=waydown,z=target.z-pos.z}),-def.speed)
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
			if  default_is_swimmable(minetest.get_node(pos).name) then
				--self.gravity = {x=0,y=0,z=0}
				self.object:remove()
				minetest.add_item(self.object:getpos(),"farming:meat " .. def.meat)
			end
			--if  minetest.get_node(vector.add(pos,{x=0,y=1,z=0})).name == "default:water_source" then
				--self.targetvektor.y = 1
			--end
			if self.jump == 0 and vector.distance(vector.new(),velocity)<def.speed/10 and velocity.y == 0 and minetest.registered_nodes[minetest.get_node(vector.add(pos,{x=0,y=-(def.size+0.5),z=0})).name].walkable then
				--self.targetvektor.y = 40	
				stomp(self,0.75)	
			end
			self.object:setacceleration(self.gravity)
			self.object:setvelocity(self.targetvektor)
			self.object:setyaw(math.atan2(self.targetvektor.z,self.targetvektor.x)+math.pi/2)
			else
				self.object:setvelocity({x=0,y=0,z=0})		
				self.nextanimation = 1
			end
			--else
			--local next_owner = get_nearest_player(self,pos,100)
			--if next_owner then
			--self.owner_name = next_owner
			--end
			--end
			if self.object:get_hp() > 0 then return end
			--add_standard_mob_drop(self)
			minetest.add_item(self.object:getpos(),"farming:meat " .. def.meat)
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
		if minetest.get_node_light(p,0.5) ~= 15 and minetest.get_node(p).name == "air" then
			minetest.add_entity(p,"rats:" .. def.name)
		end
	end,
})
end

register_guard({
	damage = 3,
	name = "mouse",
	max_hp = 1,
	--drops = {"hobbit"},
	size = 0.05,
	meat = "1",
	speed = 2,
},{"group:stone"},1000)
register_guard({
	damage = 3,
	name = "rat",
	max_hp = 1,
	--drops = {"hobbit"},
	size = 0.1,
	meat = "1",
	speed = 1,
},{"group:stone"},1000)
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


