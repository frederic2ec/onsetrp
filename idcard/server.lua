local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

AddRemoteEvent("SeeIdCard", function(player)
    -- Coming soon: job and jobTitle
    -- CallRemoteEvent(player, "OnCardDataLoaded", PlayerData[player].name, playerInfo['company']['name'], playerInfo['job'])
    CallRemoteEvent(player, "OnCardDataLoaded", PlayerData[player].accountid, PlayerData[player].name, PlayerData[player].driver_license == 1, PlayerData[player].gun_license == 1, PlayerData[player].helicopter_license == 1, PlayerData[player].age)
end)

AddRemoteEvent("ShowIdCard", function(player)
    local nearestPlayer = GetNearestPlayer(player, 115)
    if(nearestPlayer ~= nil) then
	    CallRemoteEvent(nearestPlayer, "OnCardDataLoaded",  PlayerData[player].accountid, PlayerData[player].name, PlayerData[player].driver_license == 1, PlayerData[player].gun_license == 1, PlayerData[player].helicopter_license == 1, PlayerData[player].age)
	else
	    CallRemoteEvent(player, "MakeNotification", _("no_players_around"), "linear-gradient(to right, #ff5f6d, #ffc371)")
	end
    -- Coming soon: job and jobTitle
    -- CallRemoteEvent(player, "OnCardDataLoaded", PlayerData[player].name, playerInfo['company']['name'], playerInfo['job'])
    
end)
