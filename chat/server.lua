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
AddCommand("g", function(player, ...)
    local args = { ... }
    local message = ""
    for i=1,#args do
        if i > 1 then
            message = message.." "
        end
        message = message..args[1]
    end
    message = '['.._("global")..'] <span>'..GetPlayerName(player)..'('..player..'):</> '..message
    AddPlayerChatAll(message)
end)


-- Send message to admin
AddCommand("/", function(player, ...) 
    local args = { ... }
    local message = ""
    for i=1,#args do
        if i > 1 then
            message = message.." "
        end
        message = message..args[1]
    end
    message = '['.._("admin")..'] <span>'..GetPlayerName(player)..'('..player..'):</> '..message
    AddPlayerChat(player, message)
    for k,v in pairs(GetAllPlayers()) do
        if PlayerData[k].admin == 1 then
            AddPlayerChat(k, message)
        end
    end
end)

-- Private message
AddCommand("p", function(player, toplayer, ...)
    local args = { ... }
    local message = ""
    for i=1,#args do
        if i > 1 then
            message = message.." "
        end
        message = message..args[1]
    end 
    message = '['.._("private_message")..'] <span>'..GetPlayerName(player)..'('..player..'):</> '..message
    AddPlayerChat(player, message)
    AddPlayerChat(toplayer, message)
end)

--
AddCommand("kill", function(player)
    SetPlayerHealth(player, 0)
end)

AddCommand("getpos", function(player)
    local x, y, z = GetPlayerLocation(player)
    AddPlayerChat(player, "X : "..x.." Y : "..y.." Z : "..z)
end)
AddCommand("bank", function(player)
    SetPlayerLocation(player, 189784.000000, 201549.000000, 835.000000)
end)
AddCommand("cinema", function(player)
    SetPlayerLocation(player, 173747.000000, 198165.000000, 2532.000000)
end)
AddCommand("police", function(player)
    SetPlayerLocation(player, 171553.000000, 195234.000000, 572.000000)
end)
AddCommand("hos1", function(player)
    SetPlayerLocation(player, 215235.000000, 158465.000000, 2960.000000)
end)
AddCommand("hos2", function(player)
    SetPlayerLocation(player, 212372.000000, 153763.000000, 2793.000000)
end)
AddCommand("office", function(player)
    SetPlayerLocation(player, 191369.000000, 193415.000000, 9366.000000)
end)
AddCommand("spec", function(player)
    SetPlayerSpectate( player, true)
end)