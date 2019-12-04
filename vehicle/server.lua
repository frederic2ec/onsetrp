local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

VehicleData = {}

function CreateVehicleData(player, vehicle, modelid)
    VehicleData[vehicle] = {}

    VehicleData[vehicle].garageid = 0
    VehicleData[vehicle].owner = PlayerData[player].accountid
    VehicleData[vehicle].modelid = modelid
    VehicleData[vehicle].inventory = {}
    VehicleData[vehicle].fuel = 100

    print("Data created for : "..vehicle)
end

function DestroyVehicleData(vehicle)
	if (VehicleData[vehicle] ~= nil) then
		return
    end

    VehicleData[vehicle] = nil
end

AddRemoteEvent("ServerVehicleMenu", function(player, vehicle)
    if VehicleData[vehicle].owner == PlayerData[player].accountid then
        CallRemoteEvent(player, "OpenVehicleMenu")
    end
end)

function unlockVehicle(player)
    local nearestCar = GetNearestCar(player)
    local vehicle = VehicleData[nearestCar]
    local playerData = PlayerData[player]
    if nearestCar ~= 0 then
        if vehicle.owner == playerData.accountid then
            if GetVehiclePropertyValue(nearestCar, "locked") then
                AddPlayerChat(player, _("car_unlocked"))
                SetVehiclePropertyValue(nearestCar, "locked", false, true)
                CallRemoteEvent(player, "PlayAudioFile", "carUnlock.mp3")
            else
                AddPlayerChat(player, _("car_locked"))
                SetVehiclePropertyValue(nearestCar, "locked", true, true)
                CallRemoteEvent(player, "PlayAudioFile", "carLock.mp3")
            end
        end
    end
end
AddRemoteEvent("unlockVehicle", unlockVehicle)

AddRemoteEvent("OpenTrunk", function(player)
    local vehicle = GetNearestCar(player)
    SetVehicleTrunkRatio(vehicle, 60.0)
    CallRemoteEvent(player, "OpenVehicleInventory", PlayerData[player].inventory, VehicleData[vehicle].inventory)
end)

AddRemoteEvent("CloseTrunk", function(player)
    local vehicle = GetNearestCar(player)
    SetVehicleTrunkRatio(vehicle, 0.0)
end)

AddRemoteEvent("UnflipVehicle", function(player) 
    local vehicle = GetNearestCar(player)
    local rx, ry, rz = GetVehicleRotation(vehicle)

    SetVehicleRotation(vehicle, 0, ry, 0 )
end)

AddRemoteEvent("VehicleStore", function(player, item, amount) 
    local vehicle = GetNearestCar(player)
    if tonumber(PlayerData[player].inventory[item]) < tonumber(amount) then
        AddPlayerChat(player, _("not_enough_item"))
    else
        RemoveInventory(player, item, amount)
        AddVehicleInventory(vehicle, item, amount)
    end
end)

AddRemoteEvent("VehicleUnstore", function(player, item, amount) 
    local vehicle = GetNearestCar(player)

    if tonumber(VehicleData[vehicle].inventory[item]) < tonumber(amount) then
        AddPlayerChat(player, _("not_enough_item"))
    else
        AddInventory(player, item, amount)
        RemoveVehicleInventory(vehicle, item, amount)
    end
end)

function GetNearestCar(player)
    local x, y, z = GetPlayerLocation(player)

    for k,v in pairs(GetAllVehicles()) do
        local x2, y2, z2 = GetVehicleLocation(v)
        local dist = GetDistance3D(x, y, z, x2, y2, z2)

        if dist < 300.0 then
            return v
        end
    end

    return 0
end

function getVehicleName(modelid)
    for key, value in pairs(CarPriceTable) do
        if value.modelid == modelid then
            return(value.name)
        end
    end
end

function getVehiclePrice(modelid, cardealerobject)
    for k, v in pairs(CarDealerTable) do
        if v.npc == cardealerobject then
            return(v.vehicles[modelid])
        end
    end
end

function getVehicleColor(color, cardealerobject)
    for k, v in pairs(CarDealerTable) do
        if v.npc == cardealerobject then
            return(v.colors[color])
        end
    end
end

function getVehicleId(modelid)
    return modelid:gsub("vehicle_", "")
end

function AddVehicleInventory(vehicle, item, amount)
    if VehicleData[vehicle].inventory[item] == nil then
        VehicleData[vehicle].inventory[item] = amount
    else
        VehicleData[vehicle].inventory[item] = VehicleData[vehicle].inventory[item] + amount
    end
end

function RemoveVehicleInventory(vehicle, item, amount)
    if VehicleData[vehicle].inventory[item] == nil then
        return
    else
        if VehicleData[vehicle].inventory[item] - amount < 1 then
            VehicleData[vehicle].inventory[item] = nil
        else
            VehicleData[vehicle].inventory[item] = VehicleData[vehicle].inventory[item] - amount
        end
    end
end