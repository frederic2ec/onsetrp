local Dialog = ImportPackage("dialogui")
local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local adminMenu
local teleportMenu
local teleportPlaceMenu
local teleportToPlayereMenu
local teleportPlayerMenu
local weaponMenu
local vehicleMenu
local moneyMenu
local banMenu
local logMenu
local itemMenu
local broadcastMenu

local broadcastUi

AddEvent("OnPackageStart", function()
    broadcastUi = CreateWebUI(0, 0, 0, 0, 0, 60)
    SetWebAlignment(broadcastUi, 1.0, 0.0)
    SetWebAnchors(broadcastUi, 0.0, 0.0, 1.0, 1.0)
    LoadWebFile(broadcastUi, "http://asset/onsetrp/admin/broadcastui/broadcastui.html")
    SetWebVisibility(broadcastUi, WEB_VISIBLE)
end)

AddEvent("OnTranslationReady", function()
    adminMenu = Dialog.create(_("admin_menu"), nil, _("teleportation"), _("weapon"), _("vehicle"), _("money"),_("items"), _("ban_kick"), _("log"),_("broadcast"),_("cancel"))
    teleportMenu = Dialog.create(_("teleport_menu"), nil, _("teleport_to_place"), _("teleport_to_player"), _("teleport_player"), _("cancel"))
    teleportPlaceMenu = Dialog.create(_("teleport_to_place"), nil, _("teleport"), _("cancel"))
    Dialog.addSelect(teleportPlaceMenu, 1, _("place"), 8)
    teleportToPlayereMenu = Dialog.create(_("teleport_to_player"), nil, _("teleport"), _("cancel"))
    Dialog.addSelect(teleportToPlayereMenu, 1, _("player"), 8)
    teleportPlayerMenu = Dialog.create(_("teleport_player"), nil, _("teleport"), _("cancel"))
    Dialog.addSelect(teleportPlayerMenu, 1, _("player"), 8)
    weaponMenu = Dialog.create(_("weapon_menu"), nil, _("give"), _("cancel"))
    Dialog.addSelect(weaponMenu, 1, _("weapons"), 8)
    vehicleMenu = Dialog.create(_("vehicle_menu"), nil, _("spawn"), _("cancel"))
    Dialog.addSelect(vehicleMenu, 1, _("vehicle_list"), 8)
    moneyMenu = Dialog.create(_("money_menu"), nil, _("give_bank"), _("give_cash"), _("cancel"))
    Dialog.addSelect(moneyMenu, 1, _("player"), 8)
    Dialog.addTextInput(moneyMenu, 1, _("amount"))
    itemMenu = Dialog.create(_("item_menu"), nil, _("give"), _("cancel"))
    Dialog.addSelect(itemMenu, 1, _("player"), 8)
    Dialog.addSelect(itemMenu, 2, _("items"), 12)
    Dialog.addTextInput(itemMenu, 1, _("amount"))
    banMenu = Dialog.create(_("ban_menu"), nil, _("ban"), _("kick"), _("cancel"))
    Dialog.addSelect(banMenu, 1, _("player"), 8)
    Dialog.addTextInput(banMenu, 1, _("reason"))
    logMenu = Dialog.create(_("log_menu"), nil, _("cancel"))
    Dialog.addSelect(logMenu, 1, _("log"), 12)
    broadcastMenu = Dialog.create(_("broadcast"), nil, _("send"), _("cancel"))
    Dialog.addTextInput(broadcastMenu, 1, _("text_to_send"))
    Dialog.addTextInput(broadcastMenu, 1, _("display_time"))
end)


AddEvent("OnKeyPress", function(key)
    if key == ADMIN_MENU_KEY and not GetPlayerBusy() then
        CallRemoteEvent("ServerAdminMenu") 
    end
end)

