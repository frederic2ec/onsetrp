local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end
-- Based on MasterCedric (https://github.com/MasterCedric/)
-- Based on OnfireNetwork (https://github.com/OnfireNetwork/)

local offsets = {
    ["1111"] = { -- Fishing Rod
        hand_r = {-8,6.5,-8,0,180,15}
    },
    ["1047"] = { -- Chainsaw
        hand_r = {-25,13,18,70,150,0}
    },
    ["620"] = { -- Trashsack
        hand_r = {-95,9,5,-90,60,-60}
    },
    ["654"] = { -- Package
        hand_r = {-40,20,0,90,90,0}
    },
    ["1075"] = { -- Saw
        hand_r = {-10,0,0,-30,30,50}
    },
    ["552"] = { -- Cutter
        hand_r = {-14,3,10,60,-130,0}
    },
    ["1063"] = { -- Gardening Fork/Pickaxe
        hand_r = {-10,3,75,0,0,179}
    }
}
local objects = {}

function Server_OnPlayerAnimation(player, id)
    if not GetPlayerPropertyValue(player, "cuffed") and not GetPlayerBusy(player) then
        SetPlayerAnimation(player, "STOP")
        SetPlayerAnimation(player, id)
    end
end

AddRemoteEvent("Server_OnPlayerAnimation", Server_OnPlayerAnimation)


function SetAttachedItem(player, slot, type)
    if objects[player] ~= nil then
        if objects[player][slot] ~= nil then
            DestroyObject(objects[player][slot])
            objects[player][slot] = nil
        end
    else
        objects[player] = {}
    end
    if type == 0 then
        return
    end
    local offset = {0,0,0,0,0,0}
    if offsets[tostring(type)] ~= nil then
        if offsets[tostring(type)][slot] ~= nil then
            offset = offsets[tostring(type)][slot]
        end
    end
    local x, y, z = GetPlayerLocation(player)
    objects[player][slot] = CreateObject(type, x, y, z)
    Delay(100, function()
        SetObjectAttached(objects[player][slot], 1, player, offset[1], offset[2], offset[3], offset[4], offset[5], offset[6], slot)
    end)
end

function GetAttachedItem(player, slot)
    if objects[player] == nil then
        return 0
    end
    if objects[player][slot] == nil then
        return 0
    end
    return GetObjectModel(objects[player][slot])
end

AddEvent("OnPlayerQuit", function(player)
    if objects[player] == nil then
        return
    end
    for k,v in pairs(objects[player]) do
        DestroyObject(objects[player][k])
    end
    objects[player] = nil
end)

AddRemoteEvent("DropGun", function(player, mag, bool)
	local slot = GetPlayerEquippedWeaponSlot(player)
	if GetPlayerWeapon(player, slot) ~= 1 then
		local model, ammo = GetPlayerWeapon(player, slot)
	    	local x, y, z = GetPlayerLocation(player)
		if bool then
			z = z + 40
		end
	    	local h = GetPlayerHeading(player)
        	local item = "weapon_" .. tostring(model)
        	local objet = model + 2
	    	SetPlayerAnimation(player, "STOP")
	    	SetPlayerWeapon(player, 1, 0, true, slot, false)
	    	SetPlayerAnimation(player, "CARRY_SHOULDER_SETDOWN")
        	RemoveInventory(player, item, 1)
        	if model == 21 then
            		objet = model + 1387
        	end
        	Delay(1000, function()
			droppedgun = CreateObject(objet, x, y, z - 95, 90, h -90)
		    	SetObjectPropertyValue(droppedgun, "isgun", true, true)
		    	SetObjectPropertyValue(droppedgun, "collision", false, true)
		    	SetObjectPropertyValue(droppedgun, "model", model, true)
            		SetObjectPropertyValue(droppedgun, "ammo", ammo, true)
            		SetObjectPropertyValue(droppedgun, "mag", mag, true)
        	end)
    	else
        	return CallRemoteEvent(player, "MakeNotification", _("nothing_todrop"), "linear-gradient(to right, #ff5f6d, #ffc371)")
    	end
end)
