
PlayerData = {}

function OnPackageStart()
    -- Save all player data automatically 
    CreateTimer(function()
		for _, v in pairs(GetAllPlayers()) do
            SavePlayerAccount(v)
            print("All accounts have been saved !")
		end
    end, 30000)
end
AddEvent("OnPackageStart", OnPackageStart)

function OnPlayerSteamAuth(player)

    CreatePlayerData(player)
    
    AddPlayerChatAll('<span color="#eeeeeeaa">'..GetPlayerName(player)..' from '..PlayerData[player].locale..' joined the server</>')
    AddPlayerChatAll('<span color="#eeeeeeaa">There are '..GetPlayerCount()..' players on the server</>')
    
    -- First check if there is an account for this player
	local query = mariadb_prepare(sql, "SELECT id FROM accounts WHERE steamid = '?' LIMIT 1;",
    tostring(GetPlayerSteamId(player)))

    mariadb_async_query(sql, query, OnAccountLoadId, player)
end
AddEvent("OnPlayerSteamAuth", OnPlayerSteamAuth)

function OnPlayerJoin(player)
	SetPlayerSpawnLocation(player, 125773.000000, 80246.000000, 1645.000000, -90.0)
end
AddEvent("OnPlayerJoin", OnPlayerJoin)

function OnPlayerQuit(player)
    SavePlayerAccount(player)

    DestroyPlayerData(player)
    print("Data destroyed for : "..player)
end
AddEvent("OnPlayerQuit", OnPlayerQuit)

function OnAccountLoadId(player)
	if (mariadb_get_row_count() == 0) then
		--There is no account for this player, continue by checking if their IP was banned		
        CheckForIPBan(player)
	else
		--There is an account for this player, continue by checking if it's banned
        PlayerData[player].accountid = mariadb_get_value_index(1, 1)

		local query = mariadb_prepare(sql, "SELECT FROM_UNIXTIME(bans.ban_time), bans.reason FROM bans WHERE bans.id = ?;",
			PlayerData[player].accountid)

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

		print("Kicking "..GetPlayerName(player).." because their account was banned")

		KickPlayer(player, "🚨 You have been banned from the server:\n\nReason: "..result['reason'].."\nTime: "..result['FROM_UNIXTIME(bans.ban_time)'])
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
		print("Kicking "..GetPlayerName(player).." because their IP was banned")

		local result = mariadb_get_assoc(1)
        
        KickPlayer(player, "🚨 You have been banned from the server.")
	end
end

function CreatePlayerAccount(player)
	local query = mariadb_prepare(sql, "INSERT INTO accounts (id, steamid) VALUES (NULL, '?');",
		tostring(GetPlayerSteamId(player)))

	mariadb_query(sql, query, OnAccountCreated, player)
end

function OnAccountCreated(player)
    PlayerData[player].accountid = mariadb_get_insert_id()

    SetPlayerLoggedIn(player)

	print("Account ID "..PlayerData[player].accountid.." created for "..player)

	AddPlayerChat(player, '<span color="#ffff00aa" style="bold italic" size="15">SERVER: Welcome to the community, '..GetPlayerName(player)..', have fun and play fair!</>')
	AddPlayerChatAll('<span color="00ee00ff">We now have'..PlayerData[player].accountid..' accounts registered</>')
end

function LoadPlayerAccount(player)
	local query = mariadb_prepare(sql, "SELECT * FROM accounts WHERE id = ?;",
		PlayerData[player].accountid)

	mariadb_async_query(sql, query, OnAccountLoaded, player)
end


function OnAccountLoaded(player)
	if (mariadb_get_row_count() == 0) then
		--This case should not happen but still handle it
		KickPlayer(player, "An error occured while loading your account 😨")
	else
		local result = mariadb_get_assoc(1)

		PlayerData[player].admin = math.tointeger(result['admin'])
		PlayerData[player].cash = math.tointeger(result['cash'])
        PlayerData[player].bank_balance = math.tointeger(result['bank_balance'])
        
		SetPlayerHealth(player, tonumber(result['health']))
		SetPlayerArmor(player, tonumber(result['armor']))
        setPlayerThirst(player, tonumber(result['thirst']))
        setPlayerHunger(player, tonumber(result['hunger']))

        SetPlayerLoggedIn(player)

		AddPlayerChat(player, '<span color="#ffff00aa" style="bold italic" size="17">SERVER: Welcome back '..GetPlayerName(player)..', have fun!</>')

		print("Account ID "..PlayerData[player].accountid.." loaded for "..GetPlayerIP(player))
	end
end

function CreatePlayerData(player)
	PlayerData[player] = {}

    PlayerData[player].accountid = 0
    PlayerData[player].logged_in = false
    PlayerData[player].admin = 0
    PlayerData[player].locale = GetPlayerLocale(player)
    PlayerData[player].thirst = 100
    PlayerData[player].hunger = 100
    PlayerData[player].cash = 0
    PlayerData[player].bank_balance = 1000

    print("Data created for : "..player)
end

function DestroyPlayerData(player)
	if (PlayerData[player] ~= nil) then
		return
    end

    PlayerData[player] = nil
end

function SavePlayerAccount(player)
	if (PlayerData[player] == nil) then
		return
	end

	if (PlayerData[player].accountid == 0 or PlayerData[player].logged_in == false) then
		return
	end

	local query = mariadb_prepare(sql, "UPDATE accounts SET admin = ?, cash = ?, bank_balance = ?, health = ?, armor = ?, hunger = ?, thirst = ? WHERE id = ? LIMIT 1;",
		PlayerData[player].admin,
		PlayerData[player].cash,
		PlayerData[player].bank_balance,
		GetPlayerHealth(player),
        GetPlayerArmor(player),
        PlayerData[player].hunger,
        PlayerData[player].thirst,
        PlayerData[player].accountid)
        
	mariadb_query(sql, query)
end