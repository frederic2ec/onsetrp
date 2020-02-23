function Scoreboard_RequestUpdate(player)
    local _send = {}
    for _, v in ipairs(GetAllPlayers()) do
        if PlayerData[v] ~= null and PlayerData[v].name ~= null and PlayerData[v].name ~= "" then
            _send[v] = {
                ['id'] = v,
                ['accountid'] = PlayerData[v].accountid,
                ['name'] = PlayerData[v].name or GetPlayerName(v),
                ['ping'] = GetPlayerPing(v),
                ['job'] = PlayerData[v].job or "",
                ['health'] = PlayerData[v].health or 100,
                ['hunger'] = PlayerData[v].hunger or 100,
                ['thirst'] = PlayerData[v].thirst or 100,
                ['admin'] = PlayerData[v].admin or 0
            }
        end
    end
    
    CallRemoteEvent(player, 'OnServerScoreboardUpdate', _send, #GetAllPlayers(), GetMaxPlayers())
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
