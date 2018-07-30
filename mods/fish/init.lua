-- Minetest mod: jellyfish
-- (c) Kai Gerd Müller
-- See README.txt for licensing and other information.
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
function register_jellyfish_advanced(name, def)
	local defbox = def.size/2
	local side2 = name .. "3.png"
	local side = name .. "2.png"
	local front = name .. "1.png"
	minetest.register_entity("fish:" .. name,{
		initial_properties = {
			name = "fish:" .. name,
			hp_max = def.max_hp,
			visual_size = {x = def.size*3, y = def.size*3, z = def.size*3},
			visual = "mesh",
			mesh = "fish.obj",
			textures = {"fishtex.png"},
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
			minetest.add_item(pos, ItemStack("farming:meat"))
		end,
		on_activate = function(self)
			self.hudwel = true
			self.orc = true
			self.dunlending = true
			self.seamonster = true
			self.jellyfish = true
			self.object:setacceleration({x = 0, y = 0, z = 0})
		--self.object:set_animation({x = 0,y = 250},250, 0)
			self.object:setvelocity({x = math.random(-1,1), y = math.random(-1,1), z = math.random(-1,1)})
			self.timer = 0
				self.targetvektor = {x=math.random(-10,10),y=math.random(-10,10),z=math.random(-10,10)}
				local targetdistance = math.sqrt((self.targetvektor.x*self.targetvektor.x)+(self.targetvektor.y*self.targetvektor.y)+(self.targetvektor.z*self.targetvektor.z))
				if targetdistance == 0 then
				self.targetvektor = {x=0,y=def.speed,z=0}
				else
				self.targetvektor = {x=(self.targetvektor.x/targetdistance)*def.speed,y=(self.targetvektor.y/targetdistance)*def.speed,z=(self.targetvektor.z/targetdistance)}
				end
		end,
		-- ON PUNCH --
		-- ON STEP --
		on_step = function(self, dtime)
			self.timer = self.timer+dtime
			if self.timer >= 120 then
				self.object:remove()
			end
			local pos = self.object:getpos()
			if not(self.object:get_hp() > 0) then
				pos.y = pos.y + 0.5
				self.object:remove()
				obj = minetest.add_item(pos, ItemStack("fish:jelly " .. math.random(1, 3)))
				if obj then
				obj:setvelocity({x=math.random(-1,1), y=5, z=math.random(-1,1)})
				end
			end
			if math.random(1,30) == 1 then
				self.targetvektor = {x=math.random(-10,10),y=math.random(-3,5),z=math.random(-10,10)}
				local targetdistance = math.sqrt((self.targetvektor.x*self.targetvektor.x)+(self.targetvektor.y*self.targetvektor.y)+(self.targetvektor.z*self.targetvektor.z))
				if targetdistance == 0 then
				self.targetvektor = {x=0,y=def.speed,z=0}
				else
				self.targetvektor = {x=(self.targetvektor.x/targetdistance)*def.speed,y=(self.targetvektor.y/targetdistance)*def.speed,z=(self.targetvektor.z/targetdistance)}
				end
			end
			local min_distance = 4
			for _,entity in ipairs(minetest.get_objects_inside_radius(pos,5)) do
				local luaent = entity:get_luaentity()
				if entity:is_player() --[[or (luaent and (luaent.jellyfish or luaent.seamonster))]] then
					local target = entity:getpos()
					self.targetvektor = {x=pos.x-target.x,y=pos.y-target.y,z=pos.z-target.z}
					local targetdistance = math.sqrt((self.targetvektor.x*self.targetvektor.x)+(self.targetvektor.y*self.targetvektor.y)+(self.targetvektor.z*self.targetvektor.z))
					if targetdistance < min_distance then
					if minetest.get_node({x=pos.x,y=pos.y+1,z=pos.z}).name ~= "default:water_source" then
						self.targetvektor.y = -1
						self.targetvektor = vector.normalize(self.targetvektor)
					else
						self.targetvektor.y = (0.5+(self.targetvektor.y/targetdistance))*targetdistance
						self.targetvektor = vector.normalize(self.targetvektor)
					end
					self.targetvektor = vector.multiply(self.targetvektor,def.speed)
					min_distance = targetdistance
					end
				end
			end
			if minetest.get_node(pos).name ~= "default:water_source" then
				self.object:remove()
				minetest.add_item(pos, ItemStack("farming:meat"))
			end
			if self.targetvektor then
				self.object:setvelocity(self.targetvektor)
				self.object:set_properties({automatic_rotate = 0})
				self.object:setyaw(math.atan2(self.targetvektor.z,self.targetvektor.x)+(math.pi+(math.sin(self.timer*10)/3)))
			end
			if math.random(1,math.ceil(6000/dtime)) == 1 then
				self.object:remove()
			end
		end
	})
	register_spawn("fish:" .. name, "default:water_source",def.chanche)
end
function register_jellyfish(def)
	register_jellyfish_advanced(def.name, {
		size = def.size,
		speed = 2 or def.speed,
		max_hp = def.max_hp,
		damage = def.damage,
		drops = {{name = "farming:meat",chanche = 1,min = 1,max = 1}},
		chanche = def.chanche
	})
end

register_jellyfish({
	name = "fish",
	size = 0.75,
	max_hp = 6,
	damage = 5,
	chanche = 60000*fish_spawn_constant,
	speed = 4
})
