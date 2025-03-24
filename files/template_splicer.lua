
local map_width = MAPWIDTH --size of the map cuz idk you cant access it very easily on the fly
local origin = {x = ORIGINX, y = ORIGINY} --origin point in chunks
local dimensions = {x = DIMENSIONSX, y = DIMENSIONSY} --XY size of the pixel scene in chunks
local directory = "SCENEDIRECTORY" --directory to pixel scene files

local old_init = init
init = function( x, y, w, h )
    old_init(x, y, w, h)

    local chunk = {x = x/512, y = y/512} --get chunk coordinates

    while chunk.x > map_width do --logic that relativises east PWs
        chunk.x = chunk.x - map_width
    end
    while chunk.x < 1 do --logic that relativises west PWs
        chunk.x = chunk.x + map_width
    end

    chunk.relx,chunk.rely = chunk.x - origin.x, chunk.y - origin.y --checks coordinates relative to pixel scene origin point
    if chunk.relx < dimensions.x and chunk.relx >= 0 and chunk.rely < dimensions.y and chunk.rely >= 0 then --check domain
        local target = chunk.relx + 1 + (chunk.rely * dimensions.x) --unwrap xy coordinate to a single value
        if ModDoesFileExist(directory .. target .. ".png") then --if the target file exists
            EntityLoad(directory .. target .. ".xml", x, y) -- load the pixel scene
        end
    end
end