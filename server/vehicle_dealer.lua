CarDealerObjectsCached = { }
CarDealerTable = { }
CarPriceTable = { }

AddEvent("database:connected", function()
	mariadb_async_query(sql, "SELECT * FROM vehicle_dealer;", OnCarDealerLoaded)
	mariadb_async_query(sql, "SELECT * FROM vehicle_price;", OnCarPriceLoaded)
end)

function OnCarDealerLoaded()
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

		createCarDealer(id, modelid, x, y, z, h, spawnx, spawny, spawnz, spawnh)
	end

	print("Loaded "..#CarDealerTable.." Car dealers")
end

function OnCarPriceLoaded()
	for i=1,mariadb_get_row_count() do
		local result = mariadb_get_assoc(i)

		local id = math.tointeger(result["id"])
		local modelid = math.tointeger(result["modelid"])
		local name = tostring(result["name"])
		local price = tonumber(result["price"])

		createCarPrice(id, modelid, name, price)
	end

	print("Loaded "..#CarPriceTable.." Cars in the dealer")
end

AddEvent("OnPlayerLoggedIn", function(player)
    CallRemoteEvent(player, "carDealerSetup", CarDealerObjectsCached)
end)

function createCarDealer(id, modelid, x, y, z, h, spawnx, spawny, spawnz, spawnh)
	CarDealerTable[id] = { }
	CarDealerTable[id].id = id
	CarDealerTable[id].spawnx = spawnx
	CarDealerTable[id].spawny = spawny
	CarDealerTable[id].spawnz = spawnz
	CarDealerTable[id].spawnh = spawnh
	CarDealerTable[id].object = CreateNPC(modelid, x, y, z, h)		
	CarDealerTable[id].text3d = CreateText3D("Car Dealer\nPress E", 18, x, y, z + 120, 0, 0, 0)

	table.insert(CarDealerObjectsCached, CarDealerTable[id].object)
end

function createCarPrice(id, modelid, name, price)
	CarPriceTable[id] = { }
	CarPriceTable[id].modelid = modelid
	CarPriceTable[id].name = name
	CarPriceTable[id].price = price
end

AddRemoteEvent("carDealerInteract", function(player, cardealerobject)
    local cardealer = GetCarDealearByObject(cardealerobject)
	if cardealer then
		local x, y, z = GetNPCLocation(cardealer.object)
		local x2, y2, z2 = GetPlayerLocation(player)
        local dist = GetDistance3D(x, y, z, x2, y2, z2)

		if dist < 150 then
            CallRemoteEvent(player, "openCarDealer")
		end
	end
end)

function sendCarList(player)
        CallRemoteEvent(player, "getCarList", CarPriceTable)
end
AddRemoteEvent("sendCarList", sendCarList)

function GetCarDealearByObject(cardealerobject)
	for _,v in pairs(CarDealerTable) do
		if v.object == cardealerobject then
			return v
		end
	end
	return nil
end


