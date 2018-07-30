-- Minetest 0.4 mod: volcano
-- See README.txt for licensing and other information.
--[[size
max_hp
howerheight
lift
agility
drops
speed
gravitation
]]
local function highenough(pos,l,h)
local r = 0
l = math.floor(l)
h = math.floor(h)
for x = -l,l do
for y = -h,0 do
for z = -l,l do
if minetest.get_node({x = pos.x+x,y=pos.y+y,z=pos.z+z}).name ~= "air" and minetest.get_node({x = pos.x+x,y=pos.y+y,z=pos.z+z}).name ~= "ignore" then
r = 1
end
end
end
end
return r
end
local function interpolate(v,v1,a)
return vector.add(vector.multiply(v,a),vector.multiply(v1,1-a))
end
local function banditstop(self,player)
		local name = player:get_player_name()
	self.hudwel = hudwelshplayers[name] and (hudwelshlaw[name]<=0)
	self.orc = orcishplayers[name] and (orcishlaw[name]<=0)
	self.dunlending = dunlendingshplayers[name] and (dunlendingshlaw[name]<=0)
end
local function animate(self, t)
	if t == 1 and self.canimation ~= 1 then
		self.object:set_animation({
			x = 0,
			y = 250},
			1, 0)
		self.canimation = 1
	elseif t == 2 and self.canimation ~= 2 then
		self.object:set_animation({x = 0,y = 250},200, 0)
		self.canimation = 2
	--walkmine
	elseif t == 3 and self.canimation ~= 3 then
		self.object:set_animation({x = 0,y = 250},400, 0)
		self.canimation = 3
	--walk
	end
end
function register_aircraftitem(name)
	minetest.register_craftitem("horses:spawn_" .. name, {
		description = name,
		inventory_image = "finalisator.png",--name .. ".png",
		on_place = function(itemstack, placer, pointed_thing)
			local pos = pointed_thing.above
			if pos and not minetest.is_protected(pos, placer:get_player_name()) then
				pos.y = pos.y + 1
				minetest.add_entity(pos, "horses:" .. name)
				if not creative then
					itemstack:take_item()
				end
			end
			return itemstack
		end,
	})
