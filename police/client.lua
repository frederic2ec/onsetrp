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
    policeMenu = Dialog.create(_("police_menu"), nil,  _("spawn_despawn_patrol_car"), _("handcuff_player"), _("laws"), _("call_backup"),_("cancel"))
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
    end
end)

AddRemoteEvent("PoliceMenu", function()
    Dialog.show(policeMenu)
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
