CarDealerObjectsCached = { }
CarDealerTable = { 
	{
		location = { 128990, 80774, 1567, 180 },
		spawn = { 127720, 80774, 1567, 180 }
	}
}
CarPriceTable = { 
	{
		modelid = 1,
		name = "Sedan 1",
		price = 1000
	},
	{
		modelid = 4,
		name = "Sedan 2",
		price = 1000
	},
	{
		modelid = 5,
		name = "Sedan 3",
		price = 1000
	},
	{
		modelid = 6,
		name = "Nascar",
		price = 1000
	},
	{
		modelid = 7,
		name = "Truck",
		price = 1000
	},
	{
		modelid = 11,
		name = "Coupe",
		price = 1000
	},
	{
		modelid = 12,
		name = "Rally",
		price = 1000
	}
}

AddEvent("OnPackageStart", function()
	for k,v in pairs(CarDealerTable) do
		v.npc = CreateNPC(v.location[1], v.location[2], v.location[3], v.location[4])
		CreateText3D("Car Dealer\nPress E", 18, v.location[1], v.location[2], v.location[3] + 120, 0, 0, 0)

		table.insert(CarDealerObjectsCached, v.npc)
	end
end)

AddEvent("OnPlayerJoin", function(player)
    CallRemoteEvent(player, "carDealerSetup", CarDealerObjectsCached)
end)

AddRemoteEvent("carDealerInteract", function(player, cardealerobject)
    local cardealer = GetCarDealearByObject(cardealerobject)
	if cardealer then
		local x, y, z = GetNPCLocation(cardealer.npc)
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
	for k,v in pairs(CarDealerTable) do
		if v.npc == cardealerobject then
			return v
		end
	end
	return nil
end


