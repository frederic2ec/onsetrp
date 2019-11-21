GarageDealerObjectsCached = { }
GarageDealerTable = {
	{
		location = { 126574, 74560, 1567, 90 },
		spawn = { 127533, 75598 , 1567, 90 }
	}
 }

AddEvent("database:connected", function()
    mariadb_async_query(sql, "UPDATE `player_garage` SET `garage`=1 WHERE garage = 0;")
    
end)

 AddEvent("OnPackageStart", function()
	for k,v in pairs(GarageDealerTable) do
		v.npc = CreateNPC(v.location[1], v.location[2], v.location[3], v.location[4])
		CreateText3D("Garage\nPress E", 18, v.location[1], v.location[2], v.location[3] + 120, 0, 0, 0)

		table.insert(GarageDealerObjectsCached, v.npc)
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
            CallRemoteEvent(player, "openGarageDealer")
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
AddRemoteEvent("sendGarageList", sendGarageList)

function OnGarageListLoaded(player)
    CallRemoteEvent(player, "clearGarageList")
    for i=1,mariadb_get_row_count() do
        local result = mariadb_get_assoc(i)

        local id = math.tointeger(result["id"])
		local modelid = math.tointeger(result["modelid"])
		local color = result["color"]
        local name = getVehicleName(modelid)
        local price = getVehiclePrice(modelid) * 0.25
        
        CallRemoteEvent(player, "getGarageList", id, name, price, color)
	end
end