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

local function color_abgr_split(abgr_int)
    local r = bit.band(abgr_int, 0xFF)
    local g = bit.band(bit.rshift(abgr_int, 8), 0xFF)
    local b = bit.band(bit.rshift(abgr_int, 16), 0xFF)
    local a = bit.band(bit.rshift(abgr_int, 24), 0xFF)

    return 

end

local map_path = "data/biome_impl/biome_map.png"

local map,map_width = ModImageMakeEditable(map_path, 0, 0)
local boundry_coordinate = map_width * 256 --get the full width of the map in pixels, divided by 2

--list of relevant biome scripts using biome xml as index key, vanilla biomescript data is pregenerated
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
                local _script_filepath = ("mods/parallel_parity/files/biomescripts/") .. biomepath:sub(1, -4) .. "lua"
                ModTextFileSetContent(_script_filepath, "")
                toplogy.attr.lua_script = _script_filepath
            end
            biome_scripts[biomepath] = toplogy.attr.lua_script
        end
    end

    return biome_scripts[biomepath]
end



local biomelist_xml = nxml.parse(ModTextFileGetContent("data/biome/_biomes_all.xml"))
if biomelist_xml then
    for elem in biomelist_xml:each_child() do
        GetBiomeScript(elem.attr.biome_filename)
    end
end

do return end

local spliced_pixel_scenes = {
    lavalake2 = {
        origin = {x = 4, y = 0},
        dimensions = {x = 5, y = 5},
        directory = "mods/parallel_parity/files/lavalake2/",
        localise = {
            ORB = {
                script = "data/scripts/biomes/lavalake.lua",
                code = [[EntityLoad%( "data/entities/items/orbs/orb_03%.xml", x%-10, y %)]]
            }
        },
        child_scenes = {

        }
    },
    --[[
    skull_in_desert = {},
    boss_arena = {},
    tree = {},
    watercave = {},
    mountain_lake = {},
    lake_statue = {},
    moon = {
        setting = "moons",
    },
    moon_dark = {
        setting = "moons",
    },
    lavalake_pit_bottom = {},
    gourd_room = {},
    skull = {},]]
}

local backgrounds = {
    {
        match = "data/biome_impl/hidden",
        setting = "backgrounds.hidden",
    },
    {
        match = "data/biome_impl/liquidcave/",
        setting = "visual",
    },
}

local pixel_scenes = {
    {
        material_filename = "data/biome_impl/pyramid/boss_limbs.png",
        setting = "pyramid_boss",
    },
    {
        material_filename = "data/biome_impl/temple/altar_vault_capsule.png",
        setting = "general",
    },
    {
        material_filename = "data/biome_impl/temple/altar_snowcastle_capsule.png",
        setting = "general",
    },
    {
        material_filename = "data/biome_impl/tower_start.png",
        setting = "general",
    },
    {
        material_filename = "data/biome_impl/the_end/the_end_shop.png",
        setting = "general",
    },
    {
        material_filename = "data/biome_impl/greed_treasure.png",
        setting = "avarice_diamond",
    },
    {
        material_filename = "data/biome_impl/fishing_hut.png",
        setting = "fishing_hut",
    },
    {
        material_filename = "data/biome_impl/overworld/essence_altar",
        setting = "essence_eaters",
    },
    {
        material_filename = "data/biome_impl/bunker.png",
        setting = "fishing_hut",
    },
    {
        material_filename = "data/biome_impl/bunker2.png",
        setting = "fishing_hut",
    },
    {
        material_filename = "data/biome_impl/overworld/snowy_ruins_eye_pillar.png",
        setting = "general",
    },
    {
        material_filename = "data/biome_impl/rainbow_cloud.png",
        setting = "general",
    },
    {
        material_filename = "data/biome_impl/overworld/cliff_visual.png",
        setting = "visual",
    },
    {
        material_filename = "data/biome_impl/eyespot.png",
        setting = "fungal_altars",
    },
    {
        material_filename = "data/biome_impl/overworld/desert_ruins_base_01.png",
        setting = "general",
    },
    {
        material_filename = "data/biome_impl/overworld/music_machine_stand.png",
        setting = "music_machines",
    },
}

