local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

CarDealerObjectsCached = { }

CarDefaultColors = {
	black = "0000",
	red = "FF0000",
	blue = "0000FF",
	green = "00FF00",
	orange = "971900",
	vert_bambou = "001F09",
	marron = "391c00",
	bleu_galaxie = "010026",
	rouge_bordeau = "1f0000",
	rose = "ff15b5",
	jaune = "c9be00",
	turquoise = "00a47c",
	blanc = "ffffff",
	gris_clair = "787878",
	gris_fonce = "262626",
	gris_titanium = "0b0f14",
	violet_fonce = "140019"
}

CarDefaultVehicles = {
	vehicle_25 = 2000,
	vehicle_1 = 6000,
	vehicle_19 = 6000,
	vehicle_5 = 9000,
	vehicle_4 = 12000,
	vehicle_7 = 30000,
	vehicle_11 = 40000,
	vehicle_12 = 50000,
	vehicle_22 = 45000,
	vehicle_23 = 45000,
	vehicle_17 = 60000,
	vehicle_18 = 60000,
	vehicle_6 = 70000,
}

CarDealerTable = {
    {
		vehicles = CarDefaultVehicles,
		colors = CarDefaultColors,
		location = { 162911, 191166, 1380, 180 },
		spawn = { 162518, 189841, 1347, -90 }
    },
    {
		vehicles = CarDefaultVehicles,
		colors = CarDefaultColors,
		location = { -188591, -50391, 1150, 180 },
		spawn = { -188315, -51413, 1150, 180 }
	},
    {
		vehicles = CarDefaultVehicles,
		colors = CarDefaultColors,
		location = { -24737, -18052, 2087, -150 },
		spawn = { -25060, -18800, 2062, -150 }
	}
}

AddEvent("OnPackageStart", function()
	for k,v in pairs(CarDealerTable) do
		v.npc = CreateNPC(v.location[1], v.location[2], v.location[3], v.location[4])
		CreateText3D(_("car_dealer").."\n".._("press_e"), 18, v.location[1], v.location[2], v.location[3] + 120, 0, 0, 0)

		table.insert(CarDealerObjectsCached, v.npc)
	end
end)

AddEvent("OnPlayerJoin", function(player)
    CallRemoteEvent(player, "carDealerSetup", CarDealerObjectsCached)
end)

AddRemoteEvent("carDealerInteract", function(player, cardealerobject)
	if PlayerData[player].driver_license == 1 then
		local cardealer = GetCarDealearByObject(cardealerobject)
		
		if cardealer then
			local x, y, z = GetNPCLocation(cardealer.npc)
			local x2, y2, z2 = GetPlayerLocation(player)
			local dist = GetDistance3D(x, y, z, x2, y2, z2)
	
			if dist < 250 then
				for k,v in pairs(CarDealerTable) do
					if cardealerobject == v.npc then
						CallRemoteEvent(player, "openCarDealer", v.vehicles, v.colors)
					end
				end
	
			end
		end
	else
        CallRemoteEvent(player, "MakeErrorNotification",_("no_driver_license"))
	end
end)

function GetCarDealearByObject(cardealerobject)
	for k,v in pairs(CarDealerTable) do
		if v.npc == cardealerobject then
			return v
		end
	end
	return nil
end

function CreateVehicleDatabase(player, vehicle, modelid, color, price, licensePlate)
    local query = mariadb_prepare(sql, "INSERT INTO player_garage (id, ownerid, modelid, color, garage, price, license_plate) VALUES (NULL, '?', '?', '?', '0', '?', '?');",
        tostring(PlayerData[player].accountid),
        tostring(modelid),
        tostring(color),
		tostring(price),
		tostring(licensePlate)
    )

    mariadb_async_query(sql, query, onVehicleCreateDatabase, vehicle)
end

function onVehicleCreateDatabase(vehicle)
    VehicleData[vehicle].garageid = mariadb_get_insert_id()
end

function buyCarServer(player, modelid, color, cardealerobject)
	local name = _(modelid)
	local price = getVehiclePrice(modelid, cardealerobject)
	local color = getVehicleColor(color, cardealerobject)
	local modelid = getVehicleId(modelid)
	local licensePlate = genLicensePlate()

	if price == nil or tonumber(price) > GetPlayerCash(player) then
        CallRemoteEvent(player, "MakeErrorNotification",_("no_money_car"))
    else
        local x, y, z = GetPlayerLocation(player)

        for k,v in pairs(CarDealerTable) do
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
					SetVehicleLicensePlate(vehicle, licensePlate)
                    SetVehicleRespawnParams(vehicle, false)
                    SetVehicleColor(vehicle, "0x"..color)
                    SetVehiclePropertyValue(vehicle, "locked", true, true)
                    CreateVehicleData(player, vehicle, modelid)
                    CreateVehicleDatabase(player, vehicle, modelid, color, price, licensePlate)
                    RemovePlayerCash(player, price)
                    CallRemoteEvent(player, "closeCarDealer")
                    return CallRemoteEvent(player, "MakeSuccessNotification", _("car_buy_sucess", name, price, _("currency")))
                else
                    return CallRemoteEvent(player, "MakeErrorNotification", _("cannot_spawn_vehicle"))
                end
            end
        end
    end
end
AddRemoteEvent("buyCarServer", buyCarServer)

function genLicensePlate() 
	local plate = ""

	math.randomseed(os.time()) -- Random seed
	-- FIRST 2 LETTERS
	plate = plate .. genPlateRandomLetter(2) .. "-"
	-- 3 MIDDLE NUMBERS
	plate = plate .. genPlateRandomNumber(3) .. "-"
	-- LAST 2 LETTERS
	plate = plate .. genPlateRandomLetter(2)
	return plate	
end

function genPlateRandomLetter(nb)
	if nb == nil then nb = 1 end
	local value = ""
	for i = 1 , nb do
		local rand = string.char(math.random(65,90))
    	value = value .."".. rand
	end	
	return value
end

function genPlateRandomNumber(nb)
	if nb == nil then nb = 1 end
	local value = ""
	for i = 1, nb do
		local rand = tostring(math.random(0,9))
    	value = value .. "" .. rand
	end	
	return value
end