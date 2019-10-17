
VehicleData = {}

function CreateVehicleData(player, vehicle, modelid)
    VehicleData[vehicle] = {}

    VehicleData[vehicle].owner = PlayerData[player].accountid
    VehicleData[vehicle].modelid = modelid

    print("Data created for : "..vehicle)
end

function CreateVehicleDatabase(player, modelid)
    local query = mariadb_prepare(sql, "INSERT INTO garage (id, ownerid, modelid, garage) VALUES (NULL, '?', '?', '0');",
        tostring(PlayerData[player].accountid),
        tostring(modelid)
    )

	mariadb_query(sql, query)
end

function buyCarServer(player, price, name, modelid)
	if tonumber(price) > PlayerData[player].cash then
        AddPlayerChat(player, "You don't have the money to buy this car !")
    else
        local x, y, z = GetPlayerLocation(player)

        for _,v in pairs(CarDealerTable) do
            local x2, y2, z2 = GetNPCLocation(v.object)
            local dist = GetDistance3D(x, y, z, x2, y2, z2)
            if dist < 150.0 then
                for _,w in pairs(GetAllVehicles()) do
                    local x3, y3, z3 = GetVehicleLocation(w)
                    local dist2 = GetDistance3D(v.spawnx, v.spawny, v.spawnz, x3, y3, z3)
                    if dist2 > 1000.0 then
                        -- if no vehicle on the spawn zone continue
                        local vehicle = CreateVehicle(modelid, v.spawnx, v.spawny, v.spawnz, v.spawnh)
                        SetVehiclePropertyValue(vehicle, "locked", true, true)
                        CreateVehicleData(player, vehicle, modelid)
                        CreateVehicleDatabase(player, modelid)
                        PlayerData[player].cash = PlayerData[player].cash - tonumber(price)
                        return AddPlayerChat(player, "You successfully bought a "..name.." for "..price.."$")
                    else
                        -- if vehicle on the spawn zone cancel and report an error
                        return AddPlayerChat(player, "Cannot spawn your vehicle !")
                    end
                end
                -- if no vehicle in the world spawn the car
                local vehicle = CreateVehicle(modelid, v.spawnx, v.spawny, v.spawnz, v.spawnh)
                SetVehiclePropertyValue(vehicle, "locked", true, true)
                CreateVehicleData(player, vehicle, modelid)
                CreateVehicleDatabase(player, modelid)
                PlayerData[player].cash = PlayerData[player].cash - tonumber(price)
                return AddPlayerChat(player, "You successfully bought a "..name.." for "..price.."$")
            end
        end
        
    end
end
AddRemoteEvent("buyCarServer", buyCarServer)

function unlockVehicle(player)
    local nearestCar = GetNearestCar(player)
    local vehicle = VehicleData[nearestCar]
    local playerData = PlayerData[player]
    if nearestCar ~= 0 then
        if vehicle.owner == playerData.accountid then
            if GetVehiclePropertyValue(nearestCar, "locked") then
                AddPlayerChat(player, "Car unlocked !")
                SetVehiclePropertyValue(nearestCar, "locked", false, true)
                CallRemoteEvent(player, "PlayAudioFile", "carUnlock.mp3")
            else
                AddPlayerChat(player, "Car locked !")
                SetVehiclePropertyValue(nearestCar, "locked", true, true)
                CallRemoteEvent(player, "PlayAudioFile", "carLock.mp3")
            end
        end
    end
end
AddRemoteEvent("unlockVehicle", unlockVehicle)

function GetNearestCar(player)
    local x, y, z = GetPlayerLocation(player)

    for _,v in pairs(GetAllVehicles()) do
        local x2, y2, z2 = GetVehicleLocation(v)
        local dist = GetDistance3D(x, y, z, x2, y2, z2)

        if dist < 300.0 then
            return v
        end
    end

    return 0
end