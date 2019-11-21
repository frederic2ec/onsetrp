
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

AddEvent("OnPackageStart", function()
	for k,v in pairs(GarageStoreTable) do
        v.object = CreatePickup(v.modelid , v.location[1], v.location[2], v.location[3])
        

		table.insert(GarageStoreObjectsCached, v.object)
	end
end)

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
                    return AddPlayerChat(player, "Vehicle stored !")
                end
            end
		end
	end
end
AddEvent("OnPlayerPickupHit", OnPlayerPickupHit)