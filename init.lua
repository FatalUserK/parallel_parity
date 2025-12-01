local start = GameGetRealWorldTimeSinceStarted()

--global thingy so other mods can do stuff
ParallelParity = {
	default_map_path = "data/biome_impl/biome_map.png",
	default_pixel_scenes_path = "data/biome/_pixel_scenes.xml",
	settings = {},
	force_true = false --use this to force enable everything for testing purposes
}

local par = ParallelParity
local force_true = par.force_true

---@type nxml
local nxml = dofile_once("mods/parallel_parity/files/nxml.lua")
nxml.error_handler = function() end

--tables for stuff
--#region
par.worlds = {
	["data/biome/_pixel_scenes.xml"] = {
		["data/biome_impl/biome_map.png"] = true
	},
	["data/biome/_pixel_scenes_newgame_plus.xml"] = {
		["data/biome_impl/biome_map_newgame_plus.png"] = true
	},
}

--variable biomes that can be placed during ng+ map gen, this is for temporary NG Plus support wherein i just add the appends for pixel scenes to every variable biome as well as their regular base biome
local ng_plus_biomescripts = {
	"data/scripts/biomes/coalmine_alt.lua",
	"data/scripts/biomes/fungicave.lua",
	"data/scripts/biomes/excavationsite.lua",
	"data/scripts/biomes/snowcave.lua",
	"data/scripts/biomes/snowcastle.lua",
	"data/scripts/biomes/rainforest.lua",
	"data/scripts/biomes/vault.lua",
	"data/scripts/biomes/sandcave.lua",
	"data/scripts/biomes/vault_frozen.lua",
	"data/scripts/biomes/wandcave.lua",
	"data/scripts/biomes/crypt.lua",
	"data/scripts/biomes/tower.lua",
	"data/scripts/biomes/desert.lua",
	"data/scripts/biomes/hills.lua",
	"data/scripts/biomes/orbrooms/orbroom_05.lua",
	"data/scripts/biomes/orbrooms/orbroom_06.lua",
	"data/scripts/biomes/orbrooms/orbroom_07.lua",
	"data/scripts/biomes/pyramid_top.lua",
	"data/scripts/biomes/mountain/mountain_floating_island.lua",
	"data/scripts/biomes/orbrooms/orbroom_02.lua",
	"data/scripts/biomes/orbrooms/orbroom_04.lua",
	"data/scripts/biomes/orbrooms/orbroom_08.lua",
	"data/scripts/biomes/orbrooms/orbroom_09.lua",
	"data/scripts/biomes/orbrooms/orbroom_10.lua",
	"data/scripts/biomes/orbrooms/orbroom_03.lua",
	"data/scripts/biomes/boss_victoryroom.lua",
	"data/scripts/biomes/boss_arena.lua",
} --god i hate the NG+ support its so wretched, when i make it proper, i will probably exile it to its own file when i commit to it


--table used to cache all mod settings and flag stuff like that so i dont have to call ModSettingGet duplicates
par.settings = {
	--General
	general =				ModSettingGet("parallel_parity.general") or force_true,
	visual =				ModSettingGet("parallel_parity.visual") or force_true,
	hidden =				ModSettingGet("parallel_parity.hidden") or force_true,
	fungal_altars =			ModSettingGet("parallel_parity.fungal_altars") or force_true,
	fishing_hut =			ModSettingGet("parallel_parity.fishing_hut") or force_true,
	pyramid_boss =			ModSettingGet("parallel_parity.pyramid_boss") or force_true,
	leviathan =				ModSettingGet("parallel_parity.leviathan") or force_true,
	avarice_diamond =		ModSettingGet("parallel_parity.avarice_diamond") or force_true,
	essence_eaters =		ModSettingGet("parallel_parity.essence_eaters") or force_true,
	music_machines =		ModSettingGet("parallel_parity.music_machines") or force_true,
	evil_eye =				ModSettingGet("parallel_parity.evil_eye") or force_true,


	--Spliced
	lava_lake =				ModSettingGet("parallel_parity.lava_lake") or force_true,
	moons =					ModSettingGet("parallel_parity.moons") or force_true,
	desert_skull =			ModSettingGet("parallel_parity.desert_skull") or force_true,
	kolmi_arena =			ModSettingGet("parallel_parity.kolmi_arena") or force_true,
	tree =					ModSettingGet("parallel_parity.tree") or force_true,
	dark_cave =				ModSettingGet("parallel_parity.dark_cave") or force_true,
	mountain_lake =			ModSettingGet("parallel_parity.mountain_lake") or force_true,
	lake_island =			ModSettingGet("parallel_parity.lake_island") or force_true,
	gourd_room =			ModSettingGet("parallel_parity.gourd_room") or force_true,
	meat_skull =			ModSettingGet("parallel_parity.meat_skull") or force_true,


	--Localised
	fishing_bunkers =		ModSettingGet("parallel_parity.fishing_hut.BUNKERS") or force_true,

	lava_lake_orb =			ModSettingGet("parallel_parity.lava_lake.ORB") or force_true,
	spawn_kolmi =			ModSettingGet("parallel_parity.kolmi_arena.KOLMI") or force_true,
	greed_curse =			ModSettingGet("parallel_parity.tree.GREED") or force_true,
	dark_cave_hp =			ModSettingGet("parallel_parity.dark_cave.HP") or force_true,
	fire_essence =			ModSettingGet("parallel_parity.lake_island.FIRE_ESSENCE") or force_true,
	island_boss =			ModSettingGet("parallel_parity.lake_island.BOSS") or force_true,
	spawn_gourds =			ModSettingGet("parallel_parity.gourd_room.GOURDS") or force_true,



	--Portals
	portal_general =		ModSettingGet("parallel_parity.portals.general") or force_true,
	portal_holy_mountain =	ModSettingGet("parallel_parity.portals.holy_mountain") or force_true,
	portal_fast_travel =	ModSettingGet("parallel_parity.portals.fast_travel") or force_true,
	portal_tower_entrance = ModSettingGet("parallel_parity.portals.tower_entrance") or force_true,
	portal_mountain =		ModSettingGet("parallel_parity.portals.mountain") or force_true,
	portal_skull_island = 	ModSettingGet("parallel_parity.portals.skull_island") or force_true,
	portal_summon =			ModSettingGet("parallel_parity.portals.summon") or force_true,



	--Misc
	ng_plus =				ModSettingGet("parallel_parity.ng_plus") or force_true,
	return_rifts =			ModSettingGet("parallel_parity.return_rifts")
}

