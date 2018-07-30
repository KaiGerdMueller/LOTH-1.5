-- Minetest mod: jellyfish
-- (c) Kai Gerd Müller
-- See README.txt for licensing and other information.
--[[local function spawn_fire(self,pos,targetvektor)
			--local new_pos = vector.add(pos,vector.multiply(vector.normalize({x=targetvektor.x,y=0,z=targetvektor.z}),10))
			new_pos.y = new_pos.y + 6
			local targetvektor = vector.multiply(vector.normalize(vector.add(targetvektor,vector.subtract(pos,new_pos))),self.firespeed)
			--db({"TEST"},"Debug")
			local arrow = minetest.add_entity(pos,"lotharrows:dragonfire")
			local arrowent = arrow:get_luaentity()
			arrowent.shooter = user
			arrowent.damage = self.damage
			--arrow:setyaw(math.atan2(targetvektor.z,targetvektor.x)+math.pi/2)
			--db({tostring(vector.length(targetvektor))},"Debug")
			--targetvektor = {x=0,y=10,z=0}
			arrow:setvelocity(targetvektor)
			--arrow:setacceleration({x=0,y=0,z=0})
end]]
local function boom_head_freely(self,pos)
			local oldpos = {x=pos.x,y=pos.y+6,z=pos.z}
			local dir = self.object:getyaw()+(math.pi/2)
			local dirvec = {x=math.cos(dir)*12,y=6,z=math.sin(dir)*12}
			local pos = vector.add(pos,dirvec)
			if not minetest.line_of_sight(oldpos,pos) then
			tnt.boom(vector.divide(vector.add(oldpos,pos),2), {radius = 6,damage_radius = 4,hellish_explosion = true})
			end
end
local function spawn_fire(self,pos,pos2,dir)
			local dir = dir+(math.pi/2)
			local dirvec = {x=math.cos(dir)*12,y=6,z=math.sin(dir)*12}
			local pos = vector.add(pos,dirvec)
			local targetvektor = vector.multiply(vector.normalize(vector.subtract(pos2,pos)),self.firespeed)
			--local targetvektor = vector.multiply(vector.normalize(vector.add(targetvektor,vector.subtract(pos,new_pos))),self.firespeed)
			--db({"TEST"},"Debug")
			local arrow = minetest.add_entity(pos,"lotharrows:dragonfire")
			local arrowent = arrow:get_luaentity()
			arrowent.shooter = self.object
			arrowent.duration = 300/self.firespeed
			arrowent.damage = self.damage*2
			--arrow:setyaw(math.atan2(targetvektor.z,targetvektor.x)+math.pi/2)
			--db({tostring(vector.length(targetvektor))},"Debug")
			--targetvektor = {x=0,y=10,z=0}
			arrow:setvelocity(targetvektor)
			--arrow:setacceleration({x=0,y=0,z=0})
end
--[[local function spawn_fire(self,pos,targetvektor)
			--local new_pos = vector.add(pos,vector.multiply(vector.normalize({x=targetvektor.x,y=0,z=targetvektor.z}),10))
			--new_pos.y = new_pos.y + 6
			local targetvektor = vector.multiply(vector.normalize(targetvektor),self.firespeed)
			db({"TEST"},"Debug")
			local arrow = minetest.add_entity(pos,"lotharrows:dragonfire")
			local arrowent = arrow:get_luaentity()
			arrowent.shooter = 
			arrowent.damage = self.damage
			--arrow:setyaw(math.atan2(targetvektor.z,targetvektor.x)+math.pi/2)
			--arrow:setvelocity(targetvektor)
			--arrow:setacceleration({x=0,y=0,z=0})
end]]
local function register_spawn(name, nodes,chanche)
	default_register_sbm({
	label = "spawn",
	catch_up = false,
		nodenames = nodes,
		interval = 10,
		chance = chanche,
		action = function(pos)
			pos.y = pos.y + math.random(1,20)
			local n = minetest.get_node(pos).name
			if n == "air" or n == "ignore" then
				minetest.add_entity(pos, name)
			end
		end
	})
end
local function get_nearest_enemy(self,pos,radius,fucking_punchtest)
	local min_dist = 51
	local target = false
	for _,entity in ipairs(minetest.get_objects_inside_radius(pos,radius)) do
		local luaent = entity:get_luaentity()
		local name = entity:get_player_name()
		if (luaent and (not luaent.balrog)) or (entity:is_player() and (not( entity:get_player_name() == self.owner)))  then
		local p = entity:getpos()
		local dist = vector.distance(pos,p)
				if default_do_not_punch_this_stuff(luaent) and dist < min_dist then
			min_dist = dist
				target = entity
		end
		end
	end
