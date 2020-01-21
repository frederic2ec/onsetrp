local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local personalMenu

AddRemoteEvent("OpenPersonalMenu", function(key, items, inventory, playerName, playerId, playerList, maxSlots)
    OpenUIInventory(key, items, inventory, playerName, playerId, playerList, maxSlots)
end)

function itemUsedInInventory(event)
    local data = json_decode(event)
    local vehicle = GetPlayerVehicle()

    if vehicle ~= 0 then
        CallRemoteEvent("UseInventory", data.idItem, 1, true, GetVehicleForwardSpeed(vehicle))
    else
        CallRemoteEvent("UseInventory", data.idItem, 1, false)
    end
end
AddEvent('BURDIGALAX_inventory_onUse', itemUsedInInventory)

function itemDeletedInInventory(event)
    local data = json_decode(event)
    CallRemoteEvent("RemoveFromInventory", data.idItem, data.quantity, data.destinationInventoryId)
end
AddEvent('BURDIGALAX_inventory_onDelete', itemDeletedInInventory)

function itemTransferedInInventory(event)
    local data = json_decode(event)
    CallRemoteEvent("TransferInventory", data.idItem, data.quantity, data.destinationInventoryId)
end
AddEvent('BURDIGALAX_inventory_onTransfer', itemTransferedInInventory)


AddEvent("OnKeyPress", function( key )
    local cuffed = GetPlayerPropertyValue(GetPlayerId(), "cuffed") or false
        
    if key == "F4" and not GetPlayerBusy() and not cuffed then
        local vehicle = GetPlayerVehicle()

        if vehicle ~= 0 then
            CallRemoteEvent("ServerPersonalMenu", GetVehicleForwardSpeed(vehicle))
        else
            CallRemoteEvent("ServerPersonalMenu", 0)
        end
    end
end)

AddRemoteEvent("LockControlMove", function(move)
    SetIgnoreMoveInput(move)
end)

