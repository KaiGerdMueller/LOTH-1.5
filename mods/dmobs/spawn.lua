if dmobs.regulars then
	-- friendlies

	mobs:register_spawn("dmobs:nyan", {"default:pine_needles","default:leaves"}, 20, 10, 50000, 2, 31000)
	mobs:register_spawn("dmobs:nyan", {"nyanland:meseleaves"}, 20, 10, 15000, 2, 31000)

	mobs:register_spawn("dmobs:hedgehog", {"default:dirt_with_grass","default:pine_needles"}, 20, 10, 15000, 2, 31000)
	mobs:register_spawn("dmobs:whale", {"default:water_source"}, 20, 10, 15000, -20, 1000)
	mobs:register_spawn("dmobs:owl", {"default:leaves","default:tree"}, 20, 10, 15000, 2, 31000)
	mobs:register_spawn("dmobs:gnorm", {"default:dirt_with_grass","default:wood"}, 20, 10, 32000, 2, 31000)
	mobs:register_spawn("dmobs:tortoise", {"default:clay","default:sand"}, 20, 10, 15000, 2, 31000)
	mobs:register_spawn("dmobs:elephant", {"default:dirt_with_dry_grass","default:desert_sand"}, 20, 10, 15000, 2, 31000)
	mobs:register_spawn("dmobs:badger", {"default:dirt_with_grass","default:dirt"}, 20, 10, 15000, 2, 31000)
	mobs:register_spawn("dmobs:pig", {"default:pine_needles","default:leaves", "nyanland:cloudstone"}, 20, 10, 32000, 2, 31000)
	mobs:register_spawn("dmobs:panda", {"default:dirt_with_grass","ethereal:bamboo_dirt"}, 20, 10, 15000, 2, 31000)

	-- baddies
	local evil_mob_spawn = {"default:snow","default:snowblock","default:angmarsnow","default:mordordust","default:mordordust_mapgen","default:desert_sand"}
	local evil_mob_spawn_troll = {"default:snow","default:snowblock","default:angmarsnow","default:mordordust","default:mordordust_mapgen","default:desert_sand","default:trollshawsdirt","default:brownlandsdirt"}
	local cave_spawn = {"default:stone","default:mossycobble"}
	mobs:register_spawn("dmobs:wasp", {"default:fangorndirt","default:mirkwooddirt","default:brownlandsdirt"}, 15, 0, 32000, 2, 31000,{air = true})
	mobs:register_spawn("dmobs:wasp", {"dmobs:hive"}, 20, 10, 16000, 2, 31000)
	mobs:register_spawn("dmobs:wasp_leader", {"default:dirt_with_grass","dmobs:hive"}, 20, 10, 64000, 2, 31000)

	mobs:register_spawn("dmobs:golem", cave_spawn, 7, 0, 16000, 2, 31000)
	mobs:register_spawn("dmobs:fox", {"default:dirt_with_grass","default:dirt"}, 15, 0, 32000, 2, 31000)
		mobs:register_spawn("dmobs:orc", evil_mob_spawn_troll, 15, 0, 15000, 2, 31000)
		mobs:register_spawn("nssm:manticore", {"default:desert_sand","default:trollshawsdirt","default:brownlandsdirt"}, 15, 0, 150000,2, 31000)
		mobs:register_spawn("nssm:signosigno", evil_mob_spawn_troll, 15, 0, 15000,2, 31000)
		mobs:register_spawn("nssm:werewolf", evil_mob_spawn_troll, 15, 0, 60000,2, 31000)
		mobs:register_spawn("nssm:lava_titan", {"default:mordordust","default:mordordust_mapgen"}, 15, 0, 150000,2, 31000)
		mobs:register_spawn("dmobs:ogre",  evil_mob_spawn_troll, 15, 0, 15000, 2, 31000)

	mobs:register_spawn("dmobs:rat", evil_mob_spawn, 15, 0, 32000, 2, 31000)
	mobs:register_spawn("dmobs:rat", cave_spawn, 7, 0, 32000, 2, 31000)
	mobs:register_spawn("dmobs:treeman",{"default:fangorndirt","default:mirkwooddirt","default:brownlandsdirt"}, 15, 0, 16000, 2, 31000)
	mobs:register_spawn("nssm:mantis",{"default:fangorndirt","default:mirkwooddirt"}, 15, 0, 16000, 2, 31000)
	mobs:register_spawn("nssm:larva",{"default:fangorndirt","default:mirkwooddirt"}, 15, 0, 16000, 2, 31000)
	mobs:register_spawn("nssm:masticone",{"default:fangorndirt","default:mirkwooddirt"}, 15, 0, 16000, 2, 31000)
	mobs:register_spawn("nssm:enderduck",{"default:fangorndirt","default:mirkwooddirt","default:brownlandsdirt"}, 15, 0, 16000, 2, 31000)
	mobs:register_spawn("nssm:echidna",{"default:fangorndirt","default:mirkwooddirt"}, 15, 0, 32000, 2, 31000)
	mobs:register_spawn("nssm:mantis_beast",{"default:fangorndirt","default:mirkwooddirt"}, 15, 0, 32000, 2, 31000)
	mobs:register_spawn("dmobs:skeleton", cave_spawn, 7, 0, 16000, 2, 31000)
end

-- dragons

--mobs:register_spawn("dmobs:dragon", {"default:leaves","default:dirt_with_grass"}, 20, 10, 64000, 2, 31000)

--[[if dmobs.dragons then
	mobs:register_spawn("dmobs:dragon2", {"default:pine_needles"}, 20, 10, 64000, 2, 31000)
	mobs:register_spawn("dmobs:dragon3", {"default:acacia_leaves","default:dirt_with_dry_grass"}, 20, 10, 64000, 2, 31000)
	mobs:register_spawn("dmobs:dragon4", {"default:jungleleaves"}, 20, 10, 64000, 2, 31000)
	mobs:register_spawn("dmobs:waterdragon", {"default:water_source"}, 20, 10, 32000, 1, 31000, false)
	mobs:register_spawn("dmobs:wyvern",	{"default:leaves"}, 20, 10, 32000, 1, 31000, false)
	mobs:register_spawn("dmobs:dragon_great", {"default:lava_source"}, 20, 0, 64000, -21000, 1000, false)
end]]
