local player = EntityGetWithTag("player_unit")[1]
if player ~= nil then
    print(BiomeMapGetName(EntityGetTransform(player)))
end