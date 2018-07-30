-- Minetest mod: creepers
-- (c) Kai Gerd Müller
-- See README.txt for licensing and other information.
local g_force=10
--[[
p1
p2
archer
damage[]
penetration[]
maxvel
]]
function self_first_spawn(sdata)
	if not sdata then
		return false
	end
	if sdata == "~" then
		return "",false
	elseif sdata == "" then
		return sdata,true
	else
		return sdata,false
	end
end
function add_first_spawn_flag(sdata)
	if sdata == "" then
		return "~"
	else
		return sdata
	end
end
function set_armor_groups_on_first_spawn(self,ag,flag)
	if flag then
		self.object:set_armor_groups(ag)
	end
end
local function get_nearest_enemy_orc(self,pos,radius,fucking_punchtest)
	local min_dist = radius+1
	local target = false
	for _,entity in ipairs(minetest.get_objects_inside_radius(pos,25)) do
		local luaent = entity:get_luaentity()
		local name = entity:get_player_name()
		if (luaent and (not luaent.orc)) or (entity:is_player() and(
		(not orcishplayers[name])
		 or (orcishlaw[name]  and orcishlaw[name] > 0  )
		)) then
		local p = entity:getpos()
		local dist = vector.distance(pos,p)
				if default_do_not_punch_this_stuff(luaent) and (minetest.line_of_sight(vector.add(pos,{x=0,y=10,z=0}),vector.add(p,{x=0,y=10,z=0}), 2,entity) == true or minetest.line_of_sight(pos,p, 2,entity) --[[or minetest.line_of_sight(vector.add(pos,{x=0,y=1,z=0}),vector.add(p,{x=0,y=1,z=0}), 2) == true]]) and dist < min_dist then
			min_dist = dist
				target = entity
		end
		end
	end
if target and ((not fucking_punchtest) or minetest.line_of_sight(target:getpos(),pos,2)) then
return target
else
return target
end
end
local function get_nearest_enemy_hudwel(self,pos,radius)
	local min_dist = radius+1
	local target = false
	for _,entity in ipairs(minetest.get_objects_inside_radius(pos,25)) do
		local luaent = entity:get_luaentity()
--		db(hudwelshlaw)
		local name = entity:get_player_name()
		if (luaent and (not luaent.hudwel)) or (entity:is_player() and(
		(not hudwelshplayers[name])
		 or (hudwelshlaw[name]  and hudwelshlaw[name] > 0  )
		)) then
		local p = entity:getpos()
		local dist = vector.distance(pos,p)
			if default_do_not_punch_this_stuff(luaent) and (minetest.line_of_sight(vector.add(pos,{x=0,y=5,z=0}),vector.add(p,{x=0,y=5,z=0}), 2,entity) == true or minetest.line_of_sight(pos,p, 2,entity) == true --[[or minetest.line_of_sight(vector.add(pos,{x=0,y=1,z=0}),vector.add(p,{x=0,y=1,z=0}), 2) == true]]) and dist < min_dist then
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
local function calculate_archingvec(vec,speed)
local lenght = math.sqrt((vec.x*vec.x)+(vec.z*vec.z))
local v = math.sqrt((lenght+(vec.y*g_force/lenght))*g_force)
if v <= speed then
vec.y=lenght
return vector.multiply(vector.normalize(vec),v)
else
return false
end
end
local function calculate_archingvec_gradients(v0,s,h,g)
	local g = g or g_force
	local sqrt = math.sqrt(-(g*g*s*s*s*s) +(2*g*h*s*s*v0*v0) +(s*s*v0*v0*v0*v0))
	return {((s*v0*v0) + sqrt) / (g*s*s),((s*v0*v0) - sqrt) / (g*s*s)}
end
local function calculate_archingvec_gradient1(v0,s,h,g)
	local g = g or g_force
	local sqrt = math.sqrt(-(g*g*s*s*s*s) +(2*g*h*s*s*v0*v0) +(s*s*v0*v0*v0*v0))
	return ((s*v0*v0) + sqrt) / (g*s*s)
end
local function calculate_archingvec_gradient2(v0,s,h,g)
	local g = g or g_force
	local sqrt = math.sqrt(-(g*g*s*s*s*s) +(2*g*h*s*s*v0*v0) +(s*s*v0*v0*v0*v0))
	return ((s*v0*v0) - sqrt) / (g*s*s)
