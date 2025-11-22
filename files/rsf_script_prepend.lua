RegisteredFunctions = {}
local Old_RegSpawnFunc = RegisterSpawnFunction
RegisterSpawnFunction = function(x, y)
    RegisteredFunctions[x] = y
    Old_RegSpawnFunc(x, y)
end
--RSF DOCUMENTED
