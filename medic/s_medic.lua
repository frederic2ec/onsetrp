local _ = function(k, ...) return ImportPackage("i18n").t(GetPackageName(), k, ...) end

local MAX_MEDIC = 20
local ALLOW_RESPAWN_VEHICLE = true
local TIMER_RESPAWN_WAITER = 1800 -- 30 minutes
local REVIVE_PERCENT_SUCCESS = 33 -- in percent
local TIME_TO_REVIVE = 15 -- in seconds
local AUTO_CALL_FOR_MEDIC = false
local TIME_TO_HEAL = 5 -- in seconds
local AMOUNT_TO_HEAL_PER_INTERACTION = 20 -- Hp that will be healed each time the medic interact

local DEFAULT_RESPAWN_POINT = {x = 212124, y = 159055, z = 1305, h = 90}

local VEHICLE_SPAWN_LOCATION = {
    {x = 213325, y = 161177, z = 1305, h = -90},
}

local MEDIC_SERVICE_NPC = {
    {x = 212493, y = 157096, z = 2780, h = 180},
}

local MEDIC_VEHICLE_NPC = {
    {x = 212571, y = 159486, z = 1320, h = 90},
}

local MEDIC_GARAGE = {
    {x = 215766, y = 161131, z = 1305},
}

local MEDIC_EQUIPMENT_NPC = {
    {x = 212744, y = 157405, z = 2781, h = -90},
}

local MEDIC_HOSPITAL_LOCATION = {
    {x = 213079, y = 155179, radius = 2000}
}

local MEDIC_EQUIPEMENT_NEEDED = {
    {item = "defibrillator", qty = 1},
    {item = "adrenaline_syringe", qty = 2},
    {item = "bandage", qty = 5},
    {item = "health_kit", qty = 1},
}

local ITEM_MEDKIT_HEAL = 10
local ITEM_MEDKIT_MAX_HEAL = 30
local ITEM_ADRENALINE_SYRINGE_HEAL = 20
local ITEM_TIME_TO_USE = 5

local medicNpcIds = {}
local medicVehicleNpcIds = {}
local medicGarageIds = {}
local medicEquipmentNpcIds = {}
local medicHospitalLocationIds = {}



AddEvent("OnPackageStart", function()
    for k, v in pairs(MEDIC_SERVICE_NPC) do
        v.npcObject = CreateNPC(v.x, v.y, v.z, v.h)
        
        table.insert(medicNpcIds, v.npcObject)
    end
    
    if ALLOW_RESPAWN_VEHICLE then
        for k, v in pairs(MEDIC_GARAGE) do
            v.garageObject = CreatePickup(2, v.x, v.y, v.z)
            table.insert(medicGarageIds, v.garageObject)
        end
    end
    
    for k, v in pairs(MEDIC_VEHICLE_NPC) do
        v.npcObject = CreateNPC(v.x, v.y, v.z, v.h)
        SetNPCAnimation(v.npcObject, "WALLLEAN04", true)
        table.insert(medicVehicleNpcIds, v.npcObject)
    end
    
    for k, v in pairs(MEDIC_EQUIPMENT_NPC) do
        v.npcObject = CreateNPC(v.x, v.y, v.z, v.h)
        SetNPCAnimation(v.npcObject, "WALLLEAN04", true)
        table.insert(medicEquipmentNpcIds, v.npcObject)
    end
end)

AddEvent("OnPlayerJoin", function(player)
    CallRemoteEvent(player, "medic:setup", medicNpcIds, medicVehicleNpcIds, medicGarageIds, medicEquipmentNpcIds, medicHospitalLocationIds)
end)

--------- SERVICE AND EQUIPMENT
function MedicStartStopService(player)-- toggle service
    if PlayerData[player].job == "" then
        MedicStartService(player)
    elseif PlayerData[player].job == "medic" then
        MedicEndService(player)
    else
        CallRemoteEvent(player, "MakeErrorNotification", _("please_leave_previous_job"))
    end
end
AddRemoteEvent("medic:startstopservice", MedicStartStopService)