end
--[[local function standardarch_errorcont(def)
	local target = vector.subtract(def.p2,def.p1)
	local s = math.sqrt((target.x*target.x)+(target.z*target.z))
	local b,val = pcall(function()return calculate_archingvec_gradients(def.maxvel,s,target.y,g_force)end)
	if b then
	local targetv = {x = 0,y = 0,z = 0}
	if def.targetv then
	targetv = {x=def.targetv.x,y=def.targetv.y,z=def.targetv.z}
	else
	targetv = {x = 0,y = 0,z = 0}
	end
	local target2 = {x = target.x,y = target.y,z = target.z}
	local b2 = b
	local index = 1
	if not ((targetv.x == 0) and (targetv.y == 0) and (targetv.z == 0))then
	if val then
	while (b or b2)and (index <= 5) do
		index = index+1
		target = vector.add(target,vector.multiply(targetv,s/(def.maxvel*val[1])))
		local s = math.sqrt((target.x*target.x)+(target.z*target.z))
		b,val[1] = pcall(function()return calculate_archingvec_gradient1(def.maxvel,s,target.y,g_force)end)
		target2 = vector.add(target2,vector.multiply(targetv,s/(def.maxvel*val[2])))
		local s = math.sqrt((target2.x*target2.x)+(target2.z*target2.z))
		b2,val[2] = pcall(function()return calculate_archingvec_gradient2(def.maxvel,s,target2.y,g_force)end)
	end
	end
	end
	if b2 then
		b = true
		val = val[2]
		target = target2
	elseif b then
		b = true
		val = val[1]
	end
	if b then
	local floor_vec = {x = target.x,y = 0,z = target.z}
	floor_vec.y = vector.length(floor_vec)*val
	floor_vec = vector.multiply(vector.normalize(floor_vec),def.maxvel)
	--db(avec)
	def.floor_vec = floor_vec
	minetest.log("action","BREAKPOINT1")
	local arrow = minetest.add_entity(def.p1,"lotharrows:arrow")
	local luaent = arrow:get_luaentity()
	luaent.shooter = def.archer
	luaent.damage = def.damage or 10
	minetest.log("action","BREAKPOINT2")
	arrow:setvelocity(floor_vec)
	arrow:setacceleration({x=0,y=-10,z=0})
	arrow:setyaw(math.atan2(floor_vec.z,floor_vec.x)+math.pi/2)
	return math.atan2(floor_vec.z,floor_vec.x)
	end
	return def.floor_vec
	end
	minetest.log("action","BREAKPOINT3")
end]]
math.huge = 1/0
math.finite = function(a)
return (not(a ~= a)) and (a ~= math.huge) and (a ~= -math.huge)
end
local function standardarch_easy(def,arrow)
--	def.maxvel = 100
	local target = vector.subtract(def.p2,def.p1)
	local s = math.sqrt((target.x*target.x)+(target.z*target.z))
	local b,val = pcall(function()return calculate_archingvec_gradients(def.maxvel,s,target.y,g_force)end)
	if s < target.y then
		val[2] = val[1]
	end
	local ww = (g_force*s*s)/(2*def.maxvel*def.maxvel)
	if target.y > ww then
		val[2] = math.abs(val[2])
	end
	if target.y < ww then
		val[2] = -math.abs(val[2])
	end
	if b then
	local floor_vec = {x = target.x,y = 0,z = target.z}
	floor_vec.y = vector.length(floor_vec)*val[2]
	floor_vec = vector.multiply(vector.normalize(floor_vec),def.maxvel)
	--update_health_data_file("singleplayer",{floor_vec.x,floor_vec.y,floor_vec.z,0,0})
	--db(avec)
	--def.floor_vec = floor_vec
	if math.finite(floor_vec.x) and math.finite(floor_vec.y) and math.finite(floor_vec.z) then
	--minetest.log("action","BREAKPOINT1")
	local arrow = minetest.add_entity(def.p1,arrow or "lotharrows:arrow")
	local luaent = arrow:get_luaentity()
	luaent.shooter = def.archer
	luaent.damage = def.damage or 10
	--minetest.log("action","BREAKPOINT2")
	arrow:setvelocity(floor_vec)
	arrow:setacceleration({x=0,y=-10,z=0})
	arrow:setyaw(math.atan2(floor_vec.z,floor_vec.x)+math.pi/2)
	return math.atan2(floor_vec.z,floor_vec.x)
	else
	error("NOOO")
	return false
	end
	--return floor_vec
	else
	return false
	end
	--minetest.log("action","BREAKPOINT3")
