-- Minetest mod: jellyfish
-- (c) Kai Gerd Müller
-- See README.txt for licensing and other information.
local jellyfish_spawn_constant = 3
local function register_spawn(name, nodes,chanche)
	minetest.register_abm({
		label = "spawn",
		catch_up = true,
		nodenames = nodes,
		interval = 10,
		chance = chanche,
		action = function(pos, node, _, active_object_count_wider)
			if active_object_count_wider < fish_overspawn_constant then
				minetest.add_entity(pos, name)
			end
		end
	})
end
local function get_nearest_enemy(pos,radius,fucking_punchtest)
	local min_dist = radius+1
	local target = false
	for _,entity in ipairs(minetest.get_objects_inside_radius(pos,radius)) do
		local luaent = entity:get_luaentity()
		if (luaent and (not luaent.jellyfish)) or entity:is_player() then
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
function register_jellyfish_advanced(name, def)
	local defbox = def.size/2
	local side2 = name .. "3.png"
	local side = name .. "2.png"
	local front = name .. "1.png"
	minetest.register_entity("jellyfish:" .. name,{
		initial_properties = {
			name = "jellyfish:" .. name,
			hp_max = def.max_hp*6,
			visual_size = {x = def.size, y = def.size, z = def.size},
			visual = "cube",
			textures = {side ,side , front , "empty.png" ,side2 ,side },
			collisionbox = {-defbox, -defbox, -defbox, defbox, defbox, defbox},
			physical = true
		},
		-- ON ACTIVATE --
		on_punch = function(self)
			local pos = self.object:getpos()
			if self.object:get_hp() > 0 then return end
			local pos = self.object:getpos()
			pos.y = pos.y + 0.5
			self.object:remove()
			local obj = minetest.add_item(pos, ItemStack("farming:jelly " .. math.random(1, 3)))
			if obj then
			obj:setvelocity({x=math.random(-1,1), y=5, z=math.random(-1,1)})
			end
		end,
		on_activate = function(self)
			self.targetvektor = {x=0, y = 0 , z = 0 }
			self.seamonster = true
			self.jellyfish = true
			self.object:setacceleration({x = 0, y = 0, z = 0})
			self.object:set_properties({automatic_rotate = 0})
			self.object:setvelocity({x = math.random(-1,1), y = math.random(-1,1), z = math.random(-1,1)})
			timer = 0
		end,
		-- ON PUNCH --
		-- ON STEP --
		on_step = function(self, dtime)
			timer = timer + dtime
			if timer > 1 then
				timer = 0
			end
			local pos = self.object:getpos()
			if not(self.object:get_hp() > 0) then
				pos.y = pos.y + 0.5
				self.object:remove()
				local obj = minetest.add_item(pos, ItemStack("farming:jelly " .. math.random(1, 3)))
			if obj then
			obj:setvelocity({x=math.random(-1,1), y=5, z=math.random(-1,1)})
			end
			end
			if math.random(1,50) == 1 then
				self.targetvektor = {x=math.random(-10,10),y=math.random(-10,10),z=math.random(-10,10)}
				local targetdistance = math.sqrt((self.targetvektor.x*self.targetvektor.x)+(self.targetvektor.y*self.targetvektor.y)+(self.targetvektor.z*self.targetvektor.z))
				self.targetvektor = {x=(self.targetvektor.x/targetdistance)*def.speed,y=(self.targetvektor.y/targetdistance)*def.speed,z=(self.targetvektor.z/targetdistance)}
			end
				local enemy = get_nearest_enemy(pos,25)
				if enemy then
				self.targetvektor = vector.multiply(vector.normalize(vector.subtract(enemy:getpos(),pos)),def.speed)
				end
					if minetest.get_node({x=pos.x,y=pos.y+1,z=pos.z}).name ~= "default:water_source" then
						self.targetvektor.y = -1
					end
			if timer == 0 then
				local obj = get_nearest_enemy(pos,1.5,true)
				if obj then
				obj:punch(self.object, 1.0, {full_punch_interval=1.0,damage_groups = {fleshy=def.damage}})
				end
			end
			if minetest.get_node(pos).name ~= "default:water_source" then
				self.object:remove()
			end
			if self.targetvektor then
				self.object:setvelocity(self.targetvektor)
				self.object:setyaw(math.atan2(self.targetvektor.z,self.targetvektor.x))
			end
			if math.random(1,math.ceil(6000/dtime)) == 1 then
				self.object:remove()
			end
		end
	})
	register_spawn("jellyfish:" .. name, "default:water_source",def.chanche)
end
function register_jellyfish(def)
	register_jellyfish_advanced(def.name, {
		size = def.size,
		speed = 2 or def.speed,
		max_hp = def.max_hp,
		damage = def.damage,
		drops = {{name = "farming:jelly",chanche = 1,min = 1,max = 3}},
		chanche = def.chanche
	})
end
register_jellyfish({
	name = "a",
	size = 0.25,
	max_hp = 10,
	damage = 5,
	chanche = 800000*jellyfish_spawn_constant*fish_spawn_constant,
	speed = 3
})
register_jellyfish({
	name = "b",
	size = 0.3,
	max_hp = 15,
	damage = 4,
	chanche = 400000*jellyfish_spawn_constant*fish_spawn_constant
})
register_jellyfish({
	name = "c",
	size = 0.5,
	max_hp = 25,
	damage = 2,
	chanche = 200000*jellyfish_spawn_constant*fish_spawn_constant
})
register_jellyfish({
	name = "d",
	size = 0.25,
	max_hp = 10,
	damage = 1,
	chanche = 200000*jellyfish_spawn_constant*fish_spawn_constant
})
register_jellyfish({
	name = "e",
	size = 0.2,
	max_hp = 10,
	damage = 10,
	chanche = 800000*jellyfish_spawn_constant*fish_spawn_constant,
	speed = 1.5
})
register_jellyfish({
	name = "f",
	size = 0.1,
	max_hp = 5,
	damage = 8,
	chanche = 400000*jellyfish_spawn_constant*fish_spawn_constant,
	speed = 1
})
register_jellyfish({
	name = "g",
	size = 0.75,
	max_hp = 20,
	damage = 2,
	chanche = 200000*jellyfish_spawn_constant*fish_spawn_constant,
	speed = 2.5
})
register_jellyfish({
	name = "h",
	size = 0.75,
	max_hp = 20,
	damage = 5,
	chanche = 800000*jellyfish_spawn_constant*fish_spawn_constant,
	speed = 3
})
