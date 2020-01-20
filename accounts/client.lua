function GetPlayerBusy() -- Shortcut to get the busy state of the player
	local result = GetPlayerPropertyValue(GetPlayerId(), "PlayerIsBusy") or false
	return result
end

-- Exports
AddFunctionExport("CGetPlayerBusy", GetPlayerBusy)
