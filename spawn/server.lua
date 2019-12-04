local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

spawnLocation = {
    town = { -182821, -41675, 1160 },
    gas_station = { 125773, 80246, 1645 },
    desert_town = { -16223, -8033, 2062 },
    old_town = { 39350, 138061, 1570 }
}

AddRemoteEvent("ServerSpawnMenu", function(player)
    local house = getHouseOwner(player)

    local hasHouse = false
    if house ~= 0 then
        if houses[house].spawnable == 1 then
            hasHouse = true
        end
    end

    CallRemoteEvent(player, "OpenSpawnMenu", spawnLocation, hasHouse)
end)

AddRemoteEvent("PlayerSpawn", function(player, spawn)
    if spawn == "house" then
        local house = getHouseOwner(player)

        if house ~= 0 then
            if houses[house].spawnable == 1 then
                SetPlayerLocation(player, houses[house].spawn[1], houses[house].spawn[2], houses[house].spawn[3] + 100)
                SetPlayerHeading( player, houses[house].spawn[4] )
            end
        end
    else
        spawnSelect = GetSpawnLocation(spawn)
        SetPlayerLocation(player, spawnSelect[1], spawnSelect[2], spawnSelect[3])
    end
end)

function GetSpawnLocation(spawn)
    for k,v in pairs(spawnLocation) do
        if k == spawn then
            return v
        end
    end
end