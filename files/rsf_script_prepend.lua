RegisteredFunctions = {}
Old_RegSpawnFunc = RegisterSpawnFunction
RegisterSpawnFunction = function(x, y)
    RegisteredFunctions[x] = y
    Old_RegSpawnFunc(x, y)
    --print("["..tostring(x).."] = " .. y)
end
