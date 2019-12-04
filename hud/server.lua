function getHudData(player)
    hunger = math.ceil(PlayerData[player].hunger)
    thirst = math.ceil(PlayerData[player].thirst)
    cash = PlayerData[player].cash
    bank = PlayerData[player].bank_balance

    if GetPlayerVehicle(player) ~= 0 then
        vehiclefuel = VehicleData[GetPlayerVehicle(player)].fuel
        vehicle = GetPlayerVehicle(player)
    else
        vehiclefuel = 0
        vehiclespeed = 0
    end

    CallRemoteEvent(player, "updateHud", hunger, thirst, cash, bank,  vehiclefuel)
end
AddRemoteEvent("getHudData", getHudData)

