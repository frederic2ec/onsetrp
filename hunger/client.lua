
local hungerTimer = false
local thirstTimer = false


function OnPlayerSpawn(player)
    -- Hunger
    if not hungerTimer then
        CallRemoteEvent("removePlayerHunger", 0)
        hungerTimer = true
        CreateTimer(function()
            CallRemoteEvent("removePlayerHunger", 1)
        end, 120000)
    end
    -- Thirst
    if not thirstTimer then
        CallRemoteEvent("removePlayerThirst", 0)
        thirstTimer = true
        CreateTimer(function()
            CallRemoteEvent("removePlayerThirst", 1)
        end, 60000)
    end
end
AddEvent("OnPlayerSpawn", OnPlayerSpawn)

