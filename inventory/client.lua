local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

IsViewingTrunk = false

AddRemoteEvent("OpenPersonalMenu", function(items, inventory, playerName, playerId, nearInventories, maxSlots, searchedPlayer, nearInventoryItems)
    local nearInventoryItems = nearInventoryItems or { }
    for k, nearInventory in pairs(nearInventories) do
        for nearInventoryItemId, nearInventoryItem in pairs(nearInventoryItems) do
            if nearInventory.id == nearInventoryItemId then
                nearInventory.inventory = nearInventoryItem
            end
        end
    end

    OpenUIInventory(items, inventory, playerName, playerId, nearInventories, maxSlots, searchedPlayer, nearInventoryItems)
end)

function itemUsedInInventory(event)
    local data = json_decode(event)
    local vehicle = GetPlayerVehicle()

    if vehicle ~= 0 then
        CallRemoteEvent("UseInventory", data.idInventory, data.idItem, 1, true, GetVehicleForwardSpeed(vehicle))
    else
        CallRemoteEvent("UseInventory", data.idInventory, data.idItem, 1, false)
    end
end
AddEvent('BURDIGALAX_inventory_onUse', itemUsedInInventory)

function itemEquipedInInventory(event)
    local data = json_decode(event)
    local vehicle = GetPlayerVehicle()

    if vehicle ~= 0 then
        CallRemoteEvent("EquipInventory", data.idInventory, data.idItem, 1, true, GetVehicleForwardSpeed(vehicle))
    else
        CallRemoteEvent("EquipInventory", data.idInventory, data.idItem, 1, false)
    end
end
AddEvent('BURDIGALAX_inventory_onEquip', itemEquipedInInventory)

function itemDeletedInInventory(event)
    local data = json_decode(event)
    CallRemoteEvent("RemoveFromInventory", data.idInventory, data.idItem, data.quantity, data.destinationInventoryId)
end
AddEvent('BURDIGALAX_inventory_onDelete', itemDeletedInInventory)

function itemTransferedInInventory(event)
    local data = json_decode(event)
    CallRemoteEvent("TransferInventory", data.originInventoryId, data.idItem, data.quantity, data.destinationInventoryId)
end
AddEvent('BURDIGALAX_inventory_onTransfer', itemTransferedInInventory)

function OnSelectedInventoryChange(event)
    local data = json_decode(event)

    if data.originInventoryId == tostring(GetPlayerId()) and data.destinationInventoryId then
        if string.find(data.destinationInventoryId, 'vehicle_') then
            local destinationVehicle = string.gsub(data.destinationInventoryId, 'vehicle_', '')
            destinationVehicle = tonumber(destinationVehicle)
            
            IsViewingTrunk = destinationVehicle
            CallRemoteEvent("OpenCarTrunk", destinationVehicle)
        elseif data.destinationInventoryId == "none" and IsViewingTrunk then
            CallRemoteEvent("CloseTrunk", IsViewingTrunk)
            IsViewingTrunk = false
        end
    end
end
AddEvent('BURDIGALAX_inventory_onChangeNearbyInventorySelected', OnSelectedInventoryChange)


AddEvent("OnKeyPress", function( key )
    local cuffed = GetPlayerPropertyValue(GetPlayerId(), "cuffed") or false
        
    if key == INVENTORY_KEY then
        if InventoryIsOpened then
            CloseUIInventory()
        else
            if not GetPlayerBusy() and not cuffed then
                local vehicle = GetPlayerVehicle()
    
                if vehicle ~= 0 then
                    CallRemoteEvent("ServerPersonalMenu", true, GetVehicleForwardSpeed(vehicle))
                else
                    CallRemoteEvent("ServerPersonalMenu", false)
                end
            end
        end
    end
end)

AddEvent("OnHideMainMenu", function()
    if InventoryIsOpened then
        Delay(1, function() 
            ShowMouseCursor(true)
            SetInputMode(INPUT_GAMEANDUI)
        end)
    end
end)


AddRemoteEvent("LockControlMove", function(move)
    SetIgnoreMoveInput(move)
end)

AddRemoteEvent("CheckCrouch", function(bool, item, amount)
    bool = IsPlayerCrouching(bool)
    CallRemoteEvent("ObjectDrop", bool, item, amount)
end)
