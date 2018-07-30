-- mods/default/tools.lua

-- The hand

minetest.register_item(":", {
	type = "none",
	wield_image = "wieldhand.png",
	wield_scale = {x=1,y=1,z=2.5},
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level = 0,
		groupcaps = {
			crumbly = {times={[2]=3.00, [3]=0.70}, uses=0, maxlevel=1},
			snappy = {times={[3]=0.40}, uses=0, maxlevel=1},
			oddly_breakable_by_hand = {times={[1]=3.50,[2]=2.00,[3]=0.70}, uses=0}
		},
		damage_groups = {fleshy=1},
	}
})

--
-- Picks
--

minetest.register_tool("default:pick_wood", {
	description = "Wooden Pickaxe",
	inventory_image = "default_tool_woodpick.png",
	tool_capabilities = {
		full_punch_interval = 1.2,
		max_drop_level=0,
		groupcaps={
			cracky = {times={[3]=1.60}, uses=10, maxlevel=1},
		},
		damage_groups = {fleshy=2},
	},
})
minetest.register_tool("default:pick_stone", {
	description = "Stone Pickaxe",
	inventory_image = "default_tool_stonepick.png",
	tool_capabilities = {
		full_punch_interval = 1.3,
		max_drop_level=0,
		groupcaps={
			cracky = {times={[2]=2.0, [3]=1.00}, uses=20, maxlevel=1},
		},
		damage_groups = {fleshy=3},
	},
})
minetest.register_tool("default:pick_steel", {
	description = "Steel Pickaxe",
	inventory_image = "default_tool_steelpick.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			cracky = {times={[1]=4.00, [2]=1.60, [3]=0.80}, uses=20, maxlevel=2},
		},
		damage_groups = {fleshy=4},
	},
})
minetest.register_tool("default:pick_bronze", {
	description = "Bronze Pickaxe",
	inventory_image = "default_tool_bronzepick.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			cracky = {times={[1]=4.00, [2]=1.60, [3]=0.80}, uses=30, maxlevel=2},
		},
		damage_groups = {fleshy=4},
	},
})

--
-- Shovels
--

minetest.register_tool("default:shovel_wood", {
	description = "Wooden Shovel",
	inventory_image = "default_tool_woodshovel.png",
	wield_image = "default_tool_woodshovel.png^[transformR90",
	tool_capabilities = {
		full_punch_interval = 1.2,
		max_drop_level=0,
		groupcaps={
			crumbly = {times={[1]=3.00, [2]=1.60, [3]=0.60}, uses=10, maxlevel=1},
		},
		damage_groups = {fleshy=2},
	},
})
minetest.register_tool("default:shovel_stone", {
	description = "Stone Shovel",
	inventory_image = "default_tool_stoneshovel.png",
	wield_image = "default_tool_stoneshovel.png^[transformR90",
	tool_capabilities = {
		full_punch_interval = 1.4,
		max_drop_level=0,
		groupcaps={
			crumbly = {times={[1]=1.80, [2]=1.20, [3]=0.50}, uses=20, maxlevel=1},
		},
		damage_groups = {fleshy=2},
	},
})
minetest.register_tool("default:shovel_steel", {
	description = "Steel Shovel",
	inventory_image = "default_tool_steelshovel.png",
	wield_image = "default_tool_steelshovel.png^[transformR90",
	tool_capabilities = {
		full_punch_interval = 1.1,
		max_drop_level=1,
		groupcaps={
			crumbly = {times={[1]=1.50, [2]=0.90, [3]=0.40}, uses=30, maxlevel=2},
		},
		damage_groups = {fleshy=3},
	},
})
minetest.register_tool("default:shovel_bronze", {
	description = "Bronze Shovel",
	inventory_image = "default_tool_bronzeshovel.png",
	wield_image = "default_tool_bronzeshovel.png^[transformR90",
	tool_capabilities = {
		full_punch_interval = 1.1,
		max_drop_level=1,
		groupcaps={
			crumbly = {times={[1]=1.50, [2]=0.90, [3]=0.40}, uses=40, maxlevel=2},
		},
		damage_groups = {fleshy=3},
	},
})

--
-- Axes
--