function MedicStartService(player)-- start service
    -- #1 Check for the medic whitelist of the player
    if PlayerData[player].medic ~= 1 then
        CallRemoteEvent(player, "MakeErrorNotification", _("not_whitelisted"))
        return
    end
    
    -- #2 Check if the player has a job vehicle spawned then destroy it
    if PlayerData[player].job_vehicle ~= nil then
        DestroyVehicle(PlayerData[player].job_vehicle)
        DestroyVehicleData(PlayerData[player].job_vehicle)
        PlayerData[player].job_vehicle = nil
    end
    
    -- #3 Check for the number of medics in service
    local medics = 0
    for k, v in pairs(PlayerData) do
        if v.job == "medic" then medics = medics + 1 end
    end
    if medics >= MAX_MEDIC then
        CallRemoteEvent(player, "MakeErrorNotification", _("job_full"))
        return
    end
    
    -- #4 Set the player job to medic, update the cloths, give equipment
    PlayerData[player].job = "medic"
    CallRemoteEvent(player, "medic:client:isonduty", true)
    
    -- CLOTHINGS
    GiveMedicEquipmentToPlayer(player)
    UpdateClothes(player)
    CallRemoteEvent(player, "MakeNotification", _("medic_start_service"), "linear-gradient(to right, #00b09b, #96c93d)")
    return true
end

function MedicEndService(player)-- stop service
    -- #1 Remove medic equipment
    RemoveMedicEquipmentToPlayer(player)
    if PlayerData[player].job_vehicle ~= nil then
        DestroyVehicle(PlayerData[player].job_vehicle)
        DestroyVehicleData(PlayerData[player].job_vehicle)
        PlayerData[player].job_vehicle = nil
    end
    -- #2 Set player job
    PlayerData[player].job = ""
    CallRemoteEvent(player, "medic:client:isonduty", false)
    -- #3 Trigger update of cloths
    UpdateClothes(player)
    
    CallRemoteEvent(player, "MakeNotification", _("medic_end_service"), "linear-gradient(to right, #00b09b, #96c93d)")
    
    return true
end

function GiveMedicEquipmentToPlayer(player)-- To give medic equipment to medics
    if PlayerData[player].job == "medic" and PlayerData[player].medic == 1 then -- Fail check
        for k, v in pairs(MEDIC_EQUIPEMENT_NEEDED) do
            SetInventory(player, v.item, v.qty)
        end
    end
end
AddRemoteEvent("medic:checkmyequipment", GiveMedicEquipmentToPlayer)

function RemoveMedicEquipmentToPlayer(player)-- remove equipment from a medic
    for k, v in pairs(MEDIC_EQUIPEMENT_NEEDED) do
        SetInventory(player, v.item, 0)
    end
end

AddEvent("job:onspawn", function(player)-- when player is fully loaded
    if PlayerData[player].job == "medic" and PlayerData[player].medic == 1 then -- Anti glitch
        CallRemoteEvent(player, "medic:client:isonduty", true)
    end
    
    if PlayerData[player].health ~= nil then
        SetPlayerHealth(player, PlayerData[player].health)
        if GetPlayerHealth(player) < 1 then
            SetPlayerRagdoll(player, true)
        end
    end
end)

AddEvent("OnPlayerSpawn", function(player)-- On player death
    CallRemoteEvent(player, "medic:revivescreen:toggle", false)
    SetPlayerNotBusy(player)
    SetPlayerRagdoll(player, false)
    if PlayerData and PlayerData[player] then
        if PlayerData[player].has_been_revived == false or PlayerData[player].has_been_revived == nil then -- Clean inv
            PlayerData[player].inventory = {}
            SetPlayerCuffed(player, false)
        end
        GiveMedicEquipmentToPlayer(player)
    end
end)
--------- SERVICE AND EQUIPMENT END
--------- MEDIC VEHICLE
function SpawnMedicCar(player)-- to spawn an ambulance
    -- #1 Check for the medic whitelist of the player
    if PlayerData[player].medic ~= 1 then
        CallRemoteEvent(player, "MakeErrorNotification", _("not_whitelisted"))
        return
    end
    if PlayerData[player].job ~= "medic" then
        CallRemoteEvent(player, "MakeErrorNotification", _("not_medic"))
        return
    end
    
    -- #2 Check if the player has a job vehicle spawned then destroy it
    if PlayerData[player].job_vehicle ~= nil and ALLOW_RESPAWN_VEHICLE then
        DestroyVehicle(PlayerData[player].job_vehicle)
        DestroyVehicleData(PlayerData[player].job_vehicle)
        PlayerData[player].job_vehicle = nil
    end
    
    -- #3 Try to spawn the vehicle
    if PlayerData[player].job_vehicle == nil then
        local spawnPoint = VEHICLE_SPAWN_LOCATION[MedicGetClosestSpawnPoint(player)]
        if spawnPoint == nil then return end
        for k, v in pairs(GetStreamedVehiclesForPlayer(player)) do
            local x, y, z = GetVehicleLocation(v)
            if x == false then break end
            local dist2 = GetDistance3D(spawnPoint.x, spawnPoint.y, spawnPoint.z, x, y, z)
            if dist2 < 500.0 then
                CallRemoteEvent(player, "MakeErrorNotification", _("cannot_spawn_vehicle"))
                return
            end
        end
        local vehicle = CreateVehicle(8, spawnPoint.x, spawnPoint.y, spawnPoint.z, spawnPoint.h)
        
        PlayerData[player].job_vehicle = vehicle
        CreateVehicleData(player, vehicle, 3)
        SetVehicleRespawnParams(vehicle, false)
        SetVehiclePropertyValue(vehicle, "locked", true, true)
        CallRemoteEvent(player, "MakeNotification", _("spawn_vehicle_success", _("medic_car")), "linear-gradient(to right, #00b09b, #96c93d)")
    else
        CallRemoteEvent(player, "MakeErrorNotification", _("cannot_spawn_vehicle"))
    end
