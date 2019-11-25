local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

GarageDealerObjectsCached = { }
GarageDealerTable = {
	{
		location = { 126574, 74560, 1567, 90 },
		spawn = { 127533, 75598 , 1567, 90 }
	}
 }

 GarageStoreTable = { 
    {
        modelid = 2,
        location = { 127542, 75351, 1567 }
    },
    {
        modelid = 2,
        location = { 128002, 75351, 1567 }
    },
    {
        modelid = 2,
        location = { 128557, 75351, 1567 }
    },
    {
        modelid = 2,
        location = { 129014, 75351, 1567 }
    }
}

GarageStoreObjectsCached = {}

AddEvent("database:connected", function()
    mariadb_async_query(sql, "UPDATE `player_garage` SET `garage`=1 WHERE garage = 0;")
    
end)

 AddEvent("OnPackageStart", function()
	for k,v in pairs(GarageDealerTable) do
        v.npc = CreateNPC(v.location[1], v.location[2], v.location[3], v.location[4])
        
		CreateText3D(_("garage").."\n".._("press_e"), 18, v.location[1], v.location[2], v.location[3] + 120, 0, 0, 0)

		table.insert(GarageDealerObjectsCached, v.npc)
    end
    
    for k,v in pairs(GarageStoreTable) do
        v.object = CreatePickup(v.modelid , v.location[1], v.location[2], v.location[3])
        

		table.insert(GarageStoreObjectsCached, v.object)
	end
end)

AddEvent("OnPlayerJoin", function(player)
    CallRemoteEvent(player, "garageDealerSetup", GarageDealerObjectsCached)
end)

AddRemoteEvent("garageDealerInteract", function(player, garagedealerobject)
    local garagedealer = GetGarageDealearByObject(garagedealerobject)
	if garagedealer then
		local x, y, z = GetNPCLocation(garagedealer.npc)
		local x2, y2, z2 = GetPlayerLocation(player)
        local dist = GetDistance3D(x, y, z, x2, y2, z2)
		if dist < 150 then
            sendGarageList(player)
		end
	end
end)

function GetGarageDealearByObject(garagedealerobject)
	for k,v in pairs(GarageDealerTable) do
		if v.npc == garagedealerobject then
			return v
		end
	end
	return nil
end

function sendGarageList(player)
    local query = mariadb_prepare(sql, "SELECT * FROM player_garage WHERE ownerid = ? AND garage = 1;",
		PlayerData[player].accountid)

    mariadb_async_query(sql, query, OnGarageListLoaded, player)
end

function OnGarageListLoaded(player)
    local lVehicle = {}
    for i=1,mariadb_get_row_count() do
        local result = mariadb_get_assoc(i)

        local id = tostring(result["id"])
        local modelid = math.tointeger(result["modelid"])
        local color = result["color"]
        local name = "vehicle_"..modelid
        local price = math.ceil(result["price"] * 0.25)
        lVehicle[id] = {}
        lVehicle[id].name = name
        lVehicle[id].price = price
    end
    CallRemoteEvent(player, "openGarageDealer", lVehicle)
    
end

function OnPlayerPickupHit(player, pickup)
	for k,v in pairs(GarageStoreTable) do
        if v.object == pickup then
            vehicle = GetPlayerVehicle(player)
            seat = GetPlayerVehicleSeat(player)
            if (vehicle ~= 0 and seat == 1) then
                if (VehicleData[vehicle].owner == PlayerData[player].accountid) then
                    local query = mariadb_prepare(sql, "UPDATE `player_garage` SET `garage`=1 WHERE `id` = ?;",
                    tostring(VehicleData[vehicle].garageid)
                    )
                    mariadb_async_query(sql, query)
                    DestroyVehicle(vehicle)
                    DestroyVehicleData(vehicle)
                    return AddPlayerChat(player, _("vehicle_stored"))
                end
            end
		end
	end
end
AddEvent("OnPlayerPickupHit", OnPlayerPickupHit)

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
        local name = _("vehicle_"..modelid)

        local query = mariadb_prepare(sql, "UPDATE `player_garage` SET `garage`=0 WHERE `id` = ?;",
        tostring(id)
        )

        local x, y, z = GetPlayerLocation(player)

        for k,v in pairs(GarageDealerTable) do
            local x2, y2, z2 = GetNPCLocation(v.npc)
            local dist = GetDistance3D(x, y, z, x2, y2, z2)
            if dist < 150.0 then
                for k,w in pairs(GetAllVehicles()) do
                    local x3, y3, z3 = GetVehicleLocation(w)
                    local dist2 = GetDistance3D(v.spawn[1], v.spawn[2], v.spawn[3], x3, y3, z3)
                    if dist2 > 1000.0 then
                        -- if no vehicle on the spawn zone continue
                        local vehicle = CreateVehicle(modelid, v.spawn[1], v.spawn[2], v.spawn[3], v.spawn[4])
                        SetVehicleRespawnParams(vehicle, false)
                        SetVehicleColor(vehicle, "0x"..color)
                        SetVehiclePropertyValue(vehicle, "locked", true, true)
                        CreateVehicleData(player, vehicle, modelid)
                        VehicleData[vehicle].garageid = id
                        mariadb_async_query(sql, query)
                        CallRemoteEvent(player, "closeGarageDealer")
                        return AddPlayerChat(player, _("spawn_vehicle_success", tostring(name)))
                    else
                        -- if vehicle on the spawn zone cancel and report an error
                        return AddPlayerChat(player, _("cannot_spawn_vehicle"))
                    end
                end
                -- if no vehicle in the world spawn the car
                local vehicle = CreateVehicle(modelid, v.spawn[1], v.spawn[2], v.spawn[3], v.spawn[4])
                SetVehicleRespawnParams(vehicle, false)
                SetVehicleColor(vehicle, "0x"..color)
                SetVehiclePropertyValue(vehicle, "locked", true, true)
                CreateVehicleData(player, vehicle, modelid)
                VehicleData[vehicle].garageid = id
                mariadb_async_query(sql, query)
                CallRemoteEvent(player, "closeGarageDealer")
                return AddPlayerChat(player, _("spawn_vehicle_success", tostring(name)))
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
        local name = _("vehicle_"..modelid)
        local price = math.ceil(result["price"] * 0.25)

        local query = mariadb_prepare(sql, "DELETE FROM `player_garage` WHERE `id` = ?;",
        tostring(id)
        )
        mariadb_async_query(sql, query)
        PlayerData[player].cash = PlayerData[player].cash + tonumber(price)
        return AddPlayerChat(player, _("sell_vehicle_success", tostring(name), price, _("currency")))
	end
end