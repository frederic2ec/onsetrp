local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

function OnPlayerDeath(player, instigator)
    setPlayerHunger(player, 100)
    setPlayerThirst(player, 100)
end
AddEvent("OnPlayerDeath", OnPlayerDeath)

-- Hunger
function setPlayerHunger(player, hunger)
    PlayerData[player].hunger = hunger

    -- Set hunger to an 100 if the number is greater
    if PlayerData[player].hunger > 100 then
        PlayerData[player].hunger = 100
    end
    SetPlayerPropertyValue(player, "hunger", PlayerData[player].hunger, true)
end
AddRemoteEvent("setPlayerHunger", setPlayerHunger)

function addPlayerHunger(player, hunger)
    -- Check if the hunger is not more then 100
    if PlayerData[player].hunger ~= 100 then
        PlayerData[player].hunger = PlayerData[player].hunger + hunger
    end

    -- Set hunger to an 100 if the number is greater
    if PlayerData[player].hunger > 100 then
        PlayerData[player].hunger = 100
    end
    SetPlayerPropertyValue(player, "hunger", PlayerData[player].hunger, true)
end
AddRemoteEvent("addPlayeHunger", addPlayerHunger)

function removePlayerHunger(player, hunger)
    -- Check if the hunger is higher then 0
    if  PlayerData[player].hunger ~= 0 then
        PlayerData[player].hunger = PlayerData[player].hunger - hunger
    end

    -- Set hunger to 0 if it's lower then 0
    if PlayerData[player].hunger < 0 then
        PlayerData[player].hunger = 0
    end

    -- Remove health to player if hunger is 0
    if  PlayerData[player].hunger == 0 then
        health = GetPlayerHealth(player) - 5
        SetPlayerHealth(player, health)
    end

    SetPlayerPropertyValue(player, "hunger", PlayerData[player].hunger, true)
end
AddRemoteEvent("removePlayerHunger", removePlayerHunger)

function sendPlayerHunger(player)
    hunger = PlayerData[player].hunger
    if (PlayerData[player].accountid == 0 or PlayerData[player].logged_in == false) then
		return
	end
    AddPlayerChat(player, _("hunger").." : "..hunger)
end
AddRemoteEvent("sendPlayerHunger", sendPlayerHunger)

-- Thirst
function setPlayerThirst(player, thirst)
    PlayerData[player].thirst = thirst
    -- Set thirst to an 100 if the number is greater
    if PlayerData[player].thirst > 100 then
        PlayerData[player].thirst = 100
    end

    -- Kill the player if is thirst is 0
    if  PlayerData[player].thirst == 0 then
        SetPlayerHealth(player, 0)
    end
    SetPlayerPropertyValue(player, "thirst", PlayerData[player].thirst, true)
end
AddRemoteEvent("setPlayerThirst", setPlayerThirst)

function addPlayerThirst(player, thirst)
    -- Check if the thirst is not more then 100
    if PlayerData[player].thirst ~= 100 then
        PlayerData[player].thirst = PlayerData[player].thirst + thirst
    end

    -- Set thirst to an 100 if the number is greater
    if PlayerData[player].thirst > 100 then
        PlayerData[player].thirst = 100
    end
    SetPlayerPropertyValue(player, "thirst", PlayerData[player].thirst, true)
end
AddRemoteEvent("addPlayerThirst", addPlayerThirst)

function removePlayerThirst(player, thirst)
    -- Check if the thirst is not 0
    if PlayerData[player].thirst ~= 0 then
        PlayerData[player].thirst = PlayerData[player].thirst - thirst
    end

    -- Set thirst to 0 if it's lower then 0
    if PlayerData[player].thirst < 0 then
        PlayerData[player].thirst = 0
    end

    -- Kill the player if is thirst is 0
    if  PlayerData[player].thirst == 0 then
        SetPlayerHealth(player, 0)
    end
    SetPlayerPropertyValue(player, "thirst", PlayerData[player].thirst, true)
end
AddRemoteEvent("removePlayerThirst", removePlayerThirst)

function sendPlayerThirst(player)
    thirst = PlayerData[player].thirst
    if (PlayerData[player].accountid == 0 or PlayerData[player].logged_in == false) then
		return
	end
    AddPlayerChat(player, _("thirst").." : "..thirst)
end
AddRemoteEvent("sendPlayerThirst", sendPlayerThirst)