end
local function standardarchingvec2d(def)
	local target = vector.subtract(def.p2,def.p1)
	local s = math.sqrt((target.x*target.x)+(target.z*target.z))
	local b,val = pcall(function()return calculate_archingvec_gradients(def.maxvel,s,target.y,g_force)end)
	if s < target.y then
		val[2] = val[1]
	end
	local ww = (g_force*s*s)/(2*def.maxvel*def.maxvel)
	if target.y > ww then
		val[2] = math.abs(val[2])
	end
	if target.y < ww then
		val[2] = -math.abs(val[2])
	end
	if b then
	local floor_vec = {x = s,y = 0,z = 0}
	floor_vec.y = vector.length(floor_vec)*val[2]
	floor_vec = vector.multiply(vector.normalize(floor_vec),def.maxvel)
	return floor_vec
	end
	--update_health_data_file("singleplayer",{floor_vec.x,floor_vec.y,floor_vec.z,0,0})
	--db(avec)
	--def.floor_vec = floor_vec
	
	--minetest.log("action","BREAKPOINT1")
	--minetest.log("action","BREAKPOINT3")
end
local function without_pcall_standardarch(def,arrow,offset_arching)
	local arrow = arrow or "lotharrows:arrow"
	local targetv = def.targetv or {x=0,y=0,z=0}
	local b  = true
	def.p1=  vector.add(def.p1,vector.multiply(vector.normalize(vector.subtract(def.p2,def.p1)),1.1*(offset_arching or 1)))
	local old_p2 = {x = def.p2.x,y = def.p2.y,z = def.p2.z}
	for i = 1,5 do
		local tv = vector.subtract(def.p1,def.p2)
		local dist = vector.length({x = tv.x,y = 0,z = tv.z})
		local t = standardarchingvec2d(def)
		if t then
			t = dist/(t.x)
		else
			b = false
			break
		end
		def.p2 = vector.add(old_p2,vector.multiply(targetv,t))
	end
	if b then
		return standardarch_easy(def,arrow)
	end
	return false
	--minetest.log("action","BREAKPOINT3")
end
local function standardarch(def,arrow,offset_arching)
	local _,val = pcall(without_pcall_standardarch,def,arrow,offset_arching)
	--error(type(val))
	return val or false
	--minetest.log("action","BREAKPOINT3")
end
--[[local function throwing_h_s_o_to_spf(h,s,o)
	local h = o-h
	local sx = s/(1+math.sqrt(h/o))
	local a = o/(sx*sx)
	return {x=sx,y=0,a=a}
end
local function spf_to_abcf(spf)
	return {a=spf.a,b=-2*spf.a*spf.x,c=spf.y+(spf.x*spf.x*spf.a)}
end
local function bigger_equal_or_smaller_than_abcf_of_x(p,abcf)
	local abcfv = calculate_abcf(abcf,x)
	if abcfv>p.y then
		return 2
	elseif abcfv==p.y then
		return 1
	else
		return 0
	end
end
local function throwing_calculate_hull_abcf(v)
	return {a=(-g_force)/(2*v*v),b=0,c=(v*v)/(2*g_force)}
end
local function calculate_abcf(abcf,x)
	return (x*x*abcf.a)+(x*abcf.b)+abcf.c
end
local function abcf_subtract(abcf_a,abcf_b)
	return{a=abcf_a.a-abcf_b.a,b=abcf_a.b-abcf_b.b,c=abcf_a.c-abcf_b.c}
end
local function abcf_add(abcf_a,abcf_b)
	return{a=abcf_a.a+abcf_b.a,b=abcf_a.b+abcf_b.b,c=abcf_a.c+abcf_b.c}
end
local function point_abcf_subtract(p,abcf)
	return {x=p.x,y=p.y-calculate_abcf(abcf,p.x)}
end
local function throwing_calculate_reduced_abcf_upper(hull,t)
	local o = -hull.c
	local h = point_abcf_subtract(t,hull)
	return spf_to_abcf(s_fire_h_s_o_to_spf(h,t.x,o))
end
local function throwing_reduced_upper_abcf_to_reduced_lower_abcf(abcf,t)
	local sx = (abcf.b-s/2)
	return {a = -o/(sx*sx),b = 2*o/sx,c = o}
end
local function throwing_abcf(v,t)
	local hull = throwing_calculate_hull_abcf(v)
	local reach = bigger_equal_or_smaller_than_abcf_of_x(t,hull)
	if reach == 0 then
		return {}
	end
	local upper = throwing_calculate_reduced_throwing_abcf_upper(hull,t)
	if reach == 1 then
		return {abcf_add(upper,hull)}
	end
	local lower = throwing_reduced_upper_abcf_to_reduced_lower_abcf(abcf,t)
	return {abcf_add(lower,hull),abcf_add(upper,hull)}
end]]
local function standardarch_old(def)
	local avec = calculate_archingvec(vector.subtract(def.p2,def.p1),def.maxvel)
	if avec then
	db(avec)
	local arrow = minetest.add_entity(def.p1,"lotharrows:arrow")
	local luaent = arrow:get_luaentity()
	luaent.shooter = def.archer
	luaent.damage = def.damage or 10
	arrow:setvelocity(avec)
	arrow:setacceleration({x=0,y=-10,z=0})
	arrow:setyaw(math.atan2(avec.z,avec.x)+math.pi/2)
	return math.atan2(avec.z,avec.x)
	end
	return avec
