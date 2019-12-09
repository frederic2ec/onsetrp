local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

function OnPlayerChat(player, message)
    -- Region message
    local streamedPlayers = GetStreamedPlayersForPlayer(player)
    message = '<span>'..GetPlayerName(player)..'('..player..'):</> '..message
    for k,v in pairs(streamedPlayers) do
        AddPlayerChat(k, message)
    end
end
AddEvent("OnPlayerChat", OnPlayerChat)

-- Global chat
AddCommand("g", function(player, message) 
    message = '['.._("global")..'] <span>'..GetPlayerName(player)..'('..player..'):</> '..message
    AddPlayerChatAll(message)
end)


-- Send message to admin
AddCommand("/", function(player, message) 
    message = '['.._("admin")..'] <span>'..GetPlayerName(player)..'('..player..'):</> '..message
    AddPlayerChat(player, message)
    for k,v in pairs(GetAllPlayers()) do
        if PlayerData[k].admin == 1 then
            AddPlayerChat(k, message)
        end
    end
end)

-- Private message
AddCommand("p", function(player, toplayer, message) 
    message = '['.._("private_message")..'] <span>'..GetPlayerName(player)..'('..player..'):</> '..message
    AddPlayerChat(player, message)
    AddPlayerChat(toplayer, message)
end)

AddCommand("kill", function(player)
    SetPlayerHealth(player, 0)
end)

AddCommand("getpos", function(player)
    local x, y, z = GetPlayerLocation(player)
    AddPlayerChat(player, "X : "..x.." Y : "..y.." Z : "..z)
end)