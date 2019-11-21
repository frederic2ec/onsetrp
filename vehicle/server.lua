local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

VehicleData = {}

function CreateVehicleData(player, vehicle, modelid)
    VehicleData[vehicle] = {}

    VehicleData[vehicle].garageid = 0
    VehicleData[vehicle].owner = PlayerData[player].accountid
    VehicleData[vehicle].modelid = modelid

    print("Data created for : "..vehicle)
end

function DestroyVehicleData(vehicle)
	if (VehicleData[vehicle] ~= nil) then
		return
    end

    VehicleData[vehicle] = nil
end

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

function getVehiclePrice(modelid)
    for key, value in pairs(CarPriceTable) do
        if value.modelid == modelid then
            return(value.price)
        end
    end
end