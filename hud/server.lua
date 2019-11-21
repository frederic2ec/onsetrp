function getHudData(player)
    health = GetPlayerHealth(player)
    armor = GetPlayerArmor(player)
    hunger = PlayerData[player].hunger
    thirst = PlayerData[player].thirst

    CallRemoteEvent(player, "updateHud", health, armor, hunger, thirst)
end
AddRemoteEvent("getHudData", getHudData)