minetest.register_tool("default:axe_wood", {
	description = "Wooden Axe",
	inventory_image = "default_tool_woodaxe.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=0,
		groupcaps={
			choppy = {times={[2]=3.00, [3]=1.60}, uses=10, maxlevel=1},
		},
		damage_groups = {fleshy=2},
	},
})
minetest.register_tool("default:axe_stone", {
	description = "Stone Axe",
	inventory_image = "default_tool_stoneaxe.png",
	tool_capabilities = {
		full_punch_interval = 1.2,
		max_drop_level=0,
		groupcaps={
			choppy={times={[1]=3.00, [2]=2.00, [3]=1.30}, uses=20, maxlevel=1},
		},
		damage_groups = {fleshy=3},
	},
})
minetest.register_tool("default:axe_steel", {
	description = "Steel Axe",
	inventory_image = "default_tool_steelaxe.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			choppy={times={[1]=2.50, [2]=1.40, [3]=1.00}, uses=20, maxlevel=2},
		},
		damage_groups = {fleshy=4},
	},
})
minetest.register_tool("default:axe_bronze", {
	description = "Bronze Axe",
	inventory_image = "default_tool_bronzeaxe.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			choppy={times={[1]=2.50, [2]=1.40, [3]=1.00}, uses=30, maxlevel=2},
		},
		damage_groups = {fleshy=4},
	},
})


--
-- Swords
--

