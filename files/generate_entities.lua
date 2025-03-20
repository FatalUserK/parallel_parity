
local abs_root = "C:/Program Files (x86)/Steam/steamapps/common/Noita/mods/parallel_parity/files/"
local local_root = "mods/parallel_parity/files/"

local dirs = {
    "lavalake2"
}


for index, directory in ipairs(dirs) do
    local abs_directory = abs_root .. directory .. "/"
    local local_directory = local_root .. directory .. "/"
    local targets = {}
    local i = 0
    while(true) do
        i = i + 1
        local materials
        local gfx
        local background

        local f = io.open(abs_directory .. i .. ".png", "r")
        if f ~= nil then materials = true io.close(f) end
        local f = io.open(abs_directory .. i .. "_visual.png", "r")
        if f ~= nil then gfx = true io.close(f) end
        local f = io.open(abs_directory .. i .. "_background.png", "r")
        if f ~= nil then background = true io.close(f) end

        if materials or gfx or background then
            local file = io.open(abs_directory .. i .. ".xml", "w")
            file:write(string.format([[<Entity> <PixelSceneComponent%s%s%s skip_biome_checks="1" skip_edge_textures="1" /> </Entity>]],
                materials and " pixel_scene=\"" .. local_directory .. i .. ".png\"" or "",
                gfx and " pixel_scene_visual=\"" .. local_directory .. i .. "_visual.png\"" or "",
                background and " pixel_scene_background=\"" .. local_directory .. i .. "_background.png\"" or ""))

            io.close(file)
        else
            print(string.format("Completed Directory: \"%s\" with %s files generated", directory, i - 1))
            break
        end
    end
end