end
function register_aircraft_advanced(name, def)
	local defbox = def.defbox or 0.5
	minetest.register_entity("horses:" .. name,{
		initial_properties = {
			name = "horses:"--[[ .. name]],
			hp_max = def.max_hp,
			visual = "mesh",
			visual_size = {x=1,y=1,z=1},
			mesh =def.b3d or "LOTHhorse.b3d",
			textures = def.qwarg or {"horsetex1.png"},
			collisionbox = {-defbox, -1.2, -defbox, defbox, 0.6, defbox},
			physical = true
		},
		-- ON ACTIVATE --
		on_punch = function(self)
			if self.object:get_hp() > 0 then return end
--[[			local pos = self.object:getpos()
			pos.y = pos.y + 2
			self.object:remove()
			local obj = nil
			for _,drop in ipairs(def.drops) do
				if math.random(1, drop.chance) == 1 then
					obj = minetest.add_item(pos, ItemStack(drop.name .. " " .. math.random(drop.min, drop.max)))
					if obj then
						obj:setvelocity({x=math.random(-1,1), y=5, z=math.random(-1,1)})
					end
				end
			end]]
				if self.owner then
				self.owner:set_detach()
				default.player_attached[self.owner:get_player_name()] = false
				self.object:remove()
				minetest.add_item(vector.add(self.object:getpos(),{x=0,y=1,z=0}),"farming:meat 2")
				end
		end,
		on_activate = function(self,sd)
			self.orc = def.orc
			self.warhorse = def.hudwel
			self.hudwel = def.hudwel
			self.dunlending = def.hudwel
			local sd = minetest.parse_json(sd) or false
			if sd then
				self.throttle = sd.throttle
				if sd.owner_name then
					if sd.owner_name == "" then
						db({"TRUE!!!"},"Debug")
					end
					self.owner  = minetest.get_player_by_name(sd.owner_name)
					if self.owner then
					default.player_attached[sd.owner_name] = true
					self.owner:set_attach(self.object, "", {x = 0, y = 10, z = 0}, {x = 0, y = 180, z = 0}) end
				end
			else
				self.throttle = 0
			end
			self.object:setacceleration({x=0,y=-9.81,z=0})
			self.hover = 0
			self.object:set_properties({automatic_rotate = 0})
			self.jump = 1
		end,
		-- ON PUNCH --
		-- ON STEP --
		on_rightclick = function(self,clicker)
			if not self.owner then
				self.owner = clicker
				self.owner_name = clicker:get_player_name()
				default.player_attached[self.owner_name] = true
				clicker:set_attach(self.object, "", {x = 0, y = 10, z = 0}, {x = 0, y = 180, z = 0})
			elseif self.owner_name == clicker:get_player_name() then
				self.owner = nil
				self.owner_name = nil
				clicker:set_detach()
				default.player_attached[clicker:get_player_name()] = false
			end

		end,
		get_staticdata = function(self)
			return minetest.write_json({throttle = self.throttle,owner_name = self.owner_name})
		end,
		on_step = function(self, dtime)
			if not self.jump then
				self.jump = 1
			end
			if self.jump > 0 then
				self.jump = self.jump -dtime
			end
			local targetvektor = {x=0,y=self.object:getvelocity().y,z=0}
			local pos = self.object:getpos()
			pos.y = pos.y-1
			if not(self.object:get_hp() > 0) then
--[[				pos.y = pos.y + 0.5
				self.object:remove()
				local obj = nil
				for _,drop in ipairs(def.drops) do
					if math.random(1, drop.chance) == 1 then
						obj = minetest.add_item(pos, ItemStack(drop.name.." "..math.random(drop.min, drop.max)))
						if obj then
							obj:setvelocity({x=math.random(-1,1), y=5, z=math.random(-1,1)})
						end
					end
				end]]
				if self.owner then
				self.owner:set_detach()
				default.player_attached[self.owner:get_player_name()] = false
				end
				self.object:remove()
				minetest.add_item(vector.add(pos,{x=0,y=1,z=0}),"farming:meat 2")
			end
			pos.y = pos.y+0.5
			local posvar = self.object:getpos()
			local abov = minetest.get_node(posvar).name
			if abov == "default:lava_source" or abov == "default:lava_flowing" then
				self.owner:set_detach()
				default.player_attached[self.owner:get_player_name()] = false
				self.object:remove()
			else
			posvar.y = posvar.y+0.5
			abov = minetest.get_node(posvar).name
			if default_is_swimmable(abov) then
				self.owner:set_detach()
				default.player_attached[self.owner:get_player_name()] = false
			self.object:remove()
				minetest.add_item(vector.add(pos,{x=0,y=1,z=0}),"farming:meat 2")
			end
			end
			local look = {1,0,0}
			if self.owner then
				banditstop(self,self.owner)
				look = self.owner:get_look_dir() or {1,0,0}
				local ctrl = self.owner:get_player_control()
				if ctrl.up and self.throttle < 1 then
					self.throttle = self.throttle + 1
				elseif ctrl.down and self.throttle >0 then
					self.throttle = self.throttle - 1
				end
				if ctrl.jump and self.hover < 1 then
					self.hover = self.hover + 0.01
				elseif ctrl.sneak and self.hover >0 then
					self.hover = self.hover - 0.01
				end
				targetvektor = vector.multiply(
				{x=look.x,y=0,z=look.z}
				,self.throttle*
				def.speed/
				math.sqrt((look.x*look.x)+(look.z*look.z)))
				targetvektor.y = self.object:getvelocity().y
				velocity = self.object:getvelocity()
			if self.jump <= 0 and vector.distance(vector.new(),velocity)<vector.length(targetvektor)/1.5 and velocity.y == 0 and minetest.registered_nodes[minetest.get_node(vector.add(pos,{x=0,y=-1.5,z=0})).name].walkable then
				stomp(self,2)
				self.jump = 0.25
			end
				--[[targetvektor.y = (
					def.lift*highenough(pos,def.size/2
					,def.howerheight*
					self.hover))-
				(def.gravitation*
					(1-
						highenough(pos
						,def.size/2
						,(def.howerheight*
						self.hover)
						+2)))]]
			end
			self.object:setvelocity(targetvektor)
			if vector.length(targetvektor) ~= 0 then
			animate(self,3)
			else
			animate(self,1)
			end
			self.object:setyaw(math.atan2(targetvektor.z,targetvektor.x)+math.pi/2)
		end
	})
end


function register_aircraft(def)
	register_aircraft_advanced(def.name, {
		orc = def.orc,
		defbox = def.defbox,
		hudwel = def.hudwel,
		qwarg = def.qwarg,
		b3d = def.b3d,
		lift = def.lift,
		howerheight = def.hover,
		size = def.size,
		speed = def.speed,
		max_hp = def.max_hp,
		gravitation = 50,
		drops = {},
	})
a = 0
end
--[[minetest.register_craftitem("horses:craftingtable", {
	description = "Craftingtable",
	inventory_image = "hov_crafts.jpg",
	on_use = function(ignore,player)
		minetest.show_formspec(player:get_player_name(), "crafts[tnta]", "size[0,0]image[-6.5,-5;17,10;hov_crafts.jpg]")
	end
})]]
register_aircraft({
	name = "horse",
	size = 1,
	max_hp = 67,
	hudwel = true,
	dunlending = true,
	hover = 8,
	lift = 10,
	speed = 6
})
register_aircraft({
	name = "warg",
	b3d = "LOTHWARG1.b3d",
	defbox = 0.8,
	orc = true,
	qwarg = {"wargtex2.png"},
	size = 1,
	max_hp = 80,
	hover = 8,
	lift = 10,
	speed = 8
})
