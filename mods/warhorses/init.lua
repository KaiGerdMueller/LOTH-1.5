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
function warhorses_catch_horserider(self)
local pos = self.object:getpos()
local min_dist = 4
local target = false
for _,i in pairs(minetest.get_objects_inside_radius(self.object:getpos(),3)) do
		local lentity = i:get_luaentity()
		if (lentity and (lentity.hudwel or lentity.dunlending) and (not(lentity.warhorse or lentity.owner)) ) then
			local p = i:getpos()
			local dist = vector.distance(pos,p)
			if dist < min_dist then
				min_dist = dist
				target = i
			end
		end
end
if target then
local hyaw = self.object:getyaw()
local nh = minetest.add_entity(pos,"warhorses:warhorse")
nh:setyaw(hyaw)
target:set_attach(nh, "", {x = 0, y = 10, z = 0}, {x = 0, y = 180, z = 0})
self.object:remove()
nh:get_luaentity().gets_ridden = true
end
end
function warhorses_recatch_horserider(self)
if not self.gets_ridden then
local pos = self.object:getpos()
local min_dist = 4
local target = false
for _,i in pairs(minetest.get_objects_inside_radius(self.object:getpos(),3)) do
		local lentity = i:get_luaentity()
		if (lentity and (lentity.hudwel or lentity.dunlending) and (not(lentity.warhorse or lentity.owner)) ) then
			local p = i:getpos()
			local dist = vector.distance(pos,p)
			if dist < min_dist then
				min_dist = dist
				target = i
			end
		end
end
if target then
target:set_attach(self.object, "", {x = 0, y = 10, z = 0}, {x = 0, y = 180, z = 0})
self.gets_ridden = true
end
end
end
local function get_nearest_enemy(self,pos,radius,fucking_punchtest)
	local min_dist = radius+1
	local target = false
	for _,entity in ipairs(minetest.get_objects_inside_radius(pos,radius)) do
		luaent = entity:get_luaentity()
		local name = entity:get_player_name()
		if (luaent and (not luaent.hudwel) and (not luaent.dunlending)) or (entity:is_player() and(
		((not dunlendingshplayers[name])
		 or (dunlendingshlaw[name]  and dunlendingshlaw[name] > 0  ))
		
		and((not hudwelshplayers[name])
		 or (hudwelshlaw[name]  and hudwelshlaw[name] > 0  )
		))) then
		local p = entity:getpos()
		local dist = vector.distance(pos,p)
								if default_do_not_punch_this_stuff(luaent) and (minetest.line_of_sight(vector.add(pos,{x=0,y=5,z=0}),vector.add(p,{x=0,y=5,z=0}), 2,entity) == true or minetest.line_of_sight(pos,p, 2,entity) == true --[[or minetest.line_of_sight(vector.add(pos,{x=0,y=1,z=0}),vector.add(p,{x=0,y=1,z=0}), 2) == true]]) and dist < min_dist then
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
local function register_guard(def)
	if def.drops and (not default_standard_mob_drop_list[def.drops[1]])and def.drops[2] then
	default_standard_mob_drop_list[def.drops[1]] = def.drops[2]
	end
	minetest.register_entity("warhorses:" .. def.name,{
		initial_properties = {
			name = def.name,
			hp_min = def.max_hp,
			hp_max = def.max_hp,
			visual_size = {x = 1, y = 1, z = 1},
			visual = "mesh",
			mesh = "LOTHhorse.b3d",
			textures = {"horsetex1.png"},
			collisionbox = {-0.5, -1.2, -0.5, 0.5, 0.6, 0.5},
			physical = true
		},
		-- ON ACTIVATE --
		on_punch = function(self) if self.object:get_hp() <= 0 then minetest.add_item(self.object:getpos(),"farming:meat " .. def.meat) minetest.log("action","DEEEADD") --[[self.object:remove()]]end end,--lawbreak_on_punch,

		on_activate = function(self)
			if def.drops then
				self.drops = def.drops
			end
			self.lifetimer = 600
			self.warhorse = true
			self.damagetimer = 0
			self.timer = 0
			self.jump = 0
			self.hudwel = true
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
		--on_rightclick = add_chestpriv_on_pay,
		on_step = function(self, dtime)
			self.lifetimer = self.lifetimer-dtime
			warhorses_recatch_horserider(self)
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
			local posvar = self.object:getpos()
			local abov = minetest.get_node(posvar).name
			if abov == "default:lava_source" or abov == "default:lava_flowing" then
				self.object:remove()
			else
			posvar.y = posvar.y+0.5
			abov = minetest.get_node(posvar).name
			if default_is_swimmable(abov) then
			self.object:remove()
				minetest.add_item(vector.add(pos,{x=0,y=1,z=0}),"farming:meat 2")
			end
			end	
			--db({minetest.get_node(vector.subtract(pos,{x=0,y=1,z=0})).name})
			local punching = false
			local target = get_nearest_enemy(self,pos,25)
			local waydown= self.object:getvelocity().y
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
end

register_guard({
	damage = 1,
	name = "warhorse",
	drops = {"orc"},
	max_hp = 60,
	size = 1,
	meat = "2",
	speed = 6
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


