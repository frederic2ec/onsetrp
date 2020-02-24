local _ = function(k, ...) return ImportPackage("i18n").t(GetPackageName(), k, ...) end

local deliveryNpc = {
    {
        location = {-16925, -29058, 2200, -90},
        spawn = {-17450, -28600, 2060, -90}
    },
    {
        location = {-168301, -41499, 1192, 90},
        spawn = {-168233, -40914, 1146, 90}
    },
    {
        location = {146585, 211065, 1307, -90},
        spawn = {145692, 210574, 1307, 0}
    }
}
local deliveryPoint = {
    {116691, 164243, 3028},
    {38964, 204516, 550},
    {182789, 186140, 1203},
    {211526, 176056, 1209},
    {42323, 137508, 1569},
    {122776, 207169, 1282},
    {209829, 92977, 1312},
    {176840, 10049, 10370},
    {198130, -49703, 1109},
    {130042, 78285, 1566},
    {203711, 190025, 1312},
    {170311, -161302, 1242},
    {152267, -143379, 1242},
    {-181677, -31627, 1148},
    {-179804, -66772, 1147},
    {182881, 148416, 5933}
}

local LOCATION_PRICE = 2000
local LOCATION_REFUND_PERCENTAGE = 0.8

local PRICE_DIVIDER = 250
local PRICE_PER_DIVIDE = 15

local deliveryNpcCached = {}
local playerDelivery = {}

local trucksOnLocation = {}

AddEvent("OnPackageStart", function()
    for k, v in pairs(deliveryNpc) do
        deliveryNpc[k].npc = CreateNPC(deliveryNpc[k].location[1], deliveryNpc[k].location[2], deliveryNpc[k].location[3], deliveryNpc[k].location[4])
        CreateText3D(_("delivery_job") .. "\n" .. _("press_e"), 18, deliveryNpc[k].location[1], deliveryNpc[k].location[2], deliveryNpc[k].location[3] + 120, 0, 0, 0)
        table.insert(deliveryNpcCached, deliveryNpc[k].npc)
    end
end)

AddEvent("OnPlayerQuit", function(player)
    if playerDelivery[player] ~= nil then
        playerDelivery[player] = nil
    end
end)

AddEvent("OnPlayerJoin", function(player)
    CallRemoteEvent(player, "SetupDelivery", deliveryNpcCached, LOCATION_PRICE)
end)

