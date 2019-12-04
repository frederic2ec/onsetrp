local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

spawnLocation = {
    town = { -182821, -41675, 1160 },
    gas_station = { 125773, 80246, 1645 },
    desert_town = { -16223, -8033, 2062 },
    old_town = { 39350, 138061, 1570 }
}

AddRemoteEvent("ServerSpawnMenu", function(player)
    CallRemoteEvent(player, "OpenSpawnMenu", spawnLocation)
end)

AddRemoteEvent("PlayerSpawn", function(player, spawn)
    spawnSelect = GetSpawnLocation(spawn)
    SetPlayerLocation(player, spawnSelect[1], spawnSelect[2], spawnSelect[3])
end)

function GetSpawnLocation(spawn)
    for k,v in pairs(spawnLocation) do
        if k == spawn then
            return v
        end
    end
end