dofile_once( "data/scripts/lib/utilities.lua" )

-- all functions below are optional and can be left out

--[[

function OnModPreInit()
    print("Mod - OnModPreInit()") -- First this is called for all mods
end

function OnModInit()
    print("Mod - OnModInit()") -- After that this is called for all mods
end

function OnModPostInit()
    print("Mod - OnModPostInit()") -- Then this is called for all mods
end

function OnWorldInitialized() -- This is called once the game world is initialized. Doesn't ensure any world chunks actually exist. Use OnPlayerSpawned to ensure the chunks around player have been loaded or created.
    GamePrint( "OnWorldInitialized() " .. tostring(GameGetFrameNum()) )
end

function OnWorldPreUpdate() -- This is called every time the game is about to start updating the world
    GamePrint( "Pre-update hook " .. tostring(GameGetFrameNum()) )
end

function OnWorldPostUpdate() -- This is called every time the game has finished updating the world
    GamePrint( "Post-update hook " .. tostring(GameGetFrameNum()) )
end

function OnMagicNumbersAndWorldSeedInitialized() -- this is the last point where the Mod* API is available. after this materials.xml will be loaded.
    local x = ProceduralRandom(0,0)
    print( "===================================== random " .. tostring(x) )
end

function OnPlayerSpawned( player_entity ) -- This runs when player entity has been created
    local x,y = EntityGetTransform(player_entity)
    EntityLoad("mods/parallel_parity/files/marker.xml", x, y)
end


]]--


local map_path = "data/biome_impl/biome_map.png"

local map,map_width,map_height = ModImageMakeEditable(map_path, 0, 0)
local boundry_coordinate = map_width * 256 --get the full width of the map in pixels, divided by 2, this should be used to identify targets outside of a parallel world


