 --map_width is subbed in here

if init == nil then
    RegisterSpawnFunction( 0xffffeedd, "init" ) --holy shit i spent way too long debugging stupid shit until horscht reminded me i need to register spawn functions if they dont already exist am i stupid?? 😭
end

if Parallel_Parity_InitOverridden then return end
Parallel_Parity_InitOverridden = true
Parallel_Parity_old_init = init

local half_width = map_width * .5
local chunks  = {
--PIXEL SCENE APPEND!
}

init = function( x, y, w, h)
    if Parallel_Parity_old_init then Parallel_Parity_old_init(x, y, w, h) end

    local chunk = {x = x*0.001953125, y = y*0.001953125} --get chunk coordinates

    chunk.x = ((chunk.x + half_width) % map_width) - half_width --code that relativises PWs (this is all you needed to do Nolla :devasted:)

    local chunk_table = chunks[chunk.x .. "_" .. chunk.y] --get chunk table
    if chunk_table then --if there is a chunk table
        for index, scene in ipairs(chunk_table) do --iterate over all pixel scenes in the table
            EntityLoad(scene.path, x + scene.offset.x + 256, y + scene.offset.y + 256) --load the pixel scene, add 256 to pos to place it in the rough centre of the chunk
        end
    end
end