-- Minetest mod: jellyfish
-- (c) Kai Gerd Müller
-- See README.txt for licensing and other information.
local seamonster_size_const = 1.6
local seamonster_spawn_const = 3
local function register_spawn(name, nodes,chanche)
	--[[minetest.register_abm({
		label = "spawn",
		catch_up = true,
		nodenames = nodes,
		interval = 10,
		chance = chanche*3,
		action = function(pos, node, _, active_object_count_wider)
			if active_object_count_wider < fish_overspawn_constant then
				minetest.add_entity(pos, name)
			end
		end
	})]]
default_register_sbm({
	label = "spawn",
	catch_up = false,
	nodenames = nodes,
	neighbors = {"air"},
	interval = 10,
	chance = chanche*6,
	action = function(p)
		minetest.add_entity(p,name)
	end,
})
end
local function animate(self, t,name)
	if t == 1 and (self.canimation ~= 1) then
		self.object:set_animation({
			x = 0,
			y = ((name == "turtlefish") and 100) or 250},
			50, 0)
		self.canimation = 1
	elseif t == 2 and (self.canimation ~= 2) then
		self.object:set_animation({x = 0,y = ((name == "turtlefish") and 100) or 250},100, 0)
		self.canimation = 2
	--walkmine
	elseif t == 3 and (self.canimation ~= 3) then
		self.object:set_animation({x = 0,y = ((name == "turtlefish") and 100) or 250},150, 0)
		self.canimation = 3
	--walk
	end
