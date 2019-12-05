local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local gas_station = {
    location = {
        { 127810, 78431, 1568 },
        { 127446, 78415, 1568 },
        { 127048, 78430, 1568 },
        { 126678, 78404, 1568 },
        { 126246, 78420, 1568 },
        { 125904, 78406, 1568 },
        { -17171, -2172, 2062 },
        { -16814, -3187, 2062 },
        { -17155, -3305, 2062 },
        { -17526, -2315, 2062 },
        { -17804, -2415, 2062 },
        { -17447, -3387, 2062 },
        { -17753, -3526, 2062 },
        { -18106, -2502, 2062 },
        { -167866, -37112, 1146 },
        { -168188, -37103, 1146 },
        { -168693, -37095, 1146 },
        { -169015, -37088, 1146 }
    },
    pickup = {}
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
            if enginestate == true then
                if VehicleData[k] == nil then
                    return
                end
                VehicleData[k].fuel = VehicleData[k].fuel - 1
                if VehicleData[k].fuel == 0 then
                    StopVehicleEngine(k)
                    VehicleData[k].fuel = 0
                end
            end
        end
    end, 15000)
end)

AddEvent("OnPlayerJoin", function(player)
    CallRemoteEvent(player, "gasStationSetup", GasStationCached)
end)

AddEvent("OnPlayerEnterVehicle", function( player, vehicle, seat )
    if seat == 1 then
        if VehicleData[vehicle].fuel == 0 then
            StopVehicleEngine(vehicle)
        end
    end
end)

AddEvent("OnPlayerLeaveVehicle", function( player, vehicle)
    StopVehicleEngine(vehicle)
end)


AddRemoteEvent("StartRefuel", function(player, vehicle) 
    price = math.ceil((100 - VehicleData[vehicle].fuel) * 0.5)

    if GetPlayerVehicle(player) ~= 0 then
        AddPlayerChat(player, _("cant_refuel"))
    else
        if VehicleData[vehicle].fuel >= 100 then
            AddPlayerChat(player,  _("car_full"))
        else
            if PlayerData[player].cash < price then
                AddPlayerChat(player, _("not_enought_cash") )
            else
                SetPlayerAnimation(player,"COMBINE")
                AddPlayerChat(player, _("car_refuelled_for", price, _("currency")))
                VehicleData[vehicle].fuel = 100
                PlayerData[player].cash = PlayerData[player].cash - price
            end
        end
    end
end)
