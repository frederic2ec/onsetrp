local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local personalMenu

AddRemoteEvent("OpenPersonalMenu", function(items, inventory, playerName, playerId, playerList, maxSlots, searchedPlayer)
    OpenUIInventory(items, inventory, playerName, playerId, playerList, maxSlots, searchedPlayer)
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


AddEvent("OnKeyPress", function( key )
    local cuffed = GetPlayerPropertyValue(GetPlayerId(), "cuffed") or false
        
    if key == INVENTORY_KEY and not GetPlayerBusy() and not cuffed then
        local vehicle = GetPlayerVehicle()

        if vehicle ~= 0 then
            CallRemoteEvent("ServerPersonalMenu", true, GetVehicleForwardSpeed(vehicle))
        else
            CallRemoteEvent("ServerPersonalMenu", false)
        end
    end
end)

AddRemoteEvent("LockControlMove", function(move)
    SetIgnoreMoveInput(move)
end)

