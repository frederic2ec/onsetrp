math.randomseed( os.time() )

local oldrandom = math.random
local randomtable
math.random = function()
    if randomtable == nil then
        randomtable = {}
        for i = 1, 97 do
            randomtable[i] = oldrandom()
        end
    end
    local x = oldrandom()
    local i = 1 + math.floor(97 * x)
    x, randomtable[i] = randomtable[i], x
    return math.floor(x * 100)
end