par.spliced_pixel_scenes = {
	["data/biome_impl/spliced/lavalake2.xml"] =				par.settings.lava_lake,
	["data/biome_impl/spliced/skull_in_desert.xml"] =		par.settings.lava_lake,
	["data/biome_impl/spliced/boss_arena.xml"] =			par.settings.desert_skull,
	["data/biome_impl/spliced/tree.xml"] =					par.settings.kolmi_arena,
	["data/biome_impl/spliced/watercave.xml"] =				par.settings.tree,
	["data/biome_impl/spliced/mountain_lake.xml"] =			par.settings.dark_cave,
	["data/biome_impl/spliced/lake_statue.xml"] =			par.settings.mountain_lake,
	["data/biome_impl/spliced/moon.xml"] =					par.settings.lake_island,
	["data/biome_impl/spliced/moon_dark.xml"] =				par.settings.moons,
	["data/biome_impl/spliced/lavalake_pit_bottom.xml"] =	par.settings.moons,
	["data/biome_impl/spliced/gourd_room.xml"] =			par.settings.gourd_room,
	["data/biome_impl/spliced/skull.xml"] =					par.settings.meat_skull,
}


par.pixel_scenes = {
	--materials
	["data/biome_impl/temple/altar_vault_capsule.png"] =			par.settings.general,
	["data/biome_impl/temple/altar_snowcastle_capsule.png"] =		par.settings.general,
	["data/biome_impl/tower_start.png"] =							par.settings.general,
	["data/biome_impl/the_end/the_end_shop.png"] =					par.settings.general,
	["data/biome_impl/overworld/desert_ruins_base_01.png"] =		par.settings.general,
	["data/biome_impl/snowcastle/forge.png"] =						par.settings.general,
	["data/biome_impl/temple/altar_snowcave_capsule.png"] =			par.settings.general,
	["data/biome_impl/huussi.png"] =								par.settings.general,

	["data/biome_impl/overworld/essence_altar.png"] =				par.settings.essence_eaters,
	["data/biome_impl/overworld/essence_altar_desert.png"] =		par.settings.essence_eaters,

	["data/biome_impl/overworld/snowy_ruins_eye_pillar.png"] =		par.settings.fungal_altars,
	["data/biome_impl/rainbow_cloud.png"] =							par.settings.fungal_altars,
	["data/biome_impl/eyespot.png"] =								par.settings.fungal_altars,

	["data/biome_impl/fishing_hut.png"] =							par.settings.fishing_hut,
	["data/biome_impl/bunker.png"] =								par.settings.fishing_hut and par.settings.fishing_bunkers, --requires fishing hut to exist as a prerequisite
	["data/biome_impl/bunker2.png"] =								par.settings.fishing_hut and par.settings.fishing_bunkers,

	["data/biome_impl/pyramid/boss_limbs.png"] =					par.settings.pyramid_boss,
	["data/biome_impl/greed_treasure.png"] =						par.settings.avarice_diamond,
	["data/biome_impl/overworld/essence_altar"] =					par.settings.essence_eaters,
	["data/biome_impl/overworld/cliff.png"] =						par.settings.music_machines,
	["data/biome_impl/overworld/music_machine_stand.png"] =			par.settings.music_machines,

	--backgrounds
	--hidden backgrounds are for hidden messages, more info: https://noita.wiki.gg/wiki/Game_Lore#Secret_Messages
	["data/biome_impl/hidden/boss_arena.png"] =						par.settings.visual,
	["data/biome_impl/hidden/boss_arena_under.png"] =				par.settings.visual,
	["data/biome_impl/hidden/boss_arena_under_right.png"] =			par.settings.visual,
	["data/biome_impl/hidden/completely_random.png"] =				par.settings.visual,
	["data/biome_impl/hidden/completely_random_2.png"] =			par.settings.visual,
	["data/biome_impl/hidden/fungal_caverns_1.png"] =				par.settings.visual,
	["data/biome_impl/hidden/holy_mountain_1.png"] =				par.settings.visual,
	["data/biome_impl/hidden/jungle_right.png"] =					par.settings.visual,
	["data/biome_impl/hidden/mountain_text.png"] =					par.settings.visual,
	["data/biome_impl/hidden/under_the_wand_cave.png"] =			par.settings.visual,
	["data/biome_impl/hidden/vault_inside.png"] =					par.settings.visual,
	["data/biome_impl/hidden/crypt_left.png"] =						par.settings.visual,

	["data/biome_impl/liquidcave/liquidcave_corner.png"] =			par.settings.visual,
	["data/biome_impl/liquidcave/liquidcave_top.png"] =				par.settings.visual,
	["data/biome_impl/liquidcave/liquidcave_corner2.png"] =			par.settings.visual,


	--entities
	["data/entities/misc/platform_wide.xml"] =						par.settings.fungal_altars,
	["data/entities/buildings/eyespot_a.xml"] =						par.settings.fungal_altars,
	["data/entities/buildings/eyespot_b.xml"] =						par.settings.fungal_altars,
	["data/entities/buildings/eyespot_c.xml"] =						par.settings.fungal_altars,
	["data/entities/buildings/eyespot_d.xml"] =						par.settings.fungal_altars,
	["data/entities/buildings/eyespot_e.xml"] =						par.settings.fungal_altars,
	["data/entities/items/books/book_hint.xml"] =					par.settings.fungal_altars,

	["data/entities/props/physics_fungus.xml"] =					par.settings.tree,
	["data/entities/props/physics_fungus_big.xml"] =				par.settings.tree,
	["data/entities/props/physics_fungus_small.xml"] =				par.settings.tree,

	["data/entities/props/music_machines/music_machine_00.xml"] = 	par.settings.music_machines,
	["data/entities/props/music_machines/music_machine_01.xml"] = 	par.settings.music_machines,
	["data/entities/props/music_machines/music_machine_02.xml"] = 	par.settings.music_machines,
	["data/entities/props/music_machines/music_machine_03.xml"] = 	par.settings.music_machines,

	["data/entities/props/physics/bridge_spawner.xml"] =			par.settings.lava_lake,
	["data/entities/buildings/essence_eater.xml"] =					par.settings.essence_eaters,
	["data/entities/buildings/hut_check.xml"] =						par.settings.fishing_bunkers,
	["data/entities/buildings/maggotspot.xml"] =					par.settings.meat_skull, --Tiny boss spawn
	["data/entities/animals/boss_fish/fish_giga.xml"] =				par.settings.leviathan,
	["data/entities/items/pickup/evil_eye.xml"] =					par.settings.evil_eye, --Paha Silma pedestal to left of Tree
}


