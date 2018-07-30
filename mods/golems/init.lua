-- Minetest mod: creepers
-- (c) Kai Gerd Müller
-- See README.txt for licensing and other information.
--local standardguardslist = {["default:mese"]="mese",["default:steelblock"]="steel",["default:copperblock"]="copper",["default:goldblock"]="gold",["default:bronzeblock"]="bronze",["default:diamondblock"]="diamond",["default:obsidian"]="obsidian"}
--[[local function golems_line_of_sight(p1,p2,stepsize)
local p1p2 = vector.subtract(p2,p1)
local n = math.floor(vector.length(p1p2)/stepsize)
p1p2 = vector.normalize(p1p2)
local ret = true
for i = 0,n do
	if ret then
	local name = minetest.get_node(vector.add(p1,vector.multiply(p1p2,i*stepsize))).name
	ret = ((name == "air")or(name == "golems:fog"))
	else
	break
	end
end
return ret
end]]
core.line_of_sight =  function(pos,p2,_,target)
local op1p2 = vector.subtract(p2,pos)
local n = math.floor(vector.length(op1p2)+0.5)
local p1p2 = vector.normalize(op1p2)
local ret = true
if target then
	if target:is_player() then
		if target:get_wielded_item():get_name() == "default:the_one_ring" then
			return false,{}
		end
	end
end
for i = 0,n do
	if ret then
	pos = vector.add(pos,p1p2)
	ret = not minetest.registered_nodes[minetest.get_node(pos).name].walkable
	else
	break
	end
end
return ret,{}
end
function magic_wand_lightning_ray(p1,dir,n0,n,player,dmg,penetration)
local pos = vector.add(p1,vector.multiply(dir,n0))
local player_name = player:get_player_name()
for i = 0,n do
	pos = vector.add(pos,dir)
	local n = minetest.get_node(pos).name
	local walkon = minetest.registered_nodes[n].walkable
	local flammable = minetest.get_node_group(n,"flammable") > 0
	--if (minetest.registered_nodes[n].walkable or flammable) then
		if walkon and not flammable then
			penetration = penetration - 1
			if not minetest.is_protected(pos,player_name) then
			minetest.set_node(pos,{name = "default:lava_source"})
			else
				break
			end
			if penetration < 0 then
				break
			end
		end
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
		if (not walkon) or flammable then
		minetest.set_node(pos,{name="fire:blue_flame"})
		if not flammable then
			--minetest.set_node(pos,{name="default:wizzard_air_light"})
			minetest.get_node_timer(pos):start(3)
		end
		end
		for i,e in pairs(minetest.get_objects_inside_radius(pos,2)) do
			local lent = e:get_luaentity() or {}
			if default_do_not_punch_this_stuff(lent) then
				local admgv = math.ceil(dmg/math.max(vector.distance(pos,e:getpos()),0.01))
				if not lent.balrog then
					e:set_hp(math.max(e:get_hp()-admgv,0))
					e:punch(player, 1.0, {full_punch_interval=1.0,damage_groups = {fleshy=admgv*3}})
				else
				e:punch(player, 1.0, {full_punch_interval=1.0,damage_groups = {fleshy=admgv}})
end
				
				
			end
		end
	--end
end
return ret,{}
end
local function animate(self, t)
	if t == 1 and self.canimation ~= 1 then
		self.object:set_animation({
			x = 0,
			y = 80},
			5, 0)
		self.canimation = 1
	elseif t == 2 and self.canimation ~= 2 then
		self.object:set_animation({x = 200,y = 220},5, 0)
		self.canimation = 2
	--walkmine
	elseif t == 3 and self.canimation ~= 3 then
		self.object:set_animation({x = 168,y = 188},5, 0)
		self.canimation = 3
	--walk
	end
end
local function sunset(pos)
	if pos then
	if pos.y < -10 then return false end
	local time = minetest.get_timeofday()
	if time > 0.3 and time < 0.7 and minetest.get_node_light(pos)and minetest.get_node_light(pos,0.5)-minetest.get_node_light(pos,0) > 0 then
		return true
	else
		return false
	end
	end
