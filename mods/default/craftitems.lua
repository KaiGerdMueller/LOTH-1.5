-- mods/default/craftitems.lua
minetest.register_craftitem("default:stick", {
	description = "Stick",
	inventory_image = "default_stick.png",
	groups = {stick = 1},
})

minetest.register_craftitem("default:paper", {
	description = "Paper",
	inventory_image = "default_paper.png",
})
default.on_first_spawn_formspec_race_selector = "size[6,3;]field[0,0;6,3;default:race_selector;selecht special evil race if you wish to. else just quit. possible options are orc and dunlending.;none]"
local secret_runes_table = {{"böse","böses","verbrechen"},{"magisch","magisches","zaubern","magie"},{"hell_und_dunkel","gut_und_böse"},{"sonnenfinsternis","invasion_des_bösen"},{"sterne","funkeln","nacht","kalt","himmel","schnee"},"monster",{"verdunkelung","verfall","verfallen"},{"auge","sehen","sicht","finden"},{"könig","herrscher","herrschen"},{"dunkler_herrscher","sauron"},{"schutz","verteidigung","defensive","schild","schützen","sicher"},{"mensch","kreatur","humanoid","menschlich"},{"tod","tot_sein","tot","grab","sterben"},{"soldat","ritter","kämpfer","kämpfen"},"flaggenträger",{"töten","vernichten","zerstören"},{"einfangen","fangen","einsperren","zelle","gefängnis","dungeon","gefangen_nehmen","gefangen","eingesperrt"},{"stark_magisch","stark_magisches","starke_magie","mächtiges_zaubern"},{"nicht","falsch","gelogen"},"und",{"ist","besitzt","hat","daher","mit"},"(",")",{"schlange","echidna","schlangenartige_kreatur"},{"spinne","spinnennetz"},{"schatz","geld","wohlstand","reichtum","truhe","chest","schatztruhe"},{"ende","punkt"},{"entstehung","geburt","erschaffung","zeugung","gebären","entstehen","zeugen","erschaffen","schaffen","erzeugen"},{"mal","vervielfachen","vervielfacht"},{"plus","hinzufügen","hinzugefügt","sonne","licht","gut","heilig","tag","warm"},{"minus","vermindern","vermindert"},{"geteilt","aufteilen","teilen","aufgeteilt","teil","anteil"},{"X","10","zehn"},{"V","5","fünf"},{"I","1","eins","ein"},{"null","0","nichts","leer","kein"},{"unendlich","endlos","unbegrenzt","grenzenlos","alles","alle","welt"},{"zeit","zur_zeit","zur_zeit_als","als","letztlich"},{"parasit","critter"},{"mehr","größer","mehr_als","größer_als","viel","stärker"},{"weniger","kleiner","weniger_als","kleiner_als","wenig","schwächer"},{"gleich","gleichheit","gerechtigkeit","waage","gerecht","gleichgewicht"}}
local combined_words={
["armee"]="( flaggenträger ritter ritter flaggenträger )",
["der_ring"]="( dunkler_herrscher null )",
["orc"]="soldat ist ( böse schwächer nicht mensch )",
["dunlending"]="soldat ist ( böse schwächer mensch )",
["elf"]="soldat ist ( gut stärker nicht mensch )",
["hexenkönig"]="dunkler_herrscher ist ( schwächer sauron )",
["ort"]="( anteil welt )",
["leben"]="( nicht tot )",
["ungleich"]="( nicht gleich )",
["anders"]="ungleich",
["lebensraum"]="( leben ort )",
["umgefähr_wie"]="( anteil gleich )",
["land"]="ort ist nicht himmel",
["lorien"]="ort mit ( elf und nicht böse kreatur )",
["mirkwood"]="ort mit ( elf und böse kreatur )",
["dunland"]="ort mit ( dunlending )",
["gondor"]="ort mit viel mensch",
["ithilien"]="ort mit ( anteil weniger_als gondor mensch )",
["hobbit"]="kreatur ist ( kleiner und nicht soldat )",
["shire"]="ort mit hobbit",
["zwerg"]="kreatur ist ( kleiner und soldat )",
["ironhills"]="ort mit ( zwerg und schatz )",
["blue_mountains"]="ort mit zwerg",
["angmar"]="ort mit ( kalt und hexenkönig )",
["wüstenbewohner"]="kreatur ist mensch hat ( ort warm )",
["desert"]="ort mit ( wüstenbewohner und viel warm )",
["mordor"]="ort mit ( orc und viel warm )",
["misty_mountains"]="ort mit ( viel kalt und nicht hexenkönig )",
["golem"]="kreatur mit ( lebensraum misty_mountains )",
["troll"]="( kreatur umgefähr_wie orc ) größer_als orc",
["balrog"]="( kreatur umgefähr_wie troll ) ist ( monster und viel warm )",
["drache"]="kreatur mit ( größer und lebensraum himmel ) ist viel warm",
["fledermaus"]="kreatur mit ( kleiner und lebensraum himmel )",
["fangorn"]="ort ist ( umgefähr_wie mirkwood und nicht gleich mirkwood )",
["wasser"]="( warm schnee )",
["meer"]="ort mit viel wasser",
["schlamm"]="( verfallen wasser )",
["brownlands"]="ort mit viel schlamm",
["trollshaws"]="ort mit ( viel troll und wenig ( kreatur ist nicht troll ) )"
}
local tested_combined_words = {
["army"]="armee",
["water"] = "wasser",
["the one ring"] ="der_ring",
["orc"] = "orc",
["dunlending"]= "dunlending",
["elf"]="elf",
["dwarf"] = "zwerg",
["hobbit"] = "hobbit",
["human"] = "kreatur",
["troll"] = "troll",
["spider"] = "spinne",
["snake"] = "schlange",
["balrog"]= "balrog",
["dragon"] = "drache",
["sauron"] = "sauron",
["witch king"]="hexenkönig",
["lorien"] = "lorien",
["mirkwood"] = "mirkwood",
["dunland"] = "dunland",
["gondor"] = "gondor",
["ironhills"] = "ironhills",
["shire"] = "shire",
["angmar"] = "angmar",
["sea"] = "meer",
["fangorn"] = "fangorn",
["mordor"] = "mordor"
}
local historical_sentences = {
"zur_zeit ( viel böse schlange ist monster mit wenig magie und viel spinne ist monster ) töten flaggenträger ritter ritter flaggenträger ende mensch mit starke_magie töten alle böse schlange und spinne zur_zeit nacht und finden schatz ende zur_zeit wenig mensch sterben und mensch nicht sehen böse kreatur hat ( töten mensch ) ende",
"zur_zeit_als sonnenfinsternis viel verfall und viel monster gebären und böse flaggenträger ritter ritter flaggenträger und monster töten viel mensch ende teil viel monster ist ( gebären stark_magisch ) daher alle ritter schwächer und nicht schützen mensch daher mensch erzeugen viel ritter und mensch erzeugen wenig soldat mit starke_magie daher mensch sicher ende",
"zur_zeit_als sonnenfinsternis sauron erschaffen fledermaus und drache und monster mit lebensraum meer und troll und orc und balrog und ( viel anders monster mit lebensraum land )",
"zur_zeit_als sonnenfinsternis sauron erschaffen der_ring daher sauron stärker daher ( böse armee mit orc und sauron ) kämpfen ( gut armee mit elf und zwerg und mensch ) ende ( sauron und der_ring und böse armee ) stärker gut armee ende ( könig kämpfen sauron ) daher ( könig hat der_ring und sauron hat nicht der_ring ) daher sauron schwächer und mensch und zwerg und elf nicht sterben ende"

}
local historical_text = "zur_zeit ( viel böse schlange ist monster mit wenig magie und viel spinne ist monster ) töten flaggenträger ritter ritter flaggenträger ende mensch mit starke_magie töten alle böse schlange und spinne zur_zeit nacht und finden schatz ende zur_zeit wenig mensch sterben und mensch nicht sehen böse kreatur hat ( töten mensch ) ende zur_zeit_als sonnenfinsternis viel verfall und viel monster gebären und böse flaggenträger ritter ritter flaggenträger und monster töten viel mensch ende teil viel monster ist ( gebären stark_magisch ) daher alle ritter schwächer und nicht schützen mensch daher mensch erzeugen viel ritter und mensch erzeugen wenig soldat mit starke_magie daher mensch sicher ende zur_zeit_als sonnenfinsternis sauron erschaffen fledermaus und drache und monster mit lebensraum meer und troll und orc und balrog und ( viel anders monster mit lebensraum land ) und viel monster mit lebensraum wasser ende zur_zeit_als sonnenfinsternis sauron erschaffen der_ring daher sauron stärker daher ( böse armee mit orc und sauron ) kämpfen ( gut armee mit elf und zwerg und mensch ) ende ( sauron und der_ring und böse armee ) stärker gut armee ende ( könig kämpfen sauron ) daher ( könig hat der_ring und sauron hat nicht der_ring ) daher sauron schwächer und mensch und zwerg und elf nicht sterben ende"
local historical_text_translated = "recently many evil snakelike monsters with lightweight magical skills and many monstrous spiders destroyed an army. at night strongly magical wizzards killed all evil snakelike creatures and spiders and found some treasure. still some people die and no one saw the creature that killed them. when the eclipse happened, there was much decay and many monsters got created and an evil army and the monsters killed many people. a part of the monsters was born with strong magics, therefore the knights where inferior so they yould not defeat the people properly causing the people to train more knights and train few knights capable of using strong magics so the people where safe again. at that time sauron formed the bats and the dragons and seamonsters and trolls and orcs and balrogs and many other monsters living on land. at that time sauron made the one ring so he got stronger so an evil army containing orcs and sauron fought against a good army out of elfs and dwarfs and humans. the bad army and sauron with the one ring where stronger than the good army. a king fought sauron, therefore got the one ring so sauron got weaker and humans and dwarfs and elfs didn't die."
local secret_runes_dictionary = {}
setmetatable(secret_runes_dictionary,{
__index = function(_,k)
	error(k.."_word_does_not_exist")
end
})
do
local counter = 0
for i,e in pairs(secret_runes_table) do
	counter = counter+1
	if type(e) == "table" then
		for _,el in pairs(e) do
			secret_runes_dictionary[el] = i
		end
	else
		secret_runes_dictionary[e] = i
	end
