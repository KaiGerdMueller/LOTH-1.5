-- Minetest mod: jellyfish
-- (c) Kai Gerd Müller
-- See README.txt for licensing and other information.
local function register_spawn(name, nodes,chanche)
	default_register_sbm({
	label = "spawn",
	catch_up = false,
		nodenames = nodes,
		interval = 10,
		chance = chanche,
		action = function(pos, node, _, active_object_count_wider)
			pos.y = pos.y + math.random(1,20)
			local n = minetest.get_node(pos).name
			if n == "air" or n == "ignore" then
				minetest.add_entity(pos, name)
			end
		end
	})
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
local function animate(self, t)
	if t == 1 and self.canimation ~= 1 then
		self.object:set_animation({
			x = 0,
			y = 250},
			250, 0)
		self.canimation = 1
	elseif t == 2 and self.canimation ~= 2 then
		self.object:set_animation({x = 0,y = 250},500, 0)
		self.canimation = 2
	--walkmine
	end
end
local function register_jellyfish_advanced(name, def)
	local defbox = def.size/2
	local side2 = name .. "3.png"
	local side = name .. "2.png"
	local front = name .. "1.png"
	minetest.register_entity("bats:" .. name,{
		initial_properties = {
			name = "bats:" .. name,
			hp_max = def.max_hp,
			visual_size = {x = def.size*5, y = def.size*5, z = def.size*5},
			visual = "mesh",
			mesh = "lothbat.b3d",
			textures = {"spiderskin.png","spiderskin.png","spiderskin.png"},
			collisionbox = {-defbox, -defbox, -defbox, defbox, defbox, defbox},
			physical = true
		},
		-- ON ACTIVATE --
		on_punch = function(self,puncher)
			local pos = self.object:getpos()
			if puncher:is_player() then
				add_to_law_status(puncher:get_player_name(),"orcishlaw",100)
			end
			if self.object:get_hp() > 0 then return end
			local pos = self.object:getpos()
			pos.y = pos.y + 0.5
			self.object:remove()
			obj = minetest.add_item(pos, ItemStack("farming:meat"))
			obj:setvelocity({x=math.random(-1,1), y=5, z=math.random(-1,1)})
			if puncher:is_player() then
				add_to_law_status(puncher:get_player_name(),"orcishlaw",1000000)
			end
		end,
		on_activate = function(self)
			self.damage= def.damage
			self.object:set_properties({automatic_rotate = 0})
			self.orc = true
			self.lawname = "orcishlaw"
			--targetvektor = {x=0, y = 0 , z = 0 }
			self.object:setacceleration({x = 0, y = 0, z = 0})
			self.object:setvelocity({x = math.random(-1,1), y = math.random(-1,1), z = math.random(-1,1)})
			self.lifetimer = 0
			self.timer = 0
		end,
		-- ON PUNCH --
		-- ON STEP --
		on_step = function(self, dtime)
			local animation = 1
			local targetvektor = false
			local target = false
			self.timer = self.timer + dtime
			self.lifetimer = self.lifetimer + dtime
			if self.lifetimer > 6000 then
				self.object:remove()
			end
			local pos = self.object:getpos()
			if not(self.object:get_hp() > 0) then
				pos.y = pos.y + 0.5
				self.object:remove()
				obj = minetest.add_item(pos, ItemStack("farming:meat"))
				obj:setvelocity({x=math.random(-1,1), y=5, z=math.random(-1,1)})
			end
			if math.random(1,50) == 1 then
				targetvektor = vector.multiply(vector.normalize({x=math.random(-10,10),y=math.random(-10,10),z=math.random(-10,10)}),def.speed)
				--targetdistance = math.sqrt((targetvektor.x*targetvektor.x)+(targetvektor.y*targetvektor.y)+(targetvektor.z*targetvektor.z))
				--targetvektor = {x=(targetvektor.x/targetdistance)*def.speed,y=(targetvektor.y/targetdistance)*def.speed,z=(targetvektor.z/targetdistance)}
			end
			local entity = get_nearest_enemy(self,pos,40)
--			for _,entity in ipairs(minetest.get_objects_inside_radius(pos,25)) do
--				if entity:is_player() then
					if entity then
					animation = 2
					target = entity:getpos()
					targetvektor = vector.multiply(vector.normalize({x=target.x-pos.x,y=target.y-pos.y,z=target.z-pos.z}),def.speed)
					end
--					targetdistance = math.sqrt((targetvektor.x*targetvektor.x)+(targetvektor.y*targetvektor.y)+(targetvektor.z*targetvektor.z))
--					targetvektor = {x=(targetvektor.x/targetdistance)*def.speed,y=(targetvektor.y/targetdistance)*def.speed,z=(targetvektor.z/targetdistance)*def.speed}
--				end
--			end
			if self.timer >= 2 then

--				for _,obj in ipairs(minetest.get_objects_inside_radius(pos,def.size*2)) do
--					if obj:is_player() then
				local obj = get_nearest_enemy(self,pos,def.size *3,true)
				if obj then
					obj:punch(self.object, 1.0, {full_punch_interval=1.0,damage_groups = {fleshy=def.damage}})
					if obj:is_player() then
						add_to_law_status(obj:get_player_name(),self.lawname,-self.damage)
					end
				self.timer = 0
				end
--					end
--				end
			end
			pos.y = pos.y - 1
			local n = minetest.get_node(pos).name
			if default_is_swimmable(n) then
				if targetvektor then
				targetvektor.y = 0
				else
				targetvektor = {x=0,y=0,z=0}
				end
			end
			pos.y = pos.y + 2
			local n = minetest.get_node(pos).name
			if default_is_swimmable(n) then
				if targetvektor then
				targetvektor.y = math.max(targetvektor.y,1 )
				else
				targetvektor = {x=0,y=1,z=0}
				end
			end
			pos.y = pos.y-1
			if targetvektor then
				self.object:setvelocity(targetvektor)
				self.object:setyaw(math.atan2(targetvektor.z,targetvektor.x)-(math.pi/2))
			end
			animate(self, animation)
		end
	})
	register_spawn("bats:" .. name, {"default:angmarsnow","default:mordordust_mapgen"},def.chanche)
