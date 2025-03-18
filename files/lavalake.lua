

local map_width = BiomeMapGetSize() ~= 0 and BiomeMapGetSize() or 70

local origin = {x = 4, y = 0}
local dimensions = {x = 5, y = 5}
local directory = "mods/parallel_parity/files/lavalake2/"

local old_init = init
init = function( x, y, w, h )
    print("(x, y) is (" .. x .. ", " .. y .. ")")
    local chunk = {x = x/512, y = y/512} --get chunk coordinates

    while chunk.x > map_width do --logic that relativises east PWs
        print("A: chunkx is " .. chunk.x .. ", map_width is " .. map_width)
        chunk.x = chunk.x - map_width
    end
    while chunk.x < 1 do --logic that relativises west PWs
        print("B: chunkx is " .. chunk.x .. ", map_width is " .. map_width)
        chunk.x = chunk.x + map_width
    end

    print("chunk x y is " .. chunk.x .. " " .. chunk.y)

    chunk.relx,chunk.rely = chunk.x - origin.x, chunk.y - origin.y --checks coordinates relative to pixel scene origin point
    print("relx rely is " .. chunk.relx .. " " .. chunk.rely)
    if true then --check domain --chunk.relx < dimensions.x and chunk.rely < dimensions.y
        local target = chunk.relx + 1 + (chunk.rely * dimensions.x)
        print("target is " .. target)
        print("checking \"" .. directory .. target .. ".png\"")
        if ModDoesFileExist(directory .. target .. ".png") then
            print("Loading \"" .. directory .. target .. ".png\"")
            LoadPixelScene(directory .. target .. ".png", "", x, y, "")
        else
            print("no file at coordinates (" .. x .. ", " .. y.. ") for value " .. target)
        end
    end



    old_init(x, y, w, h)
end



-- 1   2   3   4   5

-- 6   7   8   9   10

-- 11  12  13  14  15

-- 16  17  18  19  20

-- 21  22  23  24  25