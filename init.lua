--hope to god some lunatic doesnt modify this
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

--get biomescript from biomexml. note: look into merging with MapGetBiomeScript()
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

local biomelist = {}
local biomelist_xml = nxml.parse(ModTextFileGetContent("data/biome/_biomes_all.xml"))
if biomelist_xml then
    for elem in biomelist_xml:each_child() do
        biomelist[(elem.attr.color):lower():sub(3,-1)] = elem.attr.biome_filename
        --print(("biomelist[%s] = %s"):format((elem.attr.color):lower():sub(3,-1), elem.attr.biome_filename))
    end
end

--get biomescript from chunk coordinate
local function MapGetBiomeScript(chunk_pos_x, chunk_pos_y)
    local map_pos_x = (chunk_pos_x + (map_width * .5))

    local map_pos_y = chunk_pos_y + 14
	map_pos_y = math.max(map_pos_y, 0)
	map_pos_y = math.min(map_pos_y, map_height - 1)

    local abgr_int = ModImageGetPixel(map, map_pos_x, map_pos_y) --get pixel colour as ABGR integer
    local hex = ("%02x%02x%02x"):format(bit.band(abgr_int, 0xFF), bit.band(bit.rshift(abgr_int, 8), 0xFF), bit.band(bit.rshift(abgr_int, 16), 0xFF)) --convert it to something sane
    if hex == "000000" then return nil end
    return GetBiomeScript(biomelist[hex], true)
end



local force_true = true

--table used to cache all mod settings and flag stuff like that so i dont have to call ModSettingGet duplicates
local settings = {
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
    ["data/biome_impl/snowcastle/forge.png"] =                      settings.general,
    ["data/biome_impl/temple/altar_snowcave_capsule.png"] =         settings.general,
    ["data/biome_impl/huussi.png"] =                                settings.general,

    ["data/biome_impl/overworld/essence_altar.png"] =               settings.essence_eaters,
    ["data/biome_impl/overworld/essence_altar_desert.png"] =        settings.essence_eaters,

    ["data/biome_impl/overworld/snowy_ruins_eye_pillar.png"] =      settings.fungal_altars,
    ["data/biome_impl/rainbow_cloud.png"] =                         settings.fungal_altars,
    ["data/biome_impl/eyespot.png"] =                               settings.fungal_altars,

    ["data/biome_impl/fishing_hut.png"] =                           settings.fishing_hut,
    ["data/biome_impl/bunker.png"] =                                settings.fishing_hut and settings.fishing_bunkers,
    ["data/biome_impl/bunker2.png"] =                               settings.fishing_hut and settings.fishing_bunkers,

    ["data/biome_impl/pyramid/boss_limbs.png"] =                    settings.pyramid_boss,
    ["data/biome_impl/greed_treasure.png"] =                        settings.avarice_diamond,
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
    ["data/entities/buildings/maggotspot.xml"] =                    settings.meat_skull,
    ["data/entities/animals/boss_fish/fish_giga.xml"] =             settings.leviathan,
    ["data/entities/items/pickup/evil_eye.xml"] =                   settings.evil_eye,
}


local portals = {
    ["data/entities/buildings/teleport_bunker.xml"] =                       settings.portal_general,
    ["data/entities/buildings/teleport_bunker_back.xml"] =                  settings.portal_general,
    ["data/entities/buildings/teleport_bunker2.xml"] =                      settings.portal_general,
    ["data/entities/buildings/teleport_meditation_cube.xml"] =              settings.portal_general,
    ["data/entities/buildings/teleport_meditation_cube_return.xml"] =       settings.portal_general,
    ["data/entities/buildings/teleport_snowcave_buried_eye.xml"] =          settings.portal_general,
    ["data/entities/buildings/teleport_snowcave_buried_eye_return.xml"] =   settings.portal_general,
    ["data/entities/buildings/teleport_hourglass.xml"] =                    settings.portal_general,
    ["data/entities/buildings/teleport_hourglass_return.xml"] =             settings.portal_general,
    ["data/entities/buildings/teleport_ending_victory.xml"] =               settings.portal_general, --kolmi death portal
    ["data/entities/buildings/teleport_start.xml"] =                        settings.portal_general,
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
    ["data/entities/buildings/teleport_robot_egg_return.xml"] =             settings.portal_summon,
}

local biome_appends = {
    {},
    {},
}

--remove spliced pixel scenes from _pixel_scenes.xml

local pixel_scene_files = { --grab pixel scene files, all 2 of them
    nxml.parse(ModTextFileGetContent("data/biome/_pixel_scenes.xml")),
    --settings.ng_plus and nxml.parse(ModTextFileGetContent("data/biome/_pixel_scenes_newgame_plus.xml")),
}