end
function register_jellyfish(def)
	register_jellyfish_advanced(def.name, {
		size = def.size,
		speed = def.speed,
		max_hp = def.max_hp,
		damage = def.damage,
		--drops = {{name = "bats:jelly",chanche = 1,min = 1,max = 3}},
		chanche = def.chanche
	})
end
register_jellyfish({
	name = "bat",
	size =0.5,
	max_hp = 10,
	damage = 1,
	chanche = 6400,
	speed = 10
})
--[[register_jellyfish({
	name = "b",
	size = 0.3,
	max_hp = 15,
	damage = 4,
	chanche = 40000
})
register_jellyfish({
	name = "c",
	size = 0.5,
	max_hp = 25,
	damage = 2,
	chanche = 20000
})
register_jellyfish({
	name = "d",
	size = 0.25,
	max_hp = 10,
	damage = 1,
	chanche = 20000
})
register_jellyfish({
	name = "e",
	size = 0.2,
	max_hp = 10,
	damage = 10,
	chanche = 80000,
	speed = 1.5
})
register_jellyfish({
	name = "f",
	size = 0.1,
	max_hp = 5,
	damage = 8,
	chanche = 40000,
	speed = 1
})
register_jellyfish({
	name = "g",
	size = 0.75,
	max_hp = 20,
	damage = 2,
	chanche = 20000,
	speed = 2.5
})
register_jellyfish({
	name = "h",
	size = 0.75,
	max_hp = 20,
	damage = 5,
	chanche = 80000,
	speed = 3
})]]
