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

local map_width = 70
local map_path = "data/biome_impl/biome_map.png"

local map,map_x,map_y = ModImageMakeEditable(map_path, 0, 0)
print(ModImageGetPixel(map, 27, 24))
print(color_abgr_split(ModImageGetPixel(map, 27, 24)))



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
    },
    --[[
	skull_in_desert = {},
	boss_arena = {},
	tree = {},
	watercave = {},
	mountain_lake = {},
	lake_statue = {},
	moon = {
        setting = "moons"
    },
	moon_dark = {
        setting = "moons"
    },
	lavalake_pit_bottom = {},
	gourd_room = {},
	skull = {},]]
}

for id, pixel_scene in pairs(spliced_pixel_scenes) do
    if not pixel_scene.setting then pixel_scene.setting = "parallel_parity." .. id else pixel_scene.setting = "parallel_parity." .. pixel_scene.setting end
    if pixel_scene.localise then
        for object, data in pairs(pixel_scene.localise) do
            if not data.setting then data.setting = "parallel_parity." .. id .. "." .. object else data.setting = "parallel_parity." .. data.setting end
        end
    end
end

local nxml = dofile_once("mods/parallel_parity/files/nxml.lua")
nxml.error_handler = function() end


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
local pixel_scenes = nxml.parse(ModTextFileGetContent("data/biome/_pixel_scenes.xml"))
if pixel_scenes then
	local spliced_scenes = pixel_scenes:first_of("PixelSceneFiles")
	local remove_list = {}
	for elem in spliced_scenes:each_child() do
        local pixel_scene_id = elem.content[#elem.content]:sub(1,-5) --acquire the pixel scene file name minus the file extension
        local target = spliced_pixel_scenes[pixel_scene_id]
		if target and (ModSettingGet("parallel_parity." .. target.setting) or ModSettingGet(target.setting)) then
			remove_list[#remove_list+1] = elem --add to list of spliced pixel scenes to remove

            if target.localise then --apply localisation changes to objects within the spliced pixel scene
                for object, data in pairs(target.localise) do
                    if ModSettingGet(target.setting) == false then
                        ModTextFileSetContent(data.script,
                            ModTextFileGetContent(data.script):gsub(data.code,
                                "local _ = GetParallelWorldPosition(x, y) if _ == 0 then " .. data.code .. " end" --encapsulate designated code within a MW check
                        ))
                    end
                end
            end

            for i = 1, target.dimensions.y, 1 do
                for j = 1, target.dimensions.x, 1 do
                    local abgr_int = ModImageGetPixel(map, target.origin.x + j + (map_x * .5) - 1, target.origin.y + i + 13)
                    local hex = ("%02x%02x%02x"):format(bit.band(abgr_int, 0xFF), bit.band(bit.rshift(abgr_int, 8), 0xFF), bit.band(bit.rshift(abgr_int, 16), 0xFF))

                    local biome = biomelist[hex]
                    biome_appends[biome] = biome_appends[biome] or {}
                    biome_appends[biome][#biome_appends[biome] + 1] = target
                    print(("(%s, %s) = %s"):format(target.origin.x + j - 1, target.origin.y + i -1, biome))
                end
            end
		end
	end
	for index, value in ipairs(remove_list) do
		spliced_scenes:remove_child(value) --remove spliced pixel scenes from file
	end
end
ModTextFileSetContent("data/biome/_pixel_scenes.xml", tostring(pixel_scenes)) --apply changes to file


for xml_path, pixel_scenes in pairs(biome_appends) do
    local biomexml = nxml.parse(ModTextFileGetContent(xml_path))
    if biomexml then
        local toplogy = biomexml:first_of("Topology")
        if toplogy then
            if toplogy.attr.lua_script then
                for key, pixel_scene in ipairs(pixel_scenes) do
                    ModTextFileSetContent(toplogy.attr.lua_script, ModTextFileGetContent(toplogy.attr.lua_script) .. 
                        ModTextFileGetContent("mods/parallel_parity/files/template_code.lua")
                            :gsub("MAPWIDTH", map_x)
                            :gsub("ORIGINX", pixel_scene.origin.x)
                            :gsub("ORIGINY", pixel_scene.origin.y)
                            :gsub("DIMENSIONSX", pixel_scene.dimensions.x)
                            :gsub("DIMENSIONSY", pixel_scene.dimensions.y)
                            :gsub("SCENEDIRECTORY", pixel_scene.directory)
                    )
                    --print(ModTextFileGetContent(toplogy.attr.lua_script))
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