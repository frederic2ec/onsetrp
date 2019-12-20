local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local policeNpc = {
            {
                location = { 169277, 193489, 1307, 180 },
                spawn = { 169213, 191438, 1307, 90} 
            }
}

local policeNpcCached = {}
local playerPolice = {}

AddEvent("OnPackageStart", function()
    for k,v in pairs(policeNpc) do
        policeNpc[k].npc = CreateNPC(policeNpc[k].location[1], policeNpc[k].location[2], policeNpc[k].location[3], policeNpc[k].location[4])
        CreateText3D(_("police_job").."\n".._("press_e"), 18, policeNpc[k].location[1], policeNpc[k].location[2], policeNpc[k].location[3] + 120, 0, 0, 0)
        table.insert(policeNpcCached, policeNpc[k].npc)
    end
end)

AddEvent("OnPlayerQuit", function( player )
    if playerPolice[player] ~= nil then
        playerPolice[player] = nil
    end
end)

AddEvent("OnPlayerJoin", function(player)
    CallRemoteEvent(player, "SetupPolice", policeNpcCached)
end)

AddRemoteEvent("StartStopPolice", function(player)
    if PlayerData[player].job == "" then
        if PlayerData[player].job_vehicle ~= nil then
            DestroyVehicle(PlayerData[player].job_vehicle)
            DestroyVehicleData(PlayerData[player].job_vehicle)
            PlayerData[player].job_vehicle = nil
            CallRemoteEvent(player, "ClientDestroyCurrentWaypoint")
        else
	    local jobCount = 0
	    for k,v in pairs(PlayerData) do
		if v.job == "police" then
		    jobCount = jobCount + 1
		end
	    end
	    if jobCount == 10 then
		return CallRemoteEvent(player, "MakeNotification", _("job_full"), "linear-gradient(to right, #ff5f6d, #ffc371)")
	    end
	PlayerData[player].job = "police"
	GetUniformServer(player)
	CallRemoteEvent(player, "MakeNotification", _("join_police"), "linear-gradient(to right, #00b09b, #96c93d)")
	return
    end 
    elseif PlayerData[player].job == "police" then
        if PlayerData[player].job_vehicle ~= nil then
            DestroyVehicle(PlayerData[player].job_vehicle)
            DestroyVehicleData(PlayerData[player].job_vehicle)
            PlayerData[player].job_vehicle = nil
        end
	CallRemoteEvent(player, "MakeNotification", _("quit_police"), "linear-gradient(to right, #00b09b, #96c93d)")
        PlayerData[player].job = ""
	RemoveUniformServer(player)
    end
end)

AddRemoteEvent("OpenPoliceMenu", function(player)
    if PlayerData[player].job == "police" then
        CallRemoteEvent(player, "PoliceMenu")
    end
end)

function GetNearestPolice(player)
	local x, y, z = GetPlayerLocation(player)
	
	for k,v in pairs(GetAllNPC()) do
        local x2, y2, z2 = GetNPCLocation(v)
		local dist = GetDistance3D(x, y, z, x2, y2, z2)

		if dist < 250.0 then
			for k,i in pairs(policeNpc) do
				if v == i.npc then
					return k
				end
			end
		end
	end

	return 0
end

function GetUniformServer(player)
    CallRemoteEvent(player, "ChangeUniformClient", player, PlayerData[player].clothing_police[1], 0)
    CallRemoteEvent(player, "ChangeUniformClient", player, PlayerData[player].clothing_police[3], 1)
    CallRemoteEvent(player, "ChangeUniformClient", player, PlayerData[player].clothing_police[4], 4)
    CallRemoteEvent(player, "ChangeUniformClient", player, PlayerData[player].clothing_police[5], 5)
    
    for k,v in pairs(GetStreamedPlayersForPlayer(player)) do
	ChangeUniformOtherPlayerServer(k, player)
    end
end
AddRemoteEvent("GetUniformServer", GetUniformServer)

function ChangeUniformOtherPlayerServer(player, otherplayer)

    if PlayerData[otherplayer] == nil then
	return
    end
    if(PlayerData[otherplayer].job ~= "police") then
	return
    end

    if PlayerData[otherplayer].clothing_police == nil then
	return
    end
    CallRemoteEvent(player, "ChangeUniformClient", otherplayer, PlayerData[otherplayer].clothing_police[1], 0)
    CallRemoteEvent(player, "ChangeUniformClient", otherplayer, PlayerData[otherplayer].clothing_police[3], 1)
    CallRemoteEvent(player, "ChangeUniformClient", otherplayer, PlayerData[otherplayer].clothing_police[4], 4)
    CallRemoteEvent(player, "ChangeUniformClient", otherplayer, PlayerData[otherplayer].clothing_police[5], 5)
end
AddRemoteEvent("ChangeUniformOtherPlayerServer", ChangeUniformOtherPlayerServer)