for index, _pixel_scenes in ipairs(pixel_scene_files) do --iterate over like this cuz this seemed like the easiest way to slip NG+ pixel scenes into my script

    local ps_file = index-- == 1 and "regular" or "ng_plus" --nathan would love this system

    local ps_data = {
        spliced = _pixel_scenes:first_of("PixelSceneFiles"),
        backgrounds = _pixel_scenes:first_of("BackgroundImages"),
        scenes = _pixel_scenes:first_of("mBufferedPixelScenes"),
    }
    local remove_list = { --create remove list- for some reason ig
        spliced = {},
        backgrounds = {},
        scenes = {},
    }
    for sps in ps_data.spliced:each_child() do --run through spliced pixel scenes
        local spliced_scene_id = sps.content[#sps.content]:sub(1,-5) --acquire the pixel scene file name minus the file extension
        if spliced_pixel_scenes[spliced_scene_id] then --check if pixel scene is flagged
            remove_list.spliced[#remove_list.spliced+1] = sps --add to list of spliced pixel scenes to remove

            local sps_filepath = ""
            for i = 1, #sps.content, 1 do
                sps_filepath = sps_filepath .. sps.content[i]
            end

            if ModDoesFileExist(sps_filepath) then
                local sps_data = nxml.parse(ModTextFileGetContent(sps_filepath))
                if sps_data and sps_data.children[1] then --this should generally just be one singular mBufferedPixelScenes component. if theres more than one child in the file then i feel i cant really be blamed for the lunacy of other modders
                    for chunk in sps_data.children[1]:each_child() do
                        local chunk_pos_x = math.floor(chunk.attr.pos_x * 0.001953125) --i heard somewhere multiplication is more efficient than dividing so i hope thats true
                        local chunk_pos_y = math.floor(chunk.attr.pos_y * 0.001953125)

                        local biomescript = MapGetBiomeScript(chunk_pos_x, chunk_pos_y)

                        if biomescript ~= nil then
                            local chunk_key = chunk_pos_x .. "_" .. chunk_pos_y --hehe chunky 
                            biome_appends[ps_file][biomescript] = biome_appends[ps_file][biomescript] or {scenes = {}, entities = {}}
                            biome_appends[ps_file][biomescript].scenes[chunk_key] = biome_appends[ps_file][biomescript].scenes[chunk_key] or {}
                            biome_appends[ps_file][biomescript].scenes[chunk_key][#biome_appends[ps_file][biomescript].scenes[chunk_key] + 1] = {
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
        end
    end

    for bg in ps_data.backgrounds:each_child() do
        if pixel_scenes[bg.attr.filename] then
            remove_list.backgrounds[#remove_list.backgrounds+1] = bg
            local chunk_pos_x = math.floor(bg.attr.x * 0.001953125)
            local chunk_pos_y = math.floor(bg.attr.y * 0.001953125)

            local biomescript = MapGetBiomeScript(chunk_pos_x, chunk_pos_y)

            if biomescript ~= nil then
                local chunk_key = chunk_pos_x .. "_" .. chunk_pos_y
                biome_appends[ps_file][biomescript] = biome_appends[ps_file][biomescript] or {scenes = {}, entities = {}}
                biome_appends[ps_file][biomescript].scenes[chunk_key] = biome_appends[ps_file][biomescript].scenes[chunk_key] or {}
                biome_appends[ps_file][biomescript].scenes[chunk_key][#biome_appends[ps_file][biomescript].scenes[chunk_key] + 1] = {
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
    end

    for elem in ps_data.scenes:each_child() do
        if pixel_scenes[elem.attr.just_load_an_entity] or pixel_scenes[elem.attr.material_filename] or pixel_scenes[elem.attr.colors_filename] or pixel_scenes[elem.attr.background_filename] then
            remove_list.scenes[#remove_list.scenes+1] = elem
            local chunk_pos_x = math.floor(elem.attr.pos_x * 0.001953125)
            local chunk_pos_y = math.floor(elem.attr.pos_y * 0.001953125)

            local biomescript = MapGetBiomeScript(chunk_pos_x, chunk_pos_y)

            if biomescript then --do this check cuz map x is no longer modulated, this is to cull additional scenes thrown in PWs, this might break compat with future mods that specifically want a pixel scene in a PW but i can burn that bridge when it comes to it
                local chunk_key = chunk_pos_x .. "_" .. chunk_pos_y
                biome_appends[ps_file][biomescript] = biome_appends[ps_file][biomescript] or {scenes = {}, entities = {}}
                if elem.attr.just_load_an_entity then
                    biome_appends[ps_file][biomescript].entities[chunk_key] = biome_appends[ps_file][biomescript].entities[chunk_key] or {}
                    biome_appends[ps_file][biomescript].entities[chunk_key][#biome_appends[ps_file][biomescript].entities[chunk_key] + 1] = {
                        path = elem.attr.just_load_an_entity,
                        offset = {
                            x = elem.attr.pos_x - (chunk_pos_x * 512),
                            y = elem.attr.pos_y - (chunk_pos_y * 512),
                        }
                    }
                else
                    biome_appends[ps_file][biomescript].scenes[chunk_key] = biome_appends[ps_file][biomescript].scenes[chunk_key] or {}
                    biome_appends[ps_file][biomescript].scenes[chunk_key][#biome_appends[ps_file][biomescript].scenes[chunk_key] + 1] = {
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

    ModTextFileSetContent("data/biome/_pixel_scenes.xml", tostring(_pixel_scenes)) --apply changes to file
    print(tostring(_pixel_scenes))
end



local function dump(o, offset_amount)
    local offset_amount = offset_amount or 0
    local function offset()
        local _offset = ""
        for i = 1, offset_amount, 1 do
            _offset = _offset .. " "
        end
        return _offset
    end

    if type(o) == 'table' then
        local s = '{\n'
        offset_amount = offset_amount + 4
        for k,v in pairs(o) do
            if type(k) ~= 'number' then k = '"'..k..'"' end
            if type(v) == 'string' then v = '"'..v..'"' end
            s = s .. offset() .. '['..k..'] = ' .. dump(v, offset_amount) .. ',\n'
       end
       offset_amount = offset_amount - 4
       return s.. offset() .. '}'
    else
       return tostring(o)
    end
end

--print(dump(biome_appends))

local map_width_prepend = "local map_width = " .. map_width
for index, world in ipairs(biome_appends) do
    local target_world = ({"--REGULAR", "--NG_PLUS"})[index]
    print(target_world)

    for biomescript, biome in pairs(world) do

        local scenes_insert = ""
        for chunk_index, chunk in pairs(biome.scenes) do
            scenes_insert = scenes_insert .. "    [\"" .. chunk_index .. "\"] = {\n"
            for _, pixel_scene in ipairs(chunk) do
                if pixel_scene.materials == "" then pixel_scene.materials = "mods/parallel_parity/files/nil_materials.png" end
                scenes_insert = scenes_insert .. "{materials = \"" .. pixel_scene.materials .. "\", gfx = \"" .. pixel_scene.gfx .. "\", background = \"" .. pixel_scene.background .. "\", offset = { x = " .. pixel_scene.offset.x .. ", y = " .. pixel_scene.offset.y .. " }},\n"
            end
            scenes_insert = scenes_insert .. "    },\n"
        end

        local entities_insert = ""
        for chunk_index, chunk in pairs(biome.entities) do
            entities_insert = entities_insert .. "    [\"" .. chunk_index .. "\"] = {\n"
            for _, entity in ipairs(chunk) do
                entities_insert = entities_insert .. "        {path = \"" .. entity.path .. "\", offset = { x = " .. entity.offset.x .. ", y = " .. entity.offset.y .. " }},\n"
            end
            entities_insert = entities_insert .. "    },\n"
        end


        local filename
        for str in string.gmatch(biomescript, "([^/]+)") do --i stole the gmatch string, i still dont get string patterns 😭
            filename = str
        end

        local append_path = "mods/parallel_parity/generated/append_" .. filename
        ModTextFileSetContent(append_path,
            map_width_prepend .. ModTextFileGetContent("mods/parallel_parity/files/template_append.lua")
                :gsub(target_world .. " PIXEL SCENE APPEND!", scenes_insert or "")
                :gsub(target_world .. " ENTITIES APPEND!", entities_insert or "")
                :gsub("FILEHERE", append_path)
        )
        ModLuaFileAppend(biomescript, append_path)
        print(ModTextFileGetContent(append_path)) --uncomment this to get a full print of every generated append file
    end
end


--Special Main-World Localisation

local localise = {
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
    }
}

for path, biome in pairs(localise) do
    for index, targets in ipairs(biome) do
        for index, code in ipairs(targets) do
            ModTextFileSetContent(path, ModTextFileGetContent(path):gsub(code, "local _ = GetParallelWorldPosition(x, y) if _ == 0 then " .. code .. " end"))
        end
    end
end



for path, value in pairs(portals) do
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



--Special support for the Summon Portal spell and related hints in Underground Jungle
if settings.portal_summon then
    print("yap")
    ModTextFileSetContent("data/scripts/biomes/rainforest.lua",
        ModTextFileGetContent("data/scripts/biomes/rainforest.lua")
            --:gsub("return pos_x >= x and pos_x <= x%+w", "local _ = GetParallelWorldPosition(x, y)\nreturn pos_x >= x%-%(_%*".. map_width .."%*512%) and pos_x <= x%+w%-(_%*".. map_width .."%*512)")
            :gsub("local portal_x, portal_y = get_portal_position%(%)", "local portal_x, portal_y = get_portal_position()\nlocal _ = GetParallelWorldPosition(x, y)\nportal_x = portal_x%-(_%*".. map_width .."%*512)")
    )
end

--print(ModTextFileGetContent("data/scripts/biomes/rainforest.lua"))
