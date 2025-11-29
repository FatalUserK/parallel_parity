local init_func_name
if RegisteredFunctions ~= nil then
	init_func_name = RegisteredFunctions[0xffffeedd] --checking what the init function is named in case some lunatic (like nolla) doesnt set it to "init"
	if init_func_name == nil then
		init_func_name = "init"
		RegisterSpawnFunction(0xffffeedd, "init")
	end
else
	GamePrint("Something has gone very *very* wrong with Parallel Parity, please message @UserK on steam or leave a comment on Parallel Parity workshop page with your modlist o/")
	print("Something has gone very *very* wrong with Parallel Parity, please message @UserK on steam or leave a comment on Parallel Parity workshop page with your modlist o/")
	return
end

--[[
local worlds = {
	["data/biome/_pixel_scenes.xml70"] = {
		scenes = {
			["0_0"] = {
				{
					materials = "wah.png",
					gfx = "wah_gfx.png",
					offset_x = 30, --ideally within bounds of 0-511
					offset_y = 412, --ideally within bounds of 0-511
					background = "wah_bg.png",
				},
				{
					materials = "wuh.png",
					gfx = "",
					offset_x = 0, --default is 0
					offset_y = 0, --default is 0
					background = "",
				},
			},
		},
		entities = {
			["-12_22"] = {
				{
					path = "bah.xml",
					offset_x = 255,
					offset_y = 255,
				},
			},
		},
	},
	["data/biome/_pixel_scenes_newgame_plus.xml"] = {
		scenes = {},
		entities = {},
	},
} --]]

local worlds = {
--PARALLEL APPEND HERE!
}


local par_old_init = _G[init_func_name]
_G[init_func_name] = function(x, y, w, h)
	if par_old_init then par_old_init(x, y, w, h) end

	if GetParallelWorldPosition(x, y) == 0 then return end --if this is not a PW, return

	local map_width = BiomeMapGetSize()
	local content = worlds[SessionNumbersGetValue("BIOME_MAP_PIXEL_SCENES") .. map_width] --index by [pixel scenes filepath .. biome width]
	if content == nil then return end

	local marker = EntityLoad("data/entities/_debug/debug_marker.xml", x, y) --for debugging purposes
	local vsc = EntityAddComponent2(marker, "VariableStorageComponent") --for debugging purposes
	local attempted --for debugging purposes
	local log = "FILENAMEHERE"

	local half_width = map_width * .5
	local chunk_x,chunk_y = x*0.001953125, y*0.001953125 --get chunk coordinates (division is about 4% slower than multiplication, this is just dividing by 512)
	chunk_x = ((chunk_x + half_width) % map_width) - half_width --code that relativises PWs (this is all Nolla needed to do :devastated:)

	local chunk_index = chunk_x .. "_" .. chunk_y --get chunk table
	if content.scenes[chunk_index] then --if there is a chunk table
		for _, scene in ipairs(content.scenes[chunk_index]) do --iterate over all pixel scenes in the table
			LoadPixelScene(
				scene.materials,
				scene.gfx,
				x + scene.offset_x,
				y + scene.offset_y,
				scene.background,
				true, nil, nil, nil, true --data to stop biomechecks from fucking killing me or something
			)
			log = log .. ("\nloading scene:\n	materials = \"%s\"\n	gfx = \"%s\"\n	background = \"%s\"\n"):format(scene.materials, scene.gfx, scene.background)
		end

		attempted = "true" --for debugging purposes
	end

	if content.entities[chunk_index] then
		log = log .. "\n"
		for index, entity in ipairs(content.entities[chunk_index]) do --iterate over all entities in the table
			EntityLoad(entity.path, x + entity.offset_x, y + entity.offset_y )
			log = log .. ("\nloading entity:\n	path = \"%s\"\n	x.offset = %s\n	y.offset = %s"):format(entity.path, entity.gfx, entity.background)
		end
	end

	ComponentSetValue2(vsc, "value_string", string.format("Coordinates are: (%s, %s)\nChunk Coordinates are: (%s, %s)\nSpawn was attempted?: %s\n\nLog:%s", x, y, chunk_x, chunk_y, attempted, log))
end