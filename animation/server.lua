-- Based on MasterCedric (https://github.com/MasterCedric/)
-- Based on OnfireNetwork (https://github.com/OnfireNetwork/)

local offsets = {
    ["1111"] = { -- Fishing Rod
        hand_r = {-8,6.5,-8,0,180,15}
    },
    ["1047"] = { -- Chainsaw
        hand_r = {-25,13,18,70,150,0}
    },
    ["620"] = { -- Trashsack
        hand_r = {-95,9,5,-90,60,-60}
    },
    ["654"] = { -- Package
        hand_r = {-40,20,0,90,90,0}
    },
    ["1075"] = { -- Saw
        hand_r = {-10,0,0,-30,30,50}
    },
    ["552"] = { -- Cutter
        hand_r = {-14,3,10,60,-130,0}
    },
    ["1063"] = { -- Gardening Fork/Pickaxe
        hand_r = {-10,3,75,0,0,179}
    }
}
local objects = {}

function Server_OnPlayerAnimation(player, id)
	SetPlayerAnimation(player, "STOP")
	SetPlayerAnimation(player, id)
end

AddRemoteEvent("Server_OnPlayerAnimation", Server_OnPlayerAnimation)


function SetAttachedItem(player, slot, type)
    if objects[player] ~= nil then
        if objects[player][slot] ~= nil then
            DestroyObject(objects[player][slot])
            objects[player][slot] = nil
        end
    else
        objects[player] = {}
    end
    if type == 0 then
        return
    end
    local offset = {0,0,0,0,0,0}
    if offsets[tostring(type)] ~= nil then
        if offsets[tostring(type)][slot] ~= nil then
            offset = offsets[tostring(type)][slot]
        end
    end
    local x, y, z = GetPlayerLocation(player)
    objects[player][slot] = CreateObject(type, x, y, z)
    Delay(100, function()
        SetObjectAttached(objects[player][slot], 1, player, offset[1], offset[2], offset[3], offset[4], offset[5], offset[6], slot)
    end)
end

function GetAttachedItem(player, slot)
    if objects[player] == nil then
        return 0
    end
    if objects[player][slot] == nil then
        return 0
    end
    return GetObjectModel(objects[player][slot])
end

AddEvent("OnPlayerQuit", function(player)
    if objects[player] == nil then
        return
    end
    for k,v in pairs(objects[player]) do
        DestroyObject(objects[player][k])
    end
    objects[player] = nil
end)