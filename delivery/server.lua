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

local playerDelivery = {}

AddEvent("OnPackageStart", function()
    deliveryNpc.npc = CreateNPC(deliveryNpc.location[1], deliveryNpc.location[2], deliveryNpc.location[3],deliveryNpc.location[4])
    CreateText3D(_("delivery_job").."\n".._("press_e"), 18, deliveryNpc.location[1], deliveryNpc.location[2], deliveryNpc.location[3] + 120, 0, 0, 0)
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
            for k,v in pairs(GetAllVehicles()) do
                local x, y, z = GetVehicleLocation(v)
                local dist2 = GetDistance3D(deliveryNpc.spawn[1], deliveryNpc.spawn[2], deliveryNpc.spawn[3], x, y, z)
                if dist2 > 1000.0 then
                    -- if no vehicle on the spawn zone continue
                    local vehicle = CreateVehicle(24, deliveryNpc.spawn[1], deliveryNpc.spawn[2], deliveryNpc.spawn[3], deliveryNpc.spawn[4])
                    PlayerData[player].job_vehicle = vehicle
                    CreateVehicleData(player, vehicle, 24)
                    SetVehiclePropertyValue(vehicle, "locked", true, true)
                    PlayerData[player].job = "delivery"
                    return AddPlayerChat(player, "Job join successfull")
                else
                    -- if vehicle on the spawn zone cancel and report an error
                    return AddPlayerChat(player, "Cannot join this job right now !")
                end
            end
            local vehicle = CreateVehicle(24, deliveryNpc.spawn[1], deliveryNpc.spawn[2], deliveryNpc.spawn[3], deliveryNpc.spawn[4])
            PlayerData[player].job_vehicle = vehicle
            CreateVehicleData(player, vehicle, 24)
            SetVehiclePropertyValue(vehicle, "locked", true, true)
            PlayerData[player].job = "delivery"
            return AddPlayerChat(player, "Job join successfull")
        end
    elseif PlayerData[player].job == "delivery" then
        if PlayerData[player].job_vehicle ~= nil then
            DestroyVehicle(PlayerData[player].job_vehicle)
            DestroyVehicleData(PlayerData[player].job_vehicle)
            PlayerData[player].job_vehicle = nil
        end
        PlayerData[player].job = ""
        playerDelivery[player] = nil
        CallRemoteEvent(player, "ClientDestroyCurrentWaypoint")
    end
end)

AddRemoteEvent("OpenDeliveryMenu", function(player)
    if PlayerData[player].job == "delivery" then
        CallRemoteEvent(player, "DeliveryMenu")
    end
end)

AddRemoteEvent("NextDelivery", function(player)
    if playerDelivery[player] ~= nil then
        return AddPlayerChat(player, _("finish_your_delivery"))
    end
    delivery = Random(1, #deliveryPoint)
    playerDelivery[player] = delivery
    CallRemoteEvent(player, "ClientCreateWaypoint", _("delivery"), deliveryPoint[delivery][1], deliveryPoint[delivery][2], deliveryPoint[delivery][3])
    AddPlayerChat(player, _("new_delivery"))
end)

AddRemoteEvent("FinishDelivery", function(player)
    delivery = playerDelivery[player]

    if delivery == nil then
        AddPlayerChat(player, _("no_delivery"))
    end

    local x, y, z = GetPlayerLocation(player)
    
    local dist = GetDistance3D(x, y, z, deliveryPoint[delivery][1], deliveryPoint[delivery][2], deliveryPoint[delivery][3])

    if dist < 150.0 then
        local reward = Random(100, 500)

        AddPlayerChat(player, _("finished_delivery", reward, _("currency")))
        
        PlayerData[player].cash = PlayerData[player].cash + reward
        playerDelivery[player] = nil
        CallRemoteEvent(player, "ClientDestroyCurrentWaypoint")
    else
        AddPlayerChat(player, _("no_delivery_point"))
    end
end)
