local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local inventory_base_max_slots = 50
local backpack_slot_to_add = 35

local droppedObjectsPickups = {}

AddRemoteEvent("ServerPersonalMenu", function(player, inVehicle, vehiclSpeed)
    if inVehicle and GetPlayerState(player) == PS_DRIVER and vehiclSpeed > 0 then
        return CallRemoteEvent(player, "MakeErrorNotification", _("cant_while_driving"))
    end

    local x, y, z = GetPlayerLocation(player)
    local nearestPlayers = GetPlayersInRange3D(x, y, z, 1000)
    local playerList = {}
    for k,v in pairs(nearestPlayers) do
        if k ~= player then
            table.insert(playerList, { id = k, name = GetPlayerName(k) })
        end
    end

    CallRemoteEvent(player, "OpenPersonalMenu", Items, PlayerData[player].inventory, PlayerData[player].name, player, playerList, GetPlayerMaxSlots(player))
end)


function getWeaponID(modelid)
    if modelid:find("weapon_") then
        return modelid:gsub("weapon_", "")
    end
    return 0
end

AddRemoteEvent("UseInventory", function(player, originPlayer, itemName, amount, inVehicle, vehiclSpeed)
    if inVehicle and GetPlayerState(player) == PS_DRIVER and vehiclSpeed > 0 then
        return CallRemoteEvent(player, "MakeErrorNotification", _("cant_while_driving"))
    end

    local item

    for k, itemPair in pairs(Items) do
        if itemPair.name == itemName then
            item = itemPair
        end
    end

    weapon = getWeaponID(itemName)
    if tonumber(PlayerData[originPlayer].inventory[itemName]) < tonumber(amount) then
        AddPlayerChat(player, _("not_enough_item"))
    else
        if weapon ~= 0 then
            SetPlayerWeapon(player, tonumber(weapon), 1000, true, 1)
        else
            if itemName == "donut" or  itemName == "apple" or itemName == "peach" or itemName == "water_bottle" then
                UseItem(player, originPlayer, item, amount)
            end
            if itemName == "health_kit" then
                if GetPlayerHealth(player) == 100 then
                    AddPlayerChat(player, _("already_full_health"))
                else
                    SetPlayerAnimation(player, "COMBINE")
                    RemoveInventory(originPlayer, itemName, amount)
                    SetPlayerHealth(player, 100)
                end
            end
            if itemName == "repair_kit" then
                local nearestCar = GetNearestCar(player)
                if nearestCar ~= 0 then
                    if GetVehicleHealth(nearestCar) > 4000 then
                        AddPlayerChat(player, _("dont_need_repair"))
                    elseif GetVehicleHoodRatio(nearestCar) ~= 60.0 and GetVehicleModel(nearestCar) ~= 10  then
                        AddPlayerChat(player, _("need_to_open_hood"))
                    else
                        CallRemoteEvent(player, "LockControlMove", true)
                        SetPlayerAnimation(player, "COMBINE")
                        Delay(4000, function()
                            RemoveInventory(originPlayer, itemName, amount)
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
            if itemName == "jerican" then
                if GetPlayerState(player) >= 2 then
                    CallRemoteEvent(player, "MakeSuccessNotification", _("cant_while_driving"))
                else
                    local nearestCar = GetNearestCar(player)
                    if nearestCar ~= 0 then
                        if VehicleData[nearestCar].fuel >= 100 then
                            AddPlayerChat(player, _("car_full"))
                        else
                            CallRemoteEvent(player, "LockControlMove", true)
                            SetPlayerAnimation(player, "COMBINE")
                            Delay(4000, function()
                                RemoveInventory(originPlayer, itemName, amount)
                                VehicleData[nearestCar].fuel = 100
                                AddPlayerChat(player, _("car_refuelled"))
                                CallRemoteEvent(player, "LockControlMove", false)
                                SetPlayerAnimation(player, "STOP")
                            end)
                        end
                    end
                end
            end
            if itemName == "lockpick" then
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
                                RemoveInventory(originPlayer, itemName, amount)
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
                                RemoveInventory(originPlayer, itemName, amount)
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

function UseItem(player, originPlayer, item, amount, animation)
    local animation = animation or "DRINKING"
    RemoveInventory(originPlayer, item.name, amount)
    addPlayerHunger(player, item.hunger * amount)
    addPlayerThirst(player, item.thirst * amount)
    SetPlayerAnimation(player, animation)
end

AddRemoteEvent("TransferInventory", function(player, originPlayer, item, amount, toPlayer)
    local x, y, z = GetPlayerLocation(player)
    local nearestPlayers = GetPlayersInRange3D(x, y, z, 1000)
    local toPlayerIsHere = false
    for k, v in pairs(nearestPlayers) do
        if k == toPlayer then
            toPlayerIsHere = true
        end
    end
    
    if toPlayerIsHere then
        print("From: "..originPlayer)
        print("To: "..toPlayer)
        if PlayerData[originPlayer].inventory[item] < tonumber(amount) then
            CallRemoteEvent(originPlayer, "MakeErrorNotification", _("not_enough_item"))
        else
            SetPlayerAnimation(player, "PICKUP_MIDDLE")

            RemoveInventory(tonumber(originPlayer), item, tonumber(amount), false, player)
            AddInventory(tonumber(toPlayer), item, tonumber(amount), player)
            
            CallRemoteEvent(originPlayer, "MakeNotification", _("successful_transfer", amount, item, GetPlayerName(tonumber(toPlayer))), "linear-gradient(to right, #00b09b, #96c93d)")
            CallRemoteEvent(tonumber(toPlayer), "MakeNotification", _("received_transfer", amount, item, GetPlayerName(originPlayer)), "linear-gradient(to right, #00b09b, #96c93d)")
        end
    end
end)

AddEvent("OnPlayerSpawn", function(player)
    if PlayerData[player] ~= nil then
        if PlayerData[player].backpack == nil then return end
        DestroyObject(PlayerData[player].backpack)        
        PlayerData[player].backpack = nil
        DisplayPlayerBackpack(player)
    end
end)

AddRemoteEvent("RemoveFromInventory", function(player, originPlayer, item, amount)
    if PlayerData[originPlayer].inventory[item] < tonumber(amount) then
        CallRemoteEvent(player, "MakeErrorNotification", _("not_enough_item"))
    else
        RemoveInventory(tonumber(originPlayer), item, tonumber(amount), 1)
    end
end)

function AddInventory(inventoryId, item, amount, player)
    local player = player or inventoryId

    local slotsAvailables = tonumber(GetPlayerMaxSlots(inventoryId)) - tonumber(GetPlayerUsedSlots(inventoryId))
     if item == "cash" or slotsAvailables >= (amount * ItemsWeight[item]) then
        if item == "item_backpack" and GetPlayerBag(inventoryId) == 1 then -- On ne peux pas acheter plusieurs sacs
            return false
        end
        if PlayerData[inventoryId].inventory[item] == nil then
            PlayerData[inventoryId].inventory[item] = amount            
        else
            PlayerData[inventoryId].inventory[item] = PlayerData[inventoryId].inventory[item] + amount
        end
        if item == "item_backpack" then -- Affichage du sac sur le perso
            DisplayPlayerBackpack(player, 1)
        end
        UpdateUIInventory(player, inventoryId, item, PlayerData[inventoryId].inventory[item])
        return true
    else
        return false
    end
end

function RemoveInventory(inventoryId, item, amount, drop, player)
    local player = player or inventoryId

    if PlayerData[inventoryId].inventory[item] == nil then
        return false
    else
        if PlayerData[inventoryId].inventory[item] - amount < 1 then
            PlayerData[inventoryId].inventory[item] = nil
            UpdateUIInventory(player, inventoryId, item, 0)
        else
            PlayerData[inventoryId].inventory[item] = PlayerData[inventoryId].inventory[item] - amount
            UpdateUIInventory(player, inventoryId, item, PlayerData[inventoryId].inventory[item])
        end
        if item == "item_backpack" then
            DisplayPlayerBackpack(player, 1)
        end
        if drop == 1 then
            local x,y,z = GetPlayerLocation(player)
            local pickup = CreatePickup(620, x, y, z - 90)
            local text = CreateText3D(_(item).." x"..amount, 15, x, y, z, 0,0,0)
            
            Delay(300000, function(pickup,text)
                DestroyPickup(pickup)      
                DestroyText3D(text)                          
            end, pickup,text)            
        end
        return true
    end
end

function SetInventory(player, item, amount)
    PlayerData[player].inventory[item] = amount
    return true
end

function GetPlayerCash(player)
    if PlayerData[player].inventory['cash'] then
        return math.tointeger(PlayerData[player].inventory['cash'])
    else
        return 0
    end
end

function GetNumberOfItem(player, item)
    return tonumber(PlayerData[player].inventory[item]) or 0
end

function SetPlayerCash(player, amount)
    PlayerData[player].inventory['cash'] = math.max(math.tointeger(amount), 0)
end

function AddPlayerCash(player, amount)
    AddInventory(player, 'cash', math.tointeger(amount))
end

function RemovePlayerCash(player, amount)
    --UpdateUIInventory(player, 'cash', math.tointeger(amount)) -- on le fait déjà dans RemoveInventory
    return RemoveInventory(player, 'cash', math.tointeger(amount))
end

function GetPlayerBag(player)    
    if PlayerData[player].inventory['item_backpack'] and math.tointeger(PlayerData[player].inventory['item_backpack']) > 0 then
        return 1
    else
        return 0
    end
end

function GetPlayerMaxSlots(player)
    if PlayerData[player].inventory['item_backpack'] and math.tointeger(PlayerData[player].inventory['item_backpack']) > 0 then
        return math.floor(inventory_base_max_slots + backpack_slot_to_add)
    else
        return inventory_base_max_slots
    end
end

function GetPlayerUsedSlots(player)
    local usedSlots = 0
    for k,v in pairs(PlayerData[player].inventory) do
        if k ~= 'cash' then
            usedSlots = usedSlots + (v * ItemsWeight[k])
        end
    end
    return usedSlots
end

function DisplayPlayerBackpack(player, anim)
    -- items ids : 818,820,821,823
    if GetPlayerBag(player) == 1 then
        if PlayerData[player].backpack == nil then -- Pour vérifier s'il n'a pas déjà un sac
            local x, y, z = GetPlayerLocation(player)
            PlayerData[player].backpack = CreateObject(820, x, y, z)
            SetObjectAttached(PlayerData[player].backpack, ATTACH_PLAYER, player, -30.0, -9.0, 0.0, -90.0, 0.0, 0.0, "spine_03")
            if anim == 1 then BackpackPutOnAnim(player) end -- Petite animation RP
        end
    else
        if PlayerData[player].backpack ~= nil then
            if anim == 1 then BackpackPutOnAnim(player, 2500) end -- Petite animation RP
            Delay(2500, function() 
                DestroyObject(PlayerData[player].backpack)  
            end)
        end
    end
end

function BackpackPutOnAnim(player, timer)
    if timer == nil then timer = 5000 end
    SetPlayerAnimation(player, "CHECK_EQUIPMENT3")
    Delay(timer, function()
        SetPlayerAnimation(player, "STOP")
    end)
end

AddFunctionExport("AddInventory", AddInventory)
AddFunctionExport("RemoveInventory", RemoveInventory)
AddFunctionExport("GetPlayerCash", GetPlayerCash)
AddFunctionExport("SetPlayerCash", SetPlayerCash)
AddFunctionExport("AddPlayerCash", AddPlayerCash)
AddFunctionExport("RemovePlayerCash", RemovePlayerCash)
AddFunctionExport("GetPlayerBag", GetPlayerBag)
AddFunctionExport("GetPlayerMaxSlots", GetPlayerMaxSlots)
AddFunctionExport("GetPlayerUsedSlots", GetPlayerUsedSlots)
AddFunctionExport("DisplayPlayerBackpack", DisplayPlayerBackpack)
