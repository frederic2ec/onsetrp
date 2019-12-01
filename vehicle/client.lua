local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end
local Dialog = ImportPackage("dialogui")

local vehicleMenu
local vehicleInventory

AddEvent("OnTranslationReady", function()
    vehicleMenu = Dialog.create("Vehicle", nil, _("trunk"), _("unflip"), _("unlock_lock"), _("cancel"))

    vehicleInventory = Dialog.create(_("vehicle_trunk"), nil, _("cancel"))
    Dialog.addSelect(vehicleInventory, 1, _("inventory"), 5)
    Dialog.addTextInput(vehicleInventory, 1, _("quantity"))
    Dialog.setButtons(vehicleInventory, 1, _("store"))
    Dialog.addSelect(vehicleInventory, 2, _("trunk"), 5)
    Dialog.addTextInput(vehicleInventory, 2, _("quantity"))
    Dialog.setButtons(vehicleInventory, 2, _("get"))
end)

function OnPlayerStartEnterVehicle(vehicle)
    if GetVehiclePropertyValue(vehicle, "locked") then 
        AddPlayerChat(_("this_vehicle_locked"))
        return false 
    end 
end
AddEvent("OnPlayerStartEnterVehicle", OnPlayerStartEnterVehicle)

function OnPlayerStartExitVehicle(vehicle)
    if GetVehiclePropertyValue(vehicle, "locked") then 
        AddPlayerChat(_("this_vehicle_locked"))
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
    if key == "U" then
        CallRemoteEvent("unlockVehicle")
    end
    local nearestVehicle = getNearestVehicle()

    if key == "F1" then
        if nearestVehicle ~= 0 then
            CallRemoteEvent("ServerVehicleMenu", nearestVehicle)
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
    end

    if dialog == vehicleInventory then
        if button == 1 then
			if args[1] == "" then
				AddPlayerChat(_("select_item"))
			else
				if args[2] == "" then
					AddPlayerChat(_("select_amount"))
				else
					CallRemoteEvent("VehicleStore", args[1], args[2])
				end
			end
		end
		if button == 2 then
			if args[3] == "" then
				AddPlayerChat(_("select_item"))
			else
				if args[4] == "" then
					AddPlayerChat(_("select_amount"))
				else
					CallRemoteEvent("VehicleUnstore", args[3], args[4])
				end
			end
		end
        CallRemoteEvent("CloseTrunk")
    end
end)