end
hudwel_elven_boss_arch = standardarch
local function jump_needet(size,pos)
pos.y = (pos.y-size)+0.5
local r = false
for x = -1,1 do
for z = -1,1 do
if minetest.registered_nodes[minetest.get_node({x = pos.x+x,y=pos.y,z=pos.z+z}).name].walkable then
r = true
end
end
end
return r
end
local function animate(self, t)
	if t == 1 and self.canimation ~= 1 then
		self.object:set_animation({
			x = 0,
			y = 80},
			30, 0)
		self.canimation = 1
	elseif t == 2 and self.canimation ~= 2 then
		self.object:set_animation({x = 200,y = 220},30, 0)
		self.canimation = 2
	--walkmine
	elseif t == 3 and self.canimation ~= 3 then
		self.object:set_animation({x = 168,y = 188},30, 0)
		self.canimation = 3
	--walk
	elseif t == 4 and self.canimation ~= 4 then
		self.object:set_animation({x = 189,y = 199},30, 0)
		self.canimation = 4
	--walk
	end
end
local function get_nearest_enemy(self,pos,radius)
	local min_dist = radius+1
	local target = false
	for _,entity in ipairs(minetest.get_objects_inside_radius(pos,radius)) do
		luaent = entity:get_luaentity()
		if (entity:is_player() and entity:get_player_name() ~= self.owner_name)  or (luaent and (luaent.guard and not luaent.owner_name == self.owner_name) and not luaent.arrow) or ((not luaent) and not entity:is_player()) or (luaent and (not luaent.guard) and (not luaent.arrow)) then
		local p = entity:getpos()
		local dist = vector.distance(pos,p)
		if dist < min_dist then
			min_dist = dist
			min_player = player
			target = entity
		end
		end
	end
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
end
local calctarget  = function(table)
	if math.random(1,table.chanche) == 1 or not (table.target.x and table.target.y and table.target.z) then
		table.target = vector.multiply(vector.normalize({x= math.random(1,2)-1.5,y = 0,z= math.random(1,2)-1.5}),table.speed)
	end
	return table
end
local function register_archer(def)
	local defbox = def.size/2
