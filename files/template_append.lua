

if init == nil then
    RegisterSpawnFunction( 0xffffeedd, "init" )
end

if Parallel_Parity_InitOverridden then return end
Parallel_Parity_InitOverridden = true
Parallel_Parity_old_init = init

local half_width = map_width * .5
local scenes  = {
    regular = {
--REGULAR PIXEL SCENE APPEND!
    },
    ng_plus = {
--NG_PLUS PIXEL SCENE APPEND!
    }
}

local entities  = {
    regular = {
--REGULAR ENTITIES APPEND!
    },
    ng_plus = {
--NG_PLUS ENTITIES APPEND!
    }
}

init = function( x, y, w, h)
    print("a")
    if Parallel_Parity_old_init then Parallel_Parity_old_init(x, y, w, h) end
    if GetParallelWorldPosition(x, y) == 0 then return end
    print("b")

    local world_type = SessionNumbersGetValue("NEW_GAME_PLUS_COUNT") == "0" and "regular" or "ng_plus"
    if #scenes[world_type] == 0 then print('FILEHERE') return end
    print("c")

    local chunk = {x = x * 0.001953125, y = y * 0.001953125}
    chunk.x = ((chunk.x + half_width) % map_width) - half_width
    print("d")

    local chunk_index = chunk.x .. "_" .. chunk.y
    if scenes[world_type][chunk_index] then
        for index, scene in ipairs(scenes[world_type][chunk_index]) do
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

    if entities[world_type][chunk_index] then
        for index, entity in ipairs(entities[chunk_index]) do
            EntityLoad(entity.path, x + entity.offset.x, y + entity.offset.y )
        end
    end
end