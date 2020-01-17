local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end
local _objects = nil

AddRemoteEvent("DropGun", function(player)
    local slot = GetPlayerEquippedWeaponSlot(player)
    if GetPlayerWeapon(player, slot) ~= 1 then
	local model, ammo = GetPlayerWeapon(player, slot)
	local x, y, z = GetPlayerLocation(player)
	local h = GetPlayerHeading(player)
	local item = "weapon_" .. tostring(model)
	SetPlayerAnimation(player, "STOP")
	SetPlayerWeapon(player, 1, 0, true, GetPlayerEquippedWeaponSlot(player), false)
	SetPlayerAnimation(player, "CARRY_SHOULDER_SETDOWN")
	RemoveInventory(player, item, 1) 
            if model ~= 21 then
                Delay(1000, function()
			droppedgun = CreateObject(model + 2, x, y, z - 95, 90, h -90)
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
		local slot = GetPlayerEquippedWeaponSlot(player)
		local model = GetObjectPropertyValue(closest.id, "model")
		local ammo = GetObjectPropertyValue(closest.id, "ammo")
		local item = "weapon_" .. tostring(model)
		local space = AddInventory(player, item, 1)
		if not space then
			return CallRemoteEvent(player, "MakeNotification",_("inventory_not_enough_space"), "linear-gradient(to right, #ff5f6d, #ffc371)")
		end
		SetPlayerAnimation(player, "STOP")
                    if GetPlayerWeapon(player, slot) ~= 1 then
                        for i = 1, 3 do
                            if GetPlayerWeapon(player, i) == 1 then
                                SetPlayerWeapon(player, model, ammo, false, i, false)
                                break
                            end
                        end
                    else
			SetPlayerWeapon(player, model, ammo, true, slot, false)
                    end
		DestroyObject(closest.id) 
		SetPlayerAnimation(player, "PICKUP_LOWER")
		CallRemoteEvent(player, "MakeNotification", _("store_item"), "linear-gradient(to right, #00b09b, #96c93d)")
            else
                -- too far
            end
        else
            -- obj =/ gun
        end
    end
end)
