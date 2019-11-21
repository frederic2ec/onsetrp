local LastSoundPlayed = 0

function PlayAudioFile(file)
	DestroySound(LastSoundPlayed)

	LastSoundPlayed = CreateSound("client/files/"..file)
	SetSoundVolume(LastSoundPlayed, 1.1)
end
AddRemoteEvent("PlayAudioFile", PlayAudioFile)

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