--list of relevant biome scripts using biome xml as index key, vanilla biomescript data is pregenerated under the assumption surely no one would go out their way to alter the filepath of vanilla biomescripts
local biome_scripts = {
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

ModLuaFileAppend("data/biome_impl/static_tile/temples_common.lua", "mods/parallel_parity/files/fix_temples_common.lua") --fix temples_common.lua having evil alt-named init function, literally only one to have deviant name out of 130 uses of the wang function

local nxml = dofile_once("mods/parallel_parity/files/nxml.lua")
nxml.error_handler = function() end

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



local biomelist_xml = nxml.parse(ModTextFileGetContent("data/biome/_biomes_all.xml"))
if biomelist_xml then
    for elem in biomelist_xml:each_child() do
        --ModLuaFileAppend(GetBiomeScript(elem.attr.biome_filename, true), "mods/parallel_parity/files/template_append.lua")
    end
end



local force_true = true

--table used to cache all mod settings and flag stuff like that so i dont have to call ModSettingGet duplicates
local settings = {
    --General
    visual =                ModSettingGet("parallel_parity.visual") or force_true,
    hidden =                ModSettingGet("parallel_parity.backgrounds.hidden") or force_true,

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
}

local spliced_pixel_scenes = {
    lavalake2 =             settings.lava_lake,
    lavalake_pit_bottom =   settings.lava_lake,
    skull_in_desert =       settings.desert_skull,
    boss_arena =            settings.kolmi_arena,
    tree =                  settings.tree,
    watercave =             settings.dark_cave,
    mountain_lake =         settings.mountain_lake,
    lake_statue =           settings.lake_island,
    moon =                  settings.moons,
    moon_dark =             settings.moons,
    gourd_room =            settings.gourd_room,
    skull =                 settings.meat_skull,
}


local pixel_scenes = {
    --materials
    ["data/biome_impl/temple/altar_vault_capsule.png"] =            settings.general,
    ["data/biome_impl/temple/altar_snowcastle_capsule.png"] =       settings.general,
    ["data/biome_impl/tower_start.png"] =                           settings.general,
    ["data/biome_impl/the_end/the_end_shop.png"] =                  settings.general,
    ["data/biome_impl/overworld/desert_ruins_base_01.png"] =        settings.general,

    ["data/biome_impl/overworld/snowy_ruins_eye_pillar.png"] =      settings.fungal_altars,
    ["data/biome_impl/rainbow_cloud.png"] =                         settings.fungal_altars,
    ["data/biome_impl/eyespot.png"] =                               settings.fungal_altars,

    ["data/biome_impl/bunker.png"] =                                settings.fishing_hut,
    ["data/biome_impl/bunker2.png"] =                               settings.fishing_hut,

    ["data/biome_impl/pyramid/boss_limbs.png"] =                    settings.pyramid_boss,
    ["data/biome_impl/greed_treasure.png"] =                        settings.avarice_diamond,
    ["data/biome_impl/fishing_hut.png"] =                           settings.fishing_hut,
    ["data/biome_impl/overworld/essence_altar"] =                   settings.essence_eaters,
    ["data/biome_impl/overworld/cliff_visual.png"] =                settings.visual,
    ["data/biome_impl/overworld/music_machine_stand.png"] =         settings.music_machines,

    --backgrounds
    ["data/biome_impl/hidden/boss_arena.png"] =                     settings.visual,
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

    ["data/entities/props/physics_fungus.xml"] =                    settings.tree,
    ["data/entities/props/physics_fungus_big.xml"] =                settings.tree,
    ["data/entities/props/physics_fungus_small.xml"] =              settings.tree,

    ["data/entities/props/music_machines/music_machine_00.xml"] =   settings.music_machines,
    ["data/entities/props/music_machines/music_machine_01.xml"] =   settings.music_machines,
    ["data/entities/props/music_machines/music_machine_02.xml"] =   settings.music_machines,
    ["data/entities/props/music_machines/music_machine_03.xml"] =   settings.music_machines,

    ["data/entities/props/physics/bridge_spawner.xml"] =            settings.lavalake2,
    ["data/entities/buildings/essence_eater.xml"] =                 settings.essence_eaters,
}





local biomelist = {}

local biomelist_xml = nxml.parse(ModTextFileGetContent("data/biome/_biomes_all.xml"))
if biomelist_xml then
    for elem in biomelist_xml:each_child() do
        biomelist[(elem.attr.color):lower():sub(3,-1)] = elem.attr.biome_filename
        --print(("biomelist[%s] = %s"):format((elem.attr.color):lower():sub(3,-1), elem.attr.biome_filename))
    end
end


local biome_appends = {}

--remove spliced pixel scenes from _pixel_scenes.xml
local _pixel_scenes = nxml.parse(ModTextFileGetContent("data/biome/_pixel_scenes.xml")) --get all global pixel scenes
if _pixel_scenes then
    local ps_data = {
        spliced = _pixel_scenes:first_of("PixelSceneFiles"),
        backgrounds = _pixel_scenes:first_of("BackgroundImages"),
        scenes = _pixel_scenes:first_of("mBufferedPixelScenes"),
    }
    local remove_list = {
        spliced = {},
        backgrounds = {},
        scenes = {},
    }
    for sps in ps_data.spliced:each_child() do --run through spliced pixel scenes
        local spliced_scene_id = sps.content[#sps.content]:sub(1,-5) --acquire the pixel scene file name minus the file extension
        print("checking " .. spliced_scene_id)
        if spliced_pixel_scenes[spliced_scene_id] then --check if pixel scene is flagged
            print(spliced_scene_id .. " is valid")
            remove_list.spliced[#remove_list.spliced+1] = sps --add to list of spliced pixel scenes to remove

            local sps_filepath = ""
            for i = 1, #sps.content, 1 do
                sps_filepath = sps_filepath .. sps.content[i]
            end

            print(sps_filepath)
            if ModDoesFileExist(sps_filepath) then
                local sps_data = nxml.parse(ModTextFileGetContent(sps_filepath))
                if sps_data and sps_data.children[1] then --this should generally just be one singular mBufferedPixelScenes component. if theres more than one child in the file then i feel i cant really be blamed for the lunacy of other modders
                    local origin_x
                    local origin_y
                    for chunk in sps_data.children[1]:each_child() do
                        local chunk_pos_x = math.floor(chunk.attr.pos_x * 0.001953125) --i heard somewhere multiplication is more efficient than dividing so i hope thats true
                        local chunk_pos_y = math.floor(chunk.attr.pos_y * 0.001953125)
                        local map_pos_x = (chunk_pos_x + (map_width * .5)) % map_width --pray to god no one makes a mod that forces me to find out if this should lean left or right
                        local map_pos_y = clamp(chunk_pos_y + 14, 0, map_height - 1) --clamp to keep within the vertical map boundry
                        origin_x = origin_x or map_pos_x
                        origin_y = origin_y or map_pos_y

                        local abgr_int = ModImageGetPixel(map, map_pos_x, map_pos_y) --get pixel colour as ABGR integer
                        local hex = ("%02x%02x%02x"):format(bit.band(abgr_int, 0xFF), bit.band(bit.rshift(abgr_int, 8), 0xFF), bit.band(bit.rshift(abgr_int, 16), 0xFF)) --convert it to something sane

                        local biomescript = GetBiomeScript(biomelist[hex], true)
                        local chunk_key = chunk_pos_x .. "_" .. chunk_pos_y --hehe chunky 
                        biome_appends[biomescript] = biome_appends[biomescript] or {scenes = {}, entities = {}}
                        biome_appends[biomescript].scenes[chunk_key] = biome_appends[biomescript].scenes[chunk_key] or {}
                        biome_appends[biomescript].scenes[chunk_key][#biome_appends[biomescript].scenes[chunk_key] + 1] = {
                            materials = chunk.attr.material_filename,
                            gfx = chunk.attr.colors_filename,
                            background = chunk.attr.background_filename,
                            offset = {
                                x = chunk.attr.pos_x - (chunk_pos_x * 512),
                                y = chunk.attr.pos_y - (chunk_pos_y * 512),
                            }
                        } --add pixel scene to biome_appends table under biomexml path as a key
                    end
                end
            end
        end

            --move to separate thingy
            --[[if target.localise then --apply localisation changes to objects within the spliced pixel scene
                for object, data in pairs(target.localise) do
                    if ModSettingGet(target.setting) == false then --if spawning in PWs is disallowed
                        ModTextFileSetContent(data.script,
                            ModTextFileGetContent(data.script):gsub(data.code, --encapsulate designated code within a MW check
                                "local _ = GetParallelWorldPosition(x, y) if _ == 0 then " .. data.code .. " end"
                        ))
                    end
                end
            end]]
    end

    for bg in ps_data.backgrounds:each_child() do
        if pixel_scenes[bg.attr.filename] then
            remove_list.backgrounds[#remove_list.backgrounds+1] = bg
            local chunk_pos_x = math.floor(bg.attr.x * 0.001953125)
            local chunk_pos_y = math.floor(bg.attr.y * 0.001953125)
            local map_pos_x = (chunk_pos_x + (map_width * .5)) % map_width
            local map_pos_y = clamp(chunk_pos_y + 14, 0, map_height - 1)

            local abgr_int = ModImageGetPixel(map, map_pos_x, map_pos_y) --get pixel colour as ABGR integer
            local hex = ("%02x%02x%02x"):format(bit.band(abgr_int, 0xFF), bit.band(bit.rshift(abgr_int, 8), 0xFF), bit.band(bit.rshift(abgr_int, 16), 0xFF)) --convert it to something sane

            local biomescript = GetBiomeScript(biomelist[hex], true)
            local chunk_key = chunk_pos_x .. "_" .. chunk_pos_y
            biome_appends[biomescript] = biome_appends[biomescript] or {scenes = {}, entities = {}}
            biome_appends[biomescript].scenes[chunk_key] = biome_appends[biomescript].scenes[chunk_key] or {}
            biome_appends[biomescript].scenes[chunk_key][#biome_appends[biomescript].scenes[chunk_key] + 1] = {
                materials = "",
                gfx = "",
                background = bg.attr.filename,
                offset = {
                    x = bg.attr.x - (chunk_pos_x * 512),
                    y = bg.attr.y - (chunk_pos_y * 512),
                }
            }
        end
    end

    for elem in ps_data.scenes:each_child() do
        local path_id --so i have a reliably existent variable to base the new scene filepath off of
        if pixel_scenes[elem.attr.just_load_an_entity] then
            path_id = elem.attr.just_load_an_entity
        elseif pixel_scenes[elem.attr.material_filename] then
            path_id = elem.attr.material_filename
        elseif pixel_scenes[elem.attr.colors_filename] then
            path_id = elem.attr.colors_filename
        elseif pixel_scenes[elem.attr.background_filename] then
            path_id = elem.attr.background_filename
        end
        if path_id then
            print(path_id)
            remove_list.scenes[#remove_list.scenes+1] = elem
            local chunk_pos_x = math.floor(elem.attr.pos_x * 0.001953125)
            local chunk_pos_y = math.floor(elem.attr.pos_y * 0.001953125)
            local map_pos_x = (chunk_pos_x + (map_width * .5))
            local map_pos_y = clamp(chunk_pos_y + 14, 0, map_height - 1)

            local abgr_int = ModImageGetPixel(map, map_pos_x, map_pos_y) --get pixel colour as ABGR integer
            local hex = ("%02x%02x%02x"):format(bit.band(abgr_int, 0xFF), bit.band(bit.rshift(abgr_int, 8), 0xFF), bit.band(bit.rshift(abgr_int, 16), 0xFF)) --convert it to something sane
            local biomescript = GetBiomeScript(biomelist[hex], true)

            if biomescript then --do this check cuz map x is no longer modulated, this is to cull additional scenes thrown in PWs, this might break compat with future mods that specifically want a pixel scene in a PW but i can burn that bridge when it comes to it
                local scene_table
                local chunk_key = chunk_pos_x .. "_" .. chunk_pos_y
                biome_appends[biomescript] = biome_appends[biomescript] or {scenes = {}, entities = {}}
                if elem.attr.just_load_an_entity then
                    biome_appends[biomescript].entities[chunk_key] = biome_appends[biomescript].entities[chunk_key] or {}
                    biome_appends[biomescript].entities[chunk_key][#biome_appends[biomescript].entities[chunk_key] + 1] = {
                        path = elem.attr.just_load_an_entity,
                        offset = {
                            x = elem.attr.pos_x - (chunk_pos_x * 512),
                            y = elem.attr.pos_y - (chunk_pos_y * 512),
                        }
                    }
                else
                    biome_appends[biomescript].scenes[chunk_key] = biome_appends[biomescript].scenes[chunk_key] or {}
                    biome_appends[biomescript].scenes[chunk_key][#biome_appends[biomescript].scenes[chunk_key] + 1] = {
                        materials = elem.attr.material_filename,
                        gfx = elem.attr.colors_filename,
                        background = elem.attr.background_filename,
                        offset = {
                            x = elem.attr.pos_x - (chunk_pos_x * 512),
                            y = elem.attr.pos_y - (chunk_pos_y * 512),
                        }
                    }
                    --print(("PS:\n    %s\n    %s\n    %s"):format(elem.attr.material_filename, elem.attr.colors_filename, elem.attr.background_filename))
                end
            end
        end
    end

    for target, remove in pairs(remove_list) do
        for _, scene in ipairs(remove) do
            ps_data[target]:remove_child(scene) --remove spliced pixel scenes from file
        end
    end

end
ModTextFileSetContent("data/biome/_pixel_scenes.xml", tostring(_pixel_scenes)) --apply changes to file



print("A")
local map_width_prepend = "local map_width = " .. map_width
for biomescript, biome in pairs(biome_appends) do
    local table_insert = ""
    for index, chunk in pairs(biome.scenes) do
        table_insert = table_insert .. "    [\"" .. index .. "\"] = {\n"
        for index, pixel_scene in ipairs(chunk) do
            if pixel_scene.materials == "" then pixel_scene.materials = "mods/parallel_parity/files/nil_materials.png" end
            table_insert = table_insert .. "        {\n            materials = \"" .. pixel_scene.materials .. "\",\n            gfx = \"" .. pixel_scene.gfx .. "\",\n            background = \"" .. pixel_scene.background .. "\",\n            offset = { x = " .. pixel_scene.offset.x .. ", y = " .. pixel_scene.offset.y .. " }\n        },\n"
        end
        table_insert = table_insert .. "    },\n"
    end
    local filename
    for str in string.gmatch(biomescript, "([^/]+)") do --i stole the gmatch string, i still dont get string patterns 😭
        filename = str
    end
    local append_path = "mods/parallel_parity/generated/append_" .. filename
    ModTextFileSetContent(append_path,
        map_width_prepend .. ModTextFileGetContent("mods/parallel_parity/files/template_append.lua"):gsub("--PIXEL SCENE APPEND!", table_insert))
    ModLuaFileAppend(biomescript, append_path)
    --print(ModTextFileGetContent(append_path)) --uncomment this to get a full print of every generated append file
end
print("B")


do return end


for xml_path, pixel_scenes in pairs(biome_appends) do
    local biomexml = nxml.parse(ModTextFileGetContent(xml_path))
    if biomexml then
        local toplogy = biomexml:first_of("Topology")
        if toplogy then
            if toplogy.attr.lua_script then
                local table_string = ""
                for key, pixel_scene in ipairs(pixel_scenes) do
                    ModTextFileSetContent(toplogy.attr.lua_script, ModTextFileGetContent(toplogy.attr.lua_script) ..
                        ModTextFileGetContent("mods/parallel_parity/files/template_splicer.lua") --gsub in pixel scene data + map width
                            :gsub("MAPWIDTH", map_width)
                            :gsub("ORIGINX", pixel_scene.origin.x)
                            :gsub("ORIGINY", pixel_scene.origin.y)
                            :gsub("OFFSETX", pixel_scene.offset.x)
                            :gsub("OFFSETY", pixel_scene.offset.y)
                            :gsub("DIMENSIONSX", pixel_scene.dimensions.x)
                            :gsub("DIMENSIONSY", pixel_scene.dimensions.y)
                            :gsub("SCENEDIRECTORY", (pixel_scene.directory
                                :gsub("\\", "\\\\"):gsub("\"", "\\\"") --gsub thing nathan told me to put or the world would end idk- nvm, no worky
                            )
                        )
                    )
                end
            end
        end
    end
end

--print(tostring(pixel_scenes))


--ModLuaFileAppend("data/scripts/biome_scripts.lua", "mods/parallel_parity/files/lavalake.lua")




do return end
for pixel_scene_id, pixel_scene in pairs(localise) do
    for object, target in pairs(pixel_scene) do
        print("checking " .. string.format("parallel_parity.%s.%s", pixel_scene_id, object))
        if ModSettingGet(string.format("parallel_parity.%s.%s", pixel_scene_id, object)) == false then
            ModTextFileSetContent(target.script,
                ModTextFileGetContent(target.script):gsub(target.code,
                    "local _ = GetParallelWorldPosition(x, y) if _ == 0 then " .. target.code .. " end"))
        end
    end
end

for index, filepath in ipairs(biomelist) do
    local script = nxml.parse(ModTextFileGetContent(filepath)):first_of("Topology").attr.lua_script
    if script ~= nil then
        --ModLuaFileAppend(script, "mods/parallel_parity/files/lavalake.lua")
    end
end

ModLuaFileAppend("data/scripts/biomes/hills.lua", "mods/parallel_parity/files/lavalake.lua")
ModLuaFileAppend("data/scripts/biomes/mountain_lake.lua", "mods/parallel_parity/files/lavalake.lua")
ModLuaFileAppend("data/scripts/biomes/lavalake_pit.lua", "mods/parallel_parity/files/lavalake.lua")
ModLuaFileAppend("data/scripts/biomes/coalmine.lua", "mods/parallel_parity/files/lavalake.lua")