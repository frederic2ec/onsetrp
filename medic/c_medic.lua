local Dialog = ImportPackage("dialogui")
local _ = function(k, ...) return ImportPackage("i18n").t(GetPackageName(), k, ...) end

local IsOnDuty = false

local medicMenu
local medicNpcGarageMenu
local medicEquipmentMenu
local medicCalloutMenu

local medicNpcIds = {}
local medicVehicleNpcIds = {}
local medicGarageIds = {}
local medicEquipmentNpcIds = {}
local medicHospitalLocationIds = {}

local reviveScreenHUD
local isReviveScreen = false

AddRemoteEvent("medic:setup", function(_medicNpcIds, _medicVehicleNpcIds, _medicGarageIds, _medicEquipmentNpcIds, _medicHospitalLocationIds)
    medicNpcIds = _medicNpcIds
    medicVehicleNpcIds = _medicVehicleNpcIds
    medicGarageIds = _medicGarageIds
    medicEquipmentNpcIds = _medicEquipmentNpcIds
    medicHospitalLocationIds = _medicHospitalLocationIds
end)

AddRemoteEvent("medic:client:isonduty", function(isOnDuty)
    IsOnDuty = isOnDuty
end)


AddEvent("OnTranslationReady", function()
        -- MEDIC MENU : Gros soins, Mettre / sortir d'un véhicle, end callout
        medicMenu = Dialog.create(_("medic_menu"), nil, _("medic_menu_true_heal"), _("medic_menu_revive"), _("medic_menu_put_player_in_vehicle"), _("medic_menu_remove_player_from_vehicle"), _("callouts"), _("callouts_menu_end_callout"), _("cancel"))
        
        -- MEDIC NPC GARAGE MENU
        medicNpcGarageMenu = Dialog.create(_("medic_garage_menu"), nil, _("medic_garage_menu_spawn_ambulance"), _("cancel"))
        
        -- MEDIC EQUIPMENT MENU
        medicEquipmentMenu = Dialog.create(_("medic_equipment_menu"), nil, _("medic_equipment_menu_check_equipment"), _("cancel"))
end)

AddEvent("OnKeyPress", function(key)
        
        if key == JOB_MENU_KEY and not GetPlayerBusy() and IsOnDuty then
            Dialog.show(medicMenu)
        end
        
        if key == INTERACT_KEY and not GetPlayerBusy() and IsOnDuty and IsNearbyNpc(GetPlayerId(), medicVehicleNpcIds) ~= false then
            Dialog.show(medicNpcGarageMenu)
        end
        
        if key == INTERACT_KEY and not GetPlayerBusy() and IsOnDuty and IsNearbyNpc(GetPlayerId(), medicEquipmentNpcIds) ~= false then
            Dialog.show(medicEquipmentMenu)
        end
        
        if key == INTERACT_KEY and not GetPlayerBusy() and IsNearbyNpc(GetPlayerId(), medicNpcIds) ~= false then
            StartServiceConversation(IsNearbyNpc(GetPlayerId(), medicNpcIds))
        end
end)

AddEvent("OnHideMainMenu", function()
    if isReviveScreen then
        Delay(1, function()
            ShowMouseCursor(true)
            SetInputMode(INPUT_GAMEANDUI)
        end)
    end
end)


AddEvent("OnDialogSubmit", function(dialog, button, ...)
    local args = {...}
    if dialog == medicMenu then
        if button == 1 then -- heal
            CallRemoteEvent("medic:interact:heal")
        end
        if button == 2 then -- revive
            CallRemoteEvent("medic:interact:revive")
        end
        if button == 3 then -- put in vehicle
            CallRemoteEvent("medic:playerincar")
        end
        if button == 4 then -- remove from vehicle
            CallRemoteEvent("medic:removeplayerincar")
        end
        if button == 5 then -- take callout
            CallEvent("callouts:openingmenu")                        
        end
        if button == 6 then -- end callout
            CallEvent("callouts:stoppingcallout")            
        end
    end
    
    if dialog == medicNpcGarageMenu then
        if button == 1 then
            CallRemoteEvent("medic:spawnvehicle")
        end
    end
    
    if dialog == medicEquipmentMenu then
        if button == 1 then
            CallRemoteEvent("medic:checkmyequipment")
            MakeNotification(_("medic_equipment_checked"), "linear-gradient(to right, #00b09b, #96c93d)")
        end
    end
end)

function StartServiceConversation(npc)
    
    local message = (IsOnDuty and _("medic_service_npc_stop") or _("medic_service_npc_start"))
    startCinematic({
        title = _("medic_service_npc_name"),
        message = message,
        actions = {
            {
                text = _("yes"),
                callback = "medic:startstopcinematic"
            },
            {
                text = _("no"),
                close_on_click = true
            }
        }
    }, npc, "WAVE")
end

AddEvent("medic:startstopcinematic", function()
        
        local message = (IsOnDuty and _("medic_service_npc_end") or _("medic_service_npc_starting"))
        updateCinematic({
            message = message
        }, NearestPolice, "WALLLEAN04")
        Delay(1500, function()
            stopCinematic()
        end)
        CallRemoteEvent("medic:startstopservice")
end)

AddEvent("OnPackageStart", function()
    reviveScreenHUD = CreateWebUI(0, 0, 0, 0, 0, 60)
    SetWebAlignment(reviveScreenHUD, 1.0, 0.0)
    SetWebAnchors(reviveScreenHUD, 0.0, 0.0, 1.0, 1.0)
    LoadWebFile(reviveScreenHUD, "http://asset/onsetrp/medic/files/revivescreen.html")
    SetWebVisibility(reviveScreenHUD, WEB_HIDDEN)
end)

function ToggleReviveScreen(value)
    if value == true then
        SetWebVisibility(reviveScreenHUD, WEB_VISIBLE)
        ShowMouseCursor(true)
        SetInputMode(INPUT_GAMEANDUI)
        isReviveScreen = true
    else
        SetWebVisibility(reviveScreenHUD, WEB_HIDDEN)
        ShowMouseCursor(false)
        SetInputMode(INPUT_GAME)
        isReviveScreen = false
    end
end

function ToggleCallMedicBtn(value)
    ExecuteWebJS(reviveScreenHUD, "ToggleBtnCallMedic(" .. tonumber(value) .. ");")
end

AddRemoteEvent("medic:revivescreen:toggle", function(value)
    ToggleReviveScreen(value)
end)

AddRemoteEvent("medic:revivescreen:btncallmedic:toggle", function(value)
    ToggleCallMedicBtn(value)
end)

AddEvent("medic:revivescreen:giveup", function()
    ToggleReviveScreen(false)
    CallRemoteEvent("medic:giveup")
end)

AddEvent("medic:revivescreen:callmedic", function()
    CallRemoteEvent("medic:callout:create", GetPlayerId())
    ToggleCallMedicBtn(0)
    Delay(120000, function()
        ToggleCallMedicBtn(1)
    end)
end)

AddRemoteEvent("medic:deathalarm", function()
    local alarm = CreateSound("client/files/medicDeathAlarm.mp3")
    SetSoundVolume(alarm, 0.5)
    Delay(3000, function()
        DestroySound(alarm)        
    end)    
end)