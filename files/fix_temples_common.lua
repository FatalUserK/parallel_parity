if not init == nil then return end

local spawn_boss_old = spawn_boss

function init(x, y, w, h) end
function spawn_boss(x, y, w, h)
    init(x, y, w, h)
    spawn_boss_old(x, y, w, h)
end --this probably works, i genuinely dont care enough to test this super specific nolla inconsistency. If this causes a problem with a mod or a future update- let me know.
--actually though why nollaaaaa olli or arvi or whomever- you used "init" for every biome chunk initialisation function up until now and you finally break it with the temple biomes years later in epilogue 2?? :devastated: