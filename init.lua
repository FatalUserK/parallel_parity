local start = GameGetRealWorldTimeSinceStarted()

--global thingy so other mods can do stuff
ParallelParity = {
    default_map_path = "data/biome_impl/biome_map.png",
    default_pixel_scenes_path = "data/biome/_pixel_scenes.xml",
    settings = {},
    force_true = true --use this to force enable everything for testing purposes
}

local par = ParallelParity
local settings = par.settings
local force_true = par.force_true


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
} --god i hate the NG+ support its so wretched, when i make it proper, i will probably exile it to its own file

--list of relevant biome scripts using biome xml as index key, vanilla biomescript data is pregenerated under the assumption surely no one would go out their way to alter the filepath of vanilla biomescripts.
--Will probably empty the list if I run into a situation where someone does indeed altar the base-game biome script paths
par.biome_scripts = {
    ["data/biome/mountain_left_3.xml"] = "data/scripts/biomes/mountain/mountain_left_3.lua",
    ["data/biome/pyramid_left.xml"] = "data/scripts/biomes/pyramid_left.lua",
    ["data/biome/lava.xml"] = "data/scripts/biomes/hills.lua",
    ["data/biome/mestari_secret.xml"] = "data/scripts/biomes/mestari_secret.lua",
    ["data/biome/the_sky.xml"] = "data/scripts/biomes/the_end.lua",
    ["data/biome/null_room.xml"] = "data/scripts/biomes/null_room.lua",
    ["data/biome/laboratory.xml"] = "data/scripts/biomes/laboratory.lua",
    ["data/biome/lake_blood.xml"] = "data/scripts/biomes/lake.lua",
    ["data/biome/gun_room.xml"] = "data/scripts/biomes/gun_room.lua",
    ["data/biome/secret_lab.xml"] = "data/scripts/biomes/secret_lab.lua",
    ["data/biome/desert.xml"] = "data/scripts/biomes/desert.lua",
    ["data/biome/boss_arena.xml"] = "data/scripts/biomes/boss_arena.lua",
    ["data/biome_impl/static_tile/biome_barren.xml"] = "data/biome_impl/static_tile/temples_common.lua",
    ["data/biome/tower/solid_wall_tower_10.xml"] = "data/scripts/biomes/tower_end.lua",
    ["data/biome/clouds.xml"] = "data/scripts/biomes/clouds.lua",
    ["data/biome/snowcave_tunnel.xml"] = "data/scripts/biomes/snowcave.lua",
    ["data/biome/lake_deep.xml"] = "data/scripts/biomes/lake_deep.lua",
    ["data/biome/temple_altar_right_snowcave.xml"] = "data/scripts/biomes/temple_altar_right_snowcave.lua",
    ["data/biome/mountain_right_entrance.xml"] = "data/scripts/biomes/mountain/mountain_right_entrance.lua",
    ["data/biome/gourd_room.xml"] = "data/scripts/biomes/gourd_room.lua",
    ["data/biome/empty.xml"] = "data/scripts/biomes/hills.lua",
    ["data/biome/essenceroom_hell.xml"] = "data/scripts/biomes/essenceroom_hell.lua",
    ["data/biome/solid_wall_damage.xml"] = "data/scripts/biomes/solid_wall_tower.lua",
    ["data/biome/pyramid_top.xml"] = "data/scripts/biomes/pyramid_top.lua",
    ["data/biome/forest.xml"] = "data/scripts/biomes/hills.lua",
    ["data/biome/snowcastle_cavern.xml"] = "data/scripts/biomes/snowcastle_cavern.lua",
    ["data/biome/excavationsite.xml"] = "data/scripts/biomes/excavationsite.lua",
    ["data/biome_impl/static_tile/biome_darkness.xml"] = "data/biome_impl/static_tile/temples_common.lua",
    ["data/biome/temple_altar_right_snowcastle.xml"] = "data/scripts/biomes/temple_altar_right_snowcastle.lua",
    ["data/biome/hills2.xml"] = "data/scripts/biomes/hills.lua",
    ["data/biome/rock_room.xml"] = "data/scripts/biomes/rock_room.lua",
    ["data/biome/pyramid_hallway.xml"] = "data/scripts/biomes/pyramid_hallway.lua",
    ["data/biome/pyramid.xml"] = "data/scripts/biomes/pyramid.lua",
    ["data/biome/smokecave_middle.xml"] = "data/scripts/biomes/smokecave_middle.lua",
    ["data/biome/roadblock.xml"] = "data/scripts/biomes/roadblock.lua",
    ["data/biome/temple_altar_secret.xml"] = "data/scripts/biomes/temple_altar_secret.lua",
    ["data/biome/robobase.xml"] = "data/scripts/biomes/robobase.lua",
    ["data/biome/lavalake.xml"] = "data/scripts/biomes/lavalake.lua",
    ["data/biome/vault.xml"] = "data/scripts/biomes/vault.lua",
    ["data/biome/lava_90percent.xml"] = "data/scripts/biomes/hills.lua",
    ["data/biome/niilo_testroom_b.xml"] = "data/scripts/biomes/niilo_testroom_b.lua",
    ["data/biome/smokecave_right.xml"] = "data/scripts/biomes/smokecave_right.lua",
    ["data/biome/magic_gate.xml"] = "data/scripts/biomes/magic_gate.lua",
    ["data/biome/mountain_hall_trailer.xml"] = "data/scripts/biomes/mountain/trailer/mountain_hall.lua",
    ["data/biome/rainforest_open.xml"] = "data/scripts/biomes/rainforest.lua",
    ["data/biome/ghost_secret.xml"] = "data/scripts/biomes/ghost_secret.lua",
    ["data/biome/snowcave_secret_chamber.xml"] = "data/scripts/biomes/snowcave_secret_chamber.lua",
    ["data/biome/friend_1.xml"] = "data/scripts/biomes/friend_1.lua",
    ["data/biome/lake_statue.xml"] = "data/scripts/biomes/lake_statue.lua",
    ["data/biome/funroom.xml"] = "data/scripts/biomes/funroom.lua",
    ["data/biome/winter_caves.xml"] = "data/scripts/biomes/winter.lua",
    ["data/biome/tower/solid_wall_tower.xml"] = "data/scripts/biomes/solid_wall_tower.lua",
    ["data/biome/mountain_left_entrance.xml"] = "data/scripts/biomes/mountain/mountain_left_entrance.lua",
    ["data/biome/essenceroom.xml"] = "data/scripts/biomes/essenceroom.lua",
    ["data/biome/bridge.xml"] = "data/scripts/biomes/bridge.lua",
    ["data/biome/moon_room.xml"] = "data/scripts/biomes/moon_room.lua",
    ["data/biome/fungicave.xml"] = "data/scripts/biomes/fungicave.lua",
    ["data/biome/temple_altar.xml"] = "data/scripts/biomes/temple_altar.lua",
    ["data/biome/mountain_tree.xml"] = "data/scripts/biomes/mountain_tree.lua",
    ["data/biome/rainforest.xml"] = "data/scripts/biomes/rainforest.lua",
    ["data/biome/wizardcave.xml"] = "data/scripts/biomes/wizardcave.lua",
    ["data/biome/hills_flat.xml"] = "data/scripts/biomes/hills.lua",
    ["data/biome/snowcastle_hourglass_chamber.xml"] = "data/scripts/biomes/snowcastle_hourglass_chamber.lua",
    ["data/biome/mountain_right_stub.xml"] = "data/scripts/biomes/mountain/mountain_right_stub.lua",
    ["data/biome/town_under.xml"] = "data/scripts/biomes/town.lua",
    ["data/biome_impl/static_tile/biome_boss_sky.xml"] = "data/biome_impl/static_tile/temples_common.lua",
    ["data/biome/temple_altar_left.xml"] = "data/scripts/biomes/temple_altar_left.lua",
    ["data/biome_impl/static_tile/biome_potion_mimics.xml"] = "data/biome_impl/static_tile/temples_common.lua",
    ["data/biome_impl/static_tile/biome_watchtower.xml"] = "data/biome_impl/static_tile/watchtower.lua",
    ["data/biome/wandcave.xml"] = "data/scripts/biomes/wandcave.lua",
    ["data/biome/boss_arena_top.xml"] = "data/scripts/biomes/boss_arena_top.lua",
    ["data/biome/fungiforest.xml"] = "data/scripts/biomes/fungiforest.lua",
    ["data/biome/meat.xml"] = "data/scripts/biomes/meat.lua",
    ["data/biome/lavalake_pit.xml"] = "data/scripts/biomes/lavalake_pit.lua",
    ["data/biome/mountain_hall_2.xml"] = "data/scripts/biomes/mountain/mountain_hall_2.lua",
    ["data/biome/friend_6.xml"] = "data/scripts/biomes/friend_6.lua",
    ["data/biome/friend_5.xml"] = "data/scripts/biomes/friend_5.lua",
    ["data/biome/sandcave.xml"] = "data/scripts/biomes/sandcave.lua",
    ["data/biome/friend_4.xml"] = "data/scripts/biomes/friend_4.lua",
    ["data/biome/friend_3.xml"] = "data/scripts/biomes/friend_3.lua",
    ["data/biome/friend_2.xml"] = "data/scripts/biomes/friend_2.lua",
    ["data/biome/ending_placeholder.xml"] = "data/scripts/biomes/ending_placeholder.lua",
    ["data/biome/meatroom.xml"] = "data/scripts/biomes/meatroom.lua",
    ["data/biome/roboroom.xml"] = "data/scripts/biomes/roboroom.lua",
    ["data/biome/rainforest_dark.xml"] = "data/scripts/biomes/rainforest_dark.lua",
    ["data/biome/tower/solid_wall_tower_8.xml"] = "data/scripts/biomes/tower.lua",
    ["data/biome/greed_room.xml"] = "data/scripts/biomes/greed_room.lua",
    ["data/biome/excavationsite_cube_chamber.xml"] = "data/scripts/biomes/excavationsite_cube_chamber.lua",
    ["data/biome/mountain_right_2.xml"] = "data/scripts/biomes/mountain/mountain_right_2.lua",
    ["data/biome/alchemist_secret.xml"] = "data/scripts/biomes/alchemist_secret.lua",
    ["data/biome/orbrooms/orbroom_11.xml"] = "data/scripts/biomes/orbrooms/orbroom_11.lua",
    ["data/biome/boss_limbs_arena.xml"] = "data/scripts/biomes/boss_limbs_arena.lua",
    ["data/biome/essenceroom_air.xml"] = "data/scripts/biomes/essenceroom_air.lua",
    ["data/biome/mystery_teleport.xml"] = "data/scripts/biomes/mystery_teleport.lua",
    ["data/biome/coalmine_alt.xml"] = "data/scripts/biomes/coalmine_alt.lua",
    ["data/biome/watercave.xml"] = "data/scripts/biomes/watercave.lua",
    ["data/biome/secret_entrance.xml"] = "data/scripts/biomes/secret_entrance.lua",
    ["data/biome/end_wall.xml"] = "data/scripts/biomes/end_wall.lua",
    ["data/biome/temple_wall.xml"] = "data/scripts/biomes/temple_wall.lua",
    ["data/biome/essenceroom_alc.xml"] = "data/scripts/biomes/essenceroom_alc.lua",
    ["data/biome/niilo_testroom_d.xml"] = "data/scripts/biomes/niilo_testroom_d.lua",
    ["data/biome/niilo_testroom_c.xml"] = "data/scripts/biomes/niilo_testroom_c.lua",
    ["data/biome/niilo_testroom.xml"] = "data/scripts/biomes/niilo_testroom.lua",
    ["data/biome/orbrooms/orbroom_10.xml"] = "data/scripts/biomes/orbrooms/orbroom_10.lua",
    ["data/biome/robot_egg.xml"] = "data/scripts/biomes/robot_egg.lua",
    ["data/biome/winter.xml"] = "data/scripts/biomes/hills.lua",
    ["data/biome/solid_wall.xml"] = "data/scripts/biomes/hills.lua",
    ["data/biome/ocarina.xml"] = "data/scripts/biomes/ocarina.lua",
    ["data/biome/mountain_hall_3.xml"] = "data/scripts/biomes/mountain/mountain_hall_3.lua",
    ["data/biome/temple_altar_right_snowcastle_empty.xml"] = "data/scripts/biomes/temple_altar_right_snowcastle_empty.lua",
    ["data/biome/lavalake_racing.xml"] = "data/scripts/biomes/lavalake_racing.lua",
    ["data/biome/teleroom.xml"] = "data/scripts/biomes/teleroom.lua",
    ["data/biome/snowcave.xml"] = "data/scripts/biomes/snowcave.lua",
    ["data/biome/mountain_left.xml"] = "data/scripts/biomes/mountain/mountain_left.lua",
    ["data/biome/mountain_hall.xml"] = "data/scripts/biomes/mountain/mountain_hall.lua",
    ["data/biome/orbrooms/orbroom_05.xml"] = "data/scripts/biomes/orbrooms/orbroom_05.lua",
    ["data/biome/orbrooms/orbroom_04.xml"] = "data/scripts/biomes/orbrooms/orbroom_04.lua",
    ["data/biome/hills.xml"] = "data/scripts/biomes/hills.lua",
    ["data/biome/secret_altar.xml"] = "data/scripts/biomes/secret_altar.lua",
    ["data/biome/the_end.xml"] = "data/scripts/biomes/the_end.lua",
    ["data/biome/liquidcave.xml"] = "data/scripts/biomes/liquidcave.lua",
    ["data/biome/vault_entrance.xml"] = "data/scripts/biomes/vault_entrance.lua",
    ["data/biome/solid_wall_hidden_cavern.xml"] = "data/scripts/biomes/solid_wall_hidden_cavern.lua",
    ["data/biome/tower/solid_wall_tower_7.xml"] = "data/scripts/biomes/tower.lua",
    ["data/biome/tower/solid_wall_tower_6.xml"] = "data/scripts/biomes/tower.lua",
    ["data/biome/tower/solid_wall_tower_5.xml"] = "data/scripts/biomes/tower.lua",
    ["data/biome/tower/solid_wall_tower_3.xml"] = "data/scripts/biomes/tower.lua",
    ["data/biome/tower/solid_wall_tower_2.xml"] = "data/scripts/biomes/tower.lua",
    ["data/biome/mountain_left_2.xml"] = "data/scripts/biomes/mountain/mountain_left_2.lua",
    ["data/biome/tower/solid_wall_tower_1.xml"] = "data/scripts/biomes/tower.lua",
    ["data/biome/tower/solid_wall_tower_9.xml"] = "data/scripts/biomes/tower.lua",
    ["data/biome/smokecave_left.xml"] = "data/scripts/biomes/smokecave_left.lua",
    ["data/biome/crypt.xml"] = "data/scripts/biomes/crypt.lua",
    ["data/biome/temple_altar_left_empty.xml"] = "data/scripts/biomes/temple_altar_left_empty.lua",
    ["data/biome/temple_altar_right_empty.xml"] = "data/scripts/biomes/temple_altar_right_empty.lua",
    ["data/biome/vault_frozen.xml"] = "data/scripts/biomes/vault_frozen.lua",
    ["data/biome/wizardcave_entrance.xml"] = "data/scripts/biomes/wizardcave_entrance.lua",
    ["data/biome/temple_altar_right.xml"] = "data/scripts/biomes/temple_altar_right.lua",
    ["data/biome/mountain_right_entrance_2.xml"] = "data/scripts/biomes/mountain/mountain_right_entrance_2.lua",
    ["data/biome/snowcastle.xml"] = "data/scripts/biomes/snowcastle.lua",
    ["data/biome/mountain_top.xml"] = "data/scripts/biomes/mountain/mountain_top.lua",
    ["data/biome/mountain_floating_island.xml"] = "data/scripts/biomes/mountain/mountain_floating_island.lua",
    ["data/biome/mountain_center.xml"] = "data/scripts/biomes/mountain/mountain_center.lua",
    ["data/biome/dragoncave.xml"] = "data/scripts/biomes/dragoncave.lua",
    ["data/biome/boss_victoryroom.xml"] = "data/scripts/biomes/boss_victoryroom.lua",
    ["data/biome/song_room.xml"] = "data/scripts/biomes/song_room.lua",
    ["data/biome/temple_altar_right_snowcave_empty.xml"] = "data/scripts/biomes/temple_altar_right_snowcave_empty.lua",
    ["data/biome/temple_altar_empty.xml"] = "data/scripts/biomes/temple_altar_empty.lua",
    ["data/biome/sandroom.xml"] = "data/scripts/biomes/sandroom.lua",
    ["data/biome/solid_wall_temple.xml"] = "data/scripts/biomes/hills.lua",
    ["data/biome/temple_wall_ending.xml"] = "data/scripts/biomes/temple_wall_ending.lua",
    ["data/biome/mountain_lake.xml"] = "data/scripts/biomes/mountain_lake.lua",
    ["data/biome/mountain_left_stub.xml"] = "data/scripts/biomes/mountain/mountain_left_stub.lua",
    ["data/biome/pyramid_right.xml"] = "data/scripts/biomes/pyramid_right.lua",
    ["data/biome/mountain_hall_4.xml"] = "data/scripts/biomes/mountain/mountain_hall_4.lua",
    ["data/biome/scale.xml"] = "data/scripts/biomes/scale.lua",
    ["data/biome/shop_room.xml"] = "data/scripts/biomes/shop_room.lua",
    ["data/biome/lake.xml"] = "data/scripts/biomes/lake.lua",
    ["data/biome/tower/solid_wall_tower_4.xml"] = "data/scripts/biomes/tower.lua",
    ["data/biome/orbrooms/orbroom_00.xml"] = "data/scripts/biomes/orbrooms/orbroom_00.lua",
    ["data/biome/orbrooms/orbroom_01.xml"] = "data/scripts/biomes/orbrooms/orbroom_01.lua",
    ["data/biome/orbrooms/orbroom_02.xml"] = "data/scripts/biomes/orbrooms/orbroom_02.lua",
    ["data/biome/orbrooms/orbroom_03.xml"] = "data/scripts/biomes/orbrooms/orbroom_03.lua",
    ["data/biome/coalmine.xml"] = "data/scripts/biomes/coalmine.lua",
    ["data/biome/mountain_right.xml"] = "data/scripts/biomes/mountain/mountain_right.lua",
    ["data/biome/orbrooms/orbroom_06.xml"] = "data/scripts/biomes/orbrooms/orbroom_06.lua",
    ["data/biome/orbrooms/orbroom_07.xml"] = "data/scripts/biomes/orbrooms/orbroom_07.lua",
    ["data/biome/orbrooms/orbroom_08.xml"] = "data/scripts/biomes/orbrooms/orbroom_08.lua",
    ["data/biome/orbrooms/orbroom_09.xml"] = "data/scripts/biomes/orbrooms/orbroom_09.lua",
    ["data/biome/pyramid_entrance.xml"] = "data/scripts/biomes/pyramid_entrance.lua",
}

