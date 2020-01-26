worldTime = 12

local dayTime = 0.01
local nightTime = 0.05
local morning = 5
local evening = 20 

function OnPackageStart()
    -- Start the day/night system
    CreateTimer(function()
		if worldTime >= 24 then
			worldTime = 0
		end

		-- edited by wasied
		if worldTime < morning or worldTime > evening then -- night
			worldTime = worldTime + nightTime
		else -- day
			worldTime = worldTime + dayTime
		end
		--

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

AddCommand("time", function(player, time)
	if PlayerData[player].admin == 1 and (tonumber(time) >= 0 and tonumber(time) <= 23)then
		worldTime = tonumber(time)
	end
end)
