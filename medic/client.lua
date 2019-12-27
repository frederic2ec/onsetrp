local Dialog = ImportPackage("dialogui")
local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local medicNpc
local reviving = false


AddEvent("OnTranslationReady", function()
    medicNpcMenu = Dialog.create(_("medic_menu"), nil, _("start_medic") , _("stop_medic") ,_("cancel"))
    medicEmergencyMenu = Dialog.create(_("medic_emergency"), nil, _("accept_emergency"), _("cancel"))
    Dialog.addSelect(medicEmergencyMenu, 1, _("player"), 3)

end)

AddRemoteEvent("SetupMedic", function(medicnpc) 
    medicNpc = medicnpc
end)

AddEvent("OnKeyPress", function( key )
    if key == "E" then
	local NearestMedic = GetNearestMedic()
	if NearestMedic ~= 0 then
	    Dialog.show(medicNpcMenu)
	end

	if reviving == false then
	    local x, y, z = GetPlayerLocation()

	    for k,v in pairs (GetAllPlayersInSphere( x, y, z, 200.0 )) do
		if IsPlayerDead(v) then
		    CallRemoteEvent("MedicDoRevive",v)
		    reviving = true
		    Delay(6000,function()
			reviving = false
		    end)
		    break
		end
	    end
	end
    end
    if key == "F3" and not onSpawn and not onCharacterCreation then
	CallRemoteEvent("OpenMedicMenu")
    end
end)

AddRemoteEvent("MedicMenu", function(playerNames)
    Dialog.setSelectLabeledOptions(medicEmergencyMenu, 1, 1, playerNames)
    Dialog.show(medicEmergencyMenu)
end)


AddEvent("OnDialogSubmit", function(dialog, button, ...)
    local args = { ... }
    if dialog == medicNpcMenu then
	if button == 1 then	 
	    CallRemoteEvent("StartMedicJob") 
	end
	if button == 2 then
	    CallRemoteEvent("StopMedicJob") 
	end
    end
    if dialog == medicEmergencyMenu then
	if button == 1 then
	    if(args[1] ~= nil) then
		CallRemoteEvent("AcceptEmergency", args[1])
	    end
	end
    end
end)

function GetNearestMedic()
    local x, y, z = GetPlayerLocation()

    for k,v in pairs(GetStreamedNPC()) do
	local x2, y2, z2 = GetNPCLocation(v)
	local dist = GetDistance3D(x, y, z, x2, y2, z2)

	if dist < 250.0 then
	    for k,i in pairs(medicNpc) do
		if v == i then
		    return v
		end
	    end
	end
    end

    return 0
end

function UpdateMedicUniform(playerToUpdate)
    SetPlayerClothingPreset(playerToUpdate, 17)
end
AddRemoteEvent("UpdateMedicUniform", UpdateMedicUniform)

AddEvent("OnPlayerStreamIn", function(player, otherplayer)
    CallRemoteEvent("SetupMedicUniformOnStreamIn", player, otherplayer)
end)
