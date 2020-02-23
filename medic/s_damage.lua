local _ = function(k, ...) return ImportPackage("i18n").t(GetPackageName(), k, ...) end

local BLEEDING_CHANCE = 40 -- Chance for the player to bleed on damage
local INITIAL_DAMAGE_TO_BLEED = 1.5 -- how much the damages have to be divided by
local DAMAGE_PER_TICK = 1 -- the damages the player will take on each tick
local BLEEDING_DAMAGE_INTERVAL = 5000 -- The interval to apply damages
local BLEED_EFFECT_AMOUNT = 70 -- the amount of bleed effect (red flash)
local TASER_LOCK_DURATION = 10000
local TASER_EFFECT_DURATION = 20000

local BODY_Z = 50
local HEAD_Z = 150
local HEAD_Z_CROUCHING = 130

local HEADSHOT_BONUS = 20

local bleedingTimers = {}

AddEvent("OnPlayerDeath", function(player, instigator)
    CallRemoteEvent(player, "damage:death:toggleeffect", 1)
    CleanPlayerEffects(player)
end)

AddEvent("OnPlayerSpawn", function(player)
    CallRemoteEvent(player, "damage:death:toggleeffect", 0)
end)

AddEvent("OnPlayerWeaponShot", function(player, weapon, hittype, hitid, hitX, hitY, hitZ, startX, startY, normalX, normalY, normalZ)
    if hittype == 2 and weapon ~= 1 and weapon ~= 21 then -- Only for players with other weaps than fist and tazer
        -- GET PLAYER POS
        local x, y, z = GetPlayerLocation(hitid)
        -- GET PLAYER FEETS POS
        local feetPos = z - 90
        -- CROUCHING CASE
        local headZ = HEAD_Z
        local bodyZ = BODY_Z
        if GetPlayerMovementMode(hitid) == 4 then
            headZ = HEAD_Z_CROUCHING
        end
        -- APPLY MORE DMG WHEN HEADSHOT
        if hitZ > feetPos + headZ then 
            SetPlayerHealth(hitid, GetPlayerHealth(hitid) - HEADSHOT_BONUS)            
        end
    end    
    if hittype == 2 and weapon == 21 then
        ApplyTaserEffect(hitid)
    end
end)

AddEvent("OnPlayerDamage", function(player, damagetype, amount)
    if GetPlayerHealth(player) > 0 and damagetype == 1 and amount > 10 then
        math.randomseed(os.time())
        local lucky = math.random(100)
        if lucky <= BLEEDING_CHANCE then
            ApplyBleeding(player, amount)
        end
    end
end)

function ApplyTaserEffect(player)
    SetPlayerRagdoll(player, true)-- Makes player ragdoll
    CallRemoteEvent(player, "LockControlMove", true)
    CallRemoteEvent(player, "damage:taser:starteffect", TASER_EFFECT_DURATION)
    Delay(TASER_LOCK_DURATION, function()-- Waits 6 seconds before the player can stand up again
        SetPlayerRagdoll(player, false)-- Disables the ragdoll so he can walk again.
        SetPlayerAnimation(player, "PUSHUP_END")
        CallRemoteEvent(player, "LockControlMove", false)
        Delay(2000, function()
            CallEvent("police:refreshcuff", player)
        end)
    end)
end

function ApplyBleeding(player, damageAmount)
    local damages = (tonumber(damageAmount) / INITIAL_DAMAGE_TO_BLEED)
    local bleedingTime = math.ceil(damages / DAMAGE_PER_TICK)-- calculate the amount of time while the player will bleed
    
    -- Reset timer if another bleed occur
    if bleedingTimers[player] ~= nil then
        DestroyTimer(bleedingTimers[player].timer)
    end
    bleedingTimers[player] = {}
    
    CallRemoteEvent(player, "damage:bleed:toggleeffect", 1)
    
    local i = 0
    bleedingTimers[player].timer = CreateTimer(function()
        if i >= bleedingTime or GetPlayerHealth(player) < 1 then -- end is reached
            if GetPlayerHealth(player) > 0 then
                CallRemoteEvent(player, "damage:bleed:toggleeffect", 0)
            end
            DestroyTimer(bleedingTimers[player].timer)
            bleedingTimers[player] = nil
            return
        end
        i = i + 1
        SetPlayerHealth(player, GetPlayerHealth(player) - DAMAGE_PER_TICK)
        CallRemoteEvent(player, "damage:bleed:tickeffect", BLEED_EFFECT_AMOUNT)
        for k, v in pairs(GetStreamedPlayersForPlayer(player)) do
            if IsValidPlayer(v) then
                CallRemoteEvent(v, "damage:bleed:dropblood", player)
            end
        end
    end, BLEEDING_DAMAGE_INTERVAL)
end

function CleanPlayerEffects(player)
    if bleedingTimers[player] and bleedingTimers[player].timer then
        DestroyTimer(bleedingTimers[player].timer)
        bleedingTimers[player] = nil
    end
end
AddEvent("OnPlayerQuit", CleanPlayerEffects)

function IsPlayerBleeding(player)
    if bleedingTimers[player] ~= nil and bleedingTimers[player].timer ~= nil then
        return true
    end
    return false
end

function StopBleedingForPlayer(player)
    if bleedingTimers[player] ~= nil and bleedingTimers[player].timer ~= nil then
        DestroyTimer(bleedingTimers[player].timer)
        bleedingTimers[player] = nil
    end
end
