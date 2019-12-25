local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

AddRemoteEvent("SeeIdCard", function(player)
    -- Coming soon: job and jobTitle
    -- CallRemoteEvent(player, "OnCardDataLoaded", PlayerData[player].name, playerInfo['company']['name'], playerInfo['job'])
    CallRemoteEvent(player, "OnCardDataLoaded", PlayerData[player].accountid, PlayerData[player].name)
end)

AddRemoteEvent("ShowIdCard", function(player)
    local nearestPlayer = GetNearestPlayer(player, 115)
    if(nearestPlayer ~= nil) then
	    CallRemoteEvent(nearestPlayer[1], "OnCardDataLoaded", PlayerData[player].accountid, PlayerData[player].name)
	else
	    CallRemoteEvent(player, "MakeNotification", _("no_players_around"), "linear-gradient(to right, #ff5f6d, #ffc371)")
	end
    -- Coming soon: job and jobTitle
    -- CallRemoteEvent(player, "OnCardDataLoaded", PlayerData[player].name, playerInfo['company']['name'], playerInfo['job'])
    
end)

function GetNearestPlayer(player, distanceMax)
    local x, y, z = GetPlayerLocation(player)
    local listStreamed = GetStreamedPlayersForPlayer(player)
    local closestDistance = 50000
    local otherPlayer
    local _x, _y, _z
    for k,v in pairs(listStreamed) do
        _x, _y, _z = GetPlayerLocation(v)
	    local tmpDistance = GetDistance3D(x, y, z, _x, _y, _z)
	    if(tmpDistance < closestDistance and v ~= player and tmpDistance < distanceMax) then
		closestDistance = tmpDistance
		otherPlayer = v
	    end
    end
    if(otherPlayer ~= nil) then
	return {otherPlayer, _x, _y, _z}
    end
    return
end