--	def.speed = 0.01
	minetest.register_entity("archers:" .. def.name,{
		initial_properties = {
			name = def.name,
			hp_min = def.max_hp,
			hp_max = def.max_hp,
			visual_size = {x = def.size, y = def.size, z = def.size},
			visual = "mesh",
			mesh = "character20.b3d",
			textures = {"doors_blank.png","doors_blank.png"},
			collisionbox = {-defbox, -def.size, -defbox, defbox, def.size, defbox},
			physical = true
		},
		-- ON ACTIVATE --
		on_punch = lawbreak_on_punch,
		get_staticdata = function(self)
			return tostring(self.texture_index or math.random(0,def.max_texture_index or 0))
		end,
		on_activate = function(self,sdata)
			self.it_is_a_riding_creature = true
			self.walkaround = {target = {},speed = def.speed,chanche = 100,calc = calctarget}
			if sdata == "" then
			self.object:set_armor_groups({fleshy = def.armor or 100,level = 1})
			self.texture_index = tonumber(sdata) or math.random(0,def.max_texture_index or 0)
			else
			self.texture_index = math.random(0,def.max_texture_index or 0)
			end
			self.object:set_properties({textures = {"mobbow.png",def.force_textures or "lottmobs_"..def.texture.."_"..self.texture_index..".png"}})
			self.timer = 0
			self.lavadamagetimer = 0
			self.orc = def.orc
			self.hudwel = def.hudwel
			self.yaw=false
			self.jump = 0
			self.lawname = def.law
			self.guard = true
			self.object:setacceleration({x=0,y=-50,z=0})
		self.object:set_animation({
			x = 0,
			y = 80},
			30, 0)
			self.canimation = 1
		end,
		
		-- ON PUNCH --
		-- ON STEP --
		on_step = function(self, dtime)
			
			local pos = self.object:getpos()
			self.animation_set = true
			self.gravity = {x=0,y=-50,z=0}
			self.targetvektor = nil
			if (self.timer or 0) < 1 then
			self.timer = (self.timer or 0)+dtime
			end
			if self.lavadamagetimer < 1 then
			self.lavadamagetimer = self.lavadamagetimer + dtime
			elseif minetest.get_node(vector.subtract(pos,{x=0,y=0.5,z=0})).name == "default:lava_source" or minetest.get_node(vector.subtract(pos,{x=0,y=0.5,z=0})).name == "default:lava_flowing" then
			self.object:remove()
			else
			self.lavadamagetimer = 0
			end
			if self.timer >=1 then
			self.forcepunch = false
			self.yaw=false
			local target = def.get_nearest_enemy(self,pos,100)
			if target then
			local sarch=standardarch({
p1 = {x=pos.x,y = pos.y,z = pos.z},
p2 = target:getpos(),
targetv = target:getvelocity(),
archer = self.object,
damage = def.damage,
--penetration = def.penetration,
maxvel = def.maxvel})
			if sarch and (type(sarch) == "number") then
			self.yaw=sarch
			self.forcepunch = true
			end
			self.timer = 0
			end
			end

			if not self.targetvektor then
					self.walkaround = self.walkaround.calc(self.walkaround)
					self.targetvektor = self.walkaround.target
					self.nextanimation = 3
					self.animation_set = false
			end
			local velocity = self.object:getvelocity()
			self.jump = (self.jump +1)%10
			if self.targetvektor then
			if self.forcepunch then
				self.nextanimation = 2
			end
			if default_is_swimmable(minetest.get_node(pos).name) then
				self.gravity = {x=0,y=0,z=0}
			end
			pos.y = pos.y+0.5
			if default_is_swimmable(minetest.get_node(pos).name) then
				self.targetvektor.y = 1
			end
			pos.y = pos.y-0.5
			if self.jump == 0 and --[[vector.distance(vector.new(),velocity)<def.speed/10 and velocity.y == 0 and minetest.registered_nodes[minetest.get_node(vector.add(pos,{x=0,y=-(def.size+0.5),z=0})).name].walkable]]jump_needet(def.size,pos) then
					stomp(self,1)		
			end
			self.object:setacceleration(self.gravity)
			self.targetvektor.y = velocity.y
			self.object:setvelocity(self.targetvektor)
			else
				self.object:setvelocity({x=0,y=velocity.y,z=0})	
				if not self.forcepunch then	
				self.nextanimation = 1
				else
				self.nextanimation = 4
				end
			end
			animate(self,self.nextanimation)
			if( not self.yaw )then
			if( self.targetvektor )then
			self.object:setyaw(math.atan2(self.targetvektor.z,self.targetvektor.x)-math.pi/2)
			else
			self.object:setyaw(0)
			end
			else
			self.object:setyaw(self.yaw-math.pi/2)
			end
			if self.object:get_hp() > 0 then return end
			self.object:remove()
		end
	})
regular_humanoid_spawn_registry("archers:" .. def.name,def.spawn,def.chanche)
end