par.portals = {
	["data/entities/buildings/teleport_bunker.xml"] =						par.settings.portal_general, --fishing bunker
	["data/entities/buildings/teleport_bunker_back.xml"] =					par.settings.portal_general, --fishing bunker
	["data/entities/buildings/teleport_bunker2.xml"] =						par.settings.portal_general, --fishing bunker
	["data/entities/buildings/teleport_meditation_cube.xml"] =				par.settings.portal_general,
	["data/entities/buildings/teleport_meditation_cube_return.xml"] =		par.settings.portal_general,
	["data/entities/buildings/teleport_snowcave_buried_eye.xml"] =			par.settings.portal_general,
	["data/entities/buildings/teleport_snowcave_buried_eye_return.xml"] =	par.settings.portal_general,
	["data/entities/buildings/teleport_hourglass.xml"] =					par.settings.portal_general,
	["data/entities/buildings/teleport_hourglass_return.xml"] =				par.settings.portal_general,
	["data/entities/buildings/teleport_ending_victory.xml"] =				par.settings.portal_general, --kolmi death portal
	["data/entities/buildings/teleport_start.xml"] =						par.settings.portal_general, --greed curse return portal
	["data/entities/buildings/teleport_liquid_powered.xml"] =				par.settings.portal_holy_mountain, --holy mountain portal
	["data/entities/buildings/teleport_ending.xml"] =						par.settings.portal_holy_mountain, --final holy mountain portal
	["data/entities/buildings/teleport_teleroom.xml"] =						par.settings.portal_fast_travel, --fast travel portal room and co
	["data/entities/buildings/teleport_teleroom_1.xml"] =					par.settings.portal_fast_travel,
	["data/entities/buildings/teleport_teleroom_2.xml"] =					par.settings.portal_fast_travel,
	["data/entities/buildings/teleport_teleroom_3.xml"] =					par.settings.portal_fast_travel,
	["data/entities/buildings/teleport_teleroom_4.xml"] =					par.settings.portal_fast_travel,
	["data/entities/buildings/teleport_teleroom_5.xml"] =					par.settings.portal_fast_travel,
	["data/entities/buildings/teleport_teleroom_6.xml"] =					par.settings.portal_fast_travel,
	["data/entities/buildings/mystery_teleport.xml"] =						par.settings.portal_tower_entrance,
	["data/entities/buildings/mystery_teleport_back.xml"] =					par.settings.portal_mountain, --tower exit + musical curiosity
	["data/entities/buildings/teleport_lake.xml"] =							par.settings.portal_skull_island, --teleport to lake
	["data/entities/buildings/teleport_desert.xml"] =						par.settings.portal_skull_island, --teleport to desert
	["data/entities/projectiles/deck/summon_portal_teleport.xml"] =			par.settings.portal_summon, --EoE portal in underground jungle
	["data/entities/buildings/teleport_robot_egg_return.xml"] =				par.settings.portal_summon, --EoE return portal
}

