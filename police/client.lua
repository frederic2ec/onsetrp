local Dialog = ImportPackage("dialogui")
local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local policeNPC
local policeNpcMenu
local policeMenu

AddRemoteEvent("SetupPolice", function(policenpc) 
    policeNPC = policenpc
end)

AddEvent("OnTranslationReady", function()
    policeNpcMenu = Dialog.create(_("police_menu"), nil, _("start_stop_police") ,_("cancel"))
    policeMenu = Dialog.create(_("police_menu"), nil,  _("spawn_despawn_patrol_car"), _("handcuff_player"), _("put_player_in_vehicle"), _("remove_player_from_vehicle"), _("remove_all_weapons"),_("give_player_fine"), _("cancel"))

    policeReceiveFineMenu = Dialog.create(_("fine"), _("fine_price").." : {fine_price} ".._("currency").." | ".._("reason").." : {reason}", _("pay"))
    
    policeFineMenu = Dialog.create(_("finePolice"), nil, _("give_fine"), _("cancel"))
    Dialog.addTextInput(policeFineMenu, 1, _("amount").." :")
    Dialog.addSelect(policeFineMenu, 1, _("player"), 3)
    Dialog.addTextInput(policeFineMenu, 1, _("reason").." :")
end)

AddEvent("OnKeyPress", function( key )
    if key == "E" and not onSpawn and not onCharacterCreation then
        local NearestPolice = GetNearestPolice()
        if NearestPolice ~= 0 then
            Dialog.show(policeNpcMenu)
		end
    end
    if key == "F3" and not onSpawn and not onCharacterCreation then
        CallRemoteEvent("OpenPoliceMenu")
    end
end)


AddEvent("OnDialogSubmit", function(dialog, button, ...)
    local args = { ... }
    if dialog == policeNpcMenu then
	if button == 1 then
	    CallRemoteEvent("StartStopPolice")
	end
    end
    if dialog == policeMenu then
	if button == 1 then
	    CallRemoteEvent("GetPatrolCar")
	end
	if button == 2 then
	    CallRemoteEvent("HandcuffPlayerSetup")
	end
	if button == 3 then
	    CallRemoteEvent("PutPlayerInVehicle")
	end
	if button == 4 then
	    CallRemoteEvent("RemovePlayerOfVehicle")
	end
	if button == 5 then
	    CallRemoteEvent("RemoveAllWeaponsOfPlayer")
	end
	if button == 6 then
	    CallRemoteEvent("OpenPoliceFineMenu")
	end
    end

    if dialog == policeFineMenu then
	if button == 1 then
	    if args[1] ~= "" then
		if tonumber(args[1]) > 0 then
		    CallRemoteEvent("GiveFineToPlayer", args[1], args[2], args[3])
		else
		    MakeNotification(_("enter_higher_number"), "linear-gradient(to right, #ff5f6d, #ffc371)")
		end
	    else
		MakeNotification(_("valid_number"), "linear-gradient(to right, #ff5f6d, #ffc371)")
	    end

	end
    end

    if dialog == policeReceiveFineMenu then
	if button == 1 then
	    CallRemoteEvent("PayFine")
	end
    end
end)

AddRemoteEvent("PoliceMenu", function()
    Dialog.show(policeMenu)
end)

AddRemoteEvent("OpenPoliceFineMenu", function(playerNames)
    Dialog.setSelectLabeledOptions(policeFineMenu, 1, 2, playerNames)
    Dialog.show(policeFineMenu)
end)

function GetNearestPolice()
	local x, y, z = GetPlayerLocation()
	
	for k,v in pairs(GetStreamedNPC()) do
        local x2, y2, z2 = GetNPCLocation(v)
		local dist = GetDistance3D(x, y, z, x2, y2, z2)

		if dist < 250.0 then
			for k,i in pairs(policeNPC) do
				if v == i then
					return v
				end
			end
		end
	end

	return 0
end

AddRemoteEvent("ChangeUniformClient", function(playerToChange, pieceName, part)
    if(pieceName ~= nil and pieceName ~= '') then
    	local SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(playerToChange, "Clothing"..part)
    	SkeletalMeshComponent:SetSkeletalMesh(USkeletalMesh.LoadFromAsset(pieceName))
end
end)

AddEvent("OnPlayerStreamIn", function(player, otherplayer)
    CallRemoteEvent("ChangeUniformOtherPlayerServer", player, otherplayer)
end)

AddEvent("OnKeyPress", function(key)
    if(key == "R" and IsShiftPressed()) then
	    CallRemoteEvent("HandcuffPlayerSetup")
    end
end)

AddEvent("OnGameTick", function()
    if(GetPlayerPropertyValue(GetPlayerId(), "cuffed")) then
	if(GetPlayerMovementSpeed() > 0 and GetPlayerMovementMode() ~= 1) then
	    CallRemoteEvent("DisableMovementForCuffedPlayer")
	else
	    local x, y, z = GetPlayerLocation()
	    CallRemoteEvent("UpdateCuffPosition", x, y, z)
	end
    end
end)

AddEvent("OnPlayerDeath", function(player, instigator)
    if(GetPlayerPropertyValue(GetPlayerId(), "cuffed")) then
	CallRemoteEvent("FreeHandcuffPlayer")
    end
end)


AddRemoteEvent("PlayerReceiveFine", function(amount, reason)
    Dialog.setVariable(policeReceiveFineMenu, "fine_price", amount)
    Dialog.setVariable(policeReceiveFineMenu, "reason", reason)
    Dialog.show(policeReceiveFineMenu)
end)
