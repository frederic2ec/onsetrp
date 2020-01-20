local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end
local Dialog = ImportPackage("dialogui")

local vehicleMenu
local vehicleInventory
local vehicleKeys

AddEvent("OnTranslationReady", function()
    vehicleMenu = Dialog.create("Vehicle", nil, _("trunk"), _("unflip"), _("unlock_lock"), _("keys"), _("cancel"))

    vehicleInventory = Dialog.create(_("vehicle_trunk"), nil, _("cancel"))
    Dialog.addSelect(vehicleInventory, 1, _("inventory"), 5)
    Dialog.addTextInput(vehicleInventory, 1, _("quantity"))
    Dialog.setButtons(vehicleInventory, 1, _("store"))
    Dialog.addSelect(vehicleInventory, 2, _("trunk"), 5)
    Dialog.addTextInput(vehicleInventory, 2, _("quantity"))
    Dialog.setButtons(vehicleInventory, 2, _("get"))

    vehicleKeys = Dialog.create(_("keys"), nil, _("give_key"), _("remove_key"), _("cancel"))
    Dialog.addSelect(vehicleKeys, 1, _("player"), 5)
    Dialog.addSelect(vehicleKeys, 1, _("player"), 1)
end)

function OnPlayerStartEnterVehicle(vehicle)
    if GetVehiclePropertyValue(vehicle, "locked") then 
        MakeNotification(_("this_vehicle_locked"), "linear-gradient(to right, #ff5f6d, #ffc371)")
        return false 
    end 
end
AddEvent("OnPlayerStartEnterVehicle", OnPlayerStartEnterVehicle)

function OnPlayerStartExitVehicle(vehicle)
    if GetVehiclePropertyValue(vehicle, "locked") then 
        MakeNotification(_("this_vehicle_locked"), "linear-gradient(to right, #ff5f6d, #ffc371)")
        return false 
    end 
end
AddEvent("OnPlayerStartExitVehicle", OnPlayerStartExitVehicle)

function getNearestVehicle()
    local x, y, z = GetPlayerLocation()
    
    for k,v in pairs(GetStreamedVehicles()) do
        local x2, y2, z2 = GetVehicleLocation(v)
        local dist = GetDistance3D(x, y, z, x2, y2, z2)

		if dist < 300.0 then
			return v
		end
    end
    return 0
end

function OnKeyPress(key)
    if key == "U" and not GetPlayerBusy() then
        CallRemoteEvent("unlockVehicle")
    end
    
    local nearestVehicle = getNearestVehicle()

    if key == "F1" and not GetPlayerBusy() then
        if nearestVehicle ~= 0 then
            CallRemoteEvent("ServerVehicleMenu", nearestVehicle)
        end
    end

    if key == "X" and not onSpawn and not onCharacterCreation and IsPlayerInVehicle() then
        local player = GetPlayerId()
        local veh = GetPlayerVehicle(player)
        if veh ~= 0 then
            CallRemoteEvent("ToggleEngine", veh)
        end
    end

    if key == "O" and not onSpawn and not onCharacterCreation and IsPlayerInVehicle() then
        local player = GetPlayerId()
        if GetPlayerVehicle(player) ~= 0 then
            CallRemoteEvent("ToggleTrunk")
        end
    end

    if key == "I" and not onSpawn and not onCharacterCreation and IsPlayerInVehicle() then
        local player = GetPlayerId()
        if GetPlayerVehicle(player) ~= 0 then
            CallRemoteEvent("ToggleHood")
        end
    end
end
AddEvent("OnKeyPress", OnKeyPress)


AddRemoteEvent("OpenVehicleMenu", function()
    Dialog.show(vehicleMenu)
end)

AddRemoteEvent("OpenVehicleInventory", function(inventory, vehicleinventory)
    local inventoryitems = {}
	for k,v in pairs(inventory) do
		inventoryitems[k] = _(k).."["..v.."]"
	end
	local vehicleItems = {}
	for k,v in pairs(vehicleinventory) do
		vehicleItems[k] = _(k).."["..v.."]"
	end
	Dialog.setSelectLabeledOptions(vehicleInventory, 1, 1, inventoryitems)
	Dialog.setSelectLabeledOptions(vehicleInventory, 2, 1, vehicleItems)
    Dialog.show(vehicleInventory)
end)

AddRemoteEvent("OpenVehicleKeys", function(keyslist, playerlist)
    local keys = {}
    for k,v in pairs(keyslist) do
        keys[tostring(k)] = GetPlayerName(k)
    end
    local players = {}
    for k,v in pairs(playerlist) do
        players[tostring(k)] = GetPlayerName(k)
    end
    Dialog.setSelectLabeledOptions(vehicleKeys, 1, 1, keys)
    Dialog.setSelectLabeledOptions(vehicleKeys, 1, 2, players)
    Dialog.show(vehicleKeys)
end)

AddEvent("OnDialogSubmit", function(dialog, button, ...)
    local args = { ... }
	if dialog == vehicleMenu then
		if button == 1 then
            CallRemoteEvent("OpenTrunk")
        end
        if button == 2 then
            CallRemoteEvent("UnflipVehicle")
        end
        if button == 3 then
            CallRemoteEvent("unlockVehicle")
        end
        if button == 4 then
            CallRemoteEvent("VehicleKeys")
        end
    end

    if dialog == vehicleInventory then
        if button == 1 then
			if args[1] == "" then
				MakeNotification(_("select_item"), "linear-gradient(to right, #ff5f6d, #ffc371)")
			else
				if args[2] == "" then
					MakeNotification(_("select_amount"), "linear-gradient(to right, #ff5f6d, #ffc371)")
				else
					CallRemoteEvent("VehicleStore", args[1], args[2])
				end
			end
		end
		if button == 2 then
			if args[3] == "" then
				MakeNotification(_("select_item"), "linear-gradient(to right, #ff5f6d, #ffc371)")
			else
				if args[4] == "" then
					MakeNotification(_("select_amount"), "linear-gradient(to right, #ff5f6d, #ffc371)")
				else
					CallRemoteEvent("VehicleUnstore", args[3], args[4])
				end
			end
		end
        CallRemoteEvent("CloseTrunk")
    end

    if dialog == vehicleKeys then
        if button == 1 then
            if args[2] == "" then
                MakeNotification(_("select_player"), "linear-gradient(to right, #ff5f6d, #ffc371)")
            else
                CallRemoteEvent("VehicleGiveKey", args[2])
            end
        end

        if button == 2 then
            if args[1] == "" then
                MakeNotification(_("select_player"), "linear-gradient(to right, #ff5f6d, #ffc371)")
            else
                CallRemoteEvent("VehicleRemoveKey", args[1])
            end
        end
    end
end)