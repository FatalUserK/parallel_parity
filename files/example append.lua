 --map_width is subbed in here

 if init == nil then
    RegisterSpawnFunction( 0xffffeedd, "init" ) --holy shit i spent way too long debugging stupid shit until horscht reminded me i need to register spawn functions if they dont already exist am i stupid?? 😭
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


    local marker = EntityLoad("data/entities/_debug/debug_marker.xml", x, y) --for debugging purposes
    local vsc = EntityAddComponent2(marker, "VariableStorageComponent") --for debugging purposes
    local attempted --for debugging purposes
    local log = "false"



    local chunk = {x = x*0.001953125, y = y*0.001953125} --get chunk coordinates

    chunk.x = ((chunk.x + half_width) % map_width) - half_width --code that relativises PWs (this is all you needed to do Nolla :devasted:)

    local chunk_index = chunk.x .. "_" .. chunk.y --get chunk table
    if scenes[chunk_index] then --if there is a chunk table
        for index, scene in ipairs(scenes[chunk_index]) do --iterate over all pixel scenes in the table
            LoadPixelScene(
                scene.materials,
                scene.gfx,
                x + scene.offset.x,
                y + scene.offset.y,
                scene.background,
                true, nil, nil, nil, true --data to stop biomechecks from fucking killing me or something
            )
            log = log .. ("\nloading scene:\n    materials = \"%s\"\n    gfx = \"%s\"\n    background = \"%s\""):format(scene.materials, scene.gfx, scene.background)
        end

        attempted = "true" --for debugging purposes
    end

    if entities[chunk_index] then
        log = log .. "\n"
        for index, entity in ipairs(entities[chunk_index]) do --iterate over all entities in the table
            EntityLoad(entity.path, x + entity.offset.x, y + entity.offset.y )
            log = log .. ("\nloading entity:\n    path = \"%s\"\n    x.offset = %s\n    y.offset = %s"):format(entity.path, entity.gfx, entity.background)
        end
    end

    ComponentSetValue2(vsc, "value_string", string.format("Coordinates are: (%s, %s)\nChunk Coordinates are: (%s, %s)\nSpawn was attempted?: %s\n\nLog:%s", x, y, chunk.x, chunk.y, attempted, log))
end