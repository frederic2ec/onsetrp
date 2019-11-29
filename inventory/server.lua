AddRemoteEvent("ServerPersonalMenu", function(player) 
    CallRemoteEvent(player, "OpenPersonalMenu", PlayerData[player].cash, PlayerData[player].bank_balance, PlayerData[player].inventory)
end)


function AddInventory(player, item, amount)
    if PlayerData[player].inventory[item] == nil then
        PlayerData[player].inventory[item] = amount
    else
        PlayerData[player].inventory[item] = PlayerData[player].inventory[item] + amount
    end
end

function RemoveInventory(player, item, amount)
    if PlayerData[player].inventory[item] == nil then
        return
    else
        if PlayerData[player].inventory[item] - amount < 1 then
            PlayerData[player].inventory[item] = nil
        else
            PlayerData[player].inventory[item] = PlayerData[player].inventory[item] - amount
        end
    end
end