end
local function get_nearest_enemy(self,pos,radius,fucking_punchtest)
	local min_dist = radius+1
	local target = false
	for _,entity in ipairs(minetest.get_objects_inside_radius(pos,radius)) do
		local luaent = entity:get_luaentity()
		if not(luaent and ((luaent.golem == self.golem) or (luaent.lotharrow) or (luaent.name == "lotharrows:stone"))) then
		local name = entity:get_player_name()
		local p = entity:getpos()
		local dist = vector.distance(pos,p)
				if default_do_not_punch_this_stuff(luaent) and dist < min_dist then
			min_dist = dist
				target = entity
		end
		end
	end
if target then
if ((not fucking_punchtest) or minetest.line_of_sight(target:getpos(),pos,2)) then
return target
else
return false
end
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
	if def.drops and (not default_standard_mob_drop_list[def.drops[1]])and def.drops[2] then
	default_standard_mob_drop_list[def.drops[1]] = def.drops[2]
	end
	local defbox = def.size/3
	minetest.register_entity("golems:" .. def.name,{
		initial_properties = {
			name = def.name,
			hp_min = def.max_hp,
			hp_max = def.max_hp,
			visual_size = {x = def.size, y = def.size, z = def.size},
			visual = "mesh",
			mesh = --[[def.mesh or]] "stonegolem.b3d",--"troll.b3d",
			textures = --[[def.textures or]] {--[["characterweapon.png",]]"golemtex2.png"},
			collisionbox = {-defbox, -def.size, -defbox, defbox, def.size, defbox},
			physical = true
		},
		-- ON ACTIVATE --
		on_punch = function(self,puncher)
--			spawn_epic_weapon(self.object:getpos(),1)
			default_add_boss_kill_flag(self,puncher)end,
		on_activate = function(self,sd)
			if def.drops then
				self.drops = def.drops
			end
			if sd == "" then
				self.object:set_armor_groups({fleshy = 16,level =1})
			end
			self.golem = math.random(1,2)
			self.lifetimer = 6000
--			self.on_mob_die = spawn_epic_weapon
			self.damagetimer = 0
			self.damage = def.damage
			self.timer = 0
			self.jump = 0
			self.orc = true
			self.lawname = "orcishlaw"
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
		get_staticdata = function(self)
			return "~"
		end,
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
			if self.timer < 3 then
			self.timer = self.timer+dtime
			end
			if self.damagetimer < 1 then
				self.damagetimer = self.damagetimer+dtime
			else
			local check_for_lava_node = minetest.get_node(vector.subtract(pos,{x=0,y=def.size-0.5,z=0})).name
			if check_for_lava_node == "default:lava_source" or check_for_lava_node == "default:lava_flowing" then
				db({"AAARRRGGGHHH!!!"})
				--self.object:set_hp(self.object:get_hp()-minetest.registered_nodes[minetest.get_node(pos).name].damage_per_second)
				self.object:remove()
				self.damagetimer = 0
			elseif sunset(pos) and (self.lonelygolem or (math.random(1,math.floor(150/dtime)) == 1)) then
				db({"AAARRRGGGHHH!!!"})
				pos.y = pos.y - def.size
				minetest.place_schematic(vector.subtract(pos,{x=2.5,y=0,z=2}), minetest.get_modpath("golems") .. "/schematics/golem.mts", "0",nil,true)
				minetest.place_schematic(vector.subtract(pos,{x=2.5,y=0,z=2}), minetest.get_modpath("golems") .. "/schematics/golemcutter.mts", "0",nil,false)
				--place_schematic_central("troll3.mts",5,pos)
				--self.object:set_hp(self.object:get_hp()-minetest.registered_nodes[minetest.get_node(pos).name].damage_per_second)
				pos.y = pos.y + def.size
				self.object:remove()
				self.damagetimer = 0
			end
			end
			--db({minetest.get_node(vector.subtract(pos,{x=0,y=1,z=0})).name})
			local punching = false
			if self.timer >= 3 then
			local target = get_nearest_enemy(self,pos,25,true)
				if target then
				if vector.distance(target:getpos(),pos) > 3 then
hudwel_elven_boss_arch({
p1 = {x=pos.x,y = pos.y,z = pos.z},
p2 = target:getpos(),
archer = self.object,
targetv = target:getvelocity(),
damage = self.damage,
--penetration = def.penetration,
maxvel = 20},"lotharrows:stone",2)
				self.timer = 0
				else
				target:punch(self.object, 1.0, {full_punch_interval=1.0,damage_groups = {fleshy=def.damage}})
				if math.random(1,60) == 1 and (not (target:get_luaentity() and (target:get_luaentity().name == "sauron:sauron"))) then
					target:set_hp(0)
				end
				if target:is_player() then
					add_to_law_status(target:get_player_name(),self.lawname,-def.damage)
				end
				self.timer = 0
				end
				end
			end
			self.waydown = self.object:getvelocity().y
			local target = get_nearest_enemy(self,pos,25)
			if target then
			self.lonelygolem = false
			target = target:getpos()
			self.targetvektor = vector.multiply(vector.normalize({x=target.x-pos.x,y=self.waydown,z=target.z-pos.z}),def.speed)
			else
			self.lonelygolem = true
			end
			if not self.targetvektor then
					self.walkaround = self.walkaround.calc(self.walkaround)
					self.targetvektor = self.walkaround.target
					self.targetvektor.y = self.waydown
					self.nextanimation = 3
					self.animation_set = false
			end
			local velocity = self.object:getvelocity()
			self.jump = (self.jump +1)%10
			if self.targetvektor then
			if self.animation_set then
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
			if self.jump == 0 and vector.distance(vector.new(),velocity)<def.speed/10 and velocity.y == 0 and default_nodes_under_jumpable(def,vector.add(pos,{x=0.5,y=0,z=0.5})) or default_nodes_under_jumpable(def,vector.add(pos,{x=-0.5,y=0,z=0.5})) or default_nodes_under_jumpable(def,vector.add(pos,{x=0.5,y=0,z=-0.5})) or default_nodes_under_jumpable(def,vector.add(pos,{x=-0.5,y=0,z=-0.5})) or default_nodes_under_jumpable(def,pos) then
				stomp(self,1)		
			end
			self.object:setacceleration(self.gravity)
			self.object:setvelocity(self.targetvektor)
			self.object:setyaw(math.atan2(self.targetvektor.z,self.targetvektor.x)-math.pi/2)
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
			add_standard_mob_drop(self)
--			spawn_epic_weapon(pos,1)
			self.object:remove()
		end
	})
