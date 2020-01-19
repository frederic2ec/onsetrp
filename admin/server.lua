local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local teleportPlace = {
    gas_station = { 125773, 80246, 1645 },
    town = { -182821, -41675, 1160 },
    prison = { -167958, 78089, 1569 },
    diner = { 212405, 94489, 1340 },
    city = { 211526, 176056, 1250 },
    desert_town = { -16223, -8033, 2062 },
    old_town = { 39350, 138061, 1570 },
    gun_dealer = { 206071, 193057, 1357 },
    license_shop = { 183339, 182525, 1291 },
    police_station = { 169277, 193489, 1307 },
    mine = { -96159, 88621, 180 },
    circuit = { -81369, 31643, 4704 },
    airport = { 151187, -145085, 1250 },
    harbour = { 66726, 185960, 536 },
    western = { -80339, -157846, 3223 },
    mountain = { -190210, -1831, 7462 },
    training = { -13789, 136500, 1544 },
    peach_farm = {-174432, 10837, 1931},
    lumberjack_farm = {-107330, -95820, 5330},
}

local weaponList = {
    weapon_2 = 2,
    weapon_3 = 3,
    weapon_4 = 4,
    weapon_5 = 5,
    weapon_6 = 6,
    weapon_7 = 7,
    weapon_8 = 8,
    weapon_9 = 9,
    weapon_10 = 10,
    weapon_11 = 11,
    weapon_12 = 12,
    weapon_13 = 13,
    weapon_14 = 14,
    weapon_15 = 15,
    weapon_16 = 16,
    weapon_17 = 17,
    weapon_18 = 18,
    weapon_19 = 19,
    weapon_20 = 20,
}

local vehicleList = {
    vehicle_1 = 1,
    vehicle_2 = 2,
    vehicle_3 = 3,
    vehicle_4 = 4,
    vehicle_5 = 5,
    vehicle_6 = 6,
    vehicle_7 = 7,
    vehicle_8 = 8,
    vehicle_9 = 9,
    vehicle_10 = 10,
    vehicle_11 = 11,
    vehicle_12 = 12,
    vehicle_13 = 13,
    vehicle_14 = 14,
    vehicle_15 = 15,
    vehicle_16 = 16,
    vehicle_17 = 17,
    vehicle_18 = 18,
    vehicle_19 = 19,
    vehicle_20 = 20,
    vehicle_21 = 21,
    vehicle_22 = 22,
    vehicle_23 = 23,
    vehicle_24 = 24,
    vehicle_25 = 25
}

AddRemoteEvent("ServerAdminMenu", function(player)
    local playersIds = GetAllPlayers()

    if tonumber(PlayerData[player].admin) == 1 then
        playersNames = {}
        for k,v in pairs(playersIds) do
            if PlayerData[k] == nil then
                goto continue
            end
            if PlayerData[k].name == nil then
                goto continue
            end
            if PlayerData[k].steamname == nil then
                goto continue
            end
            playersNames[tostring(k)] = PlayerData[k].name.." ["..PlayerData[k].steamname.."]"
            ::continue::
        end
        local query = mariadb_prepare(sql, "SELECT * FROM logs ORDER BY id DESC LIMIT 50;")
    
        mariadb_async_query(sql, query, OnLogListLoadd, player, playersNames)
    end
end)

function OnLogListLoadd(player, playersName)
    local logList = {}
    for i=1,mariadb_get_row_count() do
        local result = mariadb_get_assoc(i)

        local id = tostring(result["id"])
        local action = result["action"]
        logList[tostring(id)] = action
    end
    CallRemoteEvent(player, "OpenAdminMenu", teleportPlace, playersNames, weaponList, vehicleList, logList)

end


AddRemoteEvent("AdminTeleportToPlace", function(player, place)
    if tonumber(PlayerData[player].admin) ~= 1 then return end

    for k,v in pairs(teleportPlace) do
        if k == place then
            SetPlayerLocation(player, v[1], v[2], v[3] + 200)
        end
    end
end)

AddRemoteEvent("AdminTeleportToPlayer", function(player, toPlayer)
    if tonumber(PlayerData[player].admin) ~= 1 then return end
    local x, y, z  = GetPlayerLocation(tonumber(toPlayer))
    SetPlayerLocation(player, x, y, z + 200)
end)

