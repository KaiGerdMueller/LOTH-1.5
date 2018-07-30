-- Minetest mod: creepers
-- (c) Kai Gerd Müller
-- See README.txt for licensing and other information.
--[[minetest.register_node("lotharrows:boltmodel",{
	drawtype = "nodebox",
	node_box = {type = "fixed",fixed = {{-0.5,-1/20,-1/20,0.5,1/20,1/20}}},
	tiles = {"culumalda_tree_top.png"},
	groups = {not_in_creative_inventory = 1}
})
local function setbox(self)
local v = self.object:setvelocity()
local orthogonal = vector.multiply(vector.normalize({x=-v.y,y=v.x,z = 0}),0.05)
--self.object:set_properties({})
end]]
--[[local function arrow_punch(t,a,d)
if a and a:is_player() and a:get_hp() > 0 then
t:punch(a, 1.0, {full_punch_interval=1.0,damage_groups = {fleshy=d}})
else
local arm = t:get_armor_groups()
if not arm.fleshy then
arm.fleshy = 100
end
if not arm.immortal and t and t:get_hp() > 0 then
t:set_hp(math.max(t:get_hp()-math.floor(d*arm.fleshy/100),0))
end
end
end]]
local built_in_lua_pcall = pcall
local function arrow_punch(t,a,d)
if t and a and d then
if not built_in_lua_pcall(function()
t:punch(a, 1.0, {full_punch_interval=1.0,damage_groups = {fleshy=d}})
end)then
minetest.log("action","lotharrows pcall err lotharrows init.lua ln 33 called arrow_punch with ("..tostring(t)..";" .. tostring(a) .. ";" ..tostring(d)..")")
end
else
minetest.log("action","lotharrows pcall err lotharrows init.lua ln 33 called arrow_punch with ("..tostring(t)..";" .. tostring(a) .. ";" ..tostring(d)..")")
end
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
local function do_damage(self,dtime)
	if self.lotharrow and self.damage then
	local pos = self.object:getpos()
	local remove_this = arrow_shall_be_removed(self,pos)
	local target = false
	local remove = 0
	for _,entity in ipairs(minetest.get_objects_inside_radius(pos,1)) do
		local luaent  = entity:get_luaentity()
		if ((not luaent) or (not luaent.arrow_resistant))  and ((not luaent) or (not luaent.lotharrow)) then
			arrow_punch(entity,self.shooter,self.damage)
			remove  = remove-1
		elseif ((not luaent) or (not luaent.lotharrow)) then
			remove  = remove-1
		end
	end
	local n = minetest.get_node(pos).name
	if remove_this or (remove < 0) or (n ~= "air" and n ~= "ignore")then
--		db({"REM",tostring(remove)},"VeryImportantMessage")
		self.object:remove()
	end
	else
		self.object:remove()
	end
end
local function do_stone_damage(self,dtime)
	if self.lotharrow and self.damage then
	local pos = self.object:getpos()
	local remove_this = arrow_shall_be_removed(self,pos)
minetest.add_particlespawner({
	amount = 3,
	time = 3,
	minpos = pos,
	maxpos = pos,
	minvel = {x=-0.5, y=-0.5, z=-0.5},
	maxvel = {x=0.5, y=0.5, z=0.5},
	minacc = {x=0, y=0, z=0},
	maxacc = {x=0, y=0, z=0},
	minexptime = 1,
	maxexptime = 1,
	minsize = 1,
	maxsize = 10,
	collisiondetection = false,
	vertical = false,
	texture = "default_stone.png",
})
	local target = false
	self.stoneremove = self.stoneremove or 3
	for _,entity in ipairs(minetest.get_objects_inside_radius(pos,2)) do
		local luaent  = entity:get_luaentity()
		if ((not luaent) or (not luaent.arrow_resistant))  and ((not luaent) or (not luaent.lotharrow)) then
			arrow_punch(entity,self.shooter,self.damage)
			self.stoneremove  = (self.stoneremove or 3)-1
		elseif ((not luaent) or (not luaent.lotharrow)) then
			self.stoneremove  = (self.stoneremove or 3)-1
		end
	end
	local n = minetest.get_node(pos).name
	if remove_this or ((self.stoneremove or 3) <= 0) or (n ~= "air" and n ~= "ignore")then
--		db({"REM",tostring(remove)},"VeryImportantMessage")
		self.object:remove()
	end
	else
		self.object:remove()
	end
	return true
