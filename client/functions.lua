local LastSoundPlayed = 0

-- This script is used to set world time of the player 
function setTimeOfClient(time)
	SetTime(time)
end
AddRemoteEvent("setTimeOfClient", setTimeOfClient)

function PlayAudioFile(file)
	DestroySound(LastSoundPlayed)

	LastSoundPlayed = CreateSound("client/files/"..file)
	SetSoundVolume(LastSoundPlayed, 1.1)
end
AddRemoteEvent("PlayAudioFile", PlayAudioFile)
