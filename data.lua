local par = ParallelParity
local force_true = par.force_true
--tables for stuff
--#region
par.worlds = {
	["data/biome/_pixel_scenes.xml"] = {
		"data/biome_impl/biome_map.png"
	},
	["data/biome/_pixel_scenes_newgame_plus.xml"] = {
		"data/biome_impl/biome_map_newgame_plus.png"
	},
}

--variable biomes that can be placed during ng+ map gen, this is for temporary NG Plus support wherein i just add the appends for pixel scenes to every variable biome as well as their regular base biome
par.ng_plus_biomescripts = {
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
	return_rifts =			ModSettingGet("parallel_parity.return_rifts") or force_true
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
	["data/entities/buildings/teleport_teleroom.xml"] =						par.settings.portal_fast_travel, --portal to fast-travel room
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