local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

spawnLocation = {
    -- The three last value are temporary until RandomFloat is fixed
    town = { 170402, 38013, 1180, "-", "-", "" },
    city = { 211526, 176056, 1450, "", "", "" },
    desert_town = { 16223, 8033, 2080, "-", "-", "" },
    old_town = { 39350, 138061, 1690, "", "", "" }
}

AddRemoteEvent("ServerSpawnMenu", function(player)
    if(PlayerData[player].job == "medic") then
	CallRemoteEvent(player, "UpdateMedicUniform", player)
    end
    if(PlayerData[player].health_state == "revived") then
	PlayerData[player].health_state = "alive"
	SetPlayerHealth(player, 50)
    elseif(PlayerData[player].health_state == "no_medic") then
	PlayerData[player].health_state = "alive"
	SetPlayerHealth(player, 100)
    else
	local house = getHouseOwner(player)

	local hasHouse = false
	if house ~= 0 then
	    if houses[house].spawnable == 1 then
		hasHouse = true
	    end
	end

	CallRemoteEvent(player, "OpenSpawnMenu", spawnLocation, hasHouse)
    end
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
        spawnx = RandomFloat(spawnSelect[1] - 500, spawnSelect[1] + 500)
        spawny = RandomFloat(spawnSelect[2] - 500, spawnSelect[2] + 500)
        SetPlayerLocation(player, spawnSelect[4]..spawnx, spawnSelect[5]..spawny, spawnSelect[6]..spawnSelect[3] + 200)
    end
end)

function GetSpawnLocation(spawn)
    for k,v in pairs(spawnLocation) do
        if k == spawn then
            return v
        end
    end
end