end
AddRemoteEvent("medic:spawnvehicle", SpawnMedicCar)

function DespawnMedicCar(player)-- to despawn an ambulance
    -- #2 Check if the player has a job vehicle spawned then destroy it
    if PlayerData[player].job_vehicle ~= nil then
        DestroyVehicle(PlayerData[player].job_vehicle)
        DestroyVehicleData(PlayerData[player].job_vehicle)
        PlayerData[player].job_vehicle = nil
        CallRemoteEvent(player, "MakeNotification", _("vehicle_stored"), "linear-gradient(to right, #00b09b, #96c93d)")
        return
    end
end

AddEvent("OnPlayerPickupHit", function(player, pickup)-- Store the vehicle in garage
    if PlayerData[player].medic ~= 1 then return end
    if PlayerData[player].job ~= "medic" then return end
    for k, v in pairs(MEDIC_GARAGE) do
        if v.garageObject == pickup then
            local vehicle = GetPlayerVehicle(player)
            if vehicle == nil then return end
            local seat = GetPlayerVehicleSeat(player)
            if vehicle == PlayerData[player].job_vehicle and
                VehicleData[vehicle].owner == PlayerData[player].accountid and
                seat == 1
            then
                DespawnMedicCar(player)
            end
        end
    end
end)
--------- MEDIC VEHICLE END
--------- INTERACTIONS
function MedicPutPlayerInCar(player)-- to put player in car
    if PlayerData[player].medic ~= 1 then return end
    if PlayerData[player].job ~= "medic" then return end
    
    local target = GetNearestPlayer(player, 200)
    if target ~= nil then
        MedicSetPlayerInCar(player, target)
    end
end
AddRemoteEvent("medic:playerincar", MedicPutPlayerInCar)

function MedicSetPlayerInCar(player, target)-- put player in car
    if PlayerData[player].job_vehicle == nil then return end
    local x, y, z = GetVehicleLocation(PlayerData[player].job_vehicle)
    local x2, y2, z2 = GetPlayerLocation(target)
    
    if GetDistance3D(x, y, z, x2, y2, z2) <= 400 then
        if GetVehiclePassenger(PlayerData[player].job_vehicle, 3) == 0 then -- First back seat
            SetPlayerInVehicle(target, PlayerData[player].job_vehicle, 3)
            CallRemoteEvent(player, "MakeNotification", _("mediccar_place_player_in_back"), "linear-gradient(to right, #00b09b, #96c93d)")
        elseif GetVehiclePassenger(PlayerData[player].job_vehicle, 4) == 0 then -- Second back seat
            SetPlayerInVehicle(target, PlayerData[player].job_vehicle, 4)
            CallRemoteEvent(player, "MakeNotification", _("mediccar_place_player_in_back"), "linear-gradient(to right, #00b09b, #96c93d)")
        else -- All seats are busy
            CallRemoteEvent(player, "MakeErrorNotification", _("mediccar_no_more_seat"))
        end
    else -- Too far away
        CallRemoteEvent(player, "MakeErrorNotification", _("mediccar_too_far_away"))
    end
end