local entities = {
    {
        filepath = "data/entities/props/music_machines/music_machine_00.xml",
        setting = "music_machines",
    },
    {
        filepath = "data/entities/props/music_machines/music_machine_01.xml",
        setting = "music_machines",
    },
    {
        filepath = "data/entities/props/music_machines/music_machine_02.xml",
        setting = "music_machines",
    },
    {
        filepath = "data/entities/props/music_machines/music_machine_03.xml",
        setting = "music_machines",
    },
    {
        filepath = "data/entities/props/physics_fungus.xml",
        setting = "tree",
    },
    {
        filepath = "data/entities/props/physics_fungus_big.xml",
        setting = "tree",
    },
    {
        filepath = "data/entities/props/physics_fungus_small.xml",
        setting = "tree",
    },
    {
        filepath = "data/entities/props/physics/bridge_spawner.xml",
        setting = "lavalake2",
    },
    {
        filepath = "data/entities/buildings/essence_eater.xml",
        setting = "essence_eaters",
    },
    {
        filepath = "data/entities/misc/platform_wide.xml",
        setting = "general",
    },
    {
        filepath = "data/entities/buildings/eyespot_a.xml",
        setting = "fungal_altars",
    },
    {
        filepath = "data/entities/buildings/eyespot_b.xml",
        setting = "fungal_altars",
    },
    {
        filepath = "data/entities/buildings/eyespot_c.xml",
        setting = "fungal_altars",
    },
    {
        filepath = "data/entities/buildings/eyespot_d.xml",
        setting = "fungal_altars",
    },
    {
        filepath = "data/entities/buildings/eyespot_e.xml",
        setting = "fungal_altars",
    },
}


for id, pixel_scene in pairs(spliced_pixel_scenes) do
    if not ModSettingGet(pixel_scene.setting and ("parallel_parity." .. pixel_scene.setting) or ("parallel_parity." .. id)) then
        pixel_scene = nil
        goto continue
    end
    if not pixel_scene.offset then pixel_scene.offset = {x = 0, y = 0} end
    if pixel_scene.localise then
        for object, data in pairs(pixel_scene.localise) do
            if not data.setting then data.setting = "parallel_parity." .. id .. "." .. object else data.setting = "parallel_parity." .. data.setting end
        end
    end
    ::continue::
end

