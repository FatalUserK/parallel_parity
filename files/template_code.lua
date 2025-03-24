
local map_width = MAPWIDTH
local origin = {x = ORIGINX, y = ORIGINY}
local dimensions = {x = DIMENSIONSX, y = DIMENSIONSY}
local directory = "SCENEDIRECTORY"

local old_init = init
init = function( x, y, w, h )
    local marker = EntityLoad("data/entities/_debug/debug_marker.xml", x, y)
    old_init(x, y, w, h)
    local vsc = EntityAddComponent2(marker, "VariableStorageComponent")

    --print("(x, y) is (" .. x .. ", " .. y .. ")")
    local chunk = {x = x/512, y = y/512} --get chunk coordinates
    local pw_num = 0

    while chunk.x > map_width do --logic that relativises east PWs
        chunk.x = chunk.x - map_width
        pw_num = pw_num + 1
    end
    while chunk.x < 1 do --logic that relativises west PWs
        chunk.x = chunk.x + map_width
        pw_num = pw_num - 1
    end


    chunk.relx,chunk.rely = chunk.x - origin.x, chunk.y - origin.y --checks coordinates relative to pixel scene origin point
    if chunk.relx < dimensions.x and chunk.relx >= 0 and chunk.rely < dimensions.y and chunk.rely >= 0 then --check domain | 
        local target = chunk.relx + 1 + (chunk.rely * dimensions.x)
        local attempted
        if ModDoesFileExist(directory .. target .. ".png") then
            --LoadPixelScene(directory .. target .. ".png", "", x, y, "")
            EntityLoad(directory .. target .. ".xml", x, y)
            attempted = true
        else
            attempted = false
        end
        ComponentSetValue2(vsc, "value_string", string.format("Coordinates are: (%s, %s)\nChunk Coordinates are: (%s, %s)\nRelative Chunk Coordinates are: (%s, %s)\nTarget Value is: %s\nLoadPixelScene was attempted: %s\nPW value is %s", x, y, chunk.x, chunk.y, chunk.relx, chunk.rely, target, attempted, pw_num))
    end
end