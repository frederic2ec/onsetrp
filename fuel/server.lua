local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local gas_station = {
    location = {
        { 127810,   78431,  1568 },
        { 127446,   78415,  1568 },
        { 127048,   78430,  1568 },
        { 126678,   78404,  1568 },
        { 126246,   78420,  1568 },
        { 125904,   78406,  1568 },
        { -17171,   -2172,  2062 },
        { -16814,   -3187,  2062 },
        { -17155,   -3305,  2062 },
        { -17526,   -2315,  2062 },
        { -17804,   -2415,  2062 },
        { -17447,   -3387,  2062 },
        { -17753,   -3526,  2062 },
        { -18106,   -2502,  2062 },
        { -167866,  -37112, 1146 },
        { -168188,  -37103, 1146 },
        { -168693,  -37095, 1146 },
        { -169015,  -37088, 1146 },
        { 170659,   207324, 1411 },
        { 170105,   207314, 1410 },
        { 170630,   206760, 1411 },
        { 170107,   206783, 1410 },
        { 170099,   206107, 1410 },
        { 170647,   206097, 1411 },
        { 170623,   205561, 1411 },
        { 170100,   205587, 1411 },
        { 42526,    137156, 1569 },
        { 42966,    137150, 1569 },
        { 42524,    136717, 1569 },
        { 42949,    136744, 1569 }
    },
    pickup = {}
}

local gasPrices = {
    gasoil = "1",
    gasoilplus = "2"
}

GasStationCached = {}

AddEvent("OnPackageStart", function()
    for i,j in pairs(gas_station.location) do
        gas_station.pickup[i] = CreatePickup(2 , gas_station.location[i][1], gas_station.location[i][2], gas_station.location[i][3])
        CreateText3D( _("refuel").."\n".._("press_e"), 18, gas_station.location[i][1], gas_station.location[i][2], gas_station.location[i][3] + 120, 0, 0, 0)
        table.insert(GasStationCached, gas_station.pickup[i])
    end

    CreateTimer(function()
        for k,v in pairs(GetAllVehicles()) do
            enginestate = GetVehicleEngineState(k)
            if enginestate then
                if VehicleData[k] == nil then
                    return
                end
                if VehicleData[k].fuel ~= 0 then
                    VehicleData[k].fuel = VehicleData[k].fuel - 1
                end
                if VehicleData[k].fuel == 0 then
                    StopVehicleEngine(k)
                    VehicleData[k].fuel = 0
                end
                SetVehiclePropertyValue(k, "fuel", VehicleData[k].fuel, true)
            end
        end
    end, 15000)
end)

AddEvent("OnPlayerJoin", function(player)
    CallRemoteEvent(player, "gasStationSetup", GasStationCached)
end)

AddEvent("OnPlayerEnterVehicle", function( player, vehicle, seat )
    if VehicleData[vehicle] == nil then
        return
    end
    if seat == 1 then
        SetVehiclePropertyValue(vehicle, "fuel", VehicleData[vehicle].fuel, true)
        if VehicleData[vehicle].fuel == 0 then
            StopVehicleEngine(vehicle)
        end
    end
end)

AddEvent("OnPlayerLeaveVehicle", function( player, vehicle, seat)
    if seat == 1 then
        StopVehicleEngine(vehicle)
    end
end)

AddRemoteEvent("StartRefuel", function(player, vehicle)
    if GetPlayerState(player) >= 2 then
        CallRemoteEvent(player, "MakeSuccessNotification", _("cant_while_driving"))
    else
        local cash = PlayerData[player].inventory['cash'] or 0
        local fuel = VehicleData[vehicle].fuel or 100
    
        CallRemoteEvent(player, "OpenUIGasStation", cash, 100, fuel, gasPrices.gasoil, gasPrices.gasoilplus)
    end
end)

AddRemoteEvent("PayGasStation", function(player, count, fuel, vehicle)
    price = count * tonumber(gasPrices[fuel])

    print(count)
    print(price)

    local resultPay = RemovePlayerCash(player, price)
    if resultPay then
        VehicleData[vehicle].fuel = VehicleData[vehicle].fuel + count
        if VehicleData[vehicle].fuel > 100 then VehicleData[vehicle].fuel = 100 end
        
        CallRemoteEvent(player, "UpdateGasStation", PlayerData[player].inventory['cash'], 100, VehicleData[vehicle].fuel)

        SetVehiclePropertyValue(vehicle, "fuel", VehicleData[vehicle].fuel, true)
    else
        CallRemoteEvent(player, "MakeNotification", _("not_enought_cash"), "linear-gradient(to right, #ff5f6d, #ffc371)")
    end
end)
