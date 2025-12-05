local init_func_name
if RegisteredFunctions ~= nil then
	init_func_name = RegisteredFunctions[0xffffeedd]
	if init_func_name == nil then
		init_func_name = "init"
		RegisterSpawnFunction(0xffffeedd, "init")
	end
end

local worlds = {
--PARALLEL APPEND HERE!
}


local par_old_init = _G[init_func_name]
_G[init_func_name] = function(x, y, w, h)
	if par_old_init then par_old_init(x, y, w, h) end

	if GetParallelWorldPosition(x, y) == 0 then return end

	local mapw,maph = BiomeMapGetSize()
	local content = worlds[SessionNumbersGetValue("BIOME_MAP_PIXEL_SCENES") .. "|" .. mapw .. "|" .. maph]
	if content == nil then return end

	local half_width = mapw * .5
	local chunk_x,chunk_y = x*0.001953125, y*0.001953125
	chunk_x = ((chunk_x + half_width) % mapw) - half_width

	local chunk_index = chunk_x .. "_" .. chunk_y
	if content.scenes[chunk_index] then
		for _, scene in ipairs(content.scenes[chunk_index]) do
			LoadPixelScene(
				scene.materials,
				scene.gfx,
				x + scene.offset_x,
				y + scene.offset_y,
				scene.background,
				true, nil, nil, nil, true
			)
		end
	end

	if content.entities[chunk_index] then
		for index, entity in ipairs(content.entities[chunk_index]) do
			EntityLoad(entity.path, x + entity.offset_x, y + entity.offset_y )
		end
	end
end