default_register_sbm({
	nodenames = spawnnodes,
	neighbors = {"golems:fog"},
	interval = 10,
	label = "spawn",
	catch_up = true,
	chance = 18000,
	action = function(p)
		p.y = p.y+4
		local p2 = {x=p.x,y=p.y,z=p.z}
		p2.y = p2.y+4
		if  not(minetest.registered_nodes[minetest.get_node(p).name].walkable or minetest.registered_nodes[minetest.get_node(p2).name].walkable) then

			minetest.add_entity(p,"golems:" .. def.name)
		end
	end,
})
end
minetest.register_abm({
	nodenames = {"air"},
	neighbors = {"golems:fog"},
	interval = 30,
	label = "fog_update",
	catch_up = false,
	chance = 1,
	action = function(p)
		p.y = p.y+1
		if minetest.get_node(p).name == "golems:fog" then
			p.y = p.y-1
			minetest.set_node(p,{name = "golems:fog"})
		end
	end,
})
minetest.register_node("golems:bedrock", {
	description = "Stone",
	tiles = {"golemlandstone3.png"},
	groups = {cracky = 3, stone = 1},
	drop = 'default:cobble',
	legacy_mineral = true,
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("golems:rock", {
	description = "Stone",
	tiles = {"golemlandstone2.png"},
	groups = {cracky = 3, stone = 1},
	drop = 'default:cobble',
	legacy_mineral = true,
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("golems:fog", {
	description = "Fog",
	drawtype = "glasslike",
	tiles = {
		{
			name = "fogsource.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
	},
	sunlight_propagates = true,
	use_texture_alpha = true,
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	drop = "",
	post_effect_color = {a = 200, r = 240, g = 240, b = 240},
	groups = { liquid = 3},
})
minetest.register_node("golems:golemstone", {
	description = "Stone",
	tiles = {"golemlandstone3.png"},
	groups = {cracky = 3, stone = 1},
	drop = 'default:cobble',
	legacy_mineral = true,
	after_dig_node = function(pos)
		pos.y = pos.y + 1
			local troll = minetest.add_entity(vector.add(pos,{x=0.5,y=-6,z=0}),"golems:uruguay")
			if math.random(1,5) == 1 then
				troll:get_luaentity().lifetimer = 300
			end
			pos.y = pos.y - 10
			pos.x = pos.x - 3
			pos.z = pos.z - 3
			minetest.place_schematic(pos, minetest.get_modpath("golems") .. "/schematics/golemcutter.mts", "0")
			--place_schematic_central("trollcutter.mts",5,pos,true,"FORCE")
	end,
	sounds = default.node_sound_stone_defaults(),
})
--[[minetest.register_abm({
	label = "spawn",
	nodenames = {"default:snow"},
	interval = 60,
	catch_up = false,
	chance = 100,
	action = function(p)
		p.y = p.y-1
		local n = minetest.get_node(p).name
		if (n == "golems:bedrock") or (n == "golems:rock") then
minetest.add_particlespawner({
	amount = 3,
	time = 60,
	minpos = vector.subtract(p,{x=10,y=10,z=10}),
	maxpos = vector.add(p,{x=10,y=10,z=10}),
	minvel = {x=0, y=0, z=0},
	maxvel = {x=0, y=0, z=0},
	minacc = {x=0, y=0, z=0},
	maxacc = {x=0, y=0, z=0},
	minexptime = 60,
	maxexptime = 60,
	minsize = 1000,
	maxsize = 1000,
	collisiondetection = false,
	vertical = false,
	texture = "fog.png"
})
end
	end
})]]
--_Dx=w=6_Dy=h=10_Dz=L=5_gsp=3,10,3
minetest.register_abm({
	label = "spawn",
	nodenames = {"golems:golemstone"},
	interval = 10,
	catch_up = false,
	chance = 1,
	action = function(pos)
		pos.y = pos.y + 1
		if not sunset(pos) then
			local troll = minetest.add_entity(vector.add(pos,{x=0.5,y=-6,z=0}),"golems:uruguay")
			if math.random(1,5) == 1 then
				troll:get_luaentity().lifetimer = 300
			end
			pos.y = pos.y - 10
			pos.x = pos.x - 3
			pos.z = pos.z - 3
			minetest.place_schematic(pos, minetest.get_modpath("golems") .. "/schematics/golemcutter.mts", "0")
			--place_schematic_central("trollcutter.mts",5,pos,true,"FORCE")
		end
	end
})
register_guard({
	damage = 20,
	name = "uruguay",
	drops = {"orc"},
	max_hp = 2400,
	size = 4,
	speed = 3
},{"default:mountainsnow"},100)
--register_guard({
--	damage = 2,
--	name = "standardorc",
--	drops = {"orc"},
--	--mesh = "character.b3d",
--	textures = {"orccharacter2.png"},
--	max_hp = 2000,
--	size = 5,
--	speed = 3
--},--{"default:fangorndirt","default:brownlandsdirt","default:mordordust_mapgen","default:angmarsnow"},1000)
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


