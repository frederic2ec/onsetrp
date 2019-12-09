local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local deliveryNpc = {
    location = { -16925, -29058, 2200, -90 },
    spawn = { -17450, -28600, 2060, 110 }
}
local deliveryPoint = {
    { 3407, 102167, 1491 },
    { 23067, 137224, 1555 },
    { 211535, 91260, 1340 }
}

AddEvent("OnPackageStart", function()
    deliveryNpc.npc = CreateNPC(deliveryNpc.location[1], deliveryNpc.location[2], deliveryNpc.location[3],deliveryNpc.location[4])
    CreateText3D("Delivery Job".."\n".._("press_e"), 18, deliveryNpc.location[1], deliveryNpc.location[2], deliveryNpc.location[3] + 120, 0, 0, 0)
end)

AddEvent("OnPlayerJoin", function(player)
    CallRemoteEvent(player, "SetupDelivery", deliveryNpc.npc)
end)

AddRemoteEvent("StartStopDelivery", function(player)
    if PlayerData[player].job == "" then
        if PlayerData[player].job_vehicle ~= nil then
            DestroyVehicle(PlayerData[player].job_vehicle)
            DestroyVehicleData(PlayerData[player].job_vehicle)
            PlayerData[player].job_vehicle = nil
        else
            local vehicle = CreateVehicle(24, deliveryNpc.spawn[1], deliveryNpc.spawn[2], deliveryNpc.spawn[3], deliveryNpc.spawn[4])
            PlayerData[player].job_vehicle = vehicle
            CreateVehicleData(player, vehicle, 24)
            SetVehiclePropertyValue(vehicle, "locked", true, true)
        end
        PlayerData[player].job = "delivery"
    elseif PlayerData[player].job == "delivery" then
        if PlayerData[player].job_vehicle ~= nil then
            DestroyVehicle(PlayerData[player].job_vehicle)
            DestroyVehicleData(PlayerData[player].job_vehicle)
            PlayerData[player].job_vehicle = nil
        end
        PlayerData[player].job = ""
    end
end)

AddRemoteEvent("OpenDeliveryMenu", function(player)
    if PlayerData[player].job == "delivery" then
        CallRemoteEvent(player, "DeliveryMenu")
    end
end)

AddRemoteEvent("NextDelivery" function(player)
    
end)
