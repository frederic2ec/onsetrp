
function OnPlayerStartEnterVehicle(vehicle)
    if GetVehiclePropertyValue(vehicle, "locked") then 
        AddPlayerChat("This vehicle is locked !")
        return false 
    end 
end
AddEvent("OnPlayerStartEnterVehicle", OnPlayerStartEnterVehicle)

function OnPlayerStartExitVehicle(vehicle)
    if GetVehiclePropertyValue(vehicle, "locked") then 
        AddPlayerChat("This vehicle is locked !")
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