--!strict
local function joinData<config, target>(config: config, target: target): config & target

    assert(type(target) == 'table', 'Target must be a table.')
    assert(type(config) == 'table', 'Config  must be a table.')

    for index, default in pairs(config) do

        if not target[index] then
            target[index] = default
        end

        if typeof(config[index]) == 'table' then
            target[index] = joinData(config[index], target[index])
        end
    end

    return target
end

return joinData