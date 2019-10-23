GarageStoreObjectsCached = { }
GarageStoreTable = { }

AddEvent("database:connected", function()
    mariadb_async_query(sql, "SELECT * FROM garage_store;", OnGarageStoreLoaded)
    
end)

function OnGarageStoreLoaded()
	for i=1,mariadb_get_row_count() do
		local result = mariadb_get_assoc(i)

		local id = math.tointeger(result["id"])
		local modelid = math.tointeger(result["modelid"])
		local x = tonumber(result["x"])
		local y = tonumber(result["y"])
		local z = tonumber(result["z"])

		createGarageStore(id, modelid, x, y, z)
	end

	print("Loaded "..#GarageStoreTable.." garages input")
end

--[[ AddEvent("OnPlayerLoggedIn", function(player)
    CallRemoteEvent(player, "garageDealerSetup", GarageDealerObjectsCached)
end) ]]

function createGarageStore(id, modelid, x, y, z)
	GarageStoreTable[id] = { }
	GarageStoreTable[id].id = id
	GarageStoreTable[id].object = CreatePickup(modelid, x, y, z)

    
    table.insert(GarageStoreObjectsCached, GarageStoreTable[id].object)
end

--[[ AddRemoteEvent("garageDealerInteract", function(player, garagedealerobject)
    local garagedealer = GetGarageDealearByObject(garagedealerobject)
	if garagedealer then
		local x, y, z = GetNPCLocation(garagedealer.object)
		local x2, y2, z2 = GetPlayerLocation(player)
        local dist = GetDistance3D(x, y, z, x2, y2, z2)
		if dist < 150 then
            CallRemoteEvent(player, "openGarageDealer")
		end
	end
end)

function GetGarageDealearByObject(garagedealerobject)
	for _,v in pairs(GarageDealerTable) do
		if v.object == garagedealerobject then
			return v
		end
	end
	return nil
end ]]

function OnPlayerPickupHit(player, pickup)
	for _,v in pairs(GarageStoreTable) do
		if v.object == pickup then
            vehicle = GetPlayerVehicle(player)
            if (VehicleData[vehicle].owner == PlayerData[player].accountid) then
                local query = mariadb_prepare(sql, "UPDATE `player_garage` SET `garage`=1 WHERE `id` = ?;",
                tostring(VehicleData[vehicle].garageid)
                )
                mariadb_async_query(sql, query)
                DestroyVehicle(vehicle)
                return AddPlayerChat(player, "Vehicle stored !")
            end
		end
	end
end
AddEvent("OnPlayerPickupHit", OnPlayerPickupHit)