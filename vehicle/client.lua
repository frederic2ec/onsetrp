local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end
local Dialog = ImportPackage("dialogui")

local vehicleMenu

AddEvent("OnTranslationReady", function()
    vehicleMenu = Dialog.create("Vehicle", nil, "Trunk", "Unflip", _("unlock_lock"), _("cancel"))
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

AddEvent("OnDialogSubmit", function(dialog, button, ...)
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
end)