par.localise = {
	["data/scripts/biomes/lake_statue.lua"] = {
		par.settings.lake_island and not par.settings.island_boss and {
			[[EntityLoad( "data/entities/animals/boss_spirit/spawner.xml", x, y )]],
		} or nil,
		par.settings.lake_island and not par.settings.fire_essence and {
			[[EntityLoad( "data/entities/items/pickup/essence_fire.xml", x, y )]],
		} or nil,
	},
	["data/scripts/biomes/lake.lua"] = {
		par.settings.fishing_hut and not par.settings.fishing_bunkers and {
			[[EntityLoad( "data/entities/buildings/bunker.xml", x, y )]],
			[[EntityLoad( "data/entities/buildings/bunker2.xml", x, y )]],
		} or nil,
	},
	["data/scripts/biomes/lavalake.lua"] = {
		par.settings.lava_lake and not par.settings.lava_lake_orb and {
			[[EntityLoad( "data/entities/items/orbs/orb_03.xml", x-10, y )]],
		} or nil,
	},
	["data/scripts/biomes/boss_arena.lua"] = {
		par.settings.kolmi_arena and not par.settings.spawn_kolmi and {
			[[EntityLoad( "data/entities/animals/boss_centipede/boss_music_buildup_trigger.xml", x, y )]],
			[[EntityLoad( "data/entities/animals/boss_centipede/boss_centipede.xml", x, y )
	-- if game is not completed
	if( GameHasFlagRun( "ending_game_completed" ) == false ) then
		EntityLoad( "data/entities/animals/boss_centipede/sampo.xml", x, y + 80 )
	end

	EntityLoad( "data/entities/animals/boss_centipede/reference_point.xml", x, y )]],
		} or nil,
	},
	["data/scripts/biomes/mountain_tree.lua"] = {
		par.settings.tree and not par.settings.greed_curse and {
			[[EntityLoad( "data/entities/items/pickup/greed_curse.xml", x, y )]],
		} or nil,
	},
	["data/scripts/biomes/watercave.lua"] = {
		par.settings.dark_cave and not par.settings.dark_cave_hp and {
			[[EntityLoad( "data/entities/items/pickup/heart.xml", x, y )]],
			[[EntityLoad( "data/entities/items/pickup/heart_fullhp.xml", x, y )]],
		} or nil,
	},
	["data/scripts/biomes/gourd_room.lua"] = {
		par.settings.gourd_room and not par.settings.spawn_gourds and {
			[[EntityLoad( "data/entities/items/pickup/gourd.xml", x, y )
	EntityLoad( "data/entities/items/pickup/gourd.xml", x - 12, y )
	EntityLoad( "data/entities/items/pickup/gourd.xml", x + 12, y )
	EntityLoad( "data/entities/items/pickup/gourd.xml", x, y - 12 )
	EntityLoad( "data/entities/items/pickup/gourd.xml", x - 12, y )
	EntityLoad( "data/entities/animals/shotgunner.xml", x + 24, y - 24 )]],
		} or nil,
	},
}
--#endregion


--convenient functions
--#region

local function escape(str) return str:gsub("[%(%)%.%%%+%-%*%?%[%^%$%]]", "%%%1") end

string.modify = function(s, pattern, repl)
	return s:gsub(escape(pattern), repl)
end

local function dump(o) --handy func i stole that prints an entire table
	if type(o) == 'table' then
		local s = '{ '
		for k,v in pairs(o) do
			if type(k) ~= 'number' then k = '"'..k..'"' end
			s = s .. '['..k..'] = ' .. dump(v) .. ','
		end
		return s .. '} '
	else
		return tostring(o)
	end
end