--table used to cache all mod settings and flag stuff like that so i dont have to call ModSettingGet duplicates
settings = {
    --General
    general =               ModSettingGet("parallel_parity.general") or force_true,
    visual =                ModSettingGet("parallel_parity.visual") or force_true,
    hidden =                ModSettingGet("parallel_parity.hidden") or force_true,
    fungal_altars =         ModSettingGet("parallel_parity.fungal_altars") or force_true,
    fishing_hut =           ModSettingGet("parallel_parity.fishing_hut") or force_true,
    pyramid_boss =          ModSettingGet("parallel_parity.pyramid_boss") or force_true,
    leviathan =             ModSettingGet("parallel_parity.leviathan") or force_true,
    avarice_diamond =       ModSettingGet("parallel_parity.avarice_diamond") or force_true,
    essence_eaters =        ModSettingGet("parallel_parity.essence_eaters") or force_true,
    music_machines =        ModSettingGet("parallel_parity.music_machines") or force_true,
    evil_eye =              ModSettingGet("parallel_parity.evil_eye") or force_true,


    --Spliced
    lava_lake =             ModSettingGet("parallel_parity.lava_lake") or force_true,
    moons =                 ModSettingGet("parallel_parity.moons") or force_true,
    desert_skull =          ModSettingGet("parallel_parity.desert_skull") or force_true,
    kolmi_arena =           ModSettingGet("parallel_parity.kolmi_arena") or force_true,
    tree =                  ModSettingGet("parallel_parity.tree") or force_true,
    dark_cave =             ModSettingGet("parallel_parity.dark_cave") or force_true,
    mountain_lake =         ModSettingGet("parallel_parity.mountain_lake") or force_true,
    lake_island =           ModSettingGet("parallel_parity.lake_island") or force_true,
    gourd_room =            ModSettingGet("parallel_parity.gourd_room") or force_true,
    meat_skull =            ModSettingGet("parallel_parity.meat_skull") or force_true,


    --Localised
    fishing_bunkers =       ModSettingGet("parallel_parity.fishing_hut.BUNKERS") or force_true,

    lava_lake_orb =         ModSettingGet("parallel_parity.lava_lake.ORB") or force_true,
    spawn_kolmi =           ModSettingGet("parallel_parity.kolmi_arena.KOLMI") or force_true,
    greed_curse =           ModSettingGet("parallel_parity.tree.GREED") or force_true,
    dark_cave_hp =          ModSettingGet("parallel_parity.dark_cave.HP") or force_true,
    fire_essence =          ModSettingGet("parallel_parity.lake_island.FIRE_ESSENCE") or force_true,
    island_boss =           ModSettingGet("parallel_parity.lake_island.BOSS") or force_true,
    spawn_gourds =          ModSettingGet("parallel_parity.gourd_room.GOURDS") or force_true,



    --Portals
    portal_general =        ModSettingGet("parallel_parity.portals.general") or force_true,
    portal_holy_mountain =  ModSettingGet("parallel_parity.portals.holy_mountain") or force_true,
    portal_fast_travel =    ModSettingGet("parallel_parity.portals.fast_travel") or force_true,
    portal_tower_entrance = ModSettingGet("parallel_parity.portals.tower_entrance") or force_true,
    portal_mountain =       ModSettingGet("parallel_parity.portals.mountain") or force_true,
    portal_skull_island =   ModSettingGet("parallel_parity.portals.skull_island") or force_true,
    portal_summon =         ModSettingGet("parallel_parity.portals.summon") or force_true,



    --Special
    ng_plus =               ModSettingGet("parallel_parity.ng_plus") or force_true
}

