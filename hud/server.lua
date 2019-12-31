function getHudData(player)
    if PlayerData[player] then
        hunger = math.ceil(PlayerData[player].hunger)
        thirst = math.ceil(PlayerData[player].thirst)
        healthlife = GetPlayerHealth(player)
        bank = PlayerData[player].bank_balance

        if GetPlayerVehicle(player) ~= 0 then
            if VehicleData[GetPlayerVehicle(player)] == nil then
                vehiclefuel = 0
            else
                vehiclefuel = VehicleData[GetPlayerVehicle(player)].fuel
            end
            vehicle = GetPlayerVehicle(player)
        else
            vehiclefuel = 0
            vehiclespeed = 0
        end

        CallRemoteEvent(player, "updateHud", hunger, thirst, GetPlayerCash(player), bank, healthlife, vehiclefuel)
    end
end
AddRemoteEvent("getHudData", getHudData)

function SetHUDMarker(player, name, heading, r, g, b)
    CallRemoteEvent(player, "SetHUDMarker", name, heading, r, g, b)
end
