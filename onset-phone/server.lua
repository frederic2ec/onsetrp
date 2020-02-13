local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

-- CONFIGS

local canUsePhoneWithoutPhoneItem = false
local phoneItemName = 'phone'
local canUsePhoneWhileGathering = false

-- LOADING

function LoadPhone(player)
    if (canUsePhoneWhileGathering or not PlayerData[player].onAction) and canUsePhoneWithoutPhoneItem or PlayerData[player].inventory[phoneItemName] then
        SetPlayerAnimation(player, 'PHONE_HOLD')
        local query = mariadb_prepare(sql, "SELECT * FROM messages WHERE messages.from = '?' OR messages.to = '?';", tostring(PlayerData[player].phone_number), tostring(PlayerData[player].phone_number))

        mariadb_async_query(sql, query, OnMessagesLoaded, player)
    end
end
AddRemoteEvent("LoadPhone", LoadPhone)


function UnloadPhone(player)
    SetPlayerAnimation(player, 'PHONE_TAKEOUT_HOLD')
end
AddRemoteEvent("UnloadPhone", UnloadPhone)

function OnMessagesLoaded(player)
    local messages = {}
    local playerData = PlayerData[player]

    for i = 1, mariadb_get_row_count() do
        local message = mariadb_get_assoc(i)

        messages[i] = { content = string.gsub(message['content'], '"', "\\\""), from = message['from'], to = message['to'],  }
    end

    CallRemoteEvent(player, "OnPhoneLoaded", player, playerData.phone_number, playerData.bank_balance, messages, playerData.phone_contacts)
end

-- CONTACTS

function ContactCreated(player, name, phone)
    table.insert(PlayerData[player].phone_contacts, { name = name, phone = phone })

    local query = mariadb_prepare(sql, "INSERT INTO phone_contacts (`id`, `owner_id`, `name`, `phone`) VALUES (NULL, '?', '?', '?');",
		tostring(PlayerData[player].accountid), name, phone)

	mariadb_query(sql, query, NullCallback)
end
AddRemoteEvent("ContactCreated", ContactCreated)

function ContactUpdated(player, name, phone)
    for key, value in pairs(PlayerData[player].phone_contacts) do
        if PlayerData[player].phone_contacts[key]['phone'] == phone then
            PlayerData[player].phone_contacts[key]['name'] = name
        end
    end

    local query = mariadb_prepare(sql, "UPDATE phone_contacts SET name = '?' WHERE phone = '?' AND owner_id = '?';", name, phone, tostring(PlayerData[player].accountid))

    mariadb_query(sql, query, NullCallback, player)
end
AddRemoteEvent("ContactUpdated", ContactUpdated)

function ContactDeleted(player, phone)
    for key, value in pairs(PlayerData[player].phone_contacts) do
        if PlayerData[player].phone_contacts[key]['phone'] == phone then
            table.remove(PlayerData[player].phone_contacts, key)
        end
    end

    local query = mariadb_prepare(sql, "DELETE FROM phone_contacts WHERE phone = '?' AND owner_id = '?';", phone, tostring(PlayerData[player].accountid))

    mariadb_query(sql, query, NullCallback, player)
end
AddRemoteEvent("ContactDeleted", ContactDeleted)

-- MESSAGES

function MessageCreated(player, phone, content)
    local created_at = tostring(os.time(os.date("!*t")))

    local from = nil
    if player == 0 then
        from = "0"
    else
        from = PlayerData[player].phone_number
    end
    local query = mariadb_prepare(sql, "INSERT INTO messages (`id`, `from`, `to`, `content`, `created_at`) VALUES (NULL, '?', '?', '?', '?');",
        tostring(from), phone, content, created_at)

    local playersIds = GetAllPlayers()

    for playerId, v in pairs(playersIds) do
        if PlayerData[playerId].phone_number == phone then
            CallRemoteEvent(playerId, "NewMessage", from, phone, content, created_at)
        end
    end

    mariadb_query(sql, query, NullCallback)
end
AddRemoteEvent("MessageCreated", MessageCreated)

-- GPS CLICK

function MessageGPSClicked(player, latitude, longitude)
    print("GPS")
    print(latitude)
    print(longitude)
end
AddRemoteEvent("MessageCreated", MessageCreated)

-- UTILS

function NullCallback()
end
