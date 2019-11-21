
worldTime = 12

function OnPackageStart()
    -- Start the day/night system
    CreateTimer(function()
		if worldTime >= 24 then
			worldTime = 0
		end
		worldTime = worldTime + 0.01
		for k, v in pairs(GetAllPlayers()) do
            CallRemoteEvent(v, "setTimeOfClient", worldTime)
		end
    end, 1000)
end
AddEvent("OnPackageStart", OnPackageStart)

function OnPlayerSpawn(player)
    -- This script is used to make the time changing and synchronise to all client
	CallRemoteEvent(player, "setTimeOfClient", worldTime)
end
AddEvent("OnPlayerSpawn", OnPlayerSpawn)
