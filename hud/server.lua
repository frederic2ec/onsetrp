function getHudData(player)
    health = math.ceil(GetPlayerHealth(player))
    armor = math.ceil(GetPlayerArmor(player))
    hunger = PlayerData[player].hunger
    thirst = PlayerData[player].thirst

    CallRemoteEvent(player, "updateHud", health, armor, hunger, thirst)
end
AddRemoteEvent("getHudData", getHudData)

