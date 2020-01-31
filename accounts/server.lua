local _ = function(k, ...) return ImportPackage("i18n").t(GetPackageName(), k, ...) end
PlayerData = {}

function OnPackageStart()
    -- Save all player data automatically
    CreateTimer(function()
        for k, v in pairs(GetAllPlayers()) do
            SavePlayerAccount(v)
        end
    end, 30000)
end
AddEvent("OnPackageStart", OnPackageStart)

AddEvent("OnPackageStop", function()
    for k, v in pairs(GetAllPlayers()) do
        SavePlayerAccount(v)
    end
    print("All accounts have been saved !")
end)


function OnPlayerSteamAuth(player)
    
    CreatePlayerData(player)
    PlayerData[player].steamname = GetPlayerName(player)
    
    -- First check if there is an account for this player
    local query = mariadb_prepare(sql, "SELECT id FROM accounts WHERE steamid = '?' LIMIT 1;",
        tostring(GetPlayerSteamId(player)))
    
    mariadb_async_query(sql, query, OnAccountLoadId, player)
end
AddEvent("OnPlayerSteamAuth", OnPlayerSteamAuth)

function OnPlayerQuit(player)
    SavePlayerAccount(player)
    GatheringCleanPlayerActions(player)-- → Gathering
    DestroyPlayerData(player)
end
AddEvent("OnPlayerQuit", OnPlayerQuit)

function OnAccountLoadId(player)
    if (mariadb_get_row_count() == 0) then
        --There is no account for this player, continue by checking if their IP was banned
        local query = mariadb_prepare(sql, "SELECT FROM_UNIXTIME(bans.ban_time), bans.reason FROM bans WHERE bans.steamid = ?;",
            tostring(GetPlayerSteamId(player)))
        
        mariadb_async_query(sql, query, OnAccountCheckBan, player)
    else
        --There is an account for this player, continue by checking if it's banned
        PlayerData[player].accountid = mariadb_get_value_index(1, 1)
        
        local query = mariadb_prepare(sql, "SELECT FROM_UNIXTIME(bans.ban_time), bans.reason FROM bans WHERE bans.steamid = ?;",
            tostring(GetPlayerSteamId(player)))
        
        mariadb_async_query(sql, query, OnAccountCheckBan, player)
    end
end

function OnAccountCheckBan(player)
    if (mariadb_get_row_count() == 0) then
        --No ban found for this account
        CheckForIPBan(player)
    else
        --There is a ban in the database for this account
        local result = mariadb_get_assoc(1)
        
        print("Kicking " .. GetPlayerName(player) .. " because their account was banned")
        
        KickPlayer(player, _("banned_for", result['reason'], result['FROM_UNIXTIME(bans.ban_time)']))
    end
end

function CheckForIPBan(player)
    local query = mariadb_prepare(sql, "SELECT ipbans.reason FROM ipbans WHERE ipbans.ip = '?' LIMIT 1;",
        GetPlayerIP(player))
    
    mariadb_async_query(sql, query, OnAccountCheckIpBan, player)
end

function OnAccountCheckIpBan(player)
    if (mariadb_get_row_count() == 0) then
        --No IP ban found for this account
        if (PlayerData[player].accountid == 0) then
            CreatePlayerAccount(player)
        else
            LoadPlayerAccount(player)
        end
    else
        print("Kicking " .. GetPlayerName(player) .. " because their IP was banned")
        
        local result = mariadb_get_assoc(1)
        
        KickPlayer(player, "🚨 You have been banned from the server.")
    end
end

function CreatePlayerAccount(player)
    local query = mariadb_prepare(sql, "INSERT INTO accounts (id, steamid, clothing, death_pos, inventory, position, drug_knowledge) VALUES (NULL, '?', '[]' , '[]' , '[]' , '[]', '[]');",
        tostring(GetPlayerSteamId(player)))
    
    mariadb_query(sql, query, OnAccountCreated, player)
end

function OnAccountCreated(player)
    PlayerData[player].accountid = mariadb_get_insert_id()
    
    CallRemoteEvent(player, "askClientCreation")
    
    SetPlayerLoggedIn(player)
    SetAvailablePhoneNumber(player)
    setPositionAndSpawn(player, nil)
    
    print("Account ID " .. PlayerData[player].accountid .. " created for " .. player)
end

function LoadPlayerAccount(player)
    local query = mariadb_prepare(sql, "SELECT * FROM accounts WHERE id = ?;",
        PlayerData[player].accountid)
    
    mariadb_async_query(sql, query, OnAccountLoaded, player)
end

function LoadPlayerPhoneContacts(player)
    local query = mariadb_prepare(sql, "SELECT * FROM phone_contacts WHERE phone_contacts.owner_id = ? ORDER BY phone_contacts.name;", PlayerData[player].accountid)
    
    mariadb_async_query(sql, query, OnPhoneContactsLoaded, player)
