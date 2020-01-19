local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local bankRobberyPickup
local bankRobberyText
local bankRobberyMoneyObject
local bankRobberyMoneyText
local robberyStep
-- STEPS:
-- * notStarted
-- * started
-- * pickup
-- * ended
local workingCops = {}

-- Configs

local robberyLocation = { 213940.421875, 192764.109375, 1309.3317871094 }
local minumumCopsToStartARobbery = 1
local timeBeforeGettingMoneyInMinutes = 5
local timeBeforeMoneyDespawn = 5
local timeBeforeNewRobbery = 15
local cashForARobbery = 10000

AddEvent("OnPackageStart", function()
    RobberyReady()
end)

AddEvent("OnPlayerJoin", function(player)
    CallRemoteEvent(player, "robberySetup", robberyLocation[1], robberyLocation[2], robberyLocation[3])
end)

AddRemoteEvent("RobberyAction", function(player)
    if robberyStep == "notStarted" then
        StartRobbery(player)
    end

    if robberyStep == "pickup" then
        PickupMoney(player)
    end
end)

function StartRobbery(player)
    -- A player can't start a robbery without a weapon
    if GetPlayerEquippedWeapon(player) == 0 then
        CallRemoteEvent(player, "MakeErrorNotification", _("equiped_weapon_needed"))
    else
        -- If enough cops are present
        if EnoughCops() then
            RobberyStarted(player)
        else
            CallRemoteEvent(player, "MakeErrorNotification", _("not_enough_cops"))
        end
    end
end

function RobberyReady()
    robberyStep = "notStarted"
    bankRobberyPickup = CreatePickup(2, robberyLocation[1], robberyLocation[2], robberyLocation[3])
    bankRobberyText = CreateText3D(_("start_robbery").."\n".._("press_e"), 18, robberyLocation[1], robberyLocation[2], robberyLocation[3] + 100, 0, 0, 0)
end

-- START ROBBERY

function RobberyStarted(player)
    robberyStep = "started"
    DestroyPickup(bankRobberyPickup)
    DestroyText3D(bankRobberyText)

    CallRemoteEvent(player, "MakeSuccessNotification", _("robbery_started", timeBeforeGettingMoneyInMinutes))

    for k, v in pairs(workingCops) do
        CallRemoteEvent(k, "PoliceAlert", _("robbery_started_police"))
    end
    --CallRemoteEvent(player, "PlayAudioFile", "alarm.mp3")
    for k,v in pairs(GetAllPlayers()) do
        CallRemoteEvent(v, "RobberySoundAlarm")
    end

    Delay(timeBeforeGettingMoneyInMinutes * 60000, function (player)
        RobberyReadyToPickup(player)
    end)
end


function RobberyReadyToPickup(player)
    -- If noone take the money within 5 minutes
    Delay(timeBeforeMoneyDespawn * 60000, function (player)
        if robberyStep ~= "ended" then
            RobberyEnded()
        end
    end, player)
    
    robberyStep = "pickup"
    
    bankRobberyMoneyObject = CreateObject(517, robberyLocation[1], robberyLocation[2], robberyLocation[3] - 100)
    bankRobberyMoneyText = CreateText3D(_("get_robbery_money").."\n".._("press_e"), 18, robberyLocation[1], robberyLocation[2], robberyLocation[3], 0, 0, 0)
end

-- PICKUP MONEY

function PickupMoney(player)
    RobberyEnded()
    SetPlayerAnimation(player, 'PICKUP_LOWER')

    AddPlayerCash(player, cashForARobbery)
    -- Wait for animation
    Delay(1700, function (player)
        DestroyObject(bankRobberyMoneyObject)
        DestroyText3D(bankRobberyMoneyText)
    end)

    CallRemoteEvent(player, "MakeSuccessNotification", _("you_get_robbery_money", _("price_in_currency", cashForARobbery)))
end

-- ROBBERY IS READY

function RobberyEnded()
    robberyStep = "ended"
    
    for k,v in pairs(GetAllPlayers()) do
        CallRemoteEvent(v, "RobberyStopAlarm")
    end

    DestroyObject(bankRobberyMoneyObject)
    DestroyText3D(bankRobberyMoneyText)
    
    Delay(timeBeforeNewRobbery * 60000, RobberyReady)
end

-- HELPERS

function EnoughCops()
    local copsCount = 0
    workingCops = {}

    for playerId, player in pairs(PlayerData) do
        if player.job == "police" then
            table.insert(workingCops, playerId)
            copsCount = copsCount + 1
        end
    end
    return copsCount >= minumumCopsToStartARobbery
end