end
local function get_nearest_enemy(pos,radius,fucking_punchtest,dtime)
	local min_dist = radius+0.01
	local target = false
	for _,entity in ipairs(minetest.get_objects_inside_radius(pos,radius+1)) do
		local luaent = entity:get_luaentity()
		if (luaent and (not luaent.balrog)) or entity:is_player() then
		local p = entity:getpos()
		if fucking_punchtest and math.random(1,math.ceil(1/dtime)) then
		local p2 = vector.add(p,vector.multiply(vector.normalize(vector.subtract(pos,p)),dtime))
		if default_is_swimmable(minetest.get_node(p2).name) then
			entity:setpos(p2)
		end
		end
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
	local defheigth = def.heigth/2
	local defdownstart = -(def.lower_defbox_lim or defheigth)
	minetest.register_entity("lothwormdragons:" .. name,{
		initial_properties = {
			name = "lothwormdragons:" .. name,
			hp_max = def.max_hp,
			visual_size = {x = def.visualsize*8, y = def.visualsize*5, z = def.visualsize*2},
			visual = "mesh",
			mesh = def.mesh,--"TURTLETEST.b3d",
			textures = def.textures,
			collisionbox = {-defbox, defdownstart, -defbox, defbox, defheigth, defbox},
			physical = true
		},
		-- ON ACTIVATE --
		on_punch = function(self,ent)
			local pos = self.object:getpos()
			if self.object:get_hp() > 0 then return end
if ent:is_player() then
local player_name = ent:get_player_name()
if not sauron_killed_bosses[player_name] then
sauron_killed_bosses[player_name] = {}
end
sauron_killed_bosses[player_name][self.object:get_luaentity().name] = true
default_write_back_boss_kill_flags()
--bones_netherport(ent)
end
			local pos = self.object:getpos()
			pos.y = pos.y + 0.5
			self.object:remove()
			obj = minetest.add_item(pos, ItemStack("farming:meat " .. math.random(1, 3)))
			obj:setvelocity({x=math.random(-1,1), y=5, z=math.random(-1,1)})
		end,
		get_staticdata = function(self)
			return "~"
		end,
		on_activate = function(self,sd)
	--minetest.chat_send_all(defbox)
			if sd== "" then
			if def.name == "turtlefish" then
				self.object:set_armor_groups({fleshy = 30})
			else
				self.object:set_armor_groups({fleshy = 50})
			end
			end
			self.last_watered_pos = self.object:getpos()
			if def.name == "seaserpent" then
			self.poison = new_poison_storage(math.random(33,666),math.random(33,9))
			end
			self.targetvektor = {x=0, y = 0 , z = 0 }
			self.balrog = true
			self.jellyfish = true
			self.object:setacceleration({x = 0, y = 0, z = 0})
			self.object:setvelocity({x = math.random(-1,1), y = math.random(-1,1), z = math.random(-1,1)})
			self.timer = 0
			self.object:set_properties({automatic_rotate = 0})
			--self.object:set_animation({x = 0,y = 80},50, 0)
			animate(self,1,def.name)
			--self.object:set_animation({x = 0,y = 250},50, 0)
			if def.name == "seaserpent" then
			self.poisontimer = 0
			end
		end,
		-- ON PUNCH --
		-- ON STEP --
		on_step = function(self, dtime)
			if def.name == "seaserpent" then
			self.poisontimer = self.poisontimer + dtime
			if self.poisontimer >= 1 then
			self.poisontimer = 0
			self.poison = self.poison.charge(self.poison)
			end
			end
			--minetest.set_node(self.object:getpos(),{name= "default:ice"})
			self.nextcanimation = 2
			self.timer = self.timer + dtime
			local pos = self.object:getpos()
			if not(self.object:get_hp() > 0) then
				pos.y = pos.y + 0.5
				self.object:remove()
				obj = minetest.add_item(pos, ItemStack("farming:meat " .. math.random(1, 3)))
				obj:setvelocity({x=math.random(-1,1), y=5, z=math.random(-1,1)})
			end
			if math.random(1,50) == 1 then
				self.targetvektor = {x=math.random(-10,10),y=math.random(-10,10),z=math.random(-10,10)}
				local targetdistance = math.sqrt((self.targetvektor.x*self.targetvektor.x)+(self.targetvektor.y*self.targetvektor.y)+(self.targetvektor.z*self.targetvektor.z))
				self.targetvektor = {x=(self.targetvektor.x/targetdistance)*def.speed,y=(self.targetvektor.y/targetdistance)*def.speed,z=(self.targetvektor.z/targetdistance)}
			end
				local enemy = get_nearest_enemy(pos,25)
				if enemy then
				self.nextcanimation = 3
				self.targetvektor = vector.multiply(vector.normalize(vector.subtract(enemy:getpos(),pos)),def.speed)
				end
					if minetest.get_node({x=pos.x,y=pos.y+0.5,z=pos.z}).name ~= "default:lava_source" then
						self.targetvektor.y = -0.2
					end
			if self.timer >= 1 then
				self.timer = 0
				local obj = get_nearest_enemy(pos,3,true,dtime)
				if obj then
				obj:punch(self.object, 1.0, {full_punch_interval=1.0,damage_groups = {fleshy=def.damage}})
				if (math.random(1,120) == 1) and( not( obj:get_luaentity() and (obj:get_luaentity().name == "sauron:sauron"))) then
					obj:set_hp(0)
				end
				if def.name == "seaserpent" then
				self.poison = self.poison.poison(self.poison,obj)
				end
				end
			end
			local wian = minetest.get_node(pos).name
			if wian == "air" then
				wian = minetest.get_node(self.last_watered_pos).name
				if (wian == "default:lava_source") or (wian == "default:lava_flowing") then
				self.object:setpos(self.last_watered_pos)
				else
				self.object:set_hp(0)
				end
			elseif (wian == "default:lava_source") or (wian == "default:lava_flowing") then
				self.last_watered_pos = pos
			end
			if self.targetvektor then
				animate(self, self.nextcanimation,def.name)
				self.object:setvelocity(self.targetvektor)
				self.object:setyaw(math.atan2(self.targetvektor.z,self.targetvektor.x)+(((def.name == "turtlefish") and math.pi/2) or -math.pi/2))
			else
				animate(self, 1,def.name)
			end
			if math.random(1,math.ceil(6000/dtime)) == 1 then
				self.object:remove()
			end
		end
	})
	register_spawn("lothwormdragons:" .. name, "default:lava_source",def.chanche)
end
function register_jellyfish(def)
	register_jellyfish_advanced(def.name, {
		name = def.name,
		size = def.size,
		mesh = def.mesh,
		textures = def.textures,
		heigth = def.heigth,
		lower_defbox_lim = def.lower_defbox_lim,
		visualsize = def.visual_size,
		speed = def.speed or 3,
		max_hp = def.max_hp,
		damage = def.damage,
		drops = {{name = "farming:jelly",chanche = 1,min = 1,max = 3}},
		chanche = def.chanche
	})
end
--[[register_jellyfish({
	name = "turtlefish",
	mesh = "turtlefish.b3d",
	textures = {"turtlefish_texture.png"},
	size = 1.5*seamonster_size_const,
	visual_size = seamonster_size_const,
	lower_defbox_lim = 0.2*seamonster_size_const,
	heigth = seamonster_size_const,
	max_hp = 900,
	damage = 10,
	chanche = 400000*seamonster_spawn_const*fish_spawn_constant,
})]]
register_jellyfish({
	name = "seaserpent",
	mesh = "seaserpent3.b3d",
	textures = {"magmaserpent_texture.png"},
	size = 1.5*seamonster_size_const,
	visual_size = seamonster_size_const,
	heigth = seamonster_size_const,
	max_hp = 800,
	damage = 25,
	chanche = 24000,--seamonster_spawn_const*fish_spawn_constant,
	speed = 6
})
