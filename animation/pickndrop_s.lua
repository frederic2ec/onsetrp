local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end
local _objects = nil

AddRemoteEvent("DropGun", function(player)
    if GetPlayerWeapon(player, GetPlayerEquippedWeaponSlot(player)) ~= 1 then
        model, ammo, magazine = GetPlayerWeapon(player, GetPlayerEquippedWeaponSlot(player))
        x, y, z = GetPlayerLocation(player)
        h = GetPlayerHeading(player)
        SetPlayerAnimation(player, "STOP")
        SetPlayerWeapon(player, 1, 0, true, GetPlayerEquippedWeaponSlot(player), false)
        SetPlayerAnimation(player, "CARRY_SHOULDER_SETDOWN")
            if GetPlayerWeapon(player, GetPlayerEquippedWeaponSlot(player)) ~= 21 then
		Delay(1000, function()
			droppedgun = CreateObject(model + 2 ,x, y, z - 95, 90, h -90)
			SetObjectPropertyValue(droppedgun, "isgun", true, true)
		    	SetObjectPropertyValue(droppedgun, "collision", false, true)
		    	SetObjectPropertyValue(droppedgun, "model", model, true)
                    	SetObjectPropertyValue(droppedgun, "ammo", ammo, true)
                end)
            else
                Delay(1000, function()
                    	droppedgun = CreateObject(model + 1387, x, y, z - 95, 90, h - 90)
                    	SetObjectPropertyValue(droppedgun, "isgun", true, true)
		    	SetObjectPropertyValue(droppedgun, "collision", false, true)
		    	SetObjectPropertyValue(droppedgun, "model", model, true)
                    	SetObjectPropertyValue(droppedgun, "ammo", ammo, true)
                end)    
            end
		--SetObjectPropertyValue(droppedgun, "magazine", magazine, true)
        
    else
        return CallRemoteEvent(player, "MakeNotification", _("nothing_todrop"), "linear-gradient(to right, #ff5f6d, #ffc371)")
    end
end)

AddRemoteEvent("ReturnedObjects", function(player, objects)
    _objects = objects
end)
        


AddRemoteEvent("PickupGun", function(player)
    closest = { id = nil, distance = nil }
    CallRemoteEvent(player, "GetClientObjects")
    x, y, z = GetPlayerLocation(player)

    if _objects ~= nil then
        for k, v in pairs(_objects) do
            if GetObjectPropertyValue(v, "isgun") ~= nil and GetObjectPropertyValue(v, "isgun") then
                x2, y2, z2 = GetObjectLocation(v)
                distance = GetDistance3D(x, y, z, x2, y2, z2)
                if closest.id == nil or closest.distance == nil then
                    closest.id = v
                    closest.distance = distance
                else
                    if distance < closest.distance then
                        closest.id = v
                        closest.distance = distance
                    end
                end
            end
        end
        
        if closest.id and closest.distance ~= nil then
            if closest.distance / 100 < 1.5 then
                local model = GetObjectPropertyValue(closest.id, "model")
                local ammo = GetObjectPropertyValue(closest.id, "ammo")
                --local magazine = GetObjectPropertyValue(closest.id, "magazine")
                if GetPlayerWeapon(player, GetPlayerEquippedWeaponSlot(player)) ~= 1 then
                    if GetPlayerWeapon(player, 1) ~= 1 then
                            if GetPlayerWeapon(player, 2) ~= 1 then
                                if GetPlayerWeapon(player, 3) ~= 1 then
                                    return CallRemoteEvent(player, "MakeNotification", _("inventory_notenoughspace"), "linear-gradient(to right, #ff5f6d, #ffc371)")
                                else 
                                    DestroyObject(closest.id)
                                    SetPlayerWeapon(player, model, ammo, false, 3, false)
                                    SetPlayerAnimation(player, "PICKUP_LOWER")
                                end
                            else 
                                DestroyObject(closest.id)
                                SetPlayerWeapon(player, model, ammo, false, 2, false)
                                SetPlayerAnimation(player, "PICKUP_LOWER")
                            end
                    else
                        DestroyObject(closest.id)
                        SetPlayerWeapon(player, model, ammo, false, 1, false)
                        SetPlayerAnimation(player, "PICKUP_LOWER")
                    end    
                else
                    DestroyObject(closest.id)
                    SetPlayerWeapon(player, model, ammo, true, GetPlayerEquippedWeaponSlot(player), false)
                    SetPlayerAnimation(player, "PICKUP_LOWER")
                end
            else
                -- too far
            end
        else
            -- obj =/ gun
        end
    end
end)
