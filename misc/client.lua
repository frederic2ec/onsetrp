local LastSoundPlayed = 0

function PlayAudioFile(file)
	DestroySound(LastSoundPlayed)

	LastSoundPlayed = CreateSound("client/files/"..file)
	SetSoundVolume(LastSoundPlayed, 1.1)
end
AddRemoteEvent("PlayAudioFile", PlayAudioFile)

-- Keybinding
function OnKeyPress(key)
    if key == "V" and not onSpawn and not onCharacterCreation then
		if IsFirstPersonCamera() then
			EnableFirstPersonCamera(false)
		else
			EnableFirstPersonCamera(true)
			SetNearClipPlane(25)
		end
	end
end
AddEvent("OnKeyPress", OnKeyPress)


AddEvent("OnNPCStreamIn", function(npc)
	SetNPCClothingPreset(npc, 14)
end)

AddEvent("OnPlayerSpawn", function()
	SetPostEffect("DepthOfField", "Distance", 0)
end)

