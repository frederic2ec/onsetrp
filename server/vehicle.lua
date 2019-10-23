
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

function CreateVehicleDatabase(player, vehicle, modelid, color)
    local query = mariadb_prepare(sql, "INSERT INTO player_garage (id, ownerid, modelid, color, garage) VALUES (NULL, '?', '?', '?', '0');",
        tostring(PlayerData[player].accountid),
        tostring(modelid),
        tostring(color)
    )

    mariadb_async_query(sql, query, onVehicleCreateDatabase, vehicle)
end

function onVehicleCreateDatabase(vehicle)
    VehicleData[vehicle].garageid = mariadb_get_insert_id()
end

function buyCarServer(player, modelid, color)
    local modelid = math.tointeger(modelid)
    local price = getVehiclePrice(modelid)
    local name = getVehicleName(modelid)
    local color = tostring(color)

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
                        SetVehicleRespawnParams(vehicle, false)
                        SetVehicleColor(vehicle, "0x"..color)
                        SetVehiclePropertyValue(vehicle, "locked", true, true)
                        CreateVehicleData(player, vehicle, modelid)
                        CreateVehicleDatabase(player, vehicle, modelid, color)
                        PlayerData[player].cash = PlayerData[player].cash - tonumber(price)
                        CallRemoteEvent(player, "closeCarDealer")
                        return AddPlayerChat(player, "You successfully bought a "..name.." for "..price.."$")
                    else
                        -- if vehicle on the spawn zone cancel and report an error
                        return AddPlayerChat(player, "Cannot spawn your vehicle !")
                    end
                end
                -- if no vehicle in the world spawn the car
                local vehicle = CreateVehicle(modelid, v.spawnx, v.spawny, v.spawnz, v.spawnh)
                SetVehicleColor(vehicle, "0x"..color)
                SetVehicleRespawnParams(vehicle, false)
                SetVehiclePropertyValue(vehicle, "locked", true, true)
                CreateVehicleData(player, vehicle, modelid)
                CreateVehicleDatabase(player, vehicle, modelid, color)
                PlayerData[player].cash = PlayerData[player].cash - tonumber(price)
                CallRemoteEvent(player, "closeCarDealer")
                return AddPlayerChat(player, "You successfully bought a "..name.." for "..price.."$")
            end
        end
        
    end
end
AddRemoteEvent("buyCarServer", buyCarServer)

function spawnCarServer(player, id)
    local query = mariadb_prepare(sql, "SELECT * FROM player_garage WHERE id = ?;",
    tostring(id))

    mariadb_async_query(sql, query, spawnCarServerLoaded, player)
end
AddRemoteEvent("spawnCarServer", spawnCarServer)

function spawnCarServerLoaded(player)
    for i=1,mariadb_get_row_count() do
        local result = mariadb_get_assoc(i)

        local id = math.tointeger(result["id"])
        local modelid = math.tointeger(result["modelid"])
        local color = tostring(result["color"])
        local name = getVehicleName(modelid)

        local query = mariadb_prepare(sql, "UPDATE `player_garage` SET `garage`=0 WHERE `id` = ?;",
        tostring(id)
        )

        local x, y, z = GetPlayerLocation(player)

        for _,v in pairs(GarageDealerTable) do
            local x2, y2, z2 = GetNPCLocation(v.object)
            local dist = GetDistance3D(x, y, z, x2, y2, z2)
            if dist < 150.0 then
                for _,w in pairs(GetAllVehicles()) do
                    local x3, y3, z3 = GetVehicleLocation(w)
                    local dist2 = GetDistance3D(v.spawnx, v.spawny, v.spawnz, x3, y3, z3)
                    if dist2 > 1000.0 then
                        -- if no vehicle on the spawn zone continue
                        local vehicle = CreateVehicle(modelid, v.spawnx, v.spawny, v.spawnz, v.spawnh)
                        SetVehicleRespawnParams(vehicle, false)
                        SetVehicleColor(vehicle, "0x"..color)
                        SetVehiclePropertyValue(vehicle, "locked", true, true)
                        CreateVehicleData(player, vehicle, modelid)
                        VehicleData[vehicle].garageid = id
                        mariadb_async_query(sql, query)
                        CallRemoteEvent(player, "closeGarageDealer")
                        return AddPlayerChat(player, "You successfully spawned your "..tostring(name))
                    else
                        -- if vehicle on the spawn zone cancel and report an error
                        return AddPlayerChat(player, "Cannot spawn your vehicle !")
                    end
                end
                -- if no vehicle in the world spawn the car
                local vehicle = CreateVehicle(modelid, v.spawnx, v.spawny, v.spawnz, v.spawnh)
                SetVehicleRespawnParams(vehicle, false)
                SetVehicleColor(vehicle, "0x"..color)
                SetVehiclePropertyValue(vehicle, "locked", true, true)
                CreateVehicleData(player, vehicle, modelid)
                VehicleData[vehicle].garageid = id
                mariadb_async_query(sql, query)
                CallRemoteEvent(player, "closeGarageDealer")
                return AddPlayerChat(player, "You successfully spawned your "..tostring(name))
            end
        end
	end
end

function sellCarServer(player, id)
    local query = mariadb_prepare(sql, "SELECT * FROM player_garage WHERE id = ?;",
    tostring(id))

    mariadb_async_query(sql, query, sellCarServerLoaded, player)
end
AddRemoteEvent("sellCarServer", sellCarServer)

function sellCarServerLoaded(player)
    for i=1,mariadb_get_row_count() do
        local result = mariadb_get_assoc(i)

        local id = math.tointeger(result["id"])
        local modelid = math.tointeger(result["modelid"])
        local name = getVehicleName(modelid)
        local price = getVehiclePrice(modelid) * 0.25

        local query = mariadb_prepare(sql, "DELETE FROM `player_garage` WHERE `id` = ?;",
        tostring(id)
        )
        mariadb_async_query(sql, query)
        PlayerData[player].cash = PlayerData[player].cash + tonumber(price)
        CallRemoteEvent(player, "closeGarageDealer")
        return AddPlayerChat(player, "You successfully selled your "..tostring(name).." for "..price.."$")
	end
end

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