function MedicRemovePlayerInCar(player)-- remove player from car
    if PlayerData[player].medic ~= 1 then return end
    if PlayerData[player].job ~= "medic" then return end
    if PlayerData[player].job_vehicle == nil then return end
    
    local x, y, z = GetVehicleLocation(PlayerData[player].job_vehicle)
    local x2, y2, z2 = GetPlayerLocation(player)
    
    if GetDistance3D(x, y, z, x2, y2, z2) <= 200 then
        if GetVehiclePassenger(PlayerData[player].job_vehicle, 3) ~= 0 then -- First back seat
            RemovePlayerFromVehicle(GetVehiclePassenger(PlayerData[player].job_vehicle, 3))
        end
        if GetVehiclePassenger(PlayerData[player].job_vehicle, 4) ~= 0 then -- Second back seat
            RemovePlayerFromVehicle(GetVehiclePassenger(PlayerData[player].job_vehicle, 4))
        end
        CallRemoteEvent(player, "MakeNotification", _("mediccar_player_remove_from_car"), "linear-gradient(to right, #00b09b, #96c93d)")
    end
end
AddRemoteEvent("medic:removeplayerincar", MedicRemovePlayerInCar)

function MedicRevivePlayer(player)-- To revive a player. can fail. need defib.
    if PlayerData[player].medic ~= 1 then return end
    if PlayerData[player].job ~= "medic" then return end
    if GetPlayerBusy(player) then return end
    
    local nearestPlayer = GetNearestPlayer(player, 200)-- Get closest player in range
    if nearestPlayer == nil or nearestPlayer == 0 then
        CallRemoteEvent(player, "MakeErrorNotification", _("medic_nobody_nearby"))
        return
    end
    if GetPlayerHealth(nearestPlayer) > 0 then -- Cehck HP
        CallRemoteEvent(player, "MakeErrorNotification", _("medic_nobody_is_dead"))
        return
    end
    
    if GetNumberOfItem(player, "defibrillator") < 1 then -- Check defib in inventory
        CallRemoteEvent(player, "MakeErrorNotification", _("medic_defibrillator_needed"))
        return
    end
    
    -- Lock player while he's acting
    CallRemoteEvent(player, "LockControlMove", true)
    SetPlayerBusy(player)
    
    CallRemoteEvent(player, "loadingbar:show", _("medic_revive_attempt"), TIME_TO_REVIVE)-- LOADING BAR
    SetPlayerAnimation(player, "REVIVE")
    local timer = CreateTimer(function()
        SetPlayerAnimation(player, "REVIVE")
    end, 4000)
    
    Delay(TIME_TO_REVIVE * 1000, function()
        DestroyTimer(timer)
        SetPlayerAnimation(player, "STOP")
        
        -- Unlock player
        CallRemoteEvent(player, "LockControlMove", false)
        SetPlayerNotBusy(player)
        
        math.randomseed(os.time())
        local lucky = math.random(100)
        if lucky > REVIVE_PERCENT_SUCCESS then -- Success !
            local x, y, z = GetPlayerLocation(nearestPlayer)
            local h = GetPlayerHeading(nearestPlayer)
            SetPlayerSpawnLocation(nearestPlayer, x, y, z, h)
            PlayerData[nearestPlayer].has_been_revived = true
            SetPlayerRespawnTime(nearestPlayer, 0)
            Delay(100, function()
                SetPlayerHealth(nearestPlayer, 1.0)
                PlayerData[nearestPlayer].health = 1
            end)
            
            CallRemoteEvent(nearestPlayer, "medic:revivescreen:toggle", false)
            CallRemoteEvent(player, "MakeNotification", _("medic_revived_success"), "linear-gradient(to right, #00b09b, #96c93d)")            
            return
        else -- Failure !
            CallRemoteEvent(player, "MakeErrorNotification", _("medic_revived_failure"))
            return
        end
    end)
end
AddRemoteEvent("medic:interact:revive", MedicRevivePlayer)

