-- Keybinding
function OnKeyPress(key)
    if key == "V" then
		local distance = GetPlayerCameraViewDistance()

		distance = distance * 1.1

		if IsPlayerInVehicle() then
			if distance > 1000 then
				distance = 450
			end
		else
			if distance > 450 then
				distance = 250
			end
		end
		SetPlayerCameraViewDistance(distance)
	end
end
AddEvent("OnKeyPress", OnKeyPress)