end
if (counter ~= 42) then
	error("malformed data")
end
end
local function resolve_combined_words(s)
	local r = ""
	not_first_el = false
	for w in string.gmatch(s,"%S+") do
		if not_first_el then
			r = r .. " "
		else
			not_first_el = true
		end
		if rawget(secret_runes_dictionary,w) then
			r = r..w
		elseif combined_words[w] then
			r = r..resolve_combined_words(combined_words[w])
		else
			error(w)
		end
	end
	return r
end
for i,e in pairs(combined_words) do
	combined_words[i] = resolve_combined_words(e)
end
local secret_runes_formspec = function(tex)
	local tex = resolve_combined_words(tex)
	local multiplier = 2
	local s  ="size[15,15;]image[1,1;15,15;secret_rune_bg.png]"
	local width = (12/22)*(0.8/multiplier)
	local width_and_height_with_free = (12/22)/multiplier
	local height = (12/22)*(0.6/multiplier)
	local i = 0
	local j = 0
	for w in string.gmatch(tex,"%S+") do s = s.."image["..((i+1)*width_and_height_with_free+1)..","..((j+1)*width_and_height_with_free+1)..";"..width..","..height..";secret_rune_no_"..secret_runes_dictionary[w]..".png]"
		i = i+1
		if i >= 20*multiplier then
			i = 0
			j = j+1
		end
	end
	return s