function MedicTruelyHealPlayer(player)-- To really heal a player. This need to be at the hospital.
    if PlayerData[player].medic ~= 1 then return end
    if PlayerData[player].job ~= "medic" then return end
    if GetPlayerBusy(player) then return end
    
    local nearestPlayer = GetNearestPlayer(player, 200)-- Get closest player in range
    if nearestPlayer == nil or nearestPlayer == 0 then
        CallRemoteEvent(player, "MakeErrorNotification", _("medic_nobody_nearby"))
        return
    end
    
    if not IsHospitalInRange(player) or not IsHospitalInRange(tonumber(nearestPlayer)) then
        CallRemoteEvent(player, "MakeErrorNotification", _("medic_hospital_needed_to_heal"))
        return
    end
    
    if GetPlayerHealth(nearestPlayer) >= 100 then -- Cehck HP
        CallRemoteEvent(player, "MakeErrorNotification", _("medic_player_is_fullhp"))
        return
    end
    
    -- Lock player while he's healing
    SetPlayerBusy(player)
    
    CallRemoteEvent(player, "loadingbar:show", _("medic_healing_in_progress"), TIME_TO_HEAL)-- LOADING BAR
    SetPlayerAnimation(player, "HANDSHAKE")
    local timer = CreateTimer(function()
        SetPlayerAnimation(player, "HANDSHAKE")
    end, 4000)
    
    Delay(TIME_TO_HEAL * 1000, function()
        DestroyTimer(timer)
        SetPlayerAnimation(player, "STOP")
        
        -- Unlock player
        SetPlayerNotBusy(player)
        
        SetPlayerHealth(nearestPlayer, GetPlayerHealth(nearestPlayer) + 20)
        if GetPlayerHealth(nearestPlayer) > 100 then
            SetPlayerHealth(nearestPlayer, 100)
        end
        PlayerData[nearestPlayer].health = GetPlayerHealth(nearestPlayer)
        
        CallRemoteEvent(player, "MakeNotification", _("medic_done_healing"), "linear-gradient(to right, #00b09b, #96c93d)")
        return
    end)
end
AddRemoteEvent("medic:interact:heal", MedicTruelyHealPlayer)

--------- INTERACTIONS END
--------- HEALTH BEHAVIOR
AddEvent("OnPlayerDeath", function(player, instigator)-- do some stuff when player die
    SetPlayerSpawnLocation(player, DEFAULT_RESPAWN_POINT.x, DEFAULT_RESPAWN_POINT.y, DEFAULT_RESPAWN_POINT.z, DEFAULT_RESPAWN_POINT.h)-- HOSPITAL
    
    SetPlayerRespawnTime(player, TIMER_RESPAWN_WAITER * 1000)
    CallRemoteEvent(player, "medic:revivescreen:toggle", true)
    
    if GetMedicsOnDuty(player) > 0 then
        if AUTO_CALL_FOR_MEDIC == true then CreateMedicCallout(player) end
        
         CallRemoteEvent(player, "medic:revivescreen:btncallmedic:toggle", 1)
    else
        CallRemoteEvent(player, "medic:revivescreen:btncallmedic:toggle", 0)
    end
    
    SetPlayerBusy(player)
    PlayerData[player].has_been_revived = false
end)

function CreateMedicCallout(player)
    CreateCallout(player, "medic", "Coma")
end
AddRemoteEvent("medic:callout:create", CreateMedicCallout)

AddCommand("suicide", function(player)
    SetPlayerHealth(player, 0)    
end)

AddRemoteEvent("medic:giveup", function(player)
    PlayerData[player].has_been_revived = false
    SetPlayerRespawnTime(player, 0)
end)

AddEvent("OnPlayerStreamIn", function(player, otherplayer)
    if GetPlayerHealth(otherplayer) < 1 then
        SetPlayerRagdoll(otherplayer, true)
    end
end)


--------- HEALTH BEHAVIOR END

