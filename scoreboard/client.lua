-- Based on digital scoreboard on onset sandbox editor gamemode 

local ScoreboardUI = 0
local ScoreboardFirstOpen = false
local IsAdmin = false

function Scoreboard_OnPackageStart()
  ScoreboardUI = CreateWebUI(0.0, 0.0, 0.0, 0.0, 1, 60)
  SetWebAnchors(ScoreboardUI, 0.0, 0.0, 1.0, 1.0)
  LoadWebFile(ScoreboardUI, 'http://asset/' .. GetPackageName() .. '/scoreboard/scoreboard/scoreboard.html')
  SetWebVisibility(ScoreboardUI, WEB_HIDDEN)
  CallRemoteEvent("scoreboard:server:isadmin")  
end
AddEvent("OnPackageStart", Scoreboard_OnPackageStart)

AddRemoteEvent("scoreboard:client:isadmin", function(_IsAdmin)
  IsAdmin = _IsAdmin
end)


function Scoreboard_OnKeyPress(key)
  if key == 'Tab' and IsAdmin == true then
    ShowMouseCursor(true)    
    CallRemoteEvent('RequestScoreboardUpdate')
    SetInputMode(INPUT_GAMEANDUI)
    SetWebVisibility(ScoreboardUI, WEB_VISIBLE)
  end
end
AddEvent('OnKeyPress', Scoreboard_OnKeyPress)

function Scoreboard_OnKeyRelease(key)
  if key == 'Tab' and IsAdmin == true then
    ShowMouseCursor(false)   
    SetInputMode(INPUT_GAME)
    SetWebVisibility(ScoreboardUI, WEB_HIDDEN)
  end
end
AddEvent('OnKeyRelease', Scoreboard_OnKeyRelease)

function Scoreboard_OnServerScoreboardUpdate(data, players, maxplayers, admin)
  if data == nil then return end
  ExecuteWebJS(ScoreboardUI, 'ResetScoreboard()')
  ExecuteWebJS(ScoreboardUI, 'SetInformation(' .. players .. ', ' .. maxplayers .. ')')
  for _, v in pairs(data) do
    ExecuteWebJS(ScoreboardUI, 'AddPlayer (' .. v['id'] .. ',' .. v['accountid'] .. ',"' .. v['name'] .. '", ' .. v['ping'] .. ', "'..v['job']..'", '..v['health']..','..v['hunger']..','..v['thirst']..','..v['admin']..')')
  end
end
AddRemoteEvent('OnServerScoreboardUpdate', Scoreboard_OnServerScoreboardUpdate)

AddEvent("scoreboard:admin:rez", function(player)
  if IsAdmin == true  then
    CallRemoteEvent("AdminRezPlayer", player) 
  end
end)

AddEvent("scoreboard:admin:heal", function(player)
  if IsAdmin == true  then
    CallRemoteEvent("AdminHealPlayer", player)    
  end
end)

AddEvent("scoreboard:admin:cuff", function(player)
  if IsAdmin == true  then
    CallRemoteEvent("AdminCuffPlayer", player)    
  end
end)

AddEvent("scoreboard:admin:freeze", function(player)
  if IsAdmin == true  then
    CallRemoteEvent("AdminFreezePlayer", player)    
  end
end)

AddEvent("scoreboard:admin:ragdoll", function(player)
  if IsAdmin == true  then
    CallRemoteEvent("AdminRagdollPlayer", player)    
  end
end)

AddEvent("scoreboard:admin:bring", function(player)
  if IsAdmin == true and GetPlayerId() ~= player then
    CallRemoteEvent("AdminTeleportPlayer",  GetPlayerId(), player)    
  end
end)

AddEvent("scoreboard:admin:goto", function(player)
  if IsAdmin == true and GetPlayerId() ~= player then
    CallRemoteEvent("AdminTeleportToPlayer", player)    
  end
end)

AddEvent("scoreboard:admin:kick", function(player)
  if IsAdmin == true and GetPlayerId() ~= player then
    CallRemoteEvent("AdminKickBan", tonumber(player), "Kick", "HOP HOP HOP, Halte là !")
  end
end)

AddEvent("scoreboard:admin:ban", function(player)
  if IsAdmin == true and GetPlayerId() ~= player then
    CallRemoteEvent("AdminKickBan", tonumber(player), "Ban", "Qui fait le malin, tombe dans le ravin !")
  end
end)

AddEvent("scoreboard:admin:spectate", function(player)
  if IsAdmin == true and GetPlayerId() ~= player then
    CallRemoteEvent("admin:spectate", player)
  end
end)