local biome_scripts = {}
--get biomescript from biomexml. note: maybe merge with MapGetBiomeScript() at some point
local function GetBiomeScript(biomepath, generate)
	local biomexml = nxml.parse(ModTextFileGetContent(biomepath))

	if not biome_scripts[biomepath] then
		local toplogy = biomexml and biomexml:first_of("Topology")
		if toplogy then
			local script = toplogy.attr.lua_script
			if generate and script == nil then
				local filename
				for str in string.gmatch(biomepath, "([^".."/".."]+)") do --i stole the gmatch string i still dont get string patterns 😭
					filename = str
				end
				local generated_script_path = ("mods/parallel_parity/files/biomescripts/") .. filename:sub(1, -4) .. "lua"
				ModTextFileSetContent(generated_script_path, "") --yknow itd be really funny if i could just append empty nothingness and have that work without needing to make an entire script
				toplogy.attr.lua_script = generated_script_path
			end
			biome_scripts[biomepath] = toplogy.attr.lua_script
		end
	end

	return biome_scripts[biomepath]
end

--get biomescript from chunk coordinate
local function MapGetBiomeScript(biome_map, chunk_pos_x, chunk_pos_y)
	local mdata = par.cached_maps[biome_map]

	local map_pos_x = (chunk_pos_x + (mdata.w * .5))

	local map_pos_y = chunk_pos_y + 14
	map_pos_y = math.max(map_pos_y, 0)
	map_pos_y = math.min(map_pos_y, mdata.h - 1)

	local abgr_int = ModImageGetPixel(mdata.map, map_pos_x, map_pos_y) --get pixel colour as ABGR integer
	local hex = ("%02x%02x%02x"):format(bit.band(abgr_int, 0xFF), bit.band(bit.rshift(abgr_int, 8), 0xFF), bit.band(bit.rshift(abgr_int, 16), 0xFF)) --convert it to something sane
	if hex == "000000" then return nil end
	return GetBiomeScript(par.biomelist[hex], true)
end
--#endregion



--automatically cache important map data
par.cached_maps = {}
for _, biome_maps in pairs(par.worlds) do
	for biome_map, _ in pairs(biome_maps) do
		if not par.cached_maps[biome_map] then
			par.cached_maps[biome_map] = {}
			par.cached_maps[biome_map].map, par.cached_maps[biome_map].w, par.cached_maps[biome_map].h = ModImageMakeEditable(biome_map, 0, 0)
		end
	end
end


function OnModPreInit() --do misc stuff on mod preinit so other mods can append without mod load order issues
	do_mod_appends("mods/parallel_parity/init.lua")

	ModTextFileSetContent("data/translations/common.csv",
		(ModTextFileGetContent("data/translations/common.csv") .. "\n" ..
		ModTextFileGetContent("mods/parallel_parity/standard.csv") .. "\n")
			:gsub("\r", "")
			:gsub("\n\n+", "\n"
		)
	)

	--special behaviour
	--#region

	--EoE Summoned Portal location and related hints in Underground Jungle
	if par.settings.portal_summon then
		local summon_portal_biomes = {
			"data/scripts/biomes/rainforest.lua",
			"data/scripts/biomes/fungicave.lua",
		}

		for _, path in ipairs(summon_portal_biomes) do --statues and portal spot
			ModTextFileSetContent(path, ModTextFileGetContent(path
				):modify(
					"function init(x, y, w, h)",
					"function init(x, y, w, h)\n	local pw_offset = GetParallelWorldPosition(x, 0) * BiomeMapGetSize() * 512"
				):modify(
					"local function is_inside_tile(pos_x, pos_y)",
					"local function is_inside_tile(pos_x, pos_y)\n		pos_x = pos_x + pw_offset"
				):modify(
					"EntityLoad( \"data/entities/misc/summon_portal_target.xml\", portal_x, portal_y )",
					"EntityLoad( \"data/entities/misc/summon_portal_target.xml\", portal_x + pw_offset, portal_y )"
				):modify(
					"local function spawn_statue(statue_num, spawn_x, spawn_y, ray_dir_x, ray_dir_y)",
					"local function spawn_statue(statue_num, spawn_x, spawn_y, ray_dir_x, ray_dir_y)\n		spawn_x = spawn_x + pw_offset"
				)
			)
		end


		local get_portal_position_targets = {
			"data/scripts/buildings/teleport_robot_egg_return.lua",
			"data/scripts/projectiles/summon_portal_position_check.lua",
		}

		for _, path in ipairs(get_portal_position_targets) do
			ModTextFileSetContent(path, ModTextFileGetContent(path):modify("local portal_x, portal_y = get_portal_position()",
	[[local portal_x, portal_y = get_portal_position()
	do
		local x,y = EntityGetTransform(GetUpdatedEntityID())
		portal_x = portal_x + (GetParallelWorldPosition(x,y) * BiomeMapGetSize() * 512)
	end]]))
		end
	end
	--#endregion


	--Special Main-World Localisation

	for path, biome in pairs(par.localise) do
		for _, targets in ipairs(biome) do
			for _, code in ipairs(targets) do
				ModTextFileSetContent(path, ModTextFileGetContent(path):modify(code, "if GetParallelWorldPosition(x, y) == 0 then " .. code .. " end;"))
			end
		end
	end


	-- Parallel Portals

	for path, value in pairs(par.portals) do
		if value then
			for portal in nxml.edit_file(path) do
				portal:add_child(nxml.new_element("LuaComponent", {
					script_source_file = "mods/parallel_parity/files/parallel_portals.lua",
					execute_on_added = true,
					remove_after_executed = true,
				}))
			end
		end
	end

	if par.settings.return_rifts then dofile("mods/parallel_parity/files/return_rift/return_rifts_init.lua") end