end
local rune_learning_formspec = secret_runes_formspec(historical_text).."textarea[1,6;12,6;translation;"..historical_text_translated..";]"
local secret_runes_formspec_test_text = function(tex)
	local tex = resolve_combined_words(tex)
	local multiplier = 2
	local s  ="size[15,15;]image[1,1;8,15;secret_rune_bg.png]"
	local width = (12/22)*(0.8/multiplier)
	local width_and_height_with_free = (12/22)/multiplier
	local height = (12/22)*(0.6/multiplier)
	local i = 0
	local j = 0
	for w in string.gmatch(tex,"%S+") do s = s.."image["..((i+1)*width_and_height_with_free+1)..","..((j+1)*width_and_height_with_free+1)..";"..width..","..height..";secret_rune_no_"..secret_runes_dictionary[w]..".png]"
		i = i+1
		if i >= 10*multiplier then
			i = 0
			j = j+1
		end
	end
	return s
end
local secret_runes_formspec_test_combined_words = function(combined_words_remaining)
	if #combined_words_remaining == 0 then
		if combined_words_remaining.correct == "correct" then
			return false,true
		else
			return false,false
		end
	end
	local data = combined_words_remaining[math.random(1,#combined_words_remaining)]
	local test = secret_runes_formspec_test_text(data.definition)
	for i,e in ipairs(combined_words_remaining) do
		if e.definition == data.definition then
			test = test.."button_exit[8,"..tostring(0.5+i/2)..";6,0.5;"..combined_words_remaining.correct..tostring(i)..";"..e.name.."]"
		else
			test = test.."button_exit[8,"..tostring(0.5+i/2)..";6,0.5;wrong"..tostring(i)..";"..e.name.."]"
		end
	end
	return test
end
local function create_combined_words_test_collection()
	local cwt = {correct = "correct"}
	for i,e in pairs(tested_combined_words) do
		table.insert(cwt,{name = i,definition = resolve_combined_words(e)})
	end
	return cwt
end
player_rune_test_tables = {}
local function test_step(name)
	local rt,s = secret_runes_formspec_test_combined_words(player_rune_test_tables[name])
	if rt then
		minetest.after(0.5,minetest.show_formspec,name, "default:secret_runes_test", rt)
	else
		if s then
			player_rune_test_tables[name] = nil
			set_rune_riddle_solved(name)
			local p = minetest.get_player_by_name(name)
			if p and not get_melkor_spawned() then
			minetest.after(3,minetest.add_entity,p:getpos(),"melkor:melkor")
			end
			minetest.after(0.5,minetest.show_formspec,name, "default:secret_runes_win", "size[15,15;]image[1,1;15,15;secret_rune_bg_win.png]")
		else
			player_rune_test_tables[name] = nil
			minetest.after(0.5,minetest.show_formspec,name, "default:secret_runes_win", "size[15,15;]image[1,1;15,15;secret_rune_bg_loose.png]")
		end
	end
end
local function secret_runes_test(name)
	if get_rune_riddle_solved(name) then
			local p = minetest.get_player_by_name(name)
			if p and not get_melkor_spawned() then
			minetest.after(3,minetest.add_entity,p:getpos(),"melkor:melkor")
			end
		return
	end
	player_rune_test_tables[name]=create_combined_words_test_collection()
	test_step(name)
end
minetest.register_tool("default:melkor_spawn_stave", {
	description = "magical stave to get melkor out of prison to kill him",
	inventory_image = "magic_stick_melkorporter.png",
	range = 0,
	on_use = function(itemstack, user)
		secret_runes_test(user:get_player_name())
	end
})
minetest.register_tool("default:grond", {
	description = "grond",
	inventory_image = "grond.png",
	range = 6,
	on_use = function(itemstack, user,pointed_thing)
		if pointed_thing then
			local explosion_pos = false
			if pointed_thing.type == "node" then
				explosion_pos = pointed_thing.above
			elseif pointed_thing.type == "object" then
				explosion_pos = pointed_thing.ref:getpos()
				pointed_thing.ref:set_hp(0)
			end
			if explosion_pos then
				tnt.boom(explosion_pos, {radius = 3,damage_radius = 3,hellish_explosion = true})
			end
		if not is_melkor_killer(user:get_player_name()) then
			user:set_hp(math.max(1,user:get_hp()-2))
		end
		end
	end
})
minetest.register_tool("default:magic_stick_raw", {
	description = "raw magical stick",
	inventory_image = "magic_stick.png",
	range = 0,
	on_use = function(itemstack, user)
		if get_ring_destroyed(user:get_player_name()) and player_is_qualified_for_rune_riddle(user:get_player_name()) then
			minetest.show_formspec(user:get_player_name(),"default:enchanting_a_stave_item_choice_form","size[15,15;]button_exit[1,1;12,1;default:ulmo_teleport_stave;magical stave to get melkor out of prison to kill him]button_exit[1,2;12,1;default:nether_teleport_stave;magical nether teleport stave]button_exit[1,3;12,1;default:ulmo_teleport_stave;magical ulmo teleport stave]button_exit[1,4;12,1;default:underworld_teleport_stave;magical underworld teleport stave]button_exit[1,5;12,1;default:magic_stick_runes_teacher;magical stick that contains a translated rune-text]")
		end
	end
})
minetest.register_tool("default:magic_stick_runes_teacher", {
	description = "magical stick that contains a translated rune-text",
	inventory_image = "magic_stick_runes_teacher.png",
	range = 0,
	on_use = function(itemstack, user)
		minetest.show_formspec(user:get_player_name(),"default:rune_teacher_encrypted_text_form",rune_learning_formspec)
	end
})
minetest.register_tool("default:nether_teleport_stave", {
	description = "magical nether teleport stave",
	inventory_image = "magic_stick_netherporter.png",
	range = 0,
	on_use = function(itemstack, user)
		bones_netherport(user)
	end
})
minetest.register_tool("default:ulmo_teleport_stave", {
	description = "magical ulmo teleport stave",
	inventory_image = "magic_stick_ulmoporter.png",
	range = 0,
	on_use = function(itemstack, user)
		bones_ulmoport_easy(user)
	end
})
minetest.register_tool("default:underworld_teleport_stave", {
	description = "magical underworld teleport stave",
	inventory_image = "magic_stick_underworldporter.png",
	range = 0,
	on_use = function(itemstack, user)
		bones_underworldport(user)
	end
})
minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname == "default:secret_runes_test" then -- This is your form name
		local name = player:get_player_name()
		local qt = "quit"
		local number_string = "1"
		for i,_ in pairs(fields) do
			if string.find(i,"correct") then
				qt = "correct"
				number_string = string.sub(i,8)
			elseif string.find(i,"wrong") then
				qt = "wrong"
				number_string = string.sub(i,6)
			end
		end
		table.remove(player_rune_test_tables[name],tonumber(number_string))
		if qt == "quit" then
			player_rune_test_tables[name] = nil
		else
		if player_rune_test_tables[name].correct == "correct" then
			player_rune_test_tables[name].correct = qt
		end
			test_step(name)
		end
		return true
	elseif formname == "default:enchanting_a_stave_item_choice_form" then
		local item = ItemStack("default:magic_stick_raw")
		for i,_ in pairs(fields) do
			if string.find(i,"default:") then
				item = ItemStack(i)
			end
		end
		player:set_wielded_item(item)
	end
end)
local function create_guard_string(s,p,g)
	local n = p:get_player_name()
	if g and (g.type == "object") then
		g = g.ref:get_luaentity() or {}
		local g = g
		local hp = g.object:get_hp()
		if (n == g.owner_name) and (type(g.worktimer) == "number") and (g.worktimer > 0) and (hp > 0) then
			local meta = s:get_meta()
--[[			meta:set_string("owner_name", g.owner_name)
			meta:set_string("worktimer", tostring(g.worktimer))
			meta:set_string("mob_name", g.name)]]
			meta:set_string("mob_name", g.name)
			meta:set_string("entity_staticdata",g:get_staticdata())
			g.object:remove()
			s:set_name("default:magic_whistle_used")
			return s
		end
	end
end
minetest.register_craftitem("default:magic_whistle", {
	description = "magic whistle",
	inventory_image = "magic_whistle.png",
	on_use = create_guard_string
})
local function summon_guard(s,p,g)
	if g and (g.type == "node") then
		local meta = s:get_meta()
		--local owner_name = meta:get_string("owner_name")
		--local worktimer = meta:get_string("worktimer")
		local name = meta:get_string("mob_name")
		local static = meta:get_string("entity_staticdata")
		--[[local mob_name = meta:get_string("mob_name")]]
		s:set_name("default:diamond")
		--[[local e= minetest.add_entity(vector.add(g.above,{x=0,y=1,z=0}),mob_name)
		e = e:get_luaentity()
		e.worktimer =tonumber(worktimer)
		e.owner = minetest.get_player_by_name(owner_name)
		minetest.chat_send_all(worktimer)
		e.owner_name = owner_name
		minetest.chat_send_all(owner_name)
		return s]]
		g.above.y = g.above.y+1
		minetest.add_entity(g.above, name, static)
		return s
	end
end
minetest.register_craftitem("default:magic_whistle_used", {
	description = "magic whistle",
	inventory_image = "magic_whistle_used.png",
	on_use = summon_guard
})
local lpp = 14 -- Lines per book's page
local function book_on_use(itemstack, user)
	local player_name = user:get_player_name()
	local data = minetest.deserialize(itemstack:get_metadata())
	local formspec, title, text, owner = "", "", "", player_name
	local page, page_max, lines, string = 1, 1, {}, ""

	if data then
		title = data.title
		text = data.text
		owner = data.owner

		for str in (text .. "\n"):gmatch("([^\n]*)[\n]") do
			lines[#lines+1] = str
		end

		if data.page then
			page = data.page
			page_max = data.page_max

			for i = ((lpp * page) - lpp) + 1, lpp * page do
				if not lines[i] then break end
				string = string .. lines[i] .. "\n"
			end
		end
	end

	if owner == player_name then
		formspec = "size[8,8]" .. default.gui_bg ..
			default.gui_bg_img ..
			"field[0.5,1;7.5,0;title;Title:;" ..
				minetest.formspec_escape(title) .. "]" ..
			"textarea[0.5,1.5;7.5,7;text;Contents:;" ..
				minetest.formspec_escape(text) .. "]" ..
			"button_exit[2.5,7.5;3,1;save;Save]"
	else
		formspec = "size[8,8]" .. default.gui_bg ..
			default.gui_bg_img ..
			"label[0.5,0.5;by " .. owner .. "]" ..
			"tablecolumns[color;text]" ..
			"tableoptions[background=#00000000;highlight=#00000000;border=false]" ..
			"table[0.4,0;7,0.5;title;#FFFF00," .. minetest.formspec_escape(title) .. "]" ..
			"textarea[0.5,1.5;7.5,7;;" ..
				minetest.formspec_escape(string ~= "" and string or text) .. ";]" ..
			"button[2.4,7.6;0.8,0.8;book_prev;<]" ..
			"label[3.2,7.7;Page " .. page .. " of " .. page_max .. "]" ..
			"button[4.9,7.6;0.8,0.8;book_next;>]"
	end

	minetest.show_formspec(player_name, "default:book", formspec)
end
minetest.register_craftitem("default:key", {
	description = "Key",
	inventory_image = "key.png",
})
minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "default:book" then return end
	local inv = player:get_inventory()
	local stack = player:get_wielded_item()

	if fields.save and fields.title ~= "" and fields.text ~= "" then
		local new_stack, data
		if stack:get_name() ~= "default:book_written" then
			local count = stack:get_count()
			if count == 1 then
				stack:set_name("default:book_written")
			else
				stack:set_count(count - 1)
				new_stack = ItemStack("default:book_written")
			end
		else
			data = minetest.deserialize(stack:get_metadata())
		end

		if not data then data = {} end
		data.title = fields.title
		data.text = fields.text
		data.text_len = #data.text
		data.page = 1
		data.page_max = math.ceil((#data.text:gsub("[^\n]", "") + 1) / lpp)
		data.owner = player:get_player_name()
		local data_str = minetest.serialize(data)

		if new_stack then
			new_stack:set_metadata(data_str)
			if inv:room_for_item("main", new_stack) then
				inv:add_item("main", new_stack)
			else
				minetest.add_item(player:getpos(), new_stack)
			end
		else
			stack:set_metadata(data_str)
		end

	elseif fields.book_next or fields.book_prev then
		local data = minetest.deserialize(stack:get_metadata())
		if not data.page then return end

		if fields.book_next then
			data.page = data.page + 1
			if data.page > data.page_max then
				data.page = 1
			end
		else
			data.page = data.page - 1
			if data.page == 0 then
				data.page = data.page_max
			end
		end

		local data_str = minetest.serialize(data)
		stack:set_metadata(data_str)
		book_on_use(stack, player)
	end

	player:set_wielded_item(stack)
end)

minetest.register_craftitem("default:book", {
	description = "Book",
	inventory_image = "default_book.png",
	groups = {book = 1},
	on_use = book_on_use,
})

minetest.register_craftitem("default:book_written", {
	description = "Book With Text",
	inventory_image = "default_book_written.png",
	groups = {book = 1, not_in_creative_inventory = 1},
	stack_max = 1,
	on_use = book_on_use,
})

minetest.register_craft({
	type = "shapeless",
	output = "default:book_written",
	recipe = {"default:book", "default:book_written"}
})

minetest.register_on_craft(function(itemstack, player, old_craft_grid, craft_inv)
	if itemstack:get_name() ~= "default:book_written" then
		return
	end

	local copy = ItemStack("default:book_written")
	local original
	local index
	for i = 1, player:get_inventory():get_size("craft") do
		if old_craft_grid[i]:get_name() == "default:book_written" then
			original = old_craft_grid[i]
			index = i
		end
	end
	if not original then
		return
	end
	local copymeta = original:get_metadata()
	-- copy of the book held by player's mouse cursor
	itemstack:set_metadata(copymeta)
	-- put the book with metadata back in the craft grid
	craft_inv:set_stack("craft", index, original)
end)
minetest.register_craftitem("default:coal_lump", {
	description = "Coal Lump",
	inventory_image = "default_coal_lump.png",
	groups = {coal = 1}
})

minetest.register_craftitem("default:iron_lump", {
	description = "Iron Lump",
	inventory_image = "default_iron_lump.png",
})
--[[minetest.register_craftitem("default:gold_and_copper_lump", {
	description = "Gold and Copper",
	inventory_image = "goldgcopper.png",
})]]
minetest.register_craftitem("default:copper_lump", {
	description = "Copper Lump",
	inventory_image = "default_copper_lump.png",
})
last_one_who_dropped_saurons_ring_name = "\"NOONE\""
minetest.register_craftitem("default:the_one_ring", {
	description = "The One Ring",
	inventory_image = "theonering.png",
	on_drop = function(itemstack, dropper, pos)
		last_one_who_dropped_saurons_ring_name = dropper:get_player_name()
		return minetest.item_drop(itemstack, dropper, pos)
	end
})


minetest.register_craftitem("default:gold_lump", {
	description = "Gold Lump",
	inventory_image = "default_gold_lump.png",
})

minetest.register_craftitem("default:diamond", {
	description = "Diamond",
	inventory_image = "default_diamond.png",
})

minetest.register_craftitem("default:clay_lump", {
	description = "Clay Lump",
	inventory_image = "default_clay_lump.png",
})

minetest.register_craftitem("default:steel_ingot", {
	description = "Steel Ingot",
	inventory_image = "default_steel_ingot.png",
})

minetest.register_craftitem("default:copper_ingot", {
	description = "Copper Ingot",
	inventory_image = "default_copper_ingot.png",
})

minetest.register_craftitem("default:bronze_ingot", {
	description = "Bronze Ingot",
	inventory_image = "default_bronze_ingot.png",
})

minetest.register_craftitem("default:gold_ingot", {
	description = "Gold Ingot",
	inventory_image = "default_gold_ingot.png"
})


minetest.register_craftitem("default:clay_brick", {
	description = "Clay Brick",
	inventory_image = "default_clay_brick.png",
})

minetest.register_craftitem("default:obsidian_shard", {
	description = "Obsidian Shard",
	inventory_image = "default_obsidian_shard.png",
})

minetest.register_craftitem("default:flint", {
	description = "Flint",
	inventory_image = "default_flint.png"
})

