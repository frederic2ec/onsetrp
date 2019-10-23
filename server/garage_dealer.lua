GarageDealerObjectsCached = { }
GarageDealerTable = { }

AddEvent("database:connected", function()
    mariadb_async_query(sql, "SELECT * FROM garage_dealer;", OnGarageDealerLoaded)
    mariadb_async_query(sql, "UPDATE `player_garage` SET `garage`=1 WHERE garage = 0;")
    
end)

function OnGarageDealerLoaded()
	for i=1,mariadb_get_row_count() do
		local result = mariadb_get_assoc(i)

		local id = math.tointeger(result["id"])
		local modelid = math.tointeger(result["modelid"])
		local x = tonumber(result["x"])
		local y = tonumber(result["y"])
		local z = tonumber(result["z"])
		local h = tonumber(result["h"])
        local spawnx = tonumber(result["spawnx"])
		local spawny = tonumber(result["spawny"])
		local spawnz = tonumber(result["spawnz"])
		local spawnh = tonumber(result["spawnh"])

		createGarageDealer(id, modelid, x, y, z, h, spawnx, spawny, spawnz, spawnh)
	end

	print("Loaded "..#GarageDealerTable.." garages")
end

AddEvent("OnPlayerLoggedIn", function(player)
    CallRemoteEvent(player, "garageDealerSetup", GarageDealerObjectsCached)
end)

function createGarageDealer(id, modelid, x, y, z, h, spawnx, spawny, spawnz, spawnh)
	GarageDealerTable[id] = { }
	GarageDealerTable[id].id = id
	GarageDealerTable[id].spawnx = spawnx
	GarageDealerTable[id].spawny = spawny
	GarageDealerTable[id].spawnz = spawnz
	GarageDealerTable[id].spawnh = spawnh
	GarageDealerTable[id].object = CreateNPC(modelid, x, y, z, h)		
	GarageDealerTable[id].text3d = CreateText3D("Garage\nPress E", 18, x, y, z + 120, 0, 0, 0)

    
    table.insert(GarageDealerObjectsCached, GarageDealerTable[id].object)
end

AddRemoteEvent("garageDealerInteract", function(player, garagedealerobject)
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
end

function sendGarageList(player)
    local query = mariadb_prepare(sql, "SELECT * FROM player_garage WHERE ownerid = ? AND garage = 1;",
		PlayerData[player].accountid)

    mariadb_async_query(sql, query, OnGarageListLoaded, player)
end
AddRemoteEvent("sendGarageList", sendGarageList)

function OnGarageListLoaded(player)
    CallRemoteEvent(player, "clearGarageList")
    for i=1,mariadb_get_row_count() do
        local result = mariadb_get_assoc(i)

        local id = math.tointeger(result["id"])
        local modelid = math.tointeger(result["modelid"])
        local name = getVehicleName(modelid)
        local price = getVehiclePrice(modelid) * 0.25
        
        CallRemoteEvent(player, "getGarageList", id, name, price)
	end
end