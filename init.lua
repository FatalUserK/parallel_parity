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

function OnPlayerSpawned( player_entity ) -- This runs when player entity has been created
	GamePrint( "OnPlayerSpawned() - Player entity id: " .. tostring(player_entity) )
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

]]--




local spliced_pixel_scenes = {
	lavalake2 = true,
	skull_in_desert = true,
	boss_arena = true,
	tree = true,
	watercave = true,
	mountain_lake = true,
	lake_statue = true,
	moon = ModSettingGet("parallel_parity.parallel_moons"),
	moon_dark = ModSettingGet("parallel_parity.parallel_moons"),
	lavalake_pit_bottom = true,
	gourd_room = true,
	skull = true,
}

local nxml = dofile_once("mods/parallel_parity/files/nxml.lua")
nxml.error_handler = function() end

--remove spliced pixel scenes from _pixel_scenes.xml
local pixel_scenes = nxml.parse(ModTextFileGetContent("data/biome/_pixel_scenes.xml"))
if pixel_scenes then
	local spliced_scenes = pixel_scenes:first_of("PixelSceneFiles")
	local remove_list = {}
	for elem in spliced_scenes:each_child() do
		if spliced_pixel_scenes[elem.content[#elem.content]:sub(1,-5)] then
			print("removing spliced pixel scene: " .. elem.content[#elem.content]:sub(1,-5) .. "...")
			remove_list[#remove_list+1] = elem
		end
	end
	for index, value in ipairs(remove_list) do
		spliced_scenes:remove_child(value)
	end
end
ModTextFileSetContent("data/biome/_pixel_scenes.xml", tostring(pixel_scenes))

--print(tostring(pixel_scenes))


--ModLuaFileAppend("data/scripts/biome_scripts.lua", "mods/parallel_parity/files/lavalake.lua")
ModLuaFileAppend("data/scripts/biomes/lavalake.lua", "mods/parallel_parity/files/lavalake.lua")