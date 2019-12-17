local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end
PlayerData = {}

function OnPackageStart()
    -- Save all player data automatically 
    CreateTimer(function()
		for k, v in pairs(GetAllPlayers()) do
            SavePlayerAccount(v)
		end
		print("All accounts have been saved !")
    end, 30000)
end
AddEvent("OnPackageStart", OnPackageStart)

function OnPlayerSteamAuth(player)

	CreatePlayerData(player)
	PlayerData[player].steamname = GetPlayerName(player)
    
    AddPlayerChatAll('<span color="#eeeeeeaa">'..GetPlayerName(player)..' from '..PlayerData[player].locale..' joined the server</>')
    AddPlayerChatAll('<span color="#eeeeeeaa">There are '..GetPlayerCount()..' players on the server</>')
    
    -- First check if there is an account for this player
	local query = mariadb_prepare(sql, "SELECT id FROM accounts WHERE steamid = '?' LIMIT 1;",
    tostring(GetPlayerSteamId(player)))

    mariadb_async_query(sql, query, OnAccountLoadId, player)
end
AddEvent("OnPlayerSteamAuth", OnPlayerSteamAuth)

AddEvent("OnPlayerJoin", function(player)
	SetPlayerSpawnLocation(player, 227603, -65590, 237, 0 )
end)

function OnPlayerQuit(player)
    SavePlayerAccount(player)

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

		print("Kicking "..GetPlayerName(player).." because their account was banned")

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
		print("Kicking "..GetPlayerName(player).." because their IP was banned")

		local result = mariadb_get_assoc(1)
        
        KickPlayer(player, "🚨 You have been banned from the server.")
	end
end

function CreatePlayerAccount(player)
	local query = mariadb_prepare(sql, "INSERT INTO accounts (id, steamid, clothing, inventory) VALUES (NULL, '?', '[]' , '[]');",
		tostring(GetPlayerSteamId(player)))

	mariadb_query(sql, query, OnAccountCreated, player)
end

function OnAccountCreated(player)
	PlayerData[player].accountid = mariadb_get_insert_id()

	CallRemoteEvent(player, "askClientCreation")

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
		PlayerData[player].name = tostring(result['name'])
		PlayerData[player].clothing = json_decode(result['clothing'])
		PlayerData[player].inventory = json_decode(result['inventory'])
		PlayerData[player].created = math.tointeger(result['created'])

		SetPlayerHealth(player, tonumber(result['health']))
		SetPlayerArmor(player, tonumber(result['armor']))
        setPlayerThirst(player, tonumber(result['thirst']))
        setPlayerHunger(player, tonumber(result['hunger']))

		SetPlayerLoggedIn(player)

		if PlayerData[player].created == 0 then
			CallRemoteEvent(player, "askClientCreation")
		else
			SetPlayerName(player, PlayerData[player].name)
		
			playerhairscolor = getHairsColor(PlayerData[player].clothing[2])
			CallRemoteEvent(player, "ClientChangeClothing", player, 0, PlayerData[player].clothing[1], playerhairscolor[1], playerhairscolor[2], playerhairscolor[3], playerhairscolor[4])
			CallRemoteEvent(player, "ClientChangeClothing", player, 1, PlayerData[player].clothing[3], 0, 0, 0, 0)
			CallRemoteEvent(player, "ClientChangeClothing", player, 4, PlayerData[player].clothing[4], 0, 0, 0, 0)
			CallRemoteEvent(player, "ClientChangeClothing", player, 5, PlayerData[player].clothing[5], 0, 0, 0, 0)
			CallRemoteEvent(player, "AskSpawnMenu")
		end
		
		AddPlayerChat(player, '<span color="#ffff00aa" style="bold italic" size="17">SERVER: Welcome back '..GetPlayerName(player)..', have fun!</>')

		print("Account ID "..PlayerData[player].accountid.." loaded for "..GetPlayerIP(player))
	end
end

function CreatePlayerData(player)
	PlayerData[player] = {}

	PlayerData[player].accountid = 0
	PlayerData[player].name = ""
	PlayerData[player].clothing = {}
	PlayerData[player].inventory = {}
    PlayerData[player].logged_in = false
	PlayerData[player].admin = 0
	PlayerData[player].created = 0
	PlayerData[player].locale = GetPlayerLocale(player)
	PlayerData[player].steamid = GetPlayerSteamId(player)
	PlayerData[player].steamname = ""
    PlayerData[player].thirst = 100
    PlayerData[player].hunger = 100
    PlayerData[player].cash = 0
	PlayerData[player].bank_balance = 1000
	PlayerData[player].job_vehicle = nil
	PlayerData[player].job = ""
	PlayerData[player].onAction = false

    print("Data created for : "..player)
end

function DestroyPlayerData(player)
	if (PlayerData[player] == nil) then
		return
	end
	
	if PlayerData[player].job_vehicle ~= nil then
        DestroyVehicle(PlayerData[player].job_vehicle)
        DestroyVehicleData( PlayerData[player].job_vehicle)
        PlayerData[player].job_vehicle = nil
    end

	PlayerData[player] = nil
	print("Data destroyed for : "..player)
end

function SavePlayerAccount(player)
	if (PlayerData[player] == nil) then
		return
	end

	if (PlayerData[player].accountid == 0 or PlayerData[player].logged_in == false) then
		return
	end

	local query = mariadb_prepare(sql, "UPDATE accounts SET admin = ?, cash = ?, bank_balance = ?, health = ?, armor = ?, hunger = ?, thirst = ?, name = '?', clothing = '?', inventory = '?', created = '?' WHERE id = ? LIMIT 1;",
		PlayerData[player].admin,
		PlayerData[player].cash,
		PlayerData[player].bank_balance,
		GetPlayerHealth(player),
        GetPlayerArmor(player),
        PlayerData[player].hunger,
		PlayerData[player].thirst,
		PlayerData[player].name,
		json_encode(PlayerData[player].clothing),
		json_encode(PlayerData[player].inventory),
		PlayerData[player].created,
		PlayerData[player].accountid
		)
        
	mariadb_query(sql, query)
end

function SetPlayerLoggedIn(player)
    PlayerData[player].logged_in = true

    CallEvent("OnPlayerJoin", player)
end