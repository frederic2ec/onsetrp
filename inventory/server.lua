AddRemoteEvent("ServerPersonalMenu", function(player) 
    CallRemoteEvent(player, "OpenPersonalMenu", PlayerData[player].cash, PlayerData[player].bank_balance, PlayerData[player].inventory)
end)


function getWeaponID(modelid)
    if modelid:find("weapon_") then
        return modelid:gsub("weapon_", "")
    end
    return 0
end

AddRemoteEvent("UseInventory", function(player, item, amount) 
    weapon = getWeaponID(item)
    if weapon ~= 0 then
        SetPlayerWeapon(player, tonumber(weapon), 1000, true, 1)
    else
        if item == "donut" then
            SetPlayerAnimation(player, "DRINKING")
            RemoveInventory(player, item, amount)
            addPlayerHunger(player, 5*amount)
        end
        if item == "water_bottle" then
            SetPlayerAnimation(player, "DRINKING")
            RemoveInventory(player, item, amount)
            addPlayerThirst(player, 25*amount)
        end
        if item == "health_kit" then
            if GetPlayerHealth(player) == 100 then
                AddPlayerChat(player, _("already_full_health"))
            else
                SetPlayerAnimation(player, "COMBINE")
                RemoveInventory(player, item, amount)
                SetPlayerHealth(player, 100)
            end
        end
        if item == "repair_kit" then
            local nearestCar = GetNearestCar(player)
            if nearestCar ~= 0 then
                if GetVehicleHealth(nearestCar) > 4000 then
                    AddPlayerChat(player, _("dont_need_repair"))
                else
                    SetPlayerAnimation(player, "COMBINE")
                    RemoveInventory(player, item, amount)
                    SetVehicleHealth(nearestCar, 5000)
                end
            end
        end
    end
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