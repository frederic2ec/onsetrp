local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local whitelist = false

AddEvent("OnPlayerSteamAuth", function(player)
    if whitelist then
        local steamid = GetPlayerSteamId(player)
        
        local query = mariadb_prepare(sql, "SELECT * FROM whitelist WHERE steamid = ?;",
        tostring(steamid))
    
        mariadb_query(sql, query, function(player)
            if mariadb_get_row_count() == 0 then
                KickPlayer(player, _("not_whitelisted"))
            end
        end, player)
    end
end)
