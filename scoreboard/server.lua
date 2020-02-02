function Scoreboard_RequestUpdate(player)
  local _send = {}
  for _, v in ipairs(GetAllPlayers()) do
    _send[v] = {
      ['id'] = v,
      ['name'] = PlayerData[v].name or GetPlayerName(v),
      ['steamid'] = tostring(GetPlayerSteamId(v)),
      ['ping'] = GetPlayerPing(v)
    }
  end

  CallRemoteEvent(player, 'OnServerScoreboardUpdate', _send, GetServerName(), #GetAllPlayers(), GetMaxPlayers())
end
AddRemoteEvent('RequestScoreboardUpdate', Scoreboard_RequestUpdate)

AddRemoteEvent("scoreboard:server:isadmin", function(player)
  local isAdmin
  if PlayerData[player].admin == 1 then
    isAdmin = true
  else
    isAdmin = false
  end
  CallRemoteEvent(player, "scoreboard:client:isadmin", isAdmin)  
end)
