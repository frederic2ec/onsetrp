local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

VehicleData = {}

VehicleTrunkSlots = { -- slots for vehicles
    vehicle_1 = 205,
    vehicle_2 = 50,
    vehicle_3 = 80,
    vehicle_4 = 215,
    vehicle_5 = 205,
    vehicle_6 = 90,
    vehicle_7 = 315,
    vehicle_8 = 50,
    vehicle_9 = 10,
    vehicle_10 = 10,
    vehicle_11 = 140,
    vehicle_12 = 100,
    vehicle_13 = 100,
    vehicle_14 = 100,
    vehicle_15 = 100,
    vehicle_16 = 100,
    vehicle_17 = 540,
    vehicle_18 = 540,
    vehicle_19 = 205,
    vehicle_20 = 10,
    vehicle_21 = 100,
    vehicle_22 = 475,
    vehicle_23 = 475,
    vehicle_24 = 10,
    vehicle_25 = 160
}

function CreateVehicleData(player, vehicle, modelid, fuel, health, licensePlate)
    VehicleData[vehicle] = {}

    local fuel = fuel or 100

    VehicleData[vehicle].garageid = 0
    VehicleData[vehicle].owner = PlayerData[player].accountid
    VehicleData[vehicle].modelid = modelid
    VehicleData[vehicle].inventory = {}
    VehicleData[vehicle].keys = {}
    VehicleData[vehicle].fuel = fuel
    VehicleData[vehicle].health = health or 5000
    VehicleData[vehicle].license_plate = licensePlate or 'AA-111-AA'

    print("Data created for : "..vehicle)
end

function OnPackageStart()
    -- Save all player data automatically 
    CreateTimer(function()
		for k,v in pairs(VehicleData) do
            SaveVehicleData(k)
            
        end
    end, 30000)
    
    CreateTimer(function()
        local vehicleToDelete = {}
        for k,v in pairs(GetAllVehicles()) do
            local hasOwner = false
            for w,z in pairs(GetAllPlayers()) do
                if VehicleData[v] == nil then
                    hasOwner = true
                    break
                end
                if PlayerData[z] == nil then
                    goto continue
                end
                if PlayerData[z].accountid == 0 or PlayerData[z].accountid == nil then
                    goto continue
                end
                if VehicleData[v].owner == PlayerData[z].accountid then
                    hasOwner = true
                    break
                end
                ::continue::
            end
            if not hasOwner then
                table.insert(vehicleToDelete, v)
            end
        end
        for k,v in pairs(vehicleToDelete) do
            local hasOwner = false
            for w,z in pairs(GetAllPlayers()) do
                if VehicleData[v] == nil then
                    hasOwner = true
                    break
                end
		if PlayerData[z] == nil then
                    goto continue
                end
                if PlayerData[z].accountid == 0 or PlayerData[z].accountid == nil then
                    goto continue
                end
                if VehicleData[v].owner == PlayerData[z].accountid then
                    hasOwner = true
                    break
                end
		::continue::
            end
            if not hasOwner then
                if VehicleData[v] ~= nil and VehicleData[v].garageid ~= 0 then
                    local query = mariadb_prepare(sql, "UPDATE `player_garage` SET `garage`=1 WHERE `id` = ?;",
                        VehicleData[v].garageid
                    )
                    mariadb_async_query(sql, query)
                end
                DestroyVehicleData(v)
                DestroyVehicle(v)
            end
        end
        print("All vehicle have been cleaned up !")
    end, 900000)
end
AddEvent("OnPackageStart", OnPackageStart)

function SaveVehicleData(vehicle) 
    VehicleData[vehicle].health = GetVehicleHealth(vehicle)    
    local query = mariadb_prepare(sql, "UPDATE player_garage SET ownerid = '?', inventory = '?', fuel = ?, health = ? WHERE id = '?' LIMIT 1;",
    VehicleData[vehicle].owner,
    json_encode(VehicleData[vehicle].inventory),
    VehicleData[vehicle].fuel,
    VehicleData[vehicle].health,
    VehicleData[vehicle].garageid
    )
    
mariadb_query(sql, query)
end

function DestroyVehicleData(vehicle)
	if (VehicleData[vehicle] == nil) then
		return
    end

    VehicleData[vehicle] = nil
end

AddRemoteEvent("ServerVehicleMenu", function(player, vehicle)
    if VehicleData[vehicle].owner == PlayerData[player].accountid then
        CallRemoteEvent(player, "OpenVehicleMenu")
    else
        for k,v in pairs(VehicleData[vehicle].keys) do
            if v == PlayerData[player].accountid then
                CallRemoteEvent(player, "OpenVehicleMenu")
            end
        end
    end
end)

function unlockVehicle(player)
    local nearestCar = GetNearestCar(player)
    local vehicle = VehicleData[nearestCar] 
    if vehicle and nearestCar ~= 0 and PlayerData[player] then
        if PlayerData[player].admin == 1 then
            if GetVehiclePropertyValue(nearestCar, "locked") then
                CallRemoteEvent(player, "MakeNotification", _("car_unlocked"), "linear-gradient(to right, #00b09b, #96c93d)")
                SetVehiclePropertyValue(nearestCar, "locked", false, true)
                CallRemoteEvent(player, "PlayAudioFile", "carUnlock.mp3")
		LightAnim(nearestCar)
            else
                CallRemoteEvent(player, "MakeNotification", _("car_locked"), "linear-gradient(to right, #00b09b, #96c93d)")
                SetVehiclePropertyValue(nearestCar, "locked", true, true)
                CallRemoteEvent(player, "PlayAudioFile", "carLock.mp3")
		LightAnim(nearestCar)
            end
            return
        end
        if vehicle.owner == PlayerData[player].accountid then
            if GetVehiclePropertyValue(nearestCar, "locked") then
                CallRemoteEvent(player, "MakeNotification", _("car_unlocked"), "linear-gradient(to right, #00b09b, #96c93d)")
                SetVehiclePropertyValue(nearestCar, "locked", false, true)
                CallRemoteEvent(player, "PlayAudioFile", "carUnlock.mp3")
		LightAnim(nearestCar)
            else
                CallRemoteEvent(player, "MakeNotification", _("car_locked"), "linear-gradient(to right, #00b09b, #96c93d)")
                SetVehiclePropertyValue(nearestCar, "locked", true, true)
                CallRemoteEvent(player, "PlayAudioFile", "carLock.mp3")
		LightAnim(nearestCar)
            end
            return
        else
            for k,v in pairs(vehicle.keys) do
                if v == PlayerData[player].accountid then
                    if GetVehiclePropertyValue(nearestCar, "locked") then
                        CallRemoteEvent(player, "MakeNotification", _("car_unlocked"), "linear-gradient(to right, #00b09b, #96c93d)")
                        SetVehiclePropertyValue(nearestCar, "locked", false, true)
                        CallRemoteEvent(player, "PlayAudioFile", "carUnlock.mp3")
			LightAnim(nearestCar)
                    else
                        CallRemoteEvent(player, "MakeNotification", _("car_locked"), "linear-gradient(to right, #00b09b, #96c93d)")
                        SetVehiclePropertyValue(nearestCar, "locked", true, true)
                        CallRemoteEvent(player, "PlayAudioFile", "carLock.mp3")
			LightAnim(nearestCar)
                    end
                end
            end
            return
        end
    end
end
AddRemoteEvent("unlockVehicle", unlockVehicle)

AddRemoteEvent("OpenTrunk", function(player, vehicle)
    local vehicle = vehicle or GetNearestCar(player)

    if GetVehiclePropertyValue(vehicle, "locked") then 
	CallRemoteEvent(player, "MakeNotification", _("this_vehicle_locked"), "linear-gradient(to right, #ff5f6d, #ffc371)")
        return false 
    end

    openTrunk(vehicle)

    local x, y, z = GetPlayerLocation(player)
    local nearestPlayers = GetPlayersInRange3D(x, y, z, 1000)
    local playersList = {}
    for k, v in pairs(nearestPlayers) do
        if PlayerData[k] == nil then
            goto continue
        end
        if PlayerData[k].name == nil then
            goto continue
        end
        if k ~= player then
            table.insert(playersList, {id = k, name = PlayerData[k].name})
        end
        ::continue::
    end
    
    local vehicleId = "vehicle_"..vehicle
    local vehicleName = _("vehicle_"..VehicleData[vehicle].modelid)
    
    friskedInventory = { 
        id = vehicleId, 
        name = vehicleName,
        inventory = VehicleData[vehicle].inventory,
        maxSlots = VehicleTrunkSlots["vehicle_"..VehicleData[vehicle].modelid]
    }
    
    table.insert(playersList, { id = vehicleId, name = vehicleName })

    SetPlayerPropertyValue(player, "opened-trunk", vehicle, true)

    CallRemoteEvent(player, "OpenPersonalMenu", Items, PlayerData[player].inventory, PlayerData[player].name, player, playersList, GetPlayerMaxSlots(player), friskedInventory)
end)

AddRemoteEvent("VehicleKeys", function(player) 
    local vehicle = GetNearestCar(player)
    if vehicle then
        local keyslist = VehicleData[vehicle].keys
        local playerlist = GetAllPlayers()
        CallRemoteEvent(player, "OpenVehicleKeys", keyslist, playerlist)
    end
end)

AddRemoteEvent("CloseTrunk", function(player, openedTrunk)
    local openedTrunk = openedTrunk or GetNearestCar(player)
    closeTrunk(openedTrunk)
end)

AddRemoteEvent("UnflipVehicle", function(player) 
    local vehicle = GetNearestCar(player)
    local rx, ry, rz = GetVehicleRotation(vehicle)

    if vehicle then
        SetVehicleRotation(vehicle, 0, ry, 0 )
    end
end)

AddRemoteEvent("VehicleGiveKey", function(player, toplayer)
    local vehicle = GetNearestCar(player)
    local toplayer = tonumber(toplayer)

    if VehicleData[vehicle].keys[player] == 1 then
        if VehicleData[vehicle].keys[toplayer] == nil then
            VehicleData[vehicle].keys[toplayer] = 1
        else
            CallRemoteEvent(player, "MakeNotification", _("already_have_key"), "linear-gradient(to right, #ff5f6d, #ffc371)")
        end
    end
end)

AddRemoteEvent("VehicleRemoveKey", function(player, toplayer)
    local vehicle = GetNearestCar(player)
    local toplayer = tonumber(toplayer)

    if VehicleData[vehicle].keys[toplayer] == nil then
        return
    else
        VehicleData[vehicle].keys[toplayer] = nil
    end
end)

function GetNearestCar(player)
    local x, y, z = GetPlayerLocation(player)

    for k,v in pairs(GetAllVehicles()) do
        local x2, y2, z2 = GetVehicleLocation(v)
        local dist = GetDistance3D(x, y, z, x2, y2, z2)

        if dist < 400.0 then
            return v
        end
    end

    return 0
end

function GetNearestCars(player, distance)
    local vehicleList = {}
    local distance = distance or 300
    local x, y, z = GetPlayerLocation(player)

    for k, vehicleId in pairs(GetStreamedVehiclesForPlayer(player)) do
        local x2, y2, z2 = GetVehicleLocation(vehicleId)
        local dist = GetDistance3D(x, y, z, x2, y2, z2)

        if dist < distance then
            table.insert(vehicleList, vehicleId)
        end
    end

    return vehicleList
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

function AddVehicleInventory(vehicle, item, amount, player)
    if item == "cash" or (VehicleTrunkSlots["vehicle_"..VehicleData[vehicle].modelid] - GetVehicleUsedSlots(vehicle)) >= (amount * ItemsWeight[item]) then
        if VehicleData[vehicle].inventory[item] == nil then
            VehicleData[vehicle].inventory[item] = amount
        else
            VehicleData[vehicle].inventory[item] = VehicleData[vehicle].inventory[item] + amount
        end
        
        if player then
            UpdateUIInventory(player, "vehicle_"..vehicle, item, VehicleData[vehicle].inventory[item])
        end

        SaveVehicleData(vehicle)
        
        return true
    else
        UpdateUIInventory(player, "vehicle_"..vehicle, item, VehicleData[vehicle].inventory[item])
        return false
    end
end

function RemoveVehicleInventory(vehicle, item, amount, player)
    if VehicleData[vehicle].inventory[item] == nil then
        return false
    else
        if VehicleData[vehicle].inventory[item] - amount < 1 then
            VehicleData[vehicle].inventory[item] = nil
        else
            VehicleData[vehicle].inventory[item] = VehicleData[vehicle].inventory[item] - amount
        end

        if player then
            local count = VehicleData[vehicle].inventory[item] or 0
            UpdateUIInventory(player, "vehicle_"..vehicle, item, count)
        end

        SaveVehicleData(vehicle)

        return true
    end
end

function GetVehicleUsedSlots(vehicle)
    local usedSlots = 0
    for k, v in pairs(VehicleData[vehicle].inventory) do
        if k ~= 'cash' then
            usedSlots = usedSlots + (v * ItemsWeight[k])
        end
    end
    return usedSlots
end

AddRemoteEvent("ToggleEngine", function(player, vehicle)
    if vehicle ~= 0 then
        if (GetPlayerVehicleSeat(player) ~= 1) then
            return 
        else
            if GetVehicleEngineState(vehicle) then
                StopVehicleEngine(vehicle)
            else
                if VehicleData[vehicle] ~= nil then
                    if VehicleData[vehicle].fuel > 0 then
                        StartVehicleEngine(vehicle)
                    end
                else
                    StartVehicleEngine(vehicle)
                end
            end
        end
    end
end)

function ToggleTrunk(player)
    if IsPlayerInVehicle(player) then
        if GetPlayerVehicleSeat(player) == 1 then
            vehicle = GetPlayerVehicle(player)
            if GetVehicleTrunkRatio(vehicle) > 0.0 and GetVehicleTrunkRatio(vehicle) < 60.0 then
                -- Animation was already running
            elseif GetVehicleTrunkRatio(vehicle) == 60.0 then
                closeTrunk(vehicle)
            else
                openTrunk(vehicle)
            end
        end
    end
end

function openTrunk(vehicle)
    CreateCountTimer(function()
        if GetVehicleTrunkRatio(vehicle) then
            openRatio = GetVehicleTrunkRatio(vehicle) + 1
            if openRatio <= 60.0 then
                SetVehicleTrunkRatio(vehicle, openRatio)
            end
        end
    end, 25, 60)
end
AddRemoteEvent("OpenCarTrunk", openTrunk)

function closeTrunk(vehicle)
    CreateCountTimer(function()
        if vehicle and GetVehicleTrunkRatio(vehicle) then
            openRatio = GetVehicleTrunkRatio(vehicle) - 1
            if openRatio >= 0.0 then
                SetVehicleTrunkRatio(vehicle, openRatio)
            end
        end
    end, 25, 60)
end

AddRemoteEvent("ToggleTrunk", ToggleTrunk)

AddRemoteEvent("ToggleHood", function(player)
    if IsPlayerInVehicle(player) then
        if GetPlayerVehicleSeat(player) == 1 then
            vehicle = GetPlayerVehicle(player)

            if GetVehicleHoodRatio(vehicle) then
                if GetVehicleHoodRatio(vehicle) > 0.0 and GetVehicleHoodRatio(vehicle) < 60.0 then
                    -- Animation was already running
                elseif GetVehicleHoodRatio(vehicle) == 60.0 then
                    CreateCountTimer(function()
                        if vehicle and GetVehicleHoodRatio(vehicle) then
                            openRatio = GetVehicleHoodRatio(vehicle) - 0.5
                            if openRatio >= 0.0 then
                                SetVehicleHoodRatio(vehicle, openRatio)
                            end
                        end
                    end, 25, 120)
                else
                    CreateCountTimer(function()
                        if GetVehicleHoodRatio(vehicle) then
                            openRatio = GetVehicleHoodRatio(vehicle) + 0.5
                            if openRatio <= 60.0 then
                                SetVehicleHoodRatio(vehicle, openRatio)
                            end
                        end
                    end, 25, 120)
                end
            end
        end
    end
end)

function LightAnim(veh)
    CreateCountTimer(function()
        if GetVehicleLightState(veh) then
            SetVehicleLightEnabled(veh, false)
        else
            SetVehicleLightEnabled(veh, true)
        end
    end, 200, 4)
end
