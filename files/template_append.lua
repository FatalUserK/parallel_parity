

if init == nil then
    RegisterSpawnFunction( 0xffffeedd, "init" )
end

if Parallel_Parity_InitOverridden then return end
Parallel_Parity_InitOverridden = true
Parallel_Parity_old_init = init

local half_width = map_width * .5
local scenes  = {
--PIXEL SCENE APPEND!
}

local entities  = {
--ENTITIES APPEND!
}

init = function( x, y, w, h)
    if Parallel_Parity_old_init then Parallel_Parity_old_init(x, y, w, h) end

    local chunk = {x = x*0.001953125, y = y*0.001953125}
    chunk.x = ((chunk.x + half_width) % map_width) - half_width

    local chunk_index = chunk.x .. "_" .. chunk.y
    if scenes[chunk_index] then
        for index, scene in ipairs(scenes[chunk_index]) do
            LoadPixelScene(
                scene.materials,
                scene.gfx,
                x + scene.offset.x,
                y + scene.offset.y,
                scene.background,
                true, nil, nil, nil, true
            )
        end
    end

    if entities[chunk_index] then
        for index, entity in ipairs(entities[chunk_index]) do
            EntityLoad(entity.path, x + entity.offset.x, y + entity.offset.y )
        end
    end
end