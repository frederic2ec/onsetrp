function Scoreboard_RequestUpdate(player)
  local _send = {}
  for _, v in ipairs(GetAllPlayers()) do
    _send[v] = {
      ['id'] = v,
      ['name'] = PlayerData[v].name,
      ['steamid'] = tostring(GetPlayerSteamId(v)),
      ['ping'] = GetPlayerPing(v)
    }
  end

  CallRemoteEvent(player, 'OnServerScoreboardUpdate', _send, GetServerName(), #GetAllPlayers(), GetMaxPlayers())
end
AddRemoteEvent('RequestScoreboardUpdate', Scoreboard_RequestUpdate)