par.spliced_pixel_scenes = {
    ["data/biome_impl/spliced/lavalake2.xml"] =             settings.lava_lake,
    ["data/biome_impl/spliced/skull_in_desert.xml"] =       settings.lava_lake,
    ["data/biome_impl/spliced/boss_arena.xml"] =            settings.desert_skull,
    ["data/biome_impl/spliced/tree.xml"] =                  settings.kolmi_arena,
    ["data/biome_impl/spliced/watercave.xml"] =             settings.tree,
    ["data/biome_impl/spliced/mountain_lake.xml"] =         settings.dark_cave,
    ["data/biome_impl/spliced/lake_statue.xml"] =           settings.mountain_lake,
    ["data/biome_impl/spliced/moon.xml"] =                  settings.lake_island,
    ["data/biome_impl/spliced/moon_dark.xml"] =             settings.moons,
    ["data/biome_impl/spliced/lavalake_pit_bottom.xml"] =   settings.moons,
    ["data/biome_impl/spliced/gourd_room.xml"] =            settings.gourd_room,
    ["data/biome_impl/spliced/skull.xml"] =                 settings.meat_skull,
}


par.pixel_scenes = {
    --materials
    ["data/biome_impl/temple/altar_vault_capsule.png"] =            settings.general,
    ["data/biome_impl/temple/altar_snowcastle_capsule.png"] =       settings.general,
    ["data/biome_impl/tower_start.png"] =                           settings.general,
    ["data/biome_impl/the_end/the_end_shop.png"] =                  settings.general,
    ["data/biome_impl/overworld/desert_ruins_base_01.png"] =        settings.general,
    ["data/biome_impl/snowcastle/forge.png"] =                      settings.general,
    ["data/biome_impl/temple/altar_snowcave_capsule.png"] =         settings.general,
    ["data/biome_impl/huussi.png"] =                                settings.general,

    ["data/biome_impl/overworld/essence_altar.png"] =               settings.essence_eaters,
    ["data/biome_impl/overworld/essence_altar_desert.png"] =        settings.essence_eaters,

    ["data/biome_impl/overworld/snowy_ruins_eye_pillar.png"] =      settings.fungal_altars,
    ["data/biome_impl/rainbow_cloud.png"] =                         settings.fungal_altars,
    ["data/biome_impl/eyespot.png"] =                               settings.fungal_altars,

    ["data/biome_impl/fishing_hut.png"] =                           settings.fishing_hut,
    ["data/biome_impl/bunker.png"] =                                settings.fishing_hut and settings.fishing_bunkers, --requires fishing hut to exist as a prerequisite
    ["data/biome_impl/bunker2.png"] =                               settings.fishing_hut and settings.fishing_bunkers,

    ["data/biome_impl/pyramid/boss_limbs.png"] =                    settings.pyramid_boss,
    ["data/biome_impl/greed_treasure.png"] =                        settings.avarice_diamond,
    ["data/biome_impl/overworld/essence_altar"] =                   settings.essence_eaters,
    ["data/biome_impl/overworld/cliff.png"] =                       settings.music_machines,
    ["data/biome_impl/overworld/music_machine_stand.png"] =         settings.music_machines,

    --backgrounds
    ["data/biome_impl/hidden/boss_arena.png"] =                     settings.visual, --hidden backgrounds are for hidden messages, more info: https://noita.wiki.gg/wiki/Game_Lore#Secret_Messages
    ["data/biome_impl/hidden/boss_arena_under.png"] =               settings.visual,
    ["data/biome_impl/hidden/boss_arena_under_right.png"] =         settings.visual,
    ["data/biome_impl/hidden/completely_random.png"] =              settings.visual,
    ["data/biome_impl/hidden/completely_random_2.png"] =            settings.visual,
    ["data/biome_impl/hidden/fungal_caverns_1.png"] =               settings.visual,
    ["data/biome_impl/hidden/holy_mountain_1.png"] =                settings.visual,
    ["data/biome_impl/hidden/jungle_right.png"] =                   settings.visual,
    ["data/biome_impl/hidden/mountain_text.png"] =                  settings.visual,
    ["data/biome_impl/hidden/under_the_wand_cave.png"] =            settings.visual,
    ["data/biome_impl/hidden/vault_inside.png"] =                   settings.visual,
    ["data/biome_impl/hidden/crypt_left.png"] =                     settings.visual,

    ["data/biome_impl/liquidcave/liquidcave_corner.png"] =          settings.visual,
    ["data/biome_impl/liquidcave/liquidcave_top.png"] =             settings.visual,
    ["data/biome_impl/liquidcave/liquidcave_corner2.png"] =         settings.visual,


    --entities
    ["data/entities/misc/platform_wide.xml"] =                      settings.fungal_altars,
    ["data/entities/buildings/eyespot_a.xml"] =                     settings.fungal_altars,
    ["data/entities/buildings/eyespot_b.xml"] =                     settings.fungal_altars,
    ["data/entities/buildings/eyespot_c.xml"] =                     settings.fungal_altars,
    ["data/entities/buildings/eyespot_d.xml"] =                     settings.fungal_altars,
    ["data/entities/buildings/eyespot_e.xml"] =                     settings.fungal_altars,
    ["data/entities/items/books/book_hint.xml"] =                   settings.fungal_altars,

    ["data/entities/props/physics_fungus.xml"] =                    settings.tree,
    ["data/entities/props/physics_fungus_big.xml"] =                settings.tree,
    ["data/entities/props/physics_fungus_small.xml"] =              settings.tree,

    ["data/entities/props/music_machines/music_machine_00.xml"] =   settings.music_machines,
    ["data/entities/props/music_machines/music_machine_01.xml"] =   settings.music_machines,
    ["data/entities/props/music_machines/music_machine_02.xml"] =   settings.music_machines,
    ["data/entities/props/music_machines/music_machine_03.xml"] =   settings.music_machines,

    ["data/entities/props/physics/bridge_spawner.xml"] =            settings.lava_lake,
    ["data/entities/buildings/essence_eater.xml"] =                 settings.essence_eaters,
    ["data/entities/buildings/hut_check.xml"] =                     settings.fishing_bunkers,
    ["data/entities/buildings/maggotspot.xml"] =                    settings.meat_skull, --Tiny boss spawn
    ["data/entities/animals/boss_fish/fish_giga.xml"] =             settings.leviathan,
    ["data/entities/items/pickup/evil_eye.xml"] =                   settings.evil_eye, --Paha Silma pedestal to left of Tree
}


