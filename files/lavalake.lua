

local map_width = BiomeMapGetSize()

--local origin = {x = 4, y = 1}

old_init = init
init = function( x, y, w, h )
    old_init(x, y, w, h)
    local chunkx = x/512
    while chunkx > map_width do
        print("A: chunkx is " .. chunkx .. ", map_width is " .. map_width)
        chunkx = chunkx - map_width
    end
    while chunkx < 1 do
        print("B: chunkx is " .. chunkx .. ", map_width is " .. map_width)
        chunkx = chunkx + map_width
    end
end