--------- ITEMS USES
function MedicUseItem(player, item)
    if item == "health_kit" then -- PERSONNAL HEALTH KIT (Dont need to be medic)
        if GetPlayerHealth(player) < ITEM_MEDKIT_MAX_HEAL then
            CallRemoteEvent(player, "loadingbar:show", _("medic_item_use", _("health_kit")), ITEM_TIME_TO_USE)-- LOADING BAR
            SetPlayerAnimation(player, "COMBINE")
            local timer = CreateTimer(function()
                SetPlayerAnimation(player, "COMBINE")
            end, 2000)
            
            Delay(ITEM_TIME_TO_USE * 1000, function()
                DestroyTimer(timer)
                SetPlayerAnimation(player, "STOP")
                SetPlayerHealth(player, GetPlayerHealth(player) + ITEM_MEDKIT_HEAL)
                if GetPlayerHealth(player) > ITEM_MEDKIT_MAX_HEAL then SetPlayerHealth(player, ITEM_MEDKIT_MAX_HEAL) end
                PlayerData[player].health = GetPlayerHealth(player)
                RemoveInventory(player, item, 1)
                CallRemoteEvent(player, "MakeNotification", _("medic_item_health_kit_success"), "linear-gradient(to right, #00b09b, #96c93d)")
            end)
        else
            CallRemoteEvent(player, "MakeErrorNotification", _("medic_item_health_kit_cant_do_more"))
        end
    end
    
    if PlayerData[player].medic ~= 1 then return end
    if PlayerData[player].job ~= "medic" then return end
    -- THE FOLLOWING NEED A MEDIC
    if item == "adrenaline_syringe" then -- ADRENALINE SYRINGUE TO SAVE OTHER PLAYER FROM DEATH
        local nearestPlayer = GetNearestPlayer(player, 200)-- Get closest player in range
        if nearestPlayer == nil or nearestPlayer == 0 then
            CallRemoteEvent(player, "MakeErrorNotification", _("medic_nobody_nearby"))
            return
        end
        if GetPlayerHealth(nearestPlayer) < ITEM_ADRENALINE_SYRINGE_HEAL then
            CallRemoteEvent(player, "loadingbar:show", _("medic_item_use", _("adrenaline_syringe")), ITEM_TIME_TO_USE)-- LOADING BAR
            SetPlayerAnimation(player, "COMBINE")
            local timer = CreateTimer(function()
                SetPlayerAnimation(player, "COMBINE")
            end, 2000)
            
            Delay(ITEM_TIME_TO_USE * 1000, function()
                DestroyTimer(timer)
                SetPlayerAnimation(player, "STOP")
                SetPlayerHealth(nearestPlayer, ITEM_ADRENALINE_SYRINGE_HEAL)
                PlayerData[player].health = GetPlayerHealth(nearestPlayer)
                RemoveInventory(player, item, 1)
                CallRemoteEvent(player, "MakeNotification", _("medic_item_adrenaline_syringue_success"), "linear-gradient(to right, #00b09b, #96c93d)")
            end)
        else
            CallRemoteEvent(player, "MakeErrorNotification", _("medic_item_adrenaline_syringue_not_needed"))
        end
    end
    
    if item == "bandage" then -- BANDAGE TO REMOVE A BLEEDING FROM A PLAYER
        local nearestPlayer = GetNearestPlayer(player, 200)-- Get closest player in range
        if nearestPlayer == nil or nearestPlayer == 0 then
            CallRemoteEvent(player, "MakeErrorNotification", _("medic_nobody_nearby"))
            return
        end
        if IsPlayerBleeding(nearestPlayer) then
            CallRemoteEvent(player, "loadingbar:show", _("medic_item_use", _("bandage")), ITEM_TIME_TO_USE)-- LOADING BAR
            SetPlayerAnimation(player, "COMBINE")
            local timer = CreateTimer(function()
                SetPlayerAnimation(player, "COMBINE")
            end, 2000)
            
            Delay(ITEM_TIME_TO_USE * 1000, function()
                DestroyTimer(timer)
                SetPlayerAnimation(player, "STOP")
                StopBleedingForPlayer(nearestPlayer)
                RemoveInventory(player, item, 1)
                CallRemoteEvent(nearestPlayer, "damage:bleed:toggleeffect", 0)
                CallRemoteEvent(player, "MakeNotification", _("medic_item_bandage_success"), "linear-gradient(to right, #00b09b, #96c93d)")
            end)
        else
            CallRemoteEvent(player, "MakeErrorNotification", _("medic_item_bandage_not_needed"))
        end
    end

end
AddEvent("job:usespecialitem", MedicUseItem)

--------- ITEMS USES END
-- Tools
function MedicGetClosestSpawnPoint(player)-- get closeest spawn point for vehicle
    local x, y, z = GetPlayerLocation(player)
    local closestSpawnPoint
    local dist
    for k, v in pairs(VEHICLE_SPAWN_LOCATION) do
        local currentDist = GetDistance3D(x, y, z, v.x, v.y, v.z)
        if (dist == nil or currentDist < dist) and currentDist <= 2000 then
            closestSpawnPoint = k
            dist = currentDist
        end
    end
    return closestSpawnPoint
end

function GetMedicsOnDuty(player)-- numbers of medics on duty
    local nb = 0
    for k, v in pairs(GetAllPlayers()) do
        if PlayerData[v] and PlayerData[v].job == "medic" and v ~= player then
            nb = nb + 1
        end
    end
    return nb
end

function IsHospitalInRange(player)-- to nknow if player and targets are in range from hospital
    local x, y, z = GetPlayerLocation(player)
    for k, v in pairs(MEDIC_HOSPITAL_LOCATION) do
        if GetDistance2D(x, y, v.x, v.y) <= v.radius then
            return true
        end
    end
    return false
end


AddCommand("medtest", function(player)
    if PlayerData[player].admin ~= 1 then return end
    local veh = GetPlayerVehicle(player)    
    SetVehicleTrunkRatio(veh, 90)
end)