par.portals = {
    ["data/entities/buildings/teleport_bunker.xml"] =                       settings.portal_general, --fishing bunker
    ["data/entities/buildings/teleport_bunker_back.xml"] =                  settings.portal_general, --fishing bunker
    ["data/entities/buildings/teleport_bunker2.xml"] =                      settings.portal_general, --fishing bunker
    ["data/entities/buildings/teleport_meditation_cube.xml"] =              settings.portal_general,
    ["data/entities/buildings/teleport_meditation_cube_return.xml"] =       settings.portal_general,
    ["data/entities/buildings/teleport_snowcave_buried_eye.xml"] =          settings.portal_general,
    ["data/entities/buildings/teleport_snowcave_buried_eye_return.xml"] =   settings.portal_general,
    ["data/entities/buildings/teleport_hourglass.xml"] =                    settings.portal_general,
    ["data/entities/buildings/teleport_hourglass_return.xml"] =             settings.portal_general,
    ["data/entities/buildings/teleport_ending_victory.xml"] =               settings.portal_general, --kolmi death portal
    ["data/entities/buildings/teleport_start.xml"] =                        settings.portal_general, --greed curse return portal
    ["data/entities/buildings/teleport_liquid_powered.xml"] =               settings.portal_holy_mountain, --holy mountain portal
    ["data/entities/buildings/teleport_ending.xml"] =                       settings.portal_holy_mountain, --final holy mountain portal
    ["data/entities/buildings/teleport_teleroom.xml"] =                     settings.portal_fast_travel, --fast travel portal room and co
    ["data/entities/buildings/teleport_teleroom_1.xml"] =                   settings.portal_fast_travel,
    ["data/entities/buildings/teleport_teleroom_2.xml"] =                   settings.portal_fast_travel,
    ["data/entities/buildings/teleport_teleroom_3.xml"] =                   settings.portal_fast_travel,
    ["data/entities/buildings/teleport_teleroom_4.xml"] =                   settings.portal_fast_travel,
    ["data/entities/buildings/teleport_teleroom_5.xml"] =                   settings.portal_fast_travel,
    ["data/entities/buildings/teleport_teleroom_6.xml"] =                   settings.portal_fast_travel,
    ["data/entities/buildings/mystery_teleport.xml"] =                      settings.portal_tower_entrance,
    ["data/entities/buildings/mystery_teleport_back.xml"] =                 settings.portal_mountain, --tower exit + musical curiosity
    ["data/entities/buildings/teleport_lake.xml"] =                         settings.portal_skull_island, --teleport to lake
    ["data/entities/buildings/teleport_desert.xml"] =                       settings.portal_skull_island, --teleport to desert
    ["data/entities/projectiles/deck/summon_portal_teleport.xml"] =         settings.portal_summon, --EoE portal in underground jungle
    ["data/entities/buildings/teleport_robot_egg_return.xml"] =             settings.portal_summon, --EoE return portal
}