end
local function do_damage_firearrow(self,dtime)
	local pos = self.object:getpos()
	local remove_this = arrow_shall_be_removed(self,pos)
	local target = false
	local remove = 0
	for _,entity in ipairs(minetest.get_objects_inside_radius(pos,1)) do
		local luaent  = entity:get_luaentity()
		if ((not luaent) or (not luaent.arrow_resistant))  and ((not luaent) or (not luaent.lotharrow)) then
			arrow_punch(entity,self.shooter,self.damage)
		remove  = remove-1
		elseif ((not luaent) or (not luaent.lotharrow)) then
					remove  = remove-1
		end
	end
	local n = minetest.get_node(pos).name
		if (n ~= "air" and n ~= "ignore") or remove_this then
--		db({"REM",tostring(remove)},"VeryImportantMessage")

		self.object:remove()
		minetest.set_node(self.lastpos,{name = "fire:basic_flame"})
		else
		if remove < 0 then
		self.object:remove()
		minetest.set_node(pos,{name = "fire:basic_flame"})
		end
	end
	self.lastpos = pos
end
local function do_damage_teleportarrow(self,dtime)
	local pos = self.object:getpos()
	local remove_this = arrow_shall_be_removed(self,pos)
	local target = false
	local remove = 0
	for _,entity in ipairs(minetest.get_objects_inside_radius(pos,1)) do
		local luaent  = entity:get_luaentity()
		if ((not luaent) or (not luaent.arrow_resistant))  and ((not luaent) or (not luaent.lotharrow)) then
			arrow_punch(entity,self.shooter,self.damage)
		remove  = remove-1
		elseif ((not luaent) or (not luaent.lotharrow)) then
					remove  = remove-1
		end
	end
	if minetest.get_gametime()-self.gt > 6 then
		self.object:remove()
	end
	local n = minetest.get_node(pos).name
		if (n ~= "air" and n ~= "ignore") or remove_this then
--		db({"REM",tostring(remove)},"VeryImportantMessage")

		self.object:remove()
		if self.shooter and (not minetest.registered_nodes[minetest.get_node(self.lastpos).name].walkable) then
		self.shooter:setpos(self.lastpos)
		end
		else
		if remove < 0 then
		self.object:remove()
		if self.shooter and (not minetest.registered_nodes[minetest.get_node(pos).name].walkable) then
		self.shooter:setpos(pos)
		end
		end
	end
	self.lastpos = pos
end
local function do_damage_black_arrow(self,dtime)
	local pos = self.object:getpos()
	local remove_this = arrow_shall_be_removed(self,pos)
	local target = false
	local remove = 0
	for _,entity in ipairs(minetest.get_objects_inside_radius(pos,1)) do
		local luaent  = entity:get_luaentity()
		if ((not luaent) or (not luaent.arrow_resistant) or luaent.dragon) and ((not luaent) or (not luaent.lotharrow)) then
			arrow_punch(entity,self.shooter,self.damage*15)
		remove  = remove-1
		elseif ((not luaent) or (not luaent.lotharrow)) then
					remove  = remove-1
		end
	end
	local n = minetest.get_node(pos).name
	if remove_this or remove < 0 or (n ~= "air" and n ~= "ignore")then
--		db({"REM",tostring(remove)},"VeryImportantMessage")
		self.object:remove()
	end
end
local function do_dragon_damage(self,dtime)
	local pos = self.object:getpos()
	local target = false
	local remove = 1
	minetest.add_particlespawner({
	amount = 100,
	time = 1,
	minpos = pos,
	maxpos = pos,
	minvel = {x=-5, y=-5, z=-5},
	maxvel = {x=5, y=5, z=5},
	minacc = {x=0, y=0, z=0},
	maxacc = {x=0, y=0, z=0},
	minexptime = 0.5,
	maxexptime = 0.5,
	minsize =5,
	maxsize = 10,
	collisiondetection = false,
	vertical = false,
	texture = "dragon_fire.png",
	})
	for _,entity in ipairs(minetest.get_objects_inside_radius(pos,2)) do
		local luaent  = entity:get_luaentity()
			if (not(luaent and luaent.dragonproof)) and ((not luaent) or (not luaent.lotharrow)) then
		if entity:is_player() then
		remove  = remove-1
		local name = entity:get_player_name()
		playerpoison[name] = 999
		update_poison_data_file(name,999)
		playernutritions[name] = {0,0,0,0,0}
		update_health_data_file(name,{0,0,0,0,0})
		self.damage = self.damage or 160
		entity:set_hp(math.max(0,entity:get_hp()-math.ceil(self.damage/10)))
		else
		self.damage = self.damage or 160
		entity:set_hp(math.max(0,entity:get_hp()-self.damage))
		end
			arrow_punch(entity,self.shooter,self.damage)
		end
	end
	local n = minetest.get_node(pos).name
	self.no_speed_remove_timer = (self.no_speed_remove_timer or 12)+dtime
	if self.no_speed_remove_timer >= 12 then
		self.no_speed_remove_timer = 0
		if vector.length(self.object:getvelocity()) == 0 then
			self.no_speed_remove_timer = false
		end
	end
	self.duration = (self.duration-dtime) or 0
	if ((n ~= "air" and n ~= "ignore" and n ~= "fire:basic_flame") and (minetest.registered_nodes[n].walkable or default_is_swimmable(n))) or (not self.no_speed_remove_timer) or (self.duration <= 0) then
--		db({"REM",tostring(remove)},"VeryImportantMessage")
		self.object:remove()
	else
		for i = 1,12 do
		minetest.set_node(vector.add(pos,{x=math.random(2,-2),y=math.random(2,-2),z=math.random(2,-2)}),{name = "fire:basic_flame"})
		end
		--minetest.set_node(pos,{name = "fire:basic_flame"})
	end
end
	minetest.register_entity("lotharrows:arrow",{
		initial_properties = {
			--name = "arrow",
			hp_min = 1000000,
			hp_max = 1000000,
			visual_size = {x = 0.5, y = 0.5,z = 0.5},
			visual = "mesh",--"wielditem",
			mesh = "arrow.obj",
	--textures = {"lotharrows:boltmodel"},
			textures = {"default_wood.png"},
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
		end,
		-- ON PUNCH --
		-- ON STEP --
		on_step = do_damage,
	})
	minetest.register_entity("lotharrows:stone",{
		initial_properties = {
			--name = "arrow",
			hp_min = 1000000,
			hp_max = 1000000,
			visual_size = {x = 20, y = 20,z = 20},
			visual = "mesh",--"wielditem",
			mesh = "crystal.obj",
	--textures = {"lotharrows:boltmodel"},
			textures = {"default_stone.png"},
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
		-- ON PUNCH --
		-- ON STEP --
		on_activate = function(self)
			self.last_simulated_pos = self.object:getpos()
		end,
		on_step = function(a,b) 
			pcall(do_stone_damage(a,b))
			end,
	})
	minetest.register_entity("lotharrows:mageball",{
		initial_properties = {
			--name = "arrow",
			hp_min = 1000000,
			hp_max = 1000000,
			visual_size = {x = 3, y = 3,z = 3},
			visual = "mesh",--"wielditem",
			mesh = "crystal.obj",
	--textures = {"lotharrows:boltmodel"},
			textures = {"default_river_water.png"},
			collisionbox = {0, 0, 0,0, 0, 0},
			physical = false
		},
		-- ON ACTIVATE --
		on_activate = function(self,sd)
		self.object:set_armor_groups({immortal =1})
			local sd = minetest.parse_json(sd) or {remove = 10,damage = 10,owner = "singleplayer.txt"}
			self.owner = sd.owner or "def.txt"
			self.remove = sd.remove or 10
			self.magic_blueball = true
			self.warhorse = true
			self.damage = sd.damage or 10
			self.lastpos ={x=0,y=0,z=0}--self.object:getpos(),
			self.orc = true
			self.hudwel = true
			self.dunlending = true
			self.balrog = true
			self.arrow_resistant  = true
			self.lotharrow = true
			self.lotharrow = true
			self.shooter = nil--self.object,
		end,
		--end,
		-- ON PUNCH --
		-- ON STEP --
		get_staticdata = function(self)
		return minetest.write_json({remove =self.remove,damage = self.damage,owner = self.owner})end,
		on_step = function(self,dtime)
			local pos = self.object:getpos()
			if self.lotharrow and self.damage then
minetest.add_particlespawner({
	amount = 3,
	time = 3,
	minpos = pos,
	maxpos = pos,
	minvel = {x=-0.5, y=-0.5, z=-0.5},
	maxvel = {x=0.5, y=0.5, z=0.5},
	minacc = {x=0, y=0, z=0},
	maxacc = {x=0, y=0, z=0},
	minexptime = 1,
	maxexptime = 1,
	minsize = 1,
	maxsize = 1,
	collisiondetection = false,
	vertical = false,
	texture = "mage_particle.png",
})
			if minetest.get_node(pos).name == "air" then
			minetest.set_node(pos,{name="default:wizzard_air_light"})
			minetest.get_node_timer(pos):start(3)
			end
				
				local pos = self.object:getpos()
				local target = false
				local remove = 0
				local min_dist = 1000
				for _,entity in ipairs(minetest.get_objects_inside_radius(pos,100)) do
		local luaent = entity:get_luaentity()
--		db(hudwelshlaw)
		local name = entity:get_player_name()
		if (luaent and (not luaent.hudwel)) or (entity:is_player() and(
		(not hudwelshplayers[name])
		 or (hudwelshlaw[name]  and hudwelshlaw[name] > 0  )
		)) then
		local p = entity:getpos()
		local dist = vector.distance(pos,p)
				if default_do_not_punch_this_stuff(luaent) and (dist < min_dist)then
			min_dist = dist
			target = entity
		end
		end
	end
				if target then
					self.object:setvelocity(vector.multiply(vector.normalize(vector.subtract(target:getpos(),self.object:getpos())),10))
				else
					self.object:setvelocity({x=0,y=0,z=0})
				end
				for _,entity in ipairs(minetest.get_objects_inside_radius(pos,1)) do
					local entityname = entity:get_player_name()
					local luaent  = entity:get_luaentity()
					if ((not luaent)or (not (luaent.name == "sauron:sauron"))) and (not (luaent and luaent.hudwel)) then
					if not (entity:is_player() and
		hudwelshplayers[entityname] and (not(hudwelshlaw[entityname]  and hudwelshlaw[entityname] > 0  ))) then
					if default_do_not_punch_this_stuff(luaent) then
						--if not(entity:is_player() and  (entity:get_player_name() == self.shooter:get_player_name())) then
						--arrow_punch(entity,self.shooter,(100*self.damage)/(entity:get_armor_groups().fleshy or 100))
						if not (luaent and luaent.balrog) then
						entity:set_hp(entity:get_hp()-self.damage)
						else
						entity:set_hp(entity:get_hp()-math.floor(self.damage*0.4))
						end
						
						--end
					end
					end
						self.remove  = (self.remove or 10)-1
					elseif luaent.name == "sauron:sauron" then
						self.remove  = (self.remove or 10)-1
						arrow_punch(entity,minetest.get_player_by_name(self.owner) or self.object,1)
					end
				end
				--local n = minetest.get_node(pos).name
				--if remove < 0 then
--		db({"REM",tostring(remove)},"VeryImportantMessage")
				--	self.object:remove()
				--end
			end
			if self.remove <= 0 then
				self.object:remove()
			end
		end
	})
	minetest.register_entity("lotharrows:bad_mageball",{
		initial_properties = {
			--name = "arrow",
			hp_min = 1000000,
			hp_max = 1000000,
			visual_size = {x = 3, y = 3,z = 3},
			visual = "mesh",--"wielditem",
			mesh = "crystal.obj",
	--textures = {"lotharrows:boltmodel"},
			textures = {"default_lava.png"},
			collisionbox = {0, 0, 0,0, 0, 0},
			physical = false
		},
		-- ON ACTIVATE --
		on_activate = function(self,sd)
		self.object:set_armor_groups({immortal =1})
			local sd = minetest.parse_json(sd) or {remove = 10,damage = 10}
			self.remove = sd.remove or 10
			self.magic_blueball = true
			self.warhorse = true
			self.warg = true
			self.damage = sd.damage or 10
			self.lastpos ={x=0,y=0,z=0}--self.object:getpos(),
			self.orc = true
			self.hudwel = true
			self.dunlending = true
			self.balrog = true
			self.arrow_resistant  = true
			self.lotharrow = true
			self.lotharrow = true
			self.shooter = nil--self.object,
		end,
		--end,
		-- ON PUNCH --
		-- ON STEP --
		get_staticdata = function(self)
		return minetest.write_json({remove =self.remove,damage = self.damage})end,
		on_step = function(self,dtime)
			local pos = self.object:getpos()
			if self.lotharrow and self.damage then
minetest.add_particlespawner({
	amount = 2,
	time = 3,
	minpos = pos,
	maxpos = pos,
	minvel = {x=-0.5, y=-0.5, z=-0.5},
	maxvel = {x=0.5, y=0.5, z=0.5},
	minacc = {x=0, y=0, z=0},
	maxacc = {x=0, y=0, z=0},
	minexptime = 1,
	maxexptime = 1,
	minsize = 1,
	maxsize = 1,
	collisiondetection = false,
	vertical = false,
	texture = "lightbeetle4.png",
})
minetest.add_particlespawner({
	amount = 1,
	time = 3,
	minpos = pos,
	maxpos = pos,
	minvel = {x=-0.5, y=-0.5, z=-0.5},
	maxvel = {x=0.5, y=0.5, z=0.5},
	minacc = {x=0, y=0, z=0},
	maxacc = {x=0, y=0, z=0},
	minexptime = 1,
	maxexptime = 1,
	minsize = 1,
	maxsize = 1,
	collisiondetection = false,
	vertical = false,
	texture = "lightbeetle2.png",
})
			if minetest.get_node(pos).name == "air" then
			minetest.set_node(pos,{name="default:wizzard_air_light"})
			minetest.get_node_timer(pos):start(3)
			end
				local pos = self.object:getpos()
				local target = false
				local remove = 0
				local min_dist = 1000
				for _,entity in ipairs(minetest.get_objects_inside_radius(pos,100)) do
		local luaent = entity:get_luaentity()
--		db(hudwelshlaw)
		local name = entity:get_player_name()
		if (luaent and (not luaent.orc)) or (entity:is_player() and(
		(not orcishplayers[name])
		 or (orcishlaw[name]  and orcishlaw[name] > 0  )
		)) then
		local p = entity:getpos()
		local dist = vector.distance(pos,p)
				if default_do_not_punch_this_stuff(luaent) and (dist < min_dist)then
			min_dist = dist
			target = entity
		end
		end
	end
				if target then
					self.object:setvelocity(vector.multiply(vector.normalize(vector.subtract(target:getpos(),self.object:getpos())),10))
				else
					self.object:setvelocity({x=0,y=0,z=0})
				end
				for _,entity in ipairs(minetest.get_objects_inside_radius(pos,1.5)) do
					local entityname = entity:get_player_name()
					local luaent  = entity:get_luaentity()
					if ((not luaent)or (not ((luaent.name == "hudwel:valar") or (luaent.name == "hudwel:thorin") or (luaent.name == "hudwel:legolas")))) and (not (luaent and luaent.orc)) then
					if not (entity:is_player() and
		orcishplayers[entityname] and (not(orcishlaw[entityname]  and orcishlaw[entityname] > 0  ))) then
					if default_do_not_punch_this_stuff(luaent) then
						--if not(entity:is_player() and  (entity:get_player_name() == self.shooter:get_player_name())) then
						--arrow_punch(entity,self.shooter,(100*self.damage)/(entity:get_armor_groups().fleshy or 100))
						if entity:is_player() then
							local key =entity:get_player_name()
							healthbar_damn_values[key] = (healthbar_damn_values[key] or 0)+self.damage
							update_damn_data_file(key,healthbar_damn_values[key])
						else
							local enthpchange = entity:get_hp()-math.floor(self.damage*0.2)
							if enthpchange <= 0 then
								minetest.add_entity(entity:getpos(),"nazgul:ghost")
								entity:set_hp(0)
							else
								entity:set_hp(enthpchange)
							end
						end
						
						--end
					end
					end
						self.remove  = (self.remove or 10)-1
					elseif ((not luaent) or (not luaent.lotharrow)) then
						self.remove  = (self.remove or 10)-1
					end
				end
				--local n = minetest.get_node(pos).name
				--if remove < 0 then
--		db({"REM",tostring(remove)},"VeryImportantMessage")
				--	self.object:remove()
				--end
			end
			if self.remove <= 0 then
				self.object:remove()
			end
		end
	})
	minetest.register_entity("lotharrows:firearrow",{
		initial_properties = {
			--name = "arrow",
			hp_min = 1000000,
			hp_max = 1000000,
			visual_size = {x = 0.5, y = 0.5,z = 0.5},
			visual = "mesh",--"wielditem",
			mesh = "arrow.obj",
	--textures = {"lotharrows:boltmodel"},
			textures = {"fire_arrcolor.png"},
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
		-- ON PUNCH --
		-- ON STEP --
		on_activate = function(self)
			self.lastpos = self.object:getpos()
			self.last_simulated_pos = self.object:getpos()
		end,
		on_step = do_damage_firearrow
	})
	minetest.register_entity("lotharrows:teleportarrow",{
		initial_properties = {
			--name = "arrow",
			hp_min = 1000000,
			hp_max = 1000000,
			visual_size = {x = 0.5, y = 0.5,z = 0.5},
			visual = "mesh",--"wielditem",
			mesh = "arrow.obj",
	--textures = {"lotharrows:boltmodel"},
			textures = {"teleport_arrcolor.png"},
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
		-- ON PUNCH --
		-- ON STEP --
		on_activate = function(self,sd)
			self.gt = tonumber(sd or "") or minetest.get_gametime()
			self.lastpos = self.object:getpos()
			self.last_simulated_pos = self.object:getpos()
		end,
		get_staticdata = function(self)
			return tostring(self.gt)
		end,
		on_step = do_damage_teleportarrow
	})
	minetest.register_entity("lotharrows:blackarrow",{
		initial_properties = {
			--name = "arrow",
			hp_min = 1000000,
			hp_max = 1000000,
			visual_size = {x = 0.5, y = 1,z = 0.5},
			visual = "mesh",--"wielditem",
			mesh = "arrow.obj",
	--textures = {"lotharrows:boltmodel"},
			textures = {"blackcolor.png"},
			collisionbox = {0, 0, 0,0, 0, 0},
			physical = false
		},
		-- ON ACTIVATE --
		--on_activate = function(self)
			--[[self.]]lastpos ={x=0,y=0,z=0},--self.object:getpos(),
			--[[self.]]orc = true,
			--[[self.]]hudwel = true,
			--[[self.]]dunlending = true,
			--[[self.]]arrow_resistant  = true,
				balrog = true,
				lotharrow = true,
			--[[self.]]shooter = nil,--self.object,
		--end,
		-- ON PUNCH --
		-- ON STEP --
		on_activate = function(self)
			self.last_simulated_pos = self.object:getpos()
		end,
		on_step = do_damage_black_arrow
	})
	minetest.register_entity("lotharrows:dragonfire",{
		initial_properties = {
			--name = "arrow",
			hp_min = 1000000,
			hp_max = 1000000,
			visual_size = {x = 0.5, y = 0.5,z = 0.5},
			visual = "mesh",--"wielditem",
			mesh = "arrow.obj",
	--textures = {"lotharrows:boltmodel"},
			textures = {"steelcolor.png"},
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
				lotharrow = true,
			--[[self.]]dragonproof  = true,
			--[[self.]]shooter = nil,--self.object,
		on_activate = function(self,static)
			if static then
				self.duration = tonumber(static) or 1
			else
				self.duration = 1
			end
		end,
		
		--end,
		-- ON PUNCH --
		-- ON STEP --
		get_staticdata = function(self)
		return tostring(self.duration)
		end,
		on_step = do_dragon_damage
	})
	minetest.register_entity("lotharrows:puncherhack",{
		initial_properties = {
			--name = "arrow",
			hp_min = 1000000,
			hp_max = 1000000,
			visual_size = {x = 1, y = 1,z = 1},
			visual = "cube",--"wielditem",
	--textures = {"lotharrows:boltmodel"},
			textures = {"doors_blank.png"},
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
			--[[self.]]--self.object,
				time = 1,
		--end,
		-- ON PUNCH --
		-- ON STEP --
		on_step = function(self,dtime)
			if self.time then
			self.time = self.time-dtime
			if self.time <= 0 then
			self.object:remove()
			end
			else
			self.object:remove()
			end
			end
	})
minetest.register_craftitem("lotharrows:arrow_standard",{
	description = "arrow",
	inventory_image = "arrow.png"
})
minetest.register_craftitem("lotharrows:arrow_black",{
	description = "blackarrow",
	inventory_image = "blackarrow.png"
})
minetest.register_craftitem("lotharrows:arrow_fire",{
	description = "firearrow",
	inventory_image = "firearrow.png"
})
minetest.register_craftitem("lotharrows:arrow_teleport",{
	description = "teleportarrow",
	inventory_image = "teleportarrow.png"
})
function register_woodbow(woodname,uses,speed,damage,crafting_mat)
local wear = math.floor(65535/uses)
local arrstack = ItemStack("lotharrows:arrow_standard")
local blackarrstack = ItemStack("lotharrows:arrow_black")
local farrstack = ItemStack("lotharrows:arrow_fire")
local tarrstack = ItemStack("lotharrows:arrow_teleport")
minetest.register_tool("lotharrows:bow_" .. woodname, {
	description = woodname .. "bow",
	inventory_image = "bow_blackwhite.png^" .. woodname ..
			"_tree_overlay.png^bow_alphamask.png^bow_blackwhite_string.png^[makealpha:255,0,255",
	wield_scale = {x=2,y=2,z=0.25},
	range = 0,
	on_use = function(itemstack, user, pointed_thing)
			if(not user:get_inventory():remove_item("main", tarrstack):is_empty()) then
			itemstack:add_wear(wear)
			local ld =user:get_look_dir()
			local pos = vector.add(user:getpos(),vector.multiply(ld,2))
			pos.y = pos.y + 1
			local arrow = minetest.add_entity(pos,"lotharrows:teleportarrow")
			local arrowent = arrow:get_luaentity()
			arrowent.shooter = user
			arrowent.damage = damage
			arrow:setyaw(user:get_look_yaw()+math.pi/2)
			arrow:setvelocity(vector.multiply(ld,speed))
			arrow:setacceleration({x=0,y=-3,z=0})
			return itemstack
			elseif (not user:get_inventory():remove_item("main", blackarrstack):is_empty()) then
			itemstack:add_wear(wear)
			local ld =user:get_look_dir()
			local pos = vector.add(user:getpos(),vector.multiply(ld,2))
			pos.y = pos.y + 1
			local arrow = minetest.add_entity(pos,"lotharrows:blackarrow")
			local arrowent = arrow:get_luaentity()
			arrowent.shooter = user
			arrowent.damage = damage
			arrow:setyaw(user:get_look_yaw()+math.pi/2)
			arrow:setvelocity(vector.multiply(ld,speed))
			arrow:setacceleration({x=0,y=-3,z=0})
			return itemstack
			elseif(not user:get_inventory():remove_item("main", farrstack):is_empty()) then
			itemstack:add_wear(wear)
			local ld =user:get_look_dir()
			local pos = vector.add(user:getpos(),vector.multiply(ld,2))
			pos.y = pos.y + 1
			local arrow = minetest.add_entity(pos,"lotharrows:firearrow")
			local arrowent = arrow:get_luaentity()
			arrowent.shooter = user
			arrowent.damage = damage
			arrow:setyaw(user:get_look_yaw()+math.pi/2)
			arrow:setvelocity(vector.multiply(ld,speed))
			arrow:setacceleration({x=0,y=-3,z=0})
			return itemstack
			elseif(not user:get_inventory():remove_item("main", arrstack):is_empty()) then
			itemstack:add_wear(wear)
			local ld =user:get_look_dir()
			local pos = vector.add(user:getpos(),vector.multiply(ld,2))
			pos.y = pos.y + 1
			local arrow = minetest.add_entity(pos,"lotharrows:arrow")
			local arrowent = arrow:get_luaentity()
			arrowent.shooter = user
			arrowent.damage = damage
			arrow:setyaw(user:get_look_yaw()+math.pi/2)
			arrow:setvelocity(vector.multiply(ld,speed))
			arrow:setacceleration({x=0,y=-3,z=0})
			return itemstack
			end
	end
})
local crafting_mat = crafting_mat or "default:"..woodname.."wood"
	minetest.register_craft({
	output = "lotharrows:bow_" .. woodname,
	recipe = {
		{"farming:string", crafting_mat, ''},
		{"farming:string", '', crafting_mat},
		{"farming:string", crafting_mat, ''},
	}
})
end
minetest.register_craft({
	output = "lotharrows:arrow_standard 99",
	recipe = {
		{"default:stick", "default:steel_ingot"}
	}
})
minetest.register_craft({
	output = "lotharrows:arrow_black 99",
	recipe = {
		{"default:stick", "default:galvorn_ingot"}
	}
})
minetest.register_craft({
	output = "lotharrows:arrow_fire 99",
	recipe = {
		{"default:stick", "default:torch"}
	}
})
minetest.register_craft({
	output = "lotharrows:arrow_teleport 99",
	recipe = {
		{"default:stick", "default:diamondblock"}
	}
})
function register_crossbow(woodname,uses,speed,damage,crafting_mat)
local wear = math.floor(65535/uses)
local arrstack = ItemStack("lotharrows:arrow_standard")
local blackarrstack = ItemStack("lotharrows:arrow_black")
local farrstack = ItemStack("lotharrows:arrow_fire")
local tarrstack = ItemStack("lotharrows:arrow_teleport")
minetest.register_tool("lotharrows:crossbow_" .. woodname, {
	description = woodname .. "crossbow",
	inventory_image = "crossbow_blackwhite.png^default_" .. woodname ..
			"_metal_overlay.png^crossbow_alphamask.png^bow_blackwhite_string.png^[makealpha:255,0,255",
	wield_scale = {x=2,y=2,z=0.25},
	range = 0,
	on_use = function(itemstack, user, pointed_thing)
			if(not user:get_inventory():remove_item("main", tarrstack):is_empty()) then
			itemstack:add_wear(wear)
			local ld =user:get_look_dir()
			local pos = vector.add(user:getpos(),vector.multiply(ld,2))
			pos.y = pos.y + 1
			local arrow = minetest.add_entity(pos,"lotharrows:teleportarrow")
			local arrowent = arrow:get_luaentity()
			arrowent.shooter = user
			arrowent.damage = damage
			arrow:setyaw(user:get_look_yaw()+math.pi/2)
			arrow:setvelocity(vector.multiply(ld,speed))
			arrow:setacceleration({x=0,y=-1,z=0})
			return itemstack
			elseif (not user:get_inventory():remove_item("main", blackarrstack):is_empty()) then
			itemstack:add_wear(wear)
			local ld =user:get_look_dir()
			local pos = vector.add(user:getpos(),vector.multiply(ld,2))
			pos.y = pos.y + 1
			local arrow = minetest.add_entity(pos,"lotharrows:blackarrow")
			local arrowent = arrow:get_luaentity()
			arrowent.shooter = user
			arrowent.damage = damage
			arrow:setyaw(user:get_look_yaw()+math.pi/2)
			arrow:setvelocity(vector.multiply(ld,speed))
			arrow:setacceleration({x=0,y=-1,z=0})
			return itemstack
			elseif(not user:get_inventory():remove_item("main", farrstack):is_empty()) then
			itemstack:add_wear(wear)
			local ld =user:get_look_dir()
			local pos = vector.add(user:getpos(),vector.multiply(ld,2))
			pos.y = pos.y + 1
			local arrow = minetest.add_entity(pos,"lotharrows:firearrow")
			local arrowent = arrow:get_luaentity()
			arrowent.shooter = user
			arrowent.damage = damage
			arrow:setyaw(user:get_look_yaw()+math.pi/2)
			arrow:setvelocity(vector.multiply(ld,speed))
			arrow:setacceleration({x=0,y=-1,z=0})
			return itemstack
			elseif(not user:get_inventory():remove_item("main", arrstack):is_empty()) then
			itemstack:add_wear(wear)
			local ld =user:get_look_dir()
			local pos = vector.add(user:getpos(),vector.multiply(ld,2))
			pos.y = pos.y + 1
			local arrow = minetest.add_entity(pos,"lotharrows:arrow")
			local arrowent = arrow:get_luaentity()
			arrowent.shooter = user
			arrowent.damage = damage
			arrow:setyaw(user:get_look_yaw()+math.pi/2)
			arrow:setvelocity(vector.multiply(ld,speed))
			arrow:setacceleration({x=0,y=-1,z=0})
			return itemstack
			end
	end
})
local crafting_mat = crafting_mat or "default:"..woodname.."_ingot"
	minetest.register_craft({
	output = "lotharrows:crossbow_" .. woodname,
	recipe = {
		{"farming:string", crafting_mat, ''},
		{"farming:string", '', crafting_mat},
		{"farming:string", crafting_mat, ''},
	}
})
end
--[[register_woodbow("mallorn",1000,10,7)
register_woodbow("mirk",200,18,6)
register_woodbow("jungletree",300,20,6)
register_woodbow("whitetree",800,10,10)
register_woodbow("lebethron",700,15,9)
register_woodbow("culumalda",400,12,8)
register_woodbow("normal_wood",100,8,4)
register_crossbow("steel",2000,22,7)
register_crossbow("bronze",4000,23,7)
register_crossbow("galvorn",8000,25,7)
register_crossbow("mithril",16000,26,7)]]
--[[register_woodbow("mallorn",1000,10,7)
register_woodbow("mirk",200,18,6)
register_woodbow("jungletree",300,20,6)
register_woodbow("whitetree",800,10,10)
register_woodbow("lebethron",700,15,9)
register_woodbow("culumalda",400,12,8)
register_woodbow("normal_wood",100,8,4)
register_crossbow("steel",2000,22,11)
register_crossbow("bronze",4000,23,12)
register_crossbow("galvorn",8000,25,14)
register_crossbow("mithril",16000,26,15)]]
register_woodbow("mallorn",1000,10,3)
register_woodbow("mirk",200,18,2)
register_woodbow("jungletree",300,20,2)
register_woodbow("whitetree",800,10,6)
register_woodbow("lebethron",700,15,5)
register_woodbow("culumalda",400,12,4)
register_woodbow("normal_wood",100,8,1,"default:wood")
register_crossbow("steel",2000,22,7)
register_crossbow("bronze",4000,23,8)
register_crossbow("galvorn",8000,25,9)
register_crossbow("mithril",16000,26,10)
--[[register_guard({
	damage = 2,
	name = "standardorc",
	drops = {"orc"},
	mesh = "character.b3d",
	textures = {"orccharacter2.png"},
	max_hp = 20,
	size = 0.9,
	speed = 3
},{"default:fangorndirt","default:brownlandsdirt","default:mordordust","default:angmarsnow"},1000)]]
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