AddRemoteEvent("AdminTeleportPlayer", function(toPlayer, player)
    if tonumber(PlayerData[toPlayer].admin) ~= 1 then return end
    local x, y, z  = GetPlayerLocation(tonumber(toPlayer))
    SetPlayerLocation(player, x, y, z + 200)
end)

AddRemoteEvent("AdminGiveWeapon", function(player, weaponName)
    if tonumber(PlayerData[player].admin) ~= 1 then return end
    weapon = weaponName:gsub("weapon_", "")
    SetPlayerWeapon(player, tonumber(weapon), 1000, true, 1, true)
end)

AddRemoteEvent("AdminSpawnVehicle", function(player, vehicleName)
    if tonumber(PlayerData[player].admin) ~= 1 then return end
    vehicle = vehicleName:gsub("vehicle_", "")

    local x, y, z = GetPlayerLocation(player)
    local h = GetPlayerHeading(player)

    spawnedVehicle = CreateVehicle(tonumber(vehicle), x, y, z, h)

    SetVehicleRespawnParams(spawnedVehicle, false)
    SetPlayerInVehicle(player, spawnedVehicle)
end)

AddRemoteEvent("AdminGiveMoney", function(player, toPlayer, account, amount)
    if tonumber(PlayerData[player].admin) ~= 1 then return end
    if account == "Cash" then
        AddPlayerCash(tonumber(toPlayer), amount)
    end
    if account == "Bank" then
        PlayerData[tonumber(toPlayer)].bank_balance = PlayerData[tonumber(toPlayer)].bank_balance + tonumber(amount)
    end
end)

AddRemoteEvent("AdminKickBan", function(player, toPlayer, type, reason)
    if tonumber(PlayerData[player].admin) ~= 1 then return end
    if type == "Ban" then
        mariadb_query(sql, "INSERT INTO `bans` (`steamid`, `ban_time`, `reason`) VALUES ('"..PlayerData[tonumber(toPlayer)].steamid.."', '"..os.time(os.date('*t')).."', '"..reason.."');")

        KickPlayer(tonumber(toPlayer), _("banned_for", reason, os.date('%Y-%m-%d %H:%M:%S', os.time())))
    end
    if type == "Kick" then
        KickPlayer(tonumber(toPlayer), _("kicked_for", reason))
    end
end)

AddCommand("delveh", function(player)
    if tonumber(PlayerData[player].admin) ~= 1 then return end
    local vehicle = GetPlayerVehicle(player)

    if vehicle ~= nil then
        DestroyVehicle( vehicle )
    end
end)

AddEvent("OnPlayerDeath", function(player, instigator)
    message = GetPlayerName(player) .. " was killed by " .. GetPlayerName(instigator)
    local query = mariadb_prepare(sql, "INSERT INTO logs VALUES (NULL, NULL, '?');",
		message)

	mariadb_async_query(sql, query)
end)

AddEvent("OnPlayerDamage", function(player, damagetype, amount)
    local DamageName = {
		"Weapon",
		"Explosion",
		"Fire",
		"Fall",
		"Vehicle Collision"
	}

    message = GetPlayerName(player).."("..player..") took "..amount.." damage of type "..DamageName[damagetype]
    local query = mariadb_prepare(sql, "INSERT INTO logs VALUES (NULL, NULL, '?');",
    message)

    mariadb_async_query(sql, query)
end)

AddEvent("OnPlayerWeaponShot", function(player, weapon, hittype, hitid, hitX, hitY, hitZ, startX, startY, startY, normalX, normalY, normalZ)
	local action = {
		"in the air",
		"at player",
		"at vehicle",
		"an NPC",
		"at object",
		"on ground",
		"in water"
	}
	
	message = GetPlayerName(player).."("..player..") shot "..action[hittype].." (ID "..hitid..") using weapon ("..weapon..")"
	
	local query = mariadb_prepare(sql, "INSERT INTO logs VALUES (NULL, NULL, '?');",
    message)

    mariadb_async_query(sql, query) 
end)