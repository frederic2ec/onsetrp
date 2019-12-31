local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

AddRemoteEvent("ServerPersonalMenu", function(player)
    local x, y, z = GetPlayerLocation(player)
    local nearestPlayers = GetPlayersInRange3D(x, y, z, 1000)
    local playerList = {}
    for k,v in pairs(nearestPlayers) do
        if k ~= player then
            playerList[tostring(k)] = GetPlayerName(k)
        end
    end
    CallRemoteEvent(player, "OpenPersonalMenu", GetPlayerCash(player), PlayerData[player].bank_balance, PlayerData[player].inventory, playerList)
end)


function getWeaponID(modelid)
    if modelid:find("weapon_") then
        return modelid:gsub("weapon_", "")
    end
    return 0
end

AddRemoteEvent("UseInventory", function(player, item, amount)
    weapon = getWeaponID(item)
    if tonumber(PlayerData[player].inventory[item]) < tonumber(amount) then
        AddPlayerChat(player, _("not_enough_item"))
    else
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
                        CallRemoteEvent(player, "LockControlMove", true)
                        SetPlayerAnimation(player, "COMBINE")
                        Delay(4000, function()
                            RemoveInventory(player, item, amount)
                            SetVehicleHealth(nearestCar, 5000)
                            for i=1,8 do
                                SetVehicleDamage(nearestCar, i, 0)
                            end
                            CallRemoteEvent(player, "LockControlMove", false)
                            SetPlayerAnimation(player, "STOP")
                        end)
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
                        CallRemoteEvent(player, "LockControlMove", true)
                        SetPlayerAnimation(player, "COMBINE")
                        Delay(4000, function()
                            RemoveInventory(player, item, amount)
                            VehicleData[nearestCar].fuel = 100
                            AddPlayerChat(player, _("car_refuelled"))
                            CallRemoteEvent(player, "LockControlMove", false)
                            SetPlayerAnimation(player, "STOP")
                        end)
                    end
                end
            end
            if item == "lockpick" then
                local nearestCar = GetNearestCar(player)
                local nearestHouseDoor = GetNearestHouseDoor(player)
                if nearestCar ~= 0 then
                    if VehicleData[nearestCar] ~= nil then
                        if GetVehiclePropertyValue(nearestCar, "locked") then
                            CallRemoteEvent(player, "LockControlMove", true)
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
                                CallRemoteEvent(player, "LockControlMove", false)
                                SetPlayerAnimation(player, "STOP")
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
                            CallRemoteEvent(player, "LockControlMove", true)
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
                                CallRemoteEvent(player, "LockControlMove", false)
                                SetPlayerAnimation(player, "STOP")
                            end)
                        else
                            AddPlayerChat(player, _("house_already_unlock"))
                        end
                    end
                end
            end
        end
    end
end)

AddRemoteEvent("TransferInventory", function(player, item, amount, toplayer)
    if PlayerData[player].inventory[item] < tonumber(amount) then
        CallRemoteEvent(player, "MakeNotification", _("not_enough_item"), "linear-gradient(to right, #ff5f6d, #ffc371)")
    else
        AddInventory(tonumber(toplayer), item, tonumber(amount))
        RemoveInventory(tonumber(player ), item, tonumber(amount))
        
        CallRemoteEvent(player, "MakeNotification", _("successful_transfer", amount, item, GetPlayerName(tonumber(toplayer))), "linear-gradient(to right, #00b09b, #96c93d)")
        CallRemoteEvent(tonumber(toplayer), "MakeNotification", _("received_transfer", amount, item, GetPlayerName(player)), "linear-gradient(to right, #00b09b, #96c93d)")
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

function GetPlayerCash(player)
    if PlayerData[player].inventory['cash'] then
        return math.tointeger(PlayerData[player].inventory['cash'])
    else
        return 0
    end
end

function SetPlayerCash(player, amount)
    PlayerData[player].inventory['cash'] = math.max(math.tointeger(amount), 0)
end

function AddPlayerCash(player, amount)
    AddInventory(player, 'cash', math.tointeger(amount))
end

function RemovePlayerCash(player, amount)
    RemoveInventory(player, 'cash', math.tointeger(amount))
end

AddFunctionExport("AddInventory", AddInventory)
AddFunctionExport("RemoveInventory", RemoveInventory)
AddFunctionExport("GetPlayerCash", GetPlayerCash)
AddFunctionExport("SetPlayerCash", SetPlayerCash)
AddFunctionExport("AddPlayerCash", AddPlayerCash)
AddFunctionExport("RemovePlayerCash", RemovePlayerCash)

AddEvent("OnPackageStart", function()

end)