local filtered_backgrounds = {}
for i = 1, #backgrounds, 1 do
    if ModSettingGet("parallel_parity." .. backgrounds[i].setting) then
        filtered_backgrounds[#filtered_backgrounds+1] = backgrounds[i]
    end
end

local filtered_ps = {}
for i = 1, #pixel_scenes, 1 do
    if ModSettingGet("parallel_parity." .. pixel_scenes[i].setting) then
        filtered_ps[#filtered_ps+1] = pixel_scenes[i]
    end
end



local biomelist = {}

local biomelist_xml = nxml.parse(ModTextFileGetContent("data/biome/_biomes_all.xml"))
if biomelist_xml then
    for elem in biomelist_xml:each_child() do
        biomelist[(elem.attr.color):lower():sub(3,-1)] = elem.attr.biome_filename
        --print(("biomelist[%s] = %s"):format((elem.attr.color):lower():sub(3,-1), elem.attr.biome_filename))
    end
end


local biome_appends = {}

local spliced_pixel_scenes = {
    ["data/biome_impl/spliced/lavalake2.xml"] = ModSettingGet(""),
    ["data/biome_impl/spliced/skull_in_desert.xml"] = ModSettingGet(""),
    ["data/biome_impl/spliced/boss_arena.xml"] = ModSettingGet(""),
    ["data/biome_impl/spliced/tree.xml"] = ModSettingGet(""),
    ["data/biome_impl/spliced/watercave.xml"] = ModSettingGet(""),
    ["data/biome_impl/spliced/mountain_lake.xml"] = ModSettingGet(""),
    ["data/biome_impl/spliced/lake_statue.xml"] = ModSettingGet(""),
    ["data/biome_impl/spliced/moon.xml"] = ModSettingGet(""),
    ["data/biome_impl/spliced/moon_dark.xml"] = ModSettingGet(""),
    ["data/biome_impl/spliced/lavalake_pit_bottom.xml"] = ModSettingGet(""),
    ["data/biome_impl/spliced/gourd_room.xml"] = ModSettingGet(""),
    ["data/biome_impl/spliced/skull.xml"] = ModSettingGet(""),
}

--remove spliced pixel scenes from _pixel_scenes.xml
local pixel_scenes = nxml.parse(ModTextFileGetContent("data/biome/_pixel_scenes.xml")) --get all global pixel scenes
if pixel_scenes then
    local spliced_scenes = pixel_scenes:first_of("PixelSceneFiles")
    local remove_list = {}
    for elem in spliced_scenes:each_child() do --run through spliced pixel scenes
        local pixel_scene_id = elem.content[#elem.content]:sub(1,-5) --acquire the pixel scene file name minus the file extension
        local target = spliced_pixel_scenes[pixel_scene_id]
        if target and (ModSettingGet("parallel_parity." .. target.setting) or ModSettingGet(target.setting)) then --make sure it exists and is enabled
            remove_list[#remove_list+1] = elem --add to list of spliced pixel scenes to remove

            if target.localise then --apply localisation changes to objects within the spliced pixel scene
                for object, data in pairs(target.localise) do
                    if ModSettingGet(target.setting) == false then --if spawning in PWs is disallowed
                        ModTextFileSetContent(data.script,
                            ModTextFileGetContent(data.script):gsub(data.code, --encapsulate designated code within a MW check
                                "local _ = GetParallelWorldPosition(x, y) if _ == 0 then " .. data.code .. " end"
                        ))
                    end
                end
            end

            for i = 1, target.dimensions.y, 1 do --iterate over the part of the biomemap this takes up
                for j = 1, target.dimensions.x, 1 do
                    local abgr_int = ModImageGetPixel(map, target.origin.x + j + (map_width * .5) - 1, target.origin.y + i + 13) --get pixel colour as ABGR integer
                    local hex = ("%02x%02x%02x"):format(bit.band(abgr_int, 0xFF), bit.band(bit.rshift(abgr_int, 8), 0xFF), bit.band(bit.rshift(abgr_int, 16), 0xFF)) --convert it to something sane

                    local biome = biomelist[hex]
                    biome_appends[biome] = biome_appends[biome] or {}
                    biome_appends[biome][#biome_appends[biome] + 1] = target --add pixel scene to biome_appends table under biomexml path as a key
                end
            end
        end
    end
    for index, value in ipairs(remove_list) do
        spliced_scenes:remove_child(value) --remove spliced pixel scenes from file
    end


    for elem in pixel_scenes:first_of("BackgroundImages") do
        
    end
end
ModTextFileSetContent("data/biome/_pixel_scenes.xml", tostring(pixel_scenes)) --apply changes to file


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
        ModLuaFileAppend(script, "mods/parallel_parity/files/lavalake.lua")
    end
end

ModLuaFileAppend("data/scripts/biomes/hills.lua", "mods/parallel_parity/files/lavalake.lua")
ModLuaFileAppend("data/scripts/biomes/mountain_lake.lua", "mods/parallel_parity/files/lavalake.lua")
ModLuaFileAppend("data/scripts/biomes/lavalake_pit.lua", "mods/parallel_parity/files/lavalake.lua")
ModLuaFileAppend("data/scripts/biomes/coalmine.lua", "mods/parallel_parity/files/lavalake.lua")