par.localise = {
    ["data/scripts/biomes/lake_statue.lua"] = {
        settings.lake_island and not settings.island_boss and {
            [[EntityLoad%( "data/entities/animals/boss_spirit/spawner%.xml", x, y %)]],
        } or nil,
        settings.lake_island and not settings.fire_essence and {
            [[EntityLoad%( "data/entities/items/pickup/essence_fire%.xml", x, y %)]],
        } or nil,
    },
    ["data/scripts/biomes/lake.lua"] = {
        settings.fishing_hut and not settings.fishing_bunkers and {
            [[EntityLoad%( "data/entities/buildings/bunker%.xml", x, y %)]],
            [[EntityLoad%( "data/entities/buildings/bunker2%.xml", x, y %)]],
        } or nil,
    },
    ["data/scripts/biomes/lavalake.lua"] = {
        settings.lava_lake and not settings.lava_lake_orb and {
            [[EntityLoad( %"data/entities/items/orbs/orb_03%.xml", x-10, y )]],
        } or nil,
    },
    ["data/scripts/biomes/boss_arena.lua"] = {
        settings.kolmi_arena and not settings.spawn_kolmi and {
            [[EntityLoad%( "data/entities/animals/boss_centipede/boss_music_buildup_trigger%.xml", x, y %)]],
            [[EntityLoad%( "data/entities/animals/boss_centipede/boss_centipede%.xml", x, y %)
	%-%- if game is not completed
	if%( GameHasFlagRun%( "ending_game_completed" %) == false %) then
		EntityLoad%( "data/entities/animals/boss_centipede/sampo%.xml", x, y + 80 %)
	end
	
	EntityLoad%( "data/entities/animals/boss_centipede/reference_point%.xml", x, y %)]],
        } or nil,
    },
    ["data/scripts/biomes/mountain_tree.lua"] = {
        settings.tree and not settings.greed_curse and {
            [[EntityLoad%( "data/entities/items/pickup/greed_curse%.xml", x, y %)]],
        } or nil,
    },
    ["data/scripts/biomes/watercave.lua"] = {
        settings.dark_cave and not settings.dark_cave_hp and {
            [[EntityLoad%( "data/entities/items/pickup/heart%.xml", x, y %)]],
            [[EntityLoad%( "data/entities/items/pickup/heart_fullhp%.xml", x, y %)]],
        } or nil,
    },
    ["data/scripts/biomes/gourd_room.lua"] = {
        settings.gourd_room and not settings.spawn_gourds and {
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

--get biomescript from biomexml. note: maybe merge with MapGetBiomeScript() at some point
local function GetBiomeScript(biomepath, generate)
    local biomexml = nxml.parse(ModTextFileGetContent(biomepath))

    if not par.biome_scripts[biomepath] then
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
            par.biome_scripts[biomepath] = toplogy.attr.lua_script
        end
    end

    return par.biome_scripts[biomepath]
end

local biomelist = {} --create hex-indexed table for all biomes that exist
local biomelist_xml = nxml.parse(ModTextFileGetContent("data/biome/_biomes_all.xml"))
if biomelist_xml then
    for elem in biomelist_xml:each_child() do biomelist[(elem.attr.color):lower():sub(3,-1)] = elem.attr.biome_filename end
else
    print("could not find \"data/biome/_biomes_all.xml\", fuck.")
end


--automatically cache important map data
local cached_maps = {}
for _, biome_maps in pairs(par.worlds) do
    for biome_map, _ in pairs(biome_maps) do
        if not cached_maps[biome_map] then
            cached_maps[biome_map] = {}
            cached_maps[biome_map].map, cached_maps[biome_map].w, cached_maps[biome_map].h = ModImageMakeEditable(biome_map, 0, 0)
        end
    end
end

--get biomescript from chunk coordinate
local function MapGetBiomeScript(biome_map, chunk_pos_x, chunk_pos_y)
    local mdata = cached_maps[biome_map]

    local map_pos_x = (chunk_pos_x + (mdata.w * .5))

    local map_pos_y = chunk_pos_y + 14
	map_pos_y = math.max(map_pos_y, 0)
	map_pos_y = math.min(map_pos_y, mdata.h - 1)

    local abgr_int = ModImageGetPixel(mdata.map, map_pos_x, map_pos_y) --get pixel colour as ABGR integer
    local hex = ("%02x%02x%02x"):format(bit.band(abgr_int, 0xFF), bit.band(bit.rshift(abgr_int, 8), 0xFF), bit.band(bit.rshift(abgr_int, 16), 0xFF)) --convert it to something sane
    if hex == "000000" then return nil end
    return GetBiomeScript(biomelist[hex], true)
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
--#endregion



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
                                local map_scene_index = pixel_scenes_path .. cached_maps[biome_map].w

                                local chunk_key = chunk_pos_x .. "_" .. chunk_pos_y --hehe chunky
                                --ng plus support code is temporary, I eventually wanna add special handling that predicts future permutations of the NG+ biome map and appends pixel scenes accordingly- even if its a bit overkill, it seems like good tech to have in my back-pocket
                                -- [[ NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT
                                local skip_scraping = false
                                if biome_map == "data/biome_impl/biome_map_newgame_plus.png" then
                                    if settings.ng_plus then
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
                    local map_scene_index = pixel_scenes_path .. cached_maps[biome_map].w

                    local chunk_key = chunk_pos_x .. "_" .. chunk_pos_y

                    -- [[ NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT
                    local skip_scraping = false
                    if biome_map == "data/biome_impl/biome_map_newgame_plus.png" then
                        if settings.ng_plus then
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
        --[[
        if (file_name):find("cliff%.png") and pixel_scenes_path == "data/biome/_pixel_scenes.xml" then
            logging = true
            print("Targetting file: " .. file_name)
        end--]]
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
                    local map_scene_index = pixel_scenes_path .. cached_maps[biome_map].w

                    local chunk_key = chunk_pos_x .. "_" .. chunk_pos_y
                    -- [[ NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT
                    local skip_scraping = false
                    if biome_map == "data/biome_impl/biome_map_newgame_plus.png" then
                        if settings.ng_plus then
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
        table_insert = table_insert .. "    [\"" .. map_index .. "\"] = {\n        scenes = {\n"
        for key, chunk in pairs(chunk_index.scenes) do
            table_insert = table_insert .. "            [\"".. key .."\"] = {\n"
            for _, scene in ipairs(chunk) do
                if scene.materials == "" then scene.materials = "mods/parallel_parity/files/nil_materials.png" end
                table_insert = table_insert .. ([[                {
                    materials = "%s",
                    gfx = "%s",
                    background = "%s",
                    offset_x = "%s",
                    offset_y = "%s",
                },
]]):format(scene.materials, scene.gfx, scene.background, scene.offset_x, scene.offset_y)
            end
            table_insert = table_insert .. "            },\n"
        end
        table_insert = table_insert .. "        },\n"

        table_insert = table_insert .. "        entities = {\n"
        for key, chunk in pairs(chunk_index.entities) do
            --do break end
            table_insert = table_insert .. "            [\"".. key .."\"] = {\n"
            for _, entity in ipairs(chunk) do
                table_insert = table_insert .. ([[                {
                    path = "%s",
                    offset_x = "%s",
                    offset_y = "%s",
                },
]]):format(entity.path, entity.offset_x, entity.offset_y)
            end
            table_insert = table_insert .. "            },\n"
        end
        table_insert = table_insert .. "        },\n    },\n"
    end
    local append_path = "mods/parallel_parity/generated/biome_appends/" .. script_path
    ModTextFileSetContent(append_path, ModTextFileGetContent("mods/parallel_parity/files/debug_template_append.lua"):gsub("%-%-PARALLEL APPEND HERE!", table_insert):gsub("FILENAMEHERE", script_path))
    ModLuaFileAppend(script_path, append_path)

    ModTextFileSetContent(script_path, ModTextFileGetContent("mods/parallel_parity/files/rsf_script_prepend.lua") .. ModTextFileGetContent(script_path))
end
--#endregion


--special behaviour
--#region

--EoE Summoned Portal location and related hints in Underground Jungle
if settings.portal_summon then
    ModTextFileSetContent("data/scripts/biomes/rainforest.lua",
        ModTextFileGetContent("data/scripts/biomes/rainforest.lua"
            ):gsub(
                "function init%(x, y, w, h%)",
                "function init%(x, y, w, h%)\n    local pw_offset = GetParallelWorldPosition%(x, 0%) %* BiomeMapGetSize%(%) %* 512"
            ):gsub(
                "local function is_inside_tile%(pos_x, pos_y%)",
                "local function is_inside_tile%(pos_x, pos_y%)\n        pos_x = pos_x %+ pw_offset"
            ):gsub(
                "EntityLoad%( \"data/entities/misc/summon_portal_target.xml\", portal_x, portal_y %)",
                "EntityLoad%( \"data/entities/misc/summon_portal_target.xml\", portal_x %+ pw_offset, portal_y %)"
            ):gsub(
                "local function spawn_statue%(statue_num, spawn_x, spawn_y, ray_dir_x, ray_dir_y%)",
                "local function spawn_statue%(statue_num, spawn_x, spawn_y, ray_dir_x, ray_dir_y%)\n        spawn_x = spawn_x %+ pw_offset"
        )
    )
end
--#endregion

--Special Main-World Localisation


for path, biome in pairs(par.localise) do
    for _, targets in ipairs(biome) do
        for _, code in ipairs(targets) do
            ModTextFileSetContent(path, ModTextFileGetContent(path):gsub(code, "local _ = GetParallelWorldPosition(x, y) if _ == 0 then " .. code .. " end"))
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

print("Parallel Parity init: " .. GameGetRealWorldTimeSinceStarted()-start)