minetest.register_tool("default:sword_wood", {
	description = "Wooden Sword",
	inventory_image = "default_tool_woodsword.png",
	tool_capabilities = {
		full_punch_interval = 1,
		max_drop_level=0,
		groupcaps={
			snappy={times={[2]=1.6, [3]=0.40}, uses=10, maxlevel=1},
		},
		damage_groups = {fleshy=2},
	}
})
minetest.register_tool("default:sword_stone", {
	description = "Stone Sword",
	inventory_image = "default_tool_stonesword.png",
	tool_capabilities = {
		full_punch_interval = 1.2,
		max_drop_level=0,
		groupcaps={
			snappy={times={[2]=1.4, [3]=0.40}, uses=20, maxlevel=1},
		},
		damage_groups = {fleshy=4},
	}
})
minetest.register_tool("default:sword_steel", {
	description = "Steel Sword",
	inventory_image = "default_tool_steelsword.png",
	tool_capabilities = {
		full_punch_interval = 0.8,
		max_drop_level=1,
		groupcaps={
			snappy={times={[1]=2.5, [2]=1.20, [3]=0.35}, uses=30, maxlevel=2},
		},
		damage_groups = {fleshy=6},
	}
})
minetest.register_tool("default:sword_bronze", {
	description = "Bronze Sword",
	inventory_image = "default_tool_bronzesword.png",
	tool_capabilities = {
		full_punch_interval = 0.8,
		max_drop_level=1,
		groupcaps={
			snappy={times={[1]=2.5, [2]=1.20, [3]=0.35}, uses=40, maxlevel=2},
		},
		damage_groups = {fleshy=6},
	}
})
default_weapon_prototypes = {warhammer = 
{
damage = 7/4,
reload = 3,
range = 1.5,
snappy = 0.5,
lvl = 0.3,
uses = 10,
craft = 
{
{"", false, false},
{"group:stick", false, false},
{'', false, false}
}
},
mace = 
{
damage = 4/4,
reload = 2.5,
range = 2,
snappy = 0.7,
lvl = 0.3,
uses = 7,
craft = 
{
{"", false,"" },
{false, 'group:stick', false},
{'', 'group:stick', ''},
}
},
halberd = 
{
damage = 5/4,
reload = 3,
range = 2.4,
snappy = 1,
lvl = 0.3,
uses = 6,
craft = 
{
{"", false, false},
{false, 'group:stick', false},
{'', 'group:stick', ''},
}
},
battleaxe = 
{
damage = 5/4,
reload = 1.5,
range = 2,
snappy = 2,
lvl = 0.3,
uses = 5,
craft = 
{
{false, false, false},
{false, 'group:stick', false},
{'', 'group:stick', ''},
}
},
spear = 
{
damage = 2/4,
reload = 0.5,
range = 6,
snappy = 1.5,
lvl = 0.3,
uses = 3,
craft = {
{"", "", false},
{"", 'group:stick', ""},
{'group:stick', '', ''},
}
}
}
function register_weapon_using_prototype(name,prefix,lvl,crafting_mat,overlay,tex)
local prot = default_weapon_prototypes[name]
local tex2 = false
if overlay then
tex2  ="weaponstick.png^" .. name .. "_" .. prefix .. ".png"--"weaponstick.png^(" .. name .. "_blackwhite.png^((" .. overlay .. ".png^" .. overlay .. ".png^" .. overlay .. ".png^" .. overlay .. ".png^" .. overlay .. ".png^" .. overlay .. ".png^" .. name .. "_alphamask.png)^[makealpha:255,0,255))"
end
minetest.register_tool("default:" .. prefix .. name, {
	description = prefix .. name,
	range = prot.range,
	inventory_image = tex or tex2 or prefix .. name .. ".png",
	tool_capabilities = {
		full_punch_interval = prot.reload/(1+(lvl/10)),
		max_drop_level=1,
		groupcaps={
			snappy={times={[1]=prot.snappy/lvl, [2]=prot.snappy/(2*lvl), [3]=prot.snappy/(6*lvl)}, uses=math.floor(prot.uses*lvl), maxlevel=math.max(math.floor(prot.lvl*lvl),1)},
		},
		damage_groups = {fleshy=prot.damage*lvl},
	}
})
local rec = prot.craft
minetest.register_craft({
	output = "default:" .. prefix .. name,
	recipe = {
		{rec[1][1] or crafting_mat, rec[1][2] or crafting_mat, rec[1][3] or crafting_mat},
		{rec[2][1] or crafting_mat, rec[2][2] or crafting_mat, rec[2][3] or crafting_mat},
		{rec[3][1] or crafting_mat, rec[3][2] or crafting_mat, rec[3][3] or crafting_mat},
	}
})
end
local default_weapon_materials = {
--wood = {lvl = 1,crafting_mat = "group:wood"},
steel = {lvl = 3,crafting_mat = "default:steel_ingot"},
bronze = {lvl = 4,crafting_mat = "default:bronze_ingot"},
galvorn = {lvl = 9,crafting_mat = "default:galvorn_ingot"},
mithril = {lvl = 10,crafting_mat = "default:mithril_ingot"}
}
for i,e in pairs(default_weapon_materials) do
register_weapon_using_prototype("mace",i,e.lvl,e.crafting_mat,"default_" .. i .. "_metal_overlay")
register_weapon_using_prototype("warhammer",i,e.lvl,e.crafting_mat,"default_" .. i .. "_metal_overlay")
register_weapon_using_prototype("battleaxe",i,e.lvl,e.crafting_mat,"default_" .. i .. "_metal_overlay")
register_weapon_using_prototype("spear",i,e.lvl,e.crafting_mat,"default_" .. i .. "_metal_overlay")
register_weapon_using_prototype("halberd",i,e.lvl,e.crafting_mat,"default_" .. i .. "_metal_overlay")
end
function register_standard_mineral(mineral,v,cracky,level,t,ore)
if ore then
minetest.register_craft({
	type = "cooking",
	output = "default:" .. mineral .. "_ingot",
	recipe = "default:" .. mineral .. "_lump",
	cooktime = t
})

