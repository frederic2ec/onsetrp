local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

GarageDealerObjectsCached = { }
GarageDealerTable = {
    {
		location = { 22083, 146617, 1560, -90 },
		spawn = { 22120, 145492 , 1560, -90 }
    },
    {
        location = { -184007, -50877, 1146, -90 },
        spawn = { -183649, -51499, 1146, -90 }
    },
    {
        location = { 207126, 171157, 1330, -90 },
        spawn = { 207090, 170725, 1306, -90 }
    },
    {
        location = { -25135, -17097, 2062, -150 },
        spawn = { -25576, -17300, 2062 , -150 }
    }
 }

 GarageStoreTable = {
    {
        modelid = 2,
        location = {
            { 23432, 145697, 1550 },
            { 20752, 168878, 1306 },
            { 207516, 168554, 1306 },
            { 207524, 168216, 1306 },
            { 207514, 167867, 1306 },
            { -184587, -51196, 1146 },
            { -185403, -51170, 1146 },
            { -185603, -51410, 1146 },
            { 207520, 168878, 1306 },
            { 207516, 168554, 1306 },
            { 207524, 168216, 1306 },
            { 207514, 167867, 1306 },
            { -25189, -16824, 2077 }
        },
        object = {}
    }
}

GarageStoreObjectsCached = {}

AddEvent("database:connected", function()
    mariadb_query(sql, "UPDATE `player_garage` SET `garage`=1 WHERE garage = 0;")
end)

 AddEvent("OnPackageStart", function()
	for k,v in pairs(GarageDealerTable) do
        v.npc = CreateNPC(v.location[1], v.location[2], v.location[3], v.location[4])

		CreateText3D(_("garage").."\n".._("press_e"), 18, v.location[1], v.location[2], v.location[3] + 120, 0, 0, 0)

		table.insert(GarageDealerObjectsCached, v.npc)
    end

    for k,v in pairs(GarageStoreTable) do
        for i,j in pairs(v.location) do
            v.object[i] = CreatePickup(v.modelid , v.location[i][1], v.location[i][2], v.location[i][3])


            table.insert(GarageStoreObjectsCached, v.object[i])
        end
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
        for i,j in pairs(v.object) do
            if j == pickup then
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
                        return CallRemoteEvent(player, "MakeNotification", _("vehicle_stored"), "linear-gradient(to right, #00b09b, #96c93d)")
                    end
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
        local fuel = math.tointeger(result["fuel"])
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
                local isSpawnable = true
                for k,w in pairs(GetAllVehicles()) do
                    local x3, y3, z3 = GetVehicleLocation(w)
                    local dist2 = GetDistance3D(v.spawn[1], v.spawn[2], v.spawn[3], x3, y3, z3)
                    if dist2 < 1000.0 then
                        isSpawnable = false
                        break
                    end
                end
                if isSpawnable then
                    local vehicle = CreateVehicle(modelid, v.spawn[1], v.spawn[2], v.spawn[3], v.spawn[4])
                    SetVehicleRespawnParams(vehicle, false)
                    SetVehicleColor(vehicle, "0x"..color)
                    SetVehiclePropertyValue(vehicle, "locked", true, true)
                    SetVehiclePropertyValue(vehicle, "fuel", true, fuel)
                    CreateVehicleData(player, vehicle, modelid, fuel)
                    VehicleData[vehicle].garageid = id
                    mariadb_async_query(sql, query)
                    CallRemoteEvent(player, "closeGarageDealer")
                    return CallRemoteEvent(player, "MakeNotification", _("spawn_vehicle_success", tostring(name)), "linear-gradient(to right, #00b09b, #96c93d)")
                else
                    return CallRemoteEvent(player, "MakeNotification", _("cannot_spawn_vehicle"), "linear-gradient(to right, #ff5f6d, #ffc371)")
                end
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

        local query = mariadb_prepare(sql, "DELETE FROM `player_garage` WHERE `id` = ?;", tostring(id))
        mariadb_async_query(sql, query)
        AddPlayerCash(player, price)
        return CallRemoteEvent(player, "MakeNotification", _("sell_vehicle_success", tostring(name), price, _("currency")), "linear-gradient(to right, #00b09b, #96c93d)")
	end
end