--if target and ((not fucking_punchtest) or minetest.line_of_sight(target:getpos(),pos,2)) then
--return target
--else
return target
--end
end
local function animate(self, t)
	if t == 1 and self.canimation ~= 1 then
		self.object:set_animation({
			x = 1,
			y = 22},
			15, 0)
		self.canimation = 1
	elseif t == 2 and self.canimation ~= 2 then
		self.object:set_animation({x = 1,y = 22},20, 0)
		self.canimation = 2
	--walkmine
	end
end
local function interpolate(a,b,i)
	return a*i+b*(1-i)
end
local function floor_under(pos,subtractor)
	local p = {x=pos.x,y=pos.y,z=pos.z}
	for x = -subtractor,pos.y do
		p.y = x
		local n = minetest.get_node(p).name
		if (n ~= "air") and (n ~= "ignore") and (n ~= "fire:basic_flame") and (n ~= "fire:permanent_flame") then
			return true
		end
	end
	return false
end
local function register_jellyfish_advanced(name, def)
	local defbox = def.size/3
	local defrad = math.sqrt(2*defbox*defbox)+1
	local defrad2 = defbox+1
	local side2 = name .. "3.png"
	local side = name .. "2.png"
	local front = name .. "1.png"
	minetest.register_entity("dragons:" .. name,{
		initial_properties = {
			name = "dragons:" .. name,
			hp_max = def.max_hp,
			visual_size = {x = def.size*0.4, y = def.size*0.4, z = def.size*0.4},
			visual = "mesh",
			mesh = "dragon.b3d",
			textures = {"dmobs_dragon_great.png"},
			collisionbox = {-defbox*0.6, -defbox*0.9, -defbox*0.6, defbox*0.6, defbox*0.4, defbox*0.6},
			physical = true
		},
		-- ON ACTIVATE --
		on_punch = function(self,ent) 
			if ent and ent:get_player_name() == self.owner and self.object:get_hp() < def.max_hp/2 then
				self.owner = "meaner.txt"
				self.g_mode = nil
			end
			default_add_boss_kill_flag(self,ent)
			end,
		on_activate = function(self,static)
			self.firespeed = 20
			self.dragonproof = true
			self.damage= def.damage
			self.arrow_resistant = true
			self.dragon = true
			self.balrog = true
			self.object:set_properties({automatic_rotate = 0})
--			self.orc = true
			self.targetvektor = {x=0, y = 0 , z = 0 }
			self.object:setacceleration({x = 0, y = 0, z = 0})
			self.object:setvelocity({x = math.random(-1,1), y = math.random(-1,1), z = math.random(-1,1)})
			self.lifetimer = 0
			self.timer = 0
			self.direction_timer = 0
			self.boom_head_timer = 0
			local static = static or "1800#singleplayer.txt"
			local split_index = string.find(static,"#") or false
			self.regentimer = 1800
			if split_index then
			local split_index2 = string.find(static,"\n")
			if split_index2 then
				static = string.sub(static,1,split_index2-1)
				self.g_mode = true
			end
			self.regentimer = tonumber(string.sub(static,1,split_index-1))
			self.owner = string.sub(static,split_index+1)
			else
			if static == "" then
				self.object:set_armor_groups({fleshy = 7,level = 1})
			end
			static = "1800#singleplayer.txt"
			local split_index = string.find(static,"#")
			self.regentimer = tonumber(string.sub(static,1,split_index-1))
			self.owner = string.sub(static,split_index+1)
			end
			
			--self.regentimer = tonumber(static) or 1800
		end,
		get_staticdata = function(self)
		if self.g_mode then
			return tostring(self.regentimer or 1800) .. "#" .. (self.owner or "dfd.txt").."\n"
		end
		return tostring(self.regentimer or 1800) .. "#" .. (self.owner or "dfd.txt")
		end,
		on_rightclick = function(self,click)
			if click and click:get_player_name() == self.owner then
				self.g_mode = not self.g_mode
			end
		-- ON PUNCH --
		end,
		on_step = function(self, dtime)
			self.regentimer = self.regentimer-dtime
			if self.regentimer < 0 then
			self.regentimer = 1800
			self.object:set_hp(def.max_hp)
			end
			local animation = 1
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
				obj = minetest.add_item(pos, ItemStack("default:diamondblock 10"))
				obj:setvelocity({x=math.random(-1,1), y=5, z=math.random(-1,1)})
			end
			self.boom_head_timer = self.boom_head_timer+dtime
			if self.boom_head_timer >=1 then
				boom_head_freely(self,pos)
			end
			self.direction_timer = self.direction_timer+dtime
			if self.direction_timer >= 3 then
				self.direction_timer = 0
				if self.g_mode then
					self.targetvektor = vector.new()
				else
				if floor_under(pos,20) or floor_under(vector.add(pos,vector.multiply(vector.normalize(self.targetvektor),defrad)),20) or floor_under(vector.add(pos,vector.multiply(vector.normalize(self.targetvektor),defrad2)),20)  then
				self.targetvektor = vector.multiply(vector.normalize({x=math.random(-10,10),y=math.random(-10,10),z=math.random(-10,10)}),def.speed)
				else
				self.targetvektor = vector.multiply(vector.normalize({x=math.random(-10,10),y=math.random(-10,0),z=math.random(-10,10)}),def.speed)
				end
				end
				--targetdistance = math.sqrt((targetvektor.x*targetvektor.x)+(targetvektor.y*targetvektor.y)+(targetvektor.z*targetvektor.z))
				--targetvektor = {x=(targetvektor.x/targetdistance)*def.speed,y=(targetvektor.y/targetdistance)*def.speed,z=(targetvektor.z/targetdistance)}
			end
			local entity = get_nearest_enemy(self,pos,50)
--			for _,entity in ipairs(minetest.get_objects_inside_radius(pos,25)) do
--				if entity:is_player() then
					if entity then
					animation = 2
					target = entity:getpos()
					target.y = target.y + 20
					local dx = math.min(math.abs(target.x-pos.x)-12,0)
					local dy = math.min(math.abs(target.z-pos.z)-12,0)
					local addslowing = math.min(dx*dx+dy*dy,def.speed)
					self.targetvektor = vector.multiply(vector.normalize({x=target.x-pos.x,y=target.y-pos.y,z=target.z-pos.z}),addslowing)
					end
--					targetdistance = math.sqrt((targetvektor.x*targetvektor.x)+(targetvektor.y*targetvektor.y)+(targetvektor.z*targetvektor.z))
--					targetvektor = {x=(targetvektor.x/targetdistance)*def.speed,y=(targetvektor.y/targetdistance)*def.speed,z=(targetvektor.z/targetdistance)*def.speed}
--				end
--			end
			if self.timer > 1 then
					--	db({"TEST"},"Debug")
--				for _,obj in ipairs(minetest.get_objects_inside_radius(pos,def.size*2)) do
--					if obj:is_player() then
						local obj = get_nearest_enemy(self,pos,50,true)
						if obj then
									local oposss = obj:getpos()
						if vector.distance(pos,oposss) <=15 and minetest.line_of_sight(pos,oposss,2) then
						obj:punch(self.object, 1.0, {full_punch_interval=1.0,damage_groups = {fleshy=def.damage*4}})
						if math.random(1,60) == 1 then
							obj:set_hp(0)
						end
						end
					--	db({"TEST"},"Debug")
						spawn_fire(self,pos,oposss,self.object:getyaw())
						self.timer = 0
						end
--					end
--				end
			end
			pos.y = pos.y - 1
			local n = minetest.get_node(pos).name
			if default_is_swimmable(n) then
				self.targetvektor.y = 0
			end
			pos.y = pos.y + 2
			local n = minetest.get_node(pos).name
			if default_is_swimmable(n) then
				self.targetvektor.y = 1
			end
			pos.y = pos.y-1
			if self.targetvektor then
				self.object:setvelocity(self.targetvektor)
				if self.targetvektor.x ~=0 or self.targetvektor.z ~=0 then
				self.object:setyaw(interpolate(math.atan2(self.targetvektor.z,self.targetvektor.x)-(math.pi/2),self.object:getyaw() or 0,0.1))
				end
				
			end
			animate(self, animation)
		end
	})
	register_spawn("dragons:" .. name, {"default:angmarsnow","default:mordordust_mapgen"},def.chanche)
--	register_spawn("dragons:" .. name, {"default:mordordust_mapgen"},def.chanche)
end
function register_jellyfish(def)
	register_jellyfish_advanced(def.name, {
		size = def.size,
		speed = def.speed,
		max_hp = def.max_hp,
		damage = def.damage,
		--drops = {{name = "dragons:jelly",chanche = 1,min = 1,max = 3}},
		chanche = def.chanche
	})
end
register_jellyfish({
	name = "bat",
	size =10,
	max_hp = 15000,
	damage = 80,
	chanche = 360000,--0!
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
