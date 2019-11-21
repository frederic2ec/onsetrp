local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

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

function OnKeyPress(key)
    if key == "U" then
        CallRemoteEvent("unlockVehicle", unlockVehicle)
	end
end
AddEvent("OnKeyPress", OnKeyPress)