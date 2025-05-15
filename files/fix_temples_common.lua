if not init == nil then return end

local spawn_boss_old = spawn_boss

function init(x, y, w, h) end
function spawn_boss(x, y, w, h)
    init(x, y, w, h)
    spawn_boss_old(x, y, w, h)
end