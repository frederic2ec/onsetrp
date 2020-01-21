local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

VehicleData = {}

function CreateVehicleData(player, vehicle, modelid, fuel)
    VehicleData[vehicle] = {}

    local fuel = fuel or 100

    VehicleData[vehicle].garageid = 0
    VehicleData[vehicle].owner = PlayerData[player].accountid
    VehicleData[vehicle].modelid = modelid
    VehicleData[vehicle].inventory = {}
    VehicleData[vehicle].keys = {}
    VehicleData[vehicle].fuel = fuel

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
                    print(VehicleData[v].owner)
                    print(PlayerData[z].accountid )
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
                    print(VehicleData[v].owner)
                    print(PlayerData[z].accountid )
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
    local query = mariadb_prepare(sql, "UPDATE player_garage SET ownerid = '?', inventory = '?', fuel = ? WHERE id = '?' LIMIT 1;",
    VehicleData[vehicle].owner,
    json_encode(VehicleData[vehicle].inventory),
    VehicleData[vehicle].fuel,
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
    if nearestCar ~= 0 then
        if PlayerData[player].admin == 1 then
            if GetVehiclePropertyValue(nearestCar, "locked") then
                CallRemoteEvent(player, "MakeNotification", _("car_unlocked"), "linear-gradient(to right, #00b09b, #96c93d)")
                SetVehiclePropertyValue(nearestCar, "locked", false, true)
                CallRemoteEvent(player, "PlayAudioFile", "carUnlock.mp3")
            else
                CallRemoteEvent(player, "MakeNotification", _("car_locked"), "linear-gradient(to right, #00b09b, #96c93d)")
                SetVehiclePropertyValue(nearestCar, "locked", true, true)
                CallRemoteEvent(player, "PlayAudioFile", "carLock.mp3")
            end
            return
        end
        if vehicle.owner == PlayerData[player].accountid then
            if GetVehiclePropertyValue(nearestCar, "locked") then
                CallRemoteEvent(player, "MakeNotification", _("car_unlocked"), "linear-gradient(to right, #00b09b, #96c93d)")
                SetVehiclePropertyValue(nearestCar, "locked", false, true)
                CallRemoteEvent(player, "PlayAudioFile", "carUnlock.mp3")
            else
                CallRemoteEvent(player, "MakeNotification", _("car_locked"), "linear-gradient(to right, #00b09b, #96c93d)")
                SetVehiclePropertyValue(nearestCar, "locked", true, true)
                CallRemoteEvent(player, "PlayAudioFile", "carLock.mp3")
            end
            return
        else
            for k,v in pairs(vehicle.keys) do
                if v == PlayerData[player].accountid then
                    if GetVehiclePropertyValue(nearestCar, "locked") then
                        CallRemoteEvent(player, "MakeNotification", _("car_unlocked"), "linear-gradient(to right, #00b09b, #96c93d)")
                        SetVehiclePropertyValue(nearestCar, "locked", false, true)
                        CallRemoteEvent(player, "PlayAudioFile", "carUnlock.mp3")
                    else
                        CallRemoteEvent(player, "MakeNotification", _("car_locked"), "linear-gradient(to right, #00b09b, #96c93d)")
                        SetVehiclePropertyValue(nearestCar, "locked", true, true)
                        CallRemoteEvent(player, "PlayAudioFile", "carLock.mp3")
                    end
                end
            end
            return
        end
    end
end
AddRemoteEvent("unlockVehicle", unlockVehicle)

AddRemoteEvent("OpenTrunk", function(player)
    local vehicle = GetNearestCar(player)
    SetVehicleTrunkRatio(vehicle, 60.0)
    CallRemoteEvent(player, "OpenVehicleInventory", PlayerData[player].inventory, VehicleData[vehicle].inventory)
end)

AddRemoteEvent("VehicleKeys", function(player) 
    local vehicle = GetNearestCar(player)
    local keyslist = VehicleData[vehicle].keys
    local playerlist = GetAllPlayers()
    CallRemoteEvent(player, "OpenVehicleKeys", keyslist, playerlist)
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
        CallRemoteEvent(player, "MakeNotification", _("not_enough_item"), "linear-gradient(to right, #ff5f6d, #ffc371)")
    else
        RemoveInventory(player, item, amount)
        AddVehicleInventory(vehicle, item, amount)
    end
end)

AddRemoteEvent("VehicleUnstore", function(player, item, amount) 
    local vehicle = GetNearestCar(player)

    if tonumber(VehicleData[vehicle].inventory[item]) < tonumber(amount) then
        CallRemoteEvent(player, "MakeNotification", _("not_enough_item"), "linear-gradient(to right, #ff5f6d, #ffc371)")
    else
        AddInventory(player, item, amount)
        RemoveVehicleInventory(vehicle, item, amount)
    end
end)


AddRemoteEvent("VehicleGiveKey", function(player, toplayer)
    local vehicle = GetNearestCar(player)
    local toplayer = tonumber(toplayer)

    if VehicleData[vehicle].keys[toplayer] == nil then
        VehicleData[vehicle].keys[toplayer] = 1
    else
        CallRemoteEvent(player, "MakeNotification", _("already_have_key"), "linear-gradient(to right, #ff5f6d, #ffc371)")
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

AddRemoteEvent("ToggleTrunk", function(player)
    if IsPlayerInVehicle(player) then
        if GetPlayerVehicleSeat(player) == 1 then
            vehicle = GetPlayerVehicle(player)
            if GetVehicleTrunkRatio(vehicle) > 0.0 and GetVehicleTrunkRatio(vehicle) < 60.0 then
                -- Animation was already running
            elseif GetVehicleTrunkRatio(vehicle) == 60.0 then
                CreateCountTimer(function()
                    openRatio = GetVehicleTrunkRatio(vehicle) - 0.5
                    if openRatio >= 0.0 then
                        SetVehicleTrunkRatio(vehicle, openRatio)
                    end
                end, 25, 120)
            else
                CreateCountTimer(function()
                    openRatio = GetVehicleTrunkRatio(vehicle) + 0.5
                    if openRatio <= 60.0 then
                        SetVehicleTrunkRatio(vehicle, openRatio)
                    end
                end, 25, 120)
            end
        end
    end
end)

AddRemoteEvent("ToggleHood", function(player)
    if IsPlayerInVehicle(player) then
        if GetPlayerVehicleSeat(player) == 1 then
            vehicle = GetPlayerVehicle(player)
            if GetVehicleHoodRatio(vehicle) > 0.0 and GetVehicleHoodRatio(vehicle) < 60.0 then
                -- Animation was already running
            elseif GetVehicleHoodRatio(vehicle) == 60.0 then
                CreateCountTimer(function()
                    openRatio = GetVehicleHoodRatio(vehicle) - 0.5
                    if openRatio >= 0.0 then
                        SetVehicleHoodRatio(vehicle, openRatio)
                    end
                end, 25, 120)
            else
                CreateCountTimer(function()
                    openRatio = GetVehicleHoodRatio(vehicle) + 0.5
                    if openRatio <= 60.0 then
                        SetVehicleHoodRatio(vehicle, openRatio)
                    end
                end, 25, 120)
            end
        end
    end
end)
