local _ = function(k, ...) return ImportPackage("i18n").t(GetPackageName(), k, ...) end

local inventory_base_max_slots = 50
local backpack_slot_to_add = 35

local droppedObjectsPickups = {}

AddRemoteEvent("ServerPersonalMenu", function(player, inVehicle, vehiclSpeed)
    if inVehicle and GetPlayerState(player) == PS_DRIVER and vehiclSpeed > 0 then
        return CallRemoteEvent(player, "MakeErrorNotification", _("cant_while_driving"))
    end
    
    local playerList = {}
    for k, neatPlayerId in pairs(GetNearestPlayers(player, 300)) do
        if neatPlayerId ~= player then
            local playerName
            if PlayerData[neatPlayerId] ~= nil then
                if PlayerData[neatPlayerId].accountid ~= nil and PlayerData[neatPlayerId].accountid ~= 0 then playerName = PlayerData[neatPlayerId].accountid else playerName = GetPlayerName(neatPlayerId) end            
                table.insert(playerList, {id = neatPlayerId, name = playerName}) -- On prend le nom affiché (l'accountid)
            end
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

AddRemoteEvent("EquipInventory", function(player, originInventory, itemName, amount, inVehicle, vehiclSpeed)
    if (amount <= 0) then
        return false
    end
      
    if string.find(originInventory, 'vehicle_') then
        CallRemoteEvent(player, "MakeErrorNotification", _("pick_first"))
        return false
    end

    originInventory = tonumber(originInventory)

    if inVehicle and GetPlayerState(player) == PS_DRIVER and vehiclSpeed > 0 then
        CallRemoteEvent(player, "MakeErrorNotification", _("cant_while_driving"))
        return false
    end
    
    local item
    
    for k, itemPair in pairs(Items) do
        if itemPair.name == itemName then
            item = itemPair
        end
    end
    
    weapon = getWeaponID(itemName)
    if tonumber(PlayerData[originInventory].inventory[itemName]) < tonumber(amount) then
        CallRemoteEvent(player, "MakeErrorNotification", _("not_enough_item"))
    else
        if weapon ~= 0 then
            for slot, v in pairs({1, 2, 3}) do
                local slotWeapon, ammo = GetPlayerWeapon(player, slot)
                if slotWeapon == tonumber(weapon) then
                    UnequipWeapon(player, originInventory, itemName, slot)
                    return true
                end
            end
            
            for slot, v in pairs({1, 2, 3}) do
                local slotWeapon, ammo = GetPlayerWeapon(player, slot)
                if slotWeapon == 1 then
                    SetPlayerWeapon(player, tonumber(weapon), 1000, true, slot)
                    CallRemoteEvent(player, "MakeSuccessNotification", _("item_equiped", slot))
                    UpdateUIInventory(player, originInventory, itemName, PlayerData[originInventory].inventory[itemName], true)
                    return true
                end
            end
            CallRemoteEvent(player, "MakeErrorNotification", _("not_enough_slots"))
        else
            if string.find(itemName, 'mask_') then
                local objectId
 
                local objX = 8.0
                local objY = 0.0
                local objZ = 0.0
                
                if itemName == 'mask_1' then
                    objectId = 463
                elseif itemName == 'mask_2' then
                    objectId = 455
                elseif itemName == 'mask_3' then
                    objX = -3.0
                    objY = 12.0
                    objZ = 0.0
                    objectId = 1451
                elseif itemName == 'mask_4' then
                    objX = -5.0
                    objY = -5.0
                    objZ = 6.0
                    objectId = 1452
                end

                BackpackPutOnAnim(player, 3000, 'FACEPALM')
                
                if PlayerData[player][itemName] then
                    UpdateUIInventory(player, originInventory, itemName, PlayerData[originInventory].inventory[itemName], false)
                    SetPlayerPropertyValue(player, "WearingItem", nil, true)
                    Delay(2000, function()
                        DestroyObject(PlayerData[player][itemName])
                        PlayerData[player][itemName] = nil
                    end)
                else
                    UpdateUIInventory(player, originInventory, itemName, PlayerData[originInventory].inventory[itemName], true)
                    SetPlayerPropertyValue(player, "WearingItem", itemName, true)
                    Delay(2000, function() 
                        local x, y, z = GetPlayerLocation(player)
                        PlayerData[player][itemName] = CreateObject(objectId, x, y, z)
                        SetObjectAttached(PlayerData[player][itemName], ATTACH_PLAYER, player, objX, objY, objZ, 0.0, 90.0, -90.0, "head")
                    end)
                end
            end
            -- No weapons items
        end
    end
end)

function UnequipWeapon(player, originInventory, itemName, slot)
    SetPlayerWeapon(player, 1, 0, true, slot)
    CallRemoteEvent(player, "MakeSuccessNotification", _("item_unequiped", slot))
    UpdateUIInventory(player, originInventory, itemName, PlayerData[originInventory].inventory[itemName], false)
end

AddRemoteEvent("UseInventory", function(player, originInventory, itemName, amount, inVehicle, vehiclSpeed)
    if (amount <= 0) then
        return false
    end

    if string.find(originInventory, 'vehicle_') then
        CallRemoteEvent(player, "MakeErrorNotification", _("pick_first"))
        return false
    end

    originInventory = tonumber(originInventory)

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
    if tonumber(PlayerData[originInventory].inventory[itemName]) < tonumber(amount) then
        CallRemoteEvent(player, "MakeErrorNotification", _("not_enough_item"))
    else
        if weapon ~= 0 then
            local weaponAdded = false
            for slot, v in pairs({1, 2, 3}) do
                if GetPlayerWeapon(player, slot) == nil then
                    SetPlayerWeapon(player, tonumber(weapon), 1000, true, slot)
                    CallRemoteEvent(player, "MakeSuccessNotification", _("item_equiped", slot))
                    weaponAdded = true
                end
            end
            if not weaponAdded then
                CallRemoteEvent(player, "MakeErrorNotification", _("not_enough_slots"))
            end
        else
            if itemName == "donut" or itemName == "apple" or itemName == "peach" or itemName == "water_bottle" or itemName == "fish" then
                UseItem(player, originInventory, item, amount)
            end
            if itemName == "repair_kit" then
                local nearestCar = GetNearestCar(player)
                if nearestCar ~= 0 then
                    if GetVehicleHealth(nearestCar) > 4000 then
                        CallRemoteEvent(player, "MakeErrorNotification", _("dont_need_repair"))
                    elseif GetVehicleHoodRatio(nearestCar) < 5 and GetVehicleModel(nearestCar) ~= 10 and GetVehicleModel(nearestCar) ~= 24 then
                        CallRemoteEvent(player, "MakeErrorNotification", _("need_to_open_hood"))
                    else
                        CallRemoteEvent(player, "LockControlMove", true)
                        SetPlayerAnimation(player, "COMBINE")
                        Delay(4000, function()
                            RemoveInventory(originInventory, itemName, amount)
                            SetVehicleHealth(nearestCar, 5000)
                            for i = 1, 8 do
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
                            CallRemoteEvent(player, "MakeErrorNotification", _("car_full"))
                        else
                            CallRemoteEvent(player, "LockControlMove", true)
                            SetPlayerAnimation(player, "COMBINE")
                            Delay(4000, function()
                                RemoveInventory(originInventory, itemName, amount)
                                VehicleData[nearestCar].fuel = 100
                                CallRemoteEvent(player, "MakeSuccessNotification", _("car_refuelled"))
                                CallRemoteEvent(player, "LockControlMove", false)
                                SetPlayerAnimation(player, "STOP")
                            end)
                        end
                    end
                end
            end
            -- if itemName == "lockpick" then -- TEMP
            --     local nearestCar = GetNearestCar(player)
            --     local nearestHouseDoor = GetNearestHouseDoor(player)
            --     if nearestCar ~= 0 then
            --         if VehicleData[nearestCar] ~= nil then
            --             if GetVehiclePropertyValue(nearestCar, "locked") then
            --                 CallRemoteEvent(player, "LockControlMove", true)
            --                 SetPlayerAnimation(player, "LOCKDOOR")
            --                 Delay(3000, function()
            --                     SetPlayerAnimation(player, "LOCKDOOR")
            --                 end)
            --                 Delay(6000, function()
            --                     SetPlayerAnimation(player, "LOCKDOOR")
            --                 end)
            --                 Delay(10000, function()
            --                     SetVehiclePropertyValue(nearestCar, "locked", false, true)
            --                     CallRemoteEvent(player, "MakeSuccessNotification", _("car_unlocked"))
            --                     RemoveInventory(originInventory, itemName, amount)
            --                     CallRemoteEvent(player, "LockControlMove", false)
            --                     SetPlayerAnimation(player, "STOP")
            --                 end)
            --             else
            --                 CallRemoteEvent(player, "MakeErrorNotification", _("vehicle_already_unlocked"))
            --             end
            --         end
            --     end
            --     if nearestHouseDoor ~= 0 then
            --         nearestHouse = getHouseDoor(nearestHouseDoor)
            --         if nearestHouse ~= 0 then
            --             if houses[nearestHouse].lock then
            --                 CallRemoteEvent(player, "LockControlMove", true)
            --                 SetPlayerAnimation(player, "LOCKDOOR")
            --                 Delay(3000, function()
            --                     SetPlayerAnimation(player, "LOCKDOOR")
            --                 end)
            --                 Delay(6000, function()
            --                     SetPlayerAnimation(player, "LOCKDOOR")
            --                 end)
            --                 Delay(10000, function()
            --                     houses[nearestHouse].lock = false
            --                     CallRemoteEvent(player, "MakeSuccessNotification", _("unlock_house"))
            --                     RemoveInventory(originInventory, itemName, amount)
            --                     CallRemoteEvent(player, "LockControlMove", false)
            --                     SetPlayerAnimation(player, "STOP")
            --                 end)
            --             else
            --                 CallRemoteEvent(player, "MakeErrorNotification", _("house_already_unlock"))
            --             end
            --         end
            --     end
            -- end
            CallEvent("job:usespecialitem", player, itemName)-- REDIRECT TO JOBS SCRIPT TO USE ITEM
        end
    end
end)

function UseItem(player, originInventory, item, amount, animation)
    local animation = animation or "DRINKING"
    RemoveInventory(originInventory, item.name, amount)
    addPlayerHunger(player, item.hunger * amount)
    addPlayerThirst(player, item.thirst * amount)
    SetPlayerAnimation(player, animation)
end

AddRemoteEvent("TransferInventory", function(player, originInventory, item, amount, destinationInventory)
    amount = tonumber(amount)

    if (amount <= 0) then
        return false
    end

    if originInventory == nil or destinationInventory == nil then
        return false
    end

    local originType, originX, originY, originZ, destX, destY, destZ

    -- ORIGIN INVENTORY

    if string.find(originInventory, 'vehicle_') then
        originType = 'vehicle'
        originInventory = string.gsub(originInventory, 'vehicle_', '')
        originX, originY, originZ = GetVehicleLocation(originInventory)
    else
        originType = 'player'
        originX, originY, originZ = GetPlayerLocation(originInventory)
    end

    originInventory = tonumber(originInventory)

    -- DESTINATION INVENTORY
    
    local destinationType

    if string.find(destinationInventory, 'vehicle_') then
        destinationType = 'vehicle'
        destinationInventory = string.gsub(destinationInventory, 'vehicle_', '')
        destX, destY, destZ = GetVehicleLocation(destinationInventory)
    else
        destinationType = 'player'
        destX, destY, destZ = GetPlayerLocation(destinationInventory)
    end

    destinationInventory = tonumber(destinationInventory)

    local dist = GetDistance3D(originX, originY, originZ, destX, destY, destZ)
    
    if dist <= 200 then
        local enoughItems = false

        if originType == 'player' then
            enoughItems = PlayerData[originInventory].inventory[item] >= amount
        else
            enoughItems = VehicleData[originInventory].inventory[item] >= amount
        end

        if not enoughItems then
            CallRemoteEvent(player, "MakeErrorNotification", _("not_enough_item"))
        else
            local itemAdded = false
            local itemRemoved = false

            if destinationType == 'player' then
                itemAdded = AddInventory(destinationInventory, item, amount, player)
            else
                itemAdded = AddVehicleInventory(destinationInventory, item, amount, player)
            end
            
            if originType == 'player' then
                itemRemoved = RemoveInventory(originInventory, item, amount, false, player)
            else
                itemRemoved = RemoveVehicleInventory(originInventory, item, amount, player)
            end
            
            if itemAdded and itemRemoved then
                if originType == 'player' then
                    if destinationType == 'player' then
                        SetPlayerAnimation(originInventory, "PICKUP_MIDDLE")
                        CallRemoteEvent(originInventory, "MakeSuccessNotification", _("successful_transfer", amount, item, PlayerData[destinationInventory].name))
                    else
                        CallRemoteEvent(originInventory, "MakeSuccessNotification", _("successful_drop", amount, item))
                    end
                end
                if destinationType == 'player' then
                    if originType == 'player' then
                        SetPlayerAnimation(destinationInventory, "PICKUP_MIDDLE")
                        CallRemoteEvent(destinationInventory, "MakeSuccessNotification", _("received_transfer", amount, item, PlayerData[originInventory].name))
                    else
                        CallRemoteEvent(destinationInventory, "MakeSuccessNotification", _("successful_pick", amount, item))
                    end
                end
            else
                -- If added and not removed, remove added item

                if itemAdded then
                    if destinationType == 'player' then
                        RemoveInventory(destinationInventory, item, amount, false, player)
                    else
                        RemoveVehicleInventory(destinationInventory, item, amount, player)
                    end
                end

                -- If removed and not added, re-add removed item

                if itemRemoved then
                    if originType == 'player' then
                        itemAdded = AddInventory(originInventory, item, amount, player)
                    else
                        itemAdded = AddVehicleInventory(originInventory, item, amount, player)
                    end
                end

                CallRemoteEvent(player, "MakeErrorNotification", _("item_transfer_error"))
            end
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

AddRemoteEvent("RemoveFromInventory", function(player, originInventory, item, amount)
    if (amount <= 0) then
        return false
    end

    originInventory = tonumber(originInventory)

    if PlayerData[originInventory].inventory[item] < tonumber(amount) then
        CallRemoteEvent(player, "MakeErrorNotification", _("not_enough_item"))
    else
        RemoveInventory(tonumber(originInventory), item, tonumber(amount), 1)
    end
end)

function AddInventory(inventoryId, item, amount, player)
    if (amount <= 0) then
        return false
    end

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
        UpdateUIInventory(inventoryId, inventoryId, item, PlayerData[inventoryId].inventory[item])
        SavePlayerAccount(player)
        return true
    else
        return false
    end
end

function RemoveInventory(inventoryId, item, amount, drop, player)
    if (amount <= 0) then
        return false
    end

    local player = player or inventoryId
    
    if PlayerData[inventoryId].inventory[item] == nil then
        return false
    else
        if PlayerData[inventoryId].inventory[item] - amount < 1 then
            UpdateUIInventory(player, inventoryId, item, 0)
            UpdateUIInventory(inventoryId, inventoryId, item, 0)

            weapon = getWeaponID(item)
            
            if weapon ~= 0 then
                for slot, v in pairs({1, 2, 3}) do
                    local slotWeapon, ammo = GetPlayerWeapon(player, slot)
                    if slotWeapon == tonumber(weapon) then
                        UnequipWeapon(player, originInventory, itemName, slot)
                    end
                end
            end
            
            PlayerData[inventoryId].inventory[item] = nil
        else
            PlayerData[inventoryId].inventory[item] = PlayerData[inventoryId].inventory[item] - amount
            UpdateUIInventory(player, inventoryId, item, PlayerData[inventoryId].inventory[item])
            UpdateUIInventory(inventoryId, inventoryId, item, PlayerData[inventoryId].inventory[item])
        end
        if item == "item_backpack" then
            DisplayPlayerBackpack(player, 1)
        end
        if drop == 1 then
            local x, y, z = GetPlayerLocation(player)
            local pickup = CreatePickup(620, x, y, z - 90)
            local text = CreateText3D(_(item) .. " x" .. amount, 15, x, y, z, 0, 0, 0)
            
            Delay(300000, function(pickup, text)
                DestroyPickup(pickup)
                DestroyText3D(text)
            end, pickup, text)
        end
        SavePlayerAccount(player)
        return true
    end
end

function SetInventory(player, item, amount)
    if (amount <= 0) then
        return false
    end

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
    for k, v in pairs(PlayerData[player].inventory) do
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

function BackpackPutOnAnim(player, timer, animation)
    if timer == nil then timer = 5000 end
    if animation == nil then animation = 'CHECK_EQUIPMENT3' end
    SetPlayerAnimation(player, animation)
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
