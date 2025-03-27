
local map_width = MAPWIDTH --size of the map cuz idk you cant access it very easily on the fly
local origin = {x = ORIGINX, y = ORIGINY} 
local offset = {x = OFFSETX, y = OFFSETY}
local dimensions = {x = DIMENSIONSX, y = DIMENSIONSY} --XY size of the pixel scene in chunks
local directory = "SCENEDIRECTORY" --directory to pixel scene files

local spliced_pixel_scenes = {
    {
        is_spliced = true,
        origin = {x = 0, y = 0}, --origin point in chunks
        offset = {x = 0, y = 0},
        width = 0, --width of pixel scene in chunks
        height = 0, --height of pixel scene in chunks
        directory = "" --directory to its folder
    }
}

local pixel_scenes = {
    {
        origin = {x = 0, y = 0},
        offset = {x = 0, y = 0},
        directory = "" --directory to its file
    }
}

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

    for index, ps in ipairs(spliced_pixel_scenes) do
        chunk.relx,chunk.rely = chunk.x - ps.origin.x, ps.chunk_y - ps.origin.y --checks coordinates relative to pixel scene origin point
        if chunk.relx < ps.width and chunk.relx >= 0 and chunk.rely < ps.height and chunk.rely >= 0 then --check domain
            local target = ps.directory .. (chunk.relx + 1 + (chunk.rely * ps.width)) .. ".xml" --unwrap xy coordinate to a single value and convert to filepath
            if ModDoesFileExist(target) then --if the target file exists
                EntityLoad(target, x + ps.offset.x, y + ps.offset.y) -- load the pixel scene
            end
        end
    end
    for index, ps in ipairs(pixel_scenes) do
        if chunk.x == ps.origin.x and chunk.y == ps.origin.y then --check domain
            if ModDoesFileExist(ps.directory) then --if the target file exists
                EntityLoad(ps.directory, x + ps.offset.x, y + ps.offset.y) -- load the pixel scene
            end
        end
    end
end