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
  if key == 'Tab' then
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
    ExecuteWebJS(ScoreboardUI, 'AddPlayer ("' .. v['name'] .. '", ' .. v['ping'] .. ')')
  end
end
AddRemoteEvent('OnServerScoreboardUpdate', Scoreboard_OnServerScoreboardUpdate)