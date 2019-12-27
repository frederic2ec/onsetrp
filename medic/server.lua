local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end
local medicNpc = {
            {
                location = { 211664, 159643, 1320, 90 },
                spawn = { 212956, 160465, 1305, -90 }
            },
          
}
local medicPoint = {
    { 116691, 164243, 3028 },
}

local medicNpcCached = {}
local playerMedic = {}

AddEvent("OnPackageStart", function()
    for k,v in pairs(medicNpc) do
        medicNpc[k].npc = CreateNPC(medicNpc[k].location[1], medicNpc[k].location[2], medicNpc[k].location[3],medicNpc[k].location[4])
        CreateText3D(_("medic_job").."\n".._("press_e"), 18, medicNpc[k].location[1], medicNpc[k].location[2], medicNpc[k].location[3] + 120, 0, 0, 0)
        table.insert(medicNpcCached, medicNpc[k].npc)
    end
end)

AddEvent("OnPlayerSpawn", function(player)
    if(GetPlayerPropertyValue(player, "reviveHint") ~= nil) then
	DestroyText3D(GetPlayerPropertyValue(player, "reviveHint"))
    end
end)

AddEvent("OnPlayerQuit", function(player)
    if playerMedic[player] ~= nil then
        playerMedic[player] = nil
    end
    if(GetPlayerPropertyValue(player, "reviveHint") ~= nil) then
	DestroyText3D(GetPlayerPropertyValue(player, "reviveHint"))
    end
end)

AddEvent("OnPlayerJoin", function(player)
    CallRemoteEvent(player, "SetupMedic", medicNpcCached)
end)

AddRemoteEvent("StartMedicJob", function(player)
    local nearestMedic = GetNearestMedic(player)
    if PlayerData[player].job == "" then
        if PlayerData[player].job_vehicle ~= nil then
            DestroyVehicle(PlayerData[player].job_vehicle)
            DestroyVehicleData(PlayerData[player].job_vehicle)
            PlayerData[player].job_vehicle = nil
           
        else
            local isSpawnable = true
            for k,v in pairs(GetAllVehicles()) do
                local x, y, z = GetVehicleLocation(v)
                local dist2 = GetDistance3D(medicNpc[nearestMedic].spawn[1], medicNpc[nearestMedic].spawn[2], medicNpc[nearestMedic].spawn[3], x, y, z)
                if dist2 < 500.0 then
                    isSpawnable = false
                    break
                end
            end
            if isSpawnable  then
                local vehicle = CreateVehicle(8, medicNpc[nearestMedic].spawn[1], medicNpc[nearestMedic].spawn[2], medicNpc[nearestMedic].spawn[3], medicNpc[nearestMedic].spawn[4])
                PlayerData[player].job_vehicle = vehicle
                CreateVehicleData(player, vehicle, 8)
                SetVehiclePropertyValue(vehicle, "locked", true, true)
                PlayerData[player].job = "medic"
		CallRemoteEvent(player, "MakeNotification", _("join_medic"), "linear-gradient(to right, #00b09b, #96c93d)")
		CallRemoteEvent(player, "UpdateMedicUniform", player)
		SetupUpdateMedicUniform(player)
                return
            end
        end
    end
end)

function SetupUpdateMedicUniform(player)
    for k,v in pairs(GetStreamedPlayersForPlayer(player)) do
	if(PlayerData[v] ~= nil and PlayerData[player].job == "medic" and player ~= v) then
	    CallRemoteEvent(v, "UpdateMedicUniform", player)
	end
    end
end
AddRemoteEvent("SetupUpdateMedicUniform", SetupUpdateMedicUniform)

AddRemoteEvent("SetupMedicUniformOnStreamIn", function(player, otherplayer)
    if PlayerData[otherplayer] == nil then
	return
    end
    if(PlayerData[otherplayer].job ~= "medic") then
	return
    end
    CallRemoteEvent(player, "UpdateMedicUniform", otherplayer)
end)

AddRemoteEvent("StopMedicJob", function(player,spawncar)
  if PlayerData[player].job == "medic" then
		if PlayerData[player].job_vehicle ~= nil then
            DestroyVehicle(PlayerData[player].job_vehicle)
            DestroyVehicleData(PlayerData[player].job_vehicle)
            PlayerData[player].job_vehicle = nil
        end
        PlayerData[player].job = ""
	CallRemoteEvent(player, "MakeNotification", _("quit_medic"), "linear-gradient(to right, #00b09b, #96c93d)")
	RemoveUniformServer(player)
        playerMedic[player] = nil
    end
end)

AddEvent("OnPlayerDeath", function(player)
    PlayerData[player].health_state = "dead"
    local x, y, z = GetPlayerLocation(player)
    PlayerData[player].death_pos[1] = x
    PlayerData[player].death_pos[2] = y
    PlayerData[player].death_pos[3] = z

    local medic = false
    for k,v in pairs(GetAllPlayers()) do
	if player ~= v and PlayerData[v].job == "medic" then
	    local reviveHint = CreateText3D(_("revive_player").."\n".._("press_e"), 18, x, y, z + 50, 0, 0, 0)
	    SetPlayerPropertyValue(player, "reviveHint", reviveHint, true)
            SetPlayerRespawnTime(player, 300000)
	    medic = true
	    break
        end
    end
    if(medic ~= true) then
	PlayerData[player].health_state = "alive"
    end
end)

AddRemoteEvent("MedicDoRevive", function(player,deadplayer)
    if player ~= deadplayer and PlayerData[player].job == "medic" then
        SetPlayerAnimation(player, "REVIVE")

        Delay(5000, function()
            SetPlayerAnimation(player, "STOP")
            SetPlayerRespawnTime(deadplayer, 100)
	    PlayerData[deadplayer].health_state = "revived"
	    SetPlayerSpawnLocation(deadplayer, PlayerData[deadplayer].death_pos[1], PlayerData[deadplayer].death_pos[2], PlayerData[deadplayer].death_pos[3], 90)
	    CallRemoteEvent(player, "MakeNotification", _("revive_player_success"), "linear-gradient(to right, #00b09b, #96c93d)")
	    CallRemoteEvent(player, "MakeNotification", _("revive_reward"), "linear-gradient(to right, #00b09b, #96c93d)")
	    PlayerData[player].bank_balance = PlayerData[player].bank_balance + 200
	    DestroyText3D(GetPlayerPropertyValue(deadplayer, "reviveHint"))
        end)
    end
end)

function GetNearestMedic(player)
	local x, y, z = GetPlayerLocation(player)
	
	for k,v in pairs(GetAllNPC()) do
        local x2, y2, z2 = GetNPCLocation(v)
		local dist = GetDistance3D(x, y, z, x2, y2, z2)

		if dist < 250.0 then
			for k,i in pairs(medicNpc) do
				if v == i.npc then
					return k
				end
			end
		end
	end

	return 0
end
