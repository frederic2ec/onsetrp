local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

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
            addPlayerHunger(player, 10*amount)
        end
        if item == "apple" then
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
        if item == "jerican" then
            local nearestCar = GetNearestCar(player)
            if nearestCar ~= 0 then
                print(VehicleData[nearestCar].fuel)
                if VehicleData[nearestCar].fuel >= 100 then
                    AddPlayerChat(player, _("car_full"))
                else
                    SetPlayerAnimation(player, "COMBINE")
                    RemoveInventory(player, item, amount)
                    VehicleData[nearestCar].fuel = 100
                    AddPlayerChat(player, _("car_refuelled"))
                end
            end
        end
        if item == "lockpick" then
            local nearestCar = GetNearestCar(player)
            local nearestHouseDoor = GetNearestHouseDoor(player)
            if nearestCar ~= 0 then
                if VehicleData[nearestCar] ~= nil then
                    if GetVehiclePropertyValue(nearestCar, "locked") then
                        SetPlayerAnimation(player, "LOCKDOOR")
                        Delay(3000, function()
                            SetPlayerAnimation(player, "LOCKDOOR")
                        end) 
                        Delay(6000, function()
                            SetPlayerAnimation(player, "LOCKDOOR")
                        end)
                        Delay(10000, function()
                            SetVehiclePropertyValue( nearestCar, "locked", false, true)
                            AddPlayerChat(player, _("car_unlocked"))
                            RemoveInventory(player, item, amount)
                        end)       
                    else
                        AddPlayerChat(player, _("vehicle_already_unlocked"))
                    end
                end
            end
            if nearestHouseDoor ~= 0 then
                nearestHouse = getHouseDoor(nearestHouseDoor)
                if nearestHouse ~= 0 then
                    if houses[nearestHouse].lock then
                        SetPlayerAnimation(player, "LOCKDOOR")
                        Delay(3000, function()
                            SetPlayerAnimation(player, "LOCKDOOR")
                        end) 
                        Delay(6000, function()
                            SetPlayerAnimation(player, "LOCKDOOR")
                        end)
                        Delay(10000, function()
                            houses[nearestHouse].lock = false
                            AddPlayerChat(player, _("unlock_house"))
                            RemoveInventory(player, item, amount)
                        end)   
                    else
                        AddPlayerChat(player, _("house_already_unlock"))
                    end
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