end

function OnAccountLoaded(player)
    if (mariadb_get_row_count() == 0) then
        --This case should not happen but still handle it
        KickPlayer(player, "An error occured while loading your account 😨")
    else
        local result = mariadb_get_assoc(1)
        PlayerData[player].admin = math.tointeger(result['admin'])
        PlayerData[player].bank_balance = math.tointeger(result['bank_balance'])
        PlayerData[player].name = tostring(result['name'])
        PlayerData[player].clothing = json_decode(result['clothing'])
        PlayerData[player].police = math.tointeger(result['police'])
        PlayerData[player].medic = math.tointeger(result['medic'])
        PlayerData[player].driver_license = math.tointeger(result['driver_license'])
        PlayerData[player].gun_license = math.tointeger(result['gun_license'])
        PlayerData[player].helicopter_license = math.tointeger(result['helicopter_license'])
        PlayerData[player].inventory = json_decode(result['inventory'])
        PlayerData[player].created = math.tointeger(result['created'])
        PlayerData[player].position = json_decode(result['position'])
        PlayerData[player].drug_knowledge = json_decode(result['drug_knowledge'])
        PlayerData[player].job = result['job']
        PlayerData[player].is_cuffed = math.tointeger(result['is_cuffed'])
        PlayerData[player].health = math.tointeger(result['health'])
        
        if result['phone_number'] and result['phone_number'] ~= "" then
            PlayerData[player].phone_number = tostring(result['phone_number'])
        else
            SetAvailablePhoneNumber(player)
        end
        
        SetPlayerArmor(player, tonumber(result['armor']))
        setPlayerThirst(player, tonumber(result['thirst']))
        setPlayerHunger(player, tonumber(result['hunger']))
        setPositionAndSpawn(player, PlayerData[player].position)
        
        SetPlayerLoggedIn(player)

        CallEvent("job:onspawn", player)-- Trigger the loading of jobs when player is fully loaded (have to be set up for each jobs)

        if PlayerData[player].created == 0 then
            CallRemoteEvent(player, "askClientCreation")
        else
            SetPlayerName(player, string.sub(PlayerData[player].name, 1, 1).."_____") -- hide name
            -- playerhairscolor = getHairsColor(PlayerData[player].clothing[2])
            -- CallRemoteEvent(player, "ClientChangeClothing", player, 0, PlayerData[player].clothing[1], playerhairscolor[1], playerhairscolor[2], playerhairscolor[3], playerhairscolor[4])
            -- CallRemoteEvent(player, "ClientChangeClothing", player, 1, PlayerData[player].clothing[3], 0, 0, 0, 0)
            -- CallRemoteEvent(player, "ClientChangeClothing", player, 4, PlayerData[player].clothing[4], 0, 0, 0, 0)
            -- CallRemoteEvent(player, "ClientChangeClothing", player, 5, PlayerData[player].clothing[5], 0, 0, 0, 0)
            UpdateClothes(player)
            DisplayPlayerBackpack(player)
        -- CallRemoteEvent(player, "AskSpawnMenu")
        end
        LoadPlayerPhoneContacts(player)
        print("Account ID " .. PlayerData[player].accountid .. " loaded for " .. GetPlayerIP(player))
    end
end

function setPositionAndSpawn(player, position)
    if position ~= nil and position.x ~= nil and position.y ~= nil and position.z ~= nil then
        SetPlayerLocation(player, PlayerData[player].position.x, PlayerData[player].position.y, PlayerData[player].position.z + 250)-- Pour empêcher de se retrouver sous la map
    else
        SetPlayerLocation(player, 227603, -65590, 400)
    end
end

function SetAvailablePhoneNumber(player)
    -- Generate a random phone number
    local phone_number = "555" .. tostring(math.random(100000, 999999))
    
    local query = mariadb_prepare(sql, "SELECT id FROM accounts WHERE phone_number = ?;",
        phone_number)
    
    mariadb_async_query(sql, query, OnPhoneNumberChecked, player, phone_number)
end

function OnPhoneNumberChecked(player, phone_number)
    if (mariadb_get_row_count() == 0) then
        -- If phone number is available
        local query = mariadb_prepare(sql, "UPDATE accounts SET phone_number = ? WHERE id = ?", phone_number, PlayerData[player].accountid)
        
        PlayerData[player].phone_number = phone_number
        
        mariadb_async_query(sql, query)
    else
        -- Retry with a new phone number if the generated one is already allowed to another account
        GetAvailablePhoneNumber(player)
    end
end

function OnPhoneContactsLoaded(player)
    for i = 1, mariadb_get_row_count() do
        local contact = mariadb_get_assoc(i)
        if contact['id'] then
            PlayerData[player].phone_contacts[i] = {id = tostring(contact['id']), name = contact['name'], phone = contact['phone']}
        end
    end
    
    print("Phone contacts loaded for " .. PlayerData[player].accountid)
