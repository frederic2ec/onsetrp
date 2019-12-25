AddRemoteEvent("SeeIdCard", function(player)
    -- Coming soon: job and jobTitle
    -- CallRemoteEvent(player, "OnCardDataLoaded", PlayerData[player].name, playerInfo['company']['name'], playerInfo['job'])
    CallRemoteEvent(player, "OnCardDataLoaded", PlayerData[player].accountid, PlayerData[player].name)
end)

AddRemoteEvent("ShowIdCard", function(player)
    local info = GetNearestPlayer(player, 115)
    -- Coming soon: job and jobTitle
    -- CallRemoteEvent(player, "OnCardDataLoaded", PlayerData[player].name, playerInfo['company']['name'], playerInfo['job'])
    CallRemoteEvent(player, "OnCardDataLoaded", PlayerData[player].accountid, PlayerData[player].name)
end)