local Dialog = ImportPackage("dialogui")
local _ = function(k, ...) return ImportPackage("i18n").t(GetPackageName(), k, ...) end

local IsOnDuty = false

local policeMenu
local policeFineMenu
local policeNpcGarageMenu
local policeEquipmentMenu

local policeNpcIds = {}
local policeVehicleNpcIds = {}
local policeGarageIds = {}
local policeEquipmentNpcIds = {}

AddRemoteEvent("police:setup", function(_policeNpcIds, _policeGarageIds, _policeVehicleNpcIds, _policeEquipmentNpcIds)
    policeNpcIds = _policeNpcIds
    policeGarageIds = _policeGarageIds
    policeVehicleNpcIds = _policeVehicleNpcIds
    policeEquipmentNpcIds = _policeEquipmentNpcIds
end)

AddRemoteEvent("police:client:isonduty", function(isOnDuty)
    IsOnDuty = isOnDuty
end)

AddEvent("OnTranslationReady", function()
        -- POLICE MENU
        policeMenu = Dialog.create(_("police_menu"), nil, _("handcuff_player"), _("put_player_in_vehicle"), _("remove_player_from_vehicle"), _("give_player_fine"),_("callouts"), _("call_police_mecano"), _("cancel"))
        
        -- FINE MENU
        policeFineMenu = Dialog.create(_("finePolice"), nil, _("give_fine"), _("cancel"))
        Dialog.addTextInput(policeFineMenu, 1, _("amount") .. " :")
        Dialog.addTextInput(policeFineMenu, 1, _("reason") .. " :")
        
        -- SPAWN VEHICLE MENU
        policeNpcGarageMenu = Dialog.create(_("police_garage_menu"), nil, _("spawn_despawn_patrol_car"), _("cancel"))

        -- POLICE EQUIPMENT MENU
        policeEquipmentMenu = Dialog.create(_("police_armory"), nil, _("police_check_my_equipment"), _("cancel"))
end)

AddEvent("OnKeyPress", function(key)
    
    if key == JOB_MENU_KEY and not GetPlayerBusy() and IsOnDuty then
        Dialog.show(policeMenu)
    end
    
    if key == "R" and IsCtrlPressed() and not GetPlayerBusy() and IsOnDuty then -- Fast handcuffing
        CallRemoteEvent("police:cuff")
    end
    
    if key == INTERACT_KEY and not GetPlayerBusy() and IsOnDuty and IsNearbyNpc(GetPlayerId(), policeVehicleNpcIds) ~= false then
        Dialog.show(policeNpcGarageMenu)
    end
    
    if key == INTERACT_KEY and not GetPlayerBusy() and IsNearbyNpc(GetPlayerId(), policeNpcIds) ~= false then
        AskForService(IsNearbyNpc(GetPlayerId(), policeNpcIds))
    end

    if key == INTERACT_KEY and not GetPlayerBusy() and IsOnDuty and IsNearbyNpc(GetPlayerId(), policeEquipmentNpcIds) ~= false then
        Dialog.show(policeEquipmentMenu)        
    end
end)

function AskForService(npc)
    
    local message = (IsOnDuty and _("police_npc_message_stop") or _("police_npc_message_start"))
    startCinematic({
        title = _("police_npc_name"),
        message = message,
        actions = {
            {
                text = _("yes"),
                callback = "police:startstopcinematic"
            },
            {
                text = _("no"),
                close_on_click = true
            }
        }
    }, NearestPolice, "SALUTE")
end

AddEvent("police:startstopcinematic", function()
    
    local message = (IsOnDuty and _("npc_end_stop") or _("police_npc_end_start"))
    updateCinematic({
        message = message
    }, NearestPolice, "WALLLEAN04")
    Delay(1500, function()
        stopCinematic()
    end)
    CallRemoteEvent("police:startstopservice")
end)

AddEvent("OnDialogSubmit", function(dialog, button, ...)
    local args = {...}
    if dialog == policeMenu then
        if button == 1 then
            CallRemoteEvent("police:cuff")
        end
        if button == 2 then
            CallRemoteEvent("police:playerincar")
        end
        if button == 3 then
            CallRemoteEvent("police:removeplayerincar")
        end
        if button == 4 then
            Dialog.show(policeFineMenu)
        end
        if button == 5 then       
            CallEvent("callouts:openingmenu")                        
        end
        if button == 6 then
            CallRemoteEvent("police:removevehicle")            
        end
    end
    
    if dialog == policeFineMenu then
        if button == 1 then
            if args[1] ~= "" then
                if tonumber(args[1]) > 0 then
                    CallRemoteEvent("police:fine", args[1], args[2])
                else
                    MakeNotification(_("enter_higher_number"), "linear-gradient(to right, #ff5f6d, #ffc371)")
                end
            else
                MakeNotification(_("valid_number"), "linear-gradient(to right, #ff5f6d, #ffc371)")
            end
        
        end
    end
    
    if dialog == policeNpcGarageMenu then
        if button == 1 then
            CallRemoteEvent("police:spawnvehicle")
        end
    end

    if dialog == policeEquipmentMenu then
        if button == 1 then
            CallRemoteEvent("police:checkmyequipment")
            MakeNotification(_("police_equipment_checked"), "linear-gradient(to right, #00b09b, #96c93d)")
        end
    end
end)

AddEvent("OnPlayerStartExitVehicle", function(vehicle)
    if (GetPlayerPropertyValue(GetPlayerId(), "cuffed")) then
        return false
    end
end)

AddEvent("OnPlayerStartEnterVehicle", function(vehicle)
    if (GetPlayerPropertyValue(GetPlayerId(), "cuffed")) then
        return false
    end
end)

function IsNearbyNpc(player, npcs)
    local x, y, z = GetPlayerLocation(player)
    for k, v in pairs(npcs) do
        local x2, y2, z2 = GetNPCLocation(v)
        if x2 ~= false and GetDistance3D(x, y, z, x2, y2, z2) <= 200 then return v end
    end
    return false
end

AddRemoteEvent("police:code3alarm", function()
    local alarm = CreateSound("client/files/policeAlertBank.mp3")
    SetSoundVolume(alarm, 0.5)
    Delay(2000, function()
        DestroySound(alarm)        
    end)    
end)

local wp = nil
AddRemoteEvent("police:waypoint", function(x,y,z)
    if wp ~= nil then DestroyWaypoint(wp) end    
    if tonumber(x) ~= nil and tonumber(y) ~= nil and tonumber(z) ~= nil then
        wp = CreateWaypoint(tonumber(x), tonumber(y), tonumber(z), _("police_robbery_in_progress"))    
    end
end)

AddRemoteEvent("police:delwaypoint", function()
    DestroyWaypoint(wp)
    wp = nil    
end)


