local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

chairs = {493, 519, 520, 532, 533, 534, 639, 728, 729, 730, 731, 769, 931, 952, 1086, 1095, 1126, 1127, 1128, 1129, 1130, 1131, 1132, 1133, 1134, 1135, 1136, 1137, 1138, 1139, 1140, 1142, 1181, 1198, 1207, 1208, 1209, 1210, 1211, 1214, 1216, 1218, 1223, 1228, 1246, 1253, 1256, 1262, 1294, 1794}

AddRemoteEvent("FindObject", function(player, objects)
	_objects = objects
	closest = { id = nil, distance = nil }
	local x, y, z = GetPlayerLocation(player)
    	if _objects ~= nil then
		for k, v in pairs(_objects) do
   			obj = Compare(v)
            		if obj ~= nil then
				if IsValidObject(obj) then
                    			local x2, y2, z2 = GetObjectLocation(obj)
            	    			local distance = GetDistance3D(x, y, z, x2, y2, z2)
				    	if closest.id == nil or closest.distance == nil then
                	    			closest.id = obj
                	    			closest.distance = distance
            	    			else
					    	if distance < closest.distance then
                    	    				closest.id = obj
                            				closest.distance = distance
                        			end
                    			end
				end
			end
		end

        if closest.id and closest.distance ~= nil then
            if closest.distance / 100 < 1.5 then
                object = closest.id
                if GetObjectPropertyValue(object, "isgun") then
                    if GetPlayerPropertyValue(player, "cuffed") then
                        CallRemoteEvent(player, "MakeNotification",_("cant_do_that"), "linear-gradient(to right, #ff5f6d, #ffc371)")
                    else
                        CallEvent("PickupGun", player, object)
                    end
                elseif GetObjectPropertyValue(object, "isitem") then
                    if GetPlayerPropertyValue(player, "cuffed") then
                        CallRemoteEvent(player, "MakeNotification",_("cant_do_that"), "linear-gradient(to right, #ff5f6d, #ffc371)")
                    else
                        CallEvent("PickupItem", player, object)
                    end
                else
                    CallEvent("Sit", player, object, x, y, z)
                end
            end
        end
    end
end)

AddEvent("PickupGun", function(player, object)
    local slot = GetPlayerEquippedWeaponSlot(player)
    local model = GetObjectPropertyValue(object, "model")
    local ammo = GetObjectPropertyValue(object, "ammo")
    local mag = GetObjectPropertyValue(object, "mag")
    local item = "weapon_" .. tostring(model)
    local space = AddInventory(player, item, 1)
    if not space then
        CallRemoteEvent(player, "MakeNotification",_("inventory_not_enough_space"), "linear-gradient(to right, #ff5f6d, #ffc371)")
    else
        SetPlayerAnimation(player, "STOP")
        if GetPlayerWeapon(player, slot) ~= 1 then
            for i = 1, 3 do
                if GetPlayerWeapon(player, i) == 1 then
                    --SetPlayerWeapon(player, model, mag, false, i, true)
                    SetPlayerWeapon(player, model, ammo, false, i, true)
                    break
                end
            end
        else
            SetPlayerWeapon(player, model, mag, true, slot, true)
            SetPlayerWeapon(player, model, ammo, true, slot, false)
        end
        DestroyObject(object) 
        SetPlayerAnimation(player, "PICKUP_LOWER")
	    SavePlayerAccount(player)
        CallRemoteEvent(player, "MakeNotification", _("store_item"), "linear-gradient(to right, #00b09b, #96c93d)")
    end

end)

AddEvent("PickupItem", function(player, object)
    local item = GetObjectPropertyValue(object, "item")
    local amount = GetObjectPropertyValue(object, "amount")
    local space = AddInventory(player, item, amount)
	if not space then
		CallRemoteEvent(player, "MakeNotification",_("inventory_not_enough_space"), "linear-gradient(to right, #ff5f6d, #ffc371)")
    	else
		SetPlayerAnimation(player, "STOP")
		SetPlayerAnimation(player, "PICKUP_LOWER")
		DestroyObject(object)
		CallRemoteEvent(player, "GetText")
		SavePlayerAccount(player)
		CallRemoteEvent(player, "MakeNotification", _("store_item"), "linear-gradient(to right, #00b09b, #96c93d)")
    	end
end)

AddEvent("Sit", function(player, object, x, y, z)
    SetPlayerAnimation(player, "STOP")
    if GetPlayerPropertyValue(player, "cuffed") then
        SetPlayerAnimation(player, "SIT01")
    else
    	SetPlayerAnimation(player, "SIT04")
    end
    CallRemoteEvent(player, "siting", object)
    CallRemoteEvent(player, "StockPos", x, y, z, object)
    SetPlayerPropertyValue(player, "sit", true, true)
    SetPlayerPropertyValue(player, "chair", object, true)
    SetObjectPropertyValue(object, "free", false, true)
end)

AddRemoteEvent("Unsit", function(player)
	CallRemoteEvent(player, "StockPos")
	SetPlayerAnimation(player, "STOP")
	if GetPlayerPropertyValue(player, "cuffed") then
        	SetPlayerAnimation(player, "CUFF")
    	end
end)

AddRemoteEvent("DeleteText", function(player, text3d)
    _text3d = text3d
    local closest = { id = nil, distance = nil }
    local x, y, z = GetPlayerLocation(player)
    if _text3d ~= nil then
        for k, v in pairs(_text3d) do
            if GetText3DPropertyValue(v, "textitem") ~= nil and GetText3DPropertyValue(v, "textitem") then
                local x2, y2, z2 = GetText3DLocation(v)
                local distance = GetDistance3D(x, y, z, x2, y2, z2)
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
                DestroyText3D(closest.id)
            end
        end
    end
end)

function ablecol(player, Pstream, objectId, condi, xL, yL, zL)
	_Pstream = Pstream
    local objet = objectId
    if condi then
        if xL ~= nil and not IsPlayerDead(player) then
            SetPlayerLocation(player, xL, yL, zL)
        end
        SetPlayerPropertyValue(player, "sit", false, true)
		SetObjectPropertyValue(objet, "free", true, true)
		if _Pstream ~= nil then
			for k,v in pairs(_Pstream) do
				CallRemoteEvent(v, "DcolforP", objet)
			end
		end
    else
		if _Pstream ~= nil then
			for k,v in pairs(_Pstream) do
				CallRemoteEvent(v, "colforP", objet)
			end
		end
	end
end
AddEvent("ablecol", ablecol)
AddRemoteEvent("ablecol", ablecol)

function Compare(v)
    if (GetObjectPropertyValue(v, "isgun")) or (GetObjectPropertyValue(v, "isitem")) then
        obj = v
    elseif (GetObjectPropertyValue(v, "free") == nil) or GetObjectPropertyValue(v, "free") then
        for i, p in pairs(chairs) do
		    if p == GetObjectModel(v) then
			    obj = v
			    break
		    end
        end
    else
        obj = nil
    end
    return obj
end

function OnPlayerDeath(player, instigator)
    if GetPlayerPropertyValue(player, "sit") then
        CallRemoteEvent(player, "StockPos")
    end
end
AddEvent("OnPlayerDeath", OnPlayerDeath)

function OnPlayerQuit(player)
    if GetPlayerPropertyValue(player, "sit") then
        local objectId = GetPlayerPropertyValue(player, "chair")
        local Pstream = GetStreamedPlayersForPlayer(player)
        local condi = true
        CallEvent("ablecol", player, Pstream, objectId, condi)
    end
end
AddEvent("OnPlayerQuit", OnPlayerQuit)
