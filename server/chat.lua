function OnPlayerChat(player, message)
    -- Normal message
	message = '<span>'..GetPlayerName(player)..'('..player..'):</> '..message
    AddPlayerChatAll(message)
end
AddEvent("OnPlayerChat", OnPlayerChat)