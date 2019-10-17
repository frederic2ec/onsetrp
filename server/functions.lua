
function OnPlayerDeath(player, instigator)
    setPlayerHunger(player, 100)
    setPlayerThirst(player, 100)
end
AddEvent("OnPlayerDeath", OnPlayerDeath)

function setPlayerHealth(player, health)
    -- Set the player health
    SetPlayerHealth(player, health)
    
end
AddRemoteEvent("setPlayerHealth", setPlayerHealth)

-- Hunger
function setPlayerHunger(player, hunger)
    PlayerData[player].hunger = hunger

    -- Set hunger to an 100 if the number is greater
    if PlayerData[player].hunger > 100 then
        PlayerData[player].hunger = 100
    end
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
        setPlayerHealth(player, health)
    end
end
AddRemoteEvent("removePlayerHunger", removePlayerHunger)

function sendPlayerHunger(player)
    hunger = PlayerData[player].hunger
    if (PlayerData[player].accountid == 0 or PlayerData[player].logged_in == false) then
		return
	end
    AddPlayerChat(player, "Hunger : "..hunger)
end
AddRemoteEvent("sendPlayerHunger", sendPlayerHunger)

-- Thirst
function setPlayerThirst(player, thirst)
    PlayerData[player].thirst = thirst

    -- Set thirst to an 100 if the number is greater
    if PlayerData[player].thirst > 100 then
        PlayerData[player].thirst = 100
    end
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
        setPlayerHealth(player, 0)
    end
end
AddRemoteEvent("removePlayerThirst", removePlayerThirst)

function sendPlayerThirst(player)
    thirst = PlayerData[player].thirst
    if (PlayerData[player].accountid == 0 or PlayerData[player].logged_in == false) then
		return
	end
    AddPlayerChat(player, "Thirst : "..thirst)
end
AddRemoteEvent("sendPlayerThirst", sendPlayerThirst)

function SetPlayerLoggedIn(player)
    PlayerData[player].logged_in = true

    CallEvent("OnPlayerLoggedIn", player)
end

function setPlayerModel(player, model)
    PlayerData[player].model = model

    SetPlayerModel(player, model)
end

function getHudData(player)
    health = GetPlayerHealth(player)
    armor = GetPlayerArmor(player)
    hunger = PlayerData[player].hunger
    thirst = PlayerData[player].thirst

    CallRemoteEvent(player, "updateHud", health, armor, hunger, thirst)
end
AddRemoteEvent("getHudData", getHudData)

function getAtmData(player)
    bank = PlayerData[player].bank_balance
    cash = PlayerData[player].cash

    CallRemoteEvent(player, "updateAtm", bank, cash)
end
AddRemoteEvent("getAtmData", getAtmData)

function withdrawAtm(player, amount)
    if tonumber(amount) > PlayerData[player].bank_balance then
        AddPlayerChat(player, "You don't have the money to withdraw !")
    else
        PlayerData[player].bank_balance = PlayerData[player].bank_balance - amount
        PlayerData[player].cash = PlayerData[player].cash + amount

        getAtmData(player)
    end
end
AddRemoteEvent("withdrawAtm", withdrawAtm)

function depositAtm(player, amount)
    if tonumber(amount) > PlayerData[player].cash then
        AddPlayerChat(player, "You don't have the money to withdraw !")
    else
        PlayerData[player].cash = PlayerData[player].cash - amount
        PlayerData[player].bank_balance = PlayerData[player].bank_balance + amount

        getAtmData(player)
    end
end
AddRemoteEvent("depositAtm", depositAtm)