AddEvent("OnDialogSubmit", function(dialog, button, ...)
    local args = { ... }

	if dialog == adminMenu then
		if button == 1 then
			Dialog.show(teleportMenu)
        end
        if button == 2 then
            Dialog.show(weaponMenu)
        end
        if button == 3 then
            Dialog.show(vehicleMenu)
        end
        if button == 4 then
            Dialog.show(moneyMenu)
        end
        if button == 5 then
            --Dialog.show(itemMenu)
            CallRemoteEvent("admin:menu:getitemlist")            
        end
        if button == 6 then
            Dialog.show(banMenu)
        end
        if button == 7 then
            Dialog.show(logMenu)
        end
        if button == 8 then -- broadcast
            CallRemoteEvent("account:setplayerbusy")   
            SetIgnoreMoveInput(true)         
            Dialog.show(broadcastMenu)
        end
    end
    if dialog == teleportMenu then 
        if button == 1 then
            Dialog.show(teleportPlaceMenu)
        end
        if button == 2 then
            Dialog.show(teleportToPlayereMenu)
        end
        if button == 3 then
            Dialog.show(teleportPlayerMenu)
        end
    end
    if dialog == teleportPlaceMenu then
        if button == 1 then
            if args[1] == "" then
                MakeNotification(_("select_place"), "linear-gradient(to right, #ff5f6d, #ffc371)")
            else
                CallRemoteEvent("AdminTeleportToPlace", args[1])
            end
        end
    end
    if dialog == teleportToPlayereMenu then
        if button == 1 then
            if args[1] == "" then
                MakeNotification(_("select_player"), "linear-gradient(to right, #ff5f6d, #ffc371)")
            else
                CallRemoteEvent("AdminTeleportToPlayer", args[1])
            end
        end
    end
    if dialog == teleportPlayerMenu then
        if button == 1 then
            if args[1] == "" then
                MakeNotification(_("select_player"), "linear-gradient(to right, #ff5f6d, #ffc371)")
            else
                CallRemoteEvent("AdminTeleportPlayer", GetPlayerId(), args[1])
            end
        end
    end
    if dialog == weaponMenu then
        if button == 1 then
            if args[1] == "" then
                MakeNotification(_("select_weapon"), "linear-gradient(to right, #ff5f6d, #ffc371)")
            else
                CallRemoteEvent("AdminGiveWeapon", args[1])
            end
        end
    end
    if dialog == vehicleMenu then
        if button == 1 then
            if args[1] == "" then
                MakeNotification(_("select_vehicle"), "linear-gradient(to right, #ff5f6d, #ffc371)")
            else
                CallRemoteEvent("AdminSpawnVehicle", args[1])
            end
        end
    end
    if dialog == moneyMenu then
        if button == 1 then
            if args[1] == "" then
                MakeNotification(_("select_player"), "linear-gradient(to right, #ff5f6d, #ffc371)")
            else
                if args[2] == "" then
                    MakeNotification(_("select_amount"), "linear-gradient(to right, #ff5f6d, #ffc371)")
                else
                    CallRemoteEvent("AdminGiveMoney", args[1], "Bank", args[2])
                end
            end
        end
        if button == 2 then
            if args[1] == "" then
                MakeNotification(_("select_player"), "linear-gradient(to right, #ff5f6d, #ffc371)")
            else
                if args[2] == "" then
                    MakeNotification(_("select_amount"), "linear-gradient(to right, #ff5f6d, #ffc371)")
                else
                    CallRemoteEvent("AdminGiveMoney", args[1], "Cash", args[2])
                end
            end
        end
    end
    if dialog == banMenu then
        if button == 1 then
            if args[1] == "" then
                MakeNotification(_("select_player"), "linear-gradient(to right, #ff5f6d, #ffc371)")
            else
                if args[2] == "" then
                    MakeNotification("Please enter a reason", "linear-gradient(to right, #ff5f6d, #ffc371)")
                else
                    CallRemoteEvent("AdminKickBan", args[1], "Ban", args[2])
                end
            end
        end
        if button == 2 then
            if args[1] == "" then
                MakeNotification(_("select_player"), "linear-gradient(to right, #ff5f6d, #ffc371)")
            else
                if args[2] == "" then
                    MakeNotification(_("enter_reason"), "linear-gradient(to right, #ff5f6d, #ffc371)")
                else
                    CallRemoteEvent("AdminKickBan", args[1], "Kick", args[2])
                end
            end
        end
    end
    if dialog == itemMenu then
        if button == 1 then
            if args[1] == "" then
                MakeNotification(_("select_player"), "linear-gradient(to right, #ff5f6d, #ffc371)")
                return
            end
            if args[2] == "" then
                MakeNotification(_("select_item"), "linear-gradient(to right, #ff5f6d, #ffc371)")
                return
            end
            if args[3] == "" then
                MakeNotification(_("select_amount"), "linear-gradient(to right, #ff5f6d, #ffc371)")
                return
            end
            CallRemoteEvent("AdminGiveItem", args[1],args[2],args[3])
        end
    end
    if dialog == broadcastMenu then
        CallRemoteEvent("account:setplayernotbusy")      
        SetIgnoreMoveInput(false)    
        CallRemoteEvent("admin:broadcast", args[1], args[2])        
    end
end)

