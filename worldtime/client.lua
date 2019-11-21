-- This script is used to set world time of the player 
function setTimeOfClient(time)
	SetTime(time)
end
AddRemoteEvent("setTimeOfClient", setTimeOfClient)