end

function CreatePlayerData(player)
    PlayerData[player] = {}
    
    PlayerData[player].accountid = 0
    PlayerData[player].name = ""
    PlayerData[player].clothing = {}
    PlayerData[player].police = 0
    PlayerData[player].medic = 0
    PlayerData[player].inventory = {cash = 100}
    PlayerData[player].driver_license = 0
    PlayerData[player].gun_license = 0
    PlayerData[player].helicopter_license = 0
    PlayerData[player].logged_in = false
    PlayerData[player].admin = 0
    PlayerData[player].created = 0
    PlayerData[player].steamid = GetPlayerSteamId(player)
    PlayerData[player].steamname = ""
    PlayerData[player].thirst = 100
    PlayerData[player].hunger = 100
    PlayerData[player].health = 100
    PlayerData[player].bank_balance = 900
    PlayerData[player].job_vehicle = nil
    PlayerData[player].job = ""
    PlayerData[player].phone_contacts = {}
    PlayerData[player].phone_number = {}
    PlayerData[player].position = {}
    PlayerData[player].backpack = nil
    PlayerData[player].drug_knowledge = {}
    PlayerData[player].is_cuffed = 0
    
    print("Data created for : " .. player)
end

function DestroyPlayerData(player)
    if (PlayerData[player] == nil) then
        return
    end
    
    if PlayerData[player].job_vehicle ~= nil then
        DestroyVehicle(PlayerData[player].job_vehicle)
        DestroyVehicleData(PlayerData[player].job_vehicle)
        PlayerData[player].job_vehicle = nil
    end
    
    if PlayerData[player].backpack ~= nil then
        DestroyObject(PlayerData[player].backpack)
        PlayerData[player].backpack = nil
    end
    
    PlayerData[player] = nil
    print("Data destroyed for : " .. player)
end

function SavePlayerAccount(player)
    if (PlayerData[player] == nil) then
        return
    end
    
    if (PlayerData[player].accountid == 0 or PlayerData[player].logged_in == false) then
        return
    end
    
    
    PlayerData[player].health = GetPlayerHealth(player)
    
    -- Sauvegarde de la position du joueur
    local x, y, z = GetPlayerLocation(player)
    PlayerData[player].position = {x = x, y = y, z = z}
    
    local query = mariadb_prepare(sql, "UPDATE accounts SET admin = ?, bank_balance = ?, health = ?, armor = ?, hunger = ?, thirst = ?, name = '?', clothing = '?', inventory = '?', created = '?', position = '?', driver_license = ?, gun_license = ?, helicopter_license = ?, drug_knowledge = '?', job = '?', is_cuffed = ? WHERE id = ? LIMIT 1;",
        PlayerData[player].admin,
        PlayerData[player].bank_balance,
        PlayerData[player].health,
        GetPlayerArmor(player),
        PlayerData[player].hunger,
        PlayerData[player].thirst,
        PlayerData[player].name,
        json_encode(PlayerData[player].clothing),
        json_encode(PlayerData[player].inventory),
        PlayerData[player].created,
        json_encode(PlayerData[player].position),
        PlayerData[player].driver_license,
        PlayerData[player].gun_license,
        PlayerData[player].helicopter_license,
        json_encode(PlayerData[player].drug_knowledge),
        PlayerData[player].job,
        PlayerData[player].is_cuffed or 0,
        PlayerData[player].accountid
    )
    mariadb_query(sql, query)
end

function SetPlayerLoggedIn(player)
    PlayerData[player].logged_in = true
end

function IsAdmin(player)
    return PlayerData[player].admin
end

function SetPlayerBusy(player)-- Shortcut to set a player in a busy state
    local result = SetPlayerPropertyValue(player, "PlayerIsBusy", true, true)
    return result
end
AddRemoteEvent("account:setplayerbusy", SetPlayerBusy)-- To do it clientside

function SetPlayerNotBusy(player)-- Shortcut to set a player in a not busy state
    local result = SetPlayerPropertyValue(player, "PlayerIsBusy", false, true)
    return result
end
AddRemoteEvent("account:setplayernotbusy", SetPlayerNotBusy)-- To do it clientside

function GetPlayerBusy(player)-- Shortcut to get the busy state of the player
    local result = GetPlayerPropertyValue(player, "PlayerIsBusy") or false
    return result
end

-- Exports
AddFunctionExport("isAdmin", IsAdmin)
AddFunctionExport("SetPlayerBusy", SetPlayerBusy)
AddFunctionExport("SetPlayerNotBusy", SetPlayerNotBusy)
AddFunctionExport("GetPlayerBusy", GetPlayerBusy)


-- TO REMOVE
function GetPlayerData(player)
    return PlayerData[player]
end
AddFunctionExport("GetPlayerData", GetPlayerData)
