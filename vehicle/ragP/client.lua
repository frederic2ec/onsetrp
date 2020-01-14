-- Made with 🖤 By Bad
-- https://github.com/Bad57/ragP

AddEvent("OnPlayerStartExitVehicle", function(vehicle)
    local currentspeed = GetVehicleForwardSpeed(vehicle)
    CallRemoteEvent("RagdollPlayer", currentspeed,vehicle)
end)