AddRemoteEvent("OpenAdminMenu", function(teleportPlace, playersNames, weaponsIds, vehicleIds, logs) 
    local tpPlace = {}
    for k,v in pairs(teleportPlace) do
        tpPlace[k] = _(k)
    end
    Dialog.setSelectLabeledOptions(teleportPlaceMenu, 1, 1, tpPlace)
    Dialog.setSelectLabeledOptions(teleportToPlayereMenu, 1, 1, playersNames)
    Dialog.setSelectLabeledOptions(teleportPlayerMenu, 1, 1, playersNames)
    Dialog.setSelectLabeledOptions(moneyMenu, 1, 1, playersNames)
    Dialog.setSelectLabeledOptions(itemMenu, 1, 1, playersNames)
    Dialog.setSelectLabeledOptions(banMenu, 1, 1, playersNames)
    Dialog.setSelectLabeledOptions(logMenu, 1, 1, logs)
    local weaponList = {}
    for k,v in pairs(weaponsIds) do
        weaponList[k] = _(k)
    end
    Dialog.setSelectLabeledOptions(weaponMenu, 1, 1, weaponList)
    local vehicleList = {}
    for k,v in pairs(vehicleIds) do
        vehicleList[k] = _(k)
    end
    Dialog.setSelectLabeledOptions(vehicleMenu, 1, 1, vehicleList)
    
    Dialog.show(adminMenu)
end)

AddRemoteEvent("admin:menu:showitemmenu", function(items)
    Dialog.setSelectLabeledOptions(itemMenu, 2, 1, items)
    Dialog.show(itemMenu)
end)

-- TO TP THE PLAYER TO THE GROUND WHEN HE IS IN WATER
AddRemoteEvent("admin:unstuck:terrainheight", function()
    local x, y, z = GetPlayerLocation()
    
    local tryZ = 0
    local maxTry = 60
    local terrain_height = GetTerrainHeight(x, y, tryZ)
    while terrain_height == false or terrain_height <= 100 do
        terrain_height = GetTerrainHeight(x, y, tryZ)
        tryZ = tryZ + 100
        if tryZ > maxTry * 100 then return end
    end

    CallRemoteEvent("admin:unstuck:teleport", terrain_height + 100)
end)

local under_water = false
AddEvent("OnPlayerEnterWater", function()
    under_water_help = true
end)
AddEvent("OnPlayerLeaveWater", function()
    under_water_help = false    
end)

AddEvent("OnRenderHUD", function()
    if under_water_help then
        DrawText(700, 10, _("under_water_help"))
    end
end)

AddRemoteEvent("admin:broadcast:display", function(name, message, temps)
    ExecuteWebJS(broadcastUi, " Broadcast('"..name.."', '"..message.."', "..temps..");")   
    local sound = CreateSound("client/files/broadcast.mp3")
    SetSoundVolume(sound, 0.1)
    Delay(2500, function()
        DestroySound(sound)        
    end)
end)