function RemoveUniformServer(player)
    CallRemoteEvent(player, "ChangeUniformClient", player, PlayerData[player].clothing[1], 0)
    CallRemoteEvent(player, "ChangeUniformClient", player, PlayerData[player].clothing[3], 1)
    CallRemoteEvent(player, "ChangeUniformClient", player, PlayerData[player].clothing[4], 4)
    CallRemoteEvent(player, "ChangeUniformClient", player, PlayerData[player].clothing[5], 5)
    
    for k,v in pairs(GetStreamedPlayersForPlayer(player)) do
	RemoveUniformOtherPlayerServer(k, player)
    end
end

function RemoveUniformOtherPlayerServer(player, otherplayer)
    if PlayerData[otherplayer] == nil then
	return
    end
    CallRemoteEvent(player, "ChangeUniformClient", otherplayer, PlayerData[otherplayer].clothing[1], 0)
    CallRemoteEvent(player, "ChangeUniformClient", otherplayer, PlayerData[otherplayer].clothing[3], 1)
    CallRemoteEvent(player, "ChangeUniformClient", otherplayer, PlayerData[otherplayer].clothing[4], 4)
    CallRemoteEvent(player, "ChangeUniformClient", otherplayer, PlayerData[otherplayer].clothing[5], 5)
end

function GetPatrolCar(player)
    local nearestPolice = GetNearestPolice(player)
    if (nearestPolice ~= 0) then
	if(PlayerData[player].job_vehicle ~= nil) then
            DestroyVehicle(PlayerData[player].job_vehicle)
            DestroyVehicleData(PlayerData[player].job_vehicle)
            PlayerData[player].job_vehicle = nil
	    return CallRemoteEvent(player, "MakeNotification", _("vehicle_stored"), "linear-gradient(to right, #00b09b, #96c93d)")
	end
	local isSpawnable = true
	for k,v in pairs(GetAllVehicles()) do
	    local x, y, z = GetVehicleLocation(v)
	    local dist2 = GetDistance3D(policeNpc[nearestPolice].spawn[1], policeNpc[nearestPolice].spawn[2], policeNpc[nearestPolice].spawn[3], x, y, z)
	    if dist2 < 500.0 then
		CallRemoteEvent(player, "MakeNotification", _("cannot_spawn_vehicle"), "linear-gradient(to right, #ff5f6d, #ffc371)")
		isSpawnable = false
		break
	    end
	end
	if isSpawnable then
	    local vehicle = CreateVehicle(3, policeNpc[nearestPolice].spawn[1], policeNpc[nearestPolice].spawn[2], policeNpc[nearestPolice].spawn[3], policeNpc[nearestPolice].spawn[4])
	    PlayerData[player].job_vehicle = vehicle
	    CreateVehicleData(player, vehicle, 3)
	    SetVehiclePropertyValue(vehicle, "locked", true, true)
	    CallRemoteEvent(player, "MakeNotification", _("spawn_vehicle_success", " patrol car"), "linear-gradient(to right, #00b09b, #96c93d)")
	end
    else
	CallRemoteEvent(player, "MakeNotification", _("cannot_spawn_vehicle"), "linear-gradient(to right, #ff5f6d, #ffc371)")
    end
end
AddRemoteEvent("GetPatrolCar", GetPatrolCar)

AddRemoteEvent("HandcuffPlayer", function(player)
    if(PlayerData[player].job == "police") then
	local x, y, z = GetPlayerLocation(player)
	local listStreamed = GetStreamedPlayersForPlayer(player)
	local closestDistance = 50000
	local otherPlayer
	for k,v in pairs(listStreamed) do
	    local _x, _y, _z = GetPlayerLocation(v)
	    local tmpDistance = GetDistance3D(x, y, z, _x, _y, _z)
	    if(tmpDistance < closestDistance and v ~= player) then
		closestDistance = tmpDistance
		otherPlayer = v
	    end
	end
	if(otherPlayer ~= player) then
	    if(closestDistance < 115) then

		if(GetPlayerPropertyValue(otherPlayer, "cuffed") == nil) then
		    SetPlayerAnimation(otherPlayer, "CUFF")
		    SetPlayerHeading(otherPlayer, GetPlayerHeading(player))
		    SetPlayerPropertyValue(otherPlayer, "cuffed", true, true)

		elseif(GetPlayerPropertyValue(otherPlayer, "cuffed") == true) then
		    SetPlayerAnimation(otherPlayer, "STOP")
		    SetPlayerPropertyValue(otherPlayer, "cuffed", false, true)
		else
		    SetPlayerAnimation(otherPlayer, "CUFF")
		    SetPlayerHeading(otherPlayer, GetPlayerHeading(player))
		    SetPlayerPropertyValue(otherPlayer, "cuffed", true, true)

		end
	    end
	end
    end
end)