minetest.register_node("default:stone_with_" .. mineral, {
	description = mineral .. " ore",
	tiles = {"default_stone.png^default_mineral_" .. mineral .. ".png"},
	groups = {cracky = cracky, level = level},
	drop = "default:" .. mineral .. "_lump",
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_craftitem("default:" .. mineral .. "_lump", {
	description = mineral .. " lump",
	inventory_image = "default_" .. mineral .. "_lump.png",
})end
minetest.register_craft({
	output = "default:" .. mineral .. "block",
	recipe = {
		{'default:' .. mineral .. '_ingot','default:' .. mineral .. '_ingot','default:' .. mineral .. '_ingot'},
		{'default:' .. mineral .. '_ingot','default:' .. mineral .. '_ingot','default:' .. mineral .. '_ingot'},
		{'default:' .. mineral .. '_ingot','default:' .. mineral .. '_ingot','default:' .. mineral .. '_ingot'},
	}
})
minetest.register_craft({
	output = "default:" .. mineral .. "_ingot 9",
	recipe = {
		{"default:" .. mineral .. "block"},
	}
})
minetest.register_craft({
	output = 'default:sword_' .. mineral,
	recipe = {
		{'default:' .. mineral .. '_ingot'},
		{'default:' .. mineral .. '_ingot'},
		{'group:stick'},
	}
})
minetest.register_craft({
	output = 'default:shovel_' .. mineral,
	recipe = {
		{'default:' .. mineral .. '_ingot'},
		{'group:stick'},
		{'group:stick'},
	}
})
minetest.register_craft({
	output = 'default:axe_' .. mineral,
	recipe = {
		{'default:' .. mineral .. '_ingot','default:' .. mineral .. '_ingot'},
		{'group:stick','default:' .. mineral .. '_ingot'},
		{'group:stick',''},
	}
})
minetest.register_craft({
	output = 'default:pick_' .. mineral,
	recipe = {
		{'default:' .. mineral .. '_ingot','default:' .. mineral .. '_ingot','default:' .. mineral .. '_ingot'},
		{'','group:stick',''},
		{'','group:stick',''},
	}
})
minetest.register_craftitem("default:" .. mineral .. "_ingot", {
	description = mineral .. " ingot",
	inventory_image = "default_" .. mineral .. "_ingot.png"
})
minetest.register_node("default:" .. mineral .. "block", {
	description = mineral .. " block",
	tiles = {"mineralblock.png^default_" .. mineral .. "_overlay.png" },
	is_ground_content = false,
	groups = {cracky = cracky, level = level+2},
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_tool("default:sword_" .. mineral, {
	description = mineral .. " sword",
	inventory_image = "default_tool_" .. mineral .. "sword.png",
	tool_capabilities = {
		full_punch_interval = 0.7/v,
		max_drop_level=math.floor(v+0.5),
		groupcaps={
			snappy={times={[1]=1.90*v, [2]=0.90*v, [3]=0.30*v}, uses=math.floor((40*v)+0.5), maxlevel=math.floor((3*v)+0.5)},
		},
		damage_groups = {fleshy=math.floor((8*v)+0.5)},
	}
})
minetest.register_tool("default:axe_" .. mineral, {
	description = mineral .. " axe",
	inventory_image = "default_tool_" .. mineral .. "axe.png",
	tool_capabilities = {
		full_punch_interval = 0.9/v,
		max_drop_level=math.floor(v+0.5),
		groupcaps={
			choppy={times={[1]=2.10*v, [2]=0.90*v, [3]=0.50*v}, uses=math.floor((30*v)+0.5), maxlevel=math.floor((2*v)+0.5)},
		},
		damage_groups = {fleshy=math.floor((7*v)+0.5)},
	},
})
minetest.register_tool("default:shovel_" .. mineral, {
	description = mineral .. " shovel",
	inventory_image = "default_tool_" .. mineral .. "shovel.png",
	wield_image = "default_tool_" .. mineral .. "shovel.png^[transformR90",
	tool_capabilities = {
		full_punch_interval = 1.0/v,
		max_drop_level=math.floor(v+0.5),
		groupcaps={
			crumbly = {times={[1]=1.10*v, [2]=0.50*v, [3]=0.30*v}, uses=math.floor((30*v)+0.5), maxlevel=math.floor((3*v)+0.5)},
		},
		damage_groups = {fleshy=math.floor((4*v)+0.5)},
	},
})
minetest.register_tool("default:pick_" .. mineral, {
	description = mineral .. " pickaxe",
	inventory_image = "default_tool_" .. mineral .. "pick.png",
	tool_capabilities = {
		full_punch_interval = 0.9/v,
		max_drop_level=math.floor((v*3)+0.5),
		groupcaps={
			cracky = {times={[1]=2.0*v, [2]=1.0*v, [3]=0.50*v}, uses=math.floor((3*v)+0.5), maxlevel=math.floor((3*v)+0.5)},
		},
		damage_groups = {fleshy=math.floor((5*v)+0.5)},
	},
})end
register_standard_mineral("galvorn",1.25,1,2,10)
register_standard_mineral("mithril",1.5,1,3,30,true)
