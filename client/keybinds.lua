-- Keybinding
function OnKeyPress(key)
    if key == "V" then
		if IsFirstPersonCamera() then
			EnableFirstPersonCamera(false)
		else
			EnableFirstPersonCamera(true)
		end
	end
end
AddEvent("OnKeyPress", OnKeyPress)