end


function OnMagicNumbersAndWorldSeedInitialized()
	par.biomelist = {} --list of every biome
	local biomelist_xml = nxml.parse(ModTextFileGetContent("data/biome/_biomes_all.xml")) --create hex-indexed table for all biomes that exist
	if biomelist_xml then
		for elem in biomelist_xml:each_child() do par.biomelist[(elem.attr.color):lower():sub(3,-1)] = elem.attr.biome_filename end
	else
		print("could not find \"data/biome/_biomes_all.xml\", fuck.")
	end


	--Scraper
	--#region
	local biome_appends = {}
	for pixel_scenes_path, biome_maps in pairs(par.worlds) do
		local pixel_scenes_xml = nxml.parse(ModTextFileGetContent(pixel_scenes_path))

		local ps_data = {
			spliced = pixel_scenes_xml:first_of("PixelSceneFiles"),
			backgrounds = pixel_scenes_xml:first_of("BackgroundImages"),
			scenes = pixel_scenes_xml:first_of("mBufferedPixelScenes"),
		}

		local remove_list = { --create remove list to cull target objects outside the world boundry
			--spliced = {}, dont check for spliced ones cuz vanilla doesnt do this and i dont wanna have to think about this until some maniac actually does this
			backgrounds = {},
			scenes = {},
		}

		for sps in ps_data.spliced:each_child() do
			local sps_filepath = ""
			for i = 1, #sps.content, 1 do
				sps_filepath = sps_filepath .. sps.content[i] --get the filepath to the spliced pixel scene xml by building it from the content, idk nolla is weird.
			end

			if par.spliced_pixel_scenes[sps_filepath] then --check if pixel scene is flagged
				if ModDoesFileExist(sps_filepath) then
					local sps_xml = nxml.parse(ModTextFileGetContent(sps_filepath))
					if sps_xml and sps_xml.children[1] then --this should generally just be one singular mBufferedPixelScenes component. if theres more than one child in the file then i feel i cant really be blamed for the lunacy of other modders
						for chunk in sps_xml.children[1]:each_child() do
							local chunk_pos_x = math.floor(chunk.attr.pos_x * 0.001953125) --i heard somewhere multiplication is more efficient than dividing so i hope thats true
							local chunk_pos_y = math.floor(chunk.attr.pos_y * 0.001953125)

							for biome_map, _ in pairs(biome_maps) do
								local biomescript = MapGetBiomeScript(biome_map, chunk_pos_x, chunk_pos_y)

								if biomescript ~= nil then --definitely SHOULD NOT be nil
									local map_scene_index = pixel_scenes_path .. par.cached_maps[biome_map].w

									local chunk_key = chunk_pos_x .. "_" .. chunk_pos_y --hehe chunky
									--ng plus support code is temporary, I eventually wanna add special handling that predicts future permutations of the NG+ biome map and appends pixel scenes accordingly- even if its a bit overkill, it seems like good tech to have in my back-pocket
									-- [[ NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT
									local skip_scraping = false
									if biome_map == "data/biome_impl/biome_map_newgame_plus.png" then
										if par.settings.ng_plus then
											for _, ng_script in ipairs(ng_plus_biomescripts) do
												if ng_script ~= biomescript then
													biome_appends[ng_script] = biome_appends[ng_script] or {}
													biome_appends[ng_script][map_scene_index] = biome_appends[ng_script][map_scene_index] or {scenes = {}, entities = {}}

													local biome_scene_index = biome_appends[ng_script][map_scene_index]
													biome_scene_index.scenes[chunk_key] = biome_scene_index.scenes[chunk_key] or {}
													biome_scene_index.scenes[chunk_key][#biome_scene_index.scenes[chunk_key] + 1] = {
														materials = chunk.attr.material_filename,
														gfx = chunk.attr.colors_filename,
														background = chunk.attr.background_filename,
														offset_x = chunk.attr.pos_x - (chunk_pos_x * 512),
														offset_y = chunk.attr.pos_y - (chunk_pos_y * 512),
													}
												end
											end
										else
											skip_scraping = true --do this cuz I HATE NG+ WHY DO I NEED TO DO SO MUCH STUPID STUFF JUST TO ACCOUNT FOR IT AAAAAAAAAAAAAAAA
										end
									end--]]-- NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT
									if not skip_scraping then
										biome_appends[biomescript] = biome_appends[biomescript] or {} --make sure biomescript table exists
										biome_appends[biomescript][map_scene_index] = biome_appends[biomescript][map_scene_index] or {scenes = {}, entities = {}} --make sure biomemap table exists

										local biome_scene_index = biome_appends[biomescript][map_scene_index] --shorten to local val so less indexing is required
										biome_scene_index.scenes[chunk_key] = biome_scene_index.scenes[chunk_key] or {} --make sure scene chunk table exists
										biome_scene_index.scenes[chunk_key][#biome_scene_index.scenes[chunk_key] + 1] = { --add to scene chunk table
											materials = chunk.attr.material_filename,
											gfx = chunk.attr.colors_filename,
											background = chunk.attr.background_filename,
											offset_x = chunk.attr.pos_x - (chunk_pos_x * 512),
											offset_y = chunk.attr.pos_y - (chunk_pos_y * 512),
										}
									end
								end
							end
						end
					end
				end
			end
		end

		for bg in ps_data.backgrounds:each_child() do
			if par.pixel_scenes[bg.attr.filename] then
				local chunk_pos_x = math.floor(bg.attr.x * 0.001953125)
				local chunk_pos_y = math.floor(bg.attr.y * 0.001953125)

				for biome_map, _ in pairs(biome_maps) do
					local biomescript = MapGetBiomeScript(biome_map, chunk_pos_x, chunk_pos_y)

					if biomescript ~= nil then
						local map_scene_index = pixel_scenes_path .. par.cached_maps[biome_map].w

						local chunk_key = chunk_pos_x .. "_" .. chunk_pos_y

						-- [[ NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT
						local skip_scraping = false
						if biome_map == "data/biome_impl/biome_map_newgame_plus.png" then
							if par.settings.ng_plus then
								for _, ng_script in ipairs(ng_plus_biomescripts) do
									if ng_script ~= biomescript then
										biome_appends[ng_script] = biome_appends[ng_script] or {}
										biome_appends[ng_script][map_scene_index] = biome_appends[ng_script][map_scene_index] or {scenes = {}, entities = {}}

										local biome_scene_index = biome_appends[ng_script][map_scene_index]
										biome_scene_index.scenes[chunk_key] = biome_scene_index.scenes[chunk_key] or {}
										biome_scene_index.scenes[chunk_key][#biome_scene_index.scenes[chunk_key] + 1] = {
											materials = "",
											gfx = "",
											background = bg.attr.filename, --is background scene so other attributes are unnecessary
											offset_x = bg.attr.x - (chunk_pos_x * 512),
											offset_y = bg.attr.y - (chunk_pos_y * 512),
										}
									end
								end
							else
								skip_scraping = true
							end
						end--]]-- NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT
						if not skip_scraping then
							biome_appends[biomescript] = biome_appends[biomescript] or {}
							biome_appends[biomescript][map_scene_index] = biome_appends[biomescript][map_scene_index] or {scenes = {}, entities = {}}

							local biome_scene_index = biome_appends[biomescript][map_scene_index]
							biome_scene_index.scenes[chunk_key] = biome_scene_index.scenes[chunk_key] or {}
							biome_scene_index.scenes[chunk_key][#biome_scene_index.scenes[chunk_key] + 1] = {
								materials = "",
								gfx = "",
								background = bg.attr.filename, --is background scene so other attributes are unnecessary
								offset_x = bg.attr.x - (chunk_pos_x * 512),
								offset_y = bg.attr.y - (chunk_pos_y * 512),
							}
						end
					else
						remove_list.backgrounds[#remove_list.backgrounds+1] = bg
					end
				end
			end
		end

		for elem in ps_data.scenes:each_child() do


			local file_name = "?"
			for _, value in ipairs({"just_load_an_entity", "material_filename", "colors_filename", "background_filename"}) do
				if elem.attr[value] ~= nil then
					file_name = elem.attr[value] or "false"
					break
				end
			end
			local logging
			if par.pixel_scenes[elem.attr.just_load_an_entity]
					or par.pixel_scenes[elem.attr.material_filename]
					or par.pixel_scenes[elem.attr.colors_filename]
					or par.pixel_scenes[elem.attr.background_filename]
				then

				local chunk_pos_x = math.floor(elem.attr.pos_x * 0.001953125)
				local chunk_pos_y = math.floor(elem.attr.pos_y * 0.001953125)
				if logging then print(elem.attr.pos_x) print(chunk_pos_x) end

				for biome_map, _ in pairs(biome_maps) do
					local biomescript = MapGetBiomeScript(biome_map,chunk_pos_x, chunk_pos_y)
					if logging then print("Biomescript: " .. tostring(biomescript)) end

					if biomescript ~= nil then
						local map_scene_index = pixel_scenes_path .. par.cached_maps[biome_map].w

						local chunk_key = chunk_pos_x .. "_" .. chunk_pos_y
						-- [[ NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT
						local skip_scraping = false
						if biome_map == "data/biome_impl/biome_map_newgame_plus.png" then
							if par.settings.ng_plus then
								for _, ng_script in ipairs(ng_plus_biomescripts) do
									if ng_script ~= biomescript then
										biome_appends[ng_script] = biome_appends[ng_script] or {}
										biome_appends[ng_script][map_scene_index] = biome_appends[ng_script][map_scene_index] or {scenes = {}, entities = {}}
										local biome_scene_index = biome_appends[ng_script][map_scene_index]
										if elem.attr.just_load_an_entity then
											biome_scene_index.entities[chunk_key] = biome_scene_index.entities[chunk_key] or {}
											biome_scene_index.entities[chunk_key][#biome_scene_index.entities[chunk_key] + 1] = {
												path = elem.attr.just_load_an_entity,
												offset_x = elem.attr.pos_x - (chunk_pos_x * 512),
												offset_y = elem.attr.pos_y - (chunk_pos_y * 512),
											}
										else
											biome_scene_index.scenes[chunk_key] = biome_scene_index.scenes[chunk_key] or {}
											biome_scene_index.scenes[chunk_key][#biome_scene_index.scenes[chunk_key] + 1] = {
												materials = elem.attr.material_filename,
												gfx = elem.attr.colors_filename,
												background = elem.attr.background_filename,
												offset_x = elem.attr.pos_x - (chunk_pos_x * 512),
												offset_y = elem.attr.pos_y - (chunk_pos_y * 512),
											}
										end
									end
								end
							else
								skip_scraping = true
							end
						end--]]-- NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT
						if not skip_scraping then
							biome_appends[biomescript] = biome_appends[biomescript] or {}
							biome_appends[biomescript][map_scene_index] = biome_appends[biomescript][map_scene_index] or {scenes = {}, entities = {}}
							local biome_scene_index = biome_appends[biomescript][map_scene_index]
							if elem.attr.just_load_an_entity then
								biome_scene_index.entities[chunk_key] = biome_scene_index.entities[chunk_key] or {}
								biome_scene_index.entities[chunk_key][#biome_scene_index.entities[chunk_key] + 1] = {
									path = elem.attr.just_load_an_entity,
									offset_x = elem.attr.pos_x - (chunk_pos_x * 512),
									offset_y = elem.attr.pos_y - (chunk_pos_y * 512),
								}
							else
								biome_scene_index.scenes[chunk_key] = biome_scene_index.scenes[chunk_key] or {}
								biome_scene_index.scenes[chunk_key][#biome_scene_index.scenes[chunk_key] + 1] = {
									materials = elem.attr.material_filename,
									gfx = elem.attr.colors_filename,
									background = elem.attr.background_filename,
									offset_x = elem.attr.pos_x - (chunk_pos_x * 512),
									offset_y = elem.attr.pos_y - (chunk_pos_y * 512),
								}
							end
							if logging then print("adding " .. file_name .. " to " .. biomescript .. " at chunk " .. chunk_key) end
						end
					else
						if logging then print("added to remove list...") end
						remove_list.scenes[#remove_list.scenes+1] = elem
					end
				end
			end
		end

		for target, remove in pairs(remove_list) do
			for _, scene in ipairs(remove) do
				ps_data[target]:remove_child(scene) --remove spliced pixel scenes from file
			end
		end
		ModTextFileSetContent(pixel_scenes_path, tostring(pixel_scenes_xml)) --apply changes to file
	end
	--#endregion


	--Compiler
	--#region
	for script_path, biome in pairs(biome_appends) do
		local table_insert = ""
		for map_index, chunk_index in pairs(biome) do
			table_insert = table_insert .. "	[\"" .. map_index .. "\"] = {\n		scenes = {\n"
			for key, chunk in pairs(chunk_index.scenes) do
				table_insert = table_insert .. "			[\"".. key .."\"] = {\n"
				for _, scene in ipairs(chunk) do
					if scene.materials == "" then scene.materials = "mods/parallel_parity/files/nil_materials.png" end
					table_insert = table_insert .. ([[				{
						materials = "%s",
						gfx = "%s",
						background = "%s",
						offset_x = "%s",
						offset_y = "%s",
					},
	]]):format(scene.materials, scene.gfx, scene.background, scene.offset_x, scene.offset_y)
				end
				table_insert = table_insert .. "			},\n"
			end
			table_insert = table_insert .. "		},\n"

			table_insert = table_insert .. "		entities = {\n"
			for key, chunk in pairs(chunk_index.entities) do
				--do break end
				table_insert = table_insert .. "			[\"".. key .."\"] = {\n"
				for _, entity in ipairs(chunk) do
					table_insert = table_insert .. ([[				{
						path = "%s",
						offset_x = "%s",
						offset_y = "%s",
					},
	]]):format(entity.path, entity.offset_x, entity.offset_y)
				end
				table_insert = table_insert .. "			},\n"
			end
			table_insert = table_insert .. "		},\n	},\n"
		end
		local append_path = "mods/parallel_parity/generated/biome_appends/" .. script_path
		ModTextFileSetContent(append_path, ModTextFileGetContent("mods/parallel_parity/files/template_append.lua"):modify("--PARALLEL APPEND HERE!", table_insert):modify("FILENAMEHERE", script_path))
		ModLuaFileAppend(script_path, append_path)

		local script = ModTextFileGetContent(script_path)
		if not script:find("--RSF DOCUMENTED") then ModTextFileSetContent(script_path, ModTextFileGetContent("mods/parallel_parity/files/rsf_script_prepend.lua") .. script) end
	end
	--#endregion
end

print("Parallel Parity init: " .. GameGetRealWorldTimeSinceStarted()-start)

return --block appends from running at end of file