AddRemoteEvent("StartStopDelivery", function(player)
    local nearestDelivery = GetNearestDelivery(player)
    local useBank = PlayerData[player].bank_balance >= LOCATION_PRICE
    local useCash = PlayerData[player].inventory['cash'] ~= nil and PlayerData[player].inventory['cash'] >= LOCATION_PRICE
    
    if PlayerData[player].job == "" then
        if PlayerData[player].job_vehicle ~= nil then
            DestroyVehicle(PlayerData[player].job_vehicle)
            DestroyVehicleData(PlayerData[player].job_vehicle)
            PlayerData[player].job_vehicle = nil
            CallRemoteEvent(player, "ClientDestroyCurrentWaypoint")
        else
            local isSpawnable = true
            local jobCount = 0
            for k, v in pairs(PlayerData) do
                if v.job == "delivery" then
                    jobCount = jobCount + 1
                end
            end
            if jobCount == 15 then
                return CallRemoteEvent(player, "MakeNotification", _("job_full"), "linear-gradient(to right, #ff5f6d, #ffc371)")
            end
            for k, v in pairs(GetAllVehicles()) do
                local x, y, z = GetVehicleLocation(v)
                local dist2 = GetDistance3D(deliveryNpc[nearestDelivery].spawn[1], deliveryNpc[nearestDelivery].spawn[2], deliveryNpc[nearestDelivery].spawn[3], x, y, z)
                if dist2 < 500.0 then
                    isSpawnable = false
                    break
                end
            end
            if isSpawnable then
                
                if useBank then
                    PlayerData[player].bank_balance = PlayerData[player].bank_balance - LOCATION_PRICE
                elseif useCash then
                    RemovePlayerCash(player, LOCATION_PRICE)
                else
                    CallRemoteEvent(player, "MakeErrorNotification", _("delivery_not_enough_location_cash", LOCATION_PRICE))
                    return
                end
                
                local vehicle = CreateVehicle(24, deliveryNpc[nearestDelivery].spawn[1], deliveryNpc[nearestDelivery].spawn[2], deliveryNpc[nearestDelivery].spawn[3], deliveryNpc[nearestDelivery].spawn[4])
                PlayerData[player].job_vehicle = vehicle
                CreateVehicleData(player, vehicle, 24)
                SetVehicleRespawnParams(vehicle, false)
                SetVehiclePropertyValue(vehicle, "locked", true, true)
                PlayerData[player].job = "delivery"
                
                trucksOnLocation[PlayerData[player].accountid] = vehicle
                
                CallRemoteEvent(player, "MakeNotification", _("delivery_start_success"), "linear-gradient(to right, #00b09b, #96c93d)")
                return
            end
        end
    elseif PlayerData[player].job == "delivery" then
        
        if trucksOnLocation[PlayerData[player].accountid] ~= nil then -- If the player has a job vehicle
            local x, y, z = GetVehicleLocation(PlayerData[player].job_vehicle)
            
            local IsNearby = false
            for k, v in pairs(deliveryNpc) do -- For each location npc
                local dist = GetDistance3D(x, y, z, v.location[1], v.location[2], v.location[3])
                if dist <= 2000 then -- if vehicle is nearby
                    IsNearby = true
                end
            end
            
            if IsNearby then
                local refund = LOCATION_PRICE * LOCATION_REFUND_PERCENTAGE
                PlayerData[player].bank_balance = PlayerData[player].bank_balance + refund
                CallRemoteEvent(player, "MakeNotification", _("delivery_location_price_refunded", refund), "linear-gradient(to right, #00b09b, #96c93d)")
            else
                CallRemoteEvent(player, "MakeErrorNotification", _("delivery_vehicle_too_far_away"))
            end
        end
        
        if trucksOnLocation[PlayerData[player].accountid] ~= nil then
            DestroyVehicle(trucksOnLocation[PlayerData[player].accountid])
            DestroyVehicleData(trucksOnLocation[PlayerData[player].accountid])
            PlayerData[player].job_vehicle = nil
            trucksOnLocation[PlayerData[player].accountid] = nil
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
        return CallRemoteEvent(player, "MakeNotification", _("finish_your_delivery"), "linear-gradient(to right, #ff5f6d, #ffc371)")
    end
    delivery = {}
    delivery[1] = Random(1, #deliveryPoint)
    local x, y, z = GetPlayerLocation(player)
    local dist = GetDistance3D(x, y, z, deliveryPoint[delivery[1]][1], deliveryPoint[delivery[1]][2], deliveryPoint[delivery[1]][3])
    delivery[2] = ((dist / 100) / PRICE_DIVIDER) * PRICE_PER_DIVIDE
    playerDelivery[player] = delivery
    CallRemoteEvent(player, "ClientCreateWaypoint", _("delivery"), deliveryPoint[delivery[1]][1], deliveryPoint[delivery[1]][2], deliveryPoint[delivery[1]][3])
    CallRemoteEvent(player, "MakeNotification", _("new_delivery"), "linear-gradient(to right, #00b09b, #96c93d)")
end)

AddRemoteEvent("FinishDelivery", function(player)
    delivery = playerDelivery[player]
    
    if delivery == nil then
        CallRemoteEvent(player, "MakeNotification", _("no_delivery"), "linear-gradient(to right, #ff5f6d, #ffc371)")
        return
    end
    
    local x, y, z = GetPlayerLocation(player)
    
    local dist = GetDistance3D(x, y, z, deliveryPoint[delivery[1]][1], deliveryPoint[delivery[1]][2], deliveryPoint[delivery[1]][3])
    
    if dist < 150.0 then
        if PlayerData[player].job_vehicle ~= GetPlayerVehicle(player) then
            CallRemoteEvent(player, "MakeErrorNotification", _("delivery_need_delivery_truck"))
            return
        end
        
        CallRemoteEvent(player, "MakeNotification", _("finished_delivery", math.ceil(delivery[2]) or PRICE_PER_DIVIDE, _("currency")), "linear-gradient(to right, #00b09b, #96c93d)")
        
        AddPlayerCash(player, math.ceil(delivery[2]) or PRICE_PER_DIVIDE)
        playerDelivery[player] = nil
        CallRemoteEvent(player, "ClientDestroyCurrentWaypoint")
    else
        CallRemoteEvent(player, "MakeNotification", _("no_delivery_point"), "linear-gradient(to right, #ff5f6d, #ffc371)")
    end
end)

function GetNearestDelivery(player)
    local x, y, z = GetPlayerLocation(player)
    
    for k, v in pairs(GetAllNPC()) do
        local x2, y2, z2 = GetNPCLocation(v)
        local dist = GetDistance3D(x, y, z, x2, y2, z2)
        
        if dist < 250.0 then
            for k, i in pairs(deliveryNpc) do
                if v == i.npc then
                    return k
                end
            end
        end
    end
    
    return 0
end

AddEvent("job:onspawn", function(player)
    PlayerData[player].job_vehicle = trucksOnLocation[PlayerData[player].accountid]
end)
