function Scoreboard_RequestUpdate(player)
  local _send = {}
  for _, v in ipairs(GetAllPlayers()) do
    _send[v] = {
      ['id'] = v,
      ['name'] = GetPlayerName(v),
      ['steamid'] = GetPlayerSteamId(v),
      ['ping'] = GetPlayerPing(v)
    }
  end

  CallRemoteEvent(player, 'OnServerScoreboardUpdate', _send, GetServerName(), #GetAllPlayers(), GetMaxPlayers())
end
AddRemoteEvent('RequestScoreboardUpdate', Scoreboard_RequestUpdate)