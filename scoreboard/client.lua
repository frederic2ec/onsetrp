-- Based on digital scoreboard on onset sandbox editor gamemode 

local ScoreboardUI = 0
local ScoreboardFirstOpen = false

function Scoreboard_OnPackageStart()
  ScoreboardUI = CreateWebUI(0.0, 0.0, 0.0, 0.0, 1, 60)
  SetWebAnchors(ScoreboardUI, 0.0, 0.0, 1.0, 1.0)
  LoadWebFile(ScoreboardUI, 'http://asset/' .. GetPackageName() .. '/scoreboard/scoreboard/scoreboard.html')
  SetWebVisibility(ScoreboardUI, WEB_HIDDEN)
end
AddEvent("OnPackageStart", Scoreboard_OnPackageStart)

function Scoreboard_OnKeyPress(key)
  local IsAdmin = GetPlayerPropertyValue(GetPlayerId(), "Account:IsAdmin")
  print('IsAdmin ?', IsAdmin) 
  if key == 'Tab' and IsAdmin == 1 then
    CallRemoteEvent('RequestScoreboardUpdate')
    SetInputMode(INPUT_GAMEANDUI)
    SetWebVisibility(ScoreboardUI, WEB_VISIBLE)
  end
end
AddEvent('OnKeyPress', Scoreboard_OnKeyPress)

function Scoreboard_OnKeyRelease(key)
  if key == 'Tab' then
    SetInputMode(INPUT_GAME)
    SetWebVisibility(ScoreboardUI, WEB_HIDDEN)
  end
end
AddEvent('OnKeyRelease', Scoreboard_OnKeyRelease)

function Scoreboard_OnServerScoreboardUpdate(data, name, players, maxplayers)
  if data == nil then return end

  ExecuteWebJS(ScoreboardUI, 'ResetScoreboard()')
  ExecuteWebJS(ScoreboardUI, 'SetInformation("' .. name .. '", ' .. players .. ', ' .. maxplayers .. ')')
  for _, v in pairs(data) do
    ExecuteWebJS(ScoreboardUI, 'AddPlayer (' .. v['id'] .. ',"' .. v['name'] .. '","' .. v['steamid'] .. '", ' .. v['ping'] .. ')')
  end
end
AddRemoteEvent('OnServerScoreboardUpdate', Scoreboard_OnServerScoreboardUpdate)

AddEvent("scoreboard:admin:freeze", function(player)
  local IsAdmin = GetPlayerPropertyValue(GetPlayerId(), "Account:IsAdmin")
  if IsAdmin == 1  then
    CallRemoteEvent("AdminFreezePlayer", player)    
  end
end)

AddEvent("scoreboard:admin:ragdoll", function(player)
  local IsAdmin = GetPlayerPropertyValue(GetPlayerId(), "Account:IsAdmin")
  if IsAdmin == 1  then
    CallRemoteEvent("AdminRagdollPlayer", player)    
  end
end)

AddEvent("scoreboard:admin:bring", function(player)
  local IsAdmin = GetPlayerPropertyValue(GetPlayerId(), "Account:IsAdmin")
  if IsAdmin == 1 and GetPlayerId() ~= player then
    CallRemoteEvent("AdminTeleportPlayer",  GetPlayerId(), player)    
  end
end)

AddEvent("scoreboard:admin:goto", function(player)
  local IsAdmin = GetPlayerPropertyValue(GetPlayerId(), "Account:IsAdmin")
  if IsAdmin == 1 and GetPlayerId() ~= player then
    CallRemoteEvent("AdminTeleportToPlayer", player)    
  end
end)

AddEvent("scoreboard:admin:kick", function(player)
  local IsAdmin = GetPlayerPropertyValue(GetPlayerId(), "Account:IsAdmin")
  if IsAdmin == 1 and GetPlayerId() ~= player then
    CallRemoteEvent("AdminKickBan", tonumber(player), "Kick", "HOP HOP HOP, Halte là !")
  end
end)

AddEvent("scoreboard:admin:ban", function(player)
  local IsAdmin = GetPlayerPropertyValue(GetPlayerId(), "Account:IsAdmin")
  if IsAdmin == 1 and GetPlayerId() ~= player then
    CallRemoteEvent("AdminKickBan", tonumber(player), "Ban", "Qui fait le malin, tombe dans le ravin !")
  end
end)