register_archer({
	damage = 3,
	--penetration = 3,
	maxvel = 300,
	get_nearest_enemy = get_nearest_enemy_orc,
	name = "uruguay",
	orc = true,
	texture = "uruk_hai_armored",
	max_texture_index = 2,
	max_hp = 30,
	armor = 30,
	spawn = {"default:mordordust_mapgen","default:mordordust","default:angmarsnow"},
	chanche = 5000,
	size = 1,
	speed = 3,
	law = "orcishlaw"
})
register_archer({
	damage = 5,
	--penetration = 3,
	maxvel = 300,
	get_nearest_enemy = get_nearest_enemy_orc,
	name = "uruguay",
	orc = true,
	texture = "uruk_hai",
	max_texture_index = 2,
	max_hp = 30,
	spawn = {"default:mordordust_mapgen","default:mordordust","default:angmarsnow"},
	chanche = 7000,
	size = 1,
	speed = 3,
	law = "orcishlaw"
})
register_archer({
	damage = 2,
	--penetration = 3,
	maxvel = 300,
	get_nearest_enemy = get_nearest_enemy_orc,
	name = "orccharacter",
	orc = true,
	texture = "orc",
	max_texture_index = 2,
	max_hp = 20,
	spawn = {"default:mordordust_mapgen","default:angmarsnow","default:mordordust","default:brownlandsdirt","default:fangorndirt"},
	chanche = 3000,
	size = 1,
	speed = 3,
	law = "orcishlaw"
})
register_archer({
	damage = 1,
	--penetration = 3,
	maxvel = 300,
	get_nearest_enemy = get_nearest_enemy_orc,
	name = "desertthug",
	force_textures = "desertthug.png",
	orc = true,
	max_hp = 25,
	spawn = {"default:desert_sand"},
	chanche = 1500,
	size = 1,
	speed = 4,
	law = "orcishlaw"
})
register_archer({
	damage = 8,
	--penetration = 3,
	maxvel = 300,
	get_nearest_enemy = get_nearest_enemy_hudwel,
	name = "elf",
	hudwel = true,
	force_textures = "elf.png",
	max_hp = 90,
	armor = 15,
	spawn = {"default:loriendirt"},
	chanche = 2000,
	size = 1,
	speed = 5,
	law = "hudwelshlaw"
})
register_archer({
	damage = 7,
	--penetration = 3,
	maxvel = 300,
	get_nearest_enemy = get_nearest_enemy_hudwel,
	name = "elfcharacter",
	hudwel = true,
	texture = "elf",
	max_texture_index = 5,
	max_hp = 85,
	spawn = {"default:mirkwooddirt","default:loriendirt"},
	chanche = 3000,
	size = 1,
	speed = 5,
	law = "hudwelshlaw"
})
register_archer({
	damage = 6,
	--penetration = 3,
	maxvel = 300,
	get_nearest_enemy = get_nearest_enemy_hudwel,
	name = "human",
	hudwel = true,
	texture = "human_armored",
	max_texture_index = 1,
	max_hp = 60,
	armor = 20,
	spawn = {"default:gondordirt","default:ithiliendirt"},
	chanche = 4000,
	size = 1,
	speed = 4,
	law = "hudwelshlaw"
})
register_archer({
	damage = 5,
	--penetration = 3,
	maxvel = 300,
	get_nearest_enemy = get_nearest_enemy_hudwel,
	name = "humancharacter",
	hudwel = true,
	texture = "human",
	max_texture_index = 10,
	max_hp = 55,
	spawn = {"default:gondordirt","default:rohandirt","default:ithiliendirt"},
	chanche = 1000,
	size = 1,
	speed = 4,
	law = "hudwelshlaw"
})--[[
register_guard({
	damage = 10,
	name = "copper",
	max_hp = 40,
	size = 1,
	speed = 3
})
register_guard({
	damage = 11,
	name = "bronze",
	max_hp = 50,
	size = 1,
	speed = 3
})
register_guard({
	damage = 12,
	name = "obsidian",
	max_hp = 60,
	size = 1,
	speed = 3
})
register_guard({
	damage = 13,
	name = "gold",
	max_hp = 80,
	size = 1,
	speed = 3
})

register_guard({
	damage = 14,
	name = "mese",
	max_hp = 85,
	size = 1,
	speed = 3
})
register_guard({
	damage = 15,
	name = "diamond",
	max_hp = 90,
	